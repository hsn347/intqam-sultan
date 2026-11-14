local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001702_have = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_9001702_have", Com_9001702_have)
function Com_9001702_have:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_9001702_have:onShow()
end
function Com_9001702_have:initItemID(itemID)
	self.itemID = itemID
	local itemName = publicRead.getName(self.itemID)
	publicRead = nil
	;(nil).item = itemName
	self.fields.Text_name:setString(i18n("Eidal_celebration_text_32", nil))
	local iconName = publicRead.getIcon(self.itemID)
	self.fields.icon:setURL(iconName)
	self:updateNum()
end
function Com_9001702_have:updateNum()
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	backpackCtrl = nil
	;(nil).num = itemCount
	self.fields.title:setString(i18n("Eidal_celebration_text_29", nil))
end
return Com_9001702_have
