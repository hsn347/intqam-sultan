local PanelView = fgui.extension_class("PanelView", fgui.GComponent)
fgui.register_extension("ui://Base/PanelView", PanelView)
function PanelView:ctor()
end
function PanelView:create()
	local ret = fgui.UIPackage.CreateObject1("Base", "PanelView")
	ret.isCocos = true
	ret:setPosition(0, 0)
	return ret
end
function PanelView:addChild(child, ...)
	fgui.GComponent.addChild(self, child, ...)
end
return PanelView
