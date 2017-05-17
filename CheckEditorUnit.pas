unit CheckEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, ExtCtrls;

type
  TCheckEditorForm = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    SaveAndClose: TMenuItem;
    Cancel: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    FindDialog1: TFindDialog;
    procedure FormShow(Sender: TObject);
    procedure SaveAndCloseClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckEditorForm: TCheckEditorForm;

implementation
  uses CheckMainUnit;

{$R *.dfm}

procedure TCheckEditorForm.Timer1Timer(Sender: TObject);
var I, J, PosReturn, SkipChars: Integer;
    LineNo:integer;
begin
  Timer1.Enabled:=false;//len raz

 ///////////////////
  if CheckMainForm.SelCode=1 then begin     //vysvieti posledny riadok
    FindDialog1.FindText:=Memo1.Lines.Strings[Memo1.Lines.Count-1];
  end;

  if CheckMainForm.SelCode=2 then begin     //vysvieti prvy riadok
    FindDialog1.FindText:=Memo1.Lines.Strings[0];
  end;

  if CheckMainForm.SelCode=3 then begin     //vysvieti prvy riadok
    FindDialog1.FindText:=Memo1.Lines.Strings[0];
  end;

  if CheckMainForm.SelCode=4 then begin //vysvieti zaciatok matice
    FindDialog1.FindText:=Memo1.Lines.Strings[5];
  end;

  if CheckMainForm.SelCode=5 then begin     //No Abudance
    if CheckMainForm.SelText='' then//dvojklik na biele pole
      LineNo:=1
    else
    LineNo:=StrToInt(copy(CheckMainForm.SelText,pos(':',CheckMainForm.SelText)+2,MaxInt));
    FindDialog1.FindText:=Memo1.Lines.Strings[LineNo-1];
  end;

  if CheckMainForm.SelCode=6 then begin     //Short Line
    if CheckMainForm.SelText='' then
      LineNo:=1
    else
    LineNo:=StrToInt(copy(CheckMainForm.SelText,pos(':',CheckMainForm.SelText)+2,MaxInt));
    FindDialog1.FindText:=Memo1.Lines.Strings[LineNo-1];
  end;

  if CheckMainForm.SelCode=7 then begin     //name repetition
    if CheckMainForm.SelText='' then
      LineNo:=1
    else
    LineNo:=StrToInt(copy(CheckMainForm.SelText,pos('&',CheckMainForm.SelText)+2,MaxInt));
    FindDialog1.FindText:=Memo1.Lines.Strings[LineNo-1];
  end;

  if CheckMainForm.SelCode=8 then begin     //invalid symbol
    if CheckMainForm.SelText='' then
      LineNo:=1
    else
    LineNo:=StrToInt(copy(CheckMainForm.SelText,pos(':',CheckMainForm.SelText)+2,MaxInt));
    FindDialog1.FindText:=Memo1.Lines.Strings[LineNo-1];
  end;

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

  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);
end;

procedure TCheckEditorForm.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true;
  Memo1.Lines.LoadFromFile(CheckMainForm.SelFile);
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);
end;

procedure TCheckEditorForm.SaveAndCloseClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(CheckMainForm.SelFile);
  CheckEditorForm.Close;
end;

procedure TCheckEditorForm.CancelClick(Sender: TObject);
begin
  CheckEditorForm.Close;
end;

procedure TCheckEditorForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

end;

procedure TCheckEditorForm.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

end;

procedure TCheckEditorForm.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar1.SimpleText:='line: '+IntToStr(Memo1.CaretPos.Y+1)+', column: '
                          +IntToStr(Memo1.CaretPos.X+1);

end;


end.
