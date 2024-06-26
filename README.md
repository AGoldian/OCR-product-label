# **Оценка маркировки и маркетинга продуктов детского питания**

Интуитивно понятное мобильное приложение для проверки соответствия маркировки товаров детского питания критериям ВОЗ.

В котором реализован функционал снимка продукта в реальном времени, либо загрузки изображения. Для его последующего анализа с помощью технологий машинного обучения. Применяем передовые технологии OCR и LLM, позволяющие добиться высокой точности.

Решение построена на основе клиент-серверной архитектуры, что обеспечивает легкое масштабирование и возможность увеличения отказоустойчивости приложения.

Помимо проверки маркировки, мы предлагаем подробные комментарии о критериях несоответствия и аналитический дашборд с историей.

Архитектура мобильного приложения и API предусматривает расширение списка доступных вариантов проверок. Все обрабатываемые файлы сохраняются на сервере для последующего отслеживания в системе "Честный знак".

# Локальное развертывание
Клонируем репозиторий
- `git clone https://github.com/AGoldian/OCR-product-label`

<a href="https://docs.flutter.dev/get-started/install">Устанавливаем Flutter</a>

Создаем виртуальное окружение и запускаем сервер
```bash
pip install virtualenv
source /usr/bin/python3
cd rest_api
python3 -m uvicorn main:app --reload
```

Собираем и запускаем Flutter-приложение:
```bash
cd mobile_client
flutter pub get
flutter run
```

# Скриншоты

<div class="row">
    <img src="https://raw.githubusercontent.com/AGoldian/OCR-product-label/safe-commit/screenshots/empty_main.jpg" height="120"/>
    <img src="https://raw.githubusercontent.com/AGoldian/OCR-product-label/safe-commit/screenshots/add_image.jpg" height="120"/>
    <img src="https://raw.githubusercontent.com/AGoldian/OCR-product-label/safe-commit/screenshots/items_list.jpg" height="120"/>
</div>
