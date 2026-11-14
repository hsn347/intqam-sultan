local BaseComponent = class("BaseComponent", fgui.GComponent)
function BaseComponent:ctor()
end
function BaseComponent:create()
	local ret = cc.Node.CreateNode()
	return ret
end
return BaseComponent
