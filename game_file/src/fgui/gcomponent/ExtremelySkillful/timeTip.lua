local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local buildLogic = include("buildLogic")
local extremelySkillfulRead = include("extremelySkillfulRead")
local baseComponent = require("fgui.base.baseComponent")
local timeTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/timeTip", timeTip)
function timeTip:onInit()
	self:fixChildrenPos()
	self.fields.Text_Tips = SoraDCreateTimerLabel(self, self.fields.Text_Tips)
	self.fields.Text_Tips:setTouchEnabled(true)
	self.fields.Text_Tips:addEventListener(fgui.UIEventType.ClickLink, handler(self, self.onClickText))
end
function timeTip:onShow()
end
function timeTip:initData(type)
	local buffIndex = ExtremelySkillfulCtrl:getBuffIndex()
	self.type = type
	self.isUnLock = type <= buffIndex
	local effectInfo = extremelySkillfulRead.getNowEffectInfo(type)
	self.isMaxLv = ExtremelySkillfulCtrl:isMaxLvByType(type)
	local lvStr = ""
	if effectInfo.CastleLv[1] == 2 then
		ExtremelySkillfulCtrl = nil
		;(nil).LV = effectInfo.CastleLv[3]
		lvStr = i18n("gemEnchant_text_39", nil)
	else
		lvStr = buildLogic.getBuildLvStr(effectInfo.CastleLv[3])
	end
	if self.isMaxLv then
		self.fields.Text_Tips:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = lvStr
			_ENV, _ENV, (nil).time = nil, lvStr, timeStr
			_ENV, lvStr.time, (nil).color = nil, nil, self.colorTime
			lvStr.__default, (nil).color = nil, self.defaultColor
			_ENV = nil
			;(nil).param = "#btn_detail.png"
			;(nil).width = 30
			;(nil).height = 30
			;(nil).custom = "Sprite"
			;(nil).name = "detail"
			;(nil).offsety = 10
			return i18n_html("Battle_Towers_10", nil, lvStr) .. SoraDWrapReplaceTag(nil)
		end)
	elseif self.isUnLock then
		self.fields.Text_Tips:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = lvStr
			_ENV, _ENV, (nil).time = nil, lvStr, timeStr
			_ENV, lvStr.time, (nil).color = nil, nil, self.colorTime
			lvStr.__default, (nil).color = nil, self.defaultColor
			_ENV = nil
			;(nil).param = "#btn_detail.png"
			;(nil).width = 30
			;(nil).height = 30
			;(nil).custom = "Sprite"
			;(nil).name = "detail"
			;(nil).offsety = 10
			return i18n_html("Battle_Towers_09", nil, lvStr) .. SoraDWrapReplaceTag(nil)
		end)
	else
		self.fields.Text_Tips:setTimeLast(function(timeStr, time)
			_ENV = nil
			;(nil).lv = lvStr
			_ENV, _ENV, (nil).time = nil, lvStr, timeStr
			_ENV, lvStr.time, (nil).color = nil, nil, self.colorTime
			lvStr.__default, (nil).color = nil, self.defaultColor
			_ENV = nil
			;(nil).param = "#btn_detail.png"
			;(nil).width = 30
			;(nil).height = 30
			;(nil).custom = "Sprite"
			;(nil).name = "detail"
			;(nil).offsety = 10
			return i18n_html("MarvelousWorkmanship_28", nil, lvStr) .. SoraDWrapReplaceTag(nil)
		end)
	end
	local _eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(gActivityTimeActivityID.EXTREMELY_SKILLFUIL)
	if _eventTime then
		self.fields.Text_Tips:beginTime(_eventTime.timerNode.timer:getRemainTime())
	end
end
function timeTip:setColorinfo(colorTime, defaultColor)
	self.colorTime = colorTime
	self.defaultColor = defaultColor
end
function timeTip:onClickText(eventContext)
	SoraDPlaySound()
	_ENV = nil
	;(nil).tag = self.type
	uiManager:show("ExtremelySkillfulBuff", nil)
end
function timeTip:setEndHandle(handler)
	self.fields.Text_Tips:setTimeEndListener(handler)
end
return timeTip
