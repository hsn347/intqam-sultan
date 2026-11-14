local c = cc
local _ENV, ui
function makeUIControl_(control)
	cc(control)
	control:addComponent("components.ui.LayoutProtocol"):exportMethods()
	control:addComponent("components.behavior.EventProtocol"):exportMethods()
	control:setCascadeOpacityEnabled(true)
	control:setCascadeColorEnabled(true)
	control:addNodeEventListener(c.NODE_EVENT, function(event)
		if event.name == "cleanup" then
			control:removeAllEventListeners()
		end
	end)
end
ui.TEXT_ALIGN_LEFT = cc.TEXT_ALIGNMENT_LEFT
ui.TEXT_ALIGN_CENTER = cc.TEXT_ALIGNMENT_CENTER
ui.TEXT_ALIGN_RIGHT = cc.TEXT_ALIGNMENT_RIGHT
ui.TEXT_VALIGN_TOP = cc.VERTICAL_TEXT_ALIGNMENT_TOP
ui.TEXT_VALIGN_CENTER = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
ui.TEXT_VALIGN_BOTTOM = cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM
ui.UIGroup = requireLocal(".UIGroup")
ui.UIImage = requireLocal(".UIImage")
ui.UIPushButton = requireLocal(".UIPushButton")
ui.UICheckBoxButton = requireLocal(".UICheckBoxButton")
ui.UICheckBoxButtonGroup = requireLocal(".UICheckBoxButtonGroup")
ui.UIInput = requireLocal(".UIInput")
ui.UILabel = requireLocal(".UILabel")
ui.UISlider = requireLocal(".UISlider")
ui.UIBoxLayout = requireLocal(".UIBoxLayout")
ui.UIScrollView = requireLocal(".UIScrollView")
ui.UIListView = requireLocal(".UIListView")
ui.UIPageView = requireLocal(".UIPageView")
ui.UILoadingBar = requireLocal(".UILoadingBar")
return ui
