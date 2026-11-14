local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local worldMapDefine = include("worldMapDefine")
local hegemonRead = include("hegemonRead")
local ua = include("utilAlign")
local hegemonPrepare = class("hegemonPrepare", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("hegemonPrepare")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function hegemonPrepare:createTimeNode(numOfChar, initTime, paddingArray)
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
			_UPVALUE6_ = time_node_cooling.setPositionX
			time_node_cooling.setPositionX[1] = string.sub(timeStr, 1, 1)
			time_node_cooling.setPositionX[2] = string.sub(timeStr, 2, 2)
			time_node_cooling.setPositionX[3] = string.sub(timeStr, 3, 3)
			time_node_cooling.setPositionX[4] = string.sub(timeStr, 5, 5)
			time_node_cooling.setPositionX[5] = string.sub(timeStr, 6, 6)
			time_node_cooling.setPositionX[6] = string.sub(timeStr, 8, 8)
			time_node_cooling.setPositionX[7] = string.sub(timeStr, 9, 9)
			time_node_cooling.setPositionX[8] = string.sub(timeStr, 9, 9)
			time_node_cooling.setPositionX[9] = string.sub(timeStr, 9, 9)
			local time_node_cooling.setPositionX[10], strArray = string.sub(timeStr, 9, 9)
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		else
			time_node_cooling:setScale(1.0)
			time_node_cooling:setPositionX(0)
			frame_LegendaryKing_countdown_12:setVisible(false)
			_UPVALUE5_ = frame_LegendaryKing_countdown_12.setVisible
			frame_LegendaryKing_countdown_12.setVisible[1] = string.sub(timeStr, 1, 1)
			frame_LegendaryKing_countdown_12.setVisible[2] = string.sub(timeStr, 2, 2)
			frame_LegendaryKing_countdown_12.setVisible[3] = string.sub(timeStr, 4, 4)
			frame_LegendaryKing_countdown_12.setVisible[4] = string.sub(timeStr, 5, 5)
			frame_LegendaryKing_countdown_12.setVisible[5] = string.sub(timeStr, 7, 7)
			frame_LegendaryKing_countdown_12.setVisible[6] = string.sub(timeStr, 8, 8)
			frame_LegendaryKing_countdown_12.setVisible[7] = string.sub(timeStr, 8, 8)
			frame_LegendaryKing_countdown_12.setVisible[8] = string.sub(timeStr, 8, 8)
			frame_LegendaryKing_countdown_12.setVisible[9] = string.sub(timeStr, 8, 8)
			local frame_LegendaryKing_countdown_12.setVisible[10], strArray = string.sub(timeStr, 8, 8)
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
function hegemonPrepare:ctor()
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
	self.frame_sheer_items_Top = SoraDGetChildByName(self, "frame_sheer_items_Top")
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
	self.time_node_cooling = SoraDGetChildByName(self, "time_node_cooling")
	print("self.time_node_cooling", self.time_node_cooling)
	self.frame_LegendaryKing_countdown_12 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")
	self.frame_LegendaryKing_countdown_13 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_13")
	self.frame_LegendaryKing_countdown_14 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_14")
	self.frame_LegendaryKing_countdown_15 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_15")
	self.frame_LegendaryKing_countdown_16 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_16")
	self.frame_LegendaryKing_countdown_17 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_17")
	self.frame_LegendaryKing_countdown_18 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_18")
	self.text_des = SoraDGetChildByName(self, "text_activity_des")
	self.nodeReward_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeReward_node")
	self.btn_hegemon_info = SoraDGetChildByName(self, "btn_hegemon_info")
	self.img_Size_R = SoraDGetChildByName(self, "img_Size_R")
	self.img_Size_L = SoraDGetChildByName(self, "img_Size_L")
	self.Top_Node_Status = SoraDGetChildByName(self, "Top_Node_Status")
	self.frame_sheer_items_bg = SoraDGetChildByName(self, "frame_sheer_items_bg")
	self.frame_SVIP_title_R_ = SoraDGetChildByName(self, "frame_SVIP_title_R_")
	self.frame_SVIP_title_L_ = SoraDGetChildByName(self, "frame_SVIP_title_L_")
	self.frame_LegendaryKing_base_L = SoraDGetChildByName(self, "frame_LegendaryKing_base_L")
	self.frame_LegendaryKing_base_R = SoraDGetChildByName(self, "frame_LegendaryKing_base_R")
	self.text_peace_status = SoraDGetChildByName(self, "text_peace_status")
	self.sprite_peace_status = SoraDGetChildByName(self, "sprite_peace_status")
	self.text_time_des = SoraDGetChildByName(self, "text_time_des")
	self.btn_stage_reward = SoraDGetChildByName(self, "btn_stage_reward")
	self.btn_stage_reward:setTitleText(i18n("common_text_3141"))
	self.btn_stage_reward:addTouchEventListener(handler(self, self.onClickBtnStageReward))
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.btn_hegemon_info:addTouchEventListener(handler(self, self.onClick_btn_hegemon_info))
	_UPVALUE6_ = self.btn_hegemon_info.addTouchEventListener
	self.timePadding, self.btn_hegemon_info.addTouchEventListener[1] = self.btn_hegemon_info.addTouchEventListener, 56
	self.timePadding, self.btn_hegemon_info.addTouchEventListener[2] = self.btn_hegemon_info.addTouchEventListener, 56
	self.timePadding, self.btn_hegemon_info.addTouchEventListener[3] = self.btn_hegemon_info.addTouchEventListener, 90
	self.timePadding, self.btn_hegemon_info.addTouchEventListener[4] = self.btn_hegemon_info.addTouchEventListener, 45
	self.timePadding, self.btn_hegemon_info.addTouchEventListener[5] = self.btn_hegemon_info.addTouchEventListener, 86
	self.timePadding, self.btn_hegemon_info.addTouchEventListener[6] = self.btn_hegemon_info.addTouchEventListener, 50
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.activity_time:addTo(self.time_node_cooling)
	self.activity_time:setPosition(cc.p(-50, 327))
	self.activity_time:setLocalZOrder(10)
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
	_UPVALUE3_ = self.Panel_Content.setPositionY
	self.tbContentNodes, self.Panel_Content.setPositionY[1] = self.Panel_Content.setPositionY, self.node_reward_info
	self.tbContentNodes, self.Panel_Content.setPositionY[2] = self.Panel_Content.setPositionY, self.node_time_info
	self.tbContentNodes, self.Panel_Content.setPositionY[3] = self.Panel_Content.setPositionY, self.nodeReward_node
	for i, v in ipairs(self.tbContentNodes) do
		v.oriPosY = v:getPositionY()
	end
	hegemonRead, self.tbRewardInUse, _ENV, self.templateNodeReward = self.nodeReward_node, self.nodeReward_node, self.nodeReward_node, self.nodeReward_node
	self.tbRewardNotInUse, self.nodeReward_node[1] = self.nodeReward_node, self.nodeReward_node
	self.kingReward = hegemonRead.getWarRankReward(1)
	self:showLegendReward()
	self:init()
	self.btn_hegemon_info:setTitleText(i18n("common_text_059"))
	SoraDAutoSizeButtonText(self.btn_hegemon_info)
	self.commonFramTitle_node:setTitle(i18n("hegemon_name_13"))
	_UPVALUE2_ = self.commonFramTitle_node
	self.commonFramTitle_node[1] = self.Size_frame_sheer_items_R
	self.commonFramTitle_node[2] = self.Size_frame_sheer_items_L
	SoraDAdjustFitHeightArray(self.commonFramTitle_node)
	hegemonRead = self.commonFramTitle_node
	self.commonFramTitle_node[1] = self.frame_sheer_items_Top
	SoraDAdjustFitPosArray(self.commonFramTitle_node)
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(70)
	nodeFireL:setPositionX(2)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(70)
	nodeFireR:setPositionX(2)
	nodeFireR:addTo(self.Node_fire_R)
end
function hegemonPrepare:onClickBtnStageReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("legendStageReward"):show()
	end
end
function hegemonPrepare:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function hegemonPrepare:updateTime()
	local eid = self.timeTbInfo.min_preparetimeId
	local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
	if eventLeftTime then
		local timerNode = eventLeftTime.timerNode
		if timerNode then
			self.activity_time:setTime(timerNode.timer:getRemainTime())
		end
	end
end
function hegemonPrepare:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function hegemonPrepare:createUI()
end
function hegemonPrepare:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	cloneNode = include("nodeReward").new(cloneNode)
	cloneNode:addTo(self.templateNodeReward:getParent())
	cloneNode:setPosition(cc.p(self.templateNodeReward:getPosition()))
	return cloneNode
end
function hegemonPrepare:updateSessionTime()
	local strTimeStr = string.format("UTC+0 %s--%s", os.date("!%Y.%m.%d %H:%M", self.timeTbInfo.min_activetime), os.date("!%Y.%m.%d %H:%M", self.timeTbInfo.max_settletime))
	self.text_time_des:setString(strTimeStr)
end
function hegemonPrepare:init(data)
	local legendState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
	self.timeTbInfo = timeTbInfo
	if legendState == gActivityState.PREPARE then
		self.text_peace_status:setString(i18n("common_text_4210"))
		self.text_time_title:setString(i18n("common_text_608"))
		self.text_des:setString(i18n("hegemon_text_09"))
		self.text_reward_title:setString(i18n("hegemon_title_01"))
		self:beginTime()
		self:updateSessionTime()
	else
		print("hegemon state error!")
	end
	_UPVALUE2_ = "hegemon state error!"
	;("hegemon state error!")[1] = self.text_peace_status
	;("hegemon state error!")[2] = self.sprite_peace_status
	_ENV = self.sprite_peace_status
	self.sprite_peace_status[1] = 10
	SoraDAlignNodeArray("hegemon state error!", not SoraDFIsRA(), self.sprite_peace_status)
	_UPVALUE2_ = "hegemon state error!"
	;("hegemon state error!")[1] = self.text_reward_title
	;("hegemon state error!")[2] = self.frame_maintenance_L
	_ENV = self.frame_maintenance_L
	self.frame_maintenance_L[1] = 15
	SoraDAlignNodeArray("hegemon state error!", true, self.frame_maintenance_L)
	_UPVALUE2_ = "hegemon state error!"
	;("hegemon state error!")[1] = self.text_reward_title
	;("hegemon state error!")[2] = self.frame_maintenance_R
	_ENV = self.frame_maintenance_R
	self.frame_maintenance_R[1] = 15
	SoraDAlignNodeArray("hegemon state error!", false, self.frame_maintenance_R)
end
function hegemonPrepare:recycleRewards()
	for i = 1, #self.tbRewardInUse do
		self.tbRewardInUse[i]:setVisible(false)
		self.tbRewardInUse[i]:removeGlow()
		table.insert(self.tbRewardNotInUse, self.tbRewardInUse[i])
	end
	self.tbRewardInUse, _ENV = 1, (for index)
end
function hegemonPrepare:showLegendReward()
	self:recycleRewards()
	local singleH = 150
	local numRewards = #self.kingReward
	local paddingy = 10
	local numx = math.min(4, math.max(3, math.ceil(numRewards / 2)))
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
		table.insert(self.tbRewardInUse, nodeReward)
		nodeReward:init(self.kingReward[i])
	end
	for i = 1, 3 do
		if self.kingReward[i].id == 6200111 then
			self.tbRewardInUse[i]:showGlow()
			break
		end
	end
	local marginx = (616 - 120 * numx - 60 * (numx - 1)) / 2
	if numx == 4 then
		marginx = 50
	end
	_ENV = 60 * (numx - 1)
	;(60 * (numx - 1)).directionx = ua.Direction.LEFT
	;(60 * (numx - 1)).directiony = ua.Direction.UP
	;(60 * (numx - 1)).totalWidth = 616
	;(60 * (numx - 1)).itemWidth = 120
	;(60 * (numx - 1)).itemHeight = 150
	;(60 * (numx - 1)).numx = numx
	;(60 * (numx - 1)).beginx = 0
	;(60 * (numx - 1)).offsetx = -60
	;(60 * (numx - 1)).beginy = 10
	;(60 * (numx - 1)).offsety = -75.0
	;(60 * (numx - 1)).marginx = marginx
	;(60 * (numx - 1)).marginy = 0
	;(60 * (numx - 1)).totalNum = #self.tbRewardInUse
	local (60 * (numx - 1)).paddingy, param = paddingy, 60 * (numx - 1)
	ua.alignHFits(self.tbRewardInUse, param)
end
function hegemonPrepare:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKING_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
end
function hegemonPrepare:onClick_Button_help(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if IsArClient then
			userSDKManager.showFAQSection(_G.gSDKDef.FAQSectionType.HEGEMON_LORD)
		else
			userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.HEGEMON_LORD_ROS)
		end
	end
end
function hegemonPrepare:onClick_btn_rank_view(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingRank")
		panel:init()
		panel:show()
	end
end
function hegemonPrepare:onClick_btn_enter_battle_active(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local isInWar = worldMapDefine.isInLegendLord()
		if not isInWar then
			SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
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
function hegemonPrepare:onClick_btn_hegemon_info(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDCreatePanel("hegemonActivity"):show()
	end
end
function hegemonPrepare:msgShowItemInfo(target, data)
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function hegemonPrepare:openItemInfoMsg(data)
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
function hegemonPrepare:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function hegemonPrepare:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID then
		if type(data.activityID) == "number" then
			hegemonCtrl = type(data.activityID)
			type(data.activityID)[1] = data.activityID
			if type(data.activityID) then
				goto lbl_23
			end
		end
		::lbl_23::
		data.activityID = data.activityID
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == gActivityCenterUIEnum.LEGEND_HEGEMON then
				local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
				if hegemonState == gActivityState.OPEN then
					self:closePanel()
				end
			end
		end
	end
end
return hegemonPrepare
