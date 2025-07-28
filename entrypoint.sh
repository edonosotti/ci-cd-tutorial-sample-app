#!/bin/sh

# This script will be executed when the Docker container starts.

# Run Flask database migrations
# Ensure FLASK_APP is set correctly if your app entry point is not app.py
# If your Flask app instance is named 'app' inside an 'app' package (e.g., app/__init__.py),
# you might need FLASK_APP=app or rely on Flask's auto-discovery.
# If your main app file is app.py and the instance is 'app', it should work.
echo "Running database migrations..."
# Check if the 'app' module can be found for Flask CLI (optional but good for debugging)
if ! python -c "import app" &> /dev/null; then
  echo "Error: Could not import 'app' module. Ensure it's in the root or FLASK_APP is set."
  exit 1
fi
flask db upgrade

# Execute the main command passed to the container (e.g., gunicorn)
# This allows you to pass arguments like 'gunicorn app:app -b 0.0.0.0:8080'
# as the CMD in the Dockerfile, and it will be executed here.
exec "$@"
