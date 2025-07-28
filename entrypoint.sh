#!/bin/sh

echo "Starting entrypoint script..."

# Set FLASK_APP to 'app' (the package name).
# This is crucial for Flask CLI commands and Gunicorn to find your application instance.
export FLASK_APP=app

echo "Running database migrations..."
# Execute migrations. Redirecting stderr to stdout (2>&1) ensures errors are logged to Cloud Logging.
# The 'set -e' (often implied by shebang or default shell behavior) will cause the script to exit
# immediately if 'flask db upgrade' fails, which is desired for failed deployments.
if flask db upgrade 2>&1; then
  echo "Database migrations completed successfully."
else
  echo "ERROR: Database migrations failed!"
  # Exit with a non-zero status to indicate failure to Cloud Run.
  exit 1
fi

echo "Starting Gunicorn server..."
# Cloud Run injects the PORT environment variable (defaulting to 8080).
# Ensure Gunicorn binds to 0.0.0.0 and uses this PORT variable.
# The ${PORT:-8080} syntax provides a fallback to 8080 if PORT isn't set (e.g., for local testing).
exec gunicorn app:app -b 0.0.0.0:${PORT:-8080}
