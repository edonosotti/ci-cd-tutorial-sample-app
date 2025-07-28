# Use the official lightweight Python image.
# python:3.11-slim is a great choice for smaller image sizes.
FROM python:3.11-slim

# Set environment variables for Python in Docker
# PYTHONDONTWRITEBYTECODE prevents Python from writing .pyc files to disk, reducing image size.
# PYTHONUNBUFFERED ensures that Python output is sent straight to the terminal without buffering.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container to /app.
# This is where your application code will reside.
WORKDIR /app

# Expose port 8080. Cloud Run typically expects services to listen on this port.
EXPOSE 8080

# Install dependencies
# Copy requirements files first to leverage Docker's caching.
# If these files don't change, Docker can use a cached layer for dependency installation, speeding up builds.
COPY requirements.txt .
# Assuming you still have/need requirements-server.txt for Gunicorn or other server-specific tools.
COPY requirements-server.txt .

# Install Python dependencies.
# `pip install --no-cache-dir --upgrade pip` ensures pip is up-to-date and avoids storing temporary cache files.
# `pip install -r ...` reads and installs packages listed in your requirements files.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install -r requirements.txt && \
    pip install -r requirements-server.txt

# Copy the rest of your application code into the container.
# This should be done after installing dependencies to maximize cache hits.
COPY . .

# Copy the entrypoint script into the container and make it executable.
# This script will be run first when the container starts.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script.
# This ensures that `flask db upgrade` runs first, then the command defined in CMD.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Define the default command to run the Flask application using Gunicorn.
# 'app:app' assumes your Flask application instance is named 'app' within the 'app' module/package.
# '-b 0.0.0.0:8080' binds Gunicorn to all network interfaces on port 8080, matching the EXPOSE instruction.
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8080"]
