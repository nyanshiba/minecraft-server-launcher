#Minecraft Server Launcher
#requires -version 7

param
(
    [parameter(mandatory)]
    [String[]]$Name,
    [parameter(mandatory)]
    [String]$Action
)

#ユーザ設定
$Settings =
@{
    #グローバル設定(既定値)
    Global =
    @{
        #RCON(推奨)を使用するか
        Rcon = $True

        #mcrconの実行ファイルパス
        MCRconPath = "/usr/local/bin/mcrcon"

        #mcrcon引数
        MCRconArg = "-H my.minecraft.server -p password -w 5"

        #実行ファイルのパス
        File = "/usr/bin/screen"

        #JVM引数 値は各環境のRAMの量、CPUコア数に見合った値にする
        Arg = ""

        #WorkingDirectoryの場所を指定する ここがカレントディレクトリの状態でFile、Argのプロセスが実行される
        Dir = ""

        #Windowsのみ ProcessWindowStyleを指定する(Hidden、Maximized、Minimized、Normal)
        Window = 'Minimized'

        #Webhook時のusername(Discordのみ)
        UserName = "Cloud Compute CBWLab"

        #icon
        Icon = "https://cdn.discordapp.com/emojis/604360349461774336.png"

        #Webhook Url
        hookUrl = 'https://discordapp.com/api/webhooks/XXXXXXXXXX' #Project:CBW server-info
    }
    #各サーバ毎の設定(既定値を上書き)
    Profiles =
    @(
        #
        @{
            Name = "CBWLab"
            #Rcon = $True
            MCRconArg = "-H 127.0.0.1 -P 25575 -p ThisIsNotARealPassword -w 5"
            #File = "/usr/bin/screen"
            Arg = "-DmS CBWLab /usr/lib/jvm/java-1.8.0-openjdk-amd64/bin/java -server -Xms4G -Xmx4G -XX:MaxNewSize=1G -XX:MetaspaceSize=1G -XX:MaxMetaspaceSize=1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=6 -XX:ConcGCThreads=6 -XX:+DisableExplicitGC -jar fabric.jar"
            Dir = "/root/Servers/CBWLab"
            #Window = 'Minimized'
            #UserName = "Cloud Compute CBWLab"
            Icon = "https://cdn.discordapp.com/emojis/604356790137782363.png"
            #hookUrl = 'https://discordapp.com/api/webhooks/XXXXXXXXXX'
        }
        @{
            Name = "CBWSnap"
            MCRconArg = "-H 127.0.0.1 -P 25574 -p ThisIsNotARealPassword -w 5"
            Arg = "-DmS CBWSnap /usr/bin/java -server -Xms7G -Xmx7G -XX:MaxNewSize=1792M -XX:MetaspaceSize=1792M -XX:MaxMetaspaceSize=1792M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=6 -XX:ConcGCThreads=6 -XX:+DisableExplicitGC -jar server.jar --forceUpgrade --eraseCache"
            Dir = "/root/Servers/CBWSnap"
            Icon = "https://cdn.discordapp.com/emojis/604360324212326421.png"
        }
        #
        @{
            UserName = "Dedicated CBWSurvival"
            Name = "CBWSurvival"
            MCRconArg = "-H 127.0.0.1 -P 25575 -p ThisIsNotARealPassword -w 5"
            Arg = "-DmS CBWSurvival /usr/bin/java -server -Xms7G -Xmx7G -XX:MaxNewSize=1792M -XX:MetaspaceSize=1792M -XX:MaxMetaspaceSize=1792M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:+DisableExplicitGC -jar server.jar"
            Dir = "/root/Servers/CBWSurvival"
        }
    )
}

#Webhook関数
function Send-Webhook
{
    param
    (
        [Hashtable]$Profile,
        [String]$Command,
        [Bool]$Webhook,
        [Bool]$Success
    )

    if ($Null -eq $Profile.hookurl -Or !$Webhook)
    {
        return
    }

    if ($IsLinux)
    {
        #screenプロセス一覧を投稿内容に追加
        foreach ($line in /usr/bin/screen -ls)
        {
            switch ([Regex]::Split($line, '\t|\.')[2])
            {
                {$Null -ne $_ -And '' -ne $_}
                {
                    [String]$Running += "$_`n"
                }
            }
        }
    }
    elseif ($IsWindows)
    {
        #プロセス一覧から$Settings.Profiles.Nameに該当するウィンドウを探し、投稿内容に追加
        [String]$Running = (Get-Process | Where-Object {$_.MainWindowTitle -in $Settings.Profiles.Name}).MainWindowTitle
    }
    if ("" -eq $Running)
    {
        $Running = "null"
    }

    #server.propertiesから設定の一部を取得
    $ServerProperties = Get-Content ./server.properties | Where-Object {$_ -match 'view-distance|level-name|server-port'} | Out-String
    if ("" -eq $ServerProperties)
    {
        $ServerProperties = "null"
    }

    if ($Profile.hookUrl -match "discord")
    {
        Write-Output "Webhook: Discord"
        $payload =
        [PSCustomObject]@{
            username = $Profile.UserName
            embeds =
            @(
                @{
                    title = "msl.ps1"
                    description = "Minecraft Server Launcher"
                    color = 0x274a7c
                    thumbnail =
                    @{
                        url = $Profile.Icon
                    }
                    fields =
                    @(
                        @{
                            name = "Profile Name"
                            value = $Profile.Name
                            inline = 'true'
                        },
                        @{
                            name = "Command"
                            value = $Command
                            inline = 'true'
                        },
                        @{
                            name = "Success"
                            value = $Success
                            inline = 'true'
                        },
                        @{
                            name = "Running"
                            value = $Running
                            inline = 'true'
                        },
                        @{
                            name = "server.properties"
                            value = $ServerProperties
                            inline = 'true'
                        }
                    )
                }
            )
        }
    }
    elseif ($Profile.hookUrl -match "slack")
    {
        Write-Output "Webhook: Slack"
        $payload = [PSCustomObject]@{
            text = $Content
            #usernameはSlack側で設定する
        }
    }
    Invoke-RestMethod -Uri $Profile.hookUrl -Method Post -Headers @{ "Content-Type" = "application/json" } -Body ([System.Text.Encoding]::UTF8.GetBytes(($payload | ConvertTo-Json -Depth 5)))
}

#プロセス起動関数
function Invoke-Process
{
    param
    (
        [Hashtable]$Profile,
        [Bool]$Webhook = $True
    )
    Write-Output "Invoke-Process"

    #param一覧
    <#
    (Get-Command -Name $MyInvocation.MyCommand).Parameters.Keys | ForEach-Object {
        Get-Variable -Name $_ -ErrorAction SilentlyContinue
    }
    #>
    
    #カレントディレクトリ
    Set-Location $Profile.Dir -ErrorAction SilentlyContinue

    #Process
    $ps = New-Object System.Diagnostics.Process
    $ps.StartInfo.Filename = $Profile.File
    $ps.StartInfo.Arguments = $Profile.Arg
    $ps.StartInfo.WorkingDirectory = $Profile.Dir
    if ($IsWindows)
    {
        $ps.StartInfo.WindowStyle = $Profile.Window
    }
    try
    {
        $Null = $ps.Start()
    }
    catch
    {
        #Webhook(例外)
        Send-Webhook -Profile $Profile -Command 'start' -Webhook $Webhook -Success $False
        #関数を抜ける
        throw "Exception: Failed to start the server"
    }
    #WindowsではMainWindowTitleを設定する
    if ($IsWindows)
    {
        #MainWindowHandleが設定されるまで待つ
        while ($ps.MainWindowHandle -eq 0)
        {
            Start-Sleep -Milliseconds 100
        }
        #MainWindowTitleを$Profile.Nameに
        $Null = [Win32API]::SetWindowText($ps.MainWindowHandle, $Profile.Name)
    }
    #Webhook
    Send-Webhook -Profile $Profile -Command 'start' -Webhook $Webhook -Success $True
}

#コマンド送信関数
function Send-CommandToMinecraftConsole
{
    param
    (
        [Hashtable]$Profile,
        [String]$Command,
        [Bool]$Webhook = $True
    )

    Write-Output "Send-CommandToMinecraftConsole $Command"

    #カレントディレクトリ
    Set-Location $Profile.Dir -ErrorAction SilentlyContinue
    
    if ($Profile.Rcon)
    {
        #Rconが有効ならmcrconに引数を渡す(同期実行でTerminal操作対応)
        Start-Process -FilePath "$($Profile.MCRconPath)" -ArgumentList "$($Profile.MCRconArg)","`"$Command`"" -Wait -NoNewWindow
    }
    elseif (!$Profile.Rcon)
    {
        #Rconが無効なら、Linuxではscreen、WindowsではPostMessageを使う
        if ($IsLinux)
        {
            /usr/bin/screen -p 0 -S "$($Profile.Name)" -X eval "stuff '$Command'\\015"
        }
        elseif ($IsWindows)
        {
            #処理するプロセスのMainWindowHandleをMainWindowTitleを参照して見つける
            $hwnd = (Get-Process | Where-Object {$_.MainWindowTitle -eq "$($Profile.Name)"}).MainWindowHandle

            #PostMassageでBackgroundWindowであってもキーを送る
            ($Command).ToCharArray() | ForEach-Object -Process {
                $Null = [Win32API]::PostMessage($hwnd, 0x0100, [Win32API]::VkKeyScan("$_"), 0)
            } -End {
                #Enter
                $Null = [Win32API]::PostMessage($hwnd, 0x0100, 0x0D, 0)
            }
        }
    }
    if (!$?)
    {
        #Webhook(例外)
        Send-Webhook -Profile $Profile -Command $Command -Webhook $Webhook -Success $False
        #関数を抜ける
        throw "Exception: Command execution failed"
    }
    #Webhook
    Send-Webhook -Profile $Profile -Command $Command -Webhook $Webhook -Success $True

    #latest.log
    Start-Sleep -Seconds 1
    Get-Content ./logs/latest.log | Select-Object -Last 1
}

#メインルーチン
#Windowsの場合.NETクラスを定義する
if ($IsWindows)
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
}

#プロセスリストからスクリプトに渡された引数に含まれるもののみを取得
foreach ($profile in ($Settings.Profiles | Where-Object {$_.Name -in $Name}))
{
    #省略した設定項目を補完する
    foreach ($Key in $Settings.Global.Keys)
    {
        if (!$profile.Contains($Key))
        {
            $profile.Add($Key, $Settings.Global.$Key)
        }
    }

    $profile

    #起動・停止関数を呼ぶ
    switch ($Action)
    {
        "start"
        {
            Invoke-Process -Profile $profile
        }
        "stop"
        {
            Send-CommandToMinecraftConsole -Profile $profile -Command "say This server will stop after 10 seconds." -Webhook $False
            Start-Sleep -Seconds 10
            Send-CommandToMinecraftConsole -Profile $profile -Command "stop"
        }
        "faststop"
        {
            Send-CommandToMinecraftConsole -Profile $profile -Command "stop"
        }
        "restart"
        {
            Send-CommandToMinecraftConsole -Profile $profile -Command "say This server will restart after 10 seconds." -Webhook $False
            Start-Sleep -Seconds 10
            Send-CommandToMinecraftConsole -Profile $profile -Command "stop"
            Start-Sleep -Seconds 5
            Invoke-Process -Profile $profile
        }
        "fastrestart"
        {
            Send-CommandToMinecraftConsole -Profile $profile -Command "stop"
            Start-Sleep -Seconds 5
            Invoke-Process -Profile $profile
        }
        "t"
        {
            if ($profile.Rcon)
            {
                Send-CommandToMinecraftConsole -Profile $profile -Command "-t" -Webhook $False
            }
            elseif (!$profile.Rcon)
            {
                throw "Exception: Please enable Rcon if you want to use Rcon Terminal"
            }
        }
        default
        {
            Send-CommandToMinecraftConsole -Profile $profile -Command "$_" -Webhook $False
        }
    }
}
