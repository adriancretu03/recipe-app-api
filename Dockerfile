# Set the python version as a build-time argument
# with Python 3.12 as the default
ARG PYTHON_VERSION=3.12-slim-bullseye
FROM python:${PYTHON_VERSION}

# Create a virtual environment
RUN python -m venv /opt/venv

# Set the virtual environment as the current location
ENV PATH=/opt/venv/bin:$PATH

# Upgrade pip
RUN pip install --upgrade pip

# Set environment variables to prevent .pyc files and ensure output is flushed immediately
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install os dependencies
RUN apt-get update && apt-get install -y \
    # for convertinf the script file
    dos2unix \
    # for postgres
    libpq-dev \
    # for Pillow
    libjpeg-dev \
    # for compiling some Python package
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create the mini vm's code directory
RUN mkdir -p /usr/src

# Set the working directory to that same code directory
WORKDIR /usr/src

# Copy the requirements file into the container
COPY requirements.txt /tmp/requirements.txt

# copy the project code into the container's working directory
COPY ./src .

# Install the Python project requirements
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /tmp

# database isn't available during build
# run any other commands that do not need the database
# such as:

# Collect static files
RUN python manage.py collectstatic --no-input

# Copy script file
COPY ./gunicorn_start.sh /usr/local/bin

#  Make the script file executable
RUN chmod +x /usr/local/bin/gunicorn_start.sh

# Convert file from DOS/Windows format (CRLF) to Unix/Linux format (LF).
RUN dos2unix /usr/local/bin/gunicorn_start.sh

# Clean up apt cache to reduce image size
RUN apt-get remove --purge -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r django-group && useradd -r -g django-group django

# Change the ownership of the /code directory to the non-root user
RUN chown -R django:django-group /usr/src

# Switch to the non-root user
USER django

# Expose application ports
EXPOSE ${PORT:-8000}

# Execute script when container run
CMD /usr/local/bin/gunicorn_start.sh
