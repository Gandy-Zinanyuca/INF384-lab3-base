FROM node:20-bookworm-slim AS build

WORKDIR /build

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY src ./src

FROM public.ecr.aws/lambda/nodejs:20

COPY --from=build /build/node_modules ${LAMBDA_TASK_ROOT}/node_modules
COPY --from=build /build/src ${LAMBDA_TASK_ROOT}/src

CMD ["src/handler.handler"]
