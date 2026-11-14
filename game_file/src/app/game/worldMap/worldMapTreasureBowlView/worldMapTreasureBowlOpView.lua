local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local worldMapTreasureBowlOpView = class("worldMapTreasureBowlOpView", function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlOpView")
end)
function worldMapTreasureBowlOpView:ctor()
	self.enableTouchCloseSelf = true
	self.treasureBowl = nil
	self.isCanReceive = false
	self.treasureBowlRewardLimit = 0
	self.cooltime = 5
	self.maxcount = 10
	self.colledNum = 0
	self.showcolledNum = 0
	self.speed = 1.0
	self.tilesArray, _ENV, self.tilePoint = nil, nil, nil
	self.index = 1
	self.stopAction = false
	self.guide = false
	self.hasGuideView = false
	self.centerPoint = cc.p(0, 0)
	self.nodeTreasureBowl = SoraDGetChildByName(self, "Node_TreasureBowl")
	self.nodeTreasureBowl:setPosition(cc.p(0, -60))
	self.nodeInfo = SoraDGetChildByName(self, "Node_Info")
	self.nodeInfo:setPosition(cc.p(0, -60))
	self.progressBar = SoraDGetChildByName(self, "ProgressBar")
	self.progressBar:setVisible(false)
	self.text_num = SoraDGetChildByName(self, "Text_Num")
	self.text_info = SoraDGetChildByName(self, "Text_info")
	self.nodeProgress = SoraDGetChildByName(self, "LoadingBar")
	self.text_Count = cc.Label:createWithCharMap("fonts/bowl_num.png", 50, 62, 48)
	self.text_Count:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Count:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 350))
	self.text_Count:addTo(self.nodeInfo, 2)
	self.gainButton = SoraDGetChildByName(self, "btn_box")
	if self.gainButton then
		self.gainButton:addTouchEventListener(function(ref, type)
			self:gainButtonCallFun(ref, type)
		end)
	end
	self.btn_close = SoraDGetChildByName(self, "Top_Button_close")
	if self.btn_close then
		self.btn_close:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound("uicontrol", 1)
				self:close(ref, type)
			end
		end)
	end
	self.treasureBowlImg = display.newSprite("#icon_TreasureBowl.png")
	self.treasureBowlImg:addTo(self.nodeTreasureBowl, 1)
	self.timeHandler = SoraDCreateTimerEx(self, handler(self, self.endTime), 5)
end
function worldMapTreasureBowlOpView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_TREASURE_BOWL_CLICK", handler(self, self.serverMessage_RequestTreasureBowlClick))
end
function worldMapTreasureBowlOpView:initData(mapInstance)
	local treasureBowlClassID = mapInstance:getTreasureBowlClassID()
	local treasureBowlData = worldMapDefine.getTreasureBowlpackShow(treasureBowlClassID)
	self.treasureBowlImg:setSpriteFrame(treasureBowlData.image)
	if mapInstance.maxcount then
		self.maxcount = mapInstance.maxcount
	end
	if mapInstance.cooltime then
		self.cooltime = mapInstance.cooltime
	end
	_ENV = nil
	;(nil).time = self.cooltime
	;(nil).count = self.maxcount
	self.text_info:setString(i18n("common_text_3672", nil))
	SoraDGotoWorldMapPoint(self.tilePoint)
end
function worldMapTreasureBowlOpView:serverMessage_RequestTreasureBowlClick(target, data)
	SoraDCloseLoading(self)
	local err = data.err
	if err == gErrDef.Err_None then
		local reqData = data.data
		if not reqData then
			return
		end
		if 1 == reqData.count then
			self.cooltime = checknumber(reqData.cooltime)
			self.maxcount = checknumber(reqData.maxcount)
			self:showProgressBar(true)
		end
		if reqData.reward then
			self.stopAction = true
			do
				local showGainItem = function()
					local items = reqData.reward
					local reqData, list
					for _, item in ipairs(items) do
						list[item.id] = item.count
					end
					SoraDMailGainItems(list)
				end
				if self.hasHD then
					local frames = display.newFrames("jiemianguanzi_0%d.png", 3, 3)
					local animation = display.newAnimation(frames, 0.25)
					self.treasureBowlImg:playAnimationOnce(animation, false, function()
						showGainItem()
						_ENV = nil
						;(nil)[1] = cca.delay(1.0)
						;(nil)[2] = cca.callFunc(function()
							self:onCloseSelf()
						end)
						;(nil)[3] = cca.callFunc(function()
							self:onCloseSelf()
						end)
						local seq_close = cca.seq(nil)
						self:runAction(seq_close)
					end)
					self:posuitxEffect()
				else
					showGainItem()
					self:onCloseSelf()
				end
				SoraDPlaySound("worldmap", 12)
			end
		end
	else
		if err == gErrDef.Err_TOOLS_NOT_REACH then
			SoraDShowMsgTip(i18n("common_text_3621"))
		else
			local msgNotice = include("msgNotice")
			local errStr = msgNotice.getTipCode(err)
			if not errStr then
				errStr = data.errCode
			else
				errStr = i18n(errStr)
			end
			SoraDShowMsgTip(errStr)
		end
		self:onCloseSelf()
	end
end
function worldMapTreasureBowlOpView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapTreasureBowlOpView:getTilePoint()
	return self.tilePoint
end
function worldMapTreasureBowlOpView:viewOnClick(ref, type)
	if type == ccui.TouchEventType.ended and self:isCanCloseView() then
		self:close(ref, type)
		SoraDPlaySound("uicontrol", 1)
	end
end
function worldMapTreasureBowlOpView:gainButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		if self.stopAction then
			return
		end
		if self.hasGuideView then
			self:closeGuide()
		end
		self.colledNum = self.colledNum + 1
		kingdomMapCtrl:reqClickTreasureBowl(self.tilePoint.x, self.tilePoint.y, self.colledNum)
		if self.colledNum <= 1 then
			SoraDShowLoading(self)
			self.btn_close:setVisible(false)
		end
		self:showHammer(true)
		self:onUpdateProgressBar()
	end
end
function worldMapTreasureBowlOpView:runHammerAction()
	local timeframe = 1.0 / (15 * self.speed)
	local _ENV, actions
	self.image_Hammer:setOpacity(0)
	actions[#actions + 1] = cca.delay(timeframe)
	actions[#actions + 1] = cca.fadeTo(0, 1.0)
	_UPVALUE1_ = cca.fadeTo(0, 1.0)
	cca.fadeTo(0, 1.0)[1] = cca.delay(timeframe * 2.5)
	cca.fadeTo(0, 1.0)[2] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[3] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[4] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[5] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[6] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[7] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[8] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	local seq_bowl = cca.seq((cca.fadeTo(0, 1.0)))
	_UPVALUE1_ = cca.delay(timeframe * 2.5)
	cca.delay(timeframe * 2.5)[1] = cca.delay(timeframe * 4)
	cca.delay(timeframe * 2.5)[2] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 2.5)[3] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 2.5)[4] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 2.5)[5] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 2.5)[6] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 2.5)[7] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	local seq_sound = cca.seq((cca.delay(timeframe * 2.5)))
	local frames = display.newFrames("gchuizi_%02d.png", 1, 10)
	local animation = display.newAnimation(frames, timeframe)
	_UPVALUE3_ = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)[1] = cc.Animate:create(animation)
	cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)[2] = seq_sound
	cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)[3] = seq_bowl
	actions[#actions + 1] = cca.spawn(cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end))
	actions[#actions + 1] = cca.callFunc(function()
		self.showcolledNum = self.showcolledNum + 1
		if self.stopAction or self.showcolledNum >= self.colledNum then
			self:showHammer(false)
		else
			self:runHammerAction()
		end
	end)
	local action = cca.seq(actions)
	self.image_Hammer:runAction(action)
end
function worldMapTreasureBowlOpView:showHammer(show)
	if self.hasHD then
		self:showHammer_hd(show)
	else
		self:showHammer_2d(show)
	end
end
function worldMapTreasureBowlOpView:showHammer_hd(show)
	if show then
		if not self.image_Hammer then
			self.image_Hammer = display.newSprite("#gchuizi_01.png")
			self.image_Hammer:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 186))
			self.image_Hammer:addTo(self.nodeInfo, 3)
			self.image_Hammer:setVisible(false)
		end
		if not self.image_Hammer:isVisible() then
			self.speed = 1.0
			self.image_Hammer:setVisible(true)
			self.image_Hammer:stopAllActions()
			self:runHammerAction()
		elseif self.speed <= 4.0 then
			self.speed = self.speed + 0.5
		end
	elseif self.image_Hammer then
		self.image_Hammer:stopAllActions()
		self.image_Hammer:setVisible(false)
	end
end
function worldMapTreasureBowlOpView:runHammerAction_2d()
	print("runHammerAction_2d")
	local timeframe = 1.0 / (12 * self.speed)
	local _ENV, actions = "runHammerAction_2d", "runHammerAction_2d"
	self.image_Hammer:setOpacity(0)
	actions[#actions + 1] = cca.delay(timeframe)
	actions[#actions + 1] = cca.fadeTo(0, 1.0)
	_UPVALUE1_ = cca.fadeTo(0, 1.0)
	cca.fadeTo(0, 1.0)[1] = cca.delay(timeframe * 3.5)
	cca.fadeTo(0, 1.0)[2] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[3] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[4] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[5] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[6] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[7] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	cca.fadeTo(0, 1.0)[8] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeTreasureBowl, 0.25, nil)
		self:baptizeEffect()
	end)
	local seq_bowl = cca.seq((cca.fadeTo(0, 1.0)))
	_UPVALUE1_ = cca.delay(timeframe * 3.5)
	cca.delay(timeframe * 3.5)[1] = cca.delay(timeframe * 4)
	cca.delay(timeframe * 3.5)[2] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 3.5)[3] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 3.5)[4] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 3.5)[5] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 3.5)[6] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	cca.delay(timeframe * 3.5)[7] = cca.callFunc(function()
		if SoraDCurrentTopPanelFromManager() == self then
			SoraDPlaySound("trainsoilder", 300)
		end
	end)
	local seq_sound = cca.seq((cca.delay(timeframe * 3.5)))
	local frames = display.newFrames("znqchuizi_0%d.png", 1, 4)
	frames[#frames + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame("znqchuizi_01.png")
	local animation = display.newAnimation(frames, 0.08333333333333333)
	_UPVALUE3_ = "znqchuizi_01.png"
	;("znqchuizi_01.png")[1] = cc.Animate:create(animation)
	;("znqchuizi_01.png")[2] = seq_sound
	;("znqchuizi_01.png")[3] = seq_bowl
	actions[#actions + 1] = cca.spawn("znqchuizi_01.png")
	actions[#actions + 1] = cca.callFunc(function()
		self.showcolledNum = self.showcolledNum + 1
		if self.stopAction or self.showcolledNum >= self.colledNum then
			self:showHammer(false)
		else
			self:runHammerAction_2d()
		end
	end)
	local action = cca.seq(actions)
	self.image_Hammer:runAction(action)
end
function worldMapTreasureBowlOpView:showHammer_2d(show)
	if show then
		if not self.image_Hammer then
			self.image_Hammer = display.newSprite("#znqchuizi_01.png")
			self.image_Hammer:setScale(2.5)
			self.image_Hammer:setPosition(cc.p(self.centerPoint.x + 110, self.centerPoint.y + 160))
			self.image_Hammer:addTo(self.nodeInfo, 3)
			self.image_Hammer:setVisible(false)
		end
		if not self.image_Hammer:isVisible() then
			self.speed = 1.0
			self.image_Hammer:setVisible(true)
			self.image_Hammer:stopAllActions()
			self:runHammerAction_2d()
		elseif self.speed <= 4.0 then
			self.speed = self.speed + 0.5
		end
	elseif self.image_Hammer then
		self.image_Hammer:stopAllActions()
		self.image_Hammer:setVisible(false)
	end
end
function worldMapTreasureBowlOpView:showProgressBar(show)
	if show then
		self.btn_close:setVisible(false)
		self.progressBar:setVisible(true)
		self.text_Count:stopAllActions()
		self.text_Count:setOpacity(0)
		self.text_Count:setScale(6)
		_UPVALUE2_ = self.text_Count
		self.text_Count[1] = cca.fadeTo(0, 0)
		self.text_Count[2] = cca.fadeTo(0.1, 0.4)
		self.text_Count[3] = cca.fadeTo(0.1, 1.0)
		self.text_Count[4] = cca.fadeTo(0.1, 1.0)
		self.text_Count[5] = cca.fadeTo(0.1, 1.0)
		self.text_Count[6] = cca.fadeTo(0.1, 1.0)
		self.text_Count[7] = cca.fadeTo(0.1, 1.0)
		self.text_Count[8] = cca.fadeTo(0.1, 1.0)
		self.text_Count[9] = cca.fadeTo(0.1, 1.0)
		local seq_fade = cca.seq(self.text_Count)
		_UPVALUE2_ = cca.fadeTo(0, 0)
		cca.fadeTo(0, 0)[1] = cca.scaleTo(0, 6.0)
		cca.fadeTo(0, 0)[2] = cca.scaleTo(0.1, 4.5)
		cca.fadeTo(0, 0)[3] = cca.scaleTo(0.1, 1.25)
		cca.fadeTo(0, 0)[4] = cca.scaleTo(0.1, 1.25)
		cca.fadeTo(0, 0)[5] = cca.scaleTo(0.1, 1.25)
		cca.fadeTo(0, 0)[6] = cca.scaleTo(0.1, 1.25)
		cca.fadeTo(0, 0)[7] = cca.scaleTo(0.1, 1.25)
		cca.fadeTo(0, 0)[8] = cca.scaleTo(0.1, 1.25)
		local seq_scale = cca.seq((cca.fadeTo(0, 0)))
		_UPVALUE1_ = cca.scaleTo(0, 6.0)
		cca.scaleTo(0, 6.0)[1] = cca.callFunc(function()
			if self.cooltime >= 0 then
				self.text_Count:setString(self.cooltime)
				self.cooltime = self.cooltime - 1
			else
				self.text_Count:stopAllActions()
			end
		end)
		cca.scaleTo(0, 6.0)[2] = cca.delay(1.0)
		cca.scaleTo(0, 6.0)[3] = cca.delay(1.0)
		cca.scaleTo(0, 6.0)[4] = cca.delay(1.0)
		cca.scaleTo(0, 6.0)[5] = cca.delay(1.0)
		cca.scaleTo(0, 6.0)[6] = cca.delay(1.0)
		cca.scaleTo(0, 6.0)[7] = cca.delay(1.0)
		local seq_string = cca.seq((cca.scaleTo(0, 6.0)))
		_UPVALUE3_ = cca.delay(1.0)
		cca.delay(1.0)[1] = seq_string
		cca.delay(1.0)[2] = seq_scale
		cca.delay(1.0)[3] = seq_fade
		self.text_Count:runAction(cca.rep(cca.spawn(cca.delay(1.0)), self.cooltime + 1))
		self:onUpdateProgressBar()
	else
		self.progressBar:setVisible(false)
	end
end
function worldMapTreasureBowlOpView:onUpdateProgressBar()
	if self.maxcount > 0 and self.colledNum <= self.maxcount then
		local colledNum = self.maxcount - math.min(self.colledNum, self.maxcount)
		local percent = colledNum / self.maxcount * 100
		if self.nodeProgress then
			self.nodeProgress:setPercent(percent)
		end
		self.text_num:setString(colledNum .. "/" .. self.maxcount)
		local index = 1
		if percent <= 20 then
			index = 3
		elseif percent <= 70 then
			index = 2
		end
		if index ~= self.index then
			self.index = index
			if self.hasHD then
				self.treasureBowlImg:setSpriteFrame("jiemianguanzi_0" .. index .. ".png")
			end
			if 2 == self.index then
				print("worldmap sound", 13)
				SoraDPlaySound("worldmap", 13)
			elseif 3 == self.index then
				print("worldmap sound", 14)
				SoraDPlaySound("worldmap", 14)
			end
		end
	end
end
function worldMapTreasureBowlOpView:onCloseSelf()
	self.colledNum = 0
	self:close(self.btn_close, ccui.TouchEventType.ended)
end
function worldMapTreasureBowlOpView:isCanCloseView()
	return self.colledNum <= 0
end
function worldMapTreasureBowlOpView:onExitPanel()
	if self.nodeTreasureBowl.animShaker then
		self.nodeTreasureBowl.animShaker:stop()
	end
end
function worldMapTreasureBowlOpView:close(ref, type)
	if type == ccui.TouchEventType.ended and self:isCanCloseView() then
		SoraCollectgarbage(self.__cname)
		self:removeFromParent()
	end
end
function worldMapTreasureBowlOpView:baptizeEffect()
	local et_node = self.nodeTreasureBowl:getChildByName("parNode_baptize")
	if et_node then
		SoraDResetEffectNode(et_node)
	else
		_ENV, _ENV = et_node, SoraDResetEffectNode
		et_node.plist = "et_cornucopia_fire_01.plist"
		_ENV, SoraDResetEffectNode[1], et_node.scale = et_node, et_node, 2.0
		et_node.plist = "et_cornucopia_fire_02.plist"
		_ENV, SoraDResetEffectNode[2], et_node.scale = et_node, et_node, 2.0
		et_node.plist = "et_cornucopia_fire_03.plist"
		_ENV, SoraDResetEffectNode[3], et_node.scale = et_node, et_node, 2.0
		et_node.plist = "et_cornucopia_fire_04.plist"
		SoraDResetEffectNode[4], et_node.scale = et_node, 2.0
		local param = SoraDResetEffectNode
		local parNode = SoraDCreateEffectNode(param)
		parNode:setName("parNode_baptize")
		parNode:setPosition(cc.p(self.centerPoint.x + 50, self.centerPoint.y + 110))
		parNode:addTo(self.nodeTreasureBowl, 2)
	end
end
function worldMapTreasureBowlOpView:posuitxEffect()
	local et_node = self.nodeTreasureBowl:getChildByName("parNode_posuitx")
	if et_node then
		SoraDResetEffectNode(et_node)
	else
		_ENV, _ENV = et_node, SoraDResetEffectNode
		et_node.plist = "et_posuitx_01.plist"
		_ENV, SoraDResetEffectNode[1], et_node.scale = et_node, et_node, 3.0
		et_node.plist = "et_posuitx_02.plist"
		_ENV, SoraDResetEffectNode[2], et_node.scale = et_node, et_node, 3.0
		et_node.plist = "et_posuitx_03.plist"
		_ENV, SoraDResetEffectNode[3], et_node.scale = et_node, et_node, 3.0
		et_node.plist = "et_posuitx_04.plist"
		SoraDResetEffectNode[4], et_node.scale = et_node, 3.0
		local param = SoraDResetEffectNode
		local parNode = SoraDCreateEffectNode(param)
		parNode:setName("parNode_posuitx")
		parNode:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 100))
		parNode:addTo(self.nodeTreasureBowl, 2)
	end
end
function worldMapTreasureBowlOpView:shakeEffect(target, time, params)
	if target.animShaker then
		target.animShaker:stop()
	end
	local AnimShaker = include("AnimShaker")
	local animShaker = AnimShaker.new(target, time, params)
	target.animShaker = animShaker
	animShaker:run()
end
function worldMapTreasureBowlOpView:starLoadImage()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).name = "Common/gchuizi"
	;(nil).key = "gchuizi"
	local (nil)[1], imgArray
	local canLoad = true
	for _, v in ipairs(imgArray) do
		local ret = SoraDIsFileExistByKey(v.key)
		print(v.name .. " ret = ", ret)
		if not ret then
			canLoad = false
		end
	end
	if canLoad then
		SoraDShowLoading(self)
		self:loadImages(imgArray, function()
			self.index = 1
			self.treasureBowlImg:setSpriteFrame("jiemianguanzi_01.png")
			SoraDCloseLoading(self)
		end)
	end
	self.hasHD = canLoad
end
function worldMapTreasureBowlOpView:onEnterOther()
	self:starLoadImage()
	self:checkShowFinger()
end
function worldMapTreasureBowlOpView:endTime(dt)
	if self.colledNum <= 0 then
		self:openGuide()
	end
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function worldMapTreasureBowlOpView:openGuide()
	if self.guide then
		return
	end
	self.guide = true
	self.hasGuideView = true
	self:showRoundEffect()
	self:showFinger()
end
function worldMapTreasureBowlOpView:closeGuide()
	if self.hasGuideView then
		self.hasGuideView = false
		local effectNode = SoraDGetChildByName(self, "mildEffect")
		effectNode:removeAllChildren()
	end
end
function worldMapTreasureBowlOpView:showRoundEffect()
	local effectNode = SoraDGetChildByName(self, "mildEffect")
	local _ENV, _ENV, _ENV, param = nil, "mildEffect", self, self
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
	_ENV, ("mildEffect")[1], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	_ENV, ("mildEffect")[2], (nil).scale = nil, nil, 2
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
	_ENV, ("mildEffect")[3], (nil).seq = nil, nil, cca.seq(nil)
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
	_ENV, ("mildEffect")[4], (nil).seq = nil, nil, cca.seq(nil)
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
	_ENV, ("mildEffect")[5], (nil).seq = nil, nil, cca.seq(nil)
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
	_ENV, ("mildEffect")[6], (nil).seq = nil, nil, cca.seq(nil)
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
	_ENV, ("mildEffect")[7], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).plist = "et_xsyd_01.plist"
	_ENV, ("mildEffect")[8], (nil).scale = nil, nil, 3.3
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
	;("mildEffect")[9], (nil).seq = nil, cca.seq(nil)
	local actionConfig = "mildEffect"
	local roundNode = display.newNode()
	roundNode:setPosition(0, 0)
	roundNode:addTo(effectNode, 1)
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
			sprite:addTo(roundNode, k)
		elseif v.plist then
			table.insert(param, v)
			local et_node = SoraDCreateEffectNode(param)
			et_node:addTo(roundNode, k)
		end
	end
	roundNode:setScale(0.5)
end
function worldMapTreasureBowlOpView:showFinger()
	local effectNode = SoraDGetChildByName(self, "mildEffect")
	local posX = 0
	local posY = 0
	local spriteFinger = SoraDFingerAction()
	spriteFinger:addTo(effectNode, 2)
end
function worldMapTreasureBowlOpView:checkShowFinger()
	if not SoraDConfigGet("Game:BowlOpView:Guide~bool") then
		SoraDConfigSet("Game:BowlOpView:Guide~bool", true)
		self:openGuide()
	end
end
return worldMapTreasureBowlOpView
