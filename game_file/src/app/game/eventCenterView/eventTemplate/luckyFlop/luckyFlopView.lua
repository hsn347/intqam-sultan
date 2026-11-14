local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local luckyFlopCtrl = SoraDGetCtrl("luckyFlopCtrl")
local luckyFlopRead = include("luckyFlopRead")
local luckyFlopView = class("luckyFlopView", function(target)
	return target or SoraDCreateBasePanel("luckyFlopView")
end)
function luckyFlopView:ctor()
	self.singleLight, _ENV = nil, nil
	self.activityID = gActivityTimeActivityID.LUCKY_FLIP_ACTIVITY
	self.scrollView = SoraDGetChildByName(self, "ScrollView")
	self.nodeBottom = SoraDGetChildByName(self.scrollView, "Bottom_Node")
	self.nodeTop = SoraDGetChildByName(self.scrollView, "Top_Node")
	self.btnFlopOne = SoraDGetExtendChildFromCCSByName(self.nodeBottom, "CCS_commonGoldNormalBtn_One")
	self.btnFlopTen = SoraDGetExtendChildFromCCSByName(self.nodeBottom, "CCS_commonGoldNormalBtn_Ten")
	self.nodePoint = SoraDGetChildByName(self, "Node_Num")
	self.btnAddPoint = SoraDGetChildByName(self.nodePoint, "Button_Add")
	self.btnLog = SoraDGetChildByName(self.nodeTop, "Button_Log")
	self.btnPointExlpain = SoraDGetChildByName(self.nodeBottom, "Button_PointExplain")
	self.textNum = SoraDGetChildByName(self.nodePoint, "Text_NumHave")
	self.textNum = SoraDChangeTextToHtml(self.textNum)
	self.textLogTip = SoraDGetChildByName(self.nodeBottom, "Text_Tip_Log")
	self.btnAward = SoraDGetChildByName(self.nodeTop, "Button_Preaward")
	self.textTime = SoraDGetChildByName(self.nodeTop, "Text_Time")
	self.textLoveNum = SoraDGetChildByName(self.nodeTop, "Text_LoveNum")
	self.textLoveTitle = SoraDGetChildByName(self.nodeTop, "Text_LoveTitle")
	self.textLoveTitle:setString(i18n("luckyFlip_text_02"))
	self.activityTime = SoraDGetChildByName(self.nodeTop, "Text_LeftTime")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.btnFlopOne:setTag(1)
	self.btnFlopOne:setColor(gBtnColorDef.YELLOW)
	_ENV = gBtnColorDef.YELLOW
	_ENV = i18n("luckyFlip_text_02")
	i18n("luckyFlip_text_02").num = 1
	gBtnColorDef.YELLOW.title = i18n("luckyFlip_btn_01", i18n("luckyFlip_text_02"))
	gBtnColorDef.YELLOW.gold = 1 * luckyFlopRead.getFlipNum()
	gBtnColorDef.YELLOW.icon = "icon_filp_score.png"
	self.btnFlopOne:initData(gBtnColorDef.YELLOW, 1)
	self.btnFlopOne:setTitleSize(cc.size(210, 21))
	self.btnFlopOne:addTouchEventListener(handler(self, self.btnClickFlop))
	self.btnFlopTen:setTag(10)
	_ENV = 10
	_ENV = handler(self, self.btnClickFlop)
	handler(self, self.btnClickFlop).num = 10
	;(10).title = i18n("luckyFlip_btn_01", handler(self, self.btnClickFlop))
	;(10).gold = 10 * luckyFlopRead.getFlipNum()
	;(10).icon = "icon_filp_score.png"
	self.btnFlopTen:initData(10, 1)
	self.btnFlopTen:setTitleSize(cc.size(210, 21))
	self.btnFlopTen:addTouchEventListener(handler(self, self.btnClickFlop))
	self.btnPointExlpain:addTouchEventListener(handler(self, self.btnClickPointExlpain))
	self.btnAddPoint:addTouchEventListener(handler(self, self.btnClickAddPoint))
	self.btnLog:addTouchEventListener(handler(self, self.btnClickOpenLog))
	self.textLogTip:setString(i18n("luckyFlip_text_14"))
	self.textTime:setString(i18n("rides_text_09"))
	self.btnAward:setTitleText(i18n("decrypt_text_03"))
	self.btnLog:setTitleText(i18n("luckyFlip_btn_02"))
	SoraDAutoSizeButtonText(self.btnLog, cc.size(115, 35))
	SoraDAutoSizeButtonText(self.btnAward, cc.size(115, 35))
	self.btnAward:addTouchEventListener(handler(self, self.btnClickOpenPreAward))
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDGetChildByName(self, "Sprite_time"):setPosition(cc.p(SoraDFPosX(640 - self.activityTime:getContentSize().width - 15), -53))
	self.nodeBeauty = SoraDGetChildByName(self.nodeBottom, "Node_Beauty")
	local spine_npc = sp.SkeletonAnimation:create("spine/madeling.skel", "spine/madeling.atlas", 1.65)
	spine_npc:addTo(self.nodeBeauty)
	spine_npc:setAnimation(0, "gaoxing", true)
	spine_npc:setPosition(cc.p(0, -160))
	self.nodeBeauty:setRotation3D(cc.vec3(0, SoraDFIsRA() and 180 or 0, 0))
	self.heartEffect = SoraDGetChildByName(self, "Node_HeartEffect")
	self.heartEffect = SoraDCreatAnimation("luckyFlopHeart", self.heartEffect, true)
	SoraDMixtureGLONEByParent(self.heartEffect)
	self.flopAnimation = SoraDGetChildByName(self, "Animation")
	self.flopAnimation = SoraDCreatAnimationEx("luckyFlopEffect", self.flopAnimation, true)
	SoraDMixtureGLONEByParent(self.flopAnimation)
	self:animationNormalLight(false)
	luckyFlopCtrl:reqLuckyFlipInit()
	self:fitView()
end
function luckyFlopView:setParentView(parent)
	self.parentView = parent
end
function luckyFlopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS", handler(self, self.updataData))
end
function luckyFlopView:updataData(target, data)
	if data.subMsg == "init" or data.subMsg == "notify" or data.subMsg == "lottery" then
		dump(data, "luckyFlopView:updataData", 10)
		self.lottoryScore = luckyFlopCtrl:getLottoryScore() or 0
		_ENV = "luckyFlopView:updataData"
		;("luckyFlopView:updataData").name = i18n("luckyFlip_text_06")
		_ENV, _ENV, ("luckyFlopView:updataData").num = self.lottoryScore, string.formatnumberthousands(self.lottoryScore), string.formatnumberthousands(self.lottoryScore)
		string.formatnumberthousands(self.lottoryScore).num, self.lottoryScore.color = self.lottoryScore, "#FFCC00"
		local str = i18n_html("common_text_036", "luckyFlopView:updataData", (string.formatnumberthousands(self.lottoryScore)))
		self.textNum:setString(str)
		self.btnFlopOne:setTextGoldColor(luckyFlopRead.isScoreEnough(self.lottoryScore, 1) and COLOR3.YELLOW or display.COLOR_RED)
		self.btnFlopTen:setTextGoldColor(luckyFlopRead.isScoreEnough(self.lottoryScore, 10) and COLOR3.YELLOW or display.COLOR_RED)
		self.textLoveNum:setString(string.formatnumberthousands(luckyFlopCtrl:getLoveNum()))
		local height = self.textNum:getContentSize().width
		SoraDSetTextWidthHeight(self.textNum, cc.size(height < 500 and height or 500, 23))
		SoraDToCenter(self.nodePoint, 0, SoraDFIsRA())
		self:setButtonTitleColor(self.btnFlopTen)
		self:setButtonTitleColor(self.btnFlopOne)
		print("SoraDCurrentTopPanelNameFromManager()", SoraDCurrentTopPanelNameFromManager())
		if data.subMsg == "lottery" then
			if SoraDCurrentTopPanelNameFromManager() ~= "luckyFlopRewardView" then
				luckyFlopCtrl = SoraDCurrentTopPanelNameFromManager()
				SoraDCurrentTopPanelNameFromManager()[1] = cca.delay(0.8)
				SoraDCurrentTopPanelNameFromManager()[2] = cca.callFunc(function()
					SoraDCloseLoading(self.parentView)
					self.isRandEffect = false
					local panel = SoraDCreatePanel("luckyFlopRewardView")
					panel:updataDataScroll(data.luckyNumbers)
					panel:show()
				end)
				SoraDCurrentTopPanelNameFromManager()[3] = cca.callFunc(function()
					SoraDCloseLoading(self.parentView)
					self.isRandEffect = false
					local panel = SoraDCreatePanel("luckyFlopRewardView")
					panel:updataDataScroll(data.luckyNumbers)
					panel:show()
				end)
				self:runAction(cca.seq(SoraDCurrentTopPanelNameFromManager()))
			else
				self.isRandEffect = false
			end
		end
	elseif data.subMsg == "clickFlop" then
		if data.flopTimes == 10 then
			self:btnClickFlop(self.btnFlopTen, ccui.TouchEventType.ended)
		else
			self:btnClickFlop(self.btnFlopOne, ccui.TouchEventType.ended)
		end
	end
end
_UPVALUE9_, luckyFlopView.setButtonTitleColor = function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end, function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[1] = cc.p(-1.23, 0)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[2] = cc.p(10, 7)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[3] = cc.p(2.22, 3.73)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[4] = cc.p(-3.74, 1.68)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[5] = cc.p(-4.97, 1.87)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[6] = cc.p(8.41, 3.77)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[7] = cc.p(9, 3.56)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[8] = cc.p(1.22, 2.73)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[9] = cc.p(-5.5, 4.56)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[10] = cc.p(-6.51, 0.78)
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[11] = cc.p(-6.51, 0.78)
local (function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[12], posTbl = cc.p(-6.51, 0.78)
function luckyFlopView:animationNormalLight()
	if self.isRandEffect then
		return
	end
	local tmp = SoraDGetChildsArrayByName(self.flopAnimation, "Node_Effect_hyfp_", 10, 0)
	for i, v in ipairs(tmp) do
		local lightSingle = self.singleLight[i]
		if not lightSingle then
			lightSingle = SoraDCreatAnimationEx("luckyFlopLightSingle", nil, false)
			local gTexture = SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp")
			local gTextureNormal = SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")
			local index = i <= 5 and i or i - 5
			if 3 < index then
				index = 6 - index
				gTexture:setFlippedX(true)
				gTextureNormal:setFlippedX(true)
			end
			if 5 < i then
				gTextureNormal:setScale(1.23, 1.35)
				gTexture:setScale(1.23, 1.35)
			end
			gTexture:setSpriteFrame("dh_Tex_hyfp_01" .. index - 1 .. ".png")
			gTextureNormal:setSpriteFrame("dh_Tex_hyfp_01" .. index - 1 .. ".png")
			local gNumber = SoraDGetChildByName(lightSingle, "G_Number")
			gNumber:setSpriteFrame("dh_Tex_hyfp_00" .. i - 1 .. ".png")
			gNumber:setPosition(posTbl[i])
			if i == 10 then
				lightSingle.action:setFrameEventCallFunc(handler(self, self.lightEffectCallBack))
			end
			SoraDMixtureGLONEByParent(lightSingle)
			lightSingle:addTo(v)
			self.singleLight[i] = lightSingle
		end
		v:stopActionByTag(999)
		lightSingle.action:gotoFrameAndPause(0)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp"):setVisible(false)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal"):setVisible(true)
		posTbl = SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[1] = cca.delay((i * 20 - 20) / 60)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[2] = cca.callFunc(function()
			if not self.isRandEffect then
				lightSingle.action:gotoFrameAndPlay(0, false)
			end
		end)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[3] = cca.callFunc(function()
			if not self.isRandEffect then
				lightSingle.action:gotoFrameAndPlay(0, false)
			end
		end)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[4] = cca.callFunc(function()
			if not self.isRandEffect then
				lightSingle.action:gotoFrameAndPlay(0, false)
			end
		end)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[5] = cca.callFunc(function()
			if not self.isRandEffect then
				lightSingle.action:gotoFrameAndPlay(0, false)
			end
		end)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[6] = cca.callFunc(function()
			if not self.isRandEffect then
				lightSingle.action:gotoFrameAndPlay(0, false)
			end
		end)
		SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")[7] = cca.callFunc(function()
			if not self.isRandEffect then
				lightSingle.action:gotoFrameAndPlay(0, false)
			end
		end)
		local seqAction = cca.seq((SoraDGetChildByName(lightSingle, "G_dh_Tex_hyfp_Normal")))
		seqAction:setTag(999)
		lightSingle:runAction(seqAction)
	end
end
function luckyFlopView:animationRandLight()
	local _ENV, t
	self:stopActionByTag(666)
	for i, v in ipairs(self.singleLight) do
		table.insert(t, v)
		v:stopActionByTag(999)
		v:stopActionByTag(9999)
		v.action:gotoFrameAndPause(0)
	end
	for i = 1, 10 do
		local r = math.random(i, 10)
		t[i], t[r] = t[r], t[i]
	end
	self.isRandEffect = true
	for i, v in ipairs(t) do
		if 5 < i then
			break
		end
		SoraDGetChildByName(v, "G_dh_Tex_hyfp"):setVisible(true)
		SoraDGetChildByName(v, "G_dh_Tex_hyfp_Normal"):setVisible(false)
		_UPVALUE1_ = SoraDGetChildByName(v, "G_dh_Tex_hyfp_Normal")
		SoraDGetChildByName(v, "G_dh_Tex_hyfp_Normal")[1] = cca.delay((i * 10 - 10) / 60)
		SoraDGetChildByName(v, "G_dh_Tex_hyfp_Normal")[2] = cca.callFunc(function()
			v.action:gotoFrameAndPlay(0, false)
		end)
		SoraDGetChildByName(v, "G_dh_Tex_hyfp_Normal")[3] = cca.callFunc(function()
			v.action:gotoFrameAndPlay(0, false)
		end)
		local seqAction = cca.seq((SoraDGetChildByName(v, "G_dh_Tex_hyfp_Normal")))
		seqAction:setTag(9999)
		v:runAction(seqAction)
	end
end
function luckyFlopView:lightEffectCallBack(frameEventName)
	local frameEvent = frameEventName:getEvent()
	print("luckyFlopView:lightEffectCallBack", frameEvent)
	if frameEvent and frameEvent == "LightEnd" and not self.isRandEffect then
		_UPVALUE1_ = "luckyFlopView:lightEffectCallBack"
		;("luckyFlopView:lightEffectCallBack")[1] = cca.delay(1)
		;("luckyFlopView:lightEffectCallBack")[2] = cca.callFunc(function()
			self:animationNormalLight()
		end)
		;("luckyFlopView:lightEffectCallBack")[3] = cca.callFunc(function()
			self:animationNormalLight()
		end)
		local action = cca.seq("luckyFlopView:lightEffectCallBack")
		action:setTag(666)
		self:runAction(action)
	end
end
function luckyFlopView:fitView()
	local height = self:getPanelOffsetHeight()
	self.scrollView:setContentSize(cc.size(640, height - 149))
	height = height < 1136 and 1136 or height
	self.scrollView:setInnerContainerSize(cc.size(640, height - 149))
	self.nodeTop:setPositionY(height - 149)
	self.scrollView:jumpToTop()
end
function luckyFlopView:btnClickFlop(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local flopTimes = button:getTag()
		if luckyFlopRead.isScoreEnough(self.lottoryScore, flopTimes) then
			local stopRandEffect = function()
				_ENV = nil
				;(nil)[1] = cca.delay(0.3)
				;(nil)[2] = cca.callFunc(function()
					for i, v in ipairs(self.singleLight) do
						v.action:gotoFrameAndPlay(0, false)
					end
					_ENV = ipairs(self.singleLight)
					ipairs(self.singleLight).lottoryTimes = tonumber(flopTimes)
					luckyFlopCtrl:reqLuckyFlipLottery(ipairs(self.singleLight))
				end)
				;(nil)[3] = cca.callFunc(function()
					for i, v in ipairs(self.singleLight) do
						v.action:gotoFrameAndPlay(0, false)
					end
					_ENV = ipairs(self.singleLight)
					ipairs(self.singleLight).lottoryTimes = tonumber(flopTimes)
					luckyFlopCtrl:reqLuckyFlipLottery(ipairs(self.singleLight))
				end)
				self:runAction(cca.seq(nil))
			end
			luckyFlopRead = flopTimes
			luckyFlopRead = nil
			;(nil)[1] = cca.delay(0.8333333333333334)
			;(nil)[2] = cca.callFunc(stopRandEffect)
			;(nil)[3] = cca.callFunc(stopRandEffect)
			flopTimes[1] = cca.seq(nil)
			flopTimes[2] = cca.callFunc(function(...)
				self:animationRandLight()
			end)
			flopTimes[3] = cca.callFunc(function(...)
				self:animationRandLight()
			end)
			flopTimes[4] = cca.callFunc(function(...)
				self:animationRandLight()
			end)
			flopTimes[5] = cca.callFunc(function(...)
				self:animationRandLight()
			end)
			local seq = cca.spawn(flopTimes)
			if not self.isRandEffect then
				SoraDShowLoading(self.parentView)
				self:runAction(seq)
			end
		else
			SoraDShowMsgTip(i18n("luckyFlip_text_08"))
		end
	end
end
function luckyFlopView:btnClickAddPoint(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function luckyFlopView:btnClickPointExlpain(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("luckyFlopPointExplain"):show()
	end
end
function luckyFlopView:btnClickOpenLog(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("luckyFlopLogView")
		panel:show()
	end
end
function luckyFlopView:btnClickOpenPreAward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("luckyFlopPreAwardView")
		panel:show()
	end
end
return luckyFlopView
