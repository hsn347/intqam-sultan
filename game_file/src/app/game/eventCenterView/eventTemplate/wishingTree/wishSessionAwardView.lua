local wishingTreeRead = include("wishingTreeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local wishSessionAwardView = class("wishSessionAwardView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("wishSessionAwardView")
end)
function wishSessionAwardView:ctor()
	self.activityId = gActivityTimeActivityID.WISH_TREE_ACTIVITY
	self.group = activityShowCtrl:getParamByID(self.activityId).classtype or 1
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.boxBg:setTitleName(i18n("common_text_854"))
	self.boxIcon = SoraDGetChildByName(self, "Image_Center_Icon")
	self.textReward = SoraDGetChildByName(self, "Text_LvName")
	self.textReward:setString(i18n("protect_text_10"))
	self.btnGetReard = SoraDGetChildByName(self, "Button_GetReward")
	self.btnGetReard:setTitleText(i18n("common_text_1146"))
	self.btnGetReard:addTouchEventListener(handler(self, self.btnClickGetReward))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
end
function wishSessionAwardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.updateData))
end
function wishSessionAwardView:initData(data)
	self.stage = data.index
	self.targetNum = data.num
	self.consumeGold = data.consumeGold or 0
	self.status = data.status and true or false
	_ENV = nil
	;(nil).activityID = self.activityId
	self:updateData(self, nil)
	_UPVALUE2_ = self
	self[1] = "id"
	self[2] = "count"
	local rewardData = serviceFunctions.tableFormat(data.reward, self)
	for i, v in ipairs(rewardData) do
		local item = include("commonItemAward").new()
		item:setScale(0.7)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:setPosition(0, 0)
		item:initData(v.id, v.count)
		item:addTo(self.nodeAward, 1, "item_" .. i)
	end
	SoraDToCenter(self.nodeAward, 90)
	_ENV = nil
	;(nil).num = string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, false))
	SoraDGetChildByName(self, "Text_Tips"):setString(i18n("wish_text_26", nil))
end
function wishSessionAwardView:updateData(target, data)
	if data.activityID == self.activityId then
		dump(data, "updateData -data", 10)
		self.consumeGold = data.updateData and data.updateData.consumeGold or self.consumeGold
		self.status = data.updateData and data.updateData.stageReward and data.updateData.stageReward[tostring(self.stage)] and true or self.status
		print("··consumeGold·- self.targetNum", self.consumeGold, self.targetNum, self.status)
		if self.status then
			self.btnGetReard:setBright(false)
			self.btnGetReard:setTouchEnabled(true)
			self.btnGetReard:setTitleText(i18n("common_text_1892"))
		else
			self.btnGetReard:setTitleText(i18n("common_text_1146"))
			self.btnGetReard:setBright(self.consumeGold >= self.targetNum)
			self.btnGetReard:setTouchEnabled(self.consumeGold >= self.targetNum)
		end
	end
end
function wishSessionAwardView:btnClickGetReward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.status then
			self:layerClickCallBack(self, ccui.TouchEventType.ended)
		else
			_ENV = self
			self.stage = self.stage
			activityTaskComponentCtrl:sendReqGetWishStageReward(self)
		end
	end
end
return wishSessionAwardView
