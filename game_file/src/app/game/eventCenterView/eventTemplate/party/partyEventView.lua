local gametop = gModuleMgr.getObject("gametop")
local partyltCtrl = include("partyltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local partyCtrl = gametop.playertop_:getModule("partyCtrl")
local partyEventView = class("partyEventView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("partyEventView")
	end
	return target
end)
function partyEventView:ctor()
	self:initView()
	self:initEvent()
end
function partyEventView:initView()
	self.tableReward, _ENV = nil, nil
	self.panel = SoraDGetChildByName(self, "Panel_1")
	self.bg_feast = self.panel:getChildByName("bg_feast")
	self.material_node = self.panel:getChildByName("material_node")
	self.text_title = SoraDGetChildByName(self.panel, "text_title")
	self.text_infos = SoraDGetChildByName(self.panel, "text_infos")
	self.text_tip = SoraDGetChildByName(self.panel, "text_tip")
	self.text_rewards = SoraDGetChildByName(self.panel, "text_rewards")
	self.node_reward = SoraDGetChildByName(self.panel, "reward_node")
	self.btn_Cancel = SoraDGetChildByName(self.panel, "btn_cancel")
	self.btn_Keep = SoraDGetChildByName(self.panel, "btn_keep")
	self.btn_Confirm = SoraDGetChildByName(self.panel, "btn_confirm")
	self.text_title:setString(i18n("feast_text_50"))
	self.btn_Cancel:setTitleText(i18n("common_text_091"))
	self.btn_Keep:setTitleText(i18n("feast_text_28"))
	self.text_tip:setString(i18n("feast_text_51"))
	SoraDSetTextWidthHeight(self.text_tip, cc.size(500, 60))
	SoraDSetTextWidthHeight(self.text_title, cc.size(200, 60))
	self.panel:setPositionY(display.height / 2)
	SoraDAutoSizeButtonText(self.btn_Keep, cc.size(100, 60))
end
function partyEventView:initEvent()
	self.btn_Cancel:addTouchEventListener(handler(self, self.clickEventCancelBtn))
	self.btn_Keep:addTouchEventListener(handler(self, self.clickEventKeepBtn))
	self.btn_Confirm:addTouchEventListener(handler(self, self.clickEventConfirmBtn))
end
function partyEventView:initData(info, partyID, isNotAttend)
	self.btn_Confirm:setTag(info.sEvent)
	self.btn_Keep:setTag(info.sEvent)
	self.btn_Cancel:setTag(info.sEvent)
	self.partyID = partyID
	self.FARD = require_data("feast_attend_reward", true).data
	self.feastData = partyltCtrl.getFeastInfoById(self.partyID)
	self.isNotAttend = isNotAttend
	if info.sEvent == gSpecialEventType.EVENT_MATERIAL then
		self.event = true
		self.btn_Confirm:setTitleText(i18n("christmas_stocking_text_04"))
		self.bg_feast:setSpriteFrame("bg_feast_05.png")
		_ENV = i18n("christmas_stocking_text_04")
		i18n("christmas_stocking_text_04").name = self.feastData.nickName
		self.text_infos:setString(i18n("feast_text_23", i18n("christmas_stocking_text_04")))
	end
	if info.sEvent == gSpecialEventType.EVENT_BANDIT then
		self.event = false
		self.btn_Confirm:setTitleText(i18n("common_text_370"))
		self.bg_feast:setSpriteFrame("bg_feast_04.png")
		self.text_infos:setString(i18n("feast_text_25"))
		self.bg_feast:setPositionY(self.bg_feast:getPositionY() + 30)
	end
	backpackCtrl = self.bg_feast:getPositionY() + 30
	;(self.bg_feast:getPositionY() + 30)[1] = "rewardId"
	;(self.bg_feast:getPositionY() + 30)[2] = "rewardNum"
	local sEventParam = serviceFunctions.tableFormat(info.sEventParam, self.bg_feast:getPositionY() + 30)
	if info.sEvent == gSpecialEventType.EVENT_MATERIAL then
		for i, v in ipairs(sEventParam) do
			local single = SoraDCreatePanel("eventGeocentricCell")
			single:initData(v.rewardId, v.rewardNum)
			single:setClickDelegate(handler(self, self.singleCellClick))
			single:setPosition(cc.p((i - 1) * 80 - 190, -30))
			single:sendParentToButton(self)
			single:setScale(0.68)
			local itemCount = backpackCtrl:getItemCount(v.rewardId)
			single:setPosition(cc.p(-50, -30))
			single.frameBG:setVisible(true)
			single.txtNum:setString(itemCount .. "/" .. v.rewardNum)
			single.txtNum:setColor(itemCount >= v.rewardNum and cc.c3b(0, 255, 0) or cc.c3b(255, 0, 0))
			single:addTo(self.material_node)
		end
	end
	self.sEventParam = sEventParam
	if info.sEvent == gSpecialEventType.EVENT_MATERIAL or info.sEvent == gSpecialEventType.EVENT_BANDIT then
		backpackCtrl = self.feastData.partyLv
		self.feastData.partyLv[1] = "rewardId"
		self.feastData.partyLv[2] = "rewardNum"
		local materialReward = serviceFunctions.tableFormat(self.FARD[self.feastData.partyLv].ExtraReward, self.feastData.partyLv)
		for i, v in ipairs(materialReward) do
			local single = SoraDCreatePanel("eventGeocentricCell")
			single:initData(v.rewardId, v.rewardNum)
			single:setClickDelegate(handler(self, self.singleCellClick))
			if #materialReward == 4 then
				single:setPosition(cc.p((i - 1) * 80 - 150, -30))
			else
				single:setPosition(cc.p((i - 1) * 80 - 190, -30))
			end
			single:sendParentToButton(self)
			single:setScale(0.68)
			single:addTo(self.node_reward)
		end
	end
	self.text_rewards:setString(i18n("feast_text_41") .. self.FARD[self.feastData.partyLv].ExtraPoint)
end
function partyEventView:singleCellClick(pItem)
end
function partyEventView:clickEventConfirmBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target:getTag() == gSpecialEventType.EVENT_MATERIAL then
			local itemCount = backpackCtrl:getItemCount(self.sEventParam[1].rewardId)
			if itemCount < self.sEventParam[1].rewardNum then
				SoraDShowMsgTip(i18n("common_text_1379"))
				return
			end
			partyCtrl:sendCommitMaterial(false, self.partyID)
		elseif target:getTag() == gSpecialEventType.EVENT_BANDIT then
			_ENV = false
			;(false).req4partyFight = true
			;(false).partyID = self.partyID
			uiManager:show("ArenaTeamSetView", false)
		end
		self:closePanel()
	end
end
function partyEventView:clickEventKeepBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target:getTag() == gSpecialEventType.EVENT_MATERIAL or target:getTag() == gSpecialEventType.EVENT_BANDIT then
			if self.keppCallback then
				self.keppCallback()
			else
				self:closePanel()
			end
		end
	end
end
function partyEventView:setKeppCallback(callback)
	self.keppCallback = callback
end
function partyEventView:clickEventCancelBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target:getTag() == gSpecialEventType.EVENT_MATERIAL then
			partyCtrl:sendCommitMaterial(true, self.partyID)
		elseif target:getTag() == gSpecialEventType.EVENT_BANDIT then
			partyCtrl:sendAttackBandit(true, self.partyID)
		end
		self:closePanel()
	end
end
function partyEventView:onExitPanel()
	local partyCtrl = SoraDGetCtrl("partyCtrl")
	if self.isNotAttend then
		partyCtrl:sendPartyUserList()
	else
		partyCtrl:sendCheckPartyCenter()
	end
end
return partyEventView
