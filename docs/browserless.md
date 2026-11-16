# Browserless

Docker内のChromiumを、Mac上のagent-browserから操作します。構成は`ai-agents/browserless/compose.yaml`、セットアップは`scripts/macos/setup-browserless`で管理します。

## 導入と起動

Docker Desktopを起動し、dotfilesのルートで実行します。

```bash
bash scripts/macos/setup-browserless
```

`install.sh`からも実行します。Docker未起動の場合はスキップするため、Dockerを起動して上記を再実行してください。既存の設定ファイルと認証情報を再利用し、他のCDP接続設定がある場合は上書きせず停止します。

- Browserless: `127.0.0.1:3333`（Macのループバックのみ公開）
- イメージ: `ghcr.io/browserless/chromium:v2.63.1`（固定。自動更新しない）
- トークン: `${XDG_CONFIG_HOME:-~/.config}/browserless/browserless.env`
- agent-browser接続設定: `~/.agent-browser/config.json`

認証情報を含む2つのファイルは権限600で保存します。Gitやチャットへ貼り付けないでください。`docker compose config`や`docker inspect`の全出力にも認証情報が含まれるため、共有しないでください。

## ブラウザ操作

通常のagent-browserコマンドでBrowserlessへ接続します。セッション名はタスクごとに一意にします。

```bash
agent-browser --session my-task-unique open http://host.docker.internal:3000
agent-browser --session my-task-unique snapshot -i
agent-browser --session my-task-unique close
```

コンテナ内の`localhost`はMacではありません。Macの開発サービスは`host.docker.internal`で指定します。アプリが`localhost`を前提とする認証・CORS・Cookie・リダイレクトや、ループバックだけの待ち受けでは調整が必要な場合があります。設定を無断で緩めず、アプリごとに接続方法を確認してください。

接続に失敗してもローカルChromeへ切り替えません。Browserlessが稼働しているか確認し、必要ならセットアップを再実行します。`--cdp`・`--config`・環境変数などで接続設定を上書きする操作は、隔離を保証するものではありません。

## スクリーンショット・録画

スクリーンショットはagent-browserの`screenshot`、操作の録画は`record start ./demo.webm`と`record stop`を使います。いずれも操作中の一意な`--session`を指定します。

録画にはMac側のffmpegを使います。ffmpegはBrewfileで管理し、Homebrewで導入します。録画したWebMはffmpegでGIFへ変換できます。画像・動画の保存先はMac側です。

## 停止・再開

```bash
docker compose -f ai-agents/browserless/compose.yaml stop
docker compose -f ai-agents/browserless/compose.yaml up -d --wait
```

PC起動時の自動起動は設定しません。Browserlessは停止するまで稼働し、各ブラウザ接続は最大15分で終了します。ブラウザ操作が済んだら自分のagent-browserセッションを閉じます。認証状態やブラウザデータの永続化用ボリュームは設定していません。

## 隔離範囲

- Macのホームディレクトリ、個人Chrome、Docker制御ソケットはコンテナへ共有しません。
- コンテナの追加権限を落とし、権限昇格を禁止します。CPU・メモリにも上限を設定します。
- 隔離されるのはBrowserless / Chromiumです。Mac上のAI CLI・agent-browser自体は隔離しません。
- 必要な外部APIやCDNの利用を許容するため、通信先の許可リストは設定しません。Macのサービスや外部サービスへのネットワーク接続、誤送信、アプリ側の本番データ操作は、このコンテナ構成では遮断しません。
- Docker DesktopのLinux VMとコンテナによる隔離であり、脆弱性や設定不備も含めて絶対的な安全性を保証するものではありません。

## 更新

リリース内容と公開後の経過期間を確認してから、Composeのイメージタグを変更し、セットアップを再実行します。`latest`への追従や定期的な自動更新は行いません。

公式資料: [Docker版](https://docs.browserless.io/enterprise/open-source)、[agent-browserのCDP接続](https://agent-browser.dev/cdp-mode)。
