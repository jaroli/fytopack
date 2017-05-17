unit FytopackUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, StrUtils;

type
  TPage = class(TObject)
    edit:TRichEdit;
    sheet:TTabSheet;
    subor:string;
  end;
  TFytopackForm = class(TForm)
    PC: TPageControl;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    FileBtn: TMenuItem;
    Edit: TMenuItem;
    Search: TMenuItem;
    Format: TMenuItem;
    Check: TMenuItem;
    Fuse: TMenuItem;
    Synon: TMenuItem;
    Fyt: TMenuItem;
    Synop: TMenuItem;
    Fulnam: TMenuItem;
    Utilities: TMenuItem;
    Help: TMenuItem;
    Timer1: TTimer;
    Open: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    N1: TMenuItem;
    PrintSetup: TMenuItem;
    PageSetup: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    CloseFile: TMenuItem;
    CloseAll: TMenuItem;
    N3: TMenuItem;
    Quit: TMenuItem;
    Undo: TMenuItem;
    N4: TMenuItem;
    Cut: TMenuItem;
    CopyBtn: TMenuItem;
    Paste: TMenuItem;
    N5: TMenuItem;
    SelectAll: TMenuItem;
    Delete: TMenuItem;
    Find: TMenuItem;
    Replace: TMenuItem;
    Font: TMenuItem;
    MonospacedFonts: TMenuItem;
    N6: TMenuItem;
    AlignLeft: TMenuItem;
    AlignRight: TMenuItem;
    Center: TMenuItem;
    N8: TMenuItem;
    WordWrap: TMenuItem;
    LoadFileFyt: TMenuItem;
    RunFyt: TMenuItem;
    SettingsFyt: TMenuItem;
    LoadFileSynop: TMenuItem;
    RunSynop: TMenuItem;
    SettingsSynop: TMenuItem;
    Synop1: TMenuItem;
    Synop2: TMenuItem;
    Synop3: TMenuItem;
    Synop4: TMenuItem;
    Synop5: TMenuItem;
    Synop6: TMenuItem;
    RunFulnam: TMenuItem;
    SettingsFulnam: TMenuItem;
    Author: TMenuItem;
    SyntaxFormat: TMenuItem;
    ZipLine: TMenuItem;
    SortLine: TMenuItem;
    Trunc: TMenuItem;
    OtherTaxa: TMenuItem;
    OpenD: TOpenDialog;
    SaveD: TSaveDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    PageSetupDialog: TPageSetupDialog;
    FytList: TMenuItem;
    FontDialog1: TFontDialog;
    FontDialog2: TFontDialog;
    FindD: TFindDialog;
    ReplaceD: TReplaceDialog;
    procedure AddPage(subor:string);
    procedure SearchDown;
    procedure ReplaceDSearchDown;
    procedure SearchUp;
    procedure ReplaceAll;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckClick(Sender: TObject);
    procedure FuseClick(Sender: TObject);
    procedure SynonClick(Sender: TObject);
    procedure LoadFileFytClick(Sender: TObject);
    procedure RunFytClick(Sender: TObject);
    procedure LoadFileSynopClick(Sender: TObject);
    procedure RunSynopClick(Sender: TObject);
    procedure RunFulnamClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure SyntaxFormatClick(Sender: TObject);
    procedure ZipLineClick(Sender: TObject);
    procedure SortLineClick(Sender: TObject);
    procedure TruncClick(Sender: TObject);
    procedure OtherTaxaClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure PrintSetupClick(Sender: TObject);
    procedure PageSetupClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure CloseFileClick(Sender: TObject);
    procedure CloseAllClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure CutClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure FontClick(Sender: TObject);
    procedure MonospacedFontsClick(Sender: TObject);
    procedure AlignLeftClick(Sender: TObject);
    procedure AlignRightClick(Sender: TObject);
    procedure CenterClick(Sender: TObject);
    procedure WordWrapClick(Sender: TObject);
    procedure FindDFind(Sender: TObject);
    procedure ReplaceDFind(Sender: TObject);
    procedure ReplaceDReplace(Sender: TObject);
  private
    { Private declarations }
    p:array of TPage;
  public
    a:string;
    asl:string;

    { Public declarations }
  end;

var
  FytopackForm: TFytopackForm;

implementation
  uses CheckMainUnit,FuseUnit,SynonUnit,FytUnit,SynopUnit,FulnamUnit,
       SyntaxFUnit,ZipLineUnit,SortLineUnit,TruncUnit,OtherTaxaUnit;
{$R *.dfm}

var p:array of TPage;
    i:integer;

procedure TFytopackForm.AddPage(subor:string);
begin
  SetLength(p,i+1);
  p[i]:=TPage.Create;
  
  p[i].sheet:=TTabSheet.Create(PC);
  p[i].sheet.PageControl:=PC;
  p[i].sheet.Align:=alClient;
  p[i].sheet.Caption:=ExtractFileName(subor);

  p[i].subor:=subor;// plna cesta suboru

  p[i].edit:=TRichEdit.Create(p[i].sheet);
  p[i].edit.Parent:=p[i].sheet;
  p[i].edit.Align:=alClient;
  p[i].edit.Font.Name:='Courier New';
  p[i].edit.Font.Size:=10;
  p[i].edit.ScrollBars:=ssBoth;
  p[i].edit.PlainText:=true;
  p[i].edit.WordWrap:=false;
  p[i].edit.Lines.LoadFromFile(subor);

  p[i].sheet.Show;
  p[i].edit.SetFocus;

  inc(i);
end;

procedure TFytopackForm.FormCreate(Sender: TObject);
begin
  SetLength(p,0);
  i:=0;
  a:=GetCurrentDir;
  asl:=a+'\';
  OpenD.InitialDir:=a;
  SaveD.InitialDir:=a;
  Application.HelpFile:=FytopackForm.asl+'Fytopack.hlp';
  //nastavenie normalnych rozmerov
  //FytopackForm.Width:=Screen.Width div 2;
  //FytopackForm.Height:=Screen.Height div 3;

end;

procedure TFytopackForm.OpenClick(Sender: TObject);
begin
  if OpenD.Execute then
    AddPage(OpenD.FileName);
end;


procedure TFytopackForm.SaveClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.Lines.SaveToFile(p[active].subor);
end;

procedure TFytopackForm.SaveAsClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  if SaveD.Execute then
    p[active].edit.Lines.SaveToFile(SaveD.FileName);
end;

procedure TFytopackForm.PrintSetupClick(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

procedure TFytopackForm.PageSetupClick(Sender: TObject);
begin
  PageSetupDialog.Execute;
end;

procedure TFytopackForm.Print1Click(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.Print(ExtractFileName(p[active].subor));
end;

procedure TFytopackForm.CloseFileClick(Sender: TObject);
var active,j:integer;
begin
  active:=PC.ActivePageIndex;
  if active>=0 then begin
    for j:=active to high(p)-1 do begin
      p[j].subor:=p[j+1].subor;
      p[j].sheet:=p[j+1].sheet;//treba aj toto kopirovat inac hrozne errory
      p[j].edit:=p[j+1].edit;
    end;
    PC.ActivePage.Destroy;
    SetLength(p,Length(p)-1);
    dec(i);
  end;
  if active=0 then begin
    StatusBar1.Panels[0].Text:='';
    StatusBar1.Panels[1].Text:='';
  end;

end;

procedure TFytopackForm.CloseAllClick(Sender: TObject);
begin
  while PC.PageCount>0 do begin
    PC.Pages[0].Destroy;
  end;
  SetLength(p,0);
  i:=0;
  StatusBar1.Panels[0].Text:='';
  StatusBar1.Panels[1].Text:='';
end;

procedure TFytopackForm.Timer1Timer(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  if active<>-1 then begin
    StatusBar1.Panels[1].Text:='line: '+IntToStr(p[active].edit.CaretPos.Y+1)
                          +', column: '+IntToStr(p[active].edit.CaretPos.X+1);
    StatusBar1.Panels[0].Text:=p[active].subor;
  end;
end;

procedure TFytopackForm.QuitClick(Sender: TObject);
begin
  FytopackForm.Close;
end;

procedure TFytopackForm.UndoClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.Undo;
end;

procedure TFytopackForm.CutClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.CutToClipboard;
end;

procedure TFytopackForm.CopyBtnClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.CopyToClipboard;
end;

procedure TFytopackForm.PasteClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.PasteFromClipboard;
end;

procedure TFytopackForm.SelectAllClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.SelectAll;
end;

procedure TFytopackForm.DeleteClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.ClearSelection;
end;

procedure TFytopackForm.SearchDown;
var FindText,scope:string;
    StartPos,FoundAt:integer;
    active:integer;
begin
  active:=PC.ActivePageIndex;
  FindText:=FindD.FindText;
  if not(frMatchCase in FindD.Options) then//nerozlisovat male a velke
    FindText:=AnsiLowerCase(FindText);

  if p[active].edit.SelLength <> 0 then
    StartPos := p[active].edit.SelStart + p[active].edit.SelLength
  else
    StartPos := p[active].edit.SelStart;

  scope:=copy(p[active].edit.Text,StartPos+1,MaxInt);
  if not(frMatchCase in FindD.Options) then//nerozlisovat male a velke
    scope:=AnsiLowerCase(scope);

  FoundAt:=pos(FindText,scope);
  if FoundAt<>0 then
    p[active].edit.SelStart:=FoundAt+StartPos-1
  else
    ShowMessage('String not found.');

  p[active].edit.SelLength:=Length(FindText);
  p[active].edit.SetFocus;

end;

procedure TFytopackForm.ReplaceDSearchDown;
var FindText,scope:string;
    StartPos,FoundAt:integer;
    active:integer;
begin
  active:=PC.ActivePageIndex;
  FindText:=ReplaceD.FindText;
  if not(frMatchCase in ReplaceD.Options) then//nerozlisovat male a velke
    FindText:=AnsiLowerCase(FindText);

  if p[active].edit.SelLength <> 0 then
    StartPos := p[active].edit.SelStart + p[active].edit.SelLength
  else
    StartPos := p[active].edit.SelStart;

  scope:=copy(p[active].edit.Text,StartPos+1,MaxInt);
  if not(frMatchCase in ReplaceD.Options) then//nerozlisovat male a velke
    scope:=AnsiLowerCase(scope);

  FoundAt:=pos(FindText,scope);
  if FoundAt<>0 then
    p[active].edit.SelStart:=FoundAt+StartPos-1
  else
    ShowMessage('String not found.');

  p[active].edit.SelLength:=Length(FindText);
  p[active].edit.SetFocus;
end;

procedure TFytopackForm.SearchUp;
var FindText,scope:string;
    ToEnd,FoundAt:integer;
    active:integer;
begin
  active:=PC.ActivePageIndex;
  FindText:=FindD.FindText;
  if not(frMatchCase in FindD.Options) then//nerozlisovat male a velke
    FindText:=AnsiLowerCase(FindText);

  ToEnd := p[active].edit.SelStart;
  scope:=copy(p[active].edit.Text,1,ToEnd);//kde hladat
  if not(frMatchCase in FindD.Options) then//nerozlisovat male a velke
    scope:=AnsiLowerCase(scope);

  //hladanie nahor
  FindText:=AnsiReverseString(FindText);
  scope:=AnsiReverseString(scope);

  FoundAt:=pos(FindText,scope);
  if FoundAt<>0 then
    p[active].edit.SelStart:=ToEnd-FoundAt-Length(FindText)+1
  else
    ShowMessage('String not found.');

  p[active].edit.SelLength:=Length(FindText);
  p[active].edit.SetFocus;
end;

procedure TFytopackForm.ReplaceAll;//od polohy kurzora az po koniec
var FindText,scope:string;
    StartPos,FoundAt:integer;
    active:integer;
begin
  active:=PC.ActivePageIndex;
  FindText:=ReplaceD.FindText;
  while true do begin
    if not(frMatchCase in ReplaceD.Options) then//nerozlisovat male a velke
      FindText:=AnsiLowerCase(FindText);

    if p[active].edit.SelLength <> 0 then
      StartPos := p[active].edit.SelStart + p[active].edit.SelLength
    else
      StartPos := p[active].edit.SelStart;

    scope:=copy(p[active].edit.Text,StartPos+1,MaxInt);
    if not(frMatchCase in ReplaceD.Options) then//nerozlisovat male a velke
      scope:=AnsiLowerCase(scope);

    FoundAt:=pos(FindText,scope);
    if FoundAt<>0 then
      p[active].edit.SelStart:=FoundAt+StartPos-1
    else
      Break;

    p[active].edit.SelLength:=Length(FindText);
    //replace
    p[active].edit.SelText:=ReplaceD.ReplaceText;
  end;
  p[active].edit.SetFocus;
end;

procedure TFytopackForm.FindDFind(Sender: TObject);
begin
  if frDown in FindD.Options then
    SearchDown
  else
    SearchUp;
end;

procedure TFytopackForm.ReplaceDFind(Sender: TObject);
begin
  ReplaceDSearchDown;
end;

procedure TFytopackForm.ReplaceDReplace(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  if frReplace in ReplaceD.Options then
    p[active].edit.SelText:=ReplaceD.ReplaceText;
  if frReplaceAll in ReplaceD.Options then
    ReplaceAll;
end;

procedure TFytopackForm.FindClick(Sender: TObject);
begin
  FindD.Execute;
end;

procedure TFytopackForm.ReplaceClick(Sender: TObject);
begin
  ReplaceD.Execute;
end;

procedure TFytopackForm.FontClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  if FontDialog1.Execute and (active<>-1) then
    p[active].edit.Font:=FontDialog1.Font;
end;

procedure TFytopackForm.MonospacedFontsClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  if FontDialog2.Execute and (active<>-1)then
    p[active].edit.Font:=FontDialog2.Font;
end;

procedure TFytopackForm.AlignLeftClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.Alignment:=taLeftJustify;
  p[active].edit.Lines.SaveToFile(p[active].subor);
  p[active].edit.Lines.LoadFromFile(p[active].subor);
end;

procedure TFytopackForm.AlignRightClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.Alignment:=taRightJustify;
  p[active].edit.Lines.SaveToFile(p[active].subor);
  p[active].edit.Lines.LoadFromFile(p[active].subor);
end;

procedure TFytopackForm.CenterClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.Alignment:=taCenter;
  p[active].edit.Lines.SaveToFile(p[active].subor);
  p[active].edit.Lines.LoadFromFile(p[active].subor);
end;

procedure TFytopackForm.WordWrapClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  p[active].edit.WordWrap:= not p[active].edit.WordWrap;
end;


procedure TFytopackForm.CheckClick(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack -> Check';
  CheckMainForm.Visible:=true;
end;

procedure TFytopackForm.FuseClick(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack -> Fuse';
  FuseForm.Visible:=true;
end;

procedure TFytopackForm.SynonClick(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack -> Synon';
  SynF.Visible:=true;
end;

procedure TFytopackForm.LoadFileFytClick(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack -> Fyt';
  if OpenD.Execute then begin
    AddPage(asl+'fytin.dat');
    AddPage(OpenD.FileName);
  end;

end;

procedure TFytopackForm.RunFytClick(Sender: TObject);
var j:integer;
begin
  FytopackForm.Caption:='Fytopack -> Fyt[RUNNING]';
  //save changes in fytin.dat
  for j:=0 to high(p) do begin
    if p[j].sheet.Caption='fytin.dat' then
      p[j].edit.Lines.SaveToFile(p[j].subor);
  end;
  if FytList.Checked then begin
    Fyt_proc(OpenD.FileName);
    AddFytListToFyt;
  end
  else
    Fyt_proc(OpenD.FileName);
  AddPage(asl+'fyt.dat');
  FytopackForm.Caption:='Fytopack -> Fyt';
end;

procedure TFytopackForm.LoadFileSynopClick(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack -> Synop';
  if OpenD.Execute then begin
    AddPage(asl+'synopin.dat');
    AddPage(OpenD.FileName);
  end;
end;

procedure TFytopackForm.RunSynopClick(Sender: TObject);
var j:integer;
begin
  FytopackForm.Caption:='Fytopack -> Synop[RUNNING]';
  //save changes in synopin.dat
  for j:=0 to high(p) do begin
    if p[j].sheet.Caption='synopin.dat' then
      p[j].edit.Lines.SaveToFile(p[j].subor);
  end;

  nastav_adresar;
  if Synop1.Checked then begin
    synop1_proc(OpenD.FileName);
    AddPage(asl+'synop1.dat');
  end;
  if Synop2.Checked then begin
    synop2_proc(OpenD.FileName);
    AddPage(asl+'synop2.dat');
  end;
  if Synop3.Checked then begin
    synop3_proc(OpenD.FileName);
    AddPage(asl+'synop3.dat');
  end;
  if Synop4.Checked then begin
    synop4_proc(OpenD.FileName);
    AddPage(asl+'synop4.dat');
  end;
  if Synop5.Checked then begin
    synop5_proc(OpenD.FileName);
    AddPage(asl+'synop5.dat');
  end;
  if Synop6.Checked then begin
    synop6_proc(OpenD.FileName);
    AddPage(asl+'synop6.dat');
  end;
  FytopackForm.Caption:='Fytopack -> Synop';
end;

procedure TFytopackForm.RunFulnamClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  FytopackForm.Caption:='Fytopack -> Fulnam[RUNNING]';
  LoadCheckList;
  if Author.Checked then
    FullnamesAndAutor(p[active].subor)
  else
    Fullnames(p[active].subor);
  AddPage(asl+'fulnam.dat');
  AddPage(asl+'fulnam.lst');
  FytopackForm.Caption:='Fytopack -> Fulnam';
end;

procedure TFytopackForm.HelpClick(Sender: TObject);
begin
  //FytopackForm.Caption:='Fytopack -> Help';
  Application.HelpContext(1);//otvori topic s ID=1
end;

procedure TFytopackForm.SyntaxFormatClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  FytopackForm.Caption:='Fytopack -> Utilities -> SyntaxFormat[RUNNING]';
  SyntaxFormat_proc(p[active].subor);
  AddPage(asl+'Syntax.dat');
  FytopackForm.Caption:='Fytopack -> Utilities -> SyntaxFormat';
end;

procedure TFytopackForm.ZipLineClick(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack -> Utilities -> ZipLine[RUNNING]';
  ZipLineForm.Visible:=true;
end;

procedure TFytopackForm.SortLineClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  FytopackForm.Caption:='Fytopack -> Utilities -> SortLine[RUNNING]';
  SortLineProc(p[active].subor);
  AddPage(asl+'SortLineOut.dat');
  FytopackForm.Caption:='Fytopack -> Utilities -> SortLine';
end;

procedure TFytopackForm.TruncClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  FytopackForm.Caption:='Fytopack -> Utilities -> Trunc[RUNNING]';
  trunctate(p[active].subor);
  AddPage(asl+'TruncOut.dat');
  FytopackForm.Caption:='Fytopack -> Utilities -> Trunc';

end;

procedure TFytopackForm.OtherTaxaClick(Sender: TObject);
var active:integer;
begin
  active:=PC.ActivePageIndex;
  FytopackForm.Caption:='Fytopack -> Utilities -> OtherTaxa[RUNNING]';
  OtherTaxaProc(p[active].subor);
  AddPage(asl+'OtherTaxaOut.dat');
  FytopackForm.Caption:='Fytopack -> Utilities -> OtherTaxa';
end;


end.
