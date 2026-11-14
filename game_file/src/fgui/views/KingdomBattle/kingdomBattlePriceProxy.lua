local conquestWarltCtrl = include("conquestWarltCtrl")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local resDesRead = include("resDesRead")
local baseProxy = require("fgui.base.baseProxy")
local kingdomBattlePriceProxy = class("kingdomBattlePriceProxy", baseProxy)
function kingdomBattlePriceProxy:onRegisterEvent()
	print("=======kingdomBattlePriceProxy:onRegisterEvent")
end
local getTypeByKingdomLv = function(lv)
	return lv and 50 <= lv and 2 or 1
end
function kingdomBattlePriceProxy:getScoreInfoList(...)
	local _normalColor = cc.c3b(220, 145, 90)
	local _greenColor = cc.c3b(0, 255, 0)
	local _ENV, infoList = 0, 0
	local cLevel = SoraDGetCastleLv()
	if cLevel > CASTLE_LV15_LIMITED then
		local tbl = conquestWarltCtrl.getConquestWarScoreConf(gConquestWarScoreEventTp.OCCUPY_PALACE)
		for _, v in ipairs(tbl) do
			_ENV = nil
			;(nil).left = v.score
			_ENV = nil
			;(nil).num = v.condition / 60
			;(nil).right = i18n("conquestwar_text_01", nil)
			;(nil).king = v.kingScore
			;(nil).pColor = _greenColor
			;(nil).kColor = _normalColor
			table.insert(infoList, nil)
		end
		local tbl = conquestWarltCtrl.getConquestWarScoreConf(gConquestWarScoreEventTp.HELP_PALACE)
		for _, v in ipairs(tbl) do
			_ENV = v.kingScore
			v.kingScore.left = v.score
			_ENV = v.condition / 60
			;(v.condition / 60).num = v.condition / 60
			v.kingScore.right = i18n("conquestwar_text_02", v.condition / 60)
			v.kingScore.king = v.kingScore
			v.kingScore.pColor = _greenColor
			v.kingScore.kColor = _normalColor
			table.insert(infoList, v.kingScore)
		end
		local tbl = conquestWarltCtrl.getConquestWarScoreConf(gConquestWarScoreEventTp.KILL_ENEMY)
		for _, v in ipairs(tbl) do
			if 0 < v.score then
				local right
				if v.condition == 13 then
					_ENV = "conquestwar_text_02"
					;("conquestwar_text_02").count = 1000
					right = i18n("limitactivities_eventtitle_16", "conquestwar_text_02")
				elseif v.condition == 14 then
					_ENV = "conquestwar_text_02"
					;("conquestwar_text_02").count = 1000
					right = i18n("limitactivities_eventtitle_17", "conquestwar_text_02")
				else
					_ENV = "conquestwar_text_02"
					;("conquestwar_text_02").num = 1000
					;("conquestwar_text_02").lv = v.condition
					right = i18n("common_text_2197", "conquestwar_text_02")
				end
				_ENV = "conquestwar_text_02"
				;("conquestwar_text_02").left = v.score * 1000
				;("conquestwar_text_02").right = right
				;("conquestwar_text_02").king = v.kingScore * 1000
				;("conquestwar_text_02").pColor = _normalColor
				;("conquestwar_text_02").kColor = _normalColor
				table.insert(infoList, "conquestwar_text_02")
			end
		end
	end
	local tbl = conquestWarltCtrl.getConquestWarScoreConf(gConquestWarScoreEventTp.COLLECT_RESOURCE)
	for _, v in ipairs(tbl) do
		_ENV = i18n("common_text_2197", "conquestwar_text_02")
		i18n("common_text_2197", "conquestwar_text_02").left = v.score
		_ENV = "conquestwar_text_02"
		;("conquestwar_text_02").num = 1
		;("conquestwar_text_02").res = resDesRead.getName(v.condition)
		i18n("common_text_2197", "conquestwar_text_02").right = i18n("common_text_2198", "conquestwar_text_02")
		i18n("common_text_2197", "conquestwar_text_02").king = v.kingScore
		i18n("common_text_2197", "conquestwar_text_02").pColor = _normalColor
		i18n("common_text_2197", "conquestwar_text_02").kColor = _normalColor
		table.insert(infoList, (i18n("common_text_2197", "conquestwar_text_02")))
	end
	local tbl = conquestWarltCtrl.getConquestWarScoreConf(gConquestWarScoreEventTp.KILL_MONSTER)
	for _, v in ipairs(tbl) do
		_ENV = v.kingScore
		v.kingScore.left = v.score
		_ENV = resDesRead.getName(v.condition)
		resDesRead.getName(v.condition).num = 1
		v.kingScore.right = i18n("common_text_2199", (resDesRead.getName(v.condition)))
		v.kingScore.king = v.kingScore
		v.kingScore.pColor = _normalColor
		v.kingScore.kColor = _normalColor
		table.insert(infoList, v.kingScore)
	end
	return infoList
end
function kingdomBattlePriceProxy:getTotalRankPrice(...)
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local kingdomLv = getTypeByKingdomLv(kingdomLev)
	local totalRankPrice = conquestWarltCtrl.getConquestWarPersonalReward(kingdomLv, conquestWarCtrl:getMatchPool())
	return totalRankPrice
end
function kingdomBattlePriceProxy:getKingdomRankPrice()
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local kingdomLv = getTypeByKingdomLv(kingdomLev)
	return conquestWarltCtrl.getConquestWarKingdomReward(kingdomLv, conquestWarCtrl:getMatchPool())
end
return kingdomBattlePriceProxy
