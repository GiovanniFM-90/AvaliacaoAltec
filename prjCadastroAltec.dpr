program prjCadastroAltec;

uses
  Vcl.Forms,
  UFrmCadastroAltec in 'UFrmCadastroAltec.pas' {frmCadastroAltec},
  UCEPModel in 'Fontes\CEP\UCEPModel.pas',
  UCEPService in 'Fontes\CEP\UCEPService.pas',
  UCadastroModel in 'Fontes\Cadastro\UCadastroModel.pas',
  UEmailService in 'Fontes\Email\UEmailService.pas',
  UCadastroService in 'Fontes\Cadastro\UCadastroService.pas',
  UEditHelper in 'Fontes\Helpers\UEditHelper.pas',
  UEmailModel in 'Fontes\Email\UEmailModel.pas',
  UObjectHelper in 'Fontes\Helpers\UObjectHelper.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:= true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastroAltec, frmCadastroAltec);
  Application.Run;
end.
