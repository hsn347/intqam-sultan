local baseComponent = require("fgui.base.baseComponent")
local Com_pre = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaAllStarWar/Com_pre", Com_pre)
function Com_pre:onInit()
	self:fixChildrenPos()
end
function Com_pre:onShow()
end
function Com_pre:setPreStr(str)
	self.fields.Text_pre:setString(str)
end
function Com_pre:setIcon(icon)
	self.fields.icon:setSpriteFrame(icon)
end
function Com_pre:setTitle(str)
	self.fields.title:setString(str)
end
return Com_pre
