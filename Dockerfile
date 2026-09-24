FROM node:20-bookworm-slim AS build

WORKDIR /build

COPY package.json package-lock.json ./
RUN npm ci

COPY src ./src
RUN npm run build

FROM public.ecr.aws/lambda/nodejs:20

COPY --from=build /build/dist ${LAMBDA_TASK_ROOT}/dist

CMD ["dist/handler.handler"]
