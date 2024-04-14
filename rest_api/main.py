import base64
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import logging
from pydantic import BaseModel
from fastapi_storages import FileSystemStorage
import easyocr
import sys
sys.path.append('OCR-product-label')
import io
from PIL import Image
from models.utils import preprocessing_image
import uuid


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
        image_data = base64.b64decode(base64_string)
        image = Image.open(io.BytesIO(image_data))
        image.save(output_path, "PNG")


    filename = uuid.uuid4()
    save_base64_to_png(data.file, f'{filename}.png')
    res = preprocessing_image(f'{filename}.png')

    return JSONResponse(content={
        'productName': 'Овсянка, сэр',
        'validateResults': {
            'child3years': {
                "validationTitle": "Для детей до 3х лет",
                "isOk": True,
                'ocr_text': res,
                # debug
            }
        }
    })
