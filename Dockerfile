FROM python:3.8-slim


# Set working directory
RUN mkdir /app
WORKDIR /app

# Set environment variables
# Prevents Python from writing pyc files to disc (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y curl
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt
RUN pip install django-environ

COPY ./src .

EXPOSE 80

CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]

