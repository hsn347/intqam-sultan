local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_GamePanel = class("Activity_9001738_GamePanel", baseFguiPanel)
local EFFECT_LOCK_TIME = 0.6
local CARD_EFFECT_STAGE_TIMEOUT = 1.2
local CARD_EFFECT_STAGE_TIMEOUT_BUFFER = 0.15
local REQUEST_UNLOCK_TIME = 5
local COUNTDOWN_SECONDS = 3
local CARD_ENTER_EFFECT_INTERVAL = 0.05
local ITEM_TYPE_CROSS_BOMB = 1
local ITEM_TYPE_X_BOMB = 2
local ITEM_TYPE_LOCK = 3
local ITEM_TYPE_FATE = 4
local EXIT_CONFIRM_SKIP_CFG_KEY = "Game:activity_9001738:exitConfirmSkipTime~integer"
_ENV = nil
;(nil)[ITEM_TYPE_CROSS_BOMB] = true
;(nil)[ITEM_TYPE_X_BOMB] = true
local _ENV, (nil)[ITEM_TYPE_LOCK], FLIP_AFTER_USE_ITEM_TYPES = nil, true, nil
;(nil)[ITEM_TYPE_CROSS_BOMB] = "十字炸弹牌"
;(nil)[ITEM_TYPE_X_BOMB] = "X型炸弹牌"
;(nil)[ITEM_TYPE_LOCK] = "锁定牌"
local (nil)[ITEM_TYPE_FATE], ITEM_TYPE_NAME = "命运牌", nil
local getEffectStack = function(level)
	if debug and debug.traceback then
		return debug.traceback("[Activity_9001738][EffectStack]", level or 2)
	end
	return ""
end
local formatPrintArgs = function(...)
	local count = select("#", ...)
	if count <= 0 then
		return ""
	end
	local _ENV, args = "", ""
	for i = 1, count do
		args[i] = tostring(select(i, ...))
	end
	return table.concat(args, "\t")
end
local formatBoolText = function(value)
	return value and "是" or "否"
end
local formatServerMismatchReason = function(reason)
	if reason == "costTime empty" then
		return "服务端未返回通关耗时(costTime为空)，触发牌面状态校正校验"
	end
	return tostring(reason)
end
local cloneCardData = function(cardData)
