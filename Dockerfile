# Use the official lightweight Python image.
FROM python:3.11-slim

# Set environment variables for Python in Docker
# Prevents Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Ensures Python output is sent immediately to the terminal
ENV PYTHONUNBUFFERED=1
# Add /app to PYTHONPATH so Python can find your 'app' package
ENV PYTHONPATH=/app:$PYTHONPATH

# Set the working directory inside the container
WORKDIR /app

# Expose port 8080. Cloud Run typically expects services to listen on this port.
EXPOSE 8080

# Install dependencies
# Copy requirements files first to leverage Docker's caching.
COPY requirements.txt .
COPY requirements-server.txt . 

# Install Python dependencies.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install -r requirements.txt && \
    pip install -r requirements-server.txt

# Copy the rest of your application code into the container
COPY . .

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# The CMD provides default arguments to the ENTRYPOINT script.
# Since Gunicorn is started by entrypoint.sh, this can be empty or used for further arguments.
CMD []
