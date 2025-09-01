load("http.star", "http")
load("encoding/base64.star", "base64")
load("render.star", "render")
load("animation.star", "animation")
load("time.star", "time")

HA_TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmMzgwMTgwN2IzZjg0NGZjOGVkYzFmNzViMGQzZjc3MCIsImlhdCI6MTc1MzcyNjIxMCwiZXhwIjoyMDY5MDg2MjEwfQ.M5A1wjs_f8_gaGmarG0NAF81mZQ9zI2ChQ91b4hW4Zk'

CODES = {
  "200": {
    "group": "Thunderstorm",
    "condition": "thunderstorm with light rain",
    "sky_color": {
      "day": "#649dd5",
      "night": "#07304e"
    }
  },
  "201": {
    "group": "Thunderstorm",
    "condition": "thunderstorm with rain",
    "sky_color": {
      "day": "#6593c2",
      "night": "#0e2c47"
    }
  },
  "202": {
    "group": "Thunderstorm",
    "condition": "thunderstorm with heavy rain",
    "sky_color": {
      "day": "#658cb3",
      "night": "#132a42"
    }
  },
  "210": {
    "group": "Thunderstorm",
    "condition": "light thunderstorm",
    "sky_color": {
      "day": "#649dd5",
      "night": "#07304e"
    }
  },
  "211": {
    "group": "Thunderstorm",
    "condition": "thunderstorm",
    "sky_color": {
      "day": "#6593c2",
      "night": "#0e2c47"
    }
  },
  "212": {
    "group": "Thunderstorm",
    "condition": "heavy thunderstorm",
    "sky_color": {
      "day": "#658cb3",
      "night": "#132a42"
    }
  },
  "221": {
    "group": "Thunderstorm",
    "condition": "ragged thunderstorm",
    "sky_color": {
      "day": "#667788",
      "night": "#222233"
    }
  },
  "230": {
    "group": "Thunderstorm",
    "condition": "thunderstorm with light drizzle",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#649dd5",
      "night": "#07304e"
    }
  },
  "231": {
    "group": "Thunderstorm",
    "condition": "thunderstorm with drizzle",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#6593c2",
      "night": "#0e2c47"
    }
  },
  "232": {
    "group": "Thunderstorm",
    "condition": "thunderstorm with heavy drizzle",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#658cb3",
      "night": "#132a42"
    }
  },
  "300": {
    "group": "Drizzle",
    "condition": "light intensity drizzle",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#8a99a8",
      "night": "#1f2e3d"
    }
  },
  "301": {
    "group": "Drizzle",
    "condition": "drizzle",
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "302": {
    "group": "Drizzle",
    "condition": "heavy intensity drizzle",
    "sky_color": {
      "day": "#6f7b88",
      "night": "#192531"
    }
  },
  "310": {
    "group": "Drizzle",
    "condition": "light intensity drizzle rain",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#8a99a8",
      "night": "#1f2e3d"
    }
  },
  "311": {
    "group": "Drizzle",
    "condition": "drizzle rain",
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "312": {
    "group": "Drizzle",
    "condition": "heavy intensity drizzle rain",
    "sky_color": {
      "day": "#6f7b88",
      "night": "#192531"
    }
  },
  "313": {
    "group": "Drizzle",
    "condition": "shower rain and drizzle",
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "314": {
    "group": "Drizzle",
    "condition": "heavy shower rain and drizzle",
    "sky_color": {
      "day": "#6f7b88",
      "night": "#192531"
    }
  },
  "321": {
    "group": "Drizzle",
    "condition": "shower drizzle",
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "500": {
    "group": "Rain",
    "condition": "light rain",
    "sky_color": {
      "day": "#8a99a8",
      "night": "#1f2e3d"
    }
  },
  "501": {
    "group": "Rain",
    "condition": "moderate rain",
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "502": {
    "group": "Rain",
    "condition": "heavy intensity rain",
    "sky_color": {
      "day": "#6f7b88",
      "night": "#192531"
    }
  },
  "503": {
    "group": "Rain",
    "condition": "very heavy rain",
    "sky_color": {
      "day": "#646f7a",
      "night": "#16222c"
    }
  },
  "504": {
    "group": "Rain",
    "condition": "extreme rain",
    "sky_color": {
      "day": "#4d555e",
      "night": "#111a22"
    }
  },
  "511": {
    "group": "Rain",
    "condition": "freezing rain",
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "520": {
    "group": "Rain",
    "condition": "light intensity shower rain",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#8a99a8",
      "night": "#1f2e3d"
    }
  },
  "521": {
    "group": "Rain",
    "condition": "shower rain",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#7b8896",
      "night": "#1b2936"
    }
  },
  "522": {
    "group": "Rain",
    "condition": "heavy intensity shower rain",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#6f7b88",
      "night": "#192531"
    }
  },
  "531": {
    "group": "Rain",
    "condition": "ragged shower rain",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#4d555e",
      "night": "#111a22"
    }
  },
  "600": {
    "group": "Snow",
    "condition": "light snow",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#b8b8b8",
      "night": "#3d3d3d"
    }
  },
  "601": {
    "group": "Snow",
    "condition": "snow",
    "sky_color": {
      "day": "#a3a3a3",
      "night": "#363636"
    }
  },
  "602": {
    "group": "Snow",
    "condition": "heavy snow",
    "sky_color": {
      "day": "#949494",
      "night": "#313131"
    }
  },
  "611": {
    "group": "Snow",
    "condition": "sleet",
    "sky_color": {
      "day": "#a3a3a3",
      "night": "#363636"
    }
  },
  "612": {
    "group": "Snow",
    "condition": "light shower sleet",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#b8b8b8",
      "night": "#3d3d3d"
    }
  },
  "613": {
    "group": "Snow",
    "condition": "shower sleet",
    "sky_color": {
      "day": "#a3a3a3",
      "night": "#363636"
    }
  },
  "615": {
    "group": "Snow",
    "condition": "light rain and snow",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#b8b8b8",
      "night": "#3d3d3d"
    }
  },
  "616": {
    "group": "Snow",
    "condition": "rain and snow",
    "sky_color": {
      "day": "#a3a3a3",
      "night": "#363636"
    }
  },
  "620": {
    "group": "Snow",
    "condition": "light shower snow",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#b8b8b8",
      "night": "#3d3d3d"
    }
  },
  "621": {
    "group": "Snow",
    "condition": "shower snow",
    "sky_color": {
      "day": "#a3a3a3",
      "night": "#363636"
    }
  },
  "622": {
    "group": "Snow",
    "condition": "heavy shower snow",
    "sky_color": {
      "day": "#949494",
      "night": "#313131"
    }
  },
  "701": {
    "group": "Atmosphere",
    "condition": "mist",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "711": {
    "group": "Atmosphere",
    "condition": "smoke",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "721": {
    "group": "Atmosphere",
    "condition": "haze",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "731": {
    "group": "Atmosphere",
    "condition": "sand/dust whirls",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "741": {
    "group": "Atmosphere",
    "condition": "fog",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "751": {
    "group": "Atmosphere",
    "condition": "sand",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "761": {
    "group": "Atmosphere",
    "condition": "dust",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "762": {
    "group": "Atmosphere",
    "condition": "volcanic ash",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "771": {
    "group": "Atmosphere",
    "condition": "squalls",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "781": {
    "group": "Atmosphere",
    "condition": "tornado",
    "sky_color": {
      "day": "#5c6b7b",
      "night": "#1f1f2e"
    }
  },
  "800": {
    "group": "Clear",
    "condition": "clear sky",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#64a6e8",
      "night": "#003355"
    }
  },
  "801": {
    "group": "Clouds",
    "condition": "few clouds: 11-25%",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#649fda",
      "night": "#053050"
    }
  },
  "802": {
    "group": "Clouds",
    "condition": "scattered clouds: 25-50%",
    "has_night_icon": 1,
    "sky_color": {
      "day": "#6596c6",
      "night": "#0c2d49"
    }
  },
  "803": {
    "group": "Clouds",
    "condition": "broken clouds: 51-84%",
    "sky_color": {
      "day": "#658aae",
      "night": "#142941"
    }
  },
  "804": {
    "group": "Clouds",
    "condition": "overcast clouds: 85-100%",
    "sky_color": {
      "day": "#66809b",
      "night": "#1b253a"
    }
  }
}

conditions = {
  "clear-night": "800",
  "cloudy": "803",
  "exceptional": "221",
  "fog": "741",
  "hail": "611",
  "lightning": "221",
  "lightning-rainy": "201",
  "partlycloudy": "801",
  "pouring": "503",
  "rainy": "501",
  "snowy": "601",
  "snowy-rainy": "616",
  "sunny": "800",
  "windy": "781",
  "windy-variant": "771",
}


ERROR = base64.decode("iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAAsTAAALEwEAmpwYAAABkklEQVQ4ja3TvWtUQRQF8N8aDSKICpYOGBxT2CkE/KjsrLW10Ubt40cnccVN0FrUWrDU/0AQAhEUKwvNs5pKEUQiMSDLWuw1vF1335rggQtvzr33zLnzZvjPaE0qKNkunIzlSqr8aqrfMUFsP5bxKmI5uO0Joo05PIqYw52mhrEjl2wW7/EWp4JewQkcS5XVrTrsYCfmU6WXKj3MB9dpcjnK3ZmS9Ur2PNYzJZuJ7xeRO/1PDkvWwn10cSvoZxFwM3IPorZZEBf0z+xxqnwIbm+E4J5EzflGwZJNYxFrWBg1UmABP7AYPWMdXsURLKXKlxrfixAuP2MJGVfqAptnULJ9+IQNzKbKei13MYSe1rg9WMU0cqp8H7BWsk78vUsNow73XI6eewMOS5bwMXY8nirdoca/HAY/hXc4GlOVP2d4F7txfVgscC5iAFF7I3rb9Z02SvamYbTWqDtXy70u2U/6zwjWcahk1/C1QXgUDuJwaGwKtvXv1sNxYhOwhtsMXpsDOIupLYp18TJVvm3TTDN+A2lMgHAefbjLAAAAAElFTkSuQmCC")
UMBRELLA = base64.decode("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")
LR = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAnElEQVR4nO3QuQ0AIADDQL79Z6ZgiCuwpdSxPMfj4G31vcbnFEALaAqgBTQF0AKaAmgBTQG0gKYAWkBTAC2gKYAW0BRAC2gKoAU0BdACmgJoAU0BtICmAFpAUwAtoCmAFtAUQAtoCqAFNAXQApoCaAFNAbSApgBaQFMALaApgBbQFEALaAqgBTQF0AKaAmgBTQG0gKYAWkBTAC2gudIqAXvbmNzZAAAAAElFTkSuQmCC")
TB = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAhklEQVR4nO3SQQ3AMAADsUwtf8yDcY/6EERWtsf7tt16RNkdAAAA6hFlAAYAAIB6RBmAAQAAoB5RBmAAAACoR5QBGAAAAOoRZQAGAACAekQZgAHYqUeUecAAAABQjygDMAAAANQjygAMAAAA9YgyAAMAAEA9ogzAAAAAUI8oAzAAAADUI8p+ohoB9esQgvwAAAAASUVORK5CYII=")
RL = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAoUlEQVR4nO3QwQmAUADD0Or+G/sFx3gHE+i5Ide2Z9tBe+H32Xbu/ZwCaAFNAbSApgBaQFMALaApgBbQFEALaAqgBTQF0AKaAmgBTQG0gKYAWkBTAC2gKYAW0BRAC2gKoAU0BdACmgJoAU0BtICmAFpAUwAtoCmAFtAUQAtoCqAFNAXQApoCaAFNAbSApgBaQFMALaApgBbQFEALaAqgBTQf/gQ/gDAMjBgAAAAASUVORK5CYII=")
BT = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAjUlEQVR4nO3SsQkDQQADQR18/w3bhg9cxAY3W4EYdLZ9dnHPtm89ogzAAAAAUI8oAzAAAADUI8oADAAAAPWIMgADAABAPaIMwAAAAFCPKAMwAACuB/jVI8o8YAAAAKhHlAEYAAAA6hFlAAYAAIB6RBmAAQAAoB5RBmAAAACoR5QBGAAAAOoRZWd/BN3aCw1XPgOPTHCYAAAAAElFTkSuQmCC")

def build_keyframe(offset, pct):
    return animation.Keyframe(
        percentage = pct,
        transforms = [animation.Translate(offset, 0)],
        curve = "ease_in_out",
    )

# A string containing all 16 hexadecimal characters in order.
HEX_CHARS = "0123456789abcdef"
def probability_to_hex_char(p):
  """Converts a probability (float between 0.0 and 1.0) to a hex char.

  Args:
      p: A float representing the probability, should be in the range [0.0, 1.0].

  Returns:
      A string containing a single hexadecimal character ('0'-'f').
  """
  if not (p >= 0.0 and p <= 1.0):
      fail("Input probability must be between 0.0 and 1.0, but got %s" % p)

  # Scale the probability from [0.0, 1.0] to an integer in [0, 15].
  # p * 16.0 scales the range to [0.0, 16.0].
  # int() truncates the float to an integer.
  # min(15, ...) clamps the result to 15 to handle the edge case where p is exactly 1.0.
  index = min(15, int(p * 16.0))

  return HEX_CHARS[index]  

def ceil(valeur):
  # Si la valeur n'est pas un entier (ex: 1.04), le reste de sa
  # division par 1 sera différent de 0.
  if valeur % 1 != 0:
    # On prend la partie entière et on ajoute 1.
    return int(valeur) + 1
  else:
    # Sinon, la valeur est déjà un entier (ex: 0.0, 1.0, 4.0), on la retourne telle quelle.
    return int(valeur)


def group_forecast_by_3h(hourly_forecasts):
    """
    Regroupe les prévisions par tranches de 3h.
    - Ignore 'condition' et 'datetime'.
    - Prend le max pour 'precipitation_probability'.
    - Additionne 'precipitation'.
    - Moyenne les autres valeurs.
    """
    three_hour_forecasts = []
    
    keys_to_ignore = ["condition", "datetime"]
    
    for i in range(0, len(hourly_forecasts) - 2, 3):
        
        chunk = [
            hourly_forecasts[i],
            hourly_forecasts[i + 1],
            hourly_forecasts[i + 2]
        ]
        aggregated_data = {}

        # --- Traitement de la 'condition' (inchangé) ---
        conditions = []
        for hour_data in chunk:
            conditions.append(hour_data['condition'])
        
        counts = {}
        for cond in conditions:
            counts[cond] = counts.get(cond, 0) + 1
        
        most_frequent_condition = ""
        max_count = 0
        for cond, count in counts.items():
            if count > max_count:
                max_count = count
                most_frequent_condition = cond
        
        aggregated_data['condition'] = most_frequent_condition
        aggregated_data['datetime'] = chunk[0]['datetime']

        # --- Traitement des valeurs numériques (MODIFIÉ) ---
        all_keys = chunk[0].keys()
        
        for key in all_keys:
            if key in keys_to_ignore:
                continue

            # NOUVELLE LOGIQUE : if / elif / else pour chaque cas
            if key == 'precipitation_probability':
                # CAS 1: On prend la valeur maximale du chunk
                max_value = 0.0
                # On peut aussi prendre la première valeur comme max initial
                # max_value = float(chunk[0].get(key, 0))
                for hour_data in chunk:
                    current_value = float(hour_data.get(key, 0))
                    if current_value > max_value:
                        max_value = current_value
                aggregated_data[key] = max_value
            
            elif key == 'precipitation':
                # CAS 2: On additionne les valeurs
                total = 0.0
                for hour_data in chunk:
                    total += float(hour_data.get(key, 0))
                aggregated_data[key] = total
            
            else:
                # CAS 3: On fait la moyenne pour tout le reste
                total = 0.0
                for hour_data in chunk:
                    total += float(hour_data.get(key, 0))
                aggregated_data[key] = total / len(chunk)

        three_hour_forecasts.append(aggregated_data)
        
    return three_hour_forecasts

# debug
debug = False

def get_tempo_today():
  if debug: return "Bleu"
  rep = http.get('http://192.168.0.50:8123/api/states/sensor.rte_tempo_couleur_actuelle', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  return rep.json()["state"]

def get_tempo_tomorrow():
  if debug: return "Rouge"
  rep = http.get('http://192.168.0.50:8123/api/states/sensor.rte_tempo_prochaine_couleur', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  return rep.json()["state"]

def get_night_code():
  if debug: return "n"
  rep = http.get('http://192.168.0.50:8123/api/states/sun.sun', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  state = rep.json()["state"]
  return "n" if state == "below_horizon" else ""

def get_current_weather_code():
  if debug: return "803"
  rep = http.get('http://192.168.0.50:8123/api/states/sensor.openweathermap_weather_code', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  state = rep.json()["state"]
  return state

def get_current_temp():
  if debug: return "12.5"
  rep = http.get('http://192.168.0.50:8123/api/states/sensor.openweathermap_temperature', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  state = float(rep.json()["state"])
  return "%s" % (int(state * 10) / 10)

def get_today_tomorrow_forecast():
  # 48 values, from 00 today to 23 tomorrow
  now = time.now()
  midnight=time.time(year=now.year,month=now.month,day=now.day)
  if debug: return [
    {
      "datetime": (midnight + 0 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 50,
      "precipitation": 1,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 1 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 90,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 2,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 2 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 70,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 4,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 3 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 40,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 70,
      "precipitation": 2,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 4 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 10,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 20,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 5 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 0,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 0,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 6 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 7 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 8 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 9 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 10 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 11 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 12 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 13 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 14 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 15 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 16 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 17 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 18 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 19 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 20 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 21 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 22 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 23 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 24 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 50,
      "precipitation": 1,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 25 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 90,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 2,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 26 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 70,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 4,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 27 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 40,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 70,
      "precipitation": 2,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 28 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 10,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 20,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 29 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 0,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 0,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 30 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 31 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 32 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 33 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 34 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 35 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 36 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 37 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 38 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 39 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 40 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 41 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 42 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 43 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 44 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 45 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 46 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
    },
    {
      "datetime": (midnight + 47 * time.hour).format("2006-01-02T15:04:05+00:00"),
      "condition": "rainy",
      "temperature": 19.3,
      "pressure": 1012,
      "cloud_coverage": 100,
      "wind_speed": 10.44,
      "wind_bearing": 38,
      "uv_index": 0.85,
      "precipitation_probability": 100,
      "precipitation": 0.5,
      "apparent_temperature": 19.2,
      "dew_point": 15,
      "wind_gust_speed": 12.42,
      "humidity": 75
      }
    ]
  rep = http.get('http://192.168.0.50:8123/api/states/pyscript.today_tomorrow_forecast', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  
  # only output what we need - a 3 hours average of the 24h
  return group_forecast_by_3h(rep.json()["attributes"]["forecast"])

def get_daily_forecast():
  rep = http.post('http://192.168.0.50:8123/api/services/weather/get_forecasts?return_response', headers={'Authorization': 'Bearer ' + HA_TOKEN}, body='{"entity_id": "weather.openweathermap", "type": "daily"}')
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  results=[]
  count=0
  return rep.json()["service_response"]["weather.openweathermap"]["forecast"]


def get_icon(code, night):
  print(code, night)
  url = 'https://raw.githubusercontent.com/zeflash/HAPixlet/refs/heads/main/images/codes/' + code + ("n" if "has_night_icon" in CODES[code] and night else "") + '.webp'
  rep = http.get(url)
  if rep.status_code != 200:
    return ERROR
  return rep.body()

def get_close_window():
  if debug: return False
  rep = http.get('http://192.168.0.50:8123/api/states/binary_sensor.climate_close_window', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  state = rep.json()["state"]
  return True if state == "on" else False

def get_open_window():
  if debug: return False
  rep = http.get('http://192.168.0.50:8123/api/states/binary_sensor.climate_open_window', headers={'Authorization': 'Bearer ' + HA_TOKEN})
  if rep.status_code != 200:
      fail("HomeAssistant request failed with status %d", rep.status_code)
  state = rep.json()["state"]
  return True if state == "on" else False


def render_close_window():
  rep = http.get("https://raw.githubusercontent.com/zeflash/HAPixlet/refs/heads/main/images/hot.webp")
  img = rep.body() if rep.status_code == 200 else ERROR

  return render.Stack(
            children=[
              render.Box(width=64, color="#F404"),
              render.Padding(
                pad = (14, 11, 0, 0), 
                child =render.Marquee(
                  width = 64,
                  child = render.Text("Fermez les fenêtres!", font = "6x10")
                )
              ),
              render.Padding(
                pad = (-10,1, 0, 0), 
                child = render.Image(src=img)
              ),
            ]
          )
  

def render_open_window():
  rep = http.get("https://raw.githubusercontent.com/zeflash/HAPixlet/refs/heads/main/images/cold.webp")
  img = rep.body() if rep.status_code == 200 else ERROR

  return render.Stack(
            children=[
              render.Box(color="#24F4"),
              render.Padding(
                pad = (14, 11, 0, 0), 
                child =render.Marquee(
                  width = 64,
                  child = render.Text("Ouvrez les fenêtres!", font = "6x10")
                )
              ),
              render.Padding(
                pad = (-10,1, 0, 0), 
                child = render.Image(src=img)
              ),
            ]
          )
  

def render_min_max(min, current, max, tempo):
  backColor = "#3a71fcff" if (tempo == "Bleu") else "#b9b9b9ff" if (tempo == "Blanc") else "#b22613ff" if (tempo == "Rouge") else "#0004"
  return render.Row(
              expanded=True,
              main_align="space_between",
              cross_align="center",
              children = [
                  render.Box(
                    width=20,
                    height=7,
                    color=backColor,
                    child=render.Padding(pad = (0 ,1, 0, 0), child = render.Text(min, font = "tom-thumb", color="#7CF"))
                ),
                render.Box(
                  width=24,
                  height=7,
                  color=backColor,
                  child=render.Padding(pad = (0 ,1, 0, 0), child = render.Text(current, font = "tom-thumb"))
                ) if current else 
                render.Box(
                  width=24,
                  height=7,
                  color=backColor
                ),
                render.Box(
                  width=20,
                  height=7,
                color=backColor,
                  child=render.Padding(pad = (1 ,1, 0, 0), child = render.Text(max, font = "tom-thumb", color="#F95"))
                ),
              ]
            )

def render_3h(x):
    cloud = x["cloud_coverage"] / 100
    # print("cloud", cloud)
    
    prob = x["precipitation_probability"] / 100
    prob = ceil(prob * 5)
    # print("prob", prob)
    
    quantity = x["precipitation"]
    # print("quantity", quantity)
    quantity = ceil(x["precipitation"]) 
    quantity = 5 if quantity > 5 else quantity

    start_time =  time.parse_time(x['datetime']) - (2 * time.hour)
    print(x['datetime'], time.now() - start_time)
    isNow = (time.now() - start_time) >= 0 * time.hour and (time.now() - start_time) < 3 * time.hour
    colorDay = "#fff" if isNow else "#0000"

    return render.Stack(
            children=[
              render.Padding(
                pad = (0, 1, 0, 0), 
                color= "#000",
                child = render.Padding(
                  pad = (1, 0, 0, 0), 
                  child=render.Stack([
                    render.Box(
                      color="#6AF",
                      width=7,
                      height=5
                    ),
                    render.Padding(
                      pad = (1, 0, 0, 0), 
                      child=render.Circle(
                        color="#FC0",
                        diameter=5
                      )
                    ),
                    render.Padding(
                      pad = (0, 0, 0, 0), 
                      color="#555" + probability_to_hex_char(cloud),
                      child=render.Row(
                        cross_align="end",
                        children = [
                          render.Box(width=3, height=5),
                          render.Box(width=2, height=-1 if prob == 0 else prob, color="#FFFA"),
                          render.Box(width=2, height=-1 if quantity == 0 else quantity, color="#79F"),
                        ]
                      )
                    )
                  ])
                )
              ),
              render.Padding(pad = (1, 0, 0, 0), child = render.Box(width=7, height=1, color=colorDay))
            ])


def render_today_forecast():
  forecast = get_today_tomorrow_forecast()
  rows = []
  for i in range(0,8):
    x = forecast[i]
    rows.append(render_3h(x))
  
  return render.Padding(
          pad=(0,26,0,0),
          child=render.Row(
              # expanded=True,
              cross_align="end",
              children = rows
            )
  )

def render_tomorrow_forecast():
  forecast = get_today_tomorrow_forecast()
  rows = []
  for i in range(8,16):
    x = forecast[i]
    rows.append(render_3h(x))

  return render.Padding(
          pad=(0,26,0,0),
          child=render.Row(
              # expanded=True,
              cross_align="end",
              children = rows
            )
  )

def render_rain_risk(prob, quantity):
  return None if (prob == 0) else render.Padding(pad = (26,7,0,0), child=render.Row(
    main_align="end",
    children=[
      render.Padding(pad = (-4,0,-4,0), color="#0004", child=render.Image(src = UMBRELLA)),
      render.Padding(pad = (0,4,0,3), color="#0008", child=render.Column(
        cross_align="end",
        children=[
          render.Box(width=26,height=-1),
          render.Text("%s%%" % prob, font = "tom-thumb", color="#FFFA"),
          render.Text("%smm" % quantity, font = "tom-thumb", color="#79F")
        ]
      ))
    ]
  ))


def render_today_tomorrow():
  night = get_night_code()
  current = get_current_temp()
  
  daily = get_daily_forecast()
  min = "%s" % daily[0]["templow"]
  max = "%s" % daily[0]["temperature"]

  min_tomorrow = "%s" % daily[1]["templow"]
  max_tomorrow = "%s" % daily[1]["temperature"]

  tempo = get_tempo_today()
  code = get_current_weather_code()
  icon = get_icon(code, night)
  sky_color = CODES[code]["sky_color"]["night" if night == "n" else "day"]
  prob = daily[0]["precipitation_probability"]
  quantity = daily[0]["precipitation"]

  tempo_tomorrow = get_tempo_tomorrow()
  code_tomorrow = conditions[daily[1]["condition"]]
  icon_tomorrow = get_icon(code_tomorrow, "")
  sky_color_tomorrow = CODES[code_tomorrow]["sky_color"][ "day"]
  prob_tomorrow = daily[1]["precipitation_probability"]
  quantity_tomorrow = daily[1]["precipitation"]

  condition = render.Stack(
    children=[
      render.Box(width=64, color=sky_color),
      # current weather condition
      render.Padding(pad = (-4, 1, 0, 0), child = render.Image(src = icon)),
    ]
  )

  condition_tomorrow = render.Stack(
    children=[
      # sky color
      render.Box(width=64, color=sky_color_tomorrow), 
      # tomorrow's weather condition
      render.Padding(pad = (-4, 1, 0, 0), child = render.Image(src = icon_tomorrow)),
    ]
  )

  return render.Stack(
          children=[
            render_close_window() if (get_close_window()) else render_open_window() if (get_open_window()) else None,
            animation.Transformation(
              duration = 200,
              width = 192,
              keyframes = [
                  build_keyframe(0, 0.0),
                  build_keyframe(0, 0.45),
                  build_keyframe(-64, 0.55),
                  build_keyframe(-64, 1),
              ],
              child = render.Row(
                children=[
                  render.Stack(
                    children=[
                      # render.Box(width=64,height=32,color="#FF0"),
                      None if (get_close_window() or get_open_window()) else condition,
                      render_rain_risk(prob, quantity),
                      render.Padding(pad = (0, -25, 0, 0), child=render.Box(width=64, child=render_min_max(min, current, max, tempo))),
                      render_today_forecast()
                    ]
                  ),
                  render.Stack(
                    children=[
                      # render.Box(width=64,height=32,color="#0F0"),
                      None if (get_close_window() or get_open_window()) else condition_tomorrow,
                      render_rain_risk(prob_tomorrow, quantity_tomorrow),
                      render.Padding(pad = (0, -25, 0, 0), child=render.Box(width=64, child=render_min_max(min_tomorrow, None, max_tomorrow, tempo_tomorrow))),
                      render_tomorrow_forecast()
                    ]
                  ),
                  # # last one is the first one again
                  # render.Stack(
                  #   children=[
                  #     render.Box(width=64,height=32,color="#0FF"),
                  #     None if (get_close_window() or get_open_window()) else condition,
                  #     render.Padding(pad = (0, -25, 0, 0), child=render.Box(width=64, child=render_min_max(min, current, max))),
                  #     render_today_forecast()
                  #   ]
                  # ),
                ]
              )
            )
          ]
  )

def main():
  return render.Root(
    child = render_today_tomorrow()
  )

  # if get_close_window():
  #   return render_close_window()

  # if get_open_window():
  #   return render_open_window()
  
  # return render_default()

  # return render.Root(
  #   # child = animation.Transformation(
  #     # duration = 100,
  #     # width = 128,
  #     # keyframes = [
  #     #     build_keyframe(0, 0.0),
  #     #     build_keyframe(0, 0.4),
  #     #     build_keyframe(-64, 0.5),
  #     #     build_keyframe(-64, 0.9),
  #     # ],
  #     child = render.Row(
  #     children=[
  #       render.Stack(
  #         children=[
  #           render.Padding(
  #             pad = (0,30, 0, 0), 
  #             child =render.Row(
  #               expanded=True,
  #               main_align="space_between",
  #               cross_align="center",
  #               children = [
  #               ]
  #             )
  #           ),
  #           # render.Padding(pad = (0,30, 0, 0), child = render.Box(color="#800")),
  #           # render.Padding(pad = (0,31, 0, 0), child = render.Box(color="#F00")),
  #           # sky color
  #           render.Box(color=CODES[code]["sky_color"]["night" if night == "n" else "day"]),
  #           # background overlay
  #           render.Column(
  #             children=[
  #               render.Box(height = 19),
  #               render.Box(height = 7, color="#0004"),
  #               render.Box(height = 7, color="#0009"),
  #             ]
  #           ),
  #           # current weather condition
  #           render.Padding(pad = (-4, -6, 0, 0), child = render.Image(src = icon)),
  #           # temperatures
  #           render.Padding(pad = (0, 19, 0, 0), child = render.Column(
  #             children = [
  #               render.Row(
  #                 expanded=True,
  #                 main_align="space_between",
  #                 cross_align="center",
  #                 children = [
  #                     render.Box(
  #                       width=20,
  #                       height=7,
  #                       color="#24F4",
  #                       child=render.Padding(pad = (0 ,1, 0, 0), child = render.Text(min_temp, font = "tom-thumb", color="#7AF"))
  #                   ),
  #                   render.Box(
  #                     width=20,
  #                     height=7,
  #                     child=render.Padding(pad = (0 ,1, 0, 0), child = render.Text(current_temp, font = "tom-thumb"))
  #                   ),
  #                   render.Box(
  #                     width=20,
  #                     height=7,
  #                   color="#F404",
  #                     child=render.Padding(pad = (1 ,1, 0, 0), child = render.Text(max_temp, font = "tom-thumb", color="#F84"))
  #                   ),
  #                   # render.Text("12.1", font = "tom-thumb"),
  #                   # render.Box(width=4, height=10, color="#F77"),
  #                 ]
  #               ),
  #               # render.Row(
  #               #   expanded=True,
  #               #   # main_align="space_around",
  #               #   cross_align="center",
  #               #   children = [
  #               #     render.Box(width=26, height=1),
  #               #     render.Box(width=4, height=10, color="#F77"),
  #               #     render.Text("12.1", font = "tom-thumb"),
  #               #   ]
  #               # )
  #             ]
  #           )),
  #           render.Column(
  #             children = [
  #               render.Box(height=26),
  #               render.Padding(
  #               pad=(0,1,0,0),
  #               child=render.Row(
  #                 expanded=True,
  #                 main_align="space_evenly",
  #                 cross_align="end",
  #                 children = rows
  #               )
  #             )
  #             ]
  #           ),
  #         ],
  #       ),
  #       # render.Stack(
  #       #   children=[
  #       #     render.Box(color = "#242", width = 64),
  #       #     render.Row(
  #       #       children = [
  #       #         render.Text("07.0•", font = "tom-thumb", color="#88F"),
  #       #         render.Text("12.1•", font = "tom-thumb"),
  #       #         render.Text("24.6", font = "tom-thumb", color="#F77")
  #       #       ]
  #       #     ),
  #       #     render.Padding(pad = -4, child = render.Image(src = RAIN_ICON)),
  #       #   ],
  #       # ),
  #     ]
  #   ),
  #   # wait_for_child = True,
  # # ),
  # )
  #         #     child = render.Row(
  #         #     expanded = True,
  #         #     main_align = "space_evenly",
  #         #     cross_align = "center",
  #         #     children = [
  #         #         render.Padding(pad = -4, child = render.Image(src = CLEAR_ICON)),
  #         #         render.Column(
  #         #           children = [
  #         #             render.Marquee(
  #         #               width = 64,
  #         #               child = render.Text("Il pleut à verse")
  #         #             ),
  #         #             render.Marquee(
  #         #                width = 64,
  #         #               child = render.Text("7.0 / 12.1 / 24.6")
  #         #             )
  #         #           ]
  #         #         )

  #         #     ],
  #         # ),
  #         # )
