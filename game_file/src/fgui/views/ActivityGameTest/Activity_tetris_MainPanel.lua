local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_tetris_MainPanel = class("Activity_tetris_MainPanel", baseFguiPanel)
function Activity_tetris_MainPanel:ctor(...)
	Activity_tetris_MainPanel.super.ctor(self, ...)
	print("Activity_tetris_MainPanel:ctor", self.viewName)
	self.debug = true
	self.isMoving = false
end
function Activity_tetris_MainPanel:onInit()
	print("=======Activity_tetris_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("俄罗斯方块"), handler(self, self.onClickClose))
	self:createNewShape()
	self.mapSize = self.fields.Com_map:getContentSize()
	self.itemSize = cc.size(40, 40)
	self.tileSize = cc.size(self.mapSize.width / self.itemSize.width, self.mapSize.height / self.itemSize.height)
	self.speed = 1
end
function Activity_tetris_MainPanel:onShow()
	print("=======Activity_tetris_MainPanel:onShow")
	self:listenerKeyPad()
	_UPVALUE10_, _UPVALUE4_, self.objMap, _ENV, self.timer = self, SoradCreateTimer(self, handler(self, self.openTimeUp)), SoradCreateTimer(self, handler(self, self.openTimeUp)), SoradCreateTimer(self, handler(self, self.openTimeUp)), SoradCreateTimer(self, handler(self, self.openTimeUp))
	_UPVALUE10_, self[1] = 1, 1
	_UPVALUE10_, self[2] = 1, 1
	_UPVALUE10_, self[3] = 1, 1
	_UPVALUE10_, self[4] = 1, 1
	_UPVALUE10_, self[5] = 1, 1
	_UPVALUE10_, self[6] = 1, 1
	_UPVALUE10_, self[7] = 1, 1
	_UPVALUE10_, self[8] = 1, 1
	_UPVALUE10_, self[9] = 1, 1
	_UPVALUE10_, self[10] = 1, 1
	_UPVALUE10_, (1)[1] = 0, 0
	_UPVALUE10_, (1)[2] = 0, 1
	_UPVALUE10_, (1)[3] = 0, 1
	_UPVALUE10_, (1)[4] = 0, 1
	_UPVALUE10_, (1)[5] = 0, 1
	_UPVALUE10_, (1)[6] = 0, 1
	_UPVALUE10_, (1)[7] = 0, 1
	_UPVALUE10_, (1)[8] = 0, 1
	_UPVALUE10_, (1)[9] = 0, 1
	_UPVALUE10_, (1)[10] = 0, 0
	_UPVALUE10_, (0)[1] = 0, 0
	_UPVALUE10_, (0)[2] = 0, 0
	_UPVALUE10_, (0)[3] = 0, 1
	_UPVALUE10_, (0)[4] = 0, 1
	_UPVALUE10_, (0)[5] = 0, 1
	_UPVALUE10_, (0)[6] = 0, 1
	_UPVALUE10_, (0)[7] = 0, 1
	_UPVALUE10_, (0)[8] = 0, 1
	_UPVALUE10_, (0)[9] = 0, 0
	_UPVALUE10_, (0)[10] = 0, 0
	;(0)[1] = 0
	;(0)[2] = 0
	;(0)[3] = 0
	;(0)[4] = 1
	;(0)[5] = 1
	;(0)[6] = 1
	;(0)[7] = 1
	;(0)[8] = 0
	;(0)[9] = 0
	;(0)[10] = 0
	SoradCreateTimer(self, handler(self, self.openTimeUp))[1] = self
	SoradCreateTimer(self, handler(self, self.openTimeUp))[2] = 1
	SoradCreateTimer(self, handler(self, self.openTimeUp))[3] = 0
	local SoradCreateTimer(self, handler(self, self.openTimeUp))[4], config = 0, SoradCreateTimer(self, handler(self, self.openTimeUp))
	for y, cfg in ipairs(config) do
		for x, v in ipairs(cfg) do
			if v ~= 0 then
				local tilePos = cc.p(x, self.tileSize.height - y + 1)
				_ENV = 0
				;(0).tilePos = tilePos
				local obj = self:createObjSingle(0)
				self.objMap[self:getKey(obj.tilePos)] = obj
			end
		end
	end
end
function Activity_tetris_MainPanel:createObjSingle(data)
	local obj = fgui.UIPackage:createObject("Activity_9001638", "Com_block")
	obj:addTo(self.fields.Com_map)
	obj.tilePos = data.tilePos
	obj:setPosition(self:tilePos2mapPos(obj.tilePos))
	return obj
end
function Activity_tetris_MainPanel:tilePos2mapPos(tilePos)
	return cc.p((tilePos.x - 1) * 40, (tilePos.y - 1) * 40)
end
function Activity_tetris_MainPanel:getKey(x, y)
	if type(x) == "table" then
		return x.x .. "," .. x.y
	else
		return x .. "," .. y
	end
end
function Activity_tetris_MainPanel:openTimeUp(dt)
	if not self.isMoving then
		return
	end
	if not self:moveMyShape(cc.p(0, 1)) then
		self:addMyShapeToMap()
	end
end
function Activity_tetris_MainPanel:addMyShapeToMap()
	for __, obj in ipairs(self.myShape.objList) do
		self.objMap[self:getKey(obj.tilePos)] = obj
	end
	local _ENV, temp = (for generator), ipairs(self.myShape.objList)
	for __, obj in pairs(self.objMap) do
		local tileY = obj.tilePos.y
		temp[tileY] = (temp[tileY] or 0) + 1
	end
	local _ENV, cleanList = (for generator), pairs(self.objMap)
	for tileY, v in pairs(temp) do
		if v >= self.tileSize.width then
			table.insert(cleanList, tileY)
		end
	end
	table.sort(cleanList)
	for __, tileY in ipairs(cleanList) do
		for tileX = 1, self.tileSize.width do
			local obj = self.objMap[self:getKey(tileX, tileY)]
			if obj then
				obj:removeFromParent()
				self.objMap[self:getKey(tileX, tileY)] = nil
			end
		end
		for i = tileY - 1, 1, -1 do
			for tileX = 1, self.tileSize.width do
				local obj = self.objMap[self:getKey(tileX, i)]
				if obj then
					obj.tilePos.y = obj.tilePos.y + 1
					obj:setPosition(self:tilePos2mapPos(obj.tilePos))
					self.objMap[self:getKey(tileX, i)] = nil
					self.objMap[self:getKey(obj.tilePos)] = obj
				end
			end
		end
	end
	self:createNewShape()
	self.isMoving = false
end
function Activity_tetris_MainPanel:createNewShape(...)
	_UPVALUE3_, _UPVALUE2_ = nil, nil
	_UPVALUE3_, (nil)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, (nil)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, (nil)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, (nil)[4] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[5] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[6] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[7] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[8] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[9] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[10] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[11] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[12] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[13] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[14] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[15] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[16] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[17] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[18] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[19] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[20] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[21] = cc.p(0, 0), cc.p(3, 0)
	_UPVALUE3_, (nil)[22] = cc.p(0, 0), cc.p(3, 0)
	cc.p(0, 0)[1] = cc.p(0, 0)
	cc.p(0, 0)[2] = cc.p(0, -1)
	cc.p(0, 0)[3] = cc.p(0, -2)
	cc.p(0, 0)[4] = cc.p(0, -3)
	cc.p(0, 0)[5] = cc.p(0, -3)
	cc.p(0, 0)[6] = cc.p(0, -3)
	cc.p(0, 0)[7] = cc.p(0, -3)
	cc.p(0, 0)[8] = cc.p(0, -3)
	cc.p(0, 0)[9] = cc.p(0, -3)
	cc.p(0, 0)[10] = cc.p(0, -3)
	cc.p(0, 0)[11] = cc.p(0, -3)
	cc.p(0, 0)[12] = cc.p(0, -3)
	cc.p(0, 0)[13] = cc.p(0, -3)
	cc.p(0, 0)[14] = cc.p(0, -3)
	cc.p(0, 0)[15] = cc.p(0, -3)
	cc.p(0, 0)[16] = cc.p(0, -3)
	cc.p(0, 0)[17] = cc.p(0, -3)
	cc.p(0, 0)[18] = cc.p(0, -3)
	cc.p(0, 0)[19] = cc.p(0, -3)
	cc.p(0, 0)[20] = cc.p(0, -3)
	cc.p(0, 0)[21] = cc.p(0, -3)
	_UPVALUE3_, _UPVALUE1_, (nil)[1] = (cc.p(0, 0))
	local _UPVALUE3_, _UPVALUE1_, (nil)[2], shape1 = cc.p(0, 0), nil, cc.p(0, 0), nil
	cc.p(0, 0)[1] = cc.p(0, 0)
	cc.p(0, 0)[2] = cc.p(1, 0)
	cc.p(0, 0)[3] = cc.p(0, 1)
	cc.p(0, 0)[4] = cc.p(1, 1)
	cc.p(0, 0)[5] = cc.p(1, 1)
	cc.p(0, 0)[6] = cc.p(1, 1)
	cc.p(0, 0)[7] = cc.p(1, 1)
	cc.p(0, 0)[8] = cc.p(1, 1)
	cc.p(0, 0)[9] = cc.p(1, 1)
	cc.p(0, 0)[10] = cc.p(1, 1)
	cc.p(0, 0)[11] = cc.p(1, 1)
	cc.p(0, 0)[12] = cc.p(1, 1)
	cc.p(0, 0)[13] = cc.p(1, 1)
	cc.p(0, 0)[14] = cc.p(1, 1)
	cc.p(0, 0)[15] = cc.p(1, 1)
	cc.p(0, 0)[16] = cc.p(1, 1)
	cc.p(0, 0)[17] = cc.p(1, 1)
	cc.p(0, 0)[18] = cc.p(1, 1)
	cc.p(0, 0)[19] = cc.p(1, 1)
	cc.p(0, 0)[20] = cc.p(1, 1)
	cc.p(0, 0)[21] = cc.p(1, 1)
	local _UPVALUE3_, _UPVALUE4_, (nil)[1], shape2 = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), nil
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[16] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[17] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[18] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[19] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[20] = cc.p(0, 0), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(1, 1), cc.p(1, 1)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(1, 1), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(1, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[16] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[17] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[18] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[19] = cc.p(1, 1), cc.p(1, -1)
	_UPVALUE3_, cc.p(1, 1)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(1, 1)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(1, 1)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, cc.p(1, 1)[4] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[5] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[6] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[7] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[8] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[9] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[10] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[11] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[12] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[13] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[14] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[15] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[16] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[17] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(1, 1)[18] = cc.p(0, 0), cc.p(1, 1)
	cc.p(0, 0)[1] = cc.p(0, 0)
	cc.p(0, 0)[2] = cc.p(1, 0)
	cc.p(0, 0)[3] = cc.p(1, 1)
	cc.p(0, 0)[4] = cc.p(1, -1)
	cc.p(0, 0)[5] = cc.p(1, -1)
	cc.p(0, 0)[6] = cc.p(1, -1)
	cc.p(0, 0)[7] = cc.p(1, -1)
	cc.p(0, 0)[8] = cc.p(1, -1)
	cc.p(0, 0)[9] = cc.p(1, -1)
	cc.p(0, 0)[10] = cc.p(1, -1)
	cc.p(0, 0)[11] = cc.p(1, -1)
	cc.p(0, 0)[12] = cc.p(1, -1)
	cc.p(0, 0)[13] = cc.p(1, -1)
	cc.p(0, 0)[14] = cc.p(1, -1)
	cc.p(0, 0)[15] = cc.p(1, -1)
	cc.p(0, 0)[16] = cc.p(1, -1)
	cc.p(0, 0)[17] = cc.p(1, -1)
	_UPVALUE3_, _UPVALUE2_, cc.p(0, 0)[1] = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, _UPVALUE2_, cc.p(0, 0)[2] = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, _UPVALUE2_, cc.p(0, 0)[3] = cc.p(0, 0), cc.p(0, 0), cc.p(1, 1)
	local _UPVALUE3_, _UPVALUE2_, cc.p(0, 0)[4], shape3 = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(0, 0), cc.p(1, 1)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[16] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[17] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[18] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[19] = cc.p(0, 0), cc.p(2, 1)
	cc.p(0, 0)[1] = cc.p(2, -1)
	cc.p(0, 0)[2] = cc.p(1, 0)
	cc.p(0, 0)[3] = cc.p(1, 1)
	cc.p(0, 0)[4] = cc.p(2, 0)
	cc.p(0, 0)[5] = cc.p(2, 0)
	cc.p(0, 0)[6] = cc.p(2, 0)
	cc.p(0, 0)[7] = cc.p(2, 0)
	cc.p(0, 0)[8] = cc.p(2, 0)
	cc.p(0, 0)[9] = cc.p(2, 0)
	cc.p(0, 0)[10] = cc.p(2, 0)
	cc.p(0, 0)[11] = cc.p(2, 0)
	cc.p(0, 0)[12] = cc.p(2, 0)
	cc.p(0, 0)[13] = cc.p(2, 0)
	cc.p(0, 0)[14] = cc.p(2, 0)
	cc.p(0, 0)[15] = cc.p(2, 0)
	cc.p(0, 0)[16] = cc.p(2, 0)
	cc.p(0, 0)[17] = cc.p(2, 0)
	cc.p(0, 0)[18] = cc.p(2, 0)
	_UPVALUE3_, _UPVALUE2_, cc.p(0, 0)[1] = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	local _UPVALUE3_, _UPVALUE2_, cc.p(0, 0)[2], shape4 = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(0, 1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(0, 1), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(0, 1), cc.p(1, 1)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[16] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[17] = cc.p(0, 1), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[18] = cc.p(0, 1), cc.p(2, 0)
	cc.p(0, 1)[1] = cc.p(1, -1)
	cc.p(0, 1)[2] = cc.p(1, 0)
	cc.p(0, 1)[3] = cc.p(2, 1)
	cc.p(0, 1)[4] = cc.p(2, 0)
	cc.p(0, 1)[5] = cc.p(2, 0)
	cc.p(0, 1)[6] = cc.p(2, 0)
	cc.p(0, 1)[7] = cc.p(2, 0)
	cc.p(0, 1)[8] = cc.p(2, 0)
	cc.p(0, 1)[9] = cc.p(2, 0)
	cc.p(0, 1)[10] = cc.p(2, 0)
	cc.p(0, 1)[11] = cc.p(2, 0)
	cc.p(0, 1)[12] = cc.p(2, 0)
	cc.p(0, 1)[13] = cc.p(2, 0)
	cc.p(0, 1)[14] = cc.p(2, 0)
	cc.p(0, 1)[15] = cc.p(2, 0)
	cc.p(0, 1)[16] = cc.p(2, 0)
	cc.p(0, 1)[17] = cc.p(2, 0)
	_UPVALUE3_, _UPVALUE4_, cc.p(0, 0)[1] = cc.p(0, 1), cc.p(0, 0), cc.p(0, 0)
	local _UPVALUE3_, _UPVALUE4_, cc.p(0, 0)[2], shape5 = cc.p(0, 1), cc.p(0, 0), cc.p(0, 1), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 1)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 1)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 1)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 1)[4] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[5] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[6] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[7] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[8] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[9] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[10] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[11] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[12] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[13] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[14] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[15] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[16] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 1)[17] = cc.p(0, 0), cc.p(2, 1)
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(1, -1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(1, -1), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(1, -1), cc.p(1, 1)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[16] = cc.p(1, -1), cc.p(0, 1)
	_UPVALUE3_, cc.p(1, -1)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(1, -1)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(1, -1)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, cc.p(1, -1)[4] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[5] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[6] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[7] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[8] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[9] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[10] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[11] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[12] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[13] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[14] = cc.p(0, 0), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[15] = cc.p(0, 0), cc.p(0, -1)
	cc.p(0, 0)[1] = cc.p(1, -1)
	cc.p(0, 0)[2] = cc.p(1, 0)
	cc.p(0, 0)[3] = cc.p(1, 1)
	cc.p(0, 0)[4] = cc.p(2, -1)
	cc.p(0, 0)[5] = cc.p(2, -1)
	cc.p(0, 0)[6] = cc.p(2, -1)
	cc.p(0, 0)[7] = cc.p(2, -1)
	cc.p(0, 0)[8] = cc.p(2, -1)
	cc.p(0, 0)[9] = cc.p(2, -1)
	cc.p(0, 0)[10] = cc.p(2, -1)
	cc.p(0, 0)[11] = cc.p(2, -1)
	cc.p(0, 0)[12] = cc.p(2, -1)
	cc.p(0, 0)[13] = cc.p(2, -1)
	cc.p(0, 0)[14] = cc.p(2, -1)
	_UPVALUE3_, _UPVALUE4_, cc.p(0, 0)[1] = cc.p(0, 0), cc.p(0, 1), cc.p(0, 1)
	_UPVALUE3_, _UPVALUE4_, cc.p(0, 0)[2] = cc.p(0, 0), cc.p(0, 1), cc.p(0, 0)
	_UPVALUE3_, _UPVALUE4_, cc.p(0, 0)[3] = cc.p(0, 0), cc.p(0, 1), cc.p(1, -1)
	local _UPVALUE3_, _UPVALUE4_, cc.p(0, 0)[4], shape6 = cc.p(0, 0), cc.p(0, 1), cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[16] = cc.p(0, 0), cc.p(0, 1)
	_UPVALUE3_, cc.p(0, 0)[1] = cc.p(1, -1), cc.p(1, -1)
	_UPVALUE3_, cc.p(0, 0)[2] = cc.p(1, -1), cc.p(1, 0)
	_UPVALUE3_, cc.p(0, 0)[3] = cc.p(1, -1), cc.p(1, 1)
	_UPVALUE3_, cc.p(0, 0)[4] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[5] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[6] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[7] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[8] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[9] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[10] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[11] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[12] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[13] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[14] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(0, 0)[15] = cc.p(1, -1), cc.p(0, -1)
	_UPVALUE3_, cc.p(1, -1)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE3_, cc.p(1, -1)[2] = cc.p(0, 0), cc.p(1, 0)
	_UPVALUE3_, cc.p(1, -1)[3] = cc.p(0, 0), cc.p(2, 0)
	_UPVALUE3_, cc.p(1, -1)[4] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[5] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[6] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[7] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[8] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[9] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[10] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[11] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[12] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[13] = cc.p(0, 0), cc.p(2, -1)
	_UPVALUE3_, cc.p(1, -1)[14] = cc.p(0, 0), cc.p(2, -1)
	cc.p(0, 0)[1] = cc.p(1, -1)
	cc.p(0, 0)[2] = cc.p(1, 0)
	cc.p(0, 0)[3] = cc.p(1, 1)
	cc.p(0, 0)[4] = cc.p(2, 1)
	cc.p(0, 0)[5] = cc.p(2, 1)
	cc.p(0, 0)[6] = cc.p(2, 1)
	cc.p(0, 0)[7] = cc.p(2, 1)
	cc.p(0, 0)[8] = cc.p(2, 1)
	cc.p(0, 0)[9] = cc.p(2, 1)
	cc.p(0, 0)[10] = cc.p(2, 1)
	cc.p(0, 0)[11] = cc.p(2, 1)
	cc.p(0, 0)[12] = cc.p(2, 1)
	cc.p(0, 0)[13] = cc.p(2, 1)
	_UPVALUE7_, cc.p(0, 1)[1] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE7_, cc.p(0, 1)[2] = cc.p(0, 0), cc.p(0, 0)
	_UPVALUE7_, cc.p(0, 1)[3] = cc.p(0, 0), cc.p(1, -1)
	local _UPVALUE7_, cc.p(0, 1)[4], shape7 = cc.p(0, 0), cc.p(0, 0), cc.p(0, 1)
	cc.p(0, 0)[1] = shape1
	cc.p(0, 0)[2] = shape2
	cc.p(0, 0)[3] = shape3
	cc.p(0, 0)[4] = shape4
	cc.p(0, 0)[5] = shape5
	cc.p(0, 0)[6] = shape6
	local cc.p(0, 0)[7], config = shape7, cc.p(0, 0)
	local sType = math.random(1, #config)
	local dirType = 1
	local cfg = config[sType][dirType]
	local tilePos = cc.p(5, 2)
	self.myShape, _ENV = 5, 5
	local _ENV, objList = 5, 5
	for i, diff in ipairs(cfg) do
		_ENV = cc.p(2, 1)
		cc.p(2, 1).tilePos = cc.pAdd(tilePos, diff)
		local obj = self:createObjSingle(cc.p(2, 1))
		table.insert(objList, obj)
	end
	self.myShape.objList = objList
	self.myShape.dirType = dirType
	self.myShape.shape = config[sType]
end
function Activity_tetris_MainPanel:listenerKeyPad()
	if self.listenerLayer then
		return
	end
	self.listenerLayer = display.newLayer()
	self.listenerLayer:addTo(self)
	self.listenerLayer:setKeypadEnabled(true)
	self.listenerLayer:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
		local code = event.code
		if code == cc.KeyCode.KEY_UP_ARROW then
			self:onDirUp()
		elseif code == cc.KeyCode.KEY_DOWN_ARROW then
			self:onDirDown()
		elseif code == cc.KeyCode.KEY_LEFT_ARROW then
			self:onDirLeft()
		elseif code == cc.KeyCode.KEY_RIGHT_ARROW then
			self:onDirRight()
		end
	end)
end
function Activity_tetris_MainPanel:onDirUp(...)
	local dirType = self.myShape.dirType
	local shape = self.myShape.shape
	if #shape <= 1 then
		return
	end
	local cfg = shape[dirType]
	local nextType = dirType % #shape + 1
	local nextCfg = shape[nextType]
	local _ENV, tilePosList
	for i, obj in ipairs(self.myShape.objList) do
		local diffTile = cc.pSub(nextCfg[i], cfg[i])
		local nextTilePos = cc.pAdd(obj.tilePos, diffTile)
		table.insert(tilePosList, nextTilePos)
	end
	local checkCanMove = self:checkCanMove(tilePosList)
	if not checkCanMove then
		return
	end
	self.myShape.dirType = nextType
	for i, obj in ipairs(self.myShape.objList) do
		obj.tilePos = tilePosList[i]
		obj:setPosition(self:tilePos2mapPos(obj.tilePos))
	end
end
function Activity_tetris_MainPanel:onDirDown(...)
	self.isMoving = true
	self:openTimeUp()
end
function Activity_tetris_MainPanel:onDirLeft(...)
	self:moveMyShape(cc.p(-1, 0))
end
function Activity_tetris_MainPanel:onDirRight(...)
	self:moveMyShape(cc.p(1, 0))
end
function Activity_tetris_MainPanel:moveMyShape(dir)
	local _ENV, tilePosList
	for __, obj in ipairs(self.myShape.objList) do
		local tilePos = obj.tilePos
		local nextTilePos = cc.pAdd(tilePos, dir)
		table.insert(tilePosList, nextTilePos)
	end
	local checkCanMove = self:checkCanMove(tilePosList)
	if not checkCanMove then
		return
	end
	for i, obj in ipairs(self.myShape.objList) do
		obj.tilePos = tilePosList[i]
		obj:setPosition(self:tilePos2mapPos(obj.tilePos))
	end
	return true
end
function Activity_tetris_MainPanel:checkCanMove(tilePosList)
	for __, tilePos in ipairs(tilePosList) do
		if tilePos.x < 1 or tilePos.x > self.tileSize.width or tilePos.y > self.tileSize.height then
			return false
		end
		local obj = self.objMap[self:getKey(tilePos)]
		if obj then
			return false
		end
	end
	return true
end
return Activity_tetris_MainPanel
