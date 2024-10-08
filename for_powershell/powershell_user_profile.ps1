# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/grandpa-style.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/paradox.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression


# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Import-module posh-git

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow_2.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView

# EditMode Emacs 標準のタブ補完
Set-PSReadLineKeyHandler -Key Tab -Function Complete
# メニュー補完に変更
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Import-Module z
# Import-Module ZLocation

# Fzf
Import-Module PSFzf
$env:FZF_DEFAULT_OPTS = "--layout=reverse --border"
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias l ls
Set-Alias ll ls
Set-Alias lt tree
Set-Alias cat Get-Content
Set-Alias grep Select-String
# Set-Alias cp Copy-Item
Set-Alias mv Move-Item
Set-Alias rm Remove-Item
Set-Alias man Get-Help

function open {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        # ファイルやディレクトリが存在する場合、それを開く
        Start-Process $Path
    } elseif ($Path -match "^https?:\/\/") {
        # URL が指定された場合、それをブラウザで開く
        Start-Process $Path
    } else {
        Write-Host "指定されたパスが存在しません: $Path"
    }
}

function touch { New-Item -ItemType File -Name ($args -join ' ') }

function la {ls -Force}
function lla {ls -Force}

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function gf {
    $path = ghq list | fzf
    if ($LastExitCode -eq 0) {
        Set-Location "$(ghq root)\$path"
    }
}

# 実行後入力待ちになるため、AcceptLine を実行する
Set-PSReadLineKeyHandler -Chord 'Ctrl+g' -ScriptBlock { gf; [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() }
Set-PSReadLineKeyHandler -Chord 'Ctrl+l' -ScriptBlock { Invoke-FuzzyZLocation; [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() }