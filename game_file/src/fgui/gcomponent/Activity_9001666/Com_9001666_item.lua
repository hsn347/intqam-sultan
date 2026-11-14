local baseComponent = require("fgui.base.baseComponent")
local Com_9001666_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001666/Com_9001666_item", Com_9001666_item)
function Com_9001666_item:onInit()
	_UPVALUE2_ = nil
	_UPVALUE2_, self.monsters, (nil)[1] = nil, nil, "xuedijzg01_dj_%02d.png"
	_UPVALUE2_, self.monsters, (nil)[2] = nil, nil, "xuedijzg02_dj_%02d.png"
	self.monsterUIs, (nil)[1] = nil, self.fields.monster1
	self.monsterUIs, (nil)[2] = nil, self.fields.monster2
end
function Com_9001666_item:onShow()
end
function Com_9001666_item:initData(itemType, round)
	self.itemType = itemType
	self.round = round
	self.controllers.c1:setSelectedIndex(itemType - 1)
	if itemType == 3 then
		local rd = math.random(1, 2)
		self.monsterUIs[1]:setVisible(false)
		self.monsterUIs[2]:setVisible(false)
		self.monsterUIs[rd]:setVisible(true)
		self.monsterUIs[rd]:setAllFrameNameOnce(self.monsters[rd], 1, true)
	end
end
local maxAddX = 130
function Com_9001666_item:setStartX(startX)
	self.startX = startX
	self.addX = 0
	self.xSpeed = 150
end
function Com_9001666_item:updateXY(dt, y)
	self:setY(y)
	if self.itemBase then
		self.itemBase:setY(y)
	end
	if self.itemType ~= 4 or dt == 0 then
		return
	end
	self.addX = self.addX + self.xSpeed * dt
	if self.addX >= maxAddX or self.addX <= -maxAddX then
		self.addX = 0 < self.xSpeed and maxAddX or -maxAddX
		self.xSpeed = -self.xSpeed
	end
	self:setX(self.startX + self.addX)
end
function Com_9001666_item:getItemType()
	return self.itemType
end
function Com_9001666_item:getRound()
	return self.round
end
function Com_9001666_item:setItemBase(itemBase)
	self.itemBase = itemBase
end
function Com_9001666_item:getItemBase()
	return self.itemBase
end
return Com_9001666_item
