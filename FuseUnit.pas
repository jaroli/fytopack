unit FuseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ComCtrls, Menus, ExtCtrls;

type
  TFuseForm = class(TForm)
    FL: TFileListBox;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    MainMenu1: TMainMenu;
    SelectAllFiles: TMenuItem;
    RunFuse: TMenuItem;
    Quit: TMenuItem;
    Bevel1: TBevel;
    StatusBar1: TStatusBar;
    ClearSelectedFiles: TMenuItem;
    OpenDialog1: TOpenDialog;
    M: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FLClick(Sender: TObject);
    procedure SelectAllFilesClick(Sender: TObject);
    procedure RunFuseClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure ClearSelectedFilesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FuseForm: TFuseForm;

implementation
  uses FytopackUnit;
{$R *.dfm}

{trieda line}
////////////////////////////////////////////////////////////////////////////////
type
  line = class
    name:string;
    data:string;
    constructor Create;
  end;
  text = array of line;

constructor line.Create;
begin
  name:='';
  data:='';
end;
////////////////////////////////////////////////////////////////////////////////

var pin1:text;
    pin2:text;
    pout:text;
    p:text;
    adresar:string;//adresar v ktorom je program

procedure read_input(var pin:text;smax:integer;vstupny_txt:string);
var r,s:integer;
    tin:TextFile;
    c:char;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(tin);//1
{  readln(tin);//2
  readln(tin);//3
  readln(tin);//4
  readln(tin);//5
}                              ////citanie mien rastlin
  for r:=low(pin) to high(pin) do begin
    for s:=1 to 9 do begin
      read(tin,c);
      pin[r].name:=pin[r].name+c;
    end;
    readln(tin);
  end;

  Reset(tin);                ////citanie cisel pokryvnosti
  readln(tin);
  for r:=low(pin) to high(pin) do begin
    for s:=1 to 10 do //preskocenie mien
      read(tin,c);
    for s:=1 to smax do begin
      read(tin,c);
      pin[r].data:=pin[r].data+c;
    end;
    readln(tin);
  end;

  CloseFile(tin);
end;


          //vrati pocet riadkov dat vo vstupnom subore(bez prveho riadku)
function rmax_in(vstupny_txt:string):integer;
var tin:TextFile;
    poc:integer;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(tin);//preskocenie prveho riadku
{  readln(tin);//2
  readln(tin);//3
  readln(tin);//4
  readln(tin);//5
}
  poc:=0;
  while not Eof(tin) do begin
    readln(tin);
    inc(poc);
  end;
  Result:=poc;
  CloseFile(tin);
end;

                          //vrati pocet stlpcov dat v subore vstupny_txt
function smax_in(vstupny_txt:string):integer;//pracuje iba s prvym riadkom dat!!
var tin:TextFile;
    s:string;
begin
  AssignFile(tin,vstupny_txt);Reset(tin);
  readln(tin);//preskocime prvy riadok
{  readln(tin);//2
  readln(tin);//3
  readln(tin);//4
  readln(tin);//5
}
  readln(tin,s);
  Result:=Length(s)-10;
  CloseFile(tin);
end;

                 //vracia pocet riadkov vo vystupnom poli
function rmax_out(pin1,pin2:text):integer;
var i,j,rovnake_mena:integer;
begin
  rovnake_mena:=0;
  for j:=low(pin2) to high(pin2) do begin
    for i:=low(pin1) to high(pin1) do begin
      if (pin1[i].name)=(pin2[j].name) then inc(rovnake_mena);
    end;
  end;
  Result:=(high(pin1)+1)+(high(pin2)+1)-rovnake_mena;
end;

procedure fill_out(var pout:text;pin1,pin2:text);
var s,r,i,j:integer;
    nuly1,nuly2:string;
    found:boolean;
begin
  nuly1:='';
  for s:=1 to Length(pin1[0].data) do
    nuly1:=nuly1+'0';

  nuly2:='';
  for s:=1 to Length(pin2[0].data) do
    nuly2:=nuly2+'0';

  for i:=low(pin1) to high(pin1) do
    pout[i].name:=pin1[i].name;

  for i:=low(pin1) to high(pin1) do begin
    found:=false;
    for j:=low(pin2) to high(pin2) do begin
      if pin1[i].name=pin2[j].name then  pout[i].data:=pin1[i].data+pin2[j].data;
      found:=found or (pin1[i].name=pin2[j].name);
    end;
    if not(found) then pout[i].data:=pin1[i].data+nuly2;
  end;

  r:=0;
  for j:=low(pin2) to high(pin2) do begin
    found:=false;
    for i:=low(pin1) to high(pin1) do begin
       found:=found or (pin1[i].name=pin2[j].name);
    end;
    if not(found) then begin
      inc(r);
      pout[high(pin1)+r].name:=pin2[j].name;
      pout[high(pin1)+r].data:=nuly1+pin2[j].data;
    end;
  end;

end;

procedure vypis(vystupny_txt:string;p:text);
var tout:TextFile;
    r:integer;
begin
  AssignFile(tout,vystupny_txt);Rewrite(tout);
  writeln(tout,'prvy riadok');
  for r:=low(p) to high(p) do
    writeln(tout,p[r].name+' '+p[r].data);

  CloseFile(tout);
end;

procedure fuse_TwoFiles(main_data,data_to_add,vystupny_txt:string);
var r:integer;
begin
  SetLength(pin1,rmax_in(main_data));
  SetLength(pin2,rmax_in(data_to_add));

  for r:=low(pin1) to high(pin1) do
    pin1[r]:=line.Create;
  for r:=low(pin2) to high(pin2) do
    pin2[r]:=line.Create;

  read_input(pin1,smax_in(main_data),main_data);
  read_input(pin2,smax_in(data_to_add),data_to_add);

  SetLength(pout,rmax_out(pin1,pin2));
  for r:=low(pout) to high(pout) do
    pout[r]:=line.Create;


  fill_out(pout,pin1,pin2);
  vypis(vystupny_txt,pout);

end;

procedure sort(p:text);
var i,j:integer;
    Mname,Mdata:string;//Memory
begin
  for j:=low(p) to high(p) do begin
    for i:=j+1 to high(p) do begin
      if p[j].name > p[i].name then begin
        Mname:=p[i].name;
        p[i].name:=p[j].name;
        p[j].name:=Mname;
        Mdata:=p[i].data;
        p[i].data:=p[j].data;
        p[j].data:=Mdata;
      end;
    end;
  end;

end;

procedure write_fuse_list(name:string);//vytvara subor fuse.lst
var tin,tout,t_data:TextFile;
    s,i,smax:integer;
    line1,line2,line3,line4,line5,line,modrak:string;
    dash_line:string;
begin
  dash_line:='--------------------------------------------------------------------------------';
  AssignFile(tout,adresar+'\fuse.lst');Rewrite(tout);
  writeln(tout,'Fytopack2004 - program Fuse  Date: '
               +DateToStr(Date)+'  Time: '+TimeToStr(Time));
  writeln(tout,dash_line);
  s:=1;
  for i:=0 to FuseForm.M.Items.Count-1 do begin
    modrak:=FuseForm.M.Items.Strings[i];
    AssignFile(tin,adresar+'\InputData\'+modrak);Reset(tin);
    readln(tin,line1);//povinny riadok
    readln(tin,line2);//povinny riadok
    readln(tin,line3);//povinny riadok
    readln(tin,line4);//nepovinny \  ak je prazdny alebo obsahuje
    readln(tin,line5);//nepovinny /  len 1 medzeru tak nepisat do fuse.lst
    CloseFile(tin);
    writeln(tout,line1);
    writeln(tout,line2);
    writeln(tout,line3);

    if not( (Length(line4)=0)or((Length(line4)=1)and(pos(' ',line4)=1)) ) then
      writeln(tout,line4);
    if not( (Length(line5)=0)or((Length(line5)=1)and(pos(' ',line5)=1)) ) then
      writeln(tout,line5);

                                            //zistenie poctu stlpcov
    AssignFile(t_data,adresar+'\CheckedData\'+modrak);Reset(t_data);
    readln(t_data,line);//preskocenie prveho riadku
    readln(t_data,line);//nacitanie riadku s doplnenymi nulami(ma spravnu dlzku)
    CloseFile(t_data);
    smax:=Length(line)-10;//pocet stlpcov
    writeln(tout,IntToStr(i+1)+'. PROCESSED DATA FILE '+modrak+
            ' RELEVEES IN FUSED TABLE:           '+
            IntToStr(s)+'-'+IntToStr(s+smax-1));
    writeln(tout,dash_line);
    s:=s+smax;
  end;
  writeln(tout,'TOTAL NUMBER OF SPECIES  (IN FINAL TABLE): '
               +IntToStr(rmax_in(name)));
  writeln(tout,'TOTAL NUMBER OF RELEVEES (IN FINAL TABLE): '
               +IntToStr(smax_in(name)));
  CloseFile(tout);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TFuseForm.FormCreate(Sender: TObject);
begin
  M.Items.Clear;
  adresar:=FytopackForm.a;
  FL.Directory:=adresar+'\CheckedData';
  RunFuse.Enabled:=false;
  StatusBar1.SimpleText:='Status: Select Files';
end;
                     //select one file
procedure TFuseForm.FLClick(Sender: TObject);
begin
  StatusBar1.SimpleText:='Status: READY';
  M.Items.Add(FL.Items.Strings[FL.ItemIndex]);
  FL.Selected[FL.ItemIndex]:=true;//subor ostava vysvieteny
  RunFuse.Enabled:=true;
end;


procedure TFuseForm.SelectAllFilesClick(Sender: TObject);
var j:integer;
begin
  for j:=0 to FL.Items.Count-1 do
    M.Items.Add(FL.Items.Strings[j]);
  FL.SelectAll;  
  RunFuse.Enabled:=true;
  StatusBar1.SimpleText:='Status: READY';
end;

procedure TFuseForm.RunFuseClick(Sender: TObject);
var k:integer;
    name:string;
    NoRow,NoCol:string;//rozmery matice vo fuse.dat
    t:TextFile;
begin
  SelectAllFiles.Enabled:=false;
  ClearSelectedFiles.Enabled:=false;
  RunFuse.Enabled:=false;
  StatusBar1.SimpleText:='Status: RUNNING';
  FuseForm.Caption:='Fuse[RUNNING]';
  ProgressBar1.Min:=0;
  ProgressBar1.Step:=1;
  ProgressBar1.Position:=0;//treba obnovit vychodzi stav
  ProgressBar1.Visible:=true;
  ProgressBar1.Max:=M.Items.Count+3;//spocita pocet vybranych suborov
  name:=adresar+'\NoSort.dat';//este nezotriedeny subor

  ///////////////////////////////////fuse
  SetCurrentDir(adresar+'\CheckedData');
  fuse_TwoFiles(M.Items.Strings[0],M.Items.Strings[1],name);
  ProgressBar1.StepIt;
  ProgressBar1.StepIt;
  for k:=2 to M.Items.Count-1 do begin
    fuse_TwoFiles(name,M.Items.Strings[k],name);
    ProgressBar1.StepIt;
  end;

  //////////////////////////////////sort
  SetLength(p,rmax_in(name));
  for k:=low(p) to high(p) do
    p[k]:=line.Create;
  read_input(p,smax_in(name),name);
  sort(p);
  ProgressBar1.StepIt;
  /////////////////////////////////napisanie suboru fuse.dat
  AssignFile(t,adresar+'\fuse.dat');Rewrite(t);
  //spravny format prveho riadku:
  NoRow:=Format('%5d',[rmax_in(name)]);
  NoCol:=Format('%5d',[smax_in(name)]);
  writeln(t,'FUSED'+NoCol+NoRow);

  for k:=low(p) to high(p) do
    writeln(t,p[k].name+' '+p[k].data);
  CloseFile(t);
  ProgressBar1.StepIt;

  write_fuse_list(name);//vytvara subor fuse.lst
  DeleteFile(name);
  ProgressBar1.StepIt;
  ProgressBar1.Visible:=false;
  SelectAllFiles.Enabled:=true;
  ClearSelectedFiles.Enabled:=true;
  StatusBar1.SimpleText:='Status: OUTPUT FILES WRITTEN TO DISK';
  FuseForm.Caption:='Fuse';
end;

procedure TFuseForm.QuitClick(Sender: TObject);
begin
  FuseForm.Close;
end;

procedure TFuseForm.ClearSelectedFilesClick(Sender: TObject);
var i:integer;
begin
  M.Clear;
  for i:=0 to FL.Items.Count-1 do
    FL.Selected[i]:=false;
  RunFuse.Enabled:=false;
  StatusBar1.SimpleText:='Status: Select Files';
end;

procedure TFuseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FytopackForm.Caption:='Fytopack';
end;

procedure TFuseForm.FormShow(Sender: TObject);
begin
  FytopackForm.Caption:='Fytopack->Fuse';
  FL.Update;//aktualny stav adresara CheckedData
end;
                 //undo one selection
procedure TFuseForm.MClick(Sender: TObject);
var bad:string;
begin
  bad:=M.Items.Strings[M.ItemIndex];
  FL.Selected[FL.Items.IndexOf(bad)]:=false;//odznacenie suboru
  M.Items.Delete(M.ItemIndex);//vymazanie suboru
end;

end.
