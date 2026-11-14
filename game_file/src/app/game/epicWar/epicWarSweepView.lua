local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarSweepView = class("epicWarSweepView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarSweepView")
	end
	return target
end)
function epicWarSweepView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("epicbattle_btn_01"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.labelDenominator = SoraDGetChildByName(self, "Text_denominator")
	self.itemUseSlider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.Button_sweep = SoraDGetChildByName(self, "Button_sweep")
	self.Button_sweep:addTouchEventListener(handler(self, self.btnSweepCallBack))
	self.Node_action = SoraDGetChildByName(self, "Node_action")
	self.Text_action = SoraDGetChildByName(self, "Text_action")
end
function epicWarSweepView:initData(gateData)
	self.gateData = gateData
	local curPoint = epicWarCtrl:getCurExploreCount()
	local leftCount = epicWarCtrl:getStageCurChallangeCount(self.gateData.stage)
	local maxCount = math.min(leftCount, math.floor(curPoint / SWEEP_COST_ACTION))
	epicWarCtrl = math.floor(curPoint / SWEEP_COST_ACTION)
	math.floor(curPoint / SWEEP_COST_ACTION).var = curPoint
	math.floor(curPoint / SWEEP_COST_ACTION).var1 = self.gateData.chapter
	math.floor(curPoint / SWEEP_COST_ACTION).var2 = self.gateData.index
	self.Text_tip:setString(i18n("epic_war_moppingupSure_desc", math.floor(curPoint / SWEEP_COST_ACTION)))
	epicWarCtrl = i18n("epic_war_moppingupSure_desc", math.floor(curPoint / SWEEP_COST_ACTION))
	i18n("epic_war_moppingupSure_desc", math.floor(curPoint / SWEEP_COST_ACTION)).maxValue = maxCount
	i18n("epic_war_moppingupSure_desc", math.floor(curPoint / SWEEP_COST_ACTION)).minValue = 1
	i18n("epic_war_moppingupSure_desc", math.floor(curPoint / SWEEP_COST_ACTION)).curValue = 1
	self.itemUseSlider:initData(i18n("epic_war_moppingupSure_desc", math.floor(curPoint / SWEEP_COST_ACTION)))
	self.labelDenominator:setString("/" .. maxCount)
	self.Text_action:setString(SWEEP_COST_ACTION)
	SoraDToCenter(self.Node_action)
end
function epicWarSweepView:sliderCallBack(value)
	self.Text_action:setString(value * SWEEP_COST_ACTION)
	SoraDToCenter(self.Node_action)
end
function epicWarSweepView:btnSweepCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local times = self.itemUseSlider:getSliderCurValue()
		epicWarCtrl:sendReqSweepStage(self.gateData.stage, times)
		self:removeFromParent()
	end
end
return epicWarSweepView
