# SeqPodで動くpodのサンプル（日本語版）

- [seqpod/hello-world.ja - Docker Hub](https://hub.docker.com/r/seqpod/hello-world.ja/)

# docker cliでのテスト実行

```sh
docker run -it --rm \
  --volume ~/tmp/data:/var/data \
  --volume ~/tmp/out:/var/out \
  -e EXAMPLE_INPUT_FOO=my-example.fastq \
  -e MY_SLEEPY_SECONDS=5 \
  seqpod/hello-world.ja
```

# podtkを使ったテスト実行

```sh
podtk run seqpod/hello-world.ja \
  --satisfy your-data-set.yaml
```
