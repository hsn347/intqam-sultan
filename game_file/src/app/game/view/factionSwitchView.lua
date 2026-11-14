local factionCtrl = SoraDGetCtrl("factionCtrl")
local factionSwitchView = class("factionSwitchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("factionSwitchView")
	end
	return target
end)
function factionSwitchView:ctor()
	self:initControls()
end
function factionSwitchView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.imageBzt = SoraDGetChildByName(self, "image_bzt")
	self.imageFrameBzt = SoraDGetChildByName(self, "frame_bzt")
	self.imageFrameSultan = SoraDGetChildByName(self, "frame_sultan")
	self.panelShadow = SoraDGetChildByName(self, "panel_shadow")
	self.imageSultan = SoraDGetChildByName(self, "image_sultan")
	self.txtBzt = SoraDGetChildByName(self, "text_bzt")
	self.txtSultan = SoraDGetChildByName(self, "text_sultan")
	self.txtSwitch = SoraDGetChildByName(self, "text_switch")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.nodeTitle:setTitle(i18n("civilization_system_text_04"))
	self.txtSwitch:setString(i18n("civilization_system_text_04"))
	self.txtBzt:setString(i18n("civilization_system_text_05"))
	self.txtSultan:setString(i18n("civilization_system_text_06"))
	self.btnSwitch = SoraDGetChildByName(self, "button_downSwitch")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.bg:setFillType(1)
	self.nodeTitle:setLocalZOrder(10)
	if SoraDGetDefaultLanguage() == "vi" or SoraDGetDefaultLanguage() == "ja" then
		self.txtBzt:setFontSize(18)
		self.txtSultan:setFontSize(18)
	end
	self.btnSwitch:addTouchEventListener(handler(self, self.buttonSwitchClick))
	self.btnQuest:addTouchEventListener(handler(self, self.buttonQuestClick))
	util.addTouch(self.imageBzt, handlerEx(self, self.buttonFactionClick, FACTION_TYPE.FACTION_BYZANTINE), false, nil, util.hitAlphaTest)
	util.addTouch(self.imageSultan, handlerEx(self, self.buttonFactionClick, FACTION_TYPE.FACTION_NORMAL), false, nil, util.hitAlphaTest)
	self.newFaction = factionCtrl:getFactionId()
	if self.newFaction == FACTION_TYPE.FACTION_NORMAL then
		self:initData(FACTION_TYPE.FACTION_BYZANTINE)
		self.newFaction = FACTION_TYPE.FACTION_BYZANTINE
	elseif self.newFaction == FACTION_TYPE.FACTION_BYZANTINE then
		self:initData(FACTION_TYPE.FACTION_NORMAL)
		self.newFaction = FACTION_TYPE.FACTION_NORMAL
	end
	self.panelShadow:setContentSize(cc.size(display.width, display.height))
	self.panelShadow:setPositionY(-display.height)
	self.imageBzt:setPositionY(-display.height / 2)
	self.imageSultan:setPositionY(-display.height / 2)
	if display.height < 960 then
		self.imageFrameSultan:setPositionY(self.imageFrameSultan:getPositionY() + 100)
		self.txtSultan:setPositionY(self.txtSultan:getPositionY() + 100)
		self.imageFrameBzt:setPositionY(self.imageFrameBzt:getPositionY() - 80)
		self.txtBzt:setPositionY(self.txtBzt:getPositionY() - 80)
	end
end
function factionSwitchView:init()
end
function factionSwitchView:initData(factionType)
	if type(factionType) ~= "number" then
		return
	end
	if factionType == FACTION_TYPE.FACTION_NORMAL then
		self.imageFrameSultan:setSpriteFrame("frame_qhwm1.png")
		self.imageFrameBzt:setSpriteFrame("frame_qhwm2.png")
		self.imageBzt:setLocalZOrder(1)
		self.imageSultan:setLocalZOrder(3)
	elseif factionType == FACTION_TYPE.FACTION_BYZANTINE then
		self.imageFrameSultan:setSpriteFrame("frame_qhwm2.png")
		self.imageFrameBzt:setSpriteFrame("frame_qhwm1.png")
		self.imageBzt:setLocalZOrder(3)
		self.imageSultan:setLocalZOrder(1)
	end
	self.imageFrameBzt:setTouchEnabled(false)
	self.imageBzt:setTouchEnabled(false)
	self.imageSultan.listener:setEnabled(factionType ~= FACTION_TYPE.FACTION_NORMAL)
	self.imageBzt.listener:setEnabled(factionType ~= FACTION_TYPE.FACTION_BYZANTINE)
	local curFaction = factionCtrl:getFactionId()
	self.btnSwitch:setColor(curFaction ~= factionType and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	self.txtSwitch:setColor(curFaction ~= factionType and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	self.btnSwitch:setEnabled(curFaction ~= factionType)
	self.panelShadow:setLocalZOrder(2)
end
function factionSwitchView:buttonQuestClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.FACTION_SWITCH)
	end
end
function factionSwitchView:buttonFactionClick(factionType, button, eventType, pos)
	if eventType == ccui.TouchEventType.ended then
		if self.newFaction == factionType then
			return
		end
		SoraDPlaySound()
		self.newFaction = factionType
		self:initData(self.newFaction)
	end
end
function factionSwitchView:buttonSwitchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).eventargs = self.newFaction
		userSDKManager.logEvent(gSDKDef.TDonEvent.faction_switch, nil)
		factionCtrl:switchFactionType(self.newFaction)
		self:removeFromParent()
	end
end
function factionSwitchView:onExitPanel()
	util.delTouch(self.imageBzt)
	util.delTouch(self.imageSultan)
end
return factionSwitchView
