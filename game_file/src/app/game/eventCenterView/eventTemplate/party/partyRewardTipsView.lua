local partyltCtrl = include("partyltCtrl")
local FAD = require_data("feastattribute", true)
local partyRewardTipsView = class("partyRewardTipsView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("partyRewardTipsView")
	end
	return target
end)
function partyRewardTipsView:ctor()
	self:initControls()
end
function partyRewardTipsView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.textCheck = SoraDGetChildByName(self, "text_check")
	SoraDSetTextWidthHeight(self.textCheck, cc.size(300, 60))
	self.feastTips = SoraDGetChildByName(self, "feast_tips")
	self.btnCancel = SoraDGetChildByName(self, "btn_cancel")
	self.btnConfirm = SoraDGetChildByName(self, "btn_confirm")
	self.btnCheckBox = SoraDGetChildByName(self, "CheckBox_dayCheck")
	self.btnConfirm:addTouchEventListener(handler(self, self.buttonConfirmClick))
	self.btnCancel:addTouchEventListener(handler(self, self.buttonCancelClick))
	self.btnCheckBox:addTouchEventListener(handler(self, self.buttonClickClick))
	self.panel:setPositionY(display.height / 2)
	self.txtTitle:setString(i18n("feast_text_18"))
	self.textCheck:setString(i18n("feast_text_22"))
	self.btnConfirm:setTitleText(i18n("common_text_204"))
	self.btnCancel:setTitleText(i18n("common_text_185"))
	self.feastTips:setString(i18n("feast_text_21"))
end
function partyRewardTipsView:initData(feastID, selectIndex)
	self.feastID = feastID
	self.selectIndex = selectIndex
	local FARD = require_data("feast_attend_reward", true)
	local feastData = partyltCtrl.getFeastInfoById(self.feastID)
	local rewardData = FARD.data[feastData.partyLv]
	local baseData = FAD.data[feastData.partyLv]
	local feastName = i18n(baseData.FeastName)
	_ENV = nil
	;(nil).name = feastData.nickName
	;(nil).point = rewardData.Point
	;(nil).feast = feastName
	self.txtTitle:setString(i18n("feast_text_20", nil))
	local totalNum = math.floor(table.nums(rewardData.Reward) / 2)
	for i = 1, 5 do
		local index = i * 2 - 1
		FAD = i18n("feast_text_20", nil)
		i18n("feast_text_20", nil)[1] = rewardData.Reward[index]
		local i18n("feast_text_20", nil)[2], rewardInfo = rewardData.Reward[index + 1], i18n("feast_text_20", nil)
		if rewardInfo[1] then
			local singleItem = include("itemSingleView").new()
			singleItem:setRechargeUse(true)
			singleItem:setButtonTag(rewardInfo[1])
			singleItem:sendParentToButton(self)
			singleItem:setScale(0.6)
			singleItem:addTo(self.panel)
			if totalNum == 4 then
				singleItem:setPosition(cc.p(100 * (i - 1) + 75, 380))
			else
				singleItem:setPosition(cc.p(100 * (i - 1) + 20, 380))
			end
			_ENV = singleItem.setPosition
			singleItem.setPosition.id = rewardInfo[1]
			local singleItem.setPosition.count, itemInfo = rewardInfo[2], singleItem.setPosition
			_ENV = cc.p(100 * (i - 1) + 20, 380)
			cc.p(100 * (i - 1) + 20, 380).itemData = itemInfo
			singleItem:initData(cc.p(100 * (i - 1) + 20, 380))
		end
	end
end
function partyRewardTipsView:buttonConfirmClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local partyCtrl = gametop.playertop_:getModule("partyCtrl")
		partyltCtrl.setSkipRewardTipsCheck(self.isSkipTips)
		partyCtrl:sendAttendParty(self.feastID, self.selectIndex)
		self:closePanel()
	end
end
function partyRewardTipsView:buttonCancelClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function partyRewardTipsView:buttonClickClick(button, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		self.isSkipTips = true
		SoraDPlaySound()
	elseif eventType == ccui.CheckBoxEventType.unselected then
		self.isSkipTips = false
		SoraDPlaySound()
	end
end
return partyRewardTipsView
