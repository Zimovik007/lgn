unit UFormTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls;

type

  { TTableForm1 }

  TTableForm1 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SQLQuery1: TSQLQuery;
    procedure CreateTable();
  end;

var
  TableForm1: TTableForm1;

implementation

{$R *.lfm}

{ TTableForm1 }

procedure TTableForm1.CreateTable();
begin

end;

end.

