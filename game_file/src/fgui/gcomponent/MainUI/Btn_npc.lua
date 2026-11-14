local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local questCtrl = SoraDGetCtrl("questCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_npc = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_npc", Btn_npc)
function Btn_npc:onInit()
	self:setRed()
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.lab_red:fixPos()
end
function Btn_npc:onShow()
end
function Btn_npc:setRed()
	local num = everydayTaskCtrl:getReceiveNormalRewardCount() + questCtrl:getCommitQuestNum()
	self.fields.lab_red:setVisible(0 < num)
	self.fields.lab_red:setString(num)
	self.fields.Particle_effect:setVisible(0 < num)
end
function Btn_npc:onBtnClick()
	SoraDPlaySound("uicontrol", 20)
	uiManager:show("questView")
end
return Btn_npc
