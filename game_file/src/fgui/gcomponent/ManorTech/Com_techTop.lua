local manorTechRead = include("manorTechRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_techTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorTech/Com_techTop", Com_techTop)
function Com_techTop:onInit()
	self.techType = "manor"
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
end
function Com_techTop:onShow()
end
function Com_techTop:initData(techID)
	self.techID = techID
	local tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
	local tableSingleDetails = technologyCtrl:getTechnologyDetails(self.techID, tableSingleData.currentLevel)
	self.fields.tech:initShow(self.techID, true)
	local cfg = manorTechRead.getTechShowCfg(self.techID)
	self.fields.Text_name:setString(i18n(cfg.techDes))
	local isToMax = tableSingleData.currentLevel >= tableSingleData.maxLevel
	technologyCtrl = i18n(cfg.techDes)
	i18n(cfg.techDes).val = tableSingleDetails.currentLevelEffect
	self.fields.Text_curLv:setString(i18n("flames_dunes_text77", i18n(cfg.techDes)))
	self.fields.Text_lv:setVisible(not isToMax)
	self.fields.arrow:setVisible(not isToMax)
	self.fields.Text_toLv:setVisible(not isToMax)
	if isToMax then
		self.fields.Text_nextLv:setString("")
	else
		technologyCtrl = i18n("flames_dunes_text77", i18n(cfg.techDes))
		i18n("flames_dunes_text77", i18n(cfg.techDes)).val = tableSingleDetails.nextLevelEffect
		self.fields.Text_nextLv:setString(i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes))))
		technologyCtrl = i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes)))
		i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes))).lv = tableSingleData.currentLevel
		self.fields.Text_lv:setString(i18n("common_text_277", i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes)))))
		self.fields.Text_toLv:setString(tableSingleData.currentLevel + 1)
	end
end
return Com_techTop
