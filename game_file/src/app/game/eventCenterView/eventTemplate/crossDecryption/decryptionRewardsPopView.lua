local gametop = gModuleMgr.getObject("gametop")
local crossDecryptionCtrl = gametop.playertop_:getModule("crossDecryptionCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
local decryptionRewardsPopView = class("decryptionRewardsPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("decryptionRewardsPopView")
	end
	return target
end)
function decryptionRewardsPopView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("decrypt_text_03"))
	self.node_rewards = SoraDGetChildByName(self, "Node_rewards")
	self.btn_receive = SoraDGetChildByName(self, "Button_receive")
	self.btn_receive:addTouchEventListener(handler(self, self.btnOperateClick))
end
function decryptionRewardsPopView:initData(data, ctrl, crossDecryptionRead)
	ctrl = {}
	if not crossDecryptionCtrl:getRewardData() then
		crossDecryptionCtrl = crossDecryptionCtrl:getRewardData()
	end
	self.rewardData = crossDecryptionCtrl:getRewardData()
	self.canReceive = data.canReceived
	self.curIndex = data.idx
	self.activityID = crossDecryptionCtrl:getActivityType()
	local rewards = crossDecryptionRead.getRewardByLine(self.curIndex, self.activityID).Reward
	if rewards then
		for k, v in ipairs(rewards) do
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(self.node_rewards)
			single:setScale(0.8)
			single:setBaseScale(1.0)
			local pos = -230 + k * 90
			if SoraDFIsRA() then
				pos = 230 - k * 90
			end
			single:setPositionX(pos)
			single:setPositionY(0)
			single:setOwnView(self)
			single:initData(v.id, v.count)
		end
	end
	self.btn_receive:setBright(data.canReceived)
	if data.canReceived then
		self.btn_receive:setTitleColor(cc.c3b(255, 255, 255))
		self.btn_receive:loadTextureNormal("btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.btn_receive:setTitleText(i18n("common_text_854"))
	else
		self.btn_receive:setTitleColor(cc.c3b(110, 110, 110))
		if self.rewardData[tostring(self.curIndex)] then
			self.btn_receive:setTitleText(i18n("common_text_1892"))
		else
			self.btn_receive:setTitleText(i18n("common_text_854"))
		end
	end
end
function decryptionRewardsPopView:btnOperateClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.canReceive then
			local loading = SoraDShowLoading(sender, sender:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
			_ENV = cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)
			cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).index = self.curIndex
			crossDecryptionCtrl:reqGetReward(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
			self:close(sender, event)
		elseif not self.rewardData[tostring(self.curIndex)] then
			local isrow = self.curIndex % 2 == 1
			local row = isrow and (self.curIndex + 1) / 2 or 0
			local line = not isrow and self.curIndex / 2 or 0
			SoraDShowMsgTip(i18n(isrow and "anniversary_cross_text_02" or "anniversary_cross_text_06"))
		end
	end
end
return decryptionRewardsPopView
