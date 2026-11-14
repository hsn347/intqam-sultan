local gametop = gModuleMgr.getObject("gametop")
local luckyTreasureCtrl = gametop.playertop_:getModule("luckyTreasureCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
_ENV, _ENV = nil, "publicRead"
;(nil).x = -151
_ENV, ("publicRead")[1], (nil).y = nil, nil, 148
;(nil).x = -50
_ENV, ("publicRead")[2], (nil).y = nil, nil, 185
;(nil).x = 50
_ENV, ("publicRead")[3], (nil).y = nil, nil, 185
;(nil).x = 151
_ENV, ("publicRead")[4], (nil).y = nil, nil, 148
;(nil).x = 194
_ENV, ("publicRead")[5], (nil).y = nil, nil, 49
;(nil).x = 194
_ENV, ("publicRead")[6], (nil).y = nil, nil, -49
;(nil).x = 151
_ENV, ("publicRead")[7], (nil).y = nil, nil, -148
;(nil).x = 50
_ENV, ("publicRead")[8], (nil).y = nil, nil, -185
;(nil).x = -50
_ENV, ("publicRead")[9], (nil).y = nil, nil, -185
;(nil).x = -151
_ENV, ("publicRead")[10], (nil).y = nil, nil, -148
;(nil).x = -194
_ENV, ("publicRead")[11], (nil).y = nil, nil, -49
;(nil).x = -194
_ENV, ("publicRead")[12], (nil).y = nil, nil, 49
local rewardListPos = "publicRead"
;(nil).single = 0.7
local _ENV, (nil).ten, speedTab = nil, 2, nil
;(nil).single = 4
local (nil).ten, circleNum = 2, nil
local luckyTreasureView = class("luckyTreasureView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("luckyTreasureView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function luckyTreasureView:ctor()
	self.btn_buy_once = SoraDGetChildByName(self, "Button_buy_once")
	self.btn_buy_ten = SoraDGetChildByName(self, "Button_buy_ten")
	self.btn_free = SoraDGetChildByName(self, "Button_free")
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.text_time = SoraDGetChildByName(self, "Text_timer")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_time_alter = SoraDGetChildByName(self, "Text_timer_alter")
	self.text_lucky_percent = SoraDGetChildByName(self, "Text_percent")
	self.text_mutiple_tips = SoraDGetChildByName(self, "Text_tip")
	self.text_one_cost = SoraDGetChildByName(self.btn_buy_once, "Text_costNum")
	self.text_ten_cost = SoraDGetChildByName(self.btn_buy_ten, "Text_costNum")
	self.progress_lucky = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_lucky")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_lucky")
	self.panel_touch = SoraDGetChildByName(self, "Panel_1")
	self.panel_touch_2 = SoraDGetChildByName(self, "Panel_2")
	self.panel_touch:setTouchEnabled(false)
	self.panel_touch:addTouchEventListener(handler(self, self.onClickPanel))
	self.panel_touch_2:setTouchEnabled(false)
	self.panel_touch_2:addTouchEventListener(handler(self, self.onClickPanel))
	self.node_progress_sprite = SoraDGetChildByName(self.progress_lucky, "Node_sprite")
	self.node_gold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	self.node_items = SoraDGetChildByName(self, "Node_items")
	self.node_select = SoraDGetChildByName(self, "Node_select")
	self.node_btn = SoraDGetChildByName(self, "Node_button")
	self.node_front_particle = SoraDGetChildByName(self, "Node_front_particle")
	self.node_behind_particle = SoraDGetChildByName(self, "Node_behind_particle")
	self.node_curtain = SoraDGetChildByName(self, "Node_curtain")
	self.node_bottom = SoraDGetChildByName(self, "Bottom_Node")
	self.node_fire = SoraDGetChildByName(self, "Node_fire")
	self.node_center = SoraDGetChildByName(self, "Center_Node")
	self.img_circle = SoraDGetChildByName(self, "Image_50")
	self.img_select_frame = SoraDGetChildByName(self.node_select, "Image_select")
	self.img_select_frame:setVisible(false)
	self.singleArray, _ENV = self.img_select_frame.setVisible, self.img_select_frame.setVisible
	self.haveData = 0
	self.finalIndex = 0
	self.beforeIdx = 1
	self.btn_free:setTitleText(i18n("common_text_049"))
	self.text_time_alter:setString(i18n("Lucky_treasure_text_09"))
	self.btn_buy_once:addTouchEventListener(handler(self, self.onClickBtnOne))
	self.btn_buy_ten:addTouchEventListener(handler(self, self.onClickBtnTen))
	self.btn_free:addTouchEventListener(handler(self, self.onClickFree))
	self.btn_help:addTouchEventListener(handler(self, self.onClickBtnHelp))
	self.node_gold:setPositionY(self.node_gold:getPositionY() + 3)
	self.btn_free:setSwallowTouches(true)
	self.btn_buy_once:setSwallowTouches(true)
	self:fitDevice()
	self:admissionAnimation()
	self:initView()
end
function luckyTreasureView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_TURNTABLE_GET_REWARD_INFO", handler(self, self.getRewardDataCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.TURNTABLE_ACTIVITY) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function luckyTreasureView:fitDevice()
	local dis = display.height - 960
	local cSize = self.panel_touch_2:getContentSize()
	if dis < 0 then
		self.node_items:setScale(0.9)
		self.img_circle:setScale(0.9)
		self.node_select:setScale(0.9)
		self.img_circle:setPositionY(self.img_circle:getPositionY() + 30)
		self.node_select:setPositionY(self.node_select:getPositionY() + 30)
		self.node_items:setPositionY(self.node_items:getPositionY() + 30)
		self.node_btn:setPositionY(self.node_btn:getPositionY() + 30)
		self.text_mutiple_tips:setPositionY(self.text_mutiple_tips:getPositionY() + 55)
		self.panel_touch_2:setContentSize(cc.size(cSize.width, cSize.height - 50))
	elseif 0 < dis then
		self.panel_touch_2:setContentSize(cc.size(cSize.width, cSize.height + 50))
	end
end
function luckyTreasureView:admissionAnimation()
	local actTime = 0.5
	local nAnimatBottom = SoraDGetChildByName(self.node_bottom, "Node_animation")
	local nBg = SoraDGetChildByName(self, "Node_bg")
	nBg:setScale(1.1)
	nBg:runAction(cc.EaseSineOut:create(cca.scaleTo(actTime, 1)))
	self.node_center:setScale(1.2)
	self.node_center:runAction(cc.EaseSineOut:create(cca.scaleTo(actTime, 1)))
	nAnimatBottom:setPositionY(60)
	nAnimatBottom:setScale(0.9)
	_UPVALUE1_ = nAnimatBottom
	nAnimatBottom[1] = cc.EaseSineOut:create(cca.scaleTo(actTime, 1))
	nAnimatBottom[2] = cc.EaseSineOut:create(cca.moveTo(actTime, nAnimatBottom:getPositionX(), 0))
	nAnimatBottom[3] = cc.EaseSineOut:create(cca.moveTo(actTime, nAnimatBottom:getPositionX(), 0))
	nAnimatBottom[4] = cc.EaseSineOut:create(cca.moveTo(actTime, nAnimatBottom:getPositionX(), 0))
	nAnimatBottom[5] = cc.EaseSineOut:create(cca.moveTo(actTime, nAnimatBottom:getPositionX(), 0))
	nAnimatBottom[6] = cc.EaseSineOut:create(cca.moveTo(actTime, nAnimatBottom:getPositionX(), 0))
	nAnimatBottom[7] = cc.EaseSineOut:create(cca.moveTo(actTime, nAnimatBottom:getPositionX(), 0))
	local action = cca.spawn(nAnimatBottom)
	nAnimatBottom:runAction(action)
	self.node_fire:setScale(1.2)
	self.node_fire:runAction(cc.EaseSineOut:create(cca.scaleTo(actTime, 1)))
	self.node_curtain:setScale(1.3)
	self.node_curtain:runAction(cc.EaseSineOut:create(cca.scaleTo(actTime, 1)))
end
function luckyTreasureView:initView()
	local bannerName, titleStr = luckyTreasureCtrl:getCurrentTurnBanner()
	if bannerName then
		self.ccs_title:setTitle(i18n(titleStr))
	else
		self.ccs_title:setTitle(i18n("Lucky_treasure_title_01"))
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.TURNTABLE_ACTIVITY)
	if eventTime then
		self.text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.costItem = luckyTreasureCtrl:getCurrentCostItem()
	luckyTreasureCtrl = eventTime.timerNode.timer:getRemainTime()
	eventTime.timerNode.timer:getRemainTime().count = 1
	self.btn_buy_once:getChildByName("Text_alter"):setString(i18n("Lucky_treasure_text_06", eventTime.timerNode.timer:getRemainTime()))
	luckyTreasureCtrl = i18n("Lucky_treasure_text_06", eventTime.timerNode.timer:getRemainTime())
	i18n("Lucky_treasure_text_06", eventTime.timerNode.timer:getRemainTime()).count = 10
	self.btn_buy_ten:getChildByName("Text_alter"):setString(i18n("Lucky_treasure_text_06", i18n("Lucky_treasure_text_06", eventTime.timerNode.timer:getRemainTime())))
	self.btn_buy_once:getChildByName("Image_icon"):loadTexture(publicRead.getSmallIcon(self.costItem.oneCost.id), ccui.TextureResType.plistType)
	self.btn_buy_ten:getChildByName("Image_icon"):loadTexture(publicRead.getSmallIcon(self.costItem.tenCost.id), ccui.TextureResType.plistType)
	self.text_one_cost:setString(self.costItem.oneCost.count)
	self.text_ten_cost:setString(self.costItem.tenCost.count)
	self:initRewards()
	self:reflashView()
end
function luckyTreasureView:initRewards()
	self.rewardList = luckyTreasureCtrl:getCurrentRewardItemList()
	self.importantItem = luckyTreasureCtrl:getImportantRewardByIndex()
	for i = 1, #self.rewardList do
		local single = include("commonItemAward").new()
		single:setName(tostring(self.rewardList[i].id))
		single:setOwnView(self)
		single:initData(self.rewardList[i].id, self.rewardList[i].count)
		single:setPosition(cc.p(rewardListPos[i].x, rewardListPos[i].y))
		single:addTo(self.node_items)
		local etShine = cc.ParticleSystemQuad:create("Particle/et_ziyuanpz_07.plist")
		etShine:addTo(single, 2)
		etShine:setPosition(0, -20)
		etShine:setScale(1.6)
		single.etShine = etShine
		local imgSelect = display.newSprite()
		imgSelect:setSpriteFrame("dh_zengsong_button_03.png")
		SoraDMixtureGLONE(imgSelect)
		imgSelect:addTo(single, 3)
		imgSelect:setVisible(false)
		imgSelect:setScale(1.0)
		single.imgSelect = imgSelect
		single:setScale(0.9)
		single:setBaseScale(1.0)
		if i == self.importantItem then
			single:showCoolSquare()
		end
		table.insert(self.singleArray, single)
	end
end
function luckyTreasureView:reflashView()
	if not self:chectIsCostItemEnough(self.costItem.oneCost) then
		self.text_one_cost:setColor(display.COLOR_RED)
	else
		self.text_one_cost:setColor(cc.c3b(255, 255, 0))
	end
	if not self:chectIsCostItemEnough(self.costItem.tenCost) then
		self.text_ten_cost:setColor(display.COLOR_RED)
	else
		self.text_ten_cost:setColor(cc.c3b(255, 255, 0))
	end
	local curProgress = luckyTreasureCtrl:getImportanCurLuckValue()
	_ENV = cc.c3b(255, 255, 0)
	cc.c3b(255, 255, 0).cur = curProgress
	cc.c3b(255, 255, 0).total = LUCKY_TREASURE
	self.text_lucky_percent:setString(i18n("Lucky_treasure_text_04", cc.c3b(255, 255, 0)))
	local nodeSprite = SoraDGetChildByName(self.progress_lucky, "Node_sprite")
	nodeSprite:setVisible(curProgress == LUCKY_TREASURE - 1)
	local spriteShine = SoraDGetChildByName(self.progress_lucky, "Sprite_shine")
	spriteShine:setVisible(curProgress == LUCKY_TREASURE - 1)
	local progressSize = SoraDGetChildByName(self.progress_lucky, "LoadingBar_progress"):getContentSize()
	if curProgress == LUCKY_TREASURE - 1 then
		curProgress = LUCKY_TREASURE
	end
	local posX = progressSize.width - progressSize.width * (curProgress / LUCKY_TREASURE) + 7
	if not SoraDFIsRA() then
		posX = progressSize.width * (curProgress / LUCKY_TREASURE) + 8
	end
	_ENV = i18n("Lucky_treasure_text_04", cc.c3b(255, 255, 0))
	i18n("Lucky_treasure_text_04", cc.c3b(255, 255, 0)).maxValue = LUCKY_TREASURE
	i18n("Lucky_treasure_text_04", cc.c3b(255, 255, 0)).curValue = curProgress
	self.progress_lucky:setProgressDate(i18n("Lucky_treasure_text_04", cc.c3b(255, 255, 0)))
	if curProgress == LUCKY_TREASURE then
		SoraDMixtureGLONE(spriteShine)
		nodeSprite:setPositionX(posX)
		self.text_lucky_percent:setString(i18n("Lucky_treasure_text_08"))
	end
	local progressLine = SoraDGetChildByName(self.progress_lucky, "Node_line")
	progressLine:setPositionX(posX)
	progressLine:setVisible(0 < curProgress and curProgress ~= LUCKY_TREASURE)
	local isFree = luckyTreasureCtrl:getIsFreeFlag()
	if isFree then
		self.btn_free:setVisible(true)
		self.btn_buy_once:setVisible(false)
	else
		self.btn_free:setVisible(false)
		self.btn_buy_once:setVisible(true)
	end
	local curLuckyValue = luckyTreasureCtrl:getCurRate()
	print("现在的rete", curLuckyValue)
	_ENV = i18n("Lucky_treasure_text_08")
	i18n("Lucky_treasure_text_08").num = curLuckyValue
	self.text_mutiple_tips:setString(i18n("Lucky_treasure_text_07", i18n("Lucky_treasure_text_08")))
	self.text_mutiple_tips:setVisible(2 <= curLuckyValue)
	SoraDSetTextWidthHeight(self.text_mutiple_tips, cc.size(500, 30))
	for i = 1, #self.rewardList do
		self.singleArray[i].etShine:stopSystem()
	end
	for k, v in ipairs(self.singleArray) do
		v.imgSelect:setOpacity(255)
		v.imgSelect:setVisible(false)
	end
end
function luckyTreasureView:createSingleAnimation(single)
	SoraDPlaySound("pyramid", 6)
	if not single.animation then
		local singleAnt = SoraDCreatAnimationEx("luckyTreasureChoose", nil, false)
		singleAnt:addTo(single, 1)
		single.pFront1 = singleAnt:getChildByName("Particle_shine_1")
		single.pFront2 = singleAnt:getChildByName("Particle_shine_2")
		single.pBehind = singleAnt:getChildByName("Particle_shine_behind")
		single.pFront2:setScale(1.7)
		single.pBehind:setScale(1.3)
		self.node_behind_particle:setGroupID(502, true)
		self.node_front_particle:setGroupID(501, true)
		single.pFront1:setGroupID(501)
		single.pFront2:setGroupID(501)
		single.pBehind:setGroupID(502)
	else
		single.pFront1:stopSystem()
		single.pFront2:stopSystem()
		single.pBehind:stopSystem()
		single.pFront1:resetSystem()
		single.pFront2:resetSystem()
		single.pBehind:resetSystem()
	end
end
function luckyTreasureView:onceAction(single, select)
	self:createSingleAnimation(self.singleArray[self.finalIndex])
	_UPVALUE1_ = self.finalIndex
	self.finalIndex[1] = cca.delay(1.0)
	self.finalIndex[2] = cca.callFunc(function()
		local _ENV, curId
		curId[tostring(self.returnRewardList[1].reward.id)] = self.returnRewardList[1].reward.count
		self:showPrize()
	end)
	self.finalIndex[3] = cca.callFunc(function()
		local _ENV, curId
		curId[tostring(self.returnRewardList[1].reward.id)] = self.returnRewardList[1].reward.count
		self:showPrize()
	end)
	self:runAction(cca.seq(self.finalIndex))
end
function luckyTreasureView:showCirclingAction(_speed)
	self.beginShowList = false
	self.haveShowQuick = false
	self.unShowQuick = nil
	local stepCount = 0
	local offsetSpeed = 0.15
	local nextIndex = self.beforeIdx == 0 and 1 or self.beforeIdx
	local totalIndex = #self.rewardList
	local _ENV, curId
	local _ENV, tableSpare
	local posX = self.singleArray[nextIndex]:getPositionX()
	local posY = self.singleArray[nextIndex]:getPositionY()
	self.singleArray[nextIndex].imgSelect:setVisible(true)
	local fadeInSelect = function()
		if self.beginShowList then
			return
		end
		local showIndex = nextIndex % totalIndex + 1
		local idx = showIndex - 1 > 0 and showIndex - 1 or #self.singleArray
		self.singleArray[idx].imgSelect:setVisible(true)
		self.singleArray[idx].imgSelect:setOpacity(100)
		table.insert(tableSpare, self.singleArray[idx])
		idx = idx - 1 > 0 and idx - 1 or #self.singleArray - idx + 1
		self.singleArray[idx].imgSelect:setVisible(true)
		self.singleArray[idx].imgSelect:setOpacity(40)
		table.insert(tableSpare, self.singleArray[idx])
	end
	local unSee = function(isShowCurSingle)
		if tableSpare then
			for k, v in ipairs(tableSpare) do
				v.imgSelect:setOpacity(255)
				v.imgSelect:setVisible(false)
			end
		end
		tableSpare = (for generator)
		if self.beginShowList then
			return
		end
		if self.curSingle and isShowCurSingle then
			self.curSingle.imgSelect:setVisible(false)
		end
	end
	local speedTime = 0
	local curSpeed = _speed
	local circle = 1
	local circleMax = circleNum.single
	self.timer = SoradCreateTimer(self, function(dt)
		if speedTime >= curSpeed then
			local showIndex = nextIndex % totalIndex + 1
			local _posX = self.singleArray[showIndex]:getPositionX()
			local _posY = self.singleArray[showIndex]:getPositionY()
			if self.unShine and self.curSingle then
				self.curSingle.imgSelect:setVisible(false)
			end
			unSee(true)
			self.singleArray[showIndex].imgSelect:setVisible(true)
			self.curSingle = self.singleArray[showIndex]
			SoraDPlaySound("pyramid", 3)
			if 5 < stepCount then
				fadeInSelect()
			end
			if circle < circleMax then
				if stepCount % totalIndex == 0 then
				end
			elseif 0 < self.haveData then
				self.unShowQuick = false
				if self.haveData == 1 then
					if showIndex + totalIndex == self.finalIndex + totalIndex - 3 then
						unSee()
					elseif showIndex + totalIndex == self.finalIndex + totalIndex - 2 then
						unSee()
					elseif showIndex + totalIndex == self.finalIndex + totalIndex - 1 then
						unSee()
					elseif showIndex == self.finalIndex then
						unSee()
						self.unShowQuick = true
						SoraDManagerRemoveTimer(self, self.timer)
						self.timer = nil
						self:onceAction()
					end
				else
					print("此刻数据已经回来了")
					self.panel_touch:setTouchEnabled(true)
					self.panel_touch_2:setTouchEnabled(true)
					self.unShowQuick = false
					self.allShow = true
					local haveShow = false
					for i, v in ipairs(self.returnRewardList) do
						if v.show == nil then
							self.allShow = false
							self.beginShowList = true
							if v.position == showIndex then
								if not haveShow then
									self.singleArray[showIndex].etShine:resetSystem()
									self:createSingleAnimation(self.singleArray[showIndex])
									self.singleArray[showIndex].imgSelect:setVisible(true)
									haveShow = true
								end
								v.show = true
							end
						end
					end
					self.unShine = true
					for i, v in ipairs(self.returnRewardList) do
						if v.position == showIndex then
							self.unShine = false
						end
					end
					if self.allShow then
						unSee()
						self.unShowQuick = true
						SoraDManagerRemoveTimer(self, self.timer)
						self.timer = nil
						SoraDPlaySound("uicontrol", 4)
						local panel = SoraDCreatePanel("luckyTreasureAwardView")
						panel:setHandle(handler(self, self.tenTurn))
						panel:initRewards(self.returnRewardList)
						panel:show()
						self:reflashView()
					end
				end
			end
		end
	end, true)
end
function luckyTreasureView:chectIsCostItemEnough(param)
	local itemType = serviceFunctions.getIDType(param.id)
	local itemCount = 0
	if itemType == gIDType.GOLD then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		itemCount = lordInfoCtrl:getBaseInfo().gold
	elseif itemType == gIDType.ITEM then
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		itemCount = backpackCtrl:getItemCount(param.id)
	end
	return itemCount >= param.count
end
function luckyTreasureView:getRewardDataCallBack(target, data)
	if not data.reward then
		SoraDManagerRemoveTimer(self, self.timer)
		self:stopAllActions()
		return
	end
	if data.isSingle then
		self.finalIndex = data.reward[1].position
		self.returnRewardList = data.reward
		self.haveData = 1
	else
		self.returnRewardList = data.reward
		self.haveData = 10
	end
	self:reflashView()
end
function luckyTreasureView:showPrize()
	local _ENV, curId
	for i, v in ipairs(self.returnRewardList) do
		_ENV = nil
		;(nil).id = v.reward.id
		;(nil).count = v.reward.count
		;(nil).rate = v.curRate
		table.insert(curId, nil)
	end
	SoraDMailGainItems(curId, true)
end
function luckyTreasureView:getPriceFast()
	self.panel_touch:setTouchEnabled(false)
	self.panel_touch_2:setTouchEnabled(false)
	for k, v in ipairs(self.singleArray) do
		v:stopAllActions()
	end
	SoraDManagerRemoveTimer(self, self.timer)
	self:reflashView()
	self:stopAllActions()
	local panel = SoraDCreatePanel("luckyTreasureAwardView")
	panel:setHandle(handler(self, self.tenTurn))
	panel:initRewards(self.returnRewardList)
	panel:show()
	self.haveShowQuick = true
end
function luckyTreasureView:onClickPanel(button, type)
	if type == ccui.TouchEventType.ended then
		print("onClickPanel")
		if self.returnRewardList and not self.allShow and self.haveData > 1 then
			self:getPriceFast()
		end
	end
end
function luckyTreasureView:onClickFree(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDManagerRemoveTimer(self, self.timer)
		self:stopAllActions()
		SoraDShowLoading()
		self.haveData = 0
		self:showCirclingAction(speedTab.single)
		luckyTreasureCtrl:sendReqSingleTurn()
	end
end
function luckyTreasureView:onClickBtnOne(button, type)
	if type == ccui.TouchEventType.ended then
		if self.unShowQuick == nil and self.returnRewardList then
			return
		end
		print("现在的single", self.singleAllShow)
		SoraDManagerRemoveTimer(self, self.timer)
		SoraDPlaySound()
		self:stopAllActions()
		if not self:chectIsCostItemEnough(self.costItem.oneCost) then
			SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					if GLOBAL_GAME_RECHARGE_MODE then
						uiManager:show("rechargeView")
					else
						SoraDCreatePanel("rechargeView"):show()
					end
				end
			end)
		else
			self.haveData = 0
			self.beforeIdx = self.finalIndex
			print("现在的点击", self.singleAllShow)
			if self.unShowQuick == false and self.returnRewardList then
				self:showPrize()
			end
			self.returnRewardList = nil
			luckyTreasureCtrl:sendReqSingleTurn()
			self.singleAllShow = nil
			self:showCirclingAction(speedTab.single)
		end
	end
end
function luckyTreasureView:tenTurn()
	print("进来")
	SoraDManagerRemoveTimer(self, self.timer)
	for k, v in ipairs(self.singleArray) do
		v.imgSelect:setOpacity(255)
		v.imgSelect:setVisible(false)
	end
	self:stopAllActions()
	if not self:chectIsCostItemEnough(self.costItem.tenCost) then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
			if MSGBOX_CALLBACK_YES == msgType then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
			end
		end)
	else
		self.haveData = 0
		if self.unShowQuick == false and self.returnRewardList and not self.haveShowQuick then
			self:showPrize()
		end
		self.returnRewardList = nil
		luckyTreasureCtrl:sendReqTenTurn()
		self:showCirclingAction(speedTab.single)
	end
end
function luckyTreasureView:onClickBtnTen(button, type)
	if type == ccui.TouchEventType.ended then
		if self.unShowQuick == nil and self.returnRewardList then
			return
		end
		SoraDPlaySound()
		self:tenTurn()
	end
end
function luckyTreasureView:onClickBtnHelp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("Lucky_treasure_text_02"))
	end
end
return luckyTreasureView
