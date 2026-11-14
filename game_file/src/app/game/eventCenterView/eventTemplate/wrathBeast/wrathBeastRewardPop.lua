local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local wrathBeastRewardPop = class("wrathBeastRewardPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("wrathBeastRewardPop")
	end
	return target
end)
function wrathBeastRewardPop:ctor()
	self:initWidget()
end
function wrathBeastRewardPop:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.btnGet:addTouchEventListener(handler(self, self.btnGetClick))
end
function wrathBeastRewardPop:onMessageListener(...)
end
function wrathBeastRewardPop:initData(index)
	self.boxData = wrathBeastCtrl:getBoxRewardConfig(index)
	local receivedReward = wrathBeastCtrl:getActivityData("receivedReward")
	self.isReceived = receivedReward[tostring(index)]
	self.totalDamage = wrathBeastCtrl:getActivityData("totalDamage")
	self:initView()
end
function wrathBeastRewardPop:initView(...)
	if not self.firstListItems then
		local publicRead = include("publicRead")
		local fillItem = function(ocx, tbl)
			local award = include("commonItemAward").new()
			award:setOwnView(self)
			award:setScale(1.0)
			award:addTo(ocx)
			award:initData(tbl.id, tbl.count)
			award:setPosition(cc.p(0, 0))
			local itemName = ocx:getChildByName("Text_itemName")
			itemName:setString(publicRead.getName(tbl.id))
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local award = serviceFunctions.tableFormat(self.boxData.reward, nil)
		local perDis = 104.5
		local sPosX = -#award * perDis / 2
		for i, v in ipairs(award) do
			local item = self.nodeItem:clone()
			item:setScale(0.85)
			item:addTo(self.nodeReward)
			item:setPosition(sPosX + (i - 1) * perDis + perDis / 2, 0)
			fillItem(item, v)
		end
		local lineNum = 5
		local lineMax = math.ceil(#award / lineNum)
		if 1 < lineMax then
			SoraDautoSortPos(self.nodeReward, lineNum, 1, cc.size(perDis, perDis + 40), not SoraDFIsRA())
			local offset = (lineMax - 1) * perDis
			local sSize = self.ccs_bg:getSize()
			self.ccs_bg:setSize(cc.size(sSize.width, sSize.height + offset))
			self.scaleActTarget:setPositionY(self.scaleActTarget:getPositionY() + offset / 2)
			self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() - offset)
			self.btnGet:setPositionY(self.btnGet:getPositionY() - offset)
			self.nodeReward:setPositionY(self.nodeReward:getPositionY() - offset / 2)
		end
		self.firstListItems = true
	end
	local myNumStr = self.boxData.num
	if self.isReceived then
		self.myState = 1
		self.btnGet:setBright(false)
		self.btnGet:setTitleText(i18n("common_text_1892"))
	elseif myNumStr <= self.totalDamage then
		self.myState = 2
		self.btnGet:setBright(true)
		self.btnGet:setTitleText(i18n("common_text_1146"))
	else
		self.myState = 3
		self.btnGet:setBright(true)
		self.btnGet:setTitleText(i18n("common_text_054"))
	end
end
function wrathBeastRewardPop:btnGetClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.myState == 1 then
			SoraDShowMsgTip(i18n("common_text_1892"))
		elseif self.myState == 2 then
			wrathBeastCtrl:sendReqGetRewardMsg(self.boxData.index)
			self:removeFromParent()
		elseif self.myState == 3 then
			self:removeFromParent()
		end
	end
end
return wrathBeastRewardPop
