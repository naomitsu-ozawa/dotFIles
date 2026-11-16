# For Fedora KAIT2EN

---

## Setup menu

- [Environment](#environment)
- [Mac風のキー操作](#mac風のキー操作)
- [GNOME標準ショートカット](#gnome標準ショートカット)
- [Ptyxis・コピーとペースト](#ptyxisコピーとペースト)
- [永続化と復旧](#永続化と復旧)
- [KAIT2ENの保守](#kait2enの保守)
- [Hybrid GPU setup](#hybrid-gpu-setup)
- [充電上限80%](#充電上限80)
- [DSP Speakers setup](#dsp-speakers-setup)
- [動画のハードウェアデコード](#動画のハードウェアデコード)
- [GNOME 200%表示](#gnome-200表示)
- [Flatpak / Extension Manager setup](#flatpak--extension-manager-setup)
- [WSFによるスクロール調整](#wsfによるスクロール調整)
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

ControlとCommandのキー交換は使わず、Commandとの組み合わせをkeydで変換する。「調整（GNOME Tweaks）→ キーボード → 追加のレイアウトオプション」で、以前設定したControlとWinの交換を解除する。

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

keydからコピーに`Ctrl+Insert`、貼り付けに`Shift+Insert`を送り、Ptyxis側も同じキーを受け付けるようにする。

### ショートカットを設定

```bash
gsettings set org.gnome.Ptyxis.Shortcuts copy-clipboard '<Control>Insert'
gsettings set org.gnome.Ptyxis.Shortcuts paste-clipboard '<Shift>Insert'
```

Ptyxisのウィンドウをすべて閉じて開き直す。

### 保存された値を確認

```bash
gsettings get org.gnome.Ptyxis.Shortcuts copy-clipboard
gsettings get org.gnome.Ptyxis.Shortcuts paste-clipboard
```

### 操作

|操作|物理キー|
|-|-|
|コピー|Command + C|
|貼り付け|Command + V|
|実行中の処理を中断|Control + C|

ブラウザー・ChatGPTアプリ・Ptyxisでコピーと貼り付けを確認し、この方式で「OK」となった。処理中断は、次を実行して物理Control + Cを押す。

```bash
sleep 60
```

### 標準のショートカットへ戻す

```bash
gsettings reset org.gnome.Ptyxis.Shortcuts copy-clipboard
gsettings reset org.gnome.Ptyxis.Shortcuts paste-clipboard
```

Ptyxisをすべて閉じて開き直す。

---

## 永続化と復旧

### 自動起動

keydの設定は`/etc/keyd/default.conf`、Ptyxisの設定はユーザーのdconfに保存される。keydの自動起動を有効にする。

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

## KAIT2ENの保守

Fedora本体とは別に、KAIT2ENのドライバーと統合設定を更新する。

```bash
kait2en-install
```

管理者権限が必要な処理ではパスワードを求められる。処理が終わり、再起動を案内されたら再起動する。

```bash
sudo reboot
```

[KAIT2EN公式の導入・更新手順](https://kait2en.org/documentation.html#finish-the-kait2en-installation)

---

## Hybrid GPU setup

Intel UHD 630でデスクトップを描画し、必要なアプリだけRadeon Pro 560Xを使う。

### GUIで設定

1. アプリ一覧から **T2 Hybrid GPU Control** を開く。
2. **Hybrid graphics** を有効にする。
3. **Apply Changes**で保存する。
4. 再起動する。

ターミナルからも起動できる。

```bash
t2-hybrid-gpu-control
```

### 確認した状態

|項目|表示|
|-|-|
|Current display GPU|Integrated GPU|
|Configured boot GPU|Integrated GPU|
|Hybrid graphics support|Available|
|Discrete GPU runtime state|DynOff|
|Hybrid graphics|Reapply|

`DynOff`はRadeonが省電力状態、`DynPwr`は稼働状態を示す。必要なアプリはGNOMEのアプリ一覧から右クリックし、「専用グラフィックカードで起動」を選ぶ。

### カーネル更新後の確認

Hybrid GPU ControlでRuntime PMの状態を確認する。AMDGPUのビルドログは次で読める。

```bash
sudo tail -n 80 /var/log/kait2en-gpu-runtime-pm.log
```

再ビルドが必要な場合は、実行中のカーネルに対して以下を実行する。

```bash
sudo /usr/local/libexec/kait2en/gpu-runtime-pm/install-gpu-runtime-pm.sh install "$(uname -r)"
sudo reboot
```

[KAIT2EN公式: GPU設定](https://github.com/kaiT2en/KaiT2en-Fedora/blob/main/website/docs/post-install/configuring-gpus.md)

---

## 充電上限80%

「設定 → 電源」で充電上限を有効にする。GNOMEの画面はトグルで切り替え、数値は次のコマンドで確認する。

```bash
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
```

今回の出力は`80`だった。

### 数値を指定する

```bash
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
```

設定はSMCに保存され、再起動後も維持される。解除する場合は`100`を指定する。

```bash
echo 100 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold
```

[KAIT2EN公式: t2smcの充電上限](https://github.com/kaiT2en/KaiT2en-Fedora/blob/main/modules/t2smc/README.md#battery-charge-limit)

---

## DSP Speakers setup

KAIT2ENがMacBookPro15,1用のPipeWire DSPプロファイルを導入する。出力一覧に **DSP Speakers** があることを確認した。

### 出力を選ぶ

1. 「設定 → サウンド」を開く。
2. 出力デバイスで **DSP Speakers** を選ぶ。
3. 音声を再生する。

|出力|用途|
|-|-|
|DSP Speakers|モデル別の音響補正を通す内蔵スピーカー|
|Apple Internal Speakers|補正を通さない内蔵スピーカー|
|Headphones|ヘッドホン出力|

### ターミナルで確認・選択

```bash
wpctl status
```

`Audio → Sinks`からDSP Speakersを探す。`*`が付いているものが標準出力。CLIで切り替える場合は、表示されたDSP Speakersの番号を指定する。

```bash
# 55は例。wpctl statusに表示されたDSP Speakersの番号に置き換える
wpctl set-default 55
```

### 導入状態を調べる

```bash
rpm -q t2-dsp
ls -l /etc/pipewire/pipewire.conf.d/51-t2-dsp.conf
```

DSPが表示されない場合は再起動し、上記のパッケージと設定ファイルを確認する。MacBookPro15,1に対応するプロファイルは`15_1`。

[KAIT2EN公式: Audio DSP](https://github.com/kaiT2en/KaiT2en-Fedora/blob/main/dsp/README.md)

---

## 動画のハードウェアデコード

KAIT2ENの動画デコード用コマンドで有効化し、Chromeの`Video Decode: Hardware accelerated`を確認した。

### VA-APIドライバーを導入

Ptyxisで以下を実行する。

```bash
cd /usr/local/src/KaiT2en-Fedora
sudo bash ./scripts/fedora/install-hardware-video-decoding.sh
```

RPM Fusionを有効にし、検出されたIntel・AMD GPU向けのVA-APIドライバーを導入する。終了時のGPU別の結果で、対応するコーデックが`available`になっていることを確認する。

### Chrome側を設定

1. 「設定 → システム」を開く。
2. 「グラフィックアクセラレーションが使用可能な場合は使用する」をONにする。
3. Chromeを再起動する。
4. アドレスバーに`chrome://gpu`を入力する。

確認時の環境と表示:

|項目|結果|
|-|-|
|Chrome|157.0.8103.78|
|カーネル|7.3.3-300.fc45.x86_64|
|Mesa|26.2.6|
|Ozone platform|wayland|
|アクティブGPU|Intel UHD 630|
|Video Decode|Hardware accelerated|
|Canvas / Compositing / Rasterization|Hardware accelerated|
|WebGL / WebGPU|Hardware accelerated|
|Video Encode|Software only|

### 再生中のデコーダーを確認

1. Chromeで動画を再生する。
2. 別タブで`chrome://media-internals`を開く。
3. 再生中の動画を選ぶ。
4. `video_decoder`や`kVideoDecoderName`を確認する。`GpuVideoDecoder`や`VaapiVideoDecoder`がGPU側のデコーダー。

YouTubeは動画を右クリックして「詳細統計情報」を開く。`avc1`はH.264、`vp09`はVP9、`av01`はAV1。このMacではAV1をハードウェアデコードできないため、H.264またはIntel GPUが対応するVP9を使う。

[KAIT2EN公式: 動画デコード](https://github.com/kaiT2en/KaiT2en-Fedora/blob/main/website/docs/post-install/hardware-video-decoding.md) / [Chromium公式: VA-APIの確認](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/gpu/vaapi.md)

---

## GNOME 200%表示

150%から200%へ変更したところ、動きは滑らかになった。一方で、文字やUIが大きく、作業領域が狭く感じられた。

### 設定方法

1. 「設定 → ディスプレイ」を開く。
2. 内蔵ディスプレイを選ぶ。
3. 「拡大率」を **200%** にする。
4. 「適用」→「変更を維持」を選ぶ。

2880×1800の画面を200%で使うと、論理的な作業領域は1440×900になる。

[GNOME公式: ディスプレイの設定](https://help.gnome.org/gnome-help/look-resolution.html)

---

## Flatpak / Extension Manager setup

Extension Managerは「ソフトウェア」で検索してインストールできた。以下はCLIから導入・管理する手順。

### FlatpakとFlathub

まず導入状態を確認する。

```bash
flatpak --version
flatpak remotes
```

Flatpakがない場合はインストールする。

```bash
sudo dnf install flatpak
```

Flathubを登録する。

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remotes
```

[Flathub公式: Fedoraの設定](https://flathub.org/en/setup/Fedora)

### Extension Managerを導入・起動

```bash
flatpak install flathub com.mattjakeman.ExtensionManager
flatpak run com.mattjakeman.ExtensionManager
```

「Browse / 探す」で拡張機能を検索し、インストールする。「Installed / インストール済み」で有効・無効を切り替え、歯車から設定を開く。

[Extension Manager公式](https://github.com/mjakeman/extension-manager)

### 日常の管理

```bash
# アプリ一覧
flatpak list --app

# アプリ検索
flatpak search ExtensionManager

# アプリとランタイムを更新
flatpak update
```

[Flatpak公式: CLIの使い方](https://docs.flatpak.org/en/latest/using-flatpak.html)

---

## WSFによるスクロール調整

ブラウザーのタッチパッドスクロール量が多く、Dconf Editorで調整しても速さが残ったため、**Wayland Scroll Factor（WSF）**を使用した。WSFで遅くできたが、GNOMEの「設定」なども遅くなったため、アプリ別に倍率を分ける構成へ進める。

### 1. WSFを導入

```bash
sudo dnf install dnf-plugins-core
sudo dnf copr enable daniel-g-carrasco/wayland-scroll-factor
sudo dnf install wayland-scroll-factor
wsf enable
```

一度ログアウトし、ログインし直す。

### 2. GUIで全体のスクロール量を調整

アプリ一覧から **Wayland Scroll Factor** を開く。ターミナルからは以下で起動できる。

```bash
wsf-gui
```

`Vertical Scroll`で縦、`Horizontal Scroll`で横のスクロール量を変更する。会話で試す値として案内した縦倍率は`0.20`。

|倍率|スクロール量|
|-|-|
|1.00|標準|
|0.50|50%|
|0.20|20%|
|0.10|10%|

CLIで縦・横を設定する場合:

```bash
wsf set --scroll-vertical 0.20 --scroll-horizontal 1.00
wsf get
wsf status
```

### 3. ブラウザーだけ遅くする

システム側まで遅くなる場合は、**Touchpad Speed Control**でアプリ別に分ける。

1. 全体の倍率を戻す。

   ```bash
   wsf set 1.00
   ```

2. Extension Managerの「Browse / 探す」で **Touchpad Speed Control** を検索してインストールする。
3. 「Installed / インストール済み」で有効にし、歯車から設定を開く。
4. **Vertical Scroll**の**Global speed**を`1.00`にする。
5. Chromeなど、遅くしたいアプリのスライダーを下げる。
6. 横方向も変える場合は**Horizontal Scroll**で調整する。

会話で案内した調整例:

|アプリ|縦スクロール倍率|
|-|-|
|Chrome / Chromium|0.20|
|Firefox|0.25|
|GNOME 設定|1.00|
|ファイルマネージャー|1.00|
|その他|1.00|

アプリを切り替えると倍率も切り替わる。`General`でフォーカス検出とカーソル追跡を有効にすると、ポインター下のウィンドウにも合わせられる。

[WSF公式](https://github.com/daniel-g-carrasco/wayland-scroll-factor) / [Touchpad Speed Control公式](https://github.com/ritesh-777/touchpad-speed-control) / [GNOME拡張の配布ページ](https://extensions.gnome.org/extension/10008/touchpad-speed-control/)

### 4. 設定の保存と復元

WSFの設定ファイルは以下。

```text
~/.config/wayland-scroll-factor/config
```

バックアップする。

```bash
cp -a ~/.config/wayland-scroll-factor/config ~/.config/wayland-scroll-factor/config.bak
```

戻す場合:

```bash
cp -a ~/.config/wayland-scroll-factor/config.bak ~/.config/wayland-scroll-factor/config
wsf get
```

Touchpad Speed Control側のアプリ別倍率は、設定画面の **Export Settings**でJSONへ保存し、**Import Settings**で戻す。

### 5. 効かない場合・解除する場合

```bash
wsf status
wsf doctor
```

ライブラリの読み込み設定を修復する場合:

```bash
wsf repair
```

ログアウトしてログインし直す。

WSFを解除する場合は、Touchpad Speed ControlをExtension ManagerでOFFにしてから以下を実行し、ログアウト・ログインする。

```bash
wsf disable
```

---

## 参考

- 既存の構成: [For Mac](../for_mac/README.md) / [For Ubuntu](../for_ubuntu/README.md)
- 元の会話: [GUIでスクロール調整](https://chatgpt.com/c/6afa6d83-8970-83ee-8a02-718d518740f3)
- [keyd公式README](https://github.com/rvaiya/keyd)
- [GNOME公式: キーボードショートカットの設定](https://help.gnome.org/gnome-help/keyboard-shortcuts-set.html)
