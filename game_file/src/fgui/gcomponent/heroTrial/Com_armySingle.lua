local baseComponent = require("fgui.base.baseComponent")
local Com_armySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_armySingle", Com_armySingle)
function Com_armySingle:onInit()
	self:fixChildrenPos()
end
function Com_armySingle:onShow()
end
function Com_armySingle:initData(data)
	self.fields.Com_army:initData(data.battleItemId)
	self.fields.Text_js:setString(data.kill)
	self.fields.Text_ch:setString(data.survive)
	self.fields.Text_ss:setString(data.lost)
end
return Com_armySingle
