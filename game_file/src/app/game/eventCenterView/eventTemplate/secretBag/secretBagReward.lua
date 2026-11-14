local gametop = gModuleMgr.getObject("gametop")
local secretBagCtrl = gametop.playertop_:getModule("secretBagCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local secretBagReward = class("secretBagReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("secretBagReward")
	end
	return target
end)
function secretBagReward:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.nodeItems = SoraDGetChildByName(self, "Node_items")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.btnGain = SoraDGetChildByName(self, "Button_gain")
	self.btnGain:addTouchEventListener(handler(self, self.btnGainClick))
	self.imgBg = SoraDGetChildByName(self, "Image_contentBg")
	self.imgBg:setTouchEnabled(true)
end
function secretBagReward:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_OPENBOX", function(...)
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_ERRBACK", function(...)
		SoraDCloseLoading(self)
	end)
end
function secretBagReward:initData(curData)
	self.boxData = curData
	self.myCurCount = secretBagCtrl:getsecretBagTaskCount()
	local curLv = secretBagCtrl:getsecretBagData().curRewardLv
	local group = activityShowCtrl:getParamByID(gActivityTimeActivityID.KITS_ACTIVITY).classtype or 1
	self.myInfo = secretBagCtrl.localClass.getBoxInfo(self.boxData.taskNum, curLv, group)
	dump(self.myInfo, "self.myInfo")
	self:initView()
end
function secretBagReward:initView(...)
	_ENV = nil
	;(nil).num = self.boxData.taskNum
	self.txtTitle:setString(i18n("kits_text_02", nil))
	if not self.firstListItems then
		local publicRead = include("publicRead")
		_UPVALUE2_ = i18n("kits_text_02", nil)
		i18n("kits_text_02", nil)[1] = "id"
		i18n("kits_text_02", nil)[2] = "count"
		local award = serviceFunctions.tableFormat(self.myInfo.award, i18n("kits_text_02", nil))
		local perDis = 170
		local sPosX = -#award * perDis / 2
		for i, v in ipairs(award) do
			local itemParent = self.nodeItem:clone()
			itemParent:addTo(self.nodeItems)
			itemParent:setPosition(sPosX + (i - 1) * perDis + perDis / 2, 0)
			local itemName = SoraDGetChildByName(itemParent, "Text_itemName")
			itemName:setString(publicRead.getName(v.id))
			local item = SoraDGetExtendChildFromCCSByName(itemParent, "CCS_commonItemAward")
			item:setScale(1.1)
			item:setBaseScale(1.0)
			item:setOwnView(self)
			item:initData(v.id, tostring(v.count))
		end
		self.firstListItems = true
	end
	if self.myCurCount >= self.boxData.taskNum and self.boxData.receive == false then
		self.btnGain:setBright(true)
		self.btnGain:setTitleText(i18n("common_text_1146"))
	elseif self.myCurCount >= self.boxData.taskNum and self.boxData.receive == true then
		self.btnGain:setBright(false)
		self.btnGain:setTitleText(i18n("common_text_1892"))
	else
		self.btnGain:setBright(false)
		self.btnGain:setTitleText(i18n("common_text_1146"))
	end
end
function secretBagReward:btnGainClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.myCurCount >= self.boxData.taskNum and self.boxData.receive == false then
			SoraDShowLoading(self)
			secretBagCtrl:gainBoxReward(self.boxData.taskNum)
		elseif self.myCurCount >= self.boxData.taskNum and self.boxData.receive == true then
			SoraDShowMsgTip(i18n("common_text_1892"))
		else
			SoraDShowMsgTip(i18n("common_text_2930"))
		end
	end
end
return secretBagReward
