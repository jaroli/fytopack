unit CheckMainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, StdCtrls, FileCtrl, ComCtrls;

type
  TCheckMainForm = class(TForm)
    SG: TStringGrid;
    MainMenu1: TMainMenu;
    RunCheck: TMenuItem;
    FileListBox1: TFileListBox;
    Quit1: TMenuItem;
    StatusBar1: TStatusBar;
    LoadFiles1: TMenuItem;
    OD: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure SGDblClick(Sender: TObject);
    procedure RunCheckClick(Sender: TObject);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure Quit1Click(Sender: TObject);
    procedure LoadFiles1Click(Sender: TObject);
    procedure SGSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    SelFile:string;//subor ktory ma zobrazit Simple Rext Editor
    SelText:string;//text vybranej bunky
    SelCode:integer;//typ chyby vybranej bunky
{   Sel Codes:
    1  symbol//
    2  Number of Cols
    3  Number of Rows
    4  Blank Column
    5  No Abudance
    6  Short Line
    7  Name Repetition
    8  Invalid Symbol
}
  end;

var
  CheckMainForm: TCheckMainForm;

implementation
  uses CheckEditorUnit,FytopackUnit;

{$R *.dfm}


var a:string;//adresar v ktorom je exe subor
    asl:string;
///////////////////////////////////////////////////////////////funkcie pre check

function slash(vstupny_txt:string):string;//hlada ukoncovaci znak '//'
var t:TextFile;
    line:string;
begin
//  Result:='no terminative symbol '+'''//'''+' found';
  Result:='not found';
  AssignFile(t,vstupny_txt);Reset(t);
  readln(t);
  readln(t);
  readln(t);
  readln(t);
  readln(t);
  while not Eof(t) do begin
    readln(t,line);
    if pos('//',line)<>0 then Result:='OK';
  end;
  CloseFile(t);

end;
                     //odrezanie prvych 5 riadkov a vsetkeho za //(vratane//)
procedure cut(vstupny_txt,vystupny_txt:string);
var tin,tout:TextFile;
    line:string;
    continue:boolean;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  readln(tin);
  readln(tin);
  readln(tin);
  readln(tin);
  readln(tin);
  continue:=true;
  while ( (not Eof(tin)) and continue ) do begin
    continue:=false;
    readln(tin,line);
    if pos('//',line)=0 then begin
      writeln(tout,line);
      continue:=true;
    end;
  end;
  CloseFile(tin);
  CloseFile(tout);
end;

function PosOfLastNumber(vstupny_txt:string):integer;//realny pocet sltpcov
var t:TextFile;
    i:integer;
    line:string;
begin
  AssignFile(t,vstupny_txt);Reset(t);
  Result:=0;    //zisti poziciu cislice(okrem 0) ktora je najviac vpravo
  while not Eof(t) do begin
    readln(t,line);
    for i:=1 to Length(line) do begin
      if ( (line[i]>='1') and (line[i]<='9') ) then
        if i>Result then Result:=i;
    end;
  end;
  Result:=Result-10;
  CloseFile(t);
end;

function DeclaredRows(vstupny_txt:string):integer;
var t:TextFile;
    first_line,rows:string;
begin
  AssignFile(t,vstupny_txt);Reset(t);
  readln(t,first_line);
  CloseFile(t);
  rows:=copy(first_line,11,5);//pevny format v modrakoch: 11,12,13,14,15
  rows:=TrimLeft(rows);//odstranenie medzier na okrajoch
  if not TryStrToInt(rows,Result) then
    Result:=-1;
end;

function DeclaredColumns(vstupny_txt:string):integer;
var t:TextFile;
    first_line,columns:string;
begin
  AssignFile(t,vstupny_txt);Reset(t);
  readln(t,first_line);
  CloseFile(t);
  columns:=copy(first_line,6,5);//pevny format v modrakoch: 6,7,8,9,10
  columns:=TrimLeft(columns);//odstranenie medzier na okrajoch
  if not TryStrToInt(columns,Result) then
    Result:=-1;
end;

function CheckNumOfRows(vstupny_txt,cut_txt:string):string;
var t:Textfile;
    poc:integer;
    DecRows:integer;
begin
  DecRows:=DeclaredRows(vstupny_txt);//aby sa funkcia pouzila iba raz
  Result:='OK';                      //(Koli ShowMessage)
  AssignFile(t,cut_txt);Reset(t);
  poc:=0;                //zistenie realneho poctu riadkov(poc)
  while not Eof(t) do begin
    readln(t);
    inc(poc);
  end;

  if poc<>DecRows then
    Result:='is '+IntToStr(poc)+' not '+
    IntToStr(DecRows);

  CloseFile(t);
  if DecRows=-1 then Result:='-1';
end;

function CheckNumOfColumns(vstupny_txt,cut_txt:string):string;
var DecCol:integer;
begin
  DecCol:=DeclaredColumns(vstupny_txt);//aby sa funkcia pouzila iba raz
  Result:='OK';                        //(Koli ShowMessage)

  if PosOfLastNumber(cut_txt)<>DecCol then
    Result:='is '+IntToStr(PosOfLastNumber(cut_txt))+' not '+IntToStr(DecCol);

  if DecCol=-1 then Result:='-1';
end;

procedure ReplaceSpaceWithNull(vstupny_txt,vystupny_txt:string);
var tin,tout:TextFile;
    IniLength,NewLength,i:integer;
    line:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin
    readln(tin,line);
    IniLength:=Length(line);
    NewLength:=PosOfLastNumber(vstupny_txt)+10;
    for i:=11 to IniLength do begin
      if line[i]=' ' then line[i]:='0';
    end;

    SetLength(line,NewLength);
    for i:=IniLength+1 to NewLength do //doplnenie nulami
      line[i]:='0';

    writeln(tout,line);
  end;
  CloseFile(tin);
  CloseFile(tout);

end;
                   //hlada stlpce zo samych nul
function blank_column(vstupny_txt:string):string;
var t:TextFile;
    line:string;
    match:boolean;//=true ak je znak '0'
    found:boolean;//=true ak cely stlpec pozostava len z nul
    i,smax:integer;
begin
  Result:='OK';
  AssignFile(t,vstupny_txt);Reset(t);
  readln(t,line);
  smax:=Length(line);
  Reset(t);
  for i:=11 to smax do begin
    found:=true;
    Reset(t);
    while not Eof(t) do begin
      readln(t,line);
      if line[i]='0' then match:=true else match:=false;
      found:=found and match;
    end;
    if found then Result:='at col.: '+IntToStr(i);
  end;
  CloseFile(t);
end;
                     //hlada riadky ktore obsahuju len nuly
function blank_row(vstupny_txt:string):string;
var t:TextFile;
    line:string;
    i,poc:integer;
    match,found:boolean;
begin
  Result:='OK';
  AssignFile(t,vstupny_txt);Reset(t);

  poc:=0;
  while not Eof(t) do begin
    readln(t,line);inc(poc);
    found:=true;
    for i:=11 to Length(line) do begin
      if line[i]='0' then match:=true else match:=false;
      found:=found and match;
    end;
    if found then Result:='at line: '+IntToStr(poc+5);

  end;
  CloseFile(t);
end;

function short_lines(vstupny_txt:string):string;
var t:Textfile;
    line:string;
    poc:integer;
begin
  Result:='OK';
  AssignFile(t,vstupny_txt);Reset(t);
  poc:=0;
  while not Eof(t) do begin
    readln(t,line); inc(poc);
    if Length(line)<11 then Result:='at line: '+IntToStr(poc+5);
  end;
  CloseFile(t);
end;


function name_repetition(vstupny_txt,vystupny_txt:string):string;
var tin,tout:TextFile;
    line:string;
    FirstChar,name,data:array of string;
    i,j:integer;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

         //zabezpecuje spravny format mien:AGRO REPE->Agro repe
                                     //    agro repe->Agro repe
  i:=0;
  while not Eof(tin) do begin
    readln(tin,line);
    SetLength(FirstChar,i+1);
    SetLength(name,i+1);
    SetLength(data,i+1);
    FirstChar[i]:=copy(line,1,1);
    name[i]:=copy(line,2,9);
    data[i]:=copy(line,11,MaxInt);//len cisla
    name[i]:=UpperCase(FirstChar[i])+LowerCase(name[i]);//meno v spravnom formate
    writeln(tout,name[i]+data[i]);
    inc(i);
  end;
  CloseFile(tin);
  CloseFile(tout);


  /////////////////////opakovanie mien
  Result:='OK';
  for i:=low(name) to high(name)-1 do begin
    for j:=i+1 to high(name) do begin
      if name[i]=name[j] then
        Result:=name[i]+' '+
                IntToStr(i+6)+' & '+IntToStr(j+6);//5 riadkov + 1(posun koli
    end;                                            //poliam i:=0,1,2,..)
  end;

end;

function forbiden_symbols(vstupny_txt:string):string;
var t:TextFile;
    line:string;
    i,poc:integer;
begin
  Result:='OK';
  AssignFile(t,vstupny_txt);Reset(t);
  poc:=0;
  while not Eof(t) do begin
    readln(t,line); inc(poc);
    for i:=11 to Length(line) do begin
      if not( (line[i]>='0') and (line[i]<='9') ) then
        Result:=' '''+line[i]+''' at line: '+IntToStr(poc+5);
    end;
  end;
  CloseFile(t);
end;

////////////////////////////////////////////////////////////////////////////////


procedure TCheckMainForm.FormCreate(Sender: TObject);
begin
  a:=FytopackForm.a;
  asl:=a+'\';
  FileListBox1.Directory:=asl+'CheckedData';
  OD.InitialDir:=asl+'InputData';
  StatusBar1.Panels[0].Text:='Status:';

  SG.Cells[0,0]:='        File';
  SG.Cells[1,0]:='symbol'+'''//''';
  SG.Cells[2,0]:='Number of Col.';
  SG.Cells[3,0]:='Number of Rows';
  SG.Cells[4,0]:='Blank Column';
  SG.Cells[5,0]:='No Abudance';
  SG.Cells[6,0]:='Short Line';
  SG.Cells[7,0]:='Name Repetition';
  SG.Cells[8,0]:='Invalid Symbol';

end;

procedure TCheckMainForm.LoadFiles1Click(Sender: TObject);
begin
  if OD.Execute then begin
//    SG.RowCount:=2;
//    SG.FixedRows:=1;
  end;

  /////zabezpecenie spravneho poradia OD.Files.Strings
  if OD.Files.Strings[0]>OD.Files.Strings[OD.Files.Count-1] then begin
    OD.Files.Add(OD.FileName);//prilepenie na koniec zoznamu
    OD.Files.Delete(0);
  end;

end;

procedure TCheckMainForm.SGDblClick(Sender: TObject);
begin
  SelFile:=SG.Cells[0,SG.Row];//meno vybrateho suboru
  SelText:=SG.Cells[SG.Col,SG.Row];
  SelCode:=SG.Col;
  CheckEditorForm.Visible:=true;
end;

procedure TCheckMainForm.RunCheckClick(Sender: TObject);
var i,j,f:integer;
    tin,tout,formated:TextFile;
    line:string;
    BadFile:boolean;
    NumOfBad:integer;//pocet suborov s nejakou chybou
    CheckCol, CheckRows:string;
begin
  CheckMainForm.Caption:='Check[RUNNING]';

///////////////////////////////////////////////////vymazanie adresara CheckedData
  CreateDir(asl+'CheckedData');//keby este nebol vytvoreny
  FileListBox1.Directory:=asl+'CheckedData';
  for i:=0 to FileListBox1.Count-1 do begin
    DeleteFile(asl+'CheckedData\'+FileListBox1.Items.Strings[i]);
  end;

///////////////////////////////////////////check & zaplnenie CheckedData
  NumOfBad:=0;
  for f:=0 to OD.Files.Count-1 do begin
    SG.RowCount:=f+2;
    SG.Rows[f+1].Clear;//aby boli viditelne zmeny v opravenych suboroch
    SG.Cells[0,f+1]:=ExtractFileName(OD.Files.Strings[f]);
    BadFile:=false;
    if slash(OD.Files.Strings[f])<>'OK' then begin
      SG.Cells[1,f+1]:=slash(OD.Files.Strings[f]);
      BadFile:=true;
    end;
    cut(OD.Files.Strings[f],asl+'cut.txt');

                                             //aby sa funkcia pouzila iba raz
    CheckCol:=CheckNumOfColumns(OD.Files.Strings[f],asl+'cut.txt');
    if CheckCol<>'OK' then begin
      SG.Cells[2,f+1]:=CheckCol;
      BadFile:=true;
    end;
    if CheckCol='-1' then
      ShowMessage('file: '+ExtractFileName(OD.Files.Strings[f])+
      ' Line 1 Error: Number of columns must be written in columns: 6,7,8,9,10');


    CheckRows:=CheckNumOfRows(OD.Files.Strings[f],asl+'cut.txt');//aby sa funkcia pouzila iba raz
    if CheckRows<>'OK' then begin
      SG.Cells[3,f+1]:=CheckRows;
      BadFile:=true;
    end;
    if CheckRows='-1' then
      ShowMessage('file: '+ExtractFileName(OD.Files.Strings[f])+
      ' Line 1 Error: Number of rows must be written in columns: 11,12,13,14,15');


    ReplaceSpaceWithNull(asl+'cut.txt',asl+'WithNull.txt');

    if Blank_column(asl+'WithNull.txt')<>'OK' then begin
      SG.Cells[4,f+1]:=Blank_column(asl+'WithNull.txt');
      BadFile:=true;
    end;

    if blank_row(asl+'WithNull.txt')<>'OK' then begin
      SG.Cells[5,f+1]:=blank_row(asl+'WithNull.txt');
      BadFile:=true;
    end;

    if short_lines(asl+'cut.txt')<>'OK' then begin
      SG.Cells[6,f+1]:=short_lines(asl+'cut.txt');
      BadFile:=true;
    end;

    if name_repetition(asl+'WithNull.txt',asl+'formated.txt')<>'OK' then begin
      SG.Cells[7,f+1]:=name_repetition(asl+'WithNull.txt',asl+'formated.txt');
      BadFile:=true;
    end;

    if forbiden_symbols(asl+'WithNull.txt')<>'OK' then begin
      SG.Cells[8,f+1]:=forbiden_symbols(asl+'WithNull.txt');
      BadFile:=true;
    end;


                          ////////zaplnenie adresara ValidData
    AssignFile(tin,OD.Files.Strings[f]);Reset(tin);//vstup: prvy riadok  (InputData)
    AssignFile(formated,asl+'formated.txt');Reset(formated);//vstup:names+data (InputData)
    AssignFile(tout,asl+'CheckedData\'+ExtractFileName(OD.Files.Strings[f]));Rewrite(tout);//vystup do CheckedData
    readln(tin,line);
    writeln(tout,line);
    while not Eof(formated) do begin
      readln(formated,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(formated);
    CloseFile(tout);

    if BadFile then begin
      inc(NumOfBad);
      StatusBar1.Panels[0].Text:='Number Of Corrupted Files: '+IntToStr(NumOfBad);
      StatusBar1.Refresh;
    end;
    SG.Col:=1;
    SG.Row:=f+1;          //!
    SG.Refresh;
  end;
  SG.Row:=1;

  StatusBar1.Panels[0].Text:='Number Of Corrupted Files: '+IntToStr(NumOfBad);
  StatusBar1.Refresh;

  DeleteFile(asl+'cut.txt');
  DeleteFile(asl+'WithNull.txt');
  DeleteFile(asl+'formated.txt');

  CheckMainForm.Caption:='Check';
end;

procedure TCheckMainForm.SGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var s:string;
begin
  s:=SG.Cells[ACol,ARow];
  if ( (s<>'') and (ARow<>0) and (ACol<>0) )then begin
    SG.Canvas.Brush.Color:=RGB(252,149,66);
    SG.Canvas.TextRect(Rect,Rect.Left,Rect.Top,s);
  end;
end;

procedure TCheckMainForm.Quit1Click(Sender: TObject);
begin
  CheckMainForm.Close;
end;


procedure TCheckMainForm.SGSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ACol=1 then StatusBar1.Panels[1].Text:='Symbol // '+SG.Cells[ACol,ARow];
  if ACol=2 then begin
    if SG.Cells[ACol,ARow]='-1' then
      StatusBar1.Panels[1].Text:='Line 1 Error: Number of columns must be written in columns: 6,7,8,9,10'
    else
      StatusBar1.Panels[1].Text:='Number Of Columns '+SG.Cells[ACol,ARow];
  end;
  if ACol=3 then begin
    if SG.Cells[ACol,ARow]='-1' then
      StatusBar1.Panels[1].Text:=' Line 1 Error: Number of rows must be written in columns: 11,12,13,14,15'
    else
      StatusBar1.Panels[1].Text:='Number Of Rows '+SG.Cells[ACol,ARow];
  end;
  if ACol=4 then StatusBar1.Panels[1].Text:='Blank Column '+SG.Cells[ACol,ARow];
  if ACol=5 then StatusBar1.Panels[1].Text:='No Abudance '+SG.Cells[ACol,ARow];
  if ACol=6 then StatusBar1.Panels[1].Text:='Short Line '+SG.Cells[ACol,ARow];
  if ACol=7 then StatusBar1.Panels[1].Text:='Name Repetition '+SG.Cells[ACol,ARow];
  if ACol=8 then StatusBar1.Panels[1].Text:='Invalid Symbol '+SG.Cells[ACol,ARow];
end;

procedure TCheckMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ShowMessage('Saving changes in directory CheckedData.');
  CheckMainForm.RunCheck.Click;
  FytopackForm.Caption:='Fytopack';
end;

end.
