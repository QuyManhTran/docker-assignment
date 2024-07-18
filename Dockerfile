FROM node:18-alpine3.20 as builder

WORKDIR /app

COPY package*.json /app


RUN npm install -g pnpm

RUN pnpm install

COPY . /app

RUN pnpm run build

COPY .env /app/build

WORKDIR /app/build

RUN pnpm install --prod

FROM node:18-alpine3.20

COPY --from=builder /app/build /app/build

WORKDIR /app/build

CMD [ "node", "bin/server.js" ]



