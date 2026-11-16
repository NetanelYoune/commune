
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
COPY apps/realtime/package.json ./apps/realtime/
COPY packages/shared/package.json ./packages/shared/
COPY tsconfig.base.json ./

RUN npm install --workspace @commune/shared --workspace @commune/realtime --include-workspace-root

COPY packages/shared ./packages/shared
COPY apps/realtime ./apps/realtime

RUN npm run build -w @commune/realtime


FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/apps/realtime/package.json ./apps/realtime/
COPY --from=builder /app/apps/realtime/dist ./apps/realtime/dist

USER node

EXPOSE 4100

CMD ["node", "apps/realtime/dist/index.js"]
