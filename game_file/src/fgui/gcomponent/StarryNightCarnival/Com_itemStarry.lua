local constantRead = include("constantRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemStarry = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Com_itemStarry", Com_itemStarry)
function Com_itemStarry:onInit()
	if SoraDGetDefaultLanguage == "ar" then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self.itemID = constantRead.getConstValue("STARLIT_NIGHT_REQ_ITEM", 847201)
	self.fields.title:setString(publicRead.getName(self.itemID))
	self.fields.icon:setURL(publicRead.getIcon(self.itemID))
	self:initData()
end
function Com_itemStarry:initData()
	self.fields.Text_num:setString(backpackCtrl:getItemCount(self.itemID))
end
function Com_itemStarry:onShow()
end
return Com_itemStarry
