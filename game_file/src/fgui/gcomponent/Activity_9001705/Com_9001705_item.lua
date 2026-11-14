local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001705/Com_9001705_item", Com_9001705_item)
function Com_9001705_item:onInit()
	_UPVALUE1_ = nil
	_UPVALUE1_, self.monsters, (nil)[1] = nil, nil, "UIba_dj_s_%02d.png"
	self.monsterUIs, (nil)[1] = nil, self.fields.monster1
end
function Com_9001705_item:onShow()
end
function Com_9001705_item:initData(itemType, round)
	self.itemType = itemType
	self.round = round
	self.controllers.c1:setSelectedIndex(itemType - 1)
	if itemType == 3 then
		local rd = 1
		self.monsterUIs[rd]:setVisible(true)
		self.monsterUIs[rd]:setAllFrameNameOnce(self.monsters[rd], 1, true)
	end
end
local maxAddX = 130
function Com_9001705_item:setStartX(startX)
	self.startX = startX
	self.addX = 0
	self.xSpeed = 150
end
function Com_9001705_item:updateXY(dt, y)
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
function Com_9001705_item:getItemType()
	return self.itemType
end
function Com_9001705_item:getRound()
	return self.round
end
function Com_9001705_item:setItemBase(itemBase)
	self.itemBase = itemBase
end
function Com_9001705_item:getItemBase()
	return self.itemBase
end
return Com_9001705_item
