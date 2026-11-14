local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CoffeeCraftsmanTastePanel = class("CoffeeCraftsmanTastePanel", baseFguiPanel)
function CoffeeCraftsmanTastePanel:ctor(...)
	self.super.ctor(self, ...)
	print("CoffeeCraftsmanTastePanel:ctor", self.viewName)
end
function CoffeeCraftsmanTastePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
	end
	return self._packageList
end
function CoffeeCraftsmanTastePanel:onInit()
	print("=======CoffeeCraftsmanTastePanel:onInit")
	self.fields.Com_title:setString(i18n("coffeeCraftsman_text_17"))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.text_time:setTimeLast(function(strTime, nTime)
		self:updateTimeStatus(nTime)
		self = nTime
		nTime.time = strTime
		return i18n("coffeeCraftsman_text_28", nTime)
	end)
	self.text_time:setTimeEndListener(function()
		self.fields.Text_time:setString(i18n("coffeeCraftsman_text_21"))
	end)
	self.fields.Text_gain:setString(i18n("coffeeCraftsman_text_15"))
	self.fields.Button_taste:setString(i18n("coffeeCraftsman_text_16"))
	self.fields.Button_del:addClickListener(handler(self, self.onClickDel))
	self.fields.Button_taste:addClickListener(handler(self, self.onClickTaste))
	self.fields.Usm_steam:setBlendFunc(gl.ONE, gl.ONE)
	self.view:fixChildrenPos(false, false)
end
function CoffeeCraftsmanTastePanel:onClickDel()
	SoraDPlaySound()
	local leftTime = coffeeCraftsmanCtrl:getLeftTime(self.index)
	if leftTime <= 0 then
		return
	end
	if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanDel) then
		_ENV = nil
		;(nil).content = i18n("coffeeCraftsman_text_12")
		;(nil).confirmFunc = function()
			coffeeCraftsmanCtrl:reqDel(self.index)
		end
		;(nil).remindString = i18n("coffeeCraftsman_text_27")
		;(nil).remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanDel)
			end
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	else
		coffeeCraftsmanCtrl:reqDel(self.index)
	end
end
function CoffeeCraftsmanTastePanel:onClickTaste()
	SoraDPlaySound()
	local leftTime = coffeeCraftsmanCtrl:getLeftTime(self.index)
	if leftTime <= 0 then
		SoraDShowMsgTip(i18n("coffeeCraftsman_text_13"))
		return
	end
	local config = coffeeCraftsmanCtrl:getConfig(self.data.id)
	local curNum = backpackCtrl:getItemCount(coffeeCraftsmanCtrl.SPOON_ID)
	if curNum < config.itemNeed then
		_ENV = i18n("coffeeCraftsman_text_13")
		i18n("coffeeCraftsman_text_13").content = i18n("coffeeCraftsman_text_14")
		i18n("coffeeCraftsman_text_13").confirmFunc = function()
			uiManager:show("CoffeeCraftsmanSpoon")
		end
		uiManager:show("MessageBox", i18n("coffeeCraftsman_text_13")):setOwnerKey(self)
		return
	end
	coffeeCraftsmanCtrl:reqSpecialDraw(self.index)
end
function CoffeeCraftsmanTastePanel:onShow()
	print("=======CoffeeCraftsmanTastePanel:onShow")
	local data = self.proxy.param.data
	self.data = data
	self.index = self.proxy.param.index
	local icon = coffeeCraftsmanRead:getCoffeeIcon(data.id)
	self.fields.Com_coffee:initData(data.id)
	local leftTime = coffeeCraftsmanCtrl:getLeftTime(self.index)
	self.disappearTime = coffeeCraftsmanCtrl:getConfig(data.id).disappear
	self.text_time:beginTime(leftTime)
	local reward = self.proxy.param.data.reward
	self.fields.Item_award:initData(reward.id, reward.count)
	self:updateSpoon()
end
function CoffeeCraftsmanTastePanel:updateSpoon()
	local config = coffeeCraftsmanCtrl:getConfig(self.data.id)
	local haveCount = backpackCtrl:getItemCount(coffeeCraftsmanCtrl.SPOON_ID)
	self.fields.Button_taste:setCostNum(config.itemNeed, haveCount)
end
function CoffeeCraftsmanTastePanel:onHide()
	print("=======CoffeeCraftsmanTastePanel:onHide")
end
function CoffeeCraftsmanTastePanel:onDispose()
	print("=======CoffeeCraftsmanTastePanel:onDispose")
end
function CoffeeCraftsmanTastePanel:updateTimeStatus(time)
	local isRed = time <= self.disappearTime
	if self.lastRed == isRed then
		return
	end
	self.lastRed = isRed
	self.controllers.Ctrl_timeStatus:setSelectedIndex(isRed and 1 or 0)
end
return CoffeeCraftsmanTastePanel
