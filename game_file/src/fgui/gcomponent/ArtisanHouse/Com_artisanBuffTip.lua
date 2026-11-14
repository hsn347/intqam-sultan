local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_artisanBuffTip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_artisanBuffTip", Com_artisanBuffTip)
function Com_artisanBuffTip:onInit()
	self.fields.title = SoraDCreateTimerLabel(self, self.fields.title)
end
function Com_artisanBuffTip:initData()
	self.isUnLock = artisanHouseCtrl:isUnLock()
	self.isMaxLv = artisanHouseCtrl:isMaxLevel()
	local effectInfo = artisanHouseltCtrl.getNowEffectInfo(SoraDGetCastleLv())
	if self.isMaxLv then
		self.fields.title:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = buildLogic.getBuildLvStr(effectInfo.CastleLv)
			_ENV, _ENV, (nil).time = effectInfo.CastleLv, buildLogic.getBuildLvStr(effectInfo.CastleLv), timeStr
			_ENV, buildLogic.getBuildLvStr(effectInfo.CastleLv).time, effectInfo.CastleLv.color = effectInfo.CastleLv, effectInfo.CastleLv, self.colorTime
			buildLogic.getBuildLvStr(effectInfo.CastleLv).__default, effectInfo.CastleLv.color = effectInfo.CastleLv, self.defaultColor
			return i18n_html("Battle_Towers_10", nil, (buildLogic.getBuildLvStr(effectInfo.CastleLv)))
		end)
	elseif self.isUnLock then
		self.fields.title:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = buildLogic.getBuildLvStr(effectInfo.CastleLv)
			_ENV, _ENV, (nil).time = effectInfo.CastleLv, buildLogic.getBuildLvStr(effectInfo.CastleLv), timeStr
			_ENV, buildLogic.getBuildLvStr(effectInfo.CastleLv).time, effectInfo.CastleLv.color = effectInfo.CastleLv, effectInfo.CastleLv, self.colorTime
			buildLogic.getBuildLvStr(effectInfo.CastleLv).__default, effectInfo.CastleLv.color = effectInfo.CastleLv, self.defaultColor
			return i18n_html("Battle_Towers_09", nil, (buildLogic.getBuildLvStr(effectInfo.CastleLv)))
		end)
	else
		self.fields.title:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = buildLogic.getBuildLvStr(effectInfo.CastleLv)
			_ENV, _ENV, (nil).time = effectInfo.CastleLv, buildLogic.getBuildLvStr(effectInfo.CastleLv), timeStr
			_ENV, buildLogic.getBuildLvStr(effectInfo.CastleLv).time, effectInfo.CastleLv.color = effectInfo.CastleLv, effectInfo.CastleLv, self.colorTime
			buildLogic.getBuildLvStr(effectInfo.CastleLv).__default, effectInfo.CastleLv.color = effectInfo.CastleLv, self.defaultColor
			return i18n_html("Battle_Towers_08", nil, (buildLogic.getBuildLvStr(effectInfo.CastleLv)))
		end)
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY)
	local leftTime = eventTime.timerNode.timer:getRemainTime()
	if 0 < leftTime then
		self.fields.title:beginTime(leftTime)
	end
	if self.fields.title:getSize().width >= 450 then
		self.fields.title:setAutoSize(fgui.AutoSizeType.HEIGHT)
		self.fields.title:setSize(cc.size(450, 29))
	end
end
function Com_artisanBuffTip:setColorinfo(colorTime, defaultColor)
	self.colorTime = colorTime
	self.defaultColor = defaultColor
end
function Com_artisanBuffTip:setEndHandle(handler)
	self.fields.title:setTimeEndListener(handler)
end
function Com_artisanBuffTip:onShow()
end
return Com_artisanBuffTip
