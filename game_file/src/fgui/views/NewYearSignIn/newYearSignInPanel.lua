local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local newYearSignInCtrl = SoraDGetCtrl("newYearSignInCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local newYearSignInPanel = class("newYearSignInPanel", basePanel)
function newYearSignInPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function newYearSignInPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function newYearSignInPanel:onInit()
	self.curDay = newYearSignInCtrl:getCurDay()
	self.fields.Com_title:initData(i18n("activity_name_9001384"), handler(self, self.onClickClose))
	self.fields.textTips:setString(i18n("newyear_signin_text_01"))
	self.fields.Usm_3:setVisible(false)
	self.effecyList = self.fields.effect_Node:getChildren()
	dump(self.effecyList, "self.effecyList")
end
function newYearSignInPanel:onShow()
	for i = 1, 7 do
		self.fields["com_box_" .. i]:addClickEventListener(handlerEx(self, self.onClickBox, i))
		if self.effecyList[i] then
			self.effecyList[i]:setAllFrameName("dh_jianianhua2_%.2d.png", 1)
			self.effecyList[i]:setVisible(false)
		end
	end
	self:initActivityTime()
	self:updateView()
end
function newYearSignInPanel:initActivityTime()
	self.fields.Labe_Time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_YEAR_CARNIVAL_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.fields.Labe_Time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function newYearSignInPanel:updateView()
	self:updateEffect()
	for i = 1, 7 do
		if self.effecyList[i] and newYearSignInCtrl:getDayRewardStatus(i) == 1 then
			self.effecyList[i]:setVisible(true)
			self.effecyList[i]:setPlaying(false)
			self.effecyList[i]:setFrame(15)
		end
		self.fields["com_box_" .. i]:initData(i)
	end
end
function newYearSignInPanel:updateEffect()
	if newYearSignInCtrl:getDayRewardStatus(7) == 2 then
		newYearSignInCtrl = 7
		;(7).byUID = true
		if not SoraDConfigGet("Game:NewYearSignInPanel:showLastDayEffect~bool", 7) then
			self:runLastDayEffect()
		else
			self.fields.Usm_2:setVisible(true)
		end
	else
		self.fields.Usm_2:setVisible(false)
		self.fields.Usm_3:setVisible(false)
	end
end
function newYearSignInPanel:runLastDayEffect()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:NewYearSignInPanel:showLastDayEffect~bool", true, nil)
	self.fields.Usm_3:setVisible(true)
	self.fields.Usm_2:setAlpha(0)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Usm_2:runAction(ffa.fadeTo(1, 1))
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Usm_2:runAction(ffa.fadeTo(1, 1))
	end)
	self:runAction(ffa.seq(nil))
end
function newYearSignInPanel:runSignSuccessEffect(day)
	if day < 7 then
		self.effecyList[day]:setVisible(true)
		self.effecyList[day]:setPlaying(true)
		self.effecyList[day]:setPlaySettings(1, -1, 1, -1, function()
			self:updateView()
		end)
	end
end
function newYearSignInPanel:onClickBox(day)
	print("day", day)
	SoraDPlaySound()
	_ENV = nil
	;(nil).day = day
	uiManager:show("newYearSignInPop", nil)
end
return newYearSignInPanel
