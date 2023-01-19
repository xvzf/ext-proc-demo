## Multistage build
FROM golang:1.19-alpine as build
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR /src
# copy go.mod and go.sum
COPY go.mod go.sum ./
RUN go mod download

COPY main.go ./
RUN go build -o /ext-proc

## Multistage deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /
COPY --from=build /ext-proc /ext-proc

ENTRYPOINT ["/ext-proc"]
