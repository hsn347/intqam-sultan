local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local worldMapDefine = include("worldMapDefine")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local ua = include("utilAlign")
local hegemonRead = include("hegemonRead")
local mainUIDef = include("mainUIDef")
local lordLocalData = include("lordLocalData")
local nationalFlagRead = include("nationalFlagRead")
local allianceDesRead = include("allianceDesRead")
local chatFunctions = include("chatFunctions")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local legendLordWarCtrl = SoraDGetCtrl("legendLordWarCtrl")
local colorSel = cc.c3b(255, 206, 87)
local colorUnSel = cc.c3b(215, 195, 155)
local hegemonActivity = class("hegemonActivity", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("hegemonActivity")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function hegemonActivity:createTimeNode(numOfChar, initTime, paddingArray)
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
function hegemonActivity:ctor()
	self.singleIsMoved = false
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Node_info = SoraDGetChildByName(self, "Top_Node_info")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Img_help = SoraDGetChildByName(self, "Img_help")
	self.Node_bg = SoraDGetChildByName(self, "Node_bg")
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
	self.txtTimeSettle = SoraDGetChildByName(self, "text_time_settle")
	self.text_time_num = SoraDGetChildByName(self, "text_time_num")
	self.frame_time_num_bg = SoraDGetChildByName(self, "frame_time_num_bg")
	self.time_node_cooling = SoraDGetChildByName(self, "time_node_cooling")
	self.frame_LegendaryKing_countdown_12 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")
	self.frame_LegendaryKing_countdown_13 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_13")
	self.frame_LegendaryKing_countdown_14 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_14")
	self.frame_LegendaryKing_countdown_15 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_15")
	self.frame_LegendaryKing_countdown_16 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_16")
	self.frame_LegendaryKing_countdown_17 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_17")
	self.frame_LegendaryKing_countdown_18 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_18")
	self.text_des = SoraDGetChildByName(self, "text_des")
	self.nodeReward_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeReward_node")
	self.Top_Node_Status = SoraDGetChildByName(self, "Top_Node_Status")
	self.frame_sheer_items_bg = SoraDGetChildByName(self, "frame_sheer_items_bg")
	self.frame_SVIP_title_R_ = SoraDGetChildByName(self, "frame_SVIP_title_R_")
	self.frame_SVIP_title_L_ = SoraDGetChildByName(self, "frame_SVIP_title_L_")
	self.frame_LegendaryKing_base_L = SoraDGetChildByName(self, "frame_LegendaryKing_base_L")
	self.frame_LegendaryKing_base_R = SoraDGetChildByName(self, "frame_LegendaryKing_base_R")
	self.text_war_status = SoraDGetChildByName(self, "text_war_status")
	self.text_peace_status = SoraDGetChildByName(self, "text_peace_status")
	self.sprite_war_status = SoraDGetChildByName(self, "sprite_war_status")
	self.sprite_peace_status = SoraDGetChildByName(self, "sprite_peace_status")
	self.frame_bg_red = SoraDGetChildByName(self, "frame_bg_red")
	self.frame_bg_blue = SoraDGetChildByName(self, "frame_bg_blue")
	self.scrollViewEvents = SoraDGetChildByName(self, "scrollViewEvents")
	self.node_event_temp = SoraDGetChildByName(self, "node_event_temp")
	self.panel_btn_bg_mask = SoraDGetChildByName(self, "panel_btn_bg_mask")
	self.img_lord_bg_R = SoraDGetChildByName(self, "img_lord_bg_R")
	self.img_lord_bg_L = SoraDGetChildByName(self, "img_lord_bg_L")
	self.img_lord_bg_L_D = SoraDGetChildByName(self, "img_lord_bg_L_D")
	self.img_lord_bg_R_D = SoraDGetChildByName(self, "img_lord_bg_R_D")
	self.Size_img_R = SoraDGetChildByName(self, "Size_img_R")
	self.Size_img_L = SoraDGetChildByName(self, "Size_img_L")
	self.Size_img_R.oriSize = self.Size_img_R:getContentSize()
	self.Size_img_L.oriSize = self.Size_img_L:getContentSize()
	self.Top_Sprite_king_gray = SoraDGetChildByName(self, "Top_Sprite_king_gray")
	self.Top_Sprite_king_nor = SoraDGetChildByName(self, "Top_Sprite_king_nor")
	self.Bottom_Node_bg = SoraDGetChildByName(self, "Bottom_Node_bg")
	self.text_reward_des = SoraDGetChildByName(self, "text_reward_des")
	self.frame_red_lace_R = SoraDGetChildByName(self, "frame_red_lace_R")
	self.frame_red_lace_L = SoraDGetChildByName(self, "frame_red_lace_L")
	self.Top_Node_over = SoraDGetChildByName(self, "Top_Node_over")
	self.img_bottom_frame = SoraDGetChildByName(self, "img_bottom_frame")
	self.node_bottom_ops = SoraDGetChildByName(self, "node_bottom_ops")
	self.Top_Node_Status_Hegemon = SoraDGetChildByName(self, "Top_Node_Status_Hegemon")
	self.nodeOpReward = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_reward")
	self.nodeOpHistory = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_history")
	self.nodeOpWarRank = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_warRank")
	self.nodeOpManage = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_manage")
	self.nodeOpGift = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_gift")
	self.nodeOpKingdom = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_kingdom")
	self.nodeOp_land = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_land")
	self.frame_throne_contend = SoraDGetChildByName(self, "frame_throne_contend")
	self.frame_throne_contend:setFillType(1)
	self.text_kingdom_name = SoraDGetChildByName(self, "text_kingdom_name")
	self.text_king_name = SoraDGetChildByName(self, "text_king_name")
	self.sprite_kingdom_icon = SoraDGetChildByName(self, "sprite_kingdom_icon")
	self.text_alliance_name = SoraDGetChildByName(self, "text_alliance_name")
	self.node_alliance = SoraDGetChildByName(self, "node_alliance")
	self.bg_alliance_name = SoraDGetChildByName(self, "bg_alliance_name")
	self.Scroll_Content = SoraDGetChildByName(self, "Scroll_Content")
	self.Panel_Bottom_Content = SoraDGetChildByName(self, "Panel_Bottom_Content")
	self.Image_Tile_bg_pp = SoraDGetChildByName(self, "Image_Tile_bg_pp")
	self.Image_Tile_bg_pp:setFillType(1)
	self.headBig_node = SoraDGetChildByName(self, "headBig_node")
	self.frame_head = SoraDGetChildByName(self, "frame_head")
	self.Top_Bg_King = SoraDGetChildByName(self, "Top_Bg_King")
	self.Top_Bg_King:loadTexture("bg_bzzz_01.png", ccui.TextureResType.plistType)
	self.btn_node_alliance = SoraDGetChildByName(self, "btn_node_alliance")
	self.Top_Btn_King = SoraDGetChildByName(self, "Top_Btn_King")
	self.Top_Btn_King:addTouchEventListener(handler(self, self.onClickBtnKing))
	self.btn_node_alliance:addTouchEventListener(handler(self, self.onClickBtnAlliance))
	self.frame_blue_lace_L = SoraDGetChildByName(self, "frame_blue_lace_L")
	self.frame_blue_lace_R = SoraDGetChildByName(self, "frame_blue_lace_R")
	self.btn_hegemon_info = SoraDGetChildByName(self, "btn_hegemon_info")
	self.btn_team = SoraDGetChildByName(self, "btn_team")
	self.btn_enter_battle = SoraDGetChildByName(self, "btn_enter_battle")
	self.node_group_events = SoraDGetChildByName(self, "node_group_events")
	self.node_group_events:setGroupID(mainUIDef.uiGroupID.group_normal_view_1, true)
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.btn_enter_battle:addTouchEventListener(handler(self, self.onClick_btn_enter_battle))
	self.btn_hegemon_info:addTouchEventListener(handler(self, self.onClick_btn_hegemon_info))
	self.btn_team:addTouchEventListener(handler(self, self.onClick_btn_team))
	self.text_btn_hegemon_info = SoraDGetChildByName(self, "text_btn_hegemon_info")
	if self.text_btn_hegemon_info then
		self.text_btn_hegemon_info:setString(i18n("hegemon_title_06"))
		local oriPos = cc.p(self.text_btn_hegemon_info:getPosition())
		if self.text_btn_hegemon_info:getContentSize().width / 2 > 70 then
			self.text_btn_hegemon_info:setPositionX(oriPos.x - (self.text_btn_hegemon_info:getContentSize().width / 2 - 70))
		end
	end
	self.Node_store = SoraDGetChildByName(self, "Node_store")
	self.Text_store = SoraDGetChildByName(self.Node_store, "Text_store")
	self.Text_store:setString(i18n("hegemon_text_60"))
	self.Button_store = SoraDGetChildByName(self.Node_store, "Button_store")
	self.Button_store:addTouchEventListener(handler(self, self.onStoreClick))
	self.img_redPoint = SoraDGetChildByName(self.Node_store, "img_redPoint")
	self.Text_redPointInt = SoraDGetChildByName(self.Node_store, "Text_redPointInt")
	self.Node_store_ex = SoraDGetChildByName(self, "Node_store_ex")
	self.Text_store_ex = SoraDGetChildByName(self.Node_store_ex, "Text_store")
	self.Text_store_ex:setString(i18n("hegemon_text_60"))
	self.Button_store_ex = SoraDGetChildByName(self.Node_store_ex, "Button_store")
	self.Button_store_ex:addTouchEventListener(handler(self, self.onStoreClick))
	self.img_redPoint_ex = SoraDGetChildByName(self.Node_store_ex, "img_redPoint")
	self.Text_redPointInt_ex = SoraDGetChildByName(self.Node_store_ex, "Text_redPointInt")
	self.node_join = SoraDGetChildByName(self, "node_join")
	self.text_join = SoraDGetChildByName(self, "text_join")
	self.icon_join = SoraDGetChildByName(self, "icon_join")
	self.btnStageReward = SoraDGetChildByName(self, "btn_stage_reward")
	self.btnStageReward:setTitleText(i18n("common_text_3141"))
	self.btnStageReward:setVisible(false)
	self.btnStageReward:addTouchEventListener(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_REWARD
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpReward)
	self.nodeOpReward:init(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_WAR_RANK
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpWarRank)
	self.nodeOpWarRank:init(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_MANAGE
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpManage)
	self.nodeOpManage:init(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_GIFT
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpGift)
	self.nodeOpGift:init(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_HISTORY
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpHistory)
	self.nodeOpHistory:init(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_KINGDOM
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpKingdom)
	self.nodeOpKingdom:init(handler(self, self.onClickBtnStageReward))
	_ENV = handler(self, self.onClickBtnStageReward)
	handler(self, self.onClickBtnStageReward).id = gLegendOpType.OP_LAND
	handler(self, self.onClickBtnStageReward).handle = handler(self, self.onBtnClickOpLand)
	self.nodeOp_land:init(handler(self, self.onClickBtnStageReward))
	_UPVALUE6_ = self.nodeOp_land.init
	self.timePadding, self.nodeOp_land.init[1] = self.nodeOp_land.init, 56
	self.timePadding, self.nodeOp_land.init[2] = self.nodeOp_land.init, 56
	self.timePadding, self.nodeOp_land.init[3] = self.nodeOp_land.init, 90
	self.timePadding, self.nodeOp_land.init[4] = self.nodeOp_land.init, 45
	self.timePadding, self.nodeOp_land.init[5] = self.nodeOp_land.init, 86
	self.timePadding, self.nodeOp_land.init[6] = self.nodeOp_land.init, 50
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.activity_time:addTo(self.time_node_cooling)
	self.activity_time:setPosition(cc.p(-50, 327))
	self.activity_time:setLocalZOrder(10)
	local obj = fguiHelper.createObject("KingStarBattle", "Button_hospital_hegemon")
	obj:addTo(self.btn_hegemon_info:getParent())
	obj:setPivot(0.5, 0.5, true)
	obj:setPosition(458, -480)
	obj:setScale(0.9)
	_ENV = 0.9
	;(0.9).warType = gKingdomClassType.legendLord
	obj:initData(0.9)
	legendTeamCtrl, self.btn_hospital_active = obj.initData, obj
	_UPVALUE5_, self.tbArrayPrepare, obj.initData[1] = obj.initData, obj.initData, self.text_peace_status
	_UPVALUE5_, self.tbArrayPrepare, obj.initData[2] = obj.initData, obj.initData, self.sprite_peace_status
	_UPVALUE5_, self.tbArrayPrepare, obj.initData[3] = obj.initData, obj.initData, self.frame_bg_blue
	_UPVALUE13_, self.tbArrayActive, obj.initData[1] = obj.initData, obj.initData, self.text_war_status
	_UPVALUE13_, self.tbArrayActive, obj.initData[2] = obj.initData, obj.initData, self.sprite_war_status
	_UPVALUE13_, self.tbArrayActive, obj.initData[3] = obj.initData, obj.initData, self.frame_time_num_bg
	_UPVALUE13_, self.tbArrayActive, obj.initData[4] = obj.initData, obj.initData, self.frame_bg_red
	_UPVALUE13_, self.tbArrayActive, obj.initData[5] = obj.initData, obj.initData, self.btn_hospital_active
	_UPVALUE7_, self.tbArraySettle, obj.initData[1] = obj.initData, obj.initData, self.Top_Sprite_king_gray
	_UPVALUE7_, self.tbArraySettle, obj.initData[2] = obj.initData, obj.initData, self.Top_Sprite_king_nor
	_UPVALUE7_, self.tbArraySettle, obj.initData[3] = obj.initData, obj.initData, self.Top_Btn_King
	_UPVALUE7_, self.tbArraySettle, obj.initData[4] = obj.initData, obj.initData, self.Bottom_Node_bg
	_UPVALUE7_, self.tbArraySettle, obj.initData[5] = obj.initData, obj.initData, self.text_reward_des
	_UPVALUE7_, self.tbArraySettle, obj.initData[6] = obj.initData, obj.initData, self.frame_red_lace_R
	_UPVALUE7_, self.tbArraySettle, obj.initData[7] = obj.initData, obj.initData, self.frame_red_lace_L
	_UPVALUE7_, self.tbArraySettle, obj.initData[8] = obj.initData, obj.initData, self.Top_Node_over
	_UPVALUE7_, self.tbArraySettle, obj.initData[9] = obj.initData, obj.initData, self.img_bottom_frame
	_UPVALUE7_, self.tbArraySettle, obj.initData[10] = obj.initData, obj.initData, self.node_bottom_ops
	_UPVALUE7_, self.tbArraySettle, obj.initData[11] = obj.initData, obj.initData, self.Top_Node_Status_Hegemon
	_UPVALUE7_, self.tbArraySettle, obj.initData[12] = obj.initData, obj.initData, self.Top_Bg_King
	_UPVALUE7_, self.tbArraySettle, obj.initData[13] = obj.initData, obj.initData, self.Scroll_Content
	self.tbArrayOpenCommon, obj.initData[1] = obj.initData, self.img_lord_bg_R
	self.tbArrayOpenCommon, obj.initData[2] = obj.initData, self.img_lord_bg_L
	self.tbArrayOpenCommon, obj.initData[3] = obj.initData, self.img_lord_bg_L_D
	self.tbArrayOpenCommon, obj.initData[4] = obj.initData, self.img_lord_bg_R_D
	self.tbArrayOpenCommon, obj.initData[5] = obj.initData, self.frame_blue_lace_L
	self.tbArrayOpenCommon, obj.initData[6] = obj.initData, self.frame_blue_lace_R
	self.tbArrayOpenCommon, obj.initData[7] = obj.initData, self.Size_ScrollView_Content
	self.Panel_Content.oriSize = self.Panel_Content:getContentSize()
	local scrollSize = self.Size_ScrollView_Content:getContentSize()
	local panelContentSize = self.Panel_Content:getContentSize()
	self.Panel_Content.oriSize = panelContentSize
	if scrollSize.height > panelContentSize.height then
		self.Size_ScrollView_Content:setInnerContainerSize(scrollSize)
	else
		self.Size_ScrollView_Content:setInnerContainerSize(panelContentSize)
	end
	local innerContainerSize = self.Size_ScrollView_Content:getInnerContainerSize()
	self.Panel_Content:setPositionY(innerContainerSize.height)
	legendTeamCtrl = self.Panel_Content.setPositionY
	self.tbContentNodes, self.Panel_Content.setPositionY[1] = self.Panel_Content.setPositionY, self.node_reward_info
	self.tbContentNodes, self.Panel_Content.setPositionY[2] = self.Panel_Content.setPositionY, self.node_time_info
	self.tbContentNodes, self.Panel_Content.setPositionY[3] = self.Panel_Content.setPositionY, self.nodeReward_node
	for i, v in ipairs(self.tbContentNodes) do
		v.oriPosY = v:getPositionY()
	end
	hegemonRead = (for generator)
	self.tbArrayPrepareOffset, ipairs(self.tbContentNodes)[1] = ipairs(self.tbContentNodes)
	self.tbArrayPrepareOffset, ipairs(self.tbContentNodes)[2] = ipairs(self.tbContentNodes)
	for i, v in ipairs(self.tbArrayPrepareOffset) do
		v.oriPosY = v:getPositionY()
	end
	self.node_join.oriPosY = self.node_join:getPositionY()
	mainUIDef, self.tbRewardInUse, _ENV, self.templateNodeReward = self.nodeReward_node, self.nodeReward_node, self.nodeReward_node, self.nodeReward_node
	self.tbRewardNotInUse, self.nodeReward_node[1] = self.nodeReward_node, self.nodeReward_node
	self.kingReward = hegemonRead.getWarRankReward(1)
	self:showLegendReward()
	if legendTeamCtrl:isHasTeam() then
		self.btn_team:setTitleText(i18n("remains_title_05"))
	else
		self.btn_team:setTitleText(i18n("complete_text_03"))
	end
	self.btn_enter_battle:setTitleText(i18n("common_text_3318"))
	SoraDAutoSizeButtonText(self.btn_rank_view)
	SoraDAutoSizeButtonText(self.btn_team)
	SoraDAutoSizeButtonText(self.btn_enter_battle_prepare)
	self.commonFramTitle_node:setTitle(i18n("hegemon_name_13"))
	hegemonRead = self.commonFramTitle_node
	self.commonFramTitle_node[1] = self.Size_frame_sheer_items_R
	self.commonFramTitle_node[2] = self.Size_frame_sheer_items_L
	SoraDAdjustFitHeightArray(self.commonFramTitle_node)
	mainUIDef = self.commonFramTitle_node
	self.commonFramTitle_node[1] = self.frame_sheer_items_Top
	SoraDAdjustFitPosArray(self.commonFramTitle_node)
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.numberView = SoraDGetExtendChildFromCCSByName(self, "CCS_commonScrollIndicatorNumber_node")
	self.numberView:setVisible(false)
	self.imgRed = SoraDGetChildByName(self, "Image_redPoint")
	self.remainTime = SoraDGetChildByName(self, "txtTime")
	self.remainTime = SoraDCreateTimerLabel(self, self.remainTime)
	self.imgRed:setVisible(false)
	self.remainTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.remainTime:setTimeEndListener(function()
		self:heroSoulIsOver()
		self = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self)
		self = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.curActivityID
		SoraDSendMessage(self)
	end)
	SoraDShowLoading(self)
	hegemonCtrl:reqBuildKingdomList()
	self.text_war_status:setString(i18n("common_text_1446"))
	self.text_peace_status:setString(i18n("common_text_4210"))
	self.text_reward_title:setString(i18n("hegemon_title_01"))
	hegemonRead = self.text_reward_title
	self.text_reward_title[1] = self.text_peace_status
	self.text_reward_title[2] = self.sprite_peace_status
	mainUIDef = self.sprite_peace_status
	self.sprite_peace_status[1] = 10
	SoraDAlignNodeArray(self.text_reward_title, not SoraDFIsRA(), self.sprite_peace_status)
	hegemonRead = self.text_reward_title
	self.text_reward_title[1] = self.text_war_status
	self.text_reward_title[2] = self.sprite_war_status
	mainUIDef = self.sprite_war_status
	self.sprite_war_status[1] = 10
	SoraDAlignNodeArray(self.text_reward_title, not SoraDFIsRA(), self.sprite_war_status)
	hegemonRead = self.text_reward_title
	self.text_reward_title[1] = self.text_reward_title
	self.text_reward_title[2] = self.frame_maintenance_L
	mainUIDef = self.frame_maintenance_L
	self.frame_maintenance_L[1] = 15
	SoraDAlignNodeArray(self.text_reward_title, true, self.frame_maintenance_L)
	hegemonRead = self.text_reward_title
	self.text_reward_title[1] = self.text_reward_title
	self.text_reward_title[2] = self.frame_maintenance_R
	mainUIDef = self.frame_maintenance_R
	self.frame_maintenance_R[1] = 15
	SoraDAlignNodeArray(self.text_reward_title, false, self.frame_maintenance_R)
	self:fitDevice()
	self:setHegemonEffect()
	local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
	self.btnHegemonPos = cc.p(self.btn_hegemon_info:getPosition())
	self.Node_storePos = cc.p(self.Node_store:getPositionX(), self.Node_store:getPositionY())
	self.Node_storeExPos = cc.p(self.Node_store_ex:getPositionX(), self.Node_store_ex:getPositionY())
end
function hegemonActivity:onClickBtnKing(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
		local hegemonInfo = hegemonCtrl:getHegemonInfoByBid(bid)
		if hegemonInfo == nil then
			return
		end
		local kingdomInfo = hegemonInfo.kingdomInfo
		if kingdomInfo == nil or next(kingdomInfo) == nil then
			return
		end
		SoraDPlaySound()
		local playerInfo = hegemonInfo.playerInfo
		local kid = kingdomInfo.kid
		local uid = playerInfo.uid
		self:reqPlayerInfo(uid, kid)
	end
end
function hegemonActivity:reqPlayerInfo(uid, kid)
	SoraDShowLoading(self)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local key = "fromHegemonActivity"
	_ENV = nil
	;(nil)[key] = true
	;(nil).targetName = key
	lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
end
function hegemonActivity:onClickBtnAlliance(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
		local hegemonInfo = hegemonCtrl:getHegemonInfoByBid(bid)
		if hegemonInfo == nil then
			return
		end
		local kingdomInfo = hegemonInfo.kingdomInfo
		if kingdomInfo == nil or next(kingdomInfo) == nil then
			return
		end
		SoraDPlaySound()
		SoraDShowLoading(self)
		local kid = kingdomInfo.kid
		local allianceInfo = hegemonInfo.allianceInfo
		local aid = allianceInfo.aid
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		print("请求联盟信息, kid = ", kid, ", aid = ", aid)
		_ENV = aid
		aid.from = "hegemonActivity"
		allianceQuery:reqAllianceInfo(kid, aid, aid)
	end
end
function hegemonActivity:fitDevice()
	if display.height >= 960 then
		local deltaH = display.height - 960
		print("hegemonActivity fitDevice:deltaH = ", deltaH)
		if 150 < deltaH then
			local deltaH1 = 150
			local deltaH2 = deltaH - deltaH1
			_UPVALUE4_ = nil
			;(nil)[1] = self.Top_Node_Status_Hegemon
			;(nil)[2] = self.Top_Sprite_king_nor
			;(nil)[3] = self.Top_Sprite_king_gray
			;(nil)[4] = self.Top_Btn_King
			SoraDAdjustFitPosArray(nil, true, deltaH1)
			_UPVALUE3_ = nil
			;(nil)[1] = self.Top_Sprite_king_nor
			;(nil)[2] = self.Top_Sprite_king_gray
			;(nil)[3] = self.Top_Btn_King
			SoraDAdjustFitPosArray(nil, false, 100)
			_UPVALUE3_ = nil
			;(nil)[1] = self.img_bottom_frame
			;(nil)[2] = self.Image_Tile_bg_pp
			;(nil)[3] = self.Scroll_Content
			SoraDAdjustFitHeightArray(nil, false, deltaH2)
			local innerContainerSize = self.Scroll_Content:getInnerContainerSize()
			self.Panel_Bottom_Content:setPositionY(innerContainerSize.height)
		else
			_UPVALUE3_ = deltaH - deltaH1
			;(deltaH - deltaH1)[1] = self.Top_Sprite_king_nor
			;(deltaH - deltaH1)[2] = self.Top_Sprite_king_gray
			;(deltaH - deltaH1)[3] = self.Top_Btn_King
			SoraDAdjustFitPosArray(deltaH - deltaH1, false, math.min(deltaH, 100))
			_UPVALUE4_ = deltaH - deltaH1
			;(deltaH - deltaH1)[1] = self.Top_Node_Status_Hegemon
			;(deltaH - deltaH1)[2] = self.Top_Sprite_king_nor
			;(deltaH - deltaH1)[3] = self.Top_Sprite_king_gray
			;(deltaH - deltaH1)[4] = self.Top_Btn_King
			SoraDAdjustFitPosArray(deltaH - deltaH1, true)
		end
	else
		_UPVALUE3_ = SoraDAdjustFitPosArray
		SoraDAdjustFitPosArray[1] = self.img_bottom_frame
		SoraDAdjustFitPosArray[2] = self.Image_Tile_bg_pp
		SoraDAdjustFitPosArray[3] = self.Scroll_Content
		SoraDAdjustFitHeightArray(SoraDAdjustFitPosArray)
		local innerContainerSize = self.Scroll_Content:getInnerContainerSize()
		self.Panel_Bottom_Content:setPositionY(innerContainerSize.height)
		self.Top_Sprite_king_nor:setVisible(false)
		self.Top_Sprite_king_gray:setVisible(false)
	end
	_ENV = innerContainerSize
	self.Scroll_Content:getInnerContainerSize()[1] = self.nodeOpReward:getPositionY()
	_UPVALUE1_, _ENV, self.opYMap, self.Scroll_Content:getInnerContainerSize()[2] = self.nodeOpHistory:getPositionY(), self.Scroll_Content:getInnerContainerSize(), self.Scroll_Content:getInnerContainerSize(), self.nodeOpHistory:getPositionY()
	_UPVALUE2_, self.Scroll_Content:getInnerContainerSize()[1], self.nodeOpHistory:getPositionY()[1] = self.nodeOpHistory:getPositionY(), self.nodeOpHistory:getPositionY(), 320
	_UPVALUE3_, self.Scroll_Content:getInnerContainerSize()[2], self.nodeOpHistory:getPositionY()[1] = self.nodeOpHistory:getPositionY(), self.nodeOpHistory:getPositionY(), 427.5
	_UPVALUE3_, self.Scroll_Content:getInnerContainerSize()[2], self.nodeOpHistory:getPositionY()[2] = self.nodeOpHistory:getPositionY(), self.nodeOpHistory:getPositionY(), 212.5
	_UPVALUE4_, self.Scroll_Content:getInnerContainerSize()[3], self.nodeOpHistory:getPositionY()[1] = self.nodeOpHistory:getPositionY(), self.nodeOpHistory:getPositionY(), 535
	_UPVALUE4_, self.Scroll_Content:getInnerContainerSize()[3], self.nodeOpHistory:getPositionY()[2] = self.nodeOpHistory:getPositionY(), self.nodeOpHistory:getPositionY(), 320
	_UPVALUE4_, self.Scroll_Content:getInnerContainerSize()[3], self.nodeOpHistory:getPositionY()[3] = self.nodeOpHistory:getPositionY(), self.nodeOpHistory:getPositionY(), 105
	self.opXMap, self.Scroll_Content:getInnerContainerSize()[4], self.nodeOpHistory:getPositionY()[1] = self.Scroll_Content:getInnerContainerSize(), self.nodeOpHistory:getPositionY(), 535
	self.opXMap, self.Scroll_Content:getInnerContainerSize()[4], self.nodeOpHistory:getPositionY()[2] = self.Scroll_Content:getInnerContainerSize(), self.nodeOpHistory:getPositionY(), 392
	self.opXMap, self.Scroll_Content:getInnerContainerSize()[4], self.nodeOpHistory:getPositionY()[3] = self.Scroll_Content:getInnerContainerSize(), self.nodeOpHistory:getPositionY(), 248
	self.opXMap, self.Scroll_Content:getInnerContainerSize()[4], self.nodeOpHistory:getPositionY()[4] = self.Scroll_Content:getInnerContainerSize(), self.nodeOpHistory:getPositionY(), 105
	self.Size_img_L.settleSize = cc.size(self.Size_img_L:getContentSize().width, self.Scroll_Content:getContentSize().height + 40)
	self.Size_img_R.settleSize = cc.size(self.Size_img_R:getContentSize().width, self.Scroll_Content:getContentSize().height + 40)
end
function hegemonActivity:updateEventNodes()
	if not self.eventList then
		_UPVALUE6_ = self.eventList
		self.eventList, self.eventList[1] = self.eventList, gActivityTimeActivityID.LEGEND_HEGEMON_1
		self.eventList, self.eventList[2] = self.eventList, gActivityTimeActivityID.LEGEND_HEGEMON_2
		self.eventList, self.eventList[3] = self.eventList, gActivityTimeActivityID.LEGEND_HEGEMON_3
		self.eventList, self.eventList[4] = self.eventList, gActivityTimeActivityID.LEGEND_HEGEMON_4
		self.eventList, self.eventList[5] = self.eventList, gActivityTimeActivityID.LEGEND_HEGEMON_5
		self.eventList, self.eventList[6] = self.eventList, gActivityTimeActivityID.LEGEND_HEGEMON_6
	end
	self.eventNode, _ENV = self.eventList, self.eventList
	local singleW = 182
	local singleH = 185
	local totalW = math.max(singleW * #self.eventList, self.scrollViewEvents:getContentSize().width)
	local totalH = self.scrollViewEvents:getContentSize().height
	for i, v in ipairs(self.eventList) do
		local nodeItem = self.node_event_temp:clone()
		nodeItem:addTo(self.scrollViewEvents)
		table.insert(self.eventNode, nodeItem)
		local offsetX = (i - 1) * singleW + singleW / 2
		nodeItem:setPositionX(SoraDFPosX(totalW - offsetX, totalW))
		nodeItem:setPositionY(94.0)
		nodeItem.activityID = v
		nodeItem.index = i
		local btn = nodeItem:getChildByName("btn_event")
		btn:setSwallowTouches(false)
		btn:addTouchEventListener(handler(self, self.onClickEvent))
		btn.activityID = v
		btn.index = i
		local text_event_title = nodeItem:getChildByName("text_event_title")
		text_event_title:setString(i18n(hegemonRead.getActivityName(v)))
		local img_event_icon = nodeItem:getChildByName("img_event_icon")
		local bid = hegemonRead.getBuildIdByActivityID(v)
		if hegemonCtrl:getJoinBid() == bid then
			img_event_icon:loadTexture("icon_hegemon_owncountry.png", ccui.TextureResType.plistType)
		else
			img_event_icon:loadTexture("icon_hegemon_otercountry.png", ccui.TextureResType.plistType)
		end
		img_event_icon:ignoreContentAdaptWithSize(true)
		img_event_icon:setOpacity(120)
		text_event_title:setGroupID(mainUIDef.uiGroupID.group_normal_view_1)
		text_event_title:setGroupAuto(true)
		local bg_event_title = nodeItem:getChildByName("bg_event_title")
		bg_event_title:setGroupID(mainUIDef.uiGroupID.group_normal_view_1)
		local img_event_sep = nodeItem:getChildByName("img_event_sep")
		img_event_sep:setGroupID(mainUIDef.uiGroupID.group_normal_view_1)
		local et_sel_1 = nodeItem:getChildByName("et_sel_1")
		local et_sel_2 = nodeItem:getChildByName("et_sel_2")
		nodeItem.et_sel_1 = et_sel_1
		nodeItem.et_sel_2 = et_sel_2
		nodeItem.et_sel_1:setVisible(false)
		nodeItem.et_sel_2:setVisible(false)
		nodeItem.text_event_title = text_event_title
		nodeItem.img_event_icon = img_event_icon
		nodeItem.btn = btn
	end
	self.scrollViewEvents:setInnerContainerSize(cc.size(totalW, totalH))
	local jumpIndex = 1
	local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
	if hegemonState == gActivityState.PREPARE then
		jumpIndex = self:getSelfJumpIndex()
		for i, v in ipairs(self.eventList) do
			local bid = hegemonRead.getBuildIdByActivityID(v)
			if bid == hegemonCtrl:getJoinBid() then
				jumpIndex = i
				break
			end
		end
	elseif hegemonState == gActivityState.OPEN then
		local curState = timeTbInfo.curState
		if curState == ACTIVITY_STATE.ACTIVE then
			print("活动处于战斗中--------------")
			local battleIndex, find = self:getBattleJumpIndex()
			print("battleIndex, find = ", battleIndex, find)
			if find then
				jumpIndex = battleIndex
			else
				jumpIndex = self:getSelfJumpIndex()
			end
		elseif curState == ACTIVITY_STATE.SETTLE then
			print("活动处于结算---------------------")
			jumpIndex = self:getSelfJumpIndex()
		end
	end
	print("jumpIndex = ", jumpIndex)
	self.curIndex = jumpIndex
	_ENV = jumpIndex
	jumpIndex.count = #self.eventList
	jumpIndex.intervalWidth = 34
	jumpIndex.begin = self.curIndex
	self.numberView:initData(jumpIndex)
	self:setItemSel(self.eventNode[self.curIndex], true)
	self:updateActivityView(self.eventList[self.curIndex])
	self:updateBattleEffect()
	if SoraDFIsRA() then
		self.scrollViewEvents:jumpToRight()
	else
		self.scrollViewEvents:jumpToLeft()
	end
	self:scrollToIndex(jumpIndex)
end
function hegemonActivity:getSelfJumpIndex()
	local jumpIndex = 1
	for i, v in ipairs(self.eventList) do
		local bid = hegemonRead.getBuildIdByActivityID(v)
		if bid == hegemonCtrl:getJoinBid() then
			jumpIndex = i
			break
		end
	end
	return jumpIndex
end
function hegemonActivity:getBattleJumpIndex()
	local jumpIndex = 1
	local find = false
	for i, v in ipairs(self.eventList) do
		local param = activityShowCtrl:getParamByID(v)
		local state = param.curState
		if state == ACTIVITY_STATE.ACTIVE then
			jumpIndex = i
			find = true
			break
		end
	end
	return jumpIndex, find
end
function hegemonActivity:updateActivityView(activityID)
	print("updateActivityView  activityID = ", activityID)
	print("todohlp: reset操作，timer等------")
	self.Top_Sprite_king_nor:setVisible(false)
	self.Top_Sprite_king_gray:setVisible(false)
	SoraDSetNodeArrayVisible(self.tbArraySettle, false)
	SoraDSetNodeArrayVisible(self.tbArrayPrepare, false)
	SoraDSetNodeArrayVisible(self.tbArrayActive, false)
	self.Size_img_L:setContentSize(self.Size_img_L.oriSize)
	self.Size_img_R:setContentSize(self.Size_img_R.oriSize)
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	local param = activityShowCtrl:getParamByID(activityID)
	local curState = param.curState
	self.curActivityID = activityID
	landOfSoulCtrl:reqDeadArmyList(self.curActivityID)
	self.btnStageReward:setVisible(false)
	self.btn_team:setPosition(cc.p(160, 53))
	self.btn_enter_battle:setPosition(cc.p(479, 53))
	self.btn_team:setContentSize(cc.size(216, 72))
	SoraDAutoSizeButtonText(self.btn_team)
	self.btn_enter_battle:setContentSize(cc.size(216, 72))
	self.btn_hegemon_info:setPosition(self.btnHegemonPos)
	self.Node_store:setPosition(self.Node_storePos)
	self.Node_store_ex:setPosition(self.Node_storeExPos)
	print("curState========", curState)
	if curState == ACTIVITY_STATE.PREPARE then
		self.btnStageReward:setVisible(false)
		self.Node_store:setVisible(false)
		self.Node_store_ex:setVisible(false)
		print("活动处于准备状态")
		self.Panel_Content:setContentSize(cc.size(self.Panel_Content.newSize.width, self.Panel_Content.newSize.height + 30))
		self.btn_hegemon_info:setPosition(cc.p(self.btnHegemonPos.x, self.btnHegemonPos.y + 40))
		local scrollSize = self.Size_ScrollView_Content:getContentSize()
		local newInnerSize = cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, math.max(self.Panel_Content:getContentSize().height, scrollSize.height))
		self.Panel_Content:setPositionY(newInnerSize.height)
		self.Size_ScrollView_Content:setInnerContainerSize(cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, newInnerSize.height))
		self.Size_ScrollView_Content:scrollToTop(0, false)
		SoraDSetNodeArrayVisible(self.tbArrayPrepare, true)
		SoraDSetNodeArrayVisible(self.tbArrayActive, false)
		SoraDSetNodeArrayVisible(self.tbArrayOpenCommon, true)
		self.text_time_title:setString(i18n("common_text_608"))
		self.text_time_num:setVisible(false)
		self.text_des:setString(i18n("hegemon_text_09"))
		self:beginTime()
		self.btn_enter_battle:setTitleText(i18n("common_text_3318"))
		self.btn_enter_battle:setBright(false)
		local posY = self.node_join.oriPosY
		self.node_join:setPositionY(posY)
		self.txtTimeSettle:setVisible(true)
		local settleTime = param.timeConfig.settleTime
		local eventLeftTime = activityShowCtrl:getTimeInfoByID(activityID)
		local durationTime = 14400
		if eventLeftTime then
			local timerNode = eventLeftTime.timerNode
			if timerNode then
				durationTime = serviceFunctions.systemTime() + timerNode.timer:getRemainTime()
			end
		end
		local beginTime = os.date("!%Y-%m-%d %H:%M:%S", durationTime)
		local endTime = os.date("!%Y-%m-%d %H:%M:%S", settleTime)
		local timeStr = string.format("UTC+0 %s~%s", beginTime, endTime)
		self.txtTimeSettle:setString(timeStr)
		local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
		if hegemonCtrl:getJoinBid() == bid then
			self.node_join:setVisible(true)
			local kid = chatFunctions:getSelfSourceKID()
			self.text_join:setString(i18n("hegemon_text_11") .. "#" .. kid)
			SoraDToCenter(self.node_join, 10)
			self.node_join:setPositionY(self.node_join:getPositionY() + 35)
			self.text_time_title:setPositionY(self.text_time_title.oriPosY)
			self.txtTimeSettle:setPositionY(435)
			self.Image_Line_top:setPositionY(self.Image_Line_top.oriPosY)
		else
			self.node_join:setVisible(false)
			self.text_time_title:setPositionY(self.text_time_title.oriPosY + 30)
			self.txtTimeSettle:setPositionY(self.text_time_title:getPositionY() - 50)
			self.Image_Line_top:setPositionY(self.Image_Line_top.oriPosY + 10)
		end
		if hegemonCtrl:getJoinBid() == bid then
			self.btn_team:setVisible(true)
			self.btnStageReward:setVisible(true)
			self.btn_team:setPosition(cc.p(110, 53))
			self.btn_enter_battle:setPosition(cc.p(531, 53))
			self.btnStageReward:setPosition(cc.p(320, 53))
			self.btn_team:setContentSize(cc.size(190, 72))
			self.btn_enter_battle:setContentSize(cc.size(190, 72))
			self.btnStageReward:setContentSize(cc.size(190, 72))
			SoraDAutoSizeButtonText(self.btn_enter_battle)
			SoraDAutoSizeButtonText(self.btnStageReward)
			SoraDAutoSizeButtonText(self.btn_team)
		else
			self.btn_enter_battle:setPositionX(320)
			self.btn_team:setVisible(false)
		end
	elseif curState == ACTIVITY_STATE.ACTIVE then
		print("活动处于争夺状态")
		local joinAid = hegemonCtrl:getJoinActivity()
		if joinAid and joinAid == self.curActivityID then
			self.Node_store:setVisible(true)
		else
			self.Node_store:setVisible(false)
		end
		self.Node_store_ex:setVisible(false)
		legendLordWarltCtrl.getLegendLordWarRankReward(rank)
		SoraDSetNodeArrayVisible(self.tbArrayPrepare, false)
		SoraDSetNodeArrayVisible(self.tbArrayActive, true)
		SoraDSetNodeArrayVisible(self.tbArrayOpenCommon, true)
		self:beginTime()
		local isInWar = worldMapDefine.isInLegendLord()
		if not isInWar then
			self.btn_enter_battle:setTitleText(i18n("common_text_3318"))
		else
			self.btn_enter_battle:setTitleText(i18n("common_text_4256"))
		end
		self.text_time_title:setString(i18n("common_text_2669"))
		self.txtTimeSettle:setVisible(false)
		self.text_des:setString(i18n("hegemon_text_09"))
		local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
		legendLordWarCtrl:reqLegendLordData()
		self.text_time_num:setVisible(true)
		self:updateWatchingNum()
		for i, v in ipairs(self.tbArrayPrepareOffset) do
			v:setPositionY(v.oriPosY)
		end
		self.text_time_title:setPositionY(435)
		self.btn_enter_battle:setBright(true)
		local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
		if hegemonCtrl:getJoinBid() == bid then
			self.node_join:setVisible(true)
			local kid = chatFunctions:getSelfSourceKID()
			self.text_join:setString(i18n("hegemon_text_11") .. "#" .. kid)
			SoraDToCenter(self.node_join, 10)
			self.Panel_Content:setContentSize(cc.size(self.Panel_Content.newSize.width, self.Panel_Content.newSize.height + 60))
			local scrollSize = self.Size_ScrollView_Content:getContentSize()
			local newInnerSize = cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, math.max(self.Panel_Content:getContentSize().height, scrollSize.height))
			self.Panel_Content:setPositionY(newInnerSize.height)
			self.Size_ScrollView_Content:setInnerContainerSize(cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, newInnerSize.height))
			self.Size_ScrollView_Content:scrollToTop(0, false)
			local posY = self.node_join.oriPosY + 60
			self.node_join:setPositionY(posY)
			self.btnStageReward:setVisible(true)
			self.btn_team:setPosition(cc.p(110, 53))
			self.btn_enter_battle:setPosition(cc.p(531, 53))
			self.btnStageReward:setPosition(cc.p(320, 53))
			self.btn_enter_battle:setContentSize(cc.size(190, 72))
			self.btnStageReward:setContentSize(cc.size(190, 72))
			SoraDAutoSizeButtonText(self.btn_enter_battle)
			SoraDAutoSizeButtonText(self.btnStageReward)
			SoraDAutoSizeButtonText(self.btn_team)
			self.btn_team:setVisible(true)
		else
			local posY = self.node_join.oriPosY
			self.node_join:setPositionY(posY)
			self.Panel_Content:setContentSize(cc.size(self.Panel_Content.newSize.width, self.Panel_Content.newSize.height))
			local scrollSize = self.Size_ScrollView_Content:getContentSize()
			local newInnerSize = cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, math.max(self.Panel_Content:getContentSize().height, scrollSize.height))
			self.Panel_Content:setPositionY(newInnerSize.height)
			self.Size_ScrollView_Content:setInnerContainerSize(cc.size(self.Size_ScrollView_Content:getInnerContainerSize().width, newInnerSize.height))
			self.Size_ScrollView_Content:scrollToTop(0, false)
			self.node_join:setVisible(false)
			self.btn_team:setVisible(false)
			self.btn_enter_battle:setPositionX(320)
		end
	elseif curState == ACTIVITY_STATE.SETTLE then
		self.btnStageReward:setVisible(false)
		self.Node_store:setVisible(false)
		local joinAid = hegemonCtrl:getJoinActivity()
		if joinAid and joinAid == self.curActivityID then
			self.Node_store_ex:setVisible(true)
		else
			self.Node_store_ex:setVisible(false)
		end
		self.Size_img_L:setContentSize(self.Size_img_L.settleSize)
		self.Size_img_R:setContentSize(self.Size_img_R.settleSize)
		worldMapDefine = self.Size_img_R.setContentSize
		self.Size_img_R.setContentSize[1] = self.nodeOpGift
		self.Size_img_R.setContentSize[2] = self.nodeOpManage
		self.Size_img_R.setContentSize[3] = self.nodeOpReward
		self.Size_img_R.setContentSize[4] = self.nodeOpHistory
		self.Size_img_R.setContentSize[5] = self.nodeOpKingdom
		self.Size_img_R.setContentSize[6] = self.nodeOpWarRank
		local self.Size_img_R.setContentSize[7], opArray = self.nodeOp_land, self.Size_img_R.setContentSize
		for i, v in ipairs(opArray) do
			v:setVisible(false)
		end
		SoraDSetNodeArrayVisible(self.tbArrayPrepare, false)
		SoraDSetNodeArrayVisible(self.tbArrayActive, false)
		SoraDSetNodeArrayVisible(self.tbArraySettle, true)
		self.Top_Sprite_king_nor:setVisible(false)
		SoraDSetNodeArrayVisible(self.tbArrayOpenCommon, false)
		self.text_time_num:setVisible(false)
		self.Top_Sprite_king_nor:setVisible(false)
		self.Top_Sprite_king_gray:setVisible(false)
		local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
		local hegemonInfo = hegemonCtrl:getHegemonInfoByBid(bid)
		if hegemonInfo and next(hegemonInfo) ~= nil then
			self:updateHegemonInfo()
		else
			SoraDShowLoading(self)
			hegemonCtrl:reqHegemonInfo(bid)
		end
		legendLordWarCtrl:reqLegendLordData(worldMapDefine.LEGENDLORD_KINGDOM_ID)
	else
		self.Node_store:setVisible(false)
		self.Node_store_ex:setVisible(false)
		print("活动处于关闭状态-------------------------")
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.LEGEND_HEGEMON_1)
	print("ret,num======", ret, num)
	self.img_redPoint:setVisible(ret)
	self.Text_redPointInt:setString(num)
	self.img_redPoint_ex:setVisible(ret)
	self.Text_redPointInt_ex:setString(num)
end
function hegemonActivity:reArrangeOpButtons(bid)
	local isSelfHegemon = self:getIsSelfHegemon(bid)
	local hasHegemon = self:hasHegemon(bid)
	local opArray
	local numRow = 3
	self.nodeOpManage:setVisible(false)
	if isSelfHegemon then
		_UPVALUE5_ = self.nodeOpManage.setVisible
		opArray, self.nodeOpManage.setVisible[1] = self.nodeOpManage.setVisible, self.nodeOpGift
		opArray, self.nodeOpManage.setVisible[2] = self.nodeOpManage.setVisible, self.nodeOpReward
		opArray, self.nodeOpManage.setVisible[3] = self.nodeOpManage.setVisible, self.nodeOpHistory
		opArray, self.nodeOpManage.setVisible[4] = self.nodeOpManage.setVisible, self.nodeOpKingdom
		opArray, self.nodeOpManage.setVisible[5] = self.nodeOpManage.setVisible, self.nodeOpWarRank
		self.nodeOpManage:setVisible(true)
	elseif hasHegemon then
		_UPVALUE5_ = self.nodeOpManage.setVisible
		opArray, self.nodeOpManage.setVisible[1] = self.nodeOpManage.setVisible, self.nodeOpGift
		opArray, self.nodeOpManage.setVisible[2] = self.nodeOpManage.setVisible, self.nodeOpReward
		opArray, self.nodeOpManage.setVisible[3] = self.nodeOpManage.setVisible, self.nodeOpHistory
		opArray, self.nodeOpManage.setVisible[4] = self.nodeOpManage.setVisible, self.nodeOpKingdom
		opArray, self.nodeOpManage.setVisible[5] = self.nodeOpManage.setVisible, self.nodeOpWarRank
	else
		_UPVALUE4_ = self.nodeOpManage.setVisible
		opArray, self.nodeOpManage.setVisible[1] = self.nodeOpManage.setVisible, self.nodeOpGift
		opArray, self.nodeOpManage.setVisible[2] = self.nodeOpManage.setVisible, self.nodeOpReward
		opArray, self.nodeOpManage.setVisible[3] = self.nodeOpManage.setVisible, self.nodeOpHistory
		opArray, self.nodeOpManage.setVisible[4] = self.nodeOpManage.setVisible, self.nodeOpKingdom
		numRow = 4
	end
	local deadArmyList = landOfSoulCtrl:getDeadArmyList()
	local remainTime = landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)
	local kingdomList = hegemonCtrl:getBuildKingdomList(bid)
	local isInKingdom = false
	if kingdomList and kingdomList.kids then
		for _, v in ipairs(kingdomList.kids) do
			local curKid = gametop.playertop_:getKingdomID()
			if v == curKid then
				isInKingdom = true
				break
			end
		end
	end
	if next(deadArmyList) and 0 < remainTime and isInKingdom then
		table.insert(opArray, self.nodeOp_land)
	end
	local rows = #opArray / numRow
	local num = #opArray
	print(" rearrage op buttons --------------:num = ", num)
	for i = 1, #opArray do
		opArray[i]:setVisible(true)
		local xIndex = i % numRow == 0 and numRow or i % numRow
		local yIndex = math.ceil(i / numRow)
		local pos
		if rows > yIndex then
			if not SoraDFIsRA() then
				xIndex = numRow - xIndex + 1
			end
			pos = cc.p(self.opXMap[numRow][xIndex], self.opYMap[yIndex])
		else
			local lastNumRow = num % numRow == 0 and numRow or num % numRow
			if not SoraDFIsRA() then
				xIndex = lastNumRow - xIndex + 1
			end
			pos = cc.p(self.opXMap[lastNumRow][xIndex], self.opYMap[yIndex])
		end
		print("xIndex = ", xIndex, ",yIndex = ", yIndex, ", pos.x = ", pos.x, ", pos.y = ", pos.y)
		opArray[i]:setPosition(pos)
	end
end
function hegemonActivity:getIsSelfHegemon(bid)
	if hegemonCtrl:getJoinBid() == bid and hegemonCtrl:getIsSelfHegemon() then
		return true
	end
	return false
end
function hegemonActivity:hasHegemon(bid)
	local hegemonInfo = hegemonCtrl:getHegemonInfoByBid(bid)
	if hegemonInfo and next(hegemonInfo) ~= nil then
		return true
	end
	return false
end
function hegemonActivity:setItemSel(nodeItem, isSel)
	if isSel then
		nodeItem.text_event_title:setColor(colorSel)
		nodeItem.img_event_icon:setOpacity(255)
	else
		nodeItem.text_event_title:setColor(colorUnSel)
		nodeItem.img_event_icon:setOpacity(120)
	end
end
function hegemonActivity:onClickEvent(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scrollViewEvents) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.curIndex == button.index then
			print("选中了同一个，直接返回")
			return
		end
		print("点击了 target:", button.activityID)
		self:setItemSel(self.eventNode[self.curIndex], false)
		self.curIndex = button.index
		self.numberView:setCurLight(self.curIndex)
		self:setItemSel(self.eventNode[self.curIndex], true)
		self:updateActivityView(self.eventList[self.curIndex])
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
function hegemonActivity:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function hegemonActivity:updateTime()
	local eid = self.curActivityID
	local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
	if eventLeftTime then
		local timerNode = eventLeftTime.timerNode
		if timerNode then
			self.activity_time:setTime(timerNode.timer:getRemainTime())
		end
	end
end
function hegemonActivity:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function hegemonActivity:createUI()
end
function hegemonActivity:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	cloneNode = include("nodeReward").new(cloneNode)
	cloneNode:addTo(self.templateNodeReward:getParent())
	cloneNode:setPosition(cc.p(self.templateNodeReward:getPosition()))
	return cloneNode
end
function hegemonActivity:recycleRewards()
	for i = 1, #self.tbRewardInUse do
		self.tbRewardInUse[i]:setVisible(false)
		self.tbRewardInUse[i]:removeGlow()
		table.insert(self.tbRewardNotInUse, self.tbRewardInUse[i])
	end
	self.tbRewardInUse, _ENV = 1, (for index)
end
function hegemonActivity:showLegendReward()
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
	self.Panel_Content.newSize = self.Panel_Content:getContentSize()
end
function hegemonActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKING_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WATCHING_NUM", handler(self, self.updateWatchingNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_KING_DATA_BACK", handler(self, self.sMsgActivityDataBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.sMsgTeamUPdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_INIT", handler(self, self.refreshIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_REFRESH", handler(self, self.refreshIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_BUILD_KINGDOM_LIST_BACK", handler(self, self.sMsgHandlerKingdomList))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WAR_DATA", handler(self, self.onMsgUpdateLegendData))
	self:updateEventNodes()
end
function hegemonActivity:refreshIcon()
	local isSatisfy, num = landOfSoulCtrl:getReceiveStatusAndNum(gActivityCenterUIEnum.LEGEND_HEGEMON)
	self.imgRed:setVisible(isSatisfy)
	local remainTime = landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)
	local deadArmyList = landOfSoulCtrl:getDeadArmyList()
	if 0 < remainTime and next(deadArmyList) then
		self.remainTime:setString(SoraDConvertSecondToString(remainTime))
		self.remainTime:beginTime(remainTime)
	else
		self:heroSoulIsOver()
	end
end
function hegemonActivity:sMsgHandlerKingdomList(target, data)
	SoraDCloseLoading(self)
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	self:reArrangeOpButtons(bid)
end
function hegemonActivity:heroSoulIsOver()
	self.nodeOp_land:setVisible(false)
end
function hegemonActivity:msgGetLordInfo(target, data)
	if data.clientData then
		local keyName = "fromHegemonActivity"
		local keyValue = data.clientData[keyName]
		if keyValue == true then
			SoraDCloseLoading(self)
			SoraDOpenLordView(data.lord)
		end
	end
end
function hegemonActivity:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "hegemonActivity" then
			SoraDCloseLoading(self)
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function hegemonActivity:onClick_Button_help(sender, event)
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
function hegemonActivity:onStoreClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("弹窗霸主兑换商店", self.curActivityID)
		local panel = SoraDCreatePanel("hegemonStoreView")
		panel:setActivityID(self.curActivityID)
		panel:show()
	end
end
function hegemonActivity:onClick_btn_hegemon_info(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
		local param = activityShowCtrl:getParamByID(self.curActivityID)
		local curState = param.curState
		local panel = SoraDCreatePanel("hegemonKingView")
		panel:show()
		_ENV = nil
		;(nil).bid = bid
		panel:init(nil)
	end
end
function hegemonActivity:onClickBtnStageReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("legendStageReward"):show()
	end
end
function hegemonActivity:onClick_btn_enter_battle(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local param = activityShowCtrl:getParamByID(self.curActivityID)
		local curState = param.curState
		if curState ~= ACTIVITY_STATE.ACTIVE then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		local isInWar = worldMapDefine.isInLegendLord()
		if not isInWar then
			local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
			local coordinate = hegemonRead.getBuildCoordinate(bid)
			SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
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
function hegemonActivity:msgShowItemInfo(target, data)
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function hegemonActivity:openItemInfoMsg(data)
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
function hegemonActivity:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function hegemonActivity:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID and type(data.activityID) == "table" then
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == gActivityCenterUIEnum.LEGEND_HEGEMON then
				local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
				if hegemonState == gActivityState.PREPARE or hegemonState == gActivityState.OPEN then
					self:updateActivityView(self.eventList[self.curIndex])
					self:updateBattleEffect()
				elseif hegemonState == gActivityState.CLOSE then
					self:closePanel()
				end
			end
		end
	end
end
function hegemonActivity:updateWatchingNum()
	local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
	local num = legendLordWarCtrl:getWatchingNum()
	if 0 <= num then
		local str = string.formatnumberthousands(num)
		gametop = nil
		;(nil).num = str
		self.text_time_num:setString(i18n("legendaryking_text_32", nil))
	end
end
function hegemonActivity:updateHegemonInfo()
	print("hegemonActivity:updateHegemonInfo")
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	self:reArrangeOpButtons(bid)
	local hegemonInfo = hegemonCtrl:getHegemonInfoByBid(bid)
	local kingdomInfo = hegemonInfo.kingdomInfo
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		self.text_king_name:setString(i18n("common_text_480"))
		self.text_kingdom_name:setVisible(false)
		self.sprite_kingdom_icon:setVisible(false)
		self.bg_alliance_name:setVisible(false)
		self.node_alliance:setVisible(false)
		self.text_alliance_name:setVisible(false)
		self.text_reward_des:setString(i18n("hegemon_text_28"))
		print("没有产生霸主----------------------")
		self.headBig_node:setVisible(false)
		self.Top_Sprite_king_gray:setVisible(false)
		self.Top_Sprite_king_nor:setVisible(false)
		return
	end
	local strKingdomInfo = kingdomInfo.kname
	self.text_kingdom_name:setString(strKingdomInfo)
	local flagImg = nationalFlagRead.getImgByID(kingdomInfo.kflag)
	if flagImg then
		self.sprite_kingdom_icon:setSpriteFrame(flagImg)
	end
	self.text_kingdom_name:setVisible(true)
	self.sprite_kingdom_icon:setVisible(true)
	local playerInfo = hegemonInfo.playerInfo
	local strPlayerInfo = playerInfo.nickName
	local buildName = hegemonRead.getName(bid)
	_ENV = i18n("hegemon_text_28")
	i18n("hegemon_text_28").build = buildName
	i18n("hegemon_text_28").name = strPlayerInfo
	self.text_king_name:setString(i18n("hegemon_title_04", i18n("hegemon_text_28")))
	local portrait = lordLocalData.getPortrait(playerInfo.imageId)
	self.Top_Sprite_king_nor:setSpriteFrame(portrait)
	self.Top_Sprite_king_gray:setVisible(false)
	if display.height < 960 then
		self.headBig_node:setVisible(true)
		SoraDGetHeadFromManager(self.frame_head, playerInfo.imageId, playerInfo.avatar)
		self.Top_Sprite_king_nor:setVisible(false)
		self.Top_Sprite_king_gray:setVisible(false)
	else
		self.headBig_node:setVisible(false)
		self.Top_Sprite_king_nor:setVisible(true)
		self.Top_Sprite_king_gray:setVisible(false)
	end
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	local strPlayerName = self:getLegendKingName(bid)
	_ENV = i18n("hegemon_title_04", i18n("hegemon_text_28"))
	i18n("hegemon_title_04", i18n("hegemon_text_28")).build = buildName
	i18n("hegemon_title_04", i18n("hegemon_text_28")).name = strPlayerName
	self.text_reward_des:setString(i18n("hegemon_text_10", i18n("hegemon_title_04", i18n("hegemon_text_28"))))
	local allianceInfo = hegemonInfo.allianceInfo
	nationalFlagRead = self.text_reward_des
	self.text_reward_des[1] = self.bg_alliance_name
	self.text_reward_des[2] = self.text_alliance_name
	local self.text_reward_des[3], tbNodeAlliance = self.node_alliance, self.text_reward_des
	if allianceInfo and next(allianceInfo) ~= nil and allianceInfo.aid ~= 0 then
		SoraDSetNodeArrayVisible(tbNodeAlliance, true)
		_ENV = true
		;(true).abbr = allianceInfo.abbr
		;(true).name = allianceInfo.alliance
		local strAllianceInfo = i18n("common_text_186", true)
		self.text_alliance_name:setString(strAllianceInfo)
		if self.node_alliance:getChildByName("node_alliance_flag") ~= nil then
			self.node_alliance:removeChildByName("node_alliance_flag", true)
		end
		local flag = allianceInfo.flag
		if flag then
			local nodeFlag = SoraDGetAllianceFlagByFid(flag)
			if nodeFlag then
				nodeFlag:setScale(0.5)
				nodeFlag:addTo(self.node_alliance)
				nodeFlag:setName("node_alliance_flag")
			end
		end
	else
		SoraDSetNodeArrayVisible(tbNodeAlliance, false)
	end
	hegemonCtrl = false
	;(false)[1] = self.text_kingdom_name
	;(false)[2] = self.sprite_kingdom_icon
	hegemonRead = self.sprite_kingdom_icon
	self.sprite_kingdom_icon[1] = 10
	SoraDAlignNodeArrayOnCenterX(320, false, not SoraDFIsRA(), self.sprite_kingdom_icon)
	hegemonCtrl = 320
	;(320)[1] = self.text_king_name
	;(320)[2] = self.sprite_king_icon
	hegemonRead = self.sprite_king_icon
	self.sprite_king_icon[1] = 10
	SoraDAlignNodeArray(320, not SoraDFIsRA(), self.sprite_king_icon)
end
function hegemonActivity:getLegendKingName(bid)
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	local hegemonInfo = hegemonCtrl:getHegemonInfoByBid(bid)
	if next(hegemonInfo) == nil then
		return i18n("common_text_480")
	end
	local playerInfo = hegemonInfo.playerInfo
	local allianceInfo = hegemonInfo.allianceInfo
	local kingdomInfo = hegemonInfo.kingdomInfo
	local strInfo = ""
	if allianceInfo and allianceInfo.abbr then
		hegemonRead = nil
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
function hegemonActivity:onBtnClickOpReward(sender)
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	local panel = SoraDCreatePanel("hegemonReward")
	panel:show()
	hegemonRead = nil
	;(nil).bid = bid
	panel:init(nil)
end
function hegemonActivity:onBtnClickOpWarRank(sender)
	local panel = SoraDCreatePanel("legendaryKingRank")
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	panel:init(bid)
	panel:show()
end
function hegemonActivity:onBtnClickOpManage(sender)
	local hegemonView = SoraDCreatePanel("hegemonView")
	hegemonView:show()
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	_ENV = nil
	;(nil).bid = bid
	hegemonView:init(nil)
end
function hegemonActivity:onBtnClickOpGift(sender)
	local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
	panel:show()
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	_ENV = nil
	;(nil).viewType = 4
	;(nil).bid = bid
	panel:init(nil)
end
function hegemonActivity:onBtnClickOpHistory(sender)
	local panel = SoraDCreatePanel("legendaryKingHistory")
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	panel:init(bid)
	panel:show()
end
function hegemonActivity:onBtnClickOpKingdom(sender)
	local bid = hegemonRead.getBuildIdByActivityID(self.curActivityID)
	local panel = SoraDCreatePanel("hegemonKingView")
	panel:show()
	hegemonRead = nil
	;(nil).bid = bid
	panel:init(nil)
end
function hegemonActivity:onBtnClickOpLand(sender)
	print("英魂之地")
	local deadArmyList = landOfSoulCtrl:getDeadArmyList()
	if not next(deadArmyList) then
		SoraDShowMsgTip(i18n("heroicSouls_text_13"))
		return
	end
	local panel = SoraDCreatePanel("heroicLandView")
	panel:initData(deadArmyList, self.curActivityID)
	panel:show()
end
function hegemonActivity:sMsgActivityDataBack(target, data)
	print("数据返回了 ----------")
	SoraDCloseLoading(self)
	self:updateHegemonInfo()
end
function hegemonActivity:setHegemonEffect()
	local eTop = SoraDGetChildByName(self, "Node_eTop")
	local showEffect = function()
		local act_eBg = SoraDCreatAnimation("etHegemonTop")
		for i = 1, 2 do
			local v = SoraDGetChildByName(act_eBg, "sp_dh_fire_" .. i)
			if v:isOpacityModifyRGB() then
				v:setBlendFunc(gl.ONE, gl.ONE)
			else
				v:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
		act_eBg:addTo(eTop)
	end
	if SoraDIsFileExistByKey("lucency") then
		_ENV, _UPVALUE1_ = "lucency", SoraDIsFileExistByKey("lucency")
		;("lucency").name = "Common/lucency"
		local SoraDIsFileExistByKey("lucency")[1], imgArray = "lucency", SoraDIsFileExistByKey("lucency")
		self:loadImages(imgArray, function()
			showEffect()
		end)
	end
end
function hegemonActivity:updateBattleEffect()
	for i, v in ipairs(self.eventList) do
		local param = activityShowCtrl:getParamByID(v)
		local curState = param.curState
		local nodeItem = self.eventNode[i]
		if curState == ACTIVITY_STATE.ACTIVE then
			nodeItem.et_sel_1:setVisible(true)
			nodeItem.et_sel_2:setVisible(true)
		else
			nodeItem.et_sel_1:setVisible(false)
			nodeItem.et_sel_2:setVisible(false)
		end
	end
end
function hegemonActivity:scrollToIndex(index)
	local singleW = 182
	local totalW = math.max(singleW * #self.eventList, self.scrollViewEvents:getContentSize().width)
	local scrollW = 640
	if index then
		local scrollPercent
		local offsetX = singleW * index - scrollW
		if SoraDFIsRA() then
			scrollPercent = 100 - math.min(math.max(0, 100 * offsetX / math.abs(totalW - scrollW)), 100)
		else
			scrollPercent = math.min(math.max(0, 100 * offsetX / math.abs(totalW - scrollW)), 100)
		end
		if scrollPercent == 0 then
		elseif scrollPercent == 100 then
		end
		self.scrollViewEvents:scrollToPercentHorizontal(scrollPercent, 0.3, false)
	end
end
function hegemonActivity:onClick_btn_team(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openView()
	end
end
function hegemonActivity:sMsgTeamUPdate(target, data)
	if legendTeamCtrl:isHasTeam() then
		self.btn_team:setTitleText(i18n("remains_title_05"))
	else
		self.btn_team:setTitleText(i18n("complete_text_03"))
	end
end
function hegemonActivity:onMsgUpdateLegendData(target, event)
	if not legendLordWarCtrl:checkBackPlayerTime() then
		return
	end
	if not self.btn_hospital_settle then
		local obj = fguiHelper.createObject("KingStarBattle", "Button_hospital_hegemon")
		obj:addTo(self.Node_store_ex:getParent())
		obj:setPivot(0.5, 0.5, true)
		obj:setPosition(65, -484)
		obj:setScale(0.9)
		legendLordWarCtrl = 0.9
		;(0.9).warType = gKingdomClassType.legendLord
		obj:initData(0.9)
		self.btn_hospital_settle = obj
	end
	self.btn_hospital_settle:onMsgUpdateWarData()
end
return hegemonActivity
