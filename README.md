# vagrant-phpenv-phpbuild

Vagrant / Chef files for PHP Server(phpenv and phpbuild, nginx)

phpenv + php-build 環境を CentOS6.4 上に構築します。デフォルトでは PHP5.3 / PHP5.4 / PHP5.5 が入ります。

nginx + php-fpm を別ポートで起動させるので、同じ PHP ファイルを、それぞれの PHP 上で動作させることができます。

## インストール方法

### 1. <a href="https://www.virtualbox.org/">VirtualBox</a> インストール

  最新版（4.2.16 以降）を利用して下さい。（ 4.2.14 は Vagrant からの起動で問題が発生する場合があります。）

  <a href="https://www.virtualbox.org/wiki/Downloads">Downloads – Oracle VM VirtualBox</a>

### 2. <a href="http://www.vagrantup.com/">Vagrant</a> インストール

  Vagrant を下記サイトからダウンロードして、インストールします。

  <a href="http://downloads.vagrantup.com/">Vagrant - Downloads</a>

### 3. git clone

  このリポジトリを git clone します。
  
    $ git clone https://github.com/shin1x1/vagrant-phpenv-phpbuild

### 4. vagrant up

  vagrant up を実行します。

    $ cd vagrant-phpenv-phpbuild
    $ vagrant up

  デフォルトでは PHP5.3, PHP5.4, PHP5.5 がインストールされます。（インストールには時間がかかるのでコーヒーで一服して下さい:D）

### 5. インストールできたか確認

  ブラウザでインストールした仮想サーバにアクセスします。
  接続ポート毎に異なる php-fpm へアクセスすることができます。

  * http://192.168.33.14:8053/ にアクセスすると PHP5.3（php-fpm は 9053）
  * http://192.168.33.14:8054/ にアクセスすると PHP5.4（php-fpm は 9054）
  * http://192.168.33.14:8055/ にアクセスすると PHP5.5（php-fpm は 9055）

### 6. docroot

  nginx のドキュメントルートは public_html/ に設定しています。
  このディレクトリにコンテンツを設置すると仮想サーバ経由で実行することができます。

## カスタマイズ

### 1. インストールする PHP バージョンを変更

  Vagrantfile を編集すれば、インストールする PHP バージョンを変更することができます。
 
  :php でインストールする PHP バージョンを指定します。
  
  :php_global_version では、インストールした PHP のうち、どのバージョンを global で有効にするか指定します。（シェル上で php コマンドを実行した際に当該バージョンが有効になります。）

  ```

    chef.json = {
      :php_global_version => "5.5.8",
      :php_configure_options => "",
      :php => [
        {
          :version => "5.3.28",
          :ini_file => "53",
          :fpm_port => "9053",
          :http_port => "8053"
        },
        {
          :version => "5.4.24",
          :ini_file => "54",
          :fpm_port => "9054",
          :http_port => "8054"
        },
        {
          :version => "5.5.8",
          :ini_file => "55",
          :fpm_port => "9055",
          :http_port => "8055"
        }
      ]
    }

  ```

### 2. configure オプション追加

  :php_configure_options にて configure オプションを追加することが可能です。ただし追加オプションに依存するライブラリは自動ではインストールされないので、必要であれば別途インストールして下さい。

