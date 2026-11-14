local baseComponent = require("fgui.base.baseComponent")
local intetiorTrickSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorTrickSingle", intetiorTrickSingle)
function intetiorTrickSingle:onInit()
	self:fixChildrenPos()
	self.fields.Bar:fixChildrenPos()
	self.fields.Button_trick:fixChildrenPos()
	self.fields.Bar:setMax(100)
	self.fields.Label_time:setTimeEndListener(function()
		if not tolua.isnull(self) and self.skill then
			self.skill:setSkillPolicyNum(0)
			self:initSkillView()
		end
	end)
	self.fields.Button_trick:addTouchEventListener(handler(self, self.onClickTrick))
end
function intetiorTrickSingle:onShow()
end
function intetiorTrickSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_DATA_RSP", handler(self, self.rspTrickData))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_CHARGE_RSP", handler(self, self.rspChargeOP))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_DATA_UPDATE", handler(self, self.updatePolicyData))
end
function intetiorTrickSingle:initData(data, mainView)
	self.skill = include("intetiorTrickSkill").new(data)
	self.mainView = mainView
	local trickData = data.trickData
	if trickData then
		self.skill:setSkillPolicyData(trickData)
	end
	self:initView()
end
function intetiorTrickSingle:updateTrickData(data)
	local trickId = self.skill:getSkillID()
	local trickData = data[tostring(trickId)]
	if trickData then
		self.skill:setSkillPolicyData(trickData)
		self:initSkillView()
	end
end
function intetiorTrickSingle:initView()
	self:initBaseView()
	self:initSkillView()
end
function intetiorTrickSingle:initBaseView()
	local skill = self.skill
	self.fields.Text_name:setString(skill:getSkillName())
	self.fields.Text_des:setString(skill:getSkillDes())
	self.fields.Image_head:setIcon(skill:getSkillIcon())
end
function intetiorTrickSingle:initSkillView()
	local skill = self.skill
	if skill:isSkillEffect() then
		self.fields.Node_OP:setVisible(false)
		self.fields.Node_CD:setVisible(true)
		self.fields.Text_time_title:setString(i18n("common_text_844"))
		self.fields.Label_time:beginTime(skill:getSkillEffectTime())
	elseif skill:isSkillCD() then
		self.fields.Node_OP:setVisible(false)
		self.fields.Node_CD:setVisible(true)
		self.fields.Text_time_title:setString(i18n("parliament_text_134"))
		self.fields.Label_time:beginTime(skill:getSkillCD())
	else
		self.fields.Node_OP:setVisible(true)
		self.fields.Node_CD:setVisible(false)
		self.fields.Bar:setVisible(true)
		local percent = self.skill:getSkillTrickPercent()
		self.fields.Bar:setValue(percent)
		self.fields.Bar:getChild("title"):setString(string.format("%.2f%%", percent))
	end
	if not skill:isSkillAllEffect() then
		self.fields.Bar:setVisible(false)
	end
	local cost = skill:getSkillCostOne()
	self.fields.Button_trick:setString(string.formatnumberthousands(cost))
end
function intetiorTrickSingle:rspChargeOP(target, data)
	if data.err == gErrDef.Err_None and data.info then
		local info = data.info
		local trickId = info.trickId
		if trickId == self.skill:getSkillID() then
			local trickNum = info.trickNum
			self.skill:setSkillPolicyNum(trickNum)
			self:initSkillView()
			_ENV = nil
			;(nil).num = info.addNum
			SoraDShowMsgTip(i18n("parliament_text_141", nil))
		end
	end
end
function intetiorTrickSingle:updatePolicyData(target, data)
	if data.info then
		self:updateTrickData(data.info)
	end
end
function intetiorTrickSingle:rspTrickData(target, data)
	if data.err == gErrDef.Err_None and data.info then
		self:updateTrickData(data.info)
	end
end
function intetiorTrickSingle:onClickTrick()
	SoraDPlaySound()
	if self.skill:checkSkillCanDo() then
		self:doAction()
	end
end
function intetiorTrickSingle:doAction()
	if self.skill:doAction() then
		SoraDShowLoading(self.mainView)
	end
end
return intetiorTrickSingle
