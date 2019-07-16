## TL;DR
Minecraft Server Launcher(msl.ps1)は、Linux・Windowsに対応したサーバ管理スクリプトです。  

- 複数のサーバの引数やディレクトリを一括で管理できるよ。  
- Webhookを使って、DiscordやSlackに通知を送れるよ。  
- サーバの起動だけでなく、`say`コマンドによるアナウンスの後、`stop`コマンドで正しくサーバを停止できるよ。  
- Windows環境でも`save-all flush`をバックアップの直前に呼び出し、サーバを停止せずにより確実なバックアップを取る用途にも使用できるよ。  

## 使い方
まずはメモ帳やサクラエディタを使っているなら**VSCodeをインストール**して下さい。  
一括修正や正確なシンタックスハイライトが無いと、以下の工程は困難です。  
https://code.visualstudio.com/

### Linux
Linuxの場合はPowerShell Coreをインストールする必要があります。  
https://docs.microsoft.com/ja-jp/powershell/scripting/install/installing-powershell-core-on-linux  

スクリプトを拡張子.ps1、**文字コードはUTF8**で保存し、スクリプト内の`#ユーザ設定`を参考に設定します。  

sh内で実行する場合の例。  
```sh
# CBWSurvivalを起動(msl.ps1がカレントディレクトリにある場合)
pwsh msl.ps1 CBWSurvival start
pwsh msl.ps1 -Name "CBWSurvival" -Action "start"

# CBWSurvivalを停止
pwsh msl.ps1 CBWSurvival stop

# CBWSurvivalを再起動
pwsh msl.ps1 CBWSurvival restart
```

```sh
# 現在起動しているサーバを確認(例)
screen -ls

# Minecraftサーバのコンソールを覗く(アタッチ)
screen -r CBWSurvival

# (誰かが既にアタッチしている場合)重複アタッチ
screen -x CBWSurvival

# 出る
Ctrl-A, Ctrl-D
```

pwsh内で実行すれば、複数サーバに同じActionを渡すことができます。  
```powershell
./msl.ps1 CBWSurvival,CBWLab1,CBWSpigot start
```

### Windows
Windowsの場合はPowerShell Core(pwsh.exe)等を使用せず、Windows PowerShellである必要があります。  
また、Windowsの仕様によりこのスクリプトが動作する瞬間にキー操作があると正常に動作しません。本格運用時はWSL、Linuxを使用することをオススメします(PostMessageを使用している、もっと良い方法があるなら教えて)。  

スクリプトを拡張子.ps1、**文字コードはShift-JIS(ANSI)**で保存し、スクリプト内の`#ユーザ設定`を参考に設定します。  

`Win`-`R` `powershell`でWindows PowerShellを起動します。  
```powershell
# CBWSurvivalを起動(msl.ps1がカレントディレクトリにある場合)
.\msl.ps1 CBWSurvival start
.\msl.ps1 -Name "CBWSurvival" -Action "start"

# 複数サーバを起動
.\msl.ps1 CBWSurvival,CBWLab1,CBWSpigot start

# CBWSurvivalを停止
.\msl.ps1 CBWSurvival stop

# CBWSurvivalを再起動
.\msl.ps1 CBWSurvival restart
```
```powershell
# 現在起動しているサーバを確認(例)
Get-Process java | Select-Object Id,MainWindowTitle,StartTime
```

コマンドプロンプトで実行する場合は以下のように。  
```cmd
powershell .\msl.ps1 CBWSurvival start
powershell .\msl.ps1 CBWSurvival,CBWLab1,CBWSpigot start
```
