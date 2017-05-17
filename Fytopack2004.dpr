program Fytopack2004;

uses
  Forms,
  FytopackUnit in 'FytopackUnit.pas' {FytopackForm},
  CheckMainUnit in 'CheckMainUnit.pas' {CheckMainForm},
  CheckEditorUnit in 'CheckEditorUnit.pas' {CheckEditorForm},
  FuseUnit in 'FuseUnit.pas' {FuseForm},
  SynonUnit in 'SynonUnit.pas' {SynF},
  SynonEditorUnit in 'SynonEditorUnit.pas' {SynonEditorForm},
  FytUnit in 'FytUnit.pas',
  SynopUnit in 'SynopUnit.pas',
  FulnamUnit in 'FulnamUnit.pas' {FulF},
  SyntaxFUnit in 'SyntaxFUnit.pas',
  ZipLineUnit in 'ZipLineUnit.pas' {ZipLineForm},
  TruncUnit in 'TruncUnit.pas',
  OtherTaxaUnit in 'OtherTaxaUnit.pas',
  SortLineUnit in 'SortLineUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'C:\Fytopack2004\FytopackHelp\Fytopack.hlp';
  Application.CreateForm(TFytopackForm, FytopackForm);
  Application.CreateForm(TCheckMainForm, CheckMainForm);
  Application.CreateForm(TCheckEditorForm, CheckEditorForm);
  Application.CreateForm(TFuseForm, FuseForm);
  Application.CreateForm(TSynF, SynF);
  Application.CreateForm(TSynonEditorForm, SynonEditorForm);
  Application.CreateForm(TFulF, FulF);
  Application.CreateForm(TZipLineForm, ZipLineForm);
  Application.Run;
end.
