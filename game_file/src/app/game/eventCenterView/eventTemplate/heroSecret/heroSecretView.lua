local heroSecretltCtrl = include("heroSecretltCtrl")
local itemDesRead = include("itemDesRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroSecretCtrl = SoraDGetCtrl("heroSecretCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local heroSecretView = class("heroSecretView", function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end)
_ENV = "heroSecretView"
;("heroSecretView")[1] = 33
;("heroSecretView")[2] = 30
;("heroSecretView")[3] = 24
;("heroSecretView")[4] = 18
;("heroSecretView")[5] = 12
;("heroSecretView")[6] = 6
;("heroSecretView")[7] = 0
;("heroSecretView")[8] = 3
;("heroSecretView")[9] = 9
;("heroSecretView")[10] = 15
;("heroSecretView")[11] = 21
local _UPVALUE3_, _ENV, ("heroSecretView")[12], frameTbl = nil, function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end, 27, "heroSecretView"
_UPVALUE3_, (function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end).kohGift, (nil)[1] = nil, nil, 13391
_UPVALUE3_, (function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end).kohGift, (nil)[2] = nil, nil, 13392
_UPVALUE3_, (function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end).kohGift, (nil)[3] = nil, nil, 13393
;(function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end).rosGift, (nil)[1] = nil, 13227
;(function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end).rosGift, (nil)[2] = nil, 13228
;(function(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end).rosGift, (nil)[3] = nil, 13229
local function giftID(target)
	return target or SoraDCreateBasePanel("heroSecretView")
end
function heroSecretView:ctor()
	self.height = 0
	self.ipadY = 0
	self.scale = 1
	self.isHideCurrentSceneView = true
	self.itemTbl, backpackCtrl, self.itemNum = backpackCtrl:getItemCount(816501) or 0, backpackCtrl:getItemCount(816501) or 0, backpackCtrl:getItemCount(816501) or 0
	SoraDGetChildByName(self, "Image_Bg"):setLocalZOrder(-100)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_heroSecret")
	self.nodeTitle:setBtnHelpClickCallBack(handler(self, self.btnClickQuestion))
	self.nodeTitle:setTitle(i18n("activity_name_24"))
	self.btnBag = SoraDGetChildByName(self, "Button_bag")
	self.btnBag:addTouchEventListener(handler(self, self.btnClickOpenBag))
	self.textNum = SoraDGetChildByName(self, "Text_Num")
	self.awardItem = SoraDGetChildByName(self, "Item")
	self.imageTop = SoraDGetChildByName(self, "Image_Up")
	self.imageMiddle = SoraDGetChildByName(self, "Image_Bg_Middle")
	self.imageDown = SoraDGetChildByName(self, "Image_Bg_Down")
	self.nodeScale = SoraDGetChildByName(self, "Node_Scale")
	self.nodeDown = SoraDGetChildByName(self, "Node_Bottom")
	self.nodeEffect = SoraDGetChildByName(self, "effect_Node")
	self.nodeEffectO = SoraDGetChildByName(self, "oeffect_Node")
	self.nodeEffectG = SoraDGetChildByName(self, "geffect_Node")
	self.nodeEffectO2 = SoraDGetChildByName(self, "oeffect_Node_2")
	self.nodeEffectBg = SoraDGetChildByName(self, "bgEffect_Node")
	self.panelLayer = SoraDGetChildByName(self, "Center_PanelLayer")
	self.panelLayer:addTouchEventListener(handler(self, self.btnClickPanel))
	self.panelLayer:setVisible(false)
	self.btnExtract = SoraDGetChildByName(self, "Btn_Open")
	self.btnExtract:addTouchEventListener(handler(self, self.btnClickExtract))
	self.textInfo = SoraDGetChildByName(self.btnExtract, "Text_Info")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.leftTime = SoraDGetChildByName(self.nodeTimer, "Text_LeftTime")
	self.btnAward = SoraDGetChildByName(self, "Image_IconBg")
	self.btnAward:setTouchEnabled(true)
	self.btnAward:addTouchEventListener(handler(self, self.btnClickShowAward))
	self.singleItem = SoraDGetChildByName(self, "Item_Single")
	self.singleItem:setVisible(false)
	self.textEnd = SoraDGetChildByName(self, "Text_End")
	self.btnTurn = SoraDGetChildByName(self, "Panel_Touch")
	self.btnTurn:setLocalZOrder(999999)
	self.btnTurn:setSwallowTouches(false)
	self.btnTurn:addTouchEventListener(handler(self, self.btnClickTurn))
	self.panelLayer:setContentSize(display.size)
	self.textClick = SoraDGetChildByName(self.panelLayer, "Text_Click")
	heroSecretCtrl:sendInitMsg()
	self.allLock = not heroSecretCtrl:isCanExtract()
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.nodeProgress:setPositionX(SoraDFPosX(20, 0))
	self.lBarProgress = SoraDGetChildByName(self.nodeProgress, "LoadingBar_progress")
	self.btnBox = SoraDGetChildByName(self.nodeProgress, "Button_box")
	self.btnBox:addTouchEventListener(handler(self, self.btnBoxClick))
	self.Node_lucky = SoraDGetChildByName(self, "Node_lucky")
	self.Panel_cutLucky = SoraDGetChildByName(self, "Panel_cutLucky")
	self.Button_lucky = SoraDGetChildByName(self, "Button_lucky")
	self.Node_luckydown = SoraDGetChildByName(self, "Node_luckydown")
	self.Text_lucky = SoraDGetChildByName(self, "Text_lucky")
	self.Button_luckyDetail = SoraDGetChildByName(self, "Button_luckyDetail")
	self.Button_lucky:addTouchEventListener(handler(self, self.btnLuckyClick))
	self.Button_luckyDetail:addTouchEventListener(handler(self, self.btnLuckyClick))
	self.Node_etFly = SoraDGetChildByName(self, "Node_etFly")
	self.Node_etLucky = SoraDGetChildByName(self, "Node_etLucky")
	self.Node_etBz = SoraDGetChildByName(self, "Node_etBz")
	self.et_fly = SoraDCreatAnimationEx("animationYXMZFly")
	self.et_fly:setVisible(false)
	self.et_fly:addTo(self.Node_etFly)
	self.et_bz = SoraDCreatAnimationEx("animationYXMZBZ", nil, false)
	self.et_bz:setVisible(false)
	self.et_bz:addTo(self.Node_etBz)
	self:fitView()
	self:initTimer()
	self:initData()
	SoraDTestButton(self, function()
		self:showLuckyFlyEffect()
	end)
end
function heroSecretView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_HEROSECRET_REFRESH", handler(self, self.updataInfo))
end
function heroSecretView:setLuckyPercent(percent)
	self.Panel_cutLucky:setContentSize(cc.size(61, 85 - 85 * percent))
	if 1 <= percent then
		self:showLuckyFullEffect()
	else
		self:hideLuckyFullEffect()
	end
end
function heroSecretView:setLuckyValue()
	self.luckyPoint = heroSecretCtrl:getLuckyPoint()
	heroSecretCtrl = nil
	;(nil).var = self.luckyPoint
	self.Text_lucky:setString(i18n("herovault_text_08", nil))
	if self.Text_lucky:getVirtualRendererSize().width > 120 then
		SoraDGetAutoHeightLabel(self.Text_lucky, 120)
	end
	SoraDToCenter(self.Node_luckydown)
	self:setLuckyPercent(self.luckyPoint / 1000)
end
function heroSecretView:showLuckyFlyEffect()
	local getNodeFly = function()
		self.et_fly:setPosition(0, 0)
		self.et_fly:setVisible(true)
		self.et_fly.action:gotoFrameAndPlay(0, true)
	end
	local getNodeBz = function()
		self.et_bz:setVisible(true)
		self.et_bz.action:gotoFrameAndPlay(0, false)
	end
	local pos = SoraDCoverToPoint(self.Node_lucky, cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY()), self.Node_etFly)
	_UPVALUE2_ = cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY())
	cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY())[1] = cca.callFunc(function()
		getNodeFly()
		self.et_fly:runAction(cca.moveTo(0.6666666666666666, pos.x, pos.y))
	end)
	cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY())[2] = cca.delay(0.6666666666666666)
	cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY())[3] = cca.callFunc(function()
		self.et_fly:setVisible(false)
		getNodeBz()
		self:setLuckyValue()
	end)
	cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY())[4] = cca.callFunc(function()
		self.et_fly:setVisible(false)
		getNodeBz()
		self:setLuckyValue()
	end)
	local seq_fly = cca.seq((cc.p(self.Node_etBz:getPositionX(), self.Node_etBz:getPositionY())))
	self:runAction(seq_fly)
end
function heroSecretView:showLuckyFullEffect()
	self.Node_etLucky:setVisible(true)
	if not self.et_full then
		self.et_full = SoraDCreatAnimationEx("animationYXMZFull")
		self.et_full:addTo(self.Node_etLucky)
	else
		self.et_full.action:gotoFrameAndPlay(0, true)
	end
end
function heroSecretView:hideLuckyFullEffect()
	self.Node_etLucky:setVisible(false)
end
function heroSecretView:initTimer()
	self.leftTime = SoraDChangeTextToHtml(self.leftTime)
	self.leftTime = SoraDCreateTimerLabel(self, self.leftTime)
	self.leftTime:setTimeLast(function(ticket)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, ticket
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_766", nil, nil)
	end)
	self.leftTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.HERO_SECRET_ACTIVITY)
	if activityTime then
		self.leftTime:beginTime(activityTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 5, not SoraDFIsRA())
end
function heroSecretView:initData()
	self:fitTimePos()
	for i = 1, 12 do
		local single = self.itemTbl[i]
		if not single then
			single = self.singleItem:clone()
			single:setVisible(true)
			single:addTo(self.singleItem:getParent())
			single:setPosition(-316, 150 + self.height + self.ipadY)
			single:setLocalZOrder(frameTbl[i])
			single = SoraDCreatAnimationEx("heroSecretItemEffect", single, false)
			self.itemTbl[i] = single
		end
		self:initSingle(i)
	end
	self:initProgressBar()
	self:setLuckyValue()
	local frameTbl, strParam = self.setLuckyValue, self.setLuckyValue
	for i, v in ipairs(self.boxData) do
		strParam[string.format("cost%d", i)] = v.lotteryTime
	end
	self.textTips:setString(i18n("HeroVault_text_01", strParam) .. i18n("HeroVault_text_02"))
end
function heroSecretView:initProgressBar(...)
	local cur = heroSecretCtrl:getNowRound() - 1
	self.stageReward = heroSecretCtrl:getStageReward()
	self.boxData = heroSecretltCtrl.getExtraConfig()
	local totalWidth = self.lBarProgress:getContentSize().width
	local lastPos = SoraDFPosX(-totalWidth / 2, 0)
	local beginPos = SoraDFPosX(totalWidth / 2 - 70, 0)
	local posXOffset = (lastPos - beginPos) / (#self.boxData - 1)
	local belongNum = 0
	for i, v in ipairs(self.boxData) do
		if cur >= v.lotteryTime then
			belongNum = i
		end
	end
	if 0 <= belongNum then
		local baseDis = (70 + math.abs(posXOffset) * (belongNum - 1)) * 100 / totalWidth
		if belongNum == 0 then
			baseDis = 0
		end
		local preTaskNum = self.boxData[belongNum] and self.boxData[belongNum].lotteryTime or 0
		local afterTaskNum = self.boxData[belongNum + 1] and self.boxData[belongNum + 1].lotteryTime or self.boxData[#self.boxData].lotteryTime + 1
		local curDis = 100 * (cur - preTaskNum) / (afterTaskNum - preTaskNum) * (belongNum == 0 and 70 or math.abs(posXOffset)) / totalWidth
		print("curDis", cur, preTaskNum, afterTaskNum, curDis, baseDis)
		local totalDis = baseDis + curDis
		self.lBarProgress:setPercent(totalDis)
	else
		self.lBarProgress:setPercent(0)
	end
	if not self.ocxBoxs then
		self.ocxBoxs, heroSecretCtrl = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single
			if i == 1 then
				single = self.btnBox
			else
				single = self.btnBox:clone()
				single:addTo(self.nodeProgress)
			end
			single:getChildByName("Sprite_box"):setSpriteFrame("icon_yxmz_closebox.png")
			single:getChildByName("Text_price"):setString(string.formatnumberthousands(v.lotteryTime))
			SoraDGetChildByName(single, "Sprite_xwjyd"):setVisible(false)
			SoraDGetChildByName(single, "Sprite_daojuwk"):setVisible(false)
			single:setTag(v.lotteryTime)
			single:setPosition(beginPos + posXOffset * (i - 1), 25)
			single:addTouchEventListener(handler(self, self.btnBoxClick))
			table.insert(self.ocxBoxs, single)
		end
	end
	self:refreshBoxState()
end
function heroSecretView:refreshBoxState(...)
	local cur = heroSecretCtrl:getNowRound() - 1
	for i, v in ipairs(self.boxData) do
		if cur >= v.lotteryTime then
			if self.stageReward[tostring(v.lotteryTime)] then
				self:showRoundEffect(self.ocxBoxs[i], 3)
			else
				self:showRoundEffect(self.ocxBoxs[i], 1)
			end
		else
			self:showRoundEffect(self.ocxBoxs[i], 2)
		end
	end
end
function heroSecretView:showRoundEffect(target, state)
	if state == 3 then
		local spBox = target:getChildByName("Sprite_box")
		spBox:setRotation(0)
		spBox:stopAllActions()
		SoraDGetChildByName(target, "Sprite_xwjyd"):setVisible(false)
		SoraDGetChildByName(target, "Sprite_daojuwk"):setVisible(false)
		target:getChildByName("Sprite_box"):setSpriteFrame("icon_yxmz_openbox.png")
	elseif state == 2 then
	else
		local spXw = SoraDGetChildByName(target, "Sprite_xwjyd")
		spXw:stopAllActions()
		spXw:setRotation(0)
		spXw:setVisible(true)
		_ENV = nil
		;(nil)[1] = cca.rotateBy(2.25, 360)
		;(nil)[2] = cca.rotateBy(2.25, 360)
		;(nil)[3] = cca.rotateBy(2.25, 360)
		;(nil)[4] = cca.rotateBy(2.25, 360)
		;(nil)[5] = cca.rotateBy(2.25, 360)
		;(nil)[6] = cca.rotateBy(2.25, 360)
		;(nil)[7] = cca.rotateBy(2.25, 360)
		spXw:runAction(cca.repeatForever(cca.seq(nil)))
		local spDa = SoraDGetChildByName(target, "Sprite_daojuwk")
		spDa:stopAllActions()
		spDa:setOpacity(53.55)
		spDa:setVisible(true)
		_UPVALUE1_ = cca.repeatForever(cca.seq(nil))
		cca.repeatForever(cca.seq(nil))[1] = cca.fadeTo(1.125, 0.42)
		cca.repeatForever(cca.seq(nil))[2] = cca.fadeTo(1.125, 0.21)
		cca.repeatForever(cca.seq(nil))[3] = cca.fadeTo(1.125, 0.21)
		cca.repeatForever(cca.seq(nil))[4] = cca.fadeTo(1.125, 0.21)
		cca.repeatForever(cca.seq(nil))[5] = cca.fadeTo(1.125, 0.21)
		cca.repeatForever(cca.seq(nil))[6] = cca.fadeTo(1.125, 0.21)
		spDa:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
		local spBox = target:getChildByName("Sprite_box")
		spBox:stopAllActions()
		spBox:setRotation(0)
		_UPVALUE6_ = spBox
		spBox[1] = cca.rotateTo(0.25, 12)
		spBox[2] = cca.rotateTo(0.2, -8)
		spBox[3] = cca.rotateTo(0.2, 6)
		spBox[4] = cca.rotateTo(0.15, -3)
		spBox[5] = cca.rotateTo(0.15, 1)
		spBox[6] = cca.rotateTo(0.15, 0)
		spBox[7] = cca.delay(0.6)
		spBox[8] = cca.delay(0.6)
		local seq = cca.seq(spBox)
		spBox:runAction(cc.RepeatForever:create(seq))
	end
end
function heroSecretView:fitTimePos()
	if self.allLock then
		self.btnExtract:setVisible(false)
		self.textEnd:setString(i18n("HeroVault_text_05"))
	end
	self.needCost = heroSecretltCtrl.getCostByRound(heroSecretCtrl:getNowRound())
	self.textInfo:setString(string.formatnumberthousands(self.needCost) .. "\n" .. i18n("common_text_246_ros"))
	self.textNum:setString(string.formatnumberthousands(self.itemNum))
	SoraDToCenter(SoraDGetChildByName(self, "Node_Auto_Center"), 0, not SoraDFIsRA())
end
function heroSecretView:initSingle(index)
	local item = heroSecretltCtrl.getAwardByIndex(heroSecretCtrl:getGroup(), index)
	if not next(item) then
		return
	end
	local single = self.itemTbl[index]
	local dh_14new1_02 = SoraDGetChildByName(single, "dh_14new1_02_1")
	SoraDMixtureGLONE(dh_14new1_02)
	local isRare = heroSecretltCtrl.getIsRare(heroSecretCtrl:getGroup(), index)
	dh_14new1_02:setVisible(isRare == 1)
	single.dh_14new1_02 = dh_14new1_02
	self:borderRotEffect(dh_14new1_02, isRare == 1)
	btnItem = include("commonBtnInstance").new(SoraDGetChildByName(single, "Button_Item"))
	btnItem:setItemInfo(self, item[1], item[2])
	btnItem:setTouchShowTips(true)
	local icon = SoraDGetChildByName(single, "Image_icon")
	icon:loadTexture(itemDesRead.getIcon(item[1]), ccui.TextureResType.plistType)
	single.nowFrame = (index - 1) * 10
	single.action:gotoFrameAndPause((index - 1) * 10)
	if heroSecretCtrl:itemIsLock(heroSecretltCtrl.getPositionByIndex(index)) then
		SoraDGetChildByName(single, "icon_g"):setVisible(true)
		icon:setColor(cc.c3b(120, 120, 120))
	end
	local labNum = SoraDGetChildByName(single, "Text_LabNum")
	local spriteNumBg = SoraDGetChildByName(single, "frame_sheer_black")
	if labNum then
		local num = itemDesRead.getNumByID(item[1])
		if num then
			spriteNumBg:setVisible(true)
			labNum:setVisible(true)
			labNum:setString(num)
		else
			spriteNumBg:setVisible(false)
			labNum:setVisible(false)
		end
	end
end
function heroSecretView:fitView()
	if SoraDFIsRA() then
		local icon = SoraDGetChildByName(self.btnExtract, "Image_Icon")
		local posX = self.textInfo:getPositionX()
		self.textInfo:setPositionX(icon:getPositionX())
		icon:setPositionX(posX)
	end
	local textTipPosOffset = 175
	if display.height < 1100 then
		if display.height < 950 then
			self.textTips:setPositionY(display.height + 50)
			self.height = -60
			self.ipadY = -15
			self.imageMiddle:setPositionY(self.imageMiddle:getPositionY() - 20)
			self.imageDown:setPositionY(self.imageDown:getPositionY() - 20)
			self.nodeEffectG:setPositionY(self.nodeEffectG:getPositionY() - 60)
			self.nodeEffect:setPositionY(self.nodeEffect:getPositionY() - 20)
			self.nodeEffectO:setPositionY(self.nodeEffectO:getPositionY() - 20)
			self.nodeEffectO2:setPositionY(self.nodeEffectO2:getPositionY() - 20)
			self.nodeEffectBg:setPositionY(self.nodeEffectBg:getPositionY() - 40)
			self.nodeProgress:setPositionY(self.nodeProgress:getPositionY() - 15)
			textTipPosOffset = 160
		end
		self.scale = 0.85
		self.nodeScale:setScale(self.scale)
		self.nodeDown:setScale(self.scale)
		self.nodeEffectBg:setPositionY(self.nodeEffectBg:getPositionY() - 140 + self.height)
	end
	self:initEffect()
	self.imageMiddle:setPositionY(self.imageMiddle:getPositionY() + self.height + self.ipadY)
	self.imageDown:setPositionY(self.imageDown:getPositionY() + self.height + self.ipadY)
	self.nodeDown:setPositionY(self.nodeDown:getPositionY() + self.height)
	self.nodeEffectG:setPositionY(self.nodeEffectG:getPositionY() + self.height + self.ipadY)
	self.textClick:setPositionY(self.nodeEffectG:getPositionY() * self.scale - textTipPosOffset)
	self.nodeEffect:setPositionY(self.nodeEffect:getPositionY() + self.height + self.ipadY)
	self.nodeEffectO:setPositionY(self.nodeEffectO:getPositionY() + self.height + self.ipadY)
	self.nodeEffectO2:setPositionY(self.nodeEffectO2:getPositionY() + self.height + self.ipadY)
	self.nodeDown:setLocalZOrder(29)
	self.nodeTitle:setLocalZOrder(40)
	self.panelLayer:setLocalZOrder(30)
	self.nodeEffect:setLocalZOrder(17)
	self.nodeEffectO:setLocalZOrder(18)
	self.nodeEffectO2:setLocalZOrder(16)
	self.nodeEffectG:setLocalZOrder(-5)
	self.imageDown:setLocalZOrder(-10)
	self.nodeEffectBg:setLocalZOrder(-20)
	self.imageMiddle:setLocalZOrder(-20)
	self.awardItem:setLocalZOrder(16)
end
function heroSecretView:btnLuckyClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("heroSecretLuckyView"):show()
	end
end
function heroSecretView:btnBoxClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local isNotGet = self.stageReward[tostring(tag)]
		if tag <= heroSecretCtrl:getNowRound() - 1 and not isNotGet then
			heroSecretCtrl:sendGetStageMsg(tag)
		else
			local panel = SoraDCreatePanel("heroStageRewardView")
			panel:initData(tag)
			panel:show()
		end
	end
end
function heroSecretView:btnClickQuestion(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _ENV, costTbl = SoraDPlaySound, SoraDPlaySound
		local num = heroSecretltCtrl.getLockNum()
		for i = 1, num do
			costTbl["cost" .. i] = heroSecretltCtrl.getCost(i)
		end
		for i, v in ipairs(self.boxData) do
			costTbl[string.format("lotteryTime%d", i)] = v.lotteryTime
		end
		SoraDShowHelpMsgTip(i18n("HeroVault_text_04", costTbl))
	end
end
function heroSecretView:btnClickExtract(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local nowRound = heroSecretCtrl:getNowRound()
		local needCost = heroSecretltCtrl.getCostByRound(nowRound)
		if self.needCost > self.itemNum then
			SoraDShowMsgBox(i18n("HeroVault_text_06"), i18n("common_text_054"), i18n("common_text_185"), handler(self, self.jumpToGift))
			return
		end
		self:showEffect()
	end
end
function heroSecretView:btnClickShowAward(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("heroAwardView"):show()
	end
end
function heroSecretView:btnClickOpenBag(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:jumpToGift(MSGBOX_CALLBACK_YES)
	end
end
function heroSecretView:btnClickTurn(button, eventType)
	if eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local turnLeft = touchBeganPoint.x > touchmovePoint.x
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > 30 and not self.isMove then
			self.isMove = true
			self:goToTurn(turnLeft)
		end
	end
end
function heroSecretView:btnClickPanel(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:textEffect(self.textClick)
		self.panelLayer:setVisible(false)
		self.nodeEffectG.action:gotoFrameAndPlay(103, 113, false)
	end
end
function heroSecretView:jumpToGift(type)
	if type == MSGBOX_CALLBACK_YES then
		local giftData = self:getGiftInfo()
		if giftData then
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).rechargeID = tonumber(giftData.ID)
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
				panel:show()
			end
		else
			SoraDShowMsgTip(i18n("HeroVault_text_03"))
		end
	end
end
function heroSecretView:getGiftInfo()
	local idTbl = IsArClient and giftID.kohGift or giftID.rosGift
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i = 3, 1, -1 do
		local item = giftInfo[tostring(idTbl[i])]
		if item and 1 <= tonumber(item.extraData) then
			return item
		end
	end
end
function heroSecretView:showEffect()
	if not self.nodeEffect then
		self:initEffect()
	end
	local action = self.nodeEffect.action
	if action and tolua.cast(action, "cc.Action") and not self.effectLock then
		self.effectLock = true
		action:gotoFrameAndPlay(451, 611, false)
	end
end
function heroSecretView:updataInfo(target, data)
	self.itemNum = backpackCtrl:getItemCount(816501) or 0
	self.allLock = not heroSecretCtrl:isCanExtract()
	self:updateData(data.subMsg == "extract")
	if data.subMsg == "stageReward" then
		if data.reward then
			SoraDMailGainItems(data.reward, true)
		end
	elseif data.subMsg == "extract" and data.reward then
		self:creatAwardItem(data.reward[1].id)
	end
end
function heroSecretView:updateData(isDrawBack)
	self:fitTimePos()
	for i = 1, 12 do
		local single = self.itemTbl[i]
		if single and heroSecretCtrl:itemIsLock(heroSecretltCtrl.getPositionByIndex(i)) then
			SoraDGetChildByName(single, "icon_g"):setVisible(true)
			local icon = SoraDGetChildByName(single, "Image_icon")
			icon:setColor(cc.c3b(120, 120, 120))
		end
	end
	self:initProgressBar()
	if isDrawBack then
		self:showLuckyFlyEffect()
	else
		self:setLuckyValue()
	end
end
function heroSecretView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_SECRET_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function heroSecretView:initEffect()
	self.nodeEffectO = SoraDCreatAnimationEx("heroSecretEffectO", self.nodeEffectO, true, nil, 0, 235)
	SoraDMixtureGLONEByParent(self.nodeEffectO)
	self.nodeEffectO2 = SoraDCreatAnimationEx("heroSecretEffectO2", self.nodeEffectO2, true, nil, 0, 235)
	SoraDMixtureGLONEByParent(self.nodeEffectO2)
	local actionO2 = self.nodeEffectO2.action
	if actionO2 and tolua.cast(actionO2, "cc.Action") then
		actionO2:setFrameEventCallFunc(handler(self, self.particleCallBack))
	end
	local cssFilePath = getCCSPath("heroSecretEffectG")
	local actionG = cc.CSLoader:createTimeline(cssFilePath)
	self.nodeEffectG.action = actionG
	self.nodeEffectG:runAction(actionG)
	SoraDMixtureGLONEByParent(SoraDGetChildByName(self.nodeEffectG, "Node_1"))
	if actionG and tolua.cast(actionG, "cc.Action") then
		actionG:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			print("frameEvent==========", frameEvent)
			if frameEvent and frameEvent == "DownEnded" then
				SoraDGetChildByName(self.nodeEffect, "Sprite_8"):setOpacity(0)
				self.nodeEffect.action:gotoFrameAndPlay(0, 77, false)
				self.nodeEffectO.action:gotoFrameAndPlay(0, 235, true)
				self.nodeEffectO2.action:gotoFrameAndPlay(0, 235, true)
				self.effectLock = false
			elseif frameEvent and frameEvent == "SHOWTEXT" then
				self.textClick:setString(i18n("summoned_text_03"))
				self:textEffect(self.textClick, true)
				self.panelLayer:setVisible(true)
			end
		end)
	end
	self.nodeEffect = SoraDCreatAnimationEx("heroSecretEffect", self.nodeEffect, true, nil, 78, 452)
	local action = self.nodeEffect.action
	if action and tolua.cast(action, "cc.Action") then
		action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			print("frameEvent==========", frameEvent)
			if frameEvent and frameEvent == "ended" then
				heroSecretCtrl:sendExtractMsg()
				self.nodeEffect:setLocalZOrder(-15)
			elseif frameEvent and frameEvent == "chuxianEnd" then
				action:gotoFrameAndPlay(78, 452, true)
			elseif frameEvent and frameEvent == "guanEnd" then
				self.nodeEffectO.action:gotoFrameAndPlay(235, 269, false)
				self.nodeEffectO2.action:gotoFrameAndPlay(424, 455, false)
			elseif frameEvent and frameEvent == "changeZ" then
				self.nodeEffectO.action:gotoFrameAndPlay(0, 235, true)
				self.nodeEffectO2.action:gotoFrameAndPlay(0, 235, true)
				self.nodeEffect:setLocalZOrder(17)
			end
		end)
	end
	SoraDMixtureGLONE(SoraDGetChildByName(self.nodeEffectBg, "Sprite_1"))
	SoraDMixtureGLONEByParent(SoraDGetChildByName(self.nodeEffectBg, "back1"))
	self:borderRotEffectBG()
end
function heroSecretView:particleCallBack(frameEventName)
	local frameEvent = frameEventName:getEvent()
	if frameEvent and frameEvent == "effectEnd" then
		for i = 1, 4 do
			local particle = SoraDGetChildByName(self.nodeEffectO2, "G_Particle_" .. i)
			if particle then
				particle:stopSystem()
			end
		end
	end
	if frameEvent and frameEvent == "effectBegin" then
		for i = 1, 4 do
			local particle = SoraDGetChildByName(self.nodeEffectO2, "G_Particle_" .. i)
			if particle then
				particle:resetSystem()
			end
		end
	end
end
function heroSecretView:creatAwardItem(itemId)
	local icon = SoraDGetChildByName(self.nodeEffectG, "Image_icon")
	icon:loadTexture(itemDesRead.getIcon(itemId), ccui.TextureResType.plistType)
	local textName = SoraDGetChildByName(self.nodeEffectG, "Text_Name")
	textName:setString(i18n(itemDesRead.getName(itemId)))
	self.nodeEffectG.action:gotoFrameAndPlay(0, 93, false)
end
function heroSecretView:borderRotEffect(target, ret)
	target:stopAllActions()
	target:setRotation(0)
	if ret then
		target:runAction(cc.RepeatForever:create(cca.rotateBy(1.4166666666666667, 360)))
	end
end
function heroSecretView:textEffect(target, ret)
	target:stopAllActions()
	target:setRotation(0)
	if ret then
		target:setOpacity(255)
		_UPVALUE1_ = target
		target[1] = cca.fadeIn(0.8)
		target[2] = cca.fadeOut(0.8)
		target[3] = cca.fadeOut(0.8)
		target[4] = cca.fadeOut(0.8)
		local seq = cca.seq(target)
		target:runAction(cc.RepeatForever:create(seq))
	end
end
function heroSecretView:goToTurn(direct)
	for i, v in ipairs(self.itemTbl) do
		local frame = direct and 280 - v.nowFrame or v.nowFrame
		if frame == 280 then
			frame = 160
		end
		v.action:gotoFrameAndPlay(frame, 10 + frame, false)
		local index = v.nowFrame / 10 + 1
		index = direct and index - 1 or index + 1
		if index == 13 then
			index = 1
		end
		if index == 0 then
			index = 12
		end
		v.nowFrame = direct and v.nowFrame - 10 or v.nowFrame + 10
		if v.nowFrame == -10 then
			v.nowFrame = 110
		end
		if v.nowFrame > 110 then
			v.nowFrame = 0
		end
		v:setLocalZOrder(frameTbl[index])
	end
	frameTbl = ipairs(self.itemTbl)
	ipairs(self.itemTbl)[1] = cca.delay(0.15)
	ipairs(self.itemTbl)[2] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[3] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[4] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[5] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[6] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[7] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[8] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[9] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	local seq = cca.seq(ipairs(self.itemTbl))
	self:runAction(seq)
end
function heroSecretView:borderRotEffectBG()
	_UPVALUE7_ = nil
	;(nil)[1] = 55
	;(nil)[2] = 55
	;(nil)[3] = 70
	;(nil)[4] = 70
	;(nil)[5] = 80
	;(nil)[6] = 80
	local (nil)[7], timeTbl = 100, nil
	for i = 1, 7 do
		local target = SoraDGetChildByName(self.nodeEffectBg, "0" .. i)
		target:setRotation(0)
		target:runAction(cc.RepeatForever:create(cca.rotateBy(timeTbl[i], 360)))
	end
	local target = SoraDGetChildByName(self.nodeEffectBg, "Sprite_1")
	target:setRotation(0)
	target:runAction(cc.RepeatForever:create(cca.rotateBy(10, -360)))
	local etTmp = SoraDGetChildByName(self.nodeEffectBg, "G_et_dixintanxian_02_47")
	etTmp:setOpacity(35.7)
	_UPVALUE1_ = cc.RepeatForever:create(cca.rotateBy(10, -360))
	cc.RepeatForever:create(cca.rotateBy(10, -360))[1] = cca.fadeTo(1, 0.05)
	cc.RepeatForever:create(cca.rotateBy(10, -360))[2] = cca.fadeTo(1, 0.14)
	cc.RepeatForever:create(cca.rotateBy(10, -360))[3] = cca.fadeTo(1, 0.14)
	cc.RepeatForever:create(cca.rotateBy(10, -360))[4] = cca.fadeTo(1, 0.14)
	etTmp:runAction(cc.RepeatForever:create(cca.seq(cc.RepeatForever:create(cca.rotateBy(10, -360)))))
end
return heroSecretView
