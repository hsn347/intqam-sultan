import re

def check():
    with open('game_file/src/app/localtb/config_server/vipbuff.lua', 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    import re
    pos = 0
    while True:
        pos = text.find('7219', pos)
        if pos == -1:
            break
        print('--- 7219 match ---')
        print(text[max(0, pos-100):min(len(text), pos+200)])
        pos += 4

if __name__ == '__main__':
    check()
