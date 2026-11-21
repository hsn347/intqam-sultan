# -*- coding: utf-8 -*-
import asyncio
import websockets
import json
import sys

async def get_logs():
    uri = 'ws://127.0.0.1:8080/ws/logs/sultan_beetoo3'
    with open("docs/live_cycle_log.txt", "w", encoding="utf-8") as out:
        try:
            async with websockets.connect(uri, ping_timeout=15) as ws:
                count = 0
                while True:
                    try:
                        msg = await asyncio.wait_for(ws.recv(), timeout=3.0)
                    except asyncio.TimeoutError:
                        break
                    try:
                        data = json.loads(msg)
                        line = data.get("message", msg)
                    except Exception:
                        line = msg
                    out.write(line + "\n")
                    count += 1
                    if count >= 3000:
                        break
        except Exception as e:
            out.write(f"\n[fetch_ws_logs] Error: {e}\n")

if __name__ == "__main__":
    asyncio.run(get_logs())
