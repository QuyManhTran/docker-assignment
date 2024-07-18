# FROM node:18-alpine3.20 as builder

# WORKDIR /app

# COPY package*.json /app

# RUN npm install -g pnpm

# RUN pnpm install

# COPY . /app

# RUN pnpm run build

# COPY .env /app/build

# WORKDIR /app/build

# RUN pnpm install --prod

# FROM node:18-alpine3.20

# COPY --from=builder /app/build /app/build

# WORKDIR /app/build

# CMD [ "node", "bin/server.js" ]

# -----------------------------------------AFFTER REFACTORING----------------------------------------- #


# Base stage
FROM node:18-alpine3.20 as base

RUN npm install -g pnpm

# All dependencies stage
FROM base as all-deps

WORKDIR /app

COPY package*.json /app

RUN pnpm install


# Production dependencies stage
FROM base as prod-deps

WORKDIR /app

COPY package*.json /app

RUN pnpm install --prod

# Build stage
FROM base as build

WORKDIR /app

COPY --from=all-deps /app/node_modules /app/node_modules

COPY . .

RUN pnpm run build

# Release stage
FROM base as release

WORKDIR /app

COPY --from=build /app/build /app

COPY --from=prod-deps /app/node_modules /app/node_modules

COPY .env /app

ENV NODE_ENV=production

CMD [ "node", "bin/server.js" ]



