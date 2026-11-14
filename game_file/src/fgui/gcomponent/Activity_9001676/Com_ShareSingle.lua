local baseComponent = require("fgui.base.baseComponent")
local Com_ShareSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001676/Com_ShareSingle", Com_ShareSingle)
function Com_ShareSingle:onInit()
	self:fixChildrenPos()
	self:addClickEventListener(handler(self, self.onItemClicked))
end
function Com_ShareSingle:onShow()
end
function Com_ShareSingle:initData(data, index, isSelected)
	self.isSelected = not not isSelected
	self:setSelected(isSelected)
	self.clickIndex = index
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
function Com_ShareSingle:setItemClickCallback(callback)
	self.itemClickCallback = callback
end
function Com_ShareSingle:onItemClicked()
	SoraDPlaySound()
	self.isSelected = not self.isSelected
	if self.itemClickCallback then
		self.itemClickCallback(self.clickIndex, self.isSelected)
	end
end
return Com_ShareSingle
