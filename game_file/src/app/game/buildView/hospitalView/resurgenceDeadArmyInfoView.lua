local gametop = gModuleMgr.getObject("gametop")
local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
local ResurgenceDeadArmyInfoView = class("resurgenceDeadArmyInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("resurgenceDeadArmyInfoView")
	end
	return target
end)
function ResurgenceDeadArmyInfoView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2506"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_army")
	self.Node_tt = SoraDGetChildByName(self, "Node_tt")
	self.labelTotalDead = SoraDGetChildByName(self, "Text_totalDead")
	self.Button_detail = SoraDGetChildByName(self, "Button_detail")
	self.spriteFuhuo = SoraDGetChildByName(self, "Sprite_fuhuo")
	self.spriteSunshi = SoraDGetChildByName(self, "Sprite_sunshi")
	self.labelResurgence = SoraDGetChildByName(self, "Text_resurgence")
	self.labelDead = SoraDGetChildByName(self, "Text_dead")
	self.labelTitile2 = SoraDGetChildByName(self, "Text_titile2")
	self.labelTitile2:setString(i18n("recharge_label_003"))
	self.labelResurgence:setString(i18n("common_text_2508"))
	self.labelDead:setString(i18n("common_text_2507"))
	self.Button_detail:addTouchEventListener(handler(self, self.onDetailClick))
	self:initData()
end
function ResurgenceDeadArmyInfoView:initData()
	local armyData = resurrectionCtrl:getResurrectionHistory()
	local totalCount = resurrectionCtrl:getTotalArmy()
	if 0 < totalCount then
		resurrectionCtrl = nil
		;(nil).total = string.formatnumberthousands(totalCount)
		self.labelTotalDead:setString(i18n("common_text_2509", nil))
		local scrollH = math.max(self.scroll:getContentSize().height, #armyData * 90)
		for i, v in ipairs(armyData) do
			local single = SoraDCreatePanel("resurgenceDeadArmyInfoSingle")
			single:initData(v)
			single:addTo(self.scroll)
			single:setPosition(cc.p(0, scrollH - 90 * i))
		end
		self.scroll:setInnerContainerSize(cc.size(533, scrollH))
	else
		self.labelTotalDead:setString(i18n("common_text_2504"))
	end
	SoraDToCenter(self.Node_tt, 10)
end
function ResurgenceDeadArmyInfoView:onDetailClick(target, event)
	if event == ccui.TouchEventType.ended then
		print("点击详情=======")
		local panel = SoraDCreatePanel("deadArmyDetailView")
		panel:initData(resurrectionCtrl:getDeadArmySource())
		panel:show()
	end
end
function ResurgenceDeadArmyInfoView:onExitPanel()
	if resurrectionCtrl:getResurrectionState() == gResurrectionActivityState.OPEN then
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		guideCtrl:updateGuideModule(gGuideModule.REVIVE_TREE)
	end
end
return ResurgenceDeadArmyInfoView
