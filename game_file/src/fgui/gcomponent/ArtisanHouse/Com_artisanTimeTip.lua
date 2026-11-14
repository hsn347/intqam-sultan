local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_artisanTimeTip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_artisanTimeTip", Com_artisanTimeTip)
function Com_artisanTimeTip:onInit()
	self:fixChildrenPos()
	self.fields.title = SoraDCreateTimerLabel(self, self.fields.title)
	self.fields.title:setTouchEnabled(true)
	self.fields.title:addEventListener(fgui.UIEventType.ClickLink, handler(self, self.onClickText))
end
function Com_artisanTimeTip:initData()
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
			_ENV = nil
			;(nil).param = "#btn_detail.png"
			;(nil).width = 37
			;(nil).height = 37
			;(nil).custom = "Sprite"
			;(nil).name = "detail"
			;(nil).offsety = 10
			return i18n_html("Battle_Towers_10", nil, (buildLogic.getBuildLvStr(effectInfo.CastleLv))) .. SoraDWrapReplaceTag(nil)
		end)
	elseif self.isUnLock then
		self.fields.title:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = buildLogic.getBuildLvStr(effectInfo.CastleLv)
			_ENV, _ENV, (nil).time = effectInfo.CastleLv, buildLogic.getBuildLvStr(effectInfo.CastleLv), timeStr
			_ENV, buildLogic.getBuildLvStr(effectInfo.CastleLv).time, effectInfo.CastleLv.color = effectInfo.CastleLv, effectInfo.CastleLv, self.colorTime
			buildLogic.getBuildLvStr(effectInfo.CastleLv).__default, effectInfo.CastleLv.color = effectInfo.CastleLv, self.defaultColor
			_ENV = nil
			;(nil).param = "#btn_detail.png"
			;(nil).width = 37
			;(nil).height = 37
			;(nil).custom = "Sprite"
			;(nil).name = "detail"
			;(nil).offsety = 10
			return i18n_html("Battle_Towers_09", nil, (buildLogic.getBuildLvStr(effectInfo.CastleLv))) .. SoraDWrapReplaceTag(nil)
		end)
	else
		self.fields.title:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = buildLogic.getBuildLvStr(effectInfo.CastleLv)
			_ENV, _ENV, (nil).time = effectInfo.CastleLv, buildLogic.getBuildLvStr(effectInfo.CastleLv), timeStr
			_ENV, buildLogic.getBuildLvStr(effectInfo.CastleLv).time, effectInfo.CastleLv.color = effectInfo.CastleLv, effectInfo.CastleLv, self.colorTime
			buildLogic.getBuildLvStr(effectInfo.CastleLv).__default, effectInfo.CastleLv.color = effectInfo.CastleLv, self.defaultColor
			_ENV = nil
			;(nil).param = "#btn_detail.png"
			;(nil).width = 37
			;(nil).height = 37
			;(nil).custom = "Sprite"
			;(nil).name = "detail"
			;(nil).offsety = 10
			return i18n_html("Battle_Towers_08", nil, (buildLogic.getBuildLvStr(effectInfo.CastleLv))) .. SoraDWrapReplaceTag(nil)
		end)
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY)
	local leftTime = eventTime.timerNode.timer:getRemainTime()
	if 0 < leftTime then
		self.fields.title:beginTime(leftTime)
	end
	if self.fields.title:getSize().width >= 500 then
		self.fields.title:setAutoSize(fgui.AutoSizeType.HEIGHT)
		self.fields.title:setSize(cc.size(500, 29))
	end
end
function Com_artisanTimeTip:setColorinfo(colorTime, defaultColor)
	self.colorTime = colorTime
	self.defaultColor = defaultColor
end
function Com_artisanTimeTip:setEndHandle(handler)
	self.fields.title:setTimeEndListener(handler)
end
function Com_artisanTimeTip:onClickText(eventContext)
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.title, param = i18n("Battle_Towers_23"), SoraDPlaySound
	uiManager:show("ArtisanHouseBuffPreview", param):setOwnerKey(self)
end
function Com_artisanTimeTip:onShow()
end
return Com_artisanTimeTip
