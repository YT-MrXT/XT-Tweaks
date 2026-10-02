# ============================================================
#  XT Optimizer  -  Otimizador de Windows com plano de energia proprio
#  Executar como Administrador:   .\XT-Optimizer.ps1
# ============================================================
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ($PSCommandPath) {
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    } else {
        [System.Windows.MessageBox]::Show("Abre o PowerShell como Administrador e executa de novo.", "XT Optimizer") | Out-Null
    }
    exit
}

# ---------- Interface ----------
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="XT Optimizer" Width="1020" Height="680" WindowStartupLocation="CenterScreen"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent" ResizeMode="CanMinimize"
        FontFamily="Segoe UI" Foreground="#E6E7EA">
  <Window.Resources>
    <Style x:Key="Nav" TargetType="Button">
      <Setter Property="Foreground" Value="#8A8F9C"/><Setter Property="Background" Value="Transparent"/>
      <Setter Property="BorderThickness" Value="0"/><Setter Property="FontSize" Value="14"/><Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="8" Padding="14,11" Margin="0,2">
          <ContentPresenter HorizontalAlignment="Left"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True">
          <Setter TargetName="b" Property="Background" Value="#1D2027"/><Setter Property="Foreground" Value="#FFFFFF"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter>
    </Style>
    <Style x:Key="Pri" TargetType="Button">
      <Setter Property="Foreground" Value="#FFFFFF"/><Setter Property="Background" Value="#FF5A1F"/>
      <Setter Property="FontWeight" Value="SemiBold"/><Setter Property="FontSize" Value="14"/><Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="8" Padding="22,12">
          <ContentPresenter HorizontalAlignment="Center"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#FF7440"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter>
    </Style>
    <Style x:Key="Sec" TargetType="Button" BasedOn="{StaticResource Pri}">
      <Setter Property="Background" Value="#1D2027"/><Setter Property="Foreground" Value="#C9CCD4"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="8" Padding="22,12" BorderBrush="#2B2F39" BorderThickness="1">
          <ContentPresenter HorizontalAlignment="Center"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#262A34"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter>
    </Style>
    <Style x:Key="Win" TargetType="Button">
      <Setter Property="Foreground" Value="#8A8F9C"/><Setter Property="Background" Value="Transparent"/><Setter Property="Width" Value="42"/><Setter Property="Height" Value="32"/>
      <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button">
        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="6"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Background" Value="#2B2F39"/><Setter Property="Foreground" Value="#FFFFFF"/></Trigger></ControlTemplate.Triggers>
      </ControlTemplate></Setter.Value></Setter>
    </Style>
  </Window.Resources>
  <Border Background="#0E0F12" CornerRadius="14" BorderBrush="#23262E" BorderThickness="1">
    <Grid>
      <Grid.ColumnDefinitions><ColumnDefinition Width="230"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
      <Border Background="#121317" CornerRadius="14,0,0,14" BorderBrush="#1B1D23" BorderThickness="0,0,1,0">
        <DockPanel Margin="18">
          <StackPanel DockPanel.Dock="Top" Orientation="Horizontal" Margin="4,6,0,28">
            <Border Background="#FF5A1F" CornerRadius="9" Width="38" Height="38">
              <TextBlock Text="XT" FontWeight="Black" FontSize="16" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
            <StackPanel Margin="12,0,0,0" VerticalAlignment="Center">
              <TextBlock Text="XT Optimizer" FontWeight="Bold" FontSize="16"/>
              <TextBlock Text="Performance Suite" FontSize="11" Foreground="#6E7380"/></StackPanel>
          </StackPanel>
          <TextBlock DockPanel.Dock="Bottom" Text="v1.0  -  usa por tua conta e risco" FontSize="11" Foreground="#555A66" Margin="6,0,0,0"/>
          <StackPanel>
            <Button x:Name="NavDash" Style="{StaticResource Nav}" Content="Painel"/>
            <Button x:Name="NavTw" Style="{StaticResource Nav}" Content="Otimizacoes"/>
            <Button x:Name="NavPw" Style="{StaticResource Nav}" Content="Plano de Energia XT"/>
          </StackPanel>
        </DockPanel>
      </Border>
      <Grid Grid.Column="1" Margin="30,0,24,20">
        <Grid.RowDefinitions><RowDefinition Height="48"/><RowDefinition Height="*"/><RowDefinition Height="120"/></Grid.RowDefinitions>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
          <Button x:Name="BtnMin" Style="{StaticResource Win}" Content="-"/>
          <Button x:Name="BtnClose" Style="{StaticResource Win}" Content="X"/>
        </StackPanel>

        <ScrollViewer x:Name="PgDash" Grid.Row="1" VerticalScrollBarVisibility="Auto">
          <StackPanel>
            <TextBlock Text="O teu PC" FontSize="28" FontWeight="Bold"/>
            <TextBlock x:Name="DashSub" Foreground="#8A8F9C" Margin="0,4,0,20" FontSize="14"/>
            <WrapPanel x:Name="Cards"/>
          </StackPanel>
        </ScrollViewer>

        <Grid x:Name="PgTw" Grid.Row="1" Visibility="Collapsed">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
          <StackPanel>
            <TextBlock Text="Otimizacoes" FontSize="28" FontWeight="Bold"/>
            <TextBlock x:Name="TwSub" Foreground="#8A8F9C" Margin="0,4,0,14" FontSize="14"/>
          </StackPanel>
          <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto"><StackPanel x:Name="TweakList"/></ScrollViewer>
          <StackPanel Grid.Row="2" Orientation="Horizontal" Margin="0,14,0,0">
            <Button x:Name="BtnApply" Style="{StaticResource Pri}" Content="Aplicar selecionadas"/>
            <Button x:Name="BtnRP" Style="{StaticResource Sec}" Content="Criar ponto de restauro" Margin="10,0,0,0"/>
          </StackPanel>
        </Grid>

        <StackPanel x:Name="PgPw" Grid.Row="1" Visibility="Collapsed">
          <TextBlock Text="Plano de Energia XT" FontSize="28" FontWeight="Bold"/>
          <TextBlock Foreground="#8A8F9C" FontSize="14" TextWrapping="Wrap" Margin="0,4,0,18"
            Text="Um plano proprio, criado a partir do Ultimate Performance e afinado para latencia minima e desempenho constante."/>
          <Border Background="#15171C" CornerRadius="12" Padding="20" BorderBrush="#23262E" BorderThickness="1">
            <StackPanel>
              <TextBlock Text="O que o plano faz (na tomada)" FontWeight="SemiBold" FontSize="15" Margin="0,0,0,10"/>
              <TextBlock x:Name="PwList" Foreground="#B5B9C4" FontSize="13.5" LineHeight="24"/>
              <TextBlock x:Name="PwActive" Foreground="#FF7440" FontSize="13" Margin="0,14,0,0"/>
            </StackPanel>
          </Border>
          <StackPanel Orientation="Horizontal" Margin="0,18,0,0">
            <Button x:Name="BtnPlan" Style="{StaticResource Pri}" Content="Criar e ativar XT Power Plan"/>
            <Button x:Name="BtnBal" Style="{StaticResource Sec}" Content="Voltar ao Equilibrado" Margin="10,0,0,0"/>
          </StackPanel>
        </StackPanel>

        <Border Grid.Row="2" Background="#0A0B0D" CornerRadius="10" BorderBrush="#1B1D23" BorderThickness="1" Margin="0,10,0,0">
          <TextBox x:Name="Log" Background="Transparent" BorderThickness="0" Foreground="#7BE0A8" FontFamily="Consolas" FontSize="12"
                   IsReadOnly="True" VerticalScrollBarVisibility="Auto" Padding="12,8" TextWrapping="Wrap"/>
        </Border>
      </Grid>
    </Grid>
  </Border>
</Window>
'@
$w = [Windows.Markup.XamlReader]::Parse($xaml)
function C($n) { $w.FindName($n) }
function Brush($c) { [Windows.Media.BrushConverter]::new().ConvertFromString($c) }
function Log($m) { $l = C 'Log'; $l.AppendText("[$(Get-Date -f HH:mm:ss)] $m`n"); $l.ScrollToEnd() }

# ---------- Hardware ----------
$cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpus = @(Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual' } | ForEach-Object Name)
$gpu  = ($gpus | Sort-Object { if ($_ -match 'NVIDIA|AMD|Radeon') { 0 } else { 1 } } | Select-Object -First 1)
if (-not $gpu) { $gpu = 'Nao detetada' }
$ram  = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$os   = (Get-CimInstance Win32_OperatingSystem).Caption
$pd   = Get-PhysicalDisk -ErrorAction SilentlyContinue | Select-Object -First 1
$disk = if ($pd) { "$($pd.FriendlyName) ($(if($pd.BusType -eq 'NVMe'){'NVMe'}else{$pd.MediaType}))" } else { 'Nao detetado' }
$isHDD = ($pd -and $pd.MediaType -eq 'HDD')
$laptop = [bool](Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue)
$hasDGPU = $gpu -match 'NVIDIA|AMD|Radeon'

(C 'DashSub').Text = "$(if($laptop){'Portatil'}else{'Desktop'})  -  $os"
$info = @(
  @('PROCESSADOR', ($cpu.Name -replace '\s+', ' '), "$($cpu.NumberOfCores) nucleos / $($cpu.NumberOfLogicalProcessors) threads"),
  @('PLACA GRAFICA', $gpu, $(if($hasDGPU){'Dedicada'}else{'Integrada'})),
  @('MEMORIA RAM', "$ram GB", $(if($ram -ge 16){'Excelente'}elseif($ram -ge 8){'Suficiente'}else{'Pouca - otimizar memoria'})),
  @('ARMAZENAMENTO', $disk, $(if($isHDD){'HDD - desfragmentar ajuda'}else{'SSD - TRIM recomendado'}))
)
foreach ($i in $info) {
    $b = New-Object Windows.Controls.Border
    $b.Background = Brush '#15171C'; $b.BorderBrush = Brush '#23262E'; $b.BorderThickness = 1
    $b.CornerRadius = 12; $b.Padding = 18; $b.Margin = '0,0,14,14'; $b.Width = 300
    $s = New-Object Windows.Controls.StackPanel
    foreach ($t in @(@($i[0], 11, '#FF7440', 'SemiBold'), @($i[1], 16, '#FFFFFF', 'SemiBold'), @($i[2], 12.5, '#8A8F9C', 'Normal'))) {
        $tb = New-Object Windows.Controls.TextBlock
        $tb.Text = $t[0]; $tb.FontSize = $t[1]; $tb.Foreground = Brush $t[2]
        $tb.FontWeight = $t[3]; $tb.TextWrapping = 'Wrap'; $tb.Margin = '0,0,0,6'
        $s.Children.Add($tb) | Out-Null
    }
    $b.Child = $s; (C 'Cards').Children.Add($b) | Out-Null
}

# ---------- Otimizacoes ----------
function Reg($p, $n, $t, $v) { reg add $p /v $n /t $t /d $v /f | Out-Null }
$tweaks = @(
 @{N='Modo de Jogo ativo'; D='Prioriza o jogo em primeiro plano.'; On=$true; A={ Reg 'HKCU\Software\Microsoft\GameBar' AutoGameModeEnabled REG_DWORD 1 }},
 @{N='Desativar Game DVR'; D='Remove a gravacao em segundo plano que custa FPS.'; On=$true; A={ Reg 'HKCU\System\GameConfigStore' GameDVR_Enabled REG_DWORD 0 }},
 @{N='Agendamento de GPU por hardware (HAGS)'; D='Menos latencia em GPUs dedicadas recentes. Requer reinicio.'; On=$hasDGPU; A={ Reg 'HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' HwSchMode REG_DWORD 2 }},
 @{N='Desativar aceleracao do rato'; D='Movimento 1:1, melhor mira.'; On=$true; A={ Reg 'HKCU\Control Panel\Mouse' MouseSpeed REG_SZ 0; Reg 'HKCU\Control Panel\Mouse' MouseThreshold1 REG_SZ 0; Reg 'HKCU\Control Panel\Mouse' MouseThreshold2 REG_SZ 0 }},
 @{N='Menus instantaneos'; D='Remove o atraso ao abrir menus.'; On=$true; A={ Reg 'HKCU\Control Panel\Desktop' MenuShowDelay REG_SZ 0 }},
 @{N='Sem atraso no arranque de apps'; D='Programas de arranque carregam logo.'; On=$true; A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize' StartupDelayInMSec REG_DWORD 0 }},
 @{N='Efeitos visuais de desempenho'; D='Menos animacoes. Notorio em PCs mais fracos.'; On=($ram -le 8); A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' VisualFXSetting REG_DWORD 2 }},
 @{N='Desativar transparencias'; D='Poupa GPU, sobretudo integrada.'; On=(-not $hasDGPU); A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' EnableTransparency REG_DWORD 0 }},
 @{N='Bloquear apps em segundo plano'; D='Liberta RAM e CPU.'; On=($ram -le 8); A={ Reg 'HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' GlobalUserDisabled REG_DWORD 1 }},
 @{N='Rede sem limitacao multimedia'; D='Remove o throttling de rede do Windows.'; On=$true; A={ Reg 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' NetworkThrottlingIndex REG_DWORD 0xffffffff }},
 @{N='Desativar Delivery Optimization'; D='O Windows deixa de usar a tua banda para partilhar updates.'; On=$true; A={ Reg 'HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' DODownloadMode REG_DWORD 0 }},
 @{N='TRIM do SSD'; D='Mantem a velocidade de escrita do SSD.'; On=(-not $isHDD); A={ fsutil behavior set DisableDeleteNotify 0 | Out-Null }},
 @{N='Desfragmentar HDD'; D='So para discos mecanicos.'; On=$isHDD; A={ defrag C: /O | Out-Null }},
 @{N='Limpar ficheiros temporarios'; D='Liberta espaco em disco.'; On=$true; A={ Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item 'C:\Windows\Temp\*' -Recurse -Force -ErrorAction SilentlyContinue }},
 @{N='Desativar telemetria (DiagTrack)'; D='Moderado: para o servico de telemetria da Microsoft.'; On=$false; A={ Stop-Service DiagTrack -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled }},
 @{N='Desativar hibernacao'; D='Moderado: liberta espaco, perdes o Arranque Rapido.'; On=$false; A={ powercfg -h off | Out-Null }}
)
(C 'TwSub').Text = "Pre-selecionadas para o teu hardware. Revê antes de aplicar."
foreach ($t in $tweaks) {
    $cb = New-Object Windows.Controls.CheckBox
    $cb.IsChecked = $t.On; $cb.Tag = $t; $cb.Margin = '0,0,0,6'
    $cb.Padding = '8,0,0,0'; $cb.VerticalContentAlignment = 'Center'
    $sp = New-Object Windows.Controls.StackPanel
    $a = New-Object Windows.Controls.TextBlock; $a.Text = $t.N; $a.FontSize = 14; $a.FontWeight = 'SemiBold'; $a.Foreground = Brush '#E6E7EA'
    $d = New-Object Windows.Controls.TextBlock; $d.Text = $t.D; $d.FontSize = 12; $d.Foreground = Brush '#7B8090'
    $sp.Children.Add($a) | Out-Null; $sp.Children.Add($d) | Out-Null
    $cb.Content = $sp
    $bd = New-Object Windows.Controls.Border
    $bd.Background = Brush '#15171C'; $bd.CornerRadius = 10; $bd.Padding = '14,10'; $bd.Margin = '0,0,8,0'; $bd.Child = $cb
    (C 'TweakList').Children.Add($bd) | Out-Null
}

# ---------- Plano de energia XT ----------
(C 'PwList').Text = "CPU a 100% sempre (sem baixar frequencia)`nCore parking desativado - todos os nucleos ativos`nPCIe Link State Power Management desligado`nUSB selective suspend desligado`nDisco e ecra nunca desligam por inatividade`nArrefecimento ativo (ventoinha antes de reduzir clock)"
function Update-Plan { (C 'PwActive').Text = "Plano ativo: " + ((powercfg /getactivescheme) -replace '^.*:\s*', '') }
Update-Plan

function New-XTPlan {
    $re = '([0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12})'
    powercfg /setactive SCHEME_BALANCED | Out-Null
    foreach ($l in (powercfg /list | Select-String 'XT')) { if ($l -match $re) { powercfg /delete $Matches[1] | Out-Null } }
    $o = (powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-String)
    if ($o -notmatch $re) { $o = (powercfg -duplicatescheme SCHEME_MIN | Out-String) }
    if ($o -notmatch $re) { throw 'Nao foi possivel duplicar o plano base.' }
    $g = $Matches[1]
    powercfg -changename $g 'XT Power Plan' 'XT Optimizer: latencia minima e desempenho maximo' | Out-Null
    $s = @(
      @('SUB_PROCESSOR','PROCTHROTTLEMIN',100), @('SUB_PROCESSOR','PROCTHROTTLEMAX',100), @('SUB_PROCESSOR','CPMINCORES',100),
      @('SUB_PROCESSOR','SYSCOOLPOL',1), @('SUB_PCIEXPRESS','ASPM',0), @('SUB_DISK','DISKIDLE',0),
      @('SUB_SLEEP','STANDBYIDLE',0), @('SUB_VIDEO','VIDEOIDLE',0),
      @('2a737441-1930-4402-8d77-b2bebba308a3','48e6b7a6-50f5-4782-a5d4-53bb8f07e226',0)
    )
    foreach ($x in $s) { powercfg /setacvalueindex $g $x[0] $x[1] $x[2] 2>$null | Out-Null }
    powercfg /setactive $g | Out-Null
}

# ---------- Eventos ----------
function Show-Page($p) {
    foreach ($n in 'PgDash','PgTw','PgPw') { (C $n).Visibility = 'Collapsed' }
    (C $p).Visibility = 'Visible'
    foreach ($n in 'NavDash','NavTw','NavPw') { (C $n).Background = Brush 'Transparent'; (C $n).Foreground = Brush '#8A8F9C' }
    $map = @{PgDash='NavDash'; PgTw='NavTw'; PgPw='NavPw'}
    $nb = C $map[$p]; $nb.Background = Brush '#1D2027'; $nb.Foreground = Brush '#FF7440'
}
(C 'NavDash').Add_Click({ Show-Page 'PgDash' })
(C 'NavTw').Add_Click({ Show-Page 'PgTw' })
(C 'NavPw').Add_Click({ Show-Page 'PgPw'; Update-Plan })
(C 'BtnMin').Add_Click({ $w.WindowState = 'Minimized' })
(C 'BtnClose').Add_Click({ $w.Close() })
$w.Add_MouseLeftButtonDown({ if ($_.GetPosition($w).Y -lt 48) { $w.DragMove() } })

(C 'BtnRP').Add_Click({
    try { Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
          Checkpoint-Computer -Description 'XT Optimizer' -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
          Log 'Ponto de restauro criado.' } catch { Log "Restauro nao criado (o Windows limita a 1 por 24h): $($_.Exception.Message)" }
})
(C 'BtnApply').Add_Click({
    Log 'A criar ponto de restauro...'
    try { Checkpoint-Computer -Description 'XT Optimizer' -RestorePointType MODIFY_SETTINGS -ErrorAction Stop } catch { Log 'Aviso: ponto de restauro ignorado.' }
    $n = 0
    foreach ($bd in (C 'TweakList').Children) {
        $cb = $bd.Child
        if ($cb.IsChecked) {
            $t = $cb.Tag
            try { & $t.A; Log "OK  $($t.N)"; $n++ } catch { Log "ERRO $($t.N): $($_.Exception.Message)" }
        }
    }
    Log "Concluido: $n otimizacoes aplicadas. Reinicia o PC para efeito total."
})
(C 'BtnPlan').Add_Click({
    try { New-XTPlan; Log 'XT Power Plan criado e ativado.'; Update-Plan } catch { Log "ERRO: $($_.Exception.Message)" }
})
(C 'BtnBal').Add_Click({ powercfg /setactive SCHEME_BALANCED | Out-Null; Log 'Plano Equilibrado reposto.'; Update-Plan })

Show-Page 'PgDash'
Log "XT Optimizer pronto. $($cpu.Name.Trim()) | $gpu | $ram GB"
$w.ShowDialog() | Out-Null
