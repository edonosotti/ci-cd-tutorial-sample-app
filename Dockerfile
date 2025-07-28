FROM ubuntu:18.04

RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq libpq-dev gcc python3.8 python3-pip && \
    apt-get clean

WORKDIR /sample-app

COPY . /sample-app/

# ... (previous lines of your Dockerfile)

RUN pip3 install --no-cache-dir --upgrade pip && \  # Add this line
    pip3 install -r requirements.txt && \
    pip3 install -r requirements-server.txt

# ... (rest of your Dockerfile)

ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"

EXPOSE 8000/tcp

CMD ["/bin/sh", "-c", "flask db upgrade && gunicorn app:app -b 0.0.0.0:8000"]
