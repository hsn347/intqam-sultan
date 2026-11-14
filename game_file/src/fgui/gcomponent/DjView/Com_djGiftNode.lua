local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_djGiftNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_djGiftNode", Com_djGiftNode)
function Com_djGiftNode:onInit()
	self.isInAct = false
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_djGiftNode:onShow()
end
function Com_djGiftNode:initData(data)
	self.fields.icon:setURL(publicRead.getIcon(data.itemID))
	self.fields.Text_num:setString("X" .. data.count)
	self.fields.Text_name:setString(data.nickName)
	publicRead = publicRead.getIcon(data.itemID)
	publicRead.getIcon(data.itemID).name = ""
	publicRead.getIcon(data.itemID).item = fguiHelper.getColorString("#E2C53D", publicRead.getName(data.itemID))
	self.fields.Text_des:setString(i18n("Anchor_text_97", publicRead.getIcon(data.itemID)))
end
return Com_djGiftNode
