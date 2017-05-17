unit FulnamUnit;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls;

type
  TFulF = class(TForm)
    sg: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FulF: TFulF;
  
procedure LoadCheckList;
procedure Fullnames(subor:string);
procedure FullnamesAndAutor(subor:string);

implementation
  uses FytopackUnit;
{$R *.dfm}

var asl:string;//adresar v ktorom je exe file + '\'
    subor:string;//processed file(full path)


    
//example:   original:Achillea millefolium * sudetica
//           modified:Achillea * sudetica
function modified(original:string):string;
var Star,FirstSpace:integer;
begin
  Star:=pos('*',original);
  FirstSpace:=pos(' ',original);
  if Star=0 then
    Result:=original
  else
    Result:=copy(original,1,FirstSpace)+copy(original,Star,MaxInt);
end;


               //text oddeleny ciarkami Coma Separated Values
procedure LoadCheckList;
var t:TextFile;
    line,word:string;
    r,s,col:integer;
begin
  AssignFile(t,asl+'checklist.txt');Reset(t);
  r:=0;
  while not Eof(t) do begin
    readln(t,line);
    FulF.sg.RowCount:=r+1;
    col:=0;
    word:='';
    for s:=1 to Length(line) do begin
      if (line[s]=#9) then //tabulator
      //if (line[s]=',') then
        begin
        FulF.sg.Cells[col,r]:=word;
        word:='';
        inc(col);
        end
      else
        word:=word+line[s];
    end;
    FulF.sg.Cells[col,r]:=word;
    inc(r);
  end;
  CloseFile(t);
end;

procedure FormatFullnames(sin,sout:string;separator:string);
var tin,tout:TextFile;
    line,full,data:string;
    max:integer;
    mark:integer;//pozicia '$' alebo '@'
begin
  AssignFile(tin,sin);Reset(tin);
  AssignFile(tout,sout);Rewrite(tout);
  readln(tin,line);
  writeln(tout,line);
  //max dlzka mena
  max:=0;
  while not Eof(tin) do begin
    readln(tin,line);
    if pos(separator,line)>max then max:=pos(separator,line);
  end;
  Reset(tin);
  readln(tin);
  while not Eof(tin) do begin
    readln(tin,line);
    mark:=pos(separator,line);
    full:=copy(line,1,mark-1);
    data:=copy(line,mark+1,MaxInt);
    line:=Format('%-'+IntToStr(max)+'s',[full])+data;
    writeln(tout,line);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

procedure Fullnames(subor:string);
var tin,tdat,tlst:TextFile;
    line,abrev,data,full:string;
    r:integer;
    col1:string;
begin
  AssignFile(tin,subor);Reset(tin);
  AssignFile(tdat,asl+'FUnformated.dat');Rewrite(tdat);
  AssignFile(tlst,asl+'fulnam.lst');Rewrite(tlst);
  readln(tin,line);
  writeln(tdat,line);
  writeln(tlst,'Fytopack2004 - program Fulnam  Date: '          //hlavicka
             +DateToStr(Date)+'  Time: '+TimeToStr(Time));
  writeln(tlst,'-------------------------------------------------------------------');
  writeln(tlst,'Processed Data File : '+subor);
  writeln(tlst,'List of names without equivalent names in data file '+asl+'checklist.csv');
  writeln(tlst,'');

  while not Eof(tin) do begin
  readln(tin,line);
  abrev:=copy(line,1,9);
  data:=copy(line,11,MaxInt);
  r:=FulF.sg.Cols[4].IndexOf(abrev);
  if r=-1 then begin
    writeln(tdat,abrev+'$'+data);
    writeln(tlst,abrev);
  end
  else begin
    col1:=FulF.sg.Cells[0,r];//prvy stlpec
    if (col1='')or(col1='#') then full:=modified(FulF.sg.Cells[1,r]);
    if (col1='s')or(col1='s#') then full:=modified(FulF.sg.Cells[2,r]);
    writeln(tdat,full+'$'+data);
  end;

  end;
  writeln(tlst,'');
  writeln(tlst,'Fulnam End ;)');
  CloseFile(tin);
  CloseFile(tdat);
  CloseFile(tlst);

  FormatFullnames(asl+'FUnformated.dat',asl+'fulnam.dat','$');
  DeleteFile(asl+'FUnformated.dat');
end;

procedure FullnamesAndAutor(subor:string);
var tin,tdat,tlst:TextFile;
    line,abrev,data,full:string;
    r:integer;
    col1:string;
begin
  AssignFile(tin,subor);Reset(tin);
  AssignFile(tdat,asl+'FUnformated.dat');Rewrite(tdat);
  AssignFile(tlst,asl+'fulnam.lst');Rewrite(tlst);
  readln(tin,line);
  writeln(tdat,line);
  writeln(tlst,'Fytopack2004 - program Fulnam  Date: '          //hlavicka
             +DateToStr(Date)+'  Time: '+TimeToStr(Time));
  writeln(tlst,'-------------------------------------------------------------------');
  writeln(tlst,'Processed Data File : '+subor);
  writeln(tlst,'List of names without equivalent names in data file '+asl+'checklist.csv');
  writeln(tlst,'');

  while not Eof(tin) do begin
  readln(tin,line);
  abrev:=copy(line,1,9);
  data:=copy(line,11,MaxInt);
  r:=FulF.sg.Cols[4].IndexOf(abrev);
  if r=-1 then begin
    writeln(tdat,abrev+'$@'+data);
    writeln(tlst,abrev);
  end
  else begin
    col1:=FulF.sg.Cells[0,r];//prvy stlpec
    if (col1='')or(col1='#') then full:=modified(FulF.sg.Cells[1,r]);
    if (col1='s')or(col1='s#') then full:=modified(FulF.sg.Cells[2,r]);
    writeln(tdat,full+'$'+FulF.sg.Cells[3,r]+'@'+data);
  end;

  end;
  writeln(tlst,'');
  writeln(tlst,'Fulnam End ;)');
  CloseFile(tin);
  CloseFile(tdat);
  CloseFile(tlst);

  FormatFullnames(asl+'FUnformated.dat',asl+'FUnfAutor.dat','$');
  FormatFullnames(asl+'FUnfAutor.dat',asl+'fulnam.dat','@');
  DeleteFile(asl+'FUnformated.dat');
  DeleteFile(asl+'FUnfAutor.dat');
end;


procedure TFulF.FormCreate(Sender: TObject);
begin
  asl:=FytopackForm.asl;
end;

end.
