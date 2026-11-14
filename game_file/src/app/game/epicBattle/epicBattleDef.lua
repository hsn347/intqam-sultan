local _ENV, epicBattleDef
epicBattleDef.gateData = require("app." .. LocalTblPath .. ".config_client.epicBattleGateInfoData")
epicBattleDef.pathInfo, _ENV, epicBattleDef.gateInfo, _ENV, epicBattleDef.pathData = require("app." .. LocalTblPath .. ".config_client.epicBattlePathInfoData"), require("app." .. LocalTblPath .. ".config_client.epicBattlePathInfoData"), require("app." .. LocalTblPath .. ".config_client.epicBattlePathInfoData"), require("app." .. LocalTblPath .. ".config_client.epicBattlePathInfoData"), require("app." .. LocalTblPath .. ".config_client.epicBattlePathInfoData")
epicBattleDef.gateOffset = cc.p(10, 25)
epicBattleDef.pathOffset = cc.p(10, 15)
_ENV, _ENV, epicBattleDef.init = 10, function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end, function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end
;(10).leftX = -130
;(10).rightX = -360
;(10).topY = -200
;(10).bottomY = -100
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[1], (10).cPos = 10, 10, cc.p(-350, -200)
;(10).leftX = -740
;(10).rightX = -900
;(10).topY = -550
;(10).bottomY = -400
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[2], (10).cPos = 10, 10, cc.p(-700, -500)
;(10).leftX = 0
;(10).rightX = -250
;(10).topY = -800
;(10).bottomY = -700
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[3], (10).cPos = 10, 10, cc.p(-250, -720)
;(10).leftX = -650
;(10).rightX = -900
;(10).topY = -1150
;(10).bottomY = -1050
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[4], (10).cPos = 10, 10, cc.p(-600, -1050)
;(10).leftX = -80
;(10).rightX = -380
;(10).topY = -1600
;(10).bottomY = -1500
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[5], (10).cPos = 10, 10, cc.p(-440, -1500)
;(10).leftX = -600
;(10).rightX = -900
;(10).topY = -1750
;(10).bottomY = -1650
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[6], (10).cPos = 10, 10, cc.p(-550, -1650)
;(10).leftX = 0
;(10).rightX = -230
;(10).topY = -2250
;(10).bottomY = -2150
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[7], (10).cPos = 10, 10, cc.p(-230, -2150)
;(10).leftX = -600
;(10).rightX = -900
;(10).topY = -2430
;(10).bottomY = -2330
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[8], (10).cPos = 10, 10, cc.p(-600, -2330)
;(10).leftX = 0
;(10).rightX = -550
;(10).topY = -2900
;(10).bottomY = -2800
_ENV, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[9], (10).cPos = 10, 10, cc.p(-700, -2800)
;(10).leftX = -550
;(10).rightX = -950
;(10).topY = -3100
;(10).bottomY = -3000
epicBattleDef.chapterOffsetDef, (function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end)[10], (10).cPos = function()
	for k, v in ipairs(epicBattleDef.gateData) do
		if not epicBattleDef.gateInfo[v.chapter] then
			epicBattleDef.gateInfo[v.chapter], _ENV = nil, nil
		end
		v.pos.x = v.pos.x + epicBattleDef.gateOffset.x
		v.pos.y = v.pos.y + epicBattleDef.gateOffset.y
		table.insert(epicBattleDef.gateInfo[v.chapter], v)
	end
	for k, v in ipairs(epicBattleDef.pathData) do
		if not epicBattleDef.pathInfo[v.chapter] then
			epicBattleDef.pathInfo[v.chapter], _ENV = v, v
		end
		v.pos.x = v.pos.x + epicBattleDef.pathOffset.x
		v.pos.y = v.pos.y + epicBattleDef.pathOffset.y
		table.insert(epicBattleDef.pathInfo[v.chapter], v)
	end
end, 10, cc.p(-550, -3000)
function epicBattleDef.getChapterOffset(chapter)
	return epicBattleDef.chapterOffsetDef[chapter]
end
function epicBattleDef.getChapterCenterOffset(chapter)
	return epicBattleDef.chapterOffsetDef[chapter].cPos
end
function epicBattleDef.getGateInfo(chapter)
	return epicBattleDef.gateInfo[chapter]
end
_ENV, epicBattleDef.getPathInfo = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).home = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ground = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).forest = 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).mountain = 4
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).box = 5
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).item = 6
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).boss = 7
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).king = 8
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).buff = 9
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).trap = 10
_ENV, epicBattleDef.epicAreaDef, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).cure = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 11
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).normal = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).shader = 2
_ENV, epicBattleDef.epicForestStatusDef, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).lock = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).unfind = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).nokill = 2
_ENV, epicBattleDef.epicBossStatusDef, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).killed = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).orange = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).green = 2
_ENV, epicBattleDef.epicFlyColor, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).black = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).NONE = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BLANK = 1
_ENV, epicBattleDef.gBoardTerrainEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).MOUNTAIN = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).NONE = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).RANDOM_ITEMS = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BATTLE = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SELECT_BUFF = 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).REMOVE_RANDOM_TROOP = 4
_ENV, epicBattleDef.gBoardEventEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CURE = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 5
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).NONE = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).HOME = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).TREASURE_CHEST = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ITEMS = 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).MONSTER = 4
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BOSS = 5
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BUFF = 6
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).TRAP = 7
_ENV, epicBattleDef.gEpicWarBoardPointTypeEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CURE = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 8
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).NONE = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ACTIVE = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).COMPLETE = 2
_ENV, epicBattleDef.gEpicWarBoardGameStatusEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).GAME_OVER = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).OPEN_TREASURE_CHEST = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).GET_ITEMS = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).KILL_MONSTER = 3
_ENV, epicBattleDef.gEpicWarLogEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).KILL_BOSS = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 4
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).path = 6000001
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).gate = 6000002
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).headBg = 6000003
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).head = 6000004
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).text = 6000005
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).other = 6000006
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).black = 6000007
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).progressbg = 6000008
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).progress = 6000009
_ENV, epicBattleDef.groupDef, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).progersstext = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 6000010
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).HOME = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BOSS = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).MONSTER = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).TREASURE_CHEST = 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ITEMS = 4
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).STRATEGY = 5
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BLESSING = 6
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CURE = 7
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SHOP = 8
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BARTIZAN = 9
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).MITHRIL_PILE = 10
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).MOUNTAIN = 11
_ENV, epicBattleDef.gEpicWarBoardPointTypeEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SPACE = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 12
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).NONE = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).LOCK = 1
_ENV, epicBattleDef.gBoardPointStatusEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).UNLOCK = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).NONE = 0
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ACTIVE = 1
_ENV, epicBattleDef.gBoardEventStatusEnum, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).COMPLETE = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BOSS_ARMY_REDUCE = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).DAMAGE_REDUCE = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CURY_ARMY = 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SHOW_MONSTER = 4
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SHOW_BOSS = 5
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CHANGE_BOSS_POS = 6
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).RELEX_GUARD = 7
_ENV, epicBattleDef.gTacticsEffectType, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).DESTROY_BARTIZAN = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 8
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).INFANTRY_ATTACK_BOOST = 1
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).INFANTRY_DEFENSE_BOOST = 2
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).INFANTRY_HP_BOOST = 3
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CAVALRY_ATTACK_BOOST = 4
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CAVALRY_DEFENSE_BOOST = 5
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).CAVALRY_HP_BOOST = 6
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ARCHER_ATTACK_BOOST = 7
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ARCHER_DEFENSE_BOOST = 8
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ARCHER_HP_BOOST = 9
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SIEGE_VEHICLES_ATTACK_BOOST = 10
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SIEGE_VEHICLES_DEFENSE_BOOST = 11
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).SIEGE_VEHICLES_HP_BOOST = 12
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).KILL_BOSS_TROOP_ATTACK_BOOST = 13
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).KILL_BOSS_TROOP_DEFENSE_BOOST = 14
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).KILL_BOSS_TROOP_HP_BOOST = 15
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ARMY_NUM_BOOST = 16
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).TROOP_ATTACK_BOOST = 17
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).TROOP_DEFENSE_BOOST = 18
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).TROOP_HP_BOOST = 19
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).ARMY_NUM_RECOVER = 20
;(function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).EXPLORE_ARMY_NUM_RECOVER = 21
epicBattleDef.gBlessEffctType, (function(chapter)
	return epicBattleDef.pathInfo[chapter]
end).BOSS_ARMY_REDUCE = function(chapter)
	return epicBattleDef.pathInfo[chapter]
end, 22
epicBattleDef.STRATEGYMODE = 0
epicBattleDef.STRATEGYIDX = nil
function epicBattleDef.isNeedPos(effectType)
	_UPVALUE5_ = nil
	;(nil)[1] = epicBattleDef.gTacticsEffectType.BOSS_ARMY_REDUCE
	;(nil)[2] = epicBattleDef.gTacticsEffectType.DAMAGE_REDUCE
	;(nil)[3] = epicBattleDef.gTacticsEffectType.CHANGE_BOSS_POS
	;(nil)[4] = epicBattleDef.gTacticsEffectType.RELEX_GUARD
	local (nil)[5], needPosType = epicBattleDef.gTacticsEffectType.DESTROY_BARTIZAN, nil
	return SoraDisInList(effectType, needPosType), effectType == epicBattleDef.gTacticsEffectType.DESTROY_BARTIZAN
end
function epicBattleDef.getDir(bPos, tPos)
	local dir = 0
	local _dx = tPos.x - bPos.x
	local _dy = tPos.y - bPos.y
	if _dx < 0 then
		dir = epicBattleDef.epicPlayerDirDef.en
	elseif 0 < _dx then
		dir = epicBattleDef.epicPlayerDirDef.ws
	end
	if _dy < 0 then
		dir = epicBattleDef.epicPlayerDirDef.wn
	elseif 0 < _dy then
		dir = epicBattleDef.epicPlayerDirDef.es
	end
	return dir
end
function epicBattleDef.getAreaIndex(pos)
	return (pos.x - 1) * 5 + pos.y
end
function epicBattleDef.isNeighborPos(posA, posB)
	return math.abs(posA.x - posB.x) + math.abs(posA.y - posB.y) == 1
end
function epicBattleDef.getAreaInfoByPos(areaData, pos)
	local _ENV, areaInfo
	for k, v in ipairs(areaData) do
		if SoraDIsEqualPoints(v.pos, pos) then
			areaInfo = v
			break
		end
	end
	return areaInfo
end
function epicBattleDef.isAreaGround(pos, areaData, targetPos)
	local ret = false
	local areaInfo = epicBattleDef.getAreaInfoByPos(areaData, pos)
	if areaInfo.areaType == epicBattleDef.epicAreaDef.home or areaInfo.areaType == epicBattleDef.epicAreaDef.ground then
		ret = true
	end
	local targetAreaInfo = epicBattleDef.getAreaInfoByPos(areaData, targetPos)
	if SoraDIsEqualPoints(targetPos, pos) and (targetAreaInfo.areaType == epicBattleDef.epicAreaDef.home or targetAreaInfo.areaType == epicBattleDef.epicAreaDef.ground or targetAreaInfo.areaType == epicBattleDef.epicAreaDef.item or targetAreaInfo.areaType == epicBattleDef.epicAreaDef.box or targetAreaInfo.areaType == epicBattleDef.epicAreaDef.boss or targetAreaInfo.areaType == epicBattleDef.epicAreaDef.king) then
		ret = true
	end
	return ret
end
function epicBattleDef.getGValue(pos1, pos2)
	return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end
function epicBattleDef.isPosInList(pos, array)
	local ret = false
	for k, v in ipairs(array) do
		if pos.x == v.x and pos.y == v.y then
			ret = true
			break
		end
	end
	return ret
end
function epicBattleDef.getPassPosArray(pos, targetPos, areaData)
	local _ENV, _ENV, array
	;(nil).x = pos.x
	local _ENV, (nil).y, posUp = pos.y - 1, pos.y - 1, nil
	;(pos.y - 1).x = pos.x
	local _ENV, (pos.y - 1).y, posDown = pos.y + 1, pos.y + 1, pos.y - 1
	;(pos.y + 1).x = pos.x - 1
	local _ENV, (pos.y + 1).y, posLeft = pos.y, pos.y, pos.y + 1
	pos.y.x = pos.x + 1
	local pos.y.y, posRight = pos.y, pos.y
	if posUp.y <= AREA_BORDER_LEN and epicBattleDef.isAreaGround(posUp, areaData, targetPos) then
		posUp.g = epicBattleDef.getGValue(targetPos, posUp)
		table.insert(array, posUp)
	end
	if posDown.y > 0 and epicBattleDef.isAreaGround(posDown, areaData, targetPos) then
		posDown.g = epicBattleDef.getGValue(targetPos, posDown)
		table.insert(array, posDown)
	end
	if posLeft.x > 0 and epicBattleDef.isAreaGround(posLeft, areaData, targetPos) then
		posLeft.g = epicBattleDef.getGValue(targetPos, posLeft)
		table.insert(array, posLeft)
	end
	if posRight.x <= AREA_BORDER_LEN and epicBattleDef.isAreaGround(posRight, areaData, targetPos) then
		posRight.g = epicBattleDef.getGValue(targetPos, posRight)
		table.insert(array, posRight)
	end
	return array
end
function epicBattleDef.getMinG(array)
	table.sort(array, function(a, b)
		if a and b then
			return a.g < b.g
		end
	end)
	local index, pos = next(array)
	return pos
end
function epicBattleDef.updateOpenArray(pos, targetPos, areaData)
	local epicBattleDef, openArray
	local neighborArray = epicBattleDef.getPassPosArray(pos, targetPos, areaData)
	for k, v in ipairs(neighborArray) do
		table.insert(openArray, v)
	end
	return openArray
end
function epicBattleDef.removePoint(pos, array)
	for k, v in pairs(array) do
		if v.x == pos.x and v.y == pos.y then
			array[k] = nil
			break
		end
	end
	return array
end
function epicBattleDef.getAutoPath(beginPos, targetPos, areaData)
	local _ENV, openArray
	local runPath, _ENV, _ENV, closeArray
	beginPos.g = epicBattleDef.getGValue(targetPos, beginPos)
	table.insert(openArray, beginPos)
	while next(openArray) do
		local minPos = epicBattleDef.getMinG(openArray)
		if not minPos then
			break
		end
		table.insert(closeArray, minPos)
		openArray = epicBattleDef.removePoint(minPos, openArray)
		if not epicBattleDef.isPosInList(targetPos, closeArray) then
			local childArray = epicBattleDef.getPassPosArray(minPos, targetPos, areaData)
			for k, v in ipairs(childArray) do
				if not epicBattleDef.isPosInList(v, closeArray) then
					if not epicBattleDef.isPosInList(v, openArray) then
						v.parent = minPos
						table.insert(openArray, v)
					else
						local _minPos = epicBattleDef.getMinG(openArray)
						if v.g < _minPos.g then
							v.parent = minPos
							openArray = epicBattleDef.updateOpenArray(v, targetPos, areaData)
						end
					end
				end
			end
		else
			break
		end
	end
	table.sort(closeArray, function(a, b)
		return a.g < b.g
	end)
	local function getPath(data)
		_ENV = nil
		;(nil).x = data.x
		;(nil).y = data.y
		table.insert(runPath, 1, nil)
		if data.parent then
			getPath(data.parent)
		end
	end
	getPath(closeArray[1])
	return runPath
end
epicBattleDef.init()
return epicBattleDef
