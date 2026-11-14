local constantRead = include("constantRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroReforgePanel = class("HeroReforgePanel", baseFguiPanel)
function HeroReforgePanel:ctor(...)
	HeroReforgePanel.super.ctor(self, ...)
	print("HeroReforgePanel:ctor", self.viewName)
end
function HeroReforgePanel:onInit()
	print("=======HeroReforgePanel:onInit")
	self.items_item, _ENV, self.items_free, _ENV = print, print, print, print
	self.fields.Panel_bg:setString(i18n("Hero_reshape_1"))
	self.fields.Text_tip:setString(i18n("Hero_reshape_2"))
	self.fields.Lab_free:setString(i18n("Hero_reshape_22"))
	self.fields.Lab_item:setString(i18n("Hero_reshape_23"))
	self.fields.Text_cd = SoraDCreateTimerLabel(self, self.fields.Text_cd)
	self.fields.Text_cd:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", strTime)
		return i18n("Hero_reshape_4", nil)
	end)
	self.fields.Btn_free:setString(i18n("Hero_reshape_5"))
	self.fields.Btn_free:addClickListener(handler(self, self.btnReforgelClick))
	self.fields.Btn_item:setString(i18n("Hero_reshape_5"))
	self.fields.Btn_item:addClickListener(handler(self, self.btnItemRelClick))
	self.fields.List_free:setItemRenderer(handler(self, self.onItem1Renderer))
	self.fields.List_item:setItemRenderer(handler(self, self.onItem2Renderer))
	self.view:fixChildrenPos()
end
function HeroReforgePanel:onItem1Renderer(index, obj)
	obj:initData(self.items_free[index + 1].id, self.items_free[index + 1].count)
end
function HeroReforgePanel:onItem2Renderer(index, obj)
	obj:initData(self.items_item[index + 1].id, self.items_item[index + 1].count)
end
function HeroReforgePanel:onShow()
	print("=======HeroReforgePanel:onShow")
	self.heroID = self.param.heroID
	self.cdTime = constantRead.getConstValue("HERO_RESHAPE_CD")
	self.costItem = constantRead.getConstValue("HERO_RESHAPE_COST_ITEM")
	self.freePercent = constantRead.getConstValue("HERO_RESHAPE_FREE_PERCENT")
	self.rid = constantRead.getConstValue("HERO_RESHAPE_GIFT_ID", 19669)
	self.items_item = heroCtrl:getReforgeItem(self.heroID)
	self.fields.List_item:setNumItems(#self.items_item)
	for k, v in ipairs(self.items_item) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).count = math.ceil(v.count * self.freePercent / 100)
		table.insert(self.items_free, nil)
	end
	self.fields.List_free:setNumItems(#self.items_free)
	self.fields.Com_have:initData(self.costItem)
	self.fields.Com_have:setAddCallback(function()
		local rechargeData = rechargeActivityCtrl:getRechargeActivityData(self.rid)
		if rechargeData then
			uiManager:show("HeroReforgeGift")
		else
			SoraDShowMsgTip(i18n("back_recharge_text13"))
		end
	end)
	self:updateView()
end
function HeroReforgePanel:updateView()
	local lastFreeReshapeTime = heroCtrl:getLastFreeReforgeTime()
	self.isNoCD = lastFreeReshapeTime == 0 or 0 < lastFreeReshapeTime and lastFreeReshapeTime + self.cdTime <= serviceFunctions.systemTime()
	self.fields.Btn_free:setBright(self.isNoCD)
	self.fields.Btn_item:setBright(self.isNoCD)
	if not self.isNoCD then
		local leftTime = lastFreeReshapeTime + self.cdTime - serviceFunctions.systemTime()
		self.fields.Text_cd:beginTime(leftTime)
		self.fields.Text_cd:setTimeEndListener(handler(self, self.updateView))
	else
		heroCtrl = handler(self, self.updateView)
		handler(self, self.updateView).num = fguiHelper.getColorString("#F0E6D2", math.ceil(self.cdTime / 86400))
		self.fields.Text_cd:setString(i18n("Hero_reshape_14", handler(self, self.updateView)))
	end
	self.fields.Com_have:updateNum()
	self.fields.Btn_item:setCost(self.costItem, 1)
end
function HeroReforgePanel:btnReforgelClick()
	SoraDPlaySound()
	if not self.isNoCD then
		SoraDShowMsgTip(i18n("Hero_reshape_24"))
		return
	end
	SoraDCheckSecondaryLock(function()
		_ENV = nil
		;(nil).cType = 0
		;(nil).items = self.items_free
		;(nil).heroID = self.heroID
		;(nil).parent = self
		uiManager:show("HeroReforgePop", nil)
	end, gSecondaryLockType.HeroReforge, "HeroReforge")
end
function HeroReforgePanel:btnItemRelClick()
	SoraDPlaySound()
	if not self.isNoCD then
		SoraDShowMsgTip(i18n("Hero_reshape_24"))
		return
	end
	SoraDCheckSecondaryLock(function()
		if backpackCtrl:getItemCount(self.costItem) > 0 then
			backpackCtrl = nil
			;(nil).cType = 1
			;(nil).items = self.items_item
			;(nil).heroID = self.heroID
			;(nil).parent = self
			uiManager:show("HeroReforgePop", nil)
		else
			SoraDShowMsgTip(i18n("gemEnchant_text_48"))
		end
	end, gSecondaryLockType.HeroReforge, "HeroReforge")
end
return HeroReforgePanel
