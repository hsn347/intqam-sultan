local baseComponent = require("fgui.base.baseComponent")
local intetiorMainPolicySingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Intetior/intetiorMainPolicySingle", intetiorMainPolicySingle)
function intetiorMainPolicySingle:onInit()
	self:fixChildrenPos()
	self.fields.Bar:fixChildrenPos()
	self.lastTime = 1
	self:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Image_arrow:setFlippedY(not SoraDFIsRA())
	self.fields.Label_time:setTimeEndListener(function()
		if not tolua.isnull(self) and self.skill then
			self:initSkillView()
		end
	end)
end
function intetiorMainPolicySingle:onShow()
end
function intetiorMainPolicySingle:initData(data)
	self.skill = data
	self:initView()
end
function intetiorMainPolicySingle:initView()
	self:initBaseView()
	self:initSkillView()
end
function intetiorMainPolicySingle:initBaseView()
	local skill = self.skill
	self.fields.Text_name:setString(skill:getSkillName())
	self.fields.Text_des:setString(skill:getSkillDes())
	self.fields.Image_head:setIcon(skill:getSkillIcon())
end
function intetiorMainPolicySingle:initSkillView()
	local skill = self.skill
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Label_time:removeTime()
	if skill:isSkillEffect() then
		self.fields.Label_time:setVisible(true)
		self.fields.Text_effect:setString(i18n("parliament_title_08"))
		self.fields.Bar:setMax(self.lastTime)
		self.fields.Label_time:setTimeLast(function(str, tick)
			self.fields.Bar:setValue(tick)
			self = tick
			tick.time = str
			local reText = i18n("common_text_421", tick)
			return reText
		end)
		self.fields.Bar:setVisible(true)
		self.lastTime = skill:getSkillEffectLastTime() or 1
		self.fields.Label_time:beginTime(skill:getSkillEffectTime())
		self.fields.Image_arrow:setVisible(false)
		self.fields.Text_effect:setVisible(skill:isBaseSkill())
		self.controllers.c1:setSelectedIndex(skill:isBaseSkill() and 1 or 0)
	elseif skill:isSkillCD() then
		self.fields.Label_time:setVisible(true)
		self.fields.Label_time:setTimeLast(function(str, tick)
			_ENV = nil
			;(nil).time = str
			local reText = i18n("common_text_725", nil)
			return reText
		end)
		self.fields.Bar:setVisible(false)
		self.fields.Label_time:beginTime(skill:getSkillCD())
		self.fields.Image_arrow:setVisible(false)
		self.fields.Text_effect:setVisible(false)
	elseif skill:isPolicyPromise() then
		self.fields.Bar:setVisible(false)
		self.fields.Text_effect:setVisible(true)
		self.fields.Text_effect:setString(i18n("parliament_title_09"))
	else
		self.fields.Bar:setVisible(false)
		self.fields.Label_time:setVisible(false)
		self.fields.Image_arrow:setVisible(true)
		self.fields.Text_effect:setVisible(false)
	end
end
function intetiorMainPolicySingle:btnClickCallBack()
	SoraDPlaySound()
	uiManager:show("intetiorPolicyInfo", self.skill)
end
return intetiorMainPolicySingle
