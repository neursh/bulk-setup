if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

mkdir Bulk-Installers
cd Bulk-Installers

echo "Downloading Visual C++ 2015 - 2022 Setup..."
(New-Object Net.WebClient).DownloadFile("https://aka.ms/vs/17/release/vc_redist.x64.exe", "$pwd\VC_redist.exe")
echo "Installing Visual C++ 2015 - 2022... (1/7)`n"
.\VC_redist /quiet /norestart

echo "Downloading Python 3.11 Setup..."
(New-Object Net.WebClient).DownloadFile("https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe", "$pwd\python.exe")
echo "Installing Python 3.11... (2/7)`n"
.\python /quiet

echo "Downloading WinRAR Setup..."
(New-Object Net.WebClient).DownloadFile("https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-623.exe", "$pwd\winrar.exe")
echo "Installing WinRAR... (3/7)`n"
.\winrar /S

echo "Downloading Code::Blocks Setup..."
(New-Object Net.WebClient).DownloadFile("https://udomain.dl.sourceforge.net/project/codeblocks/Binaries/20.03/Windows/codeblocks-20.03mingw-setup.exe", "$pwd\codeblocks.exe")
echo "Installing Code::Blocks... (4/7)`n"
.\codeblocks /S

echo "Downloading Google Chrome Setup..."
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B439B16D4-D0EB-A807-7E20-0144B60C29D8%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe", "$pwd\chrome.exe")
echo "Installing Google Chrome... (5/7)`n"
.\chrome /silent /install

echo "Downloading Visual Studio Code Setup..."
(New-Object Net.WebClient).DownloadFile("https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user", "$pwd\vscode.exe")
echo "Installing Visual Studio Code... (6/7)`n"
.\vscode /VERYSILENT /NORESTART /MERGETASKS=!runcode

echo "Downloading Office 2021 Setup..."
(New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/Neurs12/bulk-setup/main/office/setup.exe", "$pwd\office.exe")
echo "Downloading Office 2021 Configurations..."
(New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/Neurs12/bulk-setup/main/office/configuration.xml", "$pwd\configuration.xml")
echo "Installing Office 2021... (7/7)`n"
.\office /configure configuration.xml

echo "Patching Office 2021..."
cmd /c "cd /d %ProgramFiles(x86)%\Microsoft Office\Office16 & cd /d %ProgramFiles%\Microsoft Office\Office16 & for /f %x in ('dir /b ..\root\Licenses16\ProPlus2021VL_KMS*.xrm-ms') do cscript ospp.vbs /inslic:'..\root\Licenses16\%x' & cscript ospp.vbs /setprt:1688 & cscript ospp.vbs /unpkey:6F7TH >nul & cscript ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH & cscript ospp.vbs /sethst:e8.us.to & cscript ospp.vbs /act"

cd ..

echo "Patched.`n`nInstallation process ended."
