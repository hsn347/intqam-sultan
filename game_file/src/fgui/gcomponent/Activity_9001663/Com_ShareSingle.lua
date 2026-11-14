local baseComponent = require("fgui.base.baseComponent")
local Com_ShareSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001663/Com_ShareSingle", Com_ShareSingle)
function Com_ShareSingle:onInit()
	self.isSel = false
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_ShareSingle:onShow()
end
function Com_ShareSingle:initData(data, handle)
	self.data = data
	self.handle = handle
	self.fields.Com_head:setVisible(false)
	self.fields.icon:setVisible(true)
	self.fields.Check_tick:setSelected(self.isSel)
	if data.channel == gChatChannel.ALLIANCE then
		self.fields.icon:setSpriteFrame("icon_position_alliance.png")
		self.fields.title:setString(i18n("common_text_946"))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.icon:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.title:setString(data.name)
	end
end
function Com_ShareSingle:btnClick()
	SoraDPlaySound()
	self.isSel = not self.isSel
	self.fields.Check_tick:setSelected(self.isSel)
	if self.handle then
		self.handle(self.data, self.isSel)
	end
end
return Com_ShareSingle
