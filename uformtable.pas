unit UFormTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DBCtrls, Menus, ExtCtrls, StdCtrls, ActnList, UMetaData, Buttons;

type

  { TTableForm1 }

  Filter = class
    ActiveFilter: TSpeedButton;
    DeleteFilter: TButton;
    DBcolumns: TComboBox;
    Value1: TEdit;
    Value2: TEdit;
    label1: TLabel;
  end;

  FilterQueryBox = record
    Used: boolean;
    QueryString: string;
  end;

  TTableForm1 = class(TForm)
    AddFilterButton: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    FiltersPanel: TPanel;
    selfilter1: TRadioGroup;
    SQLQuery1: TSQLQuery;
    procedure AddFilterButtonClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DelFilter(Sender: TObject);
    procedure ActiveFilter(Sender: TObject);
  public
    procedure CreateTable(Sender: TObject; index: integer);
    function GetSqlInnerCode(index: integer): TStringList;
    function GetSqlWhereCode(): string;
    procedure GetPropsColumns(index: integer);
    procedure BuildSqlCode;
    procedure UseParams();
  private
    UsedFilters: array of FilterQueryBox;
    Filters: array of Filter;
    CountDelFilters: integer;
    ComparisonSortString: string;
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
  for i := 0 to high(Tables[TableIndex].Fields) do
  begin
    if Column.Fieldname = Tables[TableIndex].Fields[i].Name then
    begin
      s := Tables[TableIndex].Name + '.' + Tables[TableIndex].Fields[i].Name;
      continue;
    end;
    if Column.Fieldname = Tables[TableIndex].Fields[i].RefField then
    begin
      s := Tables[TableIndex].Fields[i].RefTable + '.' +
        Tables[TableIndex].Fields[i].RefField;
      continue;
    end;
  end;
  TableForm1.SQLQuery1.Close;
  BuildSqlCode;
  TableForm1.SQLQuery1.SQL.Text := TableForm1.SQLQuery1.SQL.Text + 'ORDER BY ' + s;
  if ComparisonSortString = s then begin
    TableForm1.SQLQuery1.SQL.Text := TableForm1.SQLQuery1.SQL.Text + ' DESC ';
    s := '';
  end;
  TableForm1.SQLQuery1.Open;
  GetPropsColumns(TableIndex);
  ComparisonSortString := s;
end;

procedure TTableForm1.AddFilterButtonClick(Sender: TObject);
var
  index, i: integer;
begin
  index := selfilter1.ItemIndex;
  setlength(Filters, length(Filters) + 1);
  setlength(UsedFilters, length(UsedFilters) + 1);
  Filters[high(Filters)] := Filter.Create;

  Filters[high(Filters)].DBColumns := TComboBox.Create(FiltersPanel);
  with Filters[high(Filters)].DBColumns do
  begin
    Parent := FiltersPanel;
    top := length(Filters) * 70 - CountDelFilters * 70;
    font.size := 10;
    Height := 12;
    left := 10;
    Width := 116;
    Style := csDropDownList;
    for i := 0 to high(Tables[Tableindex].Fields) do
      if Tables[Tableindex].Fields[i].Visible then
        Items.Add(Tables[Tableindex].Fields[i].Caption);
    ItemIndex := 0;
  end;

  Filters[high(Filters)].Value1 := TEdit.Create(FiltersPanel);
  with Filters[high(Filters)].Value1 do
  begin
    Parent := FiltersPanel;
    top := length(Filters) * 70 + 30 - CountDelFilters * 70;
    font.size := 10;
    Height := 12;
    left := 30;
    if (index = 0) or (index = 1) or (index = 2) then
      Width := 96
    else
    begin
      left := 10;
      Width := 45;
    end;
  end;

  Filters[high(Filters)].DeleteFilter := TButton.Create(FiltersPanel);
  with Filters[high(Filters)].DeleteFilter do
  begin
    Parent := FiltersPanel;
    top := length(Filters) * 70 + 30 - CountDelFilters * 70;
    font.size := 10;
    font.color := clred;
    Height := 25;
    Width := 25;
    Caption := 'X';
    left := 130;
    tag := high(Filters);
    onclick := @DelFilter;
  end;

  Filters[high(Filters)].Label1 := TLabel.Create(FiltersPanel);
  with Filters[high(Filters)].Label1 do
  begin
    Parent := FiltersPanel;
    top := length(Filters) * 70 + 30 - CountDelFilters * 70;
    font.size := 14;
    Height := 25;
    Width := 25;
    if index = 0 then
    begin
      Caption := '=';
      left := 10;
    end;
    if index = 1 then
    begin
      Caption := '<';
      left := 10;
    end;
    if index = 2 then
    begin
      Caption := '>';
      left := 10;
    end;
    if index = 3 then
    begin
      Caption := '->';
      left := 61;
    end;
  end;

  Filters[high(Filters)].Value2 := TEdit.Create(FiltersPanel);
  if index = 3 then
  begin
    with Filters[high(Filters)].Value2 do
    begin
      Parent := FiltersPanel;
      top := length(Filters) * 70 + 30 - CountDelFilters * 70;
      font.size := 10;
      Height := 12;
      left := 81;
      Width := 45;
    end;
  end;

  Filters[high(Filters)].ActiveFilter := TSpeedButton.Create(FiltersPanel);
  with Filters[high(Filters)].ActiveFilter do
  begin
    Parent := FiltersPanel;
    top := length(Filters) * 70 - CountDelFilters * 70;
    font.size := 10;
    font.color := clred;
    Height := 25;
    Width := 25;
    Caption := 'Go';
    left := 130;
    tag := high(Filters);
    GroupIndex := tag + 1;
    AllowAllUp := True;
    onclick := @ActiveFilter;
  end;
end;

procedure TTableForm1.DelFilter(Sender: TObject);
var
  index, i, j: integer;
begin
  index := (Sender as TButton).Tag;
  if UsedFilters[index].used then begin
    UsedFilters[index].used := not UsedFilters[index].used;
    TableForm1.SQLQuery1.Close;
    BuildSqlCode;
    TableForm1.SQLQuery1.Open;
    GetPropsColumns(TableIndex);
  end;
  FreeAndNil(Filters[index].ActiveFilter);
  FreeAndNil(Filters[index].DBColumns);
  FreeAndNil(Filters[index].Value1);
  FreeAndNil(Filters[index].Value2);
  FreeAndNil(Filters[index].Label1);
  Filters[index].DeleteFilter.Hide;
  for i := index + 1 to high(Filters) do
  begin
    if Filters[i].DBColumns = nil then
      continue;
    with Filters[i] do
    begin
      DeleteFilter.top := DeleteFilter.top - 70;
      DBColumns.top := DBColumns.top - 70;
      Value1.top := Value1.top - 70;
      Value2.top := Value2.top - 70;
      Label1.top := Label1.top - 70;
      ActiveFilter.top := ActiveFilter.top - 70;
    end;
  end;
  CountDelFilters += 1;
end;

procedure TTableForm1.ActiveFilter(Sender: TObject);
var
  index: integer;
begin
  index := (Sender as TSpeedButton).Tag;

  if (Filters[index].Value1.Text = '') and (Filters[index].Value2.Text = '') then
  begin
    ShowMessage('Запрос введен неверно!');
    exit;
  end;

  if (Filters[index].Value1.Text <> '') and (Filters[index].Value2.Text = '') then
  begin
    if Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefField =
      'none' then
      UsedFilters[index].QueryString :=
        Tables[TableIndex].Name + '.' +
        Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex + 1].Name +
        Filters[index].Label1.Caption + ' :' + Filters[index].Value1.Text
    else
      UsedFilters[index].QueryString :=
        Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefTable +
        '.' + Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefField +
        Filters[index].Label1.Caption + ' :' + Filters[index].Value1.Text;
  end;

  if (Filters[index].Value1.Text <> '') and (Filters[index].Value2.Text <> '') then
  begin
    if Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefField =
      'none' then
      UsedFilters[index].QueryString :=
        Tables[TableIndex].Name + '.' +
        Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex + 1].Name +
        '>' + ' :' + Filters[index].Value1.Text + ' and ' +
        Tables[TableIndex].Name + '.' +
        Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex + 1].Name +
        '<' + ' :' + Filters[index].Value2.Text
    else
      UsedFilters[index].QueryString :=
        Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefTable +
        '.' + Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefField +
        '>' + ' :' + Filters[index].Value1.Text + ' and ' +
        Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefTable +
        '.' + Tables[TableIndex].Fields[Filters[index].DBcolumns.ItemIndex].RefField +
        '<' + ' :' + Filters[index].Value2.Text;
  end;

  UsedFilters[index].used := not UsedFilters[index].used;
  TableForm1.SQLQuery1.Close;
  BuildSqlCode;
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
  TableForm1.SQLQuery1.SQL := GetSqlInnerCode(index);
  TableForm1.SQLQuery1.Active := True;
  GetPropsColumns(index);
end;

function TTableForm1.GetSqlInnerCode(index: integer): TStringList;
var
  res: TStringList;
  Sel, From, Inn: string;
  i: integer;
begin
  Inn := ' ';
  Sel := 'Select ';
  From := 'From ' + Tables[index].Name + ' ';
  for i := 0 to high(Tables[index].Fields) do
  begin
    if (Tables[index].Fields[i].RefTable = 'none') then
      continue;
    Sel := Sel + Tables[index].Fields[i].RefTable + '.';
    Sel := Sel + Tables[index].Fields[i].RefField + ' ,';
    Inn := Inn + 'Inner Join ' + Tables[index].Fields[i].RefTable + ' ON ';
    Inn := Inn + Tables[index].Name + '.';
    Inn := Inn + Tables[index].Fields[i].Name + ' = ';
    Inn := Inn + Tables[index].Fields[i].RefTable + '.id ';
  end;
  if Sel = 'Select ' then
    Sel += '* ';
  Sel[length(Sel)] := ' ';
  res := TStringList.Create;
  res.Append(Sel);
  res.Append(From);
  res.Append(Inn);
  Result := res;
end;

function TTableForm1.GetSQLWhereCode(): string;
var
  i: integer;
  s: string;
begin
  s := 'where ';
  for i := 0 to high(UsedFilters) do
    if (UsedFilters[i].used) and (Filters[i].DBcolumns <> nil) then
      s := s + UsedFilters[i].QueryString + ' and ';
  Delete(s, length(s) - 3, 4);
  if length(s) = 2 then
    s := '';
  Result := s;
end;

procedure TTableForm1.GetPropsColumns(index: integer);
var
  i: integer;
begin
  for i := 0 to high(Tables[index].Fields) do
  begin
    TableForm1.DBGrid1.Columns[i].Title.Caption := Tables[index].Fields[i].Caption;
    TableForm1.DBGrid1.Columns[i].Width := Tables[index].Fields[i].Width;
    TableForm1.DBGrid1.Columns[i].Visible := Tables[index].Fields[i].Visible;
  end;
end;

procedure TTableForm1.BuildSqlCode;
begin
  TableForm1.SQLQuery1.SQL.Text := '';
  TableForm1.SQLQuery1.SQL := GetSqlInnerCode(TableIndex);
  TableForm1.SQLQuery1.SQL.Text :=
    TableForm1.SQLQuery1.SQL.Text + ' ' + GetSqlWhereCode() + ' ';
  UseParams();
end;

procedure TTableForm1.UseParams();
var
  i: integer;
begin
  for i := 0 to high(UsedFilters) do
    if UsedFilters[i].Used then
    begin
      TableForm1.SQLQuery1.ParamByName(Filters[i].Value1.Text).AsString :=
        Filters[i].Value1.Text;
      if Filters[i].Value2.Text <> '' then
        TableForm1.SQLQuery1.ParamByName(Filters[i].Value2.Text).AsString :=
          Filters[i].Value2.Text;
    end;
end;

end.
