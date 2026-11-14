local luckyFalconCtrl = SoraDGetCtrl("luckyFalconCtrl")
local luckyFalconRead = include("luckyFalconRead")
local commonMoreGiftView = class("commonMoreGiftView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonMoreGiftView")
	end
	return target
end)
function commonMoreGiftView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonItemSingle")
	self.scroll:setIsRight(SoraDFIsRA())
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Text_tip = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_tip"))
	self.button_claim = ccui.Button:create()
	self.button_claim:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	self.button_claim:setPosition(0, -40)
	self.button_claim:ignoreContentAdaptWithSize(false)
	self.button_claim:setContentSize(cc.size(216, 72))
	self.button_claim:setTitleFontSize(20)
	self.button_claim:setTitleText(i18n("common_text_1146"))
	self.button_claim:setVisible(false)
	self.button_claim:addTouchEventListener(function(btn, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if self.otherData and self.otherData.claimIndex then
				local rotteryTimes = luckyFalconCtrl:getRotteryTimes()
				local classType = luckyFalconCtrl:getClassType()
				local rewardInfo = luckyFalconRead.getRewardInfo(classType)
				if rotteryTimes < rewardInfo[self.otherData.claimIndex].lotteryTime then
					_ENV = nil
					;(nil).var = rewardInfo[self.otherData.claimIndex].lotteryTime
					SoraDShowMsgTip(i18n("luckyFalcon_text07", nil))
					return
				end
				luckyFalconCtrl:reqGetStageReward(self.otherData.claimIndex)
				SoraDShowLoading(self)
				self:removeFromParent()
			end
		end
	end)
	self.button_claim:addTo(self.Center_Node, 2)
end
function commonMoreGiftView:initData(reward, title, tip, otherData)
	self.ccs_bg:setTitleName(title)
	self.Text_tip:setString(tip)
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = self.scroll
	;(nil).scale = 0.8
	;(nil).offset = cc.p(45, 45)
	self.scroll:updateScrollView(cc.size(90, 90), reward, #reward, nil)
	self.otherData = otherData
	if #reward == 1 then
		self.ccs_bg:setSize(cc.size(500, 300))
		self.ccs_bg:setPosition(-252, -100)
		self.scroll:setContentSize(cc.size(400, 150))
		self.scroll:setPositionY(130)
	end
	if self.otherData and self.otherData.claimIndex then
		self.button_claim:setVisible(true)
		local isGot = luckyFalconCtrl:isStageRewardGot(self.otherData.claimIndex)
		self.button_claim:setTitleText(isGot and i18n("common_text_1892") or i18n("common_text_1146"))
		self.button_claim:setBright(not isGot)
		self.button_claim:setEnabled(not isGot)
	end
end
return commonMoreGiftView
