local gametop = gModuleMgr.getObject("gametop")
local canyonTreasureCtrl = gametop.playertop_:getModule("canyonTreasureCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local canyonTreasureHuntRead = include("canyonTreasureHuntRead")
local canyonTreasureGetRewardPopView = class("canyonTreasureGetRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("canyonTreasureGetRewardPopView")
	end
	return target
end)
function canyonTreasureGetRewardPopView:ctor()
	self.activityID = gActivityTimeActivityID.HERO_FESTIVAL
	self:initControls()
end
function canyonTreasureGetRewardPopView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_score_title:setString(i18n("Promise_Summit_text_29"))
	self.btn_treasure:addTouchEventListener(handler(self, self.btnTreasureCallback))
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	self.btn_confirm:addTouchEventListener(handler(self, self.btnConfirmCallback))
	SoraDAutoSizeButtonTextByContent(self.btn_confirm)
	_ENV = handler(self, self.btnConfirmCallback)
	handler(self, self.btnConfirmCallback).num = 5
	self.text_five:setString(i18n("Canyon_Treasur_text_15", handler(self, self.btnConfirmCallback)))
	self.text_remainTime = SoraDChangeTextToHtml(self.text_remainTime)
	self.text_remainTime = SoraDCreateTimerLabel(self, self.text_remainTime)
	self.text_remainTime:setTimeLast(function(time)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, time
		;(nil).time, (nil).color = nil, cc.c3b(133, 73, 54)
		return i18n_html("Canyon_Treasur_text_17", nil, nil)
	end)
	self.text_remainTime:setTimeEndListener(function(...)
		self:removeFromParent()
	end)
	self.text_noDiscount:setString(i18n("Canyon_Treasur_text_24"))
end
function canyonTreasureGetRewardPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function canyonTreasureGetRewardPopView:initData(data, otherData)
	self.otherData = otherData
	for i, v in ipairs(data.rewards) do
		local item = SoraDCreatePanel("commonItemAward")
		item:setPosition(cc.p(0, 0))
		item:setOwnView(self)
		item:setScale(0.84)
		item:addTo(self.Node_rewards)
		item:initData(v.id, v.count)
	end
	SoraDToCenter(self.Node_rewards, 106, SoraDFIsRA())
	local price = canyonTreasureHuntRead.getTreasureCost(self.otherData.canyonTreasureType, self.otherData.times)
	if data.discount and data.discount < 100 and data.endTime and data.endTime > serviceFunctions.systemTime() then
		self.text_remainTime:beginTime(data.endTime - serviceFunctions.systemTime())
		self.text_originalPrice:setString(tostring(price))
		self.text_nowPrice:setString(tostring(math.ceil(price * data.discount / 100)))
		self.text_noDiscount:setVisible(false)
	else
		self.text_remainTime:setVisible(false)
		self.Node_originalPrice:setVisible(false)
		self.Node_nowPrice:setPositionX(108)
		self.text_nowPrice:setString(tostring(price))
		self.text_noDiscount:setVisible(true)
	end
	_ENV = tostring(price)
	tostring(price).num = self.otherData.times
	self.text_five:setString(i18n("Canyon_Treasur_text_15", tostring(price)))
	local iconImage = "icon_canyon_ordinary.png"
	if self.otherData.canyonTreasureType == gCanyonTreasureHuntType.HIGH then
		iconImage = "icon_canyon_advanced.png"
	end
	self.Image_gold_0_0:loadTexture(iconImage, ccui.TextureResType.plistType)
	self.Image_gold_0:loadTexture(iconImage, ccui.TextureResType.plistType)
end
function canyonTreasureGetRewardPopView:btnTreasureCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading()
		canyonTreasureCtrl:reqLottery(self.otherData.canyonTreasureType, self.otherData.times, true)
		self:removeFromParent()
	end
end
function canyonTreasureGetRewardPopView:btnConfirmCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function canyonTreasureGetRewardPopView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return canyonTreasureGetRewardPopView
