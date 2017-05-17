unit SyntaxFUnit;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls;

procedure SyntaxFormat_proc(subor:string);

implementation
  uses FytopackUnit;
{
vstup:
fused   10    3
Achi mill 9464342749
Agro repe 3623040440
Arte miss 2204045000

vystup:              //syntax-format
fused   10    3
3 10
9 4 6 4 3 4 2 7 4 9
3 6 2 3 0 4 0 4 4 0
2 2 0 4 0 4 5 0 0 0

}
procedure SyntaxFormat_proc(subor:string);
var tin,tout:TextFile;
    s,line:string;
    i:integer;
begin
//FytopackForm.asl adresar kde sa nachadza Fytopack.exe
  AssignFile(tin,subor); Reset(tin);
  AssignFile(tout,FytopackForm.asl+'syntax.dat'); Rewrite(tout);

  readln(tin,line);
  writeln(tout,line);
  writeln(tout,Trim(copy(line,11,5))+' '+Trim(copy(line,6,5)));//druhy riadok tout

  while not Eof(tin) do begin
    readln(tin,line);
    line:=copy(line,11,MaxInt);//odrezanie mien
    s:='';
    for i:=1 to Length(line) do begin
      s:=s+line[i]+' ';
    end;
    writeln(tout,Trim(s));
  end;

  CloseFile(tin);
  CloseFile(tout);

end;

end.

