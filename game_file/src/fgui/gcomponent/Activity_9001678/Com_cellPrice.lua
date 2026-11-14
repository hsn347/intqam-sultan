local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_cellPrice = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001678/Com_cellPrice", Com_cellPrice)
function Com_cellPrice:onInit()
	self:fixChildrenPos()
end
function Com_cellPrice:onShow()
end
function Com_cellPrice:initData(id, price, oriprice)
	local isDis = price ~= oriprice
	self.controllers.c1:setSelectedIndex(isDis and 1 or 0)
	self.fields.Text_cur:setPositionY(isDis and 27 or 15)
	self.fields.Icon_gold:setSpriteFrame(publicRead.getIcon(id))
	self.fields.Text_cur:setString(price)
	self.fields.Text_ori:setString(oriprice)
end
return Com_cellPrice
