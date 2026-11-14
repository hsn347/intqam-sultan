local baseComponent = require("fgui.base.baseComponent")
local Com_ML_SRJinnSkill = fgui.extension_class(fgui.GButton, baseComponent)
local magicLampRead = include("magicLampRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
fgui.register_extension("ui://MagicLamp/Com_ML_SRJinnSkill", Com_ML_SRJinnSkill)
function Com_ML_SRJinnSkill:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickEventListener(handler(self, self.onJinnClick))
end
function Com_ML_SRJinnSkill:onShow()
end
function Com_ML_SRJinnSkill:initData(jinnType, slot, isUnlock, isUnlocking, isSelected)
	self.jinnType = jinnType
	self.curSlot = slot
	self.isUnlock = isUnlock
	self.isUnlocking = isUnlocking
	self.isSelected = isSelected
	if self.isUnlocking then
		self.controllers.c1:setSelectedIndex(0)
	elseif isUnlock then
		local extraSlotID = magicLampRead.extraSkillSlotStartIndex + slot
		self.usingSkillID = magicLampCtrl:getBlessSkillId(jinnType, extraSlotID)
		if self.usingSkillID then
			self.controllers.c1:setSelectedIndex(3)
			self.fields.Com_skill:initDataById(self.usingSkillID)
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	else
		self.controllers.c1:setSelectedIndex(2)
	end
	self.controllers.c2:setSelectedIndex(math.min(jinnType - 1, 1))
	self.controllers.c3:setSelectedIndex(isSelected and 1 or 0)
end
function Com_ML_SRJinnSkill:setCallback(callback)
	self.callback = callback
end
function Com_ML_SRJinnSkill:onLongPress(...)
	if self.usingSkillID then
		SoraDPlaySound()
		self.isLong = true
		_ENV = nil
		;(nil).data = magicLampSkillCtrl:getSkillData(self.usingSkillID)
		uiManager:show("MagicLampSkillDetailsLook", nil)
	end
end
function Com_ML_SRJinnSkill:onJinnClick()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.isSelected then
		return
	end
	if not self.isUnlock and not self.isUnlocking then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("jinn_gaglxy_text09"))
		return
	end
	if self.callback then
		SoraDPlaySound()
		self.callback(self.curSlot)
	end
end
return Com_ML_SRJinnSkill
