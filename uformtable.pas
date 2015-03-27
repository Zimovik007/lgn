unit UFormTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, Menus, UMetaData;

type

  { TTableForm1 }

  TTableForm1 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SQLQuery1: TSQLQuery;
    public
    procedure CreateTable(Sender: TObject; index: integer);
  end;

  function GetSqlCode(index: integer): TStringList;

var
  TableForm1: TTableForm1;

implementation

{$R *.lfm}

{ TTableForm1 }

procedure TTableForm1.CreateTable(Sender: TObject; index: integer);
var
  i: integer;
begin
  TableForm1 := TTableForm1.Create(Self);
  TableForm1.Caption := (Sender as TMenuItem).Caption;
  TableForm1.Tag := (Sender as TMenuItem).Tag;
  TableForm1.SQLQuery1.Active := False;
  TableForm1.SQLQuery1.SQL := GetSqlCode(index);
  TableForm1.SQLQuery1.Active := True;
  for i := 0 to high(Tables[index].Fields) do begin
    //TableForm1.DBGrid1.Columns.Add.FieldName := Tables[index].Fields[i].name;
    TableForm1.DBGrid1.Columns[i].Title.Caption := Tables[index].Fields[i].caption;
    TableForm1.DBGrid1.Columns[i].Width := Tables[index].Fields[i].width;
    TableForm1.DBGrid1.Columns[i].Visible := Tables[index].Fields[i].Visible;
  end;
end;

function GetSqlCode(index: integer): TStringList;
var
  res : TStringList;
  Sel, From, Inn: string;
  i: integer;
begin
  Inn := ' ';
  Sel := 'Select ';
  From := 'From ' + Tables[index].name + ' ';
  for i := 0 to high(Tables[index].Fields) do begin
    if (Tables[index].Fields[i].RefTable = 'none') then continue;
    Sel += Tables[index].Fields[i].RefTable;
    Sel += '.';
    Sel += Tables[index].Fields[i].RefField;
    Sel += ' ,';
    Inn += 'Inner Join ';
    Inn += Tables[index].Fields[i].RefTable;
    Inn += ' ON ' ;
    Inn += Tables[index].name;
    Inn += '.';
    Inn += Tables[index].Fields[i].name;
    Inn += ' = ';
    Inn += Tables[index].Fields[i].RefTable;
    Inn += '.';
    Inn += 'id ';
  end;
  if Sel = 'Select ' then Sel += '* ';
  Sel[length(Sel)] := ' ';
  //ShowMessage(Sel + From + Inn);
  res := TStringList.Create;
  res.Append(Sel);
  res.Append(From);
  res.Append(Inn);
  result := res;
end;

end.

