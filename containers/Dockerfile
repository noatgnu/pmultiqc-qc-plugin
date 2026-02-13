FROM python:3.11-slim

RUN apt-get update && apt-get install -y python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir pmultiqc>=0.0.39 multiqc>=1.15 pandas>=2.0.0 click>=8.0.0 

RUN chmod +x /app/pmultiqc_runner.py
ENV PATH="/app:${PATH}"

LABEL tool="pmultiqc_runner.py"
