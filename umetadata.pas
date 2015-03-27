unit UMetaData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TField = class
    name: string;
    caption: string;
    width: integer;
    visible: boolean;
  end;

  TTable = class
    name: string;
    caption: string;
    Fields: array of TField;
  end;

  procedure FillMetaData;
  procedure addTable(name1, caption1: string);
  procedure addField(numTable: integer; name1, caption1: string; width1: integer; visible: boolean);

var
  Tables: array of TTable;

implementation

procedure addTable(name1, caption1: string);
begin
  setlength(Tables, length(Tables) + 1);
  Tables[high(Tables)] := TTable.Create;
  Tables[high(Tables)].name := name1;
  Tables[high(Tables)].caption := caption1;
end;

procedure addField(numTable: integer; name1, caption1: string; width1: integer; visible: boolean);
begin
  with Tables[numTable] do begin
  setlength(Fields, length(Fields) + 1);
  Fields[high(Fields)] := TField.Create;
  Fields[high(Fields)].name := name1;
  Fields[high(Fields)].caption := caption1;
  Fields[high(Fields)].width := width1;
  Fields[high(Fields)].visible := visible;
  end;
end;

procedure FillMetaData;
var
  i, j: integer;
begin
  addTable('CLASSROOMS', 'Аудитории');
  addTable('COURSES', 'Предметы');
  addTable('GROUPS', 'Группы');
  addTable('GROUPS_COURSES', 'Группа-Предмет');
  addTable('LESSONS', 'Уроки');
  addTable('PAIRS', 'Пары');
  addTable('TEACHERS', 'Преподаватели');
  addTable('TEACHERS_COURSES', 'Преподаватель-Предмет');
  addtable('WEEKDAYS', 'Дни Недели');

  addField(0, 'id', 'Ключ', 60, true);
  addField(0, 'classroom', 'Аудитория', 100, true);
  addField(1, 'id', 'Ключ', 60, true);
  addField(1, 'name', 'Предмет', 320, true);
  addField(2, 'id', 'Ключ', 60, true);
  addField(2, 'name', 'Группа', 100, true);
  addField(3, 'group_id', 'Ключ группы', 130, true);
  addField(3, 'course_id', 'Ключ предмета', 130, true);
  addField(4, 'pair_id', 'Ключ пары', 120, true);
  addField(4, 'weekday_id', 'Ключ дня недели', 150, true);
  addField(4, 'group_id', 'Ключ группы', 130, true);
  addField(4, 'course_id', 'Ключ предмета', 130, true);
  addField(4, 'class_id', 'Ключ аудитории', 150, true);
  addField(4, 'teacher_id', 'Ключ преподавателя', 190, true);
  addField(5, 'id', 'Ключ', 60, true);
  addField(5, 'period', 'Период', 100, true);
  addField(6, 'id', 'Ключ', 60, true);
  addField(6, 'name', 'Преподаватель', 270, true);
  addField(7, 'teacher_id', 'Ключ преподавателя', 200, true);
  addField(7, 'course_id', 'Ключ предмета', 150, true);
  addField(8, 'id', 'Ключ', 60, true);
  addField(8, 'weekday', 'День недели', 150, true);
end;

end.

