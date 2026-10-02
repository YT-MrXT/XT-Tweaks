#Requires -Version 5.1
<#
.SYNOPSIS   XT Optimizer - suite de otimização para Windows 10/11
.NOTES      Requer privilégios de Administrador. Logs e backups em %ProgramData%\XTOptimizer
#>
$ProgressPreference = 'SilentlyContinue'
Write-Host 'XT Optimizer a iniciar...' -ForegroundColor Magenta
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

#region Bootstrap
$script:Version = '1.2.0'
$script:Dir     = Join-Path $env:ProgramData 'XTOptimizer'
New-Item $script:Dir -ItemType Directory -Force | Out-Null
$LogoB64 = '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'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ($PSCommandPath) { Start-Process powershell -Verb RunAs -WindowStyle Hidden -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" }
    else { [Windows.MessageBox]::Show('Abre o PowerShell como Administrador e executa novamente.', 'XT Optimizer') | Out-Null }
    return
}
#endregion

#region UI shell
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="XT Optimizer" Width="1080" Height="720" WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" ResizeMode="CanMinimize" FontFamily="Segoe UI" Foreground="#EDE6F2">
  <Window.Resources>
    <Style x:Key="Nav" TargetType="Button">
      <Setter Property="Foreground" Value="#9A8AA8"/><Setter Property="Background" Value="Transparent"/><Setter Property="FontSize" Value="14"/><Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="8" Padding="14,10" Margin="0,2"><ContentPresenter HorizontalAlignment="Left"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#261633"/><Setter Property="Foreground" Value="#FFFFFF"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter></Style>
    <Style x:Key="Pri" TargetType="Button">
      <Setter Property="Foreground" Value="#FFFFFF"/><Setter Property="Background" Value="#9B2FB8"/><Setter Property="FontWeight" Value="SemiBold"/><Setter Property="FontSize" Value="13.5"/><Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="8" Padding="22,11"><ContentPresenter HorizontalAlignment="Center"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#B84FD6"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter></Style>
    <Style x:Key="Sec" TargetType="Button" BasedOn="{StaticResource Pri}">
      <Setter Property="Foreground" Value="#D4C6DF"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="#1F1329" CornerRadius="8" Padding="22,11" BorderBrush="#35224A" BorderThickness="1"><ContentPresenter HorizontalAlignment="Center"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#2A1A38"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter></Style>
    <Style x:Key="Win" TargetType="Button">
      <Setter Property="Foreground" Value="#9A8AA8"/><Setter Property="Width" Value="42"/><Setter Property="Height" Value="30"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="Transparent" CornerRadius="6"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#35224A"/><Setter Property="Foreground" Value="#FFFFFF"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter></Style>
  </Window.Resources>
  <Border Background="#0F0A14" CornerRadius="14" BorderBrush="#2A1A38" BorderThickness="1">
    <Grid>
      <Grid.ColumnDefinitions><ColumnDefinition Width="232"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
      <Border Background="#130C19" CornerRadius="14,0,0,14" BorderBrush="#20142A" BorderThickness="0,0,1,0">
        <DockPanel Margin="18">
          <StackPanel DockPanel.Dock="Top" Orientation="Horizontal" Margin="4,6,0,26">
            <Border x:Name="Logo" Width="40" Height="40" CornerRadius="9"/>
            <StackPanel Margin="12,0,0,0" VerticalAlignment="Center">
              <TextBlock Text="XT Optimizer" FontWeight="Bold" FontSize="16"/>
              <TextBlock x:Name="Ver" FontSize="11" Foreground="#6F5F7C"/></StackPanel>
          </StackPanel>
          <TextBlock DockPanel.Dock="Bottom" Text="Cria sempre um restauro antes de alterar o sistema." TextWrapping="Wrap" FontSize="11" Foreground="#5E4F6B" Margin="6,0,0,0"/>
          <StackPanel x:Name="NavPanel"/>
        </DockPanel>
      </Border>
      <Grid Grid.Column="1" Margin="32,0,24,20">
        <Grid.RowDefinitions><RowDefinition Height="46"/><RowDefinition Height="*"/><RowDefinition Height="118"/></Grid.RowDefinitions>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
          <Button x:Name="BtnMin" Style="{StaticResource Win}" Content="&#x2013;"/><Button x:Name="BtnClose" Style="{StaticResource Win}" Content="&#x2715;"/></StackPanel>
        <Grid x:Name="Host" Grid.Row="1"/>
        <Border Grid.Row="2" Background="#0A060E" CornerRadius="10" BorderBrush="#20142A" BorderThickness="1" Margin="0,10,0,0">
          <TextBox x:Name="LogBox" Background="Transparent" BorderThickness="0" Foreground="#A8E6C1" FontFamily="Consolas" FontSize="12" IsReadOnly="True" VerticalScrollBarVisibility="Auto" Padding="12,8" TextWrapping="Wrap"/>
        </Border>
      </Grid>
    </Grid>
  </Border>
</Window>
'@
$w = [Windows.Markup.XamlReader]::Parse($xaml)
function C($n) { $w.FindName($n) }
function Brush($c) { [Windows.Media.BrushConverter]::new().ConvertFromString($c) }
function Log($m) { $l = "[$(Get-Date -f HH:mm:ss)] $m"; $b = C 'LogBox'; $b.AppendText("$l`n"); $b.ScrollToEnd(); Add-Content (Join-Path $script:Dir 'xt.log') $l -ErrorAction SilentlyContinue }

$bmp = New-Object Windows.Media.Imaging.BitmapImage
$bmp.BeginInit(); $bmp.StreamSource = New-Object IO.MemoryStream(, [Convert]::FromBase64String($LogoB64)); $bmp.CacheOption = 'OnLoad'; $bmp.EndInit(); $bmp.Freeze()
$w.Icon = $bmp
(C 'Logo').Background = New-Object Windows.Media.ImageBrush($bmp)
(C 'Ver').Text = "v$script:Version  •  Performance Suite"

$Pages = [ordered]@{}; $Builders = @{}; $NavBtns = @{}
function DoEvents { $w.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Background) }
function Add-Page($key, $label, $el) {
    $Builders[$key] = $el
    $b = New-Object Windows.Controls.Button; $b.Content = $label; $b.Style = $w.FindResource('Nav')
    $b.Add_Click({ Show-Page $key }.GetNewClosure()); (C 'NavPanel').Children.Add($b) | Out-Null; $NavBtns[$key] = $b
}
function Show-Page($key) {
    $new = $false
    if (-not $Pages.Contains($key)) {
        $e = $Builders[$key]; if ($e -is [scriptblock]) { $e = & $e }
        $e.Visibility = 'Collapsed'; (C 'Host').Children.Add($e) | Out-Null; $Pages[$key] = $e; $new = $true
    }
    foreach ($k in $Pages.Keys) { $Pages[$k].Visibility = 'Collapsed' }
    foreach ($k in $NavBtns.Keys) { $NavBtns[$k].Background = Brush 'Transparent'; $NavBtns[$k].Foreground = Brush '#9A8AA8' }
    $Pages[$key].Visibility = 'Visible'; $NavBtns[$key].Background = Brush '#261633'; $NavBtns[$key].Foreground = Brush '#D98BEF'
    if ($key -eq 'clean' -and $new) { Update-Sizes }
}
function New-Text($t, $sz = 13, $col = '#EDE6F2', $wt = 'Normal') {
    $x = New-Object Windows.Controls.TextBlock; $x.Text = $t; $x.FontSize = $sz; $x.Foreground = Brush $col; $x.FontWeight = $wt; $x.TextWrapping = 'Wrap'; $x
}
function New-Button($t, $style = 'Pri') { $b = New-Object Windows.Controls.Button; $b.Content = $t; $b.Style = $w.FindResource($style); $b }
#endregion

#region Core helpers
function Reg($p, $n, $t, $v) { reg add $p /v $n /t $t /d $v /f | Out-Null }
function Wipe($p) { Remove-Item (Join-Path $p '*') -Recurse -Force -ErrorAction SilentlyContinue }
function Backup-Registry {
    $f = Join-Path $script:Dir "backup-$(Get-Date -f yyyyMMdd-HHmmss)"; New-Item $f -ItemType Directory -Force | Out-Null; $i = 0
    foreach ($k in 'HKCU\Control Panel\Mouse', 'HKCU\Control Panel\Desktop', 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer',
        'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize', 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile',
        'HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers', 'HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl') { reg export $k "$f\$((++$i)).reg" /y | Out-Null }
    Log "Backup do registo guardado em $f"
}
$JobInit = [scriptblock]::Create('function Reg($p,$n,$t,$v){ reg add $p /v $n /t $t /d $v /f | Out-Null }; function Wipe($p){ Remove-Item (Join-Path $p ''*'') -Recurse -Force -ErrorAction SilentlyContinue }')
function Wait-JobUI($j) {
    while ($j.State -eq 'Running') { Receive-Job $j -ErrorAction SilentlyContinue | ForEach-Object { Log $_ }; DoEvents; Start-Sleep -Milliseconds 80 }
    Receive-Job $j -ErrorAction SilentlyContinue | ForEach-Object { Log $_ }
}
function Invoke-Items($Items, [switch]$Safe) {
    $parts = @()
    if ($Safe) {
        Backup-Registry
        $parts += 'try { Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue; Checkpoint-Computer -Description "XT Optimizer" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop; "Ponto de restauro solicitado." } catch { "Ponto de restauro nao criado: " + $_.Exception.Message }'
    }
    $n = 0
    foreach ($i in $Items) {
        $on = if ($i.CB) { $i.CB.IsChecked } else { $i.On }
        if ($on) { $n++; $nm = $i.N -replace "'", "''"
            $parts += ('try {{ {0} ; "OK     {1}" }} catch {{ "ERRO   {1}: " + $_.Exception.Message }}' -f $i.A.ToString(), $nm) }
    }
    if (-not $n) { Log 'Nada selecionado.'; return }
    Log 'A executar em segundo plano...'
    $j = Start-Job -InitializationScript $JobInit -ScriptBlock ([scriptblock]::Create($parts -join "`n"))
    Wait-JobUI $j
    if ($j.State -eq 'Failed') { Log "ERRO: $($j.ChildJobs[0].JobStateInfo.Reason.Message)" }
    Remove-Job $j -Force; Log "Concluído: $n ações."
}
function New-ListPage($Title, $Sub, $Items, $BtnText, [switch]$Safe) {
    $g = New-Object Windows.Controls.Grid
    foreach ($h in [Windows.GridLength]::Auto, (New-Object Windows.GridLength(1, 'Star')), [Windows.GridLength]::Auto) { $r = New-Object Windows.Controls.RowDefinition; $r.Height = $h; $g.RowDefinitions.Add($r) }
    $hd = New-Object Windows.Controls.StackPanel; $hd.Children.Add((New-Text $Title 28 '#FFFFFF' 'Bold')) | Out-Null
    $s = New-Text $Sub 13.5 '#9A8AA8'; $s.Margin = '0,4,0,14'; $hd.Children.Add($s) | Out-Null; $g.Children.Add($hd) | Out-Null
    $sv = New-Object Windows.Controls.ScrollViewer; $sv.VerticalScrollBarVisibility = 'Auto'; [Windows.Controls.Grid]::SetRow($sv, 1)
    $sp = New-Object Windows.Controls.StackPanel; $sv.Content = $sp
    foreach ($i in $Items) {
        $cb = New-Object Windows.Controls.CheckBox; $cb.IsChecked = $i.On; $cb.Padding = '8,0,0,0'; $cb.VerticalContentAlignment = 'Center'
        $st = New-Object Windows.Controls.StackPanel
        $i.TB = New-Text $i.D 12 '#7F6F8C'
        $st.Children.Add((New-Text $i.N 14 '#EDE6F2' 'SemiBold')) | Out-Null; $st.Children.Add($i.TB) | Out-Null; $cb.Content = $st; $i.CB = $cb
        $bd = New-Object Windows.Controls.Border; $bd.Background = Brush '#1A1124'; $bd.CornerRadius = 10; $bd.Padding = '14,10'; $bd.Margin = '0,0,8,8'; $bd.Child = $cb; $sp.Children.Add($bd) | Out-Null
    }
    $g.Children.Add($sv) | Out-Null
    $row = New-Object Windows.Controls.StackPanel; $row.Orientation = 'Horizontal'; $row.Margin = '0,10,0,0'; [Windows.Controls.Grid]::SetRow($row, 2)
    $b = New-Button $BtnText; $b.Add_Click({ $b.IsEnabled = $false; try { Invoke-Items $Items -Safe:$Safe; if ($Title -eq 'Limpeza') { Update-Sizes } } finally { $b.IsEnabled = $true } }.GetNewClosure()); $row.Children.Add($b) | Out-Null
    $g.Children.Add($row) | Out-Null; $g
}
#endregion

#region Hardware
$cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpu  = @(Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual' } | ForEach-Object Name) | Sort-Object { if ($_ -match 'NVIDIA|AMD|Radeon') { 0 } else { 1 } } | Select-Object -First 1
if (-not $gpu) { $gpu = 'Não detetada' }
$ram  = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$osI  = Get-CimInstance Win32_OperatingSystem
$pd   = Get-CimInstance -Namespace root\Microsoft\Windows\Storage MSFT_PhysicalDisk -ErrorAction SilentlyContinue | Select-Object -First 1
$isHDD = ($pd -and $pd.MediaType -eq 3); $hasDGPU = $gpu -match 'NVIDIA|AMD|Radeon'
$laptop = [bool](Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue)
$diskTxt = if ($pd) { "$($pd.FriendlyName) ($(if ($pd.BusType -eq 17) { 'NVMe' } elseif ($pd.MediaType -eq 3) { 'HDD' } else { 'SSD' }))" } else { 'Não detetado' }
#endregion

#region Page: Painel
$dash = New-Object Windows.Controls.ScrollViewer; $dash.VerticalScrollBarVisibility = 'Auto'
$ds = New-Object Windows.Controls.StackPanel; $dash.Content = $ds
$ds.Children.Add((New-Text 'Painel' 28 '#FFFFFF' 'Bold')) | Out-Null
$t = New-Text "$(if ($laptop) { 'Portátil' } else { 'Desktop' })  •  $($osI.Caption)" 13.5 '#9A8AA8'; $t.Margin = '0,4,0,18'; $ds.Children.Add($t) | Out-Null
$wp = New-Object Windows.Controls.WrapPanel; $ds.Children.Add($wp) | Out-Null
function New-Card($lines, $width = 300) {
    $b = New-Object Windows.Controls.Border; $b.Background = Brush '#1A1124'; $b.BorderBrush = Brush '#2E1D3B'; $b.BorderThickness = 1; $b.CornerRadius = 12; $b.Padding = 18; $b.Margin = '0,0,14,14'; $b.Width = $width
    $s = New-Object Windows.Controls.StackPanel; foreach ($l in $lines) { $l.Margin = '0,0,0,6'; $s.Children.Add($l) | Out-Null }; $b.Child = $s; $b
}
$ramNote = if ($ram -ge 16) { 'Excelente' } elseif ($ram -ge 8) { 'Suficiente' } else { 'Pouca - otimizar memória' }
foreach ($c in @(
    @('PROCESSADOR', ($cpu.Name -replace '\s+', ' '), "$($cpu.NumberOfCores) núcleos / $($cpu.NumberOfLogicalProcessors) threads"),
    @('PLACA GRÁFICA', $gpu, $(if ($hasDGPU) { 'Dedicada' } else { 'Integrada' })),
    @('MEMÓRIA RAM', "$ram GB", $ramNote),
    @('ARMAZENAMENTO', $diskTxt, $(if ($isHDD) { 'HDD - desfragmentação recomendada' } else { 'SSD - TRIM recomendado' })))) {
    $wp.Children.Add((New-Card @((New-Text $c[0] 11 '#D98BEF' 'SemiBold'), (New-Text $c[1] 15.5 '#FFFFFF' 'SemiBold'), (New-Text $c[2] 12.5 '#9A8AA8')))) | Out-Null
}
# Monitor em tempo real
$tCpu = New-Text 'CPU' 12.5 '#D4C6DF'; $tRam = New-Text 'RAM' 12.5 '#D4C6DF'; $tUp = New-Text '' 12 '#7F6F8C'
function New-Bar { $p = New-Object Windows.Controls.ProgressBar; $p.Height = 6; $p.Maximum = 100; $p.BorderThickness = 0; $p.Background = Brush '#2E1D3B'; $p.Foreground = Brush '#B84FD6'; $p }
$bCpu = New-Bar; $bRam = New-Bar
$mon = New-Card @((New-Text 'MONITOR EM TEMPO REAL' 11 '#D98BEF' 'SemiBold'), $tCpu, $bCpu, $tRam, $bRam, $tUp) 614
$wp.Children.Add($mon) | Out-Null
$timer = New-Object Windows.Threading.DispatcherTimer; $timer.Interval = [TimeSpan]::FromSeconds(3)
$timer.Add_Tick({
    if ($dash.Visibility -ne 'Visible') { return }
    try {
        $o = Get-CimInstance Win32_OperatingSystem; $c = [int](Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average
        $u = [int](100 - $o.FreePhysicalMemory / $o.TotalVisibleMemorySize * 100); $bCpu.Value = $c; $bRam.Value = $u
        $tCpu.Text = "CPU  $c%"; $tRam.Text = "RAM  $u%  ($([math]::Round(($o.TotalVisibleMemorySize - $o.FreePhysicalMemory) / 1MB, 1)) / $([math]::Round($o.TotalVisibleMemorySize / 1MB, 1)) GB)"
        $up = (Get-Date) - $o.LastBootUpTime; $tUp.Text = "Ligado há $($up.Days)d $($up.Hours)h $($up.Minutes)m"
    } catch {}
}); $timer.Start()
$qr = New-Object Windows.Controls.StackPanel; $qr.Orientation = 'Horizontal'; $qr.Margin = '0,4,0,0'
$bQuick = New-Button 'Otimização rápida'; $bLogs = New-Button 'Abrir pasta de logs e backups' 'Sec'; $bLogs.Margin = '10,0,0,0'
$qr.Children.Add($bQuick) | Out-Null; $qr.Children.Add($bLogs) | Out-Null; $ds.Children.Add($qr) | Out-Null
$bLogs.Add_Click({ Start-Process explorer.exe $script:Dir })
#endregion

#region Page: Otimizações
$Tweaks = @(
 @{N='Modo de Jogo ativo'; D='Dá prioridade ao jogo em primeiro plano.'; On=$true; A={ Reg 'HKCU\Software\Microsoft\GameBar' AutoGameModeEnabled REG_DWORD 1 }},
 @{N='Desativar Game DVR'; D='Remove a gravação em segundo plano que custa FPS.'; On=$true; A={ Reg 'HKCU\System\GameConfigStore' GameDVR_Enabled REG_DWORD 0 }},
 @{N='Agendamento de GPU por hardware (HAGS)'; D='Menos latência em GPUs dedicadas recentes. Requer reinício.'; On=$hasDGPU; A={ Reg 'HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' HwSchMode REG_DWORD 2 }},
 @{N='Prioridade para aplicações em primeiro plano'; D='Win32PrioritySeparation = 38 (ajuste usado em PCs de jogo).'; On=$true; A={ Reg 'HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl' Win32PrioritySeparation REG_DWORD 38 }},
 @{N='Desativar aceleração do rato'; D='Movimento 1:1, melhor precisão de mira.'; On=$true; A={ foreach ($n in 'MouseSpeed', 'MouseThreshold1', 'MouseThreshold2') { Reg 'HKCU\Control Panel\Mouse' $n REG_SZ 0 } }},
 @{N='Menus e arranque instantâneos'; D='Remove atrasos de menus e de apps de arranque.'; On=$true; A={ Reg 'HKCU\Control Panel\Desktop' MenuShowDelay REG_SZ 0; Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize' StartupDelayInMSec REG_DWORD 0 }},
 @{N='Efeitos visuais de desempenho'; D='Menos animações. Notório em PCs mais fracos.'; On=($ram -le 8); A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' VisualFXSetting REG_DWORD 2 }},
 @{N='Desativar transparências'; D='Poupa GPU, sobretudo integrada.'; On=(-not $hasDGPU); A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' EnableTransparency REG_DWORD 0 }},
 @{N='Bloquear apps em segundo plano'; D='Liberta RAM e CPU.'; On=($ram -le 8); A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' GlobalUserDisabled REG_DWORD 1 }},
 @{N='Rede sem limitação multimédia'; D='Remove o throttling de rede do Windows.'; On=$true; A={ Reg 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' NetworkThrottlingIndex REG_DWORD 0xffffffff }},
 @{N='Desativar Delivery Optimization'; D='O Windows deixa de partilhar a tua banda para updates.'; On=$true; A={ Reg 'HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' DODownloadMode REG_DWORD 0 }},
 @{N='Desativar sugestões e anúncios do Windows'; D='Remove dicas, apps sugeridas e anúncios no Iniciar.'; On=$true; A={ foreach ($n in 'SubscribedContent-338388Enabled', 'SubscribedContent-338389Enabled', 'SubscribedContent-353698Enabled', 'SystemPaneSuggestionsEnabled') { Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' $n REG_DWORD 0 } }},
 @{N='TRIM do SSD'; D='Mantém a velocidade de escrita do SSD.'; On=(-not $isHDD); A={ fsutil behavior set DisableDeleteNotify 0 | Out-Null }},
 @{N='Desfragmentar HDD'; D='Apenas para discos mecânicos.'; On=$isHDD; A={ defrag C: /O | Out-Null }},
 @{N='Desativar telemetria (DiagTrack)'; D='Moderado: para o serviço de telemetria da Microsoft.'; On=$false; A={ Stop-Service DiagTrack -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled }},
 @{N='Desativar hibernação'; D='Moderado: liberta espaço, perdes o Arranque Rápido.'; On=$false; A={ powercfg -h off | Out-Null }}
)
Add-Page 'tw' 'Otimizações' { New-ListPage 'Otimizações' 'Pré-selecionadas para o teu hardware. Revê antes de aplicar.' $Tweaks 'Aplicar selecionadas' -Safe }
#endregion

#region Page: Energia XT
function New-XTPlan {
    $re = '[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}'
    $null = powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>&1
    foreach ($l in (powercfg /list 2>&1 | Where-Object { "$_" -match 'XT Power Plan' })) { $m = [regex]::Match("$l", $re); if ($m.Success) { $null = powercfg /delete $m.Value 2>&1 } }
    $m = [regex]::Match((powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1 | Out-String), $re)
    if (-not $m.Success) { $m = [regex]::Match((powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1 | Out-String), $re) }
    if (-not $m.Success) { throw 'Não foi possível duplicar o plano base.' }
    $g = $m.Value
    $null = powercfg -changename $g 'XT Power Plan' 'XT Optimizer: latência mínima e desempenho máximo' 2>&1
    $ac = @('SUB_PROCESSOR', 'PROCTHROTTLEMIN', 100), @('SUB_PROCESSOR', 'PROCTHROTTLEMAX', 100), @('SUB_PROCESSOR', 'CPMINCORES', 100), @('SUB_PROCESSOR', 'SYSCOOLPOL', 1),
        @('SUB_PCIEXPRESS', 'ASPM', 0), @('SUB_DISK', 'DISKIDLE', 0), @('SUB_SLEEP', 'STANDBYIDLE', 0), @('SUB_VIDEO', 'VIDEOIDLE', 0),
        @('2a737441-1930-4402-8d77-b2bebba308a3', '48e6b7a6-50f5-4782-a5d4-53bb8f07e226', 0)
    foreach ($x in $ac) { $r = powercfg /setacvalueindex $g $x[0] $x[1] $x[2] 2>&1 | Out-String; if ($r -match 'Invalid|inv') { Log "Aviso: definição $($x[1]) não suportada neste PC." } }
    # Bateria: perfil económico para não esgotar/aquecer o portátil
    foreach ($x in @('SUB_PROCESSOR', 'PROCTHROTTLEMIN', 5), @('SUB_PROCESSOR', 'CPMINCORES', 10), @('SUB_PROCESSOR', 'SYSCOOLPOL', 0), @('SUB_PCIEXPRESS', 'ASPM', 2), @('SUB_DISK', 'DISKIDLE', 1200)) { $null = powercfg /setdcvalueindex $g $x[0] $x[1] $x[2] 2>&1 }
    $null = powercfg /setactive $g 2>&1
}
$pw = New-Object Windows.Controls.StackPanel
$pw.Children.Add((New-Text 'Plano de Energia XT' 28 '#FFFFFF' 'Bold')) | Out-Null
$t = New-Text 'Plano próprio criado a partir do Ultimate Performance, afinado para latência mínima e desempenho constante.' 13.5 '#9A8AA8'; $t.Margin = '0,4,0,16'; $pw.Children.Add($t) | Out-Null
$act = New-Text '' 13 '#D98BEF'
function Update-Plan { $act.Text = 'Plano ativo: ' + ((powercfg /getactivescheme | Out-String) -replace '^.*?:\s*', '').Trim() }
$pw.Children.Add((New-Card @((New-Text 'O QUE FAZ (NA TOMADA)' 11 '#D98BEF' 'SemiBold'),
    (New-Text "• CPU a 100% sempre, sem descer de frequência`n• Core parking desativado: todos os núcleos ativos`n• PCIe Link State Power Management desligado`n• USB selective suspend desligado`n• Disco e ecrã nunca desligam por inatividade`n• Arrefecimento ativo (ventoinha antes de reduzir clock)" 13.5 '#C9BBD6'), $act) 640)) | Out-Null
$pr = New-Object Windows.Controls.StackPanel; $pr.Orientation = 'Horizontal'
$bPlan = New-Button 'Criar e ativar XT Power Plan'; $bBal = New-Button 'Voltar ao Equilibrado' 'Sec'; $bBal.Margin = '10,0,0,0'
$pr.Children.Add($bPlan) | Out-Null; $pr.Children.Add($bBal) | Out-Null; $pw.Children.Add($pr) | Out-Null
$bPlan.Add_Click({ try { New-XTPlan; Log 'XT Power Plan criado e ativado.' } catch { Log "ERRO: $($_.Exception.Message)" }; Update-Plan })
$bBal.Add_Click({ powercfg /setactive SCHEME_BALANCED | Out-Null; Log 'Plano Equilibrado reposto.'; Update-Plan })
Add-Page 'pw' 'Energia XT' $pw; Update-Plan
$bQuick.Add_Click({ $bQuick.IsEnabled = $false; try { Invoke-Items $Tweaks -Safe; try { New-XTPlan; Log 'XT Power Plan ativado.' } catch { Log "ERRO plano: $($_.Exception.Message)" }; Update-Plan } finally { $bQuick.IsEnabled = $true } })
#endregion

#region Page: Limpeza
$CleanP = @{
    'Temporários do utilizador' = @($env:TEMP); 'Temporários do Windows' = @("$env:windir\Temp")
    'Cache do Windows Update' = @("$env:windir\SoftwareDistribution\Download"); 'Cache de miniaturas' = @("$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db")
    'Relatórios de erros e dumps' = @("$env:LOCALAPPDATA\CrashDumps", "$env:windir\Minidump")
}
$Clean = @(
 @{N='Temporários do utilizador'; D='Ficheiros temporários de apps e instaladores.'; On=$true; A={ Wipe $env:TEMP }},
 @{N='Temporários do Windows'; D='Pasta C:\Windows\Temp.'; On=$true; A={ Wipe "$env:windir\Temp" }},
 @{N='Cache do Windows Update'; D='Ficheiros de updates já instalados.'; On=$true; A={ Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Wipe "$env:windir\SoftwareDistribution\Download"; Start-Service wuauserv -ErrorAction SilentlyContinue }},
 @{N='Cache de miniaturas'; D='Reconstruída automaticamente pelo Explorador.'; On=$true; A={ Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue }},
 @{N='Relatórios de erros e dumps'; D='Despejos de memória de crashes antigos.'; On=$true; A={ Wipe "$env:LOCALAPPDATA\CrashDumps"; Wipe "$env:windir\Minidump" }},
 @{N='Esvaziar Reciclagem'; D='Remove definitivamente os ficheiros apagados.'; On=$false; A={ Clear-RecycleBin -Force -ErrorAction SilentlyContinue }}
)
function Update-Sizes {
    foreach ($i in $Clean) { $i.TB.Text = "$($i.D)  -  a calcular..." }
    $j = Start-Job -ArgumentList $CleanP -ScriptBlock { param($h) foreach ($k in $h.Keys) { $s = 0; foreach ($p in $h[$k]) { if (Test-Path $p) { $s += (Get-ChildItem $p -Recurse -Force -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum } }; "$k|$([math]::Round($s / 1MB))" } }
    while ($j.State -eq 'Running') { DoEvents; Start-Sleep -Milliseconds 80 }
    $res = @{}; Receive-Job $j -ErrorAction SilentlyContinue | ForEach-Object { $a = "$_" -split '\|'; $res[$a[0]] = $a[1] }; Remove-Job $j -Force
    foreach ($i in $Clean) { $i.TB.Text = if ($res[$i.N]) { "$($i.D)  -  ~$($res[$i.N]) MB a libertar" } else { $i.D } }
}
Add-Page 'clean' 'Limpeza' { New-ListPage 'Limpeza' 'Analisa e remove lixo do sistema. O tamanho é calculado ao abrir esta página.' $Clean 'Limpar selecionados' }
#endregion

#region Page: Rede
$Net = @(
 @{N='Limpar cache DNS'; D='ipconfig /flushdns'; On=$true; A={ ipconfig /flushdns | Out-Null }},
 @{N='DNS Cloudflare (1.1.1.1)'; D='Resolução de nomes geralmente mais rápida nos adaptadores ativos.'; On=$false; A={ Get-NetAdapter | Where-Object Status -eq 'Up' | Set-DnsClientServerAddress -ServerAddresses '1.1.1.1', '1.0.0.1' }},
 @{N='Repor DNS automático'; D='Volta ao DNS fornecido pelo router/ISP.'; On=$false; A={ Get-NetAdapter | Where-Object Status -eq 'Up' | Set-DnsClientServerAddress -ResetServerAddresses }},
 @{N='Repor Winsock e pilha TCP/IP'; D='Resolve problemas de ligação. Requer reinício.'; On=$false; A={ netsh winsock reset | Out-Null; netsh int ip reset | Out-Null }},
 @{N='Testar latência (ping)'; D='Mede a média para 1.1.1.1 e 8.8.8.8.'; On=$true; A={ foreach ($h in '1.1.1.1', '8.8.8.8') { $r = Test-Connection $h -Count 4 -ErrorAction Stop; "Ping $h : $([int]($r | Measure-Object ResponseTime -Average).Average) ms" } }}
)
Add-Page 'net' 'Rede' { New-ListPage 'Rede' 'Ferramentas de rede e latência.' $Net 'Executar selecionadas' }
#endregion

#region Page: Debloat
$apps = 'Microsoft.BingNews', 'Microsoft.BingWeather', 'Microsoft.GetHelp', 'Microsoft.Getstarted', 'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.WindowsFeedbackHub', 'Microsoft.YourPhone', 'Microsoft.MicrosoftOfficeHub', 'Clipchamp.Clipchamp', 'Microsoft.People', 'Microsoft.549981C3F5F10'
$Debloat = foreach ($a in $apps) { @{ N = $a -replace '^Microsoft\.', ''; D = 'Aplicação pré-instalada. Pode ser reinstalada na Microsoft Store.'; On = $false; A = [scriptblock]::Create("Get-AppxPackage -AllUsers -Name '$a' | Remove-AppxPackage -AllUsers -ErrorAction Stop") } }
Add-Page 'bloat' 'Debloat' { New-ListPage 'Debloat' 'Remove apps pré-instaladas que não usas. Nada vem selecionado: escolhe tu.' $Debloat 'Remover selecionadas' }
#endregion

#region Run
Add-Page 'dash' 'Painel' $dash
# Painel primeiro na barra lateral
$np = C 'NavPanel'; $np.Children.Remove($NavBtns['dash']); $np.Children.Insert(0, $NavBtns['dash'])
(C 'BtnMin').Add_Click({ $w.WindowState = 'Minimized' }); (C 'BtnClose').Add_Click({ $timer.Stop(); $w.Close() })
$w.Add_MouseLeftButtonDown({ if ($_.GetPosition($w).Y -lt 46) { $w.DragMove() } })
Show-Page 'dash'
Log "XT Optimizer v$script:Version pronto  |  $($cpu.Name.Trim())  |  $gpu  |  $ram GB RAM"
$w.ShowDialog() | Out-Null
#endregion
