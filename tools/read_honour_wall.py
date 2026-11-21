with open(r"E:\intqam-sultan\game_file\src\fgui\views\newLordView\honourWallViewPanel.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for line in text.splitlines()[:60]:
    print(line)
