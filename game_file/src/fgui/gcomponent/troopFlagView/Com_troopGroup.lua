local baseComponent = require("fgui.base.baseComponent")
local Com_troopGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://troopFlagView/Com_troopGroup", Com_troopGroup)
function Com_troopGroup:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onArmyRenderer))
end
function Com_troopGroup:onShow()
end
function Com_troopGroup:onArmyRenderer(index, obj)
	obj:initData(self.armyList[index + 1], self.isTrap, #self.armyList == index + 1)
end
function Com_troopGroup:initData(data)
	self.data = data
	self.isTrap = self.data.isTrap or false
	self.fields.Lab_title:setString(self.data.title)
	self.armyList = self.data.data
	local height = 60
	for k, v in ipairs(self.armyList) do
		height = height + math.ceil(#v.list / 4) * 259 + math.max(0, #self.armyList - 1) * 10
	end
	self:setHeight(height)
	self.fields.List:setNumItems(#self.armyList)
end
return Com_troopGroup
