[![Build Status](https://travis-ci.org/edonosotti/ci-cd-tutorial-sample-app.svg?branch=master)](https://travis-ci.org/edonosotti/ci-cd-tutorial-sample-app)
[![codebeat badge](https://codebeat.co/badges/0e006c74-a2f9-4f34-9cf4-2378fb7d995a)](https://codebeat.co/projects/github-com-edonosotti-ci-cd-tutorial-sample-app-master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e14a2647843de209fd5e/maintainability)](https://codeclimate.com/github/edonosotti/ci-cd-tutorial-sample-app/maintainability)

# CD/CI Tutorial Sample Application

## Description

This sample Python REST API application was written for a tutorial on implementing Continuous Integration and Delivery pipelines.

It demonstrates how to:

 * Write a basic REST API using the [Flask](http://flask.pocoo.org) microframework
 * Basic database operations and migrations using the Flask wrappers around [Alembic](https://bitbucket.org/zzzeek/alembic) and [SQLAlchemy](https://www.sqlalchemy.org)
 * Write automated unit tests with [unittest](https://docs.python.org/2/library/unittest.html)

## Requirements

 * `Python 3.6`
 * `pip`
 * `virtualenv`

## Installation

Run:

```sh
$ pip install -r requirements.txt
$ python -m venv venv
$ source venv/bin/activate
```

Optional: set the `DATABASE_URL` environment variable to a valid SQLAlchemy connection string. Otherwise, a local SQLite database will be created.

Initalize and seed the database:

```sh
$ flask db upgrade
$ python seed.py
```

## Running tests

Run:

```sh
$ python -m unittest discover
```

## Running the application

### Running locally

Run the application using the built-in Flask server:

```sh
$ flask run
```

### Running on a production server

Run the application using `gunicorn`:

```sh
$ gunicorn app:app
```

## Deploying to Heroku

Run:

```sh
$ heroku create
$ git push heroku master
$ heroku run flask db upgrade
$ heroku run python seed.py
$ heroku open
```

or use the automated deploy feature:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

For more information about using Python on Heroku, see these Dev Center articles:

 - [Python on Heroku](https://devcenter.heroku.com/categories/python)
