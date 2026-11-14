local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteSkillPanel = class("MeteoriteSkillPanel", baseFguiPanel)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
local publicRead = include("publicRead")
function MeteoriteSkillPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MeteoriteSkillPanel:ctor", self.viewName)
end
function MeteoriteSkillPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteSkillPanel:onInit()
	print("=======MeteoriteSkillPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Panel_bg:setTitle(i18n("meteoritesmagic_text_1"))
	self.fields.button_use:setTitle(i18n("common_text_314"))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.text_time:setTimeLast(function(strTime)
		return i18n("parliament_text_134") .. strTime
	end)
	self.fields.text_noactive:setString(i18n("meteoritesmagic_text_32"))
	self.fields.button_use:addClickEventListener(handler(self, self.onUseClicked))
	self.fields.button_meteor:addClickEventListener(handler(self, self.onMeteorClicked))
	self.fields.text_btn_title:setString(i18n("meteoritesmagic_text_1"))
end
function MeteoriteSkillPanel:onShow()
	print("=======MeteoriteSkillPanel:onShow")
	self.curIdx = 1
	self:updateView()
end
function MeteoriteSkillPanel:updateView()
	self.skillList = meteorMagicCtrl:getSkillList()
	self.fields.scroll:setNumItems(#self.skillList)
	if #self.skillList == 0 then
		return
	end
	local skill = self.skillList[self.curIdx]
	self.skill = skill
	self.text_time:removeTime()
	self.text_time:setVisible(false)
	self.fields.text_noactive:setVisible(false)
	if skill.cdEndtime and skill.cdEndtime > serviceFunctions.systemTime() then
		self.text_time:setVisible(true)
		self.fields.button_use:setEnabled(false)
		self.fields.button_use:setFreeTitle(i18n("common_text_046"))
		self.text_time:beginTime(skill.cdEndtime - serviceFunctions.systemTime())
		self.fields.button_use:setCostNum(0)
	else
		self.fields.button_use:setEnabled(true)
		if skill.lv == 0 then
			self.fields.text_noactive:setVisible(true)
			self.fields.button_use:setFreeTitle(i18n("common_text_724"))
			self.fields.button_use:setCostNum(0)
		elseif skill.cfg.needItem[1] ~= nil then
			self.fields.button_use:setCost(skill.cfg.needItem[1], skill.cfg.needItem[2])
		else
			self.fields.button_use:setFreeTitle(i18n("common_text_314"))
			self.fields.button_use:setCostNum(0)
		end
	end
	self.fields.text_name:setString(i18n(skill.info.name))
	self.fields.text_des:setString(meteorMagicRead.getDes(skill.magicId))
end
function MeteoriteSkillPanel:onItemRenderer(index, obj)
	local skill = self.skillList[index + 1]
	obj:initData(skill, index + 1, self.curIdx == index + 1)
	obj:setHandler(handler(self, self.onClicked))
end
function MeteoriteSkillPanel:onClicked(idx)
	SoraDPlaySound()
	self.curIdx = idx
	self:updateView()
end
function MeteoriteSkillPanel:onUseClicked()
	SoraDPlaySound()
	if not self.skill.isUnLock then
		uiManager:show("MeteoriteUI")
		local config = meteorMagicRead.getMagicTree(self.skill.cfg.type)
		_ENV = nil
		;(nil).config = config
		;(nil).curProjectID = meteorMagicCtrl:getCurProjectID()
		;(nil).idGroup = self.skill.cfg.idGroup
		uiManager:show("MeteoriteTalents", nil)
	else
		if self.skill.cdEndtime and self.skill.cdEndtime > serviceFunctions.systemTime() then
			return
		end
		if self.skill.lv == 0 then
			return
		end
		if self.skill.cfg.needItem[1] ~= nil and not self:checkCost(self.skill.cfg.needItem[1], self.skill.cfg.needItem[2]) then
			_ENV = self.skill.cfg.needItem[2]
			self.skill.cfg.needItem[2].item = publicRead.getName(self.skill.cfg.needItem[1])
			SoraDShowMsgTip(i18n("Glory_text_19", self.skill.cfg.needItem[2]))
			return
		end
		meteorMagicCtrl:useSkill(self.skill.cfg.idGroup)
	end
	self:close()
end
function MeteoriteSkillPanel:checkCost(id, num)
	local publicUtil = include("publicUtil")
	return num <= publicUtil.getCount(id)
end
function MeteoriteSkillPanel:onMeteorClicked()
	SoraDPlaySound()
	uiManager:show("MeteoriteUI")
end
return MeteoriteSkillPanel
