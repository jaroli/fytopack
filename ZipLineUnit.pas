unit ZipLineUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Menus, StdCtrls, ComCtrls;

type
  TZipLineForm = class(TForm)
    MainMenu1: TMainMenu;
    LoadFile: TMenuItem;
    Quit: TMenuItem;
    OpenDialog1: TOpenDialog;
    ZipLines: TMenuItem;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    SG: TStringGrid;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure LoadFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SGDblClick(Sender: TObject);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure ZipLinesClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ZipLineForm: TZipLineForm;

implementation
  uses FytopackUnit;
{$R *.dfm}

var asl:string;//uplne meno adresara v ktorom je exe file
    tin,tout,tlist:TextFile;//vstupny, vystupny a .lst textovy subor
    sin:string;//vstupny subor
    StrSel:array of string;//pole vybratych riadkov
    IntSel:array of integer;//pole indexov vybranych riadkov
    i:integer;//index

function zip:string;//vracia scitane data (jeden riadok)
var j:integer;
    s:integer;//index stlpca
    Res:string;
    sum:real;
    line:string;
begin
  SetLength(Result,Length(StrSel[0]));

  for s:=1 to Length(Result) do begin//cez vsetky stlpce
    sum:=0;
    for j:=low(StrSel) to high(StrSel) do begin//cez vsetky vybrane riadky
      line:=StrSel[j];
      if (line[s]='0') then sum:=sum+0;
      if (line[s]='1') then sum:=sum+0.01;
      if (line[s]='2') then sum:=sum+0.1;
      if (line[s]='3') then sum:=sum+2.5;
      if (line[s]='4') then sum:=sum+2.5;
      if (line[s]='5') then sum:=sum+8.75;
      if (line[s]='6') then sum:=sum+18.8;
      if (line[s]='7') then sum:=sum+38;
      if (line[s]='8') then sum:=sum+63;
      if (line[s]='9') then sum:=sum+88;
{
   -BraunBlanket
      if (line[s]='.') then sum:=sum+0;
      if (line[s]='R')or(line[s]='r') then sum:=sum+0.01;
      if (line[s]='+') then sum:=sum+0.1;
      if (line[s]='1') then sum:=sum+2.5;
      if (line[s]='M')or(line[s]='m') then sum:=sum+2.5;
      if (line[s]='A')or(line[s]='a') then sum:=sum+8.75;
      if (line[s]='B')or(line[s]='b') then sum:=sum+18.8;
      if (line[s]='3') then sum:=sum+38;
      if (line[s]='4') then sum:=sum+63;
      if (line[s]='5') then sum:=sum+88;
}
    end;
    if (sum=0)then Result[s]:='0';
    if (sum<0.05) and (sum>0) then Result[s]:='1';
    if (sum<1.0)  and (sum>=0.05) then Result[s]:='2';
    if (sum<5.0)  and (sum>=1.0)   then Result[s]:='3';
    if (sum<12.5) and (sum>=5.0) then Result[s]:='5';
    if (sum<25)   and (sum>=12.5)then Result[s]:='6';
    if (sum<50)   and (sum>=25)  then Result[s]:='7';
    if (sum<75)   and (sum>=50)  then Result[s]:='8';
    if (sum>=75)  then Result[s]:='9';
  end;

end;

procedure TZipLineForm.FormCreate(Sender: TObject);
begin
  asl:=FytopackForm.asl;
  OpenDialog1.InitialDir:=FytopackForm.a;
  SetLength(StrSel,0);
  SetLength(IntSel,0);
  i:=0;
  PageControl1.Pages[0].Caption:='none';
  PageControl1.Pages[1].Caption:='ZipLine.dat';
  PageControl1.Pages[2].Caption:='ZipLine.lst';
  PageControl1.ActivePageIndex:=0;
end;

procedure TZipLineForm.LoadFileClick(Sender: TObject);
var line:string;
    poc:integer;
begin
  if OpenDialog1.Execute then sin:=OpenDialog1.FileName;
  PageControl1.Pages[0].Caption:=ExtractFileName(sin);

  AssignFile(tin,sin); Reset(tin);
  ///////////////////////nastavenie sirky stlpca
  readln(tin,line);
  readln(tin,line);
  SG.ColWidths[0]:=Round(Length(line)*10.05);

  //////////////////////nacitanie suboru
  Reset(tin);
  poc:=0;
  SG.RowCount:=0;
  while not Eof(tin) do begin
    readln(tin,line); inc(poc);//pocet riadkov
    SG.RowCount:=poc;
    SG.Cells[0,poc-1]:=line;
  end;
  CloseFile(tin);
  PageControl1.ActivePageIndex:=0;
end;

procedure TZipLineForm.SGDblClick(Sender: TObject);
var IsSelected:Boolean;
    j,index:integer;
begin
                //je uz riadok vybraty?
  IsSelected:=false;
  for j:=low(IntSel) to high(IntSel) do
    if SG.Row=IntSel[j] then begin
      IsSelected:=true;
      index:=j;
    end;
                //zmazanie uz vybrateho riadku
  if IsSelected then begin
    for j:=index to high(IntSel)-1 do begin//vymazanie hodnoty
      IntSel[j]:=IntSel[j+1];
      StrSel[j]:=StrSel[j+1];
    end;
    SetLength(StrSel,Length(StrSel)-1);//zkratenie poli o 1
    SetLength(IntSel,Length(IntSel)-1);
    dec(i);
  end;
                //vyber dalsieho riadku
  if not IsSelected then begin
    SetLength(StrSel,i+1);
    SetLength(IntSel,i+1);
    StrSel[i]:=SG.Cells[0,SG.Row];//plnenie pola StrSel[]
    IntSel[i]:=SG.Row;//plnenie pola IntSel[]
    inc(i);
  end;
  SG.Repaint;
end;

procedure TZipLineForm.SGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var s:string;
    IsSelected:boolean;
    j:integer;
begin
  IsSelected:=false;
  for j:=low(IntSel) to high(IntSel) do
    if ARow=IntSel[j] then IsSelected:=true;

  s:=SG.Cells[ACol,ARow];
  if IsSelected then begin
    SG.Canvas.Brush.Color:=clGreen;
    SG.Canvas.TextRect(Rect,Rect.Left,Rect.Top,s);
  end;
  
end;

procedure TZipLineForm.ZipLinesClick(Sender: TObject);
var NewName:string;
    j:integer;
    t:TextFile;
    line,line1,NumOfRows:string;
    max,poc:integer;
begin

  NewName:=InputBox('New Name','Write New name:',copy(SG.Cells[SG.Col,SG.Row],1,9) );
  NewName:=Format('%-9.9s', [NewName]);//ak je string kratsi tak doplni medzerami
                                          //ak je dlhsi oreze
  ZipLineForm.Caption:='ZipLine[RUNNING]';
  for j:=low(IntSel) to high(IntSel) do begin //oznacenie riadku
    SG.Cells[0,IntSel[j]]:='!&@(%@*^#!%*(#';
  end;

  SG.Cells[SG.Col,SG.Row]:=NewName+' '+copy(zip,11,MaxInt);

  /////////////////////////////////////////////////////////napisanie ZipLine.dat
  line1:=SG.Cells[0,0];
  NumOfRows:=IntToStr(SG.RowCount-Length(StrSel));
  NumOfRows:=Format('%5d',[SG.RowCount-Length(StrSel)]);
  line1:=copy(line1,1,10)+NumOfRows+copy(line1,16,MaxInt);
  AssignFile(tout,asl+'ZipLine.dat');Rewrite(tout);
  writeln(tout,line1);
  for j:=1 to SG.RowCount-1 do begin
    if SG.Cells[0,j]<>'!&@(%@*^#!%*(#' then
      writeln(tout,SG.Cells[0,j]);
  end;
  CloseFile(tout);
  Memo1.Lines.LoadFromFile(asl+'ZipLine.dat');
  ///////////////////////////////////////////////////////////////nacitanie do SG
  AssignFile(tin,sin); Reset(tin);
  poc:=0;
  SG.RowCount:=0;
  while not Eof(tin) do begin
    readln(tin,line); inc(poc);//pocet riadkov
    SG.RowCount:=poc;
    SG.Cells[0,poc-1]:=line;
  end;
  CloseFile(tin);

  /////////////////////////////////////////////////////////napisanie ZipLine.lst
  AssignFile(tlist,asl+'ZipLine.lst'); Append(tlist);
  line:=NewName+' = ';
  for j:=low(StrSel) to high(StrSel) do begin
    line:=line+copy(StrSel[j],1,9);
    if j<>high(StrSel) then line:=line+' + ';
  end;
  writeln(tlist,line);
  writeln(tlist,'--------------------------------------------------------------------------------');
  CloseFile(tlist);
  Memo2.Lines.LoadFromFile(asl+'ZipLine.lst');
  PageControl1.ActivePageIndex:=2;
  ///////////////////////////////////////////////////obnovenie vychodzieho stavu
  SetLength(StrSel,0);
  SetLength(IntSel,0);
  i:=0;
  ZipLineForm.Caption:='ZipLine';
end;

procedure TZipLineForm.QuitClick(Sender: TObject);
begin
  ZipLineForm.Close;
end;

procedure TZipLineForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FytopackForm.Caption:='Fytopack';
  AssignFile(tlist,asl+'ZipLine.lst'); Append(tlist);
  writeln(tlist,'ZipLine End;');
  CloseFile(tlist);
end;

procedure TZipLineForm.FormShow(Sender: TObject);
begin
  AssignFile(tlist,asl+'ZipLine.lst'); Rewrite(tlist);
  writeln(tlist,'Fytopack2004 - utility ZipLine  Date: '
               +DateToStr(Date)+'  Time: '+TimeToStr(Time));
  writeln(tlist,'--------------------------------------------------------------------------------');
  CloseFile(tlist);
end;
{
procedure TZipLineForm.Button1Click(Sender: TObject);
var j:integer;
begin
  for j:=low(StrSel) to high(StrSel) do begin
    Memo3.Lines.Add(StrSel[j]);
  end;

  for j:=low(StrSel) to high(StrSel) do begin
    Memo3.Lines.Add(IntToStr(IntSel[j]));
  end;

  Memo3.Lines.Add('//////////'+IntToStr(i));
end;
}

end.

