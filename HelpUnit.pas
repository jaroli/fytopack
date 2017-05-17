unit HelpUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  THelpForm = class(TForm)
    PageControl1: TPageControl;
    CheckSheet: TTabSheet;
    FuseSheet: TTabSheet;
    SynonSheet: TTabSheet;
    FytSheet: TTabSheet;
    SynopSheet: TTabSheet;
    FulnamSheet: TTabSheet;
    CheckRichEdit: TRichEdit;
    FuseRichEdit: TRichEdit;
    SynonRichEdit: TRichEdit;
    FytRichEdit: TRichEdit;
    SynopRichEdit: TRichEdit;
    FulnamRichEdit: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;

implementation
  uses FytopackUnit;

{$R *.dfm}

var a:string;//adresar v ktorom je exe subor
    HelpDir:string;
procedure THelpForm.FormCreate(Sender: TObject);
begin
  a:=GetCurrentDir;
  HelpDir:=a+'\Help\';
  CheckRichEdit.Lines.LoadFromFile(HelpDir+'CheckHelp.rtf');
  FuseRichEdit.Lines.LoadFromFile(HelpDir+'FuseHelp.rtf');
  SynonRichEdit.Lines.LoadFromFile(HelpDir+'SynonHelp.rtf');
  FytRichEdit.Lines.LoadFromFile(HelpDir+'FytHelp.rtf');
  SynopRichEdit.Lines.LoadFromFile(HelpDir+'SynopHelp.rtf');
  FulnamRichEdit.Lines.LoadFromFile(HelpDir+'FullnamHelp.rtf');
end;

procedure THelpForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FytopackForm.Caption:='Fytopack';
end;

end.
