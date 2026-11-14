local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local alliancePBLMarkView = class("alliancePBLMarkView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLMarkView")
	end
	return target
end)
function alliancePBLMarkView:ctor()
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.layerCut = SoraDGetChildByName(self, "Panel_cut")
	self.labelBlock = SoraDGetChildByName(self, "Text_block")
	self.labelDes1 = SoraDGetChildByName(self, "Text_des_1")
	self.labelDes2 = SoraDGetChildByName(self, "Text_des_2")
	self.btnClose = SoraDGetChildByName(self, "Button_close")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.bg1 = SoraDGetChildByName(self, "image_bg_sp")
	self.bg2 = SoraDGetChildByName(self, "image_bg_sp_2")
	self.labelName = SoraDGetChildByName(SoraDGetChildByName(self, "Node_51"), "Text_name")
	self.btnClose:setTitleText(i18n("common_text_204"))
	self:bindBtnClose()
	self:initData()
end
function alliancePBLMarkView:initData()
	local ownMarkData = pyramidWarCtrl:getOwnMark()
	if not ownMarkData then
		return
	end
	allianceDesRead.getFlagWithParticle(ownMarkData.flag, self.nodeFlag)
	if ownMarkData.battleSeasonType == gSeasonType.PINNACLE_SEASON then
		self.nodeBg:setTitleName(i18n("peakRace_text_101"))
		self.labelDes1:setString(i18n("pyramid_text_69"))
		self.labelDes2:setString(i18n("pyramid_text_74"))
		if ownMarkData.pinnacleCompetitionGroup > 0 then
			pyramidWarCtrl = i18n("pyramid_text_74")
			i18n("pyramid_text_74").num = ownMarkData.pinnacleCompetitionGroup
			i18n("pyramid_text_74").name = pyramidWarltCtrl.getGroupName(ownMarkData.pinnacleCompetitionGroup)
			self.labelBlock:setString(i18n("pyramid_text_70", i18n("pyramid_text_74")))
		elseif 0 < ownMarkData.pinnacleArea then
			pyramidWarCtrl = i18n("pyramid_text_70", i18n("pyramid_text_74"))
			i18n("pyramid_text_70", i18n("pyramid_text_74")).num = ownMarkData.pinnacleArea
			i18n("pyramid_text_70", i18n("pyramid_text_74")).name = pyramidWarltCtrl.getGroupName(ownMarkData.pinnacleBreakoutGroup)
			self.labelBlock:setString(i18n("pyramid_text_70", i18n("pyramid_text_70", i18n("pyramid_text_74"))))
		end
	else
		self.nodeBg:setTitleName(i18n("regularSeason_text_101"))
		self.labelDes1:setString(i18n("regularSeason_text_102"))
		self.labelDes2:setString(i18n("regularSeason_text_103"))
		self.labelBlock:setVisible(false)
	end
	pyramidWarCtrl = false
	;(false).abbr = ownMarkData.abbr or i18n("common_text_480")
	;(false).name = ownMarkData.legionName or i18n("common_text_480")
	local name = i18n("common_text_186", false)
	self.labelName:setString(name)
end
return alliancePBLMarkView
