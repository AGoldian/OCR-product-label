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
from models.utils import preprocessing_image, llm_work
import uuid
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
device = "cuda"
model = AutoModelForCausalLM.from_pretrained("mistralai/Mistral-7B-Instruct-v0.2",
                                            torch_dtype=torch.float16,
                                            cache_dir="cache",
                                            load_in_4bit=True,
                                            device_map="auto")
tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.2")



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
    ocr_text = preprocessing_image(f'{filename}.png')
    json_result = llm_work(ocr_text)

    return JSONResponse(content={
        'productName': 'Овсянка, сэр',
        'validateResults': {
            'child3years': {
                "validationTitle": "Для детей до 3х лет",
                "isOk": json_result['correct_flag'],
                'ocr_text': ocr_text,
                'comments': json_result['comments']
                # debug
            }
        }
    })
