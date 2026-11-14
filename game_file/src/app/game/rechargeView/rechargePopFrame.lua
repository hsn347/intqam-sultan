local gametop = gModuleMgr.getObject("gametop")
local rechargeRead = include("rechargeRead")
local RechargePopFrame = class("rechargePopFrame", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargePopFrame")
	end
	return target
end)
function RechargePopFrame:ctor()
	self.isHideCurrentSceneView = true
	self.packageList, _ENV, self.isAddToPopManager = nil, nil, true
	self.packageIndex = 1
	self.fromCenter = nil
	self.canClick = true
	self.btnLeft = SoraDGetChildByName(self, "Top_Button_left")
	self.btnRight = SoraDGetChildByName(self, "Top_Button_right")
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node_center")
	self.nodeOutSide = SoraDGetChildByName(self, "Center_Node_outSide")
	self.panelGiftTouch = SoraDGetChildByName(self, "Panel_touchPad")
	self.pagePoint = include("commonIndexNumber").new()
	self.pagePoint:setPosition(320, 12)
	self.pagePoint:addTo(self, 99)
	local judge2move = function(_sprite, _forward)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveBy(1, _forward * 15, 0)
		;(nil)[2] = cca.moveBy(1, -_forward * 15, 0)
		;(nil)[3] = cca.moveBy(1, -_forward * 15, 0)
		;(nil)[4] = cca.moveBy(1, -_forward * 15, 0)
		;(nil)[5] = cca.moveBy(1, -_forward * 15, 0)
		local seqList = cca.seq(nil)
		local acList = cc.RepeatForever:create(seqList)
		_sprite:runAction(acList)
	end
	judge2move(self.btnRight:getChildByName("Sprite_arrow"), -1)
	judge2move(self.btnLeft:getChildByName("Sprite_arrow"), -1)
	self.btnRight:addTouchEventListener(handler(self, self.btnRightClick))
	self.btnLeft:addTouchEventListener(handler(self, self.btnLeftClick))
	self.panelGiftTouch:setTouchEnabled(true)
	self.panelGiftTouch:setSwallowTouches(false)
	self.panelGiftTouch:addTouchEventListener(function(panel, eventType)
		if eventType == ccui.TouchEventType.ended then
			local touchBeganPoint = panel:getTouchBeganPosition()
			local touchmovePoint = panel:getTouchEndPosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			print("distance = ", distance)
			if 10 <= distance then
				if touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
					print("右移")
					self:btnLeftClick(self.btnLeft, ccui.TouchEventType.ended)
				elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
					print("左移")
					self:btnRightClick(self.btnRight, ccui.TouchEventType.ended)
				end
			end
		end
	end)
end
function RechargePopFrame:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWFRAMECLOSE", function(target, data)
		if not tolua.isnull(self) then
			if data and data.isForceClose then
				self:removeFromParent()
			else
				self:reInitData()
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", function(...)
		if not tolua.isnull(self) then
			self:reInitData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH", function(...)
		if not tolua.isnull(self) then
			self:reInitData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_MAIN_BREAKICE_UPDATE", function(...)
		if not tolua.isnull(self) then
			self:reInitData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_BUY_PACKAGE", function(...)
		print("关闭了吗111")
		if not tolua.isnull(self) then
			SoraDCloseLoading()
			self:removeFromParent()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_REQ_NEW_PRINCE_GIFT_BUY_PACKAGE", function(...)
		print("关闭了吗111")
		if not tolua.isnull(self) then
			SoraDCloseLoading()
			self:removeFromParent()
		end
	end)
end
function RechargePopFrame:reInitData()
	local rIndex = 0
	local isLoaded = false
	self.packageList, gametop = nil, nil
	self.packageIndex = 1
	local luckyGiftCtrl = gametop.playertop_:getModule("luckyGiftCtrl")
	local gametop, luckyGiftList = gametop.playertop_, gametop.playertop_
	if self.isChoiceGift then
		luckyGiftList = luckyGiftCtrl:getChoiceLuckyGiftData(true)
	else
		luckyGiftList = luckyGiftCtrl:getLuckyGiftData(true)
	end
	for i, v in ipairs(luckyGiftList) do
		if rechargeRead.hasRechargeItem(v.luckyGiftID) then
			gametop = nil
			;(nil).id = tonumber(v.luckyGiftID)
			;(nil).giftType = "luckyGift"
			;(nil).isChoiceGift = self.isChoiceGift
			table.insert(self.packageList, nil)
			rIndex = rIndex + 1
			if tonumber(v.luckyGiftID) == tonumber(self.pointID) then
				self.packageIndex = rIndex
				isLoaded = true
			end
		end
	end
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local activeDataList = rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList())
	local gametop, activeGiftList = rechargeActivityCtrl, rechargeActivityCtrl
	for k, v in pairs(activeDataList) do
		if paymentManager.judgeGiftExclusive(tonumber(k)) then
			gametop = tonumber(k)
			tonumber(k).id = tonumber(k)
			tonumber(k).giftType = "normalGift"
			tonumber(k).weight = v.weight
			table.insert(activeGiftList, tonumber(k))
		end
	end
	table.sort(activeGiftList, function(l, r)
		local lWeight = l.weight or 0
		local rWeight = r.weight or 0
		return lWeight > rWeight
	end)
	for _, v in ipairs(activeGiftList) do
		gametop = tonumber(k)
		tonumber(k).id = v.id
		tonumber(k).giftType = "normalGift"
		table.insert(self.packageList, tonumber(k))
		rIndex = rIndex + 1
		if tonumber(v.id) == tonumber(self.pointID) then
			self.packageIndex = rIndex
			isLoaded = true
		end
	end
	local iceBreakCtrl = gametop.playertop_:getModule("iceBreakCtrl")
	local iceBreakData = clone(iceBreakCtrl:getIceBreakData())
	if next(iceBreakData) and paymentManager.judgeGiftExclusive(tonumber(iceBreakData.iceBreakID)) then
		gametop = tonumber(iceBreakData.iceBreakID)
		tonumber(iceBreakData.iceBreakID).id = tonumber(iceBreakData.iceBreakID)
		tonumber(iceBreakData.iceBreakID).giftType = "iceBreakGift"
		table.insert(self.packageList, tonumber(iceBreakData.iceBreakID))
		rIndex = rIndex + 1
		if tonumber(iceBreakData.iceBreakID) == tonumber(self.pointID) then
			self.packageIndex = rIndex
			isLoaded = true
		end
	end
	local princeGiftNewCtrl = gametop.playertop_:getModule("princeGiftNewCtrl")
	if princeGiftNewCtrl:getNewPrinceData() then
		rIndex = rIndex + 1
		if tonumber(self.pointID) == princeGiftNewCtrl:getGiftID() then
			self.packageIndex = rIndex
			isLoaded = true
		end
		gametop = princeGiftNewCtrl
		princeGiftNewCtrl.id = princeGiftNewCtrl:getGiftID()
		princeGiftNewCtrl.giftType = "normalGift"
		table.insert(self.packageList, princeGiftNewCtrl)
	end
	dump(self.packageList, "self.packageList")
	print("self.packageIndex,isLoaded = ", self.packageIndex, isLoaded)
	if next(self.packageList) == nil then
		self:removeFromParent()
		return
	end
	self.nodeCenter:removeAllChildren()
	self:initView()
end
function RechargePopFrame:initData(_id, fromCenter, isChoiceGift)
	self.fromCenter = fromCenter
	self.isChoiceGift = isChoiceGift
	self.pointID = _id
	self.nodeCenter:removeAllChildren()
	local rIndex = 0
	self.princeList, _ENV, self.packageList, _ENV = self.nodeCenter, self.nodeCenter, self.nodeCenter, self.nodeCenter
	self.packageIndex = 1
	self.princeIndex = 1
	local _
	_, self.packageList, self.packageIndex = self.checkShow(self.pointID, isChoiceGift)
	if self.pointID == 14141 then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ORIENT_PRINCE_GIFT, false) then
			_ENV = false
			;(false).id = 14141
			;(false).giftType = "normalGift"
			table.insert(self.princeList, false)
		end
		if next(self.princeList) == nil then
			self:removeFromParent()
			return
		end
		self.btnRight:setVisible(false)
		self.btnLeft:setVisible(false)
		self.panelGiftTouch:setTouchEnabled(false)
		print("self.princeIndex = ", self.princeIndex)
		if self.princeList[self.princeIndex] then
			self:initPrinceView()
			return true
		else
			return false
		end
	else
		if next(self.packageList) == nil then
			self:removeFromParent()
			return
		end
		print("self.packageIndex = ", self.packageIndex)
		if self.packageList[self.packageIndex] then
			self:initView()
			return true
		else
			return false
		end
	end
end
function RechargePopFrame.checkShow(_id, isChoiceGift)
	local pointID = _id
	local rIndex = 0
	local gametop, packageList
	local packageIndex = 1
	local findIt = false
	local isAddSpecial = false
	local luckyGiftCtrl = gametop.playertop_:getModule("luckyGiftCtrl")
	local gametop, luckyGiftList = gametop.playertop_, gametop.playertop_
	if isChoiceGift then
		luckyGiftList = luckyGiftCtrl:getChoiceLuckyGiftData(true)
	else
		luckyGiftList = luckyGiftCtrl:getLuckyGiftData(true)
	end
	for i, v in ipairs(luckyGiftList) do
		if rechargeRead.hasRechargeItem(v.luckyGiftID) then
			if v.type == gLuckyPackageType.LUCKY_PACKAGE_BIRTHDAY and 0 < #v.extraData then
				if not isAddSpecial then
					local ladderData = luckyGiftCtrl:getBirthdayLadderGiftData()
					gametop = nil
					;(nil).id = tonumber(ladderData.luckyGiftID)
					;(nil).giftType = "luckyGift"
					;(nil).isChoiceGift = isChoiceGift
					table.insert(packageList, nil)
					rIndex = rIndex + 1
					isAddSpecial = true
				end
			else
				gametop = packageList
				packageList.id = tonumber(v.luckyGiftID)
				packageList.giftType = "luckyGift"
				packageList.isChoiceGift = isChoiceGift
				table.insert(packageList, packageList)
				rIndex = rIndex + 1
			end
			if tonumber(v.luckyGiftID) == tonumber(pointID) then
				packageIndex = rIndex
				findIt = true
			end
		end
	end
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local activeDataList = rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList())
	local gametop, activeGiftList = rechargeActivityCtrl, rechargeActivityCtrl
	for k, v in pairs(activeDataList) do
		if paymentManager.judgeGiftExclusive(tonumber(k)) then
			gametop = tonumber(k)
			tonumber(k).id = tonumber(k)
			tonumber(k).giftType = "normalGift"
			tonumber(k).weight = v.weight
			table.insert(activeGiftList, tonumber(k))
		end
	end
	for _, v in ipairs(activeGiftList) do
		gametop = tonumber(k)
		tonumber(k).id = v.id
		tonumber(k).giftType = "normalGift"
		table.insert(packageList, tonumber(k))
		rIndex = rIndex + 1
		if tonumber(v.id) == tonumber(pointID) then
			packageIndex = rIndex
			findIt = true
		end
	end
	local iceBreakCtrl = gametop.playertop_:getModule("iceBreakCtrl")
	local iceBreakData = clone(iceBreakCtrl:getIceBreakData())
	if next(iceBreakData) and paymentManager.judgeGiftExclusive(tonumber(iceBreakData.iceBreakID)) then
		gametop = tonumber(iceBreakData.iceBreakID)
		tonumber(iceBreakData.iceBreakID).id = tonumber(iceBreakData.iceBreakID)
		tonumber(iceBreakData.iceBreakID).giftType = "iceBreakGift"
		table.insert(packageList, tonumber(iceBreakData.iceBreakID))
		rIndex = rIndex + 1
		if tonumber(iceBreakData.iceBreakID) == tonumber(pointID) then
			packageIndex = rIndex
			findIt = true
		end
	end
	local princeGiftNewCtrl = gametop.playertop_:getModule("princeGiftNewCtrl")
	if princeGiftNewCtrl:getNewPrinceData() then
		rIndex = rIndex + 1
		if tonumber(princeGiftNewCtrl:getGiftID()) == tonumber(pointID) then
			packageIndex = rIndex
			findIt = true
		end
		gametop = pointID
		pointID.id = princeGiftNewCtrl:getGiftID()
		pointID.giftType = "normalGift"
		table.insert(packageList, pointID)
	end
	if next(packageList) == nil then
		gametop = packageList
		return false, packageList, packageIndex
	end
	dump(packageList, "packageList")
	print("packageIndex = ", packageIndex, pointID)
	if findIt then
		return true, packageList, packageIndex
	else
		return false, packageList, packageIndex
	end
end
function RechargePopFrame:initPrinceView(notNeedAdd)
	_UPVALUE0_ = nil
	;(nil).count = #self.princeList
	;(nil).intervalWidth = 8
	;(nil).begin = self.princeIndex
	self.pagePoint:initData(nil)
	if not notNeedAdd then
		local page = self:createAPage(self.princeList[self.princeIndex])
		page:addTo(self.nodeCenter)
	end
end
function RechargePopFrame:initView(notNeedAdd)
	_UPVALUE0_ = nil
	;(nil).count = #self.packageList
	;(nil).intervalWidth = 8
	;(nil).begin = self.packageIndex
	self.pagePoint:initData(nil)
	if not notNeedAdd then
		local page = self:createAPage(self.packageList[self.packageIndex])
		page:addTo(self.nodeCenter)
	end
end
function RechargePopFrame:createAPage(info, isPageTurn)
	dump(info, "RechargePopFrame:createAPage")
	local panel
	if "luckyGift" == info.giftType then
		panel = SoraDCreatePanel("rechargePopView")
		_ENV = nil
		;(nil).needLocateBtn = self.fromCenter == gRechargeActiveFromEnum.ROAD01
		;(nil).isChoiceGift = info.isChoiceGift
		panel:initData(info.id, self.fromCenter, isPageTurn, nil)
	elseif "normalGift" == info.giftType then
		panel = SoraDCreatePanel("rechargePopView")
		_ENV = nil
		;(nil).needLocateBtn = self.fromCenter == gRechargeActiveFromEnum.ROAD01
		panel:initData(info.id, self.fromCenter, isPageTurn, nil)
	elseif "iceBreakGift" == info.giftType then
		panel = SoraDCreatePanel("rechargePopView")
		_ENV = nil
		;(nil).needLocateBtn = self.fromCenter == gRechargeActiveFromEnum.ROAD01
		panel:initData(info.id, self.fromCenter, isPageTurn, nil)
	end
	panel:setPosition(0, 0)
	return panel
end
function RechargePopFrame:reNewNum(isLeft)
	local _max = #self.packageList
	local _cur = self.packageIndex
	local _min = 1
	local flag = 0
	if isLeft then
		_cur = _cur - 1
		if _cur < 1 then
			_cur = _max
		end
	else
		_cur = _cur + 1
		if _max < _cur then
			_cur = _min
		end
	end
	self.packageIndex = _cur
	return self.packageIndex, flag
end
function RechargePopFrame:btnRightClick(button, type)
	if type == ccui.TouchEventType.ended and self.canClick then
		SoraDPlaySound()
		local num, flag = self:reNewNum(false)
		if self.packageList[num] == nil then
			return
		end
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_switch_gift)
		self.canClick = false
		self.nodeOutSide:removeAllChildren()
		local page = self:createAPage(self.packageList[num], true)
		page:addTo(self.nodeOutSide)
		self.pagePoint:setCurLight(self.packageIndex)
		self.nodeOutSide:setPosition(display.width / 2 * 3, display.height / 2)
		self.nodeCenter:setPosition(display.width / 2, display.height / 2)
		transition.execute(self.nodeOutSide, cca.moveTo(0.2, display.width / 2, display.height / 2))
		_ENV = 0.2
		;(0.2).onComplete = function()
			self.nodeOutSide, self.nodeCenter = self.nodeCenter, self.nodeOutSide
			self.nodeOutSide:removeAllChildren()
		end
		transition.execute(self.nodeCenter, cca.moveTo(0.2, -display.width / 2, display.height / 2), 0.2)
		_ENV = 0.2
		;(0.2).delay = 0.2
		;(0.2).onComplete = function()
			self.canClick = true
		end
		transition.execute(self, nil, 0.2)
	end
end
function RechargePopFrame:btnLeftClick(button, type)
	if type == ccui.TouchEventType.ended and self.canClick then
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_switch_gift)
		SoraDPlaySound()
		self.canClick = false
		self.nodeOutSide:removeAllChildren()
		local num, flag = self:reNewNum(true)
		if self.packageList[num] == nil then
			return
		end
		local page = self:createAPage(self.packageList[num], true)
		page:addTo(self.nodeOutSide)
		self.pagePoint:setCurLight(self.packageIndex)
		self.nodeOutSide:setPosition(-display.width / 2, display.height / 2)
		self.nodeCenter:setPosition(display.width / 2, display.height / 2)
		transition.execute(self.nodeOutSide, cca.moveTo(0.2, display.width / 2, display.height / 2))
		_ENV = 0.2
		;(0.2).onComplete = function()
			self.nodeOutSide, self.nodeCenter = self.nodeCenter, self.nodeOutSide
			self.nodeOutSide:removeAllChildren()
		end
		transition.execute(self.nodeCenter, cca.moveTo(0.2, display.width / 2 * 3, display.height / 2), 0.2)
		_ENV = 0.2
		;(0.2).delay = 0.2
		;(0.2).onComplete = function()
			self.canClick = true
		end
		transition.execute(self, nil, 0.2)
	end
end
return RechargePopFrame
