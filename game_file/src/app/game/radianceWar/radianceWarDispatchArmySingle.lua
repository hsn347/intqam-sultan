local worldDispatchArmySingle = include("worldDispatchArmySingle")
local radianceWarDispatchArmySingle = class("radianceWarDispatchArmySingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("radianceWarDispatchArmySingle")
	end
	target = worldDispatchArmySingle.new(target)
	return target
end)
function radianceWarDispatchArmySingle:ctor()
	self.panelLock = SoraDGetChildByName(self, "Panel_lock")
end
function radianceWarDispatchArmySingle:initData(itemData)
	worldDispatchArmySingle.initData(self, itemData)
	self:setLock(itemData.isForbid)
end
function radianceWarDispatchArmySingle:setLock(lock)
	self.panelLock:setVisible(lock)
	self.panelLock:setSwallowTouches(not lock)
	if lock then
		SoraDGetChildByName(self, "Text_lock"):setString(i18n("brightWar_text_87"))
	end
end
return radianceWarDispatchArmySingle
