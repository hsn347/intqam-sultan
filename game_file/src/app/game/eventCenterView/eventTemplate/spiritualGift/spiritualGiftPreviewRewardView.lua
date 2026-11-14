local gametop = gModuleMgr.getObject("gametop")
local spiritualGiftRead = include("spiritualGiftRead")
local spiritualGiftCtrl = SoraDGetCtrl("spiritualGiftCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local spiritualGiftPreviewRewardView = class("spiritualGiftPreviewRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("spiritualGiftPreviewRewardView")
	end
	return target
end)
singleNodeH = 100
function spiritualGiftPreviewRewardView:ctor()
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.SPIRITUAL_GIFT).classtype
	self:initControls()
end
function spiritualGiftPreviewRewardView:initControls()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.btnNafu = SoraDGetChildByName(self, "btn_nafu")
	self.btnPool = SoraDGetChildByName(self, "btn_pool")
	self.panelCut = SoraDGetChildByName(self, "Panel_cut")
	self.txtTitle = SoraDGetChildByName(self, "Text_name")
	self.Node_tt = SoraDGetChildByName(self, "Node_tt")
	self.txtName = SoraDGetChildByName(self.Node_tt, "Text_name")
	self.txtLucky = SoraDGetChildByName(self, "Text_lucky")
	self.scrollNafu = SoraDGetChildByName(self, "ScrollView_nafu")
	self.scrollPool = SoraDGetChildByName(self, "ScrollView_pool")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeNafuSingle = SoraDGetChildByName(self, "Node_nafu_single")
	self.btnNafu:addTouchEventListener(handler(self, self.btnNafuClick))
	self.btnPool:addTouchEventListener(handler(self, self.btnPoolClick))
	self.btnNafu:setTitleText(i18n("godGift_text_04"))
	self.btnPool:setTitleText(i18n("godGift_text_05"))
	self.btnPool:setPressedActionEnabled(false)
	self.btnNafu:setPressedActionEnabled(false)
	self.scrollNafu:setVisible(false)
	self.scrollPool:setVisible(true)
	self.Node_tt:setVisible(false)
	self.ccs_bg:setTitleName(i18n("decrypt_text_03"))
	self.txtName:setString(i18n("godGift_text_20"))
	self.txtLucky:setString(i18n("common_text_2078"))
	if IsArClient then
		self.panelCut:setPositionY(display.height / 2)
	end
	self.rewardList = spiritualGiftRead:getPrizePoolRewardsForPreview(self.group)
	self.luckyNumberList = spiritualGiftRead:getLuckyNumberInfo(self.group)
	self:initPoolScroll()
	self:initNafuScroll()
end
function spiritualGiftPreviewRewardView:onMessageListener()
end
function spiritualGiftPreviewRewardView:btnNafuClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.Node_tt:setVisible(false)
		self.scrollNafu:setVisible(false)
		self.scrollPool:setVisible(true)
		button:setEnabled(false)
		self.btnPool:setEnabled(true)
		button:loadTextures("btn_secondarybtn_long_01.png", "btn_secondarybtn_long_01.png", "btn_secondarybtn_long_01.png", ccui.TextureResType.plistType)
		self.btnPool:loadTextures("btn_secondarybtn_long_02.png", "btn_secondarybtn_long_02.png", "btn_secondarybtn_long_02.png", ccui.TextureResType.plistType)
	end
end
function spiritualGiftPreviewRewardView:btnPoolClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.Node_tt:setVisible(true)
		self.scrollNafu:setVisible(true)
		self.scrollPool:setVisible(false)
		button:setEnabled(false)
		self.btnNafu:setEnabled(true)
		button:loadTextures("btn_secondarybtn_long_01.png", "btn_secondarybtn_long_01.png", "btn_secondarybtn_long_01.png", ccui.TextureResType.plistType)
		self.btnNafu:loadTextures("btn_secondarybtn_long_02.png", "btn_secondarybtn_long_02", "btn_secondarybtn_long_02", ccui.TextureResType.plistType)
	end
end
function spiritualGiftPreviewRewardView:initNafuScroll()
	self.scrollNafu:removeAllChildren()
	local scrollH = math.max(self.scrollNafu:getContentSize().height, 100 * #self.luckyNumberList)
	self.scrollNafu:setInnerContainerSize(cc.size(515, scrollH))
	for i, v in ipairs(self.luckyNumberList) do
		local single = self.nodeNafuSingle:clone()
		single:setPosition(257, scrollH - (i - 1) * 100)
		single:addTo(self.scrollNafu)
		local txtNumber = SoraDGetChildByName(single, "BitmapFontLabel_1")
		txtNumber:setString(v.luckyNum)
		local txtFrom = SoraDGetChildByName(single, "text_timeValue")
		txtFrom = SoraDChangeTextToHtml(txtFrom)
		_ENV = cc.size(515, scrollH)
		_ENV, _ENV, cc.size(515, scrollH).coin = "%", v.proportion / 10 .. "%", v.proportion / 10 .. "%"
		;(v.proportion / 10 .. "%").coin, ("%").color = "%", "#FFFF00"
		local str = i18n_html("godGift_text_15", cc.size(515, scrollH))
		txtFrom:setString(str)
	end
end
function spiritualGiftPreviewRewardView:initPoolScroll()
	self.scrollPool:removeAllChildren()
	local scrollH = math.max(self.scrollPool:getContentSize().height, 660)
	self.scrollPool:setInnerContainerSize(cc.size(515, scrollH))
	for i, v in ipairs(self.rewardList) do
		local single = self.nodeSingle:clone()
		single:setPosition(257, scrollH - 300 * (i - 1) - 30)
		if i == 2 then
			single:setPosition(257, scrollH - 300 * (i - 1) - 130)
		end
		single:addTo(self.scrollPool)
		local txtSingleTitle = SoraDGetChildByName(single, "text_singleTitle")
		if i == 1 then
			txtSingleTitle:setString(i18n("godGift_text_06"))
		else
			txtSingleTitle:setString(i18n("godGift_text_07"))
		end
		for j = 1, #self.rewardList[i] do
			local itemAward = include("commonItemAward").new()
			itemAward:setScale(0.9)
			itemAward:setBaseScale(1.0)
			itemAward:setOwnView(self)
			itemAward:initData(self.rewardList[i][j][1], self.rewardList[i][j][2])
			if j < 5 then
				itemAward:setPosition(-160 + (j - 1) * 110, -75)
			elseif j < 9 then
				itemAward:setPosition(-160 + (j - 5) * 110, -180)
			else
				itemAward:setPosition(-160 + (j - 9) * 110, -285)
			end
			itemAward:addTo(single)
		end
	end
end
return spiritualGiftPreviewRewardView
