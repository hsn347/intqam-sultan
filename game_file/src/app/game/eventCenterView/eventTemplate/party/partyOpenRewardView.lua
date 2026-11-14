local gametop = gModuleMgr.getObject("gametop")
local partyCtrl = SoraDGetCtrl("partyCtrl", gametop)
local partyltCtrl = include("partyltCtrl")
local FAD = require_data("feastattribute", true)
local partyOpenRewardView = class("partyOpenRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("partyRewardView")
	end
	return target
end)
function partyOpenRewardView:ctor()
	self:initControls()
	self:initPanel()
end
function partyOpenRewardView:initControls()
	SoraDGetChildByName(self, "Panel_cut"):setVisible(false)
	SoraDGetChildByName(self, "Panel_cut_extra"):setVisible(false)
	self.panelOpen = SoraDGetChildByName(self, "Panel_mycut")
	self.rewaed_node = SoraDGetChildByName(self.panelOpen, "reward_node")
end
function partyOpenRewardView:initPanel()
	self.tableReward, _ENV = nil, nil
	self.txtTitle = SoraDGetChildByName(self.panelOpen, "text_tips")
	self.btnConfirm = SoraDGetChildByName(self.panelOpen, "btn_confirm")
	self.btnConfirm:addTouchEventListener(handler(self, self.buttonConfirmClick))
	self.panelOpen:setPosition(cc.p(320, display.height / 2))
	self.btnConfirm:setTitleText(i18n("common_text_854"))
	self.rewardPoints = SoraDGetChildByName(self.panelOpen, "text_points")
	self.txtMainTitle = SoraDGetChildByName(self.panelOpen, "text_title")
	self.txtMainTitle:setString(i18n("feast_text_52"))
end
function partyOpenRewardView:initData(feastData)
	self.feastData = feastData
	local FARD = require_data("feast_set_reward", true).data
	local attrData = require_data("feastattribute", true).data
	local totalNum = 0
	for k, v in pairs(feastData.uidListInfo) do
		totalNum = totalNum + 1
	end
	local _ENV, totalData = (for generator), pairs(feastData.uidListInfo)
	for i, v in ipairs(FARD) do
		if v.FeastLevel == feastData.partyLv then
			table.insert(totalData, v)
		end
	end
	dump(totalData, "技术的开发和技术")
	self.rewardPoints:setString(i18n("feast_text_54") .. totalData[1].Point)
	local rewards
	for i, v in ipairs(totalData) do
		if v.Section[1] ~= v.Section[2] then
			if totalNum >= v.Section[1] and totalNum <= v.Section[2] then
				_UPVALUE2_ = nil
				;(nil)[1] = "rewardId"
				;(nil)[2] = "rewardNum"
				rewards = serviceFunctions.tableFormat(v.Reward, nil)
			end
		elseif totalNum == v.Section[1] then
			_UPVALUE2_ = nil
			;(nil)[1] = "rewardId"
			;(nil)[2] = "rewardNum"
			rewards = serviceFunctions.tableFormat(v.Reward, nil)
		end
	end
	_ENV = table.insert
	table.insert.num = totalNum
	table.insert.feast = i18n(attrData[feastData.partyLv].FeastName)
	self.txtTitle:setString(i18n("feast_text_38", table.insert))
	for i = 1, #rewards do
		local singleItem = include("itemSingleView").new()
		singleItem:setRechargeUse(true)
		singleItem:sendParentToButton(self)
		singleItem:setScale(0.8)
		singleItem:addTo(self.rewaed_node)
		self.tableReward[i] = singleItem
		if i < 5 then
			singleItem:setPosition(cc.p(130 * (i - 1) - 255, -15))
		else
			singleItem:setPosition(cc.p(130 * (i - 5) - 255, -150))
		end
		singleItem:setButtonTag(rewards[i].rewardId)
		singleItem:initRechargeForRewardData(rewards[i].rewardId, rewards[i].rewardNum)
	end
end
function partyOpenRewardView:buttonConfirmClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		partyCtrl:sendGetOpenPartyRewards(self.feastData.partyID)
		self:closePanel()
	end
end
function partyOpenRewardView:showGetRewardAnimation(rewardlist)
	local _ENV, listItem
	for i = 1, #rewardlist - 1, 2 do
		listItem[tostring(rewardlist[i])] = rewardlist[i + 1]
	end
	SoraDMailGainItems(listItem)
	self:removeFromParent()
end
return partyOpenRewardView
