BUF_VERSION:=v1.17.0
SWAGGER_UI_VERSION:=v4.15.5

init:
	test -d ./server/venv || python -m venv ./server/venv
	./server/venv/bin/python -m pip install -r ./server/requirements.txt

generate: generate/proto generate/swagger-ui
generate/proto:
	go run github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION) generate --template buf.gen.go.yaml
	go run github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION) generate --template buf.gen.python.yaml --include-imports
generate/swagger-ui:
	SWAGGER_UI_VERSION=$(SWAGGER_UI_VERSION) ./scripts/generate-swagger-ui.sh

lint:
	go run github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION) lint
	go run github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION) breaking --against 'https://github.com/johanbrandhorst/grpc-gateway-boilerplate.git#branch=main'
