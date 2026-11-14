local baseComponent = require("fgui.base.baseComponent")
local Com_ML_SRStar = fgui.extension_class(fgui.GButton, baseComponent)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
fgui.register_extension("ui://MagicLamp/Com_ML_SRStar", Com_ML_SRStar)
function Com_ML_SRStar:onInit()
end
function Com_ML_SRStar:onShow()
	self.isUnlock = nil
	self.lightState = nil
end
function Com_ML_SRStar:initData(jinnType, slotCfg, preSlotCfg, isCanUnlockSlot, isSelected, isAll)
	self.curJinnGalaxyCfg = slotCfg
	local curJinnTaskState = magicLampCtrl:getTaskState(jinnType, self.curJinnGalaxyCfg.quest)
	self.curJinnTaskState = curJinnTaskState
	self.preJinnGalaxyCfg = preSlotCfg
	local preJinnTaskState = self.preJinnGalaxyCfg and magicLampCtrl:getTaskState(jinnType, self.preJinnGalaxyCfg.quest) or gBtnTargetStatusDef.GOT
	self.preJinnTaskState = preJinnTaskState
	local delayChange = 0
	if not isCanUnlockSlot or self.preJinnGalaxyCfg ~= nil and self.preJinnTaskState ~= gBtnTargetStatusDef.GOT then
		self.isUnlock = false
		self.lightState = 0
	elseif curJinnTaskState == gBtnTargetStatusDef.GOT then
		_UPVALUE3_ = gBtnTargetStatusDef.GOT
		gBtnTargetStatusDef.GOT[1] = self.isUnlock ~= nil
		gBtnTargetStatusDef.GOT[2] = not self.isUnlock
		gBtnTargetStatusDef.GOT[3] = not isAll
		dump(gBtnTargetStatusDef.GOT, "self.isUnlock ~= nil and not self.isUnlock and not isAll")
		if self.lightState ~= nil and self.lightState ~= 2 and not isAll then
			self:playLighting(preSlotCfg == nil and 0 or 0.5)
			delayChange = 0.5
		end
		self.isUnlock = true
		self.lightState = 2
	else
		if self.lightState ~= nil and self.lightState ~= 1 then
			delayChange = 0.5
		end
		self.lightState = 1
		self.isUnlock = true
	end
	self:stopActionByTag(995)
	if delayChange ~= 0 then
		local seq = ffa.seq(ffa.delay(delayChange), ffa.callFunc(function()
			self.controllers.c1:setSelectedIndex(self.lightState)
			self.controllers.c2:setSelectedIndex(self.isUnlock and 1 or 0)
		end))
		seq:setTag(995)
		self:runAction(seq)
	else
		self.controllers.c1:setSelectedIndex(self.lightState)
		self.controllers.c2:setSelectedIndex(self.isUnlock and 1 or 0)
	end
	self:setIsSelected(isSelected)
	if isAll then
		self:playLighting(0.5)
	end
end
function Com_ML_SRStar:getIsUnlock()
	return self.isUnlock
end
function Com_ML_SRStar:getIsLighted()
	return self.lightState == 2
end
function Com_ML_SRStar:getIsLighting()
	return self.lightState == 1
end
function Com_ML_SRStar:setIsSelected(isSelected)
	self.fields.ani_choosed:setVisible(isSelected)
	if isSelected then
		self.fields.ani_choosed:setAllFrameName("dh_zndzf_pyui_%02d.png", 1)
	end
end
function Com_ML_SRStar:playLighting(delay)
	self:stopActionByTag(996)
	if delay then
		local seq = ffa.seq(ffa.delay(delay), ffa.callFunc(function()
			self.fields.light:setAllFrameNameOnce("ccxh_G_baodian_%02d.png", 1, false)
		end))
		seq:setTag(996)
		self:runAction(seq)
	else
		self.fields.light:setAllFrameNameOnce("ccxh_G_baodian_%02d.png", 1, false)
	end
end
return Com_ML_SRStar
