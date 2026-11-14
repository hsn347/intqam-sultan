local necklaceTechRead = include("necklaceTechRead")
local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local baseComponent = require("fgui.base.baseComponent")
local techSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/techSingle", techSingle)
function techSingle:onInit()
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function techSingle:onShow()
end
function techSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
end
function techSingle:init(technologyID)
	self.techID = technologyID
	local cfg = necklaceTechRead.getTechShowCfg(technologyID)
	self.fields.Image_icon:setURL(cfg.techIcon)
	self.fields.Image_techBg:setURL(cfg.techBase)
	self.fields.Text_name:setString(i18n(cfg.techName))
end
function techSingle:initData()
	self:updateView()
end
function techSingle:initShow(technologyID, showLv)
	self:init(technologyID)
	local tData = necklaceTecCtrl:getTechnoDataByID(technologyID)
	self.controllers.c2:setSelectedIndex(tData.isOpened and 1 or 0)
	if showLv then
		local curLv = tData.currentLevel or 0
		local maxLv = tData.maxLevel
		necklaceTecCtrl = nil
		;(nil).lv1 = curLv
		;(nil).lv2 = maxLv
		self.fields.Text_lv:setString(i18n("garden_text_13", nil))
		self.fields.Text_lv:setColor(curLv >= maxLv and cc.c3b(112, 199, 35) or cc.c3b(240, 230, 210))
	end
end
function techSingle:getTechID()
	return self.techID
end
function techSingle:updateView()
	self.tableSingleData = necklaceTecCtrl:getTechnoDataByID(self.techID)
	local curLv = self.tableSingleData.currentLevel or 0
	local maxLv = self.tableSingleData.maxLevel
	necklaceTecCtrl = nil
	;(nil).lv1 = curLv
	;(nil).lv2 = maxLv
	self.fields.Text_lv:setString(i18n("garden_text_13", nil))
	if self.tableSingleData and self.tableSingleData.isOpened then
		self.controllers.c2:setSelectedIndex(1)
		self:updateOtherUI()
	else
		self.controllers.c2:setSelectedIndex(0)
	end
end
function techSingle:updateOtherUI()
	local curLv = self.tableSingleData.currentLevel or 0
	local maxLv = self.tableSingleData.maxLevel
	local labelColor = curLv >= maxLv and cc.c3b(112, 199, 35) or cc.c3b(240, 230, 210)
	self.fields.Text_name:setColor(labelColor)
	self.fields.Text_lv:setColor(labelColor)
end
function techSingle:btnClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("neckTechDetail", nil)
end
return techSingle
