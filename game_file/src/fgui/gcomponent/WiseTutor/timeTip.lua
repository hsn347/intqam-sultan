local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local buildLogic = include("buildLogic")
local wiseTutorRead = include("wiseTutorRead")
local baseComponent = require("fgui.base.baseComponent")
local timeTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/timeTip", timeTip)
function timeTip:onInit()
	self:fixChildrenPos()
	self.fields.Text_Tips = SoraDCreateTimerLabel(self, self.fields.Text_Tips)
	self.fields.Text_Tips:setTouchEnabled(true)
	self.fields.Text_Tips:addEventListener(fgui.UIEventType.ClickLink, handler(self, self.onClickText))
end
function timeTip:onShow()
	self.isUnLock = wiseTutorCtrl:isUnLock()
	local effectInfo = wiseTutorRead.getNowEffectInfo(SoraDGetCastleLv())
	self.isMaxLv = wiseTutorCtrl:isMaxLevel()
	if self.isMaxLv then
		self.fields.Text_Tips:setTimeLast(function(timeStr, time)
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
		self.fields.Text_Tips:setTimeLast(function(timeStr, time)
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
		self.fields.Text_Tips:setTimeLast(function(timeStr, time)
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
	local state, leftTime = wiseTutorCtrl:getStateInfo()
	if 0 < leftTime then
		self.fields.Text_Tips:beginTime(leftTime)
	end
	if self.fields.Text_Tips:getSize().width >= 500 then
		self.fields.Text_Tips:setAutoSize(fgui.AutoSizeType.HEIGHT)
		self.fields.Text_Tips:setSize(cc.size(500, 29))
	end
end
function timeTip:setColorinfo(colorTime, defaultColor)
	self.colorTime = colorTime
	self.defaultColor = defaultColor
end
function timeTip:setEndHandle(handler)
	self.fields.Text_Tips:setTimeEndListener(handler)
end
function timeTip:onClickText(eventContext)
	SoraDPlaySound()
	uiManager:show("wiseTutorBuff")
end
return timeTip
