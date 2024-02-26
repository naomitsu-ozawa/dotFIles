# Radeon Vega56 でTensorflowを使う
## Rocmのインストール
### amdgpu-installのインストール
for 22.04.3 hwe (kernel 6.2~)  
- 以下のURLからインストーラーを落とす  
https://repo.radeon.com/amdgpu-install/  
https://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy/amdgpu-install_5.6.50600-1_all.deb  
- amdgpu-installをインストールする  
```sudo apt-get install ./amdgpu-install_5.6.50600-1_all.deb```  
### rocmと依存関係のインストール
- Miopenでつかうコンパイラのインストール  
```sudo apt install libstdc++-12-dev```  
- ソフトウェアとアップデートの他のソフトウェアに以下のレポを追加する（rocm5.5.3）  
https://repo.radeon.com/rocm/apt/5.5.3
- amdgpu-installを使ってrocm等使うものをインストールする  
```amdgpu-install --usecase=rocm,hip,mllib,dkms,multimedia --rocmrelease=5.5.3```  
インストール可能なusecaseは次のコマンドで表示できる  
```sudo amdgpu-install --list-usecase```  
amdgpu-dkmsをインストールしたくない場合は、以下を実行する  
```amdgpu-install --usecase=rocm,hip,mllib,multimedia --no-dkms --rocmrelease=5.5.3```

以下をzshrc等に追記してPathを通す  
```export LD_LIBRARY_PATH=/opt/rocm-5.5.3/lib:$LD_LIBRARY_PATH```  

以下のコマンドを実行する  
```sudo usermod -a -G video $LOGNAME```  
```sudo usermod -a -G render $LOGNAME```
