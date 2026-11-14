local pyramidClientModule = include("pyramidClientModule")
local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local PyramidPlayoffsStateView = class("pyramidPlayoffsStateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidPlayoffsView")
	end
	return target
end)
function PyramidPlayoffsStateView:ctor()
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSearch"):setTitle(i18n("common_text_3301"))
	self.btnRule = SoraDGetChildByName(self, "Button_rule")
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnRule:addTouchEventListener(handler(self, self.touchBtnClick))
	self.btnPrice:addTouchEventListener(handler(self, self.touchBtnClick))
	self:initData()
end
function PyramidPlayoffsStateView:initData(...)
	self.myState = pyramidClientModule.getPostSeasonShowState()
	self:initView()
end
function PyramidPlayoffsStateView:initView(...)
	if self.myState <= 2 then
		local labelValue = ccui.Text:create("", "", 22)
		labelValue:setAnchorPoint(cc.p(0.5, 0.5))
		labelValue:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		labelValue:ignoreContentAdaptWithSize(false)
		labelValue:setTextAreaSize(cc.size(580, 50))
		local sSize = self.scroll:getContentSize()
		labelValue:setPosition(sSize.width / 2, sSize.height / 2)
		labelValue:setString(i18n("pyramid_text_01"))
		labelValue:addTo(self.scroll)
	end
end
function PyramidPlayoffsStateView:touchBtnClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target == self.btnRule then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
		elseif target == self.btnPrice then
			if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
				SoraDCreatePanel("alliancePBLPrizeView"):show()
			else
				SoraDCreatePanel("pyramidPlayoffsPriceView"):show()
			end
		end
	end
end
return PyramidPlayoffsStateView
