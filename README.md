# play-evolutions-sample

## 動作環境
- OS OSX
- Play Framework 2.5.10(Java)
- JDK 1.8.0
- MySQL 5.7.18
- IntelliJ IDEA

## Evolutionsとは
EvolustionsとはPlay FrameworkのDBマイグレーションツール。
複数の開発者の間でDBスキーマを簡単に更新し共有することができます。

## 導入背景
ローカルでの開発においては複数の開発者がそれぞれのDBを使ってカラムやテーブルの追加をしていました。ソースコードは同じものをつかっているのに、DBスキーマはそれぞれのものだったので度々手動で更新しなければいけませんでした。DBスキーマを複数の開発者の間で一致させることがEvolutionsを使うことによって簡単になります。

## Evolutionsの使い方

### Evolutionsのセットアップ

#### build.sbtの依存ライブラリリストに`evolutions`を追加

```build.sbt
name := """play-evolutions-sample"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayJava)

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
  "mysql" % "mysql-connector-java" % "5.1.38",
  javaJdbc,
  cache,
  javaWs,
  evolutions
)
```

[![https://gyazo.com/c2fb3c3cd5e366c8b9e0e604334dfc26](https://i.gyazo.com/c2fb3c3cd5e366c8b9e0e604334dfc26.png)](https://gyazo.com/c2fb3c3cd5e366c8b9e0e604334dfc26)
右上のRefresh projectをクリック

#### application.confでの設定を確認

デフォルトではコメントアウトされていますが、念のためfalseになっていないことを確認

```application.conf
play.evolutions {
  # You can disable evolutions for a specific datasource if necessary
  #db.default.enabled = false
}
```
または明示的に`db.default.enabled = true`と記述する

### Evolution Scriptの記述
ディレクトリを作成します
`$ mkdir -p conf/evolutions/default`
`conf/evolutions/default`配下にデータベースを変更するSQLファイルを作成し記述していきます

UpsとDownsの2つのパートからなり記述する内容は以下の通りです

```
# --- !Ups

必要なスキーマの変換方法の記述(SQL文)


# --- !Downs

上記の変換をもとに戻す方法の記述(SQL文)
```




dummyテーブルを新たに追加したい場合

```1.sql
# --- !Ups
create table dummy(
    id integer not null,
    name varchar(255),
    created_at datetime not null,
    updated_at datetime not null
);

# --- !Downs
drop table dummy
```

dummyテーブルにカラムを追加したい場合

```2.sql
# --- !Ups
ALTER TABLE dummy ADD(
    deleted_at datetime not null
);

# --- !Downs
ALTER TABLE dummy DROP(
    deleted_at
);
```
#### ファイル名について
最初のスクリプトは 1.sql、2番目のスクリプトは 2.sql、…というようにファイル名をつけていきます。

#### 実行について
`$ activator run`でローカルで走らせて`http://localhost:9000/`へ飛びます
`Apply this script now!`というボタンを押すと記述したEvolution Scriptが実行されます
[![https://gyazo.com/ad537b57cd684f733522cfe19addce03](https://i.gyazo.com/ad537b57cd684f733522cfe19addce03.png)](https://gyazo.com/ad537b57cd684f733522cfe19addce03)

#### Downsについて
Downsは手動では実行されず、Upsの内容が変更された際に実行されます。Downsが実行されてからUpsが実行されるため結果としてデータベースのスキーマが更新されることになります。

## 参考文献
[Evolutions  - 2.1.x](https://www.playframework.com/documentation/ja/2.1.x/Evolutions)