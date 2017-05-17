unit SynopUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, ExtCtrls;

type
  stlpec = array of char;
  matica = array of stlpec;

  PoleCol = array of integer;  //nove poradie stlpcov
  PoleBlank = array of integer; //blank columns
  PoleSub = array of integer;   //subdivisions(statistika)

  PolePruh = array of string;  //pole stringov[1..rmax]
  PoleCelPer = array of real; //pole celkovych percent[1..rmax]

procedure nastav_adresar;
procedure synop1_proc(vstupny_txt:string);
procedure synop2_proc(vstupny_txt:string);
procedure synop3_proc(vstupny_txt:string);
procedure synop4_proc(vstupny_txt:string);
procedure synop5_proc(vstupny_txt:string);
procedure synop6_proc(vstupny_txt:string);

implementation
  uses FytopackUnit;


var new,old,final:matica;  //m[stlpec,riadok]
    rmax,smax,nocins,nobc,nos,sort,convert:integer;
    pc:PoleCol;
    pb:PoleBlank;
    ps:PoleSub;
    pp:PolePruh;
    line1:string;//prvy riadok synon.dat
    subor:string;//vstupny subor napr.: C:\Fytopack\synon.dat
    a:string;//adresar v ktorom je exe file
    asl:string;//asl=a+'\'

procedure nastav_adresar;
begin
  a:=FytopackForm.a;
  asl:=FytopackForm.asl;
end;

////////////////////////////////////////////////////////////////////////////////
procedure read_constants(synopin_txt,vstupny_txt:string;
                          var rmax,smax,nocins,nos:integer);
var syn,tin:TextFile;
    line,rows,col:string;
begin
  AssignFile(syn,synopin_txt);Reset(syn);
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(syn);//preskoci nazov

  ////////////////////////////////synopin.dat
  readln(syn,line);
  line:=copy(line,34,MaxInt);
  line:=Trim(line);
  nocins:=StrToInt(line);//pocet stlpcov v novom poradi

  readln(syn,line);
  line:=copy(line,34,MaxInt);
  line:=Trim(line);
  nos:=StrToInt(line);//pocet subdivisions

  readln(syn,line);
  line:=copy(line,34,MaxInt);
  line:=Trim(line);
  sort:=StrToInt(line);//sort: 0 or 1

  /////////////////////////////vstupny subor: napr.:synon.dat
  readln(tin,line);
  col:=copy(line,7,4);
  rows:=copy(line,12,4);
  smax:=StrToInt(trim(col));
  rmax:=StrToInt(trim(rows));

  CloseFile(tin);
  CloseFile(syn);
end;


procedure read_pos_of_col_sub(vstupny_txt:string;
                                 var PCol:PoleCol;
                                 var PSub:PoleSub);
var tin,temp1,temp2:TextFile;//dva pomocne subory
    poc:integer;
    c:char;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(temp1,'temp1.txt');Rewrite(temp1);

  readln(tin);//preskocenie prvych 4 riadkov
  readln(tin);
  readln(tin);
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
  AssignFile(temp2,'temp2.txt'); Rewrite(temp2);
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
  /////////////////array OF SUBDIVISIONS
  poc:=1;
  while (poc<=nos) do begin
    readln(temp2,s);
    PSub[poc]:=StrToInt(s);
    inc(poc);
  end;

  CloseFile(temp1);
  CloseFile(temp2);
  DeleteFile('temp1.txt');
  DeleteFile('temp2.txt');
end;

procedure read_pos_of_sub(vstupny_txt:string;var PSub:PoleSub);
var tin,temp1,temp2:TextFile;//dva pomocne subory
    poc:integer;
    c:char;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(temp1,'temp1.txt');Rewrite(temp1);

  readln(tin);//preskocenie prvych 4 riadkov
  readln(tin);
  readln(tin);
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
  AssignFile(temp2,'temp2.txt'); Rewrite(temp2);
  while not Eof(temp1) do begin
    readln(temp1,s);
    if (length(s)<>0) then writeln(temp2,s);

  end;

  Reset(temp2);
  /////////////////array OF SUBDIVISIONS
  poc:=1;
  while (poc<=nos) do begin
    readln(temp2,s);
    PSub[poc]:=StrToInt(s);
    inc(poc);
  end;

  CloseFile(temp1);
  CloseFile(temp2);
  DeleteFile('temp1.txt');
  DeleteFile('temp2.txt');
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
var s,r,poc,per,priem,suma:integer;
    //t:TextFile;
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
    per:=round((poc/nocins)*100+0.00000000001);//nahor zaokruhlene percenta
    if poc=0 then priem:=0;
    if poc<>0 then priem:=round(suma/poc+0.0000000000001);//zaokruhlovanie nahor
    if (per<=9) then p[r]:='   '+IntToStr(per)+'% '+IntToStr(priem);
    if (per>=10)and (per<=99) then p[r]:='  '+IntToStr(per)+'% '+IntToStr(priem);
    if (per>=100) then p[r]:=' '+IntToStr(per)+'% '+IntToStr(priem);
  end;
{
  AssignFile(t,asl+'pcp.txt');Rewrite(t);
  for r:=1 to rmax do begin
    writeln(t,FloatToStr(pcp[r]));
  end;
  CloseFile(t);
}
end;

procedure read_names(var p:PolePruh;vstupny_txt:string);
var tin:TextFile;
    i:integer;
    line:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(tin);

  for i:=1 to rmax do begin
    readln(tin,line);
    p[i]:=copy(line,1,9);
  end;
  CloseFile(tin);
end;

procedure append(vstupno_vystupny_txt:string; PPruh:PolePruh);
var temp,t:TextFile;
    s:string;
    i:integer;
begin
  AssignFile(t,vstupno_vystupny_txt);Reset(t);
  AssignFile(temp,'temp3.txt');Rewrite(temp);

  for i:=1 to rmax do begin
    readln(t,s);
    writeln(temp,s+PPruh[i]);
  end;

  CloseFile(t);
  CloseFile(temp);
  DeleteFile(vstupno_vystupny_txt);
  RenameFile('temp3.txt',vstupno_vystupny_txt);
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
          if new[s,r]='1' then pp[r]:=pp[r]+'R';
          if new[s,r]='2' then pp[r]:=pp[r]+'+';
          if new[s,r]='3' then pp[r]:=pp[r]+'1';
          if new[s,r]='4' then pp[r]:=pp[r]+'M';
          if new[s,r]='5' then pp[r]:=pp[r]+'A';
          if new[s,r]='6' then pp[r]:=pp[r]+'B';
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


              //meni aj poradie pcp!
procedure sort_according_percent(vystupny_txt,vstupny_txt:string;pcp:PoleCelPer);
var tin,tout:TextFile;
    i,j:integer;
    p1,p2:array of string;
    lor,hir:real;//lo real,hi real
    los,his:string; //lo string,hi string
    pcp2:PoleCelPer;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  SetLength(p1,rmax+1);
  SetLength(p2,rmax+1);
  SetLength(pcp2,rmax+1);

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
    pcp2[i]:=pcp[j];
    dec(j);
  end;

  for i:=1 to rmax do //zapisanie p2 do vystup_txt
    writeln(tout,p2[i]);

  for i:=1 to rmax do//pcp musi byt od najvacsieho po najmensie
    pcp[i]:=pcp2[i];

  CloseFile(tin);
  CloseFile(tout);
end;

                          //odstranenie riadkov s nulovou celkovou statistikou
procedure remove_null_per(vstupny_txt,vystupny_txt:string;pcp:PoleCelPer);
var line:string;
    t,tin,tout:Textfile;
    i:integer;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  for i:=1 to high(pcp) do begin
    readln(tin,line);
    if pcp[i]<>0 then writeln(tout,line);//opise len riadky s nenulovym percentom
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

////////////////////////////////////////////////////////////////////////////////


procedure FYT;//hlavna procedura
var new_ps:PoleSub;
    new_pb:PoleBlank;
    aft_ins_pb:PoleBlank;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pn:PolePruh;//pole mien
    pwb:PolePruh;//pole with_blank
    i,r:integer;//riadok
    tin,tout:TextFile;
    s:string;
begin
///////////////////////prehodenie stlpcov do noveho poradia,statistika,konverzia
  read_constants('synopin.dat','synon.dat',rmax,smax,nocins,nos);

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


  if nocins>0 then read_pos_of_col_sub('synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub('synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;
  read_numbers_only('synon.dat','matrix.txt');
  read_names(pn,'synon.dat');//citanie mien
  scan(old,smax,'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);
  compute_new_ps(new_ps,ps,pc);
  statistika('statistika.txt',new,new_ps);//napisanie suboru so statistikou
                                          //kazdy riadok je ukonceny medzerou
////////////////////////////////////////////////////////////////// blank columns
  if (nobc>0) then begin
    smax:=nocins+8*nos;//jedna statistika je dlha 8 stlpcov
    SetLength(final,smax+1,rmax+1);
    scan(final,smax,'statistika.txt');
    compute_new_pb(new_pb,pb,pc);
    SetLength(aft_ins_pb,nobc+1);
    compute_pb_after_insertion_of_stat(aft_ins_pb,new_pb,new_ps);
    write_blank('with_blank.txt',final,aft_ins_pb);//napisanie suboru so statistikou                                                 //a s blank columns
  end;

  if (nobc=0) then begin    //kopirovanie statistika.txt do with_blank.txt
    AssignFile(tin,'statistika.txt');Reset(tin);
    AssignFile(tout,'with_blank.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,s);
      writeln(tout,s);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
//////////////////////////////////////pridanie mien a celkovych percent(string)
  append('with_blank.txt',pp);//prilepenie celkovej statistiky
  AssignFile(tin,'with_blank.txt');Reset(tin);
  for r:=1 to rmax do   //nacitanie suboru do pola stringov
    readln(tin,pwb[r]);
  CloseFile(tin);

  AssignFile(tout,'complete.txt');Rewrite(tout);
  for r:=1 to rmax do   //vypis pola stringov  do suboru
    writeln(tout,pn[r]);
  CloseFile(tout);

  append('complete.txt',pwb);  //v subore complete.txt je uz vsetko okrem prveho
                              //riadku synon.txt
/////////////////////////////////// triedenie complete.txt podla celkovych percent

  AssignFile(tin,'synon.dat');Reset(tin);//nacitanie prveho riadku zo synon.dat
  readln(tin,line1);
  CloseFile(tin);

  if sort=1 then sort_according_percent('fyt1.dat','complete.txt',pcp);

                    //kopirovanie complete.txt
  if sort=0 then begin
    AssignFile(tin,'complete.txt');Reset(tin);
    AssignFile(tout,'fyt1.dat');Rewrite(tout);
    writeln(tout,line1);//prvy riadok zo synon.dat
    while not Eof(tin) do begin
      readln(tin,s);
      writeln(tout,s);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;

  remove_null_per('fyt1.dat','fyt.dat',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  DeleteFile('matrix.txt');
  DeleteFile('statistika.txt');
  DeleteFile('with_blank.txt');
  DeleteFile('complete.txt');
  DeleteFile('fyt1.dat');

///////////////////////////////////////////////////////////////////////////////
end;

procedure statistika1(vstupny_txt,vystupny_txt:string;ps:PoleSub);
var tin,tout:TextFile;
    line:string;
    i,j,lo,poc,freq:integer;
    min,max,k:integer;
    Smin,Smax,s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin
  readln(tin,line);
  lo:=1;
  s:='';
  for j:=1 to high(ps) do begin
    poc:=0;
    min:=MaxInt;
    max:=-MaxInt;
    for i:=lo to ps[j] do begin
      if ( (line[i]>='1') and (line[i]<='9') ) then begin
        inc(poc);
        k:=StrToInt(line[i]);
        if k<min then min:=k;
        if k>max then max:=k;
      end;
    end;
    freq:=Round( (poc/(ps[j]-lo+1))*100+0.0000000000000001 );
    if freq=0 then begin
      min:=0;
      max:=0;
    end;
    if min=0 then Smin:='.';if max=0 then Smax:='.';
    if min=1 then Smin:='r';if max=1 then Smax:='r';
    if min=2 then Smin:='+';if max=2 then Smax:='+';
    if min=3 then Smin:='1';if max=3 then Smax:='1';
    if min=4 then Smin:='m';if max=4 then Smax:='m';
    if min=5 then Smin:='a';if max=5 then Smax:='a';
    if min=6 then Smin:='b';if max=6 then Smax:='b';
    if min=7 then Smin:='3';if max=7 then Smax:='3';
    if min=8 then Smin:='4';if max=8 then Smax:='4';
    if min=9 then Smin:='5';if max=9 then Smax:='5';

    if freq=100 then
      s:=s+('   '+IntToStr(freq)+' '+Smin+Smax);
    if ( (freq>9) and (freq<100) ) then
      s:=s+('    '+IntToStr(freq)+' '+Smin+Smax);
    if (freq<10)  then
      s:=s+('     '+IntToStr(freq)+' '+Smin+Smax);

    lo:=ps[j]+1;
  end;
  writeln(tout,s);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

procedure statistika2(vstupny_txt,vystupny_txt:string;ps:PoleSub);
var tin,tout:TextFile;
    line:string;
    i,j,lo,poc:integer;
    freq:real;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin//pre vsetky riadky
  readln(tin,line);
  lo:=1;
  s:=' ';
  for j:=1 to high(ps) do begin
    poc:=0;
    for i:=lo to ps[j] do begin            //pocet nenulovych hodnot
      if ( (line[i]>='1') and (line[i]<='9') ) then inc(poc);
    end;
    freq:=(poc/(ps[j]-lo+1))*100;
                                           //konverzia
    if (freq=0) then s:=s+'0';
    if ( (freq>0) and (freq<=10) ) then s:=s+'1';
    if ( (freq>10) and (freq<=20) ) then s:=s+'2';
    if ( (freq>20) and (freq<=30) ) then s:=s+'3';
    if ( (freq>30) and (freq<=40) ) then s:=s+'4';
    if ( (freq>40) and (freq<=50) ) then s:=s+'5';
    if ( (freq>50) and (freq<=60) ) then s:=s+'6';
    if ( (freq>60) and (freq<=70) ) then s:=s+'7';
    if ( (freq>70) and (freq<=80) ) then s:=s+'8';
    if ( (freq>80) and (freq<=100) ) then s:=s+'9';

    lo:=ps[j]+1;
  end;
  writeln(tout,s);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

procedure statistika3(vstupny_txt,vystupny_txt:string;ps:PoleSub);
var tin,tout:TextFile;
    line:string;
    i,j,lo,poc,freq:integer;
    sum,priem:integer;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin
  readln(tin,line);
  lo:=1;
  s:=' ';
  for j:=1 to high(ps) do begin
    poc:=0;
    sum:=0;
    for i:=lo to ps[j] do begin
      if ( (line[i]>='1') and (line[i]<='9') ) then begin
        inc(poc);
        sum:=sum+StrToInt(line[i]);
      end;
    end;
    freq:=Round( (poc/(ps[j]-lo+1))*100 );
    if poc=0 then priem:=0;
    if poc<>0 then priem:=Round(sum/poc+0.0000000000000001);//zaokruhlovanie nahor

    if freq=100 then
      s:=s+('  '+IntToStr(freq)+' '+IntToStr(priem));
    if ( (freq>9) and (freq<100) ) then
      s:=s+('   '+IntToStr(freq)+' '+IntToStr(priem));
    if (freq<10)  then
      s:=s+('    '+IntToStr(freq)+' '+IntToStr(priem));

    lo:=ps[j]+1;
  end;
  writeln(tout,s);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

                                             //vracia piaty riadok
function statistika3_line5(vstupny_txt:string;ps:PoleSub):string;
var i,j,lo:integer;
    tin:TextFile;
    line:string;
    poc,priem:integer;//poc-pocet nenulovych hodnot v segmente
begin
  AssignFile(tin,vstupny_txt);Reset(tin);

  lo:=1;
  Result:='';
  for i:=1 to high(ps) do begin
    Reset(tin);
    poc:=0;
    while not Eof(tin) do begin
      readln(tin,line);
      for j:=lo to ps[i] do begin
        if line[j]<>'0' then inc(poc);
      end;
    end;
    priem:=Round( poc/((ps[i]-lo+1)) );
    Result:=Result+Format('%7s',[IntToStr(priem)]);
    lo:=ps[i]+1;
  end;
  CloseFile(tin);
  Result:='Aver.sp-no'+copy(Result,3,MaxInt);

end;

procedure statistika4(vstupny_txt,vystupny_txt:string;ps:PoleSub);
var tin,tout:TextFile;
    line:string;
    i,j,lo,poc,freq:integer;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin
  readln(tin,line);
  lo:=1;
  s:=' ';
  for j:=1 to high(ps) do begin
    poc:=0;
    for i:=lo to ps[j] do begin
      if ( (line[i]>='1') and (line[i]<='9') ) then inc(poc);
    end;
    freq:=Round( (poc/(ps[j]-lo+1))*100+0.0000000000000001 );//nahor

    if freq=100 then
      s:=s+'  '+IntToStr(freq);
    if ( (freq>9) and (freq<100) ) then
      s:=s+'   '+IntToStr(freq);
    if (freq<10)  then
      s:=s+'    '+IntToStr(freq);

    lo:=ps[j]+1;
  end;
  writeln(tout,s);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

                //to iste ako statistika3 len namiesto priemeru median
procedure statistika5(vstupny_txt,vystupny_txt:string;ps:PoleSub);
var tin,tout:TextFile;
    line:string;
    i,j,lo,poc,freq:integer;
    sum,n:integer;
    s,median,riadok:string;

  function sort_string(uns:string):string;//vysledok napr.:0013555788
  var i,j:integer;
      memory:char;
  begin
    for i:=1 to Length(uns)-1 do begin
      for j:=i+1 to Length(uns) do begin
        if uns[i]>uns[j] then begin
          memory:=uns[i];
          uns[i]:=uns[j];
          uns[j]:=memory;
        end;
      end;
    end;
    Result:=uns;
  end;

begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin
  readln(tin,line);
  lo:=1;
  s:=' ';
  for j:=1 to high(ps) do begin
    poc:=0;
    sum:=0;
    for i:=lo to ps[j] do begin
      if ( (line[i]>='1') and (line[i]<='9') ) then begin
        inc(poc);
        sum:=sum+StrToInt(line[i]);
      end;
    end;
    freq:=Round( (poc/(ps[j]-lo+1))*100+0.0000000000000001 );//zaokruhlovanie nahor

    ///////////////////vypocet medianu
    riadok:=copy(line,lo,ps[j]-lo+1); //podsubor
    riadok:=sort_string(riadok); //triedenie cislic od najmensej po najvacsiu
    n:=Length(riadok);//pocet hodnot v stat. subore

    if Odd(n) then
      median:=riadok[Round((n+1)/2+0.0000000000000001)]   //neparny pocet
    else                               //parny pocet
      median:=IntToStr(Round( 0.5*StrToInt(riadok[Round(n/2)])+0.5*StrToInt(riadok[Round(n/2+1)])+0.0000000000000001 ));

    if freq=100 then
      s:=s+('  '+IntToStr(freq)+' '+median);
    if ( (freq>9) and (freq<100) ) then
      s:=s+('   '+IntToStr(freq)+' '+median);
    if (freq<10)  then
      s:=s+('    '+IntToStr(freq)+' '+median);

    lo:=ps[j]+1;
  end;
  writeln(tout,s);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

procedure statistika6(vstupny_txt,vystupny_txt:string;ps:PoleSub);
var tin,tout:TextFile;
    line:string;
    i,j,lo,poc,freq:integer;
    sum,priem:integer;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  AssignFile(tout,vystupny_txt);Rewrite(tout);

  while not Eof(tin) do begin
  readln(tin,line);
  lo:=1;
  s:=' ';
  for j:=1 to high(ps) do begin
    poc:=0;
    sum:=0;
    for i:=lo to ps[j] do begin
      if ( (line[i]>='1') and (line[i]<='9') ) then begin
        inc(poc);
        sum:=sum+StrToInt(line[i]);
      end;
    end;
    freq:=Round( (poc/(ps[j]-lo+1))*100+0.0000000000000001 );//nahor
    priem:=Round( (sum*poc)/sqr(ps[j]-lo+1) );//????

    if freq=100 then
      s:=s+('  '+IntToStr(freq)+' '+IntToStr(priem));
    if ( (freq>9) and (freq<100) ) then
      s:=s+('   '+IntToStr(freq)+' '+IntToStr(priem));
    if (freq<10)  then
      s:=s+('    '+IntToStr(freq)+' '+IntToStr(priem));

    lo:=ps[j]+1;
  end;
  writeln(tout,s);
  end;

  CloseFile(tin);
  CloseFile(tout);
end;

function UpdatedFirstLine(vstupny_txt:string):string;
var t:TextFile;
    line,NoRow,NoCol:string;
    poc:integer;//pocet riadkov
begin

  AssignFile(t,vstupny_txt);Reset(t);

  poc:=0;
  while not Eof(t) do begin
    readln(t,line);
    inc(poc);
  end;
  Reset(t);
  readln(t,line);
  CloseFile(t);
  NoRow:=IntToStr(poc);
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

  Result:=NoCol+NoRow;
end;

procedure synop1_proc(vstupny_txt:string);
var new_ps:PoleSub;
    SumaRel:array of integer;
    pstat:PolePruh;//pole statistiky
    pn:PolePruh;//pole mien
    i,r:integer;//riadok
    t,final,tin,tout:TextFile;
    line,line1,line2,line3,line4:string;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pp:PolePruh;
begin
  read_constants(asl+'synopin.dat',vstupny_txt,rmax,smax,nocins,nos);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;

  SetLength(ps,nos+1);
  SetLength(pn,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(old,smax+1,rmax+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)

  if nocins>0 then read_pos_of_col_sub(asl+'synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub(asl+'synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;

  read_numbers_only(vstupny_txt,asl+'matrix.txt');
  read_names(pn,vstupny_txt);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);
  vypis(new,nocins,asl+'new.txt');
  compute_new_ps(new_ps,ps,pc);
  statistika1(asl+'new.txt',asl+'statistika1.txt',new_ps);

               //nacitanie statistik do pola pstat
  AssignFile(t,asl+'statistika1.txt'); Reset(t);
  i:=1;
  while not Eof(t) do begin
    SetLength(pstat,i+1);
    readln(t,pstat[i]);
    inc(i);
  end;
  CloseFile(t);
                           //zapisanie mien do suboru
  AssignFile(t,asl+'NoHead1.txt'); Rewrite(t);
  for i:=1 to high(pn) do begin
    writeln(t,pn[i]);
  end;
  CloseFile(t);

  append(asl+'NoHead1.txt',pstat);//hotovy synop1.dat (bez hlavicky)
///////////////////////////////////////////////////////sorting NoHead1.txt
  if sort=1 then
    sort_according_percent(asl+'NoHead1Sorted.txt',asl+'NoHead1.txt',pcp);

                    //kopirovanie NoHead1.txt do NoHead1Sorted.txt
  if sort=0 then begin
    AssignFile(tin,asl+'NoHead1.txt');Reset(tin);
    AssignFile(tout,asl+'NoHead1Sorted.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
  //////////////////uprava NoHead1Sorted.txt
  remove_null_per(asl+'NoHead1Sorted.txt',asl+'NoHead1Rem.txt',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  ///////////////////////////////////vyrobenie hlavicky(4 riadky)
  AssignFile(t,vstupny_txt); Reset(t);
  readln(t,line1);
  CloseFile(t);
  line1:=copy(line1,16,MaxInt);

  line1:='SNP1 '+UpdatedFirstLine(asl+'NoHead1Rem.txt')+line1;
  line2:='-------------------------------------------------------';
  SetLength(SumaRel,nos+1);
  SumaRel[1]:=new_ps[1];
  for i:=2 to nos do begin      //algoritmus robi:
    SumaRel[i]:=new_ps[i]-new_ps[i-1];  //   pole new_ps: 10 20 35 48 51
  end;                          //pole SumaRel: 10 10 15 13  3

  line3:='';           //hranie sa so zarovnanim
  for i:=1 to nos do begin
    line3:=line3+Format('%9s',[IntToStr(SumaRel[i])]);
  end;
  line3:=copy(line3,4,MaxInt);
  line3:='SUMA rel.'+line3;

  line4:=line2;

  ///////////////////////////////////////napisanie synop1.dat - finalna verzia
  AssignFile(t,asl+'NoHead1Rem.txt'); Reset(t);
  AssignFile(final,asl+'synop1.dat'); Rewrite(final);

  writeln(final,line1);//hlavicka
  writeln(final,line2);
  writeln(final,line3);
  writeln(final,line4);

  while not Eof(t) do begin //kopirovanie
    readln(t,line);
    writeln(final,line);
  end;
  CloseFile(t);
  CloseFile(final);

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'new.txt');
  DeleteFile(asl+'statistika1.txt');
  DeleteFile(asl+'NoHead1.txt');
  DeleteFile(asl+'NoHead1Sorted.txt');
  DeleteFile(asl+'NoHead1Rem.txt');//odstranene riadky s nulovou celkovou statistikou

end;

procedure synop2_proc(vstupny_txt:string);
var new_ps:PoleSub;
    pstat:PolePruh;//pole statistiky
    pn:PolePruh;//pole mien
    i,j,r:integer;//riadok
    t,final,tin,tout:TextFile;
    line,line1:string;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pp:PolePruh;
begin
  read_constants(asl+'synopin.dat',vstupny_txt,rmax,smax,nocins,nos);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;

  SetLength(ps,nos+1);
  SetLength(pn,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(old,smax+1,rmax+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)

  if nocins>0 then read_pos_of_col_sub(asl+'synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub(asl+'synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;

  read_numbers_only(vstupny_txt,asl+'matrix.txt');
  read_names(pn,vstupny_txt);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);
  vypis(new,nocins,asl+'new.txt');
  compute_new_ps(new_ps,ps,pc);
  statistika2(asl+'new.txt',asl+'statistika2.txt',new_ps);

               //nacitanie statistik do pola pstat
  AssignFile(t,asl+'statistika2.txt'); Reset(t);
  i:=1;
  while not Eof(t) do begin
    SetLength(pstat,i+1);
    readln(t,pstat[i]);
    inc(i);
  end;
  CloseFile(t);
                           //zapisanie mien do suboru
  AssignFile(t,asl+'NoHead2.txt'); Rewrite(t);
  for i:=1 to high(pn) do begin
    writeln(t,pn[i]);
  end;
  CloseFile(t);

  append(asl+'NoHead2.txt',pstat);//hotovy synop2.dat (bez hlavicky)

///////////////////////////////////////////////////////sorting NoHead2.txt
  if sort=1 then
    sort_according_percent(asl+'NoHead2Sorted.txt',asl+'NoHead2.txt',pcp);

                    //kopirovanie NoHead2.txt do NoHead2Sorted.txt
  if sort=0 then begin
    AssignFile(tin,asl+'NoHead2.txt');Reset(tin);
    AssignFile(tout,asl+'NoHead2Sorted.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
  //////////////////uprava NoHead2Sorted.txt
  remove_null_per(asl+'NoHead2Sorted.txt',asl+'NoHead2Rem.txt',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  ///////////////////////////////////vyrobenie hlavicky(1 riadok)

  AssignFile(t,vstupny_txt); Reset(t);
  readln(t,line1);
  CloseFile(t);
  line1:=copy(line1,16,MaxInt);
  line1:='SNP2 '+UpdatedFirstLine(asl+'NoHead2Rem.txt')+line1;

  ///////////////////////////////////////napisanie synop2.dat - finalna verzia
  AssignFile(t,asl+'NoHead2Rem.txt'); Reset(t);
  AssignFile(final,asl+'synop2.dat'); Rewrite(final);

  writeln(final,line1);//hlavicka

  while not Eof(t) do begin //kopirovanie
    readln(t,line);
    writeln(final,line);
  end;
  CloseFile(t);
  CloseFile(final);

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'new.txt');
  DeleteFile(asl+'statistika2.txt');
  DeleteFile(asl+'NoHead2.txt');
  DeleteFile(asl+'NoHead2Sorted.txt');
  DeleteFile(asl+'NoHead2Rem.txt');//odstranene riadky s nulovou celkovou statistikou

end;


procedure synop3_proc(vstupny_txt:string);
var new_ps:PoleSub;
    SumaRel:array of integer;
    pstat:PolePruh;//pole statistiky
    pn:PolePruh;//pole mien
    i,j,r:integer;//riadok
    t,final,tin,tout:TextFile;
    line,line1,line2,line3,line4,line5,line6:string;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pp:PolePruh;
begin
  read_constants(asl+'synopin.dat',vstupny_txt,rmax,smax,nocins,nos);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;

  SetLength(ps,nos+1);
  SetLength(pn,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(old,smax+1,rmax+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)

  if nocins>0 then read_pos_of_col_sub(asl+'synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub(asl+'synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;

  read_numbers_only(vstupny_txt,asl+'matrix.txt');
  read_names(pn,vstupny_txt);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);  
  vypis(new,nocins,asl+'new.txt');
  compute_new_ps(new_ps,ps,pc);
  statistika3(asl+'new.txt',asl+'statistika3.txt',new_ps);

               //nacitanie statistik do pola pstat
  AssignFile(t,asl+'statistika3.txt'); Reset(t);
  i:=1;
  while not Eof(t) do begin
    SetLength(pstat,i+1);
    readln(t,pstat[i]);
    inc(i);
  end;
  CloseFile(t);
                           //zapisanie mien do suboru
  AssignFile(t,asl+'NoHead3.txt'); Rewrite(t);
  for i:=1 to high(pn) do begin
    writeln(t,pn[i]);
  end;
  CloseFile(t);

  append(asl+'NoHead3.txt',pstat);//hotovy synop3.dat (bez hlavicky)
///////////////////////////////////////////////////////sorting NoHead1.txt
  if sort=1 then
    sort_according_percent(asl+'NoHead3Sorted.txt',asl+'NoHead3.txt',pcp);

                    //kopirovanie NoHead3.txt do NoHead3Sorted.txt
  if sort=0 then begin
    AssignFile(tin,asl+'NoHead3.txt');Reset(tin);
    AssignFile(tout,asl+'NoHead3Sorted.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
  //////////////////uprava NoHead3Sorted.txt
  remove_null_per(asl+'NoHead3Sorted.txt',asl+'NoHead3Rem.txt',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  ///////////////////////////////////vyrobenie hlavicky(6 riadkov)

  AssignFile(t,vstupny_txt); Reset(t);
  readln(t,line1);
  CloseFile(t);
  line1:=copy(line1,16,MaxInt);
  line1:='SNP3 '+UpdatedFirstLine(asl+'NoHead3Rem.txt')+line1;

  line2:='-------------------------------------------------------';
  SetLength(SumaRel,nos+1);
  SumaRel[1]:=new_ps[1];
  for i:=2 to nos do begin      //algoritmus robi:
    SumaRel[i]:=new_ps[i]-new_ps[i-1];  //pole new_ps: 10 20 35 48 51
  end;                          //pole SumaRel: 10 10 15 13  3

  line3:='';           //hranie sa so zarovnanim
  for i:=1 to nos do begin
    line3:=line3+Format('%7s',[IntToStr(SumaRel[i])]);
  end;
  line3:=copy(line3,4,MaxInt);
  line3:='SUMA rel.  '+line3;
  line4:=line2;
  //line5:=statistika3_line5(asl+'matrix.txt',ps);//povodny kod
  line5:=statistika3_line5(asl+'new.txt',new_ps);//!!!
  line6:=line2;

  ///////////////////////////////////////napisanie synop3.dat - finalna verzia
  AssignFile(t,asl+'NoHead3Rem.txt'); Reset(t);
  AssignFile(final,asl+'synop3.dat'); Rewrite(final);

  writeln(final,line1);//hlavicka
  writeln(final,line2);
  writeln(final,line3);
  writeln(final,line4);
  writeln(final,line5);
  writeln(final,line6);

  while not Eof(t) do begin //kopirovanie
    readln(t,line);
    writeln(final,line);
  end;
  CloseFile(t);
  CloseFile(final);

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'new.txt');
  DeleteFile(asl+'statistika3.txt');
  DeleteFile(asl+'NoHead3.txt');
  DeleteFile(asl+'NoHead3Sorted.txt');
  DeleteFile(asl+'NoHead3Rem.txt');//odstranene riadky s nulovou celkovou statistikou

end;

procedure synop4_proc(vstupny_txt:string);
var new_ps:PoleSub;
    SumaRel:array of integer;
    pstat:PolePruh;//pole statistiky
    pn:PolePruh;//pole mien
    i,j,r:integer;//riadok
    t,final,tin,tout:TextFile;
    line,line1,line2,line3,line4:string;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pp:PolePruh;
begin
  read_constants(asl+'synopin.dat',vstupny_txt,rmax,smax,nocins,nos);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;

  SetLength(ps,nos+1);
  SetLength(pn,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(old,smax+1,rmax+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)

  if nocins>0 then read_pos_of_col_sub(asl+'synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub(asl+'synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;

  read_numbers_only(vstupny_txt,asl+'matrix.txt');
  read_names(pn,vstupny_txt);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);
  vypis(new,nocins,asl+'new.txt');
  compute_new_ps(new_ps,ps,pc);
  statistika4(asl+'new.txt',asl+'statistika4.txt',new_ps);

               //nacitanie statistik do pola pstat
  AssignFile(t,asl+'statistika4.txt'); Reset(t);
  i:=1;
  while not Eof(t) do begin
    SetLength(pstat,i+1);
    readln(t,pstat[i]);
    inc(i);
  end;
  CloseFile(t);
                           //zapisanie mien do suboru
  AssignFile(t,asl+'NoHead4.txt'); Rewrite(t);
  for i:=1 to high(pn) do begin
    writeln(t,pn[i]);
  end;
  CloseFile(t);

  append(asl+'NoHead4.txt',pstat);//hotovy synop4.dat (bez hlavicky)
///////////////////////////////////////////////////////sorting NoHead4.txt
  if sort=1 then
    sort_according_percent(asl+'NoHead4Sorted.txt',asl+'NoHead4.txt',pcp);

                    //kopirovanie NoHead4.txt do NoHead4Sorted.txt
  if sort=0 then begin
    AssignFile(tin,asl+'NoHead4.txt');Reset(tin);
    AssignFile(tout,asl+'NoHead4Sorted.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
  //////////////////uprava NoHead4Sorted.txt
  remove_null_per(asl+'NoHead4Sorted.txt',asl+'NoHead4Rem.txt',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  ///////////////////////////////////vyrobenie hlavicky(4 riadky)

  AssignFile(t,vstupny_txt); Reset(t);
  readln(t,line1);
  CloseFile(t);
  line1:=copy(line1,16,MaxInt);
  line1:='SNP4 '+UpdatedFirstLine(asl+'NoHead4Rem.txt')+line1;

  line2:='-----------------------------------';

  SetLength(SumaRel,nos+1);
  SumaRel[1]:=new_ps[1];
  for i:=2 to nos do begin      //algoritmus robi:
    SumaRel[i]:=new_ps[i]-new_ps[i-1];//pole new_ps: 10 20 35 48 51
  end;                          //pole SumaRel: 10 10 15 13  3

  line3:='';           //hranie sa so zarovnanim
  for i:=1 to nos do begin
    line3:=line3+Format('%5s',[IntToStr(SumaRel[i])]);
  end;
  line3:='SUMA rel. '+line3;

  line4:=line2;

  ///////////////////////////////////////napisanie synop4.dat - finalna verzia
  AssignFile(t,asl+'NoHead4Rem.txt'); Reset(t);
  AssignFile(final,asl+'synop4.dat'); Rewrite(final);

  writeln(final,line1);//hlavicka
  writeln(final,line2);
  writeln(final,line3);
  writeln(final,line4);

  while not Eof(t) do begin //kopirovanie
    readln(t,line);
    writeln(final,line);
  end;
  CloseFile(t);
  CloseFile(final);

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'new.txt');
  DeleteFile(asl+'statistika4.txt');
  DeleteFile(asl+'NoHead4.txt');
  DeleteFile(asl+'NoHead4Sorted.txt');
  DeleteFile(asl+'NoHead4Rem.txt');//odstranene riadky s nulovou celkovou statistikou

end;

procedure synop5_proc(vstupny_txt:string);//median
var new_ps:PoleSub;
    SumaRel:array of integer;
    pstat:PolePruh;//pole statistiky
    pn:PolePruh;//pole mien
    i,j,r:integer;//riadok
    t,final,tin,tout:TextFile;
    line,line1,line2,line3,line4,line5,line6:string;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pp:PolePruh;
begin
  read_constants(asl+'synopin.dat',vstupny_txt,rmax,smax,nocins,nos);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;

  SetLength(ps,nos+1);
  SetLength(pn,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(old,smax+1,rmax+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)

  if nocins>0 then read_pos_of_col_sub(asl+'synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub(asl+'synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;

  read_numbers_only(vstupny_txt,asl+'matrix.txt');
  read_names(pn,vstupny_txt);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);  
  vypis(new,nocins,asl+'new.txt');
  compute_new_ps(new_ps,ps,pc);
  statistika5(asl+'new.txt',asl+'statistika5.txt',new_ps);

               //nacitanie statistik do pola pstat
  AssignFile(t,asl+'statistika5.txt'); Reset(t);
  i:=1;
  while not Eof(t) do begin
    SetLength(pstat,i+1);
    readln(t,pstat[i]);
    inc(i);
  end;
  CloseFile(t);
                           //zapisanie mien do suboru
  AssignFile(t,asl+'NoHead5.txt'); Rewrite(t);
  for i:=1 to high(pn) do begin
    writeln(t,pn[i]);
  end;
  CloseFile(t);

  append(asl+'NoHead5.txt',pstat);//hotovy synop5.dat (bez hlavicky)
///////////////////////////////////////////////////////sorting NoHead5.txt
  if sort=1 then
    sort_according_percent(asl+'NoHead5Sorted.txt',asl+'NoHead5.txt',pcp);

                    //kopirovanie NoHead5.txt do NoHead5Sorted.txt
  if sort=0 then begin
    AssignFile(tin,asl+'NoHead5.txt');Reset(tin);
    AssignFile(tout,asl+'NoHead5Sorted.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
  //////////////////uprava NoHead5Sorted.txt
  remove_null_per(asl+'NoHead5Sorted.txt',asl+'NoHead5Rem.txt',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  ///////////////////////////////////vyrobenie hlavicky(6 riadkov)

  AssignFile(t,vstupny_txt); Reset(t);
  readln(t,line1);
  CloseFile(t);
  line1:=copy(line1,16,MaxInt);
  line1:='SNP5 '+UpdatedFirstLine(asl+'NoHead5Rem.txt')+line1;

  line2:='-------------------------------------------------------';
  SetLength(SumaRel,nos+1);
  SumaRel[1]:=new_ps[1];
  for i:=2 to nos do begin      //algoritmus robi:
    SumaRel[i]:=new_ps[i]-new_ps[i-1];  //pole new_ps: 10 20 35 48 51
  end;                          //pole SumaRel: 10 10 15 13  3

  line3:='';           //hranie sa so zarovnanim
  for i:=1 to nos do begin
    line3:=line3+Format('%7s',[IntToStr(SumaRel[i])]);
  end;
  line3:=copy(line3,4,MaxInt);
  line3:='SUMA rel.  '+line3;
  line4:=line2;
  //line5:=statistika3_line5(asl+'matrix.txt',ps);//povodny kod
  line5:=statistika3_line5(asl+'new.txt',new_ps);//!!!
  line6:=line2;

  ///////////////////////////////////////napisanie synop5.dat - finalna verzia
  AssignFile(t,asl+'NoHead5Rem.txt'); Reset(t);
  AssignFile(final,asl+'synop5.dat'); Rewrite(final);

  writeln(final,line1);//hlavicka
  writeln(final,line2);
  writeln(final,line3);
  writeln(final,line4);
  writeln(final,line5);
  writeln(final,line6);

  while not Eof(t) do begin //kopirovanie
    readln(t,line);
    writeln(final,line);
  end;
  CloseFile(t);
  CloseFile(final);

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'new.txt');
  DeleteFile(asl+'statistika5.txt');
  DeleteFile(asl+'NoHead5.txt');
  DeleteFile(asl+'NoHead5Sorted.txt');
  DeleteFile(asl+'NoHead5Rem.txt');//odstranene riadky s nulovou celkovou statistikou

end;

procedure synop6_proc(vstupny_txt:string);
var new_ps:PoleSub;
    SumaRel:array of integer;
    pstat:PolePruh;//pole statistiky
    pn:PolePruh;//pole mien
    i,j,r:integer;//riadok
    t,final,tin,tout:TextFile;
    line,line1,line2,line3,line4:string;
    pcp:PoleCelPer; //celkove percenta(pole realnych cisel)
    pp:PolePruh;
begin
  read_constants(asl+'synopin.dat',vstupny_txt,rmax,smax,nocins,nos);

  if nocins=0 then begin//specialny pripad:ak nocins=0 tak sa poradie stlpcov
    SetLength(pc,smax+1);//nemeni
    SetLength(new,smax+1,rmax+1);
  end;
  if nocins>0 then begin
    SetLength(pc,nocins+1);
    SetLength(new,nocins+1,rmax+1);
  end;

  SetLength(ps,nos+1);
  SetLength(pn,rmax+1);
  SetLength(new_ps,nos+1);
  SetLength(old,smax+1,rmax+1);
  SetLength(pp,rmax+1);//celkove percenta (text)
  SetLength(pcp,rmax+1);//celkove percenta (real cisla)

  if nocins>0 then read_pos_of_col_sub(asl+'synopin.dat',pc,ps);
  if nocins=0 then begin
    read_pos_of_sub(asl+'synopin.dat',ps);
    for i:=1 to smax do//poradie sa nemeni
      pc[i]:=i;
    nocins:=smax;
  end;

  read_numbers_only(vstupny_txt,asl+'matrix.txt');
  read_names(pn,vstupny_txt);//citanie mien
  scan(old,smax,asl+'matrix.txt');
  prehod_stlpce(new,old,pc);
  celkove_percenta(pp,pcp,new);  
  vypis(new,nocins,asl+'new.txt');
  compute_new_ps(new_ps,ps,pc);
  statistika6(asl+'new.txt',asl+'statistika6.txt',new_ps);

               //nacitanie statistik do pola pstat
  AssignFile(t,asl+'statistika6.txt'); Reset(t);
  i:=1;
  while not Eof(t) do begin
    SetLength(pstat,i+1);
    readln(t,pstat[i]);
    inc(i);
  end;
  CloseFile(t);
                           //zapisanie mien do suboru
  AssignFile(t,asl+'NoHead6.txt'); Rewrite(t);
  for i:=1 to high(pn) do begin
    writeln(t,pn[i]);
  end;
  CloseFile(t);

  append(asl+'NoHead6.txt',pstat);//hotovy synop6.dat (bez hlavicky)

///////////////////////////////////////////////////////sorting NoHead6.txt
  if sort=1 then
    sort_according_percent(asl+'NoHead6Sorted.txt',asl+'NoHead6.txt',pcp);

                    //kopirovanie NoHead6.txt do NoHead6Sorted.txt
  if sort=0 then begin
    AssignFile(tin,asl+'NoHead6.txt');Reset(tin);
    AssignFile(tout,asl+'NoHead6Sorted.txt');Rewrite(tout);
    while not Eof(tin) do begin
      readln(tin,line);
      writeln(tout,line);
    end;
    CloseFile(tin);
    CloseFile(tout);
  end;
  //////////////////uprava NoHead6Sorted.txt
  remove_null_per(asl+'NoHead6Sorted.txt',asl+'NoHead6Rem.txt',pcp);//odstranenie riadkov s nulovou celkovou
                                        //statistikou

  ///////////////////////////////////vyrobenie hlavicky(4 riadky)

  AssignFile(t,vstupny_txt); Reset(t);
  readln(t,line1);
  CloseFile(t);
  line1:=copy(line1,16,MaxInt);
  line1:='SNP6 '+UpdatedFirstLine(asl+'NoHead6Rem.txt')+line1;

  line2:='-------------------------------------------------------';
  SetLength(SumaRel,nos+1);
  SumaRel[1]:=new_ps[1];
  for i:=2 to nos do begin      //algoritmus robi:
    SumaRel[i]:=new_ps[i]-new_ps[i-1];//pole new_ps: 10 20 35 48 51
  end;                          //pole SumaRel: 10 10 15 13  3

  line3:='';           //hranie sa so zarovnanim
  for i:=1 to nos do begin
    line3:=line3+Format('%7s',[IntToStr(SumaRel[i])]);
  end;
  line3:=copy(line3,4,MaxInt);
  line3:='SUMA rel.  '+line3;
  line4:=line2;

  ///////////////////////////////////////napisanie synop6.dat - finalna verzia
  AssignFile(t,asl+'NoHead6Rem.txt'); Reset(t);
  AssignFile(final,asl+'synop6.dat'); Rewrite(final);

  writeln(final,line1);//hlavicka
  writeln(final,line2);
  writeln(final,line3);
  writeln(final,line4);

  while not Eof(t) do begin //kopirovanie
    readln(t,line);
    writeln(final,line);
  end;
  CloseFile(t);
  CloseFile(final);

  DeleteFile(asl+'matrix.txt');
  DeleteFile(asl+'new.txt');
  DeleteFile(asl+'statistika6.txt');
  DeleteFile(asl+'NoHead6.txt');
  DeleteFile(asl+'NoHead6Sorted.txt');
  DeleteFile(asl+'NoHead6Rem.txt');//odstranene riadky s nulovou celkovou statistikou

end;

end.

