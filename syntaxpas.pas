unit syntaxpas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

var
  KeyWords: array of string;

implementation

begin
  setlength(KeyWords, 10);
  KeyWords[0] := 'select';
  KeyWords[1] := 'from';
  KeyWords[2] := 'where';
  KeyWords[3] := 'inner';
  KeyWords[4] := 'join';
  KeyWords[5] := 'on';
  KeyWords[6] := 'group';
  KeyWords[7] := 'by';
  KeyWords[8] := 'order';
  KeyWords[9] := 'desc';
end.

