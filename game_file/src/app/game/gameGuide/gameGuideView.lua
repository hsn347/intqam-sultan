local gameGuideGray = 76.5
local lordSpineDef = include("lordSpineDef")
include("gameGuideData")
local gameGuideView = class("gameGuideView", function()
	local baseView = include("baseView")
	local bgView = baseView.new(display.realSize, false)
	bgView:setName("gameGuideView")
	return bgView
end)
function gameGuideView:ctor()
	self.waitLogTimer = nil
	self.isUpdate = false
	self.findFoodCount = 0
	self:ignoreAnchorPointForPosition(false)
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setPosition(cc.p(display.cx, display.rcy))
	self:setTouchEnabled(false)
	self.touchRect = cc.rect(-1, -1, 1, 1)
	self.particleNode = nil
	self.currentStepIndex = 0
	self.fingerList, _ENV, self.tableTips, _ENV, self.tableGirl, cc.rect(-1, -1, 1, 1).right, _ENV, cc.rect(-1, -1, 1, 1).left, _ENV, _ENV, self.isForceSatrt = cc.rect(-1, -1, 1, 1), cc.rect(-1, -1, 1, 1), cc.rect(-1, -1, 1, 1), cc.rect(-1, -1, 1, 1), cc.rect(-1, -1, 1, 1), -1, -1, -1, -1, cc.rect(-1, -1, 1, 1), false
	self:initTouchClipeData()
	self:initGirl()
	self:initTips()
	if device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		self.btnClose = ccui.Button:create("icon_battle_close.png", "icon_battle_close.png", "icon_battle_close.png", ccui.TextureResType.plistType)
		self.btnClose:setPosition(cc.p(600, display.height - 340))
		self.btnClose:addTouchEventListener(function(button, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				self:closeGuide(false)
			end
		end)
		self.btnClose:addTo(self, 3)
	end
	self.btnCenter = ccui.Button:create("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	self.btnCenter:setAnchorPoint(cc.p(0.5, 1))
	self.btnCenter:setPosition(cc.p(320, display.ocy - 170))
	self.btnCenter:setTitleFontSize(20)
	self.btnCenter:addTouchEventListener(handler(self, self.centerBtnClick))
	self.btnCenter:addTo(self)
	self.btnCenter:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_SERVER_CLOSE_GUIDE", function(target, data)
		self:closeGuide(false)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_STEP_ON", function(target, data)
		self:stepOnGuide(data.step)
		GameGuideLog("解除等待 gameGuideView:startGuideWithStep")
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_STEP_END", function(target, data)
		if data.step then
			if data.reload ~= nil then
				if data.reload then
					GameGuideLog("出错啦！重登啦！ gameGuideView:reloadGuide")
					local gametop = gModuleMgr.getObject("gametop")
					gametop:Logout()
					SoraDShowLoginView()
				elseif SoradGameGuide_GetStepGetDataByKey(data.step, "waitMsgEndStep") then
					self:endCurIndexStep(true)
				end
			else
				self.currentStepIndex = data.step
				self:endCurIndexStep()
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_CHAPTERTASK_CLOSE", function(target, data)
		print("章节id", data.id)
		if data.id == 4103000 then
		end
	end)
end
function gameGuideView:centerBtnClick(target, type)
	if type == ccui.TouchEventType.ended then
		if self.currentStepIndex == 3013 then
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local cityView = SoraDCurrentSceneShowView("mainCityView")
			local tableCityList = cityCtrl:getBuildList()
			local _ENV, actionsArray = cityCtrl, cityCtrl
			local curIndex
			for k, v in pairs(tableCityList) do
				if tonumber(v.info.bid) == BUILDID.FARM or tonumber(v.info.bid) == BUILDID.SAWMILL then
					actionsArray[#actionsArray + 1] = cc.CallFunc:create(function(...)
						if curIndex == nil then
							curIndex = nil
							;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
							;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
							;(nil).bid = tonumber(v.info.bid)
							;(nil).iid = tonumber(v.info.iid)
							SoraDGotoCityBuild(nil)
						else
							curIndex = nil
							;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
							;(nil).buildIndex = curIndex
							SoraDSendMessage(nil)
							curIndex = nil
							;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP_HAND"
							;(nil).buildIndex = tonumber(v.info.index)
							SoraDSendMessage(nil)
						end
					end)
					actionsArray[#actionsArray + 1] = cc.DelayTime:create(#actionsArray == 1 and 3 or 1)
				end
			end
			if 0 < #actionsArray then
				cityView:runAction(transition.sequence(actionsArray))
			end
		elseif self.currentStepIndex == 60003 then
			gModuleMgr.sharedMgr("mildGuideManager"):starToUnlockPet()
		elseif self.currentStepIndex == 60004 and self:checkUnlockHero() then
			gModuleMgr.sharedMgr("mildGuideManager"):starToHeroUnlockOneStep()
		end
		self:endCurIndexStep()
	end
end
function gameGuideView:getCurIndex()
	return self.currentStepIndex
end
function gameGuideView:initTouchClipeData()
	self.bgImg = cc.LayerColor:create(cc.c4b(0, 0, 0, 127.5))
	self.bgImg:setContentSize(display.realSize)
	self.bgImg:setPosition(0, 0)
	self.isStopGuide = false
	self.isOnlyGirl = false
	self.isOnlyShow = false
	self.lightRect = nil
	self.otherData = nil
	self.spriteSword = display.newSprite("#icon_guide_sword.png")
	self.spriteSword:setAnchorPoint(cc.p(0.5, 0.5))
	self.spriteSword:addTo(self, 2)
	self.spriteSword:setVisible(false)
	self.spriteFinger = SoraDFingerAction()
	self.spriteFinger:addTo(self, 4)
	self.spriteFinger:setVisible(false)
	self.cliperNode = cc.ClippingNode:create()
	self.cliperNode:setInverted(true)
	self.cliperNode:addChild(self.bgImg, 1)
	self.cliperNode:setAnchorPoint(cc.p(0.0, 0.0))
	self.cliperNode:setPosition(cc.p(0, 0))
	self:addTouchClipeRect(cc.rect(-1, -1, 1, 1))
	self:addChild(self.cliperNode, 1)
end
function gameGuideView:addTouchClipeRect(rect)
	if self.lightRect then
		self.lightRect:removeFromParent()
		self.lightRect = nil
	end
	self.touchRect = rect
	_ENV = nil
	;(nil).fillColor = cc.c4f(1, 0, 0, 0.5)
	;(nil).borderColor = cc.c4f(0, 1, 0, 1)
	;(nil).borderWidth = 0.5
	local shapeRect = display.newRect(rect, nil)
	if 1 < self.touchRect.width and 1 < self.touchRect.height then
		self:showFinger()
		self:showFingerList()
		self:showBorderEffect()
		self:showTips()
	else
		self:hiddleTips()
		self:hiddleBorder()
		self:hiddleFinger()
		self:hiddleFingerList()
	end
	if tolua.isnull(self.cliperNode) then
		return
	end
	self.cliperNode:setStencil(shapeRect)
	if self.touchNodes == nil then
		self.touchNodes, _ENV = self.touchNodes, self.touchNodes
		for i = 1, 5 do
			self.touchNodes[i] = cc.LayerColor:create(cc.c4b(255, 0, 0, 0))
			self.touchNodes[i]:setName("touchNodes_" .. i)
			self.touchNodes[i]:setContentSize(1, 1)
			self.touchNodes[i]:setPosition(0, 0)
			self.touchNodes[i]:setAnchorPoint(cc.p(0, 0))
			self.touchNodes[i]:addTo(self)
			self.touchNodes[i]:setTouchEnabled(true)
			self.touchNodes[i]:setSwallowTouches(true)
			self.touchNodes[i]:addTouchEventListener_(function(ref, type)
				self:viewOnClick(ref, type)
			end)
		end
	end
	local isMaskEnable = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isMaskEnable")
	self.touchNodes[1]:setPosition(0, 0)
	self.touchNodes[1]:setContentSize(cc.size(self.touchRect.x, self.touchRect.y + self.touchRect.height))
	self.touchNodes[1]:setTouchEnabled(isMaskEnable)
	self.touchNodes[2]:setPosition(self.touchRect.x, 0)
	self.touchNodes[2]:setContentSize(cc.size(display.rwidth - self.touchRect.x, self.touchRect.y))
	self.touchNodes[2]:setTouchEnabled(isMaskEnable)
	self.touchNodes[3]:setPosition(0, self.touchRect.y + self.touchRect.height)
	self.touchNodes[3]:setContentSize(cc.size(self.touchRect.x + self.touchRect.width, display.rheight - (self.touchRect.y + self.touchRect.height)))
	self.touchNodes[3]:setTouchEnabled(isMaskEnable)
	self.touchNodes[4]:setPosition(self.touchRect.x + self.touchRect.width, self.touchRect.y)
	self.touchNodes[4]:setContentSize(cc.size(display.rwidth - (self.touchRect.x + self.touchRect.width), display.rheight - self.touchRect.y))
	self.touchNodes[4]:setTouchEnabled(isMaskEnable)
	local isSwallows = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isSwallow")
	if isSwallows == nil then
		isSwallows = true
	end
	self.touchNodes[5]:setSwallowTouches(isSwallows)
	self.touchNodes[5]:setPosition(self.touchRect.x, self.touchRect.y)
	self.touchNodes[5]:setContentSize(cc.size(self.touchRect.width, self.touchRect.height))
	self.touchNodes[5]:setTouchEnabled(isMaskEnable)
end
function gameGuideView:showBorderEffect()
	local borderWidth = 325
	local borderHeigh = 185
	if self.particleNode then
		self.particleNode:removeFromParent()
		self.particleNode = nil
	end
	local isBorder = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isBorder")
	if isBorder then
		if self.lightRect then
			self.lightRect:removeFromParent()
			self.lightRect = nil
		end
		_ENV = self.touchRect.x + 1
		;(self.touchRect.x + 1).fillColor = cc.c4f(1, 0, 0, 0)
		;(self.touchRect.x + 1).borderColor = cc.c4f(1, 1, 0, 0.8)
		;(self.touchRect.x + 1).borderWidth = 1
		self.lightRect = display.newRect(cc.rect(self.touchRect.x + 1, self.touchRect.y + 1, self.touchRect.width - 2, self.touchRect.height - 2), self.touchRect.x + 1)
		self.lightRect:addTo(self, 2)
		if isBorder == "all" then
			_ENV, _ENV = self.lightRect, self.lightRect.addTo
			_ENV, self.lightRect.plist = self, "et_lfirekuang_display_02.plist"
			_ENV, self.lightRect.scale, self.y = self, self, self.touchRect.height / borderHeigh
			self.x = 0
			_ENV, self.lightRect.addTo[1], self.lightRect.pos, self.y = self.lightRect, self.lightRect, self, self.touchRect.height * 0.4
			_ENV, self.lightRect.plist = self, "et_rfirekuang_display_03.plist"
			_ENV, self.lightRect.scale, self.y = self, self, self.touchRect.height / borderHeigh
			self.x = self.touchRect.width
			_ENV, self.lightRect.addTo[2], self.lightRect.pos, self.y = self.lightRect, self.lightRect, self, self.touchRect.height * 0.4
			_ENV, self.lightRect.plist = self, "et_ufirekuang_display_04.plist"
			_ENV, self.lightRect.scale, self.x = self, self, self.touchRect.width / borderWidth
			self.x = self.touchRect.width / 2
			_ENV, self.lightRect.addTo[3], self.lightRect.pos, self.y = self.lightRect, self.lightRect, self, self.touchRect.height
			_ENV, self.lightRect.plist = self, "et_dfirekuang_display_05.plist"
			_ENV, self.lightRect.scale, self.x = self, self, self.touchRect.width / borderWidth
			self.x = self.touchRect.width / 2
			self.lightRect.addTo[4], self.lightRect.pos, self.y = self.lightRect, self, 0
			local param = self.lightRect.addTo
			self.particleNode = SoraDCreateEffectNode(param)
			self.particleNode:setPosition(self.touchRect.x, self.touchRect.y)
			self.particleNode:addTo(self, 2)
		end
		if isBorder == "transparent" then
			self.lightRect:setVisible(false)
		end
	end
end
function gameGuideView:showRoundEffect()
	if self.roundNode then
		self.roundNode:removeFromParent()
		self.roundNode = nil
	end
	local _ENV, _ENV, _ENV, param = nil, self.roundNode, self.roundNode.removeFromParent, self.roundNode.removeFromParent
	;(nil).png = "dh_xsyd_01.png"
	;(nil).scale = 2.75
	;(nil).opacity = 178.5
	_UPVALUE1_ = nil
	;(nil)[1] = cca.fadeTo(0.55, 0.2)
	;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[10] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[11] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[12] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[13] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[14] = cca.fadeTo(0.5333333333333333, 0.7)
	_ENV, self.roundNode[1], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	_ENV, self.roundNode[2], (nil).scale = nil, nil, 2
	;(nil).png = "dh_xsyd_02.png"
	;(nil).scale = 2.4
	_ENV = nil
	;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[10] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[11] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[12] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[13] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[14] = cca.rotateBy(1.0833333333333333, 540)
	_ENV, self.roundNode[3], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_03.png"
	;(nil).scale = 2
	_ENV = nil
	;(nil)[1] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[2] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[3] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[4] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[5] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[6] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[7] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[8] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[9] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[10] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[11] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[12] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[13] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[14] = cca.rotateBy(1.0833333333333333, -180)
	_ENV, self.roundNode[4], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	;(nil).scale = 2
	;(nil).opacity = 0
	_UPVALUE4_ = nil
	_UPVALUE1_ = cca.rotateBy(1.0833333333333333, -180)
	cca.rotateBy(1.0833333333333333, -180)[1] = cca.scaleTo(0.03333333333333333, 2.1)
	cca.rotateBy(1.0833333333333333, -180)[2] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[3] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[4] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[5] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[6] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[7] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[8] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[9] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[10] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[11] = cca.fadeTo(0.03333333333333333, 0.3)
	_UPVALUE1_ = cca.scaleTo(0.03333333333333333, 2.1)
	cca.scaleTo(0.03333333333333333, 2.1)[1] = cca.scaleTo(0.23333333333333334, 2.3)
	cca.scaleTo(0.03333333333333333, 2.1)[2] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[3] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[4] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[5] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[6] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[7] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[8] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[9] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[10] = cca.fadeTo(0.23333333333333334, 0.8)
	_UPVALUE1_ = cca.scaleTo(0.23333333333333334, 2.3)
	cca.scaleTo(0.23333333333333334, 2.3)[1] = cca.scaleTo(0.4, 2.5)
	cca.scaleTo(0.23333333333333334, 2.3)[2] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[3] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[4] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[5] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[6] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[7] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[8] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[9] = cca.fadeTo(0.4, 0)
	;(nil)[1] = cca.delay(0.2)
	;(nil)[2] = cca.spawn(cca.rotateBy(1.0833333333333333, -180))
	;(nil)[3] = cca.spawn((cca.scaleTo(0.03333333333333333, 2.1)))
	;(nil)[4] = cca.spawn((cca.scaleTo(0.23333333333333334, 2.3)))
	;(nil)[5] = cca.delay(0.21666666666666667)
	;(nil)[6] = cca.delay(0.21666666666666667)
	;(nil)[7] = cca.delay(0.21666666666666667)
	;(nil)[8] = cca.delay(0.21666666666666667)
	;(nil)[9] = cca.delay(0.21666666666666667)
	;(nil)[10] = cca.delay(0.21666666666666667)
	;(nil)[11] = cca.delay(0.21666666666666667)
	;(nil)[12] = cca.delay(0.21666666666666667)
	;(nil)[13] = cca.delay(0.21666666666666667)
	;(nil)[14] = cca.delay(0.21666666666666667)
	_ENV, self.roundNode[5], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_04.png"
	;(nil).scale = 1.4
	;(nil).rotation = 70.31
	_UPVALUE6_ = nil
	_UPVALUE1_ = cca.spawn(cca.rotateBy(1.0833333333333333, -180))
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[1] = cca.scaleTo(0.08333333333333333, 1.55)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[2] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[3] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[4] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[5] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[6] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[7] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[8] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[9] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[10] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[11] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[12] = cca.fadeTo(0.08333333333333333, 0.9)
	_UPVALUE1_ = cca.scaleTo(0.08333333333333333, 1.55)
	cca.scaleTo(0.08333333333333333, 1.55)[1] = cca.scaleTo(0.16666666666666666, 1.85)
	cca.scaleTo(0.08333333333333333, 1.55)[2] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[3] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[4] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[5] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[6] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[7] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[8] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[9] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[10] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[11] = cca.fadeTo(0.16666666666666666, 0.8)
	_UPVALUE1_ = cca.scaleTo(0.16666666666666666, 1.85)
	cca.scaleTo(0.16666666666666666, 1.85)[1] = cca.scaleTo(0.08333333333333333, 2)
	cca.scaleTo(0.16666666666666666, 1.85)[2] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[3] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[4] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[5] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[6] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[7] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[8] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[9] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[10] = cca.fadeTo(0.08333333333333333, 0.4)
	_UPVALUE1_ = cca.scaleTo(0.08333333333333333, 2)
	cca.scaleTo(0.08333333333333333, 2)[1] = cca.scaleTo(0.08333333333333333, 2.2)
	cca.scaleTo(0.08333333333333333, 2)[2] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[3] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[4] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[5] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[6] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[7] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[8] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[9] = cca.fadeTo(0.08333333333333333, 0)
	_UPVALUE1_ = 0.4
	;(0.4)[1] = cca.scaleTo(0.05, 0.8)
	;(0.4)[2] = cca.fadeTo(0.05, 1)
	;(0.4)[3] = cca.fadeTo(0.05, 1)
	;(0.4)[4] = cca.fadeTo(0.05, 1)
	;(0.4)[5] = cca.fadeTo(0.05, 1)
	;(0.4)[6] = cca.fadeTo(0.05, 1)
	;(0.4)[7] = cca.fadeTo(0.05, 1)
	;(nil)[1] = cca.spawn((cca.spawn(cca.rotateBy(1.0833333333333333, -180))))
	;(nil)[2] = cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))
	;(nil)[3] = cca.spawn((cca.scaleTo(0.16666666666666666, 1.85)))
	;(nil)[4] = cca.spawn((cca.scaleTo(0.08333333333333333, 2)))
	;(nil)[5] = cca.scaleTo(0.5333333333333333, 0.4)
	;(nil)[6] = cca.spawn(0.4)
	;(nil)[7] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[8] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[9] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[10] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[11] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[12] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[13] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[14] = cca.scaleTo(0.08333333333333333, 1.4)
	_ENV, self.roundNode[6], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_05.png"
	;(nil).scale = 0.5
	;(nil).opacity = 0
	_UPVALUE4_ = nil
	_UPVALUE1_ = cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[1] = cca.scaleTo(0.16666666666666666, 0.7)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[2] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[3] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[4] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[5] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[6] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[7] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[8] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[9] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[10] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[11] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[12] = cca.fadeTo(0.16666666666666666, 0.4)
	_UPVALUE1_ = cca.scaleTo(0.16666666666666666, 0.7)
	cca.scaleTo(0.16666666666666666, 0.7)[1] = cca.scaleTo(0.08333333333333333, 0.9)
	cca.scaleTo(0.16666666666666666, 0.7)[2] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[3] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[4] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[5] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[6] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[7] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[8] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[9] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[10] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[11] = cca.fadeTo(0.08333333333333333, 0.6)
	_UPVALUE1_ = cca.scaleTo(0.08333333333333333, 0.9)
	cca.scaleTo(0.08333333333333333, 0.9)[1] = cca.scaleTo(0.23333333333333334, 1.4)
	cca.scaleTo(0.08333333333333333, 0.9)[2] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[3] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[4] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[5] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[6] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[7] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[8] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[9] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[10] = cca.fadeTo(0.23333333333333334, 0.3)
	_UPVALUE1_ = cca.scaleTo(0.23333333333333334, 1.4)
	cca.scaleTo(0.23333333333333334, 1.4)[1] = cca.scaleTo(0.25, 2)
	cca.scaleTo(0.23333333333333334, 1.4)[2] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[3] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[4] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[5] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[6] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[7] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[8] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[9] = cca.fadeTo(0.25, 0)
	;(nil)[1] = cca.spawn((cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))))
	;(nil)[2] = cca.spawn((cca.scaleTo(0.16666666666666666, 0.7)))
	;(nil)[3] = cca.spawn((cca.scaleTo(0.08333333333333333, 0.9)))
	;(nil)[4] = cca.spawn((cca.scaleTo(0.23333333333333334, 1.4)))
	;(nil)[5] = cca.delay(0.35)
	;(nil)[6] = cca.delay(0.35)
	;(nil)[7] = cca.delay(0.35)
	;(nil)[8] = cca.delay(0.35)
	;(nil)[9] = cca.delay(0.35)
	;(nil)[10] = cca.delay(0.35)
	;(nil)[11] = cca.delay(0.35)
	;(nil)[12] = cca.delay(0.35)
	;(nil)[13] = cca.delay(0.35)
	;(nil)[14] = cca.delay(0.35)
	_ENV, self.roundNode[7], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).plist = "et_xsyd_01.plist"
	_ENV, self.roundNode[8], (nil).scale = nil, nil, 3.3
	;(nil).png = "dh_xsyd_06.png"
	;(nil).scale = 3.7
	_UPVALUE8_ = nil
	_UPVALUE1_ = 4
	;(4)[1] = cca.scaleTo(0.16666666666666666, 4.25)
	;(4)[2] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[3] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[4] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[5] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[6] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[7] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[8] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[9] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[10] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[11] = cca.fadeTo(0.16666666666666666, 0.5)
	_UPVALUE1_ = cca.scaleTo(0.16666666666666666, 4.25)
	cca.scaleTo(0.16666666666666666, 4.25)[1] = cca.scaleTo(0.16666666666666666, 4.5)
	cca.scaleTo(0.16666666666666666, 4.25)[2] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[3] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[4] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[5] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[6] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[7] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[8] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[9] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[10] = cca.fadeTo(0.16666666666666666, 0)
	_UPVALUE1_ = 1.1667
	;(1.1667)[1] = cca.scaleTo(0.03333333333333333, 1.5)
	;(1.1667)[2] = cca.fadeTo(0.03333333333333333, 0.6)
	;(1.1667)[3] = cca.fadeTo(0.03333333333333333, 0.6)
	;(1.1667)[4] = cca.fadeTo(0.03333333333333333, 0.6)
	;(1.1667)[5] = cca.fadeTo(0.03333333333333333, 0.6)
	_UPVALUE1_ = cca.scaleTo(0.03333333333333333, 1.5)
	cca.scaleTo(0.03333333333333333, 1.5)[1] = cca.scaleTo(0.08333333333333333, 3.7)
	cca.scaleTo(0.03333333333333333, 1.5)[2] = cca.fadeTo(0.08333333333333333, 1)
	cca.scaleTo(0.03333333333333333, 1.5)[3] = cca.fadeTo(0.08333333333333333, 1)
	cca.scaleTo(0.03333333333333333, 1.5)[4] = cca.fadeTo(0.08333333333333333, 1)
	;(nil)[1] = cca.scaleTo(0.08333333333333333, 4)
	;(nil)[2] = cca.spawn(4)
	;(nil)[3] = cca.spawn((cca.scaleTo(0.16666666666666666, 4.25)))
	;(nil)[4] = cca.scaleTo(0.36666666666666664, 0.2)
	;(nil)[5] = cca.scaleTo(0.13333333333333333, 0.84)
	;(nil)[6] = cca.scaleTo(0.03333333333333333, 1)
	;(nil)[7] = cca.scaleTo(0.016666666666666666, 1.1667)
	;(nil)[8] = cca.spawn(1.1667)
	;(nil)[9] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[10] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[11] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[12] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[13] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[14] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	self.roundNode[9], (nil).seq = nil, cca.seq(nil)
	local actionConfig = self.roundNode
	self.roundNode = display.newNode()
	self.roundNode:setPosition(self.touchRect.x + self.touchRect.width / 2, self.touchRect.y + self.touchRect.height / 2)
	self.roundNode:addTo(self, 2)
	for k, v in ipairs(actionConfig) do
		if v.png then
			local sprite = display.newSprite("#" .. v.png)
			if v.scale then
				sprite:setScale(v.scale)
			end
			if v.opacity then
				sprite:setOpacity(v.opacity)
			end
			if v.rotation then
				sprite:setRotation(v.rotation)
			end
			if v.seq then
				sprite:runAction(cc.RepeatForever:create(v.seq))
			end
			sprite:addTo(self.roundNode, k)
		elseif v.plist then
			table.insert(param, v)
			local et_node = SoraDCreateEffectNode(param)
			et_node:addTo(self.roundNode, k)
		end
	end
	self.roundNode:setScale(0.5)
end
function gameGuideView:setTips(tips, data)
	local data = SoradGameGuide_tipsDataCheck(data)
	local tipsSize = data.size
	local offset = cc.p(data.offset.x, data.offset.y)
	local arr = data.arr
	local rotation = 0
	local arrPos = cc.p(tipsSize.width, tipsSize.height)
	if data.isOverturn and not SoraDFIsRA() then
		if arr == "left" then
			arr = "right"
		elseif arr == "right" then
			arr = "left"
		end
	end
	if arr == "top" then
		rotation = 180
		offset.y = offset.y + 20
		arrPos.x = 0.5 * arrPos.x - offset.x
		arrPos.y = 24
	elseif arr == "bottom" then
		rotation = 0
		offset.y = offset.y - 20
		arrPos.x = 0.5 * arrPos.x - offset.x
		arrPos.y = arrPos.y - 22
	elseif arr == "left" then
		rotation = 90
		offset.x = offset.x - 20
		arrPos.y = 0.5 * arrPos.y
		arrPos.x = arrPos.x - 20
	elseif arr == "right" then
		rotation = -90
		offset.x = offset.x + 20
		arrPos.y = 0.5 * arrPos.y
		arrPos.x = 20
	end
	local tipsRect = self.touchRect
	if data.itemName then
		local targetView, targetClass = SoradGameGuide_GetStepDataInfo(self.currentStepIndex, data.itemName)
		dump(data, "data")
		_UPVALUE2_ = data
		data[1] = targetView
		data[2] = targetClass
		dump(data, "targetView,targetClass")
		tipsRect = self:getTargetRect(targetClass)
	end
	local posX = tipsRect.x + 0.5 * tipsRect.width + 0.5 * (tipsRect.width + tipsSize.width) * (arr == "left" and -1 or arr == "right" and 1 or 0) + offset.x
	local posY = tipsRect.y + 0.5 * tipsRect.height + 0.5 * (tipsRect.height + tipsSize.height) * (arr == "top" and 1 or arr == "bottom" and -1 or 0) + offset.y
	if data.isCenter then
		if arr == "top" or arr == "bottom" then
			arrPos.x = arrPos.x + (posX - display.cx)
			posX = display.cx
		end
	elseif posX < 0.5 * tipsSize.width + 20 then
		arrPos.x = arrPos.x - (0.5 * tipsSize.width + 20 - posX)
		posX = 0.5 * tipsSize.width + 20
	elseif posX + 0.5 * tipsSize.width + 20 > display.width then
		arrPos.x = arrPos.x + (posX + 0.5 * tipsSize.width + 20 - display.width)
		posX = display.width - 0.5 * tipsSize.width - 20
	end
	local noticeKey
	if data.noticeKey then
		noticeKey, _ENV = data.noticeKey, data.noticeKey
		for k, v in pairs(data.noticeKey) do
			noticeKey[k] = SoradGameGuide_GetNoticeKey(k, v)
		end
	end
	tips.imgTips:setContentSize(tipsSize)
	tips.imgTips:setPosition(cc.p(posX, posY))
	tips.labelTips:setString(i18n(data.notice, noticeKey))
	tips.labelTips:setTextAreaSize(cc.size(tipsSize.width - 20, tipsSize.height - 20))
	tips.spriteArr:setRotation(rotation)
	tips.spriteArr:setPosition(arrPos)
	tips.imgTips:setVisible(true)
	if data.otherTips then
		if tips.otherTips == nil then
			tips.otherTips, _ENV = tips.otherTips, tips.otherTips
			tips.otherTips.imgTips, tips.otherTips.labelTips, tips.otherTips.spriteArr = self.createTipFrame()
			tips.otherTips.imgTips:addTo(self, 3)
			tips.otherTips.imgTips:setVisible(false)
		end
		self:setTips(tips.otherTips, data.otherTips)
	elseif tips.otherTips then
		tips.otherTips.imgTips:setVisible(false)
	end
end
function gameGuideView:showTips()
	local isTips = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isTips")
	if isTips then
		self:setTips(self.tableTips, isTips)
	else
		self.tableTips.imgTips:setVisible(false)
		if self.tableTips.otherTips then
			self.tableTips.otherTips.imgTips:setVisible(false)
		end
	end
	self.isOnlyShow = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isOnlyShow")
end
function gameGuideView:showFinger()
	local showFinger = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isFinger")
	if showFinger then
		local fix_x_ar = SoradGameGuide_getFingerData(self.currentStepIndex, "fix_x_ar") or 0
		local fix_x_en = SoradGameGuide_getFingerData(self.currentStepIndex, "fix_x_en") or 0
		local fix_x = SoraDFIsRA() and fix_x_ar or fix_x_en
		local posX = self.touchRect.x + 0.5 * self.touchRect.width + SoradGameGuide_getFingerData(self.currentStepIndex, "x") + fix_x
		local posY = self.touchRect.y + 0.5 * self.touchRect.height + SoradGameGuide_getFingerData(self.currentStepIndex, "y")
		if SoradGameGuide_getFingerData(self.currentStepIndex, "beginX") ~= 0 then
			posX = self.touchRect.x + SoradGameGuide_getFingerData(self.currentStepIndex, "beginX")
		end
		if SoradGameGuide_getFingerData(self.currentStepIndex, "beginY") ~= 0 then
			posY = self.touchRect.y + SoradGameGuide_getFingerData(self.currentStepIndex, "beginY")
		end
		print("======显示手指gameGuideView===========")
		self.spriteFinger:setPosition(cc.p(posX, posY))
		self.spriteFinger:setVisible(true)
		self.spriteFinger:getChildByName("Node_effect"):setVisible(SoradGameGuide_getFingerData(self.currentStepIndex, "round"))
		local moveData = SoradGameGuide_getFingerData(self.currentStepIndex, "moveData")
		if moveData then
			do
				local _ENV, actTab = self.currentStepIndex, self.currentStepIndex
				for i = 1, #moveData - 3, 4 do
					table.insert(actTab, cca.callFunc(function(...)
						self.spriteFinger:setPosition(posX + moveData[i], posY + moveData[i + 1])
						self.spriteFinger:setVisible(true)
					end))
					table.insert(actTab, cca.fadeIn(0.2))
					table.insert(actTab, cca.scaleTo(0.2, 1.2))
					table.insert(actTab, cca.scaleTo(0.2, 1))
					table.insert(actTab, cca.delay(0.5))
					table.insert(actTab, cca.moveTo(0.7, posX + moveData[i + 2], posY + moveData[i + 3]))
					table.insert(actTab, cca.delay(0.5))
					table.insert(actTab, cca.fadeOut(0.5))
					table.insert(actTab, cca.callFunc(function(...)
						self.spriteFinger:setVisible(false)
					end))
					table.insert(actTab, cca.delay(0.5))
				end
				local seqAction = cca.seq(actTab)
				local moveAction = cca.repeatForever(seqAction)
				moveAction:setTag(1)
				self.spriteFinger:runAction(moveAction)
			end
		end
	end
end
function gameGuideView:showFingerList(...)
	local itemNameList = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "itemNameList")
	if itemNameList and next(itemNameList) then
		self.spriteFinger:setVisible(false)
		local className = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "className")
		local targetView
		if className == "worldMapView" then
			targetView = SoraDCurrentSceneShowView("worldMapView")
		else
			targetView = SoraDSearchPanelFromManagerByName(className)
		end
		local is3d = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "is3d")
		local createFingerSingle = function(target)
			local finger = SoraDFingerAction(nil, nil, nil, true)
			finger:addTo(self, 4)
			local rect = self:getTargetRect(target, nil, is3d)
			local posX = rect.x + 0.5 * rect.width
			local posY = rect.y + 0.5 * rect.height
			finger:setPosition(cc.p(posX, posY))
			table.insert(self.fingerList, finger)
		end
		local parameters = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "parameters")
		for i, itemName in ipairs(itemNameList) do
			local targetClass = targetView:gameGuide_getTarget(itemName, parameters)
			if targetClass then
				if type(targetClass) == "table" then
					for __, v in ipairs(targetClass) do
						createFingerSingle(v)
					end
				else
					createFingerSingle(targetClass)
				end
			end
		end
	end
end
function gameGuideView:hiddleFingerList(...)
	for i, finger in ipairs(self.fingerList) do
		finger:removeFromParent()
	end
	self.fingerList, _ENV = ipairs(self.fingerList)
end
function gameGuideView:hiddleBorder()
	if self.particleNode then
		self.particleNode:removeFromParent()
		self.particleNode = nil
	end
	if self.lightRect then
		self.lightRect:removeFromParent()
		self.lightRect = nil
	end
end
function gameGuideView:hiddleTips()
	if self.tableTips.imgTips then
		self.tableTips.imgTips:setVisible(false)
		if self.tableTips.otherTips then
			self.tableTips.otherTips.imgTips:setVisible(false)
		end
	end
	self.isOnlyShow = false
end
function gameGuideView:hiddleFinger()
	self.spriteFinger:stopActionByTag(1)
	self.spriteFinger:setVisible(false)
	if self.roundNode then
		self.roundNode:removeFromParent()
		self.roundNode = nil
	end
end
function gameGuideView:showSword()
	local swordRotation = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isSword")
	if swordRotation then
		local swordH = self.spriteSword:getContentSize().height
		local rotation = swordRotation == "top" and 0 or swordRotation == "bottom" and 180 or swordRotation == "left" and -90 or swordRotation == "right" and 90
		local posX = self.touchRect.x + 0.5 * self.touchRect.width + 0.5 * (self.touchRect.width + swordH) * (swordRotation == "left" and -1 or swordRotation == "right" and 1 or 0)
		local posY = self.touchRect.y + 0.5 * self.touchRect.height + 0.5 * (self.touchRect.height + swordH) * (swordRotation == "top" and 1 or swordRotation == "bottom" and -1 or 0)
		local aPosX = swordRotation == "left" and -30 or swordRotation == "right" and 30 or 0
		local aPosY = swordRotation == "top" and 30 or swordRotation == "bottom" and -30 or 0
		self.spriteSword:setRotation(rotation)
		self.spriteSword:setPosition(cc.p(posX, posY))
		_UPVALUE1_ = cc.p(posX, posY)
		cc.p(posX, posY)[1] = cca.moveBy(0.5, aPosX, aPosY)
		cc.p(posX, posY)[2] = cca.moveBy(0.5, -aPosX, -aPosY)
		cc.p(posX, posY)[3] = cca.moveBy(0.5, -aPosX, -aPosY)
		cc.p(posX, posY)[4] = cca.moveBy(0.5, -aPosX, -aPosY)
		cc.p(posX, posY)[5] = cca.moveBy(0.5, -aPosX, -aPosY)
		self.spriteSword:runAction(cca.repeatForever(cca.seq(cc.p(posX, posY))))
		self.spriteSword:setVisible(true)
	end
end
function gameGuideView:closeGuide(isUpdate)
	self.isUpdate = isUpdate
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
	;(nil).otherPic = true
	SoraDSendMessage(nil)
	self:removeFromParent()
end
function gameGuideView:onExitOther()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_END"
	;(nil).needUpdate = self.isUpdate
	SoraDSendMessage(nil)
end
function gameGuideView:endCurIndexStep(canEndStep)
	if G_IS_UNITY and tolua.isnull(self) then
		return
	end
	print("完成步骤 ========== ", self.currentStepIndex)
	_ENV = "完成步骤 ========== "
	;("完成步骤 ========== ").msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
	;("完成步骤 ========== ").otherPic = true
	SoraDSendMessage("完成步骤 ========== ")
	if not canEndStep and SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "waitMsgEndStep") then
		if not SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "keepRect") then
			self:addTouchClipeRect(cc.rect(-1, -1, 1, 1))
		end
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	guideCtrl:CompleteGuideStep(self.currentStepIndex)
	local isEndStepSDKLog = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isEndStepSDKLog")
	if isEndStepSDKLog then
		local sdkLogStep = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "sdkLogStep")
		userSDKManager.onGuideEvent(sdkLogStep or self.currentStepIndex)
	end
	if self.currentStepIndex == 1400004 or self.currentStepIndex == 1600002 then
		_ENV = userSDKManager.onGuideEvent
		userSDKManager.onGuideEvent.msg = "MESSAGE_SOLDIERRUSH_UI_CONTINUE_PLAY"
		SoraDSendMessage(userSDKManager.onGuideEvent)
	end
	if self.currentStepIndex == 2036 then
		print("userSDKManager.reportFinishGuide")
		userSDKManager.reportFinishGuide()
		userSDKManager.onGuideEvent(2037)
	end
	if self.currentStepIndex == 2001 then
		_ENV = sdkLogStep or self.currentStepIndex
		userSDKManager.logEvent(gSDKDef.TDonEvent.guide_first_step_finish, sdkLogStep or self.currentStepIndex)
	end
	if self.currentStepIndex == 830104 then
		_ENV = gSDKDef.TDonEvent.guide_first_step_finish
		gSDKDef.TDonEvent.guide_first_step_finish.msg = "MESSAGE_SERVER_GUIDE_HIDE_AND_SHOW"
		SoraDSendMessage(gSDKDef.TDonEvent.guide_first_step_finish)
	end
	if self.currentStepIndex == 2012 then
		local gametop = gModuleMgr.getObject("gametop")
		local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
		local curChapterID = newPlayerTaskCtrl:getCurChapterID()
		_ENV = cc.rect(-1, -1, 1, 1)
		cc.rect(-1, -1, 1, 1).byUID = true
		local chapterIDTb = SoraDConfigGet("Game:newPlayerTask:chapterID~table", cc.rect(-1, -1, 1, 1))
		local curRecord = chapterIDTb[tostring(curChapterID)]
		print("2012完成步骤")
		if not curRecord or curRecord == 0 or curChapterID == 4103000 then
			print("chapterTaskShowView show")
			local panel = SoraDCreatePanel("chapterTaskShowView")
			panel:initData(curChapterID)
			panel:show(display.getRunningScene(), 200)
			self:closeGuide(false)
			return
		end
	end
	if self.currentStepIndex == 60005 then
		gModuleMgr.sharedMgr("mildGuideManager"):starToAutoKillMonster()
	end
	if self.currentStepIndex == 67001 or self.currentStepIndex == 67002 then
		_ENV = self.currentStepIndex
		local self.currentStepIndex.isNewTrial, data = true, self.currentStepIndex
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ESCORT, data)
	end
	if self.currentStepIndex == 69004 then
		local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
		princeGiftCtrl:reqFinishGuide()
	end
	if self.currentStepIndex == 91002 then
		local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
		godArmsRuneCtrl:sendGuide()
	end
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	if self.currentStepIndex == 81003 and heroCtrl:getHeroInfoByID(1700) then
		self:closeGuide(false)
		return
	end
	if self.currentStepIndex == 810702 or self.currentStepIndex == 810800 or self.currentStepIndex == 811704 or self.currentStepIndex == 811803 then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYGUIDE_CONTINUE"
		SoraDSendMessage(self)
	end
	self.isStopGuide = SoradGameGuide_IsStopGuideAfterStep(self.currentStepIndex)
	if self.isStopGuide then
		_ENV = self.currentStepIndex
		self.currentStepIndex.msg = "MESSAGE_QUEST_NOTICE_SHOW_HAND"
		SoraDSendMessage(self.currentStepIndex)
		_ENV = self.currentStepIndex
		self.currentStepIndex.msg = "MESSAGE_SERVER_GUIDE_LAST_FINISH"
		self.currentStepIndex.step = self.currentStepIndex
		SoraDSendMessage(self.currentStepIndex)
		self:closeGuide(SoradGameGuide_IsStopGuideNeedUpdate(self.currentStepIndex))
		if self.currentStepIndex == 57003 then
			SoraDRemoveAllPanelFromManager()
			SoraDNewChapterOpen()
		end
		print("self.currentStepIndex ==== ", self.currentStepIndex)
		if self.currentStepIndex == 81006 then
			SoraDRemoveAllPanelFromManager()
		end
		return
	end
	self:hiddleGirl()
	if SoradGameGuide_isAutoNextStep(self.currentStepIndex) then
		if self.currentStepIndex == 1009 then
			self:stepOnGuide(2013)
		else
			local nextStep = SoradGameGuide_getNextStep(self.currentStepIndex) or self.currentStepIndex + 1
			print("nextStep========", nextStep)
			self:stepOnGuide(nextStep)
		end
	else
		GameGuideLog("进入等待状态 gameGuideView:endCurIndexStep")
		self.bgImg:setOpacity(SoradGameGuide_getGrayStyle(self.currentStepIndex, "delay") and gameGuideGray or 0)
		if self.waitLogTimer == nil then
			self.waitLogTimer = SoraDCreateDelayTimer(self, function(...)
				local topPanelName = SoraDCurrentTopPanelFromManager() and SoraDCurrentTopPanelFromManager().__cname or SoraDCurrentSceneShowView().__cname
				GameGuideLog("进入等待状态后无响应 topPanelName：" .. topPanelName)
				SoraDManagerRemoveTimer(self, self.waitLogTimer)
				self.waitLogTimer = nil
			end, 8)
		end
	end
	self:addTouchClipeRect(cc.rect(-1, -1, 1, 1))
	self.btnCenter:setVisible(false)
end
function gameGuideView:buttonEventSpecialSend(targetView, targetClass)
	if self.currentStepIndex == 2030 then
		SoraDCurrentSceneShowView("worldMapView"):guideDoClick("closestResourceFood", SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "parameters"))
		return true
	end
end
function gameGuideView:buttonEventSend(type, touchEndPos)
	local targetView, targetClass = SoradGameGuide_GetStepDataInfo(self.currentStepIndex)
	if targetClass then
		if self:buttonEventSpecialSend(targetView, targetClass) then
			return
		end
		while targetClass and targetClass.isTouchEnabled do
			print("循环找... ", self.currentStepIndex, targetClass:getName())
			if targetClass:isTouchEnabled() then
				break
			end
			targetClass = targetClass:getParent()
		end
		local touchEventListener = targetClass._touchEventListener_
		if touchEventListener then
			touchEventListener(targetClass, type, touchEndPos)
		elseif targetClass.dispatchEvent then
			targetClass:dispatchEvent(fgui.UIEventType.Click)
		end
	end
end
function gameGuideView:viewOnClick(ref, type)
	local isSwallows = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isSwallow")
	if type == ccui.TouchEventType.began then
		local touchBeganPoint = self:getTouchBeganPosition()
		if ref ~= self.touchNodes[5] or self:isSwallowTouches() ~= isSwallows then
		else
		end
	elseif type == ccui.TouchEventType.ended then
		local touchBeganPoint = ref:getTouchBeganPosition()
		local touchEndPoint = ref:getTouchEndPosition()
		if cc.pGetDistance(touchBeganPoint, touchEndPoint) > 10 then
			touchEndPoint = touchBeganPoint
		end
		print("111============", self.currentStepIndex, touchBeganPoint.x, touchBeganPoint.y, touchEndPoint.x, touchEndPoint.y)
		if self.isOnlyShow then
			print("222============")
			SoraDPlaySound()
			self:endCurIndexStep()
		elseif ref == self.touchNodes[5] then
			print("333============")
			local curSwallow = isSwallows
			local isStopGuide = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "isStopGuide")
			local nextStep = SoradGameGuide_getNextStep(self.currentStepIndex, "nextStep")
			print("isSwallowTouches,curSwallow,isStopGuide,nextStep====", self.touchNodes[5]:isSwallowTouches(), curSwallow, isStopGuide, nextStep)
			if self:isSwallowTouches() ~= curSwallow then
			end
			if curSwallow then
				self:buttonEventSend(type, touchEndPoint)
				if isStopGuide then
					self:endCurIndexStep()
					return
				end
			end
			if nextStep then
				self:endCurIndexStep()
				return
			end
			if self.currentStepIndex == 19004 or not isStopGuide then
				self:endCurIndexStep()
			end
			GameGuideLog("完成 gameGuideView:viewOnClick 地块")
		elseif self.isOnlyGirl then
			print("444============")
			GameGuideLog("完成 gameGuideView:viewOnClick 女孩")
			if self.currentStepIndex == 60003 then
				gModuleMgr.sharedMgr("mildGuideManager"):starToUnlockPet()
			elseif self.currentStepIndex == 60004 and self:checkUnlockHero() then
				gModuleMgr.sharedMgr("mildGuideManager"):starToHeroUnlockOneStep()
			end
			self:endCurIndexStep()
		else
			print("555============")
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = self:getTouchBeganPosition()
		local touchmovePoint = self:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			local needMove = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "needMove")
			if needMove == self:isSwallowTouches() then
			end
		elseif not self:isSwallowTouches() then
		end
	end
end
function gameGuideView:checkUnlockHero()
	if SoraDGetCastleLv() < CASTLE_LV7_LIMITED then
		return false
	end
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	return heroCtrl:checkCanUnlockHero()
end
function gameGuideView:stepOnGuide(stepIndex)
	print(debug.traceback(10), "gameGuideView:stepOnGuide")
	_ENV = debug.traceback(10)
	debug.traceback(10).msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
	debug.traceback(10).otherPic = false
	SoraDSendMessage((debug.traceback(10)))
	print("stepIndex ", stepIndex)
	print("self.currentStepIndex ", self.currentStepIndex)
	print(" SoradGameGuide_GetStepGetDataByKey ", SoradGameGuide_GetStepGetDataByKey(stepIndex, "precondition"))
	if stepIndex > self.currentStepIndex and SoradGameGuide_GetStepGetDataByKey(stepIndex, "precondition") <= self.currentStepIndex then
		self:stopAllActions()
		self:hiddleGirl()
		self.currentStepIndex = stepIndex
		if not self:doVerify() then
			self:createStepDataInfo(self.currentStepIndex)
		end
		GameGuideLog("步骤走到 gameGuideView:stepOnGuide")
		if self.waitLogTimer then
			SoraDManagerRemoveTimer(self, self.waitLogTimer)
			self.waitLogTimer = nil
		end
	else
		dump(stepIndex, "步骤不走：")
	end
end
function gameGuideView:startGuideWithStep(stepIndex, otherData)
	print(debug.traceback(10), "gameGuideView:startGuideWithStep")
	_UPVALUE2_ = debug.traceback(10)
	debug.traceback(10)[1] = stepIndex
	debug.traceback(10)[2] = otherData
	dump(debug.traceback(10), "gameGuideView:startGuideWithStep")
	_ENV = debug.traceback(10)
	debug.traceback(10).msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
	debug.traceback(10).otherPic = false
	SoraDSendMessage((debug.traceback(10)))
	local commonBox = SoraDSearchPanelFromManagerByName("commonPromptBox")
	if commonBox and commonBox:getTag() == 1 then
		print("get updateModule_disconnectUpdateTip")
		self:closeGuide(false)
		return
	end
	if (SoradGameGuide_GetStepGetDataByKey(stepIndex, "showScene") ~= "all" and SoraDCurrentSceneShowView(SoradGameGuide_GetStepGetDataByKey(stepIndex, "showScene"))) == nil then
		print("当前场景不符合启动标准")
		local verifyData = SoradGameGuide_GetStepGetDataByKey(stepIndex, "needVerify")
		if verifyData and verifyData.scene and SoraDCurrentSceneShowView() ~= nil and SoraDCurrentSceneShowView().__cname ~= nil then
			self.currentStepIndex = stepIndex
			self:doVerify()
		end
		self:closeGuide(false)
		return
	end
	if SoradGameGuide_GetStepGetDataByKey(stepIndex, "precondition") == nil then
		print("不存在的步数", stepIndex)
		self:closeGuide(false)
		return
	elseif SoradGameGuide_GetStepGetDataByKey(stepIndex, "precondition") > 0 then
		self.isForceSatrt = true
	end
	self:stopAllActions()
	self:hiddleGirl()
	self.currentStepIndex = stepIndex
	if self:doVerify() then
		print("进行步骤相关条件校验！！！")
		return
	end
	if self.currentStepIndex == 2001 then
		print("记录新手引导")
		_ENV = "precondition"
		userSDKManager.logEvent(gSDKDef.TDonEvent.guide_first_step_start, "precondition")
	end
	self:createStepDataInfo(self.currentStepIndex)
	self.isForceSatrt = false
	if otherData then
		self.otherData = otherData
	else
		self.otherData = nil
	end
	self:updateButtonPass()
	gModuleMgr.sharedMgr("mildGuideManager"):clean()
end
function gameGuideView:doVerify()
	local verifyData = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "needVerify")
	local needEnd = false
	if verifyData then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		if verifyData.scene then
			if SoraDCurrentSceneShowView(verifyData.scene) == nil then
				if verifyData.scene == "worldMapView" then
					SoraDGotoWorldMapPoint()
				elseif verifyData.scene == "mainCityView" then
					_ENV = verifyData.scene
					verifyData.scene.msg = "MESSAGE_MAINSCEN_ONSHOW"
					verifyData.scene.viewType = VIEW_TYPE_CITY
					SoraDSendMessage(verifyData.scene)
				end
				needEnd = true
			end
		elseif verifyData.count and verifyData.endStep then
			print("self.findFoodCount", self.findFoodCount, verifyData.count)
			needEnd = self.findFoodCount >= verifyData.count
		elseif verifyData.bid and verifyData.endStep then
			needEnd = #cityCtrl:getBuildCellList(verifyData.bid) > 0
		elseif verifyData.bid and verifyData.starStep then
			needEnd = #cityCtrl:getBuildCellList(verifyData.bid) <= 0
		elseif verifyData.index and verifyData.endStep then
			needEnd = cityCtrl:getBuildCellByIndex(verifyData.index) ~= nil
		elseif verifyData.queueType and verifyData.endStep then
			needEnd = queueCtrl:queryQueue(verifyData.queueType) ~= nil
		elseif verifyData.troops and verifyData.endStep then
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			needEnd = kingdomMapCtrl:isHasQueue() == 1
		elseif verifyData.needQueueType and verifyData.endStep then
			needEnd = queueCtrl:queryQueue(verifyData.needQueueType) == nil
		end
		if needEnd then
			if verifyData.endStep then
				for i = self.currentStepIndex, verifyData.endStep do
					guideCtrl:CompleteGuideStep(i)
				end
				self:startGuideWithStep(verifyData.endStep + 1)
			elseif verifyData.starStep then
				self:startGuideWithStep(verifyData.starStep)
			end
		end
	end
	return needEnd
end
function gameGuideView:createStepDataInfo(stepIndex)
	local isEndStepSDKLog = SoradGameGuide_GetStepGetDataByKey(stepIndex, "isEndStepSDKLog")
	local isSDKLog = SoradGameGuide_GetStepGetDataByKey(stepIndex, "isSDKLog")
	if not isEndStepSDKLog and isSDKLog then
		local sdkLogStep = SoradGameGuide_GetStepGetDataByKey(stepIndex, "sdkLogStep")
		userSDKManager.onGuideEvent(sdkLogStep or stepIndex)
	end
	if SoradGameGuide_GetStepGetDataByKey(stepIndex, "isCleanPanel") then
		SoraDRemoveAllPanelFromManager()
	end
	self.bgImg:setVisible(SoradGameGuide_GetStepGetDataByKey(stepIndex, "isMaskEnable"))
	self:addTouchClipeRect(cc.rect(-1, -1, 1, 1))
	print("gameGuideView", self.bgImg:getOpacity())
	if SoradGameGuide_GetStepGetDataByKey(stepIndex, "resetOpacityNow") then
		self.bgImg:setOpacity(SoradGameGuide_getGrayStyle(stepIndex, "delay") and gameGuideGray or 0)
	end
	local delayTime = SoradGameGuide_GetStepDelayTime(stepIndex)
	local mildValue = SoradGameGuide_GetStepGetDataByKey(stepIndex, "mildValue")
	local _ENV, actionsArray = stepIndex, stepIndex
	if mildValue then
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
			gModuleMgr.sharedMgr("mildGuideManager"):setVariate(mildValue.className, mildValue)
		end)
	end
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(delayTime)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local action = SoradGameGuide_GetStepGetDataByKey(stepIndex, "action")
		if action then
			local name = action.name
			if name == "mainCityView" then
				if action.index then
					print("action.index ", action.index)
					_ENV = "action.index "
					;("action.index ").msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
					;("action.index ").buildIndex = action.index
					;("action.index ").delay = action.delay
					SoraDSendMessage("action.index ")
				elseif action.bid then
					print("action.bid ", action.bid)
					_ENV = "action.bid "
					;("action.bid ").msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
					;("action.bid ").buildID = action.bid
					;("action.bid ").delay = action.delay
					;("action.bid ").isSelected = action.isSelected
					SoraDSendMessage("action.bid ")
				elseif action.move then
					_ENV = "action.bid "
					;("action.bid ").msg = "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO"
					;("action.bid ").targetPos = action.move
					;("action.bid ").delay = action.delay
					SoraDSendMessage("action.bid ")
				end
			elseif name == "BuildCreatePanel" then
				if action.bid then
					_ENV = "action.bid "
					;("action.bid ").msg = "MESSAGE_MAINCITYVIEW_BUILD_CREATE_POINT"
					;("action.bid ").bid = action.bid
					SoraDSendMessage("action.bid ")
				elseif action.key then
					_ENV = "action.bid "
					;("action.bid ").msg = "MESSAGE_MAINCITYVIEW_BUILD_CREATE_POINT"
					;("action.bid ").key = action.key
					SoraDSendMessage("action.bid ")
				end
			elseif name == "worldResourceMap" then
				if action.click then
					SoraDGetChildByName(display.getRunningScene(), "worldResourceMap"):gameGuide_getTarget(action.click, nil)
				end
			elseif name == "worldMapView" then
				if action.key then
					if SoraDCurrentSceneShowView("worldMapView"):gameGuide_getTarget("closestResourceFood", action) == nil then
						print("循环找田 ", self.findFoodCount)
						self.findFoodCount = self.findFoodCount + 1
						self:stopAllActionsByTag(1)
						local verifyData = SoradGameGuide_GetStepGetDataByKey(stepIndex, "needVerify")
						if self.findFoodCount > verifyData.count then
							print("放弃找田 ", self.findFoodCount)
							self.currentStepIndex = stepIndex
							self:doVerify()
						else
							stepIndex = nil
							;(nil)[1] = cc.DelayTime:create(1)
							;(nil)[2] = cc.CallFunc:create(function()
								self:createStepDataInfo(stepIndex)
							end)
							;(nil)[3] = cc.CallFunc:create(function()
								self:createStepDataInfo(stepIndex)
							end)
							;(nil)[4] = cc.CallFunc:create(function()
								self:createStepDataInfo(stepIndex)
							end)
							self:runAction(transition.sequence(nil))
						end
					end
				elseif action.jump then
					if action.duration then
						_ENV = transition.sequence(nil)
						transition.sequence(nil).duration = action.duration
						SoraDGotoWorldMapPoint(action.pos, nil, nil, nil, transition.sequence(nil))
					else
						SoraDGotoWorldMapPoint(action.pos)
					end
					self.currentStepIndex = stepIndex
					self:doVerify()
				elseif action.gotoSelfCity then
					local gametop = gModuleMgr.getObject("gametop")
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local pos = cityCtrl:getCurCityPos()
					if pos then
						SoraDGotoWorldMapPoint(pos)
					end
				end
				if action.buildTips then
					_ENV = gametop.playertop_:getModule("cityCtrl")
					gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_WORLD_MAP_SHOW_BUILD_TIPS"
					gametop.playertop_:getModule("cityCtrl").tilePoint = action.pos
					gametop.playertop_:getModule("cityCtrl").tipsInfo = action.buildTips
					gametop.playertop_:getModule("cityCtrl").delay = action.duration
					SoraDSendMessage((gametop.playertop_:getModule("cityCtrl")))
				end
			elseif name == "kingdomMapCtrl" then
				local gametop = gModuleMgr.getObject("gametop")
				local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
				kingdomMapCtrl:reqAddGuideQueue()
				_ENV, _ENV = action.duration, transition.sequence(nil)
				transition.sequence(nil).armyData, action.duration[501] = action.duration, 100
				gModuleMgr.sharedMgr("mildGuideManager"):setVariate("worldDispatchArmyView", transition.sequence(nil))
			elseif name == "MaterialFactory" then
				if action.move then
					_ENV = gametop.playertop_:getModule("kingdomMapCtrl")
					gametop.playertop_:getModule("kingdomMapCtrl").msg = "MESSAGE_UI_MATERIAL_FACTORY_GUIDE_STAR"
					SoraDSendMessage((gametop.playertop_:getModule("kingdomMapCtrl")))
				end
			elseif name == "evilPalaceMapView" then
				local panel = SoraDSearchPanelFromManagerByName("evilPalaceMapView")
				if panel then
					panel:gameGuide_getTarget(action.key)
				end
			elseif name == "newPlayerQuestView" then
				local panel = SoraDSearchPanelFromManagerByName("newPlayerQuestView")
				if panel == nil then
					SoraDCreatePanel("newPlayerQuestView"):show()
				end
			elseif name == "atlantis_gotoPoint" then
				local worldMapView = SoraDCurrentSceneShowView("worldMapView")
				if worldMapView and worldMapView:getComponent("worldMapComLod") then
					local atlantisWarUtil = include("atlantisWarUtil")
					local atlantisActivityRead = include("atlantisActivityRead")
					local buildId = atlantisWarUtil.getBuildIdByParams(action)
					local buildPoint = atlantisActivityRead.getMapBuildPos(buildId)
					_ENV = transition.sequence(nil)
					transition.sequence(nil).needAction = true
					transition.sequence(nil).toTilePos = buildPoint
					worldMapView:gotoTilePointNew(worldMapView, transition.sequence(nil))
				end
			elseif name == "atlantis_gotoSelfCity" then
				local worldMapView = SoraDCurrentSceneShowView("worldMapView")
				if worldMapView and worldMapView:getComponent("worldMapComLod") then
					local worldMapViewDef = include("worldMapViewDef")
					local cityCtrl = SoraDGetCtrl("cityCtrl")
					local cityPos = cityCtrl:getCurCityPos()
					_ENV = worldMapView
					worldMapView.needAction = true
					worldMapView.toTilePos = cityPos
					worldMapView.toScale = worldMapViewDef.NORMAL_SCALE
					worldMapView:gotoTilePointNew(worldMapView, worldMapView)
				end
			elseif name == "nebulaWarMap_gotoPoint" then
				local worldMapView = SoraDCurrentSceneShowView("worldMapView")
				if worldMapView and worldMapView:getComponent("worldMapComLod") then
					local worldMapViewDef = include("worldMapViewDef")
					if action.scaleNormal then
						_ENV = worldMapView
						worldMapView.toScale = worldMapViewDef.NORMAL_SCALE
						worldMapView.needAction = true
						worldMapView.toTilePos = cc.p(150, 150)
						worldMapView:gotoTilePointNew(worldMapView, worldMapView)
					else
						_ENV = worldMapView
						worldMapView.toScale = worldMapViewDef.MIN_SCALE
						worldMapView.needAction = true
						worldMapView.toTilePos = cc.p(181, 181)
						worldMapView:gotoTilePointNew(worldMapView, worldMapView)
					end
				end
			elseif name == "nebulaWarMap_showArrow" then
				_ENV = worldMapView
				worldMapView.key = action.key
				uiManager:show("NebulaWarGuide", worldMapView)
			elseif name == "showView" then
				local panel = SoraDSearchPanelFromManagerByName(action.key)
				if panel then
					panel:setVisible(true)
				end
			elseif name == "showWorldMapSelectPanel" then
				_ENV = panel.setVisible
				panel.setVisible.msg = "MESSAGE_WORLD_MAP_VISIBLE_SELECTSHOWPANEL"
				panel.setVisible.isVisible = action.key
				SoraDSendMessage(panel.setVisible)
			elseif name == "commandHall_warning" then
				_ENV = panel.setVisible
				panel.setVisible.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
				panel.setVisible.isVisible = action.key
				panel.setVisible.sType = 0
				panel.setVisible.sortIdx = gWarningSortIdx.commandHall_guide
				SoraDSendMessage(panel.setVisible)
			elseif name == "commandHall_openTask" then
				_ENV = panel.setVisible
				panel.setVisible.msg = "MESSAGE_COMMANDHALL_SELECT_TASK"
				panel.setVisible.taskType = action.key
				SoraDSendMessage(panel.setVisible)
			elseif name == "commandHall_openMainView" then
				uiManager:show("CommandHallMain")
			elseif name == "magicLamp_openMainView" then
				_ENV = true
				;(true).curType = gJinnType.JINN_ONE
				uiManager:show("MagicLampMain", true)
			elseif name == "sendmessage" then
				if action.key then
					_ENV = uiManager
					uiManager.msg = action.key
					SoraDSendMessage(uiManager)
				end
			elseif name == "nebulaAllStar_addBandage" then
				local itemCount = tonumber(self.otherData.noticeKey.num)
				_ENV = self.otherData.noticeKey.num
				local self.otherData.noticeKey.num[gIDDef.NEBULA_ALLSTAR_BANDAGE], itemList = itemCount, self.otherData.noticeKey.num
				SoraDMailGainItems(itemList)
			elseif name == "roaringFlame_gotoPoint" then
				local roaringFlameWarUtil = include("roaringFlameWarUtil")
				local roaringFlameWarRead = include("roaringFlameWarRead")
				local buildID = roaringFlameWarUtil.getGuideBuildID(action.subType)
				local buildPoint = roaringFlameWarRead.getBuildServerCoord(buildID)
				local worldMapView = SoraDCurrentSceneShowView("worldMapView")
				_ENV = 181
				;(181).needAction = true
				;(181).toTilePos = buildPoint
				worldMapView:gotoTilePointNew(worldMapView, 181)
			elseif name == "roaringFlame_showArrow" then
				uiManager:show("RoaringFlameWarGuide")
			end
			self.bgImg:setOpacity(SoradGameGuide_getGrayStyle(stepIndex, "action") and gameGuideGray or 0)
		end
	end)
	local action = SoradGameGuide_GetStepGetDataByKey(stepIndex, "action")
	if action then
		local delay = action.delay or 0
		actionsArray[#actionsArray + 1] = cca.delay(delay + 0.1)
	end
	if SoradGameGuide_GetStepGetDataByKey(stepIndex, "targetDelay") then
		actionsArray[#actionsArray + 1] = cca.delay(SoradGameGuide_GetStepGetDataByKey(stepIndex, "targetDelay"))
	end
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local action = SoradGameGuide_GetStepGetDataByKey(stepIndex, "action")
		if action then
			local name = action.name
			if name == "mainCityView" then
				_ENV = nil
				;(nil).msg = "MESSAGE_MAINCITYVIEW_RESET_CONTENT_VIEW"
				SoraDSendMessage(nil)
			end
		end
		print(SoradGameGuide_isOnlyShowAction(stepIndex), stepIndex, "SoradGameGuide_isOnlyShowAction(stepIndex)")
		if SoradGameGuide_isOnlyShowAction(stepIndex) then
			self:endCurIndexStep()
		end
	end)
	if not SoradGameGuide_isOnlyShowAction(stepIndex) then
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
			local targetView, targetClass = SoradGameGuide_GetStepDataInfo(stepIndex)
			self = nil
			;(nil)[1] = targetView
			;(nil)[2] = targetClass
			dump(nil, "targetView,targetClass")
			if targetView == nil and targetClass == nil then
				if SoradGameGuide_GetStepGetDataByKey(stepIndex, "className") and SoradGameGuide_GetStepGetDataByKey(stepIndex, "itemName") then
					print("没有取到该取的东西", stepIndex)
					self:stopAllActionsByTag(1)
					stepIndex = targetClass
					targetClass[1] = cc.DelayTime:create(1)
					targetClass[2] = cc.CallFunc:create(function()
						local targetView, targetClass = SoradGameGuide_GetStepDataInfo(stepIndex)
						self:drawGuideRect(stepIndex, targetView, targetClass)
					end)
					targetClass[3] = cc.CallFunc:create(function()
						local targetView, targetClass = SoradGameGuide_GetStepDataInfo(stepIndex)
						self:drawGuideRect(stepIndex, targetView, targetClass)
					end)
					targetClass[4] = cc.CallFunc:create(function()
						local targetView, targetClass = SoradGameGuide_GetStepDataInfo(stepIndex)
						self:drawGuideRect(stepIndex, targetView, targetClass)
					end)
					self:runAction(transition.sequence(targetClass))
				end
				return
			elseif targetClass == nil and SoradGameGuide_GetStepGetDataByKey(stepIndex, "needTarget") then
				print("界面存在 但是 没有取到该取的东西")
				self:stopAllActionsByTag(1)
				stepIndex = transition.sequence(targetClass)
				transition.sequence(targetClass)[1] = cc.DelayTime:create(1)
				transition.sequence(targetClass)[2] = cc.CallFunc:create(function()
					self:createStepDataInfo(stepIndex)
				end)
				transition.sequence(targetClass)[3] = cc.CallFunc:create(function()
					self:createStepDataInfo(stepIndex)
				end)
				transition.sequence(targetClass)[4] = cc.CallFunc:create(function()
					self:createStepDataInfo(stepIndex)
				end)
				self:runAction(transition.sequence(transition.sequence(targetClass)))
				return
			end
			self:drawGuideRect(stepIndex, targetView, targetClass)
		end)
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
			local showGirl = SoradGameGuide_GetStepGetDataByKey(stepIndex, "girl")
			if showGirl == nil then
				return
			end
			self.isOnlyGirl = SoradGameGuide_isOnlyGirl(stepIndex)
			self.bgImg:setOpacity(SoradGameGuide_getGrayStyle(stepIndex, "girl") and gameGuideGray or 0)
			if self.isOnlyGirl then
				self.isOnlyGirl = false
				stepIndex = stepIndex
				stepIndex[1] = cc.DelayTime:create(1.0)
				stepIndex[2] = cc.CallFunc:create(function()
					self.isOnlyGirl = true
				end)
				stepIndex[3] = cc.CallFunc:create(function()
					self.isOnlyGirl = true
				end)
				stepIndex[4] = cc.CallFunc:create(function()
					self.isOnlyGirl = true
				end)
				self:runAction(transition.sequence(stepIndex))
			end
			self:showGirl()
		end)
	end
	local actions = transition.sequence(actionsArray)
	actions:setTag(1)
	self:runAction(actions)
end
function gameGuideView:drawGuideRect(stepIndex, targetView, targetClass)
	if (targetView == nil or targetClass == nil) and SoradGameGuide_GetStepGetDataByKey(stepIndex, "className") and SoradGameGuide_GetStepGetDataByKey(stepIndex, "itemName") then
		self:startGuideWithStep(stepIndex)
	elseif targetClass then
		local scale = SoradGameGuide_GetStepGetDataByKey(stepIndex, "scale")
		local is3d = SoradGameGuide_GetStepGetDataByKey(stepIndex, "is3d")
		local rect = self:getTargetRect(targetClass, scale, is3d)
		dump(rect, "gameGuideView:drawGuideRect")
		if rect.x + rect.width * 0.5 < 0 or 0 > rect.y + rect.height * 0.5 or rect.width < 0 or 0 > rect.height or rect.x + rect.width * 0.5 > display.width or rect.y + rect.height * 0.5 > display.height then
			print("位置不对")
			self:stopAllActionsByTag(1)
			gameGuideGray = is3d
			is3d[1] = cc.DelayTime:create(1)
			is3d[2] = cc.CallFunc:create(function()
				self:createStepDataInfo(stepIndex)
			end)
			is3d[3] = cc.CallFunc:create(function()
				self:createStepDataInfo(stepIndex)
			end)
			is3d[4] = cc.CallFunc:create(function()
				self:createStepDataInfo(stepIndex)
			end)
			self:runAction(transition.sequence(is3d))
		end
		self:addTouchClipeRect(rect)
	end
	local normal = SoradGameGuide_getGrayStyle(stepIndex, "normal")
	local opacity = 0
	if type(normal) == "number" then
		opacity = normal
	else
		opacity = normal and gameGuideGray or 0
	end
	self.bgImg:setOpacity(opacity)
end
function gameGuideView:getTargetRect(target, scale, is3d)
	local _ENV, boundingBox
	if target.setPivot then
		boundingBox = target:displayObject():getBoundingBox()
		dump(target:displayObject():getBoundingBox(), "boundingBox-1")
		dump(target:getBoundingBox(), "boundingBox-1")
	else
		boundingBox = target:getBoundingBox()
	end
	local lbPoint = cc.p(boundingBox.x, boundingBox.y)
	local rtPoint = cc.p(boundingBox.x + boundingBox.width, boundingBox.y + boundingBox.height)
	if target.setPivot then
		if target:displayObject():getParent() == nil then
			return cc.rect(0, 0, 0, 0)
		end
		lbPoint = target:displayObject():getParent():convertToWorldSpace(lbPoint)
		rtPoint = target:displayObject():getParent():convertToWorldSpace(rtPoint)
		boundingBox.width = rtPoint.x - lbPoint.x
		boundingBox.height = rtPoint.y - lbPoint.y
	else
		local targetParent = target:getParent()
		if is3d then
			lbPoint = SoraDConvertoScreenPos2DOr3D(targetParent, lbPoint)
			rtPoint = SoraDConvertoScreenPos2DOr3D(targetParent, rtPoint)
		else
			lbPoint = targetParent:convertToWorldSpace(lbPoint)
			rtPoint = targetParent:convertToWorldSpace(rtPoint)
		end
	end
	boundingBox.width = rtPoint.x - lbPoint.x
	boundingBox.height = rtPoint.y - lbPoint.y
	if scale then
		lbPoint.x = lbPoint.x + boundingBox.width * (1 - scale) * 0.5
		lbPoint.y = lbPoint.y + boundingBox.height * (1 - scale) * 0.5
		boundingBox.width = boundingBox.width * scale
		boundingBox.height = boundingBox.height * scale
	end
	dump(cc.rect(lbPoint.x, lbPoint.y, boundingBox.width, boundingBox.height), "boundingBox-3")
	return cc.rect(lbPoint.x, lbPoint.y, boundingBox.width, boundingBox.height)
end
function gameGuideView:show(parent)
	parent = parent or display.getRunningScene()
	parent:addChild(self, 200)
end
function gameGuideView:initTips()
	self.tableTips.imgTips, self.tableTips.labelTips, self.tableTips.spriteArr = self.createTipFrame()
	self.tableTips.imgTips:addTo(self, 3)
	self.tableTips.imgTips:setVisible(false)
end
function gameGuideView.createTipFrame(data)
	local imgTips = ccui.ImageView:create("frame_newbie_task_dialog_box_01.png", ccui.TextureResType.plistType)
	imgTips:setAnchorPoint(cc.p(0.5, 0.5))
	imgTips:setScale9Enabled(true)
	imgTips:setCapInsets(cc.rect(25, 25, 26, 28))
	local labelTips = ccui.Text:create("", "", 20)
	labelTips:ignoreContentAdaptWithSize(false)
	labelTips:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	labelTips:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelTips:setTextColor(cc.c4b(255, 235, 185, 255))
	labelTips:setAnchorPoint(cc.p(0, 0))
	labelTips:setPosition(cc.p(10, 10))
	labelTips:addTo(imgTips)
	local spriteArr = display.newSprite("#frame_newbie_task_dialog_box_02.png")
	spriteArr:setAnchorPoint(cc.p(0.5, 0))
	spriteArr:addTo(imgTips)
	if data then
		local tipsSize = data.size
		local offset = cc.p(data.offset.x, data.offset.y)
		local arr = data.arr
		local rotation = 0
		local arrPos = cc.p(tipsSize.width, tipsSize.height)
		if data.isOverturn and not SoraDFIsRA() then
			if arr == "left" then
				arr = "right"
			elseif arr == "right" then
				arr = "left"
			end
		end
		if arr == "top" then
			rotation = 180
			offset.y = offset.y + 20
			arrPos.x = 0.5 * arrPos.x
			arrPos.y = 24
		elseif arr == "bottom" then
			rotation = 0
			offset.y = offset.y - 20
			arrPos.x = 0.5 * arrPos.x
			arrPos.y = arrPos.y - 22
		elseif arr == "left" then
			rotation = 90
			offset.x = offset.x - 20
			arrPos.y = 0.5 * arrPos.y
			arrPos.x = arrPos.x - 20
		elseif arr == "right" then
			rotation = -90
			offset.x = offset.x + 20
			arrPos.y = 0.5 * arrPos.y
			arrPos.x = 20
		end
		local tipsRect = data.touchRect
		local posX = tipsRect.x + 0.5 * tipsRect.width + 0.5 * (tipsRect.width + tipsSize.width) * (arr == "left" and -1 or arr == "right" and 1 or 0) + offset.x
		local posY = tipsRect.y + 0.5 * tipsRect.height + 0.5 * (tipsRect.height + tipsSize.height) * (arr == "top" and 1 or arr == "bottom" and -1 or 0) + offset.y
		if data.isCenter and (arr == "top" or arr == "bottom") then
			arrPos.x = arrPos.x + (posX - display.cx)
			posX = display.cx
		end
		imgTips:setContentSize(tipsSize)
		imgTips:setPosition(cc.p(posX, posY))
		if data.str then
			labelTips:setString(data.str)
		end
		labelTips:setTextAreaSize(cc.size(tipsSize.width - 20, tipsSize.height - 20))
		spriteArr:setRotation(rotation)
		spriteArr:setPosition(arrPos)
	end
	return imgTips, labelTips, spriteArr
end
function gameGuideView:initGirl()
	self.adjustOffsetY = 25
	self.adjustGirlOffsetY = 20
	self.adjustBoxDown = 6
	self.manNpcBox, _ENV, self.adjustactionSpeed = nil, nil, 0.8333333333333334
	self.arrX = 550 + self.adjustOffsetY
	self.manNpcBox.node = display.newNode()
	self.manNpcBox.node:addTo(self, 3)
	self.manNpcBox.node:setVisible(false)
	self.manNpcBox.node:setName("NodeGirl")
	self.manNpcBox.panelCut = ccui.Layout:create()
	self.manNpcBox.panelCut:setContentSize(cc.size(640, 960))
	self.manNpcBox.panelCut:setClippingEnabled(true)
	self.manNpcBox.panelCut:setTouchEnabled(false)
	self.manNpcBox.panelCut:setAnchorPoint(cc.p(0, 0))
	self.manNpcBox.panelCut:addTo(self.manNpcBox.node, 1)
	self.manNpcBox.panelCut:setPosition(0, 0)
	self.manNpcBox.panelCut:setName("panelCut")
	self.manNpcBox.spriteGirl = display.newSprite("#icon_merchant.png")
	self.manNpcBox.spriteGirl:addTo(self.manNpcBox.node)
	self.manNpcBox.spriteGirl:setVisible(false)
	self.manNpcBox.spriteGirl:setName("spriteGirl")
	self.manNpcBox.actGirl = SoraDCreateGuideNPC(1.2, cc.p(320, 70 + self.adjustGirlOffsetY), false, cc.size(500, 500), cc.p(240, 0))
	self.manNpcBox.actGirl:addTo(self.manNpcBox.node, 10)
	self.manNpcBox.actGirl:setVisible(false)
	self.manNpcBox.actGirl:setName("actGirl")
	local blackSheer = display.newSprite("#frame_sheer_items.png", 0, 0)
	blackSheer:setContentSize(329, 640)
	blackSheer:setRotation(-90)
	blackSheer:addTo(self, 2)
	blackSheer:setVisible(false)
	blackSheer:setPosition(320, 164.5)
	blackSheer:setName("sheerBlack")
	self.manNpcBox.sheer = blackSheer
	local blackSheer1 = display.newSprite("#frame_sheer_items.png", 0, 0)
	blackSheer1:setContentSize(329, 640)
	blackSheer1:setRotation(-90)
	blackSheer1:addTo(self, 2)
	blackSheer:setVisible(false)
	blackSheer1:setPosition(320, 164.5)
	blackSheer1:setName("sheerBlack")
	self.manNpcBox.sheer1 = blackSheer1
	self.manNpcBox.spriteNotice = display.newSprite("#frame_xsyd_dhk.png", 0, 0)
	self.manNpcBox.spriteNotice:addTo(self, 3)
	self.manNpcBox.spriteNotice:setVisible(false)
	self.manNpcBox.spriteNotice:setPosition(cc.p(960, 100))
	self.manNpcBox.spriteNotice:setName("MsgBox")
	_ENV = "MsgBox"
	;("MsgBox").text = ""
	;("MsgBox").size = 20
	;("MsgBox").color = cc.c3b(68, 35, 17)
	;("MsgBox").align = cc.TEXT_ALIGNMENT_CENTER
	;("MsgBox").valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	;("MsgBox").dimensions = cc.size(560, 120)
	;("MsgBox").x = 320 + self.adjustOffsetY * 2
	;("MsgBox").y = 115
	self.manNpcBox.labelNotice = display.newTTFLabel("MsgBox")
	self.manNpcBox.labelNotice:addTo(self.manNpcBox.spriteNotice)
	self.manNpcBox.labelNotice:setName("Text_dialog")
	local arr = display.newSprite("#icon_xsyd_tg.png", self.arrX, 35)
	arr:addTo(self.manNpcBox.spriteNotice)
	_UPVALUE1_ = 120
	;(120)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
	;(120)[2] = cca.moveTo(0.5, self.arrX, 35)
	;(120)[3] = cca.moveTo(0.5, self.arrX, 35)
	;(120)[4] = cca.moveTo(0.5, self.arrX, 35)
	;(120)[5] = cca.moveTo(0.5, self.arrX, 35)
	arr:runAction(cca.repeatForever(cca.seq(120)))
	arr:setName("Image_arrow")
	self.manNpcBox.arrow = arr
	self:fitHieghtView()
end
function gameGuideView:fitHieghtView()
	if display.width / display.height <= 0.5633802816901409 then
		return
	end
	if not self.originSize then
		self.originSize = self.manNpcBox.spriteNotice:getContentSize()
	end
	local scale = self.originSize.width / 640
	self.manNpcBox.spriteNotice:setContentSize(cc.size(self.originSize.width / scale, self.originSize.height))
	self.manNpcBox.spriteNotice:setPositionY(self.manNpcBox.spriteNotice:getPositionY() - 20)
	self.manNpcBox.labelNotice:setWidth(self.manNpcBox.labelNotice:getWidth() / scale)
	self.arrX = 500
	self.manNpcBox.labelNotice:setPositionX(320)
	self.manNpcBox.arrow:stopAllActions()
	_UPVALUE1_ = cc.size(self.originSize.width / scale, self.originSize.height)
	cc.size(self.originSize.width / scale, self.originSize.height)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[2] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[3] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[4] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[5] = cca.moveTo(0.5, self.arrX, 35)
	self.manNpcBox.arrow:runAction(cca.repeatForever(cca.seq(cc.size(self.originSize.width / scale, self.originSize.height))))
end
function gameGuideView:showGirl()
	local girlData = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "girl")
	local pos = girlData.pos
	if pos == nil then
		_UPVALUE2_ = "girl"
		pos, ("girl")[1] = "girl", "left"
		pos, ("girl")[2] = "girl", 320
	elseif pos[1] == nil then
		pos[1] = "left"
	elseif pos[2] == nil then
		pos[2] = 320
	end
	dump(girlData, "girlData=====")
	if girlData.pic then
		if girlData.pic == "lordHead" then
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local lordLocalData = include("lordLocalData")
			local info = lordSpineDef.getLordSpineInfo(lordInfoCtrl:getBaseInfo().imageId)
			if info then
				self.manNpcBox.spriteGirl:setVisible(false)
				self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
				local offset = info.offset or cc.p(0, 0)
				self.spine:setPosition(cc.p(320 + offset.x, 70 + offset.y))
				self.spine:setAnimation(0, "animation", true)
				self.spine:addTo(self.manNpcBox.panelCut, 1)
			else
				self.manNpcBox.spriteGirl:setVisible(true)
				self.manNpcBox.spriteGirl:setSpriteFrame(lordLocalData.getPortrait(lordInfoCtrl:getBaseInfo().imageId))
			end
		elseif girlData.pic == "curHeroHead" then
			local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
			local heroID = self.otherData and self.otherData.heroID or girlData.heroID
			if not heroID then
				local epicWarCtrl = SoraDGetCtrl("epicWarCtrl")
				local epicWarltCtrl = include("epicWarltCtrl")
				heroID = epicWarltCtrl.getStageHeroID(epicWarCtrl:getCurGateID())
			end
			_ENV = epicWarCtrl
			SoraDGetCtrl("epicWarCtrl")[1747] = true
			SoraDGetCtrl("epicWarCtrl")[1748] = true
			local SoraDGetCtrl("epicWarCtrl")[1749], useSpineConfig = true, SoraDGetCtrl("epicWarCtrl")
			local useSpine = useSpineConfig[heroID]
			_ENV = epicWarCtrl:getCurGateID()
			epicWarCtrl:getCurGateID().useSpine = useSpine
			local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(heroID, epicWarCtrl:getCurGateID())
			local isUsm = cfg.isUsm or false
			if useSpine then
				isUsm = false
			end
			self.manNpcBox.spriteGirl:setVisible(false)
			if isUsm then
				self.spine_hero = cc.criSprite.createCriSprite(spineCfg, false, true)
				self.spine_hero:setAnchorPoint(cc.p(0.5, 0))
				self.spine_hero:setPosition(320, -300)
				self.spine_hero:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
				self.spine_hero:addTo(self.manNpcBox.panelCut)
			else
				local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
				self.spine_hero = sp.SkeletonAnimation:create(spineCfg, atlas, 1)
				self.spine_hero:setAnimation(0, "animation", true)
				self.spine_hero:setPosition(320, -300)
				self.spine_hero:addTo(self.manNpcBox.panelCut)
			end
		elseif girlData.pic == "image" then
			self.manNpcBox.spriteGirl:setVisible(false)
			self.npc_image = display.newSprite(girlData.res)
			self.npc_image:setPosition(320, 300)
			self.npc_image:addTo(self.manNpcBox.panelCut)
		else
			self.manNpcBox.spriteGirl:setVisible(true)
			self.manNpcBox.spriteGirl:setSpriteFrame(girlData.pic)
			self.manNpcBox.spriteGirl:setScale(1)
		end
		self.manNpcBox.spriteGirl:setAnchorPoint(girlData.ap and girlData.ap or cc.p(0.5, 0))
		self.manNpcBox.spriteGirl:setPosition(girlData.spos and girlData.spos or cc.p(pos[2], 80))
		self.manNpcBox.spriteGirl:setFlippedX(pos[1] == "right")
		self.manNpcBox.actGirl:setVisible(false)
	else
		self.manNpcBox.actGirl:setVisible(true)
		self.manNpcBox.spriteGirl:setVisible(false)
	end
	local noticeKey
	if girlData.noticeKey then
		noticeKey, _ENV = girlData.noticeKey, girlData.noticeKey
		for k, v in pairs(girlData.noticeKey) do
			noticeKey[k] = SoradGameGuide_GetNoticeKey(k, v)
		end
	end
	if self.otherData then
		if not noticeKey then
			noticeKey, _ENV = self.otherData, self.otherData
		end
		if not self.otherData.noticeKey then
			_ENV = self.otherData.noticeKey
		end
		for k, v in pairs(self.otherData.noticeKey) do
			noticeKey[k] = SoradGameGuide_GetNoticeKey(k, v)
		end
	end
	local onlyShowNotice = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "onlyShowNotice")
	local showDelay = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "showDelay")
	if showDelay then
		lordSpineDef = SoradGameGuide_GetNoticeKey(k, v)
		SoradGameGuide_GetNoticeKey(k, v)[1] = cca.delay(showDelay)
		SoradGameGuide_GetNoticeKey(k, v)[2] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[3] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[4] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[5] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[6] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[7] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[8] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		SoradGameGuide_GetNoticeKey(k, v)[9] = cca.callFunc(function()
			if not onlyShowNotice then
				self.manNpcBox.node:setVisible(true)
			end
			self.manNpcBox.spriteNotice:setVisible(true)
			self.manNpcBox.sheer:setVisible(true)
			self.manNpcBox.sheer1:setVisible(true)
		end)
		self:runAction(cca.seq((SoradGameGuide_GetNoticeKey(k, v))))
	else
		if not onlyShowNotice then
			self.manNpcBox.node:setVisible(true)
		end
		self.manNpcBox.spriteNotice:setVisible(true)
		self.manNpcBox.sheer:setVisible(true)
		self.manNpcBox.sheer1:setVisible(true)
	end
	local needIphoneX = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "needIphoneX")
	local showNoticeBgAction = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "showNoticeBgAction")
	local posY = 120 + (needIphoneX and display.iPhoneXBottom or 0) - self.adjustBoxDown
	self.manNpcBox.labelNotice:setString(i18n(girlData.notice, noticeKey))
	if showNoticeBgAction then
		self.manNpcBox.arrow:stopAllActions()
		self.manNpcBox.spriteNotice:setOpacity(0)
		self.manNpcBox.sheer:setOpacity(0)
		self.manNpcBox.sheer1:setOpacity(0)
		self.bgImg:setOpacity(0)
		self.manNpcBox.spriteNotice:setPosition(cc.p(320, posY - 29))
		lordSpineDef = cc.p(320, posY - 29)
		cc.p(320, posY - 29)[1] = cca.fadeIn(0.333)
		cc.p(320, posY - 29)[2] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
		cc.p(320, posY - 29)[3] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
		cc.p(320, posY - 29)[4] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
		cc.p(320, posY - 29)[5] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
		cc.p(320, posY - 29)[6] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
		self.manNpcBox.spriteNotice:runAction(cca.spawn(cc.p(320, posY - 29)))
		self.manNpcBox.sheer:runAction(cca.fadeIn(0.367 * self.adjustactionSpeed))
		self.manNpcBox.sheer1:runAction(cca.fadeIn(0.367 * self.adjustactionSpeed))
		self.bgImg:runAction(cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4))
		lordSpineDef = cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4)
		cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
		cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4)[2] = cca.moveTo(0.5, self.arrX, 35)
		cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4)[3] = cca.moveTo(0.5, self.arrX, 35)
		cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4)[4] = cca.moveTo(0.5, self.arrX, 35)
		cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4)[5] = cca.moveTo(0.5, self.arrX, 35)
		self.manNpcBox.arrow:runAction(cca.repeatForever(cca.seq(cca.fadeTo(0.45 * self.adjustactionSpeed, 0.4))))
	else
		self.manNpcBox.spriteNotice:setPosition(cc.p(320, posY))
	end
	if not onlyShowNotice and SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "showGirlIntoAction") then
		self.manNpcBox.node:setPosition(cc.p(90, posY))
		self.manNpcBox.node:runAction(cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY)))
		SoraDGetChildByName(self.manNpcBox.actGirl, "Girl"):setOpacity(0)
		lordSpineDef = cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))
		cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))[1] = cc.EaseSineOut:create(cca.fadeTo(0.417 * self.adjustactionSpeed, 0.4))
		cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))[2] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
		cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))[3] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
		cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))[4] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
		cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))[5] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
		cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))[6] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
		SoraDGetChildByName(self.manNpcBox.actGirl, "Girl"):runAction(cca.seq(cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, posY))))
	else
		self.manNpcBox.node:setPosition(cc.p(0, posY))
	end
	SoraDPlaySound("newGuide", 1)
end
function gameGuideView:hiddleGirl()
	local girlData = SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "girl")
	if SoradGameGuide_GetStepGetDataByKey(self.currentStepIndex, "hidGirl") then
		self.manNpcBox.node:setVisible(false)
	end
	if self.spine then
		self.spine:removeFromParent()
		self.spine = nil
	end
	if self.spine_hero then
		self.spine_hero:removeFromParent()
		self.spine_hero = nil
	end
	if self.npc_image then
		self.npc_image:removeFromParent()
		self.npc_image = nil
	end
	self.isOnlyGirl = false
	if girlData ~= nil and girlData.nextStepClose ~= nil and girlData.nextStepClose == false then
		self.manNpcBox.spriteNotice:setVisible(true)
		self.manNpcBox.sheer:setVisible(true)
		self.manNpcBox.sheer1:setVisible(true)
	else
		self.manNpcBox.spriteNotice:setVisible(false)
		self.manNpcBox.sheer:setVisible(false)
		self.manNpcBox.sheer1:setVisible(false)
	end
	SoraDPlaySound("newGuide", 2)
end
function gameGuideView:updateButtonPass(...)
	if not self:checkNeedShowBtnPass() then
		if self.Button_pass then
			self.Button_pass:setVisible(false)
		end
		return
	end
	if self.Button_pass then
		self.Button_pass:setVisible(true)
	else
		local obj = fguiHelper.createObject("GameGuide", "Button_pass")
		obj:addTo(self)
		obj:setPosition(cc.p(380, 200))
		obj:addClickListener(handler(self, self.onClickBtnPass))
		obj:setString(i18n("flames_dunes_text315"))
		self.Button_pass = obj
	end
end
function gameGuideView:onClickBtnPass()
	SoraDPlaySound()
	local ok, guideStep = self:checkNeedShowBtnPass()
	if not ok then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:CompleteGuideStep(nil, guideStep)
	self:closeGuide(false)
end
function gameGuideView:checkNeedShowBtnPass(...)
	local guideModule = self.otherData and self.otherData.guideModule
	if not guideModule then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	local guideConfig = include("guideConfig")
	local guideStep = guideCtrl:getNotCompletedGuideStep(guideModule)
	if guideStep then
		local needJump = guideConfig.checkGuideStepNeedJump(guideStep)
		return needJump, guideStep
	end
end
function gameGuideView:gameGuide_getTarget(itemName, parameters)
	if itemName == "centerButton" then
		self.btnCenter:setVisible(true)
		self.btnCenter:setTitleText(i18n(parameters.btn))
		return self.btnCenter
	end
	return nil
end
return gameGuideView
