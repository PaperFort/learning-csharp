# プロジェクト名（必ず小文字のみで指定）
PROJECT ?= helloworld
IMAGE_NAME := $(PROJECT)-app
PROJECT_DIR := $(PROJECT)

# ヘルプ表示
help: ## コマンドの一覧を表示する
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

# 小文字チェック関数
check-lowercase:
	@if echo "$(PROJECT)" | grep '[A-Z]' >/dev/null; then \
		echo "エラー: PROJECT 名には小文字のみを使用してください（例: helloworld）"; \
		exit 1; \
	fi

new: check-lowercase ## 新しい C# プロジェクトを作成する
	docker run --rm -v "$(PWD)":/app -w /app mcr.microsoft.com/dotnet/sdk:8.0 \
		dotnet new console -n $(PROJECT)
	cp Dockerfile.template $(PROJECT)/Dockerfile

run: check-lowercase ## プロジェクトをビルドして実行する
	docker build -t $(IMAGE_NAME) ./$(PROJECT_DIR)
	docker run --rm $(IMAGE_NAME)

build: check-lowercase ## プロジェクトをビルドだけ行う
	docker build -t $(IMAGE_NAME) ./$(PROJECT_DIR)

clean: check-lowercase ## Docker イメージを削除する
	docker rmi -f $(IMAGE_NAME) || true
