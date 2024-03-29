#!/bin/bash

if [ ! -d "/var/lib/mysql/${MYSQL_PATH}" ]; then
    mysql_install_db > /dev/null
    temp=`mktemp`
    cat << EOF > $temp

FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DB};
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* to '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    mysqld --bootstrap < $temp && rm $temp
else
    echo "Mariadb Database is already installed"
fi

mysqld --console
