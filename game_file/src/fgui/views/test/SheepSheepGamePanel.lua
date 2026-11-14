local sheepNumPerType = 3
local charNum = 26
local sheepNum = sheepNumPerType * charNum
local line = 8
local column = 8
local height = 30
local popNum = 3
local hgMax = 7
local sheepSize = 60
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SheepSheepGamePanel = class("SheepSheepGamePanel", baseFguiPanel)
function SheepSheepGamePanel:ctor(...)
	self.isLRU = true
	SheepSheepGamePanel.super.ctor(self, ...)
	print("SheepSheepGamePanel:ctor", self.viewName)
end
function SheepSheepGamePanel:onInit()
	print("=======SheepSheepGamePanel:onInit")
	self.fields.List_hg:setItemRenderer(handler(self, self.itemRenderer_List_hg))
	self.fields.List_hg:setAlign(0)
	self.fields.List_move:setItemRenderer(handler(self, self.itemRenderer_List_move))
	self.fields.List_move:setAlign(0)
	self.fields.Com_title:initData(i18n("开心三消"), handler(self, self.onClickClose))
	self.fields.Button_move:setTitle(i18n("移出"))
	self.fields.Button_move:addClickListener(handler(self, self.onClick_Button_move))
	self.fields.Button_back:setTitle(i18n("回退"))
	self.fields.Button_back:addClickListener(handler(self, self.onClick_Button_back))
	self.fields.Button_refresh:setTitle(i18n("洗盘"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClick_Button_refresh))
end
function SheepSheepGamePanel:endShow()
	print("=======SheepSheepGamePanel:endShow")
	self.fields.bar:setMax(sheepNum)
	self.sheepObjMap, _ENV, self.collectMap, _ENV, self.elementMap, _ENV, self.moveData, _ENV, self.hgData, _ENV, self.mapData, _ENV = self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax, self.fields.bar.setMax
	self.collectNum = 0
	self.backData, _ENV, self.remainNum = sheepNum - self.collectNum, sheepNum - self.collectNum, sheepNum - self.collectNum
	self:initData()
end
function SheepSheepGamePanel:initData(num)
	self.mapData = self:generateUniqueCoords(num or sheepNum)
	self:initMap()
	self:refreshProgress()
	self:refreshOperationButton()
end
function SheepSheepGamePanel:initMap()
	self.fields.Com_map:removeAllChildren()
	for k, v in ipairs(self.mapData) do
		self:generateSheepObj(v)
	end
end
function SheepSheepGamePanel:generateSheepObj(data)
	local obj = fguiHelper.createObject("test", "Com_sheep")
	obj:initData(data)
	obj:setPosition(cc.p(data.x * sheepSize - sheepSize * line / 2 - sheepSize, data.y * sheepSize - sheepSize * column / 2 - sheepSize))
	obj:addTo(self.fields.Com_map)
	obj:setSortingOrder(-(data.x * data.y * data.z))
	table.insert(self.sheepObjMap, obj)
end
function SheepSheepGamePanel:getRandomElement()
	local charNum, idList
	for i = 1, charNum do
		local num = (self.elementMap[i] or 0) + (self.collectMap[i] or 0) + self:getMoveElementNum(i) + self:getHgElementNum(i)
		if num < sheepNumPerType then
			table.insert(idList, i)
		end
	end
	return idList[math.random(1, #idList)]
end
function SheepSheepGamePanel:getMoveElementNum(id)
	local num = 0
	for k, v in ipairs(self.moveData) do
		if v.id == id then
			num = num + 1
		end
	end
	return num
end
function SheepSheepGamePanel:getHgElementNum(id)
	local num = 0
	for k, v in ipairs(self.hgData) do
		if v.id == id then
			num = num + 1
		end
	end
	return num
end
function SheepSheepGamePanel:generateUniqueCoords(count)
	local height, sheepSize, all
	;(nil)[1] = -sheepSize / 2
	;(nil)[2] = 0
	local (nil)[3], sheepSizeList = sheepSize / 2, nil
	for x = 1, line do
		for y = 1, column do
			for z = 1, height do
				sheepSize = nil
				;(nil).x = x
				;(nil).y = y
				;(nil).z = z
				table.insert(all, nil)
			end
		end
	end
	for i = #all, 2, -1 do
		local j = math.random(1, i)
		all[i], all[j] = all[j], all[i]
	end
	local sheepSize, result = (for index), #all
	for i = 1, count do
		local id = self:getRandomElement()
		print("getRandomElement===", i, count, id)
		all[i].id = id
		table.insert(result, all[i])
		self.elementMap[id] = (self.elementMap[id] or 0) + 1
	end
	table.sort(result, function(a, b)
		return a.z > b.z
	end)
	return result
end
function SheepSheepGamePanel:onSheepChoose(target, retData)
	local data = retData.data
	local isFromMove = retData.isFromMove
	if isFromMove then
		for k, v in ipairs(self.moveData) do
			if v.id == data.id then
				table.remove(self.moveData, k)
				_ENV = k
				k.type = 3
				k.data = v
				table.insert(self.backData, k)
				break
			end
		end
		self.fields.List_move:setNumItems(#self.moveData)
		table.insert(self.hgData, data)
		table.sort(self.hgData, function(a, b)
			return a.id > b.id
		end)
		self.fields.List_hg:setNumItems(#self.hgData)
	else
		local obj
		for k, v in ipairs(self.sheepObjMap) do
			local sheepData = v:getData()
			if sheepData.x == data.x and sheepData.y == data.y and sheepData.z == data.z then
				table.remove(self.sheepObjMap, k)
				obj = v
				break
			end
		end
		if obj then
			_ENV = ipairs(self.sheepObjMap)
			ipairs(self.sheepObjMap).type = 1
			ipairs(self.sheepObjMap).data = obj:getData()
			table.insert(self.backData, ipairs(self.sheepObjMap))
			obj:removeFromParent()
		end
		table.insert(self.hgData, data)
		table.sort(self.hgData, function(a, b)
			return a.id > b.id
		end)
		self.fields.List_hg:setNumItems(#self.hgData)
	end
	self:refreshOperationButton()
	local index
	for i = 1, #self.hgData - 2 do
		if self.hgData[i].id == self.hgData[i + 1].id and self.hgData[i + 1].id == self.hgData[i + 2].id then
			index = i
			break
		end
	end
	if index then
		for i = 1, popNum do
			table.remove(self.hgData, index)
		end
		self.collectMap[data.id] = (self.collectMap[data.id] or 0) + popNum
		self.collectNum = self.collectNum + popNum
		self.fields.List_hg:setNumItems(#self.hgData)
	end
	self:refreshProgress()
	if #self.hgData >= hgMax then
		SoraDShowMsgTip("游戏失败")
	end
end
function SheepSheepGamePanel:refreshProgress()
	self.remainNum = sheepNum - self.collectNum
	self.fields.Text_sheep:setString("剩余数量:" .. self.remainNum)
	self.fields.bar:setValue(self.remainNum)
	if self.remainNum <= 0 then
		SoraDShowMsgTip("游戏胜利")
		self:refreshOperationButton()
	end
end
function SheepSheepGamePanel:refreshOperationButton()
	self.fields.Button_move:setEnabled(#self.hgData > 0)
	self.fields.Button_back:setEnabled(0 < #self.backData)
	self.fields.Button_refresh:setEnabled(0 < #self.sheepObjMap)
end
function SheepSheepGamePanel:itemRenderer_List_hg(index, obj)
	local data = self.hgData[index + 1]
	obj:initData(data)
end
function SheepSheepGamePanel:itemRenderer_List_move(index, obj)
	local data = self.moveData[index + 1]
	obj:initData(data, true)
end
function SheepSheepGamePanel:onClick_Button_move(context)
	SoraDPlaySound()
	if #self.moveData >= hgMax then
		SoraDShowMsgTip("移出数量已达上限")
		return
	end
	local data = table.remove(self.hgData, 1)
	table.insert(self.moveData, data)
	_ENV = data
	data.type = 2
	data.data = data
	table.insert(self.backData, data)
	self.fields.List_move:setNumItems(#self.moveData)
	self.fields.List_hg:setNumItems(#self.hgData)
	self:refreshOperationButton()
end
function SheepSheepGamePanel:onClick_Button_back(context)
	SoraDPlaySound()
	local popData = table.remove(self.backData)
	if popData then
		if popData.type == 1 then
			self:removeData(self.hgData, popData.data.id, true)
			self.fields.List_hg:setNumItems(#self.hgData)
			self:generateSheepObj(popData.data)
		elseif popData.type == 2 then
			self:removeData(self.moveData, popData.data.id)
			self.fields.List_move:setNumItems(#self.moveData)
			table.insert(self.hgData, popData.data)
			table.sort(self.hgData, function(a, b)
				return a.id > b.id
			end)
			self.fields.List_hg:setNumItems(#self.hgData)
		elseif popData.type == 3 then
			self:removeData(self.hgData, popData.data.id, true)
			self.fields.List_hg:setNumItems(#self.hgData)
			table.insert(self.moveData, popData.data)
			self.fields.List_move:setNumItems(#self.moveData)
		end
	end
	self:refreshOperationButton()
end
function SheepSheepGamePanel:removeData(list, id, isNeedSort)
	for k, v in ipairs(list) do
		if v.id == id then
			table.remove(list, k)
			break
		end
	end
	if isNeedSort then
		table.sort(list, function(a, b)
			return a.id > b.id
		end)
	end
end
function SheepSheepGamePanel:onClick_Button_refresh(context)
	SoraDPlaySound()
	self.elementMap, _ENV = SoraDPlaySound, SoraDPlaySound
	local num = self.remainNum - #self.moveData - #self.hgData
	self:initData(num)
end
return SheepSheepGamePanel
