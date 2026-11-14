local SignRewardPopView = class("signRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("signRewardPopView")
	end
	return target
end)
function SignRewardPopView:ctor()
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.itemCopy = SoraDGetChildByName(self, "Image_itemBg")
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.btnGet:addTouchEventListener(handler(self, self.btnGetClick))
	self.nodeGold = SoraDGetChildByName(self, "Node_gold")
	self.nodeGoldSp = SoraDGetChildByName(self, "Node_goldSp")
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
	self.txtGoldTip = SoraDGetChildByName(self, "Text_goldTip")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.centerNode, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("decrypt_text_03"))
	self.nodeAward = SoraDGetChildByName(self.centerNode, "Node_Award")
	self:initCtrl()
end
function SignRewardPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.checkResEnough))
end
function SignRewardPopView:initCtrl(eid)
	print("pop", eid)
	self.activityID = eid or gActivityTimeActivityID.SIGN_REWARD_ACTIVITY
	self.signRewardCtrl = SoraDGetCtrl("signRewardCtrl")
end
function SignRewardPopView:checkResEnough()
	if not SoraDEnoughGold(self.infoTbl.needGold or 0, true) then
		self.txtGold:setColor(display.COLOR_RED)
	else
		self.txtGold:setColor(cc.c3b(255, 255, 0))
	end
end
function SignRewardPopView:begin2Action(...)
	self.centerNode:setScale(0.1)
end
function SignRewardPopView:setFromAction(pos)
	local fromPos = self:convertToNodeSpace(pos)
	local toPos = cc.p(self.centerNode:getPositionX(), self.centerNode:getPositionY())
	self.centerNode:setPosition(fromPos)
	_UPVALUE1_ = self.centerNode:getPositionY()
	self.centerNode:getPositionY()[1] = cca.scaleTo(0.3, 1)
	self.centerNode:getPositionY()[2] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.centerNode:getPositionY()[3] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.centerNode:getPositionY()[4] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.centerNode:getPositionY()[5] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.centerNode:runAction(cca.spawn(self.centerNode:getPositionY()))
end
function SignRewardPopView:initLampData(day)
	_ENV = nil
	;(nil).state = self.signRewardCtrl:getExtraRewardInfoByDay(day)
	;(nil).myDay = day
	self.infoTbl, (nil).itemList = nil, self.signRewardCtrl:getExtraAwardByDay(day)
	dump(self.infoTbl.itemList, "self.infoTbl.itemList")
	self:initLampView()
end
function SignRewardPopView:initLampView()
	self:listItem2Board(self.infoTbl.itemList)
	dump(self.infoTbl.itemList, "itemList")
	self.btnClick = nil
	self.nodeGold:setVisible(false)
	if gSignRewardStatus.CAN_NOT_RECEIVE == self.infoTbl.state then
		self.btnGet:setTitleText(i18n("common_text_1146"))
		self.btnGet:setBright(false)
		function self.btnClick(...)
			_ENV = nil
			;(nil).num = self.infoTbl.myDay
			SoraDShowMsgTip(i18n("common_text_2877", nil))
		end
	elseif gSignRewardStatus.ALREADY_RECEIVE == self.infoTbl.state then
		self.btnGet:setTitleText(i18n("common_text_1892"))
		self.btnGet:setTouchEnabled(false)
		self.btnGet:setBright(false)
	elseif gSignRewardStatus.CAN_RECEIVE == self.infoTbl.state then
		self.btnGet:setTitleText(i18n("common_text_1146"))
		function self.btnClick(...)
			local gametop = gModuleMgr.getObject("gametop")
			self.signRewardCtrl:sendGetExtraRewardMsg(self.infoTbl.myDay)
			if self.fatherLoading then
				self.fatherLoading()
			end
			self:removeFromParent()
		end
	end
	_ENV = i18n("common_text_1146")
	i18n("common_text_1146").num = self.infoTbl.myDay
	self.txtTip:setString(i18n("common_text_2877", i18n("common_text_1146")))
end
function SignRewardPopView:initData(day)
	_UPVALUE0_ = nil
	;(nil).state = self.signRewardCtrl:getSignTypeByDay(day)
	;(nil).curDay = self.signRewardCtrl:getCurDay()
	;(nil).myDay = day
	;(nil).itemList = self.signRewardCtrl:getAwardByDay(day)
	self.infoTbl, (nil).needGold = nil, self.signRewardCtrl:getCostGold()
	self:initView()
end
function SignRewardPopView:initView(...)
	self:listItem2Board(self.infoTbl.itemList)
	dump(self.infoTbl.itemList, "itemList")
	self.btnClick = nil
	if gSignRewardType.NO_SIGN == self.infoTbl.state then
		if self.infoTbl.curDay == self.infoTbl.myDay then
			self.nodeGold:setVisible(false)
			self.btnGet:setTitleText(i18n("common_text_2873"))
			function self.btnClick(...)
				self.signRewardCtrl:sendSignMsg()
				if self.fatherLoading then
					self.fatherLoading()
				end
				self:removeFromParent()
			end
		elseif self.infoTbl.curDay > self.infoTbl.myDay then
			self.nodeGold:setVisible(true)
			self.txtGoldTip:setString(i18n("common_text_2875"))
			self.txtGold:setString(self.infoTbl.needGold)
			SoraDToCenter(self.nodeGoldSp, 10, not SoraDFIsRA())
			self:checkResEnough()
			self.btnGet:setTitleText("")
			function self.btnClick(...)
				if SoraDEnoughGold(self.infoTbl.needGold) then
					self.signRewardCtrl:sendUseGoldSignMsg(self.infoTbl.myDay)
					if self.fatherLoading then
						self.fatherLoading()
					end
					self:removeFromParent()
				end
			end
		elseif self.infoTbl.curDay < self.infoTbl.myDay then
			self.nodeGold:setVisible(false)
			self.btnGet:setTitleText(i18n("common_text_2873"))
			self.btnGet:setBright(false)
			function self.btnClick(...)
				SoraDShowMsgTip(i18n("common_text_3070"))
			end
		end
	else
		self.nodeGold:setVisible(false)
		self.btnGet:setTitleText(i18n("common_text_1892"))
		self.btnGet:setTouchEnabled(false)
		self.btnGet:setBright(false)
	end
	_ENV = i18n("common_text_1892")
	i18n("common_text_1892").day = self.infoTbl.myDay
	self.txtTip:setString(i18n("common_text_2872", i18n("common_text_1892")))
end
function SignRewardPopView:listItem2Board(list)
	local publicRead = include("publicRead")
	local readArr = SoraDIntArr2Table(list)
	local keys = table.keys(readArr)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(list, nil)
	for i, value in ipairs(rewardList) do
		local item = self.itemCopy:clone()
		item:setPosition(0, 0)
		item:loadTexture(publicRead.getBg(value.id), ccui.TextureResType.plistType)
		item:getChildByName("Image_item"):loadTexture(publicRead.getIcon(value.id), ccui.TextureResType.plistType)
		item:getChildByName("Text_count"):setString("x" .. value.count)
		item:setTouchEnabled(true)
		item:setTag(tonumber(value.id))
		item:addTouchEventListener(handler(self, self.itemClick))
		item:addTo(self.nodeAward)
	end
	SoraDautoSortPos(self.nodeAward, 4, 1, cc.size(120, 120), not SoraDFIsRA())
end
function SignRewardPopView:btnGetClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnClick then
			self.btnClick()
		end
	end
end
function SignRewardPopView:setFatherLoading(handl)
	self.fatherLoading = handl
end
function SignRewardPopView:itemClick(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button, pos)
	end
end
function SignRewardPopView:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y)
		else
			self.pFloor:setPosition(pos.x, pos.y)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y)
	else
		self.pFloor:setPosition(pos.x, pos.y)
	end
	self.pFloor:addTo(self, 100)
end
return SignRewardPopView
