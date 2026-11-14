local constantRead = include("constantRead")
local activity_9001678_Read = include("activity_9001678_Read")
local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001714_HelpRewardPanel = class("Activity_9001714_HelpRewardPanel", baseFguiPanel)
function Activity_9001714_HelpRewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001714_HelpRewardPanel.super.ctor(self, ...)
	print("Activity_9001714_HelpRewardPanel:ctor", self.viewName)
end
function Activity_9001714_HelpRewardPanel:onInit()
	print("=======Activity_9001714_HelpRewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Frosty_Market_text_21"))
	self.fields.Text_tip:setString(i18n("Frosty_Market_text_22"))
	self.fields.Text_none:setString(i18n("Frosty_Market_text_07"))
	self.fields.Text_none:setVisible(false)
	_ENV = i18n("Frosty_Market_text_07")
	i18n("Frosty_Market_text_07").num = ""
	self.fields.Text_cell:setString(i18n("Frosty_Market_text_23", i18n("Frosty_Market_text_07")))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onHelperRenderer))
	self.fields.Button_cost:setString(i18n("Frosty_Market_text_17"))
	self.fields.Button_cost:addClickListener(handler(self, self.btnClick))
	self.fields.Text_cell:fixPos()
	self.fields.Com_cell:fixPos()
end
function Activity_9001714_HelpRewardPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Activity_9001714_HelpRewardPanel:onHelperRenderer(index, obj)
	obj:initData(self.helperList[index + 1])
end
function Activity_9001714_HelpRewardPanel:endShow()
	print("=======Activity_9001714_HelpRewardPanel:endShow")
	self.values = self.param.values
	local disCfg = constantRead.getConstValueArray(self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_ITEM" or "FROSTY_MARKEY_DISCOUNT_ITEM")
	_ENV = self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_ITEM" or "FROSTY_MARKEY_DISCOUNT_ITEM"
	;(self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_ITEM" or "FROSTY_MARKEY_DISCOUNT_ITEM").id = disCfg[1]
	self.discountItem, (self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_ITEM" or "FROSTY_MARKEY_DISCOUNT_ITEM").count = self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_ITEM" or "FROSTY_MARKEY_DISCOUNT_ITEM", disCfg[2]
	self.forstyNum = constantRead.getConstValue(self.values.skinType == 2 and "DESERT_DISCOUNT_NUM" or "FORSTY_DISCOUNT_NUM")
	activity_9001678_Ctrl = self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_REWARD" or "FROSTY_MARKEY_DISCOUNT_REWARD"
	;(self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_REWARD" or "FROSTY_MARKEY_DISCOUNT_REWARD")[1] = "id"
	;(self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_REWARD" or "FROSTY_MARKEY_DISCOUNT_REWARD")[2] = "count"
	;(self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_REWARD" or "FROSTY_MARKEY_DISCOUNT_REWARD")[3] = "rate"
	self.rewardList = serviceFunctions.tableFormat(constantRead.getConstValueArray(self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_REWARD" or "FROSTY_MARKEY_DISCOUNT_REWARD"), self.values.skinType == 2 and "DESERT_MARKEY_DISCOUNT_REWARD" or "FROSTY_MARKEY_DISCOUNT_REWARD")
	self.cfg = activity_9001678_Read.getFrostyMarketCfg(self.values.goodId)
	self.fields.List_reward:setNumItems(#self.rewardList)
	self.fields.List_reward:setScrollEnable(#self.rewardList > 5)
	self.fields.Button_cost:setCost(self.discountItem.id, self.discountItem.count)
	activity_9001678_Ctrl:sendHelpersMsg(self.values.goodId, self.values.uid, self.values.t)
	SoraDShowLoading(self)
end
function Activity_9001714_HelpRewardPanel:updateView(target, data)
	SoraDCloseLoading(self)
	if data.key == "helpers" then
		self.helperList = data.helpers
	elseif data.key == "help" then
		activity_9001678_Ctrl:sendHelpersMsg(self.values.goodId, self.values.uid, self.values.t)
		return
	end
	self.fields.List:setNumItems(#self.helperList)
	self.fields.Text_none:setVisible(#self.helperList == 0)
	self.discount = 0
	self.count = #self.helperList
	self.isHelped = false
	for k, v in ipairs(self.helperList) do
		self.discount = self.discount + v.discount
		if v.uid == SoraDGetPlayerID() then
			self.isHelped = true
		end
	end
	self.fields.Com_cell:initData(self.cfg.oriPrice.id, math.max(0, self.cfg.oriPrice.count - self.discount), self.cfg.oriPrice.count)
	if self.isHelped then
		self.fields.Button_cost:setString(i18n("common_text_2601"))
		self.fields.Button_cost:setEnabled(false)
	else
		self.fields.Button_cost:setEnabled(true)
		self.fields.Button_cost:setString(self.count < self.forstyNum and i18n("Frosty_Market_text_17") or i18n("common_text_2601"))
		self.myCount = backpackCtrl:getItemCount(self.discountItem.id)
		self.fields.Button_cost:setIsEnough(self.myCount >= self.discountItem.count)
	end
end
function Activity_9001714_HelpRewardPanel:btnClick()
	SoraDPlaySound()
	if self.isHelped then
		SoraDShowMsgTip(i18n("Frosty_Market_text_30"))
		return
	end
	if self.count >= self.forstyNum then
		SoraDShowMsgTip(i18n("Frosty_Market_text_29"))
		return
	end
	if self.myCount < self.discountItem.count then
		_ENV = i18n("Frosty_Market_text_29")
		i18n("Frosty_Market_text_29").name = publicRead.getName(self.discountItem.id)
		SoraDShowMsgTip(i18n("Frosty_Market_text_19", i18n("Frosty_Market_text_29")))
		return
	end
	if self.values.uid == SoraDGetPlayerID() then
		SoraDShowMsgTip(i18n("Frosty_Market_text_32"))
		return
	end
	activity_9001678_Ctrl:sendHelpMsg(self.values.uid, self.values.goodId, self.values.t, self.values.classType)
	SoraDShowLoading(self)
end
return Activity_9001714_HelpRewardPanel
