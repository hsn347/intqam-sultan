local LOOP_TIME = 30
local LOOP_DIS = 693
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroNewTrialHookViewPanel = class("HeroNewTrialHookViewPanel", baseFguiPanel)
function HeroNewTrialHookViewPanel:ctor(...)
	HeroNewTrialHookViewPanel.super.ctor(self, ...)
	print("HeroNewTrialHookViewPanel:ctor", self.viewName)
end
function HeroNewTrialHookViewPanel:onInit()
	print("=======HeroNewTrialHookViewPanel:onInit")
	self.isLoop = true
	self.toIndex = 1
	self.fields.Com_title:initData(i18n("hero_experience_04"), handler(self, self.onClickClose))
	self.fields.Button_box:addClickListener(handler(self, self.btnClick))
end
function HeroNewTrialHookViewPanel:onShow()
	print("=======HeroNewTrialHookViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.heroID = self.param and self.param.heroID
	self.afkTimeMax = heroNewTrialCtrl:getAfkTimeMax()
	self.bgInitPosY = self.fields.bg:getPositionY()
	self:setLoopAni()
	heroNewTrialCtrl:reqAfkInit(self.heroID)
	SoraDShowLoading(self)
end
function HeroNewTrialHookViewPanel:setLoopAni()
	self.fields.npc:loopNpc(self.isLoop, LOOP_TIME)
	if self.isLoop then
		_ENV = LOOP_TIME
		LOOP_TIME[1] = ffa.moveTo(LOOP_TIME, self.fields.bg:getPositionX(), self.bgInitPosY + LOOP_DIS * self.toIndex)
		LOOP_TIME[2] = ffa.callFunc(function()
			self.isLoop = not self.isLoop
			self:setLoopAni()
			self.fields.bg:getChild("Com_stage" .. self.toIndex):doing(handler(self, self.nextTurn))
		end)
		LOOP_TIME[3] = ffa.callFunc(function()
			self.isLoop = not self.isLoop
			self:setLoopAni()
			self.fields.bg:getChild("Com_stage" .. self.toIndex):doing(handler(self, self.nextTurn))
		end)
		LOOP_TIME[4] = ffa.callFunc(function()
			self.isLoop = not self.isLoop
			self:setLoopAni()
			self.fields.bg:getChild("Com_stage" .. self.toIndex):doing(handler(self, self.nextTurn))
		end)
		LOOP_TIME[5] = ffa.callFunc(function()
			self.isLoop = not self.isLoop
			self:setLoopAni()
			self.fields.bg:getChild("Com_stage" .. self.toIndex):doing(handler(self, self.nextTurn))
		end)
		LOOP_TIME[6] = ffa.callFunc(function()
			self.isLoop = not self.isLoop
			self:setLoopAni()
			self.fields.bg:getChild("Com_stage" .. self.toIndex):doing(handler(self, self.nextTurn))
		end)
		self.fields.bg:runAction(ffa.seq(LOOP_TIME))
	else
		print("self.bgInitPosY=====", self.bgInitPosY, self.bgInitPosY + LOOP_DIS * self.toIndex)
		self.fields.bg:stopAllActions()
	end
end
function HeroNewTrialHookViewPanel:nextTurn()
	self.isLoop = not self.isLoop
	self.fields.bg:getChild("Com_stage" .. self.toIndex):idle()
	self.toIndex = self.toIndex + 1
	if self.toIndex >= 3 then
		self.toIndex = 1
		self.fields.bg:setPositionY(self.bgInitPosY)
	end
	self:setLoopAni()
end
function HeroNewTrialHookViewPanel:onMsgUpdateView(target, event)
	SoraDCloseLoading(self)
	local subMsg = event.subMsg
	if subMsg == "afkInit" then
		local afkTime = heroNewTrialCtrl:getAfkTime(self.heroID)
		self.fields.Button_box:setTime(afkTime - 1, true, self.afkTimeMax)
		if not event.rewardMap then
			local _ENV, rewardMap = event.rewardMap, event.rewardMap
		end
		self.fields.Button_box:setState(table.nums(rewardMap) > 0 and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO)
	elseif subMsg == "afkCliam" then
		self.fields.Button_box:setTime(-1, true)
		self.fields.Button_box:setState(gBtnTargetStatusDef.GO)
	end
end
function HeroNewTrialHookViewPanel:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroID = self.heroID
	uiManager:show("HeroNewTrialHook2", nil)
end
return HeroNewTrialHookViewPanel
