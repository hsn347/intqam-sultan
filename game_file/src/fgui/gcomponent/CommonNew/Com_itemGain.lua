local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemGain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_itemGain", Com_itemGain)
function Com_itemGain:onInit()
	self.fields.Text_rate:setVisible(false)
end
function Com_itemGain:onShow()
end
function Com_itemGain:initData(data)
	self.fields.Text_rate:setVisible(false)
	if data.rate then
		self.fields.Text_rate:setVisible(true)
		self.fields.Text_rate:setString("x" .. data.rate)
	end
	self.fields.item:initData(tonumber(data.iid), data.itemCount)
end
return Com_itemGain
