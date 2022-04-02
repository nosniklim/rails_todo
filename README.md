## アプリケーション概要
ToDoリスト管理ツール

<img src="./app/assets/images/sample.png" width="400">

## URL
https://nosniklim-rails-todo.herokuapp.com/

### ゲスト用アカウント
```
Name: Guest
Password: guest#1
```
お気軽にご利用ください。ただし、デモ環境として公開しているため、ご入力頂いたデータやアカウントは定期的にリセットさせて頂きますので予めご了承ください。

## 使用技術
* Ruby 2.6.3
* Ruby on Rails 6.1.4
* Nginx
* Puma
* Heroku
  * Heroku Postgres
  * Heroku Scheduler


## 機能一覧
* ユーザー登録、ログイン機能（devise）
* リスト作成機能
  * 新規作成、更新、削除、並べ替え
* タスクカード作成機能
  * 新規作成、更新、削除、並べ替え


### ER図
<img src="./app/assets/images/er_diagram.png" width="400">


### テスト
* リストとタスクカードの並べ替え機能に関するUnitテスト（Minitest）
```
$ rails test
```


### 今後の予定
* Vue.jsによるSPA化
* RSpec導入
* CI/CD環境構築


