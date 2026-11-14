local farmSize = 266
local bigWorldConfig = include("bigWorldConfig")
local baseComponent = require("fgui.base.baseComponent")
local Map_farm = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Map_farm", Map_farm)
function Map_farm:onInit()
	self.memberHole, _UPVALUE0_ = nil, nil
end
function Map_farm:onShow()
end
function Map_farm:initMap(parent, map, memebers)
	self.path, _ENV, self.pathIndex = nil, nil, 0
	self.map = map
	self.parent = parent
	self.mapSize = cc.size(math.max(1600, farmSize * math.sqrt(#self.map)), math.max(1600, farmSize * math.sqrt(#self.map)))
	self.fields.bg:setSize(self.mapSize)
	local getMember = function(uid)
		for _, v in ipairs(memebers) do
			if uid == v.uid then
				return v
			end
		end
	end
	for k, v in pairs(self.memberHole) do
		v:setVisible(false)
	end
	for k, v in ipairs(self.map) do
		if v.uid and getMember(v.uid) then
			if not self.memberHole[tostring(v.uid)] then
				local farm = fgui.UIPackage:createObjectFromURL("ui://Activity_9001661/Com_farm")
				farm:setPosition(cc.p(v.pos.x * farmSize - farmSize / 2 + self.mapSize.width / 2, -v.pos.y * farmSize - farmSize / 2 + self.mapSize.height / 2))
				self:addChild(farm, 1)
				self.memberHole[tostring(v.uid)] = farm
			end
			self.memberHole[tostring(v.uid)]:initData(self.parent, getMember(v.uid))
			self.memberHole[tostring(v.uid)]:setVisible(true)
		end
	end
	self:jumpToUid(SoraDGetPlayerID())
end
function Map_farm:jumpToUid(uid)
	local target = self.memberHole[tostring(uid)]
	if target then
		self:scrollToCenter(target)
	end
end
function Map_farm:scrollToCenter(obj, ani)
	local offX = obj:getX() + farmSize / 2 - self.parent:getWidth() / 2
	local offY = obj:getY() + farmSize / 2 - (self.parent:getHeight() / 2 + 78)
	self:getScrollPane():setPosX(math.max(0, math.min(offX, self.mapSize.width - self.parent:getWidth())))
	self:getScrollPane():setPosY(math.max(0, math.min(offY, self.mapSize.height - self.parent:getHeight())))
end
function Map_farm:setPath()
	for k, v in ipairs(self.map) do
		if self.map[k - 1] then
			self:loadPath(k - 1, k)
			self:loadPath(k, k - 1)
		end
		if self.map[k + 1] then
			self:loadPath(k + 1, k)
			self:loadPath(k, k + 1)
		end
	end
end
function Map_farm:loadPath(index1, index2)
	if self.path[index1 .. "_" .. index2] or self.path[index2 .. "_" .. index1] then
		return
	end
	local posAdd = cc.pAdd(self.map[index1].pos, self.map[index2].pos)
	local pos = cc.p(posAdd.x / 2 * farmSize - farmSize / 2 + self.mapSize.width / 2, posAdd.y / 2 * farmSize - farmSize / 2 + self.mapSize.height / 2)
	self.pathIndex = self.pathIndex + 1
	local dir = kingdomPointDefine.getDir(index1, index2)
	local isFlip = self.pathIndex % 2
	local pathDir = bigWorldConfig.getPathConfigByDir(dir + isFlip)
	local index = self.pathIndex % table.nums(pathDir)
	if index == 0 then
		index = table.nums(pathDir)
	end
	local selectPathData = pathDir[index]
	local path = fgui.UIPackage:createObjectFromURL("ui://Activity_9001661/Lab_iconPath")
	path:setName("path" .. self.pathIndex)
	path:setIcon(selectPathData.png)
	path:setPosition(pos)
	local zf = selectPathData.style % 2 == 0 and -0.6 or 0.6
	if selectPathData.scale then
		path:setScale(selectPathData.scale * zf)
	else
		path:setScale(zf)
	end
	if selectPathData.rotate then
		path:setRotation(-selectPathData.rotate)
	end
	if selectPathData.offset then
		path:setPosition(cc.pAdd(pos, selectPathData.offset))
	end
	self:addChild(path, 0)
	self.path[index1 .. "_" .. index2] = path
	self.path[index2 .. "_" .. index1] = path
end
return Map_farm
