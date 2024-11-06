## DeepLabCutをAppleSiliconのMACで使うためのセットアップ
## Python環境のセットアップ
  - CondaでPython3.9の環境を用意する
## Ver2.2LTS
- Tensorflowのセットアップ
  - AppleSiliconに対応したバージョンのセットアップを行う
  - 2.10あたりを入れる

## Ver2.3.3
- GitかGHQでリポジトリをクローンする
- 次のコマンドで、環境設定ファイルから環境ごとインストールする
    ```
    conda env create -f conda-environments/DEEPLABCUT_M1.yaml
    ```
