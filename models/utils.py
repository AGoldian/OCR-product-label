import cv2
import albumentations as A
from albumentations.pytorch import ToTensorV2
import numpy as np
from PIL import Image
import easyocr

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


if __name__ == "__main__":
    txt = preprocessing_image('./data/2.jpg')
    print(txt)
