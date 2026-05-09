FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=1 \
    UV_LINK_MODE=copy

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv

COPY pyproject.toml uv.lock README.md langgraph.json ./
COPY src ./src
COPY tests ./tests

RUN uv sync --frozen

EXPOSE 2024

CMD ["uv", "run", "langgraph", "dev", "--allow-blocking", "--no-browser", "--host", "0.0.0.0", "--port", "2024", "--server-log-level", "info"]
