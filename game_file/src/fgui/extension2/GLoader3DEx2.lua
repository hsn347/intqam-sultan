local m = fgui.GLoader3D
local _setVisible = m.setVisible
function m:setVisible(value)
	_setVisible(self, value)
	local _content = self:getContent()
	if _content ~= nil then
		_content:setVisible(value)
	end
end
function m:addChild(child)
	self:setContent(child)
end
function m:getChildByName(name)
	local _content = self:getContent()
	if _content ~= nil then
		if _content:getName() == name then
			return _content
		end
		return nil
	end
end
