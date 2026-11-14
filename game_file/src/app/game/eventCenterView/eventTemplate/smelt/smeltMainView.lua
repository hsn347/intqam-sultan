local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local smeltCtrl = gametop.playertop_:getModule("smeltCtrl")
local publicRead = include("publicRead")
local smeltRead = include("smeltRead")
local smeltMainView = class("smeltMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("smeltMainView")
	end
	return target
end)
function smeltMainView:ctor()
	self.tableEXPLabelSpare, _ENV, self.isHideCurrentSceneView = nil, nil, true
	self:initView()
	self:initEffects()
	SoraDShowLoading(self)
	smeltCtrl:reqInit()
	self:initTime()
end
function smeltMainView:initEffects()
end
function smeltMainView:initView()
	self.activityID = gActivityTimeActivityID.SMELT_ACTIVITY
	self.txt_time = SoraDGetChildByName(self, "Text_time")
	self.txt_num_desc = SoraDGetChildByName(self, "txt_num_desc")
	self.txt_num_desc = SoraDChangeTextToHtml(self.txt_num_desc)
	self.txt_name = SoraDGetChildByName(self, "txt_name")
	self.txt_name:setString(i18n("Smelt_text_33"))
	self.itemTip = SoraDGetChildByName(self, "Text_item_tip")
	self.itemTip:setString(i18n("Smelt_text_34"))
	self.textTip2 = SoraDGetChildByName(self, "Text_tip2")
	self.textTip2:setString(i18n("Smelt_text_36"))
	self.textNoChoose = SoraDGetChildByName(self, "Text_no_choose")
	self.textNoChoose:setString(i18n("Smelt_text_39"))
	self.imageNoChoose = SoraDGetChildByName(self, "Image_no_choose")
	self.txtLongTip = SoraDGetChildByName(self, "Text_long_tip")
	self.txtLongTip:setString(i18n("hero_text_54"))
	self.btn_add = SoraDGetChildByName(self, "button_add")
	self.btn_choose = SoraDGetChildByName(self, "btn_choose")
	self.btn_reward_pool = SoraDGetChildByName(self, "btn_reward_pool")
	self.btn_reward = SoraDGetChildByName(self, "btn_reward")
	self.btn_task = SoraDGetChildByName(self, "btn_task")
	self.txt_reward_pool = SoraDGetChildByName(self, "txt_reward_pool")
	self.txt_reward = SoraDGetChildByName(self, "txt_reward")
	self.txt_task = SoraDGetChildByName(self, "txt_task")
	self.red_task = SoraDGetChildByName(self, "frame_red")
	self.txt_red_num = SoraDGetChildByName(self, "Text_red_num")
	self.btn_FAQ = SoraDGetChildByName(self, "btn_FAQ")
	self.btn_switch = SoraDGetChildByName(self, "Btn_switch")
	self.btn_switch:setPositionY(127)
	self.icon_get = SoraDGetChildByName(self, "Icon_get")
	self.text_got_tip = SoraDGetChildByName(self, "Text_got_tip")
	self.text_got_tip:setString(i18n("Smelt_text_40"))
	self.icon_get:setLocalZOrder(1)
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.node_bottom_item = SoraDGetChildByName(self, "Node_bottom_item")
	self.node_bottom_num = SoraDGetChildByName(self, "Node_bottom_num")
	self.node_activity_time = SoraDGetChildByName(self, "Node_after_start")
	self.node_base_box = SoraDGetChildByName(self, "Node_pBoxs")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.center_node = SoraDGetChildByName(self, "Center_Node")
	self.center_node_smelt = SoraDGetChildByName(self, "Center_Node_smelt")
	self.txt_num_desc:setString(i18n("runningSheep_text_22"))
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.title:setTitle(i18n("activity_name_9001354"))
	self.txt_time = SoraDCreateTimerLabel(self, self.txt_time)
	self.txt_time:setTimeLast(function(time)
		SoraDToCenter(self.node_activity_time, 5, SoraDFIsRA())
		return time
	end)
	self.txt_reward:setString(i18n("decrypt_text_03"))
	self.txt_reward_pool:setString(i18n("Smelt_text_14"))
	self.txt_task:setString(i18n("common_text_675"))
	self.btn_choose:addTouchEventListener(handler(self, self.onChoose))
	self.btn_FAQ:addTouchEventListener(handler(self, self.onHelp))
	self.btn_add:addTouchEventListener(handler(self, self.onGetMore))
	self.btn_reward:addTouchEventListener(handler(self, self.onShowReward))
	self.btn_reward_pool:addTouchEventListener(handler(self, self.onRewardPoolUp))
	self.btn_task:addTouchEventListener(handler(self, self.onTask))
	self.btn_switch:addTouchEventListener(handler(self, self.onChoose))
	self.btn_switch:setLocalZOrder(1)
	for i = 1, 4 do
		local boxBtn = SoraDGetChildByName(self, "Button_box_" .. i)
		boxBtn:setTag(i)
		boxBtn:addTouchEventListener(handler(self, self.onShowBoxReward))
	end
	_UPVALUE2_ = 1
	;(1)[1] = "ar"
	;(1)[2] = "en"
	local roundShowName = SoraDGetImageNameByLang("round_show_%s", 1)
	self.roundShowNode = SoraDGetChildByName(self, roundShowName)
	self.roundShowLabel = SoraDGetChildByName(self.roundShowNode, "label_round")
	self.roundSp = SoraDGetChildByName(self.roundShowNode, "sp")
	self.bgSp = cc.criSprite.createCriSprite("sp_qcbl_009.usm", false, true, true)
	if display.height >= 1136 then
		self.bgSp:setPosition(display.width / 2, display.height / 2 + 175)
	else
		self.bgSp:setPosition(display.width / 2, display.height / 2 + 255)
		self.center_node_smelt:setPositionY(display.height / 2)
		self.center_node:setPositionY(display.height / 2)
	end
	self.bgSp:addTo(self, -1)
	self.bgSp:setPreviewImage("#bg_qcbl_lzbj_02.png", cc.size(640, 1150), true, true)
	self.smeltUse = include("smeltUse").new(SoraDGetChildByName(self, "Bottom_UseNode"))
	self:setShowNode()
end
function smeltMainView:updateBg(isShowAni)
	if not smeltCtrl:getIsBuy() then
		return
	end
	function showAniFunc(bgSp, bgSpUp)
		bgSpUp:start()
		bgSp:start()
		bgSp:setOpacity(0)
		_UPVALUE2_ = nil
		;(nil)[1] = cca.delay(0.3)
		;(nil)[2] = cca.fadeOut(0.5)
		;(nil)[3] = cca.removeSelf()
		self.bgSp:runAction(cca.seq(nil))
		_ENV = cca.seq(nil)
		cca.seq(nil)[1] = cca.delay(0.3)
		cca.seq(nil)[2] = cca.fadeIn(0.5)
		cca.seq(nil)[3] = cca.fadeIn(0.5)
		bgSp:runAction(cca.seq(cca.seq(nil)))
		self.bgSp = bgSp
	end
	local isBgInited = false
	local isBgUpInited = false
	local bgSpUp
	local bgSp = cc.criSprite.createCriSprite("sp_qcbl_007.usm", false, true, function(bgSp)
		if isShowAni then
			if isBgUpInited then
				showAniFunc(bgSp, bgSpUp)
			end
		else
			bgSp:setOpacity(0)
			isBgUpInited = nil
			;(nil)[1] = cca.delay(0.5)
			;(nil)[2] = cca.fadeOut(0.5)
			;(nil)[3] = cca.removeSelf()
			self.bgSp:runAction(cca.seq(nil))
			bgSp:runAction(cca.fadeIn(0.5))
			self.bgSp = bgSp
			bgSp:start()
		end
	end)
	if display.height >= 1136 then
		bgSp:setPosition(display.width / 2, display.height / 2 + 175)
	else
		bgSp:setPosition(display.width / 2, display.height / 2 + 255)
	end
	bgSp:addTo(self, -1)
	if isShowAni then
		bgSpUp = cc.criSprite.createCriSprite("G_sp_qcbl_006.usm", true, false, function()
			if isBgInited then
				showAniFunc(bgSp, bgSpUp)
			end
		end)
		bgSpUp:setPosition(display.width / 2, display.height / 2 + 300)
		bgSpUp:addTo(self, -1)
		bgSpUp:setBlendFunc(gl.ONE, gl.ONE)
	end
end
function smeltMainView:refreshItem()
	local maxValue = smeltCtrl:getNextStageCost(smeltCtrl:getCurRound())
	local value = smeltCtrl:getValue()
	local showValue = maxValue < value and maxValue or value
	smeltCtrl = smeltCtrl:getCurRound()
	smeltCtrl:getCurRound().num = smeltCtrl:getCurRound()
	smeltCtrl:getCurRound().num1 = showValue
	smeltCtrl, smeltCtrl, smeltCtrl:getCurRound().num2 = smeltCtrl, smeltCtrl:getCurRound(), maxValue
	smeltCtrl, smeltCtrl:getCurRound().num, smeltCtrl.color = smeltCtrl, smeltCtrl, "#00BE1E"
	smeltCtrl:getCurRound().num1, smeltCtrl.color = smeltCtrl, "#00BE1E"
	self.txt_num_desc:setString(i18n_html("Smelt_text_18", smeltCtrl:getCurRound()))
	SoraDToCenter(self.node_bottom_item, 5, SoraDFIsRA())
	SoraDToCenter(self.node_bottom_num, 5, SoraDFIsRA())
	self.smeltUse:updateView()
	self:updateRedPoint()
end
function smeltMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.updataInfoData))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_DATA", handler(self, self.onNotify))
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_SMELT", handler(self, self.showGetValue))
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_CHOOSE_EQUIP", handler(self, self.onChooseEquip))
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_UPDATE_BOX", handler(self, self.updateBox))
end
function smeltMainView:updataInfoData(target, data)
	SoraDCloseLoading(self)
	if data.activityID == self.activityID then
		self:updateView()
		self:updateBg()
	end
end
function smeltMainView:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		local leftTime = eventTime.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	else
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	SoradCreateTimer(self, handler(self, function()
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if not eventTime then
			SoraDRemoveAllAfterPanelFromManager(self)
			return
		end
	end))
	SoraDToCenter(self.node_activity_time, 5, SoraDFIsRA())
end
function smeltMainView:setShowNode()
	local isChoosed = self.choosedEquip ~= nil and self.choosedEquip ~= 0
	local isFinish = smeltCtrl:getIsFinish()
	self.btn_choose:setVisible(not isChoosed)
	self.btn_task:setVisible(isChoosed)
	self.center_node:setVisible(isChoosed)
	self.node_bottom_item:setVisible(isChoosed and not isFinish)
	self.node_bottom_num:setVisible(isChoosed)
	self.node_base_box:setVisible(isChoosed)
	self.btn_reward_pool:setVisible(isChoosed and not smeltCtrl:getIsBuy() and smeltCtrl:getGiftData() ~= nil)
	self.btn_switch:setVisible(smeltCtrl:getCurRound() <= 1)
	self.icon_get:setVisible(smeltCtrl:getCurRound() > 1)
	self.Bottom_Node:setPositionY(not (not isChoosed or isFinish) and 0 or -90)
	self.smeltUse:setVisible(isChoosed and not isFinish)
	self.imageNoChoose:setVisible(not isChoosed or isFinish)
	self.textNoChoose:setString(isFinish and i18n("Smelt_text_37") or i18n("Smelt_text_39"))
end
function smeltMainView:updateView()
	self.oldIsBuy = smeltCtrl:getIsBuy()
	self:updateBox()
	self:refreshItem()
	self:updateEquip()
end
function smeltMainView:updateRedPoint()
	local isRed, tmp, num = smeltCtrl:getReceiveStatusAndNum()
	self.red_task:setVisible(isRed)
	self.txt_red_num:setString(num)
end
function smeltMainView:updateBox()
	local curRewards = smeltCtrl:getCurRewards()
	local curRound = smeltCtrl:getCurRound()
	local maxValue = 0
	local curValue = smeltCtrl:getValue()
	local curBoxIndex = 0
	for i, v in ipairs(curRewards) do
		local boxNode = SoraDGetChildByName(self, "Button_box_" .. i)
		local needNumLb = SoraDGetChildByName(boxNode, "Text_price")
		local imgIcon = SoraDGetChildByName(boxNode, "Sprite_box")
		needNumLb:setString(SoraDConvertNumberWithUnit(v.cost))
		maxValue = maxValue < v.cost and v.cost or maxValue
		local isGot = curValue >= v.cost
		SoraDSetGray(imgIcon, isGot, false)
		if isGot then
			curBoxIndex = i
		end
	end
	for i, v in ipairs(curRewards) do
		local boxNode = SoraDGetChildByName(self, "Button_box_" .. i)
		if SoraDFIsRA() then
			boxNode:setPositionX(230 - 450 * v.cost / maxValue + 5)
		else
			boxNode:setPositionX(-230 + 450 * v.cost / maxValue - 5)
		end
		boxNode:setLocalZOrder(101)
	end
	if self.oldIndex ~= nil and (curBoxIndex > self.oldIndex or self.oldRound ~= nil and curRound > self.oldRound) then
		local newGetRewards = smeltCtrl:getNewGetRewards(self.oldRound, self.oldValue, curRound, curValue, smeltCtrl:getIsBuy())
		self:showBoxAddTips(newGetRewards)
	end
	self.oldIndex = curBoxIndex
	self.oldValue = curValue
	local isFinish = smeltCtrl:getIsFinish()
	if self.oldRound ~= nil and curRound > self.oldRound and not isFinish then
		self:showNewRound(curRound)
	end
	self.oldRound = curRound
	self.loadingBar:setPercent(curValue / maxValue * 100)
end
function smeltMainView:updateEquip()
	self.choosedEquip = smeltCtrl:getChooseID()
	self:setShowNode()
	if self.choosedEquip == nil or self.choosedEquip == 0 then
		return
	end
	local equipIcon = SoraDGetChildByName(self, "Node_Equip_bg")
	local itemNum = SoraDGetChildByName(self, "Text_equip_num")
	equipIcon:setSpriteFrame("frame_square_36.png")
	local item = SoraDGetChildByName(equipIcon, "Node_Item")
	if item == nil then
		item = SoraDPopItemAward()
		item:setName("Node_Item")
		item:addTo(equipIcon)
		item:setBaseScale(1)
		item:setScale(1.5)
		item:setPosition(65, 82)
		item:setOwnView(self)
		item.Image_itemBg:setVisible(false)
		item.Image_quality:setVisible(false)
		item.Image_itemBar:setVisible(false)
		item.Image_frm:setVisible(false)
		item.Image_icon:setVisible(false)
		self.rewardItem = item
	end
	if smeltCtrl:getCurRound() == 1 or not smeltCtrl:getOtherReward(smeltCtrl:getCurRound(), smeltCtrl:getIsBuy()) then
		smeltCtrl = smeltCtrl:getOtherReward(smeltCtrl:getCurRound(), smeltCtrl:getIsBuy())
		smeltCtrl:getOtherReward(smeltCtrl:getCurRound(), smeltCtrl:getIsBuy()).id = self.choosedEquip
		local smeltCtrl:getOtherReward(smeltCtrl:getCurRound(), smeltCtrl:getIsBuy()).count, otherReward = smeltCtrl:getChooseNum(), smeltCtrl:getOtherReward(smeltCtrl:getCurRound(), smeltCtrl:getIsBuy())
	end
	if not otherReward then
		item:setVisible(false)
	else
		item:initData(otherReward.id, otherReward.count)
		equipIcon:setSpriteFrame(publicRead.getIcon(otherReward.id))
		equipIcon:setContentSize(cc.size(130, 120))
	end
	self:updateRedPoint()
end
function smeltMainView:onGetMore(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("smeltItemGet"):show()
	end
end
function smeltMainView:onStart(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if smeltCtrl:getIsFinish() then
			SoraDShowMsgTip(i18n("Smelt_text_37"))
			return
		end
		local items = smeltRead:getItems()
		if smeltCtrl:getItemCount(items[1].itemID) <= 0 and 0 >= smeltCtrl:getItemCount(items[2].itemID) then
			local tip = i18n("Smelt_text_35")
			SoraDShowMsgBoxNew(tip, i18n("common_text_477"), nil, function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				SoraDCreatePanel("smeltItemGet"):show()
			end)
		else
			self.smeltUse:btnClickCallBack(button, eventType)
		end
	end
end
function smeltMainView:onChoose(button, eventType)
	if eventType == ccui.TouchEventType.ended and not self.isShowing then
		SoraDPlaySound()
		SoraDCreatePanel("smeltChoose"):show()
	end
end
function smeltMainView:onHelp(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Smelt_text_01"
		;("Smelt_text_01").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Smelt_text_01"), "Smelt_text_01")
	end
end
function smeltMainView:onShowReward(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("smeltRewardPool"):show()
	end
end
function smeltMainView:onRewardPoolUp(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("smeltRewardPoolUp"):show()
	end
end
function smeltMainView:onTask(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("smeltTaskPopView"):show()
	end
end
function smeltMainView:onShowBoxReward(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local curRewards = smeltCtrl:getCurRewards()
		local tag = button:getTag()
		local view = SoraDCreatePanel("smeltReward")
		view:initData(curRewards[tag])
		view:show()
	end
end
function smeltMainView:onNotify(target, data)
	if not self.oldIsBuy and smeltCtrl:getIsBuy() then
		self:updateBg(true)
	end
	self:updateView()
end
function smeltMainView:showGetValue(target, data)
	local equipIcon = SoraDGetChildByName(self, "Node_Equip_bg")
	if not self.criSps then
		self.criSps, _ENV = self.criSps, self.criSps
	end
	local valueEf = cc.criSprite.createCriSprite("G_sp_qcbl_005.usm", false, false)
	valueEf:setCompleteCallback(function()
		valueEf:removeFromParent()
		for k, v in ipairs(self.criSps) do
			if v == valueEf then
				table.remove(self.criSps, k)
			end
		end
	end)
	valueEf:setPosition(equipIcon:getPosition())
	valueEf:addTo(equipIcon:getParent(), 100)
	valueEf:setBlendFunc(gl.ONE, gl.ONE)
	table.insert(self.criSps, valueEf)
	if #self.criSps > 4 then
		local sp = self.criSps[1]
		sp:removeFromParent()
		table.remove(self.criSps, 1)
	end
	local valueEf2 = cc.criSprite.createCriSprite("G_sp_qcbl_003.usm", false, false)
	valueEf2:setCompleteCallback(function()
		valueEf2:removeFromParent()
		for k, v in ipairs(self.criSps) do
			if v == valueEf2 then
				table.remove(self.criSps, k)
			end
		end
	end)
	valueEf2:setPosition(self.loadingBar:getPosition(), self.loadingBar:getPositionY() - 82)
	valueEf2:addTo(self.loadingBar:getParent(), 100)
	valueEf2:setBlendFunc(gl.ONE, gl.ONE)
	table.insert(self.criSps, valueEf2)
	if #self.criSps > 4 then
		local sp = self.criSps[1]
		sp:removeFromParent()
		table.remove(self.criSps, 1)
	end
	_ENV = self.criSps
	self.criSps.text = "x" .. data.data.addValue
	self.criSps.actType = data.data.isCrit
	self:SoraDCreateWaveBMP(self.criSps)
	self:stopAllActions()
	_UPVALUE1_ = data.data.isCrit
	data.data.isCrit[1] = cca.delay(0.5)
	data.data.isCrit[2] = cca.callFunc(function()
		self:updateBox()
	end)
	data.data.isCrit[3] = cca.callFunc(function()
		self:updateBox()
	end)
	self:runAction(cca.seq(data.data.isCrit))
	self:refreshItem()
	self:updateEquip()
	self.smeltUse:continueLongPress()
end
function smeltMainView:onChooseEquip(target, data)
	self:updateEquip()
	if self.oldEuqipId ~= self.choosedEquip then
		local equipIcon = SoraDGetChildByName(self, "Node_Equip_bg")
		self.oldEuqipId = self.choosedEquip
		local equipEf = cc.criSprite.createCriSprite("G_sp_qcbl_008.usm", true)
		equipEf:setPosition(equipIcon:getPosition())
		equipEf:addTo(equipIcon:getParent(), 100)
		equipEf:setBlendFunc(gl.ONE, gl.ONE)
	end
end
function smeltMainView:showBoxAddTips(rewards, posY)
	if table.nums(rewards) <= 0 then
		return
	end
	self.tablePackItem, _ENV, self.itemList = table.nums(rewards), table.nums(rewards), rewards
	local _ENV, tempTable = table.nums(rewards), table.nums(rewards)
	posY = posY and posY or display.height - 150
	for i, v in ipairs(self.itemList) do
		table.insert(tempTable, v)
	end
	for index, value in ipairs(tempTable) do
		_ENV = table.insert
		table.insert.x = -320 - #tempTable / 2 * 50 + (index * 2 - 1) * 50
		value.pos, table.insert.y = table.insert, posY + math.ceil(#self.itemList / 5) * 100 - #tempTable / 5 * 100
		table.insert(self.tablePackItem, value)
	end
	if next(tempTable) ~= nil then
		for i, v in ipairs(tempTable) do
			_ENV = table.insert
			table.insert.x = -320 + -#tempTable * 100 / 2 + (i * 2 - 1) * 50
			v.pos, table.insert.y = table.insert, posY
			table.insert(self.tablePackItem, v)
		end
	end
	for i, v in ipairs(self.tablePackItem) do
		local item = SoraDPopItemAward()
		item:setScale(0.1)
		item:setPosition(-320, posY - 100)
		item:addTo(self.btn_reward:getParent())
		item:initData(v.id, v.count)
		_UPVALUE2_ = item.initData
		_UPVALUE1_ = v.count
		v.count[1] = cc.EaseExponentialIn:create(cca.moveTo(0.5, self.btn_reward:getPositionX(), self.btn_reward:getPositionY()))
		v.count[2] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[3] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[4] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[5] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[6] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[7] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		item.initData[1] = cca.delay(0.6)
		item.initData[2] = cca.spawn(v.count)
		item.initData[3] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[4] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[5] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[6] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[7] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[8] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[9] = cca.callFunc(function()
			item:removeFromParent()
		end)
		local item.initData[10], action = cca.callFunc(function()
			item:removeFromParent()
		end)
		_UPVALUE1_ = cca.callFunc(function()
			item:removeFromParent()
		end)
		cca.callFunc(function()
			item:removeFromParent()
		end)[1] = cc.MoveTo:create(0.5, v.pos)
		cca.callFunc(function()
			item:removeFromParent()
		end)[2] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[3] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[4] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[5] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[6] = cca.scaleTo(0.5, 0.9)
		_ENV = cca.callFunc(function()
			item:removeFromParent()
		end)
		cca.callFunc(function()
			item:removeFromParent()
		end).easing = "BACKOUT"
		transition.execute(item, cca.spawn(cca.callFunc(function()
			item:removeFromParent()
		end)), cca.callFunc(function()
			item:removeFromParent()
		end))
		local seq = cca.seq(action)
		item:runAction(seq)
	end
	self:showWaggleEffect()
end
function smeltMainView:showNewRound(curRound)
	self.roundShowLabel:setString(curRound)
	self.roundShowNode:stopAllActions()
	self.roundShowNode:setVisible(true)
	self.roundShowNode:setCascadeOpacityEnabled(true)
	self.roundShowNode:setOpacity(0)
	SoraDToCenter(self.roundShowNode, 5, false)
	_UPVALUE4_ = false
	;(false)[1] = cca.delay(1.05)
	;(false)[2] = cca.fadeIn(0.1)
	;(false)[3] = cca.delay(1.2)
	;(false)[4] = cca.fadeOut(0.2)
	;(false)[5] = cca.callFunc(function()
		self.roundShowNode:setVisible(false)
	end)
	;(false)[6] = cca.callFunc(function()
		self.roundShowNode:setVisible(false)
	end)
	self.roundShowNode:runAction(cca.seq(false))
	if self.oldRound == 1 then
		local equipIcon = SoraDGetChildByName(self, "Node_Equip_bg")
		self.oldEuqipId = self.choosedEquip
		local equipEf = cc.criSprite.createCriSprite("G_sp_qcbl_008.usm", true)
		equipEf:setPosition(equipIcon:getPosition())
		equipEf:addTo(equipIcon:getParent(), 100)
		equipEf:setBlendFunc(gl.ONE, gl.ONE)
		_ENV, smeltCtrl = gl.ONE, gl.ONE
		gl.ONE.id = smeltCtrl:getChooseID()
		gl.ONE.count = smeltCtrl:getChooseNum()
		gl.ONE[1] = gl.ONE
		self:showBoxAddTips(gl.ONE, display.height / 2 + 155)
	end
end
function smeltMainView:showWaggleEffect()
	self.btn_reward:stopAllActions()
	_UPVALUE6_ = self.btn_reward
	self.btn_reward[1] = cca.delay(2)
	self.btn_reward[2] = cca.rotateTo(0.25, 10)
	self.btn_reward[3] = cca.rotateTo(0.21666666666666667, -10)
	self.btn_reward[4] = cca.rotateTo(0.2, 8)
	self.btn_reward[5] = cca.rotateTo(0.16666666666666666, -5)
	self.btn_reward[6] = cca.rotateTo(0.15, 2)
	self.btn_reward[7] = cca.rotateTo(0.15, 0)
	self.btn_reward[8] = cca.rotateTo(0.15, 0)
	self.btn_reward[9] = cca.rotateTo(0.15, 0)
	local seq = cca.seq(self.btn_reward)
	self.btn_reward:runAction(seq)
end
function smeltMainView:SoraDCreateWaveBMP(actionData)
	local _ENV, text = nil, actionData.text or "NA"
	;(nil).color = cc.c3b(255, 255, 0)
	;(nil).fontSize = 18
	;(nil).pos = cc.p(0, 0)
	;(nil).zOrder = 10
	;(nil).duration = 0.4
	;(nil).moveH = 155
	;(nil).scale = 1.2
	local (nil).font, param = "res/fonts/baojishuzi0-9.fnt", nil
	local waveLabel
	if #self.tableEXPLabelSpare >= 20 then
		waveLabel = table.remove(self.tableEXPLabelSpare, 1)
		waveLabel:stopAllActions()
		waveLabel:setOpacity(255)
		waveLabel:setVisible(true)
		waveLabel:setString(text)
	else
		_ENV = waveLabel
		waveLabel.text = text
		waveLabel.font = param.font
		waveLabel = display.newBMFontLabel(waveLabel)
		waveLabel:addTo(self.center_node, param.zOrder)
	end
	table.insert(self.tableEXPLabelSpare, waveLabel)
	waveLabel:setCascadeColorEnabled(false)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(param.pos)
	local baseScale = param.scale
	if actionData.actType == 1 then
		SoraDCreatAnimation("petEffectbj", self.et_center_node, false)
		waveLabel:setScale(0.1 * baseScale)
		waveLabel:setOpacity(0)
		_UPVALUE6_ = waveLabel
		_UPVALUE1_ = 0.24
		;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
		;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
		waveLabel[1] = cca.delay(0.06666666666666667)
		waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
		waveLabel[3] = cca.spawn(0.24)
		waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
		waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
		waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
		waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		local seqPrepare = cca.seq(waveLabel)
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local fadeTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = fadeTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE3_ = fadeTo
		fadeTo[1] = seqPrepare
		fadeTo[2] = spawn
		fadeTo[3] = callFunc
		local seq = cca.seq(fadeTo)
		waveLabel:runAction(seq)
		self:showCritical(param)
	else
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local tintTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = tintTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE2_ = tintTo
		tintTo[1] = spawn
		tintTo[2] = callFunc
		local seq = cca.seq(tintTo)
		waveLabel:runAction(seq)
	end
	return waveLabel
end
function smeltMainView:showCritical(param)
	if not self.spCritical then
		local spName = SoraDFIsRA() and "#baojialabo.png" or "#baojiyingwen.png"
		self.spCritical = display.newSprite(spName)
		self.spCritical:setName("spCritical")
		self.spCritical:addTo(self.center_node, 13)
		self.spCritical:setPosition(cc.p(0, -50))
	else
		self.spCritical:setVisible(true)
	end
	local baseScale = param.scale
	self.spCritical:setScale(0.1 * baseScale)
	self.spCritical:setOpacity(0)
	_UPVALUE6_ = self.spCritical
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	self.spCritical[1] = cca.delay(0.06666666666666667)
	self.spCritical[2] = cca.fadeTo(0.016666666666666666, 0.24)
	self.spCritical[3] = cca.spawn(0.24)
	self.spCritical[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	self.spCritical[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	self.spCritical[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	self.spCritical[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(self.spCritical)
	_UPVALUE2_ = cca.delay(0.06666666666666667)
	cca.delay(0.06666666666666667)[1] = seqPrepare
	cca.delay(0.06666666666666667)[2] = cca.delay(param.duration * 0.5)
	cca.delay(0.06666666666666667)[3] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[4] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[5] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[6] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[7] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[8] = cca.fadeOut(param.duration * 0.6)
	local seqAct = cca.seq((cca.delay(0.06666666666666667)))
	self.spCritical:stopAllActions()
	self.spCritical:runAction(seqAct)
end
return smeltMainView
