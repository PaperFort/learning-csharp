FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

# プロジェクトファイルをコピー
COPY . .

# アプリをビルド
RUN dotnet build

# アプリを実行
CMD ["dotnet", "run"]
