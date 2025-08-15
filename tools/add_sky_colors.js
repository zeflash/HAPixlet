const fs = require('fs');

/**
 * Converts a 3-digit hex color string (e.g., "#16B") to an RGB object.
 * @param {string} hex - The 3-digit hex color string.
 * @returns {object} The RGB color object {r, g, b}.
 */
function hexToRgb(hex) {
  const r = parseInt(hex[1] + hex[1], 16);
  const g = parseInt(hex[2] + hex[2], 16);
  const b = parseInt(hex[3] + hex[3], 16);
  return { r, g, b };
}

/**
 * Darkens an RGB color by a given factor.
 * @param {object} color - The color to darken {r, g, b}.
 * @param {number} factor - The darkening factor (0.0 to 1.0).
 * @returns {object} The new, darkened color object {r, g, b}.
 */
function darken(color, factor) {
    return {
        r: Math.round(color.r * (1 - factor)),
        g: Math.round(color.g * (1 - factor)),
        b: Math.round(color.b * (1 - factor)),
    };
}

// --- Full Day/Night Color Palette ---
const clearDay = hexToRgb('#16B');
const clearNight = hexToRgb('#035');

const cloudyDay = hexToRgb('#678');
const cloudyNight = hexToRgb('#223');

const rainyDay = hexToRgb('#9ab');
const rainyNight = hexToRgb('#234');

const snowyDay = hexToRgb('#CCC');
const snowyNight = hexToRgb('#444');


/**
 * Mixes two RGB colors based on a ratio.
 * @param {object} color1 - The first color {r, g, b}.
 * @param {object} color2 - The second color {r, g, b}.
 * @param {number} ratio - The mix ratio (0.0 to 1.0).
 * @returns {string} The mixed color as a hex string.
 */
function mixColors(color1, color2, ratio) {
  const r = Math.round(color1.r * (1 - ratio) + color2.r * ratio);
  const g = Math.round(color1.g * (1 - ratio) + color2.g * ratio);
  const b = Math.round(color1.b * (1 - ratio) + color2.b * ratio);
  return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`;
}

/**
 * Estimates cloud/precipitation intensity percentage from a weather condition object.
 * @param {object} weatherData - The weather data object.
 * @returns {number} Intensity ratio (0.0 to 1.0).
 */
function getIntensity(weatherData) {
  const condition = weatherData.condition.toLowerCase();

  if (condition.includes('clear sky')) return 0.0;
  if (condition.includes('11-25%')) return 0.15;
  if (condition.includes('25-50%')) return 0.35;
  if (condition.includes('51-84%')) return 0.60;
  if (condition.includes('85-100%')) return 0.8;
  if (condition.includes('overcast')) return 1;
  
  if (condition.includes('extreme') || condition.includes('ragged')) return 1.0;
  if (condition.includes('very heavy')) return 0.7;
  if (condition.includes('heavy')) return 0.55;
  if (condition.includes('moderate')) return 0.4;
  if (condition.includes('light') || condition.includes('few')) return 0.2;

  // Default for generic conditions like "snow" or "rain"
  return 0.4;
}


// Main script logic
fs.readFile('map.json', 'utf8', (err, data) => {
  if (err) {
    console.error("Error reading map.json:", err);
    return;
  }

  const weatherMap = JSON.parse(data);

  for (const code in weatherMap) {
    const weatherData = weatherMap[code];
    const group = weatherData.group.toLowerCase();
    const intensity = getIntensity(weatherData);
    
    let dayColor, nightColor;

    if (['rain', 'drizzle'].includes(group)) {
      const extremeDay = darken(rainyDay, 0.5);
      const extremeNight = darken(rainyNight, 0.5);
      dayColor = mixColors(rainyDay, extremeDay, intensity);
      nightColor = mixColors(rainyNight, extremeNight, intensity);
    } else if (group === 'snow') {
      const extremeDay = darken(snowyDay, 0.5);
      const extremeNight = darken(snowyNight, 0.5);
      dayColor = mixColors(snowyDay, extremeDay, intensity);
      nightColor = mixColors(snowyNight, extremeNight, intensity);
    } else if (['clouds', 'thunderstorm'].includes(group)) {
      dayColor = mixColors(clearDay, cloudyDay, intensity);
      nightColor = mixColors(clearNight, cloudyNight, intensity);
    } else if (group === 'clear') {
      dayColor = mixColors(clearDay, clearDay, 1);
      nightColor = mixColors(clearNight, clearNight, 1);
    } else { // Atmosphere group
      dayColor = mixColors(cloudyDay, darken(cloudyDay, 0.2), 0.5);
      nightColor = mixColors(cloudyNight, darken(cloudyNight, 0.2), 0.5);
    }

    weatherData.sky_color = {
      day: dayColor,
      night: nightColor
    };
  }

  fs.writeFile('map.json', JSON.stringify(weatherMap, null, 2), 'utf8', (err) => {
    if (err) {
      console.error("Error writing to map.json:", err);
    } else {
      console.log("Successfully updated map.json with new color logic.");
    }
  });
});
