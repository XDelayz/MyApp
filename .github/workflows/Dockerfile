# Используйте базовый образ Python
FROM python:3.9

# Установите рабочую директорию внутри контейнера
WORKDIR /app

# Скопируйте файлы зависимостей в контейнер
COPY requirements.txt .

# Установите зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Скопируйте код приложения в контейнер
COPY . .

# Set the Flask environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# Expose the desired port (optional)
EXPOSE 5000

# Start the Flask application
CMD ["flask", "run"]
