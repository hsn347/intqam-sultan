local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PickupStarsAgainMainPanel = class("PickupStarsAgainMainPanel", baseFguiPanel)
function PickupStarsAgainMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.tabIndex = 1
	print("PickupStarsAgainMainPanel:ctor", self.viewName)
end
function PickupStarsAgainMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function PickupStarsAgainMainPanel:onInit()
	print("=======PickupStarsAgainMainPanel:onInit")
	if self.fields.Ani_sand then
		self.fields.Ani_sand:setAllFrameName("dh_Tex_XL_zlxc01_001_%.3d", 0)
	end
	self.fields.Com_title:initData(i18n("activity_name_9001460"), handler(self, self.onClickClose), handler(self, self.onClickHelper))
	local tabIndex = pickupStarsAgainCtrl:isStageOne() and 1 or 2
	_ENV = handler(self, self.onClickClose)
	_ENV, _ENV, handler(self, self.onClickClose).defaultClick = handler(self, self.onClickHelper)
	handler(self, self.onClickHelper).title = i18n("activity_name_9001460")
	_ENV, handler(self, self.onClickHelper)[1], handler(self, self.onClickHelper).tag = handler(self, self.onClickHelper)
	handler(self, self.onClickHelper).title = i18n("pickup_star_001")
	handler(self, self.onClickClose).tabsetArray, handler(self, self.onClickHelper)[2], handler(self, self.onClickHelper).tag = handler(self, self.onClickHelper)
	handler(self, self.onClickClose).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((handler(self, self.onClickClose)))
	self.fields.Label_time:setTimeEndListener(function()
		if self.tabIndex == 1 then
			self.fields.Com_tab:setToTag(2)
			self.tabIndex = 2
			SoraDRemoveAllAfterPanelFromManager(self, true)
			self:updateUI()
		end
	end)
end
function PickupStarsAgainMainPanel:onClickHelper()
	_ENV = nil
	;(nil).content = i18n("pickup_star_002")
	uiManager:show("RuleView", nil)
end
function PickupStarsAgainMainPanel:onClickTab(index)
	self.tabIndex = index
	self:updateUI()
end
function PickupStarsAgainMainPanel:onShow()
	print("=======PickupStarsAgainMainPanel:onShow")
	self.isFirst = true
	self.fields.Label_time:beginTime(pickupStarsAgainCtrl:getActivityLeftTime())
	self:updateUI()
end
function PickupStarsAgainMainPanel:updateUI()
	if self.tabIndex == 1 then
		if not pickupStarsAgainCtrl:isStageOne() then
			SoraDShowMsgTip(i18n("Nebulaking_text_06"))
			if pickupStarsAgainCtrl:isDesertMeteoriteUnlock() then
				self.fields.Com_tab:setToTag(2)
				self.tabIndex = 2
			end
		end
	elseif not pickupStarsAgainCtrl:isDesertMeteoriteUnlock() then
		SoraDShowMsgTip(i18n("common_text_2486"))
		if pickupStarsAgainCtrl:isStageOne() then
			self.fields.Com_tab:setToTag(1)
			self.tabIndex = 1
		end
	end
	local isDesertMeteoriteUnlock = pickupStarsAgainCtrl:isDesertMeteoriteUnlock()
	self.fields.Com_tab:setBtnLock2(not isDesertMeteoriteUnlock)
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	local isStageOne = pickupStarsAgainCtrl:isStageOne()
	self.fields.Com_tab:setBtnLock1(not isStageOne)
	if isStageOne then
		self.fields.Label_time:beginTime(pickupStarsAgainCtrl:getStageOneLeftTime())
	else
		self.fields.Label_time:beginTime(pickupStarsAgainCtrl:getActivityLeftTime())
	end
	self.fields.Com_tab:setBtnRedDot(1, pickupStarsAgainCtrl:stageOneReddot())
	self.fields.Com_tab:setBtnRedDot(2, pickupStarsAgainCtrl:stageTwoReddot())
	if self.tabIndex == 1 then
		self.fields.Panel_restore:updateUI()
		local globalScore = pickupStarsAgainCtrl:getGlobalScore()
		local roundCfg = pickupStarsAgainRead:getCurGlobalRound(globalScore)
		local stage = roundCfg.Rank
		print("stage===", stage, self.isFirst, pickupStarsAgainCtrl:getLastStage())
		if self.isFirst then
			self.fields.Com_astrolabe:initData(stage)
			pickupStarsAgainCtrl:setLastStage(stage)
		elseif pickupStarsAgainCtrl:getLastStage() ~= stage then
			pickupStarsAgainCtrl:setLastStage(stage)
			if 1 < stage then
				self.fields.Com_astrolabe:initData(stage - 1)
				self.fields.Usm_sand:play(false)
				if stage == 5 then
					SoraDDelayCallOnce("PickupStarsAgainMainPanel:showMaxEffect", function()
						self.fields.Usm_max:play(false)
					end, 1, true)
				end
				self.fields.Com_astrolabe:showStageEffect(function()
					self.fields.Com_astrolabe:initData(stage)
				end)
			end
		end
		self.isFirst = false
	else
		self.fields.Panel_collection:updateUI()
		self.fields.Com_astrolabe:initData(5)
	end
end
function PickupStarsAgainMainPanel:onDispose()
	SoraDManagerRemoveTimerByTarget("PickupStarsAgainMainPanel:showMaxEffect")
end
return PickupStarsAgainMainPanel
