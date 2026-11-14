local necklaceTechRead = include("necklaceTechRead")
local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_techTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_techTop", Com_techTop)
function Com_techTop:onInit()
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 0 or 180)
end
function Com_techTop:onShow()
end
function Com_techTop:initData(techID)
	self.techID = techID
	local tableSingleData = necklaceTecCtrl:getTechnoDataByID(self.techID)
	self.fields.tech:initShow(self.techID, true)
	local cfg = necklaceTechRead.getTechCfg(self.techID)
	self.fields.Text_name:setString(i18n(cfg.techDes))
	local curLv = tableSingleData.currentLevel
	local maxLv = tableSingleData.maxLevel
	local isToMax = curLv >= maxLv
	local curAttr = "0%"
	if 0 < curLv then
		local attribute = necklaceTechRead.getTechAttribute(self.techID, curLv)
		curAttr = attribute[2] / 10 .. "%"
	end
	necklaceTecCtrl = i18n(cfg.techDes)
	i18n(cfg.techDes).val = curAttr
	self.fields.Text_curLv:setString(i18n("flames_dunes_text77", i18n(cfg.techDes)))
	self.fields.Text_lv:setVisible(not isToMax)
	self.fields.arrow:setVisible(not isToMax)
	self.fields.Text_toLv:setVisible(not isToMax)
	if isToMax then
		self.fields.Text_nextLv:setString("")
	else
		local nextAttr = necklaceTechRead.getTechAttribute(self.techID, curLv + 1)
		necklaceTecCtrl = i18n("flames_dunes_text77", i18n(cfg.techDes))
		i18n("flames_dunes_text77", i18n(cfg.techDes)).val = nextAttr[2] / 10 .. "%"
		self.fields.Text_nextLv:setString(i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes))))
		necklaceTecCtrl = i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes)))
		i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes))).lv = curLv
		self.fields.Text_lv:setString(i18n("common_text_277", i18n("flames_dunes_text78", i18n("flames_dunes_text77", i18n(cfg.techDes)))))
		self.fields.Text_toLv:setString(curLv + 1)
	end
end
return Com_techTop
