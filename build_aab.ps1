$base = 'C:\Users\NEW OWNER\AppData\Local\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Local'
$env:ANDROID_HOME = "$base\Android\Sdk"
$env:ANDROID_SDK_ROOT = "$base\Android\Sdk"
$env:JAVA_HOME = (Get-ChildItem "$base\jdk17_dl" -Directory -Filter 'jdk-17*' | Select-Object -First 1).FullName
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
Write-Host "JAVA_HOME=$env:JAVA_HOME"
Set-Location 'C:\Users\NEW OWNER\Downloads\Eduvora app'
flutter build appbundle --release --dart-define=SUPABASE_URL=https://wdsvzhxhqzblpekdmsqs.supabase.co --dart-define=SUPABASE_ANON_KEY=sb_publishable_OXt5d1ErVRZkC8vN-bGSJw_WpX07_IK
Get-Item 'build\app\outputs\bundle\release\app-release.aab' | Select-Object Name, Length, LastWriteTime
