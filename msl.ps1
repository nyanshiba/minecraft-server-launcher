#190716
#Minecraft Server Launcher
param
(
    [parameter(mandatory)]
    [String[]]$Name, #pwshの場合Arrayの挙動が変？
    [parameter(mandatory)]
    [String]$Action
)

#ユーザ設定
$Settings =
@{
    #グローバル設定
    Global =
    @{
        #実行ファイルのパス
        File = "/usr/bin/screen"
        #JVM引数 値は各環境のRAMの量、CPUコア数に見合った値にする
        Arg = ""
        #WorkingDirectoryの場所を指定する ここがカレントディレクトリの状態でFile、Argのプロセスが実行される
        Dir = ""
        #Windowsのみ ProcessWindowStyleを指定する(Hidden、Maximized、Minimized、Normal)
        Window = 'Minimized'
        #サーバ毎のオペレーティングシステムを指定する(Linux:screen、Windows:.NET PostMessage)
        OS = "Linux"
        #Webhook時のusername(Discordのみ)
        #UserName = "$(Split-Path $PSCommandPath -Leaf)"
        UserName = "OkanServer"
        #Webhook Url
        hookUrl = 'https://discordapp.com/api/webhooks/XXXXXXXXXX' #Project:CBW server-info
    }
    #各サーバ毎の設定
    InvokeList =
    @(
        #Windows Local
        #190713
        @{
            #このスクリプトに引数を渡すときのサーバ名 Linuxではscreen名、WindowsではMainWindowTitleになる
            Name = "Test1"
            File = "C:\jdk-12.0.1\bin\java.exe"
            Arg = "-server -Xms2G -Xmx2G -XX:MaxNewSize=512M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=512M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=12 -XX:ConcGCThreads=12 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "C:\Minecraft\Test1"
            OS = "Windows"
            UserName = "Local"
            hookUrl = 'https://discordapp.com/api/webhooks/XXXXXXXXXX' #External HDD test
        }
        @{
            Name = "Test2"
            File = "C:\jdk-12.0.1\bin\java.exe"
            Arg = "-server -Xms2G -Xmx2G -XX:MaxNewSize=512M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=512M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=12 -XX:ConcGCThreads=12 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "C:\Minecraft\Test2"
            Window = 'Minimized'
            OS = "Windows"
            UserName = "Local"
            hookUrl = 'https://discordapp.com/api/webhooks/XXXXXXXXXX' #External HDD test
        }
        #Linux OkanServer
        #190716
        @{
            Name = "CBWSurvival"
            Arg = "-DmS CBWSurvival /usr/bin/java -server -Xms12G -Xmx12G -XX:MaxNewSize=3G -XX:MetaspaceSize=3G -XX:MaxMetaspaceSize=3G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "/home/minecraft/Servers/CBWSurvival"
        }
        @{
            Name = "CBWLab2_SeaLab"
            Arg = "-DmS CBWLab2_SeaLab /usr/bin/java -server -Xms4G -Xmx4G -XX:MaxNewSize=1024M -XX:MetaspaceSize=1024M -XX:MaxMetaspaceSize=1024M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "/home/minecraft/Servers/CBWLab2_SeaLab"
            #Dir = "/root/Servers/CBWLab2_SeaLab"
            #UserName = "Vultr"
        }
        @{
            Name = "CBWLab2_OldLab"
            Arg = "-DmS CBWLab2_OldLab /usr/bin/java -server -Xms4G -Xmx4G -XX:MaxNewSize=1024M -XX:MetaspaceSize=1024M -XX:MaxMetaspaceSize=1024M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "/home/minecraft/Servers/CBWLab2_OldLab"
            #Dir = "/root/Servers/CBWLab2_OldLab"
            #UserName = "Vultr"
        }
        @{
            Name = "CBWSnap"
            Arg = "-DmS CBWSnap /usr/bin/java -server -Xms4G -Xmx4G -XX:MaxNewSize=1024M -XX:MetaspaceSize=1024M -XX:MaxMetaspaceSize=1024M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "/home/minecraft/Servers/CBWSnap"
            #Dir = "/root/Servers/CBWSnap"
            #UserName = "Vultr"
        }
        @{
            Name = "CBWMTest"
            Arg = "-DmS CBWMTest /usr/bin/java -server -Xms4G -Xmx4G -XX:MaxNewSize=1024M -XX:MetaspaceSize=1024M -XX:MaxMetaspaceSize=1024M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "/home/minecraft/Servers/CBWMTest"
            #Dir = "/root/Servers/CBWMTest"
            #UserName = "Vultr"
        }
        @{
            Name = "CBWSTest"
            Arg = "-DmS CBWSTest /usr/bin/java -server -Xms12G -Xmx12G -XX:MaxNewSize=3G -XX:MetaspaceSize=3G -XX:MaxMetaspaceSize=3G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Dir = "/home/minecraft/Servers/CBWSTest"
            #Dir = "/root/Servers/CBWSTest"
            #UserName = "Vultr"
        }
        @{
            Name = "CBWSpigot"
            Arg = "-DmS CBWSpigot /usr/bin/java -server -Xms2G -Xmx2G -XX:MaxNewSize=512M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=512M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar spigot.jar nogui"
            #Arg = "-DmS CBWSpigot /usr/bin/java -server -Xms12G -Xmx12G -XX:MaxNewSize=3G -XX:MetaspaceSize=3G -XX:MaxMetaspaceSize=3G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar spigot.jar nogui"
            Dir = "/home/minecraft/Servers/CBWSpigot"
            #Dir = "/root/Servers/CBWSpigot"
            #UserName = "Vultr"
        }
        #Linux Vultr
        #190716
        @{
            Name = "CBWLab1"
            #Arg = "-DmS CBWLab1 /usr/bin/java -server -Xms4G -Xmx4G -XX:MaxNewSize=1024M -XX:MetaspaceSize=1024M -XX:MaxMetaspaceSize=1024M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=8 -XX:+DisableExplicitGC -jar server.jar nogui"
            Arg = "-DmS CBWLab1 /usr/bin/java -server -Xms3G -Xmx3G -XX:MaxNewSize=768M -XX:MetaspaceSize=768M -XX:MaxMetaspaceSize=768M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:+DisableExplicitGC -jar server.jar"
            #Dir = "/home/minecraft/Servers/CBWLab1"
            Dir = "/root/Servers/CBWLab1"
            UserName = "Vultr"
        }
        @{
            Name = "BungeeCord"
            Arg = "-DmS BungeeCord /usr/bin/java -server -Xms128M -Xmx128M -XX:MaxNewSize=32M -XX:MetaspaceSize=32M -XX:MaxMetaspaceSize=32M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:+DisableExplicitGC -jar BungeeCord.jar"
            Dir = "/root/Servers/BungeeCord"
            UserName = "Vultr"
        }
        @{
            Name = "OpenLab"
            Arg = "-DmS OpenLab /usr/bin/java -server -Xms3G -Xmx3G -XX:MaxNewSize=768M -XX:MetaspaceSize=768M -XX:MaxMetaspaceSize=768M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:+DisableExplicitGC -jar spigot-1.13.2.jar"
            Dir = "/root/Servers/OpenLab"
            UserName = "Vultr"
        }
        @{
            Name = "OpenEvent"
            Arg = "-DmS OpenEvent /usr/bin/java -server -Xms3G -Xmx3G -XX:MaxNewSize=768M -XX:MetaspaceSize=768M -XX:MaxMetaspaceSize=768M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:+DisableExplicitGC -jar server.jar"
            Dir = "/root/Servers/OpenEvent"
            UserName = "Vultr"
        }
    )
}

#Webhook関数
function Send-Webhook
{
    param
    (
        [String]$Content,
        [String]$OS,
        [String]$UserName,
        [String]$hookUrl = $Settings.Global.hookUrl
    )
    if ($Null -eq $hookUrl)
    {
        return
    }
    if ($OS -eq 'Linux')
    {
        #screenプロセス一覧を投稿内容に追加
        $Content += "`n``````$(/usr/bin/screen -ls | Out-String)``````"
    } elseif ($OS -eq 'Windows')
    {
        #プロセス一覧から$Settings.InvokeList.Nameに該当するウィンドウを探し、投稿内容に追加
        $Content += "`n``````$(Get-Process | Where-Object {$_.MainWindowTitle -in $Settings.InvokeList.Name} | Select-Object Id,MainWindowTitle,StartTime | Out-String)``````"
    }
    if ($hookUrl -match "discord")
    {
        Write-Output "Webhook: Discord"
        $payload = [PSCustomObject]@{
            content = $Content
            username = $UserName
        }
    } elseif ($hookUrl -match "slack")
    {
        Write-Output "Webhook: Slack"
        $payload = [PSCustomObject]@{
            text = $Content
            #usernameはSlack側で設定する
        }
    }
    Invoke-RestMethod -Uri "$hookUrl" -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes(($payload | ConvertTo-Json)))
}

#プロセス停止関数
function Invoke-StopProcess
{
    param
    (
        [Hashtable]$Process
    )
    Write-Output "Invoke-StopProcess"
    #アナウンス
    if ($Process.OS -eq 'Linux')
    {
        #\\040でスペース
        /usr/bin/screen -p 0 -S "$($Process.Name)" -X eval 'stuff "say\\040The\\040server\\040shuts\\040down\\040after\\04010\\040seconds."\\015'
    } elseif ($Process.OS -eq 'Windows')
    {
        <#
        ###この方法はForegroundWindowを奪うので却下###
        #現在のForegroundWindowを再取得
        $DefaultWindow = [GetForeground]::GetForegroundWindow()
        #ForegroundWindowを該当するプロセスのMainWindowHandleに
        $Null = [SetForeground]::SetForegroundWindow((Get-Process | Where-Object {$_.MainWindowTitle -eq "$($Process.Name)"}).MainWindowHandle)
        #ForegroundWindowにsayコマンドを送る
        [System.Windows.Forms.SendKeys]::SendWait("say The server shuts down after 10 seconds.{ENTER}")
        #ForegroundWindowを戻す
        $Null = [SetForeground]::SetForegroundWindow($DefaultWindow)
        #>

        #処理するプロセスのMainWindowHandleをMainWindowTitleを参照して見つける
        $hwnd = (Get-Process | Where-Object {$_.MainWindowTitle -eq "$($Process.Name)"}).MainWindowHandle
        #PostMassageでBackgroundWindowであってもキーを送る
        ("say The server shuts down after 10 seconds.").ToCharArray() | ForEach-Object -Process {
            $Null = [Win32API]::PostMessage($hwnd, 0x0100, [Win32API]::VkKeyScan("$_"), 0)
        } -End {
            #Enter
            $Null = [Win32API]::PostMessage($hwnd, 0x0100, 0x0D, 0)
        }
    }
    Write-Output "Wait 10 Sec..."
    Start-Sleep -Seconds 10
    #停止
    if ($Process.OS -eq 'Linux')
    {
        /usr/bin/screen -p 0 -S "$($Process.Name)" -X eval 'stuff "stop"\\015'
    } elseif ($Process.OS -eq 'Windows')
    {
        $hwnd = (Get-Process | Where-Object {$_.MainWindowTitle -eq "$($Process.Name)"}).MainWindowHandle
        ("stop").ToCharArray() | ForEach-Object -Process {
            $Null = [Win32API]::PostMessage($hwnd, 0x0100, [Win32API]::VkKeyScan("$_"), 0)
        } -End {
            #Enter
            $Null = [Win32API]::PostMessage($hwnd, 0x0100, 0x0D, 0)
        }
    }
    if (!$?)
    {
        Write-Output "Exception."
        #Webhook(例外)
        Send-Webhook -Content ":exclamation:**`Exception` $($Process.Name)**" -OS $Process.OS -UserName $Process.UserName -hookUrl $Process.hookUrl
        #関数を抜ける
        return
    }
    #Webhook
    Send-Webhook -Content ":x:**`Stopped` $($Process.Name)**" -OS $Process.OS -UserName $Process.UserName -hookUrl $Process.hookUrl
}

#プロセス起動関数
function Invoke-StartProcess
{
    param
    (
        [Hashtable]$Process
    )
    Write-Output "Invoke-StartProcess"

    #param一覧
    <#
    (Get-Command -Name $MyInvocation.MyCommand).Parameters.Keys | ForEach-Object {
        Get-Variable -Name $_ -ErrorAction SilentlyContinue
    }
    #>
    
    #カレントディレクトリ
    Set-Location $Process.Dir
    #Process
    $ps = New-Object System.Diagnostics.Process
    $ps.StartInfo.Filename = $Process.File
    $ps.StartInfo.Arguments = $Process.Arg
    $ps.StartInfo.WorkingDirectory = $Process.Dir
    if ($Process.OS -eq 'Windows')
    {
        $ps.StartInfo.WindowStyle = $Process.Window
    }
    try
    {
        $Null = $ps.Start()
    } catch
    {
        Write-Output "Exception."
        #Webhook(例外)
        Send-Webhook -Content ":exclamation:**`Exception` $($Process.Name)**" -OS $Process.OS -UserName $Process.UserName -hookUrl $Process.hookUrl
        #関数を抜ける
        return
    }
    #WindowsではMainWindowTitleを設定する
    if ($Process.OS -eq 'Windows')
    {
        #MainWindowHandleが設定されるまで待つ
        while ($ps.MainWindowHandle -eq 0)
        {
            Start-Sleep -Milliseconds 100
        }
        #MainWindowTitleを$Process.Nameに
        $Null = [Win32API]::SetWindowText($ps.MainWindowHandle, $Process.Name)
    }
    #Webhook
    Send-Webhook -Content ":o:**`Running` $($Process.Name)**" -OS $Process.OS -UserName $Process.UserName -hookUrl $Process.hookUrl
}

#save-all flush関数
function Invoke-SaveAllFlush
{
    param
    (
        [Hashtable]$Process
    )
    Write-Output "Invoke-SaveAllFlush"
    if ($Process.OS -eq 'Linux')
    {
        #\\040でスペース
        /usr/bin/screen -p 0 -S "$($Process.Name)" -X eval 'stuff "save-all\\040flush"\\015'
    } elseif ($Process.OS -eq 'Windows')
    {
        $hwnd = (Get-Process | Where-Object {$_.MainWindowTitle -eq "$($Process.Name)"}).MainWindowHandle
        ("save-all flush").ToCharArray() | ForEach-Object -Process {
            $Null = [Win32API]::PostMessage($hwnd, 0x0100, [Win32API]::VkKeyScan("$_"), 0)
        } -End {
            #Enter
            $Null = [Win32API]::PostMessage($hwnd, 0x0100, 0x0D, 0)
        }
    }
}

#メインルーチン
#プロセスリストからスクリプトに渡された引数に含まれるもののみを取得
$Invoke = $Settings.InvokeList | Where-Object {$_.Name -in $Name}
#Windowsが使用される場合.NETクラスを定義する
if ('Windows' -in $Invoke.OS -Or ($Null -in $Invoke.OS -And $Settings.Global.OS -eq 'Windows'))
{
    Write-Output "using .NET Class"
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32API {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr PostMessage(int hWnd, UInt32 Msg, int wParam, int lParam);
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern bool SetWindowText(IntPtr hwnd, String lpString);
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int VkKeyScan(char ch);
    }
"@
    if ($PSVersionTable.PSVersion.Major -eq 6)
    {
        return "例外: Windowsで使用する場合はWindows PowerShellを使用してください。"
    }
}
$Invoke | ForEach-Object {
    #省略した設定項目をグローバル設定$Settings.Globalから今のループ$Settings.InvokeListへ補完する
    foreach ($Key in $Settings.Global.Keys)
    {
        if (!$_.Contains($Key))
        {
            $_.Add($Key, $Settings.Global.$Key)
        }
    }
    $_
    #restartのために、stop->startの順
    if ($Action -match "stop|restart")
    {
        Invoke-StopProcess -Process $_
        Start-Sleep -Seconds 3 #ﾊﾞﾊﾞｯといくのが心配だったので
    }
    if ($Action -match "start|restart")
    {
        Invoke-StartProcess -Process $_
    }
    if ($Action -eq "save")
    {
        Invoke-SaveAllFlush -Process $_
    }
}
