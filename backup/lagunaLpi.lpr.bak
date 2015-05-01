program lagunaLpi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lagunaPas, UMetaData, UFormTable, selectfilter, UFormEditDB, 
UdbConnection;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TLaguna, Laguna);
  Application.CreateForm(TTableForm1, TableForm1);
  Application.CreateForm(TselFilter, selFilter);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TFormConnection, FormConnection);
  Application.Run;
end.

