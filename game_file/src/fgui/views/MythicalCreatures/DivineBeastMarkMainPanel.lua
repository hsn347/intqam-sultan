local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkMainPanel = class("DivineBeastMarkMainPanel", baseFguiPanel)
local publicRead = include("publicRead")
local divineBeastRead = include("divineBeastRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicUtil = include("publicUtil")
function DivineBeastMarkMainPanel:ctor(...)
	DivineBeastMarkMainPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkMainPanel:ctor", self.viewName)
end
function DivineBeastMarkMainPanel:onInit()
	print("=======DivineBeastMarkMainPanel:onInit")
	self.itemID = gIDDef.DIVINE_BEAST_MARK_ENERGY
	self.itemID2 = gIDDef.DIVINE_BEAST_MARK_EXP
	self.beastId = self.param.beastId
	self.fields.bg:setURL(divineBeastRead.getBeastMarkBg(self.beastId))
	self.beastCfg = divineBeastRead.getDbCfg(self.beastId)
	self.fields.Com_title:initData(i18n(self.beastCfg.divineName), handler(self, self.onClickClose))
	local iconName = SoraDFIsRA() and self.beastCfg.divineName .. "_ar.png" or self.beastCfg.divineName .. "_en.png"
	self.fields.icon_name:setURL(iconName)
	self.fields.Com_have:initData(self.itemID2)
	self.fields.Com_MC_Have:setIcon(publicRead.getIcon(self.itemID))
	self.fields.Com_MC_Have:addClickEventListener(handler(self, self.onGetItem))
	self.fields.Com_title:setSmallHelpCallBack(handler(self, self.onClickHelp))
	self.fields.Txt_tip:setString(i18n("Divine_beast_mark_text_16"))
	self.fields.Btn_elements:setTitle(i18n("Divine_beast_mark_text_14"))
	self.fields.Btn_elements:addClickEventListener(handler(self, self.onElementsClick))
	self.fields.Btn_bag:setTitle(i18n("common_text_308"))
	self.fields.Btn_bag:addClickEventListener(handler(self, self.onBagClick))
	self.fields.Btn_recount:setTitle(i18n("hero_title_01"))
	self.fields.Btn_recount:addClickEventListener(handler(self, self.onRecountClick))
	self.fields.Btn_replace:addClickEventListener(handler(self, self.onReplaceClick))
	self.fields.Btn_up:setTitle(i18n("runningSheep_text_06"))
	self.fields.Btn_up:addClickEventListener(handler(self, self.onUpgradeClick))
	self.fields.Btn_refine:setTitle(i18n("Divine_beast_mark_refinement_02"))
	self.fields.Btn_refine:addClickEventListener(handler(self, self.onRefineClick))
	self.fields.Btn_exchange:setTitle(i18n("allianceWar_shop_title"))
	self.fields.Btn_exchange:addClickEventListener(handler(self, self.onExchangeClick))
	self.fields.Btn_illusion:setTitle(i18n("common_text_2935"))
	self.fields.Btn_illusion:addClickEventListener(handler(self, self.onIllusionClick))
	self.fields.Btn_changeElem:setTitle(i18n("Divine_beast_mark_text_111"))
	self.fields.Btn_changeElem:addClickEventListener(handler(self, self.onChangeElemClick))
	self.fields.Btn_suit:setTitle(i18n("divine_beast_mark_suit_01"))
	self.fields.Btn_suit:addClickEventListener(handler(self, self.onSuitClick))
	self.fields.Txt_StarTip:setString(i18n("Divine_beast_mark_text_66"))
	self.fields.Com_MC_MarkDetail:setActiveColor(cc.c3b(102, 20, 12))
	self.fields.Button_edit:addClickEventListener(handler(self, self.onClickGroup))
	_UPVALUE5_ = self.fields.Button_edit.addClickEventListener
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[1] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(1)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[2] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(2)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[3] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(3)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[4] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(4)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[5] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(5)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[6] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(6)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[7] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(6)
	_UPVALUE6_, self.fields.Button_edit.addClickEventListener[8] = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(6)
	local _UPVALUE6_, self.fields.Button_edit.addClickEventListener[9], items = divineBeastMarkCtrl:getGroupName(1), divineBeastMarkCtrl:getGroupName(6)
	divineBeastMarkCtrl:getGroupName(1)[1] = 1
	divineBeastMarkCtrl:getGroupName(1)[2] = 2
	divineBeastMarkCtrl:getGroupName(1)[3] = 3
	divineBeastMarkCtrl:getGroupName(1)[4] = 4
	divineBeastMarkCtrl:getGroupName(1)[5] = 5
	local divineBeastMarkCtrl:getGroupName(1)[6], values = 6, divineBeastMarkCtrl:getGroupName(1)
	dump(items, "DivineBeastMarkMainPanel:items")
	_ENV = 4
	;(4).items = items
	;(4).values = values
	;(4).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_menu, 4)
	local dropdown = self.fields.ComboBox_menu:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_menu:fixChildrenPos()
	self.fields.ComboBox_menu:setTitle(i18n("Divine_beast_mark_text_91"))
	self.fields.ComboBox_menu:fixChildrenPos()
	self.fields.Btn_elements:fixPos()
	self.fields.Btn_recount:fixPos()
	self.fields.Btn_bag:fixPos()
	self.fields.Btn_replace:fixPos()
	self.fields.Btn_up:fixPos()
	self.fields.Btn_refine:fixPos()
	self.fields.Btn_exchange:fixPos()
	self.fields.Btn_suit:fixPos()
	self.fields.Btn_illusion:fixPos()
	self.fields.Button_edit:fixPos()
	self.fields.Txt_StarTip:fixPos()
	self.fields.Com_have:fixPos()
	for i = 1, 4 do
		self.fields["Com_MC_MarkElement" .. i]:fixPos()
	end
end
function DivineBeastMarkMainPanel:updateGroupName()
	_UPVALUE5_ = nil
	;(nil)[1] = divineBeastMarkCtrl:getGroupName(1)
	;(nil)[2] = divineBeastMarkCtrl:getGroupName(2)
	;(nil)[3] = divineBeastMarkCtrl:getGroupName(3)
	;(nil)[4] = divineBeastMarkCtrl:getGroupName(4)
	;(nil)[5] = divineBeastMarkCtrl:getGroupName(5)
	;(nil)[6] = divineBeastMarkCtrl:getGroupName(6)
	;(nil)[7] = divineBeastMarkCtrl:getGroupName(6)
	local (nil)[8], items = divineBeastMarkCtrl:getGroupName(6)
	dump(items, "DivineBeastMarkMainPanel:updateGroupName")
	self.fields.ComboBox_menu:setItems(items)
	self.fields.ComboBox_menu:refresh()
	self.showingGroupSetId = divineBeastMarkCtrl:getUseSet(self.beastId)
	dump(self.showingGroupSetId, "self.showingGroupSetId")
	self.fields.ComboBox_menu:setTitle(divineBeastMarkCtrl:getGroupName(self.showingGroupSetId))
end
function DivineBeastMarkMainPanel:onShow()
	print("=======DivineBeastMarkMainPanel:onShow")
	self:updateView()
end
function DivineBeastMarkMainPanel:updateView()
	self.divineBeastData = divineBeastCtrl:getBeastData(self.beastId)
	dump(self.divineBeastData, "self.divineBeastData")
	self.stepLv = self.divineBeastData.stepLv or 0
	divineBeastCtrl = nil
	;(nil).num = self.stepLv
	self.fields.Txt_step:setString(i18n("Divine_beast_text_66", nil))
	if not divineBeastMarkCtrl:getBeastMarkData(self.beastId) then
		divineBeastCtrl = divineBeastMarkCtrl:getBeastMarkData(self.beastId)
	end
	self.beastMarkData = divineBeastMarkCtrl:getBeastMarkData(self.beastId)
	for i = 1, 6 do
		self.fields["Com_MC_MarkBtn" .. i]:initData(self.beastId, self.beastMarkData[i], i, self.stepLv)
		self.fields["Com_MC_MarkBtn" .. i]:setClickCallback(handler(self, self.onMarkClick))
	end
	self:updateElements()
	self:updateCurSlot()
	self:updateExp()
	self:resetComboBoxTitle()
end
function DivineBeastMarkMainPanel:onComboBoxClick()
	SoraDPlaySound()
	local tag = tonumber(self.fields.ComboBox_menu:getValue())
	local name = divineBeastMarkCtrl:getGroupName(tag)
	self.fields.ComboBox_menu:setTitle(divineBeastMarkCtrl:getGroupName(self.showingGroupSetId))
	_ENV = divineBeastMarkCtrl:getGroupName(self.showingGroupSetId)
	divineBeastMarkCtrl:getGroupName(self.showingGroupSetId).name = name
	SoraDShowMsgBoxNew(i18n("Divine_beast_mark_text_92", divineBeastMarkCtrl:getGroupName(self.showingGroupSetId)), i18n("common_text_204"), i18n("common_text_185"), function(type)
		if type == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			divineBeastMarkCtrl:sendUseSet(tag, self.beastId)
		end
	end)
end
function DivineBeastMarkMainPanel:updateElements()
	self.lvsCount = divineBeastMarkCtrl:getElementLvCount(self.beastId)
	dump("self.lvsCount", self.lvsCount)
	for i = 1, 4 do
		self.fields["Com_MC_MarkElement" .. i]:initData(i, self.lvsCount[i], self.beastId)
	end
end
function DivineBeastMarkMainPanel:updateCurSlot()
	self.curSlot = self.curSlot or 1
	self.curMark = self.beastMarkData[self.curSlot] and next(self.beastMarkData[self.curSlot]) and self.beastMarkData[self.curSlot] or nil
	self.controllers.c1:setSelectedIndex(self.curMark == nil and 0 or 1)
	for i = 1, 6 do
		self.fields["Com_MC_MarkBtn" .. i]:setSelected(self.curSlot == i)
	end
	if self.curMark then
		self.fields.Com_MC_MarkDetail:initData(self.curMark, true)
	end
	self:updateBtn()
end
function DivineBeastMarkMainPanel:updateMark(bagMarkId, isIgnoreChange)
	self.beastMarkData = divineBeastMarkCtrl:getBeastMarkData(self.beastId)
	for i = 1, 6 do
		self.fields["Com_MC_MarkBtn" .. i]:initData(self.beastId, self.beastMarkData[i], i, self.stepLv, isIgnoreChange)
	end
	self:updateCurSlot()
end
function DivineBeastMarkMainPanel:resetComboBoxTitle()
	self.showingGroupSetId = divineBeastMarkCtrl:getUseSet(self.beastId)
	dump(self.showingGroupSetId, "self.showingGroupSetId2")
	self.fields.ComboBox_menu:setTitle(divineBeastMarkCtrl:getGroupName(self.showingGroupSetId))
end
function DivineBeastMarkMainPanel:updateExp()
	self.expCount = divineBeastMarkCtrl:getExpCount()
	self.fields.Com_have:setTitle(self.expCount)
	local itemCount = publicUtil.getCount(self.itemID)
	self.fields.Com_MC_Have:setTitle(itemCount)
	self:updateBtn()
end
function DivineBeastMarkMainPanel:updateBtn()
	self.needExp = self.fields.Com_MC_MarkDetail:getUpgradeExp()
	self.haveExp = divineBeastMarkCtrl:getExpCount()
	self.fields.Btn_up:setEnabled(self.needExp ~= 0)
	if self.needExp == 0 then
		self.fields.Btn_up:setFreeTitle(i18n("desretDig_btn_02"), 1)
	else
		self.fields.Btn_up:setFreeTitle(i18n("Divine_beast_mark_text_65"), 1)
	end
	self.fields.Btn_replace:setVisible(self.curMark ~= nil)
	self.fields.Btn_up:setCost2(gIDDef.DIVINE_BEAST_MARK_EXP, self.needExp, self.haveExp)
	self.fields.Txt_StarTip:setVisible(false)
	if self.curMark and self.fields.Com_MC_MarkDetail:getNextLvNeedStar() > self.curMark.star then
		self.fields.Btn_up:setFreeTitle(i18n("Divine_beast_mark_text_65"), 1)
		self.fields.Txt_StarTip:setVisible(true)
	end
	self.visibleBtns, divineBeastMarkCtrl = self.fields.Txt_StarTip.setVisible, self.fields.Txt_StarTip.setVisible
	local randomElem = self.curMark and self.curMark.randomElem or 0
	dump(randomElem, "randomElem")
	local isChangeElemVisible = randomElem ~= 0
	self.fields.Btn_changeElem:setVisible(isChangeElemVisible)
	if isChangeElemVisible then
		table.insert(self.visibleBtns, self.fields.Btn_changeElem)
	end
	local isUpVisible = self.needExp ~= 0 or randomElem == 0
	self.fields.Btn_up:setVisible(isUpVisible)
	if isUpVisible then
		table.insert(self.visibleBtns, self.fields.Btn_up)
	end
	local isRefineVisible = self.curMark and (self.curMark.randomBuff1 ~= 0 or self.curMark.randomBuff2 ~= 0)
	self.fields.Btn_refine:setVisible(isRefineVisible)
	if isRefineVisible then
		table.insert(self.visibleBtns, self.fields.Btn_refine)
	end
	local viewSize = self:getSize()
	local centerX = viewSize.width / 2
	if #self.visibleBtns == 1 then
		self.visibleBtns[1]:setX(centerX)
	elseif #self.visibleBtns == 2 then
		local space = SoraDFIsRA() and 113 or -113
		self.visibleBtns[1]:setX(centerX - space)
		self.visibleBtns[2]:setX(centerX + space)
	elseif #self.visibleBtns == 3 then
		local space = SoraDFIsRA() and 206 or -206
		self.visibleBtns[1]:setX(centerX - space)
		self.visibleBtns[2]:setX(centerX)
		self.visibleBtns[3]:setX(centerX + space)
	end
	local isHaveQualityLvReward = divineBeastMarkCtrl:getIsHaveQualityLvReward(self.beastId)
	dump(isHaveQualityLvReward, "isHaveQualityLvReward")
	self.fields.Btn_suit:setReddot(isHaveQualityLvReward)
end
function DivineBeastMarkMainPanel:onGetItem()
	SoraDPlaySound()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653)
	if eventState ~= gActivityState.OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	else
		_ENV = i18n("common_text_2486")
		_UPVALUE1_, i18n("common_text_2486").id = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653, gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653
		i18n("common_text_2486").items, gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653[1] = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653, gIDDef.DIVINE_BEAST_MARK_ENERGY
		i18n("common_text_2486").clickTips = i18n("Divine_beast_mark_text_78")
		uiManager:show("ActExchangePageNew", i18n("common_text_2486")):setOwnerKey(self)
	end
end
function DivineBeastMarkMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).beastId = self.beastId
	uiManager:show("DivineBeastRule", nil)
end
function DivineBeastMarkMainPanel:onElementsClick(sender)
	_ENV = nil
	;(nil).beastId = self.beastId
	uiManager:show("DivineBeastMarkElement", nil)
end
function DivineBeastMarkMainPanel:onBagClick(sender)
	SoraDPlaySound()
	uiManager:show("DivineBeastMarkBag")
end
function DivineBeastMarkMainPanel:onRecountClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).beastId = self.beastId
	uiManager:show("DivineBeastMarkRecount", nil)
end
function DivineBeastMarkMainPanel:onReplaceClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).beastId = self.beastId
	;(nil).slot = self.curSlot
	uiManager:show("DivineBeastMarkEquip", nil)
end
function DivineBeastMarkMainPanel:onUpgradeClick(sender)
	SoraDPlaySound()
	if self.fields.Com_MC_MarkDetail:getNextLvNeedStar() > self.curMark.star then
		_ENV = nil
		;(nil).mark = self.curMark
		uiManager:show("DivineBeastMarkStar", nil)
		return
	end
	if self.haveExp < self.needExp then
		_ENV = nil
		;(nil).itemID = self.itemID2
		uiManager:show("CommonSourceGuide", nil)
		return
	end
	divineBeastMarkCtrl:sendUpgrade(self.curMark.bagMarkId)
end
function DivineBeastMarkMainPanel:onRefineClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).mark = self.curMark
	uiManager:show("DivineBeastMarkRefine", nil)
end
function DivineBeastMarkMainPanel:onIllusionClick(sender)
	SoraDPlaySound()
	uiManager:show("DivineBeastMarkIllusion")
end
function DivineBeastMarkMainPanel:onSuitClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).beastId = self.beastId
	uiManager:show("DivineBeastMarkSuit", nil)
end
function DivineBeastMarkMainPanel:onChangeElemClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).bagMarkId = self.curMark.bagMarkId
	uiManager:show("DivineBeastMarkElementSwitch", nil)
end
function DivineBeastMarkMainPanel:onExchangeClick(sender)
	SoraDPlaySound()
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).defaultClick = 2
	uiManager:show("BeastCanyonExchange", nil)
end
function DivineBeastMarkMainPanel:onMarkClick(slot)
	self.curSlot = slot
	self:updateCurSlot()
end
function DivineBeastMarkMainPanel:onClickGroup()
	SoraDPlaySound()
	_ENV = nil
	;(nil).beastId = self.beastId
	uiManager:show("DivineBeastMarkGroup", nil)
end
function DivineBeastMarkMainPanel:gameGuide_getTarget(itemName, parameters)
	_UPVALUE2_ = nil
	;(nil)[1] = self.fields[itemName]
	;(nil)[2] = itemName
	dump(nil, "gameGuide_getTarget")
	if itemName == "Com_MC_MarkBtn1" then
		if self.fields.Com_MC_MarkBtn1:isLocked() or self.fields.Com_MC_MarkBtn1.mark ~= nil then
			_ENV = self.fields.Com_MC_MarkBtn1
			self.fields.Com_MC_MarkBtn1.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(self.fields.Com_MC_MarkBtn1)
			return
		end
		return self.fields.Com_MC_MarkBtn1
	end
	return self.fields[itemName]
end
return DivineBeastMarkMainPanel
