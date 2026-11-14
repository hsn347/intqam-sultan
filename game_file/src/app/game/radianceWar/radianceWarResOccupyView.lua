local gametop = gModuleMgr.getObject("gametop")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local radianceWarRead = include("radianceWarRead")
local radianceWarUtil = include("radianceWarUtil")
local radianceWarResOccupyView = class("radianceWarResOccupyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("radianceWarResOccupyView")
	end
	return target
end)
function radianceWarResOccupyView:ctor()
	self.occupyData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch")
	self.collSpeed = 0
	self.alreadyCollCount = 0
	self.canMaxWeight = 0
	self.allTime = 0
	self.currentAllCollCount = 0
	self.timer = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.imgRes = SoraDGetChildByName(self, "Image_res")
	self.imgRes:setScale(0.7)
	self.imgRes:ignoreContentAdaptWithSize(true)
	self.txtCollSpeed = SoraDGetChildByName(self, "Text_collectSpeed")
	self.txtAddColl = SoraDGetChildByName(self, "Text_additionCollect")
	self.imgBg = SoraDGetChildByName(self, "Image_frmBg")
	self.txtAllianceOwnerTip = SoraDGetChildByName(self, "Text_allianceOwnerTip")
	self.imgJump = SoraDGetChildByName(self, "Image_jump")
	self.txtBelongAlliance = SoraDGetChildByName(self, "Text_allianceOwner")
	self.txtArmyNum = SoraDGetChildByName(self, "Text_army")
	self.txtPlayerName = SoraDGetChildByName(self, "Text_collectPerson")
	self.imgAdditionBg = SoraDGetChildByName(self, "Image_additionBg")
	self.imgAlreadyBg = SoraDGetChildByName(self, "Image_alreadyBg")
	self.nodeSpeed = SoraDGetChildByName(self, "Node_speed")
	_G.SoraDChangeTextToHtml(self.txtBelongAlliance)
	self.txtBelongAlliance:setTouchEnabled(true)
	self.txtBelongAlliance:addTouchEventListener(handler(self, self.btnClickText))
	SoraDGetChildByName(self, "Text_collectSpeedTip"):setString(i18n("common_text_572"))
	_ENV = i18n("common_text_572")
	i18n("common_text_572").num = ""
	self.txtAllianceOwnerTip:setString(i18n("brightWar_text_86", i18n("common_text_572")))
	SoraDGetChildByName(self, "Text_collectPersonTip"):setString(i18n("common_text_2909"))
	self.txtPlayerName:setString(i18n("common_text_480"))
	self.txtCollSpeed:setString("0/h")
end
function radianceWarResOccupyView:initData(reData)
