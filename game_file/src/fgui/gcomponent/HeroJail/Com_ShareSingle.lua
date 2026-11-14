local baseComponent = require("fgui.base.baseComponent")
local Com_ShareSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroJail/Com_ShareSingle", Com_ShareSingle)
function Com_ShareSingle:onInit()
	self:fixChildrenPos()
end
function Com_ShareSingle:onShow()
end
function Com_ShareSingle:initData(data)
	self.fields.Com_head:setVisible(false)
	self.fields.icon:setVisible(true)
	if data.channel == 1 or data.channel == 2 then
		self.fields.icon:setURL(data.channel == 1 and "icon_position_world.png" or "icon_position_alliance.png")
		self.fields.title:setString(data.channel == 1 and i18n("common_text_070") or i18n("common_text_946"))
	elseif data.crid then
		self.fields.title:setString(data.crName)
		self.fields.icon:setURL("icon_position_chat.png")
	else
		self.fields.Com_head:setVisible(true)
		self.fields.icon:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.title:setString(data.name)
	end
end
function Com_ShareSingle:isTickSelect()
	return self.fields.Check_tick:isSelected()
end
return Com_ShareSingle
