# For Fedora KAIT2EN

---

## Setup menu

- [Environment](#environment)
- [Mac風のキー操作](#mac風のキー操作)
- [GNOME標準ショートカット](#gnome標準ショートカット)
- [Ptyxis・コピーとペースト](#ptyxisコピーとペースト)
- [永続化と復旧](#永続化と復旧)
- [その他のセットアップ実績](#その他のセットアップ実績)
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
|ターミナル|Ptyxis|

記録日: 2026-11-16

---

## Mac風のキー操作

### keyd setup

Commandキーを使ったMac風の操作をkeydで設定する。ここでのCommandはMacの物理キー表記、`meta`はkeyd側の修飾キー名。

`[ids]`の`*`は外付けキーボードを含む対象デバイスに一致する。

### 設定前: 状態確認とバックアップ

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

復旧用に、変更前のサービスの状態とバックアップ先を控えておく。

### 保存する設定

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

### 設定後: 起動・再読み込み・確認

```bash
sudo systemctl start keyd
sudo keyd reload
systemctl status keyd --no-pager
sudo journalctl -u keyd -b --no-pager -n 50
```

ログに設定エラーがないことを確認する。

### キー割り当て

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
|Control + Command + Q|Ctrl + Meta + Q（画面ロック）|

画面ロックは、GNOME側のショートカットと合わせる。

---

## GNOME標準ショートカット

GNOME側の操作は「設定 → キーボード → キーボードショートカットの表示とカスタマイズ」で確認・変更する。[GNOME公式ヘルプ](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)

GNOME側で調整する主な操作:

- アプリ・ウィンドウの切り替え
- 検索・アクティビティ
- 画面ロック
- ワークスペースの移動
- 他の割り当てとの競合

---

## Ptyxis・コピーとペースト

保存するkeyd設定では、コピーに`Ctrl+Insert`、貼り付けに`Shift+Insert`を送る。

PtyxisとGUIアプリの間で、次の操作を確認する。

- Chrome等で文字を選択し、Command + Cでコピーできるか。
- PtyxisにCommand + Vで貼り付けできるか。
- Ptyxisの選択テキストをCommand + Cでコピーし、GUIアプリに貼り付けできるか。
- 物理Control + Cでシェル上の処理を中断できるか。
- Command + X / Z / A等が、ターミナル内で意図した動作になるか。

ターミナルではCtrl系キーをシェルや実行中のプログラムが処理するため、コピー・貼り付けとControl + Cによる中断を分けて確認する。

---

## 永続化と復旧

### 自動起動

自動起動を有効にする。

```bash
sudo systemctl enable keyd
systemctl is-enabled keyd
systemctl is-active keyd
```

再起動後の状態を確認する。

```bash
systemctl is-enabled keyd
systemctl is-active keyd
sudo journalctl -u keyd -b --no-pager -n 50
```

### 一時停止と復旧

キー操作がおかしくなった場合、操作可能なターミナルから停止する。

```bash
sudo systemctl stop keyd
```

緊急終了は`Backspace + Escape + Enter`。[keyd公式README](https://github.com/rvaiya/keyd#quickstart)

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

|項目|内容|
|-|-|
|Hybrid GPU|Intel UHD 630 + Radeon Pro 560X|
|充電上限|80%|
|音声|DSP Speakersの存在|
|Chrome|Video Decode: Hardware accelerated|
|GNOME表示|200%|
|スクロール|WSFによる調整|
|アプリ管理|Flatpak / Extension Manager等|

---

## 参考

- 既存の構成: [For Mac](../for_mac/README.md) / [For Ubuntu](../for_ubuntu/README.md)
- 元の会話: [GUIでスクロール調整](https://chatgpt.com/c/6afa6d83-8970-83ee-8a02-718d518740f3)
- [keyd公式README](https://github.com/rvaiya/keyd)
- [GNOME公式: キーボードショートカットの設定](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)
