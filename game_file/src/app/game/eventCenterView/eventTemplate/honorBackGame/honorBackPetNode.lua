local friendsCallbackRead = include("friendsCallbackRead")
local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local honorBackPetNode = class("honorBackPetNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackPetNode")
	end
	return target
end)
function honorBackPetNode:ctor()
	self.listData, friendsCallbackRead = nil, nil
	self.curPetLv = 0
	self.isUnlock = false
	self.eachLv = friendsCallbackRead.getReturnCatRewardConfig().lv
	self.itemIDFeed = 820701
	self.itemIDWalk = 820801
	self.itemFeedCost = 5
	self.itemWalkCost = 1
	self.itemFeedCount = 0
	self.itemWalkCount = 0
	self:initWidget()
	local catExpConfig = friendsCallbackRead.getReturnCatExpConfig()
	self.listData = clone(catExpConfig)
	self:refreshItemCount()
	self:refreshData()
end
function honorBackPetNode:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_INIT", function(target, data)
		SoraDCloseLoading(self)
		self:refreshData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		if data.name == "upgrade" then
			self:refreshLv()
			self:popLevelUpView(data.reward)
			self:showExpEffect()
		elseif data.name == "exp" then
			self:refreshExp()
			self:showExpEffect()
		elseif data.name == "patrol" then
			self:refreshWalk()
		elseif data.name == "unlock" then
			SoraDRemoveAllAfterPanelFromManager(self.ownView, true)
			self:afterUnlock()
			self:popUnlockView(data.reward)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_ITEM", handler(self, self.refreshItemCount))
end
function honorBackPetNode:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonScrollView")
	local _ENV, petNodeSingle = SoraDCreatePanelByCloneNode(self.scroll, "commonScrollView"), SoraDCreatePanelByCloneNode(self.scroll, "commonScrollView")
	function petNodeSingle.measureSize(data)
		if data.type == 1 then
			return cc.size(640, 84)
		else
			return cc.size(640, 112)
		end
	end
	;(nil).listData, _ENV, _ENV = nil, nil, nil
	;(nil).createNodeHandler = handler(self, self.createSingleNode)
	;(nil).nodeClass = petNodeSingle
	self.scroll:init(nil)
	self.scroll:setBounceEnabled(false)
	self.oldSize = self.Panel_cut:getContentSize()
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_HONORBACK)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.Button_info:addTouchEventListener(handler(self, self.onClickInfo))
	self.Button_award:addTouchEventListener(handler(self, self.onClickAward))
	self.Text_award:setString(i18n("return_lcks_btn_012"))
	self.Node_walking:setVisible(false)
	self.Text_walking = SoraDCreateTimerLabel(self, self.Text_walking)
	self.Text_walking:setTimeLast(function(ticket)
		return string.format([[
%s
%s]], i18n("return_lcks_text_023"), ticket)
	end)
	self.Button_receive:addTouchEventListener(handler(self, self.onClickReceive))
	self.Text_lockName:setString(i18n("pet_name_13"))
	self.Text_lvCondi:setString(i18n("return_lcks_text_014"))
	self.Button_unlock:addTouchEventListener(handler(self, self.onClickUnlock))
	SoraDGetChildByName(self.Node_level, "Text_level_title"):setString(i18n("common_text_748"))
	self.curLevel = SoraDGetChildByName(self.Node_level, "Text_level")
	self.progressExp = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.Node_cell_n:setVisible(false)
	self.Node_cell_s:setVisible(false)
	SoraDGetChildByName(self.Node_cell_title, "Text_level_title"):setString(i18n("common_text_748"))
	self.Text_youmao:setString(i18n("return_lcks_title_016"))
	self.Text_zhanmao:setString(i18n("return_lcks_title_017"))
	self.Button_feed:addTouchEventListener(handler(self, self.onClickFeed))
	self.Text_feed:setString(i18n("return_lcks_btn_019"))
	self.Button_walk:addTouchEventListener(handler(self, self.onClickWalk))
	self.Text_walk:setString(i18n("return_lcks_btn_020"))
	self.Text_walk_cost:setString(tostring(self.itemWalkCost))
	self.Button_add:addTouchEventListener(handler(self, self.onClickAdd))
	local effect = SoraDCreatAnimation("Node_Effect_lcks01")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.Node_walkReward)
	effect:setPosition(0, 10)
	local effect = SoraDCreatAnimation("Node_Effect_lcks02")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.Panel_exp_cut)
	self.expEffect = effect
	self.expCutSize = self.Panel_exp_cut:getContentSize()
	effect:setPosition(self.expCutSize.width / 2, self.expCutSize.height / 2)
	self.expPoint = SoraDGetChildByName(effect, "G_dh_Tex_lcks_006")
	self.Node_unlock:getChildByName("Sprite_lock"):setSpriteFrame("icon_lock_gold.png")
	self.progressExp:setHandle(function(data)
		local width = self.expCutSize.width * self.progressExp:getProgress() / 100
		self.expPoint:setPositionX(width - self.expCutSize.width / 2)
		self.Panel_exp_cut:setContentSize(cc.size(width, self.expCutSize.height))
	end)
	self.progressExp:setActionDelay(0.3)
end
function honorBackPetNode:setSize(size)
	self.Panel_cut:setContentSize(size)
	self.Top_Node:setPositionY(size.height)
	local offsetH = size.height - self.oldSize.height
	_UPVALUE3_ = size.height
	size.height[1] = self.scroll
	size.height[2] = self.Image_line_l
	size.height[3] = self.Image_line_r
	for i, v in ipairs(size.height) do
		local sSize = v:getContentSize()
		v:setContentSize(cc.size(sSize.width, sSize.height + offsetH))
	end
	local sSize = self.Image_line_c:getContentSize()
	self.Image_line_c:setContentSize(cc.size(sSize.width + offsetH, sSize.height))
end
function honorBackPetNode:setOwnView(view)
	self.ownView = view
end
function honorBackPetNode:initData()
end
function honorBackPetNode:refreshData(...)
	local initData = friendPetCtrl:getInitData()
	self.curPetExp = initData.curPetExp
	self.curPetLv = initData.curPetLv
	self.isAdopt = initData.isAdopt
	self.isUnlock = initData.isUnlock
	self.patrolEndtime = initData.patrolEndtime
	if not self.isAdopt then
		self:runAction(cca.callFunc(function()
			SoraDShowLoading(self)
			SoraDCreatePanel("honorBackPetAdopt"):show()
		end))
		return
	end
	if not self.spine_cat then
		self.spine_cat = self:createSpineCat()
		self.spine_cat:addTo(self.Node_cat, -1)
	end
	self:refreshLv()
	self:refreshWalk()
	self.Node_unlock:setVisible(not self.isUnlock)
	_UPVALUE3_ = not self.isUnlock
	;(not self.isUnlock)[1] = "ar"
	;(not self.isUnlock)[2] = "en"
	;(not self.isUnlock)[3] = "ko"
	local iconName = SoraDGetImageNameByLang("frame_lingchong_youmao_%s.png", not self.isUnlock)
	if self.isUnlock then
		_UPVALUE3_ = "ar"
		;("ar")[1] = "ar"
		;("ar")[2] = "en"
		;("ar")[3] = "ko"
		iconName = SoraDGetImageNameByLang("frame_lingchong_zhanmao_%s.png", "ar")
	end
	self.Sprite_name:setSpriteFrame(iconName)
end
function honorBackPetNode:onClickInfo(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("return_lcks_text_013"))
	end
end
function honorBackPetNode:onClickAward(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self.ownView, true)
		SoraDCreatePanel("honorBackPetPatrolReward"):show()
	end
end
function honorBackPetNode:onClickFeed(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.expTimer then
			return
		end
		SoraDPlaySound()
		if self.itemFeedCount >= self.itemFeedCost then
			SoraDShowLoading(self)
			friendPetCtrl:sendReqUpgrade()
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
			self:popItemGuideView()
		end
	end
end
function honorBackPetNode:onClickWalk(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:isBright() then
			if self.itemWalkCount >= self.itemWalkCost then
				SoraDShowLoading(self)
				friendPetCtrl:sendReqPatrol()
			else
				SoraDShowMsgBox(i18n("return_lcks_text_021"), i18n("common_text_204"))
			end
		elseif self.patrolEndtime == 0 then
			SoraDShowMsgBox(i18n("pet_text_54"), i18n("common_text_204"), nil, function(type, target)
				if MSGBOX_CALLBACK_CANCEL ~= type then
					SoraDShowLoading(self)
					friendPetCtrl:sendReqReceivePatrol()
				end
			end)
		else
			local petName = i18n("pet_name_14")
			if self.isUnlock then
				petName = i18n("pet_name_13")
			end
			function _ENV(type, target)
				if MSGBOX_CALLBACK_CANCEL ~= type then
					SoraDShowLoading(self)
					friendPetCtrl:sendReqReceivePatrol()
				end
			end
			;(function(type, target)
				if MSGBOX_CALLBACK_CANCEL ~= type then
					SoraDShowLoading(self)
					friendPetCtrl:sendReqReceivePatrol()
				end
			end).name = petName
			SoraDShowMsgTip(i18n("pet_text_53", function(type, target)
				if MSGBOX_CALLBACK_CANCEL ~= type then
					SoraDShowLoading(self)
					friendPetCtrl:sendReqReceivePatrol()
				end
			end))
		end
	end
end
function honorBackPetNode:onClickReceive(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self)
		friendPetCtrl:sendReqReceivePatrol()
	end
end
function honorBackPetNode:onClickUnlock(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self.ownView, true)
		SoraDCreatePanel("honorBackPetUnlock"):show()
	end
end
function honorBackPetNode:onClickAdd(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self.ownView, true)
		self:popItemGuideView()
	end
end
function honorBackPetNode:popItemGuideView(...)
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.FRIEND_HONORBACK
	;(nil).handle = handler(self, self.accessWayCallback)
	uiManager:show("EventItemGuide", nil)
end
function honorBackPetNode:accessWayCallback(honorType, btnType)
	if honorType then
		self.ownView:jumpToModel(honorType, btnType)
	else
		local panel = SoraDCreatePanel("propBuyView")
		_ENV = nil
		;(nil).itemID = self.itemIDFeed
		panel:initData(nil, nil)
		panel:show()
	end
end
function honorBackPetNode:refreshLv(...)
	local initData = friendPetCtrl:getInitData()
	self.curPetLv = initData.curPetLv
	if self.curPetLv >= 2 then
		self.Text_lvCondi:setVisible(false)
		if not self.unLockEffect then
			local effect = SoraDCreatAnimation("Node_Effect_lcks06")
			SoraDMixtureGLONEByParent(effect)
			effect:addTo(self.Node_unlock)
			effect:setPosition(48, 0)
			self.unLockEffect = effect
		end
		self.unLockEffect:setVisible(true)
	end
	self.curLevel:setString(tostring(self.curPetLv))
	self:refreshExp()
	self.scroll:refreshList(self.listData)
end
function honorBackPetNode:refreshExp(...)
	local initData = friendPetCtrl:getInitData()
	self.curPetExp = initData.curPetExp
	local maxValue = friendsCallbackRead.getLvNeedExp(self.curPetLv)
	friendPetCtrl = nil
	;(nil).curValue = self.curPetExp
	;(nil).maxValue = maxValue
	self.progressExp:setProgressDate(nil)
end
function honorBackPetNode:refreshItemCount(...)
	self.itemFeedCount = backpackCtrl:getItemCount(self.itemIDFeed)
	self.itemFeedCost = friendPetCtrl:getItemFeedCost()
	if self.itemFeedCount ~= 0 and self.itemFeedCount < self.itemFeedCost then
		self.itemFeedCost = self.itemFeedCount
	end
	self.Text_feed_num:setString(tostring(self.itemFeedCount))
	self.Text_feed_cost:setString(tostring(self.itemFeedCost))
	if self.itemFeedCount < self.itemFeedCost then
		self.Text_feed_cost:setColor(display.COLOR_RED)
	else
		self.Text_feed_cost:setColor(cc.c3b(255, 255, 0))
	end
	self.itemWalkCount = backpackCtrl:getItemCount(self.itemIDWalk)
	self.Text_walk_num:setString(tostring(self.itemWalkCount))
	if self.itemWalkCount < self.itemWalkCost then
		self.Text_walk_cost:setColor(display.COLOR_RED)
	else
		self.Text_walk_cost:setColor(cc.c3b(255, 255, 0))
	end
	self:refreshBtnRedP()
end
function honorBackPetNode:refreshWalk(...)
	local initData = friendPetCtrl:getInitData()
	self.patrolEndtime = initData.patrolEndtime
	if self.patrolEndtime > 0 then
		self.Node_walkReward:setVisible(false)
		if not self.Node_walking:isVisible() then
			self.Sprite_walking:stopAllActions()
			self.Sprite_walking:setSpriteFrame("lcks_walk_00000.png")
			self.Node_walking:setVisible(true)
			local frames = display.newFrames("lcks_walk_%.5d.png", 0, 13)
			local animation = display.newAnimation(frames, 0.1)
			self.Sprite_walking:playAnimationForever(animation)
		end
		self.Text_walking:beginTime(self.patrolEndtime - serviceFunctions.systemTime())
		self.Button_walk:setBright(false)
	else
		self.Node_walking:setVisible(false)
		if self.patrolEndtime == 0 then
			self.Node_walkReward:setVisible(true)
			self.Button_walk:setBright(false)
		else
			self.Node_walkReward:setVisible(false)
			self.Button_walk:setBright(true)
		end
	end
	self:refreshBtnRedP()
end
function honorBackPetNode:createSpineCat(...)
	local spine_cat
	if self.isUnlock then
		spine_cat = sp.SkeletonAnimation:create("spine/lingmao_zhanmao.skel", "spine/lingmao_zhanmao.atlas", 1)
	else
		spine_cat = sp.SkeletonAnimation:create("spine/lingmao_youmao.skel", "spine/lingmao_youmao.atlas", 1)
	end
	spine_cat:setAnimation(0, "animation", true)
	spine_cat:setPosition(cc.p(0, -60))
	return spine_cat
end
function honorBackPetNode:refreshBtnRedP(...)
	self.redPoint_feed:setVisible(friendPetCtrl:showFeedRedP())
	self.redPoint_walk:setVisible(friendPetCtrl:showWalkRedP())
	friendPetCtrl = self.redPoint_walk
	self.redPoint_walk.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDSendMessage(self.redPoint_walk)
end
function honorBackPetNode:popLevelUpView(reward)
	local panel = SoraDCreatePanel("honorBackPetLevelUp")
	panel:initLevelUpReward(reward)
	panel:show()
end
function honorBackPetNode:popUnlockView(reward)
	local panel = SoraDCreatePanel("honorBackPetLevelUp")
	panel:initUnlockReward(reward)
	panel:show()
end
function honorBackPetNode:afterUnlock(...)
	local initData = friendPetCtrl:getInitData()
	self.isUnlock = initData.isUnlock
	if self.spine_cat then
		self.spine_cat:removeFromParent()
		self.spine_cat = nil
	end
	self.spine_cat = self:createSpineCat()
	self.spine_cat:addTo(self.Node_cat, -1)
	self.Node_unlock:setVisible(not self.isUnlock)
	self.scroll:refreshList(self.listData)
	_UPVALUE3_ = self.listData
	self.listData[1] = "ar"
	self.listData[2] = "en"
	self.listData[3] = "ko"
	local iconName = SoraDGetImageNameByLang("frame_lingchong_youmao_%s.png", self.listData)
	if self.isUnlock then
		_UPVALUE3_ = "ar"
		;("ar")[1] = "ar"
		;("ar")[2] = "en"
		;("ar")[3] = "ko"
		iconName = SoraDGetImageNameByLang("frame_lingchong_zhanmao_%s.png", "ar")
	end
	self.Sprite_name:setSpriteFrame(iconName)
end
function honorBackPetNode:showExpEffect(...)
	local effect = SoraDCreatAnimation("Node_Effect_lcks05", nil, false)
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.Sprite_144)
	effect:setPosition(self.Sprite_144:getContentSize().width / 2, self.Sprite_144:getContentSize().height / 2)
	_UPVALUE1_ = self.Sprite_144:getContentSize().height / 2
	;(self.Sprite_144:getContentSize().height / 2)[1] = cca.delay(1.1666666666666667)
	;(self.Sprite_144:getContentSize().height / 2)[2] = cca.removeSelf()
	effect:runAction(cca.seq(self.Sprite_144:getContentSize().height / 2))
end
function honorBackPetNode:createSingleNode(...)
	local node = self.Node_cell:clone()
	node:setVisible(true)
	node.Node_cell_n = node:getChildByName("Node_cell_n")
	node.itemList, _ENV, node.Node_cell_s = node:getChildByName("Node_cell_s"), node:getChildByName("Node_cell_s"), node:getChildByName("Node_cell_s")
	function node.initData(target, data)
		if data.type == 1 then
			self:refreshCellN(node, data)
		else
			self:refreshCellS(node, data)
		end
	end
	local itemW = 640
	function node.measureSize(data)
		if data.type == 1 then
			return cc.size(itemW, 84)
		else
			return cc.size(itemW, 112)
		end
	end
	return node
end
function honorBackPetNode:getRewardItem(...)
	local item = self.Node_award:clone()
	item:setPosition(0, 0)
	item.Sprite_lock = item:getChildByName("Sprite_lock")
	item.Button_itemLock = item:getChildByName("Button_itemLock")
	item.Button_itemLock:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			SoraDShowMsgTip(i18n("return_lcks_text_022"))
		end
	end)
	item.award = SoraDGetExtendChildFromCCSByName(item, "CCS_commonItemAward_item")
	item.award:setOwnScroll(self.scroll)
	item.award:setOwnView(self.Panel_cut)
	item.award:setBaseScale(1.0)
	return item
end
function honorBackPetNode:refreshCellN(node, data)
	node.Node_cell_s:setVisible(false)
	local item = node.itemRewardL
	if not item then
		local Node_award_l = node.Node_cell_n:getChildByName("Node_award_l")
		item = self:getRewardItem()
		item:addTo(Node_award_l)
		node.itemRewardL = item
	end
	item.Sprite_lock:setVisible(self.curPetLv >= data.lv)
	item.Button_itemLock:setVisible(false)
	local reward = data.lowReward[1]
	item.award:initData(reward.id, reward.count)
	item.award:setGray(self.curPetLv < data.lv)
	local item = node.itemRewardR
	if not item then
		local Node_award_r = node.Node_cell_n:getChildByName("Node_award_r")
		item = self:getRewardItem()
		item:addTo(Node_award_r)
		node.itemRewardR = item
	end
	item.Sprite_lock:setVisible(self.curPetLv >= data.lv and self.isUnlock)
	item.Button_itemLock:setVisible(not self.isUnlock)
	local reward = data.highReward[1]
	item.award:initData(reward.id, reward.count)
	item.award:setGray(not self.isUnlock or self.curPetLv < data.lv)
	local Sprite_bg_l = node.Node_cell_n:getChildByName("Sprite_bg_l")
	local Sprite_bg_r = node.Node_cell_n:getChildByName("Sprite_bg_r")
	if self.curPetLv < data.lv then
		Sprite_bg_l:setOpacity(76.5)
		Sprite_bg_r:setOpacity(76.5)
	else
		Sprite_bg_l:setOpacity(255)
		Sprite_bg_r:setOpacity(255)
	end
	node.Node_cell_n:setVisible(true)
	node.Node_cell_n:getChildByName("Text_level"):setString(data.lv)
end
function honorBackPetNode:refreshCellS(node, data)
	node.Node_cell_n:setVisible(false)
	local Text_tip = node.Node_cell_s:getChildByName("Text_tip")
	local normalLv = #self.listData - 1 + self.eachLv
	local lv2 = normalLv - self.curPetLv
	if lv2 < 0 then
		lv2 = lv2 % self.eachLv
	end
	_ENV = nil
	;(nil).lv1 = self.eachLv
	;(nil).lv2 = lv2
	Text_tip:setString(i18n("return_lcks_text_018", nil))
	for i, v in ipairs(data.uplvReward) do
		local item = node.itemList[i]
		if not item then
			local Node_award = node.Node_cell_s:getChildByName("Node_award")
			item = self:getRewardItem()
			item:addTo(Node_award)
			item:setPositionX(-50 + 100 * (i - 1))
			node.itemList[i] = item
		end
		item.Sprite_lock:setVisible(self.curPetLv >= data.lv)
		item.Button_itemLock:setVisible(false)
		item.award:initData(v.id, v.count)
		item.award:setGray(self.curPetLv < data.lv)
	end
	local Sprite_bg = node.Node_cell_s:getChildByName("Sprite_bg")
	if self.curPetLv < data.lv then
		Sprite_bg:setOpacity(76.5)
	else
		Sprite_bg:setOpacity(255)
	end
	node.Node_cell_s:setVisible(true)
	node.Node_cell_s:getChildByName("Text_level"):setString(data.lv .. "+")
end
return honorBackPetNode
