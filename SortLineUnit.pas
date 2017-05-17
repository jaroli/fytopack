unit SortLineUnit;

interface

procedure SortLineProc(subor:string);

implementation
  uses SysUtils,FytopackUnit;

var line:array of integer;
    asl:string;

procedure MakeList(subor:string);
var tin,temp2:TextFile;
    line:string;
    continue:boolean;
    c:char;
begin
  AssignFile(tin,subor);Reset(tin);
  AssignFile(temp2,asl+'SortLineTemp.txt');Rewrite(temp2);
  continue:=true;
  while not Eof(tin) do begin
    while not Eoln(tin) do begin
      read(tin,c);
      if c<>' ' then write(temp2,c) else writeln(temp2);
    end;
    readln(tin);
    writeln(temp2);
  end;
  CloseFile(tin);
  CloseFile(temp2);
end;

procedure ReadInput;
var i:integer;
    tin:TextFile;
    s:string;
begin
  SetLength(line,0);
  ///////////nacitaj riadky do pola
  AssignFile(tin,asl+'SortLineTemp.txt');Reset(tin);
  i:=0;
  while not Eof(tin) do begin
    readln(tin,s);
    if s<>'' then begin
      SetLength(line,i+1);
      line[i]:=StrToInt(Trim(s));
      inc(i);
    end;
  end;
  CloseFile(tin);
end;

procedure sort;
var i,j:integer;
    memory:integer;//Memory
begin
  for j:=low(line) to high(line) do begin
    for i:=j+1 to high(line) do begin
      if line[j] > line[i] then begin
        memory:=line[i];
        line[i]:=line[j];
        line[j]:=memory;
      end;
    end;
  end;

end;

procedure SortLineProc(subor:string);
var i:integer;
    s:string;
    t:TextFile;
begin
  asl:=FytopackForm.asl;
  MakeList(subor);
  ReadInput;
  sort;
  AssignFile(t,asl+'SortLineOut.dat');Rewrite(t);
  for i:=low(line) to high(line) do begin
    if (i mod 13)=0 then writeln(t);
    write(t,Format('%5s',[IntToStr(line[i])])+' ');
  end;
  CloseFile(t);
  DeleteFile(asl+'SortLineTemp.txt');
end;


end.
