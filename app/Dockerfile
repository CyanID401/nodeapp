FROM node:24-alpine3.21

WORKDIR /app

RUN addgroup -S nodeapp \
    && adduser -S nodeapp -G nodeapp

COPY --chown=nodeapp:nodeapp package*.json ./

RUN npm install

USER nodeapp

COPY --chown=nodeapp:nodeapp . .

EXPOSE 3000

CMD ["node", "nodeapp.js"]