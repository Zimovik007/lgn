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
    procedure DBGrid1TitleClick(Column: TColumn);
    public
      procedure CreateTable(Sender: TObject; index: integer);
      function GetSqlCode(index: integer): TStringList;
      procedure GetPropsColumns(index: integer);
  end;


var
  TableForm1: TTableForm1;
  TableIndex: integer;

implementation

{$R *.lfm}

{ TTableForm1 }

procedure TTableForm1.DBGrid1TitleClick(Column: TColumn);
var
  i: integer;
  s: ansistring;
begin
  for i := 0 to high(Tables[TableIndex].Fields) do begin
    if Column.Fieldname = Tables[TableIndex].Fields[i].name then begin
      s := Tables[TableIndex].name + '.' + Tables[TableIndex].Fields[i].name;
      continue;
    end;
    if Column.Fieldname = Tables[TableIndex].Fields[i].RefField then begin
      s := Tables[TableIndex].Fields[i].RefTable + '.' + Tables[TableIndex].Fields[i].RefField;
      continue;
    end;
  end;
  TableForm1.SQLQuery1.Close;
  TableForm1.SQLQuery1.SQL.text := '';
  TableForm1.SQLQuery1.SQL := GetSqlCode(TableIndex);
  TableForm1.SQLQuery1.SQL.text := TableForm1.SQLQuery1.SQL.text +
    'ORDER BY ' + s;
  TableForm1.SQLQuery1.Open;
  GetPropsColumns(TableIndex);
end;

procedure TTableForm1.CreateTable(Sender: TObject; index: integer);
var
  i: integer;
begin
  TableIndex := index;
  TableForm1 := TTableForm1.Create(Self);
  TableForm1.Caption := (Sender as TMenuItem).Caption;
  TableForm1.Tag := (Sender as TMenuItem).Tag;
  TableForm1.SQLQuery1.Active := False;
  TableForm1.SQLQuery1.SQL := GetSqlCode(index);
  TableForm1.SQLQuery1.Active := True;
  GetPropsColumns(index);
end;

function TTableForm1.GetSqlCode(index: integer): TStringList;
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
    Sel := Sel + Tables[index].Fields[i].RefTable + '.';
    Sel := Sel + Tables[index].Fields[i].RefField + ' ,';
    Inn := Inn + 'Inner Join ' + Tables[index].Fields[i].RefTable + ' ON ' ;
    Inn := Inn + Tables[index].name + '.';
    Inn := Inn + Tables[index].Fields[i].name + ' = ';
    Inn := Inn + Tables[index].Fields[i].RefTable + '.id ';
  end;
  if Sel = 'Select ' then Sel += '* ';
  Sel[length(Sel)] := ' ';
  res := TStringList.Create;
  res.Append(Sel);
  res.Append(From);
  res.Append(Inn);
  result := res;
end;

procedure TTableForm1.GetPropsColumns(index: integer);
var
  i: integer;
begin
  for i := 0 to high(Tables[index].Fields) do begin
    TableForm1.DBGrid1.Columns[i].Title.Caption := Tables[index].Fields[i].caption;
    TableForm1.DBGrid1.Columns[i].Width := Tables[index].Fields[i].width;
    TableForm1.DBGrid1.Columns[i].Visible := Tables[index].Fields[i].Visible;
  end;
end;

end.

