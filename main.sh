#!/bin/bash

# このファイルは、Dockerfileで定義された計算環境がすべてセットアップされたあとに実行される、
# 具体的なワークフローの内容を記述されるためのファイルです。
# Dockerfileの最後に記載される "ENTRYPOINT"によって紐付けられています。
#
# このファイルの中では、Dockerfileによってセットアップされたライブラリやパッケージ、
# あるいはDockerfileでダウンロードしてきたリファレンスファイルなどのアセットが利用可能です。

# ためしに、Dockerfileでインストールされたコマンドを使ってみます。
echo "---> bwaコマンドの存在確認します"
bwa 2>&1
echo "---> bwaコマンドが確認されました"
# このファイルの中での標準出力は、ジョブを実行した際のログとして記録されますが、結果ファイルとしては保存されません。

# ユーザに結果ファイルを返したい場合は、
# /var/data/outディレクトリにファイルを配置してください。
echo "---> 結果ファイルのサンプルを作成します"
echo "ハローハロー！これは結果ファイルの例です！" >> ./result-example.txt
mv ./result-example.txt /var/data/out
echo "---> 結果ファイルのサンプルを配置しました"

# pod-interface.yamlにおいて、inputsフィールドで指定されたものは、
# /var/data/in というディレクトリにすでに配置されています。
# ディクショナリ形式のキーを名前とする環境変数に、
# アップロードされたオリジナルファイル名が格納されています。
echo "---> MY_EXAMPLE_FILEとして、${MY_EXAMPLE_FILE}というファイルがアップロードされました"

# もし、エラーが発生したときに、ただちにワークフローを終了させたいときは、
# 適宜、exitしてください。
touch ./message.txt
echo "This is another example of result file, going to dump input file and paste it hereafter." >> ./message.txt
echo "----- START -----" >> ./message.txt
cat /var/data/in/${MY_EXAMPLE_FILE} >> ./message.txt || exit 1
echo "------ END ------" >> ./message.txt
echo `date` >> ./message.txt

echo "MY_GREETINGが追加される"
echo ${MY_GREETING} >> ./message.txt

# pod-interface.yamlにおいて、parametersフィールドで指定されたものは、
# ディクショナリ形式のキーを名前とする環境変数に値が格納されます。
echo "---> MY_SLEEPY_SECONDSに、値 ${MY_SLEEPY_SECONDS} が与えられています"
i=0; while [ ${i} -lt ${MY_SLEEPY_SECONDS} ]; do
  printf "."; i=`expr ${i} + 1`; sleep 1s
done
printf "\n"
# おそらくは、このワークフローの中で実行するコマンドのオプションなどに使われるかと思います。
# parametersフィールドの要素はdefaultが必須なのは、このためです。

# もしユーザに返したい結果ファイルがあれば、
# /var/out というディレクトリにそれを配置してください。
# それ以外の場所に配置されたファイルは、ワークフロー終了時に、
# ジョブ実行ノードが抹殺されるとともに消え去ります。
mv ./message.txt /var/data/out/message-out.txt

# このワークフローはここで終わりです。
# おつかれさまでした！
echo "---> このワークフローはここで終わりです！お疲れ様でした！！"
