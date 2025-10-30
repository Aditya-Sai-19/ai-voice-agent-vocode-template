FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libportaudio2 libportaudiocpp0 portaudio19-dev libasound-dev libsndfile1-dev \
    ffmpeg \
 && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /code

# Copy poetry setup files first (for caching)
COPY pyproject.toml poetry.lock ./

# Install poetry and project dependencies
RUN pip install --no-cache-dir --upgrade pip poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev --no-interaction --no-ansi

# Copy the rest of the project
COPY . .

# Ensure necessary directories exist
RUN mkdir -p /code/call_transcripts /code/db

# Expose port
EXPOSE 3000

# Start the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000"]
