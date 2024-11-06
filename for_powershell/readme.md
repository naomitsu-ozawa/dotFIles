# Windowsの開発環境（うろ覚えバージョン）
---
## 必要なソフトウェアのインストール
### install git ghq z fzf
GHQ周りの必要なものを入れる  
git ghq z fzf をScoopからインストールする
```
scoop install git ghq z fzf
```

### install Terminal icons
ターミナル用のアイコンをインストールする
```
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
```
  
### install z
zをインストール
```
Install-Module -Name z -Force
```
  
### install psreadline autocompletion
psreadline autocompletionをインストール
```
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
```

### install PsFzf
Fzfをインストール
```
Install-Module -Name PSFzf -Scope CurrentUser -Force
```

### Oh-My-Poshをインストール
https://ohmyposh.dev/docs/installation/windows  
ここを参考に、Windows版をインストールする。

### Profileの編集
プロファイルの確認
```
$PROFILE
```
output 例
```
C:\Users\*****\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

これを実行して表示されるパスが現在実行されているPowerShellのプロファイルになる  
このプロファイルをVSCodeなどのテキストエディターで開いて、[powershell_user_profile.ps1](powershell_user_profile.ps1)の内容に書き換える

---

## アップデート方法
### Update PSModule
```
Get-InstalledModule #インストールされているモジュールの確認
Update-Module #すべてのモジュールのアップデート
```

### Update scoop application
```
scoop update *
```

### Wingetでインストールしたアプリの更新
```
winget update -r
```
- アップデートから除外したい場合
```
winget pin add [app id]
```
