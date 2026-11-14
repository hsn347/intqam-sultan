local ContainerScrollView = class("ContainerScrollView", function(target)
	return target
end)
function ContainerScrollView:ctor()
end
function ContainerScrollView:init(limitWidth, limitHieght, w, h, createCell, updateCell)
	self.createCell = createCell
	self.updateCell = updateCell
	self.limitWidth = limitWidth
	self.limitHieght = limitHieght
	self.spaceW = w
	self.spaceH = h
end
function ContainerScrollView:insert(data, index)
end
function ContainerScrollView:delete(index)
end
function ContainerScrollView:layout(index)
end
