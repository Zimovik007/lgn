unit lagunaPas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, DB, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBGrids, syntaxpas;

type

  { TLaguna }

  TLaguna = class(TForm)
    ErrorLog: TMemo;
    L: TLabel;
    P: TLabel;
    Login1: TMemo;
    Password1: TMemo;
    ToConnectDB: TButton;
    DataSource1: TDataSource;
    DBconnect: TMemo;
    ResultTable: TDBGrid;
    IBConnection1: TIBConnection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    ToDisconnectDB: TButton;
    ToPerform: TButton;
    InputArea: TMemo;
    SqlQuery: TLabel;
    //procedure FormCreate(Sender: TObject);
    //procedure InputAreaChange(Sender: TObject);
    procedure ToConnectDBClick(Sender: TObject);
    procedure ToDisconnectDBClick(Sender: TObject);
    procedure ToPerformClick(Sender: TObject);
  end;

var
  Laguna: TLaguna;

implementation

{$R *.lfm}

{ TLaguna }

// КЛИКИ ПО КНОПКАМ

procedure TLaguna.ToConnectDBClick(Sender: TObject);
begin
  ErrorLog.Lines.Text := '';
  SQLTransaction1.Active := False;
  IBConnection1.Connected := False;
  if (DBConnect.Lines[0] = '') or (Login1.Lines[0] = '') or
    (Password1.Lines[0] = '') then
  begin
    ErrorLog.Lines[0] := 'Присутвуют незаполненные поля';
    exit;
  end;
  IBConnection1.DatabaseName := DBConnect.Lines[0];
  IBConnection1.UserName := Login1.Lines[0];
  IBConnection1.Password := Password1.Lines[0];
  try
    SQLTransaction1.Active := True;
    IBConnection1.Connected := True;
    ErrorLog.Lines[0] := 'Успешный человек успешен во всем';
  except
    ErrorLog.Lines[0] := 'Вы ввели неверный пароль или любые другие данные';
  end;
end;

procedure TLaguna.ToDisconnectDBClick(Sender: TObject);
begin
  ErrorLog.Lines.Text := '';
  if IBConnection1.connected then
    ErrorLog.Lines[0] := 'Вы отключились от Базы Данных';
  IBConnection1.connected := False;
end;

procedure TLaguna.ToPerformClick(Sender: TObject);
begin
  ErrorLog.Lines.Text := '';
  if not SQLTransaction1.Active then
  begin
    ErrorLog.Lines[0] := 'Нельзя сотворить здесь... Не подключившись к БД';
    exit;
  end;
  SQLQuery1.Active := False;
  SQLQuery1.SQL.Text := InputArea.Lines.Text;
  if SQLQuery1.SQL.Text = '' then
  begin
    ErrorLog.Lines[0] := 'Пустой запрос';
    exit;
  end;
  try
    SQLQuery1.Active := True;
    ErrorLog.Lines[0] := 'Было исполнено';
  except
    on E: Exception do begin
      ErrorLog.Lines[0] := '';
      ErrorLog.Lines[0] := 'Ваш код содержит ошибку, нужно исправить ' + #13#10 + E.Message;
    end;
  end;
end;

{
// СИНТАКСИС

procedure TLaguna.InputAreaChange(Sender: TObject);
var
  i: integer;
begin

end;

procedure TLaguna.FormCreate(Sender: TObject);
begin

end;
}

end.
