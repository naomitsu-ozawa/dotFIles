#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\eutro\miniconda3\Scripts\conda.exe") {
    (& "C:\Users\eutro\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-module posh-git

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression

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

Import-Module ZLocation

# Fzf
Import-Module PSFzf
$env:FZF_DEFAULT_OPTS = "--layout=reverse --border"
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias lt tree

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
