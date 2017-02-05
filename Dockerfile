FROM tiangolo/uwsgi-nginx-flask:flask-python3.5

# Remove sample application included in the base image.
RUN rm /app/main.py /app/uwsgi.ini

# Install cron
RUN apt-get update \
    && apt-get install -y cron \
    && rm -rf /var/lib/apt/lists/*

# Install cron job
COPY crontab /etc/cron.d/libc-update
RUN chmod 0644 /etc/cron.d/libc-update
RUN touch /var/log/libcdb.log

# Register cron to supervisor
COPY cron.conf /etc/supervisor/conf.d/cron.conf

COPY app /app
COPY libc-database /libc-database
# nginx.conf of the base image knows only /app/static.
RUN ln -s /app/search/static /app/static
