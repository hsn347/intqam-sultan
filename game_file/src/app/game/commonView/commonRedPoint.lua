local commonRedPoint = class("commonRedPoint", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonRedPoint")
	end
	return target
end)
function commonRedPoint:ctor()
	self.Text_redPointInt = SoraDGetChildByName(self, "Text_redPointInt")
end
function commonRedPoint:updateRedPoint(count)
	self:setVisible(count ~= 0)
	if 0 < count then
		self.Text_redPointInt:setString(tostring(count))
	end
end
return commonRedPoint
