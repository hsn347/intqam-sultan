local baseComponent = require("fgui.base.baseComponent")
local Com_tilesRolygon = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/Com_tilesRolygon", Com_tilesRolygon)
function Com_tilesRolygon:onInit()
	self.useList, _UPVALUE0_, self.spaceList, _UPVALUE0_ = nil, nil, nil, nil
end
function Com_tilesRolygon:onShow()
end
function Com_tilesRolygon:recycleUseList()
	for _, obj in ipairs(self.useList) do
		obj:setVisible(false)
		table.insert(self.spaceList, obj)
	end
	self.useList, _ENV = ipairs(self.useList)
end
function Com_tilesRolygon:getTileWhiteObj()
	local obj = table.remove(self.spaceList, 1)
	if obj then
		obj:setVisible(true)
		return obj
	end
	local obj = fgui.UIPackage:createObject("ManorCity", "Com_tileWhite")
	obj:addTo(self)
	return obj
end
function Com_tilesRolygon:setComMap(comMap)
	self.comMap = comMap
end
function Com_tilesRolygon:showTilesRolygon(tilePos, size, canPlaceMap)
	self:recycleUseList()
	for i = 0, size - 1 do
		for j = 0, size - 1 do
			local obj = self:getTileWhiteObj()
			table.insert(self.useList, obj)
			local _tilePos = cc.p(tilePos.x + i, tilePos.y + j)
			local mapPos = self.comMap:getPointWithTile(_tilePos)
			obj:setPosition(mapPos)
			local poskey = _tilePos.x .. "," .. _tilePos.y
			local canPlace = canPlaceMap[poskey]
			local color = canPlace and "#45fe01" or "#fd021b"
			obj:getChild("icon"):setColor(color)
		end
	end
end
return Com_tilesRolygon
