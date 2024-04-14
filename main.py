import base64
from typing import BinaryIO
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import logging
from pydantic import BaseModel
from fastapi_storages import FileSystemStorage
import easyocr
import sys
import cv2
import uuid
sys.path.append('OCR-product-label')
import os
import numpy as np
import io
from PIL import Image


from models.utils import preprocessing_image


# download weights model
reader = easyocr.Reader(['ru'])

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = FastAPI()
storage = FileSystemStorage(path="/tmp")


class Data(BaseModel):
    file: str


@app.post("/analyze-image")
async def analyze_image(data: Data):

    def save_base64_to_png(base64_string, output_path):
        # Декодирование строки Base64 в байты
        image_data = base64.b64decode(base64_string)
        # Преобразование байтов в объект изображения
        image = Image.open(io.BytesIO(image_data))
        # Сохранение изображения в формате PNG
        image.save(output_path, "PNG")

    # Сохранение изображения в формате PNG
    save_base64_to_png(data, 'jopa.png')
    image_cv2 = cv2.imread('jopa.png')
    if image_cv2 is not None:
            print("Изображение успешно прочитано с помощью OpenCV")
    else:
        print('DLFCMDSNJKBKJDBJSF')

    # Возвращаем результат обработки изображения
    return JSONResponse(content={
        'productName': 'Овсянка, сэр',
        'validateResults': {
            'child3years': {
                "validationTitle": "Для детей до 3х лет",
                "isOk": True,
                'ocr_text': '',
                # debug
                'path': os.scandir('')
            }
        }
    })
