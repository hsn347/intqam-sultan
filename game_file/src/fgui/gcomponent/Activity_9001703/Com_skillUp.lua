local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillUp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_skillUp", Com_skillUp)
function Com_skillUp:onInit()
	self.fields.Button_choose:setString(i18n("treasure_crystal_btn_02"))
	self.fields.Button_choose:addClickListener(handler(self, self.btnChooseClick))
	self.fields.arr_lv:fix()
	self.fields.Text_fromLv:fixPos()
	self.fields.Text_toLv:fixPos()
	self.fields.Text_fromP:fixPos()
	self.fields.arr_p:setRotation(SoraDFIsRA() and -90 or 90)
	self.fields.arr_p:fixPos()
	self.fields.Text_toP:fixPos()
end
function Com_skillUp:onShow()
end
function Com_skillUp:initData(skillId, parent)
	self.skillId = skillId
	self.parent = parent
	local cfg = activity_9001703_Read.getSkillShow(skillId)
	self.fields.title:setString(i18n(cfg.skillName))
	self.fields.icon:setURL(cfg.skillIcon)
	local lv = activity_9001703_Ctrl:getSkillLv(skillId)
	activity_9001703_Read = i18n(cfg.skillName)
	i18n(cfg.skillName).lv = lv
	self.fields.Text_fromLv:setString(i18n("common_text_100", i18n(cfg.skillName)))
	activity_9001703_Read = i18n("common_text_100", i18n(cfg.skillName))
	i18n("common_text_100", i18n(cfg.skillName)).lv = lv + 1
	self.fields.Text_toLv:setString(i18n("common_text_100", i18n("common_text_100", i18n(cfg.skillName))))
	activity_9001703_Read = i18n("common_text_100", i18n("common_text_100", i18n(cfg.skillName)))
	i18n("common_text_100", i18n("common_text_100", i18n(cfg.skillName))).num = ""
	self.fields.Text_des:setString(i18n(cfg.skillDes, i18n("common_text_100", i18n("common_text_100", i18n(cfg.skillName)))))
	local val, valShow = activity_9001703_Ctrl:getSkillLvEffect(skillId)
	self.fields.Text_fromP:setString(valShow)
	local _val, _valShow = activity_9001703_Ctrl:getSkillLvEffect(skillId, lv + 1)
	self.fields.Text_toP:setString(_valShow)
end
function Com_skillUp:btnChooseClick()
	SoraDPlaySound()
	activity_9001703_Ctrl:reqSelectSkill(self.skillId)
	self.parent:close()
end
return Com_skillUp
