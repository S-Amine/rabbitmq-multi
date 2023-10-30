FROM rabbitmq:3.12.0-rc.1-management

COPY create_users.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_users.sh

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget

# Download wait-for-it script
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it.sh
