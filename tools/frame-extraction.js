/**
 * Script Node.js complet pour convertir un SVG animé (local ou via URL)
 * en GIF ou WebP animé, avec des options de redimensionnement et de découpage.
 *
 * USAGE:
 * node extraire-frames.js <fichier.svg|url> <fps> [--format gif|webp] [--width <px>|--height <px>] [--start <sec>] [--end <sec>]
 *
 * EXEMPLES:
 * // Convertir un fichier local en GIF de 500px de large
 * node extraire-frames.js anim.svg 30 --width 500
 *
 * // Convertir une URL en WebP, en ne capturant que de 1s à 4s
 * node extraire-frames.js https://example.com/anim.svg 25 --format webp --start 1 --end 4
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
const svgInput = args[0];
const fpsArg = args[1];

// Fonction utilitaire pour extraire les arguments optionnels (ex: --width 500)
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
const outputFormat = getArgValue("--format", "gif").toLowerCase();

// --- 2. VALIDATION DES ARGUMENTS ---

if (!svgInput || !fpsArg) {
  console.log("❌ Erreur : Arguments manquants.");
  console.log(
    "\n   Usage : node extraire-frames.js <fichier.svg|url> <fps> [--format gif|webp] ..."
  );
  console.log(
    "\n   Exemple : node extraire-frames.js anim.svg 30 --format webp --width 500\n"
  );
  process.exit(1);
}

if (outputFormat !== "gif" && outputFormat !== "webp") {
  console.log(
    `❌ Erreur : Format de sortie "${outputFormat}" non supporté. Choisissez "gif" ou "webp".`
  );
  process.exit(1);
}

if (resizeWidth && resizeHeight) {
  console.log(
    "❌ Erreur : Veuillez ne spécifier que --width OU --height, pas les deux."
  );
  process.exit(1);
}

const fps = parseInt(fpsArg) || 24;
const renderDelay = 50; // Délai en ms pour assurer le rendu correct de chaque frame

// --- 3. FONCTIONS UTILITAIRES ---

/**
 * Télécharge un fichier depuis une URL et le sauvegarde localement.
 * @param {string} url - L'URL du fichier à télécharger.
 * @returns {Promise<string>} Le chemin vers le fichier temporaire téléchargé.
 */
const downloadFile = (url) => {
  const tempFilePath = path.join(__dirname, `temp_svg_${Date.now()}.svg`);
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
        const fileStream = fs.createWriteStream(tempFilePath);
        response.pipe(fileStream);
        fileStream.on("finish", () =>
          fileStream.close(() => resolve(tempFilePath))
        );
      })
      .on("error", (err) => {
        fs.unlink(tempFilePath, () => {});
        reject(err);
      });
  });
};

/**
 * Analyse le contenu SVG pour en extraire la durée maximale de l'animation.
 * @param {string} svgContent - Le contenu XML du fichier SVG.
 * @returns {number} La durée en secondes, ou -1 si indéfinie.
 */
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

// --- 4. SCRIPT PRINCIPAL ---

async function main() {
  let localSvgPath = svgInput;
  let isTempFile = false;

  // Étape 0 : Téléchargement si l'entrée est une URL
  if (svgInput.startsWith("http")) {
    try {
      console.log(`🌐 Téléchargement du SVG depuis : ${svgInput}`);
      localSvgPath = await downloadFile(svgInput);
      isTempFile = true;
      console.log(`   Fichier temporaire créé : ${localSvgPath}`);
    } catch (error) {
      console.error("❌ Erreur lors du téléchargement du fichier SVG.", error);
      return;
    }
  }

  const outputDirName = path.basename(localSvgPath, path.extname(localSvgPath));

  console.log(`\n▶️  Fichier d'entrée : ${localSvgPath}`);
  console.log(`📁 Répertoire temporaire : ${outputDirName}`);
  console.log(`✨ Format de sortie : ${outputFormat.toUpperCase()}`);

  // Nettoyage du répertoire cible
  fs.rmSync(outputDirName, { recursive: true, force: true });
  fs.mkdirSync(outputDirName, { recursive: true });

  const svgContent = fs.readFileSync(localSvgPath, "utf8");
  const detectedDuration = getSvgDuration(svgContent);

  const captureStart = startTime ? parseFloat(startTime) : 0;
  const captureEnd = endTime ? parseFloat(endTime) : detectedDuration;
  const captureDuration = captureEnd - captureStart;

  if (captureDuration <= 0) {
    console.error("❌ La durée de la capture est nulle ou négative.");
    return;
  }

  console.log(
    `⏱️  Fenêtre de capture : de ${captureStart.toFixed(
      2
    )}s à ${captureEnd.toFixed(2)}s (Durée: ${captureDuration.toFixed(2)}s).`
  );
  const totalFrames = Math.ceil(captureDuration * fps);

  // Étape 1 : Capture des frames avec Puppeteer
  console.log(`\n🎬 1/4 - Lancement de la capture de ${totalFrames} images...`);
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setContent(
    `<!DOCTYPE html><html><body style="margin:0; padding:0;">${svgContent}</body></html>`
  );
  const svgElement = await page.$("svg");

  for (let i = 0; i < totalFrames; i++) {
    const currentTime = captureStart + i / fps;
    await page.evaluate((time) => {
      document.querySelector("svg").setCurrentTime(time);
    }, currentTime);
    if (renderDelay > 0)
      await new Promise((res) => setTimeout(res, renderDelay));
    const framePath = path.join(
      outputDirName,
      `frame-${String(i).padStart(5, "0")}.png`
    );
    await svgElement.screenshot({ path: framePath, omitBackground: true });
    process.stdout.write(` > Capture de l'image ${i + 1} / ${totalFrames}\r`);
  }
  await browser.close();
  console.log("\n✅ Capture des images terminée !");

  // Étape 2 : Redimensionnement (si demandé)
  let resizeOption = "";
  if (resizeWidth) {
    resizeOption = `-resize ${parseInt(resizeWidth)}x`;
    console.log(
      `\n📏 2/4 - Redimensionnement des images (largeur: ${resizeWidth}px)...`
    );
  } else if (resizeHeight) {
    resizeOption = `-resize x${parseInt(resizeHeight)}`;
    console.log(
      `\n📏 2/4 - Redimensionnement des images (hauteur: ${resizeHeight}px)...`
    );
  } else {
    console.log("\n🎨 2/4 - Pas de redimensionnement demandé.");
  }

  if (resizeOption) {
    // On utilise mogrify pour redimensionner toutes les images en une seule commande
    const mogrifyCommand = `mogrify ${resizeOption} "${path.join(
      outputDirName,
      "*.png"
    )}"`;
    try {
      await execPromise(mogrifyCommand);
      console.log("✅ Redimensionnement terminé.");
    } catch (error) {
      console.error(
        "❌ Erreur lors du redimensionnement avec 'mogrify'.",
        error
      );
      return;
    }
  }

  // Étape 3 : Compilation de l'animation finale
  console.log(
    `\n🎨 3/4 - Compilation de l'animation en ${outputFormat.toUpperCase()}...`
  );
  let compileCommand = "";
  const outputFileName = `${outputDirName}.${outputFormat}`;
  const outputFilePath = path.join(path.dirname(localSvgPath), outputFileName);

  if (outputFormat === "gif") {
    // La commande `convert` gère le redimensionnement, mais on l'a déjà fait.
    // On le laisse pour le cas où mogrify ne serait pas dispo, mais la logique actuelle le fait avant.
    compileCommand = `convert -delay ${Math.round(
      100 / fps
    )} -loop 0 -dispose Background "${path.join(
      outputDirName,
      "frame-*.png"
    )}" "${outputFilePath}"`;
  } else if (outputFormat === "webp") {
    const frameDurationMs = Math.round(1000 / fps);
    const frameFiles = fs
      .readdirSync(outputDirName)
      .sort()
      .map((f) => `"${path.join(outputDirName, f)}"`);
    const inputFilesString = frameFiles.join(" ");
    compileCommand = `img2webp -loop 0 -d ${frameDurationMs} ${inputFilesString} -o "${outputFilePath}"`;
  }

  try {
    await execPromise(compileCommand);
    console.log(`✅ Animation compilée avec succès : ${outputFilePath}`);
  } catch (error) {
    console.error(
      `❌ Erreur lors de la compilation de l'animation ${outputFormat.toUpperCase()}.`,
      error
    );
    return;
  }

  // Étape 4 : Nettoyage final
  console.log(`\n🧹 4/4 - Nettoyage des fichiers temporaires...`);
  fs.rmSync(outputDirName, { recursive: true, force: true });
  if (isTempFile) {
    fs.rmSync(localSvgPath, { force: true });
    console.log("   (Fichier SVG temporaire supprimé)");
  }
  console.log("✨ Terminé !");
}

main();
