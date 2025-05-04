# プロジェクト名を指定（使うときに PROJECT=名前 を付ける）
PROJECT ?= HelloWorld
IMAGE_NAME := $(PROJECT)-app
PROJECT_DIR := $(PROJECT)

# ヘルプ表示コマンド（make help で一覧を表示）
help: ## コマンドの一覧を表示する
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

# 新しい C# プロジェクトを作成する（Docker + Dockerfile コピー）
new: ## 新しい C# プロジェクトを作成する
	docker run --rm -v "$(PWD)":/app -w /app mcr.microsoft.com/dotnet/sdk:8.0 dotnet new console -n $(PROJECT)
	cp Dockerfile.template $(PROJECT)/Dockerfile

# プロジェクトをビルドして実行する
run: ## プロジェクトをビルドして実行する
	docker build -t $(IMAGE_NAME) ./$(PROJECT_DIR)
	docker run --rm $(IMAGE_NAME)

# ビルドのみ実行する
build: ## プロジェクトをビルドだけ行う
	docker build -t $(IMAGE_NAME) ./$(PROJECT_DIR)

# Docker イメージを削除する
clean: ## Docker イメージを削除する
	docker rmi -f $(IMAGE_NAME) || true
