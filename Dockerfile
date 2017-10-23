# このDockerfileでは、ワークフロー（SeqPodでは「pod」と呼びます）が必要とする
# ライブラリ、パッケージ、あるいはリファレンスファイル、アノテーションデータベースなどを
# ダウンロード・インストールすることができます。
#
# Dockerfileの具体亭な記述方法は、
# 公式ドキュメント
# https://docs.docker.com/engine/reference/builder/
# を参照してください。

# ここでは、一例としてDebianの最新版をベースOSイメージとして使います。
# ワークフローの再現性の観点から、本来は、OSイメージもリリースバージョンを明示すべきです。
# 例）
# FROM: debian:stretch-20171009
FROM debian:latest

# 僕が書きました
LABEL maintainer "Hiromu Ochiai <otiai10@hgc.jp>"

# ベースOSイメージとしてDebianを使用しているので、aptを使うことができます。
# RedHatをベースイメージとするなら、もちろんyumを使うことになります。あなた次第です。
RUN apt-get update

# aptやyumなどのパッケージマネージャでインストールできるツールであれば、
# 別段、makeなどせずに済むんですけどね。
RUN apt-get install -y \
    gcc \
    make \
    git \
    zlib1g-dev

# ここでは一例として、BWA http://bio-bwa.sourceforge.net/ をインストールしています。
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    make && chmod +x ./bwa && \
    cp ./bwa /bin/bwa

# 以上で、依存パッケージのインストールなどの計算環境のセットアップは終了です。
# 最後に、具体的に実行するワークフローの内容を記述したスクリプトを配置し、キックします。
ADD ./main.sh /
ENTRYPOINT /main.sh
# このスクリプトはshellで書かれている必要はありませんが、
# たとえばPythonで書きたい場合は、Pythonを含むベースイメージを使うか、
# このDockerfile内でPython自体（やpipパッケージなど必要なもの）をインストールする必要があります。
