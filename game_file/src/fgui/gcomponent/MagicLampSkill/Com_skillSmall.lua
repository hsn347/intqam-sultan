local magicLampSkillRead = include("magicLampSkillRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillSmall = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_skillSmall", Com_skillSmall)
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
function Com_skillSmall:onInit()
end
function Com_skillSmall:onShow()
end
function Com_skillSmall:initData(data)
	self.data = data
	self.fields.Text_lv:setString(data.lv or 1)
	local skillType = data.skillType
	if skillType then
		local quality = magicLampSkillRead.getSkillQuality(skillType)
		local frame1, frame2 = magicLampSkillRead.getQualityFrameSmall(quality)
		self.fields.Load_color1:setURL(frame1)
		self.fields.Load_color2:setURL(frame2)
		self.fields.Load_icon:setURL(magicLampSkillRead.getSkillIcon(skillType))
		local classLvMax = magicLampSkillRead.getSkillStageMax(skillType)
		self.fields.Com_star:initData(data.classLv or 0, classLvMax)
	end
	local quality = data.quality
	if quality then
		local frame1, frame2 = magicLampSkillRead.getQualityFrameSmall(quality)
		self.fields.Load_color1:setURL(frame1)
		self.fields.Load_color2:setURL(frame2)
		self.fields.Load_icon:setURL(magicLampSkillRead.getQualitySkillImage(quality))
	end
	if data.lock then
		self.controllers.c_lock:setSelectedIndex(1)
	else
		self.controllers.c_lock:setSelectedIndex(0)
	end
end
function Com_skillSmall:initNeedSkillData(data)
	self:initData(data)
	self.fields.Text_lv:setVisible(false)
	self.fields.Load_color2:setVisible(false)
end
function Com_skillSmall:initDataById(id)
	local data = magicLampSkillCtrl:getSkillData(id)
	if data then
		self:initData(data)
	end
end
function Com_skillSmall:showDark(isDark)
	if isDark then
		self.controllers.c_dark:setSelectedIndex(1)
	else
		self.controllers.c_dark:setSelectedIndex(0)
	end
end
return Com_skillSmall
