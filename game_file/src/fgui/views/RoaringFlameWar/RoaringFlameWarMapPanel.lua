local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWarMapPanel = class("RoaringFlameWarMapPanel", baseFguiPanel)
function RoaringFlameWarMapPanel:ctor(...)
	RoaringFlameWarMapPanel.super.ctor(self, ...)
	print("RoaringFlameWarMapPanel:ctor", self.viewName)
	self.debug = true
end
function RoaringFlameWarMapPanel:onInit()
	print("=======RoaringFlameWarMapPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Button_save:addClickListener(handler(self, self.onClickBtnSave))
	self.fields.Button_save:setString(i18n("common_text_195"))
	self:initBuild()
	local scrollpane = self.fields.Com_map:getScrollPane()
	scrollpane:setPercX(0.75)
	scrollpane:setPercY(0.2)
end
function RoaringFlameWarMapPanel:onShow()
	print("=======RoaringFlameWarMapPanel:onShow")
end
function RoaringFlameWarMapPanel:onClickBtnSave(...)
	local objIdStr = ""
	for objId, __ in ipairs(self.objList) do
		local list = self.objIdMap[objId]
		if list and next(list) then
			table.sort(list)
			objIdStr = objIdStr .. table.concat(list, ";") .. "\n"
		else
			objIdStr = objIdStr .. "\n"
		end
	end
	SoraDCopyText(objIdStr)
	SoraDShowMsgTip(i18n("common_text_1062"))
end
function RoaringFlameWarMapPanel:initBuild(...)
	local Com_map = self.fields.Com_map
	local Com_build = Com_map:getChild("Com_build")
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(Com_build, -1)
	self.objList, _ENV, self.posList, _ENV, self.drawNode = drawNode.addTo, drawNode.addTo, drawNode.addTo, drawNode.addTo, drawNode
	local _ENV, objIdMap = drawNode.addTo, drawNode.addTo
	for objId, v in ipairs(roaringFlameWarRead.get_flames_dunes_city()) do
		if next(v.binding) then
			objIdMap[objId] = v.binding
		end
	end
	self.objIdMap = objIdMap
	local p0 = cc.p(3200, -144)
	local w, h = 12.8, 6.4
	for i, v in ipairs(roaringFlameWarRead.get_flames_dunes_city()) do
		local text_id = ccui.Text:create()
		text_id:setAnchorPoint(cc.p(0.5, 0.5))
		text_id:addTo(Com_build, 1)
		text_id:setString(tostring(i))
		text_id:setFontSize(20)
		text_id:setColor(cc.c3b(0, 0, 0))
		local obj = fgui.UIPackage:createObject("CommonNew", "Button_icon")
		obj:addTo(Com_build)
		obj:setAnchorPoint(0.5, 0.5)
		obj:setIcon("lod_build_nebula_901.png")
		obj:setGrayed(true)
		obj:setTag(i)
		obj:addClickListener(handler(self, self.onClickObj))
		local city_coord = v.city_coord
		local tile = cc.p(city_coord[1], city_coord[2])
		local point = worldMapDefine.tile2point(p0, tile, w, h)
		obj:setPosition(cc.p(point.x, -point.y))
		text_id:setPosition(cc.p(point.x, point.y))
		table.insert(self.objList, obj)
	end
	self:drawLine()
	self:checkObjState()
end
function RoaringFlameWarMapPanel:onClickObj(EventContext)
	local obj = EventContext:getSender()
	if not self._obj then
		obj:getChild("icon"):setColor(display.COLOR_RED)
		self._obj = obj
		self:checkObjState()
		return
	end
	if self._obj == obj then
		self._obj = nil
		obj:getChild("icon"):setColor(display.COLOR_WHITE)
		self:checkObjState()
		return
	end
	obj:getChild("icon"):setColor(display.COLOR_WHITE)
	self._obj:getChild("icon"):setColor(display.COLOR_WHITE)
	local tag1 = obj:getTag()
	local tag2 = self._obj:getTag()
	if not self.objIdMap[tag1] then
		local _ENV, list1 = self.objIdMap[tag1], self.objIdMap[tag1]
	end
	if not self.objIdMap[tag2] then
		local _ENV, list2 = self.objIdMap[tag2], self.objIdMap[tag2]
	end
	local index1 = table.indexof(list1, tag2)
	local index2 = table.indexof(list2, tag1)
	if index1 or index2 then
		self._obj = nil
		if index1 then
			table.remove(list1, index1)
		end
		if index2 then
			table.remove(list2, index2)
		end
		dump(self.objIdMap, "==self.objIdMap==")
		self:drawLine()
		self:checkObjState()
		return
	end
	self._obj = nil
	if not self.objIdMap[tag1] then
		_ENV = self.objIdMap[tag1]
	end
	self.objIdMap[tag1] = self.objIdMap[tag1]
	table.insert(self.objIdMap[tag1], tag2)
	if not self.objIdMap[tag2] then
		_ENV = self.objIdMap[tag2]
	end
	self.objIdMap[tag2] = self.objIdMap[tag2]
	table.insert(self.objIdMap[tag2], tag1)
	self:drawLine()
	self:checkObjState()
end
function RoaringFlameWarMapPanel:drawLine(...)
	self.posList, _ENV = nil, nil
	self.drawNode:clear()
	for tag1, list in pairs(self.objIdMap) do
		local obj1 = self.objList[tag1]
		local pos1 = obj1:getPosition()
		for __, tag2 in ipairs(list) do
			local obj2 = self.objList[tag2]
			local pos2 = obj2:getPosition()
			table.insert(self.posList, cc.p(pos1.x, -pos1.y))
			table.insert(self.posList, cc.p(pos2.x, -pos2.y))
		end
	end
	for i = 2, #self.posList, 2 do
		self.drawNode:drawLine(self.posList[i - 1], self.posList[i], cc.c4b(1, 1, 1, 1))
	end
end
function RoaringFlameWarMapPanel:checkObjState(...)
	local _ENV, ret
	for tag1, list in pairs(self.objIdMap) do
		ret[tag1] = 0 < #list
		for __, tag2 in ipairs(list) do
			ret[tag2] = true
		end
	end
	for tag, obj in ipairs(self.objList) do
		if ret[tag] or self._obj == obj then
			obj:setGrayed(false)
		else
			obj:setGrayed(true)
		end
	end
end
return RoaringFlameWarMapPanel
