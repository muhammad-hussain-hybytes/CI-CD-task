FROM python:3.9-slim

WORKDIR /app

RUN pip install flask prometheus_client

COPY app.py .

EXPOSE 5000 8000

CMD ["python", "app.py"]