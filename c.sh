#!/bin/bash

# Путь к изображению
image_path="data/1.jpg"

# Чтение изображения и кодирование его в Base64
image_base64=$(base64 -i "$image_path")

# Отправка запроса на ваше API с использованием curl
curl -X POST "http://127.0.0.1:8080/analyze-image" \
     -H "Content-Type: application/json" \
     -d "{\"file\": \"data:image/jpeg;base64,$image_base64\" }"