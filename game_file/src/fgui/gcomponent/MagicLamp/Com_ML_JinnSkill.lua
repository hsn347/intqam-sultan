local baseComponent = require("fgui.base.baseComponent")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local Com_ML_JinnSkill = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_JinnSkill", Com_ML_JinnSkill)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
_ENV = "magicLampCtrl"
;("magicLampCtrl").SLOT_BLESS = 1
local ("magicLampCtrl").SLOT_EXTRA, JINN_SLOT_TYPE = 2, "magicLampCtrl"
function Com_ML_JinnSkill:onInit()
	self.isLong = false
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickEventListener(handler(self, self.onJinnClick))
end
function Com_ML_JinnSkill:onShow()
end
function Com_ML_JinnSkill:initData(jinnType, blessCfg, nowMaxLv)
	self.jinnSlotType = JINN_SLOT_TYPE.SLOT_BLESS
	self.controllers.c2:setSelectedIndex(0)
	self.isShow = nowMaxLv == nil or nowMaxLv >= blessCfg.PreJinnLv
	if not self.isShow then
		self.controllers.c1:setSelectedIndex(2)
		return
	end
	self.blessCfg = blessCfg
	self.blessLv = magicLampCtrl:getBlessLv(jinnType, self.blessCfg.BlessID)
	if 0 < self.blessLv then
		self.usingSkillID = magicLampCtrl:getBlessSkillId(jinnType, self.blessCfg.BlessID)
		self:setReddot(self.usingSkillID == nil and magicLampCtrl:getUnUsedSkill() ~= nil)
		if self.usingSkillID then
			self.controllers.c1:setSelectedIndex(3)
			self.fields.Com_skill:initDataById(self.usingSkillID)
			return
		end
	end
	self.controllers.c1:setSelectedIndex(0 < self.blessLv and 1 or 0)
end
function Com_ML_JinnSkill:initExtraSkillData(jinnType, slot, extraSlotID)
	self.jinnSlotType = JINN_SLOT_TYPE.SLOT_EXTRA
	self.controllers.c2:setSelectedIndex(jinnType == gJinnType.JINN_TWO and 1 or 0)
	local extraSkillData = magicLampCtrl:getExtraSkillData(jinnType, slot)
	self.isUnlockingSlot = slot == magicLampCtrl:getUnlockingSlot(jinnType)
	self.isShow = extraSkillData ~= nil or self.isUnlockingSlot
	self.extraSlotID = extraSlotID
	magicLampCtrl = magicLampCtrl
	magicLampCtrl[1] = self.extraSlotID
	magicLampCtrl[2] = self.isUnlockingSlot
	magicLampCtrl[3] = magicLampCtrl:getUnlockingSlot(jinnType)
	magicLampCtrl[4] = magicLampCtrl:getUnlockingSlot(jinnType)
	magicLampCtrl[5] = magicLampCtrl:getUnlockingSlot(jinnType)
	dump(magicLampCtrl, "self.extraSlotID, self.isUnlockingSlot")
	if not self.isShow then
		self.controllers.c1:setSelectedIndex(2)
		return
	end
	if extraSkillData ~= nil then
		self.usingSkillID = magicLampCtrl:getBlessSkillId(jinnType, extraSlotID)
		self:setReddot(self.usingSkillID == nil and magicLampCtrl:getUnUsedSkill() ~= nil)
		if self.usingSkillID then
			self.controllers.c1:setSelectedIndex(3)
			self.fields.Com_skill:initDataById(self.usingSkillID)
			return
		end
	end
	self.controllers.c1:setSelectedIndex(not self.isUnlockingSlot and 1 or 0)
end
function Com_ML_JinnSkill:setClickCallback(callback)
	self.callback = callback
end
function Com_ML_JinnSkill:onLongPress(...)
	if self.usingSkillID then
		SoraDPlaySound()
		self.isLong = true
		_ENV = nil
		;(nil).data = magicLampSkillCtrl:getSkillData(self.usingSkillID)
		uiManager:show("MagicLampSkillDetailsLook", nil)
	end
end
function Com_ML_JinnSkill:showUnlockAni()
	self.fields.light:setVisible(true)
	self.fields.light2:setVisible(true)
	self.fields.light:setAllFrameNameOnce("dh_xiagubk_%02d.png", 1, false)
	self.fields.light2:setAllFrameNameOnce("dh_zbhd1_%02d.png", 1, false)
	self.transitions.t0:play()
end
function Com_ML_JinnSkill:onJinnClick()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.callback and self.isShow then
		if self.jinnSlotType == JINN_SLOT_TYPE.SLOT_BLESS then
			self.callback(self.blessCfg, self.blessLv)
		elseif self.jinnSlotType == JINN_SLOT_TYPE.SLOT_EXTRA then
			self.callback(self.extraSlotID, self.isUnlockingSlot)
		end
	end
end
return Com_ML_JinnSkill
