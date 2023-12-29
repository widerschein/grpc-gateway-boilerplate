#!/bin/sh

export PYTHONPATH="$(realpath ./gen/python)"

./server/venv/bin/python ./server/server.py 50051
