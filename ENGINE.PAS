unit Engine;

interface
procedure Draw(x, y, char, attr : byte);
procedure DrawMaze;
procedure DrawPortals;

procedure SetSnakeCell(x, y, cells : byte);
procedure InitializeSnake;
procedure InitializeSnakeInMenu;
procedure DrawSnake;

function isSnackCell(x, y : byte) : boolean;
function isSnakeCell(x, y : byte) : boolean;
function isPortalCell : byte;

procedure Collision;
procedure DrawSnack;

procedure MoveSnake;
procedure MoveSnakeInMenu;

procedure DrawSnakeLength;
procedure DrawSnakeSpeed;

procedure Instructions;
procedure HighScores;
procedure Exit;
procedure Menu(var exitMenu : boolean);
procedure Level;

implementation
uses
  Crt, General;
const
  maxSnakeLength = 999;
type 
  TCell = record
    x, y : byte;
  end;
  TSnake = record
    cells : array [1..maxSnakeLength] of TCell;
    length : byte;
    direction : (right, up, left, down);
    increment : boolean;
  end;
var
  videoRAM : array [ 1..25, 1..80 ] of
    record
      symbol : char;
      attr : byte;
    end
    absolute $B800 : 0;
  snake : TSnake;
  snack : TCell;
  speed : byte;
  exitMenu, cycleLevel : boolean;
procedure Draw (x, y, char, attr : byte);
begin
  videoRAM[y,x].symbol := chr(char);
  videoRAM[y,x].attr := attr;
end;

procedure DrawMaze;
var xVideo,yVideo : byte;
begin
  textcolor(7);
  gotoxy(30,3);
  write('"F1" : pause / unpause');
  Draw(3, 4, 201, 9);
  Draw(78, 4, 187, 9);
  Draw(3, 49, 200, 9);
  Draw(78, 49, 188, 9);
  for xVideo := 4 to 77 do begin
    Draw(xVideo, 4, 205, 9);
    Draw(xVideo, 49, 205, 9);
  end;
  for yVideo := 5 to 48 do begin
    Draw(3, yVideo, 186, 9);
    Draw(78, yVideo, 186, 9);
  end;
  Draw(35, 10, 187, 9);
  Draw(13, 23, 200, 9);
  Draw(35, 23, 188, 9);
  Draw(13, 30, 201, 9);
  Draw(35, 30, 187, 9);
  Draw(35, 43, 202, 9);
  Draw(46, 10, 203, 9);
  Draw(46, 23, 200, 9);
  Draw(68, 23, 188, 9);
  Draw(46, 30, 201, 9);
  Draw(68, 30, 187, 9);
  Draw(46, 43, 200, 9);
  for xVideo := 14 to 34 do begin
    if xVideo > 22 then begin
      Draw(xVideo, 10, 205, 9);
    end;
    Draw(xVideo, 23, 205, 9);
    Draw(xVideo, 30, 205, 9);
  end;
  for yVideo := 31 to 42 do begin
    if yVideo < 39 then begin
      Draw(13, yVideo, 186, 9);
      Draw(68, yVideo, 186, 9);
    end;
    Draw(35, yVideo, 186, 9);
    Draw(46, yVideo, 186, 9);
  end;
  for xVideo := 47 to 67 do begin
    Draw(xVideo, 23, 205, 9);
    Draw(xVideo, 30, 205, 9);
    if xVideo < 60 then begin
      Draw(xVideo, 43, 205, 9);
    end;
  end;
  for yVideo := 11 to 22 do begin
    Draw(35, yVideo, 186, 9);
    Draw(46, yVideo, 186, 9);
    if yVideo > 14 then begin
      Draw(68, yVideo, 186, 9);
      Draw(13, yVideo, 186, 9);
    end;
  end;
  for xVideo := 24 to 32 do begin
    Draw(xVideo, 23, 32, 7);
  end;
  for xVideo := 49 to 57 do begin
    Draw(xVideo, 30, 32, 7);
  end;
  for yVideo := 16 to 21 do begin
    Draw(46, yVideo, 32, 7);
  end;
  for yVideo := 32 to 37 do begin
    Draw(35, yVideo, 32, 7);
  end;
  Draw(3, 40, 202, 9);
  Draw(3, 44, 203, 9);
  Draw(78, 9, 202, 9);
  Draw(78, 13, 203, 9);
  Draw(11, 4, 185, 9);
  Draw(17, 4, 204, 9);

  Draw(64, 49, 185, 9);
  Draw(70, 49, 204, 9);
  Draw(13, 14, 203, 9);
  Draw(22, 10, 204, 9);
  Draw(23, 23, 185, 9);
  Draw(33, 23, 204, 9);
  Draw(13, 39, 202, 9);
  Draw(35, 31, 202, 9);
  Draw(35, 38, 203, 9);
  Draw(46, 15, 202, 9);
  Draw(46, 22, 203, 9);
  Draw(68, 14, 203, 9);
  Draw(48, 30, 185, 9);
  Draw(58, 30, 204, 9);
  Draw(60, 43, 185, 9);
  Draw(68, 39, 202, 9);
end;

procedure DrawPortals;
var xVideo, yVideo : byte;
begin
  for yVideo := 41 to 43 do begin
    Draw(3, yVideo, 179, 11);
  end;
  for yVideo := 10 to 12 do begin
    Draw(78, yVideo, 179, 11);
  end;
  for xVideo := 12 to 16 do begin
    Draw(xVideo, 4, 196, 11);
  end;
  for xVideo := 65 to 69 do begin
    Draw(xVideo, 49, 196, 11);
  end;
end;

procedure SetSnakeCell (x, y, cells : byte);
begin
  snake.cells[cells].x := x;
  snake.cells[cells].y := y;
end;

procedure InitializeSnake;
var i : byte;
begin
  snake.length := 5;
  snake.direction := right;
  SetSnakeCell(8, 48, 1);
  SetSnakeCell(7, 48, 2);
  SetSnakeCell(6, 48, 3);
  SetSnakeCell(5, 48, 4);
  SetSnakeCell(4, 48, 5);
end;

procedure InitializeSnakeInMenu;
var i : byte;
begin
  snake.length := 20;
  snake.direction := right;
  for i := 1 to snake.length do begin
    SetSnakeCell(41 - i, 10, i);
  end;
end;

procedure DrawSnake;
var i : byte;
begin
  Draw(snake.cells[1].x, snake.cells[1].y, 219, 13);
  for i := 2 to snake.length do begin
    if IsEven(i) then
      Draw(snake.cells[i].x, snake.cells[i].y, 177, 1)
    else
      Draw(snake.cells[i].x, snake.cells[i].y, 177, 9);
  end;
end;

function isSnackCell (x,y : byte): boolean;
var i : byte;
begin
  isSnackCell := false;
  for i := 3 to 6 do begin
    if videoRAM[y,x].symbol = chr(i) then begin
      isSnackCell := true;
    end;
  end;
end;

function isMazeCell (x,y : byte): boolean;
begin
  isMazeCell := false;
  If (videoRAM[y,x].symbol = chr(186)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(205)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(187)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(188)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(200)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(201)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(202)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(203)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(204)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
  If (videoRAM[y,x].symbol = chr(185)) and (videoRAM[y,x].attr = 9 )then isMazeCell := true;
end;

function isSnakeCell (x,y : byte): boolean;
begin
   isSnakeCell := videoRAM[y,x].symbol = chr(177);
end;

function isPortalCell :byte;
type
  TCell = record
    x : byte;
    y : byte;
    z : byte;
  end;
var a : array [1..16] of TCell;
  i : byte;
  result : byte;
begin
  result := 0;
  {All the cells with portals, their locations and categories}
  a[1].x := 3;   a[1].y := 41;   a[1].z := 1;
  a[2].x := 3;   a[2].y := 42;   a[2].z := 1;
  a[3].x := 3;   a[3].y := 43;   a[3].z := 1;
  a[4].x := 78;  a[4].y := 10;   a[4].z := 3;
  a[5].x := 78;  a[5].y := 11;   a[5].z := 3;
  a[6].x := 78;  a[6].y := 12;   a[6].z := 3;
  a[7].x := 12;  a[7].y := 4;    a[7].z := 4;
  a[8].x := 13;  a[8].y := 4;    a[8].z := 4;
  a[9].x := 14;  a[9].y := 4;    a[9].z := 4;
  a[10].x := 15; a[10].y := 4;   a[10].z := 4;
  a[11].x := 16; a[11].y := 4;   a[11].z := 4;
  a[12].x := 65; a[12].y := 49;  a[12].z := 2;
  a[13].x := 66; a[13].y := 49;  a[13].z := 2;
  a[14].x := 67; a[14].y := 49;  a[14].z := 2;
  a[15].x := 68; a[15].y := 49;  a[15].z := 2;
  a[16].x := 69; a[16].y := 49;  a[16].z := 2;
  for i := 1 to 16 do begin
    if ((a[i].x = snake.cells[1].x) and (a[i].y = snake.cells[1].y)) then begin
      result := a[i].z;
    end;
  end;
  isPortalCell := result;
end;

procedure Collision;
begin
  cycleLevel := false;
  gotoxy(35, 2);
  textcolor(13);
  write('! GAME OVER !');
  sound(220);
  delay(100);
  nosound;
  repeat
    delay(100);
  until KeyPressed and (ord(ReadKeySimple) = 13);
end;

procedure DrawSnack;
begin
  randomize;
  repeat
    snack.x := random(74) + 5;
    snack.y := random(43) + 6;
  until videoRAM[snack.y, snack.x].symbol = chr(32);
    Draw(snack.x, snack.y, random(4) + 3, 13);
end;

procedure MoveSnake;
var i : byte;
    tmpCell1, tmpCell2 : TCell;
    increment : boolean;
    portal : byte;
begin
  increment := false;
  if snake.increment then begin
    DrawSnack;
    increment := snake.increment;
    snake.increment := false;
  end;
  tmpCell1 := Snake.cells[1];
  if snake.direction = right then begin
    if isMazeCell(snake.cells[1].x + 1, snake.cells[1].y) then Collision;
    if isSnakeCell(snake.cells[1].x + 1, snake.cells[1].y) then Collision;
    snake.increment := isSnackCell(snake.cells[1].x + 1, snake.cells[1].y);
    inc(Snake.cells[1].x);
  end;
  if snake.direction = up then begin
    if isMazeCell(snake.cells[1].x, snake.cells[1].y - 1) then Collision;
    if isSnakeCell(snake.cells[1].x, snake.cells[1].y - 1) then Collision;
    snake.increment := isSnackCell(snake.cells[1].x, snake.cells[1].y - 1);
    dec(Snake.cells[1].y);
  end;
  if snake.direction = left then begin
    if isMazeCell(snake.cells[1].x - 1, snake.cells[1].y) then Collision;
    if isSnakeCell(snake.cells[1].x - 1, snake.cells[1].y) then Collision;
    snake.increment := isSnackCell(snake.cells[1].x - 1, snake.cells[1].y);
    dec(Snake.cells[1].x);
  end;
  if snake.direction = down then begin
    if isMazeCell(snake.cells[1].x, snake.cells[1].y + 1) then Collision;
    if isSnakeCell(snake.cells[1].x, snake.cells[1].y + 1) then Collision;
    snake.increment := isSnackCell(snake.cells[1].x, snake.cells[1].y + 1);
    inc(Snake.cells[1].y);
  end;
  if snake.increment then begin
    sound(1760);
    delay(50);
    nosound;
    end;
  for i := 2 to snake.length do begin
    tmpCell2 := snake.cells[i];
    snake.cells[i] := tmpCell1;
    tmpCell1 := tmpCell2;
  end;

  if isPortalCell > 0 then begin
    repeat
      portal := (random(4) + 1);
    until portal <> isPortalCell;
    if portal = 1 then begin
      snake.cells[1].x := 4;
      snake.cells[1].y := 42;
      snake.direction := right;
    end;
    if portal = 2 then begin
      snake.cells[1].x := 67;
      snake.cells[1].y := 48;
      snake.direction := up;
    end;
    if portal = 3 then begin
      snake.cells[1].x := 77;
      snake.cells[1].y := 11;
      snake.direction := left;
    end;
    if portal = 4 then begin
      snake.cells[1].x := 14;
      snake.cells[1].y := 5;
      snake.direction := down;
    end;
  end;

  if increment then begin
    inc(snake.length);
    if ((snake.length mod 50 = 0) and (speed <> 20)) then begin
      inc(speed);
    end;
    snake.cells[snake.length] := tmpCell1;
  end else begin
    {Draw a non-snake cell after snake passage}
    Draw(tmpCell1.x, tmpCell1.y, 32, 7);
  end;
end;

procedure MoveSnakeInMenu;
var i : byte;
    tmpCell1, tmpCell2 : TCell;
begin
  tmpCell1 := Snake.cells[1];
  if ((snake.cells[1].x = 18) AND (snake.cells[1].y = 10)) then snake.direction := right;
  if ((snake.cells[1].x = 63) AND (snake.cells[1].y = 10)) then snake.direction := down;
  if ((snake.cells[1].x = 63) AND (snake.cells[1].y = 40)) then snake.direction := left;
  if ((snake.cells[1].x = 18) AND (snake.cells[1].y = 40)) then snake.direction := up;
  if snake.direction = right then begin
    inc(Snake.cells[1].x);
  end;
  if snake.direction = up then begin
    dec(Snake.cells[1].y);
  end;
  if snake.direction = left then begin
    dec(Snake.cells[1].x);
  end;
  if snake.direction = down then begin
    inc(Snake.cells[1].y);
  end;
  for i := 2 to snake.length do begin
    tmpCell2 := snake.cells[i];
    snake.cells[i] := tmpCell1;
    tmpCell1 := tmpCell2;
  end;
  {Draw a non-snake cell after snake passage}
  Draw(tmpCell1.x, tmpCell1.y, 32, 7);
end;

procedure DrawSnakeLength;
begin
  textcolor(13);
  gotoxy(4, 2);
  write('Length: ', snake.length, '/999');
end;

procedure DrawSnakeSpeed;
begin
  textcolor(13);
  gotoxy(68, 2);
  write('Speed: ', speed : 2);
end;

procedure Instructions;
var i : byte;
  xVideo, yVideo : byte;
begin
  InitializeScreen;
  HideCursor;
  textcolor(11);
  gotoxy(59, 50);
  write('(c)2009, Jakub Kudela');
  InitializeSnakeInMenu;
  Draw(20, 12, 201, 9);
  Draw(61, 12, 187, 9);
  Draw(20, 38, 200, 9);
  Draw(61, 38, 188, 9);
  for xVideo := 21 to 60 do begin
    Draw(xVideo, 12, 205, 9);
    Draw(xVideo, 38, 205, 9);
  end;
  for yVideo := 13 to 37 do begin
    Draw(20, yVideo, 186, 9);
    Draw(61, yVideo, 186, 9);
  end;
  gotoxy(30, 42);
  textcolor(7);
  write('press "Enter" to return');
  textcolor(11);
  for xVideo := 28 to 53 do begin
    Draw(xVideo, 6, 205, 11);
    Draw(xVideo, 8, 205, 11);
  end;
  Draw(27, 6, 201, 11);
  Draw(54, 6, 187, 11);
  Draw(27, 8, 200, 11);
  Draw(54, 8, 188, 11);
  Draw(27, 7, 186, 11);
  Draw(54, 7, 186, 11);
  gotoxy(29, 7);
  write('I N S T R U C T I O N S :');
  gotoxy(24, 14);
  textcolor(7);
  write('Use ', char(24), ',', char(25), ',',char(26), ',',char(27), ' to navigate your Snake.');
  gotoxy(23, 17);
  write('Press "F1" to pause/unpause the game.');
  gotoxy(27, 20);
  write(' , , ,   ->  Snack for Snake.');
  Draw(27, 20, 3, 13);
  Draw(29, 20, 4, 13);
  Draw(31, 20, 5, 13);
  Draw(33, 20, 6, 13);
  gotoxy(24, 22);
  write('Collect it to lenghten your Snake.');
  Draw(24, 25, 204, 9);
  Draw(25, 25, 205, 9);
  Draw(26, 25, 205, 9);
  Draw(27, 25, 205, 9);
  Draw(28, 25, 185, 9);
  gotoxy(31, 25);
  write('-> Walls. Try to avoid them.');
  Draw(24, 28, 185, 9);
  Draw(28, 28, 204, 9);
  Draw(25, 28, 196, 11);
  Draw(26, 28, 196, 11);
  Draw(27, 28, 196, 11);
  gotoxy(31,28);
  write('-> Portals. Use them to get ');
  gotoxy(25, 30);
  write('from one randomly to another one.');
  gotoxy(25, 32);
  write('Hint: Try to avoid entering the ');
  gotoxy(25, 34);
  write('portal in the middle. Soon you''ll');
  gotoxy(35, 36);
  write('discover why.');
  repeat
    delay(100);
    MoveSnakeInMenu;
    DrawSnake;
  until KeyPressed and (ord(ReadKeySimple) = 13);
end;

procedure HighScores;
type 
  TScore = record
    id : string[5];
    points : word;
  end;
  TScoreFile = file of TScore;
var i : byte;
    xVideo, yVideo, place : byte;
    winner : TScore;
    score : word;
    winnerId : string[5];
    chart : array [0..10] of TScore;
    scoreFile : TScoreFile;
begin
  chart[0].points := 999;
  assign(scoreFile, 'HS.SNK');
  reset(scoreFile);
  for i := 1 to 10 do begin
    read(scoreFile,chart[i]);
  end;
  winner.points := snake.length;
  InitializeScreen;
  HideCursor;
  textcolor(11);
  gotoxy(59, 50);
  write('(c)2009, Jakub Kudela');
  InitializeSnakeInMenu;
  Draw(20, 12, 201, 9);
  Draw(61, 12, 187, 9);
  Draw(20, 38, 200, 9);
  Draw(61, 38, 188, 9);
  for xVideo := 21 to 60 do begin
    Draw(xVideo, 12, 205, 9);
    Draw(xVideo, 38, 205, 9);
  end;
  for yVideo := 13 to 37 do begin
    Draw(20, yVideo, 186, 9);
    Draw(61, yVideo, 186, 9);
  end;
  textcolor(11);
  for xVideo := 28 to 53 do begin
    Draw(xVideo, 6, 205, 11);
    Draw(xVideo, 8, 205, 11);
  end;
  Draw(27, 6, 201, 11);
  Draw(54, 6, 187, 11);
  Draw(27, 8, 200, 11);
  Draw(54, 8, 188, 11);
  Draw(27, 7, 186, 11);
  Draw(54, 7, 186, 11);
  gotoxy(29, 7);
  write(' H I G H  S C O R E S  :');
  gotoxy(35, 14);
  textcolor(7);
  for i := 1 to 10 do begin
    gotoxy(35, i * 2 + 14);
    if i < 10 then begin
      writeln('0', i, '. ', Chart[i].id : 5, ' ', Chart[i].points : 3);
    end else begin
      writeln(i:2,'. ',Chart[i].id : 5, ' ', Chart[i].points : 3);
      end;
  end;
  if winner.points <= chart[10].points then begin
    gotoxy(30, 42);
    textcolor(7);
    write('press "Enter" to return');
    repeat
      delay(100);
      MoveSnakeInMenu;
      DrawSnake;
    until KeyPressed and (ord(ReadKeySimple) = 13);
  end else begin
    place := 11;
    while (winner.points > chart[place - 1].points) do begin
      dec(place);
    end;
    gotoxy(13, 44);
    textcolor(7);
    write('Congrats, you''ve made it to the top chart with ');
    textcolor(13);
    write(winner.points);
    textcolor(7);
    write(' points!');
    gotoxy(27, 45);
    write('You''ve ended on ');
    textcolor(13);
    write(place);
    textcolor(7);
    write('. place!');
    gotoxy(19, 46);
    write('Enter your name (It takes only firts 5 spaces).');
    gotoxy(38, 42);
    ShowCursor;
    readln(winner.id);
    rewrite(scoreFile);
    for i := 1 to 10 do begin
      if i > place then begin
        write(scoreFile,chart[i - 1]);
      end;
      if i = place then begin
        write(scoreFile,winner);
      end;
      if i < place then begin
        write(scoreFile,chart[i]);
      end;
    end;
  end;
  close(scoreFile);
end;

procedure Exit;
begin
  ClrScr;
  HideCursor;
  textcolor(11);
  gotoxy(32, 22);
  write('... Exiting ...');
  gotoxy(28, 25);
  write('thanks for playing SNAKE');
  gotoxy(29, 27);
  write('(c) 2009, Jakub Kudela');
  delay(3000);
  halt;
end;

procedure Menu (var exitMenu : boolean);
var xVideo, yVideo, option : byte;
  menuInput : char;
begin
  option := 1;
  InitializeScreen;
  HideCursor;
  textcolor(11);
  gotoxy(59, 50);
  write('(c)2009, Jakub Kudela');
  gotoxy(35, 16);
  write('= NEW GAME =');
  gotoxy(33, 22);
  write('= HIGH  SCORES =');
  gotoxy(33, 28);
  write('= INSTRUCTIONS =');
  gotoxy(37, 34);
  write('= EXIT =');
  InitializeSnakeInMenu;
  Draw(20, 12, 201, 9);
  Draw(61, 12, 187, 9);
  Draw(20, 38, 200, 9);
  Draw(61, 38, 188, 9);

  gotoxy(33, 7);
  write('S = N = A = K = E');
  gotoxy(28, 42);
  textcolor(7);
  write('use arrows for navigation  ');
  gotoxy(29, 43);
  write('press "Enter" to choose');
  textcolor(11);

  for xVideo := 28 to 53 do begin
    Draw(xVideo, 6, 205, 11);
    Draw(xVideo, 8, 205, 11);
  end;
  Draw(27, 6, 201, 11);
  Draw(54, 6, 187, 11);
  Draw(27, 8, 200, 11);
  Draw(54, 8, 188, 11);
  Draw(27, 7, 186, 11);
  Draw(54, 7, 186, 11);

  for xVideo := 21 to 60 do begin
    Draw(xVideo, 12, 205, 9);
    Draw(xVideo, 38, 205, 9);
  end;
  for yVideo := 13 to 37 do begin
    Draw(20, yVideo, 186, 9);
    Draw(61, yVideo, 186, 9);
  end;
  repeat
    delay(100);
    if KeyPressed then begin
      menuInput := ReadKeySimple;
      case ord(menuInput) of
        72 : if option <> 1 then dec(option);
        80 : if option <> 4 then inc(option);
      end;
    end;
    MoveSnakeInMenu;
    DrawSnake;
    delay(100);
    for xVideo := 23 to 58 do begin
      Draw(xVideo, 13, 32, 7);
      Draw(xVideo, 19, 32, 7);
      Draw(xVideo, 25, 32, 7);
      Draw(xVideo, 31, 32, 7);
      Draw(xVideo, 37, 32, 7);
    end;
    for yVideo := 13 to 37 do begin
      Draw(22, yVideo, 32, 7);
      Draw(59, yVideo, 32, 7);
    end;
    Draw(22, 6 * option + 7, 218, 13);
    Draw(59, 6 * option + 7, 191, 13);
    Draw(22, 6 * option + 13, 192, 13);
    Draw(59, 6 * option + 13, 217, 13);
    for xVideo := 23 to 58 do begin
      Draw(xVideo, 6 * option + 7, 196, 13);
      Draw(xVideo, 6 * option + 13, 196, 13);
    end;
    for yVideo := 6 * option + 8 to 6 * option + 12 do begin
      Draw(22, yVideo, 179, 13);
      Draw(59, yVideo, 179, 13);
    end;
  until (ord(menuInput) = 13);

  if option = 2 then begin
    exitMenu := false;
    snake.length := 0;
    HighScores;
  end;
  if option = 3 then begin
    exitMenu := false;
    Instructions;
  end;
  if option = 4 then Exit;
end;

procedure Level;
var xVideo : byte;
begin
  cycleLevel := true;
  speed := 1;
  InitializeScreen;
  DrawMaze;
  DrawPortals;
  InitializeSnake;
  DrawSnake;
  HideCursor;
  textcolor(7);
  gotoxy(30, 26);
  write('to start press "Enter"');
  gotoxy(30, 27);
  write('use arrows to navigate');

  DrawSnack;
  DrawSnakeLength;
  DrawSnakeSpeed;
  repeat
    delay(100);
  until KeyPressed and (ord(ReadKeySimple) = 13);
  for xVideo := 30 to 51 do begin
    Draw(xVideo, 26, 32, 7);
    Draw(xVideo, 27, 32, 7);
  end;
  repeat
    DrawSnakeLength;
    DrawSnakeSpeed;
    DrawPortals;
    delay(200 - 7 * speed);
    if KeyPressed then begin
      case ReadKeySpecial of
        77 : if (Snake.direction = up) OR (Snake.direction = down) then Snake.direction := right;
        72 : if (Snake.direction = right) OR (Snake.direction = left) then Snake.direction := up;
        75 : if (Snake.direction = up) OR (Snake.direction = down) then Snake.direction := left;
        80 : if (Snake.direction = right) OR (Snake.direction = left) then Snake.direction := down;
        59 : repeat
               delay(100);
               until KeyPressed and (ord(ReadKeySpecial) = 59);
      end;
    end;
    MoveSnake;
    DrawSnake;
  until (snake.length = maxSnakeLength) or (cycleLevel = false);
  DrawSnakeLength;
  DrawSnakeSpeed;

  if snake.length = maxSnakeLength then begin
    gotoxy(32,2);
    write('! MAXIMAL VICTORY !');
  end;
end;

begin
end.
