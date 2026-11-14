local UIScrollView = fgui.extension_class("UIScrollView", fgui.GComponent)
fgui.register_extension("ui://Base/UIScrollView", UIScrollView)
function UIScrollView:create()
	local scrollView = fgui.UIPackage.CreateObject1("Base", "UIScrollView")
	scrollView._isIgnorTrainsGuide = true
	scrollView:setName("Layout")
	scrollView.isCocos = true
	scrollView:setPosition(0, 0)
	return scrollView
end
function UIScrollView:setContentSize(size)
	self:SetSize(size.width, size.height)
	local scrollPane = self:getScrollPane()
	local width = scrollPane:getContentWidth()
	local height = scrollPane:getContentWidth()
	if width < size.width or height < size.height then
		scrollPane:setContentSize(width, height)
	end
end
return UIScrollView
