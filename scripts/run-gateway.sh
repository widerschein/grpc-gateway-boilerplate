#!/bin/sh

export PORT=9001
export SERVE_HTTP=true

go run ./cmd/standalone/ --server-address dns:///0.0.0.0:50051
