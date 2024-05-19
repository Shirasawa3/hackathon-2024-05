# hackathon_2024_5_team_b

番場・白澤チーム

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
git clone git@github.com:Funny-Silkie/hackathon_2024_5_team_b.git
cd hackathon_2024_5_team_b
```
**これ以降はリポジトリ内で作業**

### bundle install
```zsh
gem install bundler
bundle install
```
