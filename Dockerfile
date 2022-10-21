# cat Dockerfile
FROM mysql:latest


RUN chown -R mysql:root /var/lib/mysql/

ARG MYSQL_DATABASE=localhost
ARG MYSQL_USER=sqlroot
ARG MYSQL_PASSWORD=root
ARG MYSQL_ROOT_PASSWORD=root

ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD
ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

ADD ./database.sql database.sql

RUN sed -i 's/MYSQL_DATABASE/'$MYSQL_DATABASE'/g' ./database.sql
RUN cp ./database.sql /docker-entrypoint-initdb.d

EXPOSE 3306



FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 12345
RUN chown -R node /usr/src/app
USER node
CMD ["node", "server.js"]
