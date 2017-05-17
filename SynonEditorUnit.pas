unit SynonEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, ExtCtrls;

type
  TSynonEditorForm = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    SaveAndClose: TMenuItem;
    Cancel: TMenuItem;
    StatusBar1: TStatusBar;
    FindDialog1: TFindDialog;
    Timer1: TTimer;
    procedure SaveAndCloseClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SynonEditorForm: TSynonEditorForm;

implementation
  uses SynonUnit;

{$R *.dfm}

procedure TSynonEditorForm.Timer1Timer(Sender: TObject);
var I, J, PosReturn, SkipChars: Integer;
begin
  Timer1.Enabled:=false;//iba raz
  Memo1.Lines.LoadFromFile(SynF.selected);
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

 ///////////////////vysvietenie hladaneho mena
  FindDialog1.FindText:=SynF.meno;
  if pos('#',SynF.meno)<>0 then  //homonyma
    FindDialog1.FindText:=copy(SynF.meno,11,9);//povodne meno !

  for I := 0 to Memo1.Lines.Count do
  begin
    PosReturn := Pos(FindDialog1.FindText,Memo1.Lines[I]);
    if PosReturn <> 0 then {found!}
    begin
      SkipChars := 0;
      for J := 0 to I - 1 do
        SkipChars := SkipChars + Length(Memo1.Lines[J]);
      SkipChars := SkipChars + (I*2);
      SkipChars := SkipChars + PosReturn - 1;

      Memo1.SetFocus;
      Memo1.SelStart := SkipChars;
      Memo1.SelLength := Length(FindDialog1.FindText);
      Break;
    end;
  end;

end;

procedure TSynonEditorForm.SaveAndCloseClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(SynF.selected);
  SynonEditorForm.Close;
end;

procedure TSynonEditorForm.CancelClick(Sender: TObject);
begin
  SynonEditorForm.Close;
end;

procedure TSynonEditorForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

end;

procedure TSynonEditorForm.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

end;

procedure TSynonEditorForm.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

end;



procedure TSynonEditorForm.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true;
end;

end.
