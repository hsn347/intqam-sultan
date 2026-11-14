local baseComponent = require("fgui.base.baseComponent")
local Com_ML_SRRiver2_1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_SRRiver2_1", Com_ML_SRRiver2_1)
fgui.register_extension("ui://MagicLamp/Com_ML_SRRiver2_2", Com_ML_SRRiver2_1)
fgui.register_extension("ui://MagicLamp/Com_ML_SRRiver2_3", Com_ML_SRRiver2_1)
fgui.register_extension("ui://MagicLamp/Com_ML_SRRiver2_4", Com_ML_SRRiver2_1)
function Com_ML_SRRiver2_1:onInit()
	for i = 1, 10 do
		self.fields["star" .. i]:addClickEventListener(handler(self, self.onStarClick), i)
	end
end
function Com_ML_SRRiver2_1:onShow()
end
function Com_ML_SRRiver2_1:initData(curType, slot, slotCfgs)
	self.curType = curType
	self.slot = slot
	self.slotCfgs = slotCfgs
end
function Com_ML_SRRiver2_1:updateView(isCanUnlockSlot, isAll)
	self.lightingIndex = 0
	for i, v in ipairs(self.slotCfgs) do
		local slotCfg = self.slotCfgs[i]
		local preSlotCfg = self.slotCfgs[i - 1]
		local star = self.fields["star" .. i]
		local line = self.fields["line" .. i - 1]
		star:initData(self.curType, slotCfg, preSlotCfg, isCanUnlockSlot, self.selectedStarIndex == i, isAll)
		local isUnlock = star:getIsUnlock()
		local isLighted = star:getIsLighted()
		local isLighting = star:getIsLighting()
		if line ~= nil then
			line:initData(isLighted, not isUnlock, 0)
		end
		if isLighting then
			self.lightingIndex = i
			self.selectedStarIndex = self.selectedStarIndex or i
			self:onStarClick(nil, self.selectedStarIndex)
		end
	end
end
function Com_ML_SRRiver2_1:setSelectedStarIndex(selectedStarIndex)
	if self.selectedStarIndex then
		self.fields["star" .. self.selectedStarIndex]:setIsSelected(false)
	end
	if selectedStarIndex then
		self.fields["star" .. selectedStarIndex]:setIsSelected(true)
	end
	self.selectedStarIndex = selectedStarIndex
end
function Com_ML_SRRiver2_1:setStarClickCallback(callback)
	self.starClickCallback = callback
end
function Com_ML_SRRiver2_1:onStarClick(btn, index)
	if index > self.lightingIndex then
		return
	end
	SoraDPlaySound()
	if self.starClickCallback then
		self.starClickCallback(index)
	end
end
return Com_ML_SRRiver2_1
