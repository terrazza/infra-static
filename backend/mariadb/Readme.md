## docker-compose

### start mysql-server

docker-compose up -d

   1. without any database
   2. without any users
   3. JUST with MYSQL_ROOT_PASSWORD (ARG)

### provide entry point to create databases

docker-compose run {servicename}