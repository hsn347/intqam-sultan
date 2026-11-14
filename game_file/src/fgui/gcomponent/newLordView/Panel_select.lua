local warGemltCtrl = include("warGemltCtrl")
local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Panel_select = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Panel_select", Panel_select)
function Panel_select:onInit()
	_UPVALUE4_ = nil
	self.nums, (nil)[1] = nil, warGemltCtrl:getGemSwitchCount()
	self.nums, (nil)[2] = nil, 6
	self.nums, (nil)[3] = nil, 8
	self.nums, (nil)[4] = nil, 6
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function Panel_select:onShow()
end
function Panel_select:onListRenderer(index, obj)
	local setName = combinationCtrl:getSetName(self.index, self.setIDList[index + 1])
	obj:setTitle(setName)
	obj:setSelected(tonumber(self.setID) == tonumber(self.setIDList[index + 1]))
end
function Panel_select:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex() + 1
	if self.handle then
		self.handle(self.setIDList[index])
	end
end
function Panel_select:initData(setID, index, handle)
	self.setID = setID
	self.index = index
	self.handle = handle
	self.setIDList, _ENV, self.sCount = nil, nil, 0
	local maxNum = self.nums[self.index]
	for i = 1, maxNum do
		local _setID = tostring(i)
		if combinationCtrl:checkSetUnLock(self.index, _setID) then
			self.sCount = self.sCount + 1
			self.setIDList[self.sCount] = _setID
		end
	end
	self.fields.List:setNumItems(#self.setIDList)
end
return Panel_select
