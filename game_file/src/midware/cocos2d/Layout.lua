local Layout = class("Layout", cc.Node)
function Layout:create()
	local obj = Layout.new()
	obj:autoRelease()
	obj.isLayout = true
	obj:setPosition(0, 0)
	return obj
end
return Layout
