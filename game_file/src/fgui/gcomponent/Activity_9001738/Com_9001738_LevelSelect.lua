local baseComponent = require("fgui.base.baseComponent")
local Com_9001738_LevelSelect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_9001738_LevelSelect", Com_9001738_LevelSelect)
local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
function Com_9001738_LevelSelect:onInit()
	_UPVALUE9_ = nil
	self.levelItems, (nil)[1] = nil, self.fields.level1
	self.levelItems, (nil)[2] = nil, self.fields.level2
	self.levelItems, (nil)[3] = nil, self.fields.level3
	self.levelItems, (nil)[4] = nil, self.fields.level4
	self.levelItems, (nil)[5] = nil, self.fields.level5
	self.levelItems, (nil)[6] = nil, self.fields.level6
	self.levelItems, (nil)[7] = nil, self.fields.level7
	self.levelItems, (nil)[8] = nil, self.fields.level8
	self.levelItems, (nil)[9] = nil, self.fields.level9
	self.fields.listConsumable:setDefaultItem("ui://Activity_9001738/Com_consumableItem")
	self.fields.listConsumable:setItemRenderer(handler(self, self.itemRenderer_listConsumable))
	self.fields.listConsumable:fixChildrenPos()
end
function Com_9001738_LevelSelect:onShow()
end
function Com_9001738_LevelSelect:refreshLevelItem(index, obj)
	if not self.listLevelData[index] then
		activity_9001738_Read = self.listLevelData[index]
		local self.listLevelData[index].levelID, data = index, self.listLevelData[index]
	end
	local levelID = data.levelID or data.index or index
	local prevLevelID = activity_9001738_Read.getPrevLevelID(levelID, activity_9001738_Ctrl:getClassType())
	local isUnlock = activity_9001738_Ctrl:isLevelUnlock(levelID)
	local isSelect = isUnlock and levelID > activity_9001738_Ctrl:getMaxLevelId()
	obj:initData(data, isUnlock, prevLevelID, isSelect)
end
function Com_9001738_LevelSelect:itemRenderer_listConsumable(index, obj)
	local data = self.listConsumableData[index + 1]
	obj:initData(data)
end
function Com_9001738_LevelSelect:initData()
	self.listLevelData = activity_9001738_Read.getLevelList(activity_9001738_Ctrl:getClassType())
	self.listConsumableData = activity_9001738_Read.getItemList()
	for index, obj in ipairs(self.levelItems) do
		self:refreshLevelItem(index, obj)
	end
	self.fields.listConsumable:setNumItems(#self.listConsumableData)
end
return Com_9001738_LevelSelect
