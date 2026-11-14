local gametop = gModuleMgr.getObject("gametop")
local ramadanRewardCtrl = gametop.playertop_:getModule("ramadanRewardCtrl")
local celebratePopWindow = class("celebratePopWindow", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("celebratePopWindow")
	end
	return target
end)
function celebratePopWindow:ctor()
	self.rewards, _ENV, self.isAddToPopManager = nil, nil, true
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	SoraDGetChildByName(self, "Image_contentBg"):setFillType(1)
	self.spBgBox = SoraDGetChildByName(self, "bg_activity_show_box_3")
	self.title = SoraDGetChildByName(self, "Text_title")
	self.title:setString(i18n("rechare_activename_1204"))
	self.activityTime = SoraDGetChildByName(self, "Text_activity_time")
	self.tip = SoraDGetChildByName(self, "Text_tip")
	self.tip:setString(i18n("common_text_1695"))
	for i = 1, 4 do
		self.rewards[i] = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_" .. i)
	end
	self.btnGain = SoraDGetChildByName(self, "Button_gain")
	self.btnGain:setTitleText(i18n("common_text_1696"))
	self.btnGain:addTouchEventListener(handler(self, self.btnGainClick))
	self:initAnimation()
	self:initData()
end
function celebratePopWindow:initAnimation()
	local Node_fireWork = SoraDGetChildByName(self, "Node_fireWork")
	Node_fireWork:setPositionY(display.height - 960)
	local fireWork = SoraDCreatAnimation("animationFireWork")
	fireWork:addTo(Node_fireWork)
	local Node_girl = SoraDGetChildByName(self, "Node_girl")
	local spine_girl = sp.SkeletonAnimation:create("spine/huodongzhanshi.skel", "spine/huodongzhanshi.atlas", 1)
	spine_girl:setPosition(0, 0)
	spine_girl:addTo(Node_girl)
	spine_girl:setAnimation(0, "animation", true)
	self.Center_Node:setScale(0)
	self.Center_Node:runAction(cc.EaseBackOut:create(cca.scaleTo(0.2, 1.0)))
end
function celebratePopWindow:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_REFRESH", handler(self, self.refreshCelebrateGift))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_BACK", handler(self, self.receiveCelebrateGiftBack))
end
function celebratePopWindow:initData()
	local beginTime = ramadanRewardCtrl:getBeginTime()
	local endTime = ramadanRewardCtrl:getEndTime()
	ramadanRewardCtrl = nil
	;(nil).time = os.date("%Y.%m.%d", beginTime) .. "~" .. os.date("%Y.%m.%d", endTime)
	self.activityTime:setString(i18n("common_text_1694", nil))
	self.reward = ramadanRewardCtrl:getReward()
	for k, v in ipairs(self.reward) do
		if self.rewards[k] then
			self.rewards[k]:setOwnView(self)
			self.rewards[k]:initData(v.id, v.count)
			self.rewards[k]:setBaseScale(1.0)
		end
	end
	local isReceived = ramadanRewardCtrl:getIsReceive()
	local isOpen = ramadanRewardCtrl:getIsOpen()
	local isEnable = isOpen and not isReceived
	self.btnGain:setBright(isEnable)
	self.btnGain:setTitleColor(isEnable and cc.c3b(255, 255, 255) or cc.c3b(127, 127, 127))
	self.btnGain:setEnabled(isEnable)
end
function celebratePopWindow:btnGainClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		ramadanRewardCtrl:sendReceiveCelebrate()
	end
end
function celebratePopWindow:showGetRewards()
	SoraDMailGainItems(self.reward, true)
end
function celebratePopWindow:refreshCelebrateGift(target, data)
	local isOpen = ramadanRewardCtrl:getIsOpen()
	if not isOpen and not tolua.isnull(self) then
		self:removeFromParent()
	end
end
function celebratePopWindow:receiveCelebrateGiftBack(target, data)
	local err = data.err
	if err == gErrDef.Err_None and not tolua.isnull(self) then
		self:showGetRewards()
		self:removeFromParent()
	end
end
return celebratePopWindow
