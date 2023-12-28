#!/bin/sh

export PYTHONPATH="$(realpath ./gen/python)"

. ./server/venv/bin/activate
pip install -r ./server/requirements.txt

python ./server/server.py 50051
