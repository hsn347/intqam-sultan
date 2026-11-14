local magicLampSkillRead = include("magicLampSkillRead")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_skillDetail", Com_skillDetail)
function Com_skillDetail:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.Text_base:setString(i18n("jinn_skill_11"))
	self.fields.Text_buff:setString(i18n("jinn_skill_12"))
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnBuffHelp))
end
function Com_skillDetail:onShow()
end
function Com_skillDetail:onClickBtnBuffHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).skillType = self.data.skillType
	uiManager:show("MagicLampSkillSkill", nil)
end
function Com_skillDetail:initData(data)
	self.data = data
	self:updateSkillBaseDes()
	self:updateSkillBuffDes()
end
function Com_skillDetail:updateSkillBaseDes()
	local lvGroup = magicLampSkillRead.getSkillLvGroup(self.data.skillType)
	local buffList = magicLampSkillRead.getSkillLvTotalBuff(lvGroup, self.data.lv or 1)
	local buffStr = ""
	for i, v in ipairs(buffList) do
		if buffStr ~= "" then
			buffStr = buffStr .. "\n"
		end
		local buffBase = buffDesRead.getTitleBase(v.id, v.count)
		local buffValue = buffDesRead.getTitleValueWithValue(v.id, v.count)
		magicLampSkillRead = nil
		;(nil).color = "#C6B161"
		buffValue = SoraDWrapHtmlTagByStyle(buffValue, nil)
		buffStr = buffStr .. buffBase .. buffValue
	end
	self.fields.Text_baseDes:setString(buffStr)
end
function Com_skillDetail:updateSkillBuffDes()
	local skillGroup = magicLampSkillRead.getSkillSkillGroup(self.data.skillType)
	local firstClassLv = magicLampSkillRead.getFirstBuffClassLv(skillGroup)
	local buffCount = magicLampSkillRead.getBuffCount(skillGroup)
	local showLock = false
	local curClassLv = self.data.classLv or 0
	if firstClassLv and firstClassLv > curClassLv then
		showLock = true
		curClassLv = firstClassLv
	end
	local showBuff = firstClassLv ~= nil
	self.fields.Text_buff:setVisible(showBuff)
	self.fields.Text_lock:setVisible(showLock)
	self.fields.Text_buffDes:setVisible(showBuff)
	self.fields.Button_help:setVisible(showBuff and 1 < buffCount)
	if showBuff then
		if showLock then
			self.fields.Text_lock:setVisible(true)
			magicLampSkillRead = nil
			;(nil).lv = firstClassLv
			self.fields.Text_lock:setString(i18n("jinn_skill_13", nil))
			self.fields.Text_buffDes:setPositionY(self.fields.Text_lock:getPositionY() + self.fields.Text_lock:getContentSize().height)
		else
			self.fields.Text_lock:setVisible(false)
			self.fields.Text_buffDes:setPositionY(self.fields.Text_buff:getPositionY() + self.fields.Text_buff:getContentSize().height)
		end
		local skill = skillGroup[curClassLv + 1]
		self.fields.Text_buffDes:setString(magicLampSkillRead.getSkillBuffDes(skill))
	end
	self.showLock = showLock
end
function Com_skillDetail:updateSkillLv(data)
	self.data = data
	self:updateSkillBaseDes()
end
function Com_skillDetail:updateSkillClassLv(data)
	self.data = data
	self:updateSkillBuffDes()
end
function Com_skillDetail:setAutoHeight(width)
	local finalHeight = self.showLock and self.fields.Text_baseDes:getY() + self.fields.Text_baseDes:getHeight() or self.fields.Text_buffDes:getY() + self.fields.Text_buffDes:getHeight()
	self:setSize(width, finalHeight)
	self:setScrollEnable(false)
	self:setPositionX(10)
	self.fields.Button_help:setVisible(false)
	self.fields.Text_buff:setVisible(not self.showLock)
	self.fields.Text_lock:setVisible(not self.showLock)
	self.fields.Text_buffDes:setVisible(not self.showLock)
end
return Com_skillDetail
