unit OtherTaxaUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls;
type
  AoS = array of string;

procedure OtherTaxaProc(subor:string);

implementation
  uses FytopackUnit, StrUtils;

var OrigNumNormal:array of string;//v normalnom formate
    lo,hi,w:integer;//horna a dolna hranica matice,sirka matice

    //vracia prispevok od jedneho znaku pre dany riadok napr.:A (53, 56)
function contribution(symbol,line:string):string;
var  s:integer;
begin
  line:=copy(line,lo,w);
  Result:=' '+symbol+' (';
  for s:=1 to w do begin
    if line[s]=symbol then
      Result:=Result+OrigNumNormal[s-1]+',';
  end;
  Result:=StuffString(Result,Length(Result),1,'),');
  if pos(symbol,line)=0 then Result:='';
end;

function sorted(posch:AoS):AoS;
var memory:string;
    i,j:integer;
begin
  //zotriedenie pola
  for j:=low(posch) to high(posch) do begin
    for i:=j+1 to high(posch) do begin
      if posch[j] > posch[i] then begin
        memory:=posch[i];
        posch[i]:=posch[j];
        posch[j]:=memory;
      end;
    end;
  end;
  //kopirovanie
  SetLength(Result,Length(posch));
  for i:=low(posch) to high(posch) do begin
    Result[i]:=posch[i];
  end;
end;

procedure OtherTaxaProc(subor:string);
var tin,tout:TextFile;
    line,sum,name,last:string;
    i,s:integer;
    OrigNum:array of string;
    text:string;
    posch0,posch1,posch2,posch3:AoS;
    poc0,poc1,poc2,poc3:integer;
begin
  AssignFile(tin,subor);Reset(tin);
  AssignFile(tout,FytopackForm.asl+'OtherTaxaOut.dat');Rewrite(tout);
  //nacitanie Original Number
  readln(tin,line);
  i:=0;
  while (copy(line,1,9)='Orig.Num.') do begin
    SetLength(OrigNum,i+1);
    OrigNum[i]:=line;
    inc(i);
    readln(tin,line);
  end;

  //zistenie rozmerov matice
  line:=OrigNum[high(OrigNum)];
  hi:=Length(Trim(line));
  line:=Trim(copy(line,10,MaxInt));
  lo:=hi-Length(line)+1;
  w:=hi-lo+1;

  //plnenie OrigNumNormal
  SetLength(OrigNumNormal,w);
  for s:=0 to high(OrigNumNormal) do begin
    sum:='';
    for i:=0 to high(OrigNum) do begin
      line:=OrigNum[i];
      sum:=sum+line[s+lo];
    end;
    OrigNumNormal[s]:=Trim(sum);
  end;

  //main
  Reset(tin);
  for i:=0 to high(OrigNum) do
    readln(tin,line);


  SetLength(posch0,0);SetLength(posch1,0);SetLength(posch2,0);SetLength(posch3,0);
  poc0:=0;poc1:=0;poc2:=0;poc3:=0;
  while not Eof(tin) do begin
    text:='';
    readln(tin,line);
    if Trim(line)<>'' then begin // ignoruje prazdne riadky na konci suboru
    name:=Trim(copy(line,1,lo-1));//Kiaeria starkei 0
    last:=name[Length(name)];//0
    text:=name+contribution('r',line)
              +contribution('+',line)
              +contribution('1',line)//1 (28,12),
              +contribution('m',line)
              +contribution('a',line)//a (23),
              +contribution('b',line)
              +contribution('3',line)
              +contribution('4',line)
              +contribution('5',line);
    text:=StuffString(text,Length(text),2,'; ');//Kiaeria starkei 0 1 (28,12), a (23);
    if last='0' then begin
      SetLength(posch0,poc0+1);
      posch0[poc0]:=text;
      inc(poc0);
    end;
    if (last<>'0')and(last<>'2')and(last<>'3') then begin
      SetLength(posch1,poc1+1);
      posch1[poc1]:=text;
      inc(poc1);
    end;
    if last='2' then begin
      SetLength(posch2,poc2+1);
      posch2[poc2]:=text;
      inc(poc2);
    end;
    if last='3' then begin
      SetLength(posch3,poc3+1);
      posch3[poc3]:=text;
      inc(poc3);
    end;
    end;
  end;

  //sort
  posch0:=sorted(posch0);
  posch1:=sorted(posch1);
  posch2:=sorted(posch2);
  posch3:=sorted(posch3);

  //spojenie do textu
  text:=' ';
  for i:=0 to high(posch0) do
    text:=text+posch0[i];
  for i:=0 to high(posch1) do
    text:=text+posch1[i];
  for i:=0 to high(posch2) do
    text:=text+posch2[i];
  for i:=0 to high(posch3) do
    text:=text+posch3[i];

  text:=WrapText(text, #13#10, [';'], 80);//formatovanie
  writeln(tout,text);
  CloseFile(tin);
  CloseFile(tout);

end;



end.
 