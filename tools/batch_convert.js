/**
 * Script Node.js complet pour convertir une liste de SVG animés (depuis un JSON)
 * en fichiers WebP animés, avec des options de redimensionnement et de découpage.
 * Le script génère également un JSON de sortie avec les animations encodées en base64.
 * Il optimise le traitement en ne convertissant chaque URL unique qu'une seule fois.
 *
 * USAGE:
 * node extraire-frames.js <input.json> <output_dir> [--fps <num>] [--width <px>|--height <px>] [--start <sec>] [--end <sec>]
 *
 * FORMAT DU JSON D'ENTRÉE:
 * {
 * "cle_unique": {
 * "group": "...",
 * "condition": "...",
 * "svg_url": "http://...",
 * "fps_factor": 1.5  // Optionnel: multiplie le FPS de base (ex: 24 * 1.5 = 36 FPS)
 * }
 * }
 */

// Import des modules natifs Node.js
const { exec } = require("child_process");
const https = require("https");
const fs = require("fs");
const path = require("path");
const util = require("util");

// Import des dépendances (à installer via `npm install`)
const puppeteer = require("puppeteer");
const { DOMParser } = require("xmldom");

// Promisify exec pour utiliser async/await avec les commandes shell
const execPromise = util.promisify(exec);

// --- 1. ANALYSE DES ARGUMENTS DE LA LIGNE DE COMMANDE ---

const args = process.argv.slice(2);
const inputJsonPath = args[0];
const outputDirPath = args[1];

// Fonction utilitaire pour extraire les arguments optionnels
const getArgValue = (argName, defaultValue = null) => {
  const index = args.indexOf(argName);
  if (index !== -1 && args[index + 1]) {
    return args[index + 1];
  }
  return defaultValue;
};

// Récupération des options
const startTime = getArgValue("--start");
const endTime = getArgValue("--end");
const resizeWidth = getArgValue("--width");
const resizeHeight = getArgValue("--height");
const baseFps = parseInt(getArgValue("--fps", 24));
const renderDelay = 50; // Délai en ms pour assurer le rendu correct de chaque frame

// --- 2. VALIDATION DES ARGUMENTS ---

if (!inputJsonPath || !outputDirPath) {
  console.log("❌ Erreur : Arguments manquants.");
  console.log(
    "\n   Usage : node extraire-frames.js <input.json> <output_dir> [--fps <num>] ..."
  );
  console.log(
    "\n   Exemple : node extraire-frames.js animations.json ./output --fps 25 --width 300\n"
  );
  process.exit(1);
}

if (resizeWidth && resizeHeight) {
  console.log(
    "❌ Erreur : Veuillez ne spécifier que --width OU --height, pas les deux."
  );
  process.exit(1);
}

// --- 3. FONCTIONS UTILITAIRES ---

const downloadFile = (url, dest) => {
  return new Promise((resolve, reject) => {
    https
      .get(url, (response) => {
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return reject(
            new Error(
              `Échec du téléchargement, statut : ${response.statusCode}`
            )
          );
        }
        const fileStream = fs.createWriteStream(dest);
        response.pipe(fileStream);
        fileStream.on("finish", () => fileStream.close(() => resolve(dest)));
      })
      .on("error", (err) => {
        fs.unlink(dest, () => {});
        reject(err);
      });
  });
};

function getSvgDuration(svgContent) {
  const parser = new DOMParser();
  const doc = parser.parseFromString(svgContent, "image/svg+xml");
  const animations = doc.getElementsByTagName("*");
  let maxDuration = 0;
  for (let i = 0; i < animations.length; i++) {
    const el = animations[i];
    if (el.hasAttribute("dur")) {
      const durAttr = el.getAttribute("dur");
      if (durAttr.toLowerCase() === "indefinite") return -1;
      let currentDur = 0;
      if (durAttr.endsWith("ms")) currentDur = parseFloat(durAttr) / 1000;
      else if (durAttr.endsWith("s")) currentDur = parseFloat(durAttr);
      else currentDur = parseFloat(durAttr);
      if (currentDur > maxDuration) maxDuration = currentDur;
    }
  }
  return maxDuration;
}

// --- 4. FONCTION DE CONVERSION INDIVIDUELLE ---

async function convertSvgToWebp(svgUrl, tempFrameDir, options) {
  let localSvgPath = svgUrl;
  let isTempFile = false;

  // Étape A: Téléchargement si nécessaire
  if (svgUrl.startsWith("http")) {
    localSvgPath = path.join(tempFrameDir, "source.svg");
    await downloadFile(svgUrl, localSvgPath);
    isTempFile = true;
  }

  const svgContent = fs.readFileSync(localSvgPath, "utf8");
  const detectedDuration = getSvgDuration(svgContent);

  const captureStart = options.startTime ? parseFloat(options.startTime) : 0;
  const captureEnd = options.endTime
    ? parseFloat(options.endTime)
    : detectedDuration;
  const captureDuration = captureEnd - captureStart;

  if (captureDuration <= 0)
    throw new Error("La durée de capture est nulle ou négative.");

  const totalFrames = Math.ceil(captureDuration * options.fps);

  // Étape B: Capture des frames avec Puppeteer
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setContent(
    `<!DOCTYPE html><html><body style="margin:0; padding:0;">${svgContent}</body></html>`
  );
  const svgElement = await page.$("svg");

  for (let i = 0; i < totalFrames; i++) {
    const currentTime = captureStart + i / options.fps;
    await page.evaluate((time) => {
      document.querySelector("svg").setCurrentTime(time);
    }, currentTime);
    if (options.renderDelay > 0)
      await new Promise((res) => setTimeout(res, options.renderDelay));
    const framePath = path.join(
      tempFrameDir,
      `frame-${String(i).padStart(5, "0")}.png`
    );
    await svgElement.screenshot({ path: framePath, omitBackground: true });
  }
  await browser.close();

  // Étape C: Redimensionnement (si demandé)
  let resizeOption = "";
  if (options.resizeWidth)
    resizeOption = `-resize ${parseInt(options.resizeWidth)}x`;
  else if (options.resizeHeight)
    resizeOption = `-resize x${parseInt(options.resizeHeight)}`;

  if (resizeOption) {
    const mogrifyCommand = `mogrify ${resizeOption} "${path.join(
      tempFrameDir,
      "*.png"
    )}"`;
    await execPromise(mogrifyCommand);
  }

  // Étape D: Compilation en WebP
  const frameDurationMs = Math.round(1000 / options.fps);
  const frameFiles = fs
    .readdirSync(tempFrameDir)
    .filter((f) => f.endsWith(".png"))
    .sort()
    .map((f) => `"${path.join(tempFrameDir, f)}"`);
  const inputFilesString = frameFiles.join(" ");
  const outputWebpPath = path.join(tempFrameDir, "output.webp");
  const compileCommand = `img2webp -loop 0 -d ${frameDurationMs} ${inputFilesString} -o "${outputWebpPath}"`;
  await execPromise(compileCommand);

  if (isTempFile) fs.rmSync(localSvgPath, { force: true });

  return outputWebpPath;
}

// --- 5. SCRIPT PRINCIPAL ORCHESTRATEUR ---

async function main() {
  // Lecture du JSON d'entrée
  if (!fs.existsSync(inputJsonPath)) {
    return console.error(
      `❌ Fichier JSON d'entrée introuvable : ${inputJsonPath}`
    );
  }
  const inputJson = JSON.parse(fs.readFileSync(inputJsonPath, "utf8"));
  const outputJsonData = {};
  const conversionCache = new Map(); // Cache pour les URL déjà traitées

  // Création du répertoire de sortie principal
  fs.mkdirSync(outputDirPath, { recursive: true });
  console.log(
    `\n🚀 Démarrage du traitement de ${
      Object.keys(inputJson).length
    } animation(s)...`
  );

  for (const key in inputJson) {
    const item = inputJson[key];
    const svgUrl = item.svg_url;
    console.log(`\n--- Traitement de la clé : ${key} ---`);

    // NOUVEAU: Calcul du FPS effectif pour cet item
    let effectiveFps = baseFps;
    if (
      item.fps_factor &&
      typeof item.fps_factor === "number" &&
      item.fps_factor > 0
    ) {
      effectiveFps = Math.round(baseFps * item.fps_factor);
      console.log(
        `   INFO: Facteur FPS de ${item.fps_factor} appliqué. FPS effectif : ${effectiveFps}`
      );
    }

    // Création d'une clé de cache unique qui inclut les options de conversion
    const cacheKey = `${svgUrl}|${effectiveFps}|${resizeWidth || "none"}|${
      resizeHeight || "none"
    }|${startTime || "0"}|${endTime || "full"}`;

    // Vérification du cache
    if (conversionCache.has(cacheKey)) {
      console.log(
        `   CACHE HIT: Réutilisation du résultat pour la même URL et les mêmes options.`
      );
      const cachedResult = conversionCache.get(cacheKey);
      const finalWebpDestination = path.join(outputDirPath, `${key}.webp`);

      // Copie du fichier WebP déjà généré
      fs.copyFileSync(cachedResult.filePath, finalWebpDestination);

      outputJsonData[key] = {
        group: item.group,
        condition: item.condition,
        webp_base64: cachedResult.base64String,
      };
      console.log(
        `✅ Succès (depuis cache) pour la clé : ${key}. Fichier sauvegardé : ${finalWebpDestination}`
      );
      continue; // Passe à l'item suivant
    }

    // Si pas dans le cache, on procède à la conversion
    console.log(`   CACHE MISS: Nouvelle conversion pour l'URL ${svgUrl}`);
    const tempFrameDir = path.join(outputDirPath, `_temp_${key}`);
    fs.rmSync(tempFrameDir, { recursive: true, force: true });
    fs.mkdirSync(tempFrameDir, { recursive: true });

    try {
      const finalWebpPath = await convertSvgToWebp(svgUrl, tempFrameDir, {
        fps: effectiveFps, // Utilisation du FPS effectif
        renderDelay,
        startTime,
        endTime,
        resizeWidth,
        resizeHeight,
      });

      const base64String = fs.readFileSync(finalWebpPath, "base64");
      const finalWebpDestination = path.join(outputDirPath, `${key}.webp`);
      fs.renameSync(finalWebpPath, finalWebpDestination);

      outputJsonData[key] = {
        group: item.group,
        condition: item.condition,
        webp_base64: base64String,
      };

      // Mise en cache du nouveau résultat
      conversionCache.set(cacheKey, {
        base64String: base64String,
        filePath: finalWebpDestination,
      });

      console.log(
        `✅ Succès pour la clé : ${key}. Fichier sauvegardé : ${finalWebpDestination}`
      );
    } catch (error) {
      console.error(
        `❌ Erreur lors du traitement de la clé "${key}":`,
        error.message
      );
    } finally {
      fs.rmSync(tempFrameDir, { recursive: true, force: true });
    }
  }

  // Écriture du JSON final
  const outputJsonFilePath = path.join(outputDirPath, "output.json");
  fs.writeFileSync(outputJsonFilePath, JSON.stringify(outputJsonData, null, 2));

  console.log(`\n\n✨ Terminé !`);
  console.log(
    `   - Les fichiers WebP ont été sauvegardés dans : ${outputDirPath}`
  );
  console.log(`   - Le JSON de sortie a été créé : ${outputJsonFilePath}`);
}

main();
