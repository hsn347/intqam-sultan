local baseComponent = require("fgui.base.baseComponent")
local Com_bubble = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ActivityGameTest/Com_bubble", Com_bubble)
function Com_bubble:onInit()
	self.colorType = 1
	self.dir = cc.p(0, 0)
	self.speed = 1000
	self.isSelect = false
	self.isConnect = false
	self.tilePos = cc.p(0, 0)
end
function Com_bubble:onShow()
end
function Com_bubble:setDir(dir)
	self.dir = dir
end
function Com_bubble:getDir(...)
	return self.dir
end
function Com_bubble:getSpeed(...)
	return self.speed
end
function Com_bubble:reset(...)
	self:setIsSelect(false)
	self:setIsConnect(false)
end
function Com_bubble:initData(data)
	self:setColorType(data.colorType)
	self.tilePos = cc.p(data.x, data.y)
	self.fields.Text_pos:setString(self.tilePos.x .. "," .. self.tilePos.y)
end
function Com_bubble:setColorType(colorType)
	self.colorType = colorType
	self.controllers.c1:setSelectedIndex(self.colorType)
end
function Com_bubble:getColorType(...)
	return self.colorType
end
function Com_bubble:checkSameColor(colorType)
	return self.colorType == colorType
end
function Com_bubble:getTilePos(...)
	return self.tilePos
end
function Com_bubble:setIsSelect(isSelect)
	self.isSelect = isSelect
	if isSelect then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
end
function Com_bubble:getIsSelect(...)
	return self.isSelect
end
function Com_bubble:setIsConnect(isConnect)
	self.isConnect = isConnect
end
function Com_bubble:getIsConnect(...)
	return self.isConnect
end
return Com_bubble
