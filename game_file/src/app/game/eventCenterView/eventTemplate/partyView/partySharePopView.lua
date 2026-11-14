local gametop = gModuleMgr.getObject("gametop")
local partyCtrl = gametop.playertop_:getModule("partyCtrl")
local partyltCtrl = include("partyltCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local partySharePopView = class("partySharePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("partySharePopView")
	end
	return target
end)
function partySharePopView:ctor()
	self.isKingdom = true
	self.isAlliance = false
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.isJoinAlliance = allianceMgr:hasJoinAlliance()
	self:initControls()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTY_OPENBACK", handler(self, self.showMyParty))
end
function partySharePopView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.txtAlliance = SoraDGetChildByName(self, "text_alliance")
	self.txtKingdom = SoraDGetChildByName(self, "text_kingdom")
	self.btnCancel = SoraDGetChildByName(self, "btn_cancel")
	self.btnConfirm = SoraDGetChildByName(self, "btn_confirm")
	self.btncheckAlliance = SoraDGetChildByName(self, "CheckBox_alliance")
	self.btncheckAlliance:setSelected(false)
	self.btncheckKingdom = SoraDGetChildByName(self, "CheckBox_kingdom")
	self.btncheckKingdom:setSelected(true)
	self.btnCancel:addTouchEventListener(handler(self, self.buttonCancelClick))
	self.btncheckKingdom:addEventListener(handler(self, self.buttonClickKindom))
	self.panel:setPositionY(display.height / 2)
	self.btnConfirm:setTitleText(i18n("common_text_204"))
	self.btnCancel:setTitleText(i18n("common_text_185"))
	if not self.isJoinAlliance then
		self.btncheckAlliance:setVisible(false)
	else
		self.btncheckAlliance:addEventListener(handler(self, self.buttonClickAlliance))
	end
	self:updateSelect()
end
function partySharePopView:showMyParty()
	print("partySharePopView111", self.isKingdom, self.isAlliance)
	partyCtrl:sendInviteParty(self.isKingdom, self.isAlliance)
	local feastPanel = SoraDCreatePanel("partyFeastListView"):show()
	local partyData = partyltCtrl:getPartyData()
	feastPanel:initData(partyData.myOpenParty.partyID)
	self:closePanel()
end
function partySharePopView:initData(target, index)
	if index == 0 then
		self.btnConfirm:addTouchEventListener(handler(self, self.buttonConfirmClick_2))
		self.txtTitle:setString(i18n("feast_text_18"))
		self.txtAlliance:setString(i18n("common_text_1487"))
		self.txtKingdom:setString(i18n("common_text_1486"))
	else
		local data = require_data("feastattribute", true).data
		self.btnConfirm:addTouchEventListener(handler(self, self.buttonConfirmClick))
		self.partyCreateView = target
		self.feastLv = index
		_ENV = handler(self, self.buttonConfirmClick)
		handler(self, self.buttonConfirmClick).feast = i18n(data[index].FeastName)
		self.txtTitle:setString(i18n("feast_text_37", handler(self, self.buttonConfirmClick)))
		self.txtAlliance:setString(i18n("common_text_1487"))
		self.txtKingdom:setString(i18n("common_text_1486"))
	end
end
function partySharePopView:updateSelect()
	self.btncheckKingdom:setTouchEnabled(true)
	self.btncheckAlliance:setTouchEnabled(true)
	if self.isKingdom == true and self.isAlliance == false then
		self.btncheckKingdom:setTouchEnabled(false)
		self.btncheckAlliance:setTouchEnabled(true)
		return
	end
	if self.isKingdom == false and self.isAlliance == true then
		self.btncheckKingdom:setTouchEnabled(true)
		self.btncheckAlliance:setTouchEnabled(false)
		return
	end
end
function partySharePopView:buttonConfirmClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		partyCtrl:sendOpenParty(self.feastLv)
	end
end
function partySharePopView:buttonConfirmClick_2(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local partyCtrl = gametop.playertop_:getModule("partyCtrl")
		print("partySharePopView222", self.isKingdom, self.isAlliance)
		partyCtrl:sendInviteParty(self.isKingdom, self.isAlliance)
		self:closePanel()
	end
end
function partySharePopView:buttonCancelClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
function partySharePopView:buttonClickAlliance(button, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.isAlliance = true
		print("self.isAlliance 1", self.isAlliance)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self.isAlliance = false
		print("self.isAlliance 2", self.isAlliance)
	end
	self:updateSelect()
end
function partySharePopView:buttonClickKindom(button, eventType)
	print("buttonClickKindom", eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.isKingdom = true
		print("self.isKingdom 1", self.isKingdom)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self.isKingdom = false
		print("self.isKingdom 2", self.isKingdom)
	end
	self:updateSelect()
end
return partySharePopView
