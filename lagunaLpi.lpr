program lagunaLpi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lagunaPas, syntaxpas, UMetaData, UFormTable
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TLaguna, Laguna);
  Application.CreateForm(TTableForm1, TableForm1);
  Application.Run;
end.

