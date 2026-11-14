local gametop = gModuleMgr.getObject("gametop")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local hegemonRead = include("hegemonRead")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local chatFunctions = include("chatFunctions")
local colorPrepare = cc.c3b(0, 190, 30)
local colorActive = cc.c3b(238, 33, 33)
local colorFinish = cc.c3b(230, 180, 110)
local hegemonBuildView = class("hegemonBuildView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("hegemonBuildView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function hegemonBuildView:ctor()
	self:createUI()
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeBg_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeBg_node")
	self.img_activity_bg = SoraDGetChildByName(self, "img_activity_bg")
	self.commonFramTitle_Node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_Node")
	self.frame_throne_contend = SoraDGetChildByName(self, "frame_throne_contend")
	self.Top_Size_ScrollView_Content = SoraDGetChildByName(self, "Top_Size_ScrollView_Content")
	self.node_build_temp = SoraDGetChildByName(self, "node_build_temp")
	self.bg_node_img = SoraDGetChildByName(self, "bg_node_img")
	self.sp_fight = SoraDGetChildByName(self, "sp_fight")
	self.img_frame_node = SoraDGetChildByName(self, "img_frame_node")
	self.sp_bc_frame = SoraDGetChildByName(self, "sp_bc_frame")
	self.sp_build_frame = SoraDGetChildByName(self, "sp_build_frame")
	self.img_build_icon = SoraDGetChildByName(self, "img_build_icon")
	self.bg_text_coordinate = SoraDGetChildByName(self, "bg_text_coordinate")
	self.text_cordinate = SoraDGetChildByName(self, "text_cordinate")
	self.bg_build_name = SoraDGetChildByName(self, "bg_build_name")
	self.text_build_name = SoraDGetChildByName(self, "text_build_name")
	self.text_status = SoraDGetChildByName(self, "text_status")
	self.text_time = SoraDGetChildByName(self, "text_time")
	self.node_search = SoraDGetChildByName(self, "node_search")
	self.img_search_bg = SoraDGetChildByName(self, "img_search_bg")
	self.img_search_icon = SoraDGetChildByName(self, "img_search_icon")
	self.icon_join = SoraDGetChildByName(self, "icon_join")
	self.text_join = SoraDGetChildByName(self, "text_join")
	self.text_player_name = SoraDGetChildByName(self, "text_player_name")
	self.img_lord_icon = SoraDGetChildByName(self, "img_lord_icon")
	self.Bottom_Node_bg = SoraDGetChildByName(self, "Bottom_Node_bg")
	self.frame_LegendaryKing_base_down_R = SoraDGetChildByName(self, "frame_LegendaryKing_base_down_R")
	self.frame_LegendaryKing_base_down_L = SoraDGetChildByName(self, "frame_LegendaryKing_base_down_L")
	self.frame_lace_base_L = SoraDGetChildByName(self, "frame_lace_base_L")
	self.frame_lace_base_R = SoraDGetChildByName(self, "frame_lace_base_R")
	local nodeFireL = SoraDGetCommonJetFireNode()
	nodeFireL:addTo(self.frame_lace_base_L)
	nodeFireL:setPositionY(120)
	nodeFireL:setPositionX(34)
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:addTo(self.frame_lace_base_R)
	nodeFireR:setPositionY(120)
	nodeFireR:setPositionX(40)
	self.frame_throne_contend:setFillType(1)
	self.commonFramTitle_Node:setTitle(i18n("hegemon_title_05"))
	self.preStatus, _ENV, self.nodes, _ENV = self.commonFramTitle_Node.setTitle, self.commonFramTitle_Node.setTitle, self.commonFramTitle_Node.setTitle, self.commonFramTitle_Node.setTitle
	self:init()
end
function hegemonBuildView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function hegemonBuildView:init(data)
	SoraDShowLoading(self)
	hegemonCtrl:reqBuildInfoList()
end
function hegemonBuildView:initView(data)
	_UPVALUE6_ = nil
	;(nil)[1] = gActivityTimeActivityID.LEGEND_HEGEMON_1
	;(nil)[2] = gActivityTimeActivityID.LEGEND_HEGEMON_2
	;(nil)[3] = gActivityTimeActivityID.LEGEND_HEGEMON_3
	;(nil)[4] = gActivityTimeActivityID.LEGEND_HEGEMON_4
	;(nil)[5] = gActivityTimeActivityID.LEGEND_HEGEMON_5
	local (nil)[6], activityArray = gActivityTimeActivityID.LEGEND_HEGEMON_6, nil
	dump(activityArray, "排序前", 10)
	table.sort(activityArray, function(a1, a2)
		local param1 = activityShowCtrl:getParamByID(a1)
		local param2 = activityShowCtrl:getParamByID(a2)
		if param1.curState == ACTIVITY_STATE.ACTIVE and param2.curState == ACTIVITY_STATE.ACTIVE then
			return a1 < a2
		elseif param1.curState == ACTIVITY_STATE.ACTIVE and param2.curState ~= ACTIVITY_STATE.ACTIVE then
			return true
		elseif param1.curState ~= ACTIVITY_STATE.ACTIVE and param2.curState == ACTIVITY_STATE.ACTIVE then
			return false
		elseif param1.curState == ACTIVITY_STATE.PREPARE and param2.curState == ACTIVITY_STATE.PREPARE then
			return a1 < a2
		elseif param1.curState == ACTIVITY_STATE.PREPARE and param2.curState ~= ACTIVITY_STATE.PREPARE then
			return true
		elseif param1.curState ~= ACTIVITY_STATE.PREPARE and param2.curState == ACTIVITY_STATE.PREPARE then
			return false
		else
			return a1 < a2
		end
	end)
	dump(activityArray, "排序后", 10)
	self.activityArray = activityArray
	local singleH = 154
	local totalH = singleH * #self.activityArray + 80
	local scrollSize = self.Top_Size_ScrollView_Content:getContentSize()
	local maxH = math.max(scrollSize.height, totalH)
	self.Top_Size_ScrollView_Content:setInnerContainerSize(cc.size(scrollSize.width, maxH))
	for i, v in ipairs(self.activityArray) do
		self.preStatus[v] = activityShowCtrl:getParamByID(v).curState
		if self.nodes[i] == nil then
			self.nodes[i] = self.node_build_temp:clone()
			for j, t in ipairs(self.nodes[i]:getChildren()) do
				self.nodes[i][t:getName()] = t
			end
			self.nodes[i]:addTo(self.Top_Size_ScrollView_Content)
			self.nodes[i]:setPositionX(320)
			self.nodes[i]:setPositionY(maxH - i * singleH)
			local btn_search = self.nodes[i].node_search:getChildByName("btn_search")
			btn_search:setSwallowTouches(false)
			btn_search:addTouchEventListener(handler(self, self.onClick_btn_search))
			local btn_coordinate = self.nodes[i].btn_coordinate
			btn_coordinate:setSwallowTouches(false)
			btn_coordinate:addTouchEventListener(handler(self, self.onClick_btn_coordinate))
		end
		self:initBuild(v, self.nodes[i])
	end
	if self.timeHandler == nil then
		self:beginTime()
	end
end
function hegemonBuildView:initBuild(activityID, nodeBuild)
	local bid = hegemonRead.getBuildIdByActivityID(activityID)
	print("bid = ", bid)
	local param = activityShowCtrl:getParamByID(activityID)
	local curState = param.curState
	local icon = hegemonRead.getIcon(bid)
	local name = hegemonRead.getName(bid)
	print("name = ", name)
	local buildInfo = legendLordWarltCtrl.getLegendLordWarBuildingById(bid)
	hegemonRead = bid
	bid.x = buildInfo.x
	nodeBuild.coordinate, bid.y = bid, buildInfo.y
	hegemonRead = nil
	;(nil).x = buildInfo.x
	;(nil).y = buildInfo.y
	local strCoordinate = i18n("common_text_2155", nil)
	hegemonRead = nil
	;(nil).x = buildInfo.x
	nodeBuild.btn_coordinate.coordinate, (nil).y = nil, buildInfo.y
	nodeBuild.text_build_name:setString(name)
	nodeBuild.img_build_icon:loadTexture(icon, ccui.TextureResType.plistType)
	nodeBuild.text_coordinate:setString(strCoordinate)
	local btn_search = SoraDGetChildByName(nodeBuild.node_search, "btn_search")
	btn_search.coordinate = coordinate
	btn_search.bid = bid
	local strStatus = "NA"
	local strColor = colorFinish
	local isSelfJoin = false
	if hegemonCtrl:getJoinBid() == bid then
		isSelfJoin = true
	end
	if isSelfJoin then
		local kid = chatFunctions:getSelfSourceKID()
		nodeBuild.text_join:setString(i18n("hegemon_text_11") .. "#" .. kid)
		nodeBuild.text_join:setVisible(true)
		nodeBuild.icon_join:setVisible(true)
	else
		nodeBuild.text_join:setVisible(false)
		nodeBuild.icon_join:setVisible(false)
	end
	nodeBuild.sp_fight:setVisible(false)
	nodeBuild.text_player_name:setVisible(false)
	nodeBuild.img_lord_icon:setVisible(false)
	if curState == ACTIVITY_STATE.PREPARE then
		strStatus = i18n("common_text_4210")
		strColor = colorPrepare
	elseif curState == ACTIVITY_STATE.ACTIVE then
		strStatus = i18n("common_text_343")
		strColor = colorActive
		nodeBuild.sp_fight:setVisible(true)
		nodeBuild.sp_fight:stopAllActions()
		local actionTintTo = cca.fadeTo(1, 0)
		local actionTinBack = cca.fadeTo(1, 1)
		local actionDelay = cca.delay(0.8)
		legendLordWarltCtrl = kid
		kid[1] = actionTintTo
		kid[2] = actionTinBack
		kid[3] = actionDelay
		local actionRepeat = cca.repeatForever(cca.seq(kid))
		nodeBuild.sp_fight:runAction(actionRepeat)
	elseif curState == ACTIVITY_STATE.SETTLE then
		strColor = colorFinish
		local bid = hegemonRead.getBuildIdByActivityID(activityID)
		nodeBuild.text_player_name:setString(self:getLegendKingName(bid))
		nodeBuild.text_player_name:setVisible(true)
		nodeBuild.img_lord_icon:setVisible(true)
		strStatus = i18n("common_text_1859")
	else
		strStatus = i18n("common_text_1859")
	end
	nodeBuild.text_status:setString(strStatus)
	nodeBuild.text_status:setColor(strColor)
end
function hegemonBuildView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function hegemonBuildView:updateTime()
	for i, v in ipairs(self.activityArray) do
		local curState = activityShowCtrl:getParamByID(v).curState
		local nodeBuild = self.nodes[i]
		local textTarget = nodeBuild.text_time
		local textKey = ""
		if curState == ACTIVITY_STATE.PREPARE or curState == ACTIVITY_STATE.ACTIVE then
			if curState == ACTIVITY_STATE.PREPARE then
				textKey = "common_text_606"
			else
				textKey = "common_text_607"
			end
			local eid = v
			local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
			if eventLeftTime then
				local timerNode = eventLeftTime.timerNode
				if textTarget and timerNode then
					_ENV = nil
					;(nil).time = SoraDConvertSecondToString(timerNode.timer:getRemainTime())
					textTarget:setString(i18n(textKey, nil))
				end
			end
		end
	end
end
function hegemonBuildView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function hegemonBuildView:getLegendKingName(bid)
	local legendKingInfo = hegemonCtrl:getHegemonInfoByBid(bid)
	if legendKingInfo == nil or next(legendKingInfo) == nil then
		return i18n("common_text_480")
	end
	local playerInfo = legendKingInfo.playerInfo
	local allianceInfo = legendKingInfo.allianceInfo
	local kingdomInfo = legendKingInfo.kingdomInfo
	local strInfo = ""
	if allianceInfo and allianceInfo.abbr then
		hegemonCtrl = nil
		;(nil).abbr = allianceInfo.abbr
		;(nil).name = playerInfo.nickName
		strInfo = i18n("common_text_186", nil)
	elseif playerInfo then
		strInfo = playerInfo.nickName
	end
	if kingdomInfo then
		strInfo = strInfo .. "#" .. kingdomInfo.kid
	end
	return strInfo
end
function hegemonBuildView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_BUILD_INFO_LIST_BACK", handler(self, self.sMsgHandlerBuildInfoListBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
end
function hegemonBuildView:sMsgCommonRefresh(target, data)
	local anyChangeToSettle = false
	for i, v in ipairs(self.activityArray) do
		local curState = activityShowCtrl:getParamByID(v).curState
		if curState ~= self.preStatus[v] and curState == ACTIVITY_STATE.SETTLE then
			anyChangeToSettle = true
		end
	end
	if anyChangeToSettle then
		hegemonCtrl:reqBuildInfoList()
	else
		self:initView()
	end
end
function hegemonBuildView:sMsgHandlerBuildInfoListBack(target, data)
	SoraDCloseLoading(self)
	self:initView()
end
function hegemonBuildView:onClick_btn_search(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.Top_Size_ScrollView_Content) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("bid = ", button.bid)
		local panel = SoraDCreatePanel("hegemonKingView")
		panel:show()
		_ENV = nil
		;(nil).bid = button.bid
		panel:init(nil)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function hegemonBuildView:onClick_btn_coordinate(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.Top_Size_ScrollView_Content) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("bid = ", bid)
		local coordinate = button.coordinate
		SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
		self:closePanel()
		SoraDRemoveAllPanelFromManager()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return hegemonBuildView
