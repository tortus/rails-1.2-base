FROM tortus/rails-1.2-passenger-3:latest

ARG TZ="America/New_York"

# Set local timezone to EST at OS-level, since it cannot be done within Rails 1.
# Rails 1 thinks that storing times as UTC is a fancy feature that needs to be
# enabled! With this set, it will think that local time is EST, but
# `config.active_record.default_timezone = :utc` will make it store times in
# UTC in the database.
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    libapache2-mod-php5 && \
  /build/rmagick.sh && \
  /build/postgres.sh && \
  /build/set-tz.sh && \
  apt-get purge -y --auto-remove \
    build-essential && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY php.ini /etc/php5/apache2/php.ini

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

LABEL php="5" rails="1.2.6" passenger="3.2.21" ruby="1.8.7-p375"
