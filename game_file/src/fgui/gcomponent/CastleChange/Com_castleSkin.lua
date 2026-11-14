local castleSkinRead = include("castleSkinRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_castleSkin = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/Com_castleSkin", Com_castleSkin)
function Com_castleSkin:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_castleSkin:onShow()
end
function Com_castleSkin:initData(data, listData)
	self.tag = data.index
	self.listData = listData
	self.controllers.c1:setSelectedIndex(data.data.isOwn and 1 or 0)
	self.fields.icon:setSpriteFrame(castleSkinRead.getIconBySubType(data.subType))
	local skinQuality = castleSkinRead.getSkinQualityBySubType(data.subType)
	local skinQualityCfg = castleSkinRead.getSkinQualityCfg(skinQuality)
	if skinQualityCfg then
		self.fields.icon_tag:setVisible(true)
		self.fields.icon_tag:setSpriteFrame(SoraDFIsRA() and skinQualityCfg.ar or skinQualityCfg.en)
	else
		self.fields.icon_tag:setVisible(false)
	end
end
function Com_castleSkin:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).listData = self.listData
	;(nil).selIndex = self.tag
	uiManager:show("castleChangeDetailView", nil)
end
return Com_castleSkin
