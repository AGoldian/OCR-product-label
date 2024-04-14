import cv2
import albumentations as A
from albumentations.pytorch import ToTensorV2
import numpy as np
from PIL import Image
import easyocr
from dicts import category_product
import re
import json
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

def preprocessing_image(image_path: str) -> str:
    '''
    Preprocessing image and return ocr_text
    '''
    def _preprocess(image):
        transform = A.Compose([
            A.CLAHE(clip_limit=4, tile_grid_size=(8, 8), p=1),
            A.ToGray(p=1),
            A.Posterize(p=1, always_apply=True, num_bits=8),
            ToTensorV2()
        ])

        augmented = transform(image=image)
        img = augmented['image']
        img = img.permute(1, 2, 0).numpy()
        img = (img * 255).astype(np.uint8)

        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
        img = cv2.morphologyEx(img, cv2.MORPH_CLOSE, kernel)

        return img

    print(image_path)
    image = cv2.imread(image_path)
    print(image)
    preprocessed_image = _preprocess(image)
    reader = easyocr.Reader(['ru'])
    result = reader.readtext(preprocessed_image)

    ocr_text = []
    for (bbox, text, prob) in result:
        ocr_text.append(text)
    ocr_text = ' '.join(ocr_text)

    return ocr_text


def llm_work(ocr_text):
    promt = f"""У тебя есть описание типов продукта, необходимо определить наиболее релевантный
    {category_product}

    Проанализируй следующую маркировку товара:
    {ocr_text}

    Найди и выведи только релевантный код продукта. Напиши Category: и тут номер класса"""

    messages = [
        {"role": "user", "content": promt}
    ]
    device = "cuda"

    model = AutoModelForCausalLM.from_pretrained("mistralai/Mistral-7B-Instruct-v0.2",
                                                torch_dtype=torch.float16,
                                                cache_dir="cache",
                                                load_in_4bit=True,
                                                device_map="auto")
    tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.2")

    encodeds = tokenizer.apply_chat_template(messages, return_tensors="pt")

    model_inputs = encodeds.to(device)

    generated_ids = model.generate(model_inputs, max_new_tokens=300, do_sample=True)
    decoded = tokenizer.batch_decode(generated_ids)

    category_numbers = re.findall('(\d.\d)|\d', decoded[0].split("[/INST]")[1])
    file_path = 'product_reqs.json'

    with open(file_path, 'r', encoding='utf-8') as file:
        data_dict = json.load(file)

    promt_level_two = """
    У тебя есть требования к продукту {data_dict[max(category_numbers)]}
    Необходимо проверить соответствует ли маркировка: {ocr_text} этим требованиям.
    Выведи ответ в формате json:
    { 
    correct_flag - binary (соответствует ли маркировка требованиям)
    comments - str (почему не соответствует требованиям),
    Энергетическая ценность (ккал/100 г),
    Натрий (мг/ 100 ккал)",
    Общий сахар (% Е),
    Добавленные свободные сахара или подсластитель,
    Общий белок (г/100ккал) и вес белка,
    Общее количество жиров (г/100ккал) (без транс-жиров),
    Содержание фруктов (% веса),
    Возрастная маркировка (месяцы),
    Указание высокого содержания сахара на лицевой стороне упаковки (% калорий).
    }
    Если нет информация об пункте напиши NaN
    """

    messages = [
        {"role": "user", "content": promt_level_two}
    ]

    encodeds = tokenizer.apply_chat_template(messages, return_tensors="pt")

    model_inputs = encodeds.to(device)
    # model.to(device)

    generated_ids = model.generate(model_inputs, max_new_tokens=300, do_sample=True)
    decoded = tokenizer.batch_decode(generated_ids)
    result = decoded[0].split("[/INST]")[1]


if __name__ == "__main__":
    txt = preprocessing_image('./data/2.jpg')
    print(txt)
