local enjoyLotteryResultPopView = include("enjoyLotteryResultPopView")
local enjoyLotteryCtrl = SoraDGetCtrl("enjoyLotteryCtrl")
local enjoyLotteryView = class("enjoyLotteryView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("enjoyLotteryView")
	end
	return target
end)
enjoyLotteryView.RUNTIME = 0.2
enjoyLotteryView.DELAYTIME = 0.05
local EPC = require_data("enjoylottery_pond", true)
local enjoylottery_ticket = require_data("enjoylottery_ticket", true)
local _ENV, rewardsConfig = "enjoylottery_ticket", "enjoylottery_ticket"
for i, v in ipairs(EPC.data) do
	if not rewardsConfig[v.type] then
		rewardsConfig[v.type], _ENV = nil, nil
	end
	_ENV = nil
	;(nil).id = v.reward[1]
	;(nil).count = v.reward[2]
	table.insert(rewardsConfig[v.type], nil)
end
local enjoylotteryview_reward_data = rewardsConfig
function enjoyLotteryView:ctor()
	self.itemList, _UPVALUE0_ = nil, nil
	self.isAction = false
	self.rewardinfo, _UPVALUE0_, self.indexList, _UPVALUE0_, self.rewardsData, _UPVALUE0_, self.lotteryCounts = nil, nil, nil, nil, nil, nil, 0
	self.delayRemove = false
	if not self:initRewardConfig() then
		return
	end
	self:initWidget()
	self:initDeviceFit()
	self:addMessage()
	self:initData()
end
function enjoyLotteryView:initRewardConfig(...)
	local parma = SoraDGetCtrl("activityShowCtrl"):getParamByID(gActivityTimeActivityID.ENJOY_LOTTERY)
	if parma and parma.type then
		self.rewardsData = enjoylotteryview_reward_data[parma.type]
		return true
	end
end
function enjoyLotteryView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ENJOY_LOTTERY) then
			if self.isAction then
				self.delayRemove = true
			else
				SoraDRemoveAllAfterPanelFromManager(self)
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshLotteryCount))
	SoraDAddMessage(self, "MESSAGE_ENJOYLOTTERY_REFRESH", handler(self, self.refreshEnjoyLottery))
end
function enjoyLotteryView:initWidget(...)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("enjoylottery_title_01"))
	enjoylottery_ticket = i18n("enjoylottery_title_01")
	i18n("enjoylottery_title_01")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.nodeTitle, i18n("enjoylottery_title_01"))
	self.Button_help:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	_UPVALUE2_ = "Top_Node"
	;("Top_Node")[1] = "Node_top_line"
	;("Top_Node")[2] = "Image_6"
	local imagel = SoraDGetChildByFullPath(self.Top_Node, "Top_Node")
	_UPVALUE2_ = "Node_top_line"
	;("Node_top_line")[1] = "Node_top_line"
	;("Node_top_line")[2] = "Image_6_0"
	local imager = SoraDGetChildByFullPath(self.Top_Node, "Node_top_line")
	local sp = display.newSprite("#slotmachine_yellow2.png")
	for i = 1, 19 do
		local newSp = sp:clone()
		newSp:addTo(imagel)
		newSp:setPosition(cc.p(13, i * 28 + 20))
	end
	for i = 1, 19 do
		local newSp = sp:clone()
		newSp:addTo(imager)
		newSp:setPosition(cc.p(13, i * 28 + 20))
	end
	_UPVALUE3_ = 1
	;(1)[1] = "Node_top_line"
	;(1)[2] = "Node_times"
	;(1)[3] = "Text_times"
	self.Text_times = SoraDGetChildByFullPath(self.Top_Node, 1)
	self.Text_times = SoraDCreateTimerLabel(self, self.Text_times)
	enjoylottery_ticket = self.Text_times
	self.Text_times[1] = "Node_main"
	self.Node_main = SoraDGetChildByFullPath(self.Top_Node, self.Text_times)
	enjoylottery_ticket = self.Text_times
	self.Text_times[1] = "Button_one"
	self.Button_one = SoraDGetChildByFullPath(self.Node_main, self.Text_times)
	enjoylottery_ticket = self.Text_times
	self.Text_times[1] = "Button_two"
	self.Button_two = SoraDGetChildByFullPath(self.Node_main, self.Text_times)
	enjoylottery_ticket = self.Text_times
	self.Text_times[1] = "Text_1"
	SoraDGetChildByFullPath(self.Button_one, self.Text_times):setString(i18n("enjoylottery_btn_01"))
	enjoylottery_ticket = i18n("enjoylottery_btn_01")
	i18n("enjoylottery_btn_01")[1] = "Text_2"
	SoraDGetChildByFullPath(self.Button_one, i18n("enjoylottery_btn_01")):setString(1)
	enjoylottery_ticket = 1
	;(1)[1] = "Text_1"
	SoraDGetChildByFullPath(self.Button_two, 1):setString(i18n("enjoylottery_btn_02"))
	enjoylottery_ticket = i18n("enjoylottery_btn_02")
	i18n("enjoylottery_btn_02")[1] = "Text_2"
	SoraDGetChildByFullPath(self.Button_two, i18n("enjoylottery_btn_02")):setString(5)
	self.Button_one:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_two:addTouchEventListener(handler(self, self.btnClickCallback))
	enjoylottery_ticket = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Node_bottom_line"
	self.Node_bottom_line = SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btnClickCallback))
	enjoylottery_ticket = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Node_counts"
	self.Node_counts = SoraDGetChildByFullPath(self.Node_bottom_line, handler(self, self.btnClickCallback))
	enjoylottery_ticket = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Node_counts_up"
	self.Node_counts_up = SoraDGetChildByFullPath(self.Node_counts, handler(self, self.btnClickCallback))
	enjoylottery_ticket = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Text_has"
	self.Text_has = SoraDGetChildByFullPath(self.Node_counts_up, handler(self, self.btnClickCallback))
	self.Text_has:setString(i18n("common_text_3893"))
	enjoylottery_ticket = i18n("common_text_3893")
	i18n("common_text_3893")[1] = "Text_count"
	self.Text_count = SoraDGetChildByFullPath(self.Node_counts_up, i18n("common_text_3893"))
	enjoylottery_ticket = i18n("common_text_3893")
	i18n("common_text_3893")[1] = "Image_add"
	self.Image_add = SoraDGetChildByFullPath(self.Node_counts_up, i18n("common_text_3893"))
	self.Image_add:setTouchEnabled(true)
	self.Image_add:addTouchEventListener(handler(self, self.btnClickCallback))
	enjoylottery_ticket = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Bottom_Size_scroll"
	self.scroll = SoraDGetChildByFullPath(self.Node_bottom_line, handler(self, self.btnClickCallback))
	self.scroll:setPositionY(self.Node_counts:getPositionY() - 23)
	enjoylottery_ticket = self.Node_counts:getPositionY() - 23
	;(self.Node_counts:getPositionY() - 23)[1] = "Text_des1"
	self.Text_des1 = SoraDGetChildByFullPath(self.scroll, self.Node_counts:getPositionY() - 23)
	self.Text_des1:setString(i18n("enjoylottery_text_01"))
	local desHeight = SoraDGetAutoHeightLabel(self.Text_des1, 520)
	enjoylottery_ticket = i18n("enjoylottery_text_01")
	i18n("enjoylottery_text_01")[1] = "Image_11"
	local Image_11 = SoraDGetChildByFullPath(self.scroll, i18n("enjoylottery_text_01"))
	self.Image_11 = Image_11
	enjoylottery_ticket = "Image_11"
	;("Image_11")[1] = "Node_single"
	self.Node_single = SoraDGetChildByFullPath(self.scroll, "Image_11")
	local innerWidth = self.scroll:getContentSize().width
	local imageH = 50 * (#enjoylottery_ticket.data + 1) + 40
	Image_11:setContentSize(cc.size(Image_11:getContentSize().width, imageH))
	local innerHeight = desHeight + imageH + 60
	local sH = math.min(innerHeight, display.height - 830)
	self.scroll:setContentSize(cc.size(innerWidth, sH))
	self.scroll:setInnerContainerSize(cc.size(innerWidth, innerHeight))
	self.scroll:setBounceEnabled(self.scroll:getInnerContainerSize().height > self.scroll:getContentSize().height)
	self.Text_des1:setPositionY(innerHeight - 20)
	Image_11:setPositionY(self.Text_des1:getPositionY() - desHeight - 30)
	enjoylottery_ticket = self.Text_des1:getPositionY() - desHeight - 30
	;(self.Text_des1:getPositionY() - desHeight - 30)[1] = "Text_single"
	SoraDGetChildByFullPath(self.Node_single, self.Text_des1:getPositionY() - desHeight - 30):setString(i18n("enjoylottery_text_05"))
	enjoylottery_ticket = i18n("enjoylottery_text_05")
	i18n("enjoylottery_text_05")[1] = "Text_num"
	SoraDGetChildByFullPath(self.Node_single, i18n("enjoylottery_text_05")):setString(i18n("enjoylottery_text_06"))
	self.Node_single:setPosition(cc.p(innerWidth / 2, imageH - 40))
	for i, v in ipairs(enjoylottery_ticket.data) do
		local widget = self.Node_single:clone()
		widget:addTo(self.scroll)
		local priceStr = paymentManager.getRealPrice(v.pidindex, v.price)
		enjoylottery_ticket = cc.p(innerWidth / 2, imageH - 40)
		cc.p(innerWidth / 2, imageH - 40)[1] = "Text_single"
		SoraDGetChildByFullPath(widget, cc.p(innerWidth / 2, imageH - 40)):setString(priceStr)
		enjoylottery_ticket = priceStr
		priceStr[1] = "Text_num"
		SoraDGetChildByFullPath(widget, priceStr):setString("X" .. v.lottery)
		widget:setPosition(cc.p(innerWidth / 2, imageH - 40 - 50 * i))
	end
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE3_ = cc.p(innerWidth / 2, imageH - 40)
	cc.p(innerWidth / 2, imageH - 40)[1] = "Bottom_Node_fire"
	cc.p(innerWidth / 2, imageH - 40)[2] = "frame_lace_base_1"
	cc.p(innerWidth / 2, imageH - 40)[3] = "Node_fire"
	_UPVALUE3_ = "Bottom_Node_fire"
	;("Bottom_Node_fire")[1] = "Bottom_Node_fire"
	;("Bottom_Node_fire")[2] = "frame_lace_base_2"
	;("Bottom_Node_fire")[3] = "Node_fire"
	SoraDCreateFireEffectNode(SoraDGetChildByFullPath(self.Bottom_Node, cc.p(innerWidth / 2, imageH - 40)), SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node_fire"))
	self.singleItem = SoraDGetChildByName(self, "Node_single_item")
	for i = 1, 5 do
		local widget = SoraDGetChildByName(self, "dh_jinbi_0" .. i)
		if widget then
			_ENV = i
			i.beginOpacity = 0.7
			i.endOpacity = 1
			i.fadeIn = 0.5
			i.fadeOut = 0.5
			i.delay = 0.2
			SoraDFadeINOUT(widget, i)
		end
	end
end
function enjoyLotteryView:initDeviceFit(...)
	if display.height <= 960 then
		_UPVALUE1_ = nil
		;(nil)[1] = "Button_rule"
		self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, nil)
		self.Button_rule:setTitleText(i18n("common_text_1173"))
		self.Button_rule:addTouchEventListener(handler(self, self.btnClickCallback))
		self.Button_rule:setVisible(true)
		self.Text_des1:setVisible(false)
		self.Image_11:setVisible(false)
		self.scroll:setVisible(false)
		if display.height < 900 then
			self.Button_rule:setPositionY(self.Button_rule:getPositionY() - 50)
			_UPVALUE2_ = self.Button_rule:getPositionY() - 50
			;(self.Button_rule:getPositionY() - 50)[1] = "Node_line"
			;(self.Button_rule:getPositionY() - 50)[2] = "Image_2"
			SoraDGetChildByFullPath(self.Bottom_Node, self.Button_rule:getPositionY() - 50):setVisible(false)
			_UPVALUE2_ = false
			;(false)[1] = "Node_line"
			;(false)[2] = "Image_3"
			SoraDGetChildByFullPath(self.Bottom_Node, false):setVisible(false)
			_UPVALUE1_ = false
			;(false)[1] = "Node_golds"
			SoraDGetChildByFullPath(self.Bottom_Node, false):setVisible(false)
			_UPVALUE1_ = false
			;(false)[1] = "Sprite_frame_left"
			SoraDGetChildByFullPath(self.Node_bottom_line, false):setVisible(false)
			_UPVALUE1_ = false
			;(false)[1] = "Sprite_frame_right"
			SoraDGetChildByFullPath(self.Node_bottom_line, false):setVisible(false)
			self.Node_counts:setPositionY(-470)
			_UPVALUE1_ = -470
			;(-470)[1] = "Image_60"
			SoraDGetChildByFullPath(self.Node_counts, -470):setVisible(true)
		end
	end
end
function enjoyLotteryView:initData()
	local itemWidth = 146
	local beginPos = cc.p(-itemWidth * 1.5, itemWidth * 1.5)
	local curPos = beginPos
	for i = 1, 12 do
		local item = self:createSingleItem(i)
		item:addTo(self.Node_main)
		table.insert(self.itemList, item)
		local dir = math.ceil((i - 1) / 3)
		_UPVALUE3_ = (i - 1) / 3
		;(i - 1) / 3[1] = cc.p(itemWidth, 0)
		;(i - 1) / 3[2] = cc.p(0, -itemWidth)
		;(i - 1) / 3[3] = cc.p(-itemWidth, 0)
		;(i - 1) / 3[4] = cc.p(0, itemWidth)
		;(i - 1) / 3[5] = cc.p(0, itemWidth)
		local (i - 1) / 3[6], dirpos = cc.p(0, itemWidth)
		local posAdd = dirpos[dir] or cc.p(0, 0)
		curPos = cc.p(curPos.x + posAdd.x, curPos.y + posAdd.y)
		item:setPosition(curPos)
		item:setLocalZOrder(-curPos.y)
	end
	self.itemID = 852101
	self:refreshLotteryCount()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local packageTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ENJOY_LOTTERY)
	if packageTime then
		self.Text_times:beginTime(packageTime.timerNode.timer:getRemainTime())
	end
end
function enjoyLotteryView:refreshData(...)
end
function enjoyLotteryView:refreshLotteryCount(...)
	self.lotteryCounts = SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemID)
	self.Text_count:setString(self.lotteryCounts)
	SoraDToCenter(self.Node_counts_up, 10)
end
function enjoyLotteryView:createSingleItem(index)
	local item = self.singleItem:clone()
	_UPVALUE1_ = nil
	;(nil)[1] = "Image_select"
	item.Image_select = SoraDGetChildByFullPath(item, nil)
	item.Image_select:setVisible(false)
	_UPVALUE1_ = false
	;(false)[1] = "Node_double"
	item.Node_double = SoraDGetChildByFullPath(item, false)
	item.Node_double:setVisible(false)
	_UPVALUE1_ = false
	;(false)[1] = "Sprite_double"
	item.Sprite_double = SoraDGetChildByFullPath(item.Node_double, false)
	local singleItem = include("itemSingleView").new()
	singleItem:setPosition(cc.p(-72, 72))
	singleItem:addTo(item, -1)
	singleItem:setScale(0.9536423841059603)
	local reward = self.rewardsData[index]
	_ENV = -1
	;(-1).itemData = reward
	singleItem:initData(-1)
	singleItem:setButtonTag(reward.id)
	singleItem:setItemClickCallback(handler(self, self.showDetail))
	singleItem.imgFrame:setVisible(false)
	local effect = SoraDCreatAnimation("zunxiang")
	effect:addTo(item)
	local sp = SoraDGetChildByName(effect, "Sprite_1")
	SoraDMixtureGLONE(sp)
	item.effectSprite = sp
	item.times = 0
	return item
end
function enjoyLotteryView:showItemFadeInAndOut(item)
	if item.final then
		return
	end
	self:itemFadeInAndOut(item)
end
function enjoyLotteryView.getDoubleIcon(times)
	_UPVALUE0_ = nil
	;(nil)[2] = "8032.png"
	;(nil)[3] = "8035.png"
	;(nil)[4] = "8523.png"
	local (nil)[5], timesToIcon = "8033.png", nil
	return timesToIcon[times] or timesToIcon[2]
end
function enjoyLotteryView:setItemFinalSign(item, final)
	item.final = final
	if final == true then
		item.times = item.times + 1
		if item.times > 1 then
			item.Node_double:setVisible(true)
			local iconName = enjoyLotteryView.getDoubleIcon(item.times)
			item.Sprite_double:setSpriteFrame(iconName)
			local scale = 46 / item.Sprite_double:getContentSize().width
			item.Sprite_double:setScale(scale)
			_ENV = nil
			;(nil)[1] = cca.scaleTo(0.3, 2.0 * scale)
			;(nil)[2] = cca.scaleTo(0.3, scale)
			;(nil)[3] = cca.scaleTo(0.3, scale)
			;(nil)[4] = cca.scaleTo(0.3, scale)
			item.Sprite_double:runAction(cca.seq(nil))
		else
			item.Node_double:setVisible(false)
		end
	else
		item.times = 0
		item.Node_double:setVisible(false)
	end
end
function enjoyLotteryView:initItemState(item)
	self:setItemFinalSign(item, false)
	item.Image_select:setVisible(false)
end
function enjoyLotteryView:itemFadeInAndOut(item, callback)
	item.Image_select:setVisible(true)
	item.Image_select:setOpacity(0)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.fadeIn(enjoyLotteryView.RUNTIME / 2)
	;(nil)[2] = cca.fadeOut(enjoyLotteryView.RUNTIME / 2)
	;(nil)[3] = cca.callFunc(function()
		item.Image_select:setVisible(false)
		item.Image_select:setOpacity(255)
		if callback then
			callback()
		end
	end)
	;(nil)[4] = cca.callFunc(function()
		item.Image_select:setVisible(false)
		item.Image_select:setOpacity(255)
		if callback then
			callback()
		end
	end)
	item.Image_select:runAction(cca.seq(nil))
end
function enjoyLotteryView:showItemAction(item)
	self:itemFadeInAndOut(item, function()
		item.Image_select:setVisible(true)
	end)
end
function enjoyLotteryView:btnClickCallback(button, event)
	if event == ccui.TouchEventType.ended then
		if self.isAction then
			return
		end
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if button == self.Image_add then
			self:btnAddCallback()
		elseif button == self.Button_help then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.SHARE_LOTTERY)
		elseif button == self.Button_rule then
			SoraDCreatePanel("enjoyLotteryRulePopView"):show()
		elseif button == self.Button_one or button == self.Button_two then
			self:btnPumpClickCallBack(button)
		end
	end
end
function enjoyLotteryView:btnAddCallback()
	if SoraDCheckShow() then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
			uiManager:show("rechargePopFrame", nil)
		else
			local panel = SoraDCreatePanel("rechargePopFrame")
			panel:initData(nil, gRechargeActiveFromEnum.ROAD01)
			panel:show()
		end
	elseif GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function enjoyLotteryView:btnPumpClickCallBack(button)
	if button == self.Button_one and self.lotteryCounts < 1 or button == self.Button_two and self.lotteryCounts < 5 then
		SoraDShowMsgBox(i18n("enjoylottery_text_04"), i18n("common_text_204"), nil, function(etype)
			if etype == MSGBOX_CALLBACK_YES then
				self:btnAddCallback()
			end
		end)
		return
	end
	self.isAction = true
	if button == self.Button_one then
		enjoyLotteryCtrl:sendReqPond(1)
	elseif button == self.Button_two then
		enjoyLotteryCtrl:sendReqPond(5)
	end
end
function enjoyLotteryView:btnOneClickCallBack()
	local beginIndex = 0
	local cycleMax = 3
	local finalIndex = self.indexList[1]
	self.curCycle = 0
	self:doSinglePumping(beginIndex, cycleMax, finalIndex, 1)
end
function enjoyLotteryView:btnTwoClickCallBack()
	self.beginIndex = 0
	self.curCycle = 0
	self:doContinuePumping()
end
function enjoyLotteryView:doContinuePumping(...)
	local finalIndex = self.indexList[self.curCycle + 1]
	local cycleMax = 3
	if self.curCycle > 0 then
		if finalIndex <= self.beginIndex then
			cycleMax = 1
		else
			cycleMax = 0
		end
	end
	self:doSinglePumping(self.beginIndex, cycleMax, finalIndex, 5)
	self.beginIndex = finalIndex
end
function enjoyLotteryView:doSinglePumping(beginIndex, cycleMax, finalIndex, pumpType)
	local total = beginIndex
	local delayTime = enjoyLotteryView.DELAYTIME
	local item
	local index = 0
	local cycleNum = 0
	_ENV = nil
	;(nil)[1] = cca.delay(delayTime)
	;(nil)[2] = cca.callFunc(function()
		if cycleNum > cycleMax and index > finalIndex or cycleNum > cycleMax + 1 then
			self:pumpSingleFinishBack(item, pumpType)
			return
		end
		if item then
			self:showItemFadeInAndOut(item)
		end
	end)
	;(nil)[3] = cca.callFunc(function()
		if cycleNum > cycleMax and index > finalIndex or cycleNum > cycleMax + 1 then
			self:pumpSingleFinishBack(item, pumpType)
			return
		end
		if item then
			self:showItemFadeInAndOut(item)
		end
	end)
	self.Node_main:runAction(cc.RepeatForever:create(cca.seq(nil)))
end
function enjoyLotteryView:pumpSingleFinishBack(item, pumpType)
	self.Node_main:stopAllActions()
	if item then
		self:setItemFinalSign(item, true)
		enjoyLotteryView = true
		;(true)[1] = cca.delay(enjoyLotteryView.RUNTIME)
		;(true)[2] = cca.callFunc(function()
			self:showItemAction(item)
		end)
		;(true)[3] = cca.callFunc(function()
			self:showItemAction(item)
		end)
		;(true)[4] = cca.callFunc(function()
			self:showItemAction(item)
		end)
		;(true)[5] = cca.callFunc(function()
			self:showItemAction(item)
		end)
		item:runAction(cca.seq(true))
	end
	self.curCycle = self.curCycle + 1
	if pumpType > self.curCycle then
		enjoyLotteryView = cca.seq(true)
		cca.seq(true)[1] = cca.delay(1.0)
		cca.seq(true)[2] = cca.callFunc(function()
			self:doContinuePumping()
		end)
		cca.seq(true)[3] = cca.callFunc(function()
			self:doContinuePumping()
		end)
		cca.seq(true)[4] = cca.callFunc(function()
			self:doContinuePumping()
		end)
		cca.seq(true)[5] = cca.callFunc(function()
			self:doContinuePumping()
		end)
		self:runAction(cca.seq(cca.seq(true)))
	else
		enjoyLotteryView = cca.seq(cca.seq(true))
		cca.seq(cca.seq(true))[1] = cca.delay(1.0)
		cca.seq(cca.seq(true))[2] = cca.callFunc(handler(self, self.pumpAllFinishBack))
		cca.seq(cca.seq(true))[3] = cca.callFunc(handler(self, self.pumpAllFinishBack))
		cca.seq(cca.seq(true))[4] = cca.callFunc(handler(self, self.pumpAllFinishBack))
		cca.seq(cca.seq(true))[5] = cca.callFunc(handler(self, self.pumpAllFinishBack))
		self:runAction(cca.seq(cca.seq(cca.seq(true))))
	end
end
function enjoyLotteryView:pumpAllFinishBack(...)
	SoraDCloseLoading(self)
	self.isCantCloseByReturn = false
	self.isAction = false
	SoraDRemoveAllAfterPanelFromManager(self, true)
	local panel = SoraDCreatePanel("enjoyLotteryResultPopView")
	_ENV = nil
	;(nil).rewards = self.rewardinfo
	panel:initData(nil)
	panel:show()
	for __, item in ipairs(self.itemList) do
		item.effectSprite:setVisible(true)
	end
	local itemData = self.rewardinfo
	SoraDMailGainItems(itemData, true)
	if self.delayRemove then
		self:removeFromParent()
	end
end
function enjoyLotteryView:refreshEnjoyLottery(target, event)
	SoraDShowLoading(self, nil, nil, true)
	self.rewardinfo, _ENV, self.indexList, _ENV, self.isCantCloseByReturn = SoraDShowLoading, SoraDShowLoading, SoraDShowLoading, SoraDShowLoading, true
	local rewardinfo = event.rewardinfo
	if rewardinfo and next(rewardinfo) then
		local _ENV, indexList = next(rewardinfo), next(rewardinfo)
		for __, v in ipairs(rewardinfo) do
			for i, w in ipairs(self.rewardsData) do
				if v.id == w.id and v.count == w.count then
					table.insert(indexList, i)
					break
				end
			end
		end
		self.indexList = indexList
		self.rewardinfo = rewardinfo
	end
	self.isAction = true
	for __, item in ipairs(self.itemList) do
		self:initItemState(item)
		item.effectSprite:setVisible(false)
	end
	if #self.indexList == 1 then
		self:btnOneClickCallBack()
	elseif #self.indexList == 5 then
		self:btnTwoClickCallBack()
	end
end
function enjoyLotteryView:showDetail(target, etype)
	if etype == ccui.TouchEventType.ended or etype == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:stopAllActions()
		SoraDCloseCommonTips()
	elseif etype == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			SoraDShowCommonTips(target, target:getTag())
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDShowCommonTips(target, target:getTag())
		end)
		self:runAction(cca.seq(nil))
	end
end
return enjoyLotteryView
