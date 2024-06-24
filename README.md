# TODO API app, first project using DRF

## Dockerized baseline template for `Django` projects including `Nginx` and `Gunicorn` setup

### Steps for installation and running

Virtual environment

```bash
py -m venv venv
source venv/Scripts/activate
pip install -r requirements.txt
```

Generate django secret key

```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

Edit the `.env` file by adding the new secret key generated and uncomment file from `.gitignore`

Start project using `docker-compose`

```bash
docker-compose up
```

### May the code be with you :)