local magicLampSkillRead = include("magicLampSkillRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_jinnAdd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_jinnAdd", Com_jinnAdd)
function Com_jinnAdd:onInit()
	self.fields.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Button_delete:addClickListener(handler(self, self.btnDeleteClick))
end
function Com_jinnAdd:onShow()
end
function Com_jinnAdd:initData(index, jinnType, editData)
	self.index = index
	self.jinnType = jinnType
	self.fields.Text_index:setString("神力槽" .. index)
	if 4 < index then
		self.fields.Text_index:setString("星河槽" .. index - 4)
	end
	if editData.jinnSkillCfg[jinnType] and editData.jinnSkillCfg[jinnType][index] then
		local skillData = editData.jinnSkillCfg[jinnType][index]
		self.fields.Text_name:setString(magicLampSkillRead.getSkillName(skillData.skillType))
	else
		self.fields.Text_name:setString("空")
	end
end
function Com_jinnAdd:btnTouchClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.jinnType
	;(nil).index = self.index
	uiManager:show("CheatJinnChoose", nil)
end
function Com_jinnAdd:btnDeleteClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_JINN"
	;(nil).jinnType = self.jinnType
	;(nil).index = self.index
	;(nil).skillData = nil
	SoraDSendMessage(nil)
end
return Com_jinnAdd
