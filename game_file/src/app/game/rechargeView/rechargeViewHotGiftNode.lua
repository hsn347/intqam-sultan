local RechargeViewHotGiftNode = class("rechargeViewHotGiftNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewHotGiftNode")
	end
	return target
end)
function RechargeViewHotGiftNode:ctor()
	self.curGiftIndex = 1
	self.canClick = true
	self.nodeInSide = SoraDGetChildByName(self, "Node_inSide")
	self.nodeOutSide = SoraDGetChildByName(self, "Node_outSide")
	self.panelGiftTouch = SoraDGetChildByName(self, "Panel_normalGiftTouch")
end
function RechargeViewHotGiftNode:initData(giftInfo, isRefresh)
	self.normalGiftData = giftInfo
	self:initView(isRefresh)
end
function RechargeViewHotGiftNode:setFatherHeadRefresh(handl)
	self.handleRefreshHead = handl
end
function RechargeViewHotGiftNode:initView(isRefresh)
	dump(self.normalGiftData, "self.normalGiftData")
	local getGiftPageNode = function(...)
		local copyItem = self:getChildByName("rechargeNormalGift_copy")
		if copyItem then
			local reItem = copyItem:clone()
			reItem:setVisible(true)
			reItem = include("rechargeViewPageNode").new(reItem)
			return reItem
		else
			local single = SoraDCreateCSBNode("rechargeViewPageNode")
			single:addTo(self)
			single:setName("rechargeNormalGift_copy")
			single:setVisible(false)
			local reItem = single:clone()
			reItem:setVisible(true)
			reItem = include("rechargeViewPageNode").new(reItem)
			return reItem
		end
	end
	local createGiftNode = function(_info)
		local panel = getGiftPageNode()
		print("pageHeigh = ", self:getPositionY())
		panel:setContentHeight(self:getPositionY())
		panel:initData(_info, gRechargeActiveFromEnum.ROAD19)
		panel:setPosition(0, 0)
		return panel
	end
	local reNewNum = function(isLeft)
		local _max = #self.normalGiftData
		local _cur = self.curGiftIndex
		local _min = 1
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
		self.curGiftIndex = _cur
	end
	if not self.initNormalPageFlag then
		local pointNode = cc.Node:create()
		pointNode:setPosition(0, -340)
		pointNode:addTo(self, 99)
		local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
		imageItemBg:setName("Image_bg")
		imageItemBg:setPosition(0, 0)
		imageItemBg:addTo(pointNode)
		local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
		imageLight:setName("Image_light")
		imageLight:setPosition(0, 0)
		imageLight:addTo(pointNode)
		self.pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
		self.btnLeft = SoraDGetChildByName(self, "Button_left")
		self.btnRight = SoraDGetChildByName(self, "Button_right")
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
		local turnPage = function(isLeft, notSound)
			if self.canClick and self.canTurnPage then
				if not notSound then
					SoraDPlaySound()
				end
				self.canClick = false
				self.nodeOutSide:removeAllChildren()
				if isLeft then
					reNewNum(true)
					self.nodeOutSide:setPosition(-display.width, 0)
					self.nodeInSide:setPosition(0, 0)
				else
					reNewNum(false)
					self.nodeOutSide:setPosition(display.width, 0)
					self.nodeInSide:setPosition(0, 0)
				end
				local page = createGiftNode(self.normalGiftData[self.curGiftIndex])
				page:setName("cur_rechargeViewPageNode")
				page:addTo(self.nodeOutSide)
				self.pagePoint:setCurLight(self.curGiftIndex)
				if isLeft then
					transition.execute(self.nodeOutSide, cca.moveTo(0.2, 0, 0))
					self = 0.2
					;(0.2).onComplete = function()
						self.nodeOutSide, self.nodeInSide = self.nodeInSide, self.nodeOutSide
						self.nodeOutSide:removeAllChildren()
					end
					transition.execute(self.nodeInSide, cca.moveTo(0.2, display.width, 0), 0.2)
				else
					transition.execute(self.nodeOutSide, cca.moveTo(0.2, 0, 0))
					self = 0.2
					;(0.2).onComplete = function()
						self.nodeOutSide, self.nodeInSide = self.nodeInSide, self.nodeOutSide
						self.nodeOutSide:removeAllChildren()
					end
					transition.execute(self.nodeInSide, cca.moveTo(0.2, -display.width, 0), 0.2)
				end
				self = 0.2
				;(0.2).delay = 0.2
				;(0.2).onComplete = function()
					self.canClick = true
				end
				transition.execute(self, nil, 0.2)
			end
		end
		self.btnRight:addTouchEventListener(function(button, eventType, notSound)
			if eventType == ccui.TouchEventType.ended then
				_ENV = nil
				;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
				SoraDSendMessage(nil)
				turnPage(false, notSound)
			end
		end)
		self.btnLeft:addTouchEventListener(function(button, eventType, notSound)
			if eventType == ccui.TouchEventType.ended then
				_ENV = nil
				;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
				SoraDSendMessage(nil)
				turnPage(true, notSound)
			end
		end)
		self.panelGiftTouch:setTouchEnabled(true)
		self.panelGiftTouch:setSwallowTouches(false)
		self.panelGiftTouch:addTouchEventListener(function(panel, eventType)
			if eventType == ccui.TouchEventType.ended then
				_ENV = nil
				;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
				SoraDSendMessage(nil)
				if self.canClick then
					local touchBeganPoint = panel:getTouchBeganPosition()
					local touchmovePoint = panel:getTouchEndPosition()
					local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
					print("distance = ", distance)
					if distance < 10 then
						local curPage = self.nodeInSide:getChildByName("cur_rechargeViewPageNode")
						if curPage then
							curPage:popDesRechargeView()
						end
					elseif touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
						print("右移")
						turnPage(true)
					elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
						print("左移")
						turnPage(false)
					end
				end
			end
		end)
		isRefresh = true
		self.initNormalPageFlag = true
	end
	local refreshPagePoint = function(...)
		self.pagePoint:setVisible(true)
		self = true
		;(true).count = #self.normalGiftData
		;(true).intervalWidth = 40
		;(true).begin = self.curGiftIndex
		self.pagePoint:initData(true)
	end
	local initFirstNode = function(...)
		self.nodeInSide:removeAllChildren()
		local panel = createGiftNode(self.normalGiftData[self.curGiftIndex])
		panel:setName("cur_rechargeViewPageNode")
		panel:addTo(self.nodeInSide)
	end
	local setBtnVisiable = function(bool)
		self.btnLeft:setVisible(bool)
		self.btnRight:setVisible(bool)
		self.canTurnPage = bool
	end
	if isRefresh then
		if #self.normalGiftData > 1 then
			self.curGiftIndex = 1
			initFirstNode()
			refreshPagePoint()
			setBtnVisiable(true)
		elseif #self.normalGiftData == 1 then
			self.curGiftIndex = 1
			initFirstNode()
			refreshPagePoint()
			setBtnVisiable(false)
		else
			setBtnVisiable(false)
			if self.handleRefreshHead then
				self.handleRefreshHead()
			end
		end
	end
end
function RechargeViewHotGiftNode:turnNext(...)
	if #self.normalGiftData > 1 then
		self.btnRight._touchEventListener_(self.btnRight, ccui.TouchEventType.ended, true)
	end
end
return RechargeViewHotGiftNode
