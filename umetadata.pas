unit UMetaData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TTable = class
    name: string;
    caption: string;
  end;

  TField = class
    name: string;
    caption: string;
    width: integer;
  end;

  procedure FillMetaData;

var
  Tables: array [0..8] of TTable;
  Fields: array of array of TField;

implementation

procedure FillMetaData;
var
  i, j: integer;
begin
for i := 0 to 8 do
  Tables[i] := TTable.Create;

Tables[0].name := 'CLASSROOMS';
Tables[0].caption := 'Аудитории';

Tables[1].name := 'COURSES';
Tables[1].caption := 'Предметы';

Tables[2].name := 'GROUPS';
Tables[2].caption := 'Группы';

Tables[3].name := 'GROUPS_COURSES';
Tables[3].caption := 'Группа-Предмет';

Tables[4].name := 'LESSONS';
Tables[4].caption := 'Уроки';

Tables[5].name := 'PAIRS';
Tables[5].caption := 'Пары';

Tables[6].name := 'TEACHERS';
Tables[6].caption := 'Преподаватели';

Tables[7].name := 'TEACHERS_COURSES';
Tables[7].caption := 'Преподаватель-Предмет';

Tables[8].name := 'WEEKDAYS';
Tables[8].caption := 'Дни Недели';

setlength(Fields, 9);
setlength(Fields[0], 2);
setlength(Fields[1], 2);
setlength(Fields[2], 2);
setlength(Fields[3], 2);
setlength(Fields[4], 6);
setlength(Fields[5], 2);
setlength(Fields[6], 2);
setlength(Fields[7], 2);
setlength(Fields[8], 2);

for i := 0 to 8 do
  for j := 0 to high(Fields[i]) do
    Fields[i,j] := TField.Create;

Fields[0,0].name := 'id';
Fields[0,0].caption := 'Ключ';
Fields[0,0].width := 60;

Fields[0,1].name := 'classroom';
Fields[0,1].caption := 'Аудитория';
Fields[0,1].width := 100;

Fields[1,0].name := 'id';
Fields[1,0].caption := 'Ключ';
Fields[1,0].width := 60;

Fields[1,1].name := 'name';
Fields[1,1].caption := 'Предмет';
Fields[1,1].width := 350;

Fields[2,0].name := 'id';
Fields[2,0].caption := 'Ключ';
Fields[2,0].width := 60;

Fields[2,1].name := 'name';
Fields[2,1].caption := 'Группа';
Fields[2,1].width := 100;

Fields[3,0].name := 'group_id';
Fields[3,0].caption := 'Ключ группы';
Fields[3,0].width := 130;

Fields[3,1].name := 'course_id';
Fields[3,1].caption := 'Ключ предмета';
Fields[3,1].width := 130;

Fields[4,0].name := 'pair_id';
Fields[4,0].caption := 'Ключ пары';
Fields[4,0].width := 120;

Fields[4,1].name := 'weekday_id';
Fields[4,1].caption := 'Ключ дня недели';
Fields[4,1].width := 150;

Fields[4,2].name := 'group_id';
Fields[4,2].caption := 'Ключ группы';
Fields[4,2].width := 130;

Fields[4,3].name := 'course_id';
Fields[4,3].caption := 'Ключ предмета';
Fields[4,3].width := 130;

Fields[4,4].name := 'class_id';
Fields[4,4].caption := 'Ключ аудитории';
Fields[4,4].width := 150;

Fields[4,5].name := 'teacher_id';
Fields[4,5].caption := 'Ключ преподавателя';
Fields[4,5].width := 190;

Fields[5,0].name := 'id';
Fields[5,0].caption := 'Ключ';
Fields[5,0].width := 60;

Fields[5,1].name := 'period';
Fields[5,1].caption := 'Период';
Fields[5,1].width := 100;

Fields[6,0].name := 'id';
Fields[6,0].caption := 'Ключ';
Fields[6,0].width := 60;

Fields[6,1].name := 'name';
Fields[6,1].caption := 'Преподаватель';
Fields[6,1].width := 240;

Fields[7,0].name := 'teacher_id';
Fields[7,0].caption := 'Ключ преподавателя';
Fields[7,0].width := 200;

Fields[7,1].name := 'course_id';
Fields[7,1].caption := 'Ключ предмета';
Fields[7,1].width := 150;

Fields[8,0].name := 'id';
Fields[8,0].caption := 'Ключ';
Fields[8,0].width := 60;

Fields[8,1].name := 'weekday';
Fields[8,1].caption := 'День недели';
Fields[8,1].width := 150;

end;

end.
