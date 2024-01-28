# For Ubuntu
---
## Setup menu
### Shell setup
- [Install zsh](README.md#install-zsh)
### Homebrew setup
- [Install HomeBrew](README.md#install-homebrew)
### Terminal Tools setup
- [Install Terminal Tools](README.md#install-treminal-tools)
### Setting up Secure Boot
- [Setting up Secure Boot](README.md#setting-up-secure-boot-1)
### Deep learning setup
- [Deep learning setup](README.md#deep-learning-setup-1)
### CPU Cooler setup
- [CPU Cooler setup](README.md#cpu-cooler-setup-1)
---
Ubuntu22.04LTSで深層学習をするためのセットアップです。  
ワークステーションの仕様は以下の通り。
|項目|詳細|
|-|-|
|CPU|intel i7 13700K|
|GPU|nVidia RTX4070Ti 12GB|
|coolor|NZXT kraken240|
|memory|128GB|
|storage 1|Ubuntu(1TB)|
|storage 2|Windows(1TB)|
|storage 3|share storage(2TB)|


---
## Install zsh
Bashよりカスタムしやすいので、Shellはzshを使います。
```
sudo apt install zsh
chsh -s $(which zsh)  
```
**Make sure to reboot!**  
```
sudo reboot
```

  
## Install HomeBrew
いくつかのツールはHomeBrew経由で入手するので、セットアップします。  
依存関係をインストール後に、HomeBrewのインストールスクリプトを実行します。
- Installing HomeBrew dependencies  
```
sudo apt install build-essential procps curl file git
```
- install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/**user_name**/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
**Make sure to reboot!**
```
sudo reboot
```
---
## Install Treminal Tools
CLIを使う上で便利なツールをインストールします。

### From HomeBrew
- #### GCC, GH  and GHQ install  
  ```
  brew install ghq gcc gh
  ```
### From apt
- #### FZF ,TREE and BAT install  
  ```
  sudo apt install fzf tree bat
  ```
- ### From cargo
  ```
  curl https://sh.rustup.rs -sSf | sh

  ```
  ```
  cargo install lsd

  ```
### Install Zsh plugin maneger
- #### Zinit 
  ```
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"  
  ```
- #### Font Hack gen nerd font install  
  ターミナルで使うフォントは、hack gen nerd fontを使います。  
  https://github.com/yuru7/HackGen  
  ダウンロード後は、フォントマネージャなどでインストールしてください。

- #### clone enhancd  
  ```
  ghq get https://github.com/b4b4r07/enhancd.git
  ```
### .zshrc
- Download "zshrc_for_ubuntu" and replace it with ".zshrc".


### Configure p10K
- PowerLineの設定を、以下のコマンドで行います。
  ```
  p10k configure
  ```

### snap setup
- snapもセットアップしておく。
  - neovim
  - mpv
  - vlc
- ↑をインストールしておく。

### flatpak setup
- flathubもセットアップしておく。nVidia Driverが更新できるっぽい？
### NeoVim setup
- LazyVimを使う。
- https://github.com/LazyVim/LazyVim
- ColorschemeはSolarized osakaを使う。
- https://github.com/craftzdog/solarized-osaka.nvim

---
## Setting up Secure Boot
Windows11とデュアルブート環境を作成しているので、UEFIのセットアップ画面でセキュアブートを有効化しておく。  
セキュアブートを無効化したままだと、WindowsUpdateができなくなる可能性があるので注意が必要。  
セキュアブートを有効化してUbuntuを起動すると、サードパーティー製のドライバーが読み込めないので、読み込めるように署名を作成して必要なキーを登録する必要がある。
- セキュアブートを有効化する場合は、以下の設定を行う
  1. 署名キーを作成する  
      ```
      openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=Descriptive name/"
      ```
  2.  モジュールに署名する  
      ```
      sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der <</path/to/module>>
      ```
      <</path/to/module>>は、以下のコマンドで表示されたパスで置き換える
      ```
      modinfo -n nvidia
      ```
      以下のコマンドが置き換えたコマンドになる
      ```
      sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n nvidia)
      ```
  3.  セキュアブートにキーを登録する
      ```
      sudo mokutil --import MOK.der
      ```
      このときパスワードの設定を求められる。セキュアブートキー登録に関するパスワードになる。覚えておく。  
      再起動すると以下の画面になるのでキーを登録する  
      選択肢は以下の通りでOK  
          1.  Enroll MOK  
          2.  Continue  
          3.  Yes  
          4.  設定したパスワードを入力  
          5.  OK  
  ![Alt text](Screenshot_00.png)
  1. もう一度再起動が行われる
  2. Ubuntuのアップデートなどで↑の画面が表示された場合、再度登録する必要がある。nvidia-smiをして使えないことを確認した後に、iiとiiiを行って再起動させる
  3. 間違って何もせずにUbuntuを起動してしまったときは
      ```
      sudo mokutil --disable-validation
      ```
      で再度一時的なパスを入力して再起動  
  4.  セキュアブートをONにする画面は  
      ```
      sudo mokutil --enable-validation
      ```
---
## Deep learning setup
Ubuntuのセットアップ時には、プロプライエタリドライバーを使わずにセットアップする。  
セットアップ時にプロプライエタリドライバーを使うようにしたら、セットアップ後にドライバーの変更ができない症状が出たので・・・  
CUDA11.xとCUDA12.xの環境を両方使う必要があるので、ドライバーとCUDA Tool Kitのセットアップを行い、cuDnn等は、Conda環境内で構築するようにした。  
Open-kernelに関しては、未検証。推奨ドライバーになるという情報もある。  


### Ubuntu 22.04 LTS
#### Driver setup
- Ubuntuのセットアップ時には、プロプライエタリドライバーを使わない。
- Ubuntuセットアップ後にnVidiaドライバーを一旦削除する。
- ```sudo apt-get --purge remove "*nvidia*" "libxnvctrl*"```
- ```sudo apt-get autoremove```
- 改めて、ｎVidiaのドライバーをセットアップする。
- ドライバーのバージョンは、GPUの種類とCUDAのバージョンに合うものを入れる
- RTX4070Ti(12GB)の場合、2024年1月29日時点では、nvidia-driver-545もしくはnvidia-driver-545-openをセットアップ
- open-kernelは、新機能を利用可能。どちらでもOK。
#### CUDA setup
- Conda側でセットアップする場合はスキップ可
- OS側にセットアップする場合
  - ↓がセットアップのドキュメント
  - https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html?utm_source=pocket_saves
  - 予め、古いapt-keyを削除しておく  
    ```sudo apt-key del 7fa2af80```
  - 次に、↓からDownLoad nowをおしてダウンロード画面へ行く
  - https://developer.nvidia.com/cuda-toolkit
  - OSなどインストールする項目を選択してく
  - Download Installer for Linux Ubuntu 22.04 x86_64のBase Installerに表示されるコードを実行していく
  - .bashrcもしくは.zshrcに以下を追加する
    ```
    # <<<CUDA setting>>>
    export CUDA_PATH=/usr/local/cuda
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
    export PATH=/usr/local/cuda/bin:${PATH}
    ```

- Driver Installerは、すでに対応ドライバーがインストールされている場合はスキップする
- CUDAが要求するバージョンのセットアップ情報が記載されているので、インストールされているバージョンが異なる場合は、記載されているドライバーへ更新する。
- アップデートするときは、一旦削除しておく
  - CUDAをアンインストールする場合は以下  
    ```
    sudo apt-get --purge remove "*cuda*" "*cublas*" "*cufft*" "*cufile*" "*curand*"
    \ "*cusolver*" "*cusparse*" "*gds-tools*" "*npp*" "*nvjpeg*" "nsight*" "*nvvm*"
    ```
#### Conda setup
- miniforge3を使う
- https://github.com/conda-forge/miniforge
- Unix-like platforms (Mac OS & Linux)に従ってインストールする
  ```
  curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
  bash Miniforge3-$(uname)-$(uname -m).sh
  ```
- zshの場合、initializeされていない場合があるので、その時は以下を実行する
  ```
  conda init zsh
  ```
- condaチャンネルを追加する。nvidiaとanacondaチャンネルを追加する
  ```
  conda config --append channels nvidia
  conda config --append channels anaconda
  ```
#### Tensorflow setup
CUDA12.xの環境と11.xの環境を両立させる  
Conda使って環境を分ける
- CUDA12.x  
  - Tensorflow2.15以降
    - CUDAのインストール(OS側にインストールしている場合はスキップ可)
      - ```conda install cuda -c nvidia```
    - TensorflowとCUDAに必要な諸々をインストール(ライブラリやcuDnnなどもインストールされる)
      - ```pip install 'tensorflow[and-cuda]'```
    - TensorRT（必要ならTensorRTもインストール）
      - ```pip install --extra-index-url https://pypi.nvidia.com tensorrt-bindings==8.6.1 tensorrt-libs==8.6.1```
DeepLabCutなど2.13以前のTensorflowが必要な場合は、CUDA11.xが必要
CondaからCUDAをセットアップしてくれるパッケージがあるのでそれを活用する
- CUDA11.x
  - Tensorflow2.14以前の場合
    - CUDAのインストール(OS側にインストールしている場合はスキップ可)
      - ```conda install cuda -c nvidia```
    - TensorflowとCUDAに必要な諸々をインストール（ライブラリやcuDnnなどもインストールされる）
      - ```conda install tensorflow=2.12.*=cuda*```
    - TensrRTの互換性に注意。
  
#### Ultralytics YOLOv8 setup
  - ```pip install ultralytics```
  - PyTrochのCUDAバージョンに注意。現行のCUDAバージョンの場合は、そのままでOK。
  - 古いバージョンのCUDAを使う場合は、専用のインストールスクリプトでインストールする。
  - https://pytorch.org/get-started/locally/ ここから古いCUDA用のインストールスクリプトを取得する
  - TensrflowのCUDAを合わせること。
  
#### rembg setup
  - ```pip install 'rembg[gpu]'```
  - ```pip uninstall onnxruntime```
  - ```pip install -U --force-reinstall onnxruntime-gpu```
  - onnxruntimeは、一度アンインストールしてからgpuバージョンを再インストールしないと、CUDAのEPが使えなかった。
---
### CPU Cooler setup
NZXT kraken 240の制御をUbuntuで行いたかったので、liquidctlをセットアップする。  
[Cooler control](https://gitlab.com/coolercontrol/coolercontrol)が対応してくれれば、乗り換えたい。
### liquidctl setup
- https://github.com/liquidctl/liquidctl
- git versionで実験的に対応済みなので、gitの最新スナップショットをインストールする。
  ```
  # the latest snapshot of the official source code repository (requires git)
  python -m pip install git+https://github.com/liquidctl/liquidctl#egg=liquidctl
  ```
- /etc/udev/rules.dの中に[71-liquidctl.rules](https://github.com/liquidctl/liquidctl/blob/main/extra/linux/71-liquidctl.rules)を作成する。
- systemdに登録してサービス化する。
- ```/etc/systemd/system/liquidcfg.service```
- liquidcfg.serviceの例
  ```
  [Unit]
  Description=AIO startup service

  [Service]
  Type=oneshot
  ExecStart=/home/<<<ユーザー名>>>/miniforge3/bin/liquidctl initialize all
  ExecStart=/home/<<<ユーザー名>>>/miniforge3/bin/liquidctl set pump speed  25 30  30 50  35 75  40 100
  ExecStart=/home/<<<ユーザー名>>>/miniforge3/bin/liquidctl set fan speed 25 40  30 60  34 90  38 100

  [Install]
  WantedBy=default.target
  ```
- systemctlの自動実行設定をする
  ```
  systemctl daemon-reload
  systemctl start liquidcfg
  systemctl enable liquidcfg
  ```
  ---