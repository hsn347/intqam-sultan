local publicRead = include("publicRead")
local sinbadTreasureRead = include("sinbadTreasureRead")
local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local sinbadTreasureStageTwoView = class("sinbadTreasureStageTwoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sinbadTreasureStageTwoView")
	end
	return target
end)
_UPVALUE5_ = "sinbadTreasureStageTwoView"
_UPVALUE4_, ("sinbadTreasureStageTwoView")[1] = "01jiebx_01.png", "01jiebx_01.png"
_UPVALUE4_, ("sinbadTreasureStageTwoView")[2] = "01jiebx_01.png", "02jiebx_01.png"
_UPVALUE4_, ("sinbadTreasureStageTwoView")[3] = "01jiebx_01.png", "04jiebx_01.png"
_UPVALUE4_, ("sinbadTreasureStageTwoView")[4] = "01jiebx_01.png", "05jiebx_01.png"
local _UPVALUE4_, ("sinbadTreasureStageTwoView")[5], boxImage = "01jiebx_01.png", "03jiebx_01.png", "sinbadTreasureStageTwoView"
;("01jiebx_01.png")[1] = cc.size(320, 260)
;("01jiebx_01.png")[2] = cc.size(320, 260)
;("01jiebx_01.png")[3] = cc.size(420, 350)
;("01jiebx_01.png")[4] = cc.size(500, 420)
;("01jiebx_01.png")[5] = cc.size(460, 450)
;("01jiebx_01.png")[6] = cc.size(460, 450)
local ("01jiebx_01.png")[7], boxSize = cc.size(460, 450)
function sinbadTreasureStageTwoView:ctor()
	self.itemID = tonumber(include("constantRead").getConstValue("SINBAD_TREASURE_ITEM", 730101))
	self:initControls()
	self:fitDevice()
end
function sinbadTreasureStageTwoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_INIT", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
		self:initBoxRewardList()
	end)
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_KEY_ROTTERY_REWARD_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		if self.isSkip then
			if data.rewardList and next(data.rewardList) then
				if data.num > 1 then
					_ENV = nil
					;(nil).isArray = true
					SoraDOpenGiftView(data.rewardList, nil)
				else
					SoraDMailGainItems(data.rewardList, true)
				end
			end
			self.Button_one:setEnabled(true)
			self.Button_ten:setEnabled(true)
			self:initData()
		else
			self.Button_box_reward:setVisible(false)
			self:isPlayOpenBox(true)
			_UPVALUE3_ = nil
			;(nil)[1] = cca.delay(1.5)
			;(nil)[2] = cca.callFunc(function(...)
				if data.rewardList and next(data.rewardList) then
					if data.num > 1 then
						data = nil
						;(nil).isArray = true
						SoraDOpenGiftView(data.rewardList, nil)
					else
						self:playOneRewardPop(data.rewardList[1])
					end
				end
				self.effectDropGold:setVisible(false)
				self.Button_box_reward:setVisible(true)
				self:initData()
			end)
			;(nil)[3] = cca.delay(1.2)
			;(nil)[4] = cca.callFunc(function(...)
				self.Button_one:setEnabled(true)
				self.Button_ten:setEnabled(true)
			end)
			;(nil)[5] = cca.callFunc(function(...)
				self.Button_one:setEnabled(true)
				self.Button_ten:setEnabled(true)
			end)
			self:runAction(cca.seq(nil))
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_EXTRA_REWARD_REFRESH", function(target, data)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function sinbadTreasureStageTwoView:playOneRewardPop(reward)
	if reward and next(reward) then
		local showItem
		showItem = include("commonItemAward").new()
		showItem:initData(reward.id, reward.count)
		showItem:setScale(0.8)
		showItem:setTouchEnabled(false)
		local pos = cc.p(self.Button_box_reward:getPositionX() - 50, self.Button_box_reward:getPositionY())
		showItem:setPosition(pos.x, pos.y)
		showItem:addTo(self.Node_box, 2)
		_UPVALUE5_ = showItem.addTo
		showItem.addTo[1] = cc.EaseExponentialOut:create(cca.moveTo(0.5, 0, 150))
		showItem.addTo[2] = cca.delay(1)
		showItem.addTo[3] = cc.EaseExponentialIn:create(cca.moveTo(0.5, 0, -1000))
		showItem.addTo[4] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.25))
		showItem.addTo[5] = cca.delay(0.25)
		showItem.addTo[6] = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		showItem.addTo[7] = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		local showItem.addTo[8], action = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		local seq = cca.seq(action)
		showItem:runAction(seq)
	end
end
function sinbadTreasureStageTwoView:fitDevice(...)
	self.Size_Tile_Image_bg:setHeight(1386)
	if device.isIphoneXMode() then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 320)
		return
	end
	if display.height > 1136 then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 340)
		return
	end
	if display.height > 960 then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 180)
	elseif display.height <= 960 then
		self.frame_text_ins_two:setVisible(false)
	end
end
function sinbadTreasureStageTwoView:isPlayOpenBox(isPlay)
	if isPlay then
		local activityData = sinbadTreasureCtrl:getActivityData()
		if self.effectDropGold then
			SoraDResetEffectNode(self.effectDropGold)
			self.effectDropGold:setVisible(true)
			self.effectDropGold.action:gotoFrameAndPlay(0, 121, false)
		else
			self.effectDropGold = SoraDCreatAnimationEx("Node_Effect_xbdmz02", nil, false)
			self.effectDropGold:setPosition(cc.p(30, -90))
			self.effectDropGold:addTo(self.Node_box, 1)
		end
		local sprite_box_1 = SoraDGetChildByName(self.effectDropGold, "sprite_box_1")
		local sprite_box_2 = SoraDGetChildByName(self.effectDropGold, "sprite_box_2")
		local sprite_box_3 = SoraDGetChildByName(self.effectDropGold, "sprite_box_3")
		local sprite_box_4 = SoraDGetChildByName(self.effectDropGold, "sprite_box_4")
		local sprite_box_5 = SoraDGetChildByName(self.effectDropGold, "sprite_box_5")
		sprite_box_1:setVisible(activityData.notifiedKingdomDecorateLv == 1)
		sprite_box_2:setVisible(activityData.notifiedKingdomDecorateLv == 2)
		sprite_box_3:setVisible(activityData.notifiedKingdomDecorateLv == 3)
		sprite_box_4:setVisible(activityData.notifiedKingdomDecorateLv == 4)
		sprite_box_5:setVisible(activityData.notifiedKingdomDecorateLv == 5)
	elseif self.effectDropGold then
		self.effectDropGold:setVisible(false)
	end
end
function sinbadTreasureStageTwoView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001349"))
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
	self.btnHelpTip:addTouchEventListener(handler(self, self.btnTipClick))
	self.Button_add:addTouchEventListener(handler(self, self.btnAddClick))
	self.Button_one:addTouchEventListener(handler(self, self.btnOneClick))
	self.Button_ten:addTouchEventListener(handler(self, self.btnTenClick))
	self.Image_104:addTouchEventListener(handler(self, self.btnExtraClick))
	self.Button_rank:addTouchEventListener(handler(self, self.btnRankClick))
	self.Text_ten_need:setString(10)
	self.Text_one_need:setString(1)
	self.Text_ten = SoraDChangeTextToHtml(self.Text_ten)
	self.Text_one = SoraDChangeTextToHtml(self.Text_one)
	self.Text_time = SoraDChangeTextToHtml(self.Text_time)
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			_ENV, _ENV, (nil).time = nil, nil, ticket
			_ENV, (nil).time, (nil).color = nil, nil, "#5AB440"
			;(nil).__default, (nil).color = nil, "#FFC864"
			return i18n_html("Sinbad_text_15", nil, nil)
		end)
		self.Text_time:setTimeEndListener(function()
		end)
		self.Text_time:beginTime(leftTime)
		self.icon_hourglass_10:setPositionX(self.Text_time:getPositionX() + SoraDFSign(self.Text_time:getContentSize().width / 2) + SoraDFSign(30))
	end
	self.Text_own_rice:setString(i18n("Sinbad_text_19"))
	self.Sprite_icon_one:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.Sprite_icon:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.Sprite_icon_ten:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.Text_rank:setString(i18n("common_text_851"))
	self.tableOpenReward = SoraDGetChildsArrayByName(self.Node_box, "btn_reward_", 8, 1)
	self.tableImageNode = SoraDGetChildsArrayByName(self.Node_box, "Image_reward_", 8, 1)
	for i, v in ipairs(self.tableOpenReward) do
		v:addTouchEventListener(handler(self, self.OnTreasureClick))
	end
	self.tableMapPiece = SoraDGetChildsArrayByName(self, "bg_map_", 5, 1)
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(false)
	end
	self.Com_skip = fguiHelper.createObject("CommonUI", "UI_Com_skip")
	self.Com_skip:setPosition(cc.p(-300, -300))
	self.Com_skip:addTo(self.Bottom_node, 9)
	_ENV = self.Bottom_node
	self.Bottom_node.byUID = true
	self.isSkip = SoraDConfigGet("Game:sinbadTreasure:switch~bool", self.Bottom_node) or false
	self.Com_skip:initData(self.isSkip, nil, handler(self, self.onClickSkip))
	sinbadTreasureCtrl:reqInitInfo()
	SoraDShowLoading(self)
end
function sinbadTreasureStageTwoView:onClickSkip(ret)
	self.isSkip = ret
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:sinbadTreasure:switch~bool", self.isSkip, nil)
end
function sinbadTreasureStageTwoView:initData()
	local activityData = sinbadTreasureCtrl:getActivityData()
	local kingdomPoint = activityData.kingdomDecoratePoint
	local selfPoint = activityData.selfDecoratePoint
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	local rankData = sinbadTreasureRead.getRankData(1, sinbadTreasureCtrl:getClassType())
	local blessTimes = activityData.selfBlessingNum
	local num, nextNum = sinbadTreasureCtrl:getNextBlessRewardNum()
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(i <= activityData.notifiedKingdomDecorateLv)
	end
	self.Button_box_reward:loadTextures(boxImage[activityData.notifiedKingdomDecorateLv], boxImage[activityData.notifiedKingdomDecorateLv], boxImage[activityData.notifiedKingdomDecorateLv], ccui.TextureResType.plistType)
	self.Button_box_reward:setContentSize(boxSize[activityData.notifiedKingdomDecorateLv])
	print("slkdjfslkdjflsjdf", num)
	self.Text_own_rice_num:setString(string.formatnumberthousands(itemCount))
	if not (0 < num) or not i18n("return_lcks_text_025") then
		sinbadTreasureCtrl = string.formatnumberthousands(itemCount)
		string.formatnumberthousands(itemCount).var = nextNum
	end
	self.Text_five_ins:setString((i18n("Sinbad_text_16", string.formatnumberthousands(itemCount))))
	self.Image_redPoint:setVisible(0 < num)
	self.Text_redPointInt:setString(num)
	self.Image_104:setPositionX(self.Text_five_ins:getPositionX() - SoraDFSign(self.Text_five_ins:getContentSize().width / 2) - SoraDFSign(40))
	self.Node_effect_top:setPositionX(self.Text_five_ins:getPositionX() - SoraDFSign(self.Text_five_ins:getContentSize().width / 2) - SoraDFSign(40))
	self.Node_effect_bg:setPositionX(self.Text_five_ins:getPositionX() - SoraDFSign(self.Text_five_ins:getContentSize().width / 2) - SoraDFSign(40))
	self.Button_add:setPositionX(self.Text_own_rice_num:getPositionX() - SoraDFSign(self.Text_own_rice_num:getContentSize().width) - SoraDFSign(30))
	self:boxRotation(0 < num)
	local redColor1 = 0 < itemCount and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0)
	local redColor2 = 9 < itemCount and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0)
	sinbadTreasureCtrl = string.formatnumberthousands(itemCount)
	sinbadTreasureCtrl, sinbadTreasureCtrl, string.formatnumberthousands(itemCount).num = string.formatnumberthousands(itemCount)
	sinbadTreasureCtrl, string.formatnumberthousands(itemCount).num, string.formatnumberthousands(itemCount).color = string.formatnumberthousands(itemCount)
	string.formatnumberthousands(itemCount).__default, string.formatnumberthousands(itemCount).color = string.formatnumberthousands(itemCount)
	self.Text_one:setString(i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount)))
	sinbadTreasureCtrl = i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount))
	sinbadTreasureCtrl, sinbadTreasureCtrl, i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount)).num = i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount))
	sinbadTreasureCtrl, i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount)).num, i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount)).color = i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount))
	i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount)).__default, i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount)).color = i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount))
	self.Text_ten:setString(i18n_html("Pyramid_treasure_btn_01", i18n_html("Pyramid_treasure_btn_01", string.formatnumberthousands(itemCount))))
end
function sinbadTreasureStageTwoView:initBoxRewardList()
	local activityData = sinbadTreasureCtrl:getActivityData()
	local boxInfo = sinbadTreasureRead.getStageRewardInfo(sinbadTreasureCtrl:getClassType())
	local curBoxInfo = boxInfo[activityData.notifiedKingdomDecorateLv]
	publicRead = sinbadTreasureCtrl:getClassType()
	sinbadTreasureCtrl:getClassType()[1] = "id"
	sinbadTreasureCtrl:getClassType()[2] = "count"
	sinbadTreasureCtrl:getClassType()[3] = "rate"
	local rewardList = serviceFunctions.tableFormat(curBoxInfo.lotteryValue, sinbadTreasureCtrl:getClassType())
	for i, v in ipairs(rewardList) do
		self.tableImageNode[i]:setSpriteFrame(publicRead.getIcon(v.id))
		self.tableImageNode[i]:setScale(0.8)
	end
	for i, v in ipairs(rewardList) do
		self.tableOpenReward[i]:setEnabled(true)
		self.tableOpenReward[i]:setTag(v.id)
	end
end
function sinbadTreasureStageTwoView:boxRotation(isRotation)
	self.Image_104:stopAllActions()
	self.Image_104:setRotation(0)
	if isRotation then
		_UPVALUE6_ = self.Image_104
		self.Image_104[1] = cca.rotateTo(0.25, 12)
		self.Image_104[2] = cca.rotateTo(0.2, -8)
		self.Image_104[3] = cca.rotateTo(0.18333333333333332, 6)
		self.Image_104[4] = cca.rotateTo(0.15, -3)
		self.Image_104[5] = cca.rotateTo(0.15, 1)
		self.Image_104[6] = cca.rotateTo(0.15, 0)
		self.Image_104[7] = cca.delay(0.25)
		self.Image_104[8] = cca.delay(0.25)
		local seq_rotate = cca.seq(self.Image_104)
		self.Image_104:runAction(cc.RepeatForever:create(seq_rotate))
	end
	self.Node_effect_top:setVisible(isRotation)
	self.Node_effect_bg:setVisible(isRotation)
	self.Text_box_can_get:setVisible(isRotation)
end
function sinbadTreasureStageTwoView:btnOneClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local activityData = sinbadTreasureCtrl:getActivityData()
		local level = activityData.activityStage + 1
		local itemCount = backpackCtrl:getItemCount(self.itemID)
		if itemCount <= 0 then
			SoraDShowMsgTip(i18n("Lamp_secret_text_07"))
			return
		end
		if 2 < level then
			SoraDShowMsgTip(i18n("Sinbad_text_18"))
			SoraDRemoveAllExceptPanelFromManager(SoraDSearchPanelFromManagerByName("EventCenterView"))
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
			return
		end
		self.Button_one:setEnabled(false)
		self.Button_ten:setEnabled(false)
		sinbadTreasureCtrl:reqStageTwoReward(1)
		SoraDShowLoading(self)
	end
end
function sinbadTreasureStageTwoView:btnTenClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local activityData = sinbadTreasureCtrl:getActivityData()
		local level = activityData.activityStage + 1
		local itemCount = backpackCtrl:getItemCount(self.itemID)
		if itemCount <= 9 then
			SoraDShowMsgTip(i18n("Lamp_secret_text_07"))
			return
		end
		if 2 < level then
			SoraDShowMsgTip(i18n("Sinbad_text_18"))
			SoraDRemoveAllExceptPanelFromManager(SoraDSearchPanelFromManagerByName("EventCenterView"))
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
			return
		end
		self.Button_one:setEnabled(false)
		self.Button_ten:setEnabled(false)
		sinbadTreasureCtrl:reqStageTwoReward(10)
		SoraDShowLoading(self)
	end
end
function sinbadTreasureStageTwoView:btnExtraClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sinbadTreasureExtraView")
		panel:initData()
		panel:show()
	end
end
function sinbadTreasureStageTwoView:btnRankClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sinbadTreasureRankView")
		panel:show()
	end
end
function sinbadTreasureStageTwoView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Sinbad_text_04"
		;("Sinbad_text_04").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Sinbad_text_04"), "Sinbad_text_04")
	end
end
function sinbadTreasureStageTwoView:btnAddClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _ENV, giftList = SoraDPlaySound, SoraDPlaySound
		if IsArClient then
			_UPVALUE3_ = IsArClient
			giftList, IsArClient[1] = IsArClient, 13308
			giftList, IsArClient[2] = IsArClient, 13309
			giftList, IsArClient[3] = IsArClient, 13341
		else
			_UPVALUE3_ = IsArClient
			giftList, IsArClient[1] = IsArClient, 14616
			giftList, IsArClient[2] = IsArClient, 14617
			giftList, IsArClient[3] = IsArClient, 14618
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 14618
			;(14618).rechargeIDList = giftList
			uiManager:show("rechargeView", 14618)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftList)
			panel:show()
		end
	end
end
function sinbadTreasureStageTwoView:OnTreasureClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCloseCommonTips()
	elseif eventType == ccui.TouchEventType.began then
		SoraDPlaySound()
		SoraDShowCommonTips(button, button:getTag())
	end
end
function sinbadTreasureStageTwoView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	else
		SoraDRemoveAllAfterPanelFromManager(self)
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
	end
end
return sinbadTreasureStageTwoView
