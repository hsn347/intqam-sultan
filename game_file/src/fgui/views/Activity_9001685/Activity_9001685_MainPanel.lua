local activity_9001685_Ctrl = SoraDGetCtrl("activity_9001685_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001685_Read = include("activity_9001685_Read")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001685_MainPanel = class("Activity_9001685_MainPanel", baseFguiPanel)
function Activity_9001685_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001685_MainPanel.super.ctor(self, ...)
	print("Activity_9001685_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.WEAPON_SPECIAL_BOX
	self.exchangeActID = gActivityTimeActivityID.WEAPON_SPECIAL_BOX
end
function Activity_9001685_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExchangeShopNew"
	end
	return self._packageList
end
function Activity_9001685_MainPanel:onInit()
	print("=======Activity_9001685_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.drawCfg1 = activity_9001685_Read.getDrawCfg(1)
	self.drawCfg2 = activity_9001685_Read.getDrawCfg(2)
	self.costID = self.drawCfg1.drawCost[1]
	self.reduceID = self.drawCfg1.reduceId
	self.fields.Com_title:initData(i18n("activity_name_9001685"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onShopRenderer))
	self.fields.Text_skip:setString(i18n("weapon_creating_10"))
	self.fields.Check_tick:addClickListener(handler(self, self.btnSkipClick))
	self.fields.Usm_close:setCompleteCallback(function()
		self.fields.Usm_close:setVisible(false)
		self.fields.Usm_act:setVisible(false)
		self.fields.touch:setVisible(false)
		self.isActClose = false
	end)
	self.fields.Usm_act:setCompleteCallback(function()
		self.isAct = false
	end)
	self.fields.Com_haveReduce:hideBtnAdd()
	self.fields.Button_costOne:setString(i18n("weapon_box_activity_004"))
	self.fields.Button_costTen:setString(i18n("weapon_box_activity_005"))
	self.fields.Button_costOne:addClickListener(handler(self, self.btnOneClick))
	self.fields.Button_costTen:addClickListener(handler(self, self.btnTenClick))
	self.fields.Btn_weaponDes:setString(i18n("HeroWeapon_9"))
	self.fields.Btn_weaponDes:addClickListener(handler(self, self.btnWeaponDesClick))
	self.fields.touch:addClickListener(handler(self, self.btnContinueClick))
	self.fields.List_rewards:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_skip:fixPos()
	self.fields.n14:fixPos()
	self.fields.n14:fix()
	self.fields.Check_tick:fixPos()
	self.fields.Com_haveCost:fixPos()
	self.fields.Com_haveReduce:fixPos()
	self.fields.Button_costOne:fixPos()
	self.fields.Button_costTen:fixPos()
end
function Activity_9001685_MainPanel:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1], index + 1)
end
function Activity_9001685_MainPanel:onShopRenderer(index, obj)
	_UPVALUE0_ = index + 1
	;(index + 1).activityID = self.exchangeActID
	obj:initData(self.exchangeList[index + 1], index + 1)
end
function Activity_9001685_MainPanel:endShow()
	print("=======Activity_9001685_MainPanel:endShow")
	_ENV = nil
	;(nil).byUID = true
	self.isSkip = SoraDConfigGet("Game:Activity_9001685:switch~bool", nil) or false
	self.fields.Check_tick:setSelected(self.isSkip)
	self.isAct = false
	self.isActClose = false
	self.fields.Usm_act:setVisible(false)
	self.fields.Usm_close:setVisible(false)
	self.fields.touch:setVisible(false)
	self.fields.List_rewards:setVisible(false)
	self.exchangeList, _ENV = self.fields.List_rewards.setVisible, self.fields.List_rewards.setVisible
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.tag = 1
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("weapon_box_activity_001")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("weapon_box_activity_002")
	self.activityID.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	self.activityID.callback = handler(self, self.onClickTab)
	self.fields.Com_Tab:initView(self.activityID)
end
function Activity_9001685_MainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001685_MainPanel:initView(target, data)
	SoraDCloseLoading(self)
	if self.tag == 1 then
		self.fields.Com_haveCost:initData(self.costID)
		self.fields.Com_haveReduce:initData(self.reduceID)
		local reduceCount = backpackCtrl:getItemCount(self.reduceID)
		self.costCount = backpackCtrl:getItemCount(self.costID)
		local cost1 = self.drawCfg1.drawCost[2]
		self.curCost1 = math.max(math.ceil(cost1 / 2), cost1 - reduceCount)
		self.fields.Button_costOne:initData(self.costID, self.curCost1, cost1, self.reduceID)
		local cost2 = self.drawCfg2.drawCost[2]
		self.curCost2 = math.max(math.ceil(cost2 / 2), cost2 - reduceCount)
		self.fields.Button_costTen:initData(self.costID, self.curCost2, cost2, self.reduceID)
		if data and data.rewards then
			if self.isSkip then
				_ENV = self.curCost2
				self.curCost2.itemType = 1
				self.curCost2.rewards = data.rewards
				uiManager:show("CommonCongratulations", self.curCost2)
			else
				self.isAct = true
				self.fields.touch:setVisible(true)
				self.fields.Usm_act:setVisible(true)
				self.fields.Usm_act:play()
				backpackCtrl = self.curCost2
				self.curCost2[1] = ffa.delay(1.8)
				self.curCost2[2] = ffa.callFunc(function()
					self.fields.List_rewards:setVisible(true)
					self.rewards = data.rewards
					self.fields.List_rewards:setNumItems(#self.rewards)
				end)
				self.curCost2[3] = ffa.callFunc(function()
					self.fields.List_rewards:setVisible(true)
					self.rewards = data.rewards
					self.fields.List_rewards:setNumItems(#self.rewards)
				end)
				self:runAction(ffa.seq(self.curCost2))
			end
		end
	elseif self.tag == 2 then
		self.fields.List_rewards:setVisible(false)
		self.fields.touch:setVisible(false)
		if not activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID) then
			_ENV = activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID)
		end
		self.exchangeList = activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID)
		self:sortData()
		self.fields.List:setNumItems(#self.exchangeList)
	end
	self:updateTabRed()
end
function Activity_9001685_MainPanel:updateTabRed()
	local drawRed = activity_9001685_Ctrl:getDrawRedNum()
	self.fields.Com_Tab:setBtnRedDot(1, 0 < drawRed)
	local exchangeRed = activity_9001685_Ctrl:getExchangeRedNum()
	self.fields.Com_Tab:setBtnRedDot(2, 0 < exchangeRed, exchangeRed)
end
function Activity_9001685_MainPanel:sortData()
	for i, v in ipairs(self.exchangeList) do
		v.weight = 0
		v.index = i
		if 0 < v.limitnum - v.curExchangeNum then
			v.weight = 1
		end
	end
	table.sort(self.exchangeList, function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		else
			return a.index < b.index
		end
	end)
end
function Activity_9001685_MainPanel:btnSkipClick()
	SoraDPlaySound()
	self.isSkip = self.fields.Check_tick:isSelected()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Activity_9001685:switch~bool", self.isSkip, nil)
end
function Activity_9001685_MainPanel:btnOneClick()
	SoraDPlaySound()
	if self.costCount < self.curCost1 then
		SoraDShowMsgTip(i18n("weapon_box_activity_006"))
		return
	end
	activity_9001685_Ctrl:reqDraw(1)
	SoraDShowLoading(self)
end
function Activity_9001685_MainPanel:btnTenClick()
	SoraDPlaySound()
	if self.costCount < self.curCost2 then
		SoraDShowMsgTip(i18n("weapon_box_activity_006"))
		return
	end
	activity_9001685_Ctrl:reqDraw(2)
	SoraDShowLoading(self)
end
function Activity_9001685_MainPanel:btnContinueClick()
	if self.isAct or self.isActClose then
		return
	end
	self.fields.List_rewards:setVisible(false)
	self.fields.Usm_close:setVisible(true)
	self.fields.Usm_close:play()
	self.isActClose = true
end
function Activity_9001685_MainPanel:btnWeaponDesClick()
	SoraDPlaySound()
	uiManager:show("HeroWeaponMap")
end
function Activity_9001685_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("weapon_box_activity_003")
	uiManager:show("RuleView", nil)
end
return Activity_9001685_MainPanel
