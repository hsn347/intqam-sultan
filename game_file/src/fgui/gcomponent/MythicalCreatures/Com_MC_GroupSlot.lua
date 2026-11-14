local baseComponent = require("fgui.base.baseComponent")
local Com_MC_GroupSlot = fgui.extension_class(fgui.GButton, baseComponent)
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
fgui.register_extension("ui://MythicalCreatures/Com_MC_GroupSlot", Com_MC_GroupSlot)
function Com_MC_GroupSlot:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Com_MC_GroupSlot:onShow()
end
function Com_MC_GroupSlot:initData(mark, slot, setId, equipMarks, beastId)
	self.beastId = beastId
	self.unlockLv = divineBeastMarkRead.getSlotUnlock(beastId, slot)
	self.stepLv = divineBeastCtrl:getStepLv(beastId)
	self.controllers.c1:setSelectedIndex(mark == nil and 0 or 1)
	self.mark = mark
	self.slot = slot
	self.setId = setId
	self.equipMarks = equipMarks
	if mark then
		self.fields.Com_MC_Mark:initData(mark)
	end
end
function Com_MC_GroupSlot:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setId = self.setId
	;(nil).slot = self.slot
	;(nil).setSlotMark = self.mark
	;(nil).equipMarks = self.equipMarks
	uiManager:show("DivineBeastMarkEquip", nil)
end
return Com_MC_GroupSlot
