local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local wargemltCtrl = include("warGemltCtrl")
local warGemltCtrl = wargemltCtrl
local buildLogic = include("buildLogic")
local wargemResRead = include("wargemResRead")
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainInfoSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainInfoSingle", WarGemMainInfoSingle)
function WarGemMainInfoSingle:onInit()
	self:addClickListener(handler(self, self.onClickSelf))
	self.fields.Text_invalid:setString(i18n("gem_text_04"))
end
function WarGemMainInfoSingle:onClickSelf()
	SoraDPlaySound()
	if not self.unlock then
		_ENV = nil
		;(nil).level = self.lv
		SoraDShowMsgTip(i18n("common_text_3881", nil))
		return
	end
	_ENV = i18n("common_text_3881", nil)
	i18n("common_text_3881", nil).lv = self.lv
	i18n("common_text_3881", nil).idx = self.idx
	uiManager:show("WarGemHoleDetail", i18n("common_text_3881", nil))
end
function WarGemMainInfoSingle:onShow()
end
function WarGemMainInfoSingle:initData(lv, idx)
	self.lv = lv
	self.idx = idx
end
function WarGemMainInfoSingle:setValid(value)
	self.valid = value
end
function WarGemMainInfoSingle:updateView()
	local lv = self.lv
	local idx = self.idx
	local buildLv = SoraDGetBuildLv(BUILDID.MIRACLE)
	local isWarLv, warLv = buildLogic.isBuildWarLv(buildLv)
	local unlock = isWarLv and warLv >= self.lv
	self.unlock = unlock
	if not self.unlock then
		self.fields.Hole:initData(lv, idx)
		self.controllers.c1:setSelectedIndex(3)
		return
	end
	local changes = wargemltCtrl:getGemHoleChange(lv, idx)
	self.fields.Image_change:setVisible(0 < #changes)
	local isUp = false
	if not self.valid then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Text_invalid:setString(i18n("gem_text_04"))
		self.fields.Hole:setGem(0)
	else
		self.fields.Hole:initData(lv, idx)
		local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), lv, idx)
		if gemID and 0 < gemID then
			isUp = warGemCtrl:isCurPanelActive() and warGemCtrl:canGemComposite(gemID, true)
			self.controllers.c1:setSelectedIndex(0)
			self.fields.Text_attr:setString(wargemResRead.getAttrByID(gemID))
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	end
	self.fields.Effect_arrow:setVisible(isUp)
end
function WarGemMainInfoSingle:playChangColor()
	self.fields.Hole:playChangeColor()
end
function WarGemMainInfoSingle:playInlay()
	self.fields.Hole:playInlay()
end
function WarGemMainInfoSingle:getImageChange()
	return self.fields.Image_change
end
function WarGemMainInfoSingle:hasGem()
	local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), self.lv, self.idx)
	return gemID and 0 < gemID
end
function WarGemMainInfoSingle:getBg()
	return self.fields.Hole
end
return WarGemMainInfoSingle
