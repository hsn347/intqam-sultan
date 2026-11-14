local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_listExtra = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_listExtra", Com_listExtra)
function Com_listExtra:onInit()
	self:fixChildrenPos()
end
function Com_listExtra:onShow()
end
function Com_listExtra:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 0)
	local item = data.rewards[1]
	self.fields.Com_item:initData(item.id, item.count)
	self.fields.Text_name:setString(publicRead.getName(item.id))
	self.fields.Text_num:setString("x" .. item.count)
end
return Com_listExtra
