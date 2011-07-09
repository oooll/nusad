@echo off
setlocal

::Declare variables
set name=
set code1=
set code2=
set version=
set path1=
set wadname=
set dlname=
set md5=
set NEXT=
set patch=
set category=
set basewad=none
set basewadb=none
set nusadpath=%cd%

set currentversion=4.2.2

::Update name is also used in the following update link http://nusad.googlecode.com/files/%UPDATENAME%
set UPDATENAME=NUSAutoUpdate.txt
if exist Updatetemp.bat del updatetemp.bat


::how to pass variables to NUSAD via command line
::"NUS Auto Downloader" a b c d e f g h i
::equals
::"NUS Auto Downloader" %1 %2 %3 %4 %5 %6 %7 %8 %9

set one=%1
set two=%2
set three=%3
set four=%4
set five=%5
set six=%6
set seven=%7
set eight=%8
set nine=%9

if /i "%one%" EQU "W" goto:cmdlinewizard
if /i "%one%" EQU "H" goto:cmdlinehelp
if /i "%one%" EQU "help" goto:cmdlinehelp
if /i "%one%" EQU "-help" goto:cmdlinehelp
goto:notcmd

:cmdlinehelp
cls
::-------------CMD LINE DL WIZARD DOESN'T WORK WHEN converted to EXE---------
echo NUS Auto Downloader Command Line Usage:
echo.
echo DOWNLOAD WIZARD - Express Mode USAGE:
echo.
echo "NUS Auto Downloader.bat" W VIRGIN CurrentFirm REGION DesiredFirm WiiChannels Protection REGIONCHANGED2
echo.
echo Example:
echo "NUS Auto Downloader.bat" W Y 3.2 U 4.2 Y Y
echo.
echo     Make sure the settings are available otherwise output may be unreliable
echo     (ie. If CurrentFirmware is 4.3, Region cannot be J or K
echo          as NUS Auto Downloader does not support this scenario)
echo.
echo 1) W
echo 2) Virgin: Is your Wii a virgin? "Y" (Yes), "N" (No)
echo 3) CurrentFirmware: "4.3","4.2","4.1","4.0","3.X" (3.0-3.5), "O" (other <2.2)
echo 4) Region: "U","E","J","K","RC" (Region Changed from Korean to other)
echo.       If you Wii was Region Changed but not originally Korean,
echo        select the Region you are currently on
echo 5) DesiredFirmware: "4.2", "4.1", "3.2"
echo 6) WiiChannels: Download all Wii Channels (and IOS61)? "Y" (Yes), "N" (No)
echo 7) Protection: Download extra Brick Protection? "Y" (Yes), "N" (No)
echo 8) REGIONCHANGED2: What has your Korean Region been changed to? "U","E","J"
echo                    LEAVE BLANK IF your Wii was not formerly Korean.
echo.


::this will stop the batch file from opening, and keep the cmd box open
cmd.exe


:cmdlinewizard

set MENU1=%one%
set VIRGIN=%two%
set FIRMSTART=%three%
set REGION=%four%
set FIRM=%five%

if /i "%six%" EQU "Y" set MII=Y
if /i "%six%" EQU "Y" set PIC=Y
if /i "%six%" EQU "Y" set NET=Y
if /i "%six%" EQU "Y" set WEATHER=Y
if /i "%six%" EQU "Y" set NEWS=Y
if /i "%six%" EQU "Y" set SHOP=Y
if /i "%six%" EQU "Y" set SPEAK=Y

set protect=%seven%
set REGIONCHANGE=%eight%

goto:defaultsettings


:notcmd

title=NUS Auto Downloader
mode con cols=85 lines=54
color 1f

::start /? to view the different "start" parameters
::Increase your dos box size with MODE.
::mode con lines=45
::mode con cols=xxx





::SET FILENAME=%~nx0 //this returns the name of the batch file running (doesn't work when packaged in an exe)
::SET PATHNAME=%0 //this returns the filename but also with absolute path



::secret way to bypass scam warning
if exist skipscam.txt goto:DefaultSettings

set warning=
echo                                  NUS Auto Downloader
echo                                       by XFlak
echo.
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] THIS SOFTWARE IS NOT FOR SALE.
echo.
@ping 127.0.0.1 -n 3 -w 1000> nul
echo         IF YOU PAID FOR THIS SOFTWARE OR A RECEIVED IT AS PART OF A "BUNDLE"
echo       YOU HAVE BEEN SCAMMED AND YOU SHOULD DEMAND YOUR MONEY BACK IMMEDIATELY
echo.
echo.
@ping 127.0.0.1 -n 5 -w 1000> nul
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] USE THIS AT YOUR OWN RISK!
echo.
echo       THIS PACKAGE COMES WITH ABSOLUTELY NO WARRANTY, NEITHER STATED NOR IMPLIED.
echo       NO ONE BUT YOURSELF IS TO BE HELD RESPONSIBLE FOR ANY DAMAGE THIS MAY CAUSE
echo                             TO YOUR NINTENDO WII CONSOLE!
echo.

echo.
@ping 127.0.0.1 -n 7 -w 1000> nul
echo.
echo                 Please type the word "I" followed by the word "Agree"
echo                        with a space between those two words and
echo                             then press "Enter" to continue.
echo.
@ping 127.0.0.1 -n 7 -w 1000> nul
echo                          If you can't follow those instructions,
echo                        then you have no business modding anything.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
@ping 127.0.0.1 -n 5 -w 1000> nul

echo   Enter Selection Here:
echo.

Set /p warning=


if /i "%warning%" EQU "skipscam" echo Having 'skipscam.txt' saved in the same folder as NUSAD will skip the scam warning at startup.>skipscam.txt
if /i "%warning%" EQU "skipscam" attrib +r +h +s skipscam.txt
if /i "%warning%" EQU "skipscam" goto:DefaultSettings
if /i "%warning%" EQU "scam" echo Having 'skipscam.txt' saved in the same folder as NUSAD will skip the scam warning at startup.>skipscam.txt
if /i "%warning%" EQU "scam" attrib +r +h +s skipscam.txt
if /i "%warning%" EQU "scam" goto:DefaultSettings

if /i "%warning%" NEQ "I Agree" echo.
if /i "%warning%" NEQ "I Agree" echo                        Exiting NUS Auto Downloader...
if /i "%warning%" NEQ "I Agree" @ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%warning%" NEQ "I Agree" Exit


:DefaultSettings

title=NUS Auto Downloader
mode con cols=85 lines=54
color 1f


::----LOAD SETTINGS (if exist)----
if exist settings.bat call settings.bat

::-----default settings (default applies even if a single variable is missing from settings.bat)------
IF "%ROOTSAVE%"=="" set ROOTSAVE=off
IF "%OPTION1%"=="" set OPTION1=off
IF "%OPTION36%"=="" set OPTION36=off
IF "%Drive%"=="" set Drive=COPY_TO_SD
IF "%DriveU%"=="" set DriveU=COPY_TO_USB
IF "%SAVEZIP%"=="" set SAVEZIP=off
IF "%ACTIVEIOS%"=="" set ACTIVEIOS=on
IF "%AUTOUPDATE%"=="" set AUTOUPDATE=on
IF "%nusadverbose%"=="" set nusadverbose=off
IF "%sneekverbose%"=="" set sneekverbose=off
IF "%discexverify%"=="" set discexverify=off
IF "%SNKFONT%"=="" set SNKFONT=B
IF "%overwritecodes%"=="" set overwritecodes=off
IF "%cheatregion%"=="" set cheatregion=All
IF "%cheatlocation%"=="" set cheatlocation=B

IF "%wiicheat%"=="" set wiicheat=ON
IF "%WiiWarecheat%"=="" set WiiWarecheat=ON
IF "%VCArcadecheat%"=="" set VCArcadecheat=OFF
IF "%WiiChannelscheat%"=="" set WiiChannelscheat=ON
IF "%Gamecubecheat%"=="" set Gamecubecheat=ON
IF "%NEScheat%"=="" set NEScheat=ON
IF "%SNEScheat%"=="" set SNEScheat=ON
IF "%N64cheat%"=="" set N64cheat=ON
IF "%SMScheat%"=="" set SMScheat=ON
IF "%Segacheat%"=="" set Segacheat=ON
IF "%NeoGeocheat%"=="" set NeoGeocheat=ON
IF "%Commodorecheat%"=="" set Commodorecheat=ON
IF "%MSXcheat%"=="" set MSXcheat=ON
IF "%TurboGraFX-16cheat%"=="" set TurboGraFX-16cheat=ON
IF "%TurboGraFX-CDcheat%"=="" set TurboGraFX-CDcheat=ON


:Clear_Download_Log
::if exist %DRIVE%\Download_Log.md5 echo ;NUS Auto Downloader Log > %DRIVE%\Download_Log.md5
if exist "%Drive%"\Download_Log.md5 del "%Drive%"\Download_Log.md5>nul

::skip update when using cmd line
if /i "%one%" EQU "W" goto:MENUafterbadvars

if /i "%nusadverbose%" EQU "off" (set nusadmin=/min ) else (set nusadmin=)
if /i "%AUTOUPDATE%" EQU "on" goto:UpdateNUSAD

::......................................................MAIN MENU..............................................

:MENU

if exist NUSAutoUpdate.bat del NUSAutoUpdate.bat

::----restore settings if applicable (download queue and sneek nand builder)----
IF "%MENU1%"=="" goto:NOCLEAR
if /i "%MENU1%" NEQ "O" goto:Cleartempsettings
goto:NOCLEAR
:Cleartempsettings
Set ROOTSAVE=%ROOTSAVETEMP%
Set Option1=%Option1TEMP%
Set SAVEZIP=%SAVEZIPTEMP%
:NOCLEAR

::---SET TEMP SETTINGS FOR DL QUE---
Set ROOTSAVETEMP=%ROOTSAVE%
Set Option1TEMP=%Option1%
Set SAVEZIPTEMP=%SAVEZIP%


if /i "%nusadverbose%" EQU "off" (set nusadmin=/min ) else (set nusadmin=)


::variable that interfere with cmd line wizard
SET VIRGIN=
SET FIRMSTART=
set STUB=
set PIC=
set NET=
set WEATHER=
set NEWS=
set SHOP=
set SPEAK=
set MII=
set REGION=
:MENUafterbadvars


mode con cols=85 lines=54
SET lines=54

set MORE=
SET DEC=
SET HEX=
SET VER=
SET CONFIRM=
SET GRABBER=
set loadorgo=go
set SMAPP=

SET EXPLOIT=default
set exploitselection=
set COPY=
set DLTOTAL=0
set OPTIONS=
set DB=N
set FORMAT=NONE
set cfgfullrelease=NONE
set SNEEKTYPE=
if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVETEMP%
set USBCONFIG=
set SNEEKTYPE=
set SNEEKSELECT=
set patchIOSnum=36 or 236

:CLEAR
set EULAU=
set EULAE=
set EULAJ=
set EULAK=
set RSU=
set RSE=
set RSJ=
set RSK=
set BC=
set SM3.2U=
set SM4.1U=
set SM4.2U=
set SM4.3U=
set SM3.2E=
set SM4.1E=
set SM4.2E=
set SM4.3E=
set SM3.2J=
set SM4.1J=
set SM4.2J=
set SM4.3J=
set SM4.1K=
set SM4.2K=
set SM4.3K=
set IOS30=
set IOS30P=
set IOS30P60=
set IOS40P60=
set IOS20P60=
set IOS11P60=
set IOS50P=
set IOS52P=
set IOS60=
set IOS60P=
set IOS70=
set IOS70P=
set IOS80=
set IOS80P=

set IOS70K=
set IOS80K=
set BB1=
set BB2=
set HM=
set h4=
set h5=
set h51=
set w17=
set w19=
set w20=
set TBR=
set loadmii=
set dop=
set locked=
set AccioHacks=
set HBB=
set WII64=
set WIISX=
set bootmiisd=
set pwns=
set twi=
set smash=
set mmm=
set yawm=
set neogamma=
set cfg249=
set cfg222=
set usbfolder=
set WiiMC=
set fceugx=
set snes9xgx=
set vbagx=
set SGM=
set WIIX=
set cfgr=
set wbm=
set CheatCodes=
set f32=
set USBX=
set Pri=
set HAX=
set CM5=
set MP=
set MII=
set P=
set PK=
set S=
set SK=
set IU=
set IE=
set IJ=
set WU=
set WE=
set WJ=
set NU=
set NE=
set NJ=
set WSU=
set WSE=
set WSJ=
set M10=
set IOS9=
set IOS12=
set IOS13=
set IOS14=
set IOS15v257=
set IOS15v1031=
set IOS15=
set IOS17=
set IOS21=
set IOS22=
set IOS28=
set IOS31=
set IOS33=
set IOS34=
set IOS35=
set IOS36=
set IOS36v3607=
set IOS37=
set IOS38=
set IOS41=
set IOS41v3091=
set IOS43=
set IOS45=
set IOS46=
set IOS53=
set IOS55=
set IOS56=
set IOS57=
set IOS202P57=
set IOS58=
set IOS61=

set A0e=
set A0e_60=
set A0e_70=
set A01=
set A01_60=
set A01_70=
set A40=
set A42=
set A45=
set A70=
set A72=
set A75=
set A78=
set A7b=
set A7e=
set A84=
set A87=
set A8a=
set RVL-cmios-v4_WiiGator_GCBL_v0.2=
set RVL-cmios-v4_Waninkoko_rev5=
set cIOS222[38]-v4=
set cIOS223[37-38]-v4=
set cIOS222[38]-v5=
set cIOS223[37]-v5=
set cIOS224[57]-v5=
set cIOS249[37]-v19=
set cIOS249[38]-v19=
set cIOS249[57]-v19=
set cIOS249-v17b=
set cIOS202[37]-v5=
set cIOS202[38]-v5=
set cIOS202[57]-v5=
set cIOS223[57]-v5=
set cIOS224[37]-v5=
set cIOS250[57]-v19=
set cIOS250-v17b=
set cIOS250[37]-v19=
set cIOS250[38]-v19=



if /i "%ADVPATCH%" EQU "B" goto:ADVANCED
if /i "%ADVSLOT%" EQU "B" goto:ADVANCED
if /i "%ADVVERSION%" EQU "B" goto:ADVANCED

if /i "%list%" EQU "C" goto:list
if /i "%oldlist%" EQU "C" goto:oldlist
if /i "%GRABBER%" EQU "C" goto:NUSGRABBER

SET COUNT=1
SET COUNT2=1
SET COUNT3=1
SET COUNT4=1
SET COUNT5=1
SET COUNT6=1
SET COUNT7=1
SET COUNT8=1
SET CURRENTDL=0

::for cmdlineDLwizard
if /i "%one%" EQU "W" goto:DOWNLOAD

set MENU1=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] Choose an Activity:
echo.
echo           W = Download Wizard (Mod Your Wii) + Guide
echo.
echo           U = USB-Loader Setup + Guide
echo.
echo           H = HackMii Solutions (Upside-Down HBC/No Vulnerable IOS Fix) + Guide
echo.
echo           S = SNEEK Installation, Nand Builder, Game/ISO Bulk Extractor
echo.
echo.
echo           1 = Downloads Page 1 (System Menu's, IOSs, MIOSs, Channels, etc.)
echo.
echo           2 = Downloads Page 2 (cIOSs, Apps, USB-Loader Files, CheatCodes, etc.)
echo.
echo           3 = Downloads Page 3 (*.APP Files for SNEEK and MyMenuify)
echo.
echo           A = Advanced Custom Downloads
echo.
If Exist download_queue.bat echo           L = Load Download Queue
If Exist download_queue.bat echo.
echo           V = Verify Downloads
echo.
echo.
echo           C = Build Config Files for BootMii, Wad Manager or Multi-Mod Manager
::echo           S = SNEEK Game/ISO Bulk Extractor
echo.
echo          FC = File Cleanup: Remove un-needed files after Modding
echo.
echo.
echo           O = Options
echo.
echo          CR = Credits
echo.
echo           E = Exit
echo.
echo.
echo      *********MORE INFO*********
echo.
sfk echo -spat \x20 \x20 [RED] SH = Show your support and vote for NUSAD at http://tinyurl.com/NusAuto
echo.
echo      Use the Download Wizard to automatically set-up your SD card with
echo      all you need to modify your Wii, upgrade/downgrade your Wii,
echo      install cIOSs, and much much more.
echo.
sfk echo -spat \x20 \x20 [RED] Donations are optional and can be made via paypal.com to XFlak40@hotmail.com
echo.
echo      ***************************
echo.
set /p MENU1=     Enter Selection Here: 


if /i "%MENU1%" EQU "W" goto:LoadWizardSettings
if /i "%MENU1%" EQU "U" goto:UPAGE1
if /i "%MENU1%" EQU "S" goto:SNKPAGE1
::if /i "%MENU1%" EQU "S" goto:SNKDISCEX
if /i "%MENU1%" EQU "1" goto:LIST
if /i "%MENU1%" EQU "2" goto:OLDLIST
if /i "%MENU1%" EQU "3" goto:NUSGRABBER
if /i "%MENU1%" EQU "A" goto:ADVANCED
if /i "%MENU1%" EQU "V" goto:FINISH
if /i "%MENU1%" EQU "E" goto:exitnow
if /i "%MENU1%" EQU "O" goto:OPTIONS
if /i "%MENU1%" EQU "H" goto:WPAGE2
if /i "%MENU1%" EQU "FC" set BACKB4DRIVE=Menu
if /i "%MENU1%" EQU "FC" goto:DRIVECHANGE
if /i "%MENU1%" EQU "C" goto:CONFIGFILEMENU


if /i "%MENU1%" EQU "CR" goto:Credits
if /i "%MENU1%" EQU "SH" goto:openwebpage



If not Exist download_queue.bat goto:eastereggs
if /i "%MENU1%" EQU "L" call download_queue.bat
if /i "%MENU1%" EQU "L" set BACKB4QUEUE=Menu
if /i "%MENU1%" EQU "L" goto:DownloadQueue

:EasterEggs
if /i "%MENU1%" EQU "fuckyou" echo Fuck you too asshole!
if /i "%MENU1%" EQU "fuck you" echo Fuck you too asshole!
if /i "%MENU1%" EQU "bitch" echo I'm not a bitch, YOU'RE the Bitch!
if /i "%MENU1%" EQU "pussy" echo Well, you are what you eat ;)
if /i "%MENU1%" EQU "dick" echo Who do you think your calling a dick... DICK!
if /i "%MENU1%" EQU "help" echo Google is your friend
if /i "%MENU1%" EQU "decompiler" echo Close but no cigar!

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MENU

:openwebpage
start www.tinyurl.com/NusAuto
goto:MENU

:exitnow
if exist "%DRIVE%"\Global_Log.md5 del "%DRIVE%"\Global_Log.md5>nul
if exist "%DRIVE%"\Download_Log.md5 del "%DRIVE%"\Download_Log.md5>nul
EXIT

::..................................................Credits.........................................................
:Credits
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo                                        Credits
echo   *********************************************************************************
echo   *   Special thanks to the following people, who have gone out of their way      *
echo   *              numerous times to help me when they didn't have to               *
echo   *                                                                               *
echo   *    Leathl, cwstjdenobs, DeadlyFoez, Violator, WiiCrazy, Giantpune, WiiPower   *
echo   *     DaMysteryMan, pepxl, ChokeD, longtom1, tj_cool, mauifrog  and xzxero.     *
echo   *********************************************************************************
echo   * Thanks to my cuz, Violator, who first got me into the Wii scene.
echo.
echo   * Leathl for libwiisharp, patchios, nusfilegrabber, showmiiwads, etc.
echo.
echo   * cwstjdenobs for creating YAWMM and all his work to help support NUSAD.
echo.
echo   * tj_cool and xzxero for their Guides (and for inviting me to join 'the Crew')
echo.
echo   * Team Twiizers for creating the revolutionary HackMii Installer.
echo.
echo   * Waninkoko for creating CIOS and other excellent apps like WAD manager.
echo.
echo   * Hermes for creating his efficient CIOS 222/223/224.
echo.
echo   * Comex for creating the heavily utilized bannerbomb exploit.
echo.
echo   * Crediar, Daco Taco and Phpgeek for brick protection via Priiloader.
echo.
echo   * Arikado and the Dop-Mii team for Dop-Mii.
echo.
echo   * WiiWu and the Dop-Mii team for Multi Manager Mod (MMM).
echo.
echo   * WiiNinja and WB3000 for their work on nusd.
echo.
echo   * WiiPower for Neogamma and much more.
echo.
echo   * WiiCrazy for Crap (Forwarder Channel Maker) and Crazy Intro.
echo.
echo   * WiiGator for creating his Gamecube Backup Launcher.
echo.
echo   * oggzee, usptactical, gannon and Dr.Clipper for Configurable USB Loader.
echo.
echo   * Giantpune for USB Loader GX and much more.
echo.
echo   * DeadlyFoez for his brick fixing tutorials (and for just being Deadly).
echo.
echo   * pepxl for his awesome graphics work (including the icon for this app).
echo.
echo   * Wii.py devs: Megazig, Omega, Xuzz, SquidMan, Matt_P and The Lemon Man
echo.
echo   * Daeken for writing Struct.py and marcan for his LZ77 code
echo.
pause

goto:menu


::..................................................OPTIONS.................................................. 
.......
:OPTIONS

Set WLAST=
Set Options=
set cheatoption=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Enter the option # (or letter) to enable/disable it
echo.
echo.
echo           D = Change Drive letter (Current Setting: %Drive%)
echo.
echo          DU = Change Drive letter for USB (Current Setting: %DriveU%)
echo               * Only used for USB-Loader\SNEEK Setup
echo.
if /i "%overwritecodes%" EQU "OFF" echo          CC = Cheat Code Options
if /i "%overwritecodes%" EQU "ON" echo          CC = Cheat Code Options
echo.
if /i "%ROOTSAVE%" EQU "ON" echo          RS = Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Enabled)
if /i "%ROOTSAVE%" EQU "OFF" echo          RS = Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Disabled)
echo               * Does NOT affect Download Wizard and only applies to IOSs\MIOSs
echo               * Useful for Wii Apps that require IOSs\MIOSs saved to Root
echo.
if /i "%OPTION1%" EQU "OFF" echo           1 = Keep 00000001 Folder for IOSs\MIOSs\SMs etc. (Disabled)
if /i "%OPTION1%" EQU "ON" echo           1 = Keep 00000001 Folder for IOSs\MIOSs\SMs etc. (Enabled)
echo               * Useful for Wii Apps that require IOSs\MIOSs saved to 00000001 Folder
echo.
if /i "%SAVEZIP%" EQU "OFF" echo           Z = Save zip files after extraction (Disabled)
if /i "%SAVEZIP%" EQU "ON" echo           Z = Save zip files after extraction (Enabled)
echo.
echo           U = Update IOSs. Wizard to download all active IOSs when current
if /i "%ACTIVEIOS%" EQU "OFF" echo               firmware is less than 4.3 (Disabled)
if /i "%ACTIVEIOS%" EQU "ON" echo               firmware is less than 4.3 (Enabled)
echo.
if /i "%OPTION36%" EQU "OFF" echo          36 = Include IOS36v3607 in Download Wizards Active IOS Downloads (Disabled)
if /i "%OPTION36%" EQU "ON" echo          36 = Include IOS36v3607 in Download Wizards Active IOS Downloads (Enabled)
echo               * Your existing IOS36 may be patched. The downloaded IOS36 is not
echo.

if /i "%nusadverbose%" EQU "off" echo           V = Verbose Output Maximized when NUSAD uses wget or discex (Disabled)
if /i "%nusadverbose%" EQU "on" echo           V = Verbose Output Maximized when NUSAD uses wget or discex (Enabled)
echo.

if /i "%sneekverbose%" EQU "off" echo          SV = SNEEK Verbose Output (Disabled)
if /i "%sneekverbose%" EQU "on" echo          SV = SNEEK Verbose Output (Enabled)
echo.

if /i "%SNKFONT%" EQU "W" echo           F = Font.bin Colour for SNEEK+DI/UNEEK+DI (WHITE)
if /i "%SNKFONT%" EQU "B" echo           F = Font.bin Colour for SNEEK+DI/UNEEK+DI (BLACK)
echo.

if /i "%discexverify%" EQU "off" echo          VD = Verify Data when using SNEEK Game/ISO Bulk Extractor (Disabled)
if /i "%discexverify%" EQU "on" echo          VD = Verify Data when using SNEEK Game/ISO Bulk Extractor (Enabled)
echo.

if not exist "%DRIVE%" goto:nodrivefolder
echo           C = Create Custom.md5 file to verify all
echo               Wads, dols, elfs and apps in %DRIVE%
if exist Custom.md5 echo          C2 = Verify files in %DRIVE% against Custom.md5
:nodrivefolder
if exist Custom.md5 echo          C3 = Delete Custom.md5
echo.
if /i "%AUTOUPDATE%" EQU "OFF" echo           A = Auto-Update NUS Auto Downloader at program start (Disabled)
if /i "%AUTOUPDATE%" EQU "ON" echo           A = Auto-Update NUS Auto Downloader at program start (Enabled)
echo.
echo           N = Check for New versions of NUS Auto Downloader right now
echo.
echo.
echo       S = Save Settings       R = Restore Default Settings       M = Main Menu
echo.
echo.
set /p OPTIONS=     Enter Selection Here: 


if /i "%OPTIONS%" EQU "RS" goto:ROOTSAVE
if /i "%OPTIONS%" EQU "1" goto:Option1
if /i "%OPTIONS%" EQU "N" goto:UpdateNUSAD
if /i "%OPTIONS%" EQU "A" goto:AutoUpdate
if /i "%OPTIONS%" EQU "36" goto:Option36
if /i "%OPTIONS%" EQU "sv" goto:OptionSneekverbose
if /i "%OPTIONS%" EQU "v" goto:OptionNUSADverbose
if /i "%OPTIONS%" EQU "VD" goto:OptionDiscexVerify
if /i "%OPTIONS%" EQU "f" goto:Optionfont

if not exist "%DRIVE%" goto:nodrivefolder2
::if /i "%OPTIONS%" EQU "C" sfk list "%DRIVE%" wad dol app elf +md5gento="%DRIVE%"\Custom.md5
if /i "%OPTIONS%" EQU "C" fvc -c -a MD5 -r "%DRIVE%"\*.wad>Custom.md5
if /i "%OPTIONS%" EQU "C" fvc -c -a MD5 -r "%DRIVE%"\*.dol>>Custom.md5
if /i "%OPTIONS%" EQU "C" fvc -c -a MD5 -r "%DRIVE%"\*.app>>Custom.md5
if /i "%OPTIONS%" EQU "C" fvc -c -a MD5 -r "%DRIVE%"\*.elf>>Custom.md5
if /i "%OPTIONS%" EQU "C" fvc -c -a MD5 -r "%DRIVE%"\*.bin>>Custom.md5
::if /i "%OPTIONS%" EQU "C" fvc -c -a MD5 -r "%DRIVE%"\*.exe>>Custom.md5

if /i "%OPTIONS%" EQU "C" sfk filter Custom.md5 -unique -write -yes>nul
if /i "%OPTIONS%" EQU "C" goto:Options

if not exist Custom.md5 goto:nocustomMD5
if /i "%OPTIONS%" EQU "C2" Set DB=C
if /i "%OPTIONS%" EQU "C2" goto:Finish
:nodrivefolder2

if not exist Custom.md5 goto:nocustomMD5
if /i "%OPTIONS%" EQU "C3" del Custom.md5
if /i "%OPTIONS%" EQU "C3" goto:Options
:nocustomMD5

if /i "%OPTIONS%" EQU "D" set BACKB4DRIVE=OPTIONS
if /i "%OPTIONS%" EQU "D" goto:DRIVECHANGE
if /i "%OPTIONS%" EQU "DU" set BACKB4DRIVEU=OPTIONS
if /i "%OPTIONS%" EQU "DU" goto:DRIVEUCHANGE
if /i "%OPTIONS%" EQU "Z" goto:SAVEZIP
if /i "%OPTIONS%" EQU "CC" goto:cheatcodeoptions

if /i "%OPTIONS%" EQU "U" goto:ACTIVEIOS
if /i "%OPTIONS%" EQU "S" goto:SaveSettings
if /i "%OPTIONS%" EQU "R" goto:RestoreSettings
if /i "%OPTIONS%" EQU "M" goto:MENU
::if /i "%OPTIONS%" EQU "B" goto:MENU
if /i "%OPTIONS%" EQU "decompiler" "NUS Auto Downloader.exe" decompiler
if /i "%OPTIONS%" EQU "decompiler" goto:OPTIONS
if /i "%OPTIONS%" EQU "skipscam" echo Having 'skipscam.txt' saved in the same folder as NUSAD will skip the scam warning at startup.>skipscam.txt
if /i "%OPTIONS%" EQU "skipscam" attrib +r +h +s skipscam.txt
if /i "%OPTIONS%" EQU "skipscam" goto:OPTIONS
if /i "%OPTIONS%" EQU "scam" echo Having 'skipscam.txt' saved in the same folder as NUSAD will skip the scam warning at startup.>skipscam.txt
if /i "%OPTIONS%" EQU "scam" attrib +r +h +s skipscam.txt
if /i "%OPTIONS%" EQU "scam" goto:OPTIONS


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:OPTIONS




:SaveSettings
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo ::NUS Auto Downloader Settings > settings.bat
echo Set ROOTSAVE=%ROOTSAVE%>> settings.bat
echo Set Option1=%Option1%>> settings.bat
echo Set OPTION36=%OPTION36%>> settings.bat
echo Set Drive=%DRIVE%>> settings.bat
echo Set DriveU=%DRIVEU%>> settings.bat
echo Set SAVEZIP=%SAVEZIP%>> settings.bat
echo Set overwritecodes=%overwritecodes%>> settings.bat
echo Set cheatregion=%cheatregion%>> settings.bat
echo Set cheatlocation=%cheatlocation%>> settings.bat
echo Set ACTIVEIOS=%ACTIVEIOS%>> settings.bat
echo Set AUTOUPDATE=%AUTOUPDATE%>> settings.bat
echo Set nusadverbose=%nusadverbose%>> settings.bat
echo Set sneekverbose=%sneekverbose%>> settings.bat
echo Set discexverify=%discexverify%>> settings.bat
echo Set SNKFONT=%SNKFONT%>> settings.bat
echo Set wiicheat=%wiicheat%>> settings.bat
echo Set WiiWarecheat=%WiiWarecheat%>> settings.bat
echo Set VCArcadecheat=%VCArcadecheat%>> settings.bat
echo Set WiiChannelscheat=%WiiChannelscheat%>> settings.bat
echo Set Gamecubecheat=%Gamecubecheat%>> settings.bat
echo Set NEScheat=%NEScheat%>> settings.bat
echo Set SNEScheat=%SNEScheat%>> settings.bat
echo Set N64cheat=%N64cheat%>> settings.bat
echo Set SMScheat=%SMScheat%>> settings.bat
echo Set Segacheat=%Segacheat%>> settings.bat
echo Set NeoGeocheat=%NeoGeocheat%>> settings.bat
echo Set Commodorecheat=%Commodorecheat%>> settings.bat
echo Set MSXcheat=%MSXcheat%>> settings.bat
echo Set TurboGraFX-16cheat=%TurboGraFX-16cheat%>> settings.bat
echo Set TurboGraFX-CDcheat=%TurboGraFX-CDcheat%>> settings.bat

if exist settings.bat echo                                     Settings Saved.
echo.
@ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%cheatoption%" EQU "S" goto:cheatcodeoptions
goto:OPTIONS


:RestoreSettings
set ROOTSAVE=off
set OPTION1=off
set OPTION36=off
set Drive=COPY_TO_SD
set DriveU=COPY_TO_USB
set SAVEZIP=off
set ACTIVEIOS=on
set AUTOUPDATE=on
Set nusadverbose=off
Set sneekverbose=off
Set discexverify=off
Set SNKFONT=B

:defaultcheatsettings
set overwritecodes=off
set cheatregion=All
set cheatlocation=B

:selectallcheats
set wiicheat=ON
set WiiWarecheat=ON
set VCArcadecheat=OFF
set WiiChannelscheat=ON
set Gamecubecheat=ON
set NEScheat=ON
set SNEScheat=ON
set N64cheat=ON
set SMScheat=ON
set Segacheat=ON
set NeoGeocheat=ON
set Commodorecheat=ON
set MSXcheat=ON
set TurboGraFX-16cheat=ON
set TurboGraFX-CDcheat=ON
if /i "%cheatoption%" EQU "A" goto:cheatcodeoptions
if /i "%cheatoption%" EQU "D" goto:cheatcodeoptions

if exist settings.bat del settings.bat
goto:OPTIONS


:ROOTSAVE
if /i "%ROOTSAVE%" EQU "ON" goto:ROOTSAVEoff
Set ROOTSAVE=ON
goto:OPTIONS

:ROOTSAVEoff
Set ROOTSAVE=OFF
goto:OPTIONS


:Option1
if /i "%OPTION1%" EQU "ON" goto:Option1off
Set Option1=ON
goto:OPTIONS

:Option1off
Set Option1=OFF
goto:OPTIONS

:OPTION36
if /i "%OPTION36%" EQU "ON" goto:OPTION36off
Set OPTION36=ON
goto:OPTIONS

:OPTION36off
Set OPTION36=OFF
goto:OPTIONS

:OptionSneekverbose
if /i "%sneekverbose%" EQU "on" goto:OptionSneekverboseoff
Set sneekverbose=on
goto:OPTIONS

:OptionSneekverboseoff
Set sneekverbose=off
goto:OPTIONS

:Optionnusadverbose
if /i "%nusadverbose%" EQU "on" goto:Optionnusadverboseoff
Set nusadverbose=on
goto:OPTIONS

:Optionnusadverboseoff
Set nusadverbose=off
goto:OPTIONS


:OptionDiscexVerify
if /i "%discexverify%" EQU "on" goto:OptionDiscexVerifyoff
Set discexverify=on
goto:OPTIONS

:OptionDiscexVerifyoff
Set discexverify=off
goto:OPTIONS


:Optionfont
if /i "%SNKFONT%" EQU "W" goto:OptionfontB
Set SNKFONT=W
goto:OPTIONS

:OptionfontB
Set SNKFONT=B
goto:OPTIONS

:SAVEZIP
if /i "%SAVEZIP%" EQU "ON" goto:SAVEZIPoff
Set SAVEZIP=ON
goto:OPTIONS

:SAVEZIPoff
Set SAVEZIP=OFF
goto:OPTIONS



:ACTIVEIOS
if /i "%ACTIVEIOS%" EQU "ON" goto:ACTIVEIOSoff
Set ACTIVEIOS=ON
goto:OPTIONS

:ACTIVEIOSoff
Set ACTIVEIOS=OFF
goto:OPTIONS

:AUTOUPDATE
if /i "%AUTOUPDATE%" EQU "ON" goto:AUTOUPDATEoff
Set AUTOUPDATE=ON
goto:OPTIONS

:AUTOUPDATEoff
Set AUTOUPDATE=OFF
goto:OPTIONS





:cheatcodeoptions
set cheatoption=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                  CHEAT CODE OPTIONS
echo.
echo.
echo           R = Region to download cheats for: (%cheatregion%)
echo.
if /i "%overwritecodes%" EQU "OFF" echo           O = Overwrite existing txtcodes (Disabled)
if /i "%overwritecodes%" EQU "ON" echo           O = Overwrite existing txtcodes (Enabled)
echo.
if /i "%cheatlocation%" EQU "B" echo           L = Location(s) to save cheats: (Both 1 and 2)
if /i "%cheatlocation%" EQU "T" echo           L = Location(s) to save cheats: (1: txtcodes)
if /i "%cheatlocation%" EQU "C" echo           L = Location(s) to save cheats: (2: codes\X\L)
echo               1: - txtcodes: location used by most apps, including CFG USB-Loader
echo               2: - codes\X\L\: location used by Accio Hacks
echo                        X = Console ID Letter (ie. Wii = R)
echo                        L = 1st letter of game title ('#' if it starts with a number)
echo.
echo.
echo                   Select or deselect consoles to download cheats for:
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Selected consoles are marked in [Green]Green
echo.
echo.
if /i "%wiicheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]1 = Wii) else (echo                 1 = Wii)
if /i "%WiiWarecheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]2 = WiiWare) else (echo                 2 = WiiWare)

::if /i "%VCArcadecheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]3 = VC Arcade)  else (echo                 3 = VC Arcade)
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]3 = VC Arcade (Disabled due to geckocodes.org error)

if /i "%WiiChannelscheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]4 = Wii Channels)  else (echo                 4 = Wii Channels)
if /i "%Gamecubecheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]5 = Gamecube)  else (echo                 5 = Gamecube)
if /i "%NEScheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]6 = NES/Famicom VC)  else (echo                 6 = NES/Famicom VC)
if /i "%SNEScheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]7 = Super NES/Famicom VC)  else (echo                 7 = Super NES/Famicom VC)
if /i "%N64cheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]8 = Nintendo 64 VC)  else (echo                 8 = Nintendo 64 VC)
if /i "%SMScheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green]9 = Sega Master System VC)  else (echo                 9 = Sega Master System VC)
if /i "%Segacheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 10 = Sega Genesis/Mega Drive VC)  else (echo                10 = Sega Genesis/Mega Drive VC)
if /i "%NeoGeocheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 11 = NeoGeo VC)  else (echo                11 = NeoGeo VC)
if /i "%Commodorecheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 12 = Commodore 64 VC)  else (echo                12 = Commodore 64 VC)
if /i "%MSXcheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 13 = MSX VC)  else (echo                13 = MSX VC)
if /i "%TurboGraFX-16cheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 14 = TurboGraFX-16 VC)  else (echo                14 = TurboGraFX-16 VC)
if /i "%TurboGraFX-CDcheat%" EQU "ON" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 15 = TurboGraFX-CD VC)  else (echo                15 = TurboGraFX-CD VC)
echo.
echo.
echo                 A = All
echo                 C = Clear
echo.
echo                 S = Save Settings
echo                 D = Default Cheat Settings
echo.
echo                 B = Back
echo                 M = Main Menu
echo.
echo.
echo.
set /p cheatoption=     Enter Selection Here: 



if /i "%cheatoption%" EQU "1" goto:wiicheat
if /i "%cheatoption%" EQU "2" goto:WiiWarecheat
::if /i "%cheatoption%" EQU "3" goto:VCArcadecheat
if /i "%cheatoption%" EQU "4" goto:WiiChannelscheat
if /i "%cheatoption%" EQU "5" goto:Gamecubecheat
if /i "%cheatoption%" EQU "6" goto:NEScheat
if /i "%cheatoption%" EQU "7" goto:SNEScheat
if /i "%cheatoption%" EQU "8" goto:N64cheat
if /i "%cheatoption%" EQU "9" goto:SMScheat
if /i "%cheatoption%" EQU "10" goto:Segacheat
if /i "%cheatoption%" EQU "11" goto:NeoGeocheat
if /i "%cheatoption%" EQU "12" goto:Commodorecheat
if /i "%cheatoption%" EQU "13" goto:MSXcheat
if /i "%cheatoption%" EQU "14" goto:TurboGraFX-16cheat
if /i "%cheatoption%" EQU "15" goto:TurboGraFX-CDcheat
if /i "%cheatoption%" EQU "A" goto:selectallcheats
if /i "%cheatoption%" EQU "C" goto:deselectallcheats
if /i "%cheatoption%" EQU "R" goto:cheatregion
if /i "%cheatoption%" EQU "l" goto:cheatlocation
if /i "%cheatoption%" EQU "O" goto:overwritecodes
if /i "%cheatoption%" EQU "B" goto:countconsoles
if /i "%cheatoption%" EQU "M" goto:countconsoles

if /i "%cheatoption%" EQU "S" goto:SaveSettings
if /i "%cheatoption%" EQU "D" goto:defaultcheatsettings


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:cheatcodeoptions

:countconsoles
set countconsoles=0
if /i "%wiicheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%WiiWarecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%VCArcadecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%WiiChannelscheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%Gamecubecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%NEScheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%SNEScheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%N64cheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%SMScheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%Segacheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%NeoGeocheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%Commodorecheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%MSXcheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%TurboGraFX-16cheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1
if /i "%TurboGraFX-CDcheat%" EQU "ON" SET /a countconsoles=%countconsoles%+1

if /i "%countconsoles%" EQU "0" echo Select at least one console to download cheats for
if /i "%countconsoles%" EQU "0" @ping 127.0.0.1 -n 3 -w 1000> nul
if /i "%countconsoles%" EQU "0" goto:cheatcodeoptions

if /i "%cheatoption%" EQU "B" goto:Options
if /i "%cheatoption%" EQU "M" goto:MENU



:overwritecodes
if /i "%overwritecodes%" EQU "ON" goto:overwritecodesoff
Set overwritecodes=ON
goto:cheatcodeoptions

:overwritecodesoff
Set overwritecodes=OFF
goto:cheatcodeoptions


:cheatregion
if /i "%cheatregion%" EQU "all" Set cheatregion=USA&&goto:cheatcodeoptions
if /i "%cheatregion%" EQU "USA" Set cheatregion=PAL&&goto:cheatcodeoptions
if /i "%cheatregion%" EQU "PAL" Set cheatregion=JAP&&goto:cheatcodeoptions
if /i "%cheatregion%" EQU "JAP" Set cheatregion=all&&goto:cheatcodeoptions


:cheatlocation
if /i "%cheatlocation%" EQU "B" Set cheatlocation=T&&goto:cheatcodeoptions
if /i "%cheatlocation%" EQU "T" Set cheatlocation=C&&goto:cheatcodeoptions
if /i "%cheatlocation%" EQU "C" Set cheatlocation=B&&goto:cheatcodeoptions




:wiicheat
if /i "%wiicheat%" EQU "OFF" (set wiicheat=ON) else (set wiicheat=OFF)
goto:cheatcodeoptions


:WiiWarecheat
if /i "%WiiWarecheat%" EQU "OFF" (set WiiWarecheat=ON) else (set WiiWarecheat=OFF)
goto:cheatcodeoptions

:VCArcadecheat
if /i "%VCArcadecheat%" EQU "OFF" (set VCArcadecheat=ON) else (set VCArcadecheat=OFF)
goto:cheatcodeoptions

:WiiChannelscheat
if /i "%WiiChannelscheat%" EQU "OFF" (set WiiChannelscheat=ON) else (set WiiChannelscheat=OFF)
goto:cheatcodeoptions

:Gamecubecheat
if /i "%Gamecubecheat%" EQU "OFF" (set Gamecubecheat=ON) else (set Gamecubecheat=OFF)
goto:cheatcodeoptions

:NEScheat
if /i "%NEScheat%" EQU "OFF" (set NEScheat=ON) else (set NEScheat=OFF)
goto:cheatcodeoptions

:SNEScheat
if /i "%SNEScheat%" EQU "OFF" (set SNEScheat=ON) else (set SNEScheat=OFF)
goto:cheatcodeoptions

:N64cheat
if /i "%N64cheat%" EQU "OFF" (set N64cheat=ON) else (set N64cheat=OFF)
goto:cheatcodeoptions

:SMScheat
if /i "%SMScheat%" EQU "OFF" (set SMScheat=ON) else (set SMScheat=OFF)
goto:cheatcodeoptions

:Segacheat
if /i "%Segacheat%" EQU "OFF" (set Segacheat=ON) else (set Segacheat=OFF)
goto:cheatcodeoptions

:NeoGeocheat
if /i "%NeoGeocheat%" EQU "OFF" (set NeoGeocheat=ON) else (set NeoGeocheat=OFF)
goto:cheatcodeoptions

:Commodorecheat
if /i "%Commodorecheat%" EQU "OFF" (set Commodorecheat=ON) else (set Commodorecheat=OFF)
goto:cheatcodeoptions

:MSXcheat
if /i "%MSXcheat%" EQU "OFF" (set MSXcheat=ON) else (set MSXcheat=OFF)
goto:cheatcodeoptions

:TurboGraFX-16cheat
if /i "%TurboGraFX-16cheat%" EQU "OFF" (set TurboGraFX-16cheat=ON) else (set TurboGraFX-16cheat=OFF)
goto:cheatcodeoptions

:TurboGraFX-CDcheat
if /i "%TurboGraFX-CDcheat%" EQU "OFF" (set TurboGraFX-CDcheat=ON) else (set TurboGraFX-CDcheat=OFF)
goto:cheatcodeoptions

:deselectallcheats
set wiicheat=OFF
set WiiWarecheat=OFF
set VCArcadecheat=OFF
set WiiChannelscheat=OFF
set Gamecubecheat=OFF
set NEScheat=OFF
set SNEScheat=OFF
set N64cheat=OFF
set SMScheat=OFF
set Segacheat=OFF
set NeoGeocheat=OFF
set Commodorecheat=OFF
set MSXcheat=OFF
set TurboGraFX-16cheat=OFF
set TurboGraFX-CDcheat=OFF
goto:cheatcodeoptions



:DRIVECHANGE
set drivetemp=%DRIVE%
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo         Enter the drive letter (or Path) to save files for your SD Card

::the below msg is only for people building a nand
if /i "%SNEEKSELECT%" EQU "2" goto:donotskip
if /i "%SNEEKSELECT%" EQU "3" (goto:donotskip) else (goto:skip)
:donotskip
echo.
echo.
echo         Note: WADs installed to emulated NAND will also be saved to this location
echo               so they will not need to be redownloaded to build future NANDs
:skip

echo.
echo.
echo             Current Setting:   %Drive%
echo.
echo.
echo         Notes: * To continue using Current Settings
echo                  leave the selection blank and hit enter.
echo.
echo                * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo                * If you experience errors, try removing/adding quotes
echo                  before and after your text
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            %%userprofile%%\Desktop\COPY_TO_SD
echo                  Note: %%userprofile%% shortcut doesn't work on Windows XP
echo.
echo            NUSAD\4.2U
echo                  Note: this creates NUSAD\4.2U folders where this program is Saved
echo.
echo            C:\Users\XFlak\Desktop\New Folder
echo.
echo.
echo.
echo         D = Default Setting: COPY_TO_SD
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p Drivetemp=     Enter Selection Here: 


if /i "%DRIVETEMP%" EQU "M" goto:MENU

if /i "%DRIVETEMP%" EQU "B" goto:%BACKB4DRIVE%

if /i "%DRIVETEMP%" EQU "D" set DRIVETEMP=COPY_TO_SD

set DRIVE=%DRIVETEMP%

if exist "%Drive%"\Download_Log.md5 del "%Drive%"\Download_Log.md5>nul
if exist "%Drive%"\Global_Log.md5 del "%Drive%"\Global_Log.md5>nul

if /i "%MENU1%" EQU "FC" goto:FileCleanup
if /i "%MENU1%" EQU "U" set BACKB4QUEUE=DRIVECHANGE
if /i "%MENU1%" EQU "U" goto:DOWNLOADQUEUE
if /i "%WLAST%" EQU "Y" set BACKB4QUEUE=DRIVECHANGE
if /i "%WLAST%" EQU "Y" goto:DOWNLOAD

if /i "%SNEEKTYPE%" EQU "U" set BACKB4DRIVEU=DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "UD" set BACKB4DRIVEU=DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "U" goto:DRIVEUCHANGE
if /i "%SNEEKTYPE%" EQU "UD" goto:DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "2" set B4SNKPAGE3=DRIVECHANGE
if /i "%SNEEKSELECT%" EQU "3" set B4SNKPAGE3=DRIVECHANGE
if /i "%SNEEKSELECT%" EQU "2" goto:snkpage3
if /i "%SNEEKSELECT%" EQU "3" goto:snkpage3
if /i "%SNEEKSELECT%" EQU "1" set B4SNKCONFIRM=DRIVECHANGE
if /i "%SNEEKSELECT%" EQU "1" goto:SNKNANDCONFIRM

goto:Options








:DRIVEUCHANGE
set driveUtemp=%DRIVEU%
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo         Enter the drive letter (or Path) to save files for your USB Hard Drive
echo.
echo.
echo             Current Setting:   %DriveU%
echo.
echo.
echo         Notes: * To continue using Current Settings
echo                  leave the selection blank and hit enter.
echo.
echo                * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo                * If you experience errors, try removing/adding quotes
echo                  before and after your text
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            %%userprofile%%\Desktop\COPY_TO_USB
echo                  Note: %%userprofile%% shortcut doesn't work on Windows XP
echo.
echo            NUSAD\4.2U
echo                  Note: this creates NUSAD\4.2U folders where this program is Saved
echo.
echo            C:\Users\XFlak\Desktop\New Folder
echo.
echo.
echo.
echo         D = Default Setting: COPY_TO_USB
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p DriveUtemp=     Enter Selection Here: 


if /i "%DRIVEUTEMP%" EQU "M" goto:MENU

if /i "%DRIVEUTEMP%" EQU "B" goto:%BACKB4DRIVEU%

if /i "%DRIVEUTEMP%" EQU "D" set DRIVEUTEMP=COPY_TO_USB

set DRIVEU=%DRIVEUTEMP%

if exist "%DRIVEU%"\Download_Log.md5 del "%DRIVEU%"\Download_Log.md5

if /i "%SNEEKSELECT%" EQU "1" set B4SNKCONFIRM=DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "1" goto:SNKNANDCONFIRM
if /i "%SNEEKSELECT%" EQU "2" set B4SNKPAGE3=DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "3" set B4SNKPAGE3=DRIVEUCHANGE
if /i "%SNEEKSELECT%" EQU "2" goto:snkpage3
if /i "%SNEEKSELECT%" EQU "3" goto:snkpage3
if /i "%SNEEKSELECT%" EQU "4" goto:SNKDISCEX2

::if /i "%MENU1%" EQU "U" goto:DOWNLOADQUEUE
::if /i "%WLAST%" EQU "Y" goto:DOWNLOAD

if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVEU%
if /i "%USBCONFIG%" EQU "USB" set BACKB4QUEUE=DRIVEUCHANGE
if /i "%USBCONFIG%" EQU "USB" goto:DownloadQueue

goto:Options







:UpdateNUSAD
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                Current Version is %CurrentVersion%
echo.
echo                                 Checking for updates...
echo.
start %nusadmin%/wait wget http://nusad.googlecode.com/files/%UPDATENAME%

if not exist %UPDATENAME% goto:updatefail

ren %UPDATENAME% NUSAutoUpdate.bat

call NUSAutoUpdate.bat

if %currentversion% GEQ %newversion% (goto:menu) else (exit)

:updatefail
echo   Update check has failed, check your internet connection and firewall settings.
@ping 127.0.0.1 -n 4 -w 1000> nul
goto:menu





::-------------------------------File Cleanup------------------------------------
:FileCleanup
cls

set cleanitems=0
if exist "%DRIVE%"\WAD SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00000001 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00010008 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00010002 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\00010001 SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\private\wii\title\aktn SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\DOP-Mii SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\MMM SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\MIOSPatcher SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\Priiloader SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\YAWMM SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\HackMii_Installer SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\apps\TBR SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.dol SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.elf SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.wad SET /a cleanitems=%cleanitems%+1
if exist "%DRIVE%"\*.md5 SET /a cleanitems=%cleanitems%+1


::smash stack check
set path2clean=%DRIVE%\private\wii\app\rsbe\st\st_080805_0933.bin
set md5=aa93aab9bfdd25883bbd826a62645033
set nextgoto=cleancheck1
goto:markmatch
:cleancheck1
set SmashCheck=off
if /i "%match%" EQU "YES" set SmashCheck=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::PWNS USA
set path2clean=%DRIVE%\private\wii\title\rlie\data.bin
set md5=b94f40d57a4b5577eb2479f63cbe79df
set nextgoto=cleancheck2
goto:markmatch
:cleancheck2
set PWNSU=off
if /i "%match%" EQU "YES" set PWNSU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::PWNS JAP
set path2clean=%DRIVE%\private\wii\title\rlij\data.bin
set md5=1f7e42a30492d2fa116a2fe5ebc685d1
set nextgoto=cleancheck3
goto:markmatch
:cleancheck3
set PWNSJ=off
if /i "%match%" EQU "YES" set PWNSJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::PWNS EURO
set path2clean=%DRIVE%\private\wii\title\rlip\data.bin
set md5=a6b8f03f49baa471228dcd81d3fd623a
set nextgoto=cleancheck4
goto:markmatch
:cleancheck4
set PWNSE=off
if /i "%match%" EQU "YES" set PWNSE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::TWILIGHT USA
set path2clean=%DRIVE%\private\wii\title\rzde\data.bin
set md5=02639bd145730269a98f69a4fd466225
set nextgoto=cleancheck5
goto:markmatch
:cleancheck5
set TWIU=off
if /i "%match%" EQU "YES" set TWIU=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::TWILIGHT JAP
set path2clean=%DRIVE%\private\wii\title\rzdj\data.bin
set md5=b51cd6a64bc911cc5c8e41ed5d9fd8ae
set nextgoto=cleancheck6
goto:markmatch
:cleancheck6
set TWIJ=off
if /i "%match%" EQU "YES" set TWIJ=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1

::TWILIGHT EURO
set path2clean=%DRIVE%\private\wii\title\rzdp\data.bin
set md5=704bd625ea5b42d7ac06fc937af74d38
set nextgoto=cleancheck7
goto:markmatch
:cleancheck7
set TWIE=off
if /i "%match%" EQU "YES" set TWIE=on
if /i "%match%" EQU "YES" SET /a cleanitems=%cleanitems%+1



goto:nextpage



::----mark matches-----
:markmatch
set match=
if exist "%path2clean%" (goto:checkexisting) else (goto:nocheckexisting)
:checkexisting
set match=yes
::assume match, if its not, it will change to 'no' further below
sfk md5 -quiet -verify %md5% "%path2clean%"
if errorlevel 1 set match=no
:nocheckexisting
goto:%nextgoto%


:nextpage

if /i "%cleanitems%" NEQ "0" goto:FileCleanup2

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                     FILE CLEANUP
echo.
echo.
echo                       No Unnecessary Files Exist in %DRIVE%
echo.
echo.
echo.
echo                               Returning to Main Menu...
echo.

@ping 127.0.0.1 -n 4 -w 1000> nul
goto:MENU





:FileCleanup2
set clean=
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                     FILE CLEANUP
echo.
echo.
echo                        After you are finished modding your Wii,
echo                     you can delete certain files to free up space
echo          and ensure no one can access potentially dangerous apps on your Wii.
echo.
echo.
echo          Note: Instead of deleting apps, you can move them to a Locked Folder
echo                in the HBC (downloadable via Batch Download Page 2).
echo.
echo.
echo          Would you like to delete the following from %DRIVE%?
echo.
if exist "%DRIVE%"\WAD echo          * WAD Folder
if exist "%DRIVE%"\00000001 echo          * 00000001 Folder
if exist "%DRIVE%"\00010008 echo          * 00010008 Folder
if exist "%DRIVE%"\00010002 echo          * 00010002 Folder
if exist "%DRIVE%"\00010001 echo          * 00010001 Folder
if exist "%DRIVE%"\private\wii\title\aktn echo          * Bannerbomb
if /i "%SmashCheck%" EQU "on" echo          * Smash Stack
if /i "%PWNSU%" EQU "on" echo          * Indiana Pwns (USA)
if /i "%PWNSE%" EQU "on" echo          * Indiana Pwns (EURO)
if /i "%PWNSJ%" EQU "on" echo          * Indiana Pwns (JAP)
if /i "%TWIU%" EQU "on" echo          * Twilight Hack (USA)
if /i "%TWIE%" EQU "on" echo          * Twilight Hack (EURO)
if /i "%TWIJ%" EQU "on" echo          * Twilight Hack (JAP)
if exist "%DRIVE%"\apps\DOP-Mii echo          * apps\DOP-Mii
if exist "%DRIVE%"\apps\MMM echo          * apps\MMM
if exist "%DRIVE%"\apps\MIOSPatcher echo          * apps\MIOSPatcher
if exist "%DRIVE%"\apps\Priiloader echo          * apps\Priiloader
if exist "%DRIVE%"\apps\YAWMM echo          * apps\YAWMM
if exist "%DRIVE%"\apps\HackMii_Installer echo          * apps\HackMii_Installer
if exist "%DRIVE%"\apps\TBR echo          * apps\TBR
if exist "%DRIVE%"\apps\WiiXplorer echo          * apps\WiiXplorer
if exist "%DRIVE%"\*.dol echo          * dol's from root of device
if exist "%DRIVE%"\*.elf echo          * elf's from root of device
if exist "%DRIVE%"\*.wad echo          * wad's from root of device
if exist "%DRIVE%"\*.md5 echo          * md5's from root of device
echo.
echo         Note: All the above files, with the exception of custom WADs,
echo               can be retrieved again later using NUSAD
echo.
echo.
echo.
echo                Y = Yes, delete files now
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
set /p clean=     Enter Selection Here: 
if /i "%clean%" EQU "Y" goto:cleannow
if /i "%clean%" EQU "N" goto:MENU
if /i "%clean%" EQU "B" goto:MENU
if /i "%clean%" EQU "M" goto:MENU
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FileCleanup

:cleannow
set clean2=
echo.
echo.
echo.
echo          Are you sure you want to permanently delete the above files? (Y/N)
echo.
set /p clean2=     Enter Selection Here: 
if /i "%clean2%" EQU "Y" goto:cleannow3
if /i "%clean2%" EQU "N" goto:MENU
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FileCleanup

:cleannow3



cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                    CLEANING FILES...
echo.
if exist "%DRIVE%"\*.dol del "%DRIVE%"\*.dol> nul
if exist "%DRIVE%"\*.elf del "%DRIVE%"\*.elf> nul
if exist "%DRIVE%"\*.wad del "%DRIVE%"\*.wad> nul
if exist "%DRIVE%"\*.md5 del "%DRIVE%"\*.md5> nul
if exist "%DRIVE%"\WAD rd /s /q "%DRIVE%"\WAD> nul
if exist "%DRIVE%"\00000001 rd /s /q "%DRIVE%"\00000001> nul
if exist "%DRIVE%"\00010008 rd /s /q "%DRIVE%"\00010008> nul
if exist "%DRIVE%"\00010002 rd /s /q "%DRIVE%"\00010002> nul
if exist "%DRIVE%"\00010001 rd /s /q "%DRIVE%"\00010001> nul
if exist "%DRIVE%"\private\wii\title\aktn rd /s /q "%DRIVE%"\private\wii\title\aktn> nul
if exist "%DRIVE%"\apps\DOP-Mii rd /s /q "%DRIVE%"\apps\DOP-Mii> nul
if exist "%DRIVE%"\apps\MMM rd /s /q "%DRIVE%"\apps\MMM> nul
if exist "%DRIVE%"\apps\MIOSPatcher rd /s /q "%DRIVE%"\apps\MIOSPatcher> nul
if exist "%DRIVE%"\apps\Priiloader rd /s /q "%DRIVE%"\apps\Priiloader> nul
if exist "%DRIVE%"\apps\YAWMM rd /s /q "%DRIVE%"\apps\YAWMM> nul
if exist "%DRIVE%"\apps\HackMii_Installer rd /s /q "%DRIVE%"\apps\HackMii_Installer> nul
if exist "%DRIVE%"\apps\TBR rd /s /q "%DRIVE%"\apps\TBR> nul
if exist "%DRIVE%"\apps\WiiXplorer rd /s /q "%DRIVE%"\apps\WiiXplorer> nul
if exist "%DRIVE%"\private\*.zip del "%DRIVE%"\private\*.zip> nul

if /i "%SmashCheck%" NEQ "on" goto:skip
del "%DRIVE%"\private\wii\app\rsbe\st\st_080805_0933.bin> nul
:skip

if /i "%PWNSU%" NEQ "on" goto:skip
rd /s /q "%DRIVE%"\private\wii\title\rlie> nul
:skip

if /i "%PWNSJ%" NEQ "on" goto:skip
rd /s /q "%DRIVE%"\private\wii\title\rlij> nul
:skip

if /i "%PWNSE%" NEQ "on" goto:skip
rd /s /q "%DRIVE%"\private\wii\title\rlip> nul
:skip

if /i "%TWIU%" NEQ "on" goto:skip
rd /s /q "%DRIVE%"\private\wii\title\rzde> nul
:skip

if /i "%TWIE%" NEQ "on" goto:skip
rd /s /q "%DRIVE%"\private\wii\title\rzdp> nul
:skip

if /i "%TWIJ%" NEQ "on" goto:skip
rd /s /q "%DRIVE%"\private\wii\title\rzdj> nul
:skip

echo                                    FILES CLEANED
echo.
echo.
@ping 127.0.0.1 -n 3 -w 1000> nul
goto:MENU


::--------------------Wizard Settings Detected----------------
:LoadWizardSettings
set LoadWizSettings=
if not exist Wizard_Settings.bat goto:WPAGE1

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] Wizard Saved Settings Detected!
echo.
echo.
echo               Would you like to load the Wizard's Saved Settings now?
echo.
echo.
echo.
echo         Note: You will be able to view and confirm the loaded settings
echo               before starting your download
echo.
echo.
echo.
echo                Y = Yes, Load Wizard_Settings.bat
echo                N = No, Continue with the Download Wizard
echo.
echo                D = Delete Wizard_Settings.bat to stop seeing this page
echo                    in the future then continue with the Download Wizard
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p LoadWizSettings=     Enter Selection Here: 


if /i "%LoadWizSettings%" EQU "B" goto:MENU
if /i "%LoadWizSettings%" EQU "M" goto:MENU
if /i "%LoadWizSettings%" EQU "Y" call Wizard_Settings.bat
if /i "%LoadWizSettings%" EQU "Y" goto:WPAGELAST

if /i "%LoadWizSettings%" EQU "D" del Wizard_Settings.bat
if /i "%LoadWizSettings%" EQU "D" goto:WPAGE1
if /i "%LoadWizSettings%" EQU "N" goto:WPAGE1

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:LoadWizardSettings






::...................................Wizard Page1 - Virgin?...............................
:WPAGE1
set VIRGIN=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo         Is your Wii a virgin?
echo.
echo.
echo               ( ie. free of softmods / un-modified / brand new / stock )
echo.
echo.
echo.
echo                 Note: answer yes if you intend to upgrade your wii's softmods
echo                       (aka re-hack your wii)
echo.
echo.
echo.
echo                Y = Yes (download files to hack my virgin wii)
echo                N = No, my wii is already modded
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p VIRGIN=     Enter Selection Here: 


if exist Wizard_Settings.bat goto:backtoloadwiz
if /i "%VIRGIN%" EQU "B" goto:MENU
:backtoloadwiz
if /i "%VIRGIN%" EQU "B" goto:LoadWizardSettings

if /i "%VIRGIN%" EQU "M" goto:MENU
if /i "%VIRGIN%" EQU "Y" goto:WPAGE2
if /i "%VIRGIN%" EQU "N" goto:WPAGE2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE1

::...................................Wizard Page2 - Current Firmware...............................
:WPAGE2
set FIRMSTART=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if /i "%MENU1%" EQU "H" echo                                  HackMii Solutions
if /i "%MENU1%" EQU "H" echo.
echo         What is your current firmware version?
echo.
echo.
echo.
echo         Note: to check this, turn on your wii, click the Wii button in the
echo               bottom left of the main system menu, click Wii Settings,
echo               then you should see the firmware in the top right of the screen
echo               (ie. 4.2U, 4.1J, 3.2E, etc.)

if /i "%VIRGIN%" EQU "N" goto:skipnote
echo.
echo         Note: If current firmware is v2.2 or under, you may need to use an
echo               alternate exploit [ie. Twilight Hack (U/E/J), Smash Stack (U)
echo               or Indiana Pwns (U/E)] instead of BannerBomb.
echo.
:skipnote
echo.
echo.
echo.
echo                4.3 = 4.3
echo                4.2 = 4.2
echo                4.1 = 4.1
echo                4.0 = 4.0
echo                3.X = 3.0-3.5
echo                  O = Other (under 2.2)

echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.

set /p FIRMSTART=     Enter Selection Here: 




if /i "%FIRMSTART%" EQU "M" goto:MENU


if /i "%FIRMSTART%" EQU "4.2" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.1" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.0" goto:WPAGE3
if /i "%FIRMSTART%" EQU "3.x" set FIRMSTART=3.X
if /i "%FIRMSTART%" EQU "3.X" goto:WPAGE3
if /i "%FIRMSTART%" EQU "O" goto:WPAGE3
if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3

if /i "%MENU1%" EQU "H" goto:HACKMIIBACK

if /i "%FIRMSTART%" EQU "B" goto:WPAGE1
goto:incorrectkey

:HACKMIIBACK
if /i "%FIRMSTART%" EQU "B" goto:MENU

:incorrectkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE2


::...................................Wizard Page3 - REGION...............................
:WPAGE3
if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3hard
if /i "%FIRMSTART%" EQU "o" goto:WPAGE3hard
if /i "%MENU1%" EQU "H" goto:HACKMIISOLUTION
:WPAGE3hard
set REGION=
set REGIONCHANGE=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo         What is your Region?
echo.
echo.
echo         Note: to check this, turn on your wii, click the Wii button in the
echo               bottom left of the main system menu, click Wii Settings,
echo               then you should see the firmware in the top right of the screen
echo               (ie. 4.2U, 4.1J, 3.2E, etc.)
echo.
if /i "%MENU1%" EQU "H" echo         Note: If your Wii was Region Changed choose the region you are currently on
if /i "%MENU1%" EQU "H" goto:skipmessage
echo         Note: If your Wii is Region Changed but was originally NOT Korean,
echo               choose the region you are currently on.
echo.
echo         Note: If your not sure if your Wii was originally Korean, you can check
echo               the serial number on the Wii. Korean Wii's start with "LK".
:skipmessage
echo.
echo.

echo                U = USA
echo                E = Euro (PAL)

if /i "%MENU1%" EQU "H" goto:OtherRegions

::Virgins 4.3's, Virgin others v2.2 (and under)
::if /i "%VIRGIN%" EQU "N" goto:OtherRegions
::if /i "%FIRMSTART%" EQU "4.3" echo               RC = Region Changed (from Korean to another region)
::if /i "%FIRMSTART%" EQU "4.3" echo.

if /i "%FIRMSTART%" EQU "4.3" goto:OtherRegions
if /i "%FIRMSTART%" EQU "o" echo                J = JAP
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" sfk echo -spat \x20 [Red] WARNING: Online update to v4.3 makes JAP and Korean Wii's unhackable (for now)
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" sfk echo -spat \x20 [Red] Note to Japanese Users:
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" echo    Twilight Princess (Wii Game) required to modify JAP Virgin Wii's v2.2 and under.
if /i "%FIRMSTART%" EQU "o" echo    Alternatively, you can update your Wii to v3.0-4.2 using a DISC (ie. NSMBW) 
if /i "%FIRMSTART%" EQU "o" echo    then repeat the Download Wizard using your new Firmware


if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" echo.
if /i "%FIRMSTART%" EQU "o" sfk echo -spat \x20 [Red] Note to Korean Users:
if /i "%FIRMSTART%" EQU "o" echo.

if /i "%FIRMSTART%" EQU "o" echo    Korean Virgin Wii's v2.2 and under can only be hacked if
if /i "%FIRMSTART%" EQU "o" echo    you update your Wii to v3.0-4.2 using a DISC (ie. New Super Mario Bros Wii)
if /i "%FIRMSTART%" EQU "o" echo.

if /i "%FIRMSTART%" EQU "o" goto:SkipOtherRegions
if /i "%FIRMSTART%" NEQ "o" goto:OtherRegions

:OtherRegions
if /i "%VIRGIN%" NEQ "Y" goto:displayJK
if /i "%FIRMSTART%" EQU "4.3" goto:nodisplayJK
:displayJK
echo                J = JAP
echo                K = Korean
:nodisplayJK

if /i "%MENU1%" NEQ "H" echo               RC = Region Changed (from Korean to another region)
if /i "%VIRGIN%" NEQ "Y" goto:SkipOtherRegions
if /i "%FIRMSTART%" EQU "4.3" echo.
if /i "%FIRMSTART%" EQU "4.3" echo.
if /i "%FIRMSTART%" EQU "4.3" sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] JAP And Korean Virgin 4.3 Wii's cannot be hacked (yet)
if /i "%FIRMSTART%" EQU "4.3" echo.
if /i "%FIRMSTART%" EQU "4.3" echo.
if /i "%FIRMSTART%" EQU "4.3" sfk echo -spat \x20 [Red] Note to European Users:
if /i "%FIRMSTART%" EQU "4.3" echo.
if /i "%FIRMSTART%" EQU "4.3" sfk echo -spat \x20 [Red] LEGO Indiana Jones (Wii Game) required to modify Virgin PAL Wii's v2.2 and under.
:SkipOtherRegions

echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.

set /p REGION=     Enter Selection Here: 

if /i "%REGION%" EQU "u" set REGION=U
if /i "%REGION%" EQU "e" set REGION=E
if /i "%REGION%" EQU "j" set REGION=J
if /i "%REGION%" EQU "k" set REGION=K

if /i "%REGION%" EQU "M" goto:MENU
if /i "%REGION%" EQU "B" goto:WPAGE2
if /i "%REGION%" EQU "U" goto:WPAGE3C
if /i "%REGION%" EQU "E" goto:WPAGE3C

if /i "%MENU1%" EQU "H" goto:notRC
if /i "%FIRMSTART%" EQU "o" goto:notRC
if /i "%REGION%" EQU "RC" goto:WPAGE3B
:notRC

if /i "%FIRMSTART%" NEQ "o" goto:notother
if /i "%REGION%" EQU "J" goto:WPAGE3C
:notother

if /i "%VIRGIN%" NEQ "Y" goto:JK
if /i "%FIRMSTART%" EQU "4.3" goto:noJK
:JK
if /i "%REGION%" EQU "J" goto:WPAGE4
if /i "%FIRMSTART%" EQU "o" goto:noJK
if /i "%REGION%" EQU "K" goto:WPAGE4
:noJK

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE3

::...................................Wizard Page3B - REGION CHANGED KOREAN...............................
:WPAGE3B
set REGIONCHANGE=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo         What has your Wii's Region been changed to?
echo.
echo.
echo.
echo         Note: to check this, turn on your wii, click the Wii button in the
echo               bottom left of the main system menu, click Wii Settings,
echo               then you should see the firmware in the top right of the screen
echo               (ie. 4.2U, 4.1J, 3.2E, etc.)
echo.
echo.
echo.
echo                U = USA
echo                E = Euro (PAL)

if /i "%VIRGIN%" EQU "N" goto:showJ
if /i "%FIRMSTART%" EQU "4.3" goto:skipJ
:showJ
echo                J = JAP
goto:skipafew

:skipJ
if /i "%FIRMSTART%" EQU "4.3" echo.
if /i "%FIRMSTART%" EQU "4.3" sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] JAP And Korean Virgin 4.3 Wii's cannot be hacked (yet)
:skipafew


echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p REGIONCHANGE=     Enter Selection Here: 

if /i "%REGIONCHANGE%" EQU "u" set REGIONCHANGE=U
if /i "%REGIONCHANGE%" EQU "e" set REGIONCHANGE=E
if /i "%REGIONCHANGE%" EQU "j" set REGIONCHANGE=J

if /i "%REGIONCHANGE%" EQU "M" goto:MENU
if /i "%REGIONCHANGE%" EQU "B" goto:WPAGE3
if /i "%REGIONCHANGE%" EQU "U" goto:WPAGE3C
if /i "%REGIONCHANGE%" EQU "E" goto:WPAGE3C

if /i "%VIRGIN%" EQU "N" goto:showJ2
if /i "%FIRMSTART%" EQU "4.3" goto:nojap
:showJ2
if /i "%REGIONCHANGE%" EQU "J" goto:WPAGE3C
:nojap

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE3b







::...................................Wizard Page3C - Exploit...............................
:WPAGE3C

SET EXPLOIT=default
set exploitselection=
if /i "%VIRGIN%" EQU "N" goto:WPAGE4

if /i "%FIRMSTART%" EQU "4.3" goto:WPAGE3Cnext
if /i "%FIRMSTART%" EQU "o" goto:WPAGE3Cnext

goto:WPAGE4

::Only virgin 4.3 U/E wii's or <2.2 U/E/J Wii's will make it this far
:WPAGE3Cnext

if /i "%REGION%" EQU "J" set EXPLOIT=T
if /i "%REGION%" EQU "J" goto:WPAGE4
if /i "%REGIONCHANGE%" EQU "J" set EXPLOIT=T
if /i "%REGIONCHANGE%" EQU "J" goto:WPAGE4


if /i "%FIRMSTART%" NEQ "4.3" goto:WPAGE3Cnext2
if /i "%REGION%" EQU "E" set EXPLOIT=L
if /i "%REGION%" EQU "E" goto:WPAGE4
if /i "%REGIONCHANGE%" EQU "E" set EXPLOIT=L
if /i "%REGIONCHANGE%" EQU "E" goto:WPAGE4

:WPAGE3Cnext2
set exploitselection=yes

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if /i "%MENU1%" NEQ "H" echo      You must own, rent, or borrow one of the following games to mod your Wii
if /i "%MENU1%" EQU "H" echo      If your homebrew channel can't load apps properly, you must own, rent,
if /i "%MENU1%" EQU "H" echo      or borrow one of the following two games to fix the problem.
echo.
echo      Select the game you wish to use:
echo.
echo.
echo.
echo.
if /i "%REGIONCHANGE%" EQU "U" echo                S = Super Smash Brothers Brawl
if /i "%REGION%" EQU "U" echo                S = Super Smash Brothers Brawl
echo.
echo                L = LEGO Indiana Jones
echo.
if /i "%FIRMSTART%" EQU "o" echo                T = Twilight Princess: The Legend of Zelda
if /i "%FIRMSTART%" EQU "o" echo.
echo                ? = If you're not sure, download all of the above and decide later
echo.
echo.
echo.
echo.


if /i "%FIRMSTART%" NEQ "o" goto:skipOmsg
sfk echo -spat \x20 [Red] Important Notes:
echo.


echo    Alternatively, you can update your Wii to v3.0-4.2 using a DISC (ie. NSMBW)
echo    then repeat the Download Wizard using your new Firmware
echo.
if /i "%REGION%" EQu "E" sfk echo -spat \x20 [Red] WARNING: Online update to v4.3 will require LEGO Indiana Jones to mod Euro Wii's
if /i "%REGION%" EQu "U" sfk echo -spat \x20 [Red] WARNING: Online update to v4.3 will require Super Smash Brothers Brawl or
if /i "%REGION%" EQu "U" sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] LEGO Indiana Jones to mod USA Wii's
echo.
echo.

:skipOmsg

echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p EXPLOIT=     Enter Selection Here: 

if /i "%EXPLOIT%" EQU "M" goto:MENU
if /i "%EXPLOIT%" EQU "B" goto:WPAGE3

if /i "%REGION%" NEQ "U" goto:nosmashstack
if /i "%EXPLOIT%" EQU "S" goto:WPAGE4
:nosmashstack

if /i "%EXPLOIT%" EQU "L" goto:WPAGE4
if /i "%EXPLOIT%" EQU "?" goto:WPAGE4

if /i "%FIRMSTART%" NEQ "o" goto:twilightnotavailable
if /i "%EXPLOIT%" EQU "T" goto:WPAGE4
:twilightnotavailable

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE3C










::...................................Wizard Page4 - New Firmware...............................
:WPAGE4
if /i "%MENU1%" EQU "H" goto:HACKMIISOLUTION
set FIRM=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo         Select the new firmware you would like to upgrade/downgrade to.
echo.
echo.
echo.
echo         Note: if current firmware = new firmware, a system menu is not downloaded
echo.
echo.
echo.
sfk echo -spat \x20 \x20 \x20 [Red] Warning:[def] installing firmware below 4.0 on boot2v4 wii's results in Brick.
echo             But, Yet Another Wad Manager (YAWMM) or MMM will not permit you to
echo             (un)install anything that will brick you.
echo             You can manually check your boot2 version using MMM, DOP-Mii or Bootmii.
echo.
echo.
echo.

if /i "%FIRMSTART%" NEQ "4.3" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] 4.3 = 4.3 [NOT RECOMMENDED]) else (echo                4.3 = 4.3)
if /i "%FIRMSTART%" EQU "4.2" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 4.2 = 4.2 [RECOMMENDED]) else (echo                4.2 = 4.2)
if /i "%FIRMSTART%" NEQ "4.2" (sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Green] 4.1 = 4.1 [RECOMMENDED]) else (echo                4.1 = 4.1)


echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p FIRM=     Enter Selection Here: 

if /i "%FIRM%" EQU "M" goto:MENU

if /i "%FIRM%" EQU "4.2" goto:WPAGE5
if /i "%FIRM%" EQU "4.1" goto:WPAGE5

if /i "%VIRGIN%" NEQ "Y" goto:noskip
if /i "%REGION%" EQU "J" goto:skip
if /i "%REGION%" EQU "K" goto:skip
:noskip
if /i "%FIRM%" EQU "4.3" goto:WPAGE5
:skip



if /i "%REGION%" EQU "RC" goto:backtowpage3b
if /i "%exploitselection%" EQU "yes" goto:backtoExploits

if /i "%FIRM%" EQU "B" goto:wpage3

:backtoExploits
if /i "%FIRM%" EQU "B" goto:wpage3C

:backtowpage3b
if /i "%FIRM%" EQU "B" goto:wpage3B

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE4

::...................................Wizard Page5 - MORE Channels?...............................
:WPAGE5
set MORE=
set PIC=
set NET=
set Weather=
set NEWS=
set Mii=
set Shop=
set Speak=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Would you like to download any of the following channels:
echo.
echo.
echo.
echo           * Photo
if /i "%REGION%" NEQ "K" echo           * Internet
if /i "%REGION%" NEQ "K" echo           * Weather
if /i "%REGION%" NEQ "K" echo           * News
echo           * Mii
echo           * Shopping
if /i "%REGION%" NEQ "K" echo           * Wii Speak
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p MORE=     Enter Selection Here: 

if /i "%MORE%" EQU "M" goto:MENU
if /i "%MORE%" EQU "Y" goto:WPAGE6

if /i "%MENU1%" EQU "S" goto:forsneeknand
if /i "%MORE%" EQU "B" goto:WPAGE4
if /i "%MORE%" EQU "N" goto:WPAGE13

:forsneeknand
if /i "%MORE%" EQU "B" goto:SNKPAGE5
if /i "%MORE%" EQU "N" set B4SNKCONFIRM=WPAGE5
if /i "%MORE%" EQU "N" goto:SNKNANDCONFIRM

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE5




::...................................Wizard Page6 - Photo Channel...............................
:WPAGE6
set PIC=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Photo Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p PIC=     Enter Selection Here: 

if /i "%PIC%" EQU "Y" goto:WPAGE7
if /i "%PIC%" EQU "N" goto:WPAGE7
if /i "%PIC%" EQU "M" goto:MENU
if /i "%PIC%" EQU "B" goto:WPAGE5

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE6



::...................................Wizard Page7 - Internet?...............................
:WPAGE7

if /i "%REGION%" EQU "K" goto:WPAGE10
set NET=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Internet Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p NET=     Enter Selection Here: 

if /i "%NET%" EQU "Y" goto:WPAGE8
if /i "%NET%" EQU "N" goto:WPAGE8
if /i "%NET%" EQU "M" goto:MENU
if /i "%NET%" EQU "B" goto:WPAGE6

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE7



::...................................Wizard Page8 - Weather...............................
:WPAGE8
set Weather=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Weather Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p WEATHER=     Enter Selection Here: 

if /i "%WEATHER%" EQU "Y" goto:WPAGE9
if /i "%WEATHER%" EQU "N" goto:WPAGE9
if /i "%WEATHER%" EQU "M" goto:MENU
if /i "%WEATHER%" EQU "B" goto:WPAGE7

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE8

::...................................Wizard Page9 - NEWS...............................
:WPAGE9
set NEWS=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download News Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p NEWS=     Enter Selection Here: 

if /i "%NEWS%" EQU "Y" goto:WPAGE10
if /i "%NEWS%" EQU "N" goto:WPAGE10
if /i "%NEWS%" EQU "M" goto:MENU
if /i "%NEWS%" EQU "B" goto:WPAGE8

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE9

::...................................Wizard Page10 - Mii...............................
:WPAGE10
set Mii=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Mii Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p Mii=     Enter Selection Here: 

if /i "%Mii%" EQU "Y" goto:WPAGE11
if /i "%Mii%" EQU "N" goto:WPAGE11
if /i "%Mii%" EQU "M" goto:MENU

if /i "%REGION%" EQU "K" goto:Koreanbacktophoto
if /i "%Mii%" EQU "B" goto:WPAGE9

:Koreanbacktophoto
if /i "%Mii%" EQU "B" goto:WPAGE6

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE10

::...................................Wizard Page11 - Shop...............................
:WPAGE11


set Shop=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Shopping Channel?
if /i "%MENU1%" NEQ "S" echo.
if /i "%MENU1%" NEQ "S" echo.
if /i "%MENU1%" NEQ "S" echo.
if /i "%MENU1%" NEQ "S" echo          Note: IOS61 will also be downloaded
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SHOP=     Enter Selection Here: 

if /i "%Shop%" EQU "Y" goto:WPAGE12
if /i "%Shop%" EQU "N" goto:WPAGE12
if /i "%Shop%" EQU "M" goto:MENU
if /i "%Shop%" EQU "B" goto:WPAGE10

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE11


::...................................Wizard Page12 - Speak...............................
:WPAGE12
if /i "%REGION%" EQU "K" goto:WPAGE13
set Speak=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Wii Speak Channel?
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p Speak=     Enter Selection Here: 

if /i "%Speak%" EQU "Y" goto:WPAGE13
if /i "%Speak%" EQU "N" goto:WPAGE13
if /i "%Speak%" EQU "M" goto:MENU
if /i "%Speak%" EQU "B" goto:WPAGE11

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE12



::...................................Wizard Page13 - MORE Advanced Channels?...............................
:WPAGE13
if /i "%VIRGIN%" EQU "Y" goto:WPAGE19B
if /i "%MENU1%" EQU "S" set B4SNKCONFIRM=WPAGE12
if /i "%MENU1%" EQU "S" goto:SNKNANDCONFIRM

set Advanced=
set HM=
set H5=
set W19=
set MP=
set yawm=
set dop=
set pri=
set STUB=
set protect=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Would you like to download any of the following:
echo.
echo.
echo. 
if /i "%FIRMSTART%" EQU "3.X" echo           * HackMii Installer and BannerBomb v1 (with IOS58)
if /i "%FIRMSTART%" EQU "4.0" echo           * HackMii Installer and BannerBomb v1 (with IOS58)
if /i "%FIRMSTART%" EQU "4.1" echo           * HackMii Installer and BannerBomb v1 (with IOS58)
if /i "%FIRMSTART%" EQU "4.2" echo           * HackMii Installer and BannerBomb v2 (with IOS58)
if /i "%REGION%" EQU "K" goto:Korean2.2NoExploit
if /i "%FIRMSTART%" EQU "o" echo           * HackMii Installer and Twilight Hack (with IOS58)
if /i "%FIRMSTART%" EQU "o" goto:listthis
:Korean2.2NoExploit

if /i "%FIRMSTART%" NEQ "4.3" goto:skip4.3extra

if /i "%REGION%" EQU "U" echo           * HackMii Installer (with IOS58)
if /i "%REGION%" EQU "E" echo           * HackMii Installer (with IOS58)
if /i "%REGIONCHANGE%" EQU "U" echo           * HackMii Installer (with IOS58)
if /i "%REGIONCHANGE%" EQU "E" echo           * HackMii Installer (with IOS58)
:listthis
if /i "%REGION%" EQU "U" echo             Smash Stack and Indiana Pwns Exploits
if /i "%REGION%" EQU "E" echo             Indiana Pwns Exploit
if /i "%REGIONCHANGE%" EQU "U" echo             Smash Stack and Indiana Pwns Exploits
if /i "%REGIONCHANGE%" EQU "E" echo             Indiana Pwns Exploit

:skip4.3extra
echo.
echo           * Recommended cIOSs and cMIOS
echo.
echo           * Yet Another Wad Manager Mod v19 (YAWMM)
echo.

if /i "%REGION%" EQU "K" goto:skip
if "%FIRMSTART%" EQU "4.3" echo           * Download Trucha Bug Restorer [TBR]?
if "%FIRMSTART%" EQU "4.3" echo             with 2x IOS15, IOS36, IOS41 and MMM for installing a patched IOS236
:skip

if "%FIRMSTART%" NEQ "4.3" echo           * Download Multi-Mod-Manager [MMM]?
if "%FIRMSTART%" NEQ "4.3" echo             with 2x IOS15 and IOS36 for installing patched IOS36)



echo.

echo           * Priiloader v0.4 (with hacks.ini)
echo                  Note: hacks not available for 3.2J or 3.2K
echo.
echo           * Download Extra Brick Protection?
echo.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p Advanced=     Enter Selection Here: 

if /i "%Advanced%" EQU "M" goto:MENU

if /i "%MORE%" EQU "N" goto:BACK2MORE

if /i "%REGION%" EQU "K" goto:BACK2WPAGE11
if /i "%Advanced%" EQU "B" goto:WPAGE12

:BACK2MORE
if /i "%Advanced%" EQU "B" goto:WPAGE5

:BACK2WPAGE11
if /i "%Advanced%" EQU "B" goto:WPAGE11

if /i "%Advanced%" EQU "Y" goto:WPAGE13B
if /i "%Advanced%" EQU "N" goto:WPAGELAST

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE13


::...................................Wizard Page13B - HAckMii Installer...............................
:WPAGE13B
if /i "%FIRMSTART%" EQU "4.3" goto:moreof4.3
if /i "%FIRMSTART%" EQU "o" goto:moreofother
goto:neither

:moreof4.3
if /i "%REGION%" EQU "U" goto:neither
if /i "%REGION%" EQU "E" goto:neither
if /i "%REGION%" EQU "J" goto:WPAGE14
if /i "%REGIONCHANGE%" EQU "J" goto:WPAGE14
:moreofother
if /i "%REGION%" EQU "K" goto:WPAGE14
:neither

set HM=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if /i "%FIRMSTART%" EQU "3.X" echo      Download HackMii Installer and BannerBomb v1 (with IOS58)?
if /i "%FIRMSTART%" EQU "4.0" echo      Download HackMii Installer and BannerBomb v1 (with IOS58)?
if /i "%FIRMSTART%" EQU "4.1" echo      Download HackMii Installer and BannerBomb v1 (with IOS58)?
if /i "%FIRMSTART%" EQU "4.2" echo      Download HackMii Installer and BannerBomb v2 (with IOS58)?
if /i "%FIRMSTART%" EQU "o" echo      Download HackMii Installer and Twilight Hack (with IOS58)?
if /i "%FIRMSTART%" EQU "o" goto:listthis

if /i "%FIRMSTART%" NEQ "4.3" goto:skip4.3extra

if /i "%REGION%" EQU "U" echo      Download HackMii Installer (with IOS58)?
if /i "%REGION%" EQU "E" echo      Download HackMii Installer (with IOS58)?
if /i "%REGIONCHANGE%" EQU "U" echo      Download HackMii Installer (with IOS58)?
if /i "%REGIONCHANGE%" EQU "E" echo      Download HackMii Installer (with IOS58)?
:listthis
if /i "%REGION%" EQU "U" echo      Download Smash Stack and Indiana Pwns Exploits?
if /i "%REGION%" EQU "E" echo      Download Indiana Pwns Exploit?
if /i "%REGIONCHANGE%" EQU "U" echo      Download Smash Stack and Indiana Pwns Exploits?
if /i "%REGIONCHANGE%" EQU "E" echo      Download Indiana Pwns Exploit?
::echo      Download Trucha Bug Restorer (with IOS41v3091)?
:skip4.3extra
echo.
echo.
echo.
echo    Note: The Hackmii Installer can install the Homebrew Channel and/or Bootmii
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p HM=     Enter Selection Here: 

if /i "%HM%" EQU "Y" goto:WPAGE14
if /i "%HM%" EQU "N" goto:WPAGE14
if /i "%HM%" EQU "M" goto:MENU
if /i "%HM%" EQU "B" goto:WPAGE13



echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE13B


::...................................Wizard Page14 - cIOSs and cMIOSs...............................
:WPAGE14
set H5=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download the following recommended cIOSs and cMIOS?
echo.
echo.
echo.
echo          *cIOS202[57]-v5.wad
echo.
echo          *cIOS222[38]-v5.wad
echo.
echo          *cIOS223[37-38]-v4.wad
echo.
echo          *cIOS224[57]-v5.wad
echo.
echo          *cIOS249[57]-v19.wad
echo.
echo          *cIOS250[37]-v19.wad
echo.
echo          *RVL-cmios-v4_WiiGator_GCBL_v0.2.wad
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p H5=     Enter Selection Here: 

if /i "%H5%" EQU "Y" goto:WPAGE17
if /i "%H5%" EQU "N" goto:WPAGE17
if /i "%H5%" EQU "M" goto:MENU
if /i "%FIRMSTART%" EQU "4.3" goto:backtoWPAGE13
if /i "%FIRMSTART%" EQU "o" goto:backtoWPAGE13
if /i "%H5%" EQU "B" goto:WPAGE13B
:backtoWPAGE13
if /i "%H5%" EQU "B" goto:WPAGE13

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE14

::...................................Wizard Page15 and 16 removed...............................


::...................................Wizard Page17 - YAWMM...............................
:WPAGE17
set yawm=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Yet Another Wad Manager Mod (YAWMM)?
echo.
echo.
echo.
echo      Note: Other Wad Managers may not be compatible with cIOSs with non-IOS38 base
echo            If you're not using YAWMM as your main wad manager, you're missing out.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p yawm=     Enter Selection Here: 

if /i "%yawm%" EQU "Y" goto:WPAGE18
if /i "%yawm%" EQU "N" goto:WPAGE18
if /i "%yawm%" EQU "M" goto:MENU
if /i "%yawm%" EQU "B" goto:WPAGE14

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE17

::...................................Wizard Page18 - MMM...............................
:WPAGE18
set mmm=

if /i "%firmstart%" NEQ "4.3" goto:WPAGE18GO
if /i "%region%" EQU "K" goto:WPAGE19

:WPAGE18GO

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if "%FIRMSTART%" EQU "4.3" (echo      Download Trucha Bug Restorer [TBR]?) else (echo      Download Multi-Mod-Manager [MMM]?)
echo.
if "%FIRMSTART%" EQU "4.3" (echo           * with 2x IOS15, IOS36, IOS41 and MMM for installing a patched IOS236) else (echo           * with 2x IOS15 and IOS36 for installing patched IOS36)
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p mmm=     Enter Selection Here: 

if /i "%mmm%" EQU "Y" goto:WPAGE19
if /i "%mmm%" EQU "N" goto:WPAGE19
if /i "%mmm%" EQU "M" goto:MENU
if /i "%mmm%" EQU "B" goto:WPAGE17

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE18

::...................................Wizard Page19 - Priiloader...............................
:WPAGE19
set pri=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Priiloader?
echo.
echo.
echo.
echo    Note: Hacks.ini for your Wii will also be downloaded (excluding 3.2J and 3.2K)
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p pri=     Enter Selection Here: 

if /i "%pri%" EQU "Y" goto:WPAGE19B
if /i "%pri%" EQU "N" goto:WPAGE19B
if /i "%pri%" EQU "M" goto:MENU



if /i "%firmstart%" NEQ "4.3" goto:backto18
if /i "%region%" EQU "K" goto:gotobackto17

:backto18
if /i "%pri%" EQU "B" goto:WPAGE18

:gotobackto17
if /i "%pri%" EQU "B" goto:WPAGE17

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE19



title/00000001/00000002/data


::...................................Wizard Page19B - Extra Brick Protection...............................
:WPAGE19B
set protect=

cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Download Extra Brick Protection?
echo.
echo.
echo   This will download the following System Menu IOSs which will protect all Wii's
echo   (even newer LU64 Wii's) from bricking in the event of 'accidental' up/downgrading.
echo.
echo      * IOS11v257(IOS60v6174[FS-ES-NP])  - IOS11 required for SMv2.0-2.1
echo      * IOS20v257(IOS60v6174[FS-ES-NP])  - IOS20 required for SMv2.2
echo      * IOS30v2817(IOS60v6174[FS-ES-NP]) - IOS30 required for SMv3.0-3.3
if /i "%REGION%" EQU "K" echo      * IOS40v3073(IOS60v6174[FS-ES-NP]) - IOS40 required for SMv3.3K
echo      * IOS50v5121(IOS50v4889[FS-ES-NP]) - IOS50 required for SMv3.4
if /i "%REGION%" EQU "K" echo      * IOS52v5889(IOS52v5661[FS-ES-NP]) - IOS52 required for SMv3.5K

echo      * IOS60v6401(IOS60v6174[FS-ES-NP]) - IOS60 required for SMv4.0-4.1

if /i "%REGION%" NEQ "RC" echo      * IOS70v6913(IOS70v6687[FS-ES-NP]) - IOS70 required for SMv4.2
if /i "%REGION%" EQU "RC" echo      * IOS70v54321(IOS60v6174[FS-ES-NP]) - IOS70 required for SMv4.2
echo      * USB-Loader Forwarder Channel
echo.
echo       You should always have at least one forwarder channel installed on your Wii,
echo       that way, in the event of accidental update, you'll be able to rehack your Wii
if /i "%REGION%" EQU "U" echo       without relying on the Smashstack or Indiana Pwns exploits.
if /i "%REGION%" EQU "E" echo       without relying on the Indiana Pwns exploit.

if /i "%REGION%" EQU "RC" echo.
if /i "%REGION%" EQU "RC" echo  Note: IOS80v54321(IOS60v6174[FS-ES-NP]) will be downloaded even if you answer no
if /i "%REGION%" EQU "RC" echo        to protect against 003 Bricks


echo.
echo.
echo     NOTES:
echo.
echo     -Version numbers have been increased to survive official updates.
echo.
echo     -With the exception of the USB-Loader Forwarder Channel,
echo      Installing these will NOT reduce the amount of memory your Wii
echo      has for Channels or Game Saves.
echo.
echo.
echo.
echo                Y = Yes
echo                N = No
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p protect=     Enter Selection Here: 

if /i "%protect%" EQU "Y" goto:WPAGELAST
if /i "%protect%" EQU "N" goto:WPAGELAST
if /i "%protect%" EQU "M" goto:MENU


if /i "%Advanced%" EQU "Y" goto:Back2PRI
if /i "%Advanced%" EQU "N" goto:Back2Advanced2
if /i "%MORE%" EQU "N" goto:Back2MORE2
if /i "%REGION%" EQU "K" goto:Back2SHOP2
if /i "%MORE%" EQU "Y" goto:Back2Speak2


:BACK2PRI
if /i "%protect%" EQU "B" goto:WPAGE19

:BACK2ADVANCED2
if /i "%protect%" EQU "B" goto:WPAGE13

:BACK2SPEAK2
if /i "%protect%" EQU "B" goto:WPAGE12

:Back2SHOP2
if /i "%protect%" EQU "B" goto:WPAGE11

:BACK2MORE2
if /i "%protect%" EQU "B" goto:WPAGE5


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGE19B




::...................................Wizard Last Page - Confirmation...............................
:WPAGELAST

set WLAST=

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      Are these settings correct?
echo.
echo.
echo.
if /i "%VIRGIN%" EQU "Y" echo           * Wii is currently a virgin (un-modified)
if /i "%VIRGIN%" EQU "N" echo           * Wii is already modified
if /i "%REGION%" EQU "RC" goto:RCSTATUS
if /i "%FIRMSTART%" NEQ "o" echo           * Current firmware is %FIRMSTART%%REGION%
if /i "%FIRMSTART%" EQU "o" echo           * Current firmware is less than 2.2%REGION%

echo           * Desired firmware is %FIRM%%REGION%
goto:noRCSTATUS
:RCSTATUS


if /i "%FIRMSTART%" NEQ "o" echo           * Wii is Korean but has previously been region changed to %FIRMSTART%%REGIONCHANGE%
if /i "%FIRMSTART%" EQU "o" echo           * Wii is Korean but has previously been region changed to %REGIONCHANGE%
echo           * Desired firmware is %FIRM%%REGIONCHANGE%

:noRCSTATUS
echo.
if /i "%PIC%" EQU "Y" echo           * Download Photo Channel
if /i "%NET%" EQU "Y" echo           * Download Internet Channel
if /i "%WEATHER%" EQU "Y" echo           * Download Weather Channel
if /i "%NEWS%" EQU "Y" echo           * Download News Channel
if /i "%Mii%" EQU "Y" echo           * Download Mii Channel
if /i "%Shop%" EQU "Y" echo           * Download Shopping Channel (and IOS61)
if /i "%Speak%" EQU "Y" echo           * Download Wii Speak Channel
echo.

if /i "%HM%" NEQ "Y" goto:skip4.3extra
if /i "%FIRMSTART%" EQU "3.X" echo           * Download HackMii Installer and BannerBomb v1 (with IOS58)
if /i "%FIRMSTART%" EQU "4.0" echo           * Download HackMii Installer and BannerBomb v1 (with IOS58)
if /i "%FIRMSTART%" EQU "4.1" echo           * Download HackMii Installer and BannerBomb v1 (with IOS58)
if /i "%FIRMSTART%" EQU "4.2" echo           * Download HackMii Installer and BannerBomb v2 (with IOS58)
if /i "%FIRMSTART%" EQU "o" echo           * Download HackMii Installer and Twilight Hack (with IOS58)
if /i "%FIRMSTART%" EQU "o" goto:listthis

if /i "%FIRMSTART%" NEQ "4.3" goto:skip4.3extra

if /i "%REGION%" EQU "U" echo           * Download HackMii Installer (with IOS58)
if /i "%REGION%" EQU "E" echo           * Download HackMii Installer (with IOS58)
if /i "%REGIONCHANGE%" EQU "U" echo           * Download HackMii Installer (with IOS58)
if /i "%REGIONCHANGE%" EQU "E" echo           * Download HackMii Installer (with IOS58)
:listthis
if /i "%REGION%" EQU "U" echo             Smash Stack and Indiana Pwns Exploits
if /i "%REGION%" EQU "E" echo             Indiana Pwns Exploit
if /i "%REGIONCHANGE%" EQU "U" echo             Smash Stack and Indiana Pwns Exploits
if /i "%REGIONCHANGE%" EQU "E" echo             Indiana Pwns Exploit
::echo             Trucha Bug Restorer (with IOS41v3091)
:skip4.3extra



if /i "%H5%" EQU "Y" echo           * Download recommended cIOSs and cMIOS
if /i "%yawm%" EQU "Y" echo           * Download Yet Another Wad Manager Mod (YAWMM)

if /i "%mmm%" NEQ "Y" goto:skip
if "%FIRMSTART%" EQU "4.3" (echo           * Download Trucha Bug Restorer [TBR]) else (echo           * Download Multi-Mod-Manager [MMM])
if "%FIRMSTART%" EQU "4.3" (echo             with 2x IOS15, IOS36, IOS41 and MMM for installing a patched IOS236) else (echo             with 2x IOS15 and IOS36 for installing patched IOS36)
:skip


if /i "%pri%" EQU "Y" echo           * Download Priiloader
if /i "%protect%" EQU "Y" echo           * Download Extra Brick Protection
echo.
echo.
echo.
if /i "%LoadWizSettings%" EQU "Y" goto:skip
echo                S = Save Wizard Settings For Future Use
if exist Wizard_Settings.bat echo                    Existing Wizard_Settings.bat will be renamed
echo.
:skip
echo                Y = Yes
echo                N = No / Main Menu
echo.
echo                B = Back
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p WLAST=     Enter Selection Here: 

if /i "%LoadWizSettings%" EQU "Y" goto:skip
if /i "%WLAST%" EQU "S" goto:SaveWizardSettings
:skip
if /i "%WLAST%" EQU "Y" set BACKB4DRIVE=WPAGELAST
if /i "%WLAST%" EQU "Y" goto:DriveChange
if /i "%WLAST%" EQU "N" goto:Menu
if /i "%WLAST%" EQU "M" goto:MENU
if /i "%Advanced%" EQU "N" goto:Back2Advanced
if /i "%Advanced%" EQU "Y" goto:Back2PROTECT
if /i "%MORE%" EQU "N" goto:Back2PROTECT
if /i "%MORE%" EQU "Y" goto:Back2PROTECT


:::BACK2STUB
::if /i "%WLAST%" EQU "B" goto:WPAGE20

:BACK2ADVANCED
if /i "%WLAST%" EQU "B" goto:WPAGE13

:BACK2SPEAK
if /i "%WLAST%" EQU "B" goto:WPAGE12

:BACK2PROTECT
if /i "%WLAST%" EQU "B" goto:WPAGE19B

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WPAGELAST



::-------------Save Wizard Settings:-------------------
:SaveWizardSettings

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.

set countwiz=0

:renameWIZARDsettings
if not exist Wizard_Settings.bat goto:skip
SET /a countwiz=%countwiz%+1
if exist Wizard_Settings%countwiz%.bat goto:renameWIZARDsettings
move Wizard_Settings.bat Wizard_Settings%countwiz%.bat
:skip


echo ::NUS Auto Downloader - Wizard Settings - %DATE% - %TIME% >> Wizard_Settings.bat
echo set VIRGIN=%VIRGIN%>> Wizard_Settings.bat
echo set REGION=%REGION%>> Wizard_Settings.bat
echo set FIRMSTART=%FIRMSTART%>> Wizard_Settings.bat
echo set FIRM=%FIRM%>> Wizard_Settings.bat
echo set REGIONCHANGE=%REGIONCHANGE%>> Wizard_Settings.bat
echo set PIC=%PIC%>> Wizard_Settings.bat
echo set NET=%NET%>> Wizard_Settings.bat
echo set WEATHER=%WEATHER%>> Wizard_Settings.bat
echo set NEWS=%NEWS%>> Wizard_Settings.bat
echo set Mii=%Mii%>> Wizard_Settings.bat
echo set Shop=%Shop%>> Wizard_Settings.bat
echo set Speak=%Speak%>> Wizard_Settings.bat
echo set HM=%HM%>> Wizard_Settings.bat
echo set yawmm=%yawmm%>> Wizard_Settings.bat
echo set mmm=%mmm%>> Wizard_Settings.bat
echo set pri=%pri%>> Wizard_Settings.bat
echo set protect=%protect%>> Wizard_Settings.bat
echo set EXPLOIT=%EXPLOIT%>> Wizard_Settings.bat
echo set MORE=%MORE%>> Wizard_Settings.bat
echo set ADVANCED=%ADVANCED%>> Wizard_Settings.bat
echo set H5=%H5%>> Wizard_Settings.bat

if exist Wizard_Settings.bat echo                            Download Wizard Settings Saved.
@ping 127.0.0.1 -n 2 -w 1000> nul

goto:WPAGELAST

::...................................USB-Loader Setup Page1 - Format?...............................
:UPAGE1
set FORMAT=NONE
set f32=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo         How would you like your external Hard Drive Formatted?
echo.
echo.
sfk echo -spat \x20 \x20 \x20 [Green] 1 = FAT32 (RECOMMENDED)
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] Ripping Wii games to a FAT32 Hard Drive is possible using the Wii.
echo                  The Wii can access apps, game covers, music, etc. stored on FAT32
echo                  Ideal if you don't always have an SD card to launch the USB-Loader
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Cannot store files greater than 4GBs. The limit does not apply
echo                  to Wii games, which can be split into parts. This will likely not
echo                  affect you unless the drive is also used to store high-def videos
echo.
echo.
echo        2 = NTFS
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] Capable of storing files greater than 4GB
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Ripping to NTFS is VERY unstable, it is highly recommended to
echo                  only add games to an NTFS hard drive using your computer.
echo                  The Wii cannot access apps, game covers, etc. stored on NTFS, so
echo                  an SD card is required to run the USB-Loader (or a SM Channel)
echo.
echo.
echo        3 = Partioned partially as FAT32 and partially as NTFS
echo.
echo            Note: Small flash drives cannot be partitioned
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] Ripping Wii games to a FAT32 Hard Drive is possible using the Wii.
echo                  You can access Wii apps on the FAT32 partition while still
echo                  being able to save files greater than 4GBs on the NTFS partition
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] A little more work to setup than the other options
echo.
echo.
echo         Note: Another option is to format the drive as WBFS, but this format
echo               can ONLY be read by the Wii and ONLY used to store Wii Games
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
echo.
echo.
set /p FORMAT=     Enter Selection Here: 

if /i "%FORMAT%" EQU "M" goto:MENU
if /i "%FORMAT%" EQU "B" goto:MENU

set cfg249=*
set usbfolder=*
set cfgr=*
set wbm=*
if /i "%FORMAT%" EQU "1" set f32=*
if /i "%FORMAT%" EQU "3" set f32=*


if /i "%FORMAT%" EQU "1" goto:UPAGE2
if /i "%FORMAT%" EQU "2" set BACKB4DRIVE=UPAGE1
if /i "%FORMAT%" EQU "2" goto:DriveChange
if /i "%FORMAT%" EQU "3" goto:UPAGE2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:UPAGE1









::...................................USB-Loader Setup Page2 - Config on USB vs SD?...............................
:UPAGE2
set USBCONFIG=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo        Where would you like to save your USB-Loader app, covers and config files?
echo.
echo.
sfk echo -spat \x20 \x20 \x20 [Green] USB = USB (RECOMMENDED)[def] (Files saved to "COPY_TO_USB")
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] SD Card not required to launch USB-Loader
echo                  USB-Loader files take up a small %% of USB Hard Drive free space
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Slightly slower loading time (almost negligible)
echo.
echo.
echo.
echo         SD = SD (Files saved to "%DRIVE%")
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Green] Pros:[def] Slightly faster loading time (almost negligible)
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Red] Cons:[def] Cannot launch the USB-Loader without SD Card
echo                  USB-Loader files can take up a large %% of SD Card free space
echo.
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
echo.
echo.
set /p USBCONFIG=     Enter Selection Here: 

if /i "%USBCONFIG%" EQU "B" goto:UPAGE1
if /i "%USBCONFIG%" EQU "M" goto:MENU



if /i "%USBCONFIG%" EQU "USB" set DRIVETEMP=%DRIVE%
if /i "%USBCONFIG%" EQU "USB" set BACKB4DRIVEU=UPAGE2
if /i "%USBCONFIG%" EQU "USB" goto:DRIVEUCHANGE
::if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVEU%
::if /i "%USBCONFIG%" EQU "USB" goto:DownloadQueue

if /i "%USBCONFIG%" EQU "SD" set BACKB4DRIVE=UPAGE2
if /i "%USBCONFIG%" EQU "SD" goto:DriveChange


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:UPAGE2







::...................................SNEEK Page1 - SNEEK SELECT...............................
:SNKPAGE1
set SNEEKSELECT=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo         Which of the following SNEEK Actions would you like to perform?
echo.
echo.
echo.
echo                1 = SNEEK Installation
echo.
echo                2 = Emulated NAND Builder (for SNEEK)
echo.
echo                3 = All the above (Recommended for first time SNEEK users)
echo.
echo.
echo                4 = Game/ISO Bulk Extractor (for SNEEK)
echo.
echo.
echo.
echo   Requirements:
echo.
echo         * Your Wii must have BootMii installed in order to run SNEEK. If you
echo           don't have it installed, run NUS Auto Downloader's Download Wizard.
echo.
echo         * UNEEK and UNEEK+DI require the External Hard Drive be formatted 
echo           as FAT32 using cluster sizes 32K or lower. If you don't know how to
echo           format your drive this way, run NUS Auto Downloader's USB-Loader Setup.
echo.
echo         * SNEEK+DI and UNEEK+DI always uses the 1st partition if multiple are found.
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] WARNING: SNEEK is not directly supported by NUS Auto Downloader.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] Any problems you have with SNEEK that are not a direct result
sfk echo -spat \x20 \x20 \x20 \x20 [Red] of NUSAD should be reported here: http://code.google.com/p/sneek/
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] This is also a great place to learn more about SNEEK in general.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] Another great resource is the guide here: tinyurl.com/SNEEK-DI
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNEEKSELECT=     Enter Selection Here: 

if /i "%SNEEKSELECT%" EQU "B" goto:MENU
if /i "%SNEEKSELECT%" EQU "M" goto:MENU
if /i "%SNEEKSELECT%" EQU "1" goto:SNKPAGE2
if /i "%SNEEKSELECT%" EQU "2" goto:SNKPAGE2
if /i "%SNEEKSELECT%" EQU "3" goto:SNKPAGE2
if /i "%SNEEKSELECT%" EQU "4" goto:SNKDISCEX

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE1



::...................................SNEEK Page2 - SNEEK TYPE...............................
:SNKPAGE2
set SNEEKTYPE=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" NEQ "2" echo         What type of SNEEK would you like to install?
if /i "%SNEEKSELECT%" EQU "2" echo         What type of SNEEK would you like to build an emulated NAND for?
echo.
echo.
if /i "%SNEEKSELECT%" NEQ "1" echo   Note: NANDs built for any type of SNEEK work with any other type of SNEEK except
if /i "%SNEEKSELECT%" NEQ "1" echo           UNEEK+DI and SNEEK+DI which require 4.2U/E or 4.3U/E emulated NANDs.
if /i "%SNEEKSELECT%" NEQ "1" echo           However, ANY region Wii can use ANY region emulated NAND
if /i "%SNEEKSELECT%" NEQ "1" echo.
if /i "%SNEEKSELECT%" NEQ "1" echo   Advanced Users: If you self-compile SNEEK+DI/UNEEK+DI with hacks to support
if /i "%SNEEKSELECT%" NEQ "1" echo                   System Menu's other than those mentioned in the note above,
if /i "%SNEEKSELECT%" NEQ "1" echo                   you can select "S" or "U" to unlock more NAND building options
echo.
echo         UD = UNEEK+DI
echo              * Emulated Wii nand/memory is on FAT32 External Hard Drive
echo              * Load Wii games off your FAT32 External Hard Drive
echo              * You can load apps off an SD Card via the Homebrew Channel
echo              * DVD-Drive access is disabled for games while running UNEEK+DI
echo                but can be used in apps (ie. WiiXplorer)
echo              * Only works with 4.2U/E and 4.3E emulated NANDs
echo.
echo         SD = SNEEK+DI
echo              * Emulated Wii nand/memory is on SD Card
echo              * Load Wii games off your FAT32 External Hard Drive
echo              * You can load apps off a FAT32 USB HDD via the Homebrew Channel
echo              * DVD-Drive access is disabled for games while running SNEEK+DI
echo                but can be used in apps (ie. WiiXplorer)
echo              * Only works with 4.2U/E and 4.3E emulated NANDs
echo.
echo          U = UNEEK
echo              * Emulated Wii nand/memory is on FAT32 External Hard Drive
echo              * You cannot load any games off your Hard Drive
echo              * You can load apps off an SD Card via the Homebrew Channel
echo              * DVD-Drive access is enabled
echo              * Backup disc loading requires DarkCorp installed on emulated nand
echo                (Newer Wii's have a DVD-Drive that prevents backup disc loading)
echo.
echo          S = SNEEK
echo              * Emulated Wii nand/memory is on SD Card
::echo              * You can load ONE game at a time off your FAT32 External Hard Drive
echo              * You cannot load any games off your Hard Drive
echo              * You can load apps off a FAT32 USB HDD via the Homebrew Channel
echo              * DVD-Drive access is enabled
echo              * Backup disc loading requires DarkCorp installed on emulated nand
echo                (Newer Wii's have a DVD-Drive that prevents backup disc loading)
echo.
echo          B = Back
echo.
echo          M = Main Menu
echo.
echo.
set /p SNEEKTYPE=     Enter Selection Here: 

if /i "%SNEEKTYPE%" EQU "B" goto:SNKPAGE1
if /i "%SNEEKTYPE%" EQU "M" goto:MENU

if /i "%SNEEKTYPE%" EQU "SD" set BACKB4DRIVE=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "UD" set BACKB4DRIVE=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "U" set BACKB4DRIVE=SNKPAGE2
if /i "%SNEEKTYPE%" EQU "S" set BACKB4DRIVE=SNKPAGE2

if /i "%SNEEKTYPE%" EQU "SD" goto:DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "UD" goto:DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "U" goto:DRIVECHANGE
if /i "%SNEEKTYPE%" EQU "S" goto:DRIVECHANGE

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE2





::...................................SNEEK Page3 - SNEEK REGION...............................
:SNKPAGE3

if /i "%SNEEKTYPE%" EQU "SD" set nandpath=%DRIVE%
if /i "%SNEEKTYPE%" EQU "S" set nandpath=%DRIVE%
if /i "%SNEEKTYPE%" EQU "UD" set nandpath=%DRIVEU%
if /i "%SNEEKTYPE%" EQU "U" set nandpath=%DRIVEU%

set DITYPE=off
if /i "%SNEEKTYPE%" EQU "UD" set DITYPE=on
if /i "%SNEEKTYPE%" EQU "SD" set DITYPE=on


set REGION=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                  SNEEK NAND BUILDER
echo.
echo.
echo         What Region would you like to make your emulated NAND?
echo.
echo.
echo         Note: SNEEK+DI and UNEEK+DI only work with 4.2U/E or 4.3U/E emulated NANDs.
echo               However, ANY region Wii can use ANY region emulated NAND.
echo.
echo.
echo         Note: If you want your wiimotes be synced up to your real NAND
echo               and your emulated NAND simultaneously, then you must choose
echo               the real region of your Wii
echo               (in addition to using the setting.txt for your Wii)
echo.
echo.

echo.
echo                U = USA
echo                E = Euro (PAL)
if /i "%DITYPE%" EQU "off" echo                J = JAP
if /i "%DITYPE%" EQU "off" echo                K = Korean
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p REGION=     Enter Selection Here: 


if /i "%REGION%" EQU "B" goto:%B4SNKPAGE3%
if /i "%REGION%" EQU "M" goto:MENU

if /i "%REGION%" EQU "u" set REGION=U
if /i "%REGION%" EQU "e" set REGION=E
if /i "%REGION%" EQU "j" set REGION=J
if /i "%REGION%" EQU "k" set REGION=K

if /i "%REGION%" EQU "U" set defaultserial=LU521175683
if /i "%REGION%" EQU "E" set defaultserial=LEH133789940
if /i "%REGION%" EQU "J" set defaultserial=LJM101175683
if /i "%REGION%" EQU "K" set defaultserial=LJM101175683


if /i "%REGION%" EQU "U" (set serialdigits=11) else (set serialdigits=12)

if /i "%REGION%" EQU "U" goto:SNKPAGE4
if /i "%REGION%" EQU "E" goto:SNKPAGE4

if /i "%DITYPE%" EQU "on" goto:skip
if /i "%REGION%" EQU "J" goto:SNKPAGE4
if /i "%REGION%" EQU "K" goto:SNKPAGE4
:skip

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE3






::...................................SNEEK Page4 - SNEEK VERSION...............................
:SNKPAGE4
set SNKVERSION=


::If region is USA and building NAND for DI, force 4.2 and go to next page
::if /i "%DITYPE%" EQU "OFF" goto:skip
::if /i "%REGION%" EQU "U" set SNKVERSION=4.2
::if /i "%REGION%" EQU "U" goto:SNKPAGE5
:::skip


cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                  SNEEK NAND BUILDER
echo.
echo.
echo         What Firmware Version would you like your SNEEK emulated NAND to be?
echo.
echo.
echo         Note: SNEEK+DI and UNEEK+DI only work with 4.2U/E or 4.3U/E emulated NANDs.
echo               However, ANY region Wii can use ANY region emulated NAND.
echo.
if /i "%DITYPE%" EQU "OFF" goto:skip
if /i "%REGION%" EQU "U" sfk echo -spat \x20 \x20 [Red] Warning:[def] 4.3U specifically does NOT have Region Free hacks enabled by default.
if /i "%REGION%" EQU "U" echo               This only applies to WiiWare/VC Games (aka Channels), 
if /i "%REGION%" EQU "U" echo               the DI/Game Menu can still play Wii Games of All Regions.
:skip
echo.
echo.
echo.
echo                4.3 = 4.3
echo                4.2 = 4.2
::anything under 4.2 is not an option for NANDs for DI
if /i "%DITYPE%" EQU "ON" goto:skip
echo                4.1 = 4.1
if /i "%REGION%" NEQ "K" echo                3.2 = 3.2
:skip
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKVERSION=     Enter Selection Here: 


if /i "%SNKVERSION%" EQU "M" goto:MENU
if /i "%SNKVERSION%" EQU "B" goto:SNKPAGE3



if /i "%SNKVERSION%" EQU "4.3" goto:SNKPAGE4b
if /i "%SNKVERSION%" EQU "4.2" goto:SNKPAGE4b

if /i "%SNEEKTYPE%" EQU "SD" goto:skip
if /i "%SNEEKTYPE%" EQU "UD" goto:skip
if /i "%SNKVERSION%" EQU "4.1" goto:SNKPAGE4b

if /i "%REGION%" EQU "K" goto:skip
if /i "%SNKVERSION%" EQU "3.2" goto:SNKPAGE4b
:skip

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4


::...................................SNEEK Page4b - SNEEK IOS 202 For SNEEK...............................
:SNKPAGE4b

::THIS PAGE CURRENTLY DISABLED!
goto:SNKPAGE5

set SNK202=

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                  SNEEK NAND BUILDER
echo.
echo.
echo         Would you like to install a patched IOS57 to slot 202?
echo.
echo         Doing this will enable your NAND to run apps that require IOS202.
echo         Common apps that require IOS202 are WiiMC and WiiXplorer.
echo.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes [RECOMMENDED]
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNK202=     Enter Selection Here: 


if /i "%SNK202%" EQU "B" goto:SNKPAGE4
if /i "%SNK202%" EQU "M" goto:MENU
if /i "%SNK202%" EQU "Y" goto:SNKPAGE5
if /i "%SNK202%" EQU "N" goto:SNKPAGE5


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE4b



::...................................SNEEK Page4 - SNEEK SERIAL...............................
:SNKPAGE5
set SNKSERIAL=

set settingtxtExist=no
if exist "%nandpath%"\title\00000001\00000002\data\setting.txt set settingtxtExist=yes

set nandexist=no
if exist "%nandpath%"\title set nandexist=yes
if exist "%nandpath%"\ticket set nandexist=yes
if exist "%nandpath%"\sys set nandexist=yes
if exist "%nandpath%"\shared1 set nandexist=yes

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                  SNEEK NAND BUILDER
echo.
echo.
echo         What Serial Number Would you like to use to create setting.txt?
echo.
echo.
if /i "%settingtxtExist%" EQU "yes" sfk echo -spat \x20 \x20 \x20 \x20 [Red] setting.txt already exists in %nandpath%
if /i "%settingtxtExist%" EQU "yes" sfk echo -spat \x20 \x20 \x20 \x20 [Red] Leave the selection blank to keep using this setting.txt
if /i "%settingtxtExist%" EQU "yes" echo.
if /i "%settingtxtExist%" EQU "yes" sfk echo -spat \x20 \x20 \x20 \x20 [Red] WARNING: Existing setting.txt must be Region '%REGION%' to work
echo.
echo.
echo         Enter your %serialdigits% digit serial number now
echo.
echo               Example: %defaultserial%
echo.
echo.
echo.
echo                D = Default Serial %defaultserial%
echo.
echo.
echo                N = None, skip building setting.txt
echo.
echo.
echo.
echo         Note: setting.txt required to build nand, only select "N" if
echo               you plan to manually copy a pre-existing setting.txt
echo               to this location: %nandpath%\title\00000001\00000002\data\
echo.
echo.
echo         Note: If you want your wiimotes be synced up to your real NAND
echo               and your emulated NAND simultaneously, then you must use the
echo               serial for your Wii (or the setting.txt from your NAND Dump)
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKSERIAL=     Enter Selection Here: 

if /i "%SNKSERIAL%" EQU "M" goto:MENU

::--Disabled----If region is USA and building NAND for DI, got back to snkpage3 instead of 4
::if /i "%DITYPE%" EQU "OFF" goto:skip
::if /i "%REGION%" EQU "U" goto:backtosnkpage3
:skip
if /i "%SNKSERIAL%" EQU "B" goto:SNKPAGE4
:backtosnkpage3
if /i "%SNKSERIAL%" EQU "B" goto:SNKPAGE3





if /i "%SNKSERIAL%" EQU "N" goto:WPAGE5

if /i "%SNKSERIAL%" EQU "D" set SNKSERIAL=%defaultserial%


if /i "%settingtxtExist%" EQU "yes" goto:settingsexist
IF "%SNKSERIAL%"=="" set SNKSERIAL=9999999999999
goto:skip

:settingsexist
IF "%SNKSERIAL%"=="" set SNKSERIAL=current
if /i "%SNKSERIAL%" EQU "current" goto:WPAGE5

:skip

::limit user input to X# of digits
if "%SNKSERIAL:~2%"=="" (goto:badkey)
if "%SNKSERIAL:~3%"=="" (goto:badkey)
if "%SNKSERIAL:~4%"=="" (goto:badkey)
if "%SNKSERIAL:~5%"=="" (goto:badkey)
if "%SNKSERIAL:~6%"=="" (goto:badkey)
if "%SNKSERIAL:~7%"=="" (goto:badkey)
if "%SNKSERIAL:~8%"=="" (goto:badkey)
if "%SNKSERIAL:~9%"=="" (goto:badkey)
if "%SNKSERIAL:~10%"=="" (goto:badkey)

if /i "%REGION%" EQU "U" goto:skip
if "%SNKSERIAL:~11%"=="" (goto:badkey)
:skip

if /i "%REGION%" NEQ "U" goto:skip
if not "%SNKSERIAL:~11%"=="" (goto:badkey)
:skip

if not "%SNKSERIAL:~12%"=="" (goto:badkey)

::next page
goto:WPAGE5

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKPAGE5





::...................................SNEEK Nand Builder Confirmation...............................
:SNKNANDCONFIRM
set SNKNANDCONFIRM=

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if /i "%SNEEKSELECT%" NEQ "3" goto:notalsoinstalling
if /i "%SNEEKTYPE%" EQU "SD" echo         You are about to install SNEEK+DI and build a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "UD" echo         You are about to install UNEEK+DI and build a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "S" echo         You are about to install SNEEK and build a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "U" echo         You are about to install UNEEK and build a %SNKVERSION%%REGION% Emulated Nand
goto:skip

:notalsoinstalling

if /i "%SNEEKSELECT%" EQU "2" echo         You are about to build a %SNKVERSION%%REGION% Emulated Nand

if /i "%SNEEKSELECT%" NEQ "1" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" echo         You are about to build SNEEK+DI
if /i "%SNEEKTYPE%" EQU "UD" echo         You are about to build UNEEK+DI
if /i "%SNEEKTYPE%" EQU "U" echo         You are about to build UNEEK
if /i "%SNEEKTYPE%" EQU "S" echo         You are about to build SNEEK
echo.
echo.
echo.
echo.
goto:nonandinstallation

:skip

echo.
echo.
echo    Install wads from: %nandpath%\WAD\install2sneek\
echo     to Emulated Nand: %nandpath%\
echo.
if /i "%SNKSERIAL%" EQU "N" goto:none
if /i "%SNKSERIAL%" NEQ "current" echo           * setting.txt will be created using this serial number: %SNKSERIAL%
if /i "%SNKSERIAL%" EQU "current" echo           * Existing setting.txt will be kept
echo.
:none

if /i "%PIC%" EQU "Y" echo           * Download Photo Channel
if /i "%NET%" EQU "Y" echo           * Download Internet Channel
if /i "%WEATHER%" EQU "Y" echo           * Download Weather Channel
if /i "%NEWS%" EQU "Y" echo           * Download News Channel
if /i "%Mii%" EQU "Y" echo           * Download Mii Channel
if /i "%Shop%" EQU "Y" echo           * Download Shopping Channel
if /i "%Speak%" EQU "Y" echo           * Download Wii Speak Channel
echo.
echo.
if /i "%nandexist%" EQU "yes" sfk echo -spat \x20 \x20 \x20 \x20 [Red] WARNING: An emulated nand already exists in %nandpath%
if /i "%nandexist%" EQU "yes" sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red]Existing emulated nand will be Deleted\Replaced
:nonandinstallation
echo.
echo.
echo.
echo                Y = Yes, do it now!
echo.
echo                N = No
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p SNKNANDCONFIRM=     Enter Selection Here: 


if /i "%SNKNANDCONFIRM%" EQU "B" goto:%B4SNKCONFIRM%
if /i "%SNKNANDCONFIRM%" EQU "M" goto:MENU
if /i "%SNKNANDCONFIRM%" EQU "N" goto:MENU

if /i "%SNEEKSELECT%" EQU "1" goto:skip
if /i "%SNEEKSELECT%" EQU "3" goto:skip
if /i "%SNKNANDCONFIRM%" EQU "Y" goto:SNKNANDBUILDER
:skip
if /i "%SNKNANDCONFIRM%" EQU "Y" goto:SNEEKINSTALLER

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKNANDCONFIRM


::...................................SNEEK Nand Builder...............................
:SNKNANDBUILDER

::temporarily force wads to be saved to wad folder and not root
Set ROOTSAVE=off

if not exist "%nandpath%"\WAD\install2sneek mkdir "%nandpath%"\WAD\install2sneek

::backup setting.txt if applicable
if /i "%SNKSERIAL%" EQU "current" move /y "%nandpath%"\title\00000001\00000002\data\setting.txt "%nandpath%"\setting.txt >nul
::delete existing nand if exists
if exist "%nandpath%"\title echo.
if exist "%nandpath%"\title echo Deleting existing emulated nand...
if exist "%nandpath%"\title rd /s /q "%nandpath%"\title
if exist "%nandpath%"\ticket rd /s /q "%nandpath%"\ticket
if exist "%nandpath%"\sys rd /s /q "%nandpath%"\sys
if exist "%nandpath%"\shared1 rd /s /q "%nandpath%"\shared1
::import, meta, shared2, tmp are deleted but will not be recreated by NAND Builder
if exist "%nandpath%"\import rd /s /q "%nandpath%"\import
if exist "%nandpath%"\meta rd /s /q "%nandpath%"\meta
if exist "%nandpath%"\shared2 rd /s /q "%nandpath%"\shared2
if exist "%nandpath%"\tmp rd /s /q "%nandpath%"\tmp

if /i "%REGION%" EQU "U" goto:SNKU
if /i "%REGION%" EQU "E" goto:SNKE
if /i "%REGION%" EQU "J" goto:SNKJ
if /i "%REGION%" EQU "K" goto:SNKK

:SNKU
if /i "%SNKVERSION%" EQU "4.3" set SM4.3U=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2U=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1U=*
if /i "%SNKVERSION%" EQU "3.2" set SM3.2U=*
::SMAPP is patched for UNEEK+DI Support
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=00000098
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=00000088
if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IU=*
if /i "%WEATHER%" EQU "Y" set WU=*
if /i "%NEWS%" EQU "Y" set NU=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSU=*
goto:SNKBUGGEDSMIOS

:SNKE
if /i "%SNKVERSION%" EQU "4.3" set SM4.3E=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2E=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1E=*
if /i "%SNKVERSION%" EQU "3.2" set SM3.2E=*
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=0000009b
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=0000008b
if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IE=*
if /i "%WEATHER%" EQU "Y" set WE=*
if /i "%NEWS%" EQU "Y" set NE=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSE=*
goto:SNKBUGGEDSMIOS

:SNKJ
if /i "%SNKVERSION%" EQU "4.3" set SM4.3J=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2J=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1J=*
if /i "%SNKVERSION%" EQU "3.2" set SM3.2J=*
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=00000095
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=00000085
if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IJ=*
if /i "%WEATHER%" EQU "Y" set WJ=*
if /i "%NEWS%" EQU "Y" set NJ=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSJ=*
goto:SNKBUGGEDSMIOS

:SNKK
if /i "%SNKVERSION%" EQU "4.3" set SM4.3K=*
if /i "%SNKVERSION%" EQU "4.2" set SM4.2K=*
if /i "%SNKVERSION%" EQU "4.1" set SM4.1K=*
if /i "%SNKVERSION%" EQU "4.3" set SMAPP=0000009e
if /i "%SNKVERSION%" EQU "4.2" set SMAPP=0000008e
if /i "%PIC%" EQU "Y" set PK=*
if /i "%SHOP%" EQU "Y" set SK=*
set ios41=*
set ios43=*
set ios45=*
set ios46=*

:SNKBUGGEDSMIOS
if /i "%SNKVERSION%" EQU "3.2" set IOS30P60=*
if /i "%SNKVERSION%" EQU "4.1" set IOS60P=*
if /i "%SNKVERSION%" EQU "4.2" set IOS70P=*
if /i "%SNKVERSION%" EQU "4.3" set IOS80P=*



::activeios
set M10=*
set IOS9=*
set IOS12=*
set IOS13=*
set IOS14=*
set IOS15v1031=*
set IOS17=*
set IOS21=*
set IOS22=*
set IOS28=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
set IOS36v3607=*
set IOS37=*
set IOS38=*
set IOS53=*
set IOS55=*
set IOS56=*
set IOS57=*
set IOS58=*
set IOS61=*

if /i "%SNK202%" EQU "Y" set IOS202P57=*

goto:DLCOUNT











::...................................SNEEK SNK DISC EXtractor...............................
:SNKDISCEX
set ISOFOLDER=WiiISOs
set drivetemp=%ISOFOLDER%
::set SNEEKSELECT=4

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                GAME/ISO BULK EXTRATOR
echo                                      (FOR SNEEK)
echo.
echo.
echo         Enter the Path where your Wii Games/ISOs are saved
echo.
echo.
echo    Current Setting:
echo.
echo         %ISOFOLDER%
echo.
echo.
echo         Notes: * To continue using Current Settings
echo                  leave the selection blank and hit enter.
echo.
echo                * You can drag and drop the Drive/folder into this
echo                  window to save yourself having to manually type it
echo.
echo                * If you experience errors, try removing/adding quotes
echo                  before and after your text
echo.
echo.
echo.
echo         EXAMPLES
echo.
echo.
echo            L:
echo.
echo            %%userprofile%%\Desktop\WiiISOs
echo                  Note: %%userprofile%% shortcut doesn't work on Windows XP
echo.
echo            WiiGames\ISOs
echo                  Note: this checks the WiiGames\ISOs folder where NUSAD is saved
echo.
echo            C:\Users\XFlak\Desktop\New Folder
echo.
echo.
echo.
echo         B = Back
echo.
echo         M = Main Menu
echo.
echo.
set /p DRIVETEMP=     Enter Selection Here: 

if /i "%DRIVETEMP%" EQU "B" goto:SNKPAGE1
::if /i "%DRIVETEMP%" EQU "B" goto:MENU
if /i "%DRIVETEMP%" EQU "M" goto:MENU


if not exist "%DRIVETEMP%" goto:notexist
if not exist "%DRIVETEMP%"\*.iso goto:notexistiso


set ISOFOLDER=%DRIVETEMP%

set BACKB4DRIVEU=SNKDISCEX
goto:DRIVEUCHANGE

:notexist
echo The folder you selected does not exist
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKDISCEX

:notexistiso
echo The folder you selected does not contain any ISOs
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:SNKDISCEX







::...................................SNK DISC EXtractor2...............................
:SNKDISCEX2
set countgames=1




::---get game/iso list and game count-------
if not exist "%driveu%"\games mkdir "%driveu%"\games
dir "%ISOFOLDER%" /b>"%DRIVEU%"\games\gamelist.txt
sfk filter "%DRIVEU%"\games\gamelist.txt -le+.iso -write -yes>nul

::countgames
setlocal ENABLEDELAYEDEXPANSION
set gametotal=0
for /f "delims=" %%i in (%DRIVEU%\games\gamelist.txt) do set /a gametotal=!gametotal!+1
setlocal DISABLEDELAYEDEXPANSION




SET /a LINES=%gametotal%+34
if %LINES% LEQ 54 goto:noresize3
mode con cols=85 lines=%LINES%
:noresize3




::-------------------------------------DISCEX CONFIRM---------------
:DISCEXCONFIRM
cls
set DISCEXCONFIRM=
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                GAME/ISO BULK EXTRATOR
echo                                      (FOR SNEEK)
echo.
echo         You are about to convert the following %gametotal% Wii Games/ISOs
echo.
echo     From Source Folder: %ISOFOLDER%
echo       To Target Folder: %DRIVEU%\games
echo.
sort<"%driveu%"\games\gamelist.txt
echo.
echo.
echo     Would you like to proceed?
echo.
echo.
echo       Notes: * Each game could take approximately 5-15 minutes to convert
echo.
echo              * Make sure you have enough free space here: %DRIVEU%
echo                otherwise extraction will fail when free space is depleted
echo.
if /i "%discexverify%" EQU "off" echo              * Verify Data when using SNEEK Game/ISO Bulk Extractor is Disabled
if /i "%discexverify%" EQU "on" echo              * Verify Data when using SNEEK Game/ISO Bulk Extractor is Enabled
echo                This can be changed in NUS Auto Downloader's Options.
echo.
echo.
echo                Y = Yes
echo.
echo                N = No
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p DISCEXCONFIRM=     Enter Selection Here: 



if /i "%DISCEXCONFIRM%" EQU "M" goto:MENU
if /i "%DISCEXCONFIRM%" EQU "N" goto:MENU
if /i "%DISCEXCONFIRM%" EQU "Y" goto:DISCEXSTART
if /i "%DISCEXCONFIRM%" EQU "B" goto:SNKDISCEX

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DISCEXCONFIRM






::----------------DL and START DISCEX---------------
:DISCEXSTART
cls

if not exist modules\DiscEX-v0.5-cred.rar echo Downloading DiscEX-v0.5
if not exist modules\DiscEX-v0.5-cred.rar echo.
if not exist modules\DiscEX-v0.5-cred.rar start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/files/DiscEX-v0.5-cred.rar
if exist DiscEX-v0.5-cred.rar move /y DiscEX-v0.5-cred.rar modules\

::extract to target folder: %driveu%\games
echo Extracting DiscEX-v0.5 by Crediar to %driveu%\games in order to proceed
echo.
if not exist "%driveu%"\games mkdir "%driveu%"\games
unrar x -y modules\DiscEX-v0.5-cred.rar "%driveu%"\games
::if /i "%SAVEZIP%" NEQ "ON" del DiscEX-v0.5-cred.rar



if /i "%discexverify%" EQU "on" (set discexverifycode= -v) else (set discexverifycode=)


cls
echo Converting the following %gametotal% ISOs
echo This could take awhile, progress\details window is minimized.
echo.


::go to games folder on target device then extract each of them
cd /d "%driveu%"\games


::Loop through the the following once for EACH line in gamelist.txt and turn each line of gamelist.txt into a variable
for /F "tokens=*" %%A in (gamelist.txt) do call :process %%A
goto:nextstep


:process
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop

::extract each game
echo Converting %countgames% of %gametotal%: %*
echo Please wait...
echo.
start %nusadmin%/wait discex%discexverifycode% "%ISOFOLDER%\%*"
::discex %*

::save each line as VAR1 to VARn
set VAR%countgames%=%*

SET /a countgames=%countgames%+1
goto:EOF

:nextstep
SET /a countgames=%countgames%-1

::go back to currentpath
cd /d %nusadpath%

del "%driveu%"\games\msvcr100.dll>nul
del "%driveu%"\games\libeay32.dll>nul
del "%driveu%"\games\DiscEx.exe>nul
del "%driveu%"\games\changelog.txt>nul


::list files

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                                GAME/ISO BULK EXTRATOR
echo                                      (FOR SNEEK)
echo.
echo.
echo.
echo      You should have successfully converted the following %gametotal% Wii games/ISOs:
echo.
:listgames
sort<"%driveu%"\games\gamelist.txt

::echo %var1%
::echo %var2%

del "%driveu%"\games\gamelist.txt>nul
echo.
echo.
pause
goto:MENU







::...................................NUSGRABBER...............................
:NUSGRABBER
set GRABBER=
cls
echo                                  NUS Auto Downloader                          v4.2.2
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20[Red] BATCH PAGE 3 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak
echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    1 = Batch Page1             M = Main Menu
echo       C = Clear Download Queue       2 = Batch Page2       (blank) = Cycle Pages
echo.
if exist "%Drive%"\WAD echo                R = Rename Current %Drive%\WAD folder to %Drive%\WAD#
if exist "%Drive%"\WAD echo                    (otherwise WADs are saved to existing WAD Folder)
if exist "%Drive%"\WAD echo.
echo       Select Group: (A)ll, (S)neek files, All (My)Menuify Files,
echo                      Mymenuify files for (U)SA, (E)uro, (J)AP
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] MyMenuify Files

echo.
echo                    %A42% 42 = 00000042.app from System Menu 3.2U
echo                    %A72% 72 = 00000072.app from System Menu 4.0U
echo                    %A7b% 7b = 0000007b.app from System Menu 4.1U
echo                    %A87% 87 = 00000087.app from System Menu 4.2U
echo.
echo                    %A45% 45 = 00000045.app from System Menu 3.2E
echo                    %A75% 75 = 00000075.app from System Menu 4.0E
echo                    %A7e% 7e = 0000007e.app from System Menu 4.1E
echo                    %A8a% 8a = 0000008a.app from System Menu 4.2E
echo.
echo                    %A40% 40 = 00000040.app from System Menu 3.2J
echo                    %A70% 70 = 00000070.app from System Menu 4.0J
echo                    %A78% 78 = 00000078.app from System Menu 4.1J
echo                    %A84% 84 = 00000084.app from System Menu 4.2J
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] SNEEK Files
echo.
echo                        %A0e% 0e = 0000000e.app from IOS80 v6943
echo                        %A01% 01 = 00000001.app from IOS80 v6943
echo                     %A0e_70% 0e_70 = 0000000e.app from IOS70 v6687
echo                     %A01_70% 01_70 = 00000001.app from IOS70 v6687
echo                     %A0e_60% 0e_60 = 0000000e.app from IOS60 v6174
echo                     %A01_60% 01_60 = 00000001.app from IOS60 v6174
echo.
echo.
echo             Note: these files will be saved in the WAD folder
echo.
echo.
echo.
echo.
echo.
echo.
echo.
if not exist "%Drive%"\WAD echo.
if not exist "%Drive%"\WAD echo.
if not exist "%Drive%"\WAD echo.
set /p GRABBER=     Enter Selection Here: 



if /i "%GRABBER%" EQU "M" goto:MENU
if /i "%GRABBER%" EQU "1" goto:LIST
if /i "%GRABBER%" EQU "2" goto:oldlist
IF "%GRABBER%"=="" goto:LIST

if /i "%GRABBER%" EQU "D" set BACKB4QUEUE=NUSGRABBER
if /i "%GRABBER%" EQU "D" goto:DOWNLOADQUEUE
if /i "%GRABBER%" EQU "C" goto:CLEAR
if /i "%GRABBER%" EQU "R" goto:COPY2

if /i "%GRABBER%" EQU "A" goto:SelectAllApp
if /i "%GRABBER%" EQU "S" goto:SelectAllApp
if /i "%GRABBER%" EQU "My" goto:SelectAllMyMApps
if /i "%GRABBER%" EQU "U" goto:SelectUMyMApps
if /i "%GRABBER%" EQU "E" goto:SelectEMyMApps
if /i "%GRABBER%" EQU "J" goto:SelectJMyMApps


if /i "%GRABBER%" EQU "M" goto:MENU



if /i "%GRABBER%" EQU "0e" goto:SwitchA0e
if /i "%GRABBER%" EQU "01" goto:switchA01
if /i "%GRABBER%" EQU "0e_70" goto:SwitchA0e_70
if /i "%GRABBER%" EQU "01_70" goto:switchA01_70
if /i "%GRABBER%" EQU "0e_60" goto:SwitchA0e_60
if /i "%GRABBER%" EQU "01_60" goto:switchA01_60


if /i "%GRABBER%" EQU "70" goto:switchA70
if /i "%GRABBER%" EQU "42" goto:switchA42
if /i "%GRABBER%" EQU "45" goto:switchA45
if /i "%GRABBER%" EQU "40" goto:switchA40
if /i "%GRABBER%" EQU "72" goto:switchA72
if /i "%GRABBER%" EQU "75" goto:switchA75
if /i "%GRABBER%" EQU "78" goto:switchA78
if /i "%GRABBER%" EQU "7b" goto:switchA7b
if /i "%GRABBER%" EQU "7e" goto:switchA7e
if /i "%GRABBER%" EQU "84" goto:switchA84
if /i "%GRABBER%" EQU "87" goto:switchA87
if /i "%GRABBER%" EQU "8a" goto:switchA8a


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:NUSGRABBER

:SelectAllApp
set A0e=*
set A01=*
set A0e_70=*
set A01_70=*
set A0e_60=*
set A01_60=*
if /i "%GRABBER%" EQU "S" goto:NUSGRABBER

:SelectAllMyMApps

:SelectJMyMApps
set A40=*
set A70=*
set A78=*
set A84=*
if /i "%GRABBER%" EQU "J" goto:NUSGRABBER

:SelectUMyMApps
set A42=*
set A72=*
set A7b=*
set A87=*
if /i "%GRABBER%" EQU "U" goto:NUSGRABBER

:SelectEMyMApps
set A45=*
set A75=*
set A7e=*
set A8a=*

goto:NUSGRABBER


:switchA0e
if /i "%A0e%" EQU "*" goto:switchA0eoff
set A0e=*
goto:NUSGRABBER
:switchA0eoff
set A0e=
goto:NUSGRABBER


:switchA0e_70
if /i "%A0e_70%" EQU "*" goto:switchA0e_70off
set A0e_70=*
goto:NUSGRABBER
:switchA0e_70off
set A0e_70=
goto:NUSGRABBER

:switchA0e_60
if /i "%A0e_60%" EQU "*" goto:switchA0e_60off
set A0e_60=*
goto:NUSGRABBER
:switchA0e_60off
set A0e_60=
goto:NUSGRABBER

:switchA01
if /i "%A01%" EQU "*" goto:switchA01off
set A01=*
goto:NUSGRABBER
:switchA01off
set A01=
goto:NUSGRABBER

:switchA01_70
if /i "%A01_70%" EQU "*" goto:switchA01_70off
set A01_70=*
goto:NUSGRABBER
:switchA01_70off
set A01_70=
goto:NUSGRABBER

:switchA01_60
if /i "%A01_60%" EQU "*" goto:switchA01_60off
set A01_60=*
goto:NUSGRABBER
:switchA01_60off
set A01_60=
goto:NUSGRABBER


:switchA40
if /i "%A40%" EQU "*" goto:switchA40off
set A40=*
goto:NUSGRABBER
:switchA40off
set A40=
goto:NUSGRABBER

:switchA42
if /i "%A42%" EQU "*" goto:switchA42off
set A42=*
goto:NUSGRABBER
:switchA42off
set A42=
goto:NUSGRABBER

:switchA45
if /i "%A45%" EQU "*" goto:switchA45off
set A45=*
goto:NUSGRABBER
:switchA45off
set A45=
goto:NUSGRABBER

:switchA70
if /i "%A70%" EQU "*" goto:switchA70off
set A70=*
goto:NUSGRABBER
:switchA70off
set A70=
goto:NUSGRABBER

:switchA72
if /i "%A72%" EQU "*" goto:switchA72off
set A72=*
goto:NUSGRABBER
:switchA72off
set A72=
goto:NUSGRABBER

:switchA75
if /i "%A75%" EQU "*" goto:switchA75off
set A75=*
goto:NUSGRABBER
:switchA75off
set A75=
goto:NUSGRABBER

:switchA78
if /i "%A78%" EQU "*" goto:switchA78off
set A78=*
goto:NUSGRABBER
:switchA78off
set A78=
goto:NUSGRABBER

:switchA7b
if /i "%A7b%" EQU "*" goto:switchA7boff
set A7b=*
goto:NUSGRABBER
:switchA7boff
set A7b=
goto:NUSGRABBER

:switchA7e
if /i "%A7e%" EQU "*" goto:switchA7eoff
set A7e=*
goto:NUSGRABBER
:switchA7eoff
set A7e=
goto:NUSGRABBER

:switchA84
if /i "%A84%" EQU "*" goto:switchA84off
set A84=*
goto:NUSGRABBER
:switchA84off
set A84=
goto:NUSGRABBER

:switchA87
if /i "%A87%" EQU "*" goto:switchA87off
set A87=*
goto:NUSGRABBER
:switchA87off
set A87=
goto:NUSGRABBER

:switchA8a
if /i "%A8a%" EQU "*" goto:switchA8aoff
set A8a=*
goto:NUSGRABBER
:switchA8aoff
set A8a=
goto:NUSGRABBER













::........................................LIST / BATCH.......................................
:LIST
Set List=
cls
echo                                  NUS Auto Downloader                          v4.2.2
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20[Red] BATCH PAGE 1 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak
echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    2 = Batch Page2             M = Main Menu
echo       C = Clear Download Queue       3 = Batch Page3       (blank) = Cycle Pages
echo.
if exist "%Drive%"\WAD echo                R = Rename Current %Drive%\WAD folder to %Drive%\WAD#
if exist "%Drive%"\WAD echo                    (otherwise WADs are saved to existing WAD Folder)
if exist "%Drive%"\WAD echo.
echo  Select Group: (A)ll, (U)SA, (E)URO, (J)AP, (K)OR, Active (I)OSs, Extra (PR)otection

echo.
sfk echo -spat \x20 \x20 [Red] System Menus \x20 \x20 \x20 \x20 \x20 Non-Fakesigned IOSs\MIOS \x20 \x20 \x20 \x20 Other WADs
echo.
echo    %SM3.2U% 3.2U = 3.2U SM             %IOS9% 9 = IOS9v1034         %RSU% RSU = Region Select v2(U)
echo    %SM4.1U% 4.1U = 4.1U SM	      %IOS12% 12 = IOS12v525         %RSE% RSE = Region Select v2(E)
echo    %SM4.2U% 4.2U = 4.2U SM	      %IOS13% 13 = IOS13v1031        %RSJ% RSJ = Region Select v2(J)
echo    %SM4.3U% 4.3U = 4.3U SM            %IOS14% 14 = IOS14v1031        %RSK% RSK = Region Select v2(K)
echo    %SM3.2E% 3.2E = 3.2E SM           %IOS15v257% 15a = IOS15v257          %EULAU% EU = EULA v3(U)
echo    %SM4.1E% 4.1E = 4.1E SM           %IOS15% 15b = IOS15v523	       %EULAE% EE = EULA v3(E)
echo    %SM4.2E% 4.2E = 4.2E SM	      %IOS15v1031% 15 = IOS15v1031	       %EULAJ% EJ = EULA v3(J)
echo    %SM4.3E% 4.3E = 4.3E SM            %IOS17% 17 = IOS17v1031         %EULAK% EK = EULA v3(K)
echo    %SM3.2J% 3.2J = 3.2J SM            %IOS21% 21 = IOS21v1038         %BC% BC = BC v6
echo    %SM4.1J% 4.1J = 4.1J SM	      %IOS22% 22 = IOS22v1293

sfk echo -spat \x20 \x20%SM4.2J% 4.2J = 4.2J SM \x20 \x20 \x20 \x20 \x20 \x20 %IOS28% 28 = IOS28v1806\x20 \x20 \x20 \x20 \x20 \x20[Red]Fakesigned IOSs

echo    %SM4.3J% 4.3J = 4.3J SM          %IOS30% 30NP = IOS30v2576      
echo    %SM4.1K% 4.1K = 4.1K SM	      %IOS31% 31 = IOS31v3607         %IOS11P60% 11 = IOS11(IOS60P)
echo    %SM4.2K% 4.2K = 4.2K SM	      %IOS33% 33 = IOS33v3607         %IOS20P60% 20 = IOS20v257(IOS60P)
echo    %SM4.3K% 4.3K = 4.3K SM            %IOS34% 34 = IOS34v3607         %IOS30P60% 30 = IOS30(IOS60P)
echo                               %IOS35% 35 = IOS35v3607        %IOS30P% 30P = IOS30-Patched
sfk echo -spat \x20 \x20 \x20 \x20 [Red] Channels [def]\x20 \x20 \x20 \x20 \x20 \x20 %IOS36% 36a = IOS36v3351\x20 \x20 \x20 \x20 \x20 %IOS40P60% 40 = IOS40(IOS60P)
echo                               %IOS36v3607% 36 = IOS36v3607         %IOS50P% 50 = IOS50-Patched
echo     %P% P = Photo 1.1(U/E/J)     %IOS37% 37 = IOS37v5662         %IOS52P% 52 = IOS52-Patched
echo    %PK% PK = Photo 1.1 (KOR)      %IOS38% 38 = IOS38v4123         %IOS60P% 60 = IOS60-Patched
echo    %S% SH = Shopping (U/E/J)    %IOS41v3091% 41a = IOS41v3091        %IOS70K% 70K = IOS70(IOS60P)
echo    %SK% SK = Shopping (KOR)       %IOS41% 41 = IOS41v3348         %IOS70P% 70 = IOS70-Patched
echo    %IU% IU = Internet (USA)       %IOS43% 43 = IOS43v3348        %IOS80K% 80K = IOS80(IOS60P)
echo    %IE% IE = Internet (EUR)       %IOS45% 45 = IOS45v3348         %IOS80P% 80 = IOS80-Patched
echo    %IJ% IJ = Internet (JAP)       %IOS46% 46 = IOS46v3350
echo    %WU% WU = Weather (USA)	      %IOS53% 53 = IOS53v5662
echo    %WE% WE = Weather (EUR)	      %IOS55% 55 = IOS55v5662
echo    %WJ% WJ = Weather (JAP)	      %IOS56% 56 = IOS56v5661
echo    %NU% NU = News (USA)	      %IOS57% 57 = IOS57v5918
echo    %NE% NE = News (EUR)	      %IOS58% 58 = IOS58v6175
echo    %NJ% NJ = News (JAP)         %IOS60% 60NP = IOS60v6174
echo   %WSU% WSU = WiiSpeak(USA)        %IOS61% 61 = IOS61v5661
echo   %WSE% WSE = WiiSpeak(EUR)      %IOS70% 70NP = IOS70v6687
echo   %WSJ% WSJ = WiiSpeak(JAP)      %IOS80% 80NP = IOS80v6943
echo   %MII% Mii = Mii (RF)            %M10% M10 = MIOSv10
echo.
if not exist "%Drive%"\WAD echo.
if not exist "%Drive%"\WAD echo.
if not exist "%Drive%"\WAD echo.
set /p LIST=     Enter Selection Here: 


if /i "%LIST%" EQU "M" goto:MENU
if /i "%LIST%" EQU "D" set BACKB4QUEUE=LIST
if /i "%LIST%" EQU "D" goto:DOWNLOADQUEUE
if /i "%LIST%" EQU "C" goto:CLEAR
if /i "%LIST%" EQU "R" goto:COPY2

if /i "%LIST%" EQU "2" goto:OLDLIST
if /i "%LIST%" EQU "3" goto:NUSGRABBER
IF "%LIST%"=="" goto:OLDLIST

if /i "%LIST%" EQU "A" goto:SelectAll
if /i "%LIST%" EQU "U" goto:UALL
if /i "%LIST%" EQU "E" goto:EALL
if /i "%LIST%" EQU "J" goto:JALL
if /i "%LIST%" EQU "K" goto:KALL
if /i "%LIST%" EQU "I" goto:IOSACTIVE
if /i "%LIST%" EQU "PR" goto:PROTECTIONFILES

if /i "%LIST%" EQU "4.3U" goto:Switch4.3U
if /i "%LIST%" EQU "4.3E" goto:Switch4.3E
if /i "%LIST%" EQU "4.3J" goto:Switch4.3J
if /i "%LIST%" EQU "4.3K" goto:Switch4.3K
if /i "%LIST%" EQU "3.2U" goto:Switch3.2U
if /i "%LIST%" EQU "4.1U" goto:Switch4.1U
if /i "%LIST%" EQU "4.2U" goto:Switch4.2U
if /i "%LIST%" EQU "3.2E" goto:Switch3.2E
if /i "%LIST%" EQU "4.1E" goto:Switch4.1E
if /i "%LIST%" EQU "4.2E" goto:Switch4.2E
if /i "%LIST%" EQU "3.2J" goto:Switch3.2J
if /i "%LIST%" EQU "4.1J" goto:Switch4.1J
if /i "%LIST%" EQU "4.2J" goto:Switch4.2J
if /i "%LIST%" EQU "4.1K" goto:Switch4.1K
if /i "%LIST%" EQU "4.2K" goto:Switch4.2K
if /i "%LIST%" EQU "MII" goto:SwitchMII
if /i "%LIST%" EQU "P" goto:SwitchP
if /i "%LIST%" EQU "PK" goto:SwitchPK
if /i "%LIST%" EQU "SH" goto:SwitchS
if /i "%LIST%" EQU "SK" goto:SwitchSK
if /i "%LIST%" EQU "IU" goto:SwitchIU
if /i "%LIST%" EQU "IE" goto:SwitchIE
if /i "%LIST%" EQU "IJ" goto:SwitchIJ
if /i "%LIST%" EQU "WU" goto:SwitchWU
if /i "%LIST%" EQU "WE" goto:SwitchWE
if /i "%LIST%" EQU "WJ" goto:SwitchWJ
if /i "%LIST%" EQU "NU" goto:SwitchNU
if /i "%LIST%" EQU "NE" goto:SwitchNE
if /i "%LIST%" EQU "NJ" goto:SwitchNJ
if /i "%LIST%" EQU "WSU" goto:SwitchWSU
if /i "%LIST%" EQU "WSE" goto:SwitchWSE
if /i "%LIST%" EQU "WSJ" goto:SwitchWSJ
if /i "%LIST%" EQU "M10" goto:SwitchM10


if /i "%LIST%" EQU "9" goto:Switch9
if /i "%LIST%" EQU "12" goto:Switch12
if /i "%LIST%" EQU "13" goto:Switch13
if /i "%LIST%" EQU "14" goto:Switch14
if /i "%LIST%" EQU "15b" goto:Switch15b
if /i "%LIST%" EQU "15a" goto:Switch15v257
if /i "%LIST%" EQU "15" goto:Switch15v1031

if /i "%LIST%" EQU "17" goto:Switch17
if /i "%LIST%" EQU "20" goto:Switch20P60
if /i "%LIST%" EQU "11" goto:Switch11P60
if /i "%LIST%" EQU "21" goto:Switch21
if /i "%LIST%" EQU "22" goto:Switch22
if /i "%LIST%" EQU "28" goto:Switch28
if /i "%LIST%" EQU "30" goto:Switch30P60
if /i "%LIST%" EQU "30P" goto:Switch30P
if /i "%LIST%" EQU "31" goto:Switch31
if /i "%LIST%" EQU "33" goto:Switch33
if /i "%LIST%" EQU "34" goto:Switch34
if /i "%LIST%" EQU "35" goto:Switch35
if /i "%LIST%" EQU "36a" goto:Switch36
if /i "%LIST%" EQU "37" goto:Switch37
if /i "%LIST%" EQU "38" goto:Switch38
if /i "%LIST%" EQU "36" goto:Switch36v3607

if /i "%LIST%" EQU "40" goto:Switch40P60
if /i "%LIST%" EQU "41" goto:Switch41
if /i "%LIST%" EQU "43" goto:Switch43
if /i "%LIST%" EQU "45" goto:Switch45
if /i "%LIST%" EQU "46" goto:Switch46
if /i "%LIST%" EQU "50" goto:Switch50P
if /i "%LIST%" EQU "52" goto:Switch52P
if /i "%LIST%" EQU "53" goto:Switch53
if /i "%LIST%" EQU "55" goto:Switch55
if /i "%LIST%" EQU "56" goto:Switch56
if /i "%LIST%" EQU "57" goto:Switch57
if /i "%LIST%" EQU "58" goto:Switch58
if /i "%LIST%" EQU "60" goto:Switch60P
if /i "%LIST%" EQU "61" goto:Switch61
if /i "%LIST%" EQU "70" goto:Switch70P
if /i "%LIST%" EQU "70K" goto:Switch70K
if /i "%LIST%" EQU "80K" goto:Switch80K
if /i "%LIST%" EQU "80" goto:Switch80P
if /i "%LIST%" EQU "30NP" goto:SwitchIOS30
if /i "%LIST%" EQU "41a" goto:SwitchIOS41v3091
if /i "%LIST%" EQU "60NP" goto:SwitchIOS60
if /i "%LIST%" EQU "70NP" goto:SwitchIOS70
if /i "%LIST%" EQU "80NP" goto:SwitchIOS80

if /i "%LIST%" EQU "RSU" goto:SwitchRSU
if /i "%LIST%" EQU "RSE" goto:SwitchRSE
if /i "%LIST%" EQU "RSJ" goto:SwitchRSJ
if /i "%LIST%" EQU "RSK" goto:SwitchRSK

if /i "%LIST%" EQU "EU" goto:SwitchEULAU
if /i "%LIST%" EQU "EE" goto:SwitchEULAE
if /i "%LIST%" EQU "EJ" goto:SwitchEULAJ
if /i "%LIST%" EQU "EK" goto:SwitchEULAK

if /i "%LIST%" EQU "BC" goto:SwitchBC


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:list



:Switch3.2U
if /i "%SM3.2U%" EQU "*" goto:switch3.2Uoff
set SM3.2U=*
goto:list
:switch3.2Uoff
set SM3.2U=
goto:list

:Switch4.1U
if /i "%SM4.1U%" EQU "*" goto:switch4.1Uoff
set SM4.1U=*
goto:list
:switch4.1Uoff
set SM4.1U=
goto:list

:Switch4.2U
if /i "%SM4.2U%" EQU "*" goto:switch4.2Uoff
set SM4.2U=*
goto:list
:switch4.2Uoff
set SM4.2U=
goto:list

:Switch4.3U
if /i "%SM4.3U%" EQU "*" goto:switch4.3Uoff
set SM4.3U=*
goto:list
:switch4.3Uoff
set SM4.3U=
goto:list

:Switch3.2E
if /i "%SM3.2E%" EQU "*" goto:switch3.2Eoff
set SM3.2E=*
goto:list
:switch3.2Eoff
set SM3.2E=
goto:list

:Switch4.1E
if /i "%SM4.1E%" EQU "*" goto:switch4.1Eoff
set SM4.1E=*
goto:list
:switch4.1Eoff
set SM4.1E=
goto:list

:Switch4.2E
if /i "%SM4.2E%" EQU "*" goto:switch4.2Eoff
set SM4.2E=*
goto:list
:switch4.2Eoff
set SM4.2E=
goto:list

:Switch4.3E
if /i "%SM4.3E%" EQU "*" goto:switch4.3Eoff
set SM4.3E=*
goto:list
:switch4.3Eoff
set SM4.3E=
goto:list

:Switch3.2J
if /i "%SM3.2J%" EQU "*" goto:switch3.2Joff
set SM3.2J=*
goto:list
:switch3.2Joff
set SM3.2J=
goto:list

:Switch4.1J
if /i "%SM4.1J%" EQU "*" goto:switch4.1Joff
set SM4.1J=*
goto:list
:switch4.1Joff
set SM4.1J=
goto:list

:Switch4.2J
if /i "%SM4.2J%" EQU "*" goto:switch4.2Joff
set SM4.2J=*
goto:list
:switch4.2Joff
set SM4.2J=
goto:list

:Switch4.3J
if /i "%SM4.3J%" EQU "*" goto:switch4.3Joff
set SM4.3J=*
goto:list
:switch4.3Joff
set SM4.3J=
goto:list

:Switch4.1K
if /i "%SM4.1K%" EQU "*" goto:switch4.1Koff
set SM4.1K=*
goto:list
:switch4.1Koff
set SM4.1K=
goto:list

:Switch4.2K
if /i "%SM4.2K%" EQU "*" goto:switch4.2Koff
set SM4.2K=*
goto:list
:switch4.2Koff
set SM4.2K=
goto:list

:Switch4.3K
if /i "%SM4.3K%" EQU "*" goto:switch4.3Koff
set SM4.3K=*
goto:list
:switch4.3Koff
set SM4.3K=
goto:list

:SwitchMii
if /i "%Mii%" EQU "*" goto:switchMiioff
set Mii=*
goto:list
:switchMiioff
set Mii=
goto:list

:SwitchP
if /i "%P%" EQU "*" goto:switchPoff
set P=*
goto:list
:switchPoff
set P=
goto:list

:SwitchPK
if /i "%PK%" EQU "*" goto:switchPKoff
set PK=*
goto:list
:switchPKoff
set PK=
goto:list

:SwitchS
if /i "%S%" EQU "*" goto:switchSoff
set S=*
goto:list
:switchSoff
set S=
goto:list

:SwitchSK
if /i "%SK%" EQU "*" goto:switchSKoff
set SK=*
goto:list
:switchSKoff
set SK=
goto:list

:SwitchIU
if /i "%IU%" EQU "*" goto:switchIUoff
set IU=*
goto:list
:switchIUoff
set IU=
goto:list

:SwitchIE
if /i "%IE%" EQU "*" goto:switchIEoff
set IE=*
goto:list
:switchIEoff
set IE=
goto:list

:SwitchIJ
if /i "%IJ%" EQU "*" goto:switchIJoff
set IJ=*
goto:list
:switchIJoff
set IJ=
goto:list

:SwitchWU
if /i "%WU%" EQU "*" goto:switchWUoff
set WU=*
goto:list
:switchWUoff
set WU=
goto:list

:SwitchWE
if /i "%WE%" EQU "*" goto:switchWEoff
set WE=*
goto:list
:switchWEoff
set WE=
goto:list

:SwitchWJ
if /i "%WJ%" EQU "*" goto:switchWJoff
set WJ=*
goto:list
:switchWJoff
set WJ=
goto:list

:SwitchNU
if /i "%NU%" EQU "*" goto:switchNUoff
set NU=*
goto:list
:switchNUoff
set NU=
goto:list

:SwitchNE
if /i "%NE%" EQU "*" goto:switchNEoff
set NE=*
goto:list
:switchNEoff
set NE=
goto:list

:SwitchNJ
if /i "%NJ%" EQU "*" goto:switchNJoff
set NJ=*
goto:list
:switchNJoff
set NJ=
goto:list

:SwitchWSU
if /i "%WSU%" EQU "*" goto:switchWSUoff
set WSU=*
goto:list
:switchWSUoff
set WSU=
goto:list

:SwitchWSE
if /i "%WSE%" EQU "*" goto:switchWSEoff
set WSE=*
goto:list
:switchWSEoff
set WSE=
goto:list

:SwitchWSJ
if /i "%WSJ%" EQU "*" goto:switchWSJoff
set WSJ=*
goto:list
:switchWSJoff
set WSJ=
goto:list

:SwitchM10
if /i "%M10%" EQU "*" goto:switchM10off
set M10=*
goto:list
:switchM10off
set M10=
goto:list

:Switch9
if /i "%IOS9%" EQU "*" goto:switchIOS9off
set IOS9=*
goto:list
:switchIOS9off
set IOS9=
goto:list

:Switch12
if /i "%IOS12%" EQU "*" goto:switchIOS12off
set IOS12=*
goto:list
:switchIOS12off
set IOS12=
goto:list

:Switch13
if /i "%IOS13%" EQU "*" goto:switchIOS13off
set IOS13=*
goto:list
:switchIOS13off
set IOS13=
goto:list

:Switch14
if /i "%IOS14%" EQU "*" goto:switchIOS14off
set IOS14=*
goto:list
:switchIOS14off
set IOS14=
goto:list

:Switch15b
if /i "%IOS15%" EQU "*" goto:switchIOS15boff
set IOS15=*
goto:list
:switchIOS15boff
set IOS15=
goto:list

:Switch15v257
if /i "%IOS15v257%" EQU "*" goto:switchIOS15v257off
set IOS15v257=*
goto:list
:switchIOS15v257off
set IOS15v257=
goto:list

:Switch15v1031
if /i "%IOS15v1031%" EQU "*" goto:switchIOS15v1031off
set IOS15v1031=*
goto:list
:switchIOS15v1031off
set IOS15v1031=
goto:list

:Switch17
if /i "%IOS17%" EQU "*" goto:switchIOS17off
set IOS17=*
goto:list
:switchIOS17off
set IOS17=
goto:list

:Switch21
if /i "%IOS21%" EQU "*" goto:switchIOS21off
set IOS21=*
goto:list
:switchIOS21off
set IOS21=
goto:list

:Switch22
if /i "%IOS22%" EQU "*" goto:switchIOS22off
set IOS22=*
goto:list
:switchIOS22off
set IOS22=
goto:list

:Switch28
if /i "%IOS28%" EQU "*" goto:switchIOS28off
set IOS28=*
goto:list
:switchIOS28off
set IOS28=
goto:list

:Switch40P60
if /i "%IOS40P60%" EQU "*" goto:switchIOS40P60off
set IOS40P60=*
goto:list
:switchIOS40P60off
set IOS40P60=
goto:list

:Switch30P60
if /i "%IOS30P60%" EQU "*" goto:switchIOS30P60off
set IOS30P60=*
goto:list
:switchIOS30P60off
set IOS30P60=
goto:list

:Switch30P
if /i "%IOS30P%" EQU "*" goto:switchIOS30Poff
set IOS30P=*
goto:list
:switchIOS30Poff
set IOS30P=
goto:list

:Switch31
if /i "%IOS31%" EQU "*" goto:switchIOS31off
set IOS31=*
goto:list
:switchIOS31off
set IOS31=
goto:list

:Switch33
if /i "%IOS33%" EQU "*" goto:switchIOS33off
set IOS33=*
goto:list
:switchIOS33off
set IOS33=
goto:list

:Switch34
if /i "%IOS34%" EQU "*" goto:switchIOS34off
set IOS34=*
goto:list
:switchIOS34off
set IOS34=
goto:list

:Switch35
if /i "%IOS35%" EQU "*" goto:switchIOS35off
set IOS35=*
goto:list
:switchIOS35off
set IOS35=
goto:list

:Switch36
if /i "%IOS36%" EQU "*" goto:switchIOS36off
set IOS36=*
goto:list
:switchIOS36off
set IOS36=
goto:list

:Switch37
if /i "%IOS37%" EQU "*" goto:switchIOS37off
set IOS37=*
goto:list
:switchIOS37off
set IOS37=
goto:list

:Switch38
if /i "%IOS38%" EQU "*" goto:switchIOS38off
set IOS38=*
goto:list
:switchIOS38off
set IOS38=
goto:list

:Switch41
if /i "%IOS41%" EQU "*" goto:switchIOS41off
set IOS41=*
goto:list
:switchIOS41off
set IOS41=
goto:list

:Switch43
if /i "%IOS43%" EQU "*" goto:switchIOS43off
set IOS43=*
goto:list
:switchIOS43off
set IOS43=
goto:list

:Switch45
if /i "%IOS45%" EQU "*" goto:switchIOS45off
set IOS45=*
goto:list
:switchIOS45off
set IOS45=
goto:list

:Switch46
if /i "%IOS46%" EQU "*" goto:switchIOS46off
set IOS46=*
goto:list
:switchIOS46off
set IOS46=
goto:list

:Switch50P
if /i "%IOS50P%" EQU "*" goto:switchIOS50Poff
set IOS50P=*
goto:list
:switchIOS50Poff
set IOS50P=
goto:list

:Switch52P
if /i "%IOS52P%" EQU "*" goto:switchIOS52Poff
set IOS52P=*
goto:list
:switchIOS52Poff
set IOS52P=
goto:list

:Switch11P60
if /i "%IOS11P60%" EQU "*" goto:switchIOS11P60off
set IOS11P60=*
goto:list
:switchIOS11P60off
set IOS11P60=
goto:list

:Switch20P60
if /i "%IOS20P60%" EQU "*" goto:switchIOS20P60off
set IOS20P60=*
goto:list
:switchIOS20P60off
set IOS20P60=
goto:list

:Switch53
if /i "%IOS53%" EQU "*" goto:switchIOS53off
set IOS53=*
goto:list
:switchIOS53off
set IOS53=
goto:list

:Switch55
if /i "%IOS55%" EQU "*" goto:switchIOS55off
set IOS55=*
goto:list
:switchIOS55off
set IOS55=
goto:list

:Switch56
if /i "%IOS56%" EQU "*" goto:switchIOS56off
set IOS56=*
goto:list
:switchIOS56off
set IOS56=
goto:list

:Switch57
if /i "%IOS57%" EQU "*" goto:switchIOS57off
set IOS57=*
goto:list
:switchIOS57off
set IOS57=
goto:list

:Switch58
if /i "%IOS58%" EQU "*" goto:switchIOS58off
set IOS58=*
goto:list
:switchIOS58off
set IOS58=
goto:list


:Switch60P
if /i "%IOS60P%" EQU "*" goto:switchIOS60Poff
set IOS60P=*
goto:list
:switchIOS60Poff
set IOS60P=
goto:list

:Switch61
if /i "%IOS61%" EQU "*" goto:switchIOS61off
set IOS61=*
goto:list
:switchIOS61off
set IOS61=
goto:list

:Switch70P
if /i "%IOS70P%" EQU "*" goto:switchIOS70Poff
set IOS70P=*
goto:list
:switchIOS70Poff
set IOS70P=
goto:list

:Switch80P
if /i "%IOS80P%" EQU "*" goto:switchIOS80Poff
set IOS80P=*
goto:list
:switchIOS80Poff
set IOS80P=
goto:list

:Switch70K
if /i "%IOS70K%" EQU "*" goto:switchIOS70Koff
set IOS70K=*
goto:list
:switchIOS70Koff
set IOS70K=
goto:list

:Switch80K
if /i "%IOS80K%" EQU "*" goto:switchIOS80Koff
set IOS80K=*
goto:list
:switchIOS80Koff
set IOS80K=
goto:list

:SwitchIOS30
if /i "%IOS30%" EQU "*" goto:switchIOS30off
set IOS30=*
goto:LIST
:switchIOS30off
set IOS30=
goto:LIST

:SwitchIOS41v3091
if /i "%IOS41v3091%" EQU "*" goto:switchIOS41v3091off
set IOS41v3091=*
goto:LIST
:switchIOS41v3091off
set IOS41v3091=
goto:LIST

:SwitchIOS60
if /i "%IOS60%" EQU "*" goto:switchIOS60off
set IOS60=*
goto:LIST
:switchIOS60off
set IOS60=
goto:LIST

:SwitchIOS70
if /i "%IOS70%" EQU "*" goto:switchIOS70off
set IOS70=*
goto:LIST
:switchIOS70off
set IOS70=
goto:LIST

:SwitchIOS80
if /i "%IOS80%" EQU "*" goto:switchIOS80off
set IOS80=*
goto:LIST
:switchIOS80off
set IOS80=
goto:LIST




:Switch36v3607
if /i "%IOS36v3607%" EQU "*" goto:switchIOS36v3607off
set IOS36v3607=*
goto:LIST
:switchIOS36v3607off
set IOS36v3607=
goto:LIST



:SwitchEULAU
if /i "%EULAU%" EQU "*" goto:switchEULAUoff
set EULAU=*
goto:LIST
:switchEULAUoff
set EULAU=
goto:LIST

:SwitchEULAE
if /i "%EULAE%" EQU "*" goto:switchEULAEoff
set EULAE=*
goto:LIST
:switchEULAEoff
set EULAE=
goto:LIST

:SwitchEULAJ
if /i "%EULAJ%" EQU "*" goto:switchEULAJoff
set EULAJ=*
goto:LIST
:switchEULAJoff
set EULAJ=
goto:LIST

:SwitchEULAK
if /i "%EULAK%" EQU "*" goto:switchEULAKoff
set EULAK=*
goto:LIST
:switchEULAKoff
set EULAK=
goto:LIST

:SwitchRSU
if /i "%RSU%" EQU "*" goto:switchRSUoff
set RSU=*
goto:LIST
:switchRSUoff
set RSU=
goto:LIST

:SwitchRSE
if /i "%RSE%" EQU "*" goto:switchRSEoff
set RSE=*
goto:LIST
:switchRSEoff
set RSE=
goto:LIST

:SwitchRSJ
if /i "%RSJ%" EQU "*" goto:switchRSJoff
set RSJ=*
goto:LIST
:switchRSJoff
set RSJ=
goto:LIST

:SwitchRSK
if /i "%RSK%" EQU "*" goto:switchRSKoff
set RSK=*
goto:LIST
:switchRSKoff
set RSK=
goto:LIST

:SwitchBC
if /i "%BC%" EQU "*" goto:switchBCoff
set BC=*
goto:LIST
:switchBCoff
set BC=
goto:LIST




:SELECTALL

:PROTECTIONFILES
set IOS11P60=*
set IOS20P60=*
set IOS30P60=*
set IOS40P60=*
set IOS50P=*
set IOS52P=*
set IOS60P=*
set IOS70K=*
set IOS80K=*

if /i "%LIST%" EQU "PR" goto:list

:UALL
set MII=*
set P=*
set S=*
set IU=*
set WU=*
set NU=*
set WSU=*
if /i "%LIST%" EQU "U" goto:list

:EALL
set MII=*
set P=*
set S=*
set IE=*
set WE=*
set NE=*
set WSE=*
if /i "%LIST%" EQU "E" goto:list

:JALL
set MII=*
set P=*
set S=*
set IJ=*
set WJ=*
set NJ=*
set WSJ=*
if /i "%LIST%" EQU "J" goto:list

:KALL
set MII=*
set PK=*
set SK=*
::set IOS70K=*
set IOS80K=*
set IOS41=*
set IOS43=*
set IOS45=*
set IOS46=*
if /i "%LIST%" EQU "K" goto:list


set IOS15=*
set IOS15v257=*
set IOS36=*



:BASEWADS
set IOS37=*
set IOS38=*
set IOS57=*
if /i "%LIST%" EQU "B" goto:list

:IOSACTIVE
set M10=*
set IOS9=*
set IOS12=*
set IOS13=*
set IOS14=*
set IOS15v1031=*
set IOS17=*
set IOS21=*
set IOS22=*
set IOS28=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
set IOS36v3607=*
set IOS37=*
set IOS38=*
set IOS53=*
set IOS55=*
set IOS56=*
set IOS57=*
set IOS58=*
set IOS61=*
set IOS80P=*
if /i "%LIST%" EQU "I" goto:list


::not in any list

set SM3.2U=*
set SM4.1U=*
set SM4.2U=*
set SM4.3U=*
set SM3.2E=*
set SM4.1E=*
set SM4.2E=*
set SM4.3E=*
set SM3.2J=*
set SM4.1J=*
set SM4.2J=*
set SM4.3J=*
set SM4.1K=*
set SM4.2K=*
set SM4.3K=*
set IOS36=*
set IOS30P=*

set IOS70P=*
set IOS15=*
set ios30=*
set IOS41v3091=*
set ios60=*
set ios70=*
set ios80=*
set IOS36=*



set EULAU=*
set EULAE=*
set EULAJ=*
set EULAK=*
set RSU=*
set RSE=*
set RSJ=*
set RSK=*
set BC=*



goto:list



::........................................Additional OLDLIST / BATCH.......................................
:OLDLIST
Set OLDLIST=
cls
echo                                  NUS Auto Downloader                          v4.2.2
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20[Red] BATCH PAGE 2 [def]\x20 \x20 \x20 \x20 \x20 \x20 \x20by XFlak

echo.
echo      Choose files to add/remove to download queue (Selected files marked with an *)
echo.
echo       D = Download Selected Files    1 = Batch Page1             M = Main Menu
echo       C = Clear Download Queue       3 = Batch Page3       (blank) = Cycle Pages
echo.
if exist "%Drive%"\WAD echo                R = Rename Current %Drive%\WAD folder to %Drive%\WAD#
if exist "%Drive%"\WAD echo                    (otherwise WADs are saved to existing WAD Folder)
if exist "%Drive%"\WAD echo.
echo    Select Group: (A)ll, (CI)OSs, (REC)ommended CIOSs, (U)SB-Loader, (J)ust for Fun
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] cIOSs/cMIOSs \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Wii Apps
echo.
echo     %cIOS202[37]-v5% 20237 = cIOS202[37]-v5               %HM% HM = HackMii Installer
echo     %cIOS202[38]-v5% 20238 = cIOS202[38]-v5              %bootmiisd% BSD = BootMii SD Files
echo     %cIOS202[57]-v5% 20257 = cIOS202[57]-v5              %BB1% BB1 = Bannerbomb v1
echo     %cIOS222[38]-v4% 222v4 = cIOS222[38]-v4              %BB2% BB2 = Bannerbomb v2
echo      %cIOS222[38]-v5% 222  = cIOS222[38]-v5             %Pwns% PWNS = Indiana Pwns
echo     %cIOS223[37-38]-v4% 223v4 = cIOS223[37-38]-v4            %Smash% SS = Smash Stack (USA)
echo     %cIOS223[37]-v5% 22337 = cIOS223[37]-v5              %Twi% Twi = Twilight Hack
echo     %cIOS223[57]-v5% 22357 = cIOS223[57]-v5               %LoadMii% L  = LoadMii 0.3 (Twilight)
echo     %cIOS224[37]-v5% 22437 = cIOS224[37]-v5             %yawm% YAWM = Yet Another Wad Manager Mod
echo     %cIOS224[57]-v5% 22457 = cIOS224[57]-v5              %MMM% MMM = Multi-Mod Manager v13.2
echo    %cIOS249-v17b% 249v17 = cIOS249-v17b                %dop% DOP = Dop-Mii v13
echo     %cIOS249[37]-v19% 24937 = cIOS249[37]-v19             %TBR% TBR = Trucha Bug Restorer v1.13
echo     %cIOS249[38]-v19% 24938 = cIOS249[38]-v19             %Pri% Pri = Priiloader (v0.4)
echo     %cIOS249[57]-v19% 24957 = cIOS249[57]-v19             %HAX% HAX = Priiloader Hacks
echo    %cIOS250-v17b% 250v17 = cIOS250-v17b                %W20% W20 = Wanin's cIOS v20b Installer
echo     %cIOS250[37]-v19% 25037 = cIOS250[37]-v19             %W19% W19 = Wanin's cIOS v19 Installer
echo     %cIOS250[38]-v19% 25038 = cIOS250[38]-v19             %w17% W17 = Wanin's cIOS v17 Installer
echo     %cIOS250[57]-v19% 25057 = cIOS250[57]-v19              %h4% H4 = Hermes cIOS v4 Installer
echo     %RVL-cmios-v4_WiiGator_GCBL_v0.2% CM0.2 = cMIOS-v4 WiiGator v0.2       %H5% H5 = Hermes cIOS v5 Installer
echo      %RVL-cmios-v4_Waninkoko_rev5% CM5  = cMIOS-v4 Waninkoko rev5     %H51% H51 = Hermes cIOS v5.1 Installer
echo                                           %MP% MP = MIOS Patcher 0.2 (WiiGator)
sfk echo -spat \x20 \x20 \x20 \x20 [Red] USB-Loader Files [def] \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 %CM5% CM = cMIOS rev5 Installer (Waninkoko)
echo.
sfk echo -spat \x20 \x20 %cfg249% CFG249 = CFG-Loader (v249) \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20[Red] Just For Fun!
echo    %cfg222% CFG222 = CFG-Loader (v222)
echo       %usbfolder% USB = USB-Loader Folder (CFG)        %WiiMC% WMC = WiiMC (Media Player)
echo      %cfgr% CFGR = Configurator-CFG-Loader        %fceugx% NES = FCEUGX (NES Emulator)
echo       %wbm% WBM = WiiBackupManager               %snes9xgx% SNES = SNES9xGX (SNES Emulator)
echo       %f32% F32 = FAT32 Formatter                 %vbagx% VBA = VBAGX (GB/GBA Emulator)
echo      %USBX% USBX = USB-Loader Fwdr Chnl            %WII64% W64 = Wii64 beta1.1 (N64 Emulator)   
echo       %neogamma% NEO = Neogamma Backup Disc Loader    %WIISX% WSX = WiiSX beta2.1 (PS1 Emulator)
echo        %CheatCodes% CC = %cheatregion% Region Cheat Codes         %HBB% HBB = Homebrew Browser v0.3.8
echo        %AccioHacks% AH = AccioHacks                      %SGM% SGM = SaveGame Manager GX
echo                                               %WIIX% WX = WiiXplorer
sfk echo -spat \x20 [Red] LEGEND:[def] \x22=\x22 Auto-Updating Downloads\x20 \x20 \x20 \x20 %locked% LA = Locked Apps HBC Folder
echo                                                      (Pass: UDLRAB)

if not exist "%Drive%"\WAD echo.
if not exist "%Drive%"\WAD echo.
if not exist "%Drive%"\WAD echo.

set /p OLDLIST=     Enter Selection Here: 

if /i "%OLDLIST%" EQU "M" goto:MENU
if /i "%OLDLIST%" EQU "V" goto:FINISH
if /i "%OLDLIST%" EQU "D" set BACKB4QUEUE=OLDLIST
if /i "%OLDLIST%" EQU "D" goto:DOWNLOADQUEUE
if /i "%OLDLIST%" EQU "C" goto:CLEAR
if /i "%OLDLIST%" EQU "R" goto:COPY2

if /i "%OLDLIST%" EQU "A" goto:SelectAllOLD
if /i "%OLDLIST%" EQU "J" goto:SelectJust4FunOLD
if /i "%OLDLIST%" EQU "CI" goto:ALLCIOSS
if /i "%OLDLIST%" EQU "REC" goto:RECOMMENDEDCIOSS
if /i "%OLDLIST%" EQU "U" goto:USBLOADERSELECT


if /i "%OLDLIST%" EQU "1" goto:LIST
if /i "%OLDLIST%" EQU "3" goto:nusgrabber
IF "%OLDLIST%"=="" goto:nusgrabber



if /i "%OLDLIST%" EQU "4.3U" goto:Switch4.3U
if /i "%OLDLIST%" EQU "4.3E" goto:Switch4.3E





if /i "%OLDLIST%" EQU "h4" goto:Switchh4
if /i "%OLDLIST%" EQU "h5" goto:Switchh5
if /i "%OLDLIST%" EQU "h51" goto:Switchh51

if /i "%OLDLIST%" EQU "w17" goto:Switchw17
if /i "%OLDLIST%" EQU "w19" goto:Switchw19
if /i "%OLDLIST%" EQU "w20" goto:Switchw20

if /i "%OLDLIST%" EQU "MP" goto:SwitchMP
if /i "%OLDLIST%" EQU "CM" goto:SwitchCM
if /i "%OLDLIST%" EQU "AH" goto:SwitchAccioHacks
if /i "%OLDLIST%" EQU "BSD" goto:Switchbootmiisd


if /i "%OLDLIST%" EQU "BB1" goto:SwitchBB1
if /i "%OLDLIST%" EQU "BB2" goto:SwitchBB2
if /i "%OLDLIST%" EQU "HM" goto:SwitchHM
if /i "%OLDLIST%" EQU "LA" goto:Switchlocked
if /i "%OLDLIST%" EQU "dop" goto:Switchdop
if /i "%OLDLIST%" EQU "HBB" goto:SwitchHBB
if /i "%OLDLIST%" EQU "W64" goto:SwitchWII64
if /i "%OLDLIST%" EQU "WSX" goto:SwitchWIISX
if /i "%OLDLIST%" EQU "pwns" goto:Switchpwns
if /i "%OLDLIST%" EQU "Twi" goto:SwitchTwi
if /i "%OLDLIST%" EQU "ss" goto:Switchsmash
if /i "%OLDLIST%" EQU "mmm" goto:Switchmmm
if /i "%OLDLIST%" EQU "TBR" goto:SwitchTBR
if /i "%OLDLIST%" EQU "yawm" goto:Switchyawm
if /i "%OLDLIST%" EQU "neo" goto:Switchneogamma
if /i "%OLDLIST%" EQU "cfg249" goto:Switchcfg249
if /i "%OLDLIST%" EQU "cfg222" goto:Switchcfg222
if /i "%OLDLIST%" EQU "usb" goto:Switchusbfolder
if /i "%OLDLIST%" EQU "WMC" goto:SwitchWiiMC
if /i "%OLDLIST%" EQU "NES" goto:Switchfceugx
if /i "%OLDLIST%" EQU "SNES" goto:Switchsnes9xgx
if /i "%OLDLIST%" EQU "VBA" goto:Switchvbagx
if /i "%OLDLIST%" EQU "SGM" goto:SwitchSGM
if /i "%OLDLIST%" EQU "WX" goto:SwitchWIIX
if /i "%OLDLIST%" EQU "cfgr" goto:Switchcfgr
if /i "%OLDLIST%" EQU "wbm" goto:Switchwbm
if /i "%OLDLIST%" EQU "cc" goto:SwitchCheatCodes
if /i "%OLDLIST%" EQU "f32" goto:Switchf32
if /i "%OLDLIST%" EQU "USBX" goto:SwitchUSBX

if /i "%OLDLIST%" EQU "Pri" goto:SwitchPri
if /i "%OLDLIST%" EQU "HAX" goto:SwitchHAX
if /i "%OLDLIST%" EQU "L" goto:SwitchLOADMII
if /i "%OLDLIST%" EQU "20237" goto:SwitchcIOS202[37]-v5
if /i "%OLDLIST%" EQU "20238" goto:SwitchcIOS202[38]-v5
if /i "%OLDLIST%" EQU "20257" goto:SwitchcIOS202[57]-v5

if /i "%OLDLIST%" EQU "222" goto:SwitchcIOS222[38]-v5
if /i "%OLDLIST%" EQU "22337" goto:SwitchcIOS223[37]-v5
if /i "%OLDLIST%" EQU "22357" goto:SwitchcIOS223[57]-v5
if /i "%OLDLIST%" EQU "22437" goto:SwitchcIOS224[37]-v5
if /i "%OLDLIST%" EQU "22457" goto:SwitchcIOS224[57]-v5

if /i "%OLDLIST%" EQU "24937" goto:SwitchcIOS249[37]-v19
if /i "%OLDLIST%" EQU "24938" goto:SwitchcIOS249[38]-v19
if /i "%OLDLIST%" EQU "24957" goto:SwitchcIOS249[57]-v19

if /i "%OLDLIST%" EQU "25037" goto:SwitchcIOS250[37]-v19
if /i "%OLDLIST%" EQU "25038" goto:SwitchcIOS250[38]-v19
if /i "%OLDLIST%" EQU "25057" goto:SwitchcIOS250[57]-v19
if /i "%OLDLIST%" EQU "CM0.2" goto:SwitchRVL-cmios-v4_WiiGator_GCBL_v0.2
if /i "%OLDLIST%" EQU "CM5" goto:SwitchRVL-cmios-v4_Waninkoko_rev5
if /i "%OLDLIST%" EQU "222v4" goto:SwitchcIOS222[38]-v4

if /i "%OLDLIST%" EQU "223v4" goto:SwitchcIOS223[37-38]-v4

if /i "%OLDLIST%" EQU "249v17" goto:SwitchcIOS249-v17b

if /i "%OLDLIST%" EQU "250v17" goto:SwitchcIOS250-v17b

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:OLDLIST


:Switchh4
if /i "%H4%" EQU "*" goto:switchH4off
set H4=*
goto:OLDLIST
:switchH4off
set H4=
goto:OLDLIST

:Switchh5
if /i "%H5%" EQU "*" goto:switchH5off
set H5=*
goto:oldlist
:switchH5off
set H5=
goto:oldlist

:SwitchH51
if /i "%H51%" EQU "*" goto:switchH51off
set H51=*
goto:OLDLIST
:switchH51off
set H51=
goto:OLDLIST

:Switchw17
if /i "%W17%" EQU "*" goto:switchW17off
set W17=*
goto:OLDLIST
:switchW17off
set W17=
goto:OLDLIST

:Switchw19
if /i "%W19%" EQU "*" goto:switchW19off
set W19=*
goto:oldlist
:switchW19off
set W19=
goto:oldlist

:Switchw20
if /i "%w20%" EQU "*" goto:switchw20off
set w20=*
goto:oldlist
:switchw20off
set w20=
goto:oldlist


:SwitchCM
if /i "%CM5%" EQU "*" goto:switchCM5off
set CM5=*
goto:oldlist
:switchCM5off
set CM5=
goto:oldlist


:SwitchAccioHacks
if /i "%AccioHacks%" EQU "*" goto:switchAccioHacksoff
set AccioHacks=*
goto:oldlist
:switchAccioHacksoff
set AccioHacks=
goto:oldlist

:SwitchMP
if /i "%MP%" EQU "*" goto:switchMPoff
set MP=*
goto:oldlist
:switchMPoff
set MP=
goto:oldlist




:Switchbootmiisd
if /i "%bootmiisd%" EQU "*" goto:switchbootmiisdoff
set bootmiisd=*
goto:oldlist
:switchbootmiisdoff
set bootmiisd=
goto:oldlist




:SwitchBB1
if /i "%BB1%" EQU "*" goto:switchBB1off
set BB1=*
goto:OLDLIST
:switchBB1off
set BB1=
goto:OLDLIST

:SwitchBB2
if /i "%BB2%" EQU "*" goto:switchBB2off
set BB2=*
goto:OLDLIST
:switchBB2off
set BB2=
goto:OLDLIST

:SwitchHM
if /i "%HM%" EQU "*" goto:switchHMoff
set HM=*
goto:OLDLIST
:switchHMoff
set HM=
goto:OLDLIST

:Switchpwns
if /i "%pwns%" EQU "*" goto:switchpwnsoff
set pwns=*
goto:OLDLIST
:switchpwnsoff
set pwns=
goto:OLDLIST

:SwitchTwi
if /i "%Twi%" EQU "*" goto:switchTwioff
set Twi=*
goto:OLDLIST
:switchTwioff
set Twi=
goto:OLDLIST

:Switchsmash
if /i "%smash%" EQU "*" goto:switchsmashoff
set smash=*
goto:OLDLIST
:switchsmashoff
set smash=
goto:OLDLIST


:Switchdop
if /i "%dop%" EQU "*" goto:switchdopoff
set dop=*
goto:OLDLIST
:switchdopoff
set dop=
goto:OLDLIST

:Switchlocked
if /i "%locked%" EQU "*" goto:switchlockedoff
set locked=*
goto:OLDLIST
:switchlockedoff
set locked=
goto:OLDLIST


:SwitchHBB
if /i "%HBB%" EQU "*" goto:switchHBBoff
set HBB=*
goto:OLDLIST
:switchHBBoff
set HBB=
goto:OLDLIST


:SwitchWII64
if /i "%WII64%" EQU "*" goto:switchWII64off
set WII64=*
goto:OLDLIST
:switchWII64off
set WII64=
goto:OLDLIST


:SwitchWIISX
if /i "%WIISX%" EQU "*" goto:switchWIISXoff
set WIISX=*
goto:OLDLIST
:switchWIISXoff
set WIISX=
goto:OLDLIST

:Switchmmm
if /i "%mmm%" EQU "*" goto:switchmmmoff
set mmm=*
goto:OLDLIST
:switchmmmoff
set mmm=
goto:OLDLIST


:SwitchTBR
if /i "%TBR%" EQU "*" goto:switchTBRoff
set TBR=*
goto:OLDLIST
:switchTBRoff
set TBR=
goto:OLDLIST

:Switchyawm
if /i "%yawm%" EQU "*" goto:switchyawmoff
set yawm=*
goto:OLDLIST
:switchyawmoff
set yawm=
goto:OLDLIST

:Switchneogamma
if /i "%neogamma%" EQU "*" goto:switchneogammaoff
set neogamma=*
goto:OLDLIST
:switchneogammaoff
set neogamma=
goto:OLDLIST

:Switchcfg249
if /i "%cfg249%" EQU "*" goto:switchcfg249off
set cfg249=*
goto:OLDLIST
:switchcfg249off
set cfg249=
goto:OLDLIST

:Switchcfg222
if /i "%cfg222%" EQU "*" goto:switchcfg222off
set cfg222=*
goto:OLDLIST
:switchcfg222off
set cfg222=
goto:OLDLIST

:Switchcfgr
if /i "%cfgr%" EQU "*" goto:switchcfgroff
set cfgr=*
goto:OLDLIST
:switchcfgroff
set cfgr=
goto:OLDLIST

:Switchwbm
if /i "%wbm%" EQU "*" goto:switchwbmoff
set wbm=*
goto:OLDLIST
:switchwbmoff
set wbm=
goto:OLDLIST

:SwitchCheatCodes
if /i "%CheatCodes%" EQU "*" goto:switchCheatCodesoff
set CheatCodes=*
goto:OLDLIST
:switchCheatCodesoff
set CheatCodes=
goto:OLDLIST

:SwitchF32
if /i "%F32%" EQU "*" goto:switchF32off
set F32=*
goto:OLDLIST
:switchF32off
set F32=
goto:OLDLIST

:SwitchUSBX
if /i "%USBX%" EQU "*" goto:switchUSBXoff
set USBX=*
goto:OLDLIST
:switchUSBXoff
set USBX=
goto:OLDLIST

:Switchusbfolder
if /i "%usbfolder%" EQU "*" goto:switchusbfolderoff
set usbfolder=*
goto:OLDLIST
:switchusbfolderoff
set usbfolder=
goto:OLDLIST

:SwitchWiiMC
if /i "%WiiMC%" EQU "*" goto:switchWiiMCoff
set WiiMC=*
goto:OLDLIST
:switchWiiMCoff
set WiiMC=
goto:OLDLIST

:Switchfceugx
if /i "%fceugx%" EQU "*" goto:switchfceugxoff
set fceugx=*
goto:OLDLIST
:switchfceugxoff
set fceugx=
goto:OLDLIST

:Switchsnes9xgx
if /i "%snes9xgx%" EQU "*" goto:switchsnes9xgxoff
set snes9xgx=*
goto:OLDLIST
:switchsnes9xgxoff
set snes9xgx=
goto:OLDLIST

:Switchvbagx
if /i "%vbagx%" EQU "*" goto:switchvbagxoff
set vbagx=*
goto:OLDLIST
:switchvbagxoff
set vbagx=
goto:OLDLIST

:SwitchSGM
if /i "%SGM%" EQU "*" goto:switchSGMoff
set SGM=*
goto:OLDLIST
:switchSGMoff
set SGM=
goto:OLDLIST

:SwitchWIIX
if /i "%WIIX%" EQU "*" goto:switchWIIXoff
set WIIX=*
goto:OLDLIST
:switchWIIXoff
set WIIX=
goto:OLDLIST

:SwitchPri
if /i "%Pri%" EQU "*" goto:switchPrioff
set Pri=*
goto:OLDLIST
:switchPrioff
set Pri=
goto:OLDLIST

:SwitchHAX
if /i "%HAX%" EQU "*" goto:switchHAXoff
set HAX=*
goto:OLDLIST
:switchHAXoff
set HAX=
goto:OLDLIST

:Switchloadmii
if /i "%loadmii%" EQU "*" goto:switchloadmiioff
set loadmii=*
goto:OLDLIST
:switchloadmiioff
set loadmii=
goto:OLDLIST

:SwitchcIOS202[37]-v5
if /i "%cIOS202[37]-v5%" EQU "*" goto:switchcIOS202[37]-v5off
set cIOS202[37]-v5=*
goto:OLDLIST
:switchcIOS202[37]-v5off
set cIOS202[37]-v5=
goto:OLDLIST

:SwitchcIOS202[38]-v5
if /i "%cIOS202[38]-v5%" EQU "*" goto:switchcIOS202[38]-v5off
set cIOS202[38]-v5=*
goto:OLDLIST
:switchcIOS202[38]-v5off
set cIOS202[38]-v5=
goto:OLDLIST

:SwitchcIOS202[57]-v5
if /i "%cIOS202[57]-v5%" EQU "*" goto:switchcIOS202[57]-v5off
set cIOS202[57]-v5=*
goto:OLDLIST
:switchcIOS202[57]-v5off
set cIOS202[57]-v5=
goto:OLDLIST

:SwitchcIOS222[38]-v5
if /i "%cIOS222[38]-v5%" EQU "*" goto:switchcIOS222[38]-v5off
set cIOS222[38]-v5=*
goto:OLDLIST
:switchcIOS222[38]-v5off
set cIOS222[38]-v5=
goto:OLDLIST

:SwitchcIOS223[37]-v5
if /i "%cIOS223[37]-v5%" EQU "*" goto:switchcIOS223[37]-v5off
set cIOS223[37]-v5=*
goto:OLDLIST
:switchcIOS223[37]-v5off
set cIOS223[37]-v5=
goto:OLDLIST

:SwitchcIOS223[57]-v5
if /i "%cIOS223[57]-v5%" EQU "*" goto:switchcIOS223[57]-v5off
set cIOS223[57]-v5=*
goto:OLDLIST
:switchcIOS223[57]-v5off
set cIOS223[57]-v5=
goto:OLDLIST

:SwitchcIOS224[37]-v5
if /i "%cIOS224[37]-v5%" EQU "*" goto:switchcIOS224[37]-v5off
set cIOS224[37]-v5=*
goto:OLDLIST
:switchcIOS224[37]-v5off
set cIOS224[37]-v5=
goto:OLDLIST

:SwitchcIOS224[57]-v5
if /i "%cIOS224[57]-v5%" EQU "*" goto:switchcIOS224[57]-v5off
set cIOS224[57]-v5=*
goto:OLDLIST
:switchcIOS224[57]-v5off
set cIOS224[57]-v5=
goto:OLDLIST

:SwitchcIOS249[37]-v19
if /i "%cIOS249[37]-v19%" EQU "*" goto:switchcIOS249[37]-v19off
set cIOS249[37]-v19=*
goto:OLDLIST
:switchcIOS249[37]-v19off
set cIOS249[37]-v19=
goto:OLDLIST

:SwitchcIOS249[38]-v19
if /i "%cIOS249[38]-v19%" EQU "*" goto:switchcIOS249[38]-v19off
set cIOS249[38]-v19=*
goto:OLDLIST
:switchcIOS249[38]-v19off
set cIOS249[38]-v19=
goto:OLDLIST

:SwitchcIOS249[57]-v19
if /i "%cIOS249[57]-v19%" EQU "*" goto:switchcIOS249[57]-v19off
set cIOS249[57]-v19=*
goto:OLDLIST
:switchcIOS249[57]-v19off
set cIOS249[57]-v19=
goto:OLDLIST

:SwitchcIOS250[37]-v19
if /i "%cIOS250[37]-v19%" EQU "*" goto:switchcIOS250[37]-v19off
set cIOS250[37]-v19=*
goto:OLDLIST
:switchcIOS250[37]-v19off
set cIOS250[37]-v19=
goto:OLDLIST

:SwitchcIOS250[38]-v19
if /i "%cIOS250[38]-v19%" EQU "*" goto:switchcIOS250[38]-v19off
set cIOS250[38]-v19=*
goto:OLDLIST
:switchcIOS250[38]-v19off
set cIOS250[38]-v19=
goto:OLDLIST

:SwitchcIOS250[57]-v19
if /i "%cIOS250[57]-v19%" EQU "*" goto:switchcIOS250[57]-v19off
set cIOS250[57]-v19=*
goto:OLDLIST
:switchcIOS250[57]-v19off
set cIOS250[57]-v19=
goto:OLDLIST

:SwitchRVL-cmios-v4_WiiGator_GCBL_v0.2
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" goto:switchRVL-cmios-v4_WiiGator_GCBL_v0.2off
set RVL-cmios-v4_WiiGator_GCBL_v0.2=*
goto:OLDLIST
:switchRVL-cmios-v4_WiiGator_GCBL_v0.2off
set RVL-cmios-v4_WiiGator_GCBL_v0.2=
goto:OLDLIST

:SwitchRVL-cmios-v4_Waninkoko_rev5
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" goto:switchRVL-cmios-v4_Waninkoko_rev5off
set RVL-cmios-v4_Waninkoko_rev5=*
goto:OLDLIST
:switchRVL-cmios-v4_Waninkoko_rev5off
set RVL-cmios-v4_Waninkoko_rev5=
goto:OLDLIST

:SwitchcIOS222[38]-v4
if /i "%cIOS222[38]-v4%" EQU "*" goto:switchcIOS222[38]-v4off
set cIOS222[38]-v4=*
goto:OLDLIST
:switchcIOS222[38]-v4off
set cIOS222[38]-v4=
goto:OLDLIST

:SwitchcIOS223[37-38]-v4
if /i "%cIOS223[37-38]-v4%" EQU "*" goto:switchcIOS223[37-38]-v4off
set cIOS223[37-38]-v4=*
goto:OLDLIST
:switchcIOS223[37-38]-v4off
set cIOS223[37-38]-v4=
goto:OLDLIST

:SwitchcIOS249-v17b
if /i "%cIOS249-v17b%" EQU "*" goto:switchcIOS249-v17boff
set cIOS249-v17b=*
goto:OLDLIST
:switchcIOS249-v17boff
set cIOS249-v17b=
goto:OLDLIST

:SwitchcIOS250-v17b
if /i "%cIOS250-v17b%" EQU "*" goto:switchcIOS250-v17boff
set cIOS250-v17b=*
goto:OLDLIST
:switchcIOS250-v17boff
set cIOS250-v17b=
goto:OLDLIST





:SELECTALLOLD

:ALLCIOSS
:RECOMMENDEDCIOSS
set cIOS202[57]-v5=*
set cIOS222[38]-v5=*
set cIOS223[37-38]-v4=*
set cIOS224[57]-v5=*
set cIOS249[57]-v19=*
set cIOS250[37]-v19=*
set RVL-cmios-v4_WiiGator_GCBL_v0.2=*
if /i "%OLDLIST%" EQU "REC" goto:OLDLIST


set cIOS202[37]-v5=*
set cIOS202[38]-v5=*
set cIOS223[57]-v5=*
set cIOS224[37]-v5=*
set cIOS249[37]-v19=*
set cIOS249[38]-v19=*
set cIOS250[38]-v19=*
set cIOS250[57]-v19=*
set RVL-cmios-v4_Waninkoko_rev5=*
set cIOS222[38]-v4=*
set cIOS223[37]-v5=*

set cIOS249-v17b=*
set cIOS250-v17b=*
if /i "%OLDLIST%" EQU "CI" goto:OLDLIST



:USBLOADERSELECT
set cfg249=*

set usbfolder=*
set cfgr=*
set wbm=*
set neogamma=*
set CheatCodes=*
set AccioHacks=*
set f32=*
set USBX=*
if /i "%OLDLIST%" EQU "U" goto:OLDLIST

::not in any list
set cfg222=*
set mmm=*
set BB1=*
set BB2=*
set HM=*
set dop=*
set pwns=*
set Twi=*
set smash=*
set yawm=*
set Pri=*
set HAX=*
set loadmii=*
set TBR=*
set h4=*
set h5=*
set h51=*
set w17=*
set w19=*
set w20=*
set CM5=*
set MP=*
set bootmiisd=*

:SelectJust4FunOLD
set WiiMC=*
set fceugx=*
set snes9xgx=*
set vbagx=*
set SGM=*
set WIIX=*
set HBB=*
set WII64=*
set WIISX=*
set locked=*

goto:OLDLIST






::........................................Advanced Custom Downloads........................................
:ADVANCED
cls
set loadorgo=load

set ADVPATCH=
set ADVSLOT=
set ADVVERSION=

set wadnameless=
set patchname=
set slotname=
set versionname=
set patchcode=
set slotcode=
set versioncode=

Set ADVLIST=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo                               ADVANCED CUSTOM DOWNLOADS
echo.
echo.
echo                        Choose a file for Advanced Custom Download
echo.
echo.
echo                M = Main Menu
echo.
echo                U = User-Defined Custom Download (Very Advanced)
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] IOSs \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 cIOSs
echo.
echo                 9 = IOS9v1034		222v4 = cIOS222[38]-v4
echo                12 = IOS12v525		 222  = cIOS222[38]-v5
echo                13 = IOS13v1031		223v4 = cIOS223[37-38]-v4
echo                14 = IOS14v1031		22337 = cIOS223[37]-v5
echo                15 = IOS15v523		22457 = cIOS224[57]-v5
echo                17 = IOS17v1031	       249v17b = cIOS249-v17b
echo                21 = IOS21v1038		24937 = cIOS249[37]-v19
echo                22 = IOS22v1293		24938 = cIOS249[38]-v19
echo                28 = IOS28v1806		24957 = cIOS249[57]-v19
echo                30 = IOS30v2576
echo                31 = IOS31v3607
echo                33 = IOS33v3607
echo                34 = IOS34v3607
echo                35 = IOS35v3607
echo                36 = IOS36v3607
echo                37 = IOS37v5662
echo                38 = IOS38v4123
echo                41 = IOS41v3348
echo                43 = IOS43v3348
echo                45 = IOS45v3348
echo                46 = IOS46v3350
echo                53 = IOS53v5662
echo                55 = IOS55v5662
echo                56 = IOS56v5661
echo                57 = IOS57v5918
echo                58 = IOS58v6175
echo                60 = IOS60v6174
echo                61 = IOS61v5661
echo                70 = IOS70v6687
echo                80 = IOS80v6943
echo.
echo.
echo.
set /p ADVLIST=     Enter Selection Here: 


if /i "%ADVLIST%" EQU "M" goto:MENU
if /i "%ADVLIST%" EQU "U" goto:Custom

if /i "%ADVLIST%" EQU "9" set IOS9=*
if /i "%ADVLIST%" EQU "12" set IOS12=*
if /i "%ADVLIST%" EQU "13" set IOS13=*
if /i "%ADVLIST%" EQU "14" set IOS14=*
if /i "%ADVLIST%" EQU "15" set IOS15=*
if /i "%ADVLIST%" EQU "17" set IOS17=*
if /i "%ADVLIST%" EQU "21" set IOS21=*
if /i "%ADVLIST%" EQU "22" set IOS22=*
if /i "%ADVLIST%" EQU "28" set IOS28=*
if /i "%ADVLIST%" EQU "30" set IOS30=*
if /i "%ADVLIST%" EQU "31" set IOS31=*
if /i "%ADVLIST%" EQU "33" set IOS33=*
if /i "%ADVLIST%" EQU "34" set IOS34=*
if /i "%ADVLIST%" EQU "35" set IOS35=*
if /i "%ADVLIST%" EQU "36" set IOS36v3607=*
if /i "%ADVLIST%" EQU "37" set IOS37=*
if /i "%ADVLIST%" EQU "38" set IOS38=*
if /i "%ADVLIST%" EQU "41" set IOS41=*
if /i "%ADVLIST%" EQU "43" set IOS43=*
if /i "%ADVLIST%" EQU "45" set IOS45=*
if /i "%ADVLIST%" EQU "46" set IOS46=*
if /i "%ADVLIST%" EQU "53" set IOS53=*
if /i "%ADVLIST%" EQU "55" set IOS55=*
if /i "%ADVLIST%" EQU "56" set IOS56=*
if /i "%ADVLIST%" EQU "57" set IOS57=*
if /i "%ADVLIST%" EQU "58" set IOS58=*
if /i "%ADVLIST%" EQU "60" set IOS60=*
if /i "%ADVLIST%" EQU "61" set IOS61=*
if /i "%ADVLIST%" EQU "70" set IOS70=*
if /i "%ADVLIST%" EQU "80" set IOS80=*
if /i "%ADVLIST%" EQU "222" set cIOS222[38]-v5=*
if /i "%ADVLIST%" EQU "22337" set cIOS223[37]-v5=*
if /i "%ADVLIST%" EQU "22457" set cIOS224[57]-v5=*
if /i "%ADVLIST%" EQU "24937" set cIOS249[37]-v19=*
if /i "%ADVLIST%" EQU "24938" set cIOS249[38]-v19=*
if /i "%ADVLIST%" EQU "24957" set cIOS249[57]-v19=*
if /i "%ADVLIST%" EQU "222v4" set cIOS222[38]-v4=*
if /i "%ADVLIST%" EQU "223v4" set cIOS223[37-38]-v4=*
if /i "%ADVLIST%" EQU "249v17b" set cIOS249-v17b=*

set ADVTYPE=IOS
if /i "%ADVLIST%" EQU "9" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "12" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "13" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "14" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "15" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "17" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "21" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "22" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "28" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "30" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "31" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "33" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "34" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "35" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "36" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "37" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "38" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "41" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "43" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "45" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "46" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "53" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "55" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "56" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "57" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "58" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "60" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "61" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "70" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "80" goto:DLSETTINGS2

set ADVTYPE=CIOS
if /i "%ADVLIST%" EQU "222" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "22337" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "22457" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "24937" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "24938" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "24957" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "222v4" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "223v4" goto:DLSETTINGS2
if /i "%ADVLIST%" EQU "249v17b" goto:DLSETTINGS2


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVANCED



::------------------------------------ADVANCED page 2 - PATCH IOS--------------------------------
:ADVPAGE2
set loadorgo=go
set ADVPATCH=
set patchcode=
set patchname=

if /i "%ADVLIST%" EQU "U" goto:skip
set wadnameless=%wadname%
echo BLAH%wadname%>wadnametemp.bat
sfk filter wadnametemp.bat -rep _BLAH_"set wadnameless="_ -rep _-64-__ -rep _RVL-__ -rep _.wad__ -write -yes>nul
call wadnametemp.bat
del wadnametemp.bat
if /i "%ADVTYPE%" EQU "CIOS" goto:ADVPAGE3
:skip

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      How would you like to patch %wadnameless%?
echo.
echo.
echo.
echo                A = All 3 available patches
echo                N = No Patches
echo.
echo               FS = FakeSigning Patch
echo               ES = ES Identify Patch
echo               NP = Nand Permission Patch
echo.
echo                X = FakeSigning Patch + ES Identify Patch
echo                Y = FakeSigning Patch + Nand Permission Patch
echo                Z = ES Identify Patch + Nand Permission Patch
echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVPATCH=     Enter Selection Here: 



if /i "%ADVLIST%" EQU "U" goto:skip
::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1
if /i "%ADVPATCH%" EQU "B" goto:MENU
:skip
if /i "%ADVPATCH%" EQU "B" goto:CUSTOMPAGE2
if /i "%ADVPATCH%" EQU "M" goto:MENU

if /i "%ADVPATCH%" EQU "A" set patchcode= -FS -ES -NP
if /i "%ADVPATCH%" EQU "N" set patchcode=
if /i "%ADVPATCH%" EQU "FS" set patchcode= -FS
if /i "%ADVPATCH%" EQU "ES" set patchcode= -ES
if /i "%ADVPATCH%" EQU "NP" set patchcode= -NP
if /i "%ADVPATCH%" EQU "X" set patchcode= -FS -ES
if /i "%ADVPATCH%" EQU "Y" set patchcode= -FS -NP
if /i "%ADVPATCH%" EQU "Z" set patchcode= -ES -NP

if /i "%ADVPATCH%" EQU "A" set patchname=[FS-ES-NP]
if /i "%ADVPATCH%" EQU "N" set patchname=
if /i "%ADVPATCH%" EQU "FS" set patchname=[FS]
if /i "%ADVPATCH%" EQU "ES" set patchname=[ES]
if /i "%ADVPATCH%" EQU "NP" set patchname=[NP]
if /i "%ADVPATCH%" EQU "X" set patchname=[FS-ES]
if /i "%ADVPATCH%" EQU "Y" set patchname=[FS-NP]
if /i "%ADVPATCH%" EQU "Z" set patchname=[ES-NP]

if /i "%ADVPATCH%" EQU "A" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "N" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "FS" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "ES" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "NP" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "X" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "Y" goto:ADVPAGE3
if /i "%ADVPATCH%" EQU "Z" goto:ADVPAGE3

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVPAGE2


::------------------------------------ADVANCED page 3 - SLOT--------------------------------
:ADVPAGE3
set ADVSLOT=
set SLOTCODE=
set SLOTNAME=


cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo            To change the IOS slot # for %wadnameless%%patchname%
echo.
echo            Enter a new IOS slot # now
echo.
echo.
echo.
echo.
sfk echo -spat \x20 [Red] WARNING: Be careful what IOS slot # you choose, if it overwrites a crucial IOS 
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 [Red] YOU MAY BRICK
echo.
echo.
echo.
echo              Note: MAX is 254
echo.
echo.
echo                N = No, leave slot unchanged
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVSLOT=     Enter Selection Here: 


::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1

if /i "%ADVSLOT%" EQU "M" goto:MENU


if /i "%ADVTYPE%" EQU "CIOS" goto:BACKTOMENUFIRST
if /i "%ADVSLOT%" EQU "B" goto:ADVPAGE2
:BACKTOMENUFIRST
if /i "%ADVSLOT%" EQU "B" goto:MENU


set SLOTCODE= -slot %ADVSLOT%
set SLOTNAME=slot%ADVSLOT%

if /i "%ADVSLOT%" EQU "N" goto:ADVPAGE4

::limit user input to X# of digits
if not "%ADVSLOT:~3%"=="" (
::    echo. ERROR: Name cannot be more than 8 chars
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %ADVSLOT% LSS 1 (goto:badkey)



if %ADVSLOT% LEQ 254 goto:ADVPAGE4




:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVPAGE3



::------------------------------------ADVANCED page 4 - Version--------------------------------
:ADVPAGE4
Set ADVVERSION=
set VERSIONNAME=
set VERSIONCODE=


if /i "%ADVSLOT%" EQU "N" set SLOTCODE=
if /i "%ADVSLOT%" EQU "N" set SLOTNAME=



set versionreal=%version%
if /i "%ADVLIST%" EQU "222v4" set versionreal=4
if /i "%ADVLIST%" EQU "223v4" set versionreal=4
if /i "%ADVLIST%" EQU "249v17b" set versionreal=17
if /i "%ADVLIST%" EQU "24937" set versionreal=19
if /i "%ADVLIST%" EQU "24938" set versionreal=19
if /i "%ADVLIST%" EQU "24957" set versionreal=19
if /i "%ADVLIST%" EQU "222" set versionreal=65535
if /i "%ADVLIST%" EQU "22337" set versionreal=65535
if /i "%ADVLIST%" EQU "22457" set versionreal=65535



set /a versionplus1=%versionreal%+1

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo        Would you like to change the version # of %wadnameless%%patchname%%slotname%
echo.
echo.
echo                                Note: MAX is 65535
echo.
echo.
echo              MAX = MAX (65535)
echo.
echo                N = No, leave version unchanged (%versionreal%)
if /i "%VER%" EQU "*" goto:bypass
if /i "%versionreal%" NEQ "65535" echo.
if /i "%versionreal%" NEQ "65535" echo               V1 = Version + 1 (%versionplus1%)
:bypass
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVVERSION=     Enter Selection Here: 


::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1



if /i "%ADVVERSION%" EQU "M" goto:MENU
if /i "%ADVVERSION%" EQU "B" goto:ADVPAGE3
if /i "%ADVVERSION%" EQU "MAX" set ADVVERSION=65535
if /i "%versionreal%" EQU "65535" goto:alreadymaxxed

if /i "%VER%" EQU "*" goto:alreadymaxxed
if /i "%ADVVERSION%" EQU "v1" set ADVVERSION=%versionplus1%
:alreadymaxxed

set versioncode= -v %ADVVERSION%
set versionname=v%ADVVERSION%

if /i "%ADVLIST%" EQU "U" goto:skip
if /i "%ADVVERSION%" EQU "N" goto:ADVCONFIRM
:skip
if /i "%ADVVERSION%" EQU "N" goto:CONFIRM

::limit user input to X# of digits
if not "%ADVVERSION:~5%"=="" (
::    echo. ERROR: Name cannot be more than 8 chars
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %ADVVERSION% LSS 1 (goto:badkey)


if /i "%ADVLIST%" EQU "U" goto:skip
if %ADVVERSION% LEQ 65535 goto:ADVCONFIRM
:skip
if %ADVVERSION% LEQ 65535 goto:CONFIRM


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVPAGE4






::------------------------------------ADVANCED page CONFIRM - Version--------------------------------
:ADVCONFIRM
set ADVCONFIRM=

if /i "%ADVVERSION%" EQU "N" set VERSIONNAME=
if /i "%ADVVERSION%" EQU "N" set VERSIONCODE=

set changes=
if /i "%wadnameless%" EQU "%wadnameless%%patchname%%slotname%%versionname%" set changes=none


cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo                               ADVANCED CUSTOM DOWNLOADS
echo.
echo.

if /i "%changes%" EQU "none" goto:nochanges
echo          Are these settings correct?
echo.
echo.
echo.
echo                    Download %wadnameless% and Patch it accordingly
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 %wadnameless%[Red]%patchname%%slotname%%versionname%
goto:yeschanges
:nochanges

echo.
echo.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 [Yellow] You have not selected any changes to be made to %wadnameless%
echo.
echo.
echo                        If you want to download %wadnameless%
echo                you can do so from the Batch/Additional Download Pages
:yeschanges

echo.
echo.
echo.
echo.
echo.
if /i "%changes%" NEQ "none" echo                Y = Yes, just do it!
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p ADVCONFIRM=     Enter Selection Here: 

::"B" will actually take u to the menu only to clear the download_queue, then it will return to advanced page1
if /i "%ADVCONFIRM%" EQU "B" goto:ADVPAGE4
if /i "%ADVCONFIRM%" EQU "M" goto:MENU

if /i "%changes%" EQU "none" goto:nochanges2

if /i "%ADVCONFIRM%" EQU "Y" set DLTOTAL=1
if /i "%ADVCONFIRM%" EQU "Y" set loadorgo=go
::if /i "%ADVCONFIRM%" EQU "Y" set on=*
if /i "%ADVCONFIRM%" EQU "Y" cls
if /i "%ADVCONFIRM%" EQU "Y" goto:DLSETTINGS2
:nochanges2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:ADVCONFIRM








::...................................Custom- User-Defined Custom Download...............................
:CUSTOM

set DEC=none
set HEX=
set countIOS=0

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo          Enter the Number of the IOS you would like to download
::echo      either in Decimal (x,xx,xxx; ie. 9,60,249), or in Hex (xx; ie. F9=249)
echo          or enter "SM" or "MIOS" to download a System Menu or MIOS
echo.
echo.
echo.
sfk echo  -spat \x20 \x20 \x20 \x20 [Red] WARNING: Make sure the IOS number you input actually exists
echo.
echo.
echo.
echo.
echo               #  = Download the IOS number
echo.
echo              SM  = Download a System Menu
echo.
echo             MIOS = Download an MIOS
echo.
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p DEC=     Enter Selection Here: 

if /i "%DEC%" EQU "M" goto:MENU
if /i "%DEC%" EQU "B" goto:ADVANCED
if /i "%DEC%" EQU "MIOS" goto:CUSTOMPAGE2
if /i "%DEC%" EQU "SM" goto:CUSTOMPAGE2


::limit user input to X# of digits
if not "%DEC:~3%"=="" (
::    echo. ERROR: Name cannot be more than 8 chars
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %DEC% LSS 1 (goto:badkey)



if %DEC% LEQ 254 goto:CUSTOMPAGE2


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CUSTOM



:CUSTOMPAGE2
set VER=
set ADVPATCH=
set patchcode=
set patchname=

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
if /i "%DEC%" EQU "SM" echo      What Version of the System Menu would like to download? (ie. XXX)
if /i "%DEC%" EQU "SM" goto:NEXT1
if /i "%DEC%" EQU "MIOS" echo      What Version of MIOS would like to download? (ie. 4, 5, 8, 10)
if /i "%DEC%" EQU "MIOS" goto:NEXT1
echo      What Version of IOS %DEC% would like to download?
:NEXT1
echo.
echo.
echo.
sfk echo  -spat \x20 \x20 \x20 \x20 \x20 \x20 [Red] WARNINGS:[def] - Make sure the version you input actually exists
echo                        - Most recent version may be stubbed
echo.
echo.
echo.
echo.
if /i "%DEC%" NEQ "SM" echo                * = Download the most recent version
if /i "%DEC%" EQU "SM" echo                * = Download the most recent Korean System Menu
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
echo.
set /p VER=     Enter Selection Here: 

if /i "%VER%" EQU "M" goto:MENU
if /i "%VER%" EQU "B" goto:CUSTOM

set version=%VER%
if /i "%VER%" EQU "*" goto:bypass


::limit user input to X# of digits
if not "%VER:~5%"=="" (
    goto:badkey
)


::Reject negative numbers (LSS is less than, GTR is greater than)
if %VER% LSS 1 (goto:badkey)



:bypass

if /i "%DEC%" EQU "SM" goto:nopatches
if /i "%DEC%" EQU "MIOS" goto:nopatches

::for IOSs Only
if /i "%VER%" NEQ "*" set wadnameless=IOS%DEC%-64-v%VER%
if /i "%VER%" EQU "*" set wadnameless=IOS%DEC%-64-vNEW
if /i "%VER%" EQU "*" goto:ADVPAGE2
if /i "%VER%" LSS 65536 goto:ADVPAGE2

:nopatches
if /i "%VER%" EQU "*" goto:CONFIRM
if /i "%VER%" LSS 65536 goto:CONFIRM

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CUSTOMPAGE2




:CONFIRM
if /i "%ADVVERSION%" EQU "N" set VERSIONNAME=
if /i "%ADVVERSION%" EQU "N" set VERSIONCODE=


set VERFINAL=%VER%
if /i "%VER%" EQU "*" set VERFINAL=NEW



cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.

if /i "%DEC%" EQU "SM" echo      Are you sure you want to try downloading System Menu v%VER%?
if /i "%DEC%" EQU "SM" goto:NEXT2
if /i "%DEC%" EQU "MIOS" echo      Are you sure you want to try downloading MIOS v%VER%?
if /i "%DEC%" EQU "MIOS" goto:NEXT2


echo          Are you sure you want to try downloading IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%




:NEXT2
echo.
echo.
echo.
sfk echo  -spat \x20 \x20 \x20 \x20 [Red] WARNING: this download will fail if the file does not exist.
echo.
echo.
echo.
echo.
echo.
echo                Y = Yes, begin downloading now
echo.
echo                N = No, take me back to the Main Menu
echo.
echo.
echo.
echo                B = Back
echo.
echo                M = Main Menu
echo.
echo.
echo.
set /p CONFIRM=     Enter Selection Here: 

if /i "%CONFIRM%" EQU "M" goto:MENU
if /i "%CONFIRM%" EQU "N" goto:MENU

if /i "%CONFIRM%" EQU "Y" goto:CUSTOMDL


if /i "%DEC%" EQU "SM" goto:skip
if /i "%DEC%" EQU "MIOS" goto:skip
if /i "%CONFIRM%" EQU "B" goto:ADVPAGE4
:skip
if /i "%CONFIRM%" EQU "B" goto:CUSTOMPAGE2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CONFIRM



:CUSTOMDL
cls
if /i "%DEC%" EQU "SM" sfk echo [Red] Attempting to download System Menu v%VER%
if /i "%DEC%" EQU "SM" goto:NEXT3
if /i "%DEC%" EQU "MIOS" sfk echo [Red] Attempting to download MIOS v%VER%
if /i "%DEC%" EQU "MIOS" goto:NEXT3

sfk echo [Red] Attempting to download IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%


:NEXT3
echo.
sfk echo -spat \x20 \x20 \x20 [Yellow] Note that custom downloads are not verified, and are not necessarily safe.
sfk echo -spat \x20 \x20 \x20 [Yellow] Make sure you know what you're doing! Use at your own risk!
echo.



if /i "%DEC%" EQU "SM" set HEX=00000002
if /i "%DEC%" EQU "MIOS" set HEX=00000101
if /i "%DEC%" EQU "SM" goto:skiphexcalc
if /i "%DEC%" EQU "MIOS" goto:skiphexcalc

sfk hex %DEC% -digits=8 >hex.txt
FINDSTR /N 0 hex.txt>hex2.txt
del hex.txt
sfk filter hex2.txt -rep _" "__ -lsrep _"1:"_"set hex="_ -write -yes>nul
ren hex2.txt hex2.bat
call hex2.bat
del hex2.bat

:skiphexcalc

if not exist "%DRIVE%"\WAD mkdir "%DRIVE%"\WAD >nul

nusd 00000001%HEX% "%VER%"

echo.


if not exist 00000001%HEX%\00000001%HEX%.wad sfk echo [Red] Download FAILED!
if not exist 00000001%HEX%\00000001%HEX%.wad echo.
if not exist 00000001%HEX%\00000001%HEX%.wad sfk echo -spat \x20 \x20 \x20 [Yellow] Most likely reason is that the file does not exist.
if not exist 00000001%HEX%\00000001%HEX%.wad sfk echo -spat \x20 \x20 \x20 [Yellow] Double check your custom values.
if not exist 00000001%HEX%\00000001%HEX%.wad echo.
if not exist 00000001%HEX%\00000001%HEX%.wad Pause
if not exist 00000001%HEX%\00000001%HEX%.wad goto:menu

if /i "%DEC%" EQU "SM" goto:SYSMENU
if /i "%DEC%" EQU "MIOS" goto:MIOS2





::IOS

if /i "%ROOTSAVE%" EQU "OFF" (set wadfolder=WAD\) else (set wadfolder=)

move /Y 00000001%HEX%\00000001%HEX%.wad "%Drive%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad

if /i "%verfinal%" EQU "NEW" goto:skip
if /i "%OPTION1%" EQU "ON" mkdir "%Drive%"\00000001\%HEX%\v%verfinal%
if /i "%OPTION1%" EQU "ON" copy /Y 00000001%HEX% "%Drive%"\00000001\%HEX%\v%verfinal% >nul
:skip
rd /s /q 00000001%HEX%


echo.

if /i "IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad" EQU "IOS%DEC%v%VERFINAL%.wad" goto:nopatching


patchios "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad%PATCHCODE%%slotcode%%versioncode%
echo.
sfk echo [Yellow] Note: Patches are not always successful, read the PatchIOS log above for details
echo.
:nopatching

if exist "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad sfk echo [Green] The custom file has been created and saved here:
if exist "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad echo.

if exist "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad sfk echo -spat \x20 \x20 \x20 [Green] "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad


if not exist "%DRIVE%"\%wadfolder%IOS%DEC%v%VERFINAL%%patchname%%slotname%%versionname%.wad sfk echo [Yellow] Error: The file was not created
echo.
echo.
pause
goto:MENU



:SYSMENU
move /Y 00000001%HEX%\00000001%HEX%.wad "%Drive%"\WAD\SystemMenu-NUS-v%VERFINAL%.wad

if /i "%verfinal%" EQU "NEW" goto:skip
if /i "%OPTION1%" EQU "ON" mkdir "%Drive%"\00000001\%HEX%\v%verfinal%
if /i "%OPTION1%" EQU "ON" copy /Y 00000001%HEX% "%Drive%"\00000001\%HEX%\v%verfinal% >nul
:skip
rd /s /q 00000001%HEX%

echo.

if exist "%Drive%"\WAD\SystemMenu-NUS-v%VERFINAL%.wad sfk echo [Green] The custom file has been created and saved here:
if exist "%Drive%"\WAD\SystemMenu-NUS-v%VERFINAL%.wad echo.

if exist "%Drive%"\WAD\SystemMenu-NUS-v%VERFINAL%.wad sfk echo -spat \x20 \x20 \x20 [Green] "%Drive%"\WAD\SystemMenu-NUS-v%VERFINAL%.wad


if not exist "%Drive%"\WAD\SystemMenu-NUS-v%VERFINAL%.wad sfk echo [Yellow] Error: The file was not created
echo.
echo.
pause
goto:MENU







:MIOS2
if /i "%ROOTSAVE%" EQU "OFF" (set wadfolder=WAD\) else (set wadfolder=)
move /Y 00000001%HEX%\00000001%HEX%.wad "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad

if /i "%verfinal%" EQU "NEW" goto:skip
if /i "%OPTION1%" EQU "ON" mkdir "%Drive%"\00000001\%HEX%\v%verfinal%
if /i "%OPTION1%" EQU "ON" copy /Y 00000001%HEX% "%Drive%"\00000001\%HEX%\v%verfinal% >nul
:skip
rd /s /q 00000001%HEX%

echo.
if exist "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad sfk echo [Green] The custom file has been created and saved here:
if exist "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad echo.

if exist "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad sfk echo -spat \x20 \x20 \x20 [Green] "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad


if not exist "%Drive%"\%wadfolder%RVL-mios-v%VERFINAL%.wad sfk echo [Yellow] Error: The file was not created
echo.
echo.
pause
goto:MENU







::...................................CONFIG File Menu...............................
:CONFIGFILEMENU
set configfile=

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo          Which Wii App would you like to configure?
echo.
echo.
echo.
echo          BM = BootMii (create bootmii.ini)
echo.
echo         MMM = Multi-Mod Manager (create mmmconfig.txt)
echo.
echo          WM = Wad Manager (create wm_config.txt)
echo.
echo.
echo.
echo.
echo           B = Back
echo.
echo           M = Main Menu
echo.
echo.
echo.
echo.
set /p configfile=     Enter Selection Here: 

if /i "%configfile%" EQU "M" goto:MENU
if /i "%configfile%" EQU "B" goto:MENU

if /i "%configfile%" EQU "BM" goto:BMCONFIG
if /i "%configfile%" EQU "WM" goto:WMCONFIG
if /i "%configfile%" EQU "MMM" goto:MMMCONFIG


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:CONFIGFILEMENU




::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG
set BMVIDEO=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo                 This will create a bootmii.ini file in %DRIVE%\bootmii\
echo                        to determine how BootMii is launched.
echo.
echo.
echo.
echo.
echo      Enter the Video Mode you would like BootMii to use:
echo.
echo.
echo.
echo                 N = NTSC
echo                50 = PAL50
echo                60 = PAL60
echo                 P = Progressive
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMVIDEO=     Enter Selection Here: 

if /i "%BMVIDEO%" EQU "M" goto:MENU
if /i "%BMVIDEO%" EQU "B" goto:CONFIGFILEMENU
if /i "%BMVIDEO%" EQU "N" set BMVIDEO=NTSC
if /i "%BMVIDEO%" EQU "50" set BMVIDEO=PAL50
if /i "%BMVIDEO%" EQU "60" set BMVIDEO=PAL60
if /i "%BMVIDEO%" EQU "P" set BMVIDEO=PROGRESSIVE
if /i "%BMVIDEO%" EQU "NTSC" goto:BMCONFIG2
if /i "%BMVIDEO%" EQU "PAL50" goto:BMCONFIG2
if /i "%BMVIDEO%" EQU "PAL60" goto:BMCONFIG2
if /i "%BMVIDEO%" EQU "PROGRESSIVE" goto:BMCONFIG2

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG







::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG2
set BMBOOT=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      What would you like BootMii to AutoBoot?
echo.
echo.
echo.
echo                 O = OFF     (BootMii)
echo                 H = HBC     (Homebrew Channel)
echo                 S = SYSMENU (System Menu)
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMBOOT=     Enter Selection Here: 

if /i "%BMBOOT%" EQU "M" goto:MENU
if /i "%BMBOOT%" EQU "B" goto:BMCONFIG

if /i "%BMBOOT%" EQU "O" set BMBOOT=OFF
if /i "%BMBOOT%" EQU "H" set BMBOOT=HBC
if /i "%BMBOOT%" EQU "S" set BMBOOT=SYSMENU

if /i "%BMBOOT%" EQU "OFF" set BMDELAY=0
if /i "%BMBOOT%" EQU "OFF" goto:BMCONFIG4
if /i "%BMBOOT%" EQU "HBC" goto:BMCONFIG3
if /i "%BMBOOT%" EQU "SYSMENU" goto:BMCONFIG3

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG2



::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG3
set BMDELAY=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
if /i "%BMBOOT%" EQU "HBC" echo      How many seconds should BootMii to wait to autoboot the HomeBrew Channel?
if /i "%BMBOOT%" EQU "SYSMENU" echo      How many seconds should BootMii to wait to autoboot the System Menu?
echo.
echo.
echo.
echo.
echo          Possible Settings:
echo.
echo                 0,1,2,3,4,5,6,7,8,9,10
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMDELAY=     Enter Selection Here: 

if /i "%BMDELAY%" EQU "M" goto:MENU
if /i "%BMDELAY%" EQU "B" goto:BMCONFIG2


if /i "%BMDELAY%" EQU "0" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "1" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "2" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "3" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "4" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "5" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "6" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "7" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "8" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "9" goto:BMCONFIG4
if /i "%BMDELAY%" EQU "10" goto:BMCONFIG4

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG3





::...................................BootMii CONFIGURATOR (bootmii.ini)...............................
:BMCONFIG4
set BMSD=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      Would you also like to download BootMii SD Files required to launch BootMii?
echo.
echo.
echo.
echo          Note: these are the same files generated by the HackMii Installer
echo                by installing BootMii as Boot2 or by Preparing an SD Card
echo.
echo.
echo.
echo                 Y = Yes
echo.
echo                 N = No
echo.
echo.
echo.
echo.
echo                 B = Back
echo.
echo                 M = Main Menu
echo.
echo.
echo.
echo.
set /p BMSD=     Enter Selection Here: 

if /i "%BMSD%" EQU "M" goto:MENU

if /i "%BMBOOT%" EQU "OFF" goto:skip
if /i "%BMSD%" EQU "B" goto:BMCONFIG3
:skip
if /i "%BMSD%" EQU "B" goto:BMCONFIG2

if /i "%BMSD%" EQU "Y" goto:BMCONFIG5
if /i "%BMSD%" EQU "N" goto:BMCONFIG5


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG4






::...................................BootMii CONFIGURATOR page 5...............................
:BMCONFIG5
set BMCONFIRM=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo                              Are these settings correct?
echo.
echo.
echo      Video Mode is set to %BMVIDEO%
echo.
echo      AutoBoot is set to %BMBOOT%
if /i "%BMBOOT%" EQU "OFF" goto:nodelay
echo.
echo      AutoBoot Delay is set to %BMDELAY% seconds
:nodelay
echo.
if /i "%BMSD%" EQU "Y" echo      * Download BootMii SD Files to Launch BootMii
echo.
echo.
echo.
echo.
echo.
echo      Y = Yes, Create bootmii.ini with these settings
if exist "%Drive%"\bootmii\bootmii.ini echo           Note: existing bootmii.ini will be overwritten
echo.
echo      N = No, take me back to the Main Menu
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p BMCONFIRM=     Enter Selection Here: 

if /i "%BMCONFIRM%" EQU "B" goto:BMCONFIG4
if /i "%BMCONFIRM%" EQU "M" goto:MENU
if /i "%BMCONFIRM%" EQU "N" goto:MENU
if /i "%BMCONFIRM%" EQU "Y" goto:BUILDBMCONFIG

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:BMCONFIG5


:BUILDBMCONFIG
if not exist "%Drive%"\bootmii mkdir "%Drive%"\bootmii


echo # BootMii Config File> "%Drive%"\bootmii\bootmii.ini
echo # Created by NUS Auto Downloader>> "%Drive%"\bootmii\bootmii.ini
echo #>> "%Drive%"\bootmii\bootmii.ini
echo # Video mode, possible settings:>> "%Drive%"\bootmii\bootmii.ini
echo # NTSC, PAL50, PAL60, PROGRESSIVE>> "%Drive%"\bootmii\bootmii.ini
echo VIDEO=%BMVIDEO%>> "%Drive%"\bootmii\bootmii.ini
echo #>> "%Drive%"\bootmii\bootmii.ini
echo # Autoboot, possible settings:>> "%Drive%"\bootmii\bootmii.ini
echo # SYSMENU, HBC, OFF>> "%Drive%"\bootmii\bootmii.ini
echo AUTOBOOT=%BMBOOT%>> "%Drive%"\bootmii\bootmii.ini
echo #>> "%Drive%"\bootmii\bootmii.ini
echo # BOOTDELAY, possible settings:>> "%Drive%"\bootmii\bootmii.ini
echo # 0,1,2,3,4,5,6,7,8,9,10>> "%Drive%"\bootmii\bootmii.ini
echo BOOTDELAY=BLAH>> "%Drive%"\bootmii\bootmii.ini
sfk filter "%Drive%"\bootmii\bootmii.ini -rep _BLAH_%BMDELAY%_ -write -yes>nul

start notepad "%Drive%\bootmii\bootmii.ini"

cls
if /i "%BMSD%" EQU "Y" set DLTOTAL=1
if /i "%BMSD%" EQU "Y" set bootmiisd=*
if /i "%BMSD%" EQU "Y" goto:bootmiisd

goto:MENU






::...................................WAD MANAGER CONFIGURATOR (wmconfig.txt)...............................
:WMCONFIG
set WMCIOS=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      This will create a wm_config.txt file in %DRIVE%\WAD\, and it is optional.
echo      You will get all the prompts if you don't have this file.
echo.
echo      Note: only works for YAWMM, Wad Manager Multi-Mod and WAD Manager Folder Mod
echo.
echo.
echo.
echo.
echo      Enter the IOS # you would like Wad Manager to load automatically
echo.
echo              Note: MAX is 254
echo                    Common choices are 36, 249, 250, etc.
echo                    NAND Emulation installation only available for 249 or 250
echo.
echo.
echo.
echo      N = None (Wad Manager will prompt you for selection)
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCIOS=     Enter Selection Here: 

if /i "%WMCIOS%" EQU "M" goto:MENU
if /i "%WMCIOS%" EQU "B" goto:CONFIGFILEMENU
if /i "%WMCIOS%" EQU "N" goto:WMCONFIG2

::limit user input to X# of digits
if not "%WMCIOS:~3%"=="" (
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %WMCIOS% LSS 1 (goto:badkey)

if %WMCIOS% LEQ 254 goto:WMCONFIG2

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG


::...................................WAD MANAGER CONFIGURATOR page 2...............................
:WMCONFIG2
set WMDEVICE=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo              Enter the FAT device you would like to load automatically.
echo.
echo              Note: you can enter either the number or the word
echo.
echo.
echo.
echo.
echo      1 = SD
echo      2 = USB
echo      3 = USB2
echo      4 = GCSDA
echo      5 = GCSDA
echo.
echo      N = None (Wad Manager will prompt you for selection)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMDEVICE=     Enter Selection Here: 

if /i "%WMDEVICE%" EQU "1" SET WMDEVICE=sd
if /i "%WMDEVICE%" EQU "2" SET WMDEVICE=usb
if /i "%WMDEVICE%" EQU "3" SET WMDEVICE=usb2
if /i "%WMDEVICE%" EQU "4" SET WMDEVICE=gcsda
if /i "%WMDEVICE%" EQU "5" SET WMDEVICE=gcsdb

if /i "%WMDEVICE%" EQU "sd" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "usb" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "usb2" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "gcsda" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "gcsda" goto:WMCONFIG3
if /i "%WMDEVICE%" EQU "N" goto:WMCONFIG3

if /i "%WMDEVICE%" EQU "B" goto:WMCONFIG
if /i "%WMDEVICE%" EQU "M" goto:MENU



echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG2


::...................................WAD MANAGER CONFIGURATOR page 3...............................
:WMCONFIG3
:: NAND Emulation installation only available if cIOS249 or cIOS250 selected
if /i "%WMCIOS%" EQU "249" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "250" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "N" goto:WMCONFIG3B
set WMNAND=N
goto:WMCONFIG4

:WMCONFIG3B

set WMNAND=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo      NAND Emulation
echo.
echo      Enter the NAND device you would like to select automatically.
echo.
echo.
echo          Note: PC tools like ShowMiiWads are better at installing wads to
echo                emulated nand. So I recommend leaving NAND Emulation Disabled
echo.
echo          Note: you can enter either the number or the word
echo.
echo.
echo.
echo      1 = Disable
echo      2 = USB
echo      3 = SD
echo.
echo      N = None (Wad Manager will prompt selection if cIOS249 or cIOS250 selected)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMNAND=     Enter Selection Here: 


if /i "%WMNAND%" EQU "3" SET WMNAND=SD
if /i "%WMNAND%" EQU "2" SET WMNAND=USB
if /i "%WMNAND%" EQU "1" SET WMNAND=Disable


if /i "%WMNAND%" EQU "SD" goto:WMCONFIG4
if /i "%WMNAND%" EQU "USB" goto:WMCONFIG4
if /i "%WMNAND%" EQU "Disable" goto:WMCONFIG4
if /i "%WMNAND%" EQU "N" goto:WMCONFIG4
if /i "%WMNAND%" EQU "M" goto:MENU
if /i "%WMNAND%" EQU "B" goto:WMCONFIG2


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG3

::...................................WAD MANAGER CONFIGURATOR page 4...............................
:WMCONFIG4
set WMPATH=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter the Start-up Path you would like to load initially.
echo.
echo          Note: If you don't have a startupPath, the default is /WAD
echo.
echo          Note: Be sure that the path exists, else you will get an error.
echo.
echo.
echo.
echo.
echo          Examples:
echo                   /WAD/Forwarders
echo                   /myWad
echo                   /
echo                      Note: '/' sets the StartupPath to the root of the device
echo.
echo.
echo      N = None (the default is /WAD)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMPATH=     Enter Selection Here: 


if /i "%WMPATH%" EQU "N" SET WMPATH=/WAD
if /i "%WMPATH%" EQU "B" goto:WMCONFIG4BACK
if /i "%WMPATH%" EQU "M" goto:MENU
IF "%WMPATH%"=="" echo You Have Entered an Incorrect Key
IF "%WMPATH%"=="" @ping 127.0.0.1 -n 2 -w 1000> nul
IF "%WMPATH%"=="" goto:WMCONFIG4
goto:WMCONFIG5

:WMCONFIG4BACK
if /i "%WMCIOS%" EQU "249" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "250" goto:WMCONFIG3B
if /i "%WMCIOS%" EQU "N" goto:WMCONFIG3B
goto:WMCONFIG2





::...................................WAD MANAGER CONFIGURATOR page 5...............................
:WMCONFIG5
set WMPASS=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter a Password to access Wad Manager ONLY using LRUD; where
echo.
echo         L = Left
echo         R = Right
echo         U = Up
echo         D = Down
echo.
echo      Note: Password is entered on the WiiMote or GC Controller, max 10 characters
echo.
echo      Note: If you don't have a password, the default is no password
echo.
echo.
echo.
echo.
echo          Examples:
echo                   UDLR
echo                   UDLRUDLRUD
echo                   UUUUUUU
echo                   L
echo.
echo.
echo      N = None (No Password)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMPASS=     Enter Selection Here: 

if /i "%WMPASS%" EQU "B" goto:WMCONFIG4
if /i "%WMPASS%" EQU "M" goto:MENU

IF "%WMPASS%"=="" echo You Have Entered an Incorrect Key
IF "%WMPASS%"=="" @ping 127.0.0.1 -n 2 -w 1000> nul
IF "%WMPASS%"=="" goto:WMCONFIG5


::limit user input to X# of digits
if not "%WMPASS:~10%"=="" (
    echo. ERROR: Password cannot be more than 10 Digits
    @ping 127.0.0.1 -n 2 -w 1000> nul
    goto:WMCONFIG5
)



::...................................WAD MANAGER CONFIGURATOR page 6...............................
:WMCONFIG6
set WMCONFIRM=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo                              Are these settings correct?
echo.
echo.
if /i "%WMCIOS%" EQU "N" echo      Prompt cIOS Selection
if /i "%WMCIOS%" NEQ "N" echo      cIOSVersion=%WMCIOS%
echo.
if /i "%WMDEVICE%" EQU "N" echo      Prompt FAT Device Selection
if /i "%WMDEVICE%" NEQ "N" echo      FatDevice=%WMDEVICE%
echo.
if /i "%WMCIOS%" EQU "249" goto:nanddevice
if /i "%WMCIOS%" EQU "250" goto:nanddevice
goto:skipnanddevice

:nanddevice
if /i "%WMNAND%" EQU "N" echo      Prompt NAND Device Selection
if /i "%WMNAND%" NEQ "N" echo      NANDDevice=%WMNAND%
echo.
:skipnanddevice

echo      StartupPath=%WMPATH%
echo.
if /i "%WMPASS%" EQU "N" echo      No Password
if /i "%WMPASS%" NEQ "N" echo      Password=%WMPASS%
echo.
echo.
echo.
echo.
echo      Y = Yes, Create wm_config.txt with these settings
if exist "%Drive%"\WAD\wm_config.txt echo           Note: existing wm_config.txt will be overwritten
echo.
echo      N = No, take me back to the main menu
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCONFIRM=     Enter Selection Here: 

if /i "%WMCONFIRM%" EQU "B" goto:WMCONFIG5
if /i "%WMCONFIRM%" EQU "M" goto:MENU
if /i "%WMCONFIRM%" EQU "N" goto:MENU
if /i "%WMCONFIRM%" EQU "Y" goto:BUILDWMCONFIG

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:WMCONFIG6


:BUILDWMCONFIG
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
echo ;wm_config.txt made by NUS Auto Downloader> "%Drive%"\WAD\wm_config.txt
if /i "%WMCIOS%" NEQ "N" echo cIOSVersion=%WMCIOS%>> "%Drive%"\WAD\wm_config.txt
if /i "%WMDEVICE%" NEQ "N" echo FatDevice=%WMDEVICE%>> "%Drive%"\WAD\wm_config.txt
if /i "%WMNAND%" NEQ "N" echo NANDDevice=%WMNAND%>> "%Drive%"\WAD\wm_config.txt
echo StartupPath=%WMPATH%>> "%Drive%"\WAD\wm_config.txt
if /i "%WMPASS%" NEQ "N" echo Password=%WMPASS%>> "%Drive%"\WAD\wm_config.txt
start notepad "%Drive%\WAD\wm_config.txt"
goto:MENU








::...................................MMM CONFIGURATOR (mmmconfig.txt)...............................
:MMMCONFIG
set WMCIOS=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      This will create a mmmconfig.txt file in %DRIVE%\, and it is optional.
echo.
echo.
echo.
echo.
echo      Enter the IOS # you would like Multi-Mod Manager (MMM) to load automatically
echo.
echo              Note: MAX is 254
echo                    Common choices are 36, 249, 250, etc.
echo.
echo.
echo.
echo      N = None (Do Not Auto-Reload IOS)
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCIOS=     Enter Selection Here: 

if /i "%WMCIOS%" EQU "M" goto:MENU
if /i "%WMCIOS%" EQU "B" goto:CONFIGFILEMENU
if /i "%WMCIOS%" EQU "N" goto:MMMCONFIG2

::limit user input to X# of digits
if not "%WMCIOS:~3%"=="" (
    goto:badkey
)

::Reject negative numbers (LSS is less than, GTR is greater than)
if %WMCIOS% LSS 1 (goto:badkey)

if %WMCIOS% LEQ 254 goto:MMMCONFIG2

:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MMMCONFIG


::...................................MMM CONFIGURATOR (mmmconfig.txt) page 2...............................
:MMMCONFIG2
set WMDEVICE=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter the FAT device you would like to load automatically.
echo.
echo          Note: you can enter either the number or the word
echo.
echo.
echo.
echo.
echo      1 = SD (default if mmmconfig.txt does not exist)
echo      2 = USB
echo      3 = SMB
echo.
echo      N = None (MMM will prompt you for selection)
echo.
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMDEVICE=     Enter Selection Here: 


if /i "%WMDEVICE%" EQU "1" SET WMDEVICE=sd
if /i "%WMDEVICE%" EQU "2" SET WMDEVICE=usb
if /i "%WMDEVICE%" EQU "3" SET WMDEVICE=smb

if /i "%WMDEVICE%" EQU "sd" goto:MMMCONFIG3
if /i "%WMDEVICE%" EQU "usb" goto:MMMCONFIG3
if /i "%WMDEVICE%" EQU "smb" goto:MMMCONFIG3

if /i "%WMDEVICE%" EQU "N" goto:MMMCONFIG3

if /i "%WMDEVICE%" EQU "B" goto:MMMCONFIG
if /i "%WMDEVICE%" EQU "M" goto:MENU



echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MMMCONFIG2



::...................................MMM CONFIGURATOR (mmmconfig.txt) page 3...............................
:MMMCONFIG3
set WMPATH=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo      Enter the Start-up Path you would like to load initially.
echo.
echo          Note: If you don't have a startupPath, the default is /WAD
echo.
echo          Note: Be sure that the path exists, else you will get an error.
echo.
echo.
echo.
echo.
echo          Examples:
echo                   /WAD/Forwarders
echo                   /myWad
echo                   /
echo                      Note: '/' sets the StartupPath to the root of the device
echo.
echo.
echo      N = None (the default is /WAD)
echo.
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMPATH=     Enter Selection Here: 


if /i "%WMPATH%" EQU "N" SET WMPATH=/WAD
if /i "%WMPATH%" EQU "B" goto:MMMCONFIG2
if /i "%WMPATH%" EQU "M" goto:MENU

IF "%WMPATH%"=="" echo You Have Entered an Incorrect Key
IF "%WMPATH%"=="" @ping 127.0.0.1 -n 2 -w 1000> nul
IF "%WMPATH%"=="" goto:MMMCONFIG3

::...................................MMM CONFIGURATOR (mmmconfig.txt) page 4...............................
:MMMCONFIG4
set WMCONFIRM=
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.
echo.
echo                              Are these settings correct?
echo.
echo.
if /i "%WMCIOS%" EQU "N" echo      Do Not Auto-Reload IOS
if /i "%WMCIOS%" NEQ "N" echo      AutoLoadIOS=%WMCIOS%
echo.
if /i "%WMDEVICE%" EQU "N" echo      Prompt FAT Device Selection
echo.
if /i "%WMDEVICE%" NEQ "N" echo      FatDevice=%WMDEVICE%

echo      StartupPath=%WMPATH%
echo.
echo.
echo.
echo.
echo      Y = Yes, Create mmmconfig.txt with these settings
if exist "%Drive%"\mmmconfig.txt echo           Note: existing mmmconfig.txt will be overwritten
echo.
echo      N = No, take me back to the main menu
echo.
echo.
echo      B = Back
echo.
echo      M = Main Menu
echo.
echo.
echo.
echo.
set /p WMCONFIRM=     Enter Selection Here: 

if /i "%WMCONFIRM%" EQU "B" goto:MMMCONFIG3
if /i "%WMCONFIRM%" EQU "M" goto:MENU
if /i "%WMCONFIRM%" EQU "N" goto:MENU
if /i "%WMCONFIRM%" EQU "Y" goto:BUILDMMMCONFIG

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:MMMCONFIG4


:BUILDMMMCONFIG
if not exist "%Drive%" mkdir "%Drive%"
echo ;mmmconfig.txt made by NUS Auto Downloader> "%Drive%"\mmmconfig.txt
if /i "%WMCIOS%" NEQ "N" echo AutoLoadIOS=%WMCIOS%>> "%Drive%"\mmmconfig.txt
if /i "%WMDEVICE%" NEQ "N" echo FatDevice=%WMDEVICE%>> "%Drive%"\mmmconfig.txt
if /i "%WMDEVICE%" EQU "N" echo FatDevice=>> "%Drive%"\mmmconfig.txt

echo StartupPath=%WMPATH%>> "%Drive%"\mmmconfig.txt

start notepad "%Drive%\mmmconfig.txt"
goto:MENU











::........................................HACKMII SOLUTION.......................................
:HACKMIISOLUTION
set SETTINGSHM=
::set IOS34=*
set IOS58=*
set HM=*
set mmm=*
if /i "%FIRMSTART%" EQU "4.1" set BB1=*
if /i "%FIRMSTART%" EQU "4.0" set BB1=*
if /i "%FIRMSTART%" EQU "3.x" set BB1=*
if /i "%FIRMSTART%" EQU "4.2" set BB2=*
::if /i "%FIRMSTART%" EQU "4.3" set LOADMII=*

::if /i "%REGION%" EQU "K" goto:skiploadmiiK
if /i "%EXPLOIT%" NEQ "default" set LOADMII=*
::if /i "%FIRMSTART%" EQU "o" set LOADMII=*
:skiploadmiiK

if /i "%EXPLOIT%" EQU "S" set SMASH=*
if /i "%EXPLOIT%" EQU "L" set PWNS=*
if /i "%EXPLOIT%" EQU "T" set TWI=*

if /i "%EXPLOIT%" NEQ "?" goto:notallexploits2
if /i "%FIRMSTART%" EQU "o" set Twi=*
if /i "%REGION%" EQU "U" set SMASH=*
if /i "%REGION%" EQU "U" set PWNS=*
if /i "%REGION%" EQU "E" set PWNS=*
:notallexploits2


SET DLTOTAL=0

if /i "%BB1%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%BB2%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%HM%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%mmm%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%LOADMII%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SMASH%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%PWNS%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%Twi%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS34%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS61%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS58%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1


cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo                                  HackMii Solutions
echo.
echo      The following %DLTOTAL% files will be downloaded to "%DRIVE%":
echo.
if /i "%HM%" EQU "*" echo      * HackMii Installer
if /i "%BB1%" EQU "*" echo      * BannerBomb v1 (for 3.0 - 4.1 Wiis)
if /i "%BB2%" EQU "*" echo      * BannerBomb v2 (for 4.2 Wiis)
if /i "%pwns%" EQU "*" echo      * Indiana Pwns
if /i "%Twi%" EQU "*" echo      * Twilight Hack v0.1 Beta1 (for Wii's 3.3 and below)
if /i "%smash%" EQU "*" echo      * Smash Stack (USA)
if /i "%loadmii%" EQU "*" echo      * LoadMii v0.3 Twilight
if /i "%mmm%" EQU "*" echo      * Multi-Mod Manager (MMM)
if /i "%IOS61%" EQU "*" echo      * IOS61v5661
if /i "%IOS58%" EQU "*" echo      * IOS58v6175
echo.
echo      Begin Downloading now?
echo.
echo           Y = Yes, Generate Guide and Begin Downloading
echo           G = Generate Guide Only
echo.
echo           B = Back
echo           M = Main Menu
echo.
set /p SETTINGSHM=     Enter Selection Here: 

if /i "%SETTINGSHM%" EQU "B" goto:MENU
if /i "%SETTINGSHM%" EQU "M" goto:MENU

if /i "%SETTINGSHM%" EQU "Y" goto:COPY

if /i "%SETTINGSHM%" EQU "G" goto:HMguide

echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:HACKMIISOLUTION
cls




::...................................Download...............................
:Download

cls

if /i "%REGION%" EQU "U" goto:U
if /i "%REGION%" EQU "E" goto:E
if /i "%REGION%" EQU "J" goto:J
if /i "%REGION%" EQU "K" goto:K
if /i "%REGION%" EQU "RC" goto:REGIONCHANGEDKOREAN

:REGIONCHANGEDKOREAN
if /i "%FIRMSTART%" NEQ "4.3" set IOS80K=*
if /i "%FIRM%" EQU "4.3" set IOS80K=*
if /i "%FIRM%" EQU "4.2" set IOS70K=*
if /i "%REGIONCHANGE%" EQU "U" goto:U
if /i "%REGIONCHANGE%" EQU "E" goto:E
if /i "%REGIONCHANGE%" EQU "J" goto:J

:U
if /i "%FIRM%" EQU "%FIRMSTART%" goto:SKIPSM
if /i "%FIRM%" EQU "4.3" set SM4.3U=*
if /i "%FIRM%" EQU "4.2" set SM4.2U=*
if /i "%FIRM%" EQU "4.1" set SM4.1U=*
if /i "%FIRM%" EQU "3.2" set SM3.2U=*
:SKIPSM

if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IU=*
if /i "%WEATHER%" EQU "Y" set WU=*
if /i "%NEWS%" EQU "Y" set NU=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSU=*
goto:BUGGEDSMIOS

:E
if /i "%FIRM%" EQU "%FIRMSTART%" goto:SKIPSM
if /i "%FIRM%" EQU "4.3" set SM4.3E=*
if /i "%FIRM%" EQU "4.2" set SM4.2E=*
if /i "%FIRM%" EQU "4.1" set SM4.1E=*
if /i "%FIRM%" EQU "3.2" set SM3.2E=*
:SKIPSM

if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IE=*
if /i "%WEATHER%" EQU "Y" set WE=*
if /i "%NEWS%" EQU "Y" set NE=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSE=*
goto:BUGGEDSMIOS

:J
if /i "%FIRM%" EQU "%FIRMSTART%" goto:SKIPSM
if /i "%FIRM%" EQU "4.3" set SM4.3J=*
if /i "%FIRM%" EQU "4.2" set SM4.2J=*
if /i "%FIRM%" EQU "4.1" set SM4.1J=*
if /i "%FIRM%" EQU "3.2" set SM3.2J=*
:SKIPSM

if /i "%PIC%" EQU "Y" set P=*
if /i "%NET%" EQU "Y" set IJ=*
if /i "%WEATHER%" EQU "Y" set WJ=*
if /i "%NEWS%" EQU "Y" set NJ=*
if /i "%SHOP%" EQU "Y" set S=*
if /i "%SPEAK%" EQU "Y" set WSJ=*
goto:BUGGEDSMIOS

:K

if /i "%FIRM%" EQU "%FIRMSTART%" goto:SKIPSM
if /i "%FIRM%" EQU "4.3" set SM4.3K=*
if /i "%FIRM%" EQU "4.2" set SM4.2K=*
if /i "%FIRM%" EQU "4.1" set SM4.1K=*
:SKIPSM

if /i "%PIC%" EQU "Y" set PK=*
if /i "%SHOP%" EQU "Y" set SK=*

if /i "%ACTIVEIOS%" EQU "off" goto:skip
if /i "%FIRMSTART%" NEQ "4.3" set ios41=*
if /i "%FIRMSTART%" NEQ "4.3" set ios43=*
if /i "%FIRMSTART%" NEQ "4.3" set ios45=*
if /i "%FIRMSTART%" NEQ "4.3" set ios46=*
:skip



:BUGGEDSMIOS
if /i "%FIRM%" EQU "3.2" set IOS30P60=*
if /i "%FIRM%" EQU "4.1" set IOS60P=*
if /i "%REGION%" EQU "RC" goto:COMMONSETTINGS
if /i "%FIRM%" EQU "4.2" set IOS70P=*
if /i "%FIRM%" EQU "4.3" set IOS80P=*

:COMMONSETTINGS
if /i "%SHOP%" EQU "Y" set IOS61=*

if /i "%ACTIVEIOS%" EQU "off" goto:skipactiveios
if /i "%FIRMSTART%" EQU "4.2" goto:skipactivemios
if /i "%FIRMSTART%" EQU "4.3" goto:skipactiveios
::if /i "%FIRM%" EQU "4.2" goto:activeios


:ACTIVEIOS
set M10=*
:skipactivemios
set IOS9=*
set IOS12=*
set IOS13=*
set IOS14=*
set IOS15v1031=*
set IOS17=*
set IOS21=*
set IOS22=*
set IOS28=*
set IOS31=*
set IOS33=*
set IOS34=*
set IOS35=*
if /i "%OPTION36%" EQU "on" set IOS36v3607=*
set IOS37=*
set IOS38=*
set IOS53=*
set IOS55=*
set IOS56=*
set IOS57=*
set IOS58=*
set IOS61=*
:skipactiveios

if /i "%MII%" EQU "Y" set Mii=*



if /i "%protect%" NEQ "Y" goto:NoExtraProtection
set IOS11P60=*
set IOS20P60=*
set IOS30P60=*
if /i "%REGION%" EQU "K" set IOS40P60=*
set IOS50P=*
if /i "%REGION%" EQU "K" set IOS52P=*
set IOS60P=*
if /i "%REGION%" NEQ "RC" set IOS70P=*
if /i "%REGION%" EQU "RC" set IOS70K=*
set usbx=*
::--Note: IOS80v54321(IOS60v6174[FS-ES-NP]) will be downloaded for regionchanged korean wii's even with No Extra Brick Protection
:NoExtraProtection




if /i "%VIRGIN%" NEQ "Y" goto:notvirgin
:virgin
set HM=*
if /i "%REGION%" EQU "K" set IOS34=*
set IOS58=*
if /i "%FIRMSTART%" EQU "4.1" set BB1=*
if /i "%FIRMSTART%" EQU "4.0" set BB1=*
if /i "%FIRMSTART%" EQU "3.2" set BB1=*
if /i "%FIRMSTART%" EQU "3.x" set BB1=*
if /i "%FIRMSTART%" EQU "4.2" set BB2=*
if /i "%FIRMSTART%" EQU "4.3" set TBR=*
if /i "%FIRMSTART%" EQU "4.3" set IOS15v1031=*
::if /i "%FIRMSTART%" EQU "4.3" set LOADMII=*
::if /i "%FIRMSTART%" EQU "4.3" set IOS34=*
if /i "%FIRMSTART%" EQU "4.3" set IOS41v3091=*
if /i "%EXPLOIT%" EQU "S" set SMASH=*
if /i "%EXPLOIT%" EQU "L" set PWNS=*
if /i "%EXPLOIT%" EQU "T" set Twi=*

if /i "%EXPLOIT%" NEQ "?" goto:notallexploits
if /i "%FIRMSTART%" EQU "o" set Twi=*
if /i "%REGION%" EQU "U" set SMASH=*
if /i "%REGION%" EQU "U" set PWNS=*
if /i "%REGION%" EQU "E" set PWNS=*
if /i "%REGIONCHANGE%" EQU "U" set SMASH=*
if /i "%REGIONCHANGE%" EQU "U" set PWNS=*
if /i "%REGIONCHANGE%" EQU "E" set PWNS=*
:notallexploits


set IOS15v257=*
if /i "%FIRMSTART%" NEQ "4.3" set IOS15=*
set IOS36=*
set mmm=*
set cIOS202[57]-v5=*
set cIOS222[38]-v5=*
set cIOS223[37-38]-v4=*
set cIOS224[57]-v5=*
set cIOS249[57]-v19=*
set cIOS250[37]-v19=*
set RVL-cmios-v4_WiiGator_GCBL_v0.2=*
set M10=
set pri=*
set HAX=*

goto:DOWNLOADQUEUE



:notvirgin

if /i "%HM%" NEQ "Y" goto:noHMforNonVirgin
set HM=*
set IOS58=*
if /i "%FIRMSTART%" EQU "4.1" set BB1=*
if /i "%FIRMSTART%" EQU "4.0" set BB1=*
if /i "%FIRMSTART%" EQU "3.x" set BB1=*
if /i "%FIRMSTART%" EQU "3.2" set BB1=*
if /i "%FIRMSTART%" EQU "4.2" set BB2=*
if /i "%FIRMSTART%" EQU "o" set TWI=*

if /i "%FIRMSTART%" NEQ "4.3" goto:skip4.3extra2
if /i "%REGION%" EQU "U" set SMASH=*
if /i "%REGION%" EQU "U" set PWNS=*
if /i "%REGION%" EQU "E" set PWNS=*
if /i "%REGIONCHANGE%" EQU "U" set SMASH=*
if /i "%REGIONCHANGE%" EQU "U" set PWNS=*
if /i "%REGIONCHANGE%" EQU "E" set PWNS=*
:skip4.3extra2

:noHMforNonVirgin


if /i "%FIRMSTART%" NEQ "4.3" goto:skip4.3extra3
::if MMM is Y, then 4.3 users wants TBR 1.13 files
if /i "%mmm%" EQU "Y" set IOS41v3091=*
if /i "%mmm%" EQU "Y" set TBR=*
if /i "%mmm%" EQU "Y" set IOS15v257=*
if /i "%mmm%" EQU "Y" set IOS15v1031=*
if /i "%mmm%" EQU "Y" set IOS36=*
if /i "%mmm%" EQU "Y" set mmm=*
:skip4.3extra3



if /i "%H5%" EQU "Y" set cIOS202[57]-v5=*
if /i "%H5%" EQU "Y" set cIOS222[38]-v5=*
if /i "%H5%" EQU "Y" set cIOS223[37-38]-v4=*
if /i "%H5%" EQU "Y" set cIOS224[57]-v5=*
if /i "%H5%" EQU "Y" set cIOS249[57]-v19=*
if /i "%H5%" EQU "Y" set cIOS250[37]-v19=*
if /i "%H5%" EQU "Y" set RVL-cmios-v4_WiiGator_GCBL_v0.2=*
if /i "%H5%" EQU "Y" set M10=

if /i "%YAWM%" EQU "Y" set YAWM=*


if /i "%FIRMSTART%" EQU "4.3" goto:nopatching36
if /i "%mmm%" EQU "Y" set IOS15=*
if /i "%mmm%" EQU "Y" set IOS15v257=*
if /i "%mmm%" EQU "Y" set IOS36=*
if /i "%mmm%" EQU "Y" set mmm=*
:nopatching36

if /i "%pri%" NEQ "Y" goto:DOWNLOADQUEUE
set pri=*
set HAX=*

goto:DOWNLOADQUEUE




::...................................Download Queue...............................
:DOWNLOADQUEUE
::mode con cols=85 lines=%LINES%
set settings=

::Count how many downloads there are!
:DLCOUNT

SET DLTOTAL=0

if /i "%EULAU%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%EULAE%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%EULAJ%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%EULAK%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%RSU%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%RSE%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%RSJ%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%RSK%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%BC%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%bootmiisd%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1

if /i "%SM3.2U%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.1U%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.2U%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.3U%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM3.2E%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.1E%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.2E%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.3E%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM3.2J%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.1J%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.2J%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.3J%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.1K%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.2K%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SM4.3K%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS30%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS30P60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS40P60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS30P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS11P60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS20P60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS50P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS52P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS60P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS70%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS70P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS70K%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS80K%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS80%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS80P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%BB1%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%BB2%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%HM%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%h4%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%h5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%h51%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%CM5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%MP%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%w17%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%w19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%w20%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%TBR%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%loadmii%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%dop%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%AccioHacks%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%locked%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%HBB%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WII64%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WIISX%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%pwns%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%Twi%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%smash%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%mmm%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%yawm%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%neogamma%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cfg249%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cfg222%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cfgr%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%wbm%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%CheatCodes%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%f32%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%USBX%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%usbfolder%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WiiMC%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%fceugx%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%snes9xgx%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%vbagx%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SGM%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WIIX%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%Pri%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%HAX%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%MII%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%P%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%PK%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%S%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%SK%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IU%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IE%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IJ%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WU%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WE%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WJ%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%NU%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%NE%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%NJ%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WSU%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WSE%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%WSJ%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%M10%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS9%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS12%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS13%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS14%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS15v257%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS15v1031%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS15%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS17%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS21%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS22%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS28%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS31%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS33%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS34%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS35%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS36%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS36v3607%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS37%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS38%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS41%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS41v3091%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS43%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS45%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS46%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS53%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS55%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS56%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS57%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS202P57%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS58%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%IOS61%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A0e%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A01%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A0e_70%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A01_70%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A0e_60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A01_60%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A40%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A42%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A45%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A70%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A72%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A75%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A78%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A7b%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A7e%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A84%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A87%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%A8a%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS202[37]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS202[38]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS202[57]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS222[38]-v4%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS223[37-38]-v4%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS222[38]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS223[37]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS223[57]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS224[37]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS224[57]-v5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS249-v17b%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS249[37]-v19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS249[38]-v19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS249[57]-v19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS250-v17b%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS250[37]-v19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS250[38]-v19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%cIOS250[57]-v19%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" SET /a DLTOTAL=%DLTOTAL%+1

if /i "%MENU1%" EQU "S" goto:DLSETTINGS

SET /a LINES=%DLTOTAL%+20

if /i "%MENU1%" EQU "L" SET /a LINES=%LINES%+12

if %LINES% LEQ 54 goto:noresize
mode con cols=85 lines=%LINES%
:noresize

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
if /i "%MENU1%" EQU "H" echo                                  HackMii Solutions
if /i "%MENU1%" EQU "H" echo.


::-----------DL QUEUE SETTINGS---------
if /i "%MENU1%" NEQ "L" goto:skiploadDLcue

if /i "%ROOTSAVE%" EQU "%ROOTSAVETEMP%" set matchrs=Green
if /i "%ROOTSAVE%" NEQ "%ROOTSAVETEMP%" set matchrs=Red

if /i "%OPTION1%" EQU "%OPTION1TEMP%" set match1=Green
if /i "%OPTION1%" NEQ "%OPTION1TEMP%" set match1=Red

if /i "%SAVEZIP%" EQU "%SAVEZIPTEMP%" set matchZ=Green
if /i "%SAVEZIP%" NEQ "%SAVEZIPTEMP%" set matchZ=Red

echo.
echo                                 Download Queue Loaded
echo.
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 Queue Options appear [Red]Red [def]when they differ from
sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 \x20 your saved settings and [Green]Green [def]if they match
echo.
if /i "%ROOTSAVE%" EQU "ON" sfk echo -spat \x20 \x20 [%matchrs%]Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Enabled)
if /i "%ROOTSAVE%" EQU "OFF" sfk echo -spat \x20 \x20 [%matchrs%]Root Save: Save IOSs\MIOSs to Root instead of WAD Folder (Disabled)
echo               * Useful for Wii Apps that require IOSs\MIOSs saved to Root
echo.
if /i "%OPTION1%" EQU "OFF" sfk echo -spat \x20 \x20 [%match1%]Keep 00000001 Folder for IOSs\MIOSs\SMs etc. (Disabled)
if /i "%OPTION1%" EQU "ON" sfk echo -spat \x20 \x20 [%match1%]Keep 00000001 Folder for IOSs\MIOSs\SMs etc. (Enabled)
echo               * Useful for Wii Apps that require IOSs\MIOSs saved to 00000001 Folder
echo.
if /i "%SAVEZIP%" EQU "OFF" sfk echo -spat \x20 \x20 [%matchZ%]Save zip files after extraction (Disabled)
if /i "%SAVEZIP%" EQU "ON" sfk echo -spat \x20 \x20 [%matchZ%]Save zip files after extraction (Enabled)
echo.
echo.

:skiploadDLcue

if /i "%DLTOTAL%" EQU "0" echo      No files were marked for download
if /i "%DLTOTAL%" NEQ "0" echo      The following %DLTOTAL% files will be downloaded to "%DRIVE%":
echo.


if /i "%EULAU%" EQU "*" echo      * EULA v3 (USA)
if /i "%EULAE%" EQU "*" echo      * EULA v3 (PAL)
if /i "%EULAJ%" EQU "*" echo      * EULA v3 (JAP)
if /i "%EULAK%" EQU "*" echo      * EULA v3 (KOR)

if /i "%RSU%" EQU "*" echo      * Region Select v2 (USA)
if /i "%RSE%" EQU "*" echo      * Region Select v2 (PAL)
if /i "%RSJ%" EQU "*" echo      * Region Select v2 (JAP)
if /i "%RSK%" EQU "*" echo      * Region Select v2 (KOR)

if /i "%BC%" EQU "*" echo      * BC v6



if /i "%SM3.2U%" EQU "*" echo      * System Menu 3.2U
if /i "%SM4.1U%" EQU "*" echo      * System Menu 4.1U
if /i "%SM4.2U%" EQU "*" echo      * System Menu 4.2U
if /i "%SM4.3U%" EQU "*" echo      * System Menu 4.3U
if /i "%SM3.2E%" EQU "*" echo      * System Menu 3.2E
if /i "%SM4.1E%" EQU "*" echo      * System Menu 4.1E
if /i "%SM4.2E%" EQU "*" echo      * System Menu 4.2E
if /i "%SM4.3E%" EQU "*" echo      * System Menu 4.3E
if /i "%SM3.2J%" EQU "*" echo      * System Menu 3.2J
if /i "%SM4.1J%" EQU "*" echo      * System Menu 4.1J
if /i "%SM4.2J%" EQU "*" echo      * System Menu 4.2J
if /i "%SM4.3J%" EQU "*" echo      * System Menu 4.3J
if /i "%SM4.1K%" EQU "*" echo      * System Menu 4.1K
if /i "%SM4.2K%" EQU "*" echo      * System Menu 4.2K
if /i "%SM4.3K%" EQU "*" echo      * System Menu 4.3K

if /i "%IOS11P60%" EQU "*" echo      * IOS11v257(IOS60v6174[FS-ES-NP])
if /i "%IOS20P60%" EQU "*" echo      * IOS20v257(IOS60v6174[FS-ES-NP])
if /i "%IOS30%" EQU "*" echo      * IOS30v2576
if /i "%IOS30P%" EQU "*" echo      * IOS30v2817(IOS30v2576[FS-ES-NP])
if /i "%IOS30P60%" EQU "*" echo      * IOS30v2817(IOS60v6174[FS-ES-NP])
if /i "%IOS40P60%" EQU "*" echo      * IOS40v3073(IOS60v6174[FS-ES-NP])
if /i "%IOS50P%" EQU "*" echo      * IOS50v5121(IOS50v4889[FS-ES-NP])
if /i "%IOS52P%" EQU "*" echo      * IOS52v5889(IOS52v5661[FS-ES-NP])
if /i "%IOS60%" EQU "*" echo      * IOS60v6174
if /i "%IOS60P%" EQU "*" echo      * IOS60v6401(IOS60v6174[FS-ES-NP])
if /i "%IOS70%" EQU "*" echo      * IOS70v6687
if /i "%IOS70P%" EQU "*" echo      * IOS70v6913(IOS70v6687[FS-ES-NP])
if /i "%IOS70K%" EQU "*" echo      * IOS70v54321(IOS60v6174[FS-ES-NP])
if /i "%IOS80%" EQU "*" echo      * IOS80v6943
if /i "%IOS80P%" EQU "*" echo      * IOS80v6943[FS-ES-NP]
if /i "%IOS80K%" EQU "*" echo      * IOS80v54321(IOS60v6174[FS-ES-NP])

if /i "%cIOS202[37]-v5%" EQU "*" echo      * cIOS202[37]-v5
if /i "%cIOS202[38]-v5%" EQU "*" echo      * cIOS202[38]-v5
if /i "%cIOS202[57]-v5%" EQU "*" echo      * cIOS202[57]-v5
if /i "%cIOS222[38]-v4%" EQU "*" echo      * cIOS222[38]-v4
if /i "%cIOS223[37-38]-v4%" EQU "*" echo      * cIOS223[37-38]-v4
if /i "%cIOS222[38]-v5%" EQU "*" echo      * cIOS222[38]-v5
if /i "%cIOS223[37]-v5%" EQU "*" echo      * cIOS223[37]-v5
if /i "%cIOS223[57]-v5%" EQU "*" echo      * cIOS223[57]-v5
if /i "%cIOS224[37]-v5%" EQU "*" echo      * cIOS224[37]-v5
if /i "%cIOS224[57]-v5%" EQU "*" echo      * cIOS224[57]-v5
if /i "%cIOS249-v17b%" EQU "*" echo      * cIOS249-v17b
if /i "%cIOS249[37]-v19%" EQU "*" echo      * cIOS249[37]-v19
if /i "%cIOS249[38]-v19%" EQU "*" echo      * cIOS249[38]-v19
if /i "%cIOS249[57]-v19%" EQU "*" echo      * cIOS249[57]-v19
if /i "%cIOS250-v17b%" EQU "*" echo      * cIOS250-v17b
if /i "%cIOS250[37]-v19%" EQU "*" echo      * cIOS250[37]-v19
if /i "%cIOS250[38]-v19%" EQU "*" echo      * cIOS250[38]-v19
if /i "%cIOS250[57]-v19%" EQU "*" echo      * cIOS250[57]-v19
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" echo      * cMIOS-v4 WiiGator GCBL v0.2
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" echo      * cMIOS-v4 Waninkoko rev5
if /i "%BB1%" EQU "*" echo      * BannerBomb v1 (for 3.0 - 4.1 Wiis)
if /i "%BB2%" EQU "*" echo      * BannerBomb v2 (for 4.2 Wiis)
if /i "%pwns%" EQU "*" echo      * Indiana Pwns
if /i "%Twi%" EQU "*" echo      * Twilight Hack v0.1 Beta1 (for Wii's 3.3 and below)
if /i "%smash%" EQU "*" echo      * Smash Stack (USA)
if /i "%HM%" EQU "*" echo      * HackMii Installer
if /i "%bootmiisd%" EQU "*" echo      * BootMii SD Files
if /i "%h4%" EQU "*" echo      * Hermes cIOS v4 Installer
if /i "%h5%" EQU "*" echo      * Hermes cIOS v5 Installer
if /i "%h51%" EQU "*" echo      * Hermes cIOS v5.1 Installer
if /i "%CM5%" EQU "*" echo      * cMIOS rev5 Installer
if /i "%MP%" EQU "*" echo      * MIOS Patcher 0.2
if /i "%w17%" EQU "*" echo      * Waninkokos cIOS 38 v17 Installer
if /i "%w19%" EQU "*" echo      * Waninkokos cIOS X v19 Installer
if /i "%w20%" EQU "*" echo      * Waninkokos cIOS X v20b Installer
if /i "%TBR%" EQU "*" echo      * Trucha Bug Restorer v1.13
if /i "%loadmii%" EQU "*" echo      * LoadMii v0.3 Twilight
if /i "%dop%" EQU "*" echo      * DOP-Mii v13
if /i "%AccioHacks%" EQU "*" echo      * AccioHacks
if /i "%locked%" EQU "*" echo      * Locked Apps folder for the HBC (Pass=UDLRAB)
if /i "%HBB%" EQU "*" echo      * Homebrew Browser
if /i "%WII64%" EQU "*" echo      * Wii64 (Nintendo 64 Emulator)
if /i "%WIISX%" EQU "*" echo      * WiiSX (PlayStation 1 Emulator)
if /i "%mmm%" EQU "*" echo      * Multi-Mod Manager (MMM)
if /i "%yawm%" EQU "*" echo      * Yet Another Wad Manager Mod
if /i "%neogamma%" EQU "*" echo      * Neogamma Backup Disc Loader (most recent release)
if /i "%cfg249%" EQU "*" echo      * Configurable USB Loader (most recent 249 version)
if /i "%cfg222%" EQU "*" echo      * Configurable USB Loader (most recent 222 version)
if /i "%usbfolder%" EQU "*" echo      * USB-Loader Folder for Configurable USB Loader (most recent version)
if /i "%cfgr%" EQU "*" echo      * Configurator for Configurable USB Loader (most recent version)
if /i "%CheatCodes%" EQU "*" echo      * %cheatregion% Region Cheat Codes: txtcodes from geckocodes.org
if /i "%wbm%" EQU "*" echo      * Wii Backup Manager v0.3.5 beta1
if /i "%f32%" EQU "*" echo      * FAT32 GUI Formatter
if /i "%USBX%" EQU "*" echo      * USB-Loader Forwarder Channel
if /i "%Pri%" EQU "*" echo      * Priiloader
if /i "%HAX%" EQU "*" echo      * Priiloader Hacks.ini
if /i "%WiiMC%" EQU "*" echo      * WiiMC (most recent version)
if /i "%fceugx%" EQU "*" echo      * FCEUGX NES Emulator (most recent version)
if /i "%snes9xgx%" EQU "*" echo      * SNES9xGX SNES Emulator (most recent version)
if /i "%vbagx%" EQU "*" echo      * VBAGX GB/GBA Emulator (most recent version)
if /i "%SGM%" EQU "*" echo      * SaveGame Manager GX (most recent version)
if /i "%WIIX%" EQU "*" echo      * WiiXplorer (most recent version)
if /i "%MII%" EQU "*" echo      * Mii Channel (Region Free)
if /i "%P%" EQU "*" echo      * Photo 1.1 (USA/PAL/JAP)
if /i "%PK%" EQU "*" echo      * Photo 1.1 (KOR)
if /i "%S%" EQU "*" echo      * Shopping (USA/PAL/JAP)
if /i "%SK%" EQU "*" echo      * Shopping (KOR)
if /i "%IU%" EQU "*" echo      * Internet (USA)
if /i "%IE%" EQU "*" echo      * Internet (PAL)
if /i "%IJ%" EQU "*" echo      * Internet (JAP)
if /i "%WU%" EQU "*" echo      * Weather (USA)
if /i "%WE%" EQU "*" echo      * Weather (PAL)
if /i "%WJ%" EQU "*" echo      * Weather (JAP)
if /i "%NU%" EQU "*" echo      * News (USA)
if /i "%NE%" EQU "*" echo      * News (PAL)
if /i "%NJ%" EQU "*" echo      * News (JAP)
if /i "%WSU%" EQU "*" echo      * Wii Speak (USA)
if /i "%WSE%" EQU "*" echo      * Wii Speak (PAL)
if /i "%WSJ%" EQU "*" echo      * Wii Speak (JAP)

if /i "%M10%" EQU "*" echo      * MIOS v10
if /i "%IOS9%" EQU "*" echo      * IOS9v1034
if /i "%IOS12%" EQU "*" echo      * IOS12v525
if /i "%IOS13%" EQU "*" echo      * IOS13v1031
if /i "%IOS14%" EQU "*" echo      * IOS14v1031
if /i "%IOS15v257%" EQU "*" echo      * IOS15v257
if /i "%IOS15%" EQU "*" echo      * IOS15v523
if /i "%IOS15v1031%" EQU "*" echo      * IOS15v1031
if /i "%IOS17%" EQU "*" echo      * IOS17v1031
if /i "%IOS21%" EQU "*" echo      * IOS21v1038
if /i "%IOS22%" EQU "*" echo      * IOS22v1293
if /i "%IOS28%" EQU "*" echo      * IOS28v1806
if /i "%IOS31%" EQU "*" echo      * IOS31v3607
if /i "%IOS33%" EQU "*" echo      * IOS33v3607
if /i "%IOS34%" EQU "*" echo      * IOS34v3607
if /i "%IOS35%" EQU "*" echo      * IOS35v3607


if /i "%IOS36%" EQU "*" echo      * IOS36v3351

if /i "%IOS36v3607%" EQU "*" echo      * IOS36v3607
if /i "%IOS37%" EQU "*" echo      * IOS37v5662
if /i "%IOS38%" EQU "*" echo      * IOS38v4123

if /i "%IOS41%" EQU "*" echo      * IOS41v3348
if /i "%IOS41v3091%" EQU "*" echo      * IOS41v3091
if /i "%IOS43%" EQU "*" echo      * IOS43v3348
if /i "%IOS45%" EQU "*" echo      * IOS45v3348
if /i "%IOS46%" EQU "*" echo      * IOS46v3350
if /i "%IOS53%" EQU "*" echo      * IOS53v5662
if /i "%IOS55%" EQU "*" echo      * IOS55v5662
if /i "%IOS56%" EQU "*" echo      * IOS56v5661
if /i "%IOS57%" EQU "*" echo      * IOS57v5918
if /i "%IOS58%" EQU "*" echo      * IOS58v6175
if /i "%IOS61%" EQU "*" echo      * IOS61v5661
if /i "%IOS202P57%" EQU "*" echo      * IOS202v65535(IOS57v5918[FS-ES-NP])

if /i "%A0e%" EQU "*" echo      * 0000000e.app from IOS80 v6943 (SNEEK)
if /i "%A01%" EQU "*" echo      * 00000001.app from IOS80 v6943 (SNEEK)
if /i "%A0e_70%" EQU "*" echo      * 0000000e.app from IOS70 v6687 (SNEEK)
if /i "%A01_70%" EQU "*" echo      * 00000001.app from IOS70 v6687 (SNEEK)
if /i "%A0e_60%" EQU "*" echo      * 0000000e.app from IOS60 v6174 (SNEEK)
if /i "%A01_60%" EQU "*" echo      * 00000001.app from IOS60 v6174 (SNEEK)
if /i "%A40%" EQU "*" echo      * 00000040.app System Menu 3.2J (for Mymenuify)
if /i "%A42%" EQU "*" echo      * 00000042.app System Menu 3.2U (for Mymenuify)
if /i "%A45%" EQU "*" echo      * 00000045.app System Menu 3.2E (for Mymenuify)
if /i "%A70%" EQU "*" echo      * 00000070.app System Menu 4.0J (for Mymenuify)
if /i "%A72%" EQU "*" echo      * 00000072.app System Menu 4.0U (for Mymenuify)
if /i "%A75%" EQU "*" echo      * 00000075.app System Menu 4.0E (for Mymenuify)
if /i "%A78%" EQU "*" echo      * 00000078.app System Menu 4.1J (for Mymenuify)
if /i "%A7b%" EQU "*" echo      * 0000007b.app System Menu 4.1U (for Mymenuify)
if /i "%A7e%" EQU "*" echo      * 0000007e.app System Menu 4.1E (for Mymenuify)
if /i "%A84%" EQU "*" echo      * 00000084.app System Menu 4.2J (for Mymenuify)
if /i "%A87%" EQU "*" echo      * 00000087.app System Menu 4.2U (for Mymenuify)
if /i "%A8a%" EQU "*" echo      * 0000008a.app System Menu 4.2E (for Mymenuify)







echo.

echo      Begin Downloading now?
echo.
if /i "%DLTOTAL%" EQU "0" goto:zerodownloads
if /i "%MENU1%" EQU "W" goto:WorUSB
if /i "%MENU1%" EQU "U" goto:WorUSB

echo           Y = Yes, Begin Downloading

:WorUSB
if /i "%MENU1%" EQU "W" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "W" echo           G = Generate Guide Only
if /i "%MENU1%" EQU "U" echo           Y = Yes, Generate Guide and Begin Downloading
if /i "%MENU1%" EQU "U" echo           G = Generate Guide Only


:zerodownloads

if /i "%MENU1%" EQU "1" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "2" echo           A = Add more files to batch download list
if /i "%MENU1%" EQU "3" echo           A = Add more files to batch download list
echo.

if /i "%MENU1%" EQU "L" goto:NoNewDownloads
If not Exist download_queue.bat echo           S = Save Download Queue
If Exist download_queue.bat echo           S  = Save Download Queue (existing Download Queue will be renamed)
If Exist download_queue.bat echo           S+ = Save Download Queue+ (add above files to existing Download Queue)
echo.
:NoNewDownloads

echo           B = Back
echo           M = Main Menu
echo.
set /p SETTINGS=     Enter Selection Here: 



if /i "%SETTINGS%" EQU "Y" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "Y" set lines=54
if /i "%SETTINGS%" EQU "B" goto:%BACKB4QUEUE%
if /i "%SETTINGS%" EQU "M" goto:MENU


if /i "%MENU1%" EQU "L" goto:noexistingqueue
if /i "%SETTINGS%" EQU "S" goto:SaveDownloadQueue

If not Exist download_queue.bat goto:noexistingqueue
if /i "%SETTINGS%" EQU "S+" goto:SaveDownloadQueue
:noexistingqueue



if /i "%MENU1%" NEQ "1" goto:notbatch
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:LIST
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" goto:DLSETTINGS
:notbatch

if /i "%MENU1%" NEQ "2" goto:notoldbatch
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:OLDLIST
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" goto:DLSETTINGS
:notoldbatch

if /i "%MENU1%" NEQ "3" goto:NotBatchApp
if /i "%SETTINGS%" EQU "A" mode con cols=85 lines=54
if /i "%SETTINGS%" EQU "A" set lines=54
if /i "%SETTINGS%" EQU "A" goto:NUSGRABBER
if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" goto:DLSETTINGS
:NotBatchApp

if /i "%DLTOTAL%" EQU "0" goto:badkey
if /i "%SETTINGS%" EQU "Y" goto:COPY


if /i "%MENU1%" EQU "W" goto:generateguideonly
if /i "%MENU1%" EQU "U" goto:generateguideonly
goto:badkey

:generateguideonly
if /i "%SETTINGS%" EQU "G" goto:guide


:badkey
echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:DOWNLOADQUEUE
cls





:SaveDownloadQueue
cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.

if /i "%SETTINGS%" EQU "S+" goto:SaveDownloadQueue2
if /i "%FINISH%" EQU "S+" goto:SaveDownloadQueue2


:renameDownloadQueue
if not exist Download_Queue.bat goto:SaveDownloadQueue2
SET /a COUNT8=%COUNT8%+1
if exist Download_Queue%COUNT8%.bat goto:renameDownloadQueue
move Download_Queue.bat Download_Queue%count8%.bat

:SaveDownloadQueue2
echo.

echo ::NUS Auto Downloader - Download Queue - %DATE% - %TIME% >> Download_Queue.bat
echo ::Queue Settings>> Download_Queue.bat
echo Set ROOTSAVE=%ROOTSAVE%>> Download_Queue.bat
echo Set Option1=%Option1%>> Download_Queue.bat
echo Set SAVEZIP=%SAVEZIP%>> Download_Queue.bat

echo ::Queue>> Download_Queue.bat

::if /i "%MENU1%" EQU "W" echo SET VIRGIN=%VIRGIN%>> Download_Queue.bat
::if /i "%MENU1%" EQU "W" echo SET FIRMSTART=%FIRMSTART%>> Download_Queue.bat
::if /i "%MENU1%" EQU "W" echo SET REGION=%REGION%>> Download_Queue.bat
::if /i "%MENU1%" EQU "W" echo SET REGIONCHANGE=%REGIONCHANGE%>> Download_Queue.bat
::if /i "%MENU1%" EQU "W" echo SET FIRM=%FIRM%>> Download_Queue.bat

if /i "%EULAU%" EQU "*" echo SET EULAU=%EULAU%>> Download_Queue.bat
if /i "%EULAE%" EQU "*" echo SET EULAE=%EULAE%>> Download_Queue.bat
if /i "%EULAJ%" EQU "*" echo SET EULAJ=%EULAJ%>> Download_Queue.bat
if /i "%EULAK%" EQU "*" echo SET EULAK=%EULAK%>> Download_Queue.bat
if /i "%RSU%" EQU "*" echo SET RSU=%RSU%>> Download_Queue.bat
if /i "%RSE%" EQU "*" echo SET RSE=%RSE%>> Download_Queue.bat
if /i "%RSJ%" EQU "*" echo SET RSJ=%RSJ%>> Download_Queue.bat
if /i "%RSK%" EQU "*" echo SET RSK=%RSK%>> Download_Queue.bat
if /i "%BC%" EQU "*" echo SET BC=%BC%>> Download_Queue.bat

if /i "%SM3.2U%" EQU "*" echo SET SM3.2U=%SM3.2U%>> Download_Queue.bat
if /i "%SM4.1U%" EQU "*" echo SET SM4.1U=%SM4.1U%>> Download_Queue.bat
if /i "%SM4.2U%" EQU "*" echo SET SM4.2U=%SM4.2U%>> Download_Queue.bat
if /i "%SM4.3U%" EQU "*" echo SET SM4.3U=%SM4.3U%>> Download_Queue.bat
if /i "%SM3.2E%" EQU "*" echo SET SM3.2E=%SM3.2E%>> Download_Queue.bat
if /i "%SM4.1E%" EQU "*" echo SET SM4.1E=%SM4.1E%>> Download_Queue.bat
if /i "%SM4.2E%" EQU "*" echo SET SM4.2E=%SM4.2E%>> Download_Queue.bat
if /i "%SM4.3E%" EQU "*" echo SET SM4.3E=%SM4.3E%>> Download_Queue.bat
if /i "%SM3.2J%" EQU "*" echo SET SM3.2J=%SM3.2J%>> Download_Queue.bat
if /i "%SM4.1J%" EQU "*" echo SET SM4.1J=%SM4.1J%>> Download_Queue.bat
if /i "%SM4.2J%" EQU "*" echo SET SM4.2J=%SM4.2J%>> Download_Queue.bat
if /i "%SM4.3J%" EQU "*" echo SET SM4.3J=%SM4.3J%>> Download_Queue.bat
if /i "%SM4.1K%" EQU "*" echo SET SM4.1K=%SM4.1K%>> Download_Queue.bat
if /i "%SM4.2K%" EQU "*" echo SET SM4.2K=%SM4.2K%>> Download_Queue.bat
if /i "%SM4.3K%" EQU "*" echo SET SM4.3K=%SM4.3K%>> Download_Queue.bat
if /i "%IOS30%" EQU "*" echo SET IOS30=%IOS30%>> Download_Queue.bat
if /i "%IOS30P60%" EQU "*" echo SET IOS30P60=%IOS30P60%>> Download_Queue.bat
if /i "%IOS20P60%" EQU "*" echo SET IOS20P60=%IOS20P60%>> Download_Queue.bat
if /i "%IOS30P%" EQU "*" echo SET IOS30P=%IOS30P%>> Download_Queue.bat
if /i "%IOS11P60%" EQU "*" echo SET IOS11P60=%IOS11P60%>> Download_Queue.bat
if /i "%IOS20P60%" EQU "*" echo SET IOS20P60=%IOS20P60%>> Download_Queue.bat
if /i "%IOS50P%" EQU "*" echo SET IOS50P=%IOS50P%>> Download_Queue.bat
if /i "%IOS52P%" EQU "*" echo SET IOS52P=%IOS52P%>> Download_Queue.bat
if /i "%IOS60%" EQU "*" echo SET IOS60=%IOS60%>> Download_Queue.bat
if /i "%IOS60P%" EQU "*" echo SET IOS60P=%IOS60P%>> Download_Queue.bat
if /i "%IOS70%" EQU "*" echo SET IOS70=%IOS70%>> Download_Queue.bat
if /i "%IOS70P%" EQU "*" echo SET IOS70P=%IOS70P%>> Download_Queue.bat
if /i "%IOS70K%" EQU "*" echo SET IOS70K=%IOS70K%>> Download_Queue.bat
if /i "%IOS80%" EQU "*" echo SET IOS80=%IOS80%>> Download_Queue.bat
if /i "%IOS80P%" EQU "*" echo SET IOS80P=%IOS80P%>> Download_Queue.bat
if /i "%IOS80K%" EQU "*" echo SET IOS80K=%IOS80K%>> Download_Queue.bat
if /i "%BB1%" EQU "*" echo SET BB1=%BB1%>> Download_Queue.bat
if /i "%BB2%" EQU "*" echo SET BB2=%BB2%>> Download_Queue.bat
if /i "%HM%" EQU "*" echo SET HM=%HM%>> Download_Queue.bat
if /i "%h4%" EQU "*" echo SET h4=%h4%>> Download_Queue.bat
if /i "%h5%" EQU "*" echo SET h5=%h5%>> Download_Queue.bat
if /i "%h51%" EQU "*" echo SET h51=%h51%>> Download_Queue.bat
if /i "%CM5%" EQU "*" echo SET CM5=%CM5%>> Download_Queue.bat
if /i "%MP%" EQU "*" echo SET MP=%MP%>> Download_Queue.bat
if /i "%w17%" EQU "*" echo SET w17=%w17%>> Download_Queue.bat
if /i "%w19%" EQU "*" echo SET w19=%w19%>> Download_Queue.bat
if /i "%w20%" EQU "*" echo SET w20=%w20%>> Download_Queue.bat
if /i "%TBR%" EQU "*" echo SET TBR=%TBR%>> Download_Queue.bat
if /i "%loadmii%" EQU "*" echo SET loadmii=%loadmii%>> Download_Queue.bat
if /i "%dop%" EQU "*" echo SET dop=%dop%>> Download_Queue.bat
if /i "%AccioHacks%" EQU "*" echo SET AccioHacks=%AccioHacks%>> Download_Queue.bat
if /i "%locked%" EQU "*" echo SET locked=%locked%>> Download_Queue.bat
if /i "%HBB%" EQU "*" echo SET HBB=%HBB%>> Download_Queue.bat
if /i "%WII64%" EQU "*" echo SET WII64=%WII64%>> Download_Queue.bat
if /i "%WIISX%" EQU "*" echo SET WIISX=%WIISX%>> Download_Queue.bat
if /i "%bootmiisd%" EQU "*" echo SET bootmiisd=%bootmiisd%>> Download_Queue.bat
if /i "%pwns%" EQU "*" echo SET pwns=%pwns%>> Download_Queue.bat
if /i "%Twi%" EQU "*" echo SET Twi=%Twi%>> Download_Queue.bat
if /i "%smash%" EQU "*" echo SET smash=%smash%>> Download_Queue.bat
if /i "%mmm%" EQU "*" echo SET mmm=%mmm%>> Download_Queue.bat
if /i "%yawm%" EQU "*" echo SET yawm=%yawm%>> Download_Queue.bat
if /i "%neogamma%" EQU "*" echo SET neogamma=%neogamma%>> Download_Queue.bat
if /i "%cfg249%" EQU "*" echo SET cfg249=%cfg249%>> Download_Queue.bat
if /i "%cfg222%" EQU "*" echo SET cfg222=%cfg222%>> Download_Queue.bat
if /i "%usbfolder%" EQU "*" echo SET usbfolder=%usbfolder%>> Download_Queue.bat
if /i "%WiiMC%" EQU "*" echo SET WiiMC=%WiiMC%>> Download_Queue.bat
if /i "%fceugx%" EQU "*" echo SET fceugx=%fceugx%>> Download_Queue.bat
if /i "%snes9xgx%" EQU "*" echo SET snes9xgx=%snes9xgx%>> Download_Queue.bat
if /i "%vbagx%" EQU "*" echo SET vbagx=%vbagx%>> Download_Queue.bat
if /i "%SGM%" EQU "*" echo SET SGM=%SGM%>> Download_Queue.bat
if /i "%WIIX%" EQU "*" echo SET WIIX=%WIIX%>> Download_Queue.bat
if /i "%wbm%" EQU "*" echo SET wbm=%wbm%>> Download_Queue.bat
if /i "%CheatCodes%" EQU "*" echo SET CheatCodes=%CheatCodes%>> Download_Queue.bat
if /i "%f32%" EQU "*" echo SET f32=%f32%>> Download_Queue.bat
if /i "%USBX%" EQU "*" echo SET USBX=%USBX%>> Download_Queue.bat
if /i "%cfgr%" EQU "*" echo SET cfgr=%cfgr%>> Download_Queue.bat
if /i "%Pri%" EQU "*" echo SET Pri=%Pri%>> Download_Queue.bat
if /i "%HAX%" EQU "*" echo SET HAX=%HAX%>> Download_Queue.bat
if /i "%MII%" EQU "*" echo SET MII=%MII%>> Download_Queue.bat
if /i "%P%" EQU "*" echo SET P=%P%>> Download_Queue.bat
if /i "%PK%" EQU "*" echo SET PK=%PK%>> Download_Queue.bat
if /i "%S%" EQU "*" echo SET S=%S%>> Download_Queue.bat
if /i "%SK%" EQU "*" echo SET SK=%SK%>> Download_Queue.bat
if /i "%IU%" EQU "*" echo SET IU=%IU%>> Download_Queue.bat
if /i "%IE%" EQU "*" echo SET IE=%IE%>> Download_Queue.bat
if /i "%IJ%" EQU "*" echo SET IJ=%IJ%>> Download_Queue.bat
if /i "%WU%" EQU "*" echo SET WU=%WU%>> Download_Queue.bat
if /i "%WE%" EQU "*" echo SET WE=%WE%>> Download_Queue.bat
if /i "%WJ%" EQU "*" echo SET WJ=%WJ%>> Download_Queue.bat
if /i "%NU%" EQU "*" echo SET NU=%NU%>> Download_Queue.bat
if /i "%NE%" EQU "*" echo SET NE=%NE%>> Download_Queue.bat
if /i "%NJ%" EQU "*" echo SET NJ=%NJ%>> Download_Queue.bat
if /i "%WSU%" EQU "*" echo SET WSU=%WSU%>> Download_Queue.bat
if /i "%WSE%" EQU "*" echo SET WSE=%WSE%>> Download_Queue.bat
if /i "%WSJ%" EQU "*" echo SET WSJ=%WSJ%>> Download_Queue.bat
if /i "%M10%" EQU "*" echo SET M10=%M10%>> Download_Queue.bat
if /i "%IOS9%" EQU "*" echo SET IOS9=%IOS9%>> Download_Queue.bat
if /i "%IOS12%" EQU "*" echo SET IOS12=%IOS12%>> Download_Queue.bat
if /i "%IOS13%" EQU "*" echo SET IOS13=%IOS13%>> Download_Queue.bat
if /i "%IOS14%" EQU "*" echo SET IOS14=%IOS14%>> Download_Queue.bat
if /i "%IOS15v257%" EQU "*" echo SET IOS15v257=%IOS15v257%>> Download_Queue.bat
if /i "%IOS15v1031%" EQU "*" echo SET IOS15v1031=%IOS15v1031%>> Download_Queue.bat
if /i "%IOS15%" EQU "*" echo SET IOS15=%IOS15%>> Download_Queue.bat
if /i "%IOS17%" EQU "*" echo SET IOS17=%IOS17%>> Download_Queue.bat
if /i "%IOS21%" EQU "*" echo SET IOS21=%IOS21%>> Download_Queue.bat
if /i "%IOS22%" EQU "*" echo SET IOS22=%IOS22%>> Download_Queue.bat
if /i "%IOS28%" EQU "*" echo SET IOS28=%IOS28%>> Download_Queue.bat
if /i "%IOS31%" EQU "*" echo SET IOS31=%IOS31%>> Download_Queue.bat
if /i "%IOS33%" EQU "*" echo SET IOS33=%IOS33%>> Download_Queue.bat
if /i "%IOS34%" EQU "*" echo SET IOS34=%IOS34%>> Download_Queue.bat
if /i "%IOS35%" EQU "*" echo SET IOS35=%IOS35%>> Download_Queue.bat
if /i "%IOS36%" EQU "*" echo SET IOS36=%IOS36%>> Download_Queue.bat
if /i "%IOS36v3607%" EQU "*" echo SET IOS36v3607=%IOS36v3607%>> Download_Queue.bat
if /i "%IOS37%" EQU "*" echo SET IOS37=%IOS37%>> Download_Queue.bat
if /i "%IOS38%" EQU "*" echo SET IOS38=%IOS38%>> Download_Queue.bat
if /i "%IOS41%" EQU "*" echo SET IOS41=%IOS41%>> Download_Queue.bat
if /i "%IOS41v3091%" EQU "*" echo SET IOS41v3091=%IOS41v3091%>> Download_Queue.bat
if /i "%IOS43%" EQU "*" echo SET IOS43=%IOS43%>> Download_Queue.bat
if /i "%IOS45%" EQU "*" echo SET IOS45=%IOS45%>> Download_Queue.bat
if /i "%IOS46%" EQU "*" echo SET IOS46=%IOS46%>> Download_Queue.bat
if /i "%IOS53%" EQU "*" echo SET IOS53=%IOS53%>> Download_Queue.bat
if /i "%IOS55%" EQU "*" echo SET IOS55=%IOS55%>> Download_Queue.bat
if /i "%IOS56%" EQU "*" echo SET IOS56=%IOS56%>> Download_Queue.bat
if /i "%IOS57%" EQU "*" echo SET IOS57=%IOS57%>> Download_Queue.bat
if /i "%IOS202P57%" EQU "*" echo SET IOS202P57=%IOS202P57%>> Download_Queue.bat
if /i "%IOS58%" EQU "*" echo SET IOS58=%IOS58%>> Download_Queue.bat
if /i "%IOS61%" EQU "*" echo SET IOS61=%IOS61%>> Download_Queue.bat

if /i "%A0e%" EQU "*" echo SET A0e=%A0e%>> Download_Queue.bat
if /i "%A01%" EQU "*" echo SET A01=%A01%>> Download_Queue.bat

if /i "%A0e_70%" EQU "*" echo SET A0e_70=%A0e_70%>> Download_Queue.bat
if /i "%A01%" EQU "*" echo SET A01__60=%A01_60%>> Download_Queue.bat
if /i "%A0e_60%" EQU "*" echo SET A0e_60=%A0e_60%>> Download_Queue.bat
if /i "%A01%" EQU "*" echo SET A01=%A01%>> Download_Queue.bat

if /i "%A40%" EQU "*" echo SET A40=%A40%>> Download_Queue.bat
if /i "%A42%" EQU "*" echo SET A42=%A42%>> Download_Queue.bat
if /i "%A45%" EQU "*" echo SET A45=%A45%>> Download_Queue.bat
if /i "%A70%" EQU "*" echo SET A70=%A70%>> Download_Queue.bat
if /i "%A72%" EQU "*" echo SET A72=%A72%>> Download_Queue.bat
if /i "%A75%" EQU "*" echo SET A75=%A75%>> Download_Queue.bat
if /i "%A78%" EQU "*" echo SET A78=%A78%>> Download_Queue.bat
if /i "%A7b%" EQU "*" echo SET A7b=%A7b%>> Download_Queue.bat
if /i "%A7e%" EQU "*" echo SET A7e=%A7e%>> Download_Queue.bat
if /i "%A84%" EQU "*" echo SET A84=%A84%>> Download_Queue.bat
if /i "%A87%" EQU "*" echo SET A87=%A87%>> Download_Queue.bat
if /i "%A8a%" EQU "*" echo SET A8a=%A8a%>> Download_Queue.bat
if /i "%cIOS202[37]-v5%" EQU "*" echo SET cIOS202[37]-v5=%cIOS202[37]-v5%>> Download_Queue.bat
if /i "%cIOS202[38]-v5%" EQU "*" echo SET cIOS202[38]-v5=%cIOS202[38]-v5%>> Download_Queue.bat
if /i "%cIOS202[57]-v5%" EQU "*" echo SET cIOS202[57]-v5=%cIOS202[57]-v5%>> Download_Queue.bat
if /i "%cIOS222[38]-v4%" EQU "*" echo SET cIOS222[38]-v4=%cIOS222[38]-v4%>> Download_Queue.bat

if /i "%cIOS223[37-38]-v4%" EQU "*" echo SET cIOS223[37-38]-v4=%cIOS223[37-38]-v4%>> Download_Queue.bat

if /i "%cIOS222[38]-v5%" EQU "*" echo SET cIOS222[38]-v5=%cIOS222[38]-v5%>> Download_Queue.bat
if /i "%cIOS223[37]-v5%" EQU "*" echo SET cIOS223[37]-v5=%cIOS223[37]-v5%>> Download_Queue.bat
if /i "%cIOS223[57]-v5%" EQU "*" echo SET cIOS223[57]-v5=%cIOS223[57]-v5%>> Download_Queue.bat
if /i "%cIOS224[37]-v5%" EQU "*" echo SET cIOS224[37]-v5=%cIOS224[37]-v5%>> Download_Queue.bat
if /i "%cIOS224[57]-v5%" EQU "*" echo SET cIOS224[57]-v5=%cIOS224[57]-v5%>> Download_Queue.bat
if /i "%cIOS249-v17b%" EQU "*" echo SET cIOS249-v17b=%cIOS249-v17b%>> Download_Queue.bat
if /i "%cIOS249[37]-v19%" EQU "*" echo SET cIOS249[37]-v19=%cIOS249[37]-v19%>> Download_Queue.bat
if /i "%cIOS249[38]-v19%" EQU "*" echo SET cIOS249[38]-v19=%cIOS249[38]-v19%>> Download_Queue.bat
if /i "%cIOS249[57]-v19%" EQU "*" echo SET cIOS249[57]-v19=%cIOS249[57]-v19%>> Download_Queue.bat
if /i "%cIOS250-v17b%" EQU "*" echo SET cIOS250-v17b=%cIOS250-v17b%>> Download_Queue.bat
if /i "%cIOS250[37]-v19%" EQU "*" echo SET cIOS250[37]-v19=%cIOS250[37]-v19%>> Download_Queue.bat
if /i "%cIOS250[38]-v19%" EQU "*" echo SET cIOS250[38]-v19=%cIOS250[38]-v19%>> Download_Queue.bat
if /i "%cIOS250[57]-v19%" EQU "*" echo SET cIOS250[57]-v19=%cIOS250[57]-v19%>> Download_Queue.bat
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" echo SET RVL-cmios-v4_WiiGator_GCBL_v0.2=%RVL-cmios-v4_WiiGator_GCBL_v0.2%>> Download_Queue.bat
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" echo SET RVL-cmios-v4_Waninkoko_rev5=%RVL-cmios-v4_Waninkoko_rev5%>> Download_Queue.bat
sfk filter Download_Queue.bat -unique -write -yes>nul

if exist Download_Queue.bat echo                                  Download Queue Saved.
@ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%LIST%" EQU "S" goto:LIST
if /i "%SETTINGS%" EQU "S" goto:DOWNLOADQUEUE
if /i "%SETTINGS%" EQU "S+" goto:DOWNLOADQUEUE
if /i "%FINISH%" EQU "S" goto:FINISH
if /i "%FINISH%" EQU "S+" goto:FINISH






::...................................Copy (rename %Drive%\wad if applicable)...............................
:COPY
if not exist "%Drive%"\WAD goto:DLSettings
if /i "%USBCONFIG%" EQU "USB" goto:DLSettings
::if /i "%DRIVE%" NEQ "COPY_TO_SD" goto:DLSettings

Set COPY=

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo      %Drive%\WAD Folder already exists, what would you like to do?
echo.
echo           M = Merge downloads with existing %Drive%\WAD Folder.
echo               Duplicates will be skipped.
echo.
echo           R = Rename the existing %Drive%\WAD Folder to %Drive%\WAD#
echo               and begin downloading.
echo.
echo           C = Cancel/Main Menu
echo.
echo           E = Exit
echo.
set /p COPY=     Enter Selection Here: 

if /i "%COPY%" EQU "M" goto:DLSettings
if /i "%COPY%" EQU "E" EXIT
if /i "%COPY%" EQU "C" goto:MENU

if /i "%COPY%" NEQ "R" echo You Have Entered an Incorrect Key
if /i "%COPY%" NEQ "R" @ping 127.0.0.1 -n 2 -w 1000> nul
if /i "%COPY%" NEQ "R" goto:COPY

:COPY2
SET /a COUNT=%COUNT%+1
if exist "%Drive%"\WAD%COUNT% goto:COPY2
move "%Drive%"\WAD "%Drive%"\WAD%COUNT%
::rename "%Drive%"\WAD WAD%COUNT%
if /i "%LIST%" EQU "R" goto:LIST
if /i "%OLDLIST%" EQU "R" goto:OLDLIST
if /i "%GRABBER%" EQU "R" goto:NUSGRABBER
goto:DLSETTINGS


::.................................................ACTUAL DOWNLOAD CODE...........................................................................
:DOWNLOADSTART
if /i "%loadorgo%" EQU "load" goto:NEXT
set retry=1
set attempt=1
:DOWNLOADSTART2

::if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
if not exist "%Drive%" mkdir "%Drive%"

:actualDL
if /i "%on%" NEQ "*" goto:NEXT
if /i "%retry%" EQU "1" SET /a CURRENTDL=%CURRENTDL%+1
::::if exist "%Drive%"\WAD\%wadname% goto:NEXT

if /i "%CURRENTDL%" NEQ "1" echo.
if /i "%retry%" EQU "1" sfk echo [Red]Downloading %CURRENTDL% of %DLTOTAL%: %name%
if /i "%retry%" NEQ "1" sfk echo [Yellow]Re-Downloading %CURRENTDL% of %DLTOTAL%: %name%
::echo Downloading %CURRENTDL% of %DLTOTAL%: %name%
echo.

::---------Exceptions----------------

if /i "%category%" EQU "cfg" goto:CFGDOWNLOADER
if /i "%category%" EQU "cfgr" goto:CFGRDOWNLOADER
if /i "%category%" EQU "EXE" goto:EXEDOWNLOADER
if /i "%category%" EQU "CWAD" goto:nusd
if /i "%category%" EQU "TANTRIC" goto:TANTRIC
if /i "%category%" EQU "GOOGLEUPDATE" goto:GOOGLEUPDATE
if /i "%category%" EQU "CHEATS" goto:CHEATS
if /i "%category%" EQU "ManualUpdate" goto:MANUALUPDATE

if /i "%basewad%" NEQ "none" goto:CIOSMAKER


if /i "%wadname%" EQU "BB1.zip" goto:renameprivate
if /i "%wadname%" EQU "BB2.zip" goto:renameprivate

if /i "%name%" EQU "Hackmii Installer" goto:wget

if /i "%category%" EQU "fullextract" goto:fullextract

if /i "%wadname%" EQU "PriiloaderHacks.zip" goto:DownloadhacksToRoot






::-----------IOS/MIOS Exceptions for DL Wizard Only----------

if /i "%MENU1%" NEQ "W" goto:skipwizardexceptions


if /i "%name%" EQU "IOS15 v257" goto:savetoroot
if /i "%name%" EQU "IOS15" goto:savetoroot

::Save IOS15v1031 to Root (and WAD Folder)--if not on 4.3 only save to wad folder
if /i "%firmstart%" NEQ "4.3" goto:savetowadonly
if /i "%wadname%" EQU "IOS15-64-v1031.wad" goto:savetoroot
:savetowadonly

if /i "%name%" EQU "IOS36" goto:savetoroot

:skipwizardexceptions
::----------------------------


::-----ROOT SAVE OPTION for IOSs (does not apply to wizard)-----
if /i "%MENU1%" EQU "W" goto:skip
if /i "%category%" EQU "ios" goto:noskip
if /i "%category%" EQU "patchios" goto:noskip
goto:skip
:noskip
if /i "%ROOTSAVE%" EQU "ON" goto:savetoroot
:skip


if /i "%code1%" EQU "APP" goto:DownloadApp
if /i "%code1%" EQU "URL" goto:DownloadURL



::--------------------------NUSD.EXE Downloader---------------
:nusd
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
:checkifwadexist
if exist "%Drive%"\WAD\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting
if /i "%category%" EQU "CWAD" goto:CWAD

::--skip downloading IOS60 as base if it already exists--
if /i "%category%" NEQ "patchios" goto:notpatchingIOS60
if /i "%code2%" NEQ "0000003C" goto:notpatchingIOS60

if exist "%Drive%"\WAD\IOS60v6401(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS60v6401(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
if exist "%Drive%"\WAD\IOS20v257(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS20v257(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
if exist "%Drive%"\WAD\IOS30v2817(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS30v2817(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
if exist "%Drive%"\WAD\IOS70v54321(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS70v54321(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
if exist "%Drive%"\WAD\IOS80v54321(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS80v54321(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
if exist "%Drive%"\WAD\IOS11v257(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS11v257(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
if exist "%Drive%"\WAD\IOS40v3073(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\WAD\IOS40v3073(IOS60v6174[FS-ES-NP]).wad "%Drive%"\WAD\%wadname%
if exist "%Drive%"\WAD\%wadname% goto:patchios60now
goto:notpatchingIOS60


:patchios60now
patchios "%Drive%"\WAD\%wadname% -slot %ciosslot% -v %ciosversion%
::echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5
goto:wadverifyretry

::SAVE TO WAD FOLDER ONLY
:notpatchingIOS60
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
nusd %code1%%code2% %version%
move %code1%%code2%\%code1%%code2%.wad "%Drive%"\WAD\%wadname%


if /i "%OPTION1%" EQU "ON" mkdir "%Drive%"\%code1%\%code2%\v%version%
if /i "%OPTION1%" EQU "ON" copy %code1%%code2% "%Drive%"\%code1%\%code2%\v%version% >nul

rd /s /q %code1%%code2%

::Patchios (mostly for system menu IOSs)
if /i "%category%" NEQ "patchios" goto:skippingpatchios

patchios "%Drive%"\WAD\%wadname% -FS -ES -NP -slot %ciosslot% -v %ciosversion%
:skippingpatchios

:wadverifyretry
::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\WAD\%wadname% goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname% goto:DOWNLOADSTART2
goto:NEXT
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT



:savetoroot
if not exist "%Drive%" mkdir "%Drive%"
echo %md5% *%wadname%>> "%Drive%"\Download_Log.md5
::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\%wadname%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting







::--skip downloading IOS60 as base if it already exists--
if /i "%category%" NEQ "patchios" goto:notpatchingIOS60
if /i "%code2%" NEQ "0000003C" goto:notpatchingIOS60

if exist "%Drive%"\IOS60v6401(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS60v6401(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
if exist "%Drive%"\IOS20v257(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS20v257(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
if exist "%Drive%"\IOS30v2817(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS30v2817(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
if exist "%Drive%"\IOS70v54321(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS70v54321(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
if exist "%Drive%"\IOS80v54321(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS80v54321(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
if exist "%Drive%"\IOS11v257(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS11v257(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
if exist "%Drive%"\IOS40v3073(IOS60v6174[FS-ES-NP]).wad copy "%Drive%"\IOS40v3073(IOS60v6174[FS-ES-NP]).wad "%Drive%"\%wadname%
if exist "%Drive%"\%wadname% goto:patchios60now
goto:notpatchingIOS60


:patchios60now
patchios "%Drive%"\%wadname% -slot %ciosslot% -v %ciosversion%
::echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5
goto:checkretryroot

::SAVE TO ROOT FOLDER ONLY
:notpatchingIOS60




nusd %code1%%code2% %version%
move %code1%%code2%\%code1%%code2%.wad "%Drive%"\%wadname%
::Also IOS15v1031 to WAD Folder (for wizard only)
if /i "%MENU1%" NEQ "W" goto:skip
if /i "%wadname%" EQU "IOS15-64-v1031.wad" copy /y "%Drive%"\%wadname% "%Drive%"\WAD\%wadname%
:skip


if /i "%OPTION1%" EQU "ON" mkdir "%Drive%"\%code1%\%code2%\v%version%
if /i "%OPTION1%" EQU "ON" copy %code1%%code2% "%Drive%"\%code1%\%code2%\v%version% >nul
rd /s /q %code1%%code2%

::Patchios (mostly for system menu IOSs)
if /i "%category%" NEQ "patchios" goto:skippingpatchios
patchios "%Drive%"\%wadname% -FS -ES -NP -slot %ciosslot% -v %ciosversion%
:skippingpatchios

goto:checkretryroot




::Forced save to root, wad and 00000001 folders (not restricted by options)
:savetowadroot01
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5
echo %md5% *%wadname%>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\WAD\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
copy /Y "%Drive%"\WAD\%wadname% "%Drive%"\%wadname%> nul
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

nusd %code1%%code2% %version%
move /Y %code1%%code2%\%code1%%code2%.wad "%Drive%"\%wadname%
copy "%Drive%"\%wadname% "%Drive%"\WAD\%wadname% >nul
mkdir "%Drive%"\%code1%\%code2%\v%version%
copy %code1%%code2% "%Drive%"\%code1%\%code2%\v%version% >nul
rd /s /q %code1%%code2%
goto:wadverifyretry
::DONE, goes to next (or retries)


::Forced save to root and 00000001 folders (not restricted by options)
:savetoroot01
if not exist "%Drive%" mkdir "%Drive%"
echo %md5% *%wadname%>> "%Drive%"\Download_Log.md5


::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\%wadname%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

nusd %code1%%code2% %version%
move /Y %code1%%code2%\%code1%%code2%.wad "%Drive%"\%wadname%
::copy "%Drive%"\%wadname% "%Drive%"\WAD\%wadname% >nul
mkdir "%Drive%"\%code1%\%code2%\v%version%
copy %code1%%code2% "%Drive%"\%code1%\%code2%\v%version% >nul
rd /s /q %code1%%code2%
::echo %md5% *%wadname%>> "%Drive%"\Download_Log.md5

:checkretryroot
::----check after downloading - if md5 check fails, delete and redownload----

if exist "%Drive%"\%wadname% goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%"\%wadname%
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\%wadname%
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\%wadname% goto:DOWNLOADSTART2
goto:NEXT
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT


::----NO LONGER USED----
::Forced save 00000001 folders ONLY (no WADS! old IOS37v3612 and IOS38v3610 for Hermes v4)
:save01only
echo %md5% *%code1%\%code2%\v%version%\cetk>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
If exist "%Drive%"\%code1%\%code2%\v%version%\cetk goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\%code1%\%code2%\v%version%\cetk
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%"\%code1%\%code2%\v%version%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist ""%Drive%"\%code1%\%code2%\v%version%\cetk goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

nusd %code1%%code2% %version%
del %code1%%code2%\%code1%%code2%.wad
mkdir "%Drive%"\%code1%\%code2%\v%version%
copy %code1%%code2% "%Drive%"\%code1%\%code2%\v%version% >nul
rd /s /q %code1%%code2%
::echo %md5% *%code1%\%code2%\v%version%\cetk>> "%Drive%"\Download_Log.md5
goto:NEXT


::Forced save to WAD and 00000001 folders (and patch SM IOS) this is for IOS60 and H4 Installer
:savetoWAD01
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\WAD\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

nusd %code1%%code2% %version%
move %code1%%code2%\%code1%%code2%.wad "%Drive%"\WAD\%wadname%
mkdir "%Drive%"\%code1%\%code2%\v%version%
copy %code1%%code2% "%Drive%"\%code1%\%code2%\v%version% >nul
rd /s /q %code1%%code2%
if /i "%category%" EQU "patchios" patchios "%Drive%"\WAD\%wadname% -FS -ES -NP -slot %ciosslot% -v %ciosversion%
::echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5
goto:wadverifyretry



::-------------------------------cIOS Maker-----------------------------------------------------
:CIOSMAKER

echo %md5% *WAD\%wadname%.wad>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\WAD\%wadname%.wad goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%.wad
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%.wad
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname%.wad goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting


::missing modules folder error message and skip
if not exist modules sfk echo -spat [Yellow] Missing "modules" folder - Required to make cIOSs/cMIOSs
if not exist modules sfk echo -spat \x20 \x20 [Yellow] Redownload NUS Auto Downloader from tinyurl.com/NusAuto
if not exist modules sfk echo -spat \x20 \x20 [Yellow] Skipping download
if not exist modules @ping 127.0.0.1 -n 5 -w 1000> nul
if not exist modules goto:NEXT


if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD


::download base wad to "%Drive%"
echo.
echo Downloading Base Wad: %basewad%
echo.




::----Check base IOS-----------
::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\%basewad%.wad goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5base% "%Drive%"\%basewad%.wad
if errorlevel 1 echo This base wad already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\%basewad%.wad
SET retry=2
if not exist "%Drive%"\%basewad%.wad goto:DOWNLOADSTART2
sfk echo -spat \x20 \x20 \x20 [Green] Base Wad already exists and has been verified, Continuing...
goto:basealreadythere
:nocheckexisting


nusd %code1%%code2% %version%
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
move %code1%%code2%\%code1%%code2%.wad "%Drive%"\%basewad%.wad
rd /s /q %code1%%code2%

:basealreadythere

::unpack base wad
echo.
echo Unpacking Base Wad: %basewad%
echo.

mkdir %basecios%
wadmii -in "%Drive%"\%basewad%.wad -out %basecios%






if /i "%basewadb%" EQU "none" goto:nobasewadb

::download SECOND base wadB to "%Drive%" (if applicable)

echo.
echo Downloading Base Wad: %basewadb%
echo.


::----Check base IOS B-----------
::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\%basewadb%.wad goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5baseb% "%Drive%"\%basewadb%.wad
if errorlevel 1 echo This base wad already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\%basewadb%.wad
SET retry=2
if not exist "%Drive%"\%basewadb%.wad goto:DOWNLOADSTART2
sfk echo -spat \x20 \x20 \x20 [Green] Base Wad already exists and has been verified, Continuing...
goto:baseBalreadythere
:nocheckexisting


nusd %code1b%%code2b% %versionb%
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
move %code1b%%code2b%\%code1b%%code2b%.wad "%Drive%"\%basewadb%.wad
rd /s /q %code1b%%code2b%

:baseBalreadythere

::----unpack base wad
echo.
echo Unpacking Base Wad: %basewadb%
echo.

mkdir %basewadb%
wadmii -in "%Drive%"\%basewadb%.wad -out %basewadb%

::----specific for cios223v4[37+38]

::delete IOS37 modules that are from 38 and patched
del %basecios%\00000001.app
del %basecios%\%lastbasemodule%.app

move %basewadb%\00000001.app %basecios%\00000001.app
move %basewadb%\%lastbasemodule%.app %basecios%\%lastbasemodule%.app
rd /s /q %basewadb%


:nobasewadb







::rename *.cert and *.footer (doesn't need to be patched), rename components that need to be patched (excluding tik and tmd)

echo.
echo Patching A handful of BaseWad Component Files
echo.

ren %basecios%\%code1%%code2%.cert %code1%%code2new%.cert
ren %basecios%\%code1%%code2%.footer %code1%%code2new%.footer

if exist modules\Diffs\%basecios%\%basecios%_00.diff ren %basecios%\00000000.app 00000000-original.app
if exist modules\Diffs\%basecios%\%basecios%_01.diff ren %basecios%\00000001.app 00000001-original.app
if exist modules\Diffs\%basecios%\%basecios%_%lastbasemodule%.diff ren %basecios%\%lastbasemodule%.app %lastbasemodule%-original.app

::rename tik & tmd for cMIOSs
if /i "%code2%" NEQ "00000101" goto:notcMIOS

if exist modules\Diffs\%basecios%\%basecios%_tik.diff ren %basecios%\%code1%%code2new%.tik %code1%%code2new%-original.tik
if exist modules\Diffs\%basecios%\%basecios%_tmd.diff ren %basecios%\%code1%%code2new%.tmd %code1%%code2new%-original.tmd
:notcMIOS





::-------------diff patch files----------------
if exist modules\Diffs\%basecios%\%basecios%_00.diff jptch %basecios%\00000000-original.app modules\Diffs\%basecios%\%basecios%_00.diff %basecios%\00000000.app
if exist modules\Diffs\%basecios%\%basecios%_01.diff jptch %basecios%\00000001-original.app modules\Diffs\%basecios%\%basecios%_01.diff %basecios%\00000001.app
if exist modules\Diffs\%basecios%\%basecios%_%lastbasemodule%.diff jptch %basecios%\%lastbasemodule%-original.app modules\Diffs\%basecios%\%basecios%_%lastbasemodule%.diff %basecios%\%lastbasemodule%.app


::patch tmd and tiks when they've been renamed to *-original.tik\tmd (for cMIOSs)
if /i "%code2%" NEQ "00000101" goto:NotRenamedOriginal
if exist modules\Diffs\%basecios%\%basecios%_tik.diff jptch %basecios%\%code1%%code2%-original.tik modules\Diffs\%basecios%\%basecios%_tik.diff %basecios%\%code1%%code2new%.tik
if exist modules\Diffs\%basecios%\%basecios%_tmd.diff jptch %basecios%\%code1%%code2%-original.tmd modules\Diffs\%basecios%\%basecios%_tmd.diff %basecios%\%code1%%code2new%.tmd
goto:deletefiles

:NotRenamedOriginal
if exist modules\Diffs\%basecios%\%basecios%_tik.diff jptch %basecios%\%code1%%code2%.tik modules\Diffs\%basecios%\%basecios%_tik.diff %basecios%\%code1%%code2new%.tik
if exist modules\Diffs\%basecios%\%basecios%_tmd.diff jptch %basecios%\%code1%%code2%.tmd modules\Diffs\%basecios%\%basecios%_tmd.diff %basecios%\%code1%%code2new%.tmd




::delete un-needed original files that have already been patched
:deletefiles

if exist %basecios%\00000000-original.app del %basecios%\00000000-original.app
if exist %basecios%\00000001-original.app del %basecios%\00000001-original.app
if exist %basecios%\%lastbasemodule%-original.app del %basecios%\%lastbasemodule%-original.app

::--for cMIOS's that have tiks and tmds renamed to -original
if exist %basecios%\%code1%%code2%-original.tik del %basecios%\%code1%%code2%-original.tik
if exist %basecios%\%code1%%code2%-original.tmd del %basecios%\%code1%%code2%-original.tmd
if /i "%code2%" EQU "00000101" goto:repackwad

if exist %basecios%\%code1%%code2%.tik del %basecios%\%code1%%code2%.tik
if exist %basecios%\%code1%%code2%.tmd del %basecios%\%code1%%code2%.tmd




::copy over extra components

echo.
echo Copying over Custom Modules
echo.

::222v4
if /i "%basecios%" EQU "cIOS222[38]-v4" copy modules\Hermes\mloadv3.app %basecios%\0000000f.app

::223v4
if /i "%basecios%" EQU "cIOS223[37-38]-v4" copy modules\Hermes\mloadv3.app %basecios%\0000000f.app

::222v5
if /i "%basecios%" EQU "cIOS222[38]-v5" copy modules\Hermes\mloadv5.app %basecios%\0000000f.app

::223v5 base37
if /i "%basecios%" EQU "cIOS223[37]-v5" copy modules\Hermes\mloadv5.app %basecios%\0000000f.app

::224v5 base57
if /i "%basecios%" EQU "cIOS224[57]-v5" copy modules\Hermes\mloadv5.app %basecios%\00000013.app



::249v19 base37
if /i "%basecios%" EQU "cIOS249[37]-v19" copy modules\W19Modules\mload.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy modules\W19Modules\EHCI.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy modules\W19Modules\FAT.app %basecios%\00000011.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy modules\W19Modules\SDHC.app %basecios%\00000012.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy modules\W19Modules\DIPP.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[37]-v19" copy modules\W19Modules\FFSP.app %basecios%\00000014.app

::249v19 base38
if /i "%basecios%" EQU "cIOS249[38]-v19" copy modules\W19Modules\mload.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy modules\W19Modules\EHCI.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy modules\W19Modules\FAT.app %basecios%\00000011.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy modules\W19Modules\SDHC.app %basecios%\00000012.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy modules\W19Modules\DIPP.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[38]-v19" copy modules\W19Modules\FFSP.app %basecios%\00000014.app

::249v19 base57
if /i "%basecios%" EQU "cIOS249[57]-v19" copy modules\W19Modules\mload.app %basecios%\00000013.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy modules\W19Modules\EHCI.app %basecios%\00000014.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy modules\W19Modules\FAT.app %basecios%\00000015.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy modules\W19Modules\SDHC.app %basecios%\00000016.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy modules\W19Modules\DIPP.app %basecios%\00000017.app
if /i "%basecios%" EQU "cIOS249[57]-v19" copy modules\W19Modules\FFSP.app %basecios%\00000018.app

::249v17b
if /i "%basecios%" EQU "cIOS249-v17b" copy modules\W17bModules\0000000f.app %basecios%\0000000f.app
if /i "%basecios%" EQU "cIOS249-v17b" copy modules\W17bModules\00000010.app %basecios%\00000010.app
if /i "%basecios%" EQU "cIOS249-v17b" copy modules\W17bModules\00000011.app %basecios%\00000011.app

::pack files into cIOS wad
:repackwad
echo.
echo Repacking Wad
echo.

wadmii -in %basecios% -out "%Drive%"\WAD\%wadname%.wad

::delete unpacked files
rd /s /q %basecios%





::Change version number and slot number (using patchios) only if required
:patchios

if /i "%ciosslot%" EQU "unchanged" goto:CIOSMD5

echo.
echo Changing version number and/or slot number
echo.
patchios "%Drive%"\WAD\%wadname%.wad -slot %ciosslot% -v %ciosversion%
echo.



:CIOSMD5
::echo %md5% *WAD\%wadname%.wad>> "%Drive%"\Download_Log.md5


::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\WAD\%wadname%.wad goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%.wad
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%.wad
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname%.wad goto:DOWNLOADSTART2
goto:NEXT
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT


::------------------------------------------CFG USB Loader Downloader--------------------------------------
:CFGDOWNLOADER

::choice=1 for most recent 249 and choice=2 for most recent 222
if /i "%cfg249%" EQU "*" set cfgchoice=1
if /i "%cfg222%" EQU "*" set cfgchoice=2

if /i "%name%" EQU "USB-Loader Folder" goto:doesntexist

if not exist "%Drive%\apps\USBLoader_cfg\meta.xml" goto:doesntexist

echo.
echo This app already exists...


::get current version if app already exists, skip if its the most recent version
sfk filter -quiet "%Drive%\apps\USBLoader_cfg\meta.xml" -+"/version" -rep _"*<version>"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat
echo.
echo Current version is %currentcode%
echo.
echo Checking for updates...
echo.

:doesntexist

::Download updates.txt
start %nusadmin%/wait wget http://cfg-loader.googlecode.com/svn/trunk/updates.txt


::Most Recent Version Download Link
sfk filter updates.txt -ls+url>cfgurl.txt
FINDSTR /N url cfgurl.txt>cfgurl2.txt
sfk filter cfgurl2.txt -rep _"url = "__>cfgurl.txt
del cfgurl2.txt
sfk filter cfgurl.txt -ls+"%cfgchoice%:" -ls!"%cfgchoice%%cfgchoice%:" -lsrep _"%cfgchoice%:"_"set cfgurl="_>cfgDLsettings.bat
del cfgurl.txt

::Most Recent Version Release Number
sfk filter updates.txt -ls+release>cfgrelease.txt
FINDSTR /N release cfgrelease.txt>cfgrelease2.txt
sfk filter cfgrelease2.txt -rep _"release = "__>cfgrelease.txt
del cfgrelease2.txt
sfk filter cfgrelease.txt -ls+"%cfgchoice%:" -ls!"%cfgchoice%%cfgchoice%:" -lsrep _"%cfgchoice%:"_"set cfgrelease="_>>cfgDLsettings.bat
del cfgrelease.txt

::Most Recent Version Release Date
sfk filter updates.txt -ls+date>cfgdate.txt
FINDSTR /N date cfgdate.txt>cfgdate2.txt
sfk filter cfgdate2.txt -rep _"date = "__>cfgdate.txt
del cfgdate2.txt
sfk filter cfgdate.txt -ls+"%cfgchoice%:" -ls!"%cfgchoice%%cfgchoice%:" -lsrep _"%cfgchoice%:"_"set cfgdate="_>>cfgDLsettings.bat
del cfgdate.txt

::Most Recent FULL Version number, used to download most recent 'usb-loader' folder
sfk filter updates.txt -ls+"release = " -rep _"release = "__>cfgFullRelease.txt
sfk filter cfgFullRelease.txt ++release -write -yes>nul
FINDSTR /N release cfgFullRelease.txt>cfgFullRelease2.txt
sfk filter cfgFullRelease2.txt -rep _" (release)"__>cfgFullRelease.txt
del cfgFullRelease2.txt
sfk filter cfgFullRelease.txt -ls+"1:" -ls!"11:" -lsrep _"1:"_"set cfgfullrelease="_>>cfgDLsettings.bat
del cfgFullRelease.txt


del updates.txt
call cfgDLsettings.bat
del cfgDLsettings.bat


if /i "%name%" EQU "USB-Loader Folder" goto:usbloaderFolder

if not exist "%Drive%\apps\USBLoader_cfg\meta.xml" goto:doesntalreadyexist


if "%currentcode%" EQU "%cfgrelease%" goto:noupdate

echo Updating from %currentcode% to %cfgrelease%
echo.
goto:update

:noupdate
sfk echo -spat \x20 [Green] Your current version of %currentcode% is up to date, skipping download
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:next




::Download most recent version of cfg loader
:doesntalreadyexist
Echo.
Echo Downloading most recent version: %cfgrelease%
:update
start %nusadmin%/wait wget %cfgurl%
if not exist "%Drive%"\apps\USBLoader_cfg mkdir "%Drive%"\apps\USBLoader_cfg
move /Y *.dol "%Drive%"\apps\USBLoader_cfg\boot.dol> nul

:geticon
if not exist "%Drive%"\apps\USBLoader_cfg\icon.png start %nusadmin%/wait wget http://code.google.com/p/cfg-loader/logo?cct=1263052802
if exist "logo@cct=1263052802" move /Y "logo@cct=1263052802" "%Drive%"\apps\USBLoader_cfg\icon.png

::meta
start %nusadmin%/wait wget "http://nusad.googlecode.com/files/meta.xml"
sfk filter meta.xml -rep _cfgrelease_"%cfgrelease%"_ -rep _cfgdate_"%cfgdate%"_ -write -yes>nul
move /Y meta.xml "%Drive%"\apps\USBLoader_cfg\meta.xml

::set DRIVE=%DRIVETEMP%

::----simple check if missing after downloading - if so, redownload----
if exist "%Drive%"\apps\USBLoader_cfg\boot.dol goto:NEXT
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2


:usbloaderFolder


if not exist "%DRIVE%\usb-loader\rev.txt" goto:skip
echo.
echo This app already exists...
echo.

set cfgfullreleaseOLD=
attrib -r -h -s "%DRIVE%\usb-loader\rev.txt"
copy /y "%DRIVE%\usb-loader\rev.txt" "%DRIVE%\usb-loader\rev.bat">nul
attrib +r +h +s "%DRIVE%\usb-loader\rev.txt"
call "%DRIVE%\usb-loader\rev.bat"
del "%DRIVE%\usb-loader\rev.bat"
echo Current version is %cfgfullreleaseOLD%
echo.
echo Checking for updates...
echo.
if %cfgfullreleaseOLD% GEQ %cfgfullrelease% goto:noupdate
:skip

::Download most recent full version for USB-Loader Folder

echo Downloading most recent USB-Loader Folder from CFG USB Loader Version %cfgfullrelease%
if exist "%Drive%\usb-loader" Echo.
if exist "%Drive%\usb-loader" Echo Note: Existing USB-Loader Folder will be renamed
start %nusadmin%/wait wget http://cfg-loader.googlecode.com/files/Cfg_USB_Loader_%cfgfullrelease%.zip



::Move most recent usb-loader folder to root of drive
7za x -aoa Cfg_USB_Loader_%cfgfullrelease%.zip

::rename exisiting usb-loader folder if applicable
:renameusbloader
if not exist "%Drive%\usb-loader" goto:moveusbloader
SET /a COUNT9=%COUNT9%+1
if exist "%Drive%\usb-loader%COUNT9%" goto:renameusbloader
move "%Drive%\usb-loader" "%Drive%\usb-loader%COUNT9%"
goto:moveusbloader


:moveusbloader
move /Y "Cfg_USB_Loader_%cfgfullrelease%\inSDRoot\usb-loader" "%DRIVE%\usb-loader"

::save version info for next time!
if exist "%DRIVE%\usb-loader\rev.txt" attrib -r -h -s "%DRIVE%\usb-loader\rev.txt"
echo set cfgfullreleaseOLD=%cfgfullrelease%>"%DRIVE%\usb-loader\rev.txt"
attrib +r +h +s "%DRIVE%\usb-loader\rev.txt"

rd /s /q Cfg_USB_Loader_%cfgfullrelease%
if /i "%SAVEZIP%" NEQ "ON" del Cfg_USB_Loader_%cfgfullrelease%.zip


if /i "%FORMAT%" EQU "1" echo partition = FAT1>>"%DRIVE%\usb-loader\config.txt"
if /i "%FORMAT%" EQU "2" echo partition = NTFS1>>"%DRIVE%\usb-loader\config.txt"
if /i "%FORMAT%" EQU "3" echo partition = FAT1>>"%DRIVE%\usb-loader\config.txt"

if /i "%FORMAT%" NEQ "NONE" echo unlock_password = AAAA>>"%DRIVE%\usb-loader\config.txt"
if /i "%FORMAT%" NEQ "NONE" echo disable_remove = BLAHBLAH>>"%DRIVE%\usb-loader\config.txt"
if /i "%FORMAT%" NEQ "NONE" echo disable_format = BLAHBLAH>>"%DRIVE%\usb-loader\config.txt"
if /i "%FORMAT%" NEQ "NONE" echo admin_unlock = BLAHBLAH>>"%DRIVE%\usb-loader\config.txt"

if /i "%FORMAT%" NEQ "NONE" sfk filter -write -yes "%DRIVE%\usb-loader\config.txt" -rep _BLAHBLAH_1_> nul


if /i "%USBCONFIG%" EQU "USB" echo covers_path = usb:/usb-loader/covers>>"%DRIVE%\usb-loader\config.txt"
if /i "%USBCONFIG%" EQU "USB" echo covers_path_2d = usb:/usb-loader/covers>>"%DRIVE%\usb-loader\config.txt"
if /i "%USBCONFIG%" EQU "USB" echo covers_path_3d = usb:/usb-loader/covers/3d>>"%DRIVE%\usb-loader\config.txt"
if /i "%USBCONFIG%" EQU "USB" echo covers_path_disc = usb:/usb-loader/covers/disc>>"%DRIVE%\usb-loader\config.txt"
if /i "%USBCONFIG%" EQU "USB" echo covers_path_full = usb:/usb-loader/covers/full>>"%DRIVE%\usb-loader\config.txt"

mkdir "%DRIVE%"/usb-loader/music
echo Save music Here>"%DRIVE%\usb-loader\music\Save MP3s Here To Play at USB-Loader Menu"
if /i "%USBCONFIG%" EQU "USB" echo music = usb:/usb-loader/music>>"%DRIVE%\usb-loader\config.txt"
if /i "%USBCONFIG%" EQU "SD" echo music = sd:/usb-loader/music>>"%DRIVE%\usb-loader\config.txt"

::set DRIVE=%DRIVETEMP%

::----simple check if missing after downloading - if so, redownload----
if exist "%DRIVE%"\usb-loader\background.png goto:NEXT
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2

:noupdate
sfk echo -spat \x20 [Green] Your current version of %cfgfullreleaseOLD% is up to date, skipping download
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:next


::------------------------------------------CONFIGURATOR FOR CFG USB Loader Downloader--------------------------------------
:CFGRDOWNLOADER

::set DRIVETEMP=%DRIVE%
::if /i "%USBCONFIG%" EQU "USB" set DRIVE=%DRIVEU%

::Download updates.txt
start %nusadmin%/wait wget "http://gwht.wdfiles.com/local--files/configurable-options/updates.txt"


::Most Recent Version Download Link
sfk filter updates.txt -ls+url>cfgrurl.txt
FINDSTR /N url cfgrurl.txt>cfgrurl2.txt
sfk filter cfgrurl2.txt -rep _"url = "__>cfgrurl.txt
del cfgrurl2.txt
sfk filter cfgrurl.txt -ls+"1:" -ls!"11:" -lsrep _"1:"_"set cfgrurl="_>cfgrDLsettings.bat
del cfgrurl.txt

::Most Recent Version Release Number
sfk filter updates.txt -ls+release>cfgrrelease.txt
FINDSTR /N release cfgrrelease.txt>cfgrrelease2.txt
sfk filter cfgrrelease2.txt -rep _"release = "__>cfgrrelease.txt
del cfgrrelease2.txt
sfk filter cfgrrelease.txt -ls+"1:" -ls!"11:" -lsrep _"1:"_"set cfgrrelease="_>>cfgrDLsettings.bat
del cfgrrelease.txt

del updates.txt
call cfgrDLsettings.bat
del cfgrDLsettings.bat

::Download most recent version

if not exist "%DRIVE%\usb-loader\cfgrrev.txt" goto:skip
echo.
echo This app already exists...
echo.
set cfgrreleaseOLD=
attrib -r -h -s "%DRIVE%\usb-loader\cfgrrev.txt"
copy /y "%DRIVE%\usb-loader\cfgrrev.txt" "%DRIVE%\usb-loader\cfgrev.bat">nul
attrib +r +h +s "%DRIVE%\usb-loader\cfgrrev.txt"
call "%DRIVE%\usb-loader\cfgrev.bat"
del "%DRIVE%\usb-loader\cfgrev.bat"
echo Current version is %cfgrreleaseOLD%
echo.
echo Checking for updates...
echo.
if %cfgrreleaseOLD% GEQ %cfgrrelease% goto:noupdate
:skip

Echo.
Echo Downloading most recent version: %cfgrrelease%
start %nusadmin%/wait wget %cfgrurl%
if not exist "%Drive%"\USB-Loader mkdir "%Drive%"\USB-Loader

::Move most recent usb-loader folder to root of drive
7za x -aoa CfgLoaderConfiguratorv%cfgrrelease%.zip
move /Y "CfgLoaderConfigurator.exe" "%DRIVE%\usb-loader"
move /Y "ConfiguratorHelp.chm" "%DRIVE%\usb-loader"
move /Y "Ionic.Zip.Reduced.dll" "%DRIVE%\usb-loader"
move /Y "Readme.txt" "%DRIVE%\usb-loader"

::save version info for next time!
if exist "%DRIVE%\usb-loader\cfgrrev.txt" attrib -r -h -s "%DRIVE%\usb-loader\cfgrrev.txt"
echo set cfgrreleaseOLD=%cfgrrelease%>"%DRIVE%\usb-loader\cfgrrev.txt"
attrib +r +h +s "%DRIVE%\usb-loader\cfgrrev.txt"

if /i "%SAVEZIP%" NEQ "ON" del CfgLoaderConfiguratorv%cfgrrelease%.zip

::set DRIVE=%DRIVETEMP%

::----simple check if missing after downloading - if so, redownload----
if exist "%DRIVE%"\usb-loader\CfgLoaderConfigurator.exe goto:NEXT
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2


:noupdate
sfk echo -spat \x20 [Green] Your current version of %cfgrreleaseOLD% is up to date, skipping download
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:next


::--------------------------TANTRIC APPS AUTO-UDPATE------------------------
:TANTRIC


if not exist "%DRIVE%\%path1%\meta.xml" goto:doesntexist

echo.
echo This app already exists...


::get current version if app already exists, skip if its the most recent version
sfk filter -quiet "%DRIVE%\%path1%\meta.xml" -+"/version" -rep _"*<version>"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat
echo.
echo Current version is %currentcode%
echo.
echo Checking for updates...
echo.

:doesntexist
start %nusadmin%/wait wget "%updateurl%"
sfk filter -quiet update.xml -+"app version" -rep _"<app version=""_"set newcode="_ -write -yes
sfk filter -quiet update.xml -rep _">_""_ -write -yes
sfk filter -quiet update.xml -rep _""""__>code.bat
del update.xml>nul
call code.bat
del code.bat>nul

if not exist "%DRIVE%\%path1%\meta.xml" goto:doesntalreadyexist


if %currentcode% GEQ %newcode% goto:noupdate
echo Updating from %currentcode% to %newcode%
goto:update

:noupdate
sfk echo -spat \x20 [Green] Your current version of %currentcode% is up to date, skipping download
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:next

:doesntalreadyexist

::Download most recent version
Echo.
Echo Downloading most recent version: %newcode%
:update
echo.
start %nusadmin%/wait wget "%code1%%newcode%%code2%"
if not exist "%Drive%"\%path1% mkdir "%Drive%"\%path1%


set wadname="%zip1%%newcode%%zip2%"

7za x -aoa %wadname% -o"%Drive%"
::7za e -aoa %wadname% -o"%Drive%"/%path1% *.%version% -r

if /i "%SAVEZIP%" EQU "off" del %wadname%


::----simple check if downloaded meta is the latest version - if not, redownload----
if not exist "%DRIVE%\%path1%\meta.xml" goto:skip
::get current version AGAIN if app already exists, skip if its the most recent version
sfk filter -quiet "%DRIVE%\%path1%\meta.xml" -+"/version" -rep _"*<version>"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat
if %currentcode% EQU %newcode% goto:NEXT
:skip
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file was not downloaded properly, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2



::--------------------------GOOGLE CODE 'MANUAL' AUTO-UDPATE------------------------
:GOOGLEUPDATE


if not exist "%DRIVE%\%path1%\meta.xml" goto:doesntexist

echo.
echo This app already exists...

::get current version if app already exists, skip if its the most recent version
::--------WARNING, if version doesn't start with "R", it will FAIL---------
sfk filter -quiet "%DRIVE%\%path1%\meta.xml" -+"/version" -rep _"*<version>R"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat
echo.
echo Current version is %currentcode%
echo.
echo Checking for updates...
echo.

:doesntexist
start %nusadmin%/wait wget %updateurl%
move /y %updatedlname% code.bat>nul

sfk filter -quiet code.bat -rep _"*name=R"_"set newcode="_ -rep _".dol&amp;*"__ -write -yes
sfk filter -quiet code.bat -ls+"set newcode" -write -yes
sfk filter -quiet code.bat -unique -write -yes
call code.bat
del code.bat>nul

set newcode0check=%newcode:~0,1%
if /i "%newcode0check%" EQU "0" (set newcodeNoZeros=%newcode:~1,10%) else (set newcodeNoZeros=%newcode%)


if not exist "%DRIVE%\%path1%\meta.xml" goto:doesntalreadyexist

if %currentcode% GEQ %newcodeNoZeros% goto:noupdate
echo Updating from %currentcode% to %newcodeNoZeros%
goto:update

:noupdate
sfk echo -spat \x20 [Green] Your current version of %currentcode% is up to date, skipping download
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:next

:doesntalreadyexist

::Download most recent version
Echo.
Echo Downloading most recent version: %newcodeNoZeros%
:update
echo.

start %nusadmin%/wait wget "%code1%%newcode%%code2%"

if not exist "%Drive%"\%path1% mkdir "%Drive%"\%path1%

::----move file to new location!----
set wadname="%wadname1%%newcode%%wadname2%"
move /y %wadname% "%DRIVE%\%path1%\boot.dol">nul


::----not needed (yet), only applies when downloading zips, not dols---
::set wadname="%zip1%%newcode%%zip2%"
::7za x -aoa %wadname% -o"%Drive%"
::if /i "%SAVEZIP%" EQU "off" del %wadname%


::geticon if doesn't exist
if not exist "%DRIVE%\%path1%\icon.png" start %nusadmin%/wait wget %iconurl%
if exist "icon.png" move /Y "icon.png" "%DRIVE%\%path1%\icon.png"

::meta
start %nusadmin%/wait wget %metaurl%
::sfk filter meta.xml -rep _cfgrelease_"%cfgrelease%"_ -rep _cfgdate_"%cfgdate%"_ -write -yes>nul
move /Y meta.xml "%DRIVE%\%path1%\meta.xml"

::----simple check if downloaded meta is the latest version - if not, redownload----

if not exist "%DRIVE%\%path1%\meta.xml" goto:skip
::get current version AGAIN if app already exists, skip if its the most recent version
::-----warning, replacing "R" too, careful when applying to other thigns------
sfk filter -quiet "%DRIVE%\%path1%\meta.xml" -+"/version" -rep _"*<version>R"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat
if %currentcode% EQU %newcodeNoZeros% goto:NEXT
:skip
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file was not downloaded properly, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2


::--------------------------------------Cheat Codes: txtcodes from geckocodes.org------------------------------
:CHEATS

::set cheatregion=all

if exist "codeindex.txt" del "codeindex.txt" >nul
if exist "codeindextemp.txt" del "codeindextemp.txt"

echo.
echo       Downloading %cheatregion% Region Cheat Codes for the following console(s):
echo.
if /i "%wiicheat%" EQU "ON" echo                * Wii
if /i "%WiiWarecheat%" EQU "ON" echo                * WiiWare
if /i "%VCArcadecheat%" EQU "ON" echo                * VC Arcade
if /i "%WiiChannelscheat%" EQU "ON" echo                * Wii Channels
if /i "%Gamecubecheat%" EQU "ON" echo                * Gamecube
if /i "%NEScheat%" EQU "ON" echo                * NES/Famicom VC
if /i "%SNEScheat%" EQU "ON" echo                * Super NES/Famicom VC
if /i "%N64cheat%" EQU "ON" echo                * Nintendo 64 VC
if /i "%SMScheat%" EQU "ON" echo                * Sega Master System VC
if /i "%Segacheat%" EQU "ON" echo                * Sega Genesis/Mega Drive VC
if /i "%NeoGeocheat%" EQU "ON" echo                * NeoGeo VC
if /i "%Commodorecheat%" EQU "ON" echo                * Commodore 64 VC
if /i "%MSXcheat%" EQU "ON" echo                * MSX VC
if /i "%TurboGraFX-16cheat%" EQU "ON" echo                * TurboGraFX-16 VC
if /i "%TurboGraFX-CDcheat%" EQU "ON" echo                * TurboGraFX-CD VC
echo.
if /i "%cheatlocation%" EQU "B" echo           Location(s) to save cheats: (txtcodes and codes\X\L)
if /i "%cheatlocation%" EQU "T" echo           Location(s) to save cheats: (txtcodes)
if /i "%cheatlocation%" EQU "C" echo           Location(s) to save cheats: (codes\X\L)
echo.
if /i "%overwritecodes%" EQU "OFF" echo           Overwrite existing txtcodes (Disabled)
if /i "%overwritecodes%" EQU "ON" echo           Overwrite existing txtcodes (Enabled)
echo.
echo       Note: The above settings can be customized in the Cheat Code Options
echo.
echo.
echo   Grabbing current list of cheats from geckocodes.org,
echo   Please wait...
echo.


::---get game/iso list and game count-------
if /i "%cheatlocation%" EQU "C" goto:skip
if not exist "%drive%"\txtcodes mkdir "%drive%"\txtcodes
:skip




::-----------used to get full list of all games---------------
goto:skipcheatrepeat
:cheatrepeat
if exist codeindex.txt copy /y codeindex.txt codeindextemp.txt >nul
if exist codeindex.txt (copy /y codeindextemp.txt+"index*=all" codeindex.txt >nul) else (move /y "index*=all" "codeindex.txt">nul)
if exist "index*=all" del "index*=all" >nul
if exist "codeindextemp.txt" del "codeindextemp.txt" >nul
goto:%nextcheatlist%
:skipcheatrepeat





::--------------ALL REGION---------------
if /i "%cheatregion%" NEQ "all" goto:skipall

::-------Wii Games--------
set nextcheatlist=allwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=*&l=all"
goto:cheatrepeat

::-------WiiWare------
:allwiiwarecheats
set nextcheatlist=allvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=*&l=all"
goto:cheatrepeat

::-------VC Arcade------
:allVCcheats
set nextcheatlist=allwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=*&l=all"
goto:cheatrepeat

::-------Wii Channels------
:allwiichannelcheats
set nextcheatlist=allGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=*&l=all"
goto:cheatrepeat

::-------Gamecube------
:allGCcheats
set nextcheatlist=allNEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=*&l=all"
goto:cheatrepeat

::-------NES------
:allNEScheats
set nextcheatlist=allSNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=*&l=all"
goto:cheatrepeat

::-------SNES------
:allSNEScheats
set nextcheatlist=allN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=*&l=all"
goto:cheatrepeat

::-------N64------
:allN64cheats
set nextcheatlist=allSMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=*&l=all"
goto:cheatrepeat

::-------SMS------
:allSMScheats
set nextcheatlist=allGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=*&l=all"
goto:cheatrepeat

::-------Genesis------
:allGenesischeats
set nextcheatlist=allNEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=*&l=all"
goto:cheatrepeat

::-------NEO------
:allNEOcheats
set nextcheatlist=allCOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=*&l=all"
goto:cheatrepeat

::-------COMMODORE------
:allCOMcheats
set nextcheatlist=allMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=*&l=all"
goto:cheatrepeat

::-------MSX------
:allMSXcheats
set nextcheatlist=allT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=*&l=all"
goto:cheatrepeat

::-------T16------
:allT16cheats
set nextcheatlist=allTCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=*&l=all"
goto:cheatrepeat

::-------TCD------
:allTCDcheats
set nextcheatlist=skipall
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=*&l=all"
goto:cheatrepeat

:skipall



::--------------USA REGION---------------
if /i "%cheatregion%" NEQ "USA" goto:skipUSA

::-------Wii Games--------
set nextcheatlist=USAwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=E&l=all"
goto:cheatrepeat

::-------WiiWare------
:USAwiiwarecheats
set nextcheatlist=USAvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=E&l=all"
goto:cheatrepeat

::-------VC Arcade------
:USAVCcheats
set nextcheatlist=USAwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=E&l=all"
goto:cheatrepeat

::-------Wii Channels------
:USAwiichannelcheats
set nextcheatlist=USAGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=E&l=all"
goto:cheatrepeat

::-------Gamecube------
:USAGCcheats
set nextcheatlist=USANEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=E&l=all"
goto:cheatrepeat

::-------NES------
:USANEScheats
set nextcheatlist=USASNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=E&l=all"
goto:cheatrepeat

::-------SNES------
:USASNEScheats
set nextcheatlist=USAN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=E&l=all"
goto:cheatrepeat

::-------N64------
:USAN64cheats
set nextcheatlist=USASMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=E&l=all"
goto:cheatrepeat

::-------SMS------
:USASMScheats
set nextcheatlist=USAGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=E&l=all"
goto:cheatrepeat

::-------Genesis------
:USAGenesischeats
set nextcheatlist=USANEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=E&l=all"
goto:cheatrepeat

::-------NEO------
:USANEOcheats
set nextcheatlist=USACOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=E&l=all"
goto:cheatrepeat

::-------COMMODORE------
:USACOMcheats
set nextcheatlist=USAMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=E&l=all"
goto:cheatrepeat

::-------MSX------
:USAMSXcheats
set nextcheatlist=USAT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=E&l=all"
goto:cheatrepeat

::-------T16------
:USAT16cheats
set nextcheatlist=USATCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=E&l=all"
goto:cheatrepeat

::-------TCD------
:USATCDcheats
set nextcheatlist=skipUSA
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=E&l=all"
goto:cheatrepeat

:skipUSA





::--------------PAL REGION---------------
if /i "%cheatregion%" NEQ "PAL" goto:skipPAL

::-------Wii Games--------
set nextcheatlist=PALwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=P&l=all"
goto:cheatrepeat

::-------WiiWare------
:PALwiiwarecheats
set nextcheatlist=PALvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=P&l=all"
goto:cheatrepeat

::-------VC Arcade------
:PALVCcheats
set nextcheatlist=PALwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=P&l=all"
goto:cheatrepeat

::-------Wii Channels------
:PALwiichannelcheats
set nextcheatlist=PALGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=P&l=all"
goto:cheatrepeat

::-------Gamecube------
:PALGCcheats
set nextcheatlist=PALNEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=P&l=all"
goto:cheatrepeat

::-------NES------
:PALNEScheats
set nextcheatlist=PALSNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=P&l=all"
goto:cheatrepeat

::-------SNES------
:PALSNEScheats
set nextcheatlist=PALN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=P&l=all"
goto:cheatrepeat

::-------N64------
:PALN64cheats
set nextcheatlist=PALSMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=P&l=all"
goto:cheatrepeat

::-------SMS------
:PALSMScheats
set nextcheatlist=PALGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=P&l=all"
goto:cheatrepeat

::-------Genesis------
:PALGenesischeats
set nextcheatlist=PALNEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=P&l=all"
goto:cheatrepeat

::-------NEO------
:PALNEOcheats
set nextcheatlist=PALCOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=P&l=all"
goto:cheatrepeat

::-------COMMODORE------
:PALCOMcheats
set nextcheatlist=PALMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=P&l=all"
goto:cheatrepeat

::-------MSX------
:PALMSXcheats
set nextcheatlist=PALT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=P&l=all"
goto:cheatrepeat

::-------T16------
:PALT16cheats
set nextcheatlist=PALTCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=P&l=all"
goto:cheatrepeat

::-------TCD------
:PALTCDcheats
set nextcheatlist=skipPAL
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=P&l=all"
goto:cheatrepeat

:skipPAL





::--------------JAP REGION---------------
if /i "%cheatregion%" NEQ "JAP" goto:skipJAP

::-------Wii Games--------
set nextcheatlist=JAPwiiwarecheats
if /i "%wiicheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=R&r=J&l=all"
goto:cheatrepeat

::-------WiiWare------
:JAPwiiwarecheats
set nextcheatlist=JAPvccheats
if /i "%WiiWarecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=W&r=J&l=all"
goto:cheatrepeat

::-------VC Arcade------
:JAPVCcheats
set nextcheatlist=JAPwiichannelcheats
if /i "%VCArcadecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=D&r=J&l=all"
goto:cheatrepeat

::-------Wii Channels------
:JAPwiichannelcheats
set nextcheatlist=JAPGCcheats
if /i "%WiiChannelscheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=H&r=J&l=all"
goto:cheatrepeat

::-------Gamecube------
:JAPGCcheats
set nextcheatlist=JAPNEScheats
if /i "%Gamecubecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=G&r=J&l=all"
goto:cheatrepeat

::-------NES------
:JAPNEScheats
set nextcheatlist=JAPSNEScheats
if /i "%NEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=F&r=J&l=all"
goto:cheatrepeat

::-------SNES------
:JAPSNEScheats
set nextcheatlist=JAPN64cheats
if /i "%SNEScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=J&r=J&l=all"
goto:cheatrepeat

::-------N64------
:JAPN64cheats
set nextcheatlist=JAPSMScheats
if /i "%N64cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=N&r=J&l=all"
goto:cheatrepeat

::-------SMS------
:JAPSMScheats
set nextcheatlist=JAPGenesischeats
if /i "%SMScheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=L&r=J&l=all"
goto:cheatrepeat

::-------Genesis------
:JAPGenesischeats
set nextcheatlist=JAPNEOcheats
if /i "%Segacheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=M&r=J&l=all"
goto:cheatrepeat

::-------NEO------
:JAPNEOcheats
set nextcheatlist=JAPCOMcheats
if /i "%NeoGeocheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=E&r=J&l=all"
goto:cheatrepeat

::-------COMMODORE------
:JAPCOMcheats
set nextcheatlist=JAPMSXcheats
if /i "%Commodorecheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=C&r=J&l=all"
goto:cheatrepeat

::-------MSX------
:JAPMSXcheats
set nextcheatlist=JAPT16cheats
if /i "%MSXcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=X&r=J&l=all"
goto:cheatrepeat

::-------T16------
:JAPT16cheats
set nextcheatlist=JAPTCDcheats
if /i "%TurboGraFX-16cheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=P&r=J&l=all"
goto:cheatrepeat

::-------TCD------
:JAPTCDcheats
set nextcheatlist=skipJAP
if /i "%TurboGraFX-CDcheat%" NEQ "on" goto:%nextcheatlist%
start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --accept index*l=all "http://www.geckocodes.org/index.php?chid=Q&r=J&l=all"
goto:cheatrepeat

:skipJAP



sfk filter -quiet codeindex.txt -+"index.php?c=******" -write -yes



goto:nextstep
::----------DISABLED------------
::-----remove titles that already exist (if applicable)---------
if /i "%overwritecodes%" EQU "on" goto:nextstep
if not exist "%drive%"\txtcodes\*.txt goto:nextstep
::echo Checking for new cheat codes
::echo This could take a minute, please wait...
::echo.
echo The following cheats already exist and will be removed from the download queue:
echo.
dir /b "%drive%"\txtcodes>existingcodes.txt
sfk filter -quiet existingcodes.txt -+.txt -rep _.txt__ -write -yes
::Loop through the existing list of codes (existingcodes.txt) and remove each existing game from codeindex.txt
for /F "tokens=*" %%A in (existingcodes.txt) do call :processthis %%A
goto:nextstep

:processthis
::this is repeated for each line of the txt.file
::"%*" (no quotes) is the variable for each line as it passes through the loop

set removetitleID=%*
echo Skipping %removetitleID%.txt...
sfk filter -quiet codeindex.txt -!%removetitleID% -write -yes
goto:EOF
:nextstep


if exist existingcodes.txt del existingcodes.txt


sfk filter codeindex.txt -unique -write -yes>nul
FINDSTR /N href codeindex.txt>codeindexfull.txt
del codeindex.txt

::totalcodes
setlocal ENABLEDELAYEDEXPANSION
set totalcodes=0
set codenumber=0
for /f "delims=" %%i in (codeindexfull.txt) do set /a totalcodes=!totalcodes!+1
setlocal DISABLEDELAYEDEXPANSION

echo.
:processcode

copy /y codeindexfull.txt codeindexfull2.txt>nul

if /i "%totalcodes%" EQU "%codenumber%" goto:nextstep
set /a codenumber=%codenumber%+1

sfk filter -quiet codeindexfull2.txt -ls+"%codenumber%:<" -ls!"%codenumber%%codenumber%:<" -ls!"%codenumber%%codenumber%%codenumber%:<" -rep _"*title='*["_"set titleid="_ -rep _"] *"__ -rep _"set titleid=set titleid="_"set titleid="_ -write -yes

::sfk filter -quiet codeindexfull2.txt -ls+"%codenumber%:<" -ls!"%codenumber%%codenumber%:<" -ls!"%codenumber%%codenumber%%codenumber%:<" -rep _"*'Wii ["_"set titleid="_ -rep _"] *"__ -write -yes



FINDSTR /N set codeindexfull2.txt>codeindex.bat
del codeindexfull2.txt

sfk filter -quiet codeindex.bat -ls+"1:" -rep _"1:"__ -write -yes
call codeindex.bat
del codeindex.bat


::now get game name!!
copy /y codeindexfull.txt codeindexTitle.bat>nul

sfk filter -quiet codeindexTitle.bat -+"%titleid%" -rep _"*c=%titleid%"_"set titlename="_ -rep _" [%titleid%]*"_"""_ -rep _>__ -write -yes
sfk filter -quiet codeindexTitle.bat -ls+"set titlename=" -write -yes
call codeindexTitle.bat
del codeindexTitle.bat


::if /i "%cheatlocation%" EQU "T" goto:skipconsoleinfo

::now get console!!
copy /y codeindexfull.txt codeindexConsole.bat>nul
sfk filter -quiet codeindexConsole.bat -+"%titleid%" -rep _"*sysn' title='"_"set console="_ -rep _"'>[*"_"""_ -write -yes
sfk filter -quiet codeindexConsole.bat -rep _"""__ -write -yes
sfk filter -quiet codeindexConsole.bat -ls+"set console=" -write -yes
call codeindexConsole.bat
del codeindexConsole.bat

::get console code
set consolecode=
if /i "%console%" EQU "Wii" set consolecode=R
if /i "%console%" EQU "WiiWare" set consolecode=W
if /i "%console%" EQU "VC Arcade" set consolecode=D
if /i "%console%" EQU "GameCube" set consolecode=G
::Wii Channels(H)-currently no codes, so unsure of "Wii Channels"
if /i "%console%" EQU "Wii Channels" set consolecode=H
if /i "%console%" EQU "NES/Famicom VC" set consolecode=F
if /i "%console%" EQU "Super NES/Famicom VC" set consolecode=J
if /i "%console%" EQU "Nintendo 64 VC" set consolecode=N
if /i "%console%" EQU "Sega Master System VC" set consolecode=L
if /i "%console%" EQU "Sega Genesis/Mega Drive VC" set consolecode=M
if /i "%console%" EQU "NeoGeo VC" set consolecode=E
if /i "%console%" EQU "Commodore 64 VC" set consolecode=C
if /i "%console%" EQU "MSX VC" set consolecode=X
if /i "%console%" EQU "TurboGraFX-16 VC" set consolecode=P
if /i "%console%" EQU "TurboGraFX-CD VC" set consolecode=Q

::get first letter of titlename (actually second letter cuz first one is ")
set letter1=%titlename:~1,1%
if /i "%letter1%" EQU "0" set letter1=#
if /i "%letter1%" EQU "1" set letter1=#
if /i "%letter1%" EQU "2" set letter1=#
if /i "%letter1%" EQU "3" set letter1=#
if /i "%letter1%" EQU "4" set letter1=#
if /i "%letter1%" EQU "5" set letter1=#
if /i "%letter1%" EQU "6" set letter1=#
if /i "%letter1%" EQU "7" set letter1=#
if /i "%letter1%" EQU "8" set letter1=#
if /i "%letter1%" EQU "9" set letter1=#

:skipconsoleinfo

::echo %titlename%
::echo %titleid%
::echo %console%
::echo %consolecode%
::echo %letter1%

echo.
echo Downloading Cheat %codenumber% of %totalcodes%: %titlename% [%titleid%]

if /i "%cheatlocation%" EQU "T" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%" mkdir "%drive%\codes\%consolecode%\%letter1%"
:skip

if /i "%overwritecodes%" EQU "on" goto:overwritecheat


::----copy existing codes to alternate location if missing----
if /i "%cheatlocation%" EQU "C" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" goto:skip
if not exist "%drive%\txtcodes\%titleid%.txt" echo Copying from codes\%consolecode%\%letter1%\%titleid%.txt to txtcodes\%titleid%.txt
if not exist "%drive%\txtcodes\%titleid%.txt" copy /y "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" "%drive%\txtcodes\%titleid%.txt">nul
:skip
if /i "%cheatlocation%" EQU "T" goto:skip
if not exist "%drive%\txtcodes\%titleid%.txt" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" echo Copying from txtcodes\%titleid%.txt to codes\%consolecode%\%letter1%\%titleid%.txt
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" copy /y "%drive%\txtcodes\%titleid%.txt" "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt">nul
:skip

if /i "%cheatlocation%" EQU "C" goto:skip
if not exist "%drive%\txtcodes\%titleid%.txt" goto:downloadcheat
:skip

if /i "%cheatlocation%" EQU "T" goto:skip
if not exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" goto:downloadcheat
:skip

echo %titleid%.txt already exists,
echo Skipping download...
echo.
goto:processcode

:overwritecheat
if /i "%cheatlocation%" EQU "C" goto:skip
if exist "%drive%\txtcodes\%titleid%.txt" echo Overwriting %drive%\txtcodes\%titleid%.txt...
:skip
if /i "%cheatlocation%" EQU "T" goto:skip
if exist "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt" echo Overwriting %drive%\codes\%consolecode%\%letter1%\%titleid%.txt...
:skip

:downloadcheat
start %nusadmin%/wait wget "http://www.geckocodes.org/txt.php?txt=%titleid%"

if /i "%cheatlocation%" EQU "T" move /y "txt.php@txt=%titleid%" "%drive%\txtcodes\%titleid%.txt">nul
if /i "%cheatlocation%" EQU "C" move /y "txt.php@txt=%titleid%" "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt">nul

if /i "%cheatlocation%" EQU "B" copy /y "txt.php@txt=%titleid%" "%drive%\txtcodes\%titleid%.txt">nul
if /i "%cheatlocation%" EQU "B" move /y "txt.php@txt=%titleid%" "%drive%\codes\%consolecode%\%letter1%\%titleid%.txt">nul

::for some reason VC downloads fail, and they leave index.html as a trace instead
::if exist index.html del index.html

goto:processcode

:nextstep

del codeindexfull.txt
del codeindexfull2.txt

goto:NEXT


::--------------------------------------Manual Update for Neogamma and YAWMM------------------------------
:MANUALUPDATE

if not exist "%DRIVE%\%path1%\meta.xml" goto:update

echo.
echo This app already exists...


::get current version if app already exists, skip if its the most recent version
sfk filter -quiet "%DRIVE%\%path1%\meta.xml" -+"/version" -rep _"*<version>"_"set currentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
del currentcode.bat
echo.
echo Current version is %currentcode%
echo.
echo Checking for updates...
echo.


::check for updates
start %nusadmin%/wait wget "%updateurl%"
move /y ManualUpdate.txt ManualUpdate.bat>nul

call ManualUpdate.bat
del ManualUpdate.bat>nul

if /i "%currentcode%" EQU "%newcode%" goto:noupdate
::echo Updating from %currentcode% to %newcode%
echo Updating to most recent version...


goto:update

:noupdate
sfk echo [Green] Current version of %currentcode% is up to date, Skipping download

@ping 127.0.0.1 -n 2 -w 1000> nul
goto:next

::Download most recent version
:update
echo.
start %nusadmin%/wait wget %code2%

if not exist "%Drive%"\%path1% mkdir "%Drive%"\%path1%

if /i "%path1%" NEQ "apps\neogamma" goto:normal
7za x -aoa "*-NeoGammaR9*.zip" -o"%Drive%" apps neogamma -r
7za e -aoa "*-NeoGammaR9*.zip" -o"%Drive%"/%path1% *.%version% -x!"gameconfig.txt" -x!"sourcecode" -r
goto:skip
:normal

7za e -aoa %wadname% -o"%Drive%"/%path1% *.%version% -r
:skip

if /i "%SAVEZIP%" EQU "off" del %wadname%


::----simple check if missing after downloading - if so, redownload----
if exist "%DRIVE%\%path1%\meta.xml" goto:NEXT
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2



::------------------------NUS File Grabber Downloader---------------------

:DownloadApp
if not exist "%Drive%"\WAD mkdir "%Drive%"\WAD
echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\WAD\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\WAD\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\WAD\%wadname%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\WAD\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

nusfilegrabber.exe %version%
move /Y %wadname% "%Drive%"\WAD\

::echo %md5% *WAD\%wadname%>> "%Drive%"\Download_Log.md5
goto:wadverifyretry



::-----------------------RENAME a bunch of stuff---------------------

:renameprivate
if not exist "%Drive%"\private goto:downloadurl2
if exist "%Drive%"\Private\%WADNAME% goto:next
SET /a COUNT2=%COUNT2%+1
if exist "%Drive%"\private%COUNT2% goto:renameprivate
move "%Drive%"\private "%Drive%"\private%COUNT2%> nul
if /i "%wadname%" EQU "Smashstack.zip" goto:fullextract2
goto:downloadURL2

::not used anymore
:renamehacks
if not exist "%Drive%"\hacks.ini goto:DownloadhacksToRoot
SET /a COUNT3=%COUNT3%+1
if exist "%Drive%"\hacks%COUNT3%.ini goto:renamehacks
move "%Drive%"\hacks.ini "%Drive%"\hacks%count3%.ini> nul
goto:DownloadhacksToRoot


:renamehackmiielf
if not exist "%Drive%"\boot.elf goto:renamehackmiidol
SET /a COUNT4=%COUNT4%+1
if exist "%Drive%"\boot%COUNT4%.elf goto:renamehackmiielf
move "%Drive%"\boot.elf "%Drive%"\boot%count4%.elf> nul
goto:renamehackmiidol

:renamehackmiidol
if not exist "%Drive%"\boot.dol goto:WGET
SET /a COUNT5=%COUNT5%+1
if exist "%Drive%"\boot%COUNT5%.dol goto:renamehackmiidol
move "%Drive%"\boot.dol "%Drive%"\boot%count5%.dol> nul
goto:WGET

::-------------------------Download from URLs------------------------------
:DownloadURL
echo %md5% *%path1%%filename%>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\%path1%%filename% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\%path1%%filename%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%"\%path1%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\%path1%%filename% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
::-----exceptions to overwrite to root!------
if /i "%wadname%" EQU "loadMii_0.3_twilightHack.zip" goto:overwritenow
goto:NEXT
:nocheckexisting

:DownloadURL2
if not exist %wadname% start %nusadmin%/wait wget %code2%
::if not exist %wadname% URL2File %code2% %wadname%
if exist %dlname% rename %dlname% %wadname%
7za e -aoa %wadname% -o"%Drive%"/%path1% *.%version% -r
if /i "%wadname%" EQU "BB1.zip" goto:BBstuff
if /i "%wadname%" EQU "BB2.zip" goto:BBstuff
::echo %md5% *%path1%%filename%>> "%Drive%"\Download_Log.md5
if /i "%SAVEZIP%" EQU "off" del %wadname%

if /i "%wadname%" EQU "loadMii_0.3_twilightHack.zip" ren "%Drive%"\%path1%%filename1% %filename%
if /i "%wadname%" EQU "loadMii_0.3_twilightHack.zip" goto:overwritenow
goto:nooverwrite


::OVERWRITE FILE AND SAVE TO ROOT!
:overwritenow
copy /Y "%Drive%"\%path1%%filename% "%Drive%"\%filename%>nul
if /i "%filename%" EQU "boot.dol" goto:delelf
if /i "%filename%" EQU "boot.elf" goto:deldol

:delelf
if exist "%Drive%"\boot.elf del "%Drive%"\boot.elf>nul
goto:nooverwrite

:deldol
if exist "%Drive%"\boot.dol del "%Drive%"\boot.dol>nul

:nooverwrite


:URLverifyretry
::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%\%path1%%filename%" goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%\%path1%%filename%"
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%\%path1%"
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%\%path1%%filename%" goto:DOWNLOADSTART2
goto:NEXT
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT


:BBstuff
::next line is to differentiate BB1 from BB2, they're really small files anyways, so having duplicates doesn't matter
copy %wadname% "%Drive%"\Private\%WADNAME%
echo %md5% *%path1%content.bin>> "%Drive%"\Download_Log.md5
if /i "%SAVEZIP%" EQU "off" del %wadname%
goto:next

:fullextract

echo %md5% *%path1%%filename%>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%\%path1%%filename%" goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%\%path1%%filename%"
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%\%path1%"
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%\%path1%%filename%" goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting
if /i "%wadname%" NEQ "Smashstack.zip" goto:fullextract2
if exist "%Drive%"\%path1%*.* goto:renameprivate

:fullextract2

if exist %wadname% goto:FullExtractZipAlreadyExists
if /i "%wadname%" NEQ "twilight-hack-v0.1-beta1.zip" start %nusadmin%/wait wget %code2%
if /i "%wadname%" EQU "twilight-hack-v0.1-beta1.zip" start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --reject "*.html*" --reject "%2A" --reject "main.css" --reject "*.ico" --reject "*.png" --reject "*beta2*" --reject "*pwns*" %code2%*
if /i "%wadname%" EQU "twilight-hack-v0.1-beta1.zip" rename get.* %wadname%
if exist %dlname% rename %dlname% %wadname%
:FullExtractZipAlreadyExists

::extract selected apps differently...
if /i "%wadname%" EQU "indiana-pwns.zip" 7za X -aoa %wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "indiana-pwns.zip" goto:skipnormalextraction
if /i "%wadname%" EQU "twilight-hack-v0.1-beta1.zip" 7za X -aoa %wadname% -o"%Drive%" private -r
if /i "%wadname%" EQU "twilight-hack-v0.1-beta1.zip" goto:skipnormalextraction
if /i "%wadname%" EQU "homebrew_browser_v0.3.8.zip" 7za X -aoa %wadname% -o"%Drive%"\apps homebrew_browser -r
if /i "%wadname%" EQU "homebrew_browser_v0.3.8.zip" goto:skipnormalextraction

if /i "%wadname%" EQU "Cheat_manager_v0_3.rar" unrar x -y %wadname% "%drive%"
if /i "%wadname%" EQU "Cheat_manager_v0_3.rar" goto:skipnormalextraction

if /i "%wadname%" EQU "DOP-Mii_v13.zip" 7za e -aoa %wadname% -o"%Drive%"/%path1% -x!*.cfg
if /i "%wadname%" EQU "DOP-Mii_v13.zip" rd /s /q "%Drive%\%path1%DOP-Mii" -r >nul
if /i "%wadname%" EQU "DOP-Mii_v13.zip" rd /s /q "%Drive%\%path1%DOP-Mii v13" -r >nul
if /i "%wadname%" EQU "DOP-Mii_v13.zip" rd /s /q "%Drive%\%path1%config" -r >nul
if /i "%wadname%" EQU "DOP-Mii_v13.zip" rd /s /q "%Drive%\%path1%apps" -r >nul
if /i "%wadname%" EQU "DOP-Mii_v13.zip" mkdir "%DRIVE%\config"
if /i "%wadname%" EQU "DOP-Mii_v13.zip" move /y "%Drive%\%path1%\DOP-Mii.cfg" "%Drive%\config\DOP-Mii.cfg" >nul
if /i "%wadname%" EQU "DOP-Mii_v13.zip" goto:skipnormalextraction


7za x -aoa %wadname% -o"%Drive%" -x!README
:skipnormalextraction

if /i "%SAVEZIP%" EQU "off" del %wadname%
goto:URLverifyretry
::DONE (will retry if necessary)



:DownloadhacksToRoot
echo %md5% *hacks.ini>> "%Drive%"\Download_Log.md5

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\hacks.ini goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\hacks.ini
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\hacks.ini
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\hacks.ini goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

if not exist %wadname% start %nusadmin%/wait wget %code2%
::rename %dlname% %wadname%
7za e -aoa %wadname% -o"%Drive%" *.%version% -r
if /i "%SAVEZIP%" EQU "off" del %wadname%


::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\hacks.ini goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%"\hacks.ini
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 del "%Drive%"\%path1%
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\hacks.ini goto:DOWNLOADSTART2
goto:NEXT
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT


::--------------------Wii Backup Manager and FAT32 Downloader Code-------------------------
:EXEDOWNLOADER

::echo %md5% *%path1%\%wadname%>> "%Drive%"\Download_Log.md5
::if exist "%DRIVE%"\%path1%\%wadname% echo This file already exists, Skipping download
::if exist "%DRIVE%"\%path1%\%wadname% @ping 127.0.0.1 -n 1 -w 1000> nul
::if exist "%DRIVE%"\%path1%\%wadname% goto:next

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\%path1%\%wadname% goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\%path1%\%wadname%
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%"\%path1%
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\%path1%\%wadname% goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT
:nocheckexisting

if not exist %dlname% start %nusadmin%/wait wget %code2%
::echo %md5% *%path1%\%wadname%>> "%Drive%"\Download_Log.md5

::WBM
if /i "%code1%" NEQ "ZIP" goto:notzipped
7za x -aoa %dlname%
if /i "%SAVEZIP%" EQU "off" del %dlname%
::if not exist "%DRIVE%\%path1%" mkdir "%DRIVE%\%path1%"
if /i "%wadname%" EQU "WiiBackupManager.exe" move /Y %path1% "%DRIVE%"
goto:exenextretry

::F32
:notzipped
if not exist "%DRIVE%\%path1%" mkdir "%DRIVE%\%path1%"
move /Y %wadname% "%DRIVE%\%path1%"

:exenextretry
::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\%path1%\%wadname% goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%"\%path1%\%wadname%
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%"\%path1%
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\%path1%\%wadname% goto:DOWNLOADSTART2
goto:NEXT
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT

::----------------------CUSTOM WAD DOWNLOAD (forwarder channels)-------------------------------
:CWAD

if not exist %dlname% start %nusadmin%/wait wget %code2%
if not exist "%DRIVE%"\WAD mkdir "%DRIVE%"\WAD
7za e -aoa %dlname% -o"%Drive%"/WAD *.%version% -r
if /i "%SAVEZIP%" EQU "off" del %dlname%
goto:wadverifyretry



::---------------HackMii Installer WGET Download CODE-----------------------

:wget

echo %md5% *apps\HackMii_Installer\boot.elf>> "%Drive%"\Download_Log.md5
::if exist "%Drive%"\apps\HackMii_Installer\boot.elf copy "%Drive%"\apps\HackMii_Installer\boot.elf "%Drive%"\boot.elf

::----if exist and fails md5 check, delete and redownload----
if exist "%Drive%"\apps\HackMii_Installer\boot.elf goto:checkexisting
goto:nocheckexisting
:checkexisting
echo.
sfk md5 -quiet -verify %md5% "%Drive%"\apps\HackMii_Installer\boot.elf
if errorlevel 1 echo This file already exists but it failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%"\apps\HackMii_Installer
SET retry=2
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\apps\HackMii_Installer goto:DOWNLOADSTART2
sfk echo [Green] This file already exists and has been verified, Skipping download
COPY /Y "%Drive%"\apps\HackMii_Installer\boot.elf "%Drive%"\boot.elf> nul
COPY /Y "%Drive%"\apps\HackMii_Installer\bootmini.elf "%Drive%"\bootmini.elf> nul
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:alreadyhavehackmii
:nocheckexisting

::echo.
::echo This software is not for sale.
::echo If you paid for this software or a "bundle" you have been scammed.
if not exist %wadname% start %nusadmin%/wait wget -c -l1 -r -nd --retr-symlinks -t10 -T30 --random-wait --reject "*.html" --reject "%2A" %code2%*
rename get.*.* %wadname%

::7za e -aoa %wadname% -o"%Drive%"/%path1% *.%version% -r
if not exist "%Drive%"\apps\HackMii_Installer mkdir "%Drive%"\apps\HackMii_Installer
7za e -aoa %wadname% -o"%Drive%"\apps\HackMii_Installer *.%version% *.txt -r
7za e -aoa %wadname% -o"%Drive%" *.%version% -r
if /i "%SAVEZIP%" EQU "off" del %wadname%



::----check after downloading - if md5 check fails, delete and redownload----
if exist "%Drive%"\apps\HackMii_Installer\boot.elf goto:checkexisting
echo.
if /i "%attempt%" NEQ "1" echo This file has failed to download properly multiple times, Skipping download.
if /i "%attempt%" NEQ "1" @ping 127.0.0.1 -n 1 -w 1000> nul
if /i "%attempt%" NEQ "1" goto:NEXT
echo The file is missing, retrying download.
SET retry=2
SET /a attempt=%attempt%+1
@ping 127.0.0.1 -n 1 -w 1000> nul
goto:DOWNLOADSTART2
:checkexisting
sfk md5 -quiet -verify %md5% "%Drive%"\apps\HackMii_Installer\boot.elf
echo.
if /i "%attempt%" NEQ "1" goto:giveup
::retry
if errorlevel 1 echo This file failed MD5 verification.
if errorlevel 1 echo The current version of the file will be deleted and the file will be re-downloaded.
if errorlevel 1 rd /s /q "%Drive%"\apps\HackMii_Installer
SET retry=2
SET /a attempt=%attempt%+1
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
if not exist "%Drive%"\apps\HackMii_Installer\boot.elf goto:DOWNLOADSTART2
goto:alreadyhavehackmii
:giveup
if errorlevel 1 echo This file has failed to download properly multiple times, Skipping download.
if errorlevel 1 @ping 127.0.0.1 -n 1 -w 1000> nul
goto:NEXT


:alreadyhavehackmii

if /i "%MENU1%" EQU "H" goto:RenameBootToHackMii
if /i "%virgin%" EQU "N" goto:next
if /i "%REGION%" EQU "K" goto:RenameBootToHackMii

::echo %md5% *boot.elf>> "%Drive%"\Download_Log.md5
goto:next


::-----Bannerbomb MMM instead of HackMii installer------
:RenameBootToHackMii

if exist "%Drive%"\apps\MMM\boot.dol del "%Drive%"\boot.elf
if exist "%Drive%"\apps\MMM\boot.dol copy /Y "%Drive%"\apps\MMM\boot.dol "%Drive%"\boot.dol

:: MD5 hash of MMM v13.2 is 739192c45ee31b7db00eda671a775ffa
::echo 739192c45ee31b7db00eda671a775ffa *"%Drive%"\boot.dol>> "%Drive%"\Download_Log.md5

goto:next


::----------------------NEXT----------------------
:NEXT
::cls
set basewad=none
set basewadb=none
set on=
set category=

if /i "%MENU1%" EQU "A" goto:customcopyandpatch


::if using nand builder, copy files to install folder
if /i "%nandpath%" EQU "%DRIVE%" goto:move
if /i "%MENU1%" EQU "S" copy /Y "%Drive%"\WAD\%wadname% "%nandpath%"\WAD\install2sneek\%wadname% >nul
goto:skip

:move
if /i "%MENU1%" EQU "S" move /Y "%Drive%"\WAD\%wadname% "%nandpath%"\WAD\install2sneek\%wadname% >nul
:skip

goto:%NEXT%





::-----------------------------------------cUSTOM COPY AND PATCH (only for advanced downloads)--------------------------------
:customcopyandpatch

if /i "%loadorgo%" EQU "load" goto:ADVPAGE2

echo.
sfk echo [Red] Creating a copy of %wadname% and turning it into

echo.
sfk echo -spat \x20 \x20 [Red] * %wadnameless%%patchname%%slotname%%versionname%
echo.

if /i "%ADVTYPE%" EQU "CIOS" set wadname=%wadname%.wad
::if /i "%ADVTYPE%" EQU "CMIOS" set wadname=%wadname%.wad


if exist "%DRIVE%"\WAD\%wadname% copy /Y "%DRIVE%"\WAD\%wadname% "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad

if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad goto:copyisthere

if not exist "%DRIVE%"\WAD mkdir "%DRIVE%"\WAD >nul
if exist "%DRIVE%"\%wadname% copy /Y "%DRIVE%"\%wadname% "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad

if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad goto:copyisthere

sfk echo -spat \x20 \x20 [Yellow] %WADNAME% is missing, check your internet connection.
echo.
pause
goto:MENU

:copyisthere

if /i "%wadnameless%%patchname%%slotname%%versionname%.wad" EQU "%wadnameless%.wad" goto:nopatching

echo.
patchios "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad%PATCHCODE%%slotcode%%versioncode%
echo.
sfk echo [Yellow] Note: Patches are not always successful, read the PatchIOS log above for details
echo.
:nopatching

if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad sfk echo [Green] The file has been created and saved here:
if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad echo.
if exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad sfk echo -spat \x20 \x20 \x20 [Green] "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad


if not exist "%DRIVE%"\WAD\%wadnameless%%patchname%%slotname%%versionname%.wad sfk echo [Yellow] Error: The file was not created

pause

goto:MENU




::---------------------------------------SNEEKINSTALLER----------------------------------
:SNEEKINSTALLER
cls

::delete all files that may interfere with SNEEK
if exist "%DRIVE%"\SNEEK\kernel.bin del "%DRIVE%"\SNEEK\kernel.bin
if exist "%DRIVE%"\SNEEK\di.bin del "%DRIVE%"\SNEEK\di.bin

if exist "%DRIVE%"\SNEEK\font.bin del "%DRIVE%"\SNEEK\font.bin


::Special handling of bootmii\armboot.bin to avoid deleting Bootmii-SD Files
if not exist "%DRIVE%"\bootmii\armboot.bin goto:skip

::No Bootmii-SD Files
if not exist "%DRIVE%"\bootmii\ppcboot.elf del "%DRIVE%"\bootmii\armboot.bin
if not exist "%DRIVE%"\bootmii\ppcboot.elf goto:skip

::RENAME Bootmii Booter Folder
set countbootmii=0
:renamebootmii
SET /a countbootmii=%countbootmii%+1
if exist "%DRIVE%"\bootmii_SDBooter%countbootmii% goto:renamebootmii
move "%DRIVE%"\bootmii "%DRIVE%"\bootmii_SDBooter%countbootmii%>nul
:skip


::Don't delete anything from USB if making Sneek or Sneek+di
if /i "%SNEEKTYPE%" EQU "SD" goto:skip
if /i "%SNEEKTYPE%" EQU "S" goto:skip
if exist "%DRIVEU%"\SNEEK\kernel.bin del "%DRIVEU%"\SNEEK\kernel.bin
if exist "%DRIVEU%"\SNEEK\di.bin del "%DRIVEU%"\SNEEK\di.bin
if exist "%DRIVEU%"\SNEEK\font.bin del "%DRIVEU%"\SNEEK\font.bin
:skip

if not exist modules\sneeksupport mkdir modules\sneeksupport
if not exist "%DRIVE%"\bootmii mkdir "%DRIVE%"\bootmii
if not exist "%DRIVE%"\SNEEK mkdir "%DRIVE%"\SNEEK

if /i "%SNEEKTYPE%" EQU "UD" goto:builddriveu
if /i "%SNEEKTYPE%" EQU "U" (goto:builddriveu) else (goto:nobuilddriveu)
:builddriveu
if not exist "%DRIVEU%"\SNEEK mkdir "%DRIVEU%"\SNEEK
:nobuilddriveu


::get sneek rev number

start %nusadmin%/wait wget http://code.google.com/p/sneek/downloads/list
move /y list sneekrev.bat>nul
sfk filter -quiet "sneekrev.bat" -rep _"*FS-SD module r"_"set sneekrev="_ -write -yes
sfk filter -quiet "sneekrev.bat" -+"set sneekrev" -write -yes
call sneekrev.bat
del sneekrev.bat




if /i "%SNEEKTYPE%" EQU "SD" echo Building SNEEK+DI rev%sneekrev%
if /i "%SNEEKTYPE%" EQU "UD" echo Building UNEEK+DI rev%sneekrev%
if /i "%SNEEKTYPE%" EQU "U" echo Building UNEEK rev%sneekrev%
if /i "%SNEEKTYPE%" EQU "S" echo Building SNEEK rev%sneekrev%
echo.

echo Downloading 0000000e.app from IOS80
nusfilegrabber.exe 0e
move /Y 0000000e.app modules\sneeksupport\
if not exist modules\sneeksupport\0000000e.app goto:sneekwarning
echo.

if /i "%SNEEKTYPE%" EQU "SD" goto:DL01
if /i "%SNEEKTYPE%" EQU "UD" goto:DL01
goto:skipDL01
:DL01
echo Downloading 00000001.app from IOS60
nusfilegrabber.exe 01_60
move /Y 00000001.app modules\sneeksupport\
if not exist modules\sneeksupport\00000001.app goto:sneekwarning
echo.


::FONT.BIN
if /i "%SNKFONT%" EQU "W" echo Downloading White font.bin (this can be changed to Black in Options)
if /i "%SNKFONT%" EQU "W" start %nusadmin%/wait wget -t 3 http://nusad.googlecode.com/files/fontw.bin
if /i "%SNKFONT%" EQU "B" echo Downloading Black font.bin (this can be changed to White in Options)
if /i "%SNKFONT%" EQU "B" start %nusadmin%/wait wget -t 3 http://nusad.googlecode.com/files/fontb.bin
if exist font%SNKFONT%.bin move /Y font%SNKFONT%.bin font.bin>nul

if /i "%SNEEKTYPE%" EQU "UD" goto:save2DriveU
if exist font.bin move /Y font.bin "%DRIVE%"\SNEEK\font.bin
if not exist "%DRIVE%"\SNEEK\font.bin goto:sneekwarning
echo.
goto:DLDIMODULE

:save2DriveU
if exist font.bin move /Y font.bin "%DRIVEU%"\SNEEK\font.bin
if not exist "%DRIVEU%"\SNEEK\font.bin goto:sneekwarning
echo.




:DLDIMODULE
echo Downloading dimodule.elf
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/files/dimodule.elf
if exist dimodule.elf move /Y dimodule.elf modules\sneeksupport\dimodule.elf
if not exist modules\sneeksupport\dimodule.elf goto:sneekwarning
echo.
:skipDL01


if /i "%SNEEKTYPE%" EQU "U" goto:USBMODULES
if /i "%SNEEKTYPE%" EQU "UD" (goto:USBMODULES) else (goto:NoUSBMODULES)
:USBMODULES
echo Downloading fsmodule-usb.elf
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/files/fsmodule-usb.elf
if exist fsmodule-usb.elf move /Y fsmodule-usb.elf modules\sneeksupport\fsmodule-usb.elf
if not exist modules\sneeksupport\fsmodule-usb.elf goto:sneekwarning
echo.
:NoUSBMODULES


if /i "%SNEEKTYPE%" EQU "S" goto:SDMODULES
if /i "%SNEEKTYPE%" EQU "SD" (goto:SDMODULES) else (goto:NoSDMODULES)
:SDMODULES
echo Downloading fsmodule-sd.elf
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/files/fsmodule-sd.elf
if exist fsmodule-sd.elf move /Y fsmodule-sd.elf modules\sneeksupport\fsmodule-sd.elf
if not exist modules\sneeksupport\fsmodule-sd.elf goto:sneekwarning
echo.
:NoSDMODULES

echo Downloading esmodule.elf
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/files/esmodule.elf
if exist esmodule.elf move /Y esmodule.elf modules\sneeksupport\esmodule.elf
echo.

echo Downloading armboot.bin
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/files/armboot.bin
if exist armboot.bin move /Y armboot.bin "%DRIVE%"\bootmii\armboot.bin

if not exist "%DRIVE%"\bootmii\armboot.bin goto:sneekwarning
echo.

::----------always DL most recent and save with nusad exe-----------
echo Downloading elfins.exe
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/svn/trunk/ELFIns/elfins.exe
if not exist elfins.exe goto:sneekwarning
echo.


echo Downloading IOSKPatch.exe
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/svn/trunk/IOSKpatch/IOSKPatch.exe
if not exist IOSKPatch.exe goto:sneekwarning
echo.



if /i "%SNEEKTYPE%" EQU "SD" goto:DI
if /i "%SNEEKTYPE%" EQU "UD" goto:UDI
if /i "%SNEEKTYPE%" EQU "U" goto:UNEEK
if /i "%SNEEKTYPE%" EQU "S" goto:SNEEK



::------random compiling info--------
::--IOSKPATCH
::Sneek-SD is (-s)
::SNEEK-DI must be (-s -d)
::UNEEK must be (-u)
::UNEEK-DI must be (-u)
::--elfins
::di.bin for SNEEK+DI: elfins.exe 00000001.app di.bin DIModule.elf
::kernel.bin for SNEEK-SD and SNEEK+DI:elfins.exe 0000000e.app kernel.bin ESModule.elf FSModule-sd.elf
::kernel.bin for UNEEK: elfins.exe 0000000e.app kernel.bin esmodule.elf fsmodule-usb.elf
::(substitute 0000000e_patched.app for 0000000e.app in the above)


if /i "%sneekverbose%" EQU "on" (set snkverbosecode= -v) else (set snkverbosecode=)
:DI
::SNEEK DI 0e maker
echo Patching 0000000e.app
ioskpatch.exe modules\sneeksupport\0000000e.app modules\sneeksupport\0000000e-patched.app -s -d%snkverbosecode% >nul
echo.

echo Building kernel.bin for SNEEK+DI
elfins.exe modules\sneeksupport\0000000e-patched.app "%DRIVE%"\SNEEK\kernel.bin modules\sneeksupport\ESModule.elf modules\sneeksupport\FSModule-sd.elf >nul
echo.

::DI Module Maker
echo Building di.bin
elfins.exe modules\sneeksupport\00000001.app "%DRIVE%"\SNEEK\di.bin modules\sneeksupport\DIModule.elf >nul
echo.

echo SNEEK+DI rev%sneekrev%>"%DRIVE%"\SNEEK\rev.txt
if not exist "%DRIVE%"\SNEEK\kernel.bin goto:sneekwarning
if not exist "%DRIVE%"\SNEEK\di.bin goto:sneekwarning
if /i "%SNEEKSELECT%" EQU "3" goto:SNKNANDBUILDER
goto:finishsneekinstall



:UDI
::UNEEK DI 0e maker
echo Patching 0000000e.app
ioskpatch.exe modules\sneeksupport\0000000e.app modules\sneeksupport\0000000e-patched.app -u%snkverbosecode% >nul
echo.

::kernel.bin for UNEEK
echo Building kernel.bin for UNEEK+DI
elfins.exe modules\sneeksupport\0000000e-patched.app "%DRIVE%"\SNEEK\kernel.bin modules\sneeksupport\esmodule.elf modules\sneeksupport\fsmodule-usb.elf >nul

copy /y "%DRIVE%"\SNEEK\kernel.bin "%DRIVEU%"\SNEEK\kernel.bin
echo.

::DI Module Maker
echo Building di.bin
elfins.exe modules\sneeksupport\00000001.app "%DRIVEU%"\SNEEK\di.bin modules\sneeksupport\DIModule.elf >nul
echo.

echo UNEEK+DI rev%sneekrev%>"%DRIVE%"\SNEEK\rev.txt
echo UNEEK+DI rev%sneekrev%>"%DRIVEU%"\SNEEK\rev.txt
if not exist "%DRIVE%"\SNEEK\kernel.bin goto:sneekwarning
if not exist "%DRIVEU%"\SNEEK\kernel.bin goto:sneekwarning
if not exist "%DRIVEU%"\SNEEK\di.bin goto:sneekwarning
if /i "%SNEEKSELECT%" EQU "3" goto:SNKNANDBUILDER
goto:finishsneekinstall



:UNEEK
::UNEEK 0e maker
echo Patching 0000000e.app
ioskpatch.exe modules\sneeksupport\0000000e.app modules\sneeksupport\0000000e-patched.app -u%snkverbosecode% >nul
echo.

::kernel.bin for UNEEK
echo Building kernel.bin for UNEEK
elfins.exe modules\sneeksupport\0000000e-patched.app "%DRIVE%"\SNEEK\kernel.bin modules\sneeksupport\esmodule.elf modules\sneeksupport\fsmodule-usb.elf >nul

copy /y "%DRIVE%"\SNEEK\kernel.bin "%DRIVEU%"\SNEEK\kernel.bin
echo.

echo UNEEK rev%sneekrev%>"%DRIVE%"\SNEEK\rev.txt
echo UNEEK rev%sneekrev%>"%DRIVEU%"\SNEEK\rev.txt
if not exist "%DRIVE%"\SNEEK\kernel.bin goto:sneekwarning
if not exist "%DRIVEU%"\SNEEK\kernel.bin goto:sneekwarning
if /i "%SNEEKSELECT%" EQU "3" goto:SNKNANDBUILDER
goto:finishsneekinstall


:SNEEK
::SNEEK SD 0e maker
echo Patching 0000000e.app
ioskpatch.exe modules\sneeksupport\0000000e.app modules\sneeksupport\0000000e-patched.app -s%snkverbosecode% >nul
echo.

echo Building kernel.bin for SNEEK
elfins.exe modules\sneeksupport\0000000e-patched.app "%DRIVE%"\SNEEK\kernel.bin modules\sneeksupport\ESModule.elf modules\sneeksupport\FSModule-sd.elf >nul

echo SNEEK rev%sneekrev%>"%DRIVE%"\SNEEK\rev.txt
if not exist "%DRIVE%"\SNEEK\kernel.bin goto:sneekwarning
echo.


if /i "%SNEEKSELECT%" EQU "3" goto:SNKNANDBUILDER
goto:finishsneekinstall




:sneekwarning
rd /s /q modules\sneeksupport
del elfins.exe
del ioskpatch.exe
echo.
sfk echo -spat \x20 [Yellow] WARNING: Some files Required for the SNEEK install are missing.
sfk echo -spat \x20 \x20 \x20 \x20 [Yellow] Aborting SNEEK Installation, check your internet connection
sfk echo -spat \x20 \x20 \x20 \x20 [Yellow] Then repeat the SNEEK Installation to try again.
echo.
pause
goto:MENU





::------------------------wad2nand-install wads from install2sneek to emu nand--------------------
:wad2nand

if exist modules\ShowMiiWads\common-key.bin copy /y modules\ShowMiiWads\common-key.bin "%nandpath%"\WAD\common-key.bin>nul

copy /y modules\ShowMiiWads\ShowMiiWads_template.cfg "%nandpath%"\WAD\ShowMiiWads.cfg>nul
copy /y modules\ShowMiiWads\ShowMiiWads_Sneek_Mod.exe "%nandpath%"\WAD\ShowMiiWads_Sneek_Mod.exe>nul

cls
echo Loading ShowMiiWads
echo.
echo installing wads from: %nandpath%\WAD\install2sneek\
echo     to emulated nand: %nandpath%\
echo.
echo Please wait for ShowMiiWads to finish doing it job...

cd /d "%nandpath%"\WAD
ShowMiiWads_Sneek_Mod.exe
cd /d %nusadpath%

if exist "%nandpath%"\WAD\common-key.bin move /y "%nandpath%"\WAD\common-key.bin modules\ShowMiiWads\common-key.bin>nul

::these were moved, not copied, so move 'em back to wad folder!!
if /i "%nandpath%" EQU "%DRIVE%" move /y "%Drive%"\WAD\install2sneek\*.wad "%Drive%"\WAD\ >nul

del "%nandpath%"\WAD\ShowMiiWads_Sneek_Mod.exe>nul
del "%nandpath%"\WAD\ShowMiiWads.cfg>nul
rd /s /q "%nandpath%"\WAD\install2sneek

if /i "%nandpath%" EQU "%DRIVE%" goto:neverempty
::echo Deleting %nandpath%\WAD (only if the directory is empty)
rd "%nandpath%\WAD"
:neverempty

::restore setting.txt if applicable
if not exist "%nandpath%\title\00000001\00000002\data" mkdir "%nandpath%\title\00000001\00000002\data"
if /i "%SNKSERIAL%" EQU "current" move /y "%nandpath%"\setting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt>nul

::Build setting.txt if applicable
if /i "%SNKSERIAL%" EQU "current" goto:skip
if /i "%SNKSERIAL%" EQU "N" goto:skip

settings %SNKSERIAL% >nul

if /i "%REGION%" EQU "K" move /y KORsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul
if /i "%REGION%" EQU "U" move /y USAsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul
if /i "%REGION%" EQU "E" move /y EURsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul
if /i "%REGION%" EQU "J" move /y JPNsetting.txt "%nandpath%"\title\00000001\00000002\data\setting.txt >nul

if /i "%REGION%" NEQ "K" del KORsetting.txt
if /i "%REGION%" NEQ "E" del EURsetting.txt
if /i "%REGION%" NEQ "J" del JPNsetting.txt
if /i "%REGION%" NEQ "U" del USAsetting.txt

:skip



::-----------patch SM .app file for UNEEK+DI... Always do this for 4.3X and 4.2U/E----------------

IF "%SMAPP%"=="" goto:skippatchSMios

::----------always DL most recent and save with nusad exe-----------
if exist IOSKPatch.exe goto:skip
echo.
echo Downloading IOSKPatch.exe to Patch System Menu for UNEEK+DI Compatability
start %nusadmin%/wait wget -t 3 http://sneek.googlecode.com/svn/trunk/IOSKpatch/IOSKPatch.exe
if not exist IOSKPatch.exe echo Unable to download IOSKPatch, System Menu will not be able to be patched
echo.
if not exist IOSKPatch.exe goto:skippatchSMios
:skip


::NUSAD only makes UNEEK+DI nands for 4.3U/E/J/K and 4.2U/E Nands (for now)

echo.
echo Patching System Menu %SMAPP%.app for UNEEK+DI Compatability

move /y "%nandpath%"\title\00000001\00000002\content\%SMAPP%.app "%nandpath%"\title\00000001\00000002\content\%SMAPP%_original.app >nul
ioskpatch.exe "%nandpath%"\title\00000001\00000002\content\%SMAPP%_original.app "%nandpath%"\title\00000001\00000002\content\%SMAPP%.app -p >nul
:skippatchSMios

echo.
goto:finishsneekinstall




::----------------------------------SNEEK INSTALL FINISH------------------------------------
:finishsneekinstall
rd /s /q modules\sneeksupport>nul
del elfins.exe>nul
del ioskpatch.exe>nul

cls
echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
echo.

::both sneek install and nand build
if /i "%SNEEKSELECT%" NEQ "3" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" echo         You have successfully installed SNEEK+DI rev%sneekrev% and built a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "UD" echo         You have installed UNEEK+DI rev%sneekrev% and built a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "S" echo         You have installed SNEEK rev%sneekrev% and built a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "U" echo         You have installed UNEEK rev%sneekrev% and built a %SNKVERSION%%REGION% Emulated Nand
:skip

::only install sneek
if /i "%SNEEKSELECT%" NEQ "1" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" echo         You have successfully installed SNEEK+DI rev%sneekrev%
if /i "%SNEEKTYPE%" EQU "UD" echo         You have successfully installed UNEEK+DI rev%sneekrev%
if /i "%SNEEKTYPE%" EQU "U" echo         You have successfully installed UNEEK rev%sneekrev%
if /i "%SNEEKTYPE%" EQU "S" echo         You have successfully installed SNEEK rev%sneekrev%
:skip

::only build nand
if /i "%SNEEKSELECT%" NEQ "2" goto:skip
if /i "%SNEEKTYPE%" EQU "SD" echo         You have successfully built a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "UD" echo         You have successfully built a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "U" echo         You have successfully built a %SNKVERSION%%REGION% Emulated Nand
if /i "%SNEEKTYPE%" EQU "S" echo         You have successfully built a %SNKVERSION%%REGION% Emulated Nand
:skip


echo.
echo.

if /i "%Drive%" EQU "COPY_TO_SD" echo    * Copy the contents of the COPY_TO_SD folder to SD Card
if /i "%Drive%" NEQ "COPY_TO_SD" echo    * Make sure that %DRIVE% is your SD card Drive Letter
if /i "%Drive%" NEQ "COPY_TO_SD" echo    * If %DRIVE% is not your SD card Drive Letter, copy the contents of
if /i "%Drive%" NEQ "COPY_TO_SD" echo      the %DRIVE% folder to your SD card
echo.

if /i "%SNEEKTYPE%" EQU "UD" goto:UDRIVEMSG
if /i "%SNEEKTYPE%" NEQ "U" goto:skipUDRIVEMSG
:UDRIVEMSG
if /i "%DRIVEU%" EQU "COPY_TO_USB" echo    * Copy the contents of the COPY_TO_USB folder to FAT32 Hard Drive
if /i "%DRIVEU%" NEQ "COPY_TO_USB" echo    * Make sure that %DRIVEU% is your USB HDD Drive Letter
if /i "%DRIVEU%" NEQ "COPY_TO_USB" echo    * If %DRIVEU% is not your USB HDD Drive Letter, copy the contents of
if /i "%DRIVEU%" NEQ "COPY_TO_USB" echo      the %DRIVEU% folder to your USB Hard Drive
echo.
:skipUDRIVEMSG

if /i "%SNEEKSELECT%" EQU "2" goto:skip
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] WARNING: SNEEK is not directly supported by NUS Auto Downloader.
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] Any problems you have with SNEEK that are not a direct result
sfk echo -spat \x20 \x20 \x20 \x20 [Red] of NUSAD should be reported here: http://code.google.com/p/sneek/
echo.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] This is also a great place to learn more about SNEEK in general.
sfk echo -spat \x20 \x20 \x20 \x20 [Red] Another great resource is the guide here: tinyurl.com/SNEEK-DI
:skip

echo.
echo.
echo    SOME QUICK SNEEK TIPS:
echo.
echo        * When launching any form of SNEEK for the first time,
echo          it could take a long time to load the System Menu,
echo          but it will be much quicker the second time around.
echo.
echo        * If you have BootMii as Boot2, SNEEK will start immediately 
echo          when the Wii powers on. To stop this from happening, rename 
echo          the BootMii folder on the SD Card to something else.
echo.
echo        * If you have BootMii as IOS, you will need to launch BootMii as IOS
echo          to start SNEEK. You can do so manually from the Homebrew Channel (HBC),
echo          or automatically via Priiloader's Autoboot Settings.
echo.
echo        * When using SNEEK+DI or UNEEK+DI, you can access the Game/DI Menu
echo          by pressing "1" on the WiiMote. To access other settings
echo          (including Region Options), you must press "B" from within the DI Menu.
echo.
echo        * To add Games to the Game/DI Menu, you can use NUSAD to extract
echo          Wii Games/ISOs to your FAT32 USB External Hard Drive.
echo.
echo        * ShowMiiWads can be used to decrypt your real Wii's BootMii NAND
echo          dump (nand.bin) to use as an emulated NAND, and it can add custom
echo          channels/WADs to an emulated NAND.
echo          ShowMiiWads is available here: http://code.google.com/p/showmiiwads/
echo.
echo        * For more SNEEK info, like formatting a USB Hard Drive for SNEEK,
echo          or installing the HBC to an emulated NAND, visit: tinyurl.com/SNEEK-DI
echo.
echo.
pause

goto:MENU





::.........................................FINISH / Verify..................................
:FINISH

if /i "%MENU1%" EQU "S" goto:wad2nand

::title=NUS Auto Downloader
setlocal ENABLEDELAYEDEXPANSION
set loglines=0



if /i "%DB%" EQU "N" goto:countnew
if /i "%DB%" EQU "A" goto:countall
if /i "%DB%" EQU "C" goto:countcustom

:countnew
if not exist %DRIVE%\Download_Log.md5 goto:donecounting
sfk filter "%DRIVE%"\Download_Log.md5 -unique -write -yes>nul
for /f "delims=" %%i in (%DRIVE%\Download_Log.md5) do set /a loglines=!loglines!+1
If /i "%cfgr%" EQU "*" set /a loglines=%loglines%+1
If /i "%cfg249%" EQU "*" set /a loglines=%loglines%+1
If /i "%cfg222%" EQU "*" set /a loglines=%loglines%+1
If /i "%usbfolder%" EQU "*" set /a loglines=%loglines%+1
If /i "%WiiMC%" EQU "*" set /a loglines=%loglines%+1
If /i "%fceugx%" EQU "*" set /a loglines=%loglines%+1
If /i "%snes9xgx%" EQU "*" set /a loglines=%loglines%+1
If /i "%vbagx%" EQU "*" set /a loglines=%loglines%+1
If /i "%SGM%" EQU "*" set /a loglines=%loglines%+1
If /i "%WIIX%" EQU "*" set /a loglines=%loglines%+1
If /i "%CheatCodes%" EQU "*" set /a loglines=%loglines%+1
If /i "%neogamma%" EQU "*" set /a loglines=%loglines%+1
If /i "%yawm%" EQU "*" set /a loglines=%loglines%+1


goto:donecounting

:countall
if exist %DRIVE%\Global_Log.md5 for /f "delims=" %%i in (%DRIVE%\Global_Log.md5) do set /a loglines=!loglines!+1
If exist "%DRIVE%"\apps\usbloader_cfg\boot.dol set /a loglines=%loglines%+1
If exist "%DRIVE%"\usb-loader\background.png set /a loglines=%loglines%+1
If exist "%DRIVE%"\usb-loader\CfgLoaderConfigurator.exe set /a loglines=%loglines%+1
goto:donecounting

:countcustom
if exist Custom.md5 for /f "delims=" %%i in (Custom.md5) do set /a loglines=!loglines!+1

:donecounting

::resize window
SET /a LINES=%loglines%+35
if %LINES% LEQ 54 set lines=54
mode con cols=85 lines=%LINES%

setlocal DISABLEDELAYEDEXPANSION

Set FINISH=
cls

echo                                  NUS Auto Downloader                          v4.2.2
echo                                       by XFlak
echo.
if /i "%DB%" EQU "N" echo         DOWNLOAD LOG - New Downloads Only (Including Skipped Downloads)
if /i "%DB%" EQU "A" echo         DOWNLOAD LOG - All Downloads (Doesn't check for missing files)
if /i "%DB%" EQU "C" echo         DOWNLOAD LOG - Custom

if /i "%DB%" EQU "N" set log=download_log.md5
if /i "%DB%" EQU "A" set log=global_log.md5
if /i "%DB%" EQU "C" set log=custom.md5

echo.

if not exist modules sfk echo -spat \x20 \x20 \x20 [Yellow] Missing "modules" folder - Required to verify files and make cIOSs/cMIOSs
if not exist modules sfk echo -spat \x20 \x20 \x20 \x20 \x20 \x20 [Yellow] Redownload NUS Auto Downloader from tinyurl.com/NusAuto

if /i "%DB%" NEQ "N" goto:Simpletestall


If /i "%cfg249%" EQU "*" goto:checkcfgbootdol
If /i "%cfg222%" EQU "*" goto:checkcfgbootdol
goto:next

:checkcfgbootdol
If not exist "%DRIVE%"\apps\usbloader_cfg\meta.xml echo %DRIVE%\apps\usbloader_cfg (CFG USB-Loader): Missing
If not exist "%DRIVE%"\apps\usbloader_cfg\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\usbloader_cfg\meta.xml" -+"/version" -rep _"*<version>"_"set cfgcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\usbloader_cfg (CFG USB-Loader): Found Version %cfgcurrentcode%
:next


::check for usb-folder
If /i "%usbfolder%" NEQ "*" goto:next
If not exist "%DRIVE%"\usb-loader\background.png echo %DRIVE%\usb-loader (CFG USB-Loader Folder): Missing
If not exist "%DRIVE%"\usb-loader\background.png goto:next
If not exist "%DRIVE%"\usb-loader\rev.txt echo %DRIVE%\usb-loader (CFG USB-Loader Folder): Found (unable to detect version)
If exist "%DRIVE%"\usb-loader\rev.txt attrib -r -h -s "%DRIVE%\usb-loader\rev.txt"
If not exist "%DRIVE%"\usb-loader\rev.txt (goto:next) else (copy /y "%DRIVE%"\usb-loader\rev.txt "%DRIVE%"\usb-loader\rev.bat>nul )
attrib +r +h +s "%DRIVE%\usb-loader\rev.txt"
call "%DRIVE%"\usb-loader\rev.bat
del "%DRIVE%"\usb-loader\rev.bat
echo %DRIVE%\usb-loader (CFG USB-Loader Folder): Found Version %cfgfullreleaseOLD%
:next

::check for configurator for configurable
If /i "%cfgr%" NEQ "*" goto:next
If not exist "%DRIVE%"\usb-loader\CfgLoaderConfigurator.exe echo %DRIVE%\usb-loader\CfgLoaderConfigurator.exe: Missing
If not exist "%DRIVE%"\usb-loader\CfgLoaderConfigurator.exe goto:next
If not exist "%DRIVE%"\usb-loader\cfgrrev.txt echo %DRIVE%\usb-loader\CfgLoaderConfigurator.exe: Found (unable to detect version)
If exist "%DRIVE%"\usb-loader\cfgrrev.txt attrib -r -h -s "%DRIVE%\usb-loader\cfgrrev.txt"
If not exist "%DRIVE%"\usb-loader\cfgrrev.txt (goto:next) else (copy /y "%DRIVE%"\usb-loader\cfgrrev.txt "%DRIVE%"\usb-loader\cfgrrev.bat>nul )
attrib +r +h +s "%DRIVE%\usb-loader\cfgrrev.txt"
call "%DRIVE%"\usb-loader\cfgrrev.bat
del "%DRIVE%"\usb-loader\cfgrrev.bat
echo %DRIVE%\usb-loader\CfgLoaderConfigurator.exe: Found Version %cfgrreleaseOLD%
:next

::check for neogamma
If /i "%neogamma%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\neogamma\meta.xml echo %DRIVE%\apps\NeoGamma: Missing
If not exist "%DRIVE%"\apps\neogamma\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\neogamma\meta.xml" -+"/version" -rep _"*<version>"_"set neocurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\NeoGamma: Found Version %neocurrentcode%
:next

::check for yawm
If /i "%yawm%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\yawmm\meta.xml echo %DRIVE%\apps\yawmm: Missing
If not exist "%DRIVE%"\apps\yawmm\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\yawmm\meta.xml" -+"/version" -rep _"*<version>"_"set yawmcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\yawmm: Found Version %yawmcurrentcode%
:next

::check for WiiMC
If /i "%WiiMC%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\WiiMC\meta.xml echo %DRIVE%\apps\WiiMC: Missing
If not exist "%DRIVE%"\apps\WiiMC\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\WiiMC\meta.xml" -+"/version" -rep _"*<version>"_"set WMCcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\WiiMC: Found Version %WMCcurrentcode%
:next

::check for fceugx
If /i "%fceugx%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\fceugx\meta.xml echo %DRIVE%\apps\fceugx: Missing
If not exist "%DRIVE%"\apps\fceugx\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\fceugx\meta.xml" -+"/version" -rep _"*<version>"_"set fceugxcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\fceugx: Found Version %fceugxcurrentcode%
:next

::check for snes9xgx
If /i "%snes9xgx%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\snes9xgx\meta.xml echo %DRIVE%\apps\snes9xgx: Missing
If not exist "%DRIVE%"\apps\snes9xgx\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\snes9xgx\meta.xml" -+"/version" -rep _"*<version>"_"set snescurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\snes9xgx: Found Version %snescurrentcode%
:next

::check for vbagx
If /i "%vbagx%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\vbagx\meta.xml echo %DRIVE%\apps\vbagx: Missing
If not exist "%DRIVE%"\apps\vbagx\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\vbagx\meta.xml" -+"/version" -rep _"*<version>"_"set vbagxcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\vbagx: Found Version %vbagxcurrentcode%

:next

::check for SGM
If /i "%SGM%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\SaveGameManagerGX\meta.xml echo %DRIVE%\apps\SaveGameManagerGX: Missing
If not exist "%DRIVE%"\apps\SaveGameManagerGX\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\SaveGameManagerGX\meta.xml" -+"/version" -rep _"*<version>"_"set SGMcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\SaveGameManagerGX: Found Version %SGMcurrentcode%
:next

::check for WIIX
If /i "%WIIX%" NEQ "*" goto:next
If not exist "%DRIVE%"\apps\WiiXplorer\meta.xml echo %DRIVE%\apps\WiiXplorer: Missing
If not exist "%DRIVE%"\apps\WiiXplorer\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\WiiXplorer\meta.xml" -+"/version" -rep _"*<version>"_"set WIIXcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\WiiXplorer: Found Version %WIIXcurrentcode%
:next

::check for CheatCodes
If /i "%CheatCodes%" NEQ "*" goto:next

if /i "%cheatlocation%" EQU "C" goto:skip
If exist "%DRIVE%"\txtcodes\*.txt echo %DRIVE%\txtcodes: Found
If not exist "%DRIVE%"\txtcodes\*.txt echo %DRIVE%\txtcodes: Missing
:skip

if /i "%cheatlocation%" EQU "T" goto:skip
If exist "%DRIVE%"\codes echo %DRIVE%\codes: Found
If not exist "%DRIVE%"\codes echo %DRIVE%\codes: Missing
:skip
:next


::------------------simple ALL check, check current version!--------------------------------
:Simpletestall
if /i "%DB%" NEQ "A" goto:skipall

If not exist "%DRIVE%"\apps\usbloader_cfg\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\usbloader_cfg\meta.xml" -+"/version" -rep _"*<version>"_"set cfgcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\usbloader_cfg (CFG USB-Loader): Found Version %cfgcurrentcode%
:next

::check for usb-folder
If not exist "%DRIVE%"\usb-loader\background.png goto:next
If not exist "%DRIVE%"\usb-loader\rev.txt echo %DRIVE%\usb-loader (CFG USB-Loader Folder): Found  (unable to detect version)
If exist "%DRIVE%"\usb-loader\rev.txt attrib -r -h -s "%DRIVE%\usb-loader\rev.txt"
If not exist "%DRIVE%"\usb-loader\rev.txt (goto:next) else (copy /y "%DRIVE%"\usb-loader\rev.txt "%DRIVE%"\usb-loader\rev.bat>nul )
attrib +r +h +s "%DRIVE%\usb-loader\rev.txt"
call "%DRIVE%"\usb-loader\rev.bat
del "%DRIVE%"\usb-loader\rev.bat
echo %DRIVE%\usb-loader (CFG USB-Loader Folder): Found Version %cfgfullreleaseOLD%
:next

::check for configurator for configurable
If not exist "%DRIVE%"\usb-loader\CfgLoaderConfigurator.exe goto:next
If not exist "%DRIVE%"\usb-loader\cfgrrev.txt echo %DRIVE%\usb-loader\CfgLoaderConfigurator.exe: Found  (unable to detect version)
If exist "%DRIVE%"\usb-loader\cfgrrev.txt attrib -r -h -s "%DRIVE%\usb-loader\cfgrrev.txt"
If not exist "%DRIVE%"\usb-loader\cfgrrev.txt (goto:next) else (copy /y "%DRIVE%"\usb-loader\cfgrrev.txt "%DRIVE%"\usb-loader\cfgrrev.bat>nul )
attrib +r +h +s "%DRIVE%\usb-loader\cfgrrev.txt"
call "%DRIVE%"\usb-loader\cfgrrev.bat
del "%DRIVE%"\usb-loader\cfgrrev.bat
echo %DRIVE%\usb-loader\CfgLoaderConfigurator.exe: Found Version %cfgrreleaseOLD%
:next

::check for neogamma
If not exist "%DRIVE%"\apps\neogamma\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\neogamma\meta.xml" -+"/version" -rep _"*<version>"_"set neocurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\NeoGamma: Found Version %neocurrentcode%
:next

::check for yawm
If not exist "%DRIVE%"\apps\yawmm\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\yawmm\meta.xml" -+"/version" -rep _"*<version>"_"set yawmcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\yawmm: Found Version %yawmcurrentcode%
:next

::check for WiiMC
If not exist "%DRIVE%"\apps\WiiMC\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\WiiMC\meta.xml" -+"/version" -rep _"*<version>"_"set WMCcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\WiiMC: Found Version %WMCcurrentcode%
:next

::check for fceugx
If not exist "%DRIVE%"\apps\fceugx\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\fceugx\meta.xml" -+"/version" -rep _"*<version>"_"set fceugxcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\fceugx: Found Version %fceugxcurrentcode%
:next

::check for snes9xgx
If not exist "%DRIVE%"\apps\snes9xgx\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\snes9xgx\meta.xml" -+"/version" -rep _"*<version>"_"set snescurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\snes9xgx: Found Version %snescurrentcode%
:next

::check for vbagx
If not exist "%DRIVE%"\apps\vbagx\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\vbagx\meta.xml" -+"/version" -rep _"*<version>"_"set vbagxcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\vbagx: Found Version %vbagxcurrentcode%
:next

::check for SGM
If not exist "%DRIVE%"\apps\SaveGameManagerGX\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\SaveGameManagerGX\meta.xml" -+"/version" -rep _"*<version>"_"set SGMcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\SaveGameManagerGX: Found Version %SGMcurrentcode%
:next

::check for WIIX
If not exist "%DRIVE%"\apps\WiiXplorer\meta.xml goto:next
sfk filter -quiet "%DRIVE%\apps\WiiXplorer\meta.xml" -+"/version" -rep _"*<version>"_"set WIIXcurrentcode="_ -rep _"</version*"__ >currentcode.bat
call currentcode.bat
echo %DRIVE%\apps\WiiXplorer: Found Version %WIIXcurrentcode%
:next

If exist "%DRIVE%"\txtcodes\*.txt echo %DRIVE%\txtcodes: Found
If exist "%DRIVE%"\codes echo %DRIVE%\codes: Found

:skipall

if exist currentcode.bat del currentcode.bat

echo.

If not exist "%DRIVE%"\Download_Log.md5 goto:SkipNewWADCheck
::if /i "%DB%" EQU "N" sfk md5check "%DRIVE%"\Download_Log.md5
::if /i "%DB%" EQU "N" sfk filter "%DRIVE%"\Download_Log.md5 -unique -write -yes>nul
::for /f "delims=" %%i in ("%DRIVE%\Download_Log.md5") do set /a loglines=!loglines!+1
if /i "%DB%" EQU "N" fvc -x -v "%DRIVE%"\Download_Log.md5
:SkipNewWADCheck

If not exist "%DRIVE%"\Global_Log.md5 goto:SkipGlobalROOTCheck
::if /i "%DB%" EQU "A" sfk md5check "%DRIVE%"\Global_Log.md5
if /i "%DB%" EQU "A" fvc -x -v "%DRIVE%"\Global_Log.md5
:SkipGlobalROOTCheck

If not exist Custom.md5 goto:SkipCustomCheck
::if /i "%DB%" EQU "C" sfk md5check "%DRIVE%"\Custom.md5
::for /f "delims=" %%i in (Custom.md5) do set /a loglines=!loglines!+1
if /i "%DB%" EQU "C" fvc -x -v Custom.md5
:SkipCustomCheck



echo.
if /i "%DLTOTAL%" NEQ "0" Echo    *If any files are Invalid or Missing, select Repeat Download (R).
if /i "%DLTOTAL%" EQU "0" Echo    *If any files are Invalid or Missing, retry downloading the files.
echo.
echo    *If you are experiencing errors, make sure you have free space here: %DRIVE%
echo     Check internet connection (try disabling firewall/bypasing proxy if applicable).
echo     Make sure that your Windows has .NET Framework 3.5 installed.


if /i "%USBCONFIG%" EQU "USB" goto:skipcopytoSDmsg
echo.
if /i "%Drive%" EQU "COPY_TO_SD" echo    *If the files are good, copy the contents of the COPY_TO_SD folder to SD Card
if /i "%Drive%" NEQ "COPY_TO_SD" echo    *If the files are good, make sure that %DRIVE% is your SD card Drive Letter
if /i "%Drive%" NEQ "COPY_TO_SD" echo    *If %DRIVE% is not your SD card Drive Letter, copy the contents of
if /i "%Drive%" NEQ "COPY_TO_SD" echo    the %DRIVE% folder to your SD card
:skipcopytoSDmsg
echo.
echo.

if exist "%DRIVE%" echo          O = Open File Location (%Drive%)

if exist "%DRIVE%"\%log% echo          L = Log: View %Log% to see which files were checked
if exist %log% echo          L = Log: View %Log% to see which files were checked

if /i "%DLTOTAL%" EQU "0" goto:dltotaliszero
echo.
echo          R = Repeat Download (select this if you experience errors)
If not Exist download_queue.bat echo          S = Save Download Queue
If Exist download_queue.bat echo          S = Save Download Queue (existing Download Queue will be renamed)
If Exist download_queue.bat echo          S+= Save Download Queue+ (add files to existing Download Queue)
:dltotaliszero


echo.

if /i "%DB%" NEQ "A" echo          A = Verify ALL Files in %DRIVE% (does not check missing files)
if /i "%DB%" NEQ "N" echo          N = Verify NEW Downloads only
if /i "%DB%" EQU "C" goto:next
if exist Custom.md5 echo          C = Verify Files against Custom.md5


:next
echo.
echo          M = Main Menu
echo          E = Exit
::echo          M = Main Menu                        +  Expand Window
::echo          E = Exit                             -  Shrink Window
echo.
set /p FINISH=     Enter Selection Here: 



if /i "%FINISH%" EQU "M" goto:MENU
if /i "%FINISH%" EQU "E" goto:exitnow

if not exist "%DRIVE%" goto:drivedoesnotexist2
if /i "%FINISH%" EQU "O" explorer "%DRIVE%"
if /i "%FINISH%" EQU "O" goto:Finish
:drivedoesnotexist2

if /i "%DB%" EQU "C" goto:opencustommd5
if not exist "%DRIVE%\%log%" goto:nolog
if /i "%FINISH%" EQU "L" start notepad "%DRIVE%\%log%"
if /i "%FINISH%" EQU "L" goto:Finish

:opencustommd5
if not exist "%log%" goto:nolog
if /i "%FINISH%" EQU "L" start notepad "%log%"
if /i "%FINISH%" EQU "L" goto:Finish

:nolog

if /i "%FINISH%" EQU "A" SET DB=A
if /i "%FINISH%" EQU "A" goto:GLOBALDB

if /i "%FINISH%" EQU "C" SET DB=C
if /i "%FINISH%" EQU "C" goto:Finish

if /i "%FINISH%" EQU "N" SET DB=N
if /i "%FINISH%" EQU "N" del "%DRIVE%"\Global_Log.md5
if /i "%FINISH%" EQU "N" goto:FINISH

::if /i "%FINISH%" EQU "+" SET /a LINES=%LINES%+20
::if /i "%FINISH%" EQU "+" goto:Finish
::if /i "%FINISH%" EQU "-" SET /a LINES=%LINES%-20
::if /i "%FINISH%" EQU "-" goto:Finish

if /i "%DLTOTAL%" EQU "0" goto:dltotaliszero2
if /i "%FINISH%" EQU "R" goto:DLSettings2
if /i "%FINISH%" EQU "S" goto:SaveDownloadQueue
If not Exist download_queue.bat goto:dltotaliszero2
if /i "%FINISH%" EQU "S+" goto:SaveDownloadQueue
:dltotaliszero2


echo You Have Entered an Incorrect Key
@ping 127.0.0.1 -n 2 -w 1000> nul
goto:FINISH






::..........................DOWNLOAD SETTINGS................................
:DLSETTINGS

if /i "%MENU1%" EQU "W" goto:guide
if /i "%MENU1%" EQU "H" goto:HMguide
if /i "%MENU1%" EQU "U" goto:USBguide
:DLSETTINGS2

SET CURRENTDL=0

cls


:EULAU
if /i "%EULAU%" EQU "*" set on=*
set NEXT=EULAE
if /i "%on%" NEQ "*" goto:%NEXT%
set name=EULA v3 (USA)
set code1=00010008
set code2=48414B45
set version=3
set wadname=EULA-NUS-v3[U].wad
set md5=f30393cd89cb20007c501efab75dab0c
goto:downloadstart

:EULAE
if /i "%EULAE%" EQU "*" set on=*
set NEXT=EULAJ
if /i "%on%" NEQ "*" goto:%NEXT%
set name=EULA v3 (PAL)
set code1=00010008
set code2=48414B50
set version=3
set wadname=EULA-NUS-v3[E].wad
set md5=e835877a6460beeb0d6756c43a800465
goto:downloadstart

:EULAJ
if /i "%EULAJ%" EQU "*" set on=*
set NEXT=EULAK
if /i "%on%" NEQ "*" goto:%NEXT%
set name=EULA v3 (JAP)
set code1=00010008
set code2=48414B4A
set version=3
set wadname=EULA-NUS-v3[J].wad
set md5=1b73948a1b3729cd29f0939652e856b3
goto:downloadstart

:EULAK
if /i "%EULAJ%" EQU "*" set on=*
set NEXT=RSU
if /i "%on%" NEQ "*" goto:%NEXT%
set name=EULA v3 (KOR)
set code1=00010008
set code2=48414B4B
set version=3
set wadname=EULA-NUS-v3[K].wad
set md5=21c48127696cf028a3bc19b3d34aef11
goto:downloadstart

:RSU
if /i "%RSU%" EQU "*" set on=*
set NEXT=RSE
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Region Select v3 (USA)
set code1=00010008
set code2=48414C45
set version=2
set wadname=Region-Select-NUS-v2[U].wad
set md5=27950cf84c554a851c42c33688f301c5
goto:downloadstart

:RSE
if /i "%RSE%" EQU "*" set on=*
set NEXT=RSJ
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Region Select v3 (PAL)
set code1=00010008
set code2=48414C50
set version=2
set wadname=Region-Select-NUS-v2[E].wad
set md5=bac3441c6b6aec07a38b4b2cab103a3d
goto:downloadstart

:RSJ
if /i "%RSJ%" EQU "*" set on=*
set NEXT=RSK
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Region Select v3 (JAP)
set code1=00010008
set code2=48414C4A
set version=2
set wadname=Region-Select-NUS-v2[J].wad
set md5=982d8507a94fbad1e298b073ba90c16d
goto:downloadstart

:RSK
if /i "%RSJ%" EQU "*" set on=*
set NEXT=BC
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Region Select v3 (KOR)
set code1=00010008
set code2=48414C4B
set version=2
set wadname=Region-Select-NUS-v2[K].wad
set md5=18aee652bc16bc1aa4261400758ac04a
goto:downloadstart



:BC
if /i "%BC%" EQU "*" set on=*
set NEXT=SM4.3U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=BC
set code1=00000001
set code2=00000100
set version=6
set wadname=BC-NUS-v6.wad
set md5=d1593a77e24ecc95af2b393abe5d92f0
goto:downloadstart



:SM4.3U

if /i "%SM4.3U%" EQU "*" set on=*
set NEXT=SM4.2U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.3U
set code1=00000001
set code2=00000002
set version=513
set wadname=4.3U_Systemmenu_v513.wad
set md5=4f5c63e3fd1bf732067fa4c439c68a97
goto:downloadstart


:SM4.2U

if /i "%SM4.2U%" EQU "*" set on=*
set NEXT=SM4.1U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.2U
set code1=00000001
set code2=00000002
set version=481
set wadname=4.2U_Systemmenu_v481.wad
set md5=4ac52b981845473bd3655e4836d7442b
goto:downloadstart

:SM4.1U

if /i "%SM4.1U%" EQU "*" set on=*
set NEXT=SM3.2U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.1U
set code1=00000001
set code2=00000002
set version=449
set wadname=4.1U_Systemmenu_v449.wad
set md5=38a95a9acd257265294be41b796f6239
goto:downloadstart

:SM3.2U

if /i "%SM3.2U%" EQU "*" set on=*
set NEXT=SM4.3E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 3.2U
set code1=00000001
set code2=00000002
set version=289
set wadname=3.2U_Systemmenu_v289.wad
set md5=7514582f06126aee897fc2b2e9185980
goto:downloadstart

:SM4.3E

if /i "%SM4.3E%" EQU "*" set on=*
set NEXT=SM4.2E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.3E
set code1=00000001
set code2=00000002
set version=514
set wadname=4.3E_Systemmenu_v514.wad
set md5=2ec2e6fbdfc52fe5174749e7032f1bad
goto:downloadstart

:SM4.2E

if /i "%SM4.2E%" EQU "*" set on=*
set NEXT=SM4.1E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.2E
set code1=00000001
set code2=00000002
set version=482
set wadname=4.2E_Systemmenu_v482.wad
set md5=7d77be8b6df5ac893d24652db33d02cd
goto:downloadstart

:SM4.1E

if /i "%SM4.1E%" EQU "*" set on=*
set NEXT=SM3.2E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.1E
set code1=00000001
set code2=00000002
set version=450
set wadname=4.1E_Systemmenu_v450.wad
set md5=688cc78b8eab4e30da04f01a81a3739f
goto:downloadstart

:SM3.2E

if /i "%SM3.2E%" EQU "*" set on=*
set NEXT=SM4.3J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 3.2E
set code1=00000001
set code2=00000002
set version=290
set wadname=3.2E_Systemmenu_v290.wad
set md5=5f0ff5a2b160f5340ccf74118edc9e33
goto:downloadstart

:SM4.3J
if /i "%SM4.3J%" EQU "*" set on=*
set NEXT=SM4.2J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.3J
set code1=00000001
set code2=00000002
set version=512
set wadname=4.3J_Systemmenu_v512.wad
set md5=df67ed4bd8f8f117741fef7952ee5c17
goto:downloadstart

:SM4.2J

if /i "%SM4.2J%" EQU "*" set on=*
set NEXT=SM4.1J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.2J
set code1=00000001
set code2=00000002
set version=480
set wadname=4.2J_Systemmenu_v480.wad
set md5=0413a9aed208b193fea85db908bbdabf
goto:downloadstart

:SM4.1J

if /i "%SM4.1J%" EQU "*" set on=*
set NEXT=SM3.2J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.1J
set code1=00000001
set code2=00000002
set version=448
set wadname=4.1J_Systemmenu_v448.wad
set md5=6edb4b3f7ca26c643c6bc662d159ec2e
goto:downloadstart

:SM3.2J

if /i "%SM3.2J%" EQU "*" set on=*
set NEXT=SM4.3K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 3.2J
set code1=00000001
set code2=00000002
set version=288
set wadname=3.2J_Systemmenu_v288.wad
set md5=907e4901a936337bd7188c82d449eae0
goto:downloadstart


:SM4.3K

if /i "%SM4.3K%" EQU "*" set on=*
set NEXT=SM4.2K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.3K
set code1=00000001
set code2=00000002
set version=518
set wadname=4.3K_Systemmenu_v518.wad
set md5=6ed8f9e75b0a54eacfbacce57c20136d
goto:downloadstart


:SM4.2K

if /i "%SM4.2K%" EQU "*" set on=*
set NEXT=SM4.1K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.2K
set code1=00000001
set code2=00000002
set version=486
set wadname=4.2K_Systemmenu_v486.wad
set md5=40c0bf90ea07b02d610edae1d7aea39f
goto:downloadstart

:SM4.1K

if /i "%SM4.1K%" EQU "*" set on=*
set NEXT=MII
if /i "%on%" NEQ "*" goto:%NEXT%
set name=System Menu 4.1K
set code1=00000001
set code2=00000002
set version=454
set wadname=4.1K_Systemmenu_v454.wad
set md5=c0e5d5c4914e76e7df7495ccf28ef869
goto:downloadstart

:MII

if /i "%MII%" EQU "*" set on=*
set NEXT=PHOTO
if /i "%on%" NEQ "*" goto:%NEXT%
set name=MII Channel
set code1=00010002
set code2=48414341
set version=6
set wadname=Mii-Channel-NUS-v6.wad
set md5=5f03c5970ecf064bc520f4a11a0d3a34
goto:downloadstart

:PHOTO

if /i "%P%" EQU "*" set on=*
set NEXT=PHOTO_K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Photo Channel 1.1 (USA / PAL / JAP)
set code1=00010002
set code2=48415941
set version=3
set wadname=Photo-Channel-1.1-NUS-v3.wad
set md5=ba88843d7d5d8090c6cce2c822965299
goto:downloadstart

:PHOTO_K

if /i "%PK%" EQU "*" set on=*
set NEXT=SHOP
if /i "%on%" NEQ "*" goto:%NEXT%
set name=KOREAN Photo Channel 1.1
set code1=00010002
set code2=4841594B
set version=3
set wadname=Photo-Channel-1.1-NUS-v3[K].wad
set md5=a3aa49e803fe297c0e23dd2d6a1467b3
goto:downloadstart

:SHOP

if /i "%S%" EQU "*" set on=*
set NEXT=SHOP_K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Shopping Channel (USA / PAL / JAP)
set code1=00010002
set code2=48414241
set version=19
set wadname=Shopping-Channel-NUS-v19.wad
set md5=70e5368e09e25bf01bd6ca7aa5a4eec0
goto:downloadstart

:SHOP_K

if /i "%SK%" EQU "*" set on=*
set NEXT=NET_U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=KOREAN Shopping Channel
set code1=00010002
set code2=4841424B
set version=19
set wadname=Shopping-Channel-NUS-v19[K].wad
set md5=f44c72e858ad057e811c8f34bba7b713
goto:downloadstart

:NET_U

if /i "%IU%" EQU "*" set on=*
set NEXT=NET_E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=USA Internet Channel
set code1=00010001
set code2=48414445
set version=*
set wadname=Opera-Internet-Channel-NUS[U].wad
set md5=434356a447bc01f10ea6a3289521d127
goto:downloadstart

:NET_E

if /i "%IE%" EQU "*" set on=*
set NEXT=NET_J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=PAL Internet Channel
set code1=00010001
set code2=48414450
set version=*
set wadname=Opera-Internet-Channel-NUS[E].wad
set md5=da20d4d1aedcd4dfa281423f2152ef6e
goto:downloadstart

:NET_J

if /i "%IJ%" EQU "*" set on=*
set NEXT=WEATHER_U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=JAP Internet Channel
set code1=00010001
set code2=4841444A
set version=*
set wadname=Opera-Internet-Channel-NUS[J].wad
set md5=2ed4f8ad0977a3073b8fdfbf76ef1ba8
goto:downloadstart

:WEATHER_U

if /i "%WU%" EQU "*" set on=*
set NEXT=WEATHER_E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=USA Weather Channel
set code1=00010002
set code2=48414645
set version=7
set wadname=Weather-Channel-NUS-v7[U].wad
set md5=3c6c857751770fdcf3a80facbbfe3be4
goto:downloadstart

:WEATHER_E

if /i "%WE%" EQU "*" set on=*
set NEXT=WEATHER_J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=PAL Weather Channel
set code1=00010002
set code2=48414650
set version=7
set wadname=Weather-Channel-NUS-v7[E].wad
set md5=56dd7a5a34cf4ee4ac222eb6bd01c0d9
goto:downloadstart

:WEATHER_J

if /i "%WJ%" EQU "*" set on=*
set NEXT=NEWS_U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=JAP Weather Channel
set code1=00010002
set code2=4841464A
set version=7
set wadname=Weather-Channel-NUS-v7[J].wad
set md5=c9f5ee197779910e71f9f554f7fa64ac
goto:downloadstart

:NEWS_U

if /i "%NU%" EQU "*" set on=*
set NEXT=NEWS_E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=USA NEWS Channel
set code1=00010002
set code2=48414745
set version=7
set wadname=NEWS-Channel-NUS-v7[U].wad
set md5=c9fff95d6a4ca9f04dcd1fe3b28cc83a
goto:downloadstart

:NEWS_E

if /i "%NE%" EQU "*" set on=*
set NEXT=NEWS_J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=PAL NEWS Channel
set code1=00010002
set code2=48414750
set version=7
set wadname=NEWS-Channel-NUS-v7[E].wad
set md5=11c713ff825f918bfe2c1065e5ab9827
goto:downloadstart

:NEWS_J

if /i "%NJ%" EQU "*" set on=*
set NEXT=SPEAK_U
if /i "%on%" NEQ "*" goto:%NEXT%
set name=JAP NEWS Channel
set code1=00010002
set code2=4841474A
set version=7
set wadname=NEWS-Channel-NUS-v7[J].wad
set md5=15dbd847c9f4b1df53cabe3fad57ad87
goto:downloadstart

:SPEAK_U

if /i "%WSU%" EQU "*" set on=*
set NEXT=SPEAK_E
if /i "%on%" NEQ "*" goto:%NEXT%
set name=USA Wii Speak Channel
set code1=00010001
set code2=48434645
set version=*
set wadname=Wii-Speak-Channel-NUS[U].wad
set md5=0c48ace121c73f1703e8790a494712bb
goto:downloadstart

:SPEAK_E

if /i "%WSE%" EQU "*" set on=*
set NEXT=SPEAK_J
if /i "%on%" NEQ "*" goto:%NEXT%
set name=PAL Wii Speak Channel
set code1=00010001
set code2=48434650
set version=*
set wadname=Wii-Speak-Channel-NUS[E].wad
set md5=77643094290097a2d237c78ba6e78df6
goto:downloadstart

:SPEAK_J

if /i "%WSJ%" EQU "*" set on=*
set NEXT=IOS9
if /i "%on%" NEQ "*" goto:%NEXT%
set name=JAP Wii Speak Channel
set code1=00010001
set code2=4843464A
set version=*
set wadname=Wii-Speak-Channel-NUS[J].wad
set md5=a686e2934045eff007a62760272208b8
goto:downloadstart

:IOS9

if /i "%IOS9%" EQU "*" set on=*
set NEXT=IOS12
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS9
set code1=00000001
set code2=00000009
set version=1034
set wadname=IOS9-64-v1034.wad
set md5=b81f3fe9912ac711b3e6423116420bc1
set category=ios
goto:downloadstart

:IOS12

if /i "%IOS12%" EQU "*" set on=*
set NEXT=IOS13
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS12
set code1=00000001
set code2=0000000C
set version=525
set wadname=IOS12-64-v525.wad
set md5=117829bec9bddf83292356a08be186bc
set category=ios
goto:downloadstart

:IOS13

if /i "%IOS13%" EQU "*" set on=*
set NEXT=IOS14
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS13
set code1=00000001
set code2=0000000D
set version=1031
set wadname=IOS13-64-v1031.wad
set md5=95173b01e0b7867c418145fdff8f0b45
set category=ios
goto:downloadstart

:IOS14

if /i "%IOS14%" EQU "*" set on=*
set NEXT=IOS15v257
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS14
set code1=00000001
set code2=0000000E
set version=1031
set wadname=IOS14-64-v1031.wad
set md5=be8660dc6a7dae37d79e8a5c7836ccc0
set category=ios
goto:downloadstart

:IOS15v257

if /i "%IOS15v257%" EQU "*" set on=*
set NEXT=IOS15
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS15 v257
set code1=00000001
set code2=0000000F
set version=257
set wadname=IOS15-64-v257.wad
set md5=4250eda3c9b11b1c184e494909926547
set category=ios
goto:downloadstart

:IOS15

if /i "%IOS15%" EQU "*" set on=*
set NEXT=IOS15v1031
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS15
set code1=00000001
set code2=0000000F
set version=523
set wadname=IOS15-64-v523.wad
set md5=4c1d940cdd9c05f2ceb7e74dbc5e1073
set category=ios
goto:downloadstart

:IOS15v1031
if /i "%IOS15v1031%" EQU "*" set on=*
set NEXT=IOS17
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS15 v1031
set code1=00000001
set code2=0000000F
set version=1031
set wadname=IOS15-64-v1031.wad
set md5=027938ec6e15f1b8f4c89f0fb4255a7f
set category=ios
goto:downloadstart


:IOS17

if /i "%IOS17%" EQU "*" set on=*
set NEXT=IOS21
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS17
set code1=00000001
set code2=00000011
set version=1031
set wadname=IOS17-64-v1031.wad
set md5=0ab4aa75fca871320988f4fa8a459062
set category=ios
goto:downloadstart

:IOS21

if /i "%IOS21%" EQU "*" set on=*
set NEXT=IOS22
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS21
set code1=00000001
set code2=00000015
set version=1038
set wadname=IOS21-64-v1038.wad
set md5=0707195ab1dc8d1c522962bee688d3ef
set category=ios
goto:downloadstart

:IOS22

if /i "%IOS22%" EQU "*" set on=*
set NEXT=IOS28
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS22
set code1=00000001
set code2=00000016
set version=1293
set wadname=IOS22-64-v1293.wad
set md5=d82e16702fe3371a8c41ba851d1dec2e
set category=ios
goto:downloadstart

:IOS28

if /i "%IOS28%" EQU "*" set on=*
set NEXT=IOS30
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS28
set code1=00000001
set code2=0000001C
set version=1806
set wadname=IOS28-64-v1806.wad
set md5=a305788950ce1433ecde2ee2d6573bb9
set category=ios
goto:downloadstart

:IOS30
if /i "%IOS30%" EQU "*" set on=*
set NEXT=IOS30P
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS30v2576 (3.2 System Menu IOS)
set code1=00000001
set code2=0000001E
set version=2576
set wadname=IOS30-64-v2576.wad
set md5=45d7945d08eb25dc167b6f30ab8a9a9d
set category=ios
goto:downloadstart

:IOS30P

if /i "%IOS30P%" EQU "*" set on=*
set NEXT=IOS31
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS30v2817(IOS30v2576[FS-ES-NP]) (patched 3.2 System Menu IOS for non-LU64+ Wii's)
set code1=00000001
set code2=0000001E
set version=2576
set wadname=IOS30v2817(IOS30v2576[FS-ES-NP]).wad
set md5=9ca28e4c3b5d2222deccc5a10e376ec7
set ciosslot=30
set ciosversion=2817
set category=patchios
goto:downloadstart

:IOS31

if /i "%IOS31%" EQU "*" set on=*
set NEXT=IOS33
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS31
set code1=00000001
set code2=0000001F
set version=3607
set wadname=IOS31-64-v3607.wad
set md5=ed3a6214c68c37db4c24a0dcadf53ff0
set category=ios
goto:downloadstart

:IOS33

if /i "%IOS33%" EQU "*" set on=*
set NEXT=IOS34
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS33
set code1=00000001
set code2=00000021
set version=3607
set wadname=IOS33-64-v3607.wad
set md5=9c51dbb1ff67c01030a8559521233e1f
set category=ios
goto:downloadstart

:IOS34

if /i "%IOS34%" EQU "*" set on=*
set NEXT=IOS35
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS34
set code1=00000001
set code2=00000022
set version=3607
set wadname=IOS34-64-v3607.wad
set md5=8778db1418f06971875e7ec7dafbdabd
set category=ios
goto:downloadstart

:IOS35

if /i "%IOS35%" EQU "*" set on=*
set NEXT=IOS36
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS35
set code1=00000001
set code2=00000023
set version=3607
set wadname=IOS35-64-v3607.wad
set md5=1c20b2d72254fb3a853a4fafe4a3f201
set category=ios
goto:downloadstart

:IOS36
if /i "%IOS36%" EQU "*" set on=*
set NEXT=IOS36v3607
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS36
set code1=00000001
set code2=00000024
set version=3351
set wadname=IOS36-64-v3351.wad
set md5=47ef27d46fc581c520f8215f39f11ecb
set category=ios
goto:downloadstart

:IOS36v3607
if /i "%IOS36v3607%" EQU "*" set on=*
set NEXT=IOS37
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS36v3607
set code1=00000001
set code2=00000024
set version=3607
set wadname=IOS36-64-v3607.wad
set md5=a02bc94736ab31c9f4f1f97a65c9137d
set category=ios
goto:downloadstart



:IOS37
if /i "%IOS37%" EQU "*" set on=*
set NEXT=IOS38
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS37
set code1=00000001
set code2=00000025
set version=5662
set wadname=IOS37-64-v5662.wad
set md5=8f905b7002e01fbb9950265ba2931d2c
set category=ios
goto:downloadstart

:IOS38

if /i "%IOS38%" EQU "*" set on=*
set NEXT=IOS41
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS38
set code1=00000001
set code2=00000026
set version=4123
set wadname=IOS38-64-v4123.wad
set md5=21c06e48bfe98012e28165c2c8261f46
set category=ios
goto:downloadstart

:IOS41

if /i "%IOS41%" EQU "*" set on=*
set NEXT=IOS41v3091
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS41
set code1=00000001
set code2=00000029
set version=3348
set wadname=IOS41-64-v3348.wad
set md5=bc20bfd2772a5d76d7ebc1e0852ee665
set category=ios
goto:downloadstart


:IOS41v3091

if /i "%IOS41v3091%" EQU "*" set on=*
set NEXT=IOS43
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS41v3091
set code1=00000001
set code2=00000029
set version=3091
set wadname=IOS41-64-v3091.wad
set md5=a601e7151155e1c7da580dbbc7b4f45e
set category=ios
goto:downloadstart


:IOS43

if /i "%IOS43%" EQU "*" set on=*
set NEXT=IOS45
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS43
set code1=00000001
set code2=0000002B
set version=3348
set wadname=IOS43-64-v3348.wad
set md5=56918919932d4e8892e545230354f7ef
set category=ios
goto:downloadstart

:IOS45

if /i "%IOS45%" EQU "*" set on=*
set NEXT=IOS46
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS45
set code1=00000001
set code2=0000002D
set version=3348
set wadname=IOS45-64-v3348.wad
set md5=6f07bf0b18ff1d72721a69105031de51
set category=ios
goto:downloadstart

:IOS46

if /i "%IOS46%" EQU "*" set on=*
set NEXT=IOS50P
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS46
set code1=00000001
set code2=0000002E
set version=3350
set wadname=IOS46-64-v3350.wad
set md5=786c2b7d65d5449add33b78d67629762
set category=ios
goto:downloadstart



:IOS50P

if /i "%IOS50P%" EQU "*" set on=*
set NEXT=IOS52P
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS50v5121(IOS50v4889[FS-ES-NP]) (patched 3.4 System Menu IOS that even works for LU64+ Wii's)
set code1=00000001
set code2=00000032
set version=4889
set wadname=IOS50v5121(IOS50v4889[FS-ES-NP]).wad
set md5=cdf6e98cdb8fef49ff83514c2a6d2c30
set ciosslot=50
set ciosversion=5121
set category=patchios
goto:downloadstart


:IOS52P

if /i "%IOS52P%" EQU "*" set on=*
set NEXT=IOS53
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS52v5889(IOS52v5661[FS-ES-NP]) (patched 3.5K System Menu IOS)
set code1=00000001
set code2=00000034
set version=5661
set wadname=IOS52v5889(IOS52v5661[FS-ES-NP]).wad
set md5=7a9ac41bff365877bc056c71620426c0
set ciosslot=52
set ciosversion=5889
set category=patchios
goto:downloadstart



:IOS53

if /i "%IOS53%" EQU "*" set on=*
set NEXT=IOS55
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS53
set code1=00000001
set code2=00000035
set version=5662
set wadname=IOS53-64-v5662.wad
set md5=b2440898e60eb457cc2113c217dd8946
set category=ios
goto:downloadstart

:IOS55

if /i "%IOS55%" EQU "*" set on=*
set NEXT=IOS56
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS55
set code1=00000001
set code2=00000037
set version=5662
set wadname=IOS55-64-v5662.wad
set md5=914ce492bbee80420f30c52b1a3172af
set category=ios
goto:downloadstart

:IOS56

if /i "%IOS56%" EQU "*" set on=*
set NEXT=IOS57
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS56
set code1=00000001
set code2=00000038
set version=5661
set wadname=IOS56-64-v5661.wad
set md5=1ab773dc324ccac079d9f544e4360ae9
set category=ios
goto:downloadstart

:IOS57

if /i "%IOS57%" EQU "*" set on=*
set NEXT=IOS202P57
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS57
set code1=00000001
set code2=00000039
set version=5918
set wadname=IOS57-64-v5918.wad
set md5=b3c387fbca8e16ef09466b903557321b
set category=ios
goto:downloadstart

:IOS202P57

if /i "%IOS202P57%" EQU "*" set on=*
set NEXT=IOS58
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS202v65535(IOS57v5918[FS-ES-NP]) (For SNEEK WiiMC Support)
set code1=00000001
set code2=00000039
set version=5918
set wadname=IOS202v65535(IOS57v5918[FS-ES-NP]).wad
set md5=9f1fd638f1d8b9c6c5b145392e043fef
set ciosslot=202
set ciosversion=65535
set category=patchios
goto:downloadstart

:IOS58

if /i "%IOS58%" EQU "*" set on=*
set NEXT=IOS60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS58
set code1=00000001
set code2=0000003A
set version=6175
set wadname=IOS58-64-v6175.wad
set md5=1c67427069e0a3781fae3be7df1e3fec
set category=ios
goto:downloadstart

:IOS60

if /i "%IOS60%" EQU "*" set on=*
set NEXT=IOS60P
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS60v6174 (4.1 System Menu IOS)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS60-64-v6174.wad
set md5=a8cfd7a77016227203639713db5ac34e
set category=ios
goto:downloadstart



:IOS60P

if /i "%IOS60P%" EQU "*" set on=*
set NEXT=IOS11P60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS60v6174[FS-ES-NP] (patched 4.1 System Menu IOS)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS60v6401(IOS60v6174[FS-ES-NP]).wad
set md5=67563398753c9d3a1cba696316afb283
set ciosslot=60
set ciosversion=6401
set category=patchios
goto:downloadstart


::IOS60 installed to a bunch of different SM IOS slots for brick protection
:IOS11P60

if /i "%IOS11P60%" EQU "*" set on=*
set NEXT=IOS20P60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS11v257(IOS60v6174[FS-ES-NP]) (patched 2.0-2.1 System Menu IOS that even works for LU64+ Wii's)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS11v257(IOS60v6174[FS-ES-NP]).wad
set md5=2146691f86fd2cc23ab085a48a9f456c
set ciosslot=11
set ciosversion=257
set category=patchios
goto:downloadstart



:IOS20P60

if /i "%IOS20P60%" EQU "*" set on=*
set NEXT=IOS30P60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS20v257(IOS60v6174[FS-ES-NP]) (patched 2.2 System Menu IOS that even works for LU64+ Wii's)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS20v257(IOS60v6174[FS-ES-NP]).wad
set md5=0edf328f8ea8ac566b48896ee5753d57
set ciosslot=20
set ciosversion=257
set category=patchios
goto:downloadstart



:IOS30P60

if /i "%IOS30P60%" EQU "*" set on=*
set NEXT=IOS40P60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS30v2817(IOS60v6174[FS-ES-NP]) (patched 3.2 System Menu IOS that even works for LU64+ Wii's)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS30v2817(IOS60v6174[FS-ES-NP]).wad
set md5=3484503ec75e9ff64d26d06049a90705
set ciosslot=30
set ciosversion=2817
set category=patchios
goto:downloadstart

:IOS40P60

if /i "%IOS40P60%" EQU "*" set on=*
set NEXT=IOS70K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS40v3073(IOS60v6174[FS-ES-NP]) (patched 3.3K System Menu IOS)
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS40v3073(IOS60v6174[FS-ES-NP]).wad
set md5=b47ef5112488d91a85a137e7c283e7b3
set ciosslot=40
set ciosversion=3073
set category=patchios
goto:downloadstart


:IOS70K

if /i "%IOS70K%" EQU "*" set on=*
set NEXT=IOS80K
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS70v54321(IOS60v6174[FS-ES-NP])-for Region Changed Korean Wii's
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS70v54321(IOS60v6174[FS-ES-NP]).wad
set md5=dce3dc7d32af4c6590a6d920e14cc96b
set ciosslot=70
set ciosversion=54321
set category=patchios
goto:downloadstart


:IOS80K

if /i "%IOS80K%" EQU "*" set on=*
set NEXT=IOS61
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS80v54321(IOS60v6174[FS-ES-NP])-for Region Changed Korean Wii's
set code1=00000001
set code2=0000003C
set version=6174
set wadname=IOS80v54321(IOS60v6174[FS-ES-NP]).wad
set md5=e57c4670df4d4699989b22547559b2d0
set ciosslot=80
set ciosversion=54321
set category=patchios
goto:downloadstart



:IOS61

if /i "%IOS61%" EQU "*" set on=*
set NEXT=IOS70
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS61
set code1=00000001
set code2=0000003D
set version=5661
set wadname=IOS61-64-v5661.wad
set md5=5c8deaef0fb0d0a8d5530a9cef21f4e5
set category=ios
goto:downloadstart


:IOS70

if /i "%IOS70%" EQU "*" set on=*
set NEXT=IOS70P
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS70v6687 (4.2 System Menu IOS)
set code1=00000001
set code2=00000046
set version=6687
set wadname=IOS70-64-v6687.wad
set md5=c38ff50344c00e17b7fe58c05d35a91c
set category=ios
goto:downloadstart



:IOS70P

if /i "%IOS70P%" EQU "*" set on=*
set NEXT=IOS80
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS70v6913(IOS70v6687[FS-ES-NP]) (patched 4.2 System Menu IOS)
set code1=00000001
set code2=00000046
set version=6687
set wadname=IOS70v6913(IOS70v6687[FS-ES-NP]).wad
::IOS70-64-v6687[FS-ES-NP].wad
set md5=8faafd4589916ab2514541ddc5cf98d3
set ciosslot=70
set ciosversion=6913
set category=patchios
goto:downloadstart





:IOS80

if /i "%IOS80%" EQU "*" set on=*
set NEXT=IOS80P
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS80v6943 (4.3 System Menu IOS)
set code1=00000001
set code2=00000050
set version=6943
set wadname=IOS80-64-v6943.wad
set md5=29993ed3b21035edd9334d0eaec8e52b
set category=ios
goto:downloadstart



:IOS80P

if /i "%IOS80P%" EQU "*" set on=*
set NEXT=M10
if /i "%on%" NEQ "*" goto:%NEXT%
set name=IOS80v6943[FS-ES-NP] (patched 4.3 System Menu IOS)
set code1=00000001
set code2=00000050
set version=6943
set wadname=IOS80-64-v6943[FS-ES-NP].wad
set md5=19d4cf2464c366915734b7a1f768d805
set ciosslot=80
set ciosversion=6943
set category=patchios
goto:downloadstart





:M10
if /i "%M10%" EQU "*" set on=*
set NEXT=NUSGRABBER0e
if /i "%on%" NEQ "*" goto:%NEXT%
set name=MIOSv10
set code1=00000001
set code2=00000101
set version=10
set wadname=RVL-mios-v10.wad
set md5=851c27dae82bc1c758be07fa964d17cb
set category=ios
goto:downloadstart


:NUSGRABBER0e

if /i "%A0e%" EQU "*" set on=*
set NEXT=NUSGRABBER0e_70
if /i "%on%" NEQ "*" goto:%NEXT%
set name=0000000e.app from IOS80 v6943 (SNEEK)
set code1=APP
::set code2=APP
set version=0e
set wadname=0000000e.app
set md5=4b3ad6d33707d55ec27583a84b2ecf2a
goto:downloadstart




:NUSGRABBER0e_70

if /i "%A0e_70%" EQU "*" set on=*
set NEXT=NUSGRABBER0e_60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=0000000e.app from IOS70 v6687 (SNEEK)
set code1=APP
::set code2=APP
set version=0e_70
set wadname=0000000e.app
set md5=7c3a8a690b6f701d2dcea082da1bd478
goto:downloadstart


:NUSGRABBER0e_60

if /i "%A0e_60%" EQU "*" set on=*
set NEXT=NUSGRABBER01
if /i "%on%" NEQ "*" goto:%NEXT%
set name=0000000e.app from IOS60 v6174 (SNEEK)
set code1=APP
::set code2=APP
set version=0e_60
set wadname=0000000e.app
set md5=ddaa661a6aac528c26217eda972a1787
goto:downloadstart

:NUSGRABBER01

if /i "%A01%" EQU "*" set on=*
set NEXT=NUSGRABBER01_70
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000001.app from IOS80 v6687 (SNEEK)
set code1=APP
::set code2=APP
set version=01
set wadname=00000001.app
set md5=89f7dc21f07e2cae97c3a571b23d8abd
goto:downloadstart

:NUSGRABBER01_70

if /i "%A01_70%" EQU "*" set on=*
set NEXT=NUSGRABBER01_60
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000001.app from IOS70 v6687 (SNEEK)
set code1=APP
::set code2=APP
set version=01_70
set wadname=00000001.app
set md5=89f7dc21f07e2cae97c3a571b23d8abd
goto:downloadstart


:NUSGRABBER01_60

if /i "%A01_60%" EQU "*" set on=*
set NEXT=NUSGRABBER40
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000001.app from IOS60 v6174 (SNEEK)
set code1=APP
::set code2=APP
set version=01_60
set wadname=00000001.app
set md5=48e1be8f767feb59cbc51aa4329d735a
goto:downloadstart



:NUSGRABBER40

if /i "%A40%" EQU "*" set on=*
set NEXT=NUSGRABBER42
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000040.app from System Menu 3.2J (for Mymenuify)
set code1=APP
::set code2=APP
set version=40
set wadname=00000040.app
set md5=c39e9edfc6df2264ce8ade4fd933f47f
goto:downloadstart

:NUSGRABBER42

if /i "%A42%" EQU "*" set on=*
set NEXT=NUSGRABBER45
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000042.app from System Menu 3.2U (for Mymenuify)
set code1=APP
::set code2=APP
set version=42
set wadname=00000042.app
set md5=9aae1917fdb8ba4d409664c230d89b27
goto:downloadstart

:NUSGRABBER45

if /i "%A45%" EQU "*" set on=*
set NEXT=NUSGRABBER70
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000045.app from System Menu 3.2E (for Mymenuify)
set code1=APP
::set code2=APP
set version=45
set wadname=00000045.app
set md5=500130276620408b47777355460193de
goto:downloadstart

:NUSGRABBER70

if /i "%A70%" EQU "*" set on=*
set NEXT=NUSGRABBER72
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000070.app from System Menu 4.0J (for Mymenuify)
set code1=APP
::set code2=APP
set version=70
set wadname=00000070.app
set md5=cc23b71d9246154f289644beee1b1682
goto:downloadstart

:NUSGRABBER72

if /i "%A72%" EQU "*" set on=*
set NEXT=NUSGRABBER75
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000072.app from System Menu 4.0U (for Mymenuify)
set code1=APP
::set code2=APP
set version=72
set wadname=00000072.app
set md5=611d8d5e1f7ce778ba4c44d1b4c2910b
goto:downloadstart

:NUSGRABBER75

if /i "%A75%" EQU "*" set on=*
set NEXT=NUSGRABBER78
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000075.app from System Menu 4.0E (for Mymenuify)
set code1=APP
::set code2=APP
set version=75
set wadname=00000075.app
set md5=a1d5703a4a2a5d764a12224d646c2849
goto:downloadstart

:NUSGRABBER78

if /i "%A78%" EQU "*" set on=*
set NEXT=NUSGRABBER7b
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000078.app from System Menu 4.1J (for Mymenuify)
set code1=APP
::set code2=APP
set version=78
set wadname=00000078.app
set md5=f2eadf12d18e793373060222b870057d
goto:downloadstart

:NUSGRABBER7b

if /i "%A7b%" EQU "*" set on=*
set NEXT=NUSGRABBER7e
if /i "%on%" NEQ "*" goto:%NEXT%
set name=0000007b.app from System Menu 4.1U (for Mymenuify)
set code1=APP
::set code2=APP
set version=7b
set wadname=0000007b.app
set md5=6b939de8222800733f4c44ae4eadb325
goto:downloadstart

:NUSGRABBER7e

if /i "%A7e%" EQU "*" set on=*
set NEXT=NUSGRABBER84
if /i "%on%" NEQ "*" goto:%NEXT%
set name=0000007e.app from System Menu 4.1E (for Mymenuify)
set code1=APP
::set code2=APP
set version=7e
set wadname=0000007e.app
set md5=574a3a144971ea0ec61bf8cef8d7ff80
goto:downloadstart

:NUSGRABBER84

if /i "%A84%" EQU "*" set on=*
set NEXT=NUSGRABBER87
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000084.app from System Menu 4.2J (for Mymenuify)
set code1=APP
::set code2=APP
set version=84
set wadname=00000084.app
set md5=b08998e582c48afba3a14f6d9e1e9373
goto:downloadstart

:NUSGRABBER87

if /i "%A87%" EQU "*" set on=*
set NEXT=NUSGRABBER8a
if /i "%on%" NEQ "*" goto:%NEXT%
set name=00000087.app from System Menu 4.2U (for Mymenuify)
set code1=APP
::set code2=APP
set version=87
set wadname=00000087.app
set md5=7079948c6aed8aae6009e4fdf27c7171
goto:downloadstart

:NUSGRABBER8a

if /i "%A8a%" EQU "*" set on=*
set NEXT=URLDownloadDB
if /i "%on%" NEQ "*" goto:%NEXT%
set name=0000008a.app from System Menu 4.2E (for Mymenuify)
set code1=APP
::set code2=APP
set version=8a
set wadname=0000008a.app
set md5=7e7994f78941afb51e9a20085deac305
goto:downloadstart


:URLDownloadDB

:BannerBomb1

if /i "%BB1%" EQU "*" set on=*
set NEXT=Bannerbomb2
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Bannerbomb v1 (compatible with Wii Menu version 3.0 - 4.1)
set code1=URL
set code2=http://bannerbomb.qoid.us/aads/aad1f_v108.zip
set version=bin
set dlname=aad1f_v108.zip
set wadname=BB1.zip
set md5=41d50b69c5763159afb35918c42cf320
set path1=private\wii\title\aktn\
goto:downloadstart

:BannerBomb2

if /i "%BB2%" EQU "*" set on=*
set NEXT=MMM
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Bannerbomb v2 (compatible with Wii Menu version 4.2)
set code1=URL
set code2=http://bannerbomb.qoid.us/abds/abd6a_v200.zip
set version=bin
set dlname=abd6a_v200.zip
set wadname=BB2.zip
set md5=d846f2c07c0a3be6fadca90dbb7356a7
set path1=private\wii\title\aktn\
goto:downloadstart


:mmm
if /i "%mmm%" EQU "*" set on=*
set NEXT=HackmiiInstaller
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Multi-Mod Manager (MMM) v13.2
set code1=URL
set code2="http://filetrip.net/f/11230-Multi-Mod-Manager_v13.2.zip"
set version=*
set dlname="11230-Multi-Mod-Manager_v13.2.zip"
set wadname=Multi-Mod-Manager_v13.2.zip
set filename=boot.dol
set md5=739192c45ee31b7db00eda671a775ffa
set path1=apps\mmm\
goto:downloadstart


:HackmiiInstaller
::NOTE-MMM must be before this in the list
if /i "%HM%" EQU "*" set on=*
set NEXT=Hermesv4
if /i "%on%" NEQ "*" goto:%NEXT%
set name=HackMii Installer
set code1=URL
::set code2="http://bootmii.org/download/"
set code2="http://bootmii.org/download/"
set version=elf
::set dlname=
set wadname=hackmii_installer.zip
set filename=boot.dol
set path1=
set md5=8dcada755a608c70ed171ced7f9ef2f3
goto:downloadstart

:Hermesv4

if /i "%h4%" EQU "*" set on=*
set NEXT=Hermesv5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Hermes cIOS v4 Installer
set code1=URL
set code2=http://filetrip.net/d8367-hermes-cIOS-222223202-installer-4.html
set version=*
set dlname=8367-Hermes_cIOS_222_rev4_installer.zip
set wadname=Hermes_cIOS_v4.zip
set filename=boot.dol
set md5=a1c4a81802da20cf8990d03ebd3b3218
set path1=apps\cios_installer_v4\
goto:downloadstart

:Hermesv5
if /i "%h5%" EQU "*" set on=*
set NEXT=Hermesv51
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Hermes cIOS v5 Installer
set code1=URL
set code2=http://filetrip.net/d9681-hermes-cIOS-Installer-5.html
set version=*
set dlname=9681-cIOS222rev5_installer.zip
set wadname=Hermes_cIOS_v5.zip
set filename=boot.dol
set md5=030a2aba6e0297080ecdfc7f7a6ba2d7
set path1=apps\cios_installer_v5\
goto:downloadstart



:Hermesv51
if /i "%h51%" EQU "*" set on=*
set NEXT=waninv17
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Hermes cIOS v5.1 Installer
set code1=URL
set code2="http://nusad.googlecode.com/files/cios_installer_v5.1.zip"
set version=*
set dlname="cios_installer_v5.1.zip"
set wadname=cios_installer_v5.1.zip
set filename=boot.dol
set md5=077ac9cdffbea1155dc4bb4fb4cff6b3
set path1=apps\cios_installer_v5.1\
goto:downloadstart


:waninv17
if /i "%w17%" EQU "*" set on=*
set NEXT=waninv19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Waninkokos cIOS v17 Installer
set code1=URL
set code2=http://filetrip.net/d9426-cIOS-Installer-38r17.html
set version=*
set dlname=9426-cIOS38r17-Installer.zip
set wadname=cIOS38_v17.zip
set filename=boot.dol
set md5=b29a490968c12dc5476bb85abf8dd750
set path1=apps\cIOS38_rev17-Installer\
goto:downloadstart

:waninv19
if /i "%w19%" EQU "*" set on=*
set NEXT=waninv20
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Waninkokos cIOS v19 Installer
set code1=URL
set code2=http://filetrip.net/d9911-cIOS-Installer-Xr19.html
set version=*
set dlname=9911-cIOSXrev19-Installer.zip
set wadname=cIOSX_v19.zip
set filename=boot.dol
set md5=2d678c3d4e7ea5c55a4a00472abb7421
set path1=apps\cIOSx_rev19-Installer\
goto:downloadstart


:waninv20
if /i "%w20%" EQU "*" set on=*
set NEXT=TBR113
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Waninkokos cIOS v20b Installer
set code1=URL
set code2=http://filetrip.net/d12411-cIOS-Installer-Xr20b.html
set version=*
set dlname=12411-cIOSX_rev20b-Installer.zip
set wadname=cIOSX_v20b.zip
set filename=boot.dol
set md5=ea5e2e4ba67b7612be4ab9fa00b96ba0
set path1=apps\cIOSx_rev20b-Installer\
goto:downloadstart


:TBR113
if /i "%TBR%" EQU "*" set on=*
set NEXT=pwns
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Trucha Bug Restorer (TBR) v1.13
set code1=URL
set code2=http://nusad.googlecode.com/files/TBR1.13.zip
set version=*
set dlname=TBR1.13.zip
set wadname=TBR1.13.zip
set filename=boot.dol
set md5=66296682ddd7233431ced92f8636ab0b
set path1=apps\TBR\
goto:downloadstart

:pwns
if /i "%pwns%" EQU "*" set on=*
set NEXT=Twi
if /i "%on%" NEQ "*" goto:%NEXT%
set category=fullextract
set name=Indiana Pwns
set code1=URL
set code2="http://static.hackmii.com/indiana-pwns.zip"
set version=*
set dlname="indiana-pwns.zip"
set wadname=indiana-pwns.zip
set filename=data.bin
set md5=a6b8f03f49baa471228dcd81d3fd623a
set path1=private\wii\title\rlip\
goto:downloadstart

:Twi
if /i "%Twi%" EQU "*" set on=*
set NEXT=smash
if /i "%on%" NEQ "*" goto:%NEXT%
set category=fullextract
set name=Twilight Hack v0.1 Beta1 (for Wii's 3.3 and below)
set code1=URL
set code2="http://hbc.hackmii.com/get.php?file=twilight-hack-v0.1-beta1.zip"
set version=*
set dlname="twilight-hack-v0.1-beta1.zip"
set wadname=twilight-hack-v0.1-beta1.zip
set filename=data.bin
set md5=704bd625ea5b42d7ac06fc937af74d38
set path1=private\wii\title\rzdp\
goto:downloadstart



:smash
if /i "%smash%" EQU "*" set on=*
set NEXT=dopmii
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Smash Stack (USA)
set category=fullextract
set code1=URL
set code2="http://wiibrew.org/w/images/4/4e/Smashstack.zip"
set version=*
set dlname="Smashstack.zip"
set wadname=Smashstack.zip
set filename=st_080805_0933.bin
set md5=aa93aab9bfdd25883bbd826a62645033
set path1=private\wii\app\rsbe\st\
goto:downloadstart

:dopmii
if /i "%dop%" EQU "*" set on=*
set NEXT=locked
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Dop-Mii v13
set category=fullextract
set code1=URL
set code2="http://dop-mii.googlecode.com/files/DOP-Mii v13.zip"
set version=*
set dlname="DOP-Mii v13.zip"
set wadname=DOP-Mii_v13.zip
set filename=boot.dol
set md5=7cbd40d4987d17d85d4184bafc886c1c
set path1=apps\DOP-Mii\
goto:downloadstart



:locked
if /i "%locked%" EQU "*" set on=*
set NEXT=AccioHacks
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Locked Apps Folder for HBC (PASS=UDLRAB)
set category=fullextract
set code1=URL
set code2="http://nusad.googlecode.com/files/LockedApps(Categorii).zip"
set version=*
set dlname="LockedApps(Categorii).zip"
set wadname=LockedApps(Categorii).zip
set filename=boot.dol
set md5=6f277fd19e359db7d6f84dbad1076a29
set path1=apps\_apps_locked\
goto:downloadstart

:AccioHacks
if /i "%AccioHacks%" EQU "*" set on=*
set NEXT=bootmiisd
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Accio Hacks
set code1=URL
set code2=http://geckocodes.org/AH.php?dl
set version=*
set dlname="AH.php@dl"
set wadname=AccioHacks.zip
set filename=boot.dol
set md5=842507bb33184ac96bb093ceb6cd8826
set path1=apps\AccioHacks\
goto:downloadstart



:bootmiisd
if /i "%bootmiisd%" EQU "*" set on=*
set NEXT=neogamma
if /i "%on%" NEQ "*" goto:%NEXT%
set name=BootMii SD Files
set category=fullextract
set code1=URL
set code2="http://static.hackmii.com/bootmii_sd_files.zip"
set version=*
set dlname="bootmii_sd_files.zip"
set wadname=bootmii_sd_files.zip
set filename=ppcboot.elf
set md5=4b2ac026e3b08a588a340841244f4e98
set path1=bootmii\
goto:downloadstart

::--------Manual Update File-----
:neogamma
if /i "%neogamma%" EQU "*" set on=*
set NEXT=yawm
if /i "%on%" NEQ "*" goto:%NEXT%
set category=ManualUpdate
set name=Neogamma Backup Disc Loader (most recent release)
set version=txt
set code2="http://filetrip.net/h25123270-NeoGamma.html"
set wadname="*-NeoGammaR9*.zip"
set updateurl=http://nusad.googlecode.com/files/ManualUpdate.txt
set path1=apps\neogamma
goto:downloadstart

::--------Manual Update File-----
:yawm
if /i "%yawm%" EQU "*" set on=*
set NEXT=loadmii
if /i "%on%" NEQ "*" goto:%NEXT%
set category=ManualUpdate
set name=Yet Another Wad Manager Mod
set code2="http://yawmm.googlecode.com/files/YAWMM.zip"
set updateurl=http://nusad.googlecode.com/files/ManualUpdate.txt
set version=*
set wadname=yawmm.zip
set path1=apps\yawmm
goto:downloadstart



:loadmii
if /i "%loadmii%" EQU "*" set on=*
set NEXT=cfg249
if /i "%on%" NEQ "*" goto:%NEXT%
set name=LoadMii v0.3 Twilight Hack
set code1=URL
set code2="http://loadmii.googlecode.com/files/loadMii_0.3_twilightHack.zip"
set version=*
set dlname="loadMii_0.3_twilightHack.zip"
set wadname=loadMii_0.3_twilightHack.zip
set filename1=loader.elf
set filename=boot.elf
set md5=715ae195012c6ce69ae7196a58922df6
set path1=apps\loadmii\
goto:downloadstart



:cfg249
if /i "%cfg249%" EQU "*" set on=*
set NEXT=cfg222
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Configurable USB Loader (Most recent 249 version)
set category=cfg
goto:downloadstart

:cfg222
if /i "%cfg222%" EQU "*" set on=*
set NEXT=usbfolder
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Configurable USB Loader (Most recent 222 version)
set category=cfg
goto:downloadstart

:usbfolder
if /i "%usbfolder%" EQU "*" set on=*
set NEXT=cfgr
if /i "%on%" NEQ "*" goto:%NEXT%
set name=USB-Loader Folder
set category=cfg
goto:downloadstart

:cfgr
if /i "%cfgr%" EQU "*" set on=*
set NEXT=CheatCodes
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Configurator for Configurable USB Loader (Most recent version)
set category=cfgr
goto:downloadstart

:CheatCodes
if /i "%CheatCodes%" EQU "*" set on=*
set NEXT=WBM
if /i "%on%" NEQ "*" goto:%NEXT%
set name=%cheatregion% Region Cheat Codes: txtcodes from geckocodes.org
set category=CHEATS
goto:downloadstart


:WBM
if /i "%WBM%" EQU "*" set on=*
set NEXT=USBX
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Wii Backup Manager v0.3.5 beta1
set code1=ZIP
set code2="http://www.filetrip.net/d11959-Wii-Backup-Manager-0-3-5b1.html"
set version=*
set dlname=11959-WiiBackupManager0.3.5-beta1.zip
set wadname=WiiBackupManager.exe
set md5=7ce1f1fbd21e140784a2f7f4cca893d9
set category=EXE
set path1=WiiBackupManager0.3.5-beta1
goto:downloadstart

:USBX
if /i "%USBX%" EQU "*" set on=*
set NEXT=F32
if /i "%on%" NEQ "*" goto:%NEXT%
set name=USB-Loader Forwarder Channel
set code1=ZIP
set code2="http://nusad.googlecode.com/files/usbloader(s)-(emulators)-IDCL.zip"
set version=*
set dlname=usbloader(s)-(emulators)-IDCL.zip
set wadname=usbloader(s)-(emulators)-IDCL.wad
set md5=ffc88e71d10e92660f5b4a02088156b7
set category=CWAD
set path1=WAD
goto:downloadstart

:F32
if /i "%F32%" EQU "*" set on=*
set NEXT=WIIMC
if /i "%on%" NEQ "*" goto:%NEXT%
set name=FAT32 GUI Formatter
set code1=NOTZIP
set code2="http://nusad.googlecode.com/files/FAT32_GUI_Formatter.exe"
set version=*
set dlname=FAT32_GUI_Formatter.exe
set wadname=FAT32_GUI_Formatter.exe
set md5=daf2d9aa422c3d065c6f4e8823644944
set category=EXE
set path1=FAT32_GUI_Formatter
goto:downloadstart


::TANTRIC APPS!!!!

:WIIMC
if /i "%WiiMC%" EQU "*" set on=*
set NEXT=fceugx
if /i "%on%" NEQ "*" goto:%NEXT%
set name=WiiMC - Media Player (Most Recent Release)
set category=TANTRIC
set path1=apps\WiiMC\
set updateurl=http://wiimc.googlecode.com/svn/trunk/update.xml
set code1=http://wiimc.googlecode.com/files/WiiMC 
set code2= (New Install).zip
set zip1=WiiMC 
set zip2= (New Install).zip
::set version=*
goto:downloadstart

:fceugx
if /i "%fceugx%" EQU "*" set on=*
set NEXT=snes9xgx
if /i "%on%" NEQ "*" goto:%NEXT%
set name=FCEUGX - NES Emulator for the Wii (Most Recent Release)
set category=TANTRIC
set path1=apps\fceugx\
set updateurl=http://fceugc.googlecode.com/svn/trunk/update.xml
set code1=http://fceugc.googlecode.com/files/FCE Ultra GX 
set code2=.zip
set zip1=FCE Ultra GX 
set zip2=.zip
::set version=*
goto:downloadstart

:snes9xgx
if /i "%snes9xgx%" EQU "*" set on=*
set NEXT=vbagx
if /i "%on%" NEQ "*" goto:%NEXT%
set name=SNES9xGX - SNES Emulator for the Wii (Most Recent Release)
set category=TANTRIC
set path1=apps\snes9xgx\
set updateurl=http://snes9x-gx.googlecode.com/svn/trunk/update.xml
set code1=http://snes9x-gx.googlecode.com/files/Snes9x GX 
set code2=.zip
set zip1=Snes9x GX 
set zip2=.zip
::set version=*
goto:downloadstart

:vbagx
if /i "%vbagx%" EQU "*" set on=*
set NEXT=SGM
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Visual Boy Advance GX - GB/GBA Emulator for the Wii (Most Recent Release)
set category=TANTRIC
set path1=apps\vbagx\
set updateurl=http://vba-wii.googlecode.com/svn/trunk/update.xml
set code1=http://vba-wii.googlecode.com/files/Visual Boy Advance GX 
set code2=.zip
set zip1=Visual Boy Advance GX 
set zip2=.zip
::set version=*
goto:downloadstart


:SGM
if /i "%SGM%" EQU "*" set on=*
set NEXT=WIIX
if /i "%on%" NEQ "*" goto:%NEXT%
set name=SaveGame Manager GX (Most Recent Release)
set category=GOOGLEUPDATE
set path1=apps\SaveGameManagerGX\
set updateurl="http://code.google.com/p/savegame-manager-gx/downloads/list?can=2&q=dol+-forwarder&colspec=Filename+Summary+Uploaded+Size+DownloadCount"
set updatedlname="list@can=2&q=dol+-forwarder&colspec=Filename+Summary+Uploaded+Size+DownloadCount"
set code1="http://savegame-manager-gx.googlecode.com/files/R"
set code2=.dol
set iconurl="http://savegame-manager-gx.googlecode.com/svn/trunk/HBC/icon.png"
set metaurl="http://savegame-manager-gx.googlecode.com/svn/trunk/HBC/meta.xml"
set wadname1=R
set wadname2=.dol
::set zip1=Visual Boy Advance GX 
::set zip2=.zip
goto:downloadstart

:WIIX
if /i "%WIIX%" EQU "*" set on=*
set NEXT=HBB
if /i "%on%" NEQ "*" goto:%NEXT%
set name=WiiXplorer (Most Recent Release)
set category=GOOGLEUPDATE
set path1=apps\WiiXplorer\
set updateurl="http://code.google.com/p/wiixplorer/downloads/list?can=3&q=dol&colspec=Filename+Summary+Uploaded+Size+DownloadCount+UploadedBy"
set updatedlname="list@can=3&q=dol&colspec=Filename+Summary+Uploaded+Size+DownloadCount+UploadedBy"
set code1="http://wiixplorer.googlecode.com/files/R"
set code2=.dol
set iconurl="http://wiixplorer.googlecode.com/svn/trunk/HBC/icon.png"
set metaurl="http://wiixplorer.googlecode.com/svn/trunk/HBC/meta.xml"
::will eventually need to be changed to "set wadname1=R" after R100
set wadname1=R
set wadname2=.dol
::set zip1=Visual Boy Advance GX 
::set zip2=.zip
goto:downloadstart


:HBB
if /i "%HBB%" EQU "*" set on=*
set NEXT=WII64
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Homebrew Browser v0.3.8
set category=fullextract
set code1=URL
set code2="http://www.codemii.com/wiihomebrew/homebrew_browser_v0.3.8.zip"
set version=*
set dlname="homebrew_browser_v0.3.8.zip"
set wadname=homebrew_browser_v0.3.8.zip
set filename=boot.dol
set md5=d710ca71979e1e30aa7a490e0f3afe03
set path1=apps\homebrew_browser\
goto:downloadstart


:WII64
if /i "%WII64%" EQU "*" set on=*
set NEXT=WIISX
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Wii64 beta1.1 (N64 Emulator)
set category=fullextract
set code1=URL
set code2="http://mupen64gc.googlecode.com/files/wii64-beta1.1.zip"
set version=*
set dlname="wii64-beta1.1.zip"
set wadname=wii64-beta1.1.zip
set filename=boot.dol
set md5=630dbc8b8a5be6527b76d49b65c47f23
set path1=apps\wii64\
goto:downloadstart

:WIISX
if /i "%WIISX%" EQU "*" set on=*
set NEXT=Priiloader
if /i "%on%" NEQ "*" goto:%NEXT%
set name=WiiSX beta2.1 (Playstation 1 Emulator)
set category=fullextract
set code1=URL
set code2="http://pcsxgc.googlecode.com/files/WiiSX-beta2.1.zip"
set version=*
set dlname="WiiSX-beta2.1.zip"
set wadname=WiiSX-beta2.1.zip
set filename=boot.dol
set md5=9c245a7bcfd7b2f99ac9f01712736d43
set path1=apps\wiiSX\
goto:downloadstart


:Priiloader
if /i "%Pri%" EQU "*" set on=*
set NEXT=PriiHacks
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Priiloader v0.4
set code1=URL
set code2="http://priiloader.googlecode.com/files/Priiloader_v0_4.zip"
set version=*
set dlname=Priiloader_v0_4.zip
set wadname=Priiloader_v0_4.zip
set filename=boot.dol
set md5=30ea349eeb532229a73529b40ca60be5
set path1=apps\Priiloader\
goto:downloadstart

:PriiHacks
if /i "%HAX%" EQU "*" set on=*
set NEXT=cMIOSrev5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=Priiloader Hacks
set code1=URL
set code2="http://nusad.googlecode.com/files/PriiloaderHacks.zip"
set version=ini
set dlname="PriiloaderHacks.zip"
set wadname=PriiloaderHacks.zip
set md5=adeb7f5f6758ed4f866bd180b2180ed2
set path1=
goto:downloadstart

:cMIOSrev5
if /i "%CM5%" EQU "*" set on=*
set NEXT=MIOSPatcher
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cMIOS rev5 Installer
set code1=URL
set code2="http://nusad.googlecode.com/files/cMIOS_rev5-Installer.zip"
set version=*
set dlname="cMIOS_rev5-Installer.zip"
set wadname=cMIOS_rev5-Installer.zip
set filename=boot.dol
set md5=1c436e8134d750299138a19a433a45a6
set path1=apps\cMIOS_rev5-Installer\
goto:downloadstart


:MIOSPatcher
if /i "%MP%" EQU "*" set on=*
set NEXT=CIOSDATABASE
if /i "%on%" NEQ "*" goto:%NEXT%
set name=MIOS Patcher 0.2
set code1=URL
set code2="http://filetrip.net/d8368-MIOS-Patcher-0-2.html"
set version=*
set dlname=8368-MIOSPatcher.zip
set wadname=MIOSPatcher0.2.zip
set filename=boot.dol
set md5=f2e5b95e246528488a3556608ddae217
set path1=apps\MIOSPatcher\
goto:downloadstart



::---------------------cIOSs----------------------
:CIOSDATABASE

:cIOS222[38]-v4

if /i "%cIOS222[38]-v4%" EQU "*" set on=*
set NEXT=cIOS223[37-38]-v4
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS222[38]-v4
set wadname=cIOS222[38]-v4
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS222[38]-v4.diff
set md5=cb22f1e2b7490514d714a8bd6c4d31e6
set basewad=IOS38-64-v3610
set md5base=7fa5aa3ee9fbb041b69a190928029b29
set code1=00000001
set code2=00000026
set version=3610

set basecios=cIOS222[38]-v4
set code2new=000000de
set lastbasemodule=0000000e

goto:downloadstart




:cIOS223[37-38]-v4

if /i "%cIOS223[37-38]-v4%" EQU "*" set on=*
set NEXT=cIOS222[38]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS223[37-38]-v4
set wadname=cIOS223[37-38]-v4
set ciosslot=unchanged
set ciosversion=
set md5=990272c4d04566df668df994d7b06647

set basewad=IOS37-64-v3612
set md5base=8af99fa502a5035e77fc80835e91faaa
set code1=00000001
set code2=00000025
set version=3612

set basewadb=IOS38-64-v3610
set md5baseb=7fa5aa3ee9fbb041b69a190928029b29
set code1b=00000001
set code2b=00000026
set versionb=3610

set basecios=cIOS223[37-38]-v4
set code2new=000000df
set lastbasemodule=0000000e

goto:downloadstart








::HERMES V5 BASE 38
:cIOS222[38]-v5
if /i "%cIOS222[38]-v5%" EQU "*" set on=*
set NEXT=cIOS202[38]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS222[38]-v5
set wadname=cIOS222[38]-v5
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS222[38]-v5.diff
set md5=1946fa59e0a851f54c10988b04ce3928
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set code1=00000001
set code2=00000026
set version=3867

set basecios=cIOS222[38]-v5
set code2new=000000de
set lastbasemodule=0000000e

goto:downloadstart


:cIOS202[38]-v5
if /i "%cIOS202[38]-v5%" EQU "*" set on=*
set NEXT=cIOS223[37]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS202[38]-v5
set wadname=cIOS202[38]-v5
set ciosslot=202
set ciosversion=65535
::set diffname=cIOS222[38]-v5.diff
set md5=da71c2ee634884c7ac00d741921b1ef0
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set code1=00000001
set code2=00000026
set version=3867

set basecios=cIOS222[38]-v5
set code2new=000000de
set lastbasemodule=0000000e

goto:downloadstart


::HERMES V5 BASE 37
:cIOS223[37]-v5

if /i "%cIOS223[37]-v5%" EQU "*" set on=*
set NEXT=cIOS202[37]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS223[37]-v5
set wadname=cIOS223[37]-v5
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS223[37]-v5.diff
set md5=79d7ca910b719b4134d90b9d9912462c
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set code1=00000001
set code2=00000025
set version=3869

set basecios=cIOS223[37]-v5
set code2new=000000df
set lastbasemodule=0000000e

goto:downloadstart

:cIOS202[37]-v5
if /i "%cIOS202[37]-v5%" EQU "*" set on=*
set NEXT=cIOS224[37]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS202[37]-v5
set wadname=cIOS202[37]-v5
set ciosslot=202
set ciosversion=65535
::set diffname=cIOS223[37]-v5.diff
set md5=c213009e23c9ff87dd53d0cf7920819b
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set code1=00000001
set code2=00000025
set version=3869

set basecios=cIOS223[37]-v5
set code2new=000000df
set lastbasemodule=0000000e

goto:downloadstart

:cIOS224[37]-v5
if /i "%cIOS224[37]-v5%" EQU "*" set on=*
set NEXT=cIOS224[57]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS224[37]-v5
set wadname=cIOS224[37]-v5
set ciosslot=224
set ciosversion=65535
::set diffname=cIOS223[37]-v5.diff
set md5=7f7c8928156240f547a7ef87a59b049e
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set code1=00000001
set code2=00000025
set version=3869

set basecios=cIOS223[37]-v5
set code2new=000000df
set lastbasemodule=0000000e

goto:downloadstart


::HERMES V5 BASE 57

:cIOS224[57]-v5
if /i "%cIOS224[57]-v5%" EQU "*" set on=*
set NEXT=cIOS202[57]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS224[57]-v5
set wadname=cIOS224[57]-v5
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS224[57]-v5.diff
set md5=0b4bf426a9a682e3899b8590ca701e0f
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set code1=00000001
set code2=00000039
set version=5661

set basecios=cIOS224[57]-v5
set code2new=000000e0
set lastbasemodule=00000012

goto:downloadstart


:cIOS202[57]-v5
if /i "%cIOS202[57]-v5%" EQU "*" set on=*
set NEXT=cIOS223[57]-v5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS202[57]-v5
set wadname=cIOS202[57]-v5
set ciosslot=202
set ciosversion=65535
::set diffname=cIOS224[57]-v5.diff
set md5=dfe18d152c3cca198d69110cba740091
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set code1=00000001
set code2=00000039
set version=5661

set basecios=cIOS224[57]-v5
set code2new=000000e0
set lastbasemodule=00000012

goto:downloadstart


:cIOS223[57]-v5
if /i "%cIOS223[57]-v5%" EQU "*" set on=*
set NEXT=cIOS249-v17b
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS223[57]-v5
set wadname=cIOS223[57]-v5
set ciosslot=223
set ciosversion=65535
::set diffname=cIOS224[57]-v5.diff
set md5=8aff8481db05f5ce91274d542ce2711f
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set code1=00000001
set code2=00000039
set version=5661

set basecios=cIOS224[57]-v5
set code2new=000000e0
set lastbasemodule=00000012

goto:downloadstart


::WANIN'S V17B BASE 38

:cIOS249-v17b

if /i "%cIOS249-v17b%" EQU "*" set on=*
set NEXT=cIOS250-v17b
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS249-v17b
set wadname=cIOS249-v17b
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS249-v17b.diff
set md5=9f410814c921880507ddcf3824f9f873
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set code1=00000001
set code2=00000026
set version=3867

set basecios=cIOS249-v17b
set code2new=000000f9
set lastbasemodule=0000000e

goto:downloadstart


:cIOS250-v17b
if /i "%cIOS250-v17b%" EQU "*" set on=*
set NEXT=cIOS249[37]-v19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS250-v17b
set wadname=cIOS250-v17b
set ciosslot=250
set ciosversion=65535
::set diffname=cIOS249-v17b.diff
set md5=7119e3c0fff48ecd9aa747d1d4319207
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS249-v17b
set code2new=000000f9
set lastbasemodule=0000000e
goto:downloadstart



::WANIN'S V19 BASE 37
:cIOS249[37]-v19

if /i "%cIOS249[37]-v19%" EQU "*" set on=*
set NEXT=cIOS250[37]-v19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS249[37]-v19
set wadname=cIOS249[37]-v19
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS249[37]-v19.diff
set md5=816b9ba664e19548f1d6af5661019d8e
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set code1=00000001
set code2=00000025
set version=3869

set basecios=cIOS249[37]-v19
set code2new=000000f9
set lastbasemodule=0000000e

goto:downloadstart


:cIOS250[37]-v19
if /i "%cIOS250[37]-v19%" EQU "*" set on=*
set NEXT=cIOS249[38]-v19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS250[37]-v19
set wadname=cIOS250[37]-v19
set ciosslot=250
set ciosversion=65535
::set diffname=cIOS249[37]-v19.diff
set md5=405c509051f6a2a441ce92572b256822
set basewad=IOS37-64-v3869
set md5base=5f4295741efab0d919e491b7151d5ed3
set code1=00000001
set code2=00000025
set version=3869
set basecios=cIOS249[37]-v19
set code2new=000000f9
set lastbasemodule=0000000e
goto:downloadstart



::WANIN'S V19 BASE 38
:cIOS249[38]-v19

if /i "%cIOS249[38]-v19%" EQU "*" set on=*
set NEXT=cIOS250[38]-v19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS249[38]-v19
set wadname=cIOS249[38]-v19
set ciosslot=unchanged
set ciosversion=
::set diffname=cIOS249[38]-v19.diff
set md5=1242d269a650cd0a899f3dd1391b480f
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set code1=00000001
set code2=00000026
set version=3867

set basecios=cIOS249[38]-v19
set code2new=000000f9
set lastbasemodule=0000000e

goto:downloadstart


:cIOS250[38]-v19
if /i "%cIOS250[38]-v19%" EQU "*" set on=*
set NEXT=cIOS249[57]-v19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS250[38]-v19
set wadname=cIOS250[38]-v19
set ciosslot=250
set ciosversion=65535
::set diffname=cIOS249[38]-v19.diff
set md5=2dba40263fb96c47a82b3ed8e060a4f0
set basewad=IOS38-64-v3867
set md5base=394298e4c9ff287e69020f2405423eb4
set code1=00000001
set code2=00000026
set version=3867
set basecios=cIOS249[38]-v19
set code2new=000000f9
set lastbasemodule=0000000e
goto:downloadstart


::WANIN'S V19 BASE 57
:cIOS249[57]-v19

if /i "%cIOS249[57]-v19%" EQU "*" set on=*
set NEXT=cIOS250[57]-v19
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS249[57]-v19
set wadname=cIOS249[57]-v19
set ciosslot=unchanged
set ciosversion=

::set diffname=cIOS249[57]-v19.diff
set md5=f50ac643ce9f31a888a1b147ee0dff69
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set basecios=cIOS249[57]-v19
set code1=00000001
set code2=00000039
set version=5661

set code2new=000000f9
set lastbasemodule=00000012

goto:downloadstart


:cIOS250[57]-v19

if /i "%cIOS250[57]-v19%" EQU "*" set on=*
set NEXT=RVL-cmios-v4_WiiGator_GCBL_v0.2
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cIOS250[57]-v19
set wadname=cIOS250[57]-v19
set ciosslot=250
set ciosversion=65535
::set diffname=cIOS249[57]-v19.diff
set md5=7a010f14c6c3d0638c99ff54343d57bd
set basewad=IOS57-64-v5661
set md5base=ba50f0d46290d74d020f0afa58811e2e
set basecios=cIOS249[57]-v19
set code1=00000001
set code2=00000039
set version=5661

set code2new=000000f9
set lastbasemodule=00000012

goto:downloadstart


::------------------CMIOSs--------------------
::MIOS PATCHER V0.2 BASE MIOSV4
:RVL-cmios-v4_WiiGator_GCBL_v0.2

if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" set on=*
set NEXT=RVL-cmios-v4_Waninkoko_rev5
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cMIOS-v4 WiiGator GCBL v0.2
set wadname=RVL-cmios-v4_WiiGator_GCBL_v0.2
set ciosslot=unchanged
set ciosversion=
::set diffname=RVL-cmios-v4_WiiGator_GCBL_v0.2.diff
set md5=3ea68908f6fdea52de2a2a2561074660
set basewad=RVL-mios-v4
set md5base=60502dbd092d941cf627ac6db95a35cf
set code1=00000001
set code2=00000101
set version=4

set basecios=RVL-cmios-v4_WiiGator_GCBL_v0.2
set code2new=00000101

goto:downloadstart


::WANINS CMIOS REV5 BASE MIOSV4
:RVL-cmios-v4_Waninkoko_rev5

if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" set on=*
set NEXT=Finish
if /i "%on%" NEQ "*" goto:%NEXT%
set name=cMIOS-v4 Waninkoko rev5
set wadname=RVL-cmios-v4_Waninkoko_rev5
set ciosslot=unchanged
set ciosversion=
::set diffname=RVL-cmios-v4_Waninkoko_rev5.diff
set md5=c392d59f10fbd9f3f3f2ad405c43464a
set basewad=RVL-mios-v4
set md5base=60502dbd092d941cf627ac6db95a35cf
set code1=00000001
set code2=00000101
set version=4

set basecios=RVL-cmios-v4_Waninkoko_rev5
set code2new=00000101

goto:downloadstart


::.................................Global Database....................................... 
:GLOBALDB
if exist "%DRIVE%\Global_Log.md5" del "%DRIVE%\Global_Log.md5"


::APPS
if exist "%DRIVE%"\apps\cIOS38_rev17-Installer\boot.dol echo b29a490968c12dc5476bb85abf8dd750 *apps\cIOS38_rev17-Installer\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\cios_installer_v4\boot.dol echo a1c4a81802da20cf8990d03ebd3b3218 *apps\cios_installer_v4\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\cios_installer_v5\boot.dol echo 030a2aba6e0297080ecdfc7f7a6ba2d7 *apps\cios_installer_v5\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\cios_installer_v5.1\boot.dol echo 077ac9cdffbea1155dc4bb4fb4cff6b3 *apps\cios_installer_v5.1\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\cIOSx_rev19-Installer\boot.dol echo 2d678c3d4e7ea5c55a4a00472abb7421 *apps\cIOSx_rev19-Installer\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\cIOSx_rev20b-Installer\boot.dol echo ea5e2e4ba67b7612be4ab9fa00b96ba0 *apps\cIOSx_rev20b-Installer\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\cMIOS_rev5-Installer\boot.dol echo 1c436e8134d750299138a19a433a45a6 *apps\cMIOS_rev5-Installer\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\_apps_locked\boot.dol echo 6f277fd19e359db7d6f84dbad1076a29 *apps\_apps_locked\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\DOP-Mii\boot.dol echo 7cbd40d4987d17d85d4184bafc886c1c *apps\DOP-Mii\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%\apps\AccioHacks\boot.dol" echo 842507bb33184ac96bb093ceb6cd8826 *apps\AccioHacks\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\homebrew_browser\boot.dol echo d710ca71979e1e30aa7a490e0f3afe03 *apps\homebrew_browser\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\wii64\boot.dol echo 630dbc8b8a5be6527b76d49b65c47f23 *apps\wii64\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\wiiSX\boot.dol echo 9c245a7bcfd7b2f99ac9f01712736d43 *apps\wiiSX\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\MMM\boot.dol echo 739192c45ee31b7db00eda671a775ffa *apps\MMM\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\MIOSPatcher\boot.dol echo f2e5b95e246528488a3556608ddae217 *apps\MIOSPatcher\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\Priiloader\boot.dol echo 30ea349eeb532229a73529b40ca60be5 *apps\Priiloader\boot.dol>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\HackMii_Installer\boot.elf echo 8dcada755a608c70ed171ced7f9ef2f3 *apps\HackMii_Installer\boot.elf>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\bootmii\ppcboot.elf echo 4b2ac026e3b08a588a340841244f4e98 *bootmii\ppcboot.elf>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\loadmii\boot.elf echo 715ae195012c6ce69ae7196a58922df6 *apps\loadmii\boot.elf>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\apps\TBR\boot.dol echo 66296682ddd7233431ced92f8636ab0b *apps\TBR\boot.dol>> "%DRIVE%"\Global_Log.md5

::WAD Folder (*.app and *.wad)
::if exist "%DRIVE%"\WAD\0000000e.app echo 4b3ad6d33707d55ec27583a84b2ecf2a *WAD\0000000e.app>> "%DRIVE%"\Global_Log.md5
::if exist "%DRIVE%"\WAD\00000001.app echo 48e1be8f767feb59cbc51aa4329d735a *WAD\00000001.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000040.app echo c39e9edfc6df2264ce8ade4fd933f47f *WAD\00000040.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000042.app echo 9aae1917fdb8ba4d409664c230d89b27 *WAD\00000042.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000045.app echo 500130276620408b47777355460193de *WAD\00000045.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000070.app echo cc23b71d9246154f289644beee1b1682 *WAD\00000070.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000072.app echo 611d8d5e1f7ce778ba4c44d1b4c2910b *WAD\00000072.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000075.app echo a1d5703a4a2a5d764a12224d646c2849 *WAD\00000075.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000078.app echo f2eadf12d18e793373060222b870057d *WAD\00000078.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\0000007b.app echo 6b939de8222800733f4c44ae4eadb325 *WAD\0000007b.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\0000007e.app echo 574a3a144971ea0ec61bf8cef8d7ff80 *WAD\0000007e.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000084.app echo b08998e582c48afba3a14f6d9e1e9373 *WAD\00000084.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\00000087.app echo 7079948c6aed8aae6009e4fdf27c7171 *WAD\00000087.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\0000008a.app echo 7e7994f78941afb51e9a20085deac305 *WAD\0000008a.app>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\EULA-NUS-v3[U].wad echo f30393cd89cb20007c501efab75dab0c *WAD\EULA-NUS-v3[U].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\EULA-NUS-v3[E].wad echo e835877a6460beeb0d6756c43a800465 *WAD\EULA-NUS-v3[E].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\EULA-NUS-v3[J].wad echo 1b73948a1b3729cd29f0939652e856b3 *WAD\EULA-NUS-v3[J].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\EULA-NUS-v3[K].wad echo 21c48127696cf028a3bc19b3d34aef11 *WAD\EULA-NUS-v3[K].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Region-Select-NUS-v2[U].wad echo 27950cf84c554a851c42c33688f301c5 *WAD\Region-Select-NUS-v2[U].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Region-Select-NUS-v2[E].wad echo bac3441c6b6aec07a38b4b2cab103a3d *WAD\Region-Select-NUS-v2[E].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Region-Select-NUS-v2[J].wad echo 982d8507a94fbad1e298b073ba90c16d *WAD\Region-Select-NUS-v2[J].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Region-Select-NUS-v2[K].wad echo 18aee652bc16bc1aa4261400758ac04a *WAD\Region-Select-NUS-v2[K].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\BC-NUS-v6.wad echo d1593a77e24ecc95af2b393abe5d92f0 *WAD\BC-NUS-v6.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\3.2E_Systemmenu_v290.wad echo 5f0ff5a2b160f5340ccf74118edc9e33 *WAD\3.2E_Systemmenu_v290.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\3.2J_Systemmenu_v288.wad echo 907e4901a936337bd7188c82d449eae0 *WAD\3.2J_Systemmenu_v288.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\3.2U_Systemmenu_v289.wad echo 7514582f06126aee897fc2b2e9185980 *WAD\3.2U_Systemmenu_v289.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.1E_Systemmenu_v450.wad echo 688cc78b8eab4e30da04f01a81a3739f *WAD\4.1E_Systemmenu_v450.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.1J_Systemmenu_v448.wad echo 6edb4b3f7ca26c643c6bc662d159ec2e *WAD\4.1J_Systemmenu_v448.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.1K_Systemmenu_v454.wad echo c0e5d5c4914e76e7df7495ccf28ef869 *WAD\4.1K_Systemmenu_v454.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.1U_Systemmenu_v449.wad echo 38a95a9acd257265294be41b796f6239 *WAD\4.1U_Systemmenu_v449.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.2E_Systemmenu_v482.wad echo 7d77be8b6df5ac893d24652db33d02cd *WAD\4.2E_Systemmenu_v482.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.3E_Systemmenu_v514.wad echo 2ec2e6fbdfc52fe5174749e7032f1bad *WAD\4.3E_Systemmenu_v514.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.2J_Systemmenu_v480.wad echo 0413a9aed208b193fea85db908bbdabf *WAD\4.2J_Systemmenu_v480.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.3J_Systemmenu_v512.wad echo df67ed4bd8f8f117741fef7952ee5c17 *WAD\4.3J_Systemmenu_v512.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.3K_Systemmenu_v518.wad echo 6ed8f9e75b0a54eacfbacce57c20136d *WAD\4.3K_Systemmenu_v518.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.2K_Systemmenu_v486.wad echo 40c0bf90ea07b02d610edae1d7aea39f *WAD\4.2K_Systemmenu_v486.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.2U_Systemmenu_v481.wad echo 4ac52b981845473bd3655e4836d7442b *WAD\4.2U_Systemmenu_v481.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\4.3U_Systemmenu_v513.wad echo 4f5c63e3fd1bf732067fa4c439c68a97 *WAD\4.3U_Systemmenu_v513.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS12-64-v525.wad echo 117829bec9bddf83292356a08be186bc *WAD\IOS12-64-v525.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS13-64-v1031.wad echo 95173b01e0b7867c418145fdff8f0b45 *WAD\IOS13-64-v1031.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS14-64-v1031.wad echo be8660dc6a7dae37d79e8a5c7836ccc0 *WAD\IOS14-64-v1031.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS15-64-v523.wad echo 4c1d940cdd9c05f2ceb7e74dbc5e1073 *WAD\IOS15-64-v523.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS17-64-v1031.wad echo 0ab4aa75fca871320988f4fa8a459062 *WAD\IOS17-64-v1031.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS21-64-v1038.wad echo 0707195ab1dc8d1c522962bee688d3ef *WAD\IOS21-64-v1038.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS22-64-v1293.wad echo d82e16702fe3371a8c41ba851d1dec2e *WAD\IOS22-64-v1293.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS28-64-v1806.wad echo a305788950ce1433ecde2ee2d6573bb9 *WAD\IOS28-64-v1806.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS30-64-v2576.wad echo 45d7945d08eb25dc167b6f30ab8a9a9d *WAD\IOS30-64-v2576.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS30v2817(IOS30v2576[FS-ES-NP]).wad echo 9ca28e4c3b5d2222deccc5a10e376ec7 *WAD\IOS30v2817(IOS30v2576[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5




if exist "%DRIVE%"\WAD\IOS31-64-v3607.wad echo ed3a6214c68c37db4c24a0dcadf53ff0 *WAD\IOS31-64-v3607.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS33-64-v3607.wad echo 9c51dbb1ff67c01030a8559521233e1f *WAD\IOS33-64-v3607.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS34-64-v3607.wad echo 8778db1418f06971875e7ec7dafbdabd *WAD\IOS34-64-v3607.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS35-64-v3607.wad echo 1c20b2d72254fb3a853a4fafe4a3f201 *WAD\IOS35-64-v3607.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS36-64-v3351.wad echo 47ef27d46fc581c520f8215f39f11ecb *WAD\IOS36-64-v3351.wad>> "%DRIVE%"\Global_Log.md5

if exist "%DRIVE%"\WAD\IOS36-64-v3607.wad echo a02bc94736ab31c9f4f1f97a65c9137d *IOS36-64-v3607.wad>> "%DRIVE%"\WAD\Global_Log.md5

if exist "%DRIVE%"\WAD\IOS37-64-v5662.wad echo 8f905b7002e01fbb9950265ba2931d2c *WAD\IOS37-64-v5662.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS38-64-v4123.wad echo 21c06e48bfe98012e28165c2c8261f46 *WAD\IOS38-64-v4123.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS41-64-v3348.wad echo bc20bfd2772a5d76d7ebc1e0852ee665 *WAD\IOS41-64-v3348.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS41-64-v3091.wad echo a601e7151155e1c7da580dbbc7b4f45e *WAD\IOS41-64-v3091.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS43-64-v3348.wad echo 56918919932d4e8892e545230354f7ef *WAD\IOS43-64-v3348.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS45-64-v3348.wad echo 6f07bf0b18ff1d72721a69105031de51 *WAD\IOS45-64-v3348.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS46-64-v3350.wad echo 786c2b7d65d5449add33b78d67629762 *WAD\IOS46-64-v3350.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS50v5121(IOS50v4889[FS-ES-NP]).wad echo cdf6e98cdb8fef49ff83514c2a6d2c30 *WAD\IOS50v5121(IOS50v4889[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS52v5889(IOS52v5661[FS-ES-NP]).wad echo 7a9ac41bff365877bc056c71620426c0 *WAD\IOS52v5889(IOS52v5661[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS11v257(IOS60v6174[FS-ES-NP]).wad echo 2146691f86fd2cc23ab085a48a9f456c *WAD\IOS11v257(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS20v257(IOS60v6174[FS-ES-NP]).wad echo 0edf328f8ea8ac566b48896ee5753d57 *WAD\IOS20v257(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS30v2817(IOS60v6174[FS-ES-NP]).wad echo 3484503ec75e9ff64d26d06049a90705 *WAD\IOS30v2817(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS40v3073(IOS60v6174[FS-ES-NP]).wad echo b47ef5112488d91a85a137e7c283e7b3 *WAD\IOS40v3073(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS53-64-v5662.wad echo b2440898e60eb457cc2113c217dd8946 *WAD\IOS53-64-v5662.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS55-64-v5662.wad echo 914ce492bbee80420f30c52b1a3172af *WAD\IOS55-64-v5662.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS56-64-v5661.wad echo 1ab773dc324ccac079d9f544e4360ae9 *WAD\IOS56-64-v5661.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS57-64-v5918.wad echo b3c387fbca8e16ef09466b903557321b *WAD\IOS57-64-v5918.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS202v65535(IOS57v5918[FS-ES-NP]).wad echo 9f1fd638f1d8b9c6c5b145392e043fef *WAD\IOS202v65535(IOS57v5918[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS58-64-v6175.wad echo 1c67427069e0a3781fae3be7df1e3fec *WAD\IOS58-64-v6175.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS60-64-v6174.wad echo a8cfd7a77016227203639713db5ac34e *WAD\IOS60-64-v6174.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS60v6401(IOS60v6174[FS-ES-NP]).wad echo 67563398753c9d3a1cba696316afb283 *WAD\IOS60v6401(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS61-64-v5661.wad echo 5c8deaef0fb0d0a8d5530a9cef21f4e5 *WAD\IOS61-64-v5661.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS70-64-v6687.wad echo c38ff50344c00e17b7fe58c05d35a91c *WAD\IOS70-64-v6687.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS70v6913(IOS70v6687[FS-ES-NP]).wad echo 8faafd4589916ab2514541ddc5cf98d3 *WAD\IOS70v6913(IOS70v6687[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS70v54321(IOS60v6174[FS-ES-NP]).wad echo dce3dc7d32af4c6590a6d920e14cc96b *WAD\IOS70v54321(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS80v54321(IOS60v6174[FS-ES-NP]).wad echo e57c4670df4d4699989b22547559b2d0 *WAD\IOS80v54321(IOS60v6174[FS-ES-NP]).wad>> "%DRIVE%"\Global_Log.md5

if exist "%DRIVE%"\WAD\IOS80-64-v6943.wad echo 29993ed3b21035edd9334d0eaec8e52b *WAD\IOS80-64-v6943.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\IOS80-64-v6943[FS-ES-NP].wad echo 19d4cf2464c366915734b7a1f768d805 *WAD\IOS80-64-v6943[FS-ES-NP].wad>> "%DRIVE%"\Global_Log.md5

if exist "%DRIVE%"\WAD\IOS9-64-v1034.wad echo b81f3fe9912ac711b3e6423116420bc1 *WAD\IOS9-64-v1034.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Mii-Channel-NUS-v6.wad echo 5f03c5970ecf064bc520f4a11a0d3a34 *WAD\Mii-Channel-NUS-v6.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\NEWS-Channel-NUS-v7[E].wad echo 11c713ff825f918bfe2c1065e5ab9827 *WAD\NEWS-Channel-NUS-v7[E].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\NEWS-Channel-NUS-v7[J].wad echo 15dbd847c9f4b1df53cabe3fad57ad87 *WAD\NEWS-Channel-NUS-v7[J].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\NEWS-Channel-NUS-v7[U].wad echo c9fff95d6a4ca9f04dcd1fe3b28cc83a *WAD\NEWS-Channel-NUS-v7[U].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Opera-Internet-Channel-NUS[E].wad echo da20d4d1aedcd4dfa281423f2152ef6e *WAD\Opera-Internet-Channel-NUS[E].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Opera-Internet-Channel-NUS[J].wad echo 2ed4f8ad0977a3073b8fdfbf76ef1ba8 *WAD\Opera-Internet-Channel-NUS[J].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Opera-Internet-Channel-NUS[U].wad echo 434356a447bc01f10ea6a3289521d127 *WAD\Opera-Internet-Channel-NUS[U].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Photo-Channel-1.1-NUS-v3.wad echo ba88843d7d5d8090c6cce2c822965299 *WAD\Photo-Channel-1.1-NUS-v3.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Photo-Channel-1.1-NUS-v3[K].wad echo a3aa49e803fe297c0e23dd2d6a1467b3 *WAD\Photo-Channel-1.1-NUS-v3[K].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\RVL-mios-v10.wad echo 851c27dae82bc1c758be07fa964d17cb *WAD\RVL-mios-v10.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Shopping-Channel-NUS-v19.wad echo 70e5368e09e25bf01bd6ca7aa5a4eec0 *WAD\Shopping-Channel-NUS-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Shopping-Channel-NUS-v19[K].wad echo f44c72e858ad057e811c8f34bba7b713 *WAD\Shopping-Channel-NUS-v19[K].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Weather-Channel-NUS-v7[E].wad echo 56dd7a5a34cf4ee4ac222eb6bd01c0d9 *WAD\Weather-Channel-NUS-v7[E].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Weather-Channel-NUS-v7[J].wad echo c9f5ee197779910e71f9f554f7fa64ac *WAD\Weather-Channel-NUS-v7[J].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Weather-Channel-NUS-v7[U].wad echo 3c6c857751770fdcf3a80facbbfe3be4 *WAD\Weather-Channel-NUS-v7[U].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Wii-Speak-Channel-NUS[E].wad echo 77643094290097a2d237c78ba6e78df6 *WAD\Wii-Speak-Channel-NUS[E].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Wii-Speak-Channel-NUS[J].wad echo a686e2934045eff007a62760272208b8 *WAD\Wii-Speak-Channel-NUS[J].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\Wii-Speak-Channel-NUS[U].wad echo 0c48ace121c73f1703e8790a494712bb *WAD\Wii-Speak-Channel-NUS[U].wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS202[37]-v5.wad echo c213009e23c9ff87dd53d0cf7920819b *WAD\cIOS202[37]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS202[38]-v5.wad echo da71c2ee634884c7ac00d741921b1ef0 *WAD\cIOS202[38]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS202[57]-v5.wad echo dfe18d152c3cca198d69110cba740091 *WAD\cIOS202[57]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS222[38]-v4.wad echo cb22f1e2b7490514d714a8bd6c4d31e6 *WAD\cIOS222[38]-v4.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS223[37-38]-v4.wad echo 990272c4d04566df668df994d7b06647 *WAD\cIOS223[37-38]-v4.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS222[38]-v5.wad echo 1946fa59e0a851f54c10988b04ce3928 *WAD\cIOS222[38]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS223[37]-v5.wad echo 79d7ca910b719b4134d90b9d9912462c *WAD\cIOS223[37]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS223[57]-v5.wad echo 8aff8481db05f5ce91274d542ce2711f *WAD\cIOS223[57]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS224[37]-v5.wad echo 7f7c8928156240f547a7ef87a59b049e *WAD\cIOS224[37]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS224[57]-v5.wad echo 0b4bf426a9a682e3899b8590ca701e0f *WAD\cIOS224[57]-v5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS249-v17b.wad echo 9f410814c921880507ddcf3824f9f873 *WAD\cIOS249-v17b.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS249[37]-v19.wad echo 816b9ba664e19548f1d6af5661019d8e *WAD\cIOS249[37]-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS249[38]-v19.wad echo 1242d269a650cd0a899f3dd1391b480f *WAD\cIOS249[38]-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS249[57]-v19.wad echo f50ac643ce9f31a888a1b147ee0dff69 *WAD\cIOS249[57]-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS250-v17b.wad echo 7119e3c0fff48ecd9aa747d1d4319207 *WAD\cIOS250-v17b.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS250[37]-v19.wad echo 405c509051f6a2a441ce92572b256822 *WAD\cIOS250[37]-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS250[38]-v19.wad echo 2dba40263fb96c47a82b3ed8e060a4f0 *WAD\cIOS250[38]-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\cIOS250[57]-v19.wad echo 7a010f14c6c3d0638c99ff54343d57bd *WAD\cIOS250[57]-v19.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\RVL-cmios-v4_WiiGator_GCBL_v0.2.wad echo 3ea68908f6fdea52de2a2a2561074660 *WAD\RVL-cmios-v4_WiiGator_GCBL_v0.2.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\RVL-cmios-v4_Waninkoko_rev5.wad echo c392d59f10fbd9f3f3f2ad405c43464a *WAD\RVL-cmios-v4_Waninkoko_rev5.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\WAD\usbloader(s)-(emulators)-IDCL.wad echo ffc88e71d10e92660f5b4a02088156b7 *WAD\usbloader(s)-(emulators)-IDCL.wad>> "%DRIVE%"\Global_Log.md5


::ROOT
if exist "%DRIVE%"\IOS15-64-v257.wad echo 4250eda3c9b11b1c184e494909926547 *IOS15-64-v257.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS15-64-v1031.wad echo 027938ec6e15f1b8f4c89f0fb4255a7f *IOS15-64-v1031.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS15-64-v523.wad echo 4c1d940cdd9c05f2ceb7e74dbc5e1073 *IOS15-64-v523.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS36-64-v3351.wad echo 47ef27d46fc581c520f8215f39f11ecb *IOS36-64-v3351.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS36-64-v3607.wad echo a02bc94736ab31c9f4f1f97a65c9137d *IOS36-64-v3607.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS37-64-v3612.wad echo 8af99fa502a5035e77fc80835e91faaa *IOS37-64-v3612.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS37-64-v3869.wad echo 5f4295741efab0d919e491b7151d5ed3 *IOS37-64-v3869.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS38-64-v3610.wad echo 7fa5aa3ee9fbb041b69a190928029b29 *IOS38-64-v3610.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS38-64-v3867.wad echo 394298e4c9ff287e69020f2405423eb4 *IOS38-64-v3867.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\IOS57-64-v5661.wad echo ba50f0d46290d74d020f0afa58811e2e *IOS57-64-v5661.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\RVL-mios-v10.wad echo 851c27dae82bc1c758be07fa964d17cb *RVL-mios-v10.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\RVL-mios-v4.wad echo 60502dbd092d941cf627ac6db95a35cf *RVL-mios-v4.wad>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\hacks.ini echo adeb7f5f6758ed4f866bd180b2180ed2 *hacks.ini>> "%DRIVE%"\Global_Log.md5


::PRIVATE
if exist "%DRIVE%"\private\BB2.zip echo d846f2c07c0a3be6fadca90dbb7356a7 *private\wii\title\aktn\content.bin>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\private\BB1.zip echo 41d50b69c5763159afb35918c42cf320 *private\wii\title\aktn\content.bin>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\private\wii\title\rlip\data.bin echo a6b8f03f49baa471228dcd81d3fd623a *private\wii\title\rlip\data.bin>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\private\wii\title\rzdp\data.bin echo 704bd625ea5b42d7ac06fc937af74d38 *private\wii\title\rzdp\data.bin>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\private\wii\app\rsbe\st\st_080805_0933.bin echo aa93aab9bfdd25883bbd826a62645033 *private\wii\app\rsbe\st\st_080805_0933.bin>> "%DRIVE%"\Global_Log.md5

::00000001 Folder
::if exist "%DRIVE%"\00000001\00000025\v3612\cetk echo 686224a1879b2027bfcc4737e2021ed9 *00000001\00000025\v3612\cetk>> "%DRIVE%"\Global_Log.md5
::old ios60 cetk check not needed, also saved to root--if exist "%DRIVE%"\00000001\00000026\v3610\cetk echo 733a3fe5b4ff41e4414bae0dab300990 *00000001\00000026\v3610\cetk>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\00000001\0000003C\v6174\cetk echo 8c51f8500b75591f62d4cf4fade7f41e *00000001\0000003C\v6174\cetk>> "%DRIVE%"\Global_Log.md5

::EXE's
if exist "%DRIVE%"\WiiBackupManager0.3.5-beta1\WiiBackupManager.exe echo 7ce1f1fbd21e140784a2f7f4cca893d9 *WiiBackupManager0.3.5-beta1\WiiBackupManager.exe>> "%DRIVE%"\Global_Log.md5
if exist "%DRIVE%"\FAT32_GUI_Formatter\FAT32_GUI_Formatter.exe echo daf2d9aa422c3d065c6f4e8823644944 *FAT32_GUI_Formatter\FAT32_GUI_Formatter.exe>> "%DRIVE%"\Global_Log.md5
goto:FINISH



::--------------------------------------Custom Guide (for DL Wizard only)-------------------------------------

:guide
if /i "%MENU1%" EQU "U" goto:USBguide



::----------EXCEPTIONS With No GUIDES---------DISABLED
::if /i "%FIRMSTART%" NEQ "4.3" goto:guidestart

::if /i "%REGION%" NEQ "J" goto:skipJback
::sfk echo [Red] No Guide will be Generated for 4.3J Wii's
::@ping 127.0.0.1 -n 3 -w 1000> nul
::if /i "%SETTINGS%" EQU "G" goto:DOWNLOADQUEUE
::goto:DLSETTINGS2
:::skipJback

::if /i "%REGION%" NEQ "K" goto:skipKback
::sfk echo [Red] No Guide will be Generated for 4.3K Wii's
::@ping 127.0.0.1 -n 3 -w 1000> nul
::if /i "%SETTINGS%" EQU "G" goto:DOWNLOADQUEUE
::goto:DLSETTINGS2
:::skipKback


:guidestart
set guidename=NusAutoGuide.txt

SET COUNT7=1
cls
if /i "%SETTINGS%" EQU "G" echo Generating Guide, please wait.
if /i "%SETTINGS%" NEQ "G" echo Generating Guide, please wait, your downloads will begin shortly.

if not exist "%DRIVE%" mkdir "%DRIVE%" >nul
if not exist "%Drive%"\%guidename% goto:norename
SET /a COUNT6=%COUNT6%+1
if exist "%DRIVE%"\NusAutoGuide%COUNT6%.txt goto:guide
move "%Drive%"\%guidename% "%DRIVE%"\NusAutoGuide%count6%.txt >nul
:norename



echo NUS Auto Downloader %currentversion% Custom Guide>"%Drive%"\%guidename%
echo Generated on %DATE% - %TIME%>>"%Drive%"\%guidename%
echo Check for updates at tinyurl.com/nusauto>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo This Guide was generated using the following parameters:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
if /i "%VIRGIN%" EQU "Y" echo                * Wii is currently a virgin (un-modified)>>"%Drive%"\%guidename%
if /i "%VIRGIN%" EQU "N" echo                * Wii is already modified>>"%Drive%"\%guidename%

if /i "%REGION%" EQU "K" goto:Koreansetting
if /i "%REGION%" EQU "RC" goto:RCSTATUS
if /i "%FIRMSTART%" NEQ "o" echo                * Current firmware is %FIRMSTART%%REGION%>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo                * Current firmware is less than 2.2%REGION%>>"%Drive%"\%guidename%
goto:skipKoreansetting

:RCSTATUS
if /i "%FIRMSTART%" NEQ "o" echo                * Wii is Korean but has previously been region changed to %FIRMSTART%%REGIONCHANGE%>>"%DRIVE%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo                * Wii is Korean but has previously been region changed to %REGIONCHANGE%>>"%DRIVE%"\%guidename%
echo                * Desired firmware is %FIRM%%REGIONCHANGE%>>"%Drive%"\%guidename%
goto:skipKoreansetting

echo .>>"%Drive%"\%guidename%

:Koreansetting
if /i "%FIRMSTART%" NEQ "o" echo                * Current firmware is %FIRMSTART%K (Korean Wii's are hacked differently than Wii's from other regions.)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo                * Current firmware is less than 2.2K (Korean Wii's are hacked differently than Wii's from other regions.)>>"%Drive%"\%guidename%
:skipKoreansetting
if /i "%REGION%" NEQ "RC" echo                * Desired firmware is %FIRM%%REGION%>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

if /i "%PIC%" EQU "Y" echo                * Download Photo Channel>>"%Drive%"\%guidename%
if /i "%NET%" EQU "Y" echo                * Download Internet Channel>>"%Drive%"\%guidename%
if /i "%WEATHER%" EQU "Y" echo                * Download Weather Channel>>"%Drive%"\%guidename%
if /i "%NEWS%" EQU "Y" echo                * Download News Channel>>"%Drive%"\%guidename%
if /i "%Mii%" EQU "*" echo                * Download Mii Channel>>"%Drive%"\%guidename%
if /i "%Shop%" EQU "Y" echo                * Download Shopping Channel (and IOS61)>>"%Drive%"\%guidename%
if /i "%Speak%" EQU "Y" echo                * Download Wii Speak Channel>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
if /i "%VIRGIN%" EQU "Y" goto:skipvirginstandard


if /i "%HM%" NEQ "*" goto:skip4.3extra
if /i "%FIRMSTART%" EQU "3.X" echo                * Download HackMii Installer and BannerBomb v1 (with IOS58)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "4.0" echo                * Download HackMii Installer and BannerBomb v1 (with IOS58)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "4.1" echo                * Download HackMii Installer and BannerBomb v1 (with IOS58)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "4.2" echo                * Download HackMii Installer and BannerBomb v2 (with IOS58)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo                * Download HackMii Installer and Twilight Hack (with IOS58)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" goto:listthis

if /i "%FIRMSTART%" NEQ "4.3" goto:skip4.3extra

if /i "%REGION%" EQU "U" echo                * HackMii Installer (with IOS58)>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "E" echo                * HackMii Installer (with IOS58)>>"%Drive%"\%guidename%
:listthis
if /i "%REGION%" EQU "U" echo                  Smash Stack and Indiana Pwns Exploits>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "E" echo                  Indiana Pwns Exploit>>"%Drive%"\%guidename%
:skip4.3extra



if /i "%cIOS249[57]-v19%" EQU "*" echo                * Download recommended cIOSs and cMIOS>>"%Drive%"\%guidename%
if /i "%yawm%" EQU "*" echo                * Download Yet Another Wad Manager Mod (YAWMM)>>"%Drive%"\%guidename%

if /i "%mmm%" NEQ "*" goto:skip

if "%FIRMSTART%" EQU "4.3" (echo                * Download Trucha Bug Restorer [TBR]>>"%Drive%"\%guidename%) else (echo                * Download Multi-Mod-Manager [MMM]>>"%Drive%"\%guidename%)
if "%FIRMSTART%" EQU "4.3" (echo                  with 2x IOS15, IOS36, IOS41 and MMM for installing a patched IOS236>>"%Drive%"\%guidename%) else (echo                  with 2x IOS15 and IOS36 for installing patched IOS36>>"%Drive%"\%guidename%)
:skip

if /i "%pri%" EQU "*" echo                * Download Priiloader>>"%Drive%"\%guidename%
:skipvirginstandard
if /i "%protect%" EQU "Y" echo                * Download Extra Brick Protection>>"%Drive%"\%guidename%




if /i "%ACTIVEIOS%" NEQ "ON" goto:skipupdatelog
if /i "%FIRMSTART%" EQU "4.3" goto:skipupdatelog
if /i "%FIRMSTART%" EQU "4.2" goto:skipupdatelog
echo                * Update active IOSs>>"%Drive%"\%guidename%
:skipupdatelog


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo This software is not for sale. If you paid for this software or a "bundle" you have been scammed.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo THIS PACKAGE COMES WITH ABSOLUTELY NO WARRANTY, NEITHER STATED NOR IMPLIED.>>"%Drive%"\%guidename%
echo NO ONE BUT YOURSELF IS TO BE HELD RESPONSIBLE FOR ANY DAMAGE THIS MAY CAUSE TO YOUR NINTENDO WII CONSOLE!>>"%Drive%"\%guidename%
echo USE THIS AT YOUR OWN RISK!>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo IMPORTANT NOTES:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo *This guide does NOT require a Wifi connection on your Wii.>>"%Drive%"\%guidename%
echo *An SD card formatted to FAT(32) required (Best results are with non-SDHC cards, SDHC will only work on 4.0 or above).>>"%DRIVE%"\%guidename%
echo *If you get errors during any of the steps reformat your SD card as FAT or FAT32>>"%Drive%"\%guidename%
echo *Turn off WiiConnect24 and take out all gamecube memory cards/controllers when modding the Wii (unless instructed otherwise).>>"%DRIVE%"\%guidename%
echo *If your Wii ever freezes, hold the power button on the Wii for 5 seconds to power it off then try again.>>"%Drive%"\%guidename%
echo *Don’t ever accept a new Nintendo update without first googling to see if it’s safe. The last update (to 4.3) was released in late June 2010 and is NOT safe to accept. If you accept an official Nintendo update after modding the Wii, you may lose some or all of your modifications.>>"%Drive%"\%guidename%
echo *Never uninstall a system menu or IOS>>"%Drive%"\%guidename%
echo *Do not install untested wads/themes without Bootmii or Priiloader installed.>>"%Drive%"\%guidename%
echo *This custom guide is great start, but Wii modding is always evolving. Check for updates online, and remember, google is your friend.>>"%Drive%"\%guidename%
echo *If you have questions, a more detailed guide can be found here: http://www.completesoftmodguide.tk>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

If /i "%VIRGIN%" NEQ "Y" goto:nonkorean


::-----------------------------------------virgin Korean Wiis-----------------------------------
If /i "%REGION%" NEQ "K" goto:nonkorean


::---------------------------------RESTORING THE TRUCHA BUG for Korean Wiis (4.2 and under)-------------------------


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) LAUNCH Multi-Mod-Manager (MMM) USING BANNERBOMB>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

If /i "%BB2%" EQU "*" echo Run BannerBomb v2 by selecting the SD Card Button on the main system menu screen and choosing yes to load boot.dol/elf>>"%Drive%"\%guidename%
If /i "%BB1%" EQU "*" echo Run BannerBomb v1 by going to Settings, Data Management, Channels, SD Card and choosing yes to load boot.dol/elf>>"%Drive%"\%guidename%
echo Note: If it doesn't work for you, visit http://bannerbomb.qoid.us/ for more variations of either version of bannerbomb.>>"%DRIVE%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo This will launch Multi-Mod-Manager.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%




echo %COUNT7%) RESTORING THE TRUCHA BUG>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo In MMM, Go down to select "Install & Patch IOS36" and choose express mode.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%





:KOREANEXTRA
echo %COUNT7%) INSTALL IOS58 USING Multi-Mod Manager (MMM)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo In Multi-Manager Mod's main menu, Go down to select "WAD Manager".>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Now install IOS58v6175.>>"%Drive%"\%guidename%
echo Navigate to the wad and hit A twice to install the IOS individually.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Be careful not to install any additional wads that may have been previously saved in this folder (they may be safe, but I cannot say for sure).>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%


echo Make sure the file installed properly.>>"%Drive%"\%guidename%
echo Only move onto the next step after successfully installing the wad, but do NOT exit MMM.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



echo %COUNT7%) INSTALLING THE HOMEBREW CHANNEL (HBC) and BOOTMII>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo Back in the MMM main menu, choose "App Manager" and press A.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo Launch the HackMii_Installer>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo This runs the Hackmii Installer which you should now use to install the Homebrew Channel and Bootmii as boot2 if possible.>>"%DRIVE%"\%guidename%

goto:nandbackup

::---------------------------virgin NON-Korean Wiis-----------------------------------

::---------------------------------HACKMII INSTALLER-----------------------------

:nonkorean


::If /i "%FIRMSTART%" EQU "4.3" goto:Method4.3


If /i "%HM%" NEQ "*" goto:TBRGUIDE

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) INSTALLING THE HOMEBREW CHANNEL (HBC) AND BOOTMII>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


::---------------------------EXPLOITS GUIDES------------------------------
:EXPLOITS

set exploitnum=0
If /i "%BB1%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%BB2%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%TWI%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%PWNS%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%SMASH%" EQU "*" SET /a exploitnum=%exploitnum%+1

If /i "%exploitnum%" GEQ "2" echo EXPLOITS>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo You only need to perform ONE of the following exploits>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo.>>"%Drive%"\%guidename%


If /i "%BB1%" EQU "*" goto:skipforwardersolution
If /i "%BB2%" EQU "*" goto:skipforwardersolution
echo Note: if this Wii was previously modified, and it has either the HBC, BootMii as Boot2, or a Forwarder Channel installed, you can use that instead of an exploit (as it does not require physically owning a specific game).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If using BootMii as Boot2 to install the HBC, copy the 'BootMii' folder from your previous BootMii install to the root of your SD Card (or download it using NUSAD). Then boot your wii, BootMii will load, go To the SD menu, load bootmini.elf. This will load the Hackmii Installer allowing you to reinstall the HBC.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If using a Forwarder Channel, just save the boot.elf/dol from the app you want to load (ie. SD:\apps\hackmii_installer\boot.elf or SD:\apps\MMM\boot.dol) to the location used by your SPECIFIC Forwarder Channel (ie. SD:\apps\usbloader\boot.dol). Then start the channel and the Hackmii Installer will load allowing you to reinstall the HBC. Note, if your forwarder channel only loads dol's and not elf's, launch MMM's boot.dol, then use its app launcher to load the Hackmii Installer.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


if /i "%FIRMSTART%" EQU "o" echo Alternatively, you can update your Wii to v3.0-4.2 using a DISC (ie. NSMBW). Then repeat the NUSAD Download Wizard using your new Firmware and then you will be able to use the BannerBomb Exploit (which does not require a specific disc to work)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo.>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo WARNING: Online update to v4.3 makes JAP and Korean Wii's unhackable (unless it previously had HBC v1.0.7, BootMii as Boot2v4, or a forwarder channel installed.>>"%DRIVE%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo .>>"%Drive%"\%guidename%
:skipforwardersolution

:EXPLOITSNOW

echo.>>"%Drive%"\%guidename%
::If /i "%BB1%" EQU "*" echo BANNERBOMB V1 EXPLOIT>>"%Drive%"\%guidename%
If /i "%BB1%" EQU "*" echo Run BannerBomb v1 by going to Settings, Data Management, Channels, SD Card and choosing yes to load boot.dol/elf>>"%Drive%"\%guidename%
If /i "%BB1%" EQU "*" echo Note: If it doesn't work for you, visit http://bannerbomb.qoid.us/ for more variations of either version of bannerbomb.>>"%Drive%"\%guidename%
If /i "%BB1%" EQU "*" echo .>>"%Drive%"\%guidename%




::If /i "%BB2%" EQU "*" echo BANNERBOMB V2 EXPLOIT>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo Run BannerBomb v2 by selecting the SD Card Button on the main system menu screen and choosing yes to load boot.dol/elf>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo Note: If it doesn't work for you, visit http://bannerbomb.qoid.us/ for more variations of either version of bannerbomb.>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo .>>"%Drive%"\%guidename%



If /i "%SMASH%" NEQ "*" goto:skipSmashStackGuide

echo SMASH STACK EXPLOIT>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo REQUIREMENTS: * US version of Super Smash Brothers Brawl (RSBE)>>"%Drive%"\%guidename%
echo               * A non-SDHC card since game doesn't support SDHC cards>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo Insert the Super Smash Brothers Brawl Game.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo You have to delete all the custom stages you have created before running this hack (if applicable),>>"%Drive%"\%guidename%
echo otherwise be prepared for annoying harmless crashes>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo Then insert your SD Card, start the game and go to the stage builder,>>"%Drive%"\%guidename%
echo it should launch the boot.elf/dol file saved on the root of your SD card.>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo .>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo .>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo .>>"%Drive%"\%guidename%
:skipSmashStackGuide



If /i "%PWNS%" NEQ "*" goto:skipPWNSGuide

echo INDIANA PWNS EXPLOIT>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo REQUIREMENT: A copy of LEGO Indiana Jones>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo A. Load the LEGO Indiana Jones game at least once>>"%Drive%"\%guidename%
echo    (otherwise you won't be able to copy over the hack).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo B. Backup your personal LEGO Indiana Jones save file before copying the files to your SD Card (if applicable):>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo   a) Put your SD card in your Wii and turn it on.>>"%Drive%"\%guidename%
echo   b) Go into Wii Options - Data Management - Save Data - Wii>>"%Drive%"\%guidename%
echo   c) Find your Indiana save, click on it, click "Copy", and click Yes. Now erase the save file from the Wii.>>"%Drive%"\%guidename%
echo   d) Put your SD card in your computer, and copy the "private" folder from the card to a safe place. Alternatively you can temporarily rename it.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo C. Copy the files from the %DRIVE% to the root of your SD card (if you haven’t already) and insert it into your Wii>>"%DRIVE%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo D. Go into Wii Options - Data Management - Save Data - Wii - SD Card>>"%Drive%"\%guidename%
echo    then copy over the "Indiana Pwns" save that corresponds to your region.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo E. Play the Lego Indiana Jones game. Load the new save file.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo    You will be in the Main hall, walk towards the camera,>>"%Drive%"\%guidename%
echo    enter the first door on the right (Indy's left) and go into the 'Courtyard'.>>"%Drive%"\%guidename%
echo    Walk to the end and enter the 'Art Room', you will see a podium with 2 characters on it, talk to the left one.>>"%DRIVE%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo    Hit left twice (scrolling through his items) to choose the switch option (Black silhouette with a white arrow to another black silhouette)>>"%Drive%"\%guidename%
echo    Hit A to launch the boot.elf/dol file saved on the root of your SD card.>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo .>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo .>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo .>>"%Drive%"\%guidename%
:skipPWNSGuide




If /i "%TWI%" NEQ "*" goto:skipTWIGuide

echo TWILIGHT HACK/EXPLOIT>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo REQUIREMENT: A copy of The Legend of Zelda: Twilight Princess>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo A. Load the Twilight Princess game at least once>>"%Drive%"\%guidename%
echo    (otherwise you won't be able to copy over the hack).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo B. Backup your personal Twilight Princess save file before copying the files to your SD Card (if applicable):>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo   a) Put your SD card in your Wii and turn it on.>>"%Drive%"\%guidename%
echo   b) Go into Wii Options - Data Management - Save Data - Wii>>"%Drive%"\%guidename%
echo   c) Find your Twilight Princess save, click on it, click "Copy", and click Yes.>>"%Drive%"\%guidename%
echo   d) Put your SD card in your computer, and copy the "private" folder from the card to a safe place. Alternatively you can temporarily rename it.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo C. Copy the files from the %DRIVE% to the root of your SD card (if you haven’t already) and insert it into your Wii>>"%DRIVE%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo D. Go into Wii Options - Data Management - Save Data - Wii>>"%Drive%"\%guidename%
echo    Now delete the Zelda save file on the Wii.>>"%Drive%"\%guidename%
echo    Switch to the SD card tab and select the "Twilight Hack" save that corresponds to your game region.>>"%Drive%"\%guidename%
echo    Click copy and then yes. Now exit out of the menu.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo E. Insert the The Legend of Zelda: Twilight Princess disc and run the game.>>"%Drive%"\%guidename%
If /i "%REGION%" EQU "U" echo .>>"%Drive%"\%guidename%
If /i "%REGION%" EQU "U" echo Note: Look at the bottom of the game disc first.>>"%Drive%"\%guidename%
If /i "%REGION%" EQU "U" echo       If it has RVL-RZDE-0A-2 USA in its inner ring, you'll have to load TwilightHack2 in the next step.>>"%Drive%"\%guidename%
If /i "%REGION%" EQU "U" echo       If it says something else, load TwilightHack0.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo F. On the title screen of the game, press A and B to go to the main menu.>>"%Drive%"\%guidename%
If /i "%REGION%" NEQ "U" echo    Now load the twilight hack save file.>>"%Drive%"\%guidename%
If /i "%REGION%" EQU "U" echo    Now load the twilight hack save file (see the note above!).>>"%Drive%"\%guidename%

If /i "%REGION%" EQU "U" echo    If you accidentally load the wrong file and continue with the hack, the game will freeze but do not panic,>>"%Drive%"\%guidename%
If /i "%REGION%" EQU "U" echo    just hold down the power button for 5 seconds to turn it off, then turn it back on, and start over.>>"%DRIVE%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo G. The game will start like normal. To execute the hack, talk to the first character you see, or try to leave the room.>>"%DRIVE%"\%guidename%
:skipTWIGuide

echo .>>"%Drive%"\%guidename%

If /i "%MENU1%" EQU "H" goto:HMsolution2

::If /i "%FIRMSTART%" EQU "4.3" goto:after4.3exploit



:HACKMIIGUIDE
If /i "%HM%" NEQ "*" goto:PRIIGUIDE

echo .>>"%Drive%"\%guidename%
echo This runs the Hackmii Installer (and silently/automatically installs BootMii as IOS). Use the installer to install the Homebrew Channel (HBC) and Bootmii as Boot2 if possible. If you cannot install BootMii as Boot2, you also need to 'prepare an SD Card' for BootMii (as the 'BootMii' folder is required to launch BootMii as IOS or Boot2).>>"%DRIVE%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Note: If you get a 'no vulnerable IOS' error message, run NUS Auto Downloader again and this time select the 'Hackmii Solutions' option instead of 'Download Wizard' and follow the new instructions before continuing this guide.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo After you exit the hackmii installer, you will be taken to the HBC.>>"%Drive%"\%guidename%


echo Hit the home button. In the top right corner you will see the IOS used by the HBC.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo If the HBC is using an IOS other than IOS58 or your homebrew channel is upside-down, make a note of it as it applies later in the guide (you will have to reinstall the HBC).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo If it is using IOS58 and your HBC is not upside-down, you can skip the Reinstall The Homebrew Channel step when you get to it.>>"%DRIVE%"\%guidename%


echo .>>"%Drive%"\%guidename%



:nandbackup

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) MAKING A NAND BACKUP>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%



echo While inside the Homebrew Channel, load BootMii by pressing home and clicking Launch Bootmii.>>"%Drive%"\%guidename%
echo Press the power button on the wii 3 times to get to the last option, then press the reset button. [You can also navigate with a Gamecube controller]>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Press reset to choose the first option, then follow the directions on the screen to make your NAND backup. [Bad blocks are no problem.]>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Backup the Bootmii folder, NAND.bin, and keys.bin elsewhere and erase from the sd card (or rename it). You'll need these in case of emergencies, so don't lose them.>>"%Drive%"\%guidename%
echo Go back to The Homebrew Channel.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo Note: if Bootmii was installed as boot2, then it will show up as soon as the Wii is turned on AS LONG AS it finds the bootmii folder (mentioned above) on the root of the SD card.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%


If /i "%FIRMSTART%" EQU "4.3" goto:Method4.3
::if /i "%FIRMSTART%" EQU "4.3" goto:PRIIGUIDE


::----------------------------RESTORING THE TRUCHA BUG (using MMM on NON-4.3 Wii's)--------------------------
:TBRGUIDE

If /i "%firmstart%" EQU "4.3" goto:skipTBRstep
If /i "%mmm%" NEQ "*" goto:installwads
If /i "%REGION%" EQU "K" goto:skipTBRstep

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) RESTORING THE TRUCHA BUG>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%


echo Start the Homebrew Channel and use it to load Multi-Mod Manager (MMM).>>"%Drive%"\%guidename%
echo In MMM, Go down to select "Install & Patch IOS36" and choose express mode.>>"%Drive%"\%guidename%

set patchIOSnum=36

::---------CREATE MMMCONFIG To Autoload 36--------

if /i "%SETTINGS%" EQU "G" goto:skipTBRstep
if /i "%SETTINGSHM%" EQU "G" goto:skipTBRstep
echo ;MMMCONFIG (By NUS Auto Downloader)> "%Drive%"\mmmconfig.txt
echo AutoLoadIOS=%patchIOSnum%>> "%Drive%"\mmmconfig.txt


:skipTBRstep







::-----------------------------------------------------4.3 MOD Method-------------------------------------
:Method4.3
If /i "%FIRMSTART%" NEQ "4.3" goto:installwads


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%





::-----4.3 JAP AND KOR Exploit work arounds--------
If /i "%Region%" EQU "J" goto:JKMSG
If /i "%Region%" EQU "K" goto:JKMSG
If /i "%Regionchange%" EQU "J" goto:JKMSG
goto:skipJKMSG

:JKMSG

echo MISSING THE HOMEBREW CHANNEL???>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If this Wii was previously modified, and it has either BootMii as Boot2 or a Forwarder Channel installed, you can use that instead of an exploit to install the Homebrew Channel (as one does not YET exist for virgin 4.3J/K Wii's).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If using BootMii as Boot2 to install the HBC, copy the 'BootMii' folder from your previous BootMii install to the root of your SD Card (or download it using NUSAD). Then boot your wii, BootMii will load, go To the SD menu, load bootmini.elf. This will load the Hackmii Installer allowing you to reinstall the HBC.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If using a Forwarder Channel, just save the boot.elf/dol from the app you want to load (ie. SD:\apps\hackmii_installer\boot.elf or SD:\apps\MMM\boot.dol) to the location used by your SPECIFIC Forwarder Channel (ie. SD:\apps\usbloader\boot.dol). Then start the channel and the Hackmii Installer will load allowing you to reinstall the HBC. Note, if your forwarder channel only loads dol's and not elf's, launch MMM's boot.dol, then use its app launcher to load the Hackmii Installer.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

:skipJKMSG





If /i "%mmm%" NEQ "*" goto:installwads




::Korean wii's can't do this!
If /i "%Region%" EQU "K" goto:installwads

::3)
echo %COUNT7%) INSTALL IOS41v3091 USING MMM's WAD MANAGER>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

SET /a COUNT7PLUS1=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo Note: if this Wii was previously modified before updating to 4.3 it may have had a patched IOS or cIOS installed that survived the update and now you can load it to skip some steps. If this describes your Wii, move onto step #%COUNT7PLUS1%, but instead of loading IOS15, load the cIOS or patched IOS # that survived the 4.3 update [most probably IOS250 - other common cIOS survivors include IOS202/236/224 (or IOS222/223 v5 or higher)]. However, If you get errors when skipping steps, return to this step and complete it.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Launch Multi-Manager Mod via the HBC, Go down to select "WAD Manager".>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Navigate to the IOS41v3091 wad and hit A twice to install only that IOS.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo Move onto the next step after successfully installing the wad, but you do NOT have to exit MMM.>>"%Drive%"\%guidename%
echo Press B to get back to the MMM main menu.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

::4)
echo %COUNT7%) DOWNGRADE IOS15 USING Trucha Bug Restorer (TBR)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo In MMM, Select 'APP Manager' - Press A >>"%Drive%"\%guidename%
echo Select TBR (Trucha Bug Restorer) - Press A >>"%Drive%"\%guidename%
echo (If you already exited MMM, you can launch TBR via the HBC) >>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo In TBR, Select IOS41 - Press A >>"%Drive%"\%guidename%
echo Don't be impatient, wait, read - Press 1 >>"%Drive%"\%guidename%
echo Select 'Downgrade IOS15' - Press A >>"%Drive%"\%guidename%
echo Choose 'Load IOS from SD card' - Press A, Press A again >>"%Drive%"\%guidename%
echo Press A to start the install - Press A again >>"%Drive%"\%guidename%
echo Press any button to exit >>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo Note: If you get an error similar to the example below, or a DSI error after IOS15 downgrade (bunch of 'random' letters on screen), move onto the next step of the guide (as this step may have been successful).>>"%Drive%"\%guidename%
echo If the next step fails, then return to the beginning of this step.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo Error Example:>>"%Drive%"\%guidename%
echo    Setting the revision to 0 >>"%Drive%"\%guidename%
echo    Error: ES_AddTitleFinish returned -1017>>"%Drive%"\%guidename%
echo    Error: Could not set the revision to 0 >>"%Drive%"\%guidename%
echo    Downgrade failed>>"%Drive%"\%guidename%
echo    Press any button to exit...>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



::5)
echo %COUNT7%) INSTALL A PATCHED IOS236 USING MMM>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo Load MMM again via the HBC>>"%Drive%"\%guidename%
echo Select 'Load another IOS' - load IOS15 -press A >>"%Drive%"\%guidename%
echo Select IOS Manager- Press A >>"%Drive%"\%guidename%
echo Press 1, select IOS36 -Press A (install cios) >>"%Drive%"\%guidename%
echo Select IOS236 - press A >>"%Drive%"\%guidename%
echo Set version # to v65535 -press A >>"%Drive%"\%guidename%
echo Say YES to all 4 patches, install from SD card >>"%Drive%"\%guidename%
echo When finished press B to get to the MMM Main Menu >>"%Drive%"\%guidename%


set patchIOSnum=236
::---------CREATE MMMCONFIG To Autoload 236--------
if /i "%SETTINGS%" EQU "G" goto:skip
if /i "%SETTINGSHM%" EQU "G" goto:skip
echo ;MMMCONFIG (By NUS Auto Downloader)> "%Drive%"\mmmconfig.txt
echo AutoLoadIOS=%patchIOSnum%>> "%Drive%"\mmmconfig.txt
:skip

::----------------------Install Wads (MMM)-----------------------------

:installwads

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) INSTALL WADS>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%
echo If you exited MMM, reload it via the HBC, then select 'Load another IOS' -press A >>"%Drive%"\%guidename%
echo Select IOS%patchIOSnum% - press A >>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo Note: If this step fails with error -ret 2011 or other, you may need to retry patching IOS%patchIOSnum%. If the Wii was previously softmodded, you can try using cIOS250 (or others like 202,222,223,224,236,249)>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo In Multi-Manager Mod's main menu, Go down to select "WAD Manager".>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Install the following WADs in the WAD folder (this list of WADs is unique to how you answered the Wizard's questions).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Be careful not to install any additional wads that may have been previously saved in this folder (they may be safe, but I cannot say for sure).>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo Hold + for 2 seconds to select all wads in the folder. Then Press A twice to install them all.>>"%Drive%"\%guidename%
echo After the installation finishes read the install report to make sure all the files installed properly.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo      You're unique list of wads to install are as follows:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



if /i "%IOS11P60%" EQU "*" echo      * IOS11v257(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS20P60%" EQU "*" echo      * IOS20v257(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS30P60%" EQU "*" echo      * IOS30v2817(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS40P60%" EQU "*" echo      * IOS40v3073(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS50P%" EQU "*" echo      * IOS50v5121(IOS50v4889[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS52P%" EQU "*" echo      * IOS52v5889(IOS52v5661[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS60P%" EQU "*" echo      * IOS60v6401(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS70P%" EQU "*" echo      * IOS70v6913(IOS70v6687[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS70K%" EQU "*" echo      * IOS70v54321(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%
if /i "%IOS80P%" EQU "*" echo      * IOS80v6943[FS-ES-NP]>>"%Drive%"\%guidename%
if /i "%IOS80K%" EQU "*" echo      * IOS80v54321(IOS60v6174[FS-ES-NP])>>"%Drive%"\%guidename%

if /i "%SM3.2U%" EQU "*" echo      * System Menu 3.2U>>"%Drive%"\%guidename%
if /i "%SM4.1U%" EQU "*" echo      * System Menu 4.1U>>"%Drive%"\%guidename%
if /i "%SM4.2U%" EQU "*" echo      * System Menu 4.2U>>"%Drive%"\%guidename%
if /i "%SM4.3U%" EQU "*" echo      * System Menu 4.3U>>"%Drive%"\%guidename%
if /i "%SM3.2E%" EQU "*" echo      * System Menu 3.2E>>"%Drive%"\%guidename%
if /i "%SM4.1E%" EQU "*" echo      * System Menu 4.1E>>"%Drive%"\%guidename%
if /i "%SM4.2E%" EQU "*" echo      * System Menu 4.2E>>"%Drive%"\%guidename%
if /i "%SM4.3E%" EQU "*" echo      * System Menu 4.3E>>"%Drive%"\%guidename%
if /i "%SM3.2J%" EQU "*" echo      * System Menu 3.2J>>"%Drive%"\%guidename%
if /i "%SM4.1J%" EQU "*" echo      * System Menu 4.1J>>"%Drive%"\%guidename%
if /i "%SM4.2J%" EQU "*" echo      * System Menu 4.2J>>"%Drive%"\%guidename%
if /i "%SM4.3J%" EQU "*" echo      * System Menu 4.3J>>"%Drive%"\%guidename%
if /i "%SM4.1K%" EQU "*" echo      * System Menu 4.1K>>"%Drive%"\%guidename%
if /i "%SM4.2K%" EQU "*" echo      * System Menu 4.2K>>"%Drive%"\%guidename%
if /i "%SM4.3K%" EQU "*" echo      * System Menu 4.3K>>"%Drive%"\%guidename%

if /i "%cIOS202[37]-v5%" EQU "*" echo      * cIOS202[37]-v5>>"%Drive%"\%guidename%
if /i "%cIOS202[38]-v5%" EQU "*" echo      * cIOS202[38]-v5>>"%Drive%"\%guidename%
if /i "%cIOS202[57]-v5%" EQU "*" echo      * cIOS202[57]-v5>>"%Drive%"\%guidename%
if /i "%cIOS222[38]-v4%" EQU "*" echo      * cIOS222[38]-v4>>"%Drive%"\%guidename%
if /i "%cIOS223[37-38]-v4%" EQU "*" echo      * cIOS223[37-38]-v4>>"%Drive%"\%guidename%
if /i "%cIOS222[38]-v5%" EQU "*" echo      * cIOS222[38]-v5>>"%Drive%"\%guidename%
if /i "%cIOS223[37]-v5%" EQU "*" echo      * cIOS223[37]-v5>>"%Drive%"\%guidename%
if /i "%cIOS223[57]-v5%" EQU "*" echo      * cIOS223[57]-v5>>"%Drive%"\%guidename%
if /i "%cIOS224[37]-v5%" EQU "*" echo      * cIOS224[37]-v5>>"%Drive%"\%guidename%
if /i "%cIOS224[57]-v5%" EQU "*" echo      * cIOS224[57]-v5>>"%Drive%"\%guidename%
if /i "%cIOS249-v17b%" EQU "*" echo      * cIOS249-v17b>>"%Drive%"\%guidename%
if /i "%cIOS249[37]-v19%" EQU "*" echo      * cIOS249[37]-v19>>"%Drive%"\%guidename%
if /i "%cIOS249[38]-v19%" EQU "*" echo      * cIOS249[38]-v19>>"%Drive%"\%guidename%
if /i "%cIOS249[57]-v19%" EQU "*" echo      * cIOS249[57]-v19>>"%Drive%"\%guidename%
if /i "%cIOS250-v17b%" EQU "*" echo      * cIOS250-v17b>>"%Drive%"\%guidename%
if /i "%cIOS250[37]-v19%" EQU "*" echo      * cIOS250[37]-v19>>"%Drive%"\%guidename%
if /i "%cIOS250[38]-v19%" EQU "*" echo      * cIOS250[38]-v19>>"%Drive%"\%guidename%
if /i "%cIOS250[57]-v19%" EQU "*" echo      * cIOS250[57]-v19>>"%Drive%"\%guidename%
if /i "%RVL-cmios-v4_WiiGator_GCBL_v0.2%" EQU "*" echo      * RVL-cmios-v4_WiiGator_GCBL_v0.2>>"%Drive%"\%guidename%
if /i "%RVL-cmios-v4_Waninkoko_rev5%" EQU "*" echo      * RVL-cmios-v4_Waninkoko_rev5>>"%Drive%"\%guidename%


if /i "%MII%" EQU "*" echo      * Mii Channel (Region Free)>>"%Drive%"\%guidename%
if /i "%P%" EQU "*" echo      * Photo 1.1 (USA/PAL/JAP)>>"%Drive%"\%guidename%
if /i "%PK%" EQU "*" echo      * Photo 1.1 (KOR)>>"%Drive%"\%guidename%
if /i "%S%" EQU "*" echo      * Shopping (USA/PAL/JAP)>>"%Drive%"\%guidename%
if /i "%SK%" EQU "*" echo      * Shopping (KOR)>>"%Drive%"\%guidename%
if /i "%IU%" EQU "*" echo      * Internet (USA)>>"%Drive%"\%guidename%
if /i "%IE%" EQU "*" echo      * Internet (PAL)>>"%Drive%"\%guidename%
if /i "%IJ%" EQU "*" echo      * Internet (JAP)>>"%Drive%"\%guidename%
if /i "%WU%" EQU "*" echo      * Weather (USA)>>"%Drive%"\%guidename%
if /i "%WE%" EQU "*" echo      * Weather (PAL)>>"%Drive%"\%guidename%
if /i "%WJ%" EQU "*" echo      * Weather (JAP)>>"%Drive%"\%guidename%
if /i "%NU%" EQU "*" echo      * News (USA)>>"%Drive%"\%guidename%
if /i "%NE%" EQU "*" echo      * News (PAL)>>"%Drive%"\%guidename%
if /i "%NJ%" EQU "*" echo      * News (JAP)>>"%Drive%"\%guidename%
if /i "%WSU%" EQU "*" echo      * Wii Speak (USA)>>"%Drive%"\%guidename%
if /i "%WSE%" EQU "*" echo      * Wii Speak (PAL)>>"%Drive%"\%guidename%
if /i "%WSJ%" EQU "*" echo      * Wii Speak (JAP)>>"%Drive%"\%guidename%




if /i "%M10%" EQU "*" echo      * MIOS v10>>"%Drive%"\%guidename%
if /i "%IOS9%" EQU "*" echo      * IOS9v1034>>"%Drive%"\%guidename%
if /i "%IOS12%" EQU "*" echo      * IOS12v525>>"%Drive%"\%guidename%
if /i "%IOS13%" EQU "*" echo      * IOS13v1031>>"%Drive%"\%guidename%
if /i "%IOS14%" EQU "*" echo      * IOS14v1031>>"%Drive%"\%guidename%



::IOS15 exceptions
if /i "%ACTIVEIOS%" EQU "OFF" goto:skipsave15towad3
if /i "%FIRMSTART%" EQU "4.3" goto:save15towad3
if /i "%FIRMSTART%" EQU "3.X" goto:save15towad3
if /i "%FIRMSTART%" EQU "o" goto:save15towad3
::if /i "%MENU1%" EQU "1" goto:save15towad3----batch mode never creates a guide


goto:skipsave15towad3

:save15towad3

if /i "%IOS15%" EQU "*" echo      * IOS15v523>>"%Drive%"\%guidename%
if /i "%IOS15v1031%" EQU "*" echo      * IOS15v1031>>"%Drive%"\%guidename%

:skipsave15towad3



if /i "%IOS17%" EQU "*" echo      * IOS17v1031>>"%Drive%"\%guidename%
if /i "%IOS21%" EQU "*" echo      * IOS21v1038>>"%Drive%"\%guidename%
if /i "%IOS22%" EQU "*" echo      * IOS22v1293>>"%Drive%"\%guidename%
if /i "%IOS28%" EQU "*" echo      * IOS28v1806>>"%Drive%"\%guidename%
if /i "%IOS31%" EQU "*" echo      * IOS31v3607>>"%Drive%"\%guidename%
if /i "%IOS33%" EQU "*" echo      * IOS33v3607>>"%Drive%"\%guidename%
if /i "%IOS34%" EQU "*" echo      * IOS34v3607>>"%Drive%"\%guidename%
if /i "%IOS35%" EQU "*" echo      * IOS35v3607>>"%Drive%"\%guidename%

if /i "%OPTION36%" EQU "OFF" goto:skip36queuelist
if /i "%IOS36%" EQU "*" echo      * IOS36v3351 [This is saved in the WAD Folder because you enabled the Option36, installing this is not recommended as your IOS36 is likely already patched]>>"%Drive%"\%guidename%
:skip36queuelist


if /i "%ACTIVEIOS%" EQU "OFF" goto:DontSave3738ToWad2
if /i "%FIRMSTART%" EQU "4.2" goto:DontSave3738ToWad2
if /i "%IOS37%" EQU "*" echo      * IOS37v5662>>"%Drive%"\%guidename%
if /i "%IOS38%" EQU "*" echo      * IOS38v4123>>"%Drive%"\%guidename%
:DontSave3738ToWad2



if /i "%IOS41%" EQU "*" echo      * IOS41v3348>>"%Drive%"\%guidename%
if /i "%IOS43%" EQU "*" echo      * IOS43v3348>>"%Drive%"\%guidename%
if /i "%IOS45%" EQU "*" echo      * IOS45v3348>>"%Drive%"\%guidename%
if /i "%IOS46%" EQU "*" echo      * IOS46v3350>>"%Drive%"\%guidename%
if /i "%IOS53%" EQU "*" echo      * IOS53v5662>>"%Drive%"\%guidename%
if /i "%IOS55%" EQU "*" echo      * IOS55v5662>>"%Drive%"\%guidename%
if /i "%IOS56%" EQU "*" echo      * IOS56v5661>>"%Drive%"\%guidename%


if /i "%ACTIVEIOS%" EQU "OFF" goto:DontSave57ToWad2
if /i "%FIRMSTART%" EQU "4.2" goto:DontSave57ToWad2
if /i "%IOS57%" EQU "*" echo      * IOS57v5918>>"%Drive%"\%guidename%
:DontSave57ToWad2

if /i "%IOS58%" EQU "*" echo      * IOS58v6175>>"%Drive%"\%guidename%
if /i "%IOS61%" EQU "*" echo      * IOS61v5661>>"%Drive%"\%guidename%
if /i "%USBX%" NEQ "*" goto:nousbx
echo      * usbloader(s)-(emulators)-IDCL>>"%Drive%"\%guidename%

echo        This is a forwarder channel that will load the first file it finds from the following list:>>"%Drive%"\%guidename%
echo                    FAT:/apps/usbloader_cfg/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps_emulators/usbloader_cfg/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps/usbloader/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps_emulators/usbloader/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps/usb-loader/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps_emulators/usb-loader/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps/usbloader_gx/boot.dol>>"%Drive%"\%guidename%
echo                    FAT:/apps_emulators/usbloader_gx/boot.dol>>"%Drive%"\%guidename%
echo        Note: First the SD Card is checked, then your USB Hard Drive (formatted as FAT32).>>"%Drive%"\%guidename%
echo.
echo        You should always have at least one forwarder channel installed on your Wii,>>"%Drive%"\%guidename%
echo        that way, in the event of accidental update, you will be able to rehack your Wii>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "U" echo        without relying on the Smashstack or Indiana Pwns exploits.>>"%Drive%"\%guidename%
if /i "%REGION%" EQU "E" echo        without relying on the Indiana Pwns exploit.>>"%Drive%"\%guidename%
:nousbx

echo .>>"%Drive%"\%guidename%


echo If any failed, make a note of which ones and retry installing them one at time.>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "4.3" echo Be sure to load IOS%patchIOSnum% prior to wad install>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo Note: Whenever you install a new System Menu, Priiloader is uninstalled. So be sure to reinstall it afterwards (especially if you do not have bootmii as boot2)>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

::if /i "%FIRMSTART%" EQU "4.3" goto:HACKMIIGUIDE

::------------------------reinstall HBC / Fix Upsidedown homebrew channel----------------------------
:reinstallHBC
If /i "%HM%" NEQ "*" goto:PRIIGUIDE

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) REINSTALL THE HOMEBREW CHANNEL (if applicable)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo Earlier you should have checked what IOS is used by the HBC. If the IOS used by your Homebrew Channel is IOS58 and your HBC is not upside-down, you can skip this step.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo If the HBC is using an IOS other than IOS58 or your homebrew channel is upside-down, you should reinstall the HBC.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo In MMM's main menu, select 'App Manager' and then select the HackMii_Installer.>>"%Drive%"\%guidename%
echo Use the Hackmii Installer to fix/re-install the HBC. Once you've successfully reinstalled the HBC, you can move onto the next step of the guide.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%


echo If you already exited MMM, you can load the HackMii_Installer from the Homebrew Channel.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If the HBC is failing to load any apps (just blackscreens), instead launch the Hackmii Installer using the method described in the First Step>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

goto:priiguide


::--------------------------INSTALL PRIILOADER-------------------------------

:PRIIGUIDE
If /i "%PRI%" NEQ "*" goto:AFTERMODDING

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) INSTALL PRIILOADER>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%

echo Run the Priiloader installer from the HBC. On the main menu screen, hold B and press + to install Priiloader using IOS249.>>"%Drive%"\%guidename%
echo Priiloader may ask for confirmation, say Yes (the installation should go smoothly despite the warning).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Priiloader may give the following two 'yellow' errors. These are expected and are not an issue.>>"%Drive%"\%guidename%
echo       loader.ini couldn't delete error -106 >>"%Drive%"\%guidename%
echo       password.txt couldn't delete error -106 >>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo Note: If you get repeated errors, first launch MMM via the HBC, then select 'Load another IOS' and Select IOS%patchIOSnum% (or any IOS you know is patched). Then use MMM's app launcher to start the Priiloader installer and just press + to install using the loaded IOS.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



echo After successfully installing Priiloader, access it by powering off the wii,>>"%Drive%"\%guidename%
echo then powering it back and holding reset while it's booting until you see the Priiloader menu.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo You should install some system menu hacks now (by going to System Menu hacks option).>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo RECOMMENDED HACKS: Block Disc Updates, Block Online Updates, Replace Health Screen, Auto-Press A at Health Screen, Disable Deletion of some important channels, Region-Free Everything, remove no copy save file protection, and Move Disc Channel.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo The priiloader menu is white by default, you can change it to black in the Priiloader settings if you prefer.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%

echo One of the special functions of Priiloader is that it can autoboot any app/file instead of the system menu. Some apps (like crazyIntro) can't be used without it.>>"%Drive%"\%guidename%
echo For details on how to do so, visit http://www.completesoftmodguide.tk/system-hacks/priiloader>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%




::--------------------After Modding-----------------------
:AFTERMODDING

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) AFTER MODDING>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1

echo .>>"%Drive%"\%guidename%


If /i "%BB1%" EQU "*" echo After you are done modding your Wii, in order to avoid having your Wii freeze when accessing the SD Card Menu, you should either delete the 'aktn' folder where  bannerbomb is saved (SD:\private\wii\title\aktn), or rename the entire 'private' folder.>>"%Drive%"\%guidename%
If /i "%BB1%" EQU "*" echo .>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo After you are done modding your Wii, in order to avoid having your Wii freeze when accessing the SD Card Menu, you should either delete the 'aktn' folder where  bannerbomb is saved (SD:\private\wii\title\aktn), or rename the entire 'private' folder.>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo .>>"%Drive%"\%guidename%

echo Now at this point your practically done.>>"%Drive%"\%guidename%
echo Now you should be downloading the latest homebrew applications and setting them up on>>"%Drive%"\%guidename%
echo your SD Card (or FAT32 USB Hard Drive) so they can be launched via the HBC.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo For playing your backups off a USB hard drive, run the USB-Loader Setup feature from NUS Auto Downloader's Main Menu>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo For downloading applications, you should:>>"%Drive%"\%guidename%
echo * Check out NUS Auto Downloader's batch download pages as it has many popular apps available for download.>>"%Drive%"\%guidename%
echo * Download Homebrew Browser via NUS Auto Downloader to get many popular apps, but this is an online only Wii application (http://www.completesoftmodguide.tk/how-to-use/hbb)>>"%Drive%"\%guidename%
echo * For those without internet on their Wii, check out this list of Homebrew applications (wiibrew.org/wiki/List_of_all_homebrew).>>"%Drive%"\%guidename%
echo Another great resource is webrewwii.blogspot.com>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo After getting whatever apps you want, you should get a boot.dol file and possibly a icon.png and meta.xml.>>"%Drive%"\%guidename%
echo For HBC to read your SD/USB correctly, your card must be structured SD:/apps/application name/boot.dol>>"%Drive%"\%guidename%
echo If you have a *.dol not named boot.dol, rename it boot.dol, otherwise it will not be recognized by the HBC.>>"%Drive%"\%guidename%
echo (optional: the icon.png and meta.xml should be saved in the same place as the boot.dol)>>"%Drive%"\%guidename%


::---------------------support XFLAK-----------------------
:supportxflak

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo %COUNT7%) SUPPORT XFLAK>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo IF NUS AUTO DOWNLOADER WORKED FOR YOU, PLEASE VOTE IN FAVOUR OF THE PROGRAM HERE (tinyurl.com/NusAuto)>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo DONATIONS CAN OPTIONALLY BE MADE VIA PAYPAL TO XFLAK40@HOTMAIL.COM>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo CHECK OUT MY TOP CHANNELS HERE (tinyurl.com/topchannels)>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo CHECK OUT MY CRAZY INTRO VIDEOS HERE (tinyurl.com/crazyintro)>>"%Drive%"\%guidename%

sfk filter "%Drive%"\%guidename% -lsrep _.__ -write -yes>nul
start notepad "%Drive%\%guidename%"


if /i "%SETTINGS%" EQU "G" goto:DOWNLOADQUEUE
if /i "%SETTINGSHM%" EQU "G" goto:HACKMIISOLUTION

goto:DLSETTINGS2





::--------------------------------------HACKMII SOLUTIONS GUIDE--------------------------------------
:HMguide
set guidename=NusAutoGuide_HackMiiFix.txt

SET COUNT7=1
cls
if /i "%SETTINGSHM%" EQU "G" echo Generating Guide, please wait.
if /i "%SETTINGSHM%" NEQ "G" echo Generating Guide, please wait, your downloads will begin shortly.

if not exist "%Drive%" mkdir "%Drive%" >nul
if not exist "%Drive%"\%guidename% goto:norename1
SET /a COUNT6=%COUNT6%+1
if exist "%Drive%"\NusAutoGuide_HackMiiFix%COUNT6%.txt goto:HMguide
move "%Drive%"\%guidename% "%Drive%"\NusAutoGuide_HackMiiFix%count6%.txt >nul
:norename1




echo NUS Auto Downloader %currentversion% HackMii Solutions Guide>"%Drive%"\%guidename%
echo Generated on %DATE% - %TIME%>>"%Drive%"\%guidename%
echo Check for updates at tinyurl.com/nusauto>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo This Guide was generated using the following parameters:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

if /i "%FIRMSTART%" NEQ "o" echo                * Current firmware is %FIRMSTART%%REGION%>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo                * Current firmware is less than 2.2>>"%Drive%"\%guidename%



echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo This software is not for sale. If you paid for this software or a "bundle" you have been scammed.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo THIS PACKAGE COMES WITH ABSOLUTELY NO WARRANTY, NEITHER STATED NOR IMPLIED.>>"%Drive%"\%guidename%
echo NO ONE BUT YOURSELF IS TO BE HELD RESPONSIBLE FOR ANY DAMAGE THIS MAY CAUSE TO YOUR NINTENDO WII CONSOLE!>>"%Drive%"\%guidename%
echo USE THIS AT YOUR OWN RISK!>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo IMPORTANT NOTES:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo *This guide does NOT require a Wifi connection on your Wii.>>"%Drive%"\%guidename%
echo *An SD card formatted to FAT(32) required (Best results are with non-SDHC cards, SDHC will only work on 4.0 or above).>>"%Drive%"\%guidename%
echo *If you get errors during any of the steps reformat your SD card as FAT or FAT32>>"%Drive%"\%guidename%
echo *Turn off WiiConnect24 and take out all gamecube memory cards/controllers when modding the Wii (unless instructed otherwise).>>"%Drive%"\%guidename%
echo *If your Wii ever freezes, hold the power button on the Wii for 5 seconds to power it off then try again.>>"%Drive%"\%guidename%
echo *Don’t ever accept a new Nintendo update without first googling to see if it’s safe. The last update (to 4.3) was released in late June 2010 and is NOT safe to accept. If you accept an official Nintendo update after modding the Wii, you may lose some or all of your modifications.>>"%Drive%"\%guidename%
echo *Never uninstall a system menu or IOS>>"%Drive%"\%guidename%
echo *Do not install untested wads/themes without Bootmii or Priiloader installed.>>"%Drive%"\%guidename%
echo *This custom guide is great start, but Wii modding is always evolving. Check for updates online, and remember, google is your friend.>>"%Drive%"\%guidename%
echo *If you have questions, a more detailed guide can be found here: http://www.completesoftmodguide.tk>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



set exploitnum=0
If /i "%BB1%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%BB2%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%TWI%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%PWNS%" EQU "*" SET /a exploitnum=%exploitnum%+1
If /i "%SMASH%" EQU "*" SET /a exploitnum=%exploitnum%+1



echo %COUNT7%) LAUNCH Multi-Mod Manager (MMM)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo Start the Homebrew Channel (HBC) and load Multi-Mod Manager (MMM). Once you've loaded MMM, move onto the next step.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If you are missing the HBC or it is failing to load any apps (just blackscreens), you will need to launch MMM using another method.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%




If /i "%exploitnum%" GEQ "2" echo EXPLOITS>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo You only need to perform ONE of the following exploits>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
If /i "%exploitnum%" GEQ "2" echo.>>"%Drive%"\%guidename%


If /i "%BB1%" EQU "*" goto:skipforwardersolution
If /i "%BB2%" EQU "*" goto:skipforwardersolution
echo Note: if this Wii was previously modified, and it still has a Forwarder Channel installed, you can use that to launch MMM instead of an exploit. Just save the boot.dol from the app you want to load (ie. SD:\apps\MMM\boot.dol) to the location used by your SPECIFIC Forwarder Channel (ie. SD:\apps\usbloader\boot.dol). Then start the channel and the app will load.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


if /i "%FIRMSTART%" EQU "o" echo Alternatively, you can update your Wii to v3.0-4.2 using a DISC (ie. NSMBW). Then repeat the NUSAD Download Wizard using your new Firmware and then you will be able to use the BannerBomb Exploit (which does not require a specific disc to work)>>"%Drive%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo.>>"%Drive%"\%guidename%

if /i "%REGION%" EQU "U" goto:skipforwardersolution
if /i "%REGION%" EQU "E" goto:skipforwardersolution
if /i "%FIRMSTART%" EQU "o" echo WARNING: Online update to v4.3 makes JAP and Korean Wii's unhackable (unless it previously had HBC v1.0.7, BootMii as Boot2v4, or a forwarder channel installed.>>"%DRIVE%"\%guidename%
if /i "%FIRMSTART%" EQU "o" echo .>>"%Drive%"\%guidename%
:skipforwardersolution

goto:EXPLOITSNOW


:HMsolution2

::If /i "%BB2%" EQU "*" echo Run BannerBomb v2 by selecting the SD Card Button on the main system menu screen and choosing yes to load boot.dol/elf>>"%Drive%"\%guidename%
::If /i "%BB1%" EQU "*" echo Run BannerBomb v1 by going to Settings, Data Management, Channels, SD Card and choosing yes to load boot.dol/elf>>"%Drive%"\%guidename%
::echo Note: If it doesn't work for you, visit http://bannerbomb.qoid.us/ for more variations of either version of bannerbomb.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo %COUNT7%) INSTALL IOS58 USING Multi-Mod Manager (MMM)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo In Multi-Manager Mod's main menu, Go down to select "WAD Manager".>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Now install IOS58v6175.>>"%Drive%"\%guidename%
echo Navigate to the wad and hit A twice to install the IOS individually.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Be careful not to install any additional wads that may have been previously saved in this folder (they may be safe, but I cannot say for sure).>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%


echo Make sure the file installed properly.>>"%Drive%"\%guidename%
echo Only move onto the next step after successfully installing the wad, but do NOT exit MMM.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo %COUNT7%) INSTALL THE HOMEBREW CHANNEL (HBC)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo In MMM's main menu, select 'App Manager' and then select the HackMii_Installer.>>"%Drive%"\%guidename%

echo Use the Hackmii Installer to fix/re-install the HBC. If you haven't done so already, you should also install BootMii as Boot2 (if possible).>>"%Drive%"\%guidename%


echo Once you've successfully reinstalled the HBC, you are finished with this guide.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%


echo If you already exited MMM, you can load the HackMii_Installer from the Homebrew Channel.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo If the HBC is failing to load any apps (just blackscreens), instead launch MMM using the method described in Step 1, then in MMM's main menu, select 'App Manager' and then select the HackMii_Installer.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo This will launch the HackMii Installer, use it to reinstall your Homebrew Channel.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

If /i "%BB1%" EQU "*" echo After you are done modding your Wii, in order to avoid having your Wii freeze when accessing the SD Card Menu, you should either delete the 'aktn' folder where  bannerbomb is saved (SD:\private\wii\title\aktn), or rename the entire 'private' folder.>>"%Drive%"\%guidename%
If /i "%BB1%" EQU "*" echo .>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo After you are done modding your Wii, in order to avoid having your Wii freeze when accessing the SD Card Menu, you should either delete the 'aktn' folder where  bannerbomb is saved (SD:\private\wii\title\aktn), or rename the entire 'private' folder.>>"%Drive%"\%guidename%
If /i "%BB2%" EQU "*" echo .>>"%Drive%"\%guidename%

GOTO:supportxflak



::--------------------------------------------USB-Loader Set-Up Guide------------------------------------------
:USBguide
set guidename=NusAutoGuide_USBLoaderSetup.txt

if /i "%FORMAT%" EQU "1" set FORMATNAME=FAT32
if /i "%FORMAT%" EQU "2" set FORMATNAME=NTFS
if /i "%FORMAT%" EQU "3" set FORMATNAME=Part FAT32 and Part NTFS

SET COUNT7=1
cls
if /i "%SETTINGS%" EQU "G" echo Generating Guide, please wait.
if /i "%SETTINGS%" NEQ "G" echo Generating Guide, please wait, your downloads will begin shortly.

if not exist "%Drive%" mkdir "%Drive%" >nul
if not exist "%Drive%"\%guidename% goto:norename
SET /a COUNT6=%COUNT6%+1
if exist "%Drive%"\NusAutoGuide_USBLoaderSetup%COUNT6%.txt goto:usbguide
move "%Drive%"\%guidename% "%Drive%"\NusAutoGuide_USBLoaderSetup%count6%.txt >nul
:norename

echo NUS Auto Downloader %currentversion% USB-Loader Setup Custom Guide>"%Drive%"\%guidename%
echo Generated on %DATE% - %TIME%>>"%Drive%"\%guidename%
echo Check for updates at tinyurl.com/nusauto>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%





echo This Guide was generated using the following parameters:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo                * External Hard Drive to be Formatted as %FORMATNAME%>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" EQU "USB" echo                * USB-Loader Settings and config files saved to USB Hard Drive>>"%Drive%"\%guidename%
if /i "%USBCONFIG%" NEQ "USB" echo                * USB-Loader Settings and config files saved to SD Card>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo This software is not for sale. If you paid for this software or a "bundle" you have been scammed.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo THIS PACKAGE COMES WITH ABSOLUTELY NO WARRANTY, NEITHER STATED NOR IMPLIED.>>"%Drive%"\%guidename%
echo NO ONE BUT YOURSELF IS TO BE HELD RESPONSIBLE FOR ANY DAMAGE THIS MAY CAUSE TO YOUR NINTENDO WII CONSOLE!>>"%Drive%"\%guidename%
echo USE THIS AT YOUR OWN RISK!>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%



echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo IMPORTANT NOTES:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo *cIOS(s) required to use USB-Loaders, if you are missing cIOS(s) run the NUS Auto Downloader Wizard function to softmod your Wii before setting up your USB-Loader and/or external Hard-Drive.>>"%Drive%"\%guidename%
echo *cIOS249 rev18 or higher required to use Hard Drives Formatted as FAT32 or NTFS (cIOS222 rev4 or higher also works, but you would need to download the 222 version of configurable usb-loader or modify your config.txt file for configurable USB-Loader)>>"%Drive%"\%guidename%
echo *Not all external hard drive's are compatible with the Wii, for a list of which USB Hard Drive's are compatible, see this webpage: http://wiki.gbatemp.net/wiki/USB_Devices_Compatibility_List>>"%Drive%"\%guidename%
echo *If you have questions, a more detailed guide can be found here: http://www.completesoftmodguide.tk>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


if /i "%FORMAT%" NEQ "3" goto:skippartition
echo %COUNT7%) PARTITION AND FORMAT THE HARD DRIVE>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo If you have anything saved on the hard drive, you should back it up now as all the data will be lost once you complete this step.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Right-click 'My Computer' and select 'Manage', a new window will open, on left panel click 'Disk Management'.>>"%Drive%"\%guidename%
echo Right-click the drive you want to partition (make sure you select the right drive!), then select 'Delete Volume...'>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo On the lower half menu of the window, locate the unallocated space, right-click it, and select 'New Simple Volume...'>>"%Drive%"\%guidename%
echo Enter the 'volume size' you want your FAT32 partition to be, and click 'Next'.>>"%Drive%"\%guidename%
echo Choose a Drive letter for this partition, and click 'Next' (Make note of the drive letter, as it will be needed later)>>"%Drive%"\%guidename%
echo You will likely not be able to change the file system to FAT32 (it will only be an option if the volume size is under 32GB)>>"%Drive%"\%guidename%
echo If FAT32 isn't an option, select 'Do not format this volume', and click 'Next'>>"%Drive%"\%guidename%
echo (it doesn't matter if you format the volume, you are going to format it using 'FAT32 GUI Formatter' later on)>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%

echo On the lower half menu of the window, locate the remaining unallocated space (for the NTFS partition), right-click it, and select 'New Simple Volume....>>"%Drive%"\%guidename%
echo Click 'Next' (to format the all remaining space on the drive).>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Choose a Drive letter for this partition, and click 'Next'.>>"%Drive%"\%guidename%
echo Ensure the file system is set to NTFS then name the partition/volume,>>"%Drive%"\%guidename%
echo You may optionally uncheck the 'Perform a quick format' box, click 'Next', then click 'Finish'.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

::-----FAT32 gui formatter on unformatted partition------
echo If you managed to format the first partition as FAT32, then you can skip the remainder of this step.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

echo Start the FAT32_GUI_Formatter.exe saved here: %DRIVE%\FAT32_GUI_Formatter\>>"%Drive%"\%guidename%
echo Make sure you select the drive letter corresponding to the partition you want to format as FAT32.>>"%Drive%"\%guidename%
echo You may optionally uncheck the 'Quick Format' box, then click start.>>"%Drive%"\%guidename%


echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

:skippartition

if /i "%FORMAT%" EQU "3" goto:skipformat
echo %COUNT7%) FORMAT THE HARD DRIVE (if applicable)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo First check if your drive needs to be formatted by checking the current Format\File-System of the drive.>>"%Drive%"\%guidename%
echo Open 'My Computer', right-click the external hard drive you want to use, then select 'properties'.>>"%Drive%"\%guidename%
echo Make note of the Drive Letter of the external hard drive as this will be important later.>>"%Drive%"\%guidename%
echo If the 'File-System' is already %FORMATNAME%, you can skip this step.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo If you have anything saved on the hard drive, you should back it up now as all the data will be lost once you format it.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

if /i "%FORMAT%" EQU "2" goto:formatNTFS
echo Start the FAT32_GUI_Formatter.exe saved here: %DRIVE%\FAT32_GUI_Formatter\>>"%Drive%"\%guidename%
echo Make sure you select the drive letter corresponding to your external hard drive.>>"%Drive%"\%guidename%
echo You may optionally uncheck the 'Quick Format' box, then click start.>>"%Drive%"\%guidename%
goto:notformatNTFS

:formatNTFS
echo Right-click 'My Computer' and select 'Manage', a new window will open, on left panel click 'Disk Management'.>>"%Drive%"\%guidename%
echo Right-click the drive you want to format (make sure you select the right drive!), then select 'Format...'>>"%Drive%"\%guidename%
echo Select 'NTFS' as the File system to use and input a name for the Hard-Drive/Volume, you may optionally uncheck the 'Perform a quick format' box, then click 'OK', then click 'OK' again.>>"%Drive%"\%guidename%

:notformatNTFS
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%

:skipformat



if /i "%USBCONFIG%" NEQ "USB" goto:skipcopytousb
echo %COUNT7%) COPY FILES TO HARD DRIVE>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo Copy everything inside the %DRIVE% folder to the root of your FAT32 hard-drive\partition.>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
:skipcopytousb


echo %COUNT7%) CONFIGURE/CUSTOMIZE YOUR USB-LOADER>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%

echo To Configure/Customize your USB-Loader, use the Configurator for Configurable USB-Loader found here:>>"%Drive%"\%guidename%
echo %DRIVE%\usb-loader\CfgLoaderConfigurator.exe>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Optional: additional themes for Configurable USB-Loader can be found here:>>"%Drive%"\%guidename%
echo http://wii.spiffy360.com/themes.php>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo * IMPORTANT NOTES ON DEFAULT SETTINGS:>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo Two potentially dangerous features have been locked:>>"%Drive%"\%guidename%
echo      1) The ability to remove/delete games>>"%Drive%"\%guidename%
echo      2) the ability to format a hard drive.>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo To unlock these features, while in the configurable USB-Loader menu, hold '1' for 5 seconds, then enter the password to unlock these features. The password is 'AAAA', you can change the password/settings by using the Configurator for Configurable USB-Loader. Hold '1' again for 5 seconds to lock the USB-Loader again (or it will lock automatically again once you exit the USB-Loader).>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%


echo %COUNT7%) MANAGE WII BACKUPS USING WII BACKUP MANAGER (Optional)>>"%Drive%"\%guidename%
SET /a COUNT7=%COUNT7%+1
echo .>>"%Drive%"\%guidename%


echo Launch WiiBackupManager.exe saved here:>>"%Drive%"\%guidename%
echo %DRIVE%\WiiBackupManager0.3.5-beta1\WiiBackupManager.exe>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo You can use this program to manage/transfer your electronic backups of Wii Games.>>"%Drive%"\%guidename%
echo It is very simple to use, but a detailed tutorial on using Wii Backup Manager can be found here:>>"%Drive%"\%guidename%
echo http://www.completesoftmodguide.tk/backup-launchers/iso/wbfs-managers/wii-backup-manager>>"%Drive%"\%guidename%

echo .>>"%Drive%"\%guidename%

echo Note: To copy ORIGINAL Wii Disc's, insert the disc into your Wii, launch Configurable USB-Loader, and hit the plus sign '+'. Original Wii Disc's cannot be read/copied by using a computer (unless you have one of the rare LG Drives that is capable of doing so)>>"%Drive%"\%guidename%
echo .>>"%Drive%"\%guidename%
if /i "%FORMAT%" NEQ "1" echo Warning: Ripping to NTFS is VERY unstable, it is highly recommended to only add games to an NTFS hard drive using your computer.>>"%Drive%"\%guidename%

GOTO:supportxflak
