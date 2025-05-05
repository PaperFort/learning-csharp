# Makefile for CSharpLearning

.PHONY: help new run build clean delete delete-win

# MAKECMDGOALS の第2ワードをプロジェクト名として取得
PRJ := $(word 2,$(MAKECMDGOALS))
IMAGE_NAME := $(PRJ)-app
PROJECT_DIR := $(PRJ)

# help: コマンド一覧を表示
help: ## コマンド一覧を表示
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile \
		| awk 'BEGIN {FS=":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

# 共通チェック: 第2引数の有無 & 小文字のみチェック
check: ## 第2引数必須 & プロジェクト名は小文字のみ
	@# プロジェクト名が指定されているか
	@test -n "$(PRJ)" || { \
		echo "エラー: プロジェクト名を第2引数で指定してください"; \
		echo "例: make run helloworld"; \
		exit 1; \
	}
	@# 小文字のみか
	@if echo "$(PRJ)" | grep -q '[[:upper:]]'; then \
		echo "エラー: プロジェクト名は小文字のみで指定してください"; \
		exit 1; \
	fi

# new: 新規 C# コンソールプロジェクトを作成
new: check ## 新規 C# コンソールプロジェクトを作成
	docker run --rm \
		-v "$(PWD)":/app \
		-w /app \
		mcr.microsoft.com/dotnet/sdk:8.0 \
		dotnet new console -n $(PRJ)
	cp Dockerfile.template $(PRJ)/Dockerfile

# run: プロジェクトをビルド＆実行
run: check ## プロジェクトをビルド＆実行
	docker build -t $(IMAGE_NAME) ./$(PROJECT_DIR)
	docker run --rm $(IMAGE_NAME)

# build: プロジェクトをビルドのみ
build: check ## プロジェクトをビルドのみ
	docker build -t $(IMAGE_NAME) ./$(PROJECT_DIR)

# clean: Dockerイメージを削除
clean: check ## Dockerイメージを削除
	docker rmi -f $(IMAGE_NAME) || true

# delete: プロジェクトフォルダとイメージを削除（Unix系）
delete: check ## フォルダ＆イメージ削除（Unix）
	@# 存在チェック
	@if [ ! -d "$(PROJECT_DIR)" ]; then \
		echo "エラー: フォルダ '$(PROJECT_DIR)' が存在しません"; \
		exit 1; \
	fi
	docker rmi -f $(IMAGE_NAME) || true
	rm -rf $(PROJECT_DIR)

# delete-win: プロジェクトフォルダとイメージを削除（Windows用）
delete-win: check ## フォルダ＆イメージ削除（Windows）
	@# 存在チェック
	@if [ ! -d "$(PROJECT_DIR)" ]; then \
		echo "エラー: フォルダ '$(PROJECT_DIR)' が存在しません"; \
		exit 1; \
	fi
	docker rmi -f $(IMAGE_NAME) || true
	rm -rf $(PROJECT_DIR)
