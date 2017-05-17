unit TruncUnit;

interface

procedure trunctate(subor:string);

implementation
  uses StrUtils,FytopackUnit;


{
h-> agro repe
t-> agro rep3
s-> agro rep2
j-> agro repe
m-> agro rep0
}
procedure trunctate(subor:string);
var tin,tout:TextFile;
    line,abrev:string;
    gap:integer;
begin
  AssignFile(tin,subor);Reset(tin);
  AssignFile(tout,FytopackForm.asl+'TruncOut.dat');Rewrite(tout);
  readln(tin,line);
  writeln(tout,line);
  while not Eof(tin) do begin
    readln(tin,line);
    gap:=pos(' ',line); //pozicia medzery
    abrev:=copy(line,1,4)+' '+copy(line,gap+1,4)+'  '+copy(line,1,22);
    if line[24]='t' then abrev:=StuffString(abrev,9,1,'3');
    if line[24]='s' then abrev:=StuffString(abrev,9,1,'2');
    if line[24]='m' then abrev:=StuffString(abrev,9,1,'0');
    writeln(tout,abrev);
  end;
  CloseFile(tin);
  CloseFile(tout);

end;

end.
 