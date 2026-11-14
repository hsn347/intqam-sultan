local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_icon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_icon", com_Meteorite_icon)
local meteorMagicRead = include("meteorMagicRead")
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
function com_Meteorite_icon:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self:addClickEventListener(handler(self, self.onCliecked))
end
function com_Meteorite_icon:onShow()
end
function com_Meteorite_icon:setConfig(config)
	self.config = config
	self.fields.icon:setURL(config.icon)
	self.fields.title:setString(i18n(config.name))
end
function com_Meteorite_icon:setData(data, curProjectID)
	self.curProjectID = curProjectID
	self.data = data
	self.costNum = meteorMagicCtrl:getCostByLight(data and data.light, self.config.idGroup)
	self.fields.cost:setString(self.costNum)
	local isActive = meteorMagicCtrl:getIsActiveType(curProjectID, self.config.type)
	self.fields.active:setVisible(isActive)
	if isActive then
		self.fields.active:setAllFrameName("dh_Tex_XL_xwzb03_0%02d.png", 0)
		self.fields.active:setPlaySettings(0, -1, 0)
		local lang = SoraDGetDefaultLanguage()
		_UPVALUE2_ = -1
		;(-1)[1] = "ar"
		;(-1)[2] = "en"
		spName = SoraDGetImageNameByLang("framer_yxmn_active_%s.png", -1)
		self.fields.active_lan:setURL(spName)
	end
	self.fields.active_lan:setVisible(isActive)
end
function com_Meteorite_icon:onCliecked(sender, params)
	SoraDPlaySound()
	_ENV = nil
	;(nil).config = self.config
	;(nil).curProjectID = self.curProjectID
	uiManager:show("MeteoriteTalents", nil)
end
return com_Meteorite_icon
