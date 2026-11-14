local activity_9001713_Read = include("activity_9001713_Read")
local activity_9001713_Ctrl = SoraDGetCtrl("activity_9001713_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001713_MainPanel = class("Activity_9001713_MainPanel", baseFguiPanel)
function Activity_9001713_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001713_MainPanel.super.ctor(self, ...)
	print("Activity_9001713_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_SHOP_2025
	self.itemID = activity_9001713_Read.getItemID()
	self.refreshCfg = constantRead.getConstValueArray("ANNIVERSARY_SHOP_REFRESH_CONSUME")
end
function Activity_9001713_MainPanel:onInit()
	print("=======Activity_9001713_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_gift:setTitle(i18n("kindofwar_btn_01"))
	self.fields.Button_gift:addClickListener(handler(self, self.onClick_Button_gift))
	self.fields.Button_refresh:setTitle(i18n("ANNIVERSARY_MARKET_TEXT_04"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClick_Button_refresh))
	self.fields.Text_tip:setString(i18n("ANNIVERSARY_MARKET_TEXT_02"))
end
function Activity_9001713_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ANNIVERSARY_MARKET_TEXT_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001713_MainPanel:endShow()
	print("=======Activity_9001713_MainPanel:endShow")
	self:initView()
end
function Activity_9001713_MainPanel:initView()
	SoraDCloseLoading(self)
	self.fields.Com_have:initData(self.itemID)
	self.ListData = activity_9001713_Ctrl:getGoodsList()
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:setScrollEnable(#self.ListData > 6)
	local refreshCount = activity_9001713_Ctrl:getRefreshCount()
	self.leftTimes = #self.refreshCfg - refreshCount
	_ENV = nil
	;(nil).num1 = self.leftTimes
	;(nil).num2 = #self.refreshCfg
	self.fields.Text_refresh:setString(i18n("ANNIVERSARY_MARKET_TEXT_06", nil))
	self.refreshGold = self.refreshCfg[refreshCount + 1] or self.refreshCfg[#self.refreshCfg]
	self.isEnough = SoraDEnoughGold(self.refreshGold, true)
	if self.refreshGold > 0 then
		self.fields.Button_refresh:initData(gIDDef.GOLD, self.refreshGold)
		self.fields.Button_refresh:setStatus(self.isEnough, false)
		self.fields.Button_refresh:setGrayed(self.leftTimes < 1)
	else
		self.fields.Button_refresh:setTitle(i18n("ANNIVERSARY_MARKET_TEXT_04"))
	end
end
function Activity_9001713_MainPanel:itemRenderer_List(index, obj)
	obj:initData(self.ListData[index + 1])
end
function Activity_9001713_MainPanel:onClick_Button_gift()
	SoraDPlaySound()
	uiManager:show("Activity_9001713_Gift")
end
function Activity_9001713_MainPanel:isCanBuy()
	local ret = false
	for k, v in ipairs(self.ListData) do
		local cfg = activity_9001713_Read.getShopGoodCfg(v.goodsID)
		local buyCount = activity_9001713_Ctrl:getGoodsBuyCount(v.goodsID)
		if cfg.limit - buyCount > 0 and backpackCtrl:getItemCount(cfg.itemID) >= cfg.itemCount then
			ret = true
			break
		end
	end
	return ret
end
function Activity_9001713_MainPanel:onClick_Button_refresh()
	SoraDPlaySound()
	if self.leftTimes < 1 then
		SoraDShowMsgTip(i18n("ANNIVERSARY_MARKET_TEXT_05"))
		return
	end
	if not self.isEnough then
		SoraDShowMsgTip(i18n("Canyon_Treasur_text_13"))
		return
	end
	if not self:isCanBuy() then
		activity_9001713_Ctrl:reqRefresh()
		SoraDShowLoading(self)
	elseif dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.activity_9001713_2) then
		if self.refreshGold > 0 then
			_ENV = i18n("Canyon_Treasur_text_13")
			i18n("Canyon_Treasur_text_13").num = self.refreshGold
			if i18n("ANNIVERSARY_MARKET_TEXT_08", i18n("Canyon_Treasur_text_13")) then
				goto lbl_52
			end
		end
		local msg = i18n("ANNIVERSARY_MARKET_TEXT_07")
		::lbl_52::
		_ENV = i18n("Canyon_Treasur_text_13")
		i18n("Canyon_Treasur_text_13").content = msg
		i18n("Canyon_Treasur_text_13").confirmFunc = function()
			activity_9001713_Ctrl:reqRefresh()
			SoraDShowLoading(self)
		end
		i18n("Canyon_Treasur_text_13").remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.activity_9001713_2)
			end
		end
		uiManager:show("MessageBox", i18n("Canyon_Treasur_text_13"))
	else
		activity_9001713_Ctrl:reqRefresh()
		SoraDShowLoading(self)
	end
end
return Activity_9001713_MainPanel
