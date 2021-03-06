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
  procedure addField(numTable: integer; name1, caption1: string;width1: integer;
    visible: boolean; type1: TFieldType; RefTable1, RefField1: string);

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

procedure addField(numTable: integer; name1, caption1: string; width1: integer;
  visible: boolean; type1: TFieldType; RefTable1, RefField1: string);
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
  addField(0, 'CLASSROOM', 'Аудитория', 100, true, ftString, 'none', 'none');
  addField(1, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(1, 'SUBNAME', 'Предмет', 320, true, ftString, 'none', 'none');
  addField(2, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(2, 'GROUPNAME', 'Группа', 100, true, ftString, 'none', 'none');
  addField(3, 'group_id', 'Группа', 130, true, ftInteger, 'GROUPS', 'GROUPNAME');
  addField(3, 'course_id', 'Предмет', 300, true, ftInteger, 'COURSES', 'SUBNAME');
  addField(4, 'pair_id', 'Пара', 120, true, ftInteger, 'PAIRS', 'PERIOD');
  addField(4, 'weekday_id', 'День недели', 130, true, ftInteger, 'WEEKDAYS', 'WEEKDAY');
  addField(4, 'group_id', 'Группа', 100, true, ftInteger, 'GROUPS', 'GROUPNAME');
  addField(4, 'course_id', 'Предмет', 300, true, ftInteger, 'COURSES', 'SUBNAME');
  addField(4, 'class_id', 'Аудитория', 100, true, ftInteger, 'CLASSROOMS', 'CLASSROOM');
  addField(4, 'teacher_id', 'Преподаватель', 300, true, ftInteger, 'TEACHERS', 'TEACHERNAME');
  addField(5, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(5, 'PERIOD', 'Период', 100, true, ftString, 'none', 'none');
  addField(6, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(6, 'TEACHERNAME', 'Преподаватель', 270, true, ftString, 'none', 'none');
  addField(7, 'teacher_id', 'Преподаватель', 300, true, ftInteger, 'TEACHERS', 'TEACHERNAME');
  addField(7, 'course_id', 'Предмет', 300, true, ftInteger, 'COURSES', 'SUBNAME');
  addField(8, 'id', 'Ключ', 60, false, ftInteger, 'none', 'none');
  addField(8, 'WEEKDAY', 'День недели', 150, true, ftString, 'none', 'none');
end;

end.

