// Import des modules nécessaires
const axios = require("axios");
const fs = require("fs").promises; // Utilisation de la version 'promises' de fs pour async/await

// 1. Définition de la liste des conditions météo
const weatherConditions = {
  "clear-night": { text: "Nuit claire", icon: 16310 },
  cloudy: { text: "Nuages", icon: 53673 },
  exceptional: { text: "Exceptionnel", icon: 7921 },
  fog: { text: "Brouillard", icon: 17055 },
  hail: { text: "Grêle", icon: 53288 },
  lightning: { text: "Orage", icon: 53801 },
  "lightning-rainy": { text: "Orage et pluie", icon: 53798 },
  partlycloudy: { text: "Éclaircies", icon: 53802 },
  pouring: { text: "Déluge", icon: 49300 },
  rainy: { text: "Pluie", icon: 53674 },
  snowy: { text: "Neige", icon: 53756 },
  "snowy-rainy": { text: "Neige fondue", icon: 53675 },
  sunny: { text: "Soleil", icon: 11201 },
  windy: { text: "Vent", icon: 15618 },
  "windy-variant": { text: "Vent nuageux", icon: 15618 },
};

/**
 * Fonction pour télécharger une image et l'encoder en Base64.
 * @param {number} iconId - L'ID de l'icône à télécharger.
 * @returns {Promise<string|null>} Une chaîne de caractères Base64 (Data URI) ou null en cas d'erreur.
 */
async function fetchAndEncodeIcon(iconId) {
  const url = `https://developer.lametric.com/content/apps/icon_thumbs/${iconId}.gif`;
  try {
    // 2. Téléchargement de l'image en tant que buffer binaire
    const response = await axios.get(url, { responseType: "arraybuffer" });

    // 3. Conversion du buffer en chaîne Base64 et formatage en Data URI
    const base64Icon = Buffer.from(response.data, "binary").toString("base64");
    return `data:image/png;base64,${base64Icon}`;
  } catch (error) {
    console.error(
      `❌ Erreur lors du téléchargement de l'icône ${iconId} depuis ${url}: ${error.message}`
    );
    return null;
  }
}

/**
 * Fonction principale qui orchestre la création du JSON final.
 */
async function generateWeatherJson() {
  console.log("🚀 Démarrage de la génération du fichier JSON...");
  const finalJson = {};

  // Traitement de chaque condition météo en parallèle pour plus d'efficacité
  const processingPromises = Object.entries(weatherConditions).map(
    async ([key, data]) => {
      console.log(`- Traitement de '${key}' (icône ${data.icon})...`);
      const base64Icon = await fetchAndEncodeIcon(data.icon);

      if (base64Icon) {
        finalJson[key] = {
          text: data.text,
          icon: base64Icon,
        };
      }
    }
  );

  // Attendre que toutes les icônes soient téléchargées et encodées
  await Promise.all(processingPromises);

  try {
    // 4. Écriture du résultat dans un fichier JSON
    await fs.writeFile(
      "weather_icons.json",
      JSON.stringify(finalJson, null, 2)
    );
    console.log("\n✅ Fichier 'weather_icons.json' généré avec succès !");
  } catch (error) {
    console.error(
      "❌ Erreur lors de l'écriture du fichier JSON final :",
      error
    );
  }
}

// Lancement du script
generateWeatherJson();
