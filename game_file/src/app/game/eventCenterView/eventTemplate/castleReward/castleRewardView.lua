local cityCtrl = SoraDGetCtrl("cityCtrl")
local castleRewardCtrl = SoraDGetCtrl("castleRewardCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local castleRewardRead = include("castleRewardRead")
local mainUIDef = include("mainUIDef")
local castleRewardView = class("castleRewardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("castleRewardView")
	end
	return target
end)
function castleRewardView:ctor()
	self.cellList, castleRewardCtrl, self.isHideCurrentSceneView = nil, nil, true
	castleRewardCtrl:reqInit()
	SoraDShowLoading(self)
	self:initControls()
	self:initEffect()
end
function castleRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CASTLE_REWARD_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CASTLE_REWARD_GET_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CASTLE_REWARD_GET_ALL_REWARD", handler(self, self.initData))
end
function castleRewardView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001342"))
	self.activityID = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY
	self.Button_receive:setTitleText(i18n("ice_carnival_text05"))
	self.Text_lv:setString(i18n("common_text_4488"))
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeProBarPreview:setLocalZOrder(1)
	self.nodeProBarPreview:setVisible(false)
	self.Button_receive:addTouchEventListener(handler(self, self.buttonGetRewardCallBack))
	self.Button_receive:setTouchEnabled(false)
	self.Button_receive:setBright(false)
	self.Receive_effect:setVisible(false)
	self.Button_buy:addTouchEventListener(handler(self, self.buttonGetGodRewardGift))
	self.Button_buy:setVisible(false)
	self.Text_1:setString(i18n("cityUp_title_01"))
	self.Text_buy:setString(i18n("common_text_740"))
	self.Text_isBuy:setString(i18n("common_text_2943"))
	self.Top_Size_ScrollView:addEventListener(handler(self, self.scrollEventCallBack))
	for i = 1, 12 do
		local text_node = display.newNode()
		text_node:setGroupID(mainUIDef.uiGroupID.group_award_item + i, true)
		text_node:addTo(self.Top_Size_ScrollView, 12)
	end
	for i = 24, 25 do
		local text_node = display.newNode()
		text_node:setGroupID(mainUIDef.uiGroupID.group_award_item + i, true)
		text_node:addTo(self.Top_Size_ScrollView, 12)
	end
	self.btnHelpTip:addTouchEventListener(handler(self, self.buttonHelp))
	self.beginPercent = 1
	_UPVALUE2_ = handler(self, self.buttonHelp)
	handler(self, self.buttonHelp)[1] = "ar"
	handler(self, self.buttonHelp)[2] = "en"
	self.Image_gold_title:setSpriteFrame(SoraDGetImageNameByLang("font_groupUp_castle_supreme_%s.png", handler(self, self.buttonHelp)))
	_UPVALUE2_ = SoraDGetImageNameByLang("font_groupUp_castle_supreme_%s.png", handler(self, self.buttonHelp))
	SoraDGetImageNameByLang("font_groupUp_castle_supreme_%s.png", handler(self, self.buttonHelp))[1] = "ar"
	SoraDGetImageNameByLang("font_groupUp_castle_supreme_%s.png", handler(self, self.buttonHelp))[2] = "en"
	self.Image_normal_title:setSpriteFrame(SoraDGetImageNameByLang("font_groupUp_castle_ordinary_%s.png", SoraDGetImageNameByLang("font_groupUp_castle_supreme_%s.png", handler(self, self.buttonHelp))))
	self:initGoldReward()
	if not SoraDFIsRA() then
		print("======= Node_getGold:setScaleX")
		self.beijing02_1:setFlippedX(false)
		self.beijing02_1:getChildByName("icon"):setFlippedX(true)
	end
end
function castleRewardView:initEffect()
	local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(1.65)
	;(nil)[2] = cca.callFunc(function()
		effectAction:gotoFrameAndPlay(100, 200, true)
	end)
	;(nil)[3] = cca.callFunc(function()
		effectAction:gotoFrameAndPlay(100, 200, true)
	end)
	self:runAction(cca.seq(nil))
end
function castleRewardView:initData()
	SoraDCloseLoading(self)
	local begin = socket:gettime()
	local isBuy = castleRewardCtrl:getIsBuy()
	self.Button_buy:setVisible(not isBuy)
	self.Text_isBuy:setVisible(isBuy)
	self.icon_lock_gold_6:setVisible(not isBuy)
	self:initScroll()
	print(string.format("total time:%.2fms\n", (socket:gettime() - begin) * 1000))
end
function castleRewardView:initGoldReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local goldRewards = serviceFunctions.tableFormat(castleRewardRead.getGoldShowReward(), nil)
	_UPVALUE3_ = castleRewardRead.getGoldShowReward()
	castleRewardRead.getGoldShowReward()[1] = self.Node_gold_reward_1
	castleRewardRead.getGoldShowReward()[2] = self.Node_gold_reward_2
	local castleRewardRead.getGoldShowReward()[3], rewardNodes = self.Node_gold_reward_3, castleRewardRead.getGoldShowReward()
	for i, v in ipairs(goldRewards) do
		local item = include("commonItemAward").new()
		item:setCascadeOpacityEnabled(true)
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:setPosition(0, 0)
		item:initData(v.id, v.count)
		item:addTo(rewardNodes[i], 1)
	end
end
function castleRewardView:initScroll()
	local cfgs = castleRewardCtrl:getCfgList()
	local curLv = SoraDGetCastleLv()
	local isBuy = castleRewardCtrl:getIsBuy()
	local sSize = self.Top_Size_ScrollView:getContentSize()
	local sH = math.max(sSize.height, #cfgs * 190 + 30 + 122)
	self.Top_Size_ScrollView:setInnerContainerSize(cc.size(sSize.width, sH))
	local isHaveCanGet = false
	local scrollToIdx = 0
	for i, v in ipairs(cfgs) do
		local cell
		if self.cellList[i] then
			cell = self.cellList[i]
		else
			cell = include("castleRewardCellSingle").new()
			cell:addTo(self.Top_Size_ScrollView, 10 - i)
			cell:playAnimation(i)
			table.insert(self.cellList, cell)
		end
		cell:setVisible(true)
		cell:setPosition(320, sH - i * 190)
		isHaveCanGet = cell:initData(self.Top_Size_ScrollView, v) or isHaveCanGet
		if isHaveCanGet and scrollToIdx == 0 then
			scrollToIdx = i
		end
	end
	for i = #cfgs + 1, #self.cellList do
		self.cellList[i]:setVisible(false)
	end
	self.nodeProBarPreview:setVisible(true)
	self.nodeProBarPreview:setPosition(320, sH)
	local LoadingBar_progress = SoraDGetChildByName(self.nodeProBarPreview, "LoadingBar_progress_fg")
	LoadingBar_progress:setContentSize(cc.size(30, sH - 50 - 122))
	LoadingBar_progress:setVisible(false)
	local progressHeight = sH - 50 - 122
	self.nodeProBarPreview:setProgressContentSize(cc.size(progressHeight, 25))
	local curIndex, curCfg, nextCfg = castleRewardCtrl:getCurIndex(curLv)
	local singlePercent = 1 / #cfgs
	local curPercent = 0
	local lastLv = curCfg and curCfg.castlelv or 0
	if nextCfg then
		curPercent = singlePercent * curIndex + singlePercent * (curLv - lastLv) / (nextCfg.castlelv - lastLv)
	elseif curCfg then
		curPercent = 1
	end
	self.nodeProBarPreview:setInitState(false)
	castleRewardCtrl = false
	;(false).maxValue = progressHeight
	;(false).curValue = curPercent * progressHeight
	self.nodeProBarPreview:setProgressDate(false)
	self.Node_Effect_ProgressHead:setPositionX(curPercent * progressHeight)
	local scrollHeight = -sSize.height + self.Top_Size_ScrollView:getInnerContainerSize().height
	if scrollToIdx == 0 then
		scrollToIdx = curIndex
	end
	local scrollPercent = 190 * (scrollToIdx - 1) / scrollHeight
	if 1 < scrollPercent then
		scrollPercent = 1
	end
	if scrollToIdx ~= 1 and 0 < scrollPercent then
		self.Top_Size_ScrollView:stopAllActions()
		_ENV = cc.size(progressHeight, 25)
		cc.size(progressHeight, 25)[1] = cca.delay(curIndex / 2 * 5 / 60)
		cc.size(progressHeight, 25)[2] = cca.callFunc(function()
			self.Top_Size_ScrollView:scrollToPercentVertical(scrollPercent * 100, 3.5 * scrollPercent, true)
		end)
		cc.size(progressHeight, 25)[3] = cca.callFunc(function()
			self.Top_Size_ScrollView:scrollToPercentVertical(scrollPercent * 100, 3.5 * scrollPercent, true)
		end)
		self.Top_Size_ScrollView:runAction(cca.seq(cc.size(progressHeight, 25)))
	end
	if isHaveCanGet then
		self.Button_receive:setTouchEnabled(true)
		self.Button_receive:setBright(true)
		self.Receive_effect:setVisible(true)
	else
		self.Button_receive:setTouchEnabled(false)
		self.Button_receive:setBright(false)
		self.Receive_effect:setVisible(false)
	end
end
function castleRewardView:buttonGetRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		castleRewardCtrl:reqGetAllReward()
	end
end
function castleRewardView:buttonGetGodRewardGift(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if castleRewardCtrl:getGiftData() == nil then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		SoraDCreatePanel("castleRewardGiftView"):show()
	end
end
function castleRewardView:buttonHelp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("cityUp_text_03"))
	end
end
function castleRewardView:scrollEventCallBack(target, event)
end
function castleRewardView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return castleRewardView
