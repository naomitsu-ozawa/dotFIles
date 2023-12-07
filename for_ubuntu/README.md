# For Ubuntu
---
Please execute in order from the top.  
---
## Install zsh
```
sudo apt install zsh
chsh -s $(which zsh)  
```
#### Make sure to reboot!

## Installing HomeBrew dependencies  
```
sudo apt install build-essential procps curl file git
```
  
## Install HomeBrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/**user_name**/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
#### Make sure to reboot!
---
## Install Treminal Tools
### From HomeBrew
#### GCC, GH  and GHQ install  
```
brew install ghq gcc gh
```
### From apt
#### FZF ,TREE and BAT install  
```
sudo apt install fzf tree bat
```
### From cargo
```
curl https://sh.rustup.rs -sSf | sh

```
```
cargo install lsd

```
### Install Zsh plugin maneger
#### Zinit 
```
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"  
```
#### Font Hack gen nerd font install  
```
https://github.com/yuru7/HackGen  
```
Download it and install it with a font manager or something.  

#### clone enhancd  
```
ghq get https://github.com/b4b4r07/enhancd.git
```
### .zshrc
Download "zshrc_for_ubuntu" and replace it with ".zshrc".


### Configure p10K
```
p10k configure
```

## Deep learning setup
#### Driver setup
- Ubuntuのセットアップ時には、プロプライエタリドライバーを使わない。
- Ubuntuセットアップ後にnVidiaドライバーを一旦削除する。
- 改めて、ｎVidiaのドライバーをセットアップする。
#### Install Tensorflow
- 2.15以降の場合
  - Tensorflow
    - ```pip install 'tensorflow[and-cuda]'```
  - TensorRT
    - ```pip install --extra-index-url https://pypi.nvidia.com tensorrt-bindings==8.6.1 tensorrt-libs==8.6.1```
- 2.14以前の場合
  - Tensorflow
    - ```conda install tensorflow=2.12.*=cuda*```
  - TensrRTの互換性に注意。
  
#### Install Ultralytics
  - ```pip install ultralytics```
  - PyTrochのCUDAバージョンに注意。現行のCUDAバージョンの場合は、そのままでOK。
  - 古いバージョンのCUDAを使う場合は、専用のインストールスクリプトでインストールする。
  - TensrflowのCUDAを合わせること。
  
#### Install rembg
  - ```pip install 'rembg[gpu]'```
  - ```pip uninstall onnxruntime```
  - ```pip install -U --force-reinstall onnxruntime-gpu```
  - onnxruntimeは、一度アンインストールしてからgpuバージョンを再インストールしないと、CUDAのEPが使えなかった。

