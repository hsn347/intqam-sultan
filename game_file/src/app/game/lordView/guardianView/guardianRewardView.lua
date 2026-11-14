local guardianRead = include("guardianRead")
local guardianCtrl = SoraDGetCtrl("guardianCtrl")
local guardianRewardView = class("guardianRewardView", function(target)
	return target or SoraDCreateTouchPanel("guardianRewardView")
end)
function guardianRewardView:ctor()
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.boxBg:setTitleName(i18n("common_text_854"))
	self.boxIcon = SoraDGetChildByName(self, "Image_Center_Icon")
	self.boxIcon:loadTexture("frame_protect_box.png", ccui.TextureResType.plistType)
	self.textReward = SoraDGetChildByName(self, "Text_LvName")
	self.textReward:setString(i18n("protect_text_10"))
	self.btnGetReard = SoraDGetChildByName(self, "Button_GetReward")
	self.btnGetReard:setTitleText(i18n("ramadan_text_29"))
	self.btnGetReard:loadTextures("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self:initData()
end
function guardianRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_GUARDIAN_REFRESH", handler(self, self.updateData))
end
function guardianRewardView:initData(target, data)
	self:updateData()
	local rewardData = guardianRead.getProperty(self.guardType == 0 and 1 or self.guardType, "reward")
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardData = serviceFunctions.tableFormat(rewardData, nil)
	for i, v in ipairs(rewardData) do
		local item = include("commonItemAward").new()
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:setPosition(0, 0)
		item:initData(v.id, v.count)
		item:addTo(self.nodeAward, 1, "item_" .. i)
	end
	SoraDToCenter(self.nodeAward, 100)
end
function guardianRewardView:updateData(target, data)
	self.isCanReceive = guardianCtrl:getIsCanReceive()
	self.guardType = guardianCtrl:getGuardType()
	self.btnGetReard:setTouchEnabled(self.isCanReceive)
	self.btnGetReard:setBright(self.isCanReceive)
	if self.isCanReceive and self.guardType ~= 0 then
		self.btnGetReard:setTitleText(i18n("common_text_854"))
		self.btnGetReard:getVirtualRenderer():setState(0)
	elseif self.guardType == 0 then
		self.btnGetReard:setTitleText(i18n("common_text_2274"))
		self.btnGetReard:getVirtualRenderer():setState(1)
	else
		self.btnGetReard:setTitleText(i18n("ramadan_text_29"))
		self.btnGetReard:getVirtualRenderer():setState(1)
	end
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
		return
	end
end
function guardianRewardView:btnClickGetReward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isCanReceive and self.guardType ~= 0 then
			guardianCtrl:sendReqGetReward()
		else
			self:layerClickCallBack(self, ccui.TouchEventType.ended)
		end
	end
end
return guardianRewardView
