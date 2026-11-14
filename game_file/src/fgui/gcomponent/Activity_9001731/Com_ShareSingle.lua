local baseComponent = require("fgui.base.baseComponent")
local Com_ShareSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_ShareSingle", Com_ShareSingle)
function Com_ShareSingle:onInit()
	self:fixChildrenPos()
end
function Com_ShareSingle:onShow()
end
function Com_ShareSingle:initData(data)
	self.fields.Com_head:setVisible(false)
	self.fields.icon:setVisible(true)
	if data.channel == gChatChannel.KINGDOM then
		self.fields.icon:setSpriteFrame("icon_position_world.png")
		self.fields.title:setString(i18n("common_text_070"))
	elseif data.channel == gChatChannel.ALLIANCE then
		self.fields.icon:setSpriteFrame("icon_position_alliance.png")
		self.fields.title:setString(i18n("common_text_946"))
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
