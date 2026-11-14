local baseComponent = require("fgui.base.baseComponent")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local Com_ML_skillGroupItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_ML_skillGroupItem", Com_ML_skillGroupItem)
_ENV = fgui.register_extension
fgui.register_extension.LOCK = 0
fgui.register_extension.EMPTY = 1
fgui.register_extension.HIDE = 2
local fgui.register_extension.HAS_SKILL, C1_STATE = 3, fgui.register_extension
function Com_ML_skillGroupItem:onInit()
	self.isLong = false
	self:addClickEventListener(handler(self, self.onClickItem))
end
function Com_ML_skillGroupItem:onShow()
end
function Com_ML_skillGroupItem:isSlotClickable(stateIndex)
	return stateIndex == C1_STATE.EMPTY or stateIndex == C1_STATE.HAS_SKILL
end
function Com_ML_skillGroupItem:initData(data, clickHandle)
