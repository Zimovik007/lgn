unit UFormEditDB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  UMetaData, sqldb, UdbConnection;

type

  { TEditForm }

  TEditForm = class(TForm)
    Apply1: TButton;
    Cancel1: TButton;
    SQLQuery1: TSQLQuery;
    procedure Apply1Click(Sender: TObject);
    procedure Cancel1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MakeFormForTEdit;
    procedure MakeFormForTComboBox;
    procedure ApplyTEditValue;
    procedure ApplyTComboBoxValue;
  private
    FNotify: TNotifyEvent;
  public
    FieldId: array of array of integer;
    AddField: TEdit;
    SelectField: array of TComboBox;
    procedure AddRecord(index: integer; flag: boolean);
    property Notify: TNotifyEvent read FNotify write FNotify;
  end;

var
  EditForm: TEditForm;

implementation

var
  TableIndex: integer;
  Ref: boolean;

{$R *.lfm}

{ TEditForm }

procedure TEditForm.AddRecord(index: integer; flag: boolean);
begin
  TableIndex := index;
  Ref := flag;
  if not flag then
    MakeFormForTEdit
  else MakeFormForTComboBox;
end;

procedure TEditForm.MakeFormForTEdit();
begin
  EditForm.height := 200;
  EditForm.width := 200;
  AddField := TEdit.Create(EditForm);
    with AddField do
    begin
      Parent := EditForm;
      top := 45;
      font.size := 10;
      Height := 12;
      left := 18;
      Width := 163;
    end;
  Apply1.top := 100;
  Apply1.left := 18;
  Cancel1.left := 106;
  Cancel1.top := 100;
  EditForm.Show;
end;

procedure TEditForm.MakeFormForTComboBox();
var
  i, j, index: integer;
  s: string;
begin
  EditForm.Width := 200;
  setlength(SelectField, length(Tables[TableIndex].Fields));
  for i := 0 to high(Tables[TableIndex].Fields) do begin
    SelectField[i] := TComboBox.Create(EditForm);
    with SelectField[i] do
    begin
      Parent := EditForm;
      top := 30 + 65 * i;
      font.size := 10;
      Height := 12;
      left := 18;
      Width := 163;
    end;
    //Индекс таблицы
    for j := 0 to high(Tables) do
      if Tables[j].name = Tables[TableIndex].Fields[i].RefTable then
        index := j;
    // <--
    //Считываем записи из БД в ComboBox
    s := 'SELECT DISTINCT ' + 'id ' + ', ' + Tables[TableIndex].Fields[i].RefField + ' FROM ' + Tables[TableIndex].Fields[i].RefTable;
    with EditForm.SQLQuery1 do begin
      Close;
      SQL.Clear;
      SQL.Add(s);
      Open;
    end;
    setlength(FieldId, length(SelectField));
    while not EditForm.SQLQuery1.Eof do begin
     SelectField[i].Items.Add(EditForm.SQLQuery1.Fields[1].AsString);
     setlength(FieldId[i], length(FieldId[i]) + 1);
     FieldId[i, high(FieldId[i])] := EditForm.SQLQuery1.Fields[0].AsInteger;
     EditForm.SQLQuery1.Next;
    end;
    // <--
  end;
  Apply1.top := 30 + 65 * high(Tables[TableIndex].Fields) + 50;
  Apply1.left := 18;
  Cancel1.left := 106;
  Cancel1.top := 30 + 65 * high(Tables[TableIndex].Fields) + 50;
  EditForm.Height := Apply1.top + 40;
  EditForm.Show;
end;

procedure TEditForm.Apply1Click(Sender: TObject);
begin
  if not Ref then
    ApplyTEditValue
  else ApplyTComboBoxValue;
  FNotify(Self);
end;

procedure TEditForm.ApplyTEditValue;
var
  s, sqlQ: string;
begin
  if AddField.Text = '' then begin
    ShowMessage('Вы ничего не ввели =)');
    exit;
  end;
  sqlQ := '(SELECT GEN_ID(s, 1) FROM RDB$DATABASE)';
  s := 'INSERT INTO ' + Tables[TableIndex].name + ' VALUES (' + sqlQ;
  s += ' , ''' + AddField.Text + ''');';
  with EditForm.SqlQuery1 do begin
    Close;
    Sql.Clear;
    Sql.Add(s);
    ExecSql;
  end;
  FormConnection.SqlTransaction1.Commit;
  EditForm.Close;
end;

procedure TEditForm.ApplyTComboBoxValue;
var
  i, j: integer;
  s, temp: string;
begin
  for i := 0 to high(SelectField) do
    if SelectField[i].ItemIndex = -1 then begin
      ShowMessage('Заполнены не все поля');
      exit;
    end;
  s := 'INSERT INTO ' + Tables[TableIndex].name + ' VALUES (';
  for i := 0 to high(SelectField) - 1 do
    s += IntToStr(FieldId[i, SelectField[i].ItemIndex]) + ', ';
  s += IntToStr(FieldId[high(SelectField), SelectField[high(SelectField)].ItemIndex]) +');';
  with EditForm.SqlQuery1 do begin
    Close;
    Sql.Clear;
    Sql.Add(s);
    ExecSql;
  end;
  FormConnection.SqlTransaction1.Commit;
  EditForm.Close;
end;

procedure TEditForm.Cancel1Click(Sender: TObject);
begin
  EditForm.close;
end;

procedure TEditForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  i: integer;
begin
  for i := 0 to high(SelectField) do
    freeandnil(SelectField[i]);
  setlength(SelectField, 0);
  if AddField = nil then
    exit;
  freeandnil(AddField);
end;



end.

