unit SynonUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls, Grids, FileCtrl;

type
  TSynF = class(TForm)
    MainMenu1: TMainMenu;
    LoadFile: TMenuItem;
    OpenDialog1: TOpenDialog;
    Quit: TMenuItem;
    StatusBar1: TStatusBar;
    RunSynon: TMenuItem;
    SG: TStringGrid;
    FileListBox1: TFileListBox;
    ChL: TStringGrid;
    procedure LoadFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RunSynonClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure SGDblClick(Sender: TObject);
    procedure SGSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    selected:string;//vybrany subor zo SG
    meno:string;
    { Public declarations }
  end;

var
  SynF: TSynF;

implementation
  uses FytopackUnit,SynonEditorUnit,StrUtils;
{$R *.dfm}

var a:string;//adresar v ktorom je exe file
    asl:string;//asl=a+'\'
    BadNames:array of string;//mena ktore nie su v zoznamoch a homonyma
    poc:integer;
    StrSel:array of string;
procedure LoadCheckList;
var t:TextFile;
    line,word:string;
    r,s,col:integer;
begin
  AssignFile(t,asl+'checklist.txt');Reset(t);
  r:=0;
  while not Eof(t) do begin
    readln(t,line);
    SynF.ChL.RowCount:=r+1;
    col:=0;
    word:='';
    for s:=1 to Length(line) do begin
      if (line[s]=#9) then   //tabulator
      //if (line[s]=',') then
        begin
        SynF.ChL.Cells[col,r]:=word;
        word:='';
        inc(col);
        end
      else
        word:=word+line[s];
    end;
    SynF.ChL.Cells[col,r]:=word;
    inc(r);
  end;
  CloseFile(t);
end;

//skratku hladam v stlpci 7 a vratim obsahy stlpcov 2 a 5
//tolkokrat kolkokrat je v stlpci 7
procedure FillBadNames(abrev:string);
var r:integer;
begin
  for r:=0 to SynF.ChL.RowCount-1 do begin
    if SynF.ChL.Cells[6,r]=abrev then begin
      SetLength(BadNames,poc+1);
      BadNames[poc]:=Stuffstring(abrev,9,1,'#')+' '+
                     abrev+' | '+
                     SynF.ChL.Cells[1,r]+' | '+
                     SynF.ChL.Cells[3,r]+' | '+
                     SynF.ChL.Cells[4,r];
      inc(poc);
    end;
  end;
end;

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

function zip(subor,meno:string):string;//vracia scitane data (jeden riadok)
var j:integer;
    s:integer;//index stlpca
    sum:real;
    line:string;
    NonZero:integer;//pocet nenulovych hodnot
begin
  SetLength(Result,Length(StrSel[0]));

  NonZero:=0;
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
      if line[s]<>'0' then inc(NonZero);
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
  if NonZero>Length(StrSel[0]) then
      ShowMessage('WARNING: Fusing more than 1 non-zero value!'+#13+
                  'FILE: '+ExtractFileName(subor)+#13+
                  'NAME: '+meno);
end;

//zozipuje mena ktore sa opakuju v subore CorrectNames.$$$
//uvedie spravny pocet riadkov po zipovani
procedure FinishSynonDat(subor:string);
var tin,tout:TextFile;
    line,name,memory,meno:string;
    text:array of string;
    i,j,poc:integer;
begin
// CorrectNames.$$$ - subor so spravnymi menami podla CheckListu,niektore
//                    mena sa vyskytuju viack krat
// Zipped.$$$ - subor v ktorom je kazde meno len raz, data su zozipovane
//                subor nie je zotriedeny, pocet riadkov nie je aktualny
  AssignFile(tin,asl+'CorrectNames.$$$');Reset(tin);
  Assignfile(tout,asl+'Zipped.$$$');Rewrite(tout);
  readln(tin,line);
  writeln(tout,line);

  //nacitanie suboru CorrectNames.$$$ do pola text
  i:=0;
  SetLength(text,0);
  while not Eof(tin) do begin
    readln(tin,line);
    SetLength(text,i+1);
    text[i]:=line;
    inc(i);
  end;

  //zipovanie a vypis do Zipped.$$$
  for i:=0 to high(text) do begin
  if text[i]<>'' then begin
    SetLength(StrSel,1);
    StrSel[0]:=copy(text[i],11,MaxInt);
    poc:=1;
    name:=copy(text[i],1,9);
    for j:=i+1 to high(text) do begin
      if name=copy(text[j],1,9) then begin
        SetLength(StrSel,poc+1);
        StrSel[poc]:=copy(text[j],11,MaxInt);
        text[j]:=''; //zmazanie zipovaneho riadku
        inc(poc);
      end;
    end;
    meno:=copy(text[i],1,10);
    writeln(tout,meno+zip(subor,meno));//vypis
    //text[i]:=copy(text[i],1,10)+zip;
  end;
  end;
  CloseFile(tin);
  CloseFile(tout);

  AssignFile(tin,asl+'Zipped.$$$');Reset(tin);
  Assignfile(tout,asl+'SynonOut\'+ExtractFileName(subor));Rewrite(tout);
  readln(tin);//preskoc prvy riadok

  //nacitanie suboru Zipped.$$$ do pola text
  i:=0;
  SetLength(text,0);
  while not Eof(tin) do begin
    readln(tin,line);
    SetLength(text,i+1);
    text[i]:=line;
    inc(i);
  end;

  //aktualizacia poctu riadkov vo konecnom subore
  Reset(tin);
  readln(tin,line);
  line:=copy(line,1,10)+Format('%5d',[Length(text)])+copy(line,16,MaxInt);
  writeln(tout,line);

  //zotriedenie riadkov a vypis do konecneho suboru
  for j:=low(text) to high(text) do begin
    for i:=j+1 to high(text) do begin
      if text[j] > text[i] then begin
        memory:=text[i];
        text[i]:=text[j];
        text[j]:=memory;
      end;
    end;
    writeln(tout,text[j]);//vypis
  end;

  CloseFile(tin);
  CloseFile(tout);

end;

procedure synon(subor:string);
var abrev,correct:string;
    r:integer;
    tin,temp:TextFile;
    line,mark:string;
begin
  AssignFile(tin,subor);Reset(tin);
  AssignFile(temp,asl+'CorrectNames.$$$');Rewrite(temp);
  readln(tin,line);
  writeln(temp,line);
  SetLength(BadNames,0);
  poc:=0;
  while not Eof(tin) do begin
    readln(tin,line);
    abrev:=copy(line,1,9);

    r:=SynF.ChL.Cols[4].IndexOf(abrev);
    if r<>-1 then begin
      mark:=SynF.ChL.Cells[0,r];
      if (mark='#')or(mark='') then correct:=abrev;// or (sg.Cells[0,r]=' ') TRIM??
      if (mark='s')or(mark='s#') then correct:=SynF.ChL.Cells[5,r];
    end
    else begin
      r:=SynF.ChL.Cols[6].IndexOf(abrev);
      if r<>-1 then begin//nasiel medzi homonymami
        correct:=Stuffstring(abrev,9,1,'#');
        FillBadNames(abrev);//vypis na obrazovku oranzovym
      end
      else begin //nenasiel nikde
        correct:=abrev;
        SetLength(BadNames,poc+1);
        BadNames[poc]:=abrev;//vypis na obrazovku zelenym
        inc(poc);
      end;
    end;
    writeln(temp,correct+copy(line,10,MaxInt));
  end;
  CloseFile(tin);
  CloseFile(temp);

  FinishSynonDat(subor);
  DeleteFile(asl+'CorrectNames.$$$');
  DeleteFile(asl+'Zipped.$$$');
end;


////////////////////////////////////////////////////////////////////////////////


procedure TSynF.LoadFileClick(Sender: TObject);
begin

  if OpenDialog1.Execute then begin
    SG.RowCount:=1;
    SG.Rows[0].Clear;
    /////zabezpecenie spravneho poradia OpenDialog1.Files.Strings
    if OpenDialog1.Files.Strings[0]>
                  OpenDialog1.Files.Strings[OpenDialog1.Files.Count-1] then begin
      OpenDialog1.Files.Add(OpenDialog1.FileName);//prilepenie na koniec zoznamu
      OpenDialog1.Files.Delete(0);
    end;
    RunSynon.Enabled:=true;
  end;

end;

procedure TSynF.FormCreate(Sender: TObject);
begin
  a:=FytopackForm.a;
  asl:=a+'\';
  OpenDialog1.InitialDir:=asl+'CheckedData';
  FileListBox1.Directory:=asl+'SynonOut';
  RunSynon.Enabled:=false;
end;


procedure TSynF.RunSynonClick(Sender: TObject);
var i,f:integer;
    NumOfBad:integer;//pocet suborov s chybami
begin
  //vyprazdnenie adresara SynonOut
  for i:=0 to FileListBox1.Count-1 do
    DeleteFile(asl+'SynonOut\'+FileListBox1.Items[i]);


  SynF.Caption:='Synon[RUNNING]';
  SG.ColCount:=2;
  NumOfBad:=0;
  for f:=0 to OpenDialog1.Files.Count-1 do begin
    SG.RowCount:=f+1;
    SG.Rows[f].Clear;//aby boli viditelne zmeny v opravenych suboroch
    SG.Cells[0,f]:=ExtractFileName(OpenDialog1.Files.Strings[f]);
    synon(OpenDialog1.Files.Strings[f]);
    if Length(BadNames)>SG.ColCount-1 then SG.ColCount:=Length(BadNames)+1;

    for i:=low(BadNames) to high(BadNames) do begin
      SG.Cells[i+1,f]:=BadNames[i];
    end;
    sg.Col:=1;
    sg.Row:=f;
    SG.Refresh;
    if Length(BadNames)<>0 then inc(NumOfBad);
    StatusBar1.Panels[0].Text:='Number Of Corrupted Files: '+IntToStr(NumOfBad);
    StatusBar1.Refresh;
  end;
  SynF.Caption:='Synon';
  sg.Col:=1;
  sg.Row:=0;
end;

procedure TSynF.QuitClick(Sender: TObject);
begin
  SynF.Close;
end;

procedure TSynF.SGDblClick(Sender: TObject);
begin

  selected:=OpenDialog1.Files.Strings[SG.Row];
  meno:=SG.Cells[SG.Col,SG.Row];
  SynonEditorForm.Visible:=true;
end;

procedure TSynF.SGSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  StatusBar1.Panels[1].Text:=SG.Cells[ACol,ARow];
end;

procedure TSynF.SGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var s:string;
begin
  s:=SG.Cells[ACol,ARow];
  if ( (s<>'') and (ARow<>0) and (ACol<>0) )then begin
    SG.Canvas.Brush.Color:=RGB(139,227,1);
    SG.Canvas.TextRect(Rect,Rect.Left,Rect.Top,s);
  end;
  if (pos('#',s)<>0)then begin
    SG.Canvas.Brush.Color:=RGB(252,149,66);
    SG.Canvas.TextRect(Rect,Rect.Left,Rect.Top,s);
  end;

end;

procedure TSynF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShowMessage('Saving changes in directory SynonOut.');
  SynF.RunSynon.Click;
  FytopackForm.Caption:='Fytopack';
end;

procedure TSynF.FormShow(Sender: TObject);
begin
  LoadCheckList;
  SG.RowCount:=1;
  SG.ColCount:=12;
  SG.Rows[0].Clear;
end;

end.
