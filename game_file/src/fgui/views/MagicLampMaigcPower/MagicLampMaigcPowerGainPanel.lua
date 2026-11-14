local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillRead = include("magicLampSkillRead")
local MagicLampMaigcPowerGainPanel = class("MagicLampMaigcPowerGainPanel", baseFguiPanel)
function MagicLampMaigcPowerGainPanel:ctor(...)
	self.debug = true
	self.super.ctor(self, ...)
	print("MagicLampMaigcPowerGainPanel:ctor", self.viewName)
end
function MagicLampMaigcPowerGainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampMaigcPowerGainPanel:onInit()
	print("=======MagicLampMaigcPowerGainPanel:onInit")
	self.fields.Com_title:setTitle(i18n("Magic_draw_text_14"))
	self.fields.text_tip:setString(i18n("Magic_draw_text_15"))
	self.fields.text_close:setString(i18n("shoot_game_text_002"))
	self.fields.list_reward1:setItemRenderer(handler(self, self.onItem1sRender))
	self.fields.list_reward2:setItemRenderer(handler(self, self.onItem2sRender))
	self.fields.list_reward3:setItemRenderer(handler(self, self.onItem3sRender))
end
function MagicLampMaigcPowerGainPanel:onShow()
	print("=======MagicLampMaigcPowerGainPanel:onShow")
	if not self.param.isNoAct then
		self.controllers.c1:setSelectedIndex(3)
		self.fields.mask:setVisible(true)
		self.fields.Usm_1:setEffectPath("sdslchuxian1_01.usm,sdsldaiji1_01.usm", true)
		self.fields.Usm_1:getCriSprite():setSpeed(2, 3)
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self:runAction(ffa.seq(ffa.delay(1.56), ffa.callFunc(function()
			if not SoraDIsMemoryLowLevel() then
				self.fields.Usm_3:play(false)
			end
			for i = 1, self.view:getChildrenCount() do
				local child = self.view:getChildAt(i - 1)
				local childName = child:getName()
				if childName ~= "Usm_1" and childName ~= "Usm_2" and childName ~= "Usm_3" then
					child:setAlpha(0)
					child:runAction(ffa.seq(ffa.delay(0.7), ffa.fadeIn(0.5)))
				end
			end
			self:updateView()
		end), ffa.delay(1), ffa.callFunc(function()
		end)))
	else
		self.fields.Usm_1:setEffectPath("sdsldaiji1_01.usm", true)
		self.fields.Usm_1:getCriSprite():setSpeed(2, 3)
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		for i = 1, self.view:getChildrenCount() do
			local child = self.view:getChildAt(i - 1)
			local childName = child:getName()
			if childName ~= "Usm_1" and childName ~= "Usm_2" and childName ~= "Usm_3" then
				child:setAlpha(1)
			end
		end
		self:updateView()
	end
end
function MagicLampMaigcPowerGainPanel:updateView()
	local exReward = self.param.extraReward
	if exReward and #exReward ~= 0 then
		self.fields.exItem:initData(exReward[1].id, exReward[1].count)
	end
	local rewardsList = self.param.rewardsList
	if #rewardsList == 1 then
		local v = rewardsList[1]
		v.isSkill = JudgeItemType(v.id) == gIDType.MAGIC_LAMP_SKILL
		self.rewardsList = rewardsList
		self.controllers.c1:setSelectedIndex(2)
		self.fields.list_reward3:setNumItems(1)
		self.fields.mask:runAction(ffa.seq(ffa.delay(0.7), ffa.callFunc(function()
			self.fields.mask:setVisible(false)
		end)))
		return
	end
	local _ENV, rewardsList1 = v, rewardsList[1]
	local _ENV, rewardsList2 = self.fields.mask.runAction, self.fields.mask.runAction
	self.controllers.c1:setSelectedIndex(0)
	rewardsList2, _ENV, rewardsList1, _ENV = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	for i, v in ipairs(rewardsList) do
		local isSkill = JudgeItemType(v.id) == gIDType.MAGIC_LAMP_SKILL
		v.isSkill = isSkill
		if i <= 3 then
			table.insert(rewardsList1, v)
		else
			table.insert(rewardsList2, v)
		end
	end
	self.rewardsList1 = rewardsList1
	self.rewardsList2 = rewardsList2
	self.showTime = 0.7
	self.fields.list_reward1:setNumItems(#self.rewardsList1)
	self.fields.list_reward2:setNumItems(#self.rewardsList2)
	self.fields.mask:runAction(ffa.seq(ffa.delay(self.showTime), ffa.callFunc(function()
		self.fields.mask:setVisible(false)
	end)))
end
function MagicLampMaigcPowerGainPanel:onItem1sRender(index, obj)
	local data = self.rewardsList1[index + 1]
	obj:initData(data)
	self:showInAni(obj, data, 1)
end
function MagicLampMaigcPowerGainPanel:onItem2sRender(index, obj)
	local data = self.rewardsList2[index + 1]
	obj:initData(data)
	self:showInAni(obj, data, 2)
end
function MagicLampMaigcPowerGainPanel:showInAni(obj, data, listIdx)
	self.showTime = obj:showInAni(self.showTime)
end
function MagicLampMaigcPowerGainPanel:onItem3sRender(index, obj)
	obj:initData(self.rewardsList[index + 1])
end
return MagicLampMaigcPowerGainPanel
