FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Dependências de sistema necessárias para dbt-postgres (libpq) e build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1) Copie apenas requirements primeiro para maximizar cache
COPY requirements.txt /app/requirements.txt

# 2) Instale as dependências Python
# (dbt e o adapter devem estar no requirements.txt)
RUN pip install --upgrade pip \
 && pip install -r requirements.txt

EXPOSE 8081

# 3) Agora copie o código do projeto
COPY . /app

