# Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY app/. .
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "main:app"]
