local partyltCtrl = include("partyltCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local FAD = require_data("feastattribute", true)
local partyRewardView = class("partyRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("partyRewardView")
	end
	return target
end)
function partyRewardView:ctor()
	self:initControls()
end
function partyRewardView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.panelExtra = SoraDGetChildByName(self, "Panel_cut_extra")
	self.panelOpen = SoraDGetChildByName(self, "Panel_mycut")
	self.rewaed_node = SoraDGetChildByName(self.panel, "reward_node")
	self.ext_rewaed_node = SoraDGetChildByName(self.panelExtra, "extra_reward_node")
end
function partyRewardView:initPanel(panel)
	self.txtTitle = SoraDGetChildByName(panel, "text_tips")
	self.txtTitle:setString(i18n("feast_text_26"))
	self.rewardExtraTips = SoraDGetChildByName(panel, "reward_extra_tips")
	SoraDSetTextWidthHeight(self.rewardExtraTips, cc.size(500, 60))
	self.centerPanel = SoraDGetChildByName(self, "Center_Node")
	self.btnConfirm = SoraDGetChildByName(panel, "btn_confirm")
	self.btnConfirm:addTouchEventListener(handler(self, self.buttonConfirmClick))
	panel:setPosition(cc.p(320, display.height / 2))
	self.centerPanel:setPositionY(display.height / 2)
	self.btnConfirm:setTitleText(i18n("common_text_854"))
	if self.rewardExtraTips then
		self.rewardExtraTips:setString(i18n("feast_text_27"))
	end
	self.txtExPoint = SoraDGetChildByName(panel, "text_points_ex")
	self.txtMainTitle = SoraDGetChildByName(panel, "text_title")
	SoraDSetTextWidthHeight(self.txtMainTitle, cc.size(100, 60))
	self.txtMainTitle:setFontSize(18)
	self.txtPoint = SoraDGetChildByName(panel, "text_points")
end
function partyRewardView:initData(info, isNotAttend)
	local FARD = require_data("feast_attend_reward", true)
	local feastData = info.feastInfo
	local rewardInfo = FARD.data[feastData.partyLv]
	local baseData = FAD.data[feastData.partyLv]
	local feastName = i18n(baseData.FeastName)
	self.partyID = feastData.partyID
	self.isNotAttend = isNotAttend
	self.isTiredEvent = false
	local ownUUID = lordInfoCtrl:getLordInfo().base.uid
	if feastData.uidListInfo[tostring(ownUUID)] and feastData.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_TIRED then
		self.isTiredEvent = true
	end
	local panel = self.panel
	if info.eventReward then
		panel = self.panelExtra
	end
	self:initPanel(panel)
	if self.txtExPoint then
		self.txtExPoint:setString(i18n("feast_text_41") .. rewardInfo.ExtraPoint)
	end
	if self.txtMainTitle then
		self.txtMainTitle:setString(i18n("feast_text_52"))
	end
	if self.txtPoint then
		self.txtPoint:setString(i18n("feast_text_54") .. rewardInfo.Point)
	end
	_ENV = i18n("feast_text_52")
	i18n("feast_text_52").name = feastData.nickName
	i18n("feast_text_52").feast = feastName
	self.txtTitle:setString(i18n("feast_text_39", i18n("feast_text_52")))
	self.panelExtra:setVisible(panel == self.panelExtra)
	self.panel:setVisible(panel == self.panel)
	panel:setPositionY(display.height / 2)
	local rewardNode = panel:getChildByName("reward_node")
	for k, v in ipairs(info.commonReward) do
		local singleItem = include("itemSingleView").new()
		singleItem:setRechargeUse(true)
		singleItem:sendParentToButton(self)
		singleItem:setScale(0.6)
		singleItem:addTo(rewardNode)
		singleItem:setButtonTag(v.id)
		if table.nums(info.commonReward) == 4 then
			singleItem:setPosition(cc.p(110 * (k - 1) - 212, -15))
		else
			singleItem:setPosition(cc.p(110 * (k - 1) - 272, -15))
		end
		singleItem:initRechargeForRewardData(v.id, v.num)
	end
	if self.isTiredEvent then
		self.rewardExtraTips:setString(i18n("feast_text_24"))
	end
	if info.eventReward then
		local rewardExtraNode = panel:getChildByName("extra_reward_node")
		for k, v in ipairs(info.eventReward) do
			local singleItem = include("itemSingleView").new()
			singleItem:setRechargeUse(true)
			singleItem:sendParentToButton(self)
			singleItem:setScale(0.6)
			singleItem:addTo(rewardExtraNode)
			singleItem:setButtonTag(v.id)
			if table.nums(info.commonReward) == 4 then
				singleItem:setPosition(cc.p(110 * (k - 1) - 212, -15))
			else
				singleItem:setPosition(cc.p(110 * (k - 1) - 272, -15))
			end
			singleItem:initRechargeForRewardData(v.id, v.num)
		end
	end
	if info.attackBanditResult ~= nil then
		self:showFightResultAni(info.attackBanditResult, panel)
	end
end
function partyRewardView:showFightResultAni(isWin, panel)
	local actionNode = SoraDGetChildByName(self, "Node_action")
	local node
	if isWin then
		node = SoraDCreatAnimation("animationCommonWarWin", nil, false)
		node:setPositionY(-40)
		panel:setPositionY(display.height / 2 - 90)
	else
		node = SoraDCreatAnimation("animationKingWarLose", nil, false)
		node:setPositionY(-60)
	end
	if node then
		node:setLocalZOrder(10)
		actionNode:addChild(node)
	end
	SoraDPlaySound("innerbuildsound", 106)
end
function partyRewardView:buttonConfirmClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local partyCtrl = SoraDGetCtrl("partyCtrl")
		local partyData = partyCtrl:getPartyData()
		partyCtrl:sendGetAttendPartyRewards(self.partyID)
		self.partyPanel = SoraDSearchPanelFromManagerByName("partyView")
		if self.partyPanel ~= nil then
			SoraDRemoveAllAfterPanelFromManager(self.partyPanel, true)
		else
			self:closePanel()
		end
	end
end
function partyRewardView:onExitPanel()
	local partyCtrl = SoraDGetCtrl("partyCtrl")
	print("金黄色的开婚纱店", self.isNotAttend)
	if self.isNotAttend then
		partyCtrl:sendPartyUserList()
	else
		partyCtrl:sendCheckPartyCenter()
	end
end
return partyRewardView
