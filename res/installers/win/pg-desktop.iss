; -- Example1.iss --
; Demonstrates copying 3 files and creating an icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppPublisher=Adobe Inc.
AppPublisherURL=https://www.adobe.com/
AppName=PhoneGap Desktop
AppVersion=0.1.1
DefaultDirName={pf}\My Program\PhoneGap Desktop
DefaultGroupName=My Program
UninstallDisplayIcon={app}\MyProg.exe
Compression=lzma2
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output
LicenseFile=license.txt

[Files]
Source: "C:\Users\herm\Documents\HermWong\phonegap-gui\build\PhoneGap\win\PhoneGap.exe"; DestDir: "{app}"
Source: "C:\Users\herm\Documents\HermWong\phonegap-gui\build\PhoneGap\win\nw.pak"; DestDir: "{app}"
Source: "C:\Users\herm\Documents\HermWong\phonegap-gui\build\PhoneGap\win\libGLESv2.dll"; DestDir: "{app}"
Source: "C:\Users\herm\Documents\HermWong\phonegap-gui\build\PhoneGap\win\libEGL.dll"; DestDir: "{app}"
Source: "C:\Users\herm\Documents\HermWong\phonegap-gui\build\PhoneGap\win\icudtl.dat"; DestDir: "{app}"
Source: "C:\Users\herm\Documents\HermWong\phonegap-gui\build\PhoneGap\win\ffmpegsumo.dll"; DestDir: "{app}"

[Icons]
;Name: "{group}\My Program"; Filename: "{app}\MyProg.exe"

[Code]
// Utility functions for Inno Setup
//   used to add/remove programs from the windows firewall rules
// Code originally from http://news.jrsoftware.org/news/innosetup/msg43799.html

const
  NET_FW_SCOPE_ALL = 0;
  NET_FW_IP_VERSION_ANY = 2;

procedure SetFirewallException(AppName,FileName:string);
var
  FirewallObject: Variant;
  FirewallManager: Variant;
  FirewallProfile: Variant;
begin
  try
    FirewallObject := CreateOleObject('HNetCfg.FwAuthorizedApplication');
    FirewallObject.ProcessImageFileName := FileName;
    FirewallObject.Name := AppName;
    FirewallObject.Scope := NET_FW_SCOPE_ALL;
    FirewallObject.IpVersion := NET_FW_IP_VERSION_ANY;
    FirewallObject.Enabled := True;
    FirewallManager := CreateOleObject('HNetCfg.FwMgr');
    FirewallProfile := FirewallManager.LocalPolicy.CurrentProfile;
    FirewallProfile.AuthorizedApplications.Add(FirewallObject);
  except
  end;
end;

procedure RemoveFirewallException( FileName:string );
var
  FirewallManager: Variant;
  FirewallProfile: Variant;
begin
  try
    FirewallManager := CreateOleObject('HNetCfg.FwMgr');
    FirewallProfile := FirewallManager.LocalPolicy.CurrentProfile;
    FireWallProfile.AuthorizedApplications.Remove(FileName);
  except
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep=ssPostInstall then
     SetFirewallException('My Server', ExpandConstant('{app}')+'\TCPServer.exe');
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep=usPostUninstall then
     RemoveFirewallException(ExpandConstant('{app}')+'\TCPServer.exe');
end;
