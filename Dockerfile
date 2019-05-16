FROM tortus/rails-1.2-passenger-3:latest

ARG TZ="America/New_York"

COPY bin/setuser /bin/setuser

# Set local timezone to EST at OS-level, since it cannot be done within Rails 1.
# Rails 1 thinks that storing times as UTC is a fancy feature that needs to be
# enabled! With this set, it will think that local time is EST, but
# `config.active_record.default_timezone = :utc` will make it store times in
# UTC in the database.
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  a2dismod mpm_event && \
  a2enmod mpm_prefork && \
  apt-get install -y --no-install-recommends \
    build-essential \
    dnsutils \
    imagemagick \
    libapache2-mod-php5 \
    libmagickwand-6.q16-2 \
    libmagickwand-6.q16-dev \
    libpq5 \
    libpq-dev \
    php5 \
    postgresql-client \
    python3 && \
  gem install postgres --no-ri --no-rdoc -v 0.7.9.2008.01.28 && \
  gem install rmagick --no-ri --no-rdoc -v 2.15.4 && \
  ln -sv /opt/rubies/1.8.7-p375 /opt/rubies/ruby-1.8.7-p375 && \
  echo ${TZ} > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
  apt-get purge -y --auto-remove \
    build-essential \
    libmagickwand-6.q16-dev \
    libpq-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY php.ini /etc/php5/apache2/php.ini
COPY on-server-start/*.sh /etc/on-server-start/

ENV MIGRATE="false"

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

LABEL php="5" rails="1.2.6" passenger="3.2.21" ruby="1.8.7-p375"
