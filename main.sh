#!/bin/bash

cat << EOS
# このファイルは、Dockerfileで定義された計算環境がすべてセットアップされたあとに実行される、
# 具体的なワークフローの内容を記述されるためのファイルです。
# Dockerfileの最後に記載される "ENTRYPOINT"によって紐付けられています。
#
# このファイルの中では、Dockerfileによってセットアップされたライブラリやパッケージ、
# あるいはDockerfileでダウンロードしてきたリファレンスファイルなどのアセットが利用可能です。
#
# ためしに、Dockerfileでインストールされたコマンドを使ってみます。
EOS

printf "[bwaコマンドの存在確認します]"
bwa 2>&1
printf "[bwaコマンドが確認されました]\n\n"

cat << EOS
# pod-interface.yamlにおいて、inputsフィールドで指定されたものは、
# /var/data というディレクトリに配置され、
# ディクショナリ形式のキーを名前とする環境変数に、
# アップロードされたオリジナルファイル名が格納されています。
EOS
touch ./message.txt
echo "EXAMPLE_FOOとして、${EXAMPLE_FOO}というファイルがアップロードされました。" >> ./message.txt
printf "\n"

cat << EOS
# pod-interface.yamlにおいて、parametersフィールドで指定されたものは、
# ディクショナリ形式のキーを名前とする環境変数に値が格納されます。
EOS
echo "MY_SLEEPY_SECONDS: ${MY_SLEEPY_SECONDS} が与えられています。"
i=0; while [ ${i} -lt ${MY_SLEEPY_SECONDS} ]; do
  printf "."
  i=`expr ${i} + 1`
  sleep 1s
done
printf "\n"

cat << EOS
# もし、エラーが発生したときに、ただちにワークフローを終了させたいときは、
# 適宜、exitしてください。
EOS
echo "---" >> ./message.txt
cat /var/data/${EXAMPLE_FOO} >> ./message.txt || exit 1
echo "---" >> ./message.txt
echo `date` >> ./message.txt
printf "\n"

cat << EOS
# もしユーザに返したい結果ファイルがあれば、
# /var/out というディレクトリにそれを配置してください。
# それ以外の場所に配置されたファイルは、ワークフロー終了時に、
# ジョブ実行ノードが抹殺されるとともに消え去ります。
EOS
mv ./message.txt /var/out
printf "\n"

cat << EOS
# このワークフローはここで終わりです。
# おつかれさまでした！
EOS
