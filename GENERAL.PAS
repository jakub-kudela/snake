unit General;

interface
procedure HideCursor;
procedure ShowCursor;
procedure InitializeScreen;

function ReadKeySpecial : byte;
function ReadKeyASCII : byte;
function ReadKeySimple : char;

function IsEven(i : longint) : boolean;

implementation
uses crt;
var cursor : word;

procedure HideCursor;
var s : word;
begin
  asm
    mov AH, 03h;
    mov BH, 00h;
    int 10h;
    mov S, CX;
    mov AH, 01h;
    mov BH, 00h;
    mov CX, 2000h;
    int 10h;
  end;
  cursor := s;
end;

procedure ShowCursor;
var s : word;
begin
  s := cursor;
  asm
    mov ah, 01h;
    mov bh, 00h;
    mov cx, s;
    int 10h;
  end;
end;

procedure InitializeScreen;
begin
  ClrScr;
  TextMode(C80 + Font8x8);
  Window(1, 1, 50, 80);
end;

function ReadKeySpecial : byte;
var x : char;
begin
    x := ReadKey;
    if x = #0 then begin
      x := ReadKey;
      ReadKeySpecial := ord(x);
  end;
end;

function ReadKeyASCII : byte;
var x : char;
begin
  x := ReadKey;
  if x <> #0 then begin
    ReadKeyASCII := ord(x);
    if x = #27 then halt;
  end;
end;

function ReadKeySimple: char;
var x : char;
begin
  x := ReadKey;
  if x = #0 then begin
    x :=ReadKey;
  end;
  ReadKeySimple := x;
end;

function IsEven (i : longint): boolean;
begin
  IsEven := (i mod 2) = 0;
end;

begin
end.
