FROM node:22
WORKDIR /app

RUN npm install express

COPY index.js .

CMD ["node", "index.js"]
