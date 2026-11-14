local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local worldMapDefine = include("worldMapDefine")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local ua = include("utilAlign")
local kingStarActivity = class("kingStarActivity", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("kingStarActivity")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function kingStarActivity:createTimeNode(numOfChar, initTime, paddingArray)
	local nodeParent = display.newNode()
	local getCharNode = function()
		local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
		numChar:setAnchorPoint(cc.p(0, 0))
		numChar:setPosition(0, 0)
		return numChar
	end
	local _ENV, numArray
	for i = 1, numOfChar do
		local numChar = getCharNode()
		numChar:addTo(nodeParent)
		numChar:setContentSize(cc.size(35, 46))
		numChar:setFontSize(46)
		numArray[i] = numChar
	end
	SoraDAlignNodeArray(numArray, false, paddingArray)
	local time_node_cooling = self.time_node_cooling
	local frame_LegendaryKing_countdown_12 = self.frame_LegendaryKing_countdown_12
	function nodeParent:setTime(secTime)
		local timeStr = SoraDConvertSecondToStringNoDay(secTime)
		local splitTime = string.split(timeStr, ":")
		if string.len(splitTime[1]) >= 3 then
			if tonumber(splitTime[1]) > 999 then
				splitTime[1] = tostring(999)
			end
			time_node_cooling:setScale(0.9)
			frame_LegendaryKing_countdown_12:setVisible(true)
			time_node_cooling:setPositionX(70)
			time_node_cooling:setPositionY(time_node_cooling.oriPos.y + 30)
			_UPVALUE6_ = time_node_cooling.setPositionY
			time_node_cooling.setPositionY[1] = string.sub(timeStr, 1, 1)
			time_node_cooling.setPositionY[2] = string.sub(timeStr, 2, 2)
			time_node_cooling.setPositionY[3] = string.sub(timeStr, 3, 3)
			time_node_cooling.setPositionY[4] = string.sub(timeStr, 5, 5)
			time_node_cooling.setPositionY[5] = string.sub(timeStr, 6, 6)
			time_node_cooling.setPositionY[6] = string.sub(timeStr, 8, 8)
			time_node_cooling.setPositionY[7] = string.sub(timeStr, 9, 9)
			time_node_cooling.setPositionY[8] = string.sub(timeStr, 9, 9)
			time_node_cooling.setPositionY[9] = string.sub(timeStr, 9, 9)
			local time_node_cooling.setPositionY[10], strArray = string.sub(timeStr, 9, 9)
			dump(strArray, "strArray")
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		else
			time_node_cooling:setScale(1.0)
			time_node_cooling:setPositionX(0)
			time_node_cooling:setPositionY(time_node_cooling.oriPos.y)
			frame_LegendaryKing_countdown_12:setVisible(false)
			print("timeStr = ", timeStr)
			_UPVALUE5_ = print
			print[1] = string.sub(timeStr, 1, 1)
			print[2] = string.sub(timeStr, 2, 2)
			print[3] = string.sub(timeStr, 4, 4)
			print[4] = string.sub(timeStr, 5, 5)
			print[5] = string.sub(timeStr, 7, 7)
			print[6] = string.sub(timeStr, 8, 8)
			print[7] = string.sub(timeStr, 8, 8)
			print[8] = string.sub(timeStr, 8, 8)
			print[9] = string.sub(timeStr, 8, 8)
			local print[10], strArray = string.sub(timeStr, 8, 8)
			for i = 1, #strArray do
				if numArray[i + 1] then
					numArray[i + 1]:setString(strArray[i])
				end
			end
		end
	end
	if initTime then
		nodeParent:setTime(initTime)
	end
	return nodeParent
end
function kingStarActivity:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Node_info = SoraDGetChildByName(self, "Top_Node_info")
	self.bg_activity_lord = SoraDGetChildByName(self, "bg_activity_lord")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Img_help = SoraDGetChildByName(self, "Img_help")
	self.Node_bg = SoraDGetChildByName(self, "Node_bg")
	self.Size_Image_bg2 = SoraDGetChildByName(self, "Size_Image_bg2")
	self.Size_frame_sheer_items_L = SoraDGetChildByName(self, "Size_frame_sheer_items_L")
	self.Size_frame_sheer_items_R = SoraDGetChildByName(self, "Size_frame_sheer_items_R")
	self.Size_frame_LegendaryKing_lace = SoraDGetChildByName(self, "Size_frame_LegendaryKing_lace")
	self.frame_sheer_items_Top = SoraDGetChildByName(self, "frame_sheer_items_Top")
	self.Size_frame_LegendaryKing_base_red = SoraDGetChildByName(self, "Size_frame_LegendaryKing_base_red")
	self.Size_ScrollView_Content = SoraDGetChildByName(self, "Size_ScrollView_Content")
	self.Panel_Content = SoraDGetChildByName(self, "Panel_Content")
	self.node_reward_info = SoraDGetChildByName(self, "node_reward_info")
	self.Image_Line_middle = SoraDGetChildByName(self, "Image_Line_middle")
	self.text_reward_title = SoraDGetChildByName(self, "text_reward_title")
	self.frame_maintenance_R = SoraDGetChildByName(self, "frame_maintenance_R")
	self.frame_maintenance_L = SoraDGetChildByName(self, "frame_maintenance_L")
	self.node_time_info = SoraDGetChildByName(self, "node_time_info")
	self.Image_Line_top = SoraDGetChildByName(self, "Image_Line_top")
	self.text_time_title = SoraDGetChildByName(self, "text_time_title")
	self.text_time_num = SoraDGetChildByName(self, "text_time_num")
	self.time_node_cooling = SoraDGetChildByName(self, "time_node_cooling")
	self.time_node_cooling.oriPos = cc.p(self.time_node_cooling:getPosition())
	print("self.time_node_cooling", self.time_node_cooling)
	self.frame_LegendaryKing_countdown_12 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")
	self.frame_LegendaryKing_countdown_13 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_13")
	self.frame_LegendaryKing_countdown_14 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_14")
	self.frame_LegendaryKing_countdown_15 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_15")
	self.frame_LegendaryKing_countdown_16 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_16")
	self.frame_LegendaryKing_countdown_17 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_17")
	self.frame_LegendaryKing_countdown_18 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_18")
	self.text_des = SoraDGetChildByName(self, "text_des")
	self.nodeReward_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeReward_node")
	self.btn_rank_view = SoraDGetChildByName(self, "btn_rank_view")
	self.btn_rank_view:setVisible(false)
	self.btn_team = SoraDGetChildByName(self, "btn_team")
	self.btn_enter_battle_active = SoraDGetChildByName(self, "btn_enter_battle_active")
	self.btn_stage_reward = SoraDGetChildByName(self, "btn_stage_reward")
	self.btn_enter_battle_prepare = SoraDGetChildByName(self, "btn_enter_battle_prepare")
	self.btn_king_reward = SoraDGetChildByName(self, "Button_KingAward")
	self.btn_exchange_shop = SoraDGetChildByName(self, "Button_ExchangeShop")
	self.exchangeRedPoint = SoraDGetChildByName(self.btn_exchange_shop, "Image_redPoint")
	self.img_Size_R = SoraDGetChildByName(self, "img_Size_R")
	self.img_Size_L = SoraDGetChildByName(self, "img_Size_L")
	self.Top_Node_Status = SoraDGetChildByName(self, "Top_Node_Status")
	self.frame_sheer_items_bg = SoraDGetChildByName(self, "frame_sheer_items_bg")
	self.frame_SVIP_title_R_ = SoraDGetChildByName(self, "frame_SVIP_title_R_")
	self.frame_SVIP_title_L_ = SoraDGetChildByName(self, "frame_SVIP_title_L_")
	self.frame_SVIP_title_war_R = SoraDGetChildByName(self, "frame_SVIP_title_war_R")
	self.frame_SVIP_title_war_L = SoraDGetChildByName(self, "frame_SVIP_title_war_L")
	self.frame_LegendaryKing_base_L = SoraDGetChildByName(self, "frame_LegendaryKing_base_L")
	self.frame_LegendaryKing_base_R = SoraDGetChildByName(self, "frame_LegendaryKing_base_R")
	self.sprite_activity_text = SoraDGetChildByName(self, "sprite_activity_text")
	self.frame_red_package_L = SoraDGetChildByName(self, "frame_red_package_L")
	self.frame_red_package_R = SoraDGetChildByName(self, "frame_red_package_R")
	self.text_war_status = SoraDGetChildByName(self, "text_war_status")
	self.text_peace_status = SoraDGetChildByName(self, "text_peace_status")
	self.sprite_war_status = SoraDGetChildByName(self, "sprite_war_status")
	self.sprite_peace_status = SoraDGetChildByName(self, "sprite_peace_status")
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.btn_rank_view:addTouchEventListener(handler(self, self.onClick_btn_rank_view))
	self.btn_team:addTouchEventListener(handler(self, self.onClick_btn_team))
	self.btn_enter_battle_active:addTouchEventListener(handler(self, self.onClick_btn_enter_battle_active))
	self.btn_enter_battle_prepare:addTouchEventListener(handler(self, self.onClick_btn_enter_battle_prepare))
	self.btn_king_reward:addTouchEventListener(handler(self, self.onClick_btn_king_reward))
	self.btn_exchange_shop:addTouchEventListener(handler(self, self.onClick_btn_exchange_shop))
	_UPVALUE6_ = self.btn_exchange_shop.addTouchEventListener
	self.timePadding, self.btn_exchange_shop.addTouchEventListener[1] = self.btn_exchange_shop.addTouchEventListener, 56
	self.timePadding, self.btn_exchange_shop.addTouchEventListener[2] = self.btn_exchange_shop.addTouchEventListener, 56
	self.timePadding, self.btn_exchange_shop.addTouchEventListener[3] = self.btn_exchange_shop.addTouchEventListener, 90
	self.timePadding, self.btn_exchange_shop.addTouchEventListener[4] = self.btn_exchange_shop.addTouchEventListener, 45
	self.timePadding, self.btn_exchange_shop.addTouchEventListener[5] = self.btn_exchange_shop.addTouchEventListener, 86
	self.timePadding, self.btn_exchange_shop.addTouchEventListener[6] = self.btn_exchange_shop.addTouchEventListener, 50
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.activity_time:addTo(self.time_node_cooling)
	self.activity_time:setPosition(cc.p(-50, 307))
	self.activity_time:setLocalZOrder(10)
	_UPVALUE5_ = self.activity_time.setLocalZOrder
	_UPVALUE7_, self.tbArrayPrepare, self.activity_time.setLocalZOrder[1] = self.activity_time.setLocalZOrder, self.activity_time.setLocalZOrder, self.btn_enter_battle_prepare
	_UPVALUE7_, self.tbArrayPrepare, self.activity_time.setLocalZOrder[2] = self.activity_time.setLocalZOrder, self.activity_time.setLocalZOrder, self.text_peace_status
	_UPVALUE7_, self.tbArrayPrepare, self.activity_time.setLocalZOrder[3] = self.activity_time.setLocalZOrder, self.activity_time.setLocalZOrder, self.sprite_peace_status
	_UPVALUE7_, self.tbArrayPrepare, self.activity_time.setLocalZOrder[4] = self.activity_time.setLocalZOrder, self.activity_time.setLocalZOrder, self.btn_stage_reward
	_UPVALUE7_, self.tbArrayPrepare, self.activity_time.setLocalZOrder[5] = self.activity_time.setLocalZOrder, self.activity_time.setLocalZOrder, self.btn_team
	self.tbArrayActive, self.activity_time.setLocalZOrder[1] = self.activity_time.setLocalZOrder, self.btn_enter_battle_active
	self.tbArrayActive, self.activity_time.setLocalZOrder[2] = self.activity_time.setLocalZOrder, self.btn_team
	self.tbArrayActive, self.activity_time.setLocalZOrder[3] = self.activity_time.setLocalZOrder, self.text_war_status
	self.tbArrayActive, self.activity_time.setLocalZOrder[4] = self.activity_time.setLocalZOrder, self.sprite_war_status
	self.tbArrayActive, self.activity_time.setLocalZOrder[5] = self.activity_time.setLocalZOrder, self.btn_stage_reward
	self.tbArrayActive, self.activity_time.setLocalZOrder[6] = self.activity_time.setLocalZOrder, self.btn_king_reward
	self.tbArrayActive, self.activity_time.setLocalZOrder[7] = self.activity_time.setLocalZOrder, self.btn_exchange_shop
	self.Panel_Content.oriSize = self.Panel_Content:getContentSize()
	local scrollSize = self.Size_ScrollView_Content:getContentSize()
	local panelContentSize = self.Panel_Content:getContentSize()
	if scrollSize.height > panelContentSize.height then
		self.Size_ScrollView_Content:setInnerContainerSize(scrollSize)
	else
		self.Size_ScrollView_Content:setInnerContainerSize(panelContentSize)
	end
	local innerContainerSize = self.Size_ScrollView_Content:getInnerContainerSize()
	self.Panel_Content:setPositionY(innerContainerSize.height)
	kingStarTeamCtrl = self.Panel_Content.setPositionY
	self.tbContentNodes, self.Panel_Content.setPositionY[1] = self.Panel_Content.setPositionY, self.node_reward_info
	self.tbContentNodes, self.Panel_Content.setPositionY[2] = self.Panel_Content.setPositionY, self.node_time_info
	self.tbContentNodes, self.Panel_Content.setPositionY[3] = self.Panel_Content.setPositionY, self.nodeReward_node
	for i, v in ipairs(self.tbContentNodes) do
		v.oriPosY = v:getPositionY()
	end
	legendLordWarltCtrl, self.tbRewardInUse, _ENV, self.templateNodeReward = self.nodeReward_node, self.nodeReward_node, self.nodeReward_node, self.nodeReward_node
	self.tbRewardNotInUse, self.nodeReward_node[1] = self.nodeReward_node, self.nodeReward_node
	self.kingReward = legendLordWarltCtrl.getLegendLordWarRankReward(1, worldMapDefine.KINGSTAR_KINGDOM_ID)
	self:showLegendReward()
	self:init()
	self.btn_rank_view:setTitleText(i18n("common_text_4232"))
	if kingStarTeamCtrl:isHasTeam() then
		self.btn_team:setTitleText(i18n("remains_title_05"))
	else
		self.btn_team:setTitleText(i18n("complete_text_03"))
	end
	self.btn_enter_battle_prepare:setTitleText(i18n("common_text_3318"))
	SoraDAutoSizeButtonText(self.btn_rank_view)
	SoraDAutoSizeButtonText(self.btn_team)
	SoraDAutoSizeButtonText(self.btn_enter_battle_prepare)
	self.commonFramTitle_node:setTitle(i18n("common_text_4207"))
	self.btn_stage_reward:setTitleText(i18n("common_text_3141"))
	_UPVALUE5_ = self.btn_stage_reward
	self.btn_stage_reward[1] = self.Size_Image_bg2
	self.btn_stage_reward[2] = self.Size_frame_sheer_items_R
	self.btn_stage_reward[3] = self.Size_frame_sheer_items_L
	self.btn_stage_reward[4] = self.Size_frame_LegendaryKing_lace
	self.btn_stage_reward[5] = self.Size_frame_LegendaryKing_base_red
	SoraDAdjustFitHeightArray(self.btn_stage_reward)
	legendLordWarltCtrl = self.btn_stage_reward
	self.btn_stage_reward[1] = self.frame_sheer_items_Top
	SoraDAdjustFitPosArray(self.btn_stage_reward)
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.btn_stage_reward:addTouchEventListener(handler(self, self.onClickBtnStageReward))
	self.Size_Image_bg2:setFillType(1)
	if userSDKManager.getChannel() ~= "ar" then
		self.sprite_activity_text:setSpriteFrame("frame_LegendaryKing_word_en.png")
	end
end
function kingStarActivity:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function kingStarActivity:updateTime()
	local eid = gActivityTimeActivityID.KING_STAR_BATTLE
	local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
	if eventLeftTime then
		local timerNode = eventLeftTime.timerNode
		if timerNode then
			self.activity_time:setTime(timerNode.timer:getRemainTime())
		end
	end
end
function kingStarActivity:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function kingStarActivity:createUI()
end
function kingStarActivity:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	cloneNode = include("nodeReward").new(cloneNode)
	cloneNode:addTo(self.templateNodeReward:getParent())
	cloneNode:setPosition(cc.p(self.templateNodeReward:getPosition()))
	return cloneNode
end
function kingStarActivity:init(data)
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
	self.legendState = param.curState
	if self.legendState == ACTIVITY_STATE.PREPARE then
		SoraDSetNodeArrayVisible(self.tbArrayActive, false)
		SoraDSetNodeArrayVisible(self.tbArrayPrepare, true)
		self.text_peace_status:setString(i18n("common_text_4210"))
		self.text_time_title:setString(i18n("common_text_608"))
		self.text_time_num:setVisible(false)
		self.text_des:setString(i18n("common_text_4209"))
		self.text_reward_title:setString(i18n("common_text_4211"))
		self:beginTime()
		self.btn_enter_battle_prepare:setBright(false)
		self.btn_stage_reward:setPositionX(320)
	elseif self.legendState == ACTIVITY_STATE.ACTIVE then
		self.btn_stage_reward:setPositionX(320)
		SoraDSetNodeArrayVisible(self.tbArrayPrepare, false)
		SoraDSetNodeArrayVisible(self.tbArrayActive, true)
		self:beginTime()
		local isInWar = worldMapDefine.isInLegendLord()
		if not isInWar then
			self.btn_enter_battle_active:setTitleText(i18n("common_text_3318"))
		else
			self.btn_enter_battle_active:setTitleText(i18n("common_text_4256"))
		end
		self.text_war_status:setString(i18n("common_text_1446"))
		self.text_time_title:setString(i18n("common_text_2669"))
		self.text_des:setString(i18n("common_text_4209"))
		self.text_reward_title:setString(i18n("common_text_4211"))
		SoraDAutoSizeButtonText(self.btn_enter_battle_active)
		local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
		legendLordWarCtrl:reqLegendLordData(worldMapDefine.KINGSTAR_KINGDOM_ID)
		self.text_time_num:setVisible(true)
		self:updateWatchingNum()
		self:updateExchangeNum()
	elseif self.legendState == ACTIVITY_STATE.SETTLE then
		self.text_time_num:setVisible(false)
	else
		print("kingStarActivity state error! ")
	end
	worldMapDefine = "kingStarActivity state error! "
	;("kingStarActivity state error! ")[1] = self.text_peace_status
	;("kingStarActivity state error! ")[2] = self.sprite_peace_status
	_ENV = self.sprite_peace_status
	self.sprite_peace_status[1] = 10
	SoraDAlignNodeArray("kingStarActivity state error! ", not SoraDFIsRA(), self.sprite_peace_status)
	worldMapDefine = "kingStarActivity state error! "
	;("kingStarActivity state error! ")[1] = self.text_war_status
	;("kingStarActivity state error! ")[2] = self.sprite_war_status
	_ENV = self.sprite_war_status
	self.sprite_war_status[1] = 10
	SoraDAlignNodeArray("kingStarActivity state error! ", not SoraDFIsRA(), self.sprite_war_status)
	worldMapDefine = "kingStarActivity state error! "
	;("kingStarActivity state error! ")[1] = self.text_reward_title
	;("kingStarActivity state error! ")[2] = self.frame_maintenance_L
	_ENV = self.frame_maintenance_L
	self.frame_maintenance_L[1] = 15
	SoraDAlignNodeArray("kingStarActivity state error! ", true, self.frame_maintenance_L)
	worldMapDefine = "kingStarActivity state error! "
	;("kingStarActivity state error! ")[1] = self.text_reward_title
	;("kingStarActivity state error! ")[2] = self.frame_maintenance_R
	_ENV = self.frame_maintenance_R
	self.frame_maintenance_R[1] = 15
	SoraDAlignNodeArray("kingStarActivity state error! ", false, self.frame_maintenance_R)
end
function kingStarActivity:recycleRewards()
	for i = 1, #self.tbRewardInUse do
		self.tbRewardInUse[i]:setVisible(false)
		self.tbRewardInUse[i]:removeGlow()
		table.insert(self.tbRewardNotInUse, self.tbRewardInUse[i])
	end
	self.tbRewardInUse, _ENV = 1, (for index)
end
function kingStarActivity:showLegendReward()
	self:recycleRewards()
	local singleH = 150
	local numRewards = #self.kingReward
	local paddingy = 10
	local numx = math.ceil(numRewards / 2)
	local scale = numx == 3 and 1 or 0.95
	local addH = (math.ceil(numRewards / numx) - 1) * singleH + math.ceil(numRewards / numx) * paddingy
	if 0 < addH then
		self.Panel_Content:setContentSize(cc.size(self.Panel_Content.oriSize.width, self.Panel_Content.oriSize.height + addH))
		for i, v in ipairs(self.tbContentNodes) do
			v:setPositionY(v.oriPosY + addH)
		end
	end
	if self.Size_ScrollView_Content:getInnerContainerSize().height < self.Panel_Content:getContentSize().height then
		self.Size_ScrollView_Content:setInnerContainerSize(cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, self.Panel_Content:getContentSize().height))
		self.Panel_Content:setPositionY(self.Panel_Content:getContentSize().height)
	end
	for i = 1, #self.kingReward do
		local nodeReward
		if 0 < #self.tbRewardNotInUse then
			nodeReward = table.remove(self.tbRewardNotInUse)
			nodeReward:setVisible(true)
		else
			nodeReward = self:getCloneNodeReward()
		end
		nodeReward:setContentSize(120, 150)
		nodeReward:setScale(scale)
		table.insert(self.tbRewardInUse, nodeReward)
		nodeReward:init(self.kingReward[i])
	end
	for i = 1, 3 do
		if self.kingReward[i].id == 6200111 then
			self.tbRewardInUse[i]:showGlow()
			break
		end
	end
	for i, v in ipairs(self.tbRewardInUse) do
		print(i, v)
	end
	local offsetx = numx == 3 and 60 or 30
	local marginx = math.max(0, (616 - 120 * scale * numx - 30 * (numx - 1)) / 2)
	_ENV = 0
	;(0).directionx = ua.Direction.LEFT
	;(0).directiony = ua.Direction.DOWN
	;(0).totalWidth = 616
	;(0).itemWidth = 120 * scale
	;(0).itemHeight = 150
	;(0).numx = numx
	;(0).beginx = 0
	;(0).offsetx = -60.0 * scale
	;(0).beginy = 10
	;(0).offsety = -75.0
	;(0).marginx = marginx
	;(0).marginy = 0
	;(0).totalNum = #self.tbRewardInUse
	;(0).paddingy = paddingy
	local (0).isSamePadding, param = true, 0
	ua.alignHFits(self.tbRewardInUse, param)
end
function kingStarActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKING_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WATCHING_NUM", handler(self, self.updateWatchingNum))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.sMsgTeamUPdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.updateExchangeNum))
end
function kingStarActivity:onClick_Button_help(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.LEGGEND_LORD)
	end
end
function kingStarActivity:onClickBtnStageReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanelByFixName("kingStarStageReward")
		panel:initData(worldMapDefine.KINGSTAR_KINGDOM_ID)
		panel:show()
	end
end
function kingStarActivity:onClick_btn_rank_view(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingRank")
		panel:init(gLegendBuildID, worldMapDefine.KINGSTAR_KINGDOM_ID)
		panel:show()
	end
end
function kingStarActivity:onClick_btn_enter_battle_active(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local isInWar = worldMapDefine.isInLegendLord()
		if not isInWar then
			SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.KINGSTAR_KINGDOM_ID)
		else
			local sourceKid = gametop.playertop_:getKingdomID()
			if 0 < sourceKid then
				SoraDGotoWorldMapPoint(cc.p(600, 600), false, sourceKid)
			end
		end
		self:closePanel()
		SoraDRemoveAllPanelFromManager()
	end
end
function kingStarActivity:onClick_btn_enter_battle_prepare(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function kingStarActivity:onClick_btn_king_reward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingAwardView")
		panel:setWarType(gKingdomClassType.legendLord, worldMapDefine.KINGSTAR_KINGDOM_ID)
		panel:show()
	end
end
function kingStarActivity:onClick_btn_exchange_shop(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local legendTeamUtil = include("legendTeamUtil")
		if not legendTeamUtil.isWarTest() then
			local panel = SoraDCreatePanel("legendaryExchangeShopView")
			panel:setActivityID(gActivityTimeActivityID.KING_STAR_BATTLE)
			panel:show()
		else
			SoraDShowMsgTip(i18n("Battlefield_queue_text_005"))
		end
	end
end
function kingStarActivity:msgShowItemInfo(target, data)
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function kingStarActivity:openItemInfoMsg(data)
	local itemID = data.id
	local item = data.item
	local ret = SoraDJudgeResOrItem(itemID)
	if ret == false then
		return
	end
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	if gIDType.EQUIPMENT == JudgeItemType(itemID) then
		local equipDesRead = include("equipDesRead")
		local equipmentltCtrl = include("equipmentltCtrl")
		local itemName = equipDesRead.getName(itemID)
		local baseProperty, mayVal = equipmentltCtrl.getEquipmentBaseProperty(itemID, 999, 0)
		local baseString = equipDesRead.getAttrName(baseProperty, mayVal)
		local itemContent = baseString .. "\n" .. i18n("common_text_1344")
		self.itemTips:customData(itemName, itemContent)
	else
		self.itemTips:initData(itemID)
	end
end
function kingStarActivity:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function kingStarActivity:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID and type(data.activityID) == "table" then
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == gActivityTimeActivityID.KING_STAR_BATTLE then
				local activityState = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_STAR_BATTLE)
				print("activityState = ", activityState)
				if activityState == gActivityState.CLOSE then
					self:closePanel()
					break
				end
				if activityState == gActivityState.OPEN then
					local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
					local legendState = param.curState
					if legendState == ACTIVITY_STATE.PREPARE then
						self:init()
						break
					end
					if legendState == ACTIVITY_STATE.ACTIVE then
						self:init()
						break
					end
					if legendState == ACTIVITY_STATE.SETTLE then
						self:closePanel()
					end
				end
				break
			end
		end
	end
end
function kingStarActivity:updateWatchingNum()
	local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
	local num = legendLordWarCtrl:getWatchingNum()
	if 0 <= num then
		local str = string.formatnumberthousands(num)
		gametop = nil
		;(nil).num = str
		self.text_time_num:setString(i18n("legendaryking_text_32", nil))
	end
end
function kingStarActivity:updateExchangeNum()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local retShop, num = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.KING_STAR_BATTLE)
	self.exchangeRedPoint:setVisible(retShop)
	print("kingStarActivity:updateExchangeNum", retShop, num)
	self.exchangeRedPoint:getChildByName("Text_redPointInt"):setString(num)
end
function kingStarActivity:onClick_btn_team(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openView(worldMapDefine.KINGSTAR_KINGDOM_ID)
	end
end
function kingStarActivity:sMsgTeamUPdate(target, data)
	if kingStarTeamCtrl:isHasTeam() then
		self.btn_team:setTitleText(i18n("remains_title_05"))
	else
		self.btn_team:setTitleText(i18n("complete_text_03"))
	end
	SoraDAutoSizeButtonText(self.btn_team)
end
return kingStarActivity
