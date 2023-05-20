#!/bin/bash

# Проверяем наличие аргумента:
if [[ ! -n $1 ]]
then
    # Если аргумента нет - выводим запрос города:
    echo -n "Input city name: "
    read City
else
    # Если аргумент есть - берем город из первого аргумента и присваиваем его переменной:
    City=$1
fi

API=$(cat WeatherAPI.txt)

# Создаем условие: если файл с таким названием существует, то (файл с этим названием будет использоваться для получения в него результата запроса):
if [[ -e city.json ]]
then
    cat city.json
    echo -e "\nFile city.json exist. Are you sure to overwrite? (y/n)"
    read YesNo1
else
    YesNo1="y"
fi

if [[ -e weather.json ]]
then
    # Выводим содержимое файла:
    cat weather.json
    # Спрашиваем у пользователя, хочет ли он перезаписать данные в этот файл?:
    echo -e "\nFile weather.json exist. Are you sure to overwrite? (y/n) "
    # Считываем введенный пользователем ответ:
    read YesNo2
else
    # Если файла не существует, то сразу присваиваем переменной значение "y":
    YesNo2="y"
fi

# Создаем условие: если значение переменной равно "y", то:
if [[ "$YesNo1" == "y" && "$YesNo2" == "y" ]]
then
    curl -sLo city.json "https://geocoding-api.open-meteo.com/v1/search?name=$City&count=1&language=en&format=json"
    lat=$(cat city.json | jq '.results[] | .latitude')
    long=$(cat city.json | jq '.results[] | .longitude')
    name=$(cat city.json | jq -r '.results[] | .name')
    # Обращаемся к API сайта погоды и отправляем результат в наш файлл. API токен получен в личном кабинете сайта (без подписки доступно 1000 обращений в день):
    curl -sLo weather.json "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current_weather=true&forecast_days=1"
    code=$(cat weather.json | jq '.current_weather.weathercode')
    # Считываем данные в файле и выводим только нужные параметры (запрашиваемый город, текущая погода и температура в градусах по цельсию):
    echo $name
    cat weather.json | jq -r '.current_weather | "Температура: \(.temperature)", "Скорость ветра: \(.windspeed)"'
    cat weather-code.json | jq -r ".weather[] | select(.code == $code) | \"Погода - \(.description)\""
fi