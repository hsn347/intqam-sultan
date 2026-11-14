local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001642/Com_reward", Com_reward)
function Com_reward:onInit()
	self:fixChildrenPos()
end
function Com_reward:onShow()
end
function Com_reward:initData(data, index)
	self.fields.Image_light:setVisible(index % 2 == 0)
	self.fields.Com_item:initData(data.id)
	self.fields.Text_name:setString(publicRead.getName(data.id))
	self.fields.Text_count:setString("x" .. data.count)
end
return Com_reward
