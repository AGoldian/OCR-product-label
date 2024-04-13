import base64
from typing import BinaryIO

from fastapi import FastAPI
from fastapi.responses import JSONResponse
import logging
from pydantic import BaseModel
from fastapi_storages import FileSystemStorage

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = FastAPI()
storage = FileSystemStorage(path="/tmp")


class Data(BaseModel):
    file: str


@app.post("/analyze-image")
async def analyze_image(data: Data):

    # Сохраняем изображение на сервере
    binf = BinaryIO()
    binf.write(data.file.encode('ascii'))
    storage.write(binf, name=str(hash(data.file)))


    # Возвращаем результат обработки изображения
    return JSONResponse(content={
        'productName': 'Овсянка, сэр',
        'validateResults': {
            'child3years': {
                "validationTitle": "Для детей до 3х лет",
                "isOk": True
            }
        }
    })
