program Snake;

uses
  General, Engine;

var exitMenu : boolean;

begin
  while true do begin
    repeat
      exitMenu := true;
      Menu(exitMenu);
    until exitMenu;
    Level;
    HighScores;
  end;
end.
