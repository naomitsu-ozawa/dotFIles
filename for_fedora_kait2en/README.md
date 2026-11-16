# For Fedora KAIT2EN

---

## Setup menu

- [Environment](#environment)
- [記録の確認範囲](#記録の確認範囲)
- [Mac風のキー操作](#mac風のキー操作)
- [GNOME標準ショートカット](#gnome標準ショートカット)
- [Ptyxis・コピーとペースト](#ptyxisコピーとペースト)
- [永続化と復旧](#永続化と復旧)
- [その他のセットアップ実績](#その他のセットアップ実績)
- [未検証・追記する項目](#未検証追記する項目)
- [参考](#参考)

---

## Environment

2018年のMacBook ProにKAIT2ENでLinuxを導入し、FedoraでMac風のキー操作を使うためのセットアップ記録。

|項目|詳細|
|-|-|
|本体|MacBook Pro (2018)|
|モデル|MacBookPro15,1|
|導入|KAIT2EN|
|OS|Fedora 45|
|デスクトップ|GNOME 51|
|GPU|Hybrid GPU: Intel UHD 630 + Radeon Pro 560X|
|表示倍率|GNOME 200%|
|ターミナル|Ptyxis（キー操作の記録対象）|

OS・GNOMEのバージョンはユーザー申告値を記載している。このREADME作成時に実機のバージョンを取得したものではない。

## 記録の確認範囲

記録日: 2026-11-16

- **ユーザー報告**: 今回の依頼に記載された環境・実績、および「KAIT2ENで2018年MacにLinuxを入れてキー周りを改修した」という報告。
- **ユーザー提供の保存用設定**: このチャットで全文が提示され、保存を希望されたkeyd設定。設定本文の提供と、実機での適用・動作確認は区別する。
- **手順・未検証**: バックアップ、再読み込み、自動起動、復旧など、再現のために添えたコマンド。実機で実行済みとは扱わない。

参照会話「GUIでスクロール調整」から取得できたのは末尾5件であり、キー操作を試した前後のログは含まれていなかった。そのため、提供された設定を「検証済みの最終設定」とは記載しない。以下に未検証の拡張設定を混ぜて適用済みとすることも避ける。

---

## Mac風のキー操作

### keyd setup

ユーザー提供の保存用設定を以下にそのまま残す。ここでのCommandはMacの物理キー表記、`meta`はkeyd側の修飾キー名。物理キーの認識・変換結果は実機で確認する。

この設定は`[ids]`の`*`で全対象デバイスに一致するため、外付けキーボード等への影響も確認する。keydの導入元・導入時のバージョンは未確認なので、特定のインストールコマンドを実行済みとしては記録しない。

### 設定前: 状態確認とバックアップ（手順・未検証）

以下はkeydが導入され、`keyd.service`が利用できる環境向け。

```bash
command -v keyd
systemctl is-enabled keyd
systemctl is-active keyd
sudo install -d -m 0755 /etc/keyd

# 既存設定がある場合だけ、日時付きの別ファイルへ保存する
if sudo test -f /etc/keyd/default.conf; then
    backup_path="/etc/keyd/default.conf.backup-$(date +%Y%m%d-%H%M%S)"
    sudo cp -a /etc/keyd/default.conf "$backup_path"
    printf 'Backup: %s\n' "$backup_path"
fi
```

`is-enabled`と`is-active`が無効・停止中と表示する場合もある。復旧時のため、変更前の状態とバックアップ先を控えておく。

### 設定本文（ユーザー提供・適用結果は未確認）

次のコマンドは`/etc/keyd/default.conf`を上書きする。先にバックアップを取る。

```bash
sudo tee /etc/keyd/default.conf > /dev/null <<'EOF'
[ids]
*

[meta]
# Clipboard
c = C-insert
v = S-insert
x = C-x

# Editing
a = C-a
z = C-z
s = C-s
f = C-f
g = C-g

# Documents
n = C-n
o = C-o
p = C-p

# Tabs and windows
t = C-t
w = C-w
q = C-q

# Browser navigation
r = C-r
l = C-l

# Text formatting
b = C-b
i = C-i
u = C-u
k = C-k

# Cursor navigation
left = home
right = end
up = C-home
down = C-end

# Preserve the macOS screen-lock shortcut
[control+meta]
q = C-M-q
EOF
```

### 設定後: 起動・再読み込み・確認（手順・未検証）

```bash
sudo systemctl start keyd
sudo keyd reload
systemctl status keyd --no-pager
sudo journalctl -u keyd -b --no-pager -n 50
```

サービスが起動していても、設定の全項目が期待どおり動くことを保証するものではない。ログの設定エラーと、各アプリでの実際の入力を確認する。

### 保存した設定の意図

以下は設定から読める変換先であり、動作確認結果の一覧ではない。

|操作|keydで送るキー|
|-|-|
|Command + C / V / X|Ctrl + Insert / Shift + Insert / Ctrl + X|
|Command + A / Z / S / F / G|Ctrl + A / Z / S / F / G|
|Command + N / O / P|Ctrl + N / O / P|
|Command + T / W / Q|Ctrl + T / W / Q|
|Command + R / L|Ctrl + R / L|
|Command + B / I / U / K|Ctrl + B / I / U / K|
|Command + ← / →|Home / End|
|Command + ↑ / ↓|Ctrl + Home / Ctrl + End|
|Control + Command + Q|Ctrl + Meta + Q（ロック用ショートカットを残す意図）|

キー送信後の動作はアプリ側の割り当てにも依存する。Control + Command + Qによるロックも、GNOME側の割り当てとの一致を確認する必要がある。

---

## GNOME標準ショートカット

GNOME側の操作は「設定 → キーボード → キーボードショートカットの表示とカスタマイズ」で確認・変更する。[GNOME公式ヘルプ](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)

keydのキー変換と、GNOME標準ショートカットの割り当てを分けて管理する。以下は確認対象であり、今回取得できた会話だけでは変更済みのキーを特定できない。

- アプリ・ウィンドウの切り替え
- 検索・アクティビティ
- 画面ロック
- ワークスペースの移動
- 他の割り当てとの競合

GNOMEの割り当てを変更した場合は、操作名・変更前・変更後・keyd有効時の動作を記録する。keyd設定内のロック維持コメントだけを根拠に、ロックの動作確認済みとはしない。

---

## Ptyxis・コピーとペースト

PtyxisもMac風の操作に揃える際の確認対象。保存用keyd設定では、コピーは`Ctrl+Insert`、貼り付けは`Shift+Insert`を送る。Ptyxis側のショートカット設定値や、これらのキーで実際にコピー・貼り付けできた結果は未確認。

以下をそれぞれ確認して記録する。

- Chrome等で文字を選択し、Command + Cでコピーできるか。
- PtyxisにCommand + Vで貼り付けできるか。
- Ptyxisの選択テキストをCommand + Cでコピーし、GUIアプリに貼り付けできるか。
- 物理Control + Cでシェル上の処理を中断できるか。
- Command + X / Z / A等が、ターミナル内で意図した動作になるか。

ターミナル内では、送信されたCtrl系キーをシェルや実行中のプログラムが処理する場合がある。GUIアプリとターミナルで同じ結果になるとは限らないため、切り分けて確認する。

---

## 永続化と復旧

### 自動起動（手順・未検証）

手動での動作確認が済んでから、自動起動を有効にする。

```bash
sudo systemctl enable keyd
systemctl is-enabled keyd
systemctl is-active keyd
```

設定ファイルの保存とサービスの自動起動は別の確認項目。再起動後に次を実行し、さらに実際のキー操作を試す。

```bash
systemctl is-enabled keyd
systemctl is-active keyd
sudo journalctl -u keyd -b --no-pager -n 50
```

再起動後の永続化は、今回の記録では未確認。GNOMEやPtyxis側で変更した設定も、ログインし直した後に別途確認する。

### 一時停止と復旧（手順・未検証）

キー操作がおかしくなった場合、操作可能なターミナルから停止する。

```bash
sudo systemctl stop keyd
```

keyd公式READMEには緊急終了用の`Backspace + Escape + Enter`が案内されている。この実機での利用結果は未確認。[keyd公式README](https://github.com/rvaiya/keyd#quickstart)

バックアップへ戻す場合は、以下のパスを先に控えた実際のバックアップ先へ置き換える。

```bash
# 日時部分を実際のバックアップ名に置き換えてから実行する
sudo cp -a /etc/keyd/default.conf.backup-YYYYMMDD-HHMMSS /etc/keyd/default.conf
sudo systemctl start keyd
sudo keyd reload
systemctl status keyd --no-pager
sudo journalctl -u keyd -b --no-pager -n 50
```

新規作成でバックアップがない場合は、今回作成した設定を読み込ませない名前へ退避する。

```bash
sudo systemctl stop keyd
sudo mv /etc/keyd/default.conf /etc/keyd/default.conf.disabled
```

ほかの`/etc/keyd/*.conf`がある場合は、それらの設定も別途確認する。変更前にサービスが停止中だった場合は停止状態に戻す。今回初めて自動起動を有効にした場合に限り、元へ戻すために無効化する。

```bash
sudo systemctl disable --now keyd
```

GNOMEやPtyxis側の変更はkeydの停止では元に戻らないため、それぞれの設定画面で元の割り当てに戻す。

---

## その他のセットアップ実績

以下は今回の依頼で実績として挙げられたユーザー報告。README作成時に実機の再測定・再設定はしていない。

|項目|ユーザー報告の内容|確認範囲・残すべき詳細|
|-|-|-|
|Hybrid GPU|Intel UHD 630 + Radeon Pro 560X|GPU構成の記録。アプリごとの使用GPUや切替方法は未確認|
|充電上限|80%|設定方法、管理ツール、再起動後の維持は未確認|
|音声|DSP Speakersの存在|出力先の存在の記録。実際の発音・音質・全スピーカー動作の確認とは区別|
|Chrome|Video Decode: Hardware accelerated|表示された状態の記録。全動画・全コーデックでのハードウェアデコードを保証しない|
|GNOME表示|200%|表示倍率の記録|
|スクロール|WSFによる調整|具体的な拡張機能ID・設定値・アプリ別の効果は未確認|
|アプリ管理|Flatpak / Extension Manager等|導入元・バージョン・追加したアプリや拡張機能の一覧は未確認|

WSFの正式名称や設定値は推測で補わない。充電制御のサービスやGPU切り替えコマンドも、実機の記録を得てから追加する。

---

## 未検証・追記する項目

- keydの導入元・バージョン、提示された設定の実機への適用結果。
- GNOME標準ショートカットの変更前・変更後の具体値。
- Ptyxis側のコピー・貼り付けの割り当てと、アプリ間の動作確認結果。
- keyd自動起動、再起動後のキー操作、復旧手順の実機確認結果。
- 会話中で提案されたkeyd拡張設定の全文と、試したかどうか。現時点では適用済み扱いにしない。
- GPU、充電上限、音声、Chrome、WSF、Flatpak関連の設定値・確認ログ。

---

## 参考

- 既存の構成: [For Mac](../for_mac/README.md) / [For Ubuntu](../for_ubuntu/README.md)
- 元の会話: [GUIでスクロール調整](https://chatgpt.com/c/6afa6d83-8970-83ee-8a02-718d518740f3)（アクセスには元の会話を閲覧できるアカウントが必要）
- [keyd公式README](https://github.com/rvaiya/keyd)（管理コマンドの参考。実機での実行履歴ではない）
- [GNOME公式: キーボードショートカットの設定](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)
