import cv2
import albumentations as A
from albumentations.pytorch import ToTensorV2
import numpy as np
from PIL import Image
import easyocr
from models.dicts import category_product
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
    file_path = 'models/product_reqs.json'

    with open(file_path, 'r', encoding='utf-8') as file:
        data_dict = json.load(file)

    promt_flag_value = """
    У тебя есть требования к продукту {data_dict[max(category_numbers)]}
    Необходимо проверить соответствует ли маркировка: {ocr_text} этим требованиям.
    Выведи бинарный ответ 0 или 1.
    """

    promt_comments_value =  """
    У тебя есть требования к продукту {data_dict[max(category_numbers)]}
    Необходимо проверить соответствует ли маркировка: {ocr_text} этим требованиям и напиши комментарий: совпадает или нет."""

    messages_1 = [
        {"role": "user", "content": promt_flag_value}
    ]
    messages_2 = [
        {"role": "user", "content": promt_comments_value}
    ]

    encodeds_1 = tokenizer.apply_chat_template(messages_1, return_tensors="pt")
    encodeds_2 = tokenizer.apply_chat_template(messages_2, return_tensors="pt")

    model_inputs_1 = encodeds_1.to(device)
    model_inputs_2 = encodeds_2.to(device)

    generated_ids_1 = model.generate(model_inputs_1, max_new_tokens=10, do_sample=True)
    generated_ids_2 = model.generate(model_inputs_2, max_new_tokens=250, do_sample=True)
    decoded_1 = tokenizer.batch_decode(generated_ids_1)
    decoded_2 = tokenizer.batch_decode(generated_ids_2)

    result_1 = decoded_1[0].split("[/INST]")[1]
    result_2 = decoded_2[0].split("[/INST]")[1]

    if ('1' in result_1) or ("True" in result_1):
       result_1 = True 
    else:
       result_1 = False
    # json_result = json.dumps({"correct_flag": result_1, "comments": result_2}, ensure_ascii=False)
    return {"correct_flag": result_1, "comments": result_2}


if __name__ == "__main__":
    txt = preprocessing_image('./data/2.jpg')
    print(txt)
