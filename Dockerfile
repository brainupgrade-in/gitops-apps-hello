FROM golang:1.19.2 as builder
WORKDIR /app
RUN go mod init hello
COPY src/*.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /hello

FROM gcr.io/distroless/base-debian11
ARG BUILD_ID=BUILD_ID
ARG GIT_COMMIT_ID=COMMIT_ID
WORKDIR /
COPY --from=builder /hello /hello
ENV PORT 8080
ENV ENVIRONMENT e2e
ENV BUILD_ID ${BUILD_ID}
ENV GIT_COMMIT_ID ${GIT_COMMIT_ID}
USER nonroot:nonroot
CMD ["/hello"]