import os


# El importador de MOV_TICKET puede tardar bastante con archivos de ~190 MB.
# Mantenemos el timeout por debajo del maximo de 15 minutos del edge de Railway.
timeout = int(os.getenv('GUNICORN_TIMEOUT', '600'))
graceful_timeout = int(os.getenv('GUNICORN_GRACEFUL_TIMEOUT', '120'))

