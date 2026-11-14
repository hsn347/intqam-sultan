local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorPolicyInfoPanel = class("intetiorPolicyInfoPanel", baseFguiPanel)
function intetiorPolicyInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorPolicyInfoPanel:ctor", self.viewName)
end
function intetiorPolicyInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function intetiorPolicyInfoPanel:onInit()
	print("=======intetiorPolicyInfoPanel:onInit")
	self.isPolicyBase = false
	self.fields.text_time_last:fixChildrenPos()
	self.fields.text_time_cd:fixChildrenPos()
	self.fields.text_identity:fixChildrenPos()
	self.fields.text_cost:fixChildrenPos()
	self.fields.Button_promise:fixPos()
	self.fields.Button_policy:fixPos()
	self.fields.Button_promise:addClickListener(handler(self, self.onClickPromise))
	self.fields.Button_policy:addClickListener(handler(self, self.onClickPolicy))
	self.fields.Button_publish:addClickListener(handler(self, self.onClickPublish))
	self.fields.text_time_last:getChildByName("Text_Title"):setString(i18n("parliament_text_133"))
	self.fields.text_time_cd:getChildByName("Text_Title"):setString(i18n("parliament_text_134"))
	self.fields.text_identity:getChildByName("Text_Title"):setString(i18n("parliament_text_132"))
	self.fields.text_cost:getChildByName("Text_Title"):setString(i18n("parliament_text_51"))
	self.fields.Button_policy:setString(i18n("parliament_text_52"))
	self.fields.Button_publish:setString(i18n("parliament_text_52"))
end
function intetiorPolicyInfoPanel:onShow()
	print("=======intetiorPolicyInfoPanel:onShow")
	self:initView(self.proxy.param)
end
function intetiorPolicyInfoPanel:initView(skill)
	self.skill = skill
	self.isPolicyBase = skill:isBaseSkill()
	self:initSkillBaseInfo()
	self:updatePolicyData()
end
function intetiorPolicyInfoPanel:updatePolicyData()
	self:initSkillView()
	self:initSkillCostInfo()
end
function intetiorPolicyInfoPanel:initSkillBaseInfo()
	local skill = self.skill
	self.isPolicyBase = skill:isBaseSkill()
	self.fields.Text_des:setString(skill:getSkillDes())
	self.fields.Image_head:setIcon(skill:getSkillIcon())
	self.fields.text_time_last:setString(SoraDConvertSecondToString(skill:getSkillEffectLastTime()))
	self.fields.text_time_cd:setString(SoraDConvertSecondToString(skill:getSkillCDLastTime()))
	self.fields.text_identity:setString(skill:getSkillIdentityStr())
end
function intetiorPolicyInfoPanel:initSkillCostInfo()
	local skill = self.skill
	local cost = skill:getSkillCost()
	self.fields.text_cost:setString(string.formatnumberthousands(cost))
	if skill:isPolicyGoldEnough_Kingdom() then
		self.fields.text_cost:setColor(cc.c3b(215, 195, 155))
	else
		self.fields.text_cost:setColor(display.COLOR_RED)
	end
end
function intetiorPolicyInfoPanel:initSkillView()
	local skill = self.skill
	if self.isPolicyBase then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Panel_bg:setString(i18n("parliament_title_06"))
		self.fields.Text_info_title:setString(i18n("parliament_text_37"))
		if skill:isPolicyPolicy() then
			self.fields.Text_tips:setVisible(false)
			self.fields.Button_promise:setVisible(false)
			self.fields.Button_policy:setVisible(false)
		else
			if skill:isCanShowPromise() then
				self.fields.Text_tips:setVisible(false)
				self.fields.Button_promise:setVisible(true)
				self.fields.Button_promise:setString(i18n("parliament_title_09"))
			elseif skill:isCanShowDoate() then
				self.fields.Text_tips:setVisible(true)
				local num = string.formatnumberthousands(skill:getSkillPolicyNum())
				_ENV = skill:getSkillPolicyNum()
				skill:getSkillPolicyNum().num = num
				self.fields.Text_tips:setString(i18n("parliament_text_42", skill:getSkillPolicyNum()))
				self.fields.Button_promise:setVisible(true)
				self.fields.Button_promise:setString(i18n("common_text_284"))
			else
				self.fields.Text_tips:setVisible(false)
				self.fields.Button_promise:setVisible(false)
			end
			if skill:isCanShowPolicy() then
				self.fields.Button_policy:setVisible(true)
			else
				self.fields.Button_policy:setVisible(false)
			end
			local centerPosX = self.fields.Button_publish:getPositionX()
			if self.fields.Button_promise:isVisible() then
				self.fields.Button_policy:setPositionX(centerPosX + SoraDFPosX(140, 0))
			else
				self.fields.Button_policy:setPositionX(centerPosX)
			end
			if self.fields.Button_policy:isVisible() then
				self.fields.Button_promise:setPositionX(centerPosX + SoraDFPosX(-140, 0))
			else
				self.fields.Button_promise:setPositionX(centerPosX)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Panel_bg:setString(i18n("parliament_title_07"))
		self.fields.Text_info_title:setString(i18n("parliament_text_50"))
		self.controllers.c1:setSelectedIndex(0)
		if skill:isCanShowPublish() then
			self.fields.Button_publish:setVisible(true)
		else
			self.fields.Button_publish:setVisible(false)
		end
	end
end
function intetiorPolicyInfoPanel:onClickPromise()
	SoraDPlaySound()
	if self.skill:isPolicyPromise() then
		if self.skill:checkSkillCanDo_Doate() then
			uiManager:show("intetiorDonateGold", self.skill)
		end
	elseif self.skill:checkSkillCanDo_Promise() then
		self.skill:doPromise()
		SoraDShowLoading(self)
	end
end
function intetiorPolicyInfoPanel:onClickPolicy()
	if self.skill:checkSkillCanDo_Policy() then
		self.skill:doPolicy(self)
	end
end
function intetiorPolicyInfoPanel:onClickPublish()
	if self.skill:checkSkillCanDo_Publish() then
		self.skill:doPublish(self)
	end
end
return intetiorPolicyInfoPanel
