local baseComponent = require("fgui.base.baseComponent")
local ComMLGroupSwitch = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/ComMLGroupSwitch", ComMLGroupSwitch)
function ComMLGroupSwitch:onInit()
	self.fields.listSkill:setItemRenderer(handler(self, self.itemRenderer_listSkill))
	self.fields.btnPaste:setTitle(i18n("Weapon_Rune_tips_087"))
	self.fields.btnPaste:addClickListener(handler(self, self.onClick_btnPaste))
	self.fields.txtEmpty:setString(i18n("magic_lamp_text_176"))
	self.fields.listSkill:fixPos()
	self.fields.txtEmpty:fixPos()
	self.fields.btnPaste:fixPos()
end
function ComMLGroupSwitch:onShow()
end
function ComMLGroupSwitch:initData(data, copyCallback)
	self.data = data
	self.copyCallback = copyCallback
	if not data.skillIdList then
		_UPVALUE0_ = data.skillIdList
	end
	self.listSkillData = data.skillIdList
	self.fields.txtName:setString(data.name)
	self.controllers.ctrlEmpty:setSelectedIndex(#self.listSkillData == 0 and 1 or 0)
	self.fields.listSkill:setNumItems(#self.listSkillData)
end
function ComMLGroupSwitch:itemRenderer_listSkill(index, obj)
	local skillID = self.listSkillData[index + 1]
	obj.fields = obj.fields or fguiHelper.get_fields(obj)
	obj.fields.Com_skill:initDataById(skillID)
	obj.fields.Com_skill.controllers.ctrlBigWord:setSelectedIndex(1)
end
function ComMLGroupSwitch:onClick_btnPaste(context)
	SoraDPlaySound()
	self.copyCallback(self.data.groupID)
end
return ComMLGroupSwitch
