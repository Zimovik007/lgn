unit UMetaData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, typinfo, dialogs, db;

type
  TField = class
    name: string;
    caption: string;
    width: integer;
    visible: boolean;
    Ftype: TFieldType;
    RefTable: string;
    RefField: string;
  end;

  TTable = class
    name: string;
    caption: string;
    Fields: array of TField;
  end;

  procedure FillMetaData;
  procedure addTable(name1, caption1: string);
  procedure addField(numTable: integer; name1, caption1: string; width1: integer; visible: boolean; type1: TFieldType; RefTable1, RefField1: string);

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

procedure addField(numTable: integer; name1, caption1: string; width1: integer; visible: boolean; type1: TFieldType; RefTable1, RefField1: string);
begin
  with Tables[numTable] do begin
  setlength(Fields, length(Fields) + 1);
  Fields[high(Fields)] := TField.Create;
  Fields[high(Fields)].name := name1;
  Fields[high(Fields)].caption := caption1;
  Fields[high(Fields)].width := width1;
  Fields[high(Fields)].visible := visible;
  Fields[high(Fields)].Ftype := type1;
  Fields[high(Fields)].RefTable := RefTable1;
  Fields[high(Fields)].RefField := RefField1;
  end;
end;

procedure FillMetaData;
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

  addField(0, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(0, 'classroom', 'Аудитория', 100, true, ftString, 'none', 'none');
  addField(1, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(1, 'name', 'Предмет', 320, true, ftString, 'none', 'none');
  addField(2, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(2, 'name', 'Группа', 100, true, ftString, 'none', 'none');
  addField(3, 'group_id', 'Ключ группы', 130, true, ftInteger, 'GROUPS', 'name');
  addField(3, 'course_id', 'Ключ предмета', 130, true, ftInteger, 'COURSES', 'name');
  addField(4, 'pair_id', 'Ключ пары', 120, true, ftInteger, 'PAIRS', 'period');
  addField(4, 'weekday_id', 'Ключ дня недели', 150, true, ftInteger, 'WEEKDAYS', 'weekday');
  addField(4, 'group_id', 'Ключ группы', 130, true, ftInteger, 'GROUPS', 'name');
  addField(4, 'course_id', 'Ключ предмета', 130, true, ftInteger, 'COURSES', 'name');
  addField(4, 'class_id', 'Ключ аудитории', 150, true, ftInteger, 'CLASSROOMS', 'classroom');
  addField(4, 'teacher_id', 'Ключ преподавателя', 190, true, ftInteger, 'TEACHERS', 'name');
  addField(5, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(5, 'period', 'Период', 100, true, ftString, 'none', 'none');
  addField(6, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(6, 'name', 'Преподаватель', 270, true, ftString, 'none', 'none');
  addField(7, 'teacher_id', 'Ключ преподавателя', 200, true, ftInteger, 'TEACHERS', 'name');
  addField(7, 'course_id', 'Ключ предмета', 150, true, ftInteger, 'COURSES', 'name');
  addField(8, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(8, 'weekday', 'День недели', 150, true, ftString, 'none', 'none');
end;

end.

