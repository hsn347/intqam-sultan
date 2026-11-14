local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local publicRead = include("publicRead")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroChipExchangePanel = class("HeroChipExchangePanel", baseFguiPanel)
function HeroChipExchangePanel:ctor(...)
	HeroChipExchangePanel.super.ctor(self, ...)
	print("HeroChipExchangePanel:ctor", self.viewName)
end
function HeroChipExchangePanel:onInit()
	print("=======HeroChipExchangePanel:onInit")
	self.fields.Btn_exchange:addClickListener(handler(self, self.btnClick))
	self.fields.slider:setSliderCallBack(handler(self, self.sliderBack))
	self.fields.item_from:fixPos()
	self.fields.Text_from:fixPos()
	self.fields.item_to:fixPos()
	self.fields.Text_to:fixPos()
	self.fields.arrow:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.slider:setInpuBoxFixPos()
end
function HeroChipExchangePanel:onShow()
	print("=======HeroChipExchangePanel:onShow")
	self.itemID = self.param.itemID
	self.mode = self.param.mode or 1
	self.heroID = self.param.heroID
	self.fields.Panel_bg:setString(self.mode == 1 and i18n("Hero_reshape_8") or i18n("heroskill_title_01"))
	self.fields.Btn_exchange:setString(self.mode == 1 and i18n("Hero_reshape_7") or i18n("common_text_1889"))
	self:initData()
end
function HeroChipExchangePanel:sliderBack(value)
	if self.mode == 1 then
		local num = self.exchangeInfo and self.exchangeInfo.newTokenNum or 1
		self.costNum = value
		self.exchageNum = value * num
		self.fields.item_from:setNumText(self.costNum)
		self.fields.item_to:setNumText(self.exchageNum)
	else
		local num = self.exchangeInfo and self.exchangeInfo.changeNum or 1
		self.costNum = value * num
		self.exchageNum = value
	end
	self.fields.Btn_exchange:setCost2(self.chipID, self.costNum, self.itemNum)
end
function HeroChipExchangePanel:initData()
	if self.mode == 1 then
		self.chipID = self.itemID
		self.exchangeInfo = heroltCtrl:getExchangeInfo(self.chipID)
		self.fields.item_from:initData(self.chipID)
		self.fields.Text_from:setString(publicRead.getName(self.chipID))
		self.fields.item_to:initData(self.exchangeInfo.newTokenID)
		self.fields.Text_to:setString(publicRead.getName(self.exchangeInfo.newTokenID))
		self.itemNum = backpackCtrl:getItemCount(self.chipID)
		local useMax = backpackltCtrl:getUseMax(self.chipID)
		heroltCtrl = publicRead.getName(self.exchangeInfo.newTokenID)
		publicRead.getName(self.exchangeInfo.newTokenID).maxValue = math.min(useMax, self.itemNum)
		publicRead.getName(self.exchangeInfo.newTokenID).minValue = 1
		publicRead.getName(self.exchangeInfo.newTokenID).curValue = 1
		self.fields.slider:initData(publicRead.getName(self.exchangeInfo.newTokenID))
	else
		self.chipID = heroltCtrl:getChipID(self.heroID)
		self.exchangeInfo = heroltCtrl:getExchangeInfo(self.chipID)
		self.fields.item_to:initData(self.chipID)
		self.fields.Text_to:setString(publicRead.getName(self.chipID))
		self.fields.item_from:initData(self.exchangeInfo.changeID)
		self.fields.Text_from:setString(publicRead.getName(self.exchangeInfo.changeID))
		self.itemNum = backpackCtrl:getItemCount(self.exchangeInfo.changeID)
		local useMax = backpackltCtrl:getUseMax(self.exchangeInfo.changeID)
		heroltCtrl = publicRead.getName(self.exchangeInfo.changeID)
		publicRead.getName(self.exchangeInfo.changeID).maxValue = math.min(useMax, math.floor(self.itemNum / self.exchangeInfo.changeNum))
		publicRead.getName(self.exchangeInfo.changeID).minValue = 1
		publicRead.getName(self.exchangeInfo.changeID).curValue = 1
		self.fields.slider:initData(publicRead.getName(self.exchangeInfo.changeID))
	end
	self.fields.Btn_exchange:setCostIcon(publicRead.getIcon(self.chipID))
end
function HeroChipExchangePanel:btnClick()
	SoraDPlaySound()
	local index = self.exchangeInfo.index
	local value = self.fields.slider:getSliderCurValue()
	local chipID = self.chipID
	local newTokenID = self.exchangeInfo.newTokenID
	if self.mode == 1 then
		SoraDCheckSecondaryLock(function()
			if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.heroChipExchange) then
				dailyRemindManager = nil
				dailyRemindManager = nil
				;(nil).name1 = publicRead.getName(chipID)
				;(nil).name2 = publicRead.getName(newTokenID)
				;(nil).content = i18n("Hero_reshape_15", nil)
				;(nil).confirmString = i18n("common_text_204")
				;(nil).confirmFunc = function()
					if not tolua.isnull(self) then
						heroCtrl:exchangeChipsReq(index, value, 1)
						self:close()
					end
				end
				;(nil).cancelString = i18n("common_text_185")
				;(nil).remindString = i18n("build_gold_lvup_tips_name")
				;(nil).remindFunc = function(value)
					if value then
						dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.heroChipExchange)
					end
				end
				uiManager:show("MessageBox", nil)
			elseif not tolua.isnull(self) then
				heroCtrl:exchangeChipsReq(index, value, 1)
				self:close()
			end
		end, gSecondaryLockType.HeroChipExchange, "HeroChipExchange")
	else
		local costNum = self.costNum
		local changeID = self.exchangeInfo.changeID
		local exchageNum = self.exchageNum
		_ENV = nil
		;(nil).num = costNum
		;(nil).item = publicRead.getName(changeID)
		;(nil).num1 = exchageNum
		;(nil).item1 = publicRead.getName(chipID)
		SoraDShowMsgBox(i18n("heroskill_text_09", nil), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				heroCtrl:exchangeChipsReq(index, value)
				self:close()
			end
		end)
	end
end
return HeroChipExchangePanel
