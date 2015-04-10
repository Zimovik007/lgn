program lagunaLpi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lagunaPas, syntaxpas, UMetaData, UFormTable, selectfilter
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TLaguna, Laguna);
  Application.CreateForm(TTableForm1, TableForm1);
  Application.CreateForm(TselFilter, selFilter);
  Application.Run;
end.

