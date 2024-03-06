program cableJobs;

uses
  Vcl.Forms,
  uDataMod in 'uDataMod.pas' {DM: TDataModule},
  uMainForm in 'uMainForm.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  uGallery in 'uGallery.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Blue');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
