unit lagunaPas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, DB, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Menus, UMetaData, UFormTable;

type

  { TLaguna }

  FormBox = record
    FormTable: TTableForm1;
    Used: boolean;
  end;

  TLaguna = class(TForm)
    MainMenu: TMainMenu;
    MainMenu1: TMenuItem;
    Reference1: TMenuItem;
    AboutProg: TMenuItem;
    ExitMenu1: TMenuItem;
    AboutRef: TMenuItem;
    ToConnectDB: TButton;
    DataSource1: TDataSource;
    DBconnect: TMemo;
    IBConnection1: TIBConnection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    ToDisconnectDB: TButton;
    procedure AboutProgClick(Sender: TObject);
    procedure ExitMenu1Click(Sender: TObject);
    procedure AboutRefClick(Sender: TObject);
    procedure ToConnectDBClick(Sender: TObject);
    procedure ToDisconnectDBClick(Sender: TObject);
    procedure CreateMenu(Sender: TObject);
    private
      AllForms: array of FormBox;
      SubMenu: array of TMenuItem;
      procedure ClickOnTable(Sender: TObject);
      procedure CloseForm(Sender: TObject; var Action1: TCloseAction);
  end;

var
  Laguna: TLaguna;

implementation

{$R *.lfm}

{ TLaguna }

// КЛИКИ ПО КНОПКАМ

procedure TLaguna.ToConnectDBClick(Sender: TObject);
begin
  SQLTransaction1.Active := False;
  IBConnection1.Connected := False;
  IBConnection1.DatabaseName := DBConnect.Lines[0];
  try
    SQLTransaction1.Active := True;
    IBConnection1.Connected := True;
    FillMetaData;
    CreateMenu(Sender);
  except
    ShowMessage('Проверьте правильность введенных данных и повторите попытку');
  end;
end;

procedure TLaguna.ToDisconnectDBClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to high(SubMenu) do begin
    SubMenu[i].free;
    AllForms[i].FormTable.free;
    AllForms[i].Used := false;
  end;
  setlength(AllForms, 0);
  setlength(SubMenu, 0);
  IBConnection1.connected := FALSE;
end;

procedure TLaguna.AboutProgClick(Sender: TObject);
begin
  ShowMessage('Laguna - Система управления базами данных.' + #13#10 +
    'Разработал: Гусаров В.Е.' + #13#10 +
    'Преподаватель: Кленин А.С.');
end;

procedure TLaguna.ExitMenu1Click(Sender: TObject);
begin
  Laguna.close;
end;

procedure TLaguna.AboutRefClick(Sender: TObject);
begin
  ShowMessage('Для пользования справочником подключитесь к БД' + #13#10 +
    'Введите полный путь к БД и нажмите "Подключить"' + #13#10 +
    'В Меню - Справочник вы можете выбрать таблицу');
end;

// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

procedure TLaguna.CreateMenu(Sender: TObject);
var
  SLTables: TStringList;
  i: integer;
begin
  for i := 0 to high(SubMenu) do
    SubMenu[i].free;
  SLTables := TStringList.Create;
  IBConnection1.GetTableNames(SLTables, False);
  setlength(SubMenu, SLTables.Count);
  setlength(AllForms, SLTables.Count);
  for i := 0 to SLTables.Count - 1 do begin
    with Reference1 do begin
      SubMenu[i] := TMenuItem.Create(Self);
      with SubMenu[i] do begin
        Caption := Tables[i].Caption;
        OnClick := @ClickOnTable;
        Tag := i;
      end;
      insert(i, SubMenu[i]);
    end;
  end;
  SLTables.free;
end;

procedure TLaguna.ClickOnTable(Sender: TObject);
var
  index: integer;
begin
  index := (Sender as TMenuItem).Tag;
  if AllForms[index].used then begin
    AllForms[index].FormTable.BringToFront;
  end
  else begin
    TableForm1.CreateTable(Sender, index);
    with AllForms[index] do begin
      FormTable := TTableForm1.Create(Self);
      FormTable := TableForm1;
      Used := True;
      FormTable.OnClose := @CloseForm;
      FormTable.Show;
      end;
    end;
  end;

procedure TLaguna.CloseForm(Sender: TObject; var Action1: TCloseAction);
begin
  AllForms[(Sender as TForm).Tag].Used := False;
end;

end.
