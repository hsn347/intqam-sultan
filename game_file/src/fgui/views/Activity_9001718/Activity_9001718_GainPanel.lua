local activityCommonDrawRead = include("activityCommonDrawRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001718_GainPanel = class("Activity_9001718_GainPanel", baseFguiPanel)
function Activity_9001718_GainPanel:ctor(...)
	self.isLRU = true
	Activity_9001718_GainPanel.super.ctor(self, ...)
	print("Activity_9001718_GainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001718
end
function Activity_9001718_GainPanel:onInit()
	print("=======Activity_9001718_GainPanel:onInit")
	self.fields.Label_title:setString(i18n("prayer_lamp_007"))
	self.fields.text_tip:setString(i18n("prayer_lamp_006"))
	self.fields.text_close:setString(i18n("shoot_game_text_002"))
end
function Activity_9001718_GainPanel:endShow()
	print("=======Activity_9001718_GainPanel:endShow")
	if not self.param.rewardsDetail then
		_ENV = self.param.rewardsDetail
	end
	self.rewards = self.param.rewardsDetail
	self.fields.Usm_1:getCriSprite():setSpeed(2, 3)
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self:initView()
end
function Activity_9001718_GainPanel:initView()
	if #self.rewards == 1 then
		self.fields.Com_gain:getController("c1"):setSelectedIndex(0)
		local target = self.fields.Com_gain:getChild("n0")
		target:getChild("Com_item"):initData(self.rewards[1].id)
		local isSuper = activityCommonDrawRead.isSuperReward(self.rewards[1].id, self.rewards[1].count)
		target:getChild("prefabEx"):setEffectPath(isSuper and "fx_9001718_paopao_glod.prefab" or "fx_9001718_paopao.prefab")
		target:getChild("title"):setString(self.rewards[1].count)
		target:getController("c1"):setSelectedIndex(0)
	else
		self.fields.Com_gain:getController("c1"):setSelectedIndex(1)
		for i = 1, #self.rewards do
			if self.fields.Com_gain:getChild("n" .. i) then
				local target = self.fields.Com_gain:getChild("n" .. i)
				target:getChild("Com_item"):initData(self.rewards[i].id)
				local isSuper = activityCommonDrawRead.isSuperReward(self.rewards[i].id, self.rewards[i].count)
				target:getChild("prefabEx"):setEffectPath(isSuper and "fx_9001718_paopao_glod.prefab" or "fx_9001718_paopao.prefab")
				target:getChild("title"):setString(self.rewards[i].count)
				target:getController("c1"):setSelectedIndex(0)
			end
		end
	end
end
return Activity_9001718_GainPanel
