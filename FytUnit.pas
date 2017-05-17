unit FytUnit;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls;

type
  stlpec = array of char;
  matica = array of stlpec;

  PoleCol = array of integer;  //nove poradie stlpcov
  PoleBlank = array of integer; //blank columns
  PoleSub = array of integer;   //subdivisions(statistika)

  PolePruh = array of string;  //pole stringov[1..rmax]
  PoleCelPer = array of real; //pole celkovych percent[1..rmax]

procedure Fyt_proc(subor:string);
procedure AddFytListToFyt;

  
implementation
  uses FytopackUnit;


var new,old,final:matica;  //m[stlpec,riadok]
    rmax,smax,nocins,nobc,nos,sort,convert:integer;
    pc:PoleCol;
    pb:PoleBlank;
    ps:PoleSub;
    pp:PolePruh;
    new_ps:PoleSub;
    new_pb:PoleBlank;
    aft_ins_pb:PoleBlank;
    line1:string;//prvy riadok synon.dat
//    subor:string;//cely nazov vstupneho suboru
    a:string;//cely nazov adresara v ktorom je exe subor
    asl:string;//asl=a+'\'

procedure read_fytins_constants(vstupny_txt:string;
                          var rmax,smax,nocins,nobc,nos,sort,convert:integer);
var tin:TextFile;
    line:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(tin);//preskoci nazov

  readln(tin,line);
  rmax:=StrToInt(Trim(copy(line,34,MaxInt)));

  readln(tin,line);
  smax:=StrToInt(Trim(copy(line,34,MaxInt)));

  readln(tin,line);
  nocins:=StrToInt(Trim(copy(line,34,MaxInt)));

  readln(tin,line);
  nobc:=StrToInt(Trim(copy(line,34,MaxInt)));

  readln(tin,line);
  nos:=StrToInt(Trim(copy(line,34,MaxInt)));

  readln(tin,line);
  sort:=StrToInt(Trim(copy(line,34,MaxInt)));

  readln(tin,line);
  convert:=StrToInt(Trim(copy(line,34,MaxInt)));

  CloseFile(tin);
end;


procedure read_pos_of_col_blank_sub(vstupny_txt:string;
                                    var PCol:PoleCol;
                                    var PBlank:PoleBLank;
                                    var PSub:PoleSub);
var tin,temp1,temp2:TextFile;//dva pomocne subory
    i,poc:integer;
    c:char;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(temp1,asl+'temp1.txt');Rewrite(temp1);

  for i:=1 to 8 do//preskocenie prvych 8 riadkov
    readln(tin);

////////////////////////////////napisanie temp1->nahradenie medzier
  while not Eof(tin) do begin // novymi riadkami
    if Eoln(tin) then
      begin
        readln(tin);
        writeln(temp1);
      end
    else
      begin
        read(tin,c);
        if c=' ' then
          writeln(temp1)
        else
          write(temp1,c);
      end;
  end;
  CloseFile(tin);

  /////////////////////napisnie temp2-> v kazdom riadku jedno cislo
  Reset(temp1);
  AssignFile(temp2,asl+'temp2.txt'); Rewrite(temp2);
  while not Eof(temp1) do begin
    readln(temp1,s);
    if (length(s)<>0) then writeln(temp2,s);

  end;

  Reset(temp2);
  //////////////////array of columns in new sequence
  poc:=1;
  while (poc<=nocins) do begin
    readln(temp2,s);
    PCol[poc]:=StrToInt(s);
    inc(poc);
  end;
  /////////////////array OF BLANK COLUMNS
  poc:=1;
  while (poc<=nobc) do begin
    readln(temp2,s);
    PBlank[poc]:=StrToInt(s);
    inc(poc);
  end;
  /////////////////array OF SUBDIVISIONS
  poc:=1;
  while (poc<=nos) do begin
    readln(temp2,s);
    PSub[poc]:=StrToInt(s);
    inc(poc);
  end;

  CloseFile(temp1);
  CloseFile(temp2);
  DeleteFile(asl+'temp1.txt');
  DeleteFile(asl+'temp2.txt');
end;

procedure read_pos_of_blank_sub(vstupny_txt:string;
                                    var PBlank:PoleBLank;
                                    var PSub:PoleSub);
var tin,temp1,temp2:TextFile;//dva pomocne subory
    i,poc:integer;
    c:char;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(temp1,asl+'temp1.txt');Rewrite(temp1);

  for i:=1 to 8 do//preskocenie prvych 8 riadkov
    readln(tin);

////////////////////////////////napisanie temp1->nahradenie medzier
  while not Eof(tin) do begin // novymi riadkami
    if Eoln(tin) then
      begin
        readln(tin);
        writeln(temp1);
      end
    else
      begin
        read(tin,c);
        if c=' ' then
          writeln(temp1)
        else
          write(temp1,c);
      end;
  end;
  CloseFile(tin);

  /////////////////////napisnie temp2-> v kazdom riadku jedno cislo
  Reset(temp1);
  AssignFile(temp2,asl+'temp2.txt'); Rewrite(temp2);
  while not Eof(temp1) do begin
    readln(temp1,s);
    if (length(s)<>0) then writeln(temp2,s);

  end;

  Reset(temp2);
  /////////////////array OF BLANK COLUMNS
  poc:=1;
  while (poc<=nobc) do begin
    readln(temp2,s);
    PBlank[poc]:=StrToInt(s);
    inc(poc);
  end;
  /////////////////array OF SUBDIVISIONS
  poc:=1;
  while (poc<=nos) do begin
    readln(temp2,s);
    PSub[poc]:=StrToInt(s);
    inc(poc);
  end;

  CloseFile(temp1);
  CloseFile(temp2);
  DeleteFile(asl+'temp1.txt');
  DeleteFile(asl+'temp2.txt');
end;

procedure read_numbers_only(vstupny_txt,vystupny_txt:string);
var tin,tout:TextFile;
    c:char;
    i:integer;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  readln(tin);
  for i:=1 to 10 do
    read(tin,c);
  while not Eof(tin) do begin
    if Eoln(tin) then
      begin
        readln(tin);
        for i:=1 to 10 do
          read(tin,c);
        writeln(tout);
      end
    else
      begin
        read(tin,c);
        write(tout,c);
      end;

  end;
  CloseFile(tin);
  CloseFile(tout);

end;

                                    //nacita znaky z tin do pola m[s,r]
procedure scan(var m:matica;stlpce_max:integer;vstupny_txt:string);
var c:char;
    s,r:integer;
    tin:TextFile;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  for r:=1 to rmax do begin
    for s:=1 to stlpce_max do begin
      read(tin,c);
      m[s,r]:=c;
    end;
    readln(tin);
  end;
  CloseFile(tin);
end;

procedure vypis(pole:matica;stlpce_max:integer;vystupny_txt:string);
var s,r:integer;
    tout:TextFile;
begin
  AssignFile(tout,vystupny_txt);Rewrite(tout);
  for r:=1 to rmax do begin
    for s:=1 to stlpce_max do begin
      write(tout,pole[s,r]);
    end;
    writeln(tout);
  end;

  CloseFile(tout);
end;


procedure prehod_stlpce(var new:matica; old:matica; pc:PoleCol);
var s,r:integer;

begin
  for r:=1 to rmax do begin
    for s:=1 to nocins do begin
      new[s,r]:=old[pc[s],r];
    end;
  end;

end;

procedure celkove_percenta(var p:PolePruh;var pcp:PoleCelPer;m:matica);
var s,r,poc,priem,suma:integer;
    per:real;
begin

  for r:=1 to rmax do begin
    poc:=0;
    suma:=0;
    for s:=1 to nocins do begin
      if m[s,r]<>'0' then begin
        inc(poc);
        suma:=suma+StrToInt(new[s,r]);
      end;
    end;
    pcp[r]:=(poc/nocins)*100;//nezaokruhlene realne cislo
    per:=(poc/nocins)*100;
    if poc=0 then priem:=0;
    if poc<>0 then priem:=round(suma/poc+0.0000000000001);//zaokruhlovanie nahor
    pp[r]:=Format('%11.6f',[per])+'% '+IntToStr(priem);
  end;

end;

procedure read_names(var p:PolePruh;vstupny_txt:string);
var c:char;
    tin:TextFile;
    i:integer;
    s:string;
    name:string[10];
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(tin);

  for i:=1 to rmax do begin
    readln(tin,s);
    name:=s+' ';
    p[i]:=name;
  end;
  CloseFile(tin);
end;

procedure append(vstupno_vystupny_txt:string; PPruh:PolePruh);
var temp,t:TextFile;
    s:string;
    i:integer;
begin
  AssignFile(t,vstupno_vystupny_txt);Reset(t);
  AssignFile(temp,asl+'temp3.txt');Rewrite(temp);

  for i:=1 to rmax do begin
    readln(t,s);
    writeln(temp,s+PPruh[i]);
  end;

  CloseFile(t);
  CloseFile(temp);
  DeleteFile(vstupno_vystupny_txt);
  RenameFile(asl+'temp3.txt',vstupno_vystupny_txt);
end;


procedure statistika(vystupny_txt:string;new:matica;ps:PoleSub);
var i,lo,hi,r,s:integer;
    t:TextFile;
    pruh:PolePruh;
                       //pomocna procedura pre percenta
  procedure go(new:matica;lo,hi:integer;vystupny_txt:string);
  var s,r:integer;
      poc,per,priem,suma:integer;
      pp:PolePruh;
  begin
    SetLength(pp,rmax+1);
    for r:=1 to rmax do //nulovanie pola stringov
      pp[r]:='';

                  //napisanie stlpcov od lo do hi

    for r:=1 to rmax do begin
      for s:=lo to hi do begin

        if convert=0 then        //ak je convert=0 znaky sa len opisu
          pp[r]:=pp[r]+new[s,r];
        if convert=1 then begin      //ak je convert=1 robi sa konverzia
          if new[s,r]='0' then pp[r]:=pp[r]+'.';
          if new[s,r]='1' then pp[r]:=pp[r]+'r';
          if new[s,r]='2' then pp[r]:=pp[r]+'+';
          if new[s,r]='3' then pp[r]:=pp[r]+'1';
          if new[s,r]='4' then pp[r]:=pp[r]+'m';
          if new[s,r]='5' then pp[r]:=pp[r]+'a';
          if new[s,r]='6' then pp[r]:=pp[r]+'b';
          if new[s,r]='7' then pp[r]:=pp[r]+'3';
          if new[s,r]='8' then pp[r]:=pp[r]+'4';
          if new[s,r]='9' then pp[r]:=pp[r]+'5';
        end;

      end;
    end;
    append(vystupny_txt,pp);//prilepenie plneho pola do suboru vystupny_txt

    for r:=1 to rmax do//nulovanie pola stringov (od 1 do pocet riadkov)
      pp[r]:='';

                     //naplnenie pola stringov statistikou pre stlpce lo az hi
    for r:=1 to rmax do begin
      poc:=0;
      suma:=0;
      for s:=lo to hi do begin
        if new[s,r]<>'0' then begin
          inc(poc);
          suma:=suma+StrToInt(new[s,r]);
        end;
      end;
      per:=round((poc/(hi-lo+1))*100+0.00000000000001);//aby zaokhruhloval nahor
      if poc=0 then priem:=0;
      if poc<>0 then priem:=round(suma/poc+0.000000000001);//aby zaokhruhloval nahor
      if (per<=9) then pp[r]:='   '+IntToStr(per)+'% '+IntToStr(priem)+' ';
      if (per>=10)and (per<=99) then pp[r]:='  '+IntToStr(per)+'% '+IntToStr(priem)+' ';
      if (per>=100) then pp[r]:=' '+IntToStr(per)+'% '+IntToStr(priem)+' ';
    end;

    append(vystupny_txt,pp);//prilepenie plneho pola stringov do suboru vystupny_txt
  //////////////////////////////////////////

  end;

begin
  AssignFile(t,vystupny_txt); Rewrite(t);//zmazanie t
  CloseFile(t);

  SetLength(pruh,rmax+1);

  for i:=1 to nos do begin
    if (i=1) then lo:=1;
    if (i>=2) then lo:=ps[i-1]+1;
    hi:=ps[i];
    go(new,lo,hi,vystupny_txt);
  end;
 //////////////////////////pripisanie koncovych stlpcov
                           //ktore su bez statistiky
  for r:=1 to rmax do
    pruh[r]:='';

  for r:=1 to rmax do begin
    for s:=(hi+1) to nocins do begin
      pruh[r]:=pruh[r]+new[s,r];
    end;
  end;
  append(vystupny_txt,pruh);

end;



{
pc: 10 9 8 7 6 5 4 3 2  <-nove poradie stlpcov(fytin.txt)
pb: 10 6     <-chcem medzery za stlpcom cislo 10 a 6  (fytin.txt)
compute_new_pb(new_pb,pb,pc);
new_pb: 1 5    <-medzery budu vlozene za prvy a piaty stlpec v poradi
->nasleduje compute_pb_after_insertion_of_stat;
(dalsie prepocitavanie suradnic medzier po vlozeni statistik)
}
procedure compute_new_pb(var new_sorted_pb:PoleBlank;fytin_pb:PoleBlank;pc:PoleCol);
var i,j:integer;
    new_uns_pb:PoleBlank;
                   //sort:len cislice,okrem 0,jedno cislo maximalne raz!!!
  procedure sort(var sorted:PoleBlank;uns:PoleBlank);
  var i,j,lo,hi:integer;
  begin
    SetLength(sorted,nobc+1);
    lo:=maxint;
    hi:=0;
    for j:=1 to nobc do begin
      for i:=1 to nobc do begin
        if (uns[i]<lo) and (uns[i]>hi) then lo:=uns[i];
      end;
      sorted[j]:=lo;
      hi:=lo;
      lo:=maxint;
    end;
  end;

begin
  SetLength(new_uns_pb,nobc+1);
  for j:=1 to nobc do begin
    for i:=1 to nocins do begin
      if fytin_pb[j]=pc[i] then new_uns_pb[j]:=i;
    end;
  end;

  sort(new_sorted_pb,new_uns_pb);
end;


{
pc: 10 9 8 7 6 5 4 3 2  <-nove poradie stlpcov(fytin.txt)
ps: 8 4 2     <-chcem statistiku za stlpcom cislo 8,4 a 2  (fytin.txt)
compute_new_ps(new_ps,ps,pc);
new_ps: 3 7 9 <-statistiky budu vlozene za treti,siedmy a deviaty stlpec v poradi
}
procedure compute_new_ps(var new_sorted_ps:PoleSub;fytin_ps:PoleSub;pc:PoleCol);
var i,j:integer;
    new_uns_ps:PoleSub;
                 //sort:len cislice,okrem 0,jedno cislo maximalne raz!!!
  procedure sort(var sorted:PoleSub;uns:PoleSub);
  var i,j,lo,hi:integer;
  begin
    SetLength(sorted,nos+1);
    lo:=maxint;
    hi:=0;
    for j:=1 to nos do begin
      for i:=1 to nos do begin
        if (uns[i]<lo) and (uns[i]>hi) then lo:=uns[i];
      end;
      sorted[j]:=lo;
      hi:=lo;
      lo:=maxint;
    end;
  end;

begin
  SetLength(new_uns_ps,nos+1);
  for j:=1 to nos do begin
    for i:=1 to nocins do begin
      if fytin_ps[j]=pc[i] then new_uns_ps[j]:=i;
    end;
  end;

  sort(new_sorted_ps,new_uns_ps);
end;


            //treba zmenit nocins na vacsie cislo!!!
procedure write_blank(vystupny_txt:string;m:matica;pb:PoleBlank);
var i,lo,hi,r,s:integer;
    t:TextFile;
    pruh:PolePruh;
                       //pomocna procedura
  procedure go(new:matica;lo,hi:integer;vystupny_txt:string);
  var s,r:integer;
      pp:PolePruh;
  begin
    SetLength(pp,rmax+1);
    SetLength(new,smax+1,rmax+1);
    for r:=1 to rmax do
      pp[r]:='';

    for r:=1 to rmax do begin
      for s:=lo to hi do begin
        pp[r]:=pp[r]+new[s,r];
      end;
    end;
    append(vystupny_txt,pp);

    for r:=1 to rmax do    //pridanie stlpcu medzier
      pp[r]:=' ';
    append(vystupny_txt,pp);
  end;

begin
  AssignFile(t,vystupny_txt); Rewrite(t);//zmazanie t
  CloseFile(t);

  SetLength(pruh,rmax+1);

  for i:=1 to nobc do begin
    if (i=1) then lo:=1;
    if (i>=2) then lo:=pb[i-1]+1;
    hi:=pb[i];
    go(m,lo,hi,vystupny_txt);
  end;
 //////////////////////////pripisanie koncovych stlpcov
                           //ktore su bez statistiky
  for r:=1 to rmax do
    pruh[r]:='';

  for r:=1 to rmax do begin
    for s:=(hi+1) to smax do begin
      pruh[r]:=pruh[r]+m[s,r];
    end;
  end;
  append(vystupny_txt,pruh);

end;


                           //after insertion,before insertion of statistics
procedure compute_pb_after_insertion_of_stat(var after_ins:PoleBlank;
                                                 before_ins:PoleBlank;
                                                 ps:PoleSub);
var i,j,poc:integer;
begin
  for j:=1 to nobc do begin
    poc:=0;
    for i:=1 to nos do begin
      if ps[i]<before_ins[j] then inc(poc);
    end;
    after_ins[j]:=before_ins[j]+poc*8;
  end;

end;



procedure sort_according_percent(vystupny_txt,vstupny_txt:string;pcp:PoleCelPer);
var tin,tout:TextFile;
    i,j:integer;
    p1,p2:array of string;
    lor,hir:real;//lo real,hi real
    los,his:string; //lo string,hi string
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);
  writeln(tout,line1);//vypis prveho riadku zo synon.dat

  SetLength(p1,rmax+1);
  SetLength(p2,rmax+1);

  for i:=1 to rmax do
    readln(tin,p1[i]);

                //zoradenie p1 od najmensieho percenta po najvacsie
  for j:=1 to (rmax-1) do begin
    for i:=j to rmax do begin
      if pcp[j]>pcp[i] then begin
        lor:=pcp[i];hir:=pcp[j];
        pcp[j]:=lor;pcp[i]:=hir;
        los:=p1[i];his:=p1[j];
        p1[j]:=los;p1[i]:=his;
      end;
    end;
  end;

  j:=rmax;     //zoradenie p2 od najvacsieho percenta po najmensie
  for i:=1 to rmax do begin
    p2[i]:=p1[j];
    dec(j);
  end;

  for i:=1 to rmax do //zapisanie p2 do vystup_txt
    writeln(tout,p2[i]);

  CloseFile(tin);
  CloseFile(tout);
end;

                          //odstranenie riadkov s nulovou celkovou statistikou
                          //t.j 0.000000% , bez jedineho vyskytu
procedure remove_null_per(vstupny_txt,vystupny_txt:string);
var s,per:string;
    tin,tout:Textfile;
    L:integer;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  readln(tin,s);
  writeln(tout,s);//opisanie 1. riadku
  while not Eof(tin) do begin
    readln(tin,s);
    L:=Length(s);
    per:=Trim(copy(s,L-13,11));
    if per<>'0.000000' then begin
      s:=copy(s,1,L-13)+Format('%3.0f',[StrToFloat(per)])+copy(s,L-2,MaxInt);
      writeln(tout,s);
    end;
  end;

  CloseFile(tin);
  CloseFile(tout);
end;


//  ->ak nos<>0 potom konverzia sa robi len vo vybratych castiach
//  ->staci zadat nos=posledny stlpec a vsetko je OK(konverzia je vsade)
procedure LastProcedure(vstupno_vystutny_txt:string);
var t,temp:TextFile;
    line:string;
    i:integer;
begin
  AssignFile(t,vstupno_vystutny_txt);Reset(t);
  AssignFile(temp,asl+'tempq.txt');Rewrite(temp);

  readln(t,line); writeln(temp,line);//kopirovanie prveho riadku

  while not Eof(t) do begin
    readln(t,line);
    for i:=11 to Length(line)-7 do begin//konverzia Braun-Blanket
      if line[i]='0' then line[i]:='.';
      if line[i]='1' then line[i]:='r';
      if line[i]='2' then line[i]:='+';
      if line[i]='3' then line[i]:='1';
      if line[i]='4' then line[i]:='m';
      if line[i]='5' then line[i]:='a';
      if line[i]='6' then line[i]:='b';
      if line[i]='7' then line[i]:='3';
      if line[i]='8' then line[i]:='4';
      if line[i]='9' then line[i]:='5';
    end;
    writeln(temp,line);
  end;

  CloseFile(t);
  CloseFile(temp);

  AssignFile(t,vstupno_vystutny_txt);Rewrite(t);//kopirovanie tempq.txt->fyt.dat
  AssignFile(temp,asl+'tempq.txt');Reset(temp);
  while not Eof(temp) do begin
    readln(temp,line);
    writeln(t,line);
  end;
  CloseFile(t);
  CloseFile(temp);
  DeleteFile(asl+'tempq.txt');

end;

procedure UpdateFirstLine(vstupno_vystupny_txt:string);
var t,temp:TextFile;
    line,NoRow,NoCol:string;
    poc:integer;//pocet riadkov
begin

  AssignFile(t,vstupno_vystupny_txt);Reset(t);
  AssignFile(temp,asl+'UpdateTemp.txt');Rewrite(temp);

  poc:=0;
  while not Eof(t) do begin
    readln(t,line);
    inc(poc);
  end;
  Reset(t);
  readln(t,line);
  NoRow:=IntToStr(poc-1);
  if nocins=0 then NoCol:=IntToStr(smax) else NoCol:=IntToStr(nocins);
  ///////spravny format prveho riadku:
  if Length(NoRow)=1 then NoRow:='    '+NoRow;
  if Length(NoRow)=2 then NoRow:='   '+NoRow;
  if Length(NoRow)=3 then NoRow:='  '+NoRow;
  if Length(NoRow)=4 then NoRow:=' '+NoRow;
  if Length(NoCol)=1 then NoCol:='    '+NoCol;
  if Length(NoCol)=2 then NoCol:='   '+NoCol;
  if Length(NoCol)=3 then NoCol:='  '+NoCol;
  if Length(NoCol)=4 then NoCol:=' '+NoCol;

  line:=copy(line,1,5)+NoCol+NoRow+copy(line,16,MaxInt);
  writeln(temp,line);
  while not Eof(t) do begin
    readln(t,line);
    writeln(temp,line);
  end;
  CloseFile(t);
  CloseFile(temp);
  DeleteFile(vstupno_vystupny_txt);
  RenameFile(asl+'UpdateTemp.txt',vstupno_vystupny_txt);

end;

procedure Fyt_proc(subor:string);//hlavna procedura
var pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pn:PolePruh;//pole mien
    pwb:PolePruh;//pole with_blank
    i,r:integer;//riadok
    tin,tout:TextFile;
    s:string;
begin
  asl:=FytopackForm.asl;
///////////////////////prehodenie stlpcov do noveho poradia,statistika,konverzia
  read_fytins_constants(asl+'fytin.dat',rmax,smax,nocins,nobc,nos,sort,convert);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;
  SetLength(pb,nobc+1);
  SetLength(ps,nos+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)
  SetLength(pn,rmax+1);
  SetLength(pwb,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(new_pb,nobc+1);
  SetLength(old,smax+1,rmax+1);


  if nocins>0 then read_pos_of_col_blank_sub(asl+'fytin.dat',pc,pb,ps);
  if nocins=0 then begin
    read_pos_of_blank_sub(asl+'fytin.dat',pb,ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;
  read_numbers_only(subor,asl+'matrix.txt');
  read_names(pn,subor);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);
  compute_new_ps(new_ps,ps,pc);
  statistika(asl+'statistika.txt',new,new_ps);//napisanie suboru so statistikou
                                          //kazdy riadok je ukonceny medzerou

  if nos=0 then
    vypis(new,smax,asl+'statistika.txt');

////////////////////////////////////////////////////////////////// blank columns
  if (nobc>0) then begin
    smax:=nocins+8*nos;//jedna statistika je dlha 8 stlpcov
    SetLength(final,smax+1,rmax+1);
    scan(final,smax,asl+'statistika.txt');
    compute_new_pb(new_pb,pb,pc);
    SetLength(aft_ins_pb,nobc+1);
    compute_pb_after_insertion_of_stat(aft_ins_pb,new_pb,new_ps);
    write_blank(asl+'with_blank.txt',final,aft_ins_pb);//napisanie suboru so statistikou                                                 //a s blank columns
  end;

  if (nobc=0) then begin    //kopirovanie statistika.txt do with_blank.txt
    AssignFile(tin,asl+'statistika.txt');Reset(tin);
    AssignFile(tout,asl+'with_blank.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,s);
      writeln(tout,s);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
//////////////////////////////////////pridanie mien a celkovych percent(string)
  append(asl+'with_blank.txt',pp);//prilepenie celkovej statistiky
  AssignFile(tin,asl+'with_blank.txt');Reset(tin);
  for r:=1 to rmax do   //nacitanie suboru do pola stringov
    readln(tin,pwb[r]);
  CloseFile(tin);

  AssignFile(tout,asl+'complete.txt');Rewrite(tout);
  for r:=1 to rmax do   //vypis pola stringov  do suboru
    writeln(tout,pn[r]);
  CloseFile(tout);

  append(asl+'complete.txt',pwb);  //v subore complete.txt je uz vsetko okrem prveho
                              //riadku synon.txt
/////////////////////////////////// triedenie complete.txt podla celkovych percent

  AssignFile(tin,subor);Reset(tin);//nacitanie prveho riadku zo synon.dat
  readln(tin,line1);
  CloseFile(tin);

  if sort=1 then sort_according_percent(asl+'fyt1.dat',asl+'complete.txt',pcp);

                    //kopirovanie complete.txt
  if sort=0 then begin
    AssignFile(tin,asl+'complete.txt');Reset(tin);
    AssignFile(tout,asl+'fyt1.dat');Rewrite(tout);
    writeln(tout,line1);//prvy riadok zo synon.dat
    while not Eof(tin) do begin
      readln(tin,s);
      writeln(tout,s);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;

  remove_null_per(asl+'fyt1.dat',asl+'fyt.dat');//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'statistika.txt');
  DeleteFile(asl+'with_blank.txt');
  DeleteFile(asl+'complete.txt');
  //DeleteFile(asl+'fyt1.dat');

  if (nos=0) and (convert=1)  then LastProcedure(asl+'fyt.dat');
  UpdateFirstLine(asl+'fyt.dat'); //spravne rozmery matice
end;


//vstup hotovy fyt.dat
//vystup upraveny fyt.dat:
//            cast1:poradie 1 2 3 4 5 6 7 ...
//            cast2:nove poradie stlpcov ps[]  (z fytin.dat)
//            cast3:pocet nenulovych hodnot v danom stlpci
//         -vsetky 3 casti vo formate: 5941 -> 5
//                                             9
//                                             4
//                                             1

procedure AddFytListToFyt;
var t,temp:TextFile;
    line:string;
    c,cislo,FormatCmd:string;
    i,j,max:integer;
    poc:array of integer;//pole[stlpec]=pocet nenulovych hodnot v danom stlpci
                          //pole[0..]
    por:array of integer;//poradie 1,2,3,4...
    RowPor:array of string;
    RowPc:array of string;
    RowPoc:array of string;
    space:integer;//pocet medzier v statistike pred %
begin
  asl:=FytopackForm.asl;
  AssignFile(t,asl+'fyt.dat'); Reset(t);
  readln(t,line);
  readln(t,line);
  Reset(t);

             //plnenie pola por
  SetLength(por,nocins);
  for i:=low(por) to high(por) do
    por[i]:=i+1;

             //plnenie pola poc
  SetLength(poc,Length(line)-7);
  for i:=low(poc) to high(poc) do begin
    Reset(t);
    readln(t,line);//preskocenie prveho riadku
    poc[i]:=0;
    while not Eof(t) do begin//cez vsetky riadky
      readln(t,line);
      c:=line[i+1];//line[1,2,3,4...]
      if ((c<>'0') and (c<>'.')) then inc(poc[i]);
      //if ((c>='1')and(c<='9'))or(c='R')or(c='+')or(c='M')or(c='A')or(c='B') then
        //inc(poc[i]);
    end;
  end;


  ////////////////////////////////////////////////////////plnenie pola RowPor
  max:=0;              //zistenie dlzky najvacsieho cisla
  for i:=low(Por) to high(Por) do begin
    if Length(IntToStr(Por[i]))> max then max:=Length(IntToStr(Por[i]));
  end;
  SetLength(RowPor,max);
  FormatCmd:='%'+IntToStr(max)+'s';
                           //plnenie pola RowPor
  for i:=low(RowPor) to high(RowPor) do begin
    RowPor[i]:='';
    for j:=low(Por) to high(Por) do begin
      cislo:=Format(FormatCmd,[IntToStr(Por[j])]);//napr.ak max=4 tak cislo='_102'
      RowPor[i]:=RowPor[i]+cislo[i+1];
    end;
  end;


  ////////////////////////////////////////////////////////plnenie pola RowPc
  max:=0;              //zistenie dlzky najvacsieho cisla
  for i:=1 to high(pc) do begin
    if Length(IntToStr(pc[i]))> max then max:=Length(IntToStr(pc[i]));
  end;
  SetLength(RowPc,max);
  FormatCmd:='%'+IntToStr(max)+'s';
                           //plnenie pola row
  for i:=low(RowPc) to high(RowPc) do begin
    RowPc[i]:='';
    for j:=1 to high(pc) do begin
      cislo:=Format(FormatCmd,[IntToStr(pc[j])]);//napr.ak max=4 tak cislo='_102'
      RowPc[i]:=RowPc[i]+cislo[i+1];
    end;
  end;

  ////////////////////////////////////////////////////////plnenie pola RowPoc
  max:=0;              //zistenie dlzky najvacsieho cisla
  for i:=low(Poc) to high(Poc) do begin
    if Length(IntToStr(Poc[i]))> max then max:=Length(IntToStr(Poc[i]));
  end;
  SetLength(RowPoc,max);
  FormatCmd:='%'+IntToStr(max)+'s';
                           //plnenie pola RowPoc
  for i:=low(RowPoc) to high(RowPoc) do begin
    RowPoc[i]:='';
    for j:=low(poc) to high(poc) do begin
      cislo:=Format(FormatCmd,[IntToStr(Poc[j])]);//napr.ak max=4 tak cislo='_102'
      RowPoc[i]:=RowPoc[i]+cislo[i+1];
    end;
  end;


  //////////////uprava RowPor-> nad statistikami medzery,zaciatok od 11 stlpca
  for i:=low(RowPor) to high(RowPor) do begin //cez vsetky riadky
    for j:=nos downto 1 do  //statistiky
      Insert('        ',RowPor[i],new_ps[j]+1);

    for j:=nobc downto 1 do  //blank columns
      Insert(' ',RowPor[i],aft_ins_pb[j]+1);

    Insert('NumOfCol. ',RowPor[i],1);

  end;

  //////////////uprava RowPc-> nad statistikami medzery,zaciatok od 11 stlpca
  for i:=low(RowPc) to high(RowPc) do begin //cez vsetky riadky
    for j:=nos downto 1 do  //statistiky
      Insert('        ',RowPc[i],new_ps[j]+1);

    for j:=nobc downto 1 do  //blank columns
      Insert(' ',RowPc[i],aft_ins_pb[j]+1);

    Insert('Orig.Num. ',RowPc[i],1);

  end;

  //////////////uprava RowPoc-> nad statistikami medzery,zaciatok od 11 stlpca
  ////////////////nad statistikami same medzery
  Reset(t);
  readln(t,line);
  readln(t,line);
  for j:=low(RowPoc) to high(RowPoc) do begin
    for i:=1 to Length(line) do begin
      if line[i]='%' then begin //hladanie statistiky
        Delete(RowPoc[j],i-4,8); //stat je siroka 8 znakov
        Insert('        ',RowPoc[j],i-4);
      end;
      if line[i]=' ' then begin //hladanie blank column
        Delete(RowPoc[j],i,1);
        Insert(' ',RowPoc[j],i);
      end;

    end;
          //nad menami same medzerami
    Delete(RowPoc[j],1,10);
    Insert('NumOfSpec ',RowPoc[j],1);

         //orezanie koncoveho znaku(posledna stat ma len 7 znakov)
    SetLength(RowPoc[j],Length(line));
  end;

  AssignFile(temp,asl+'tempqw.txt');Rewrite(temp);

  Reset(t);
  readln(t,line);
  writeln(temp,line);
  for i:=low(RowPor) to high(RowPor) do
    writeln(temp,RowPor[i]);
  for i:=low(RowPc) to high(RowPc) do
    writeln(temp,RowPc[i]);
  for i:=low(RowPoc) to high(RowPoc) do
    writeln(temp,RowPoc[i]);

  while not Eof(t) do begin//kopirovanie fyt.dat do tempqw.txt
    readln(t,line);
    writeln(temp,line);
  end;

  CloseFile(temp);
  CloseFile(t);

  DeleteFile(asl+'fyt.dat');
  RenameFile(asl+'tempqw.txt',asl+'fyt.dat');

end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

end.

