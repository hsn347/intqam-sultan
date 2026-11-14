local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local christmasTreeSharePopView = class("christmasTreeSharePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("christmasTreeSharePopView")
	end
	return target
end)
function christmasTreeSharePopView:ctor()
	self:initControls()
end
function christmasTreeSharePopView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.txtAlliance = SoraDGetChildByName(self, "text_alliance")
	self.txtKingdom = SoraDGetChildByName(self, "text_kingdom")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.btnShare = SoraDGetChildByName(self, "btn_confirm")
	self.btncheckAlliance = SoraDGetChildByName(self, "CheckBox_alliance")
	self.btncheckKingdom = SoraDGetChildByName(self, "CheckBox_kingdom")
	self.panel:setPositionY(display.height / 2)
	self.txtAlliance:setString(i18n("common_text_1487"))
	self.txtKingdom:setString(i18n("common_text_1486"))
	self.txtTitle:setString(i18n("common_text_533"))
	self.btnShare:setTitleText(i18n("common_text_533"))
	self.btnShare:addTouchEventListener(handler(self, self.btnShareClick))
	self.btncheckKingdom:addEventListener(handler(self, self.buttonClickKindom))
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.isJoinAlliance = allianceMgr:hasJoinAlliance()
	if not self.isJoinAlliance then
		self.btncheckAlliance:setVisible(false)
	else
		self.btncheckAlliance:addEventListener(handler(self, self.buttonClickAlliance))
	end
	self.isKingdom = false
	self.isAlliance = false
end
function christmasTreeSharePopView:buttonClickAlliance(button, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.isAlliance = true
		print("self.isAlliance 1", self.isAlliance)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self.isAlliance = false
		print("self.isAlliance 2", self.isAlliance)
	end
	self.btncheckAlliance:setSelected(self.isAlliance)
	self.btncheckKingdom:setSelected(false)
	self.btncheckKingdom:setEnabled(true)
	self.btncheckAlliance:setEnabled(false)
	self.btnShare:setTag(1)
end
function christmasTreeSharePopView:buttonClickKindom(button, eventType)
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
	self.btncheckAlliance:setSelected(false)
	self.btncheckKingdom:setSelected(self.isKingdom)
	self.btncheckKingdom:setEnabled(false)
	self.btncheckAlliance:setEnabled(true)
	self.btnShare:setTag(2)
end
function christmasTreeSharePopView:btnShareClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		christmasTreeCtrl:sendTreeShareMsg(button:getTag(), 851801)
		self:removeFromParent()
	end
end
return christmasTreeSharePopView
