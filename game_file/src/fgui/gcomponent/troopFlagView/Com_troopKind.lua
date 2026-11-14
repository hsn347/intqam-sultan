local baseComponent = require("fgui.base.baseComponent")
local Com_troopKind = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://troopFlagView/Com_troopKind", Com_troopKind)
function Com_troopKind:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onArmyRenderer))
end
function Com_troopKind:onShow()
end
function Com_troopKind:onArmyRenderer(index, obj)
	obj:initData(self.armyList[index + 1], self.isTrap)
end
function Com_troopKind:initData(data, isTrap, isLast)
	self.armyList = data.list
	self.isTrap = isTrap
	local height = math.ceil(#self.armyList / 4) * 259 + 20
	self:setHeight(height)
	table.sort(self.armyList, function(a, b)
		return a.id > b.id
	end)
	self.fields.List:setNumItems(#self.armyList)
	self.fields.line:setPositionY(height - 10)
	self.fields.line:setVisible(not isLast)
end
return Com_troopKind
