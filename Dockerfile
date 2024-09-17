
# Stage 1: Build the Next.js app
FROM node:22-alpine3.19  AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install -g pnpm
RUN npm install --force

COPY . .

RUN npm run build

# Stage 2: Serve the Next.js app
FROM node:22-alpine3.19 

WORKDIR /app

COPY --from=builder /app/package.json /app/package-lock.json ./
RUN npm install --force --only=production

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["npm", "start"]