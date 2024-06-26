# hackathon_2024_5_team_b

番場・白澤チーム

## 制作物の概要
<img width="1447" alt="image" src="https://github.com/Shirasawa3/hackathon-2024-05/assets/156413299/6ae027e5-4503-43b0-808f-8b13db5d0d6c">
ユーザー用画面
<img width="1227" alt="image" src="https://github.com/Shirasawa3/hackathon-2024-05/assets/156413299/554895f9-5998-45d9-af71-49699f225305">
管理者用画面
<img width="1215" alt="image" src="https://github.com/Shirasawa3/hackathon-2024-05/assets/156413299/6c8e8914-e23d-4e4d-b81a-932f2b448294">

## 環境構築

### PostgreSQL
```zsh
# インストール
brew install postgresql

# 起動
brew services start postgresql

# ユーザー作成＆DB作成
createuser hackathon
createdb hackathon-dev -O hackathon
createdb hackathon-test -O hackathon
```

DB `hackathon-dev`, `hackathon-test` の存在を確認
```shellsession
% psql -l
      Name      |   Owner    | Encoding | Collate | Ctype |     Access privileges
----------------+------------+----------+---------+-------+---------------------------
 hackathon-dev  | hackathon  | UTF8     | C       | C     |
 hackathon-test | hackathon  | UTF8     | C       | C     |
```

以下のコマンドで問題なくPostgreSQLに入れたら成功
```zsh
psql -h localhost -p 5432 -U hackathon -d hackathon-dev
psql -h localhost -p 5432 -U hackathon -d hackathon-test
```

デフォルトのユーザーでログイン
```shellsession
# PostgreSQL に入り，ユーザー "hackathon" に DB 作成の権限付与
% psql -U <ユーザー名> -d postgres
postgres=# ALTER ROLE hackathon WITH CREATEDB;
ALTER ROLE
postgres=# exit
# PostgreSQL を再起動
% brew services restart postgresql
```

参考
- https://zenn.dev/eguchi244_dev/articles/sql-postresql-install-20230620#homebrew%E3%81%8B%E3%82%89%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B
- https://qiita.com/Tiger-Kid/items/8cacb8b89a2d201f4cf8

### rbenv

```zh
brew install rbenv ruby-build
rbenv init
echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc
rbenv install 3.2.2
```

### GitHubからclone
```zsh
git clone git@github.com:techouse-inc/hackathon_2024_5_team_b.git
cd hackathon_2024_5_team_b
```
**これ以降はリポジトリ内で作業**

### bundle install
```zsh
gem install bundler
bundle install
```

### DB初期化
```zsh
sh scripts/init_db.zh
```
