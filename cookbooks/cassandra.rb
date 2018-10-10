# 必要なパッケージをインストール
package "wget"
package "vim"
package "java-1.8.0-openjdk"

# /etc/hostsファイルを配布する
remote_file "/etc/hosts"

# cassandra-3.11.3ダウンロード
execute "wget http://ftp.tsukuba.wide.ad.jp/software/apache/cassandra/3.11.3/apache-cassandra-3.11.3-bin.tar.gz" do
  not_if "test -e /home/vagrant/apache-cassandra-3.11.3-bin.tar.gz"
end
# tar.gzファイルを解凍
execute "tar xvfz apache-cassandra-3.11.3-bin.tar.gz -C /opt/" do
  not_if "test -d /opt/apache-cassandra-3.11.3"
end
# ディレクトリ権限変更
directory "/opt/apache-cassandra-3.11.3" do
  owner "vagrant"
  group "vagrant"
end
# /opt/casssandraでアクセスできるようにシンボリックリンクを作成
link "/opt/cassandra" do
  to "/opt/apache-cassandra-3.11.3"
end

# 環境変数の設定を追加
remote_file "/etc/profile.d/cassandra.sh"

# Cassandra設定ファイル
# /opt/cassandra/conf/cassandra.yamlを配布
template "/opt/cassandra/conf/cassandra.yaml" do

  # レシピ実行対象のノードのIPアドレスを取得
  self_host = node['hostname']
  listen_address = node['cluster'][self_host]['ip']

  # seedsに設定するIPアドレスを設定
  seeds = node['cluster'].values.map {|v| v['ip']}.join(",")

  # テンプレートcassandra.yaml.rbにパラメータを渡す
  variables(listen_address: listen_address, seeds: seeds)
end
