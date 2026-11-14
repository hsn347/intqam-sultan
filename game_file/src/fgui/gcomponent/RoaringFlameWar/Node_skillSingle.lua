local baseComponent = require("fgui.base.baseComponent")
local Node_skillSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Node_skillSingle", Node_skillSingle)
function Node_skillSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Node_skillSingle:onShow()
end
function Node_skillSingle:initData(data, warType)
	self.data = data
	self.warType = warType
	self.fields.Image_skill:setSpriteFrame(data.img)
	local qConfig = gAtlantisQualityConfig[data.quality]
	self.fields.Image_quality:setSpriteFrame(qConfig.qImage)
	self.fields.Text_skill:setString(i18n(data.name))
	self.fields.Text_skill:setColor(qConfig.color)
end
function Node_skillSingle:btnClick()
	SoraDPlaySound()
	if self.warType == gKingdomClassType.atlantis then
		local panel = SoraDCreatePanel("atlantisSkillDetail")
		panel:initData(self.data.skillID)
		panel:show()
	else
		_ENV = self.data.skillID
		self.data.skillID.skillId = self.data.skillID
		uiManager:show("RoaringFlame_SkillDetail", self.data.skillID)
	end
end
return Node_skillSingle
