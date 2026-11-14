local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local lordLocalData = include("lordLocalData")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local nationalFlagRead = include("nationalFlagRead")
local allianceDesRead = include("allianceDesRead")
_ENV = "allianceDesRead"
;("allianceDesRead").activity = 1
local ("allianceDesRead").lord, LEGENDLORD_VIEW_TYPE = 2, "allianceDesRead"
local legendaryKingView = class("legendaryKingView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendaryKingView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendaryKingView:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Size_Bg_King = SoraDGetChildByName(self, "Top_Size_Bg_King")
	self.Top_Size_Bg_King:loadTexture(SoraDCheckPNG("bg_legendaryking_junwangbeijing_01.png", "bg_throne_contend_01.png"), ccui.TextureResType.plistType)
	self.Top_Sprite_king_gray = SoraDGetChildByName(self, "Top_Sprite_king_gray")
	self.Top_Sprite_king_nor = SoraDGetChildByName(self, "Top_Sprite_king_nor")
	self.Bottom_Node_bg = SoraDGetChildByName(self, "Bottom_Node_bg")
	self.Image_Tile_bg_pp = SoraDGetChildByName(self, "Image_Tile_bg_pp")
	self.Image_Frame_bg = SoraDGetChildByName(self, "Image_Frame_bg")
	self.Image_Lace_BL = SoraDGetChildByName(self, "Image_Lace_BL")
	self.Image_Lace_BR = SoraDGetChildByName(self, "Image_Lace_BR")
	self.frame_LegendaryKing_base_down_R = SoraDGetChildByName(self, "frame_LegendaryKing_base_down_R")
	self.frame_LegendaryKing_base_down_L = SoraDGetChildByName(self, "frame_LegendaryKing_base_down_L")
	self.frame_lace_base_L = SoraDGetChildByName(self, "frame_lace_base_L")
	self.frame_lace_base_R = SoraDGetChildByName(self, "frame_lace_base_R")
	self.Top_Node_Status = SoraDGetChildByName(self, "Top_Node_Status")
	self.Sprite_throne_sheer = SoraDGetChildByName(self, "Sprite_throne_sheer")
	self.frame_throne_contend_1 = SoraDGetChildByName(self, "frame_throne_contend_1")
	self.frame_throne_contend_2 = SoraDGetChildByName(self, "frame_throne_contend_2")
	self.frame_throne_contend_3 = SoraDGetChildByName(self, "frame_throne_contend_3")
	self.frame_throne_contend_4 = SoraDGetChildByName(self, "frame_throne_contend_4")
	self.frame_throne_contend_5 = SoraDGetChildByName(self, "frame_throne_contend_5")
	self.frame_throne_contend_6 = SoraDGetChildByName(self, "frame_throne_contend_6")
	self.frame_LegendaryKing_base_L = SoraDGetChildByName(self, "frame_LegendaryKing_base_L")
	self.frame_LegendaryKing_base_R = SoraDGetChildByName(self, "frame_LegendaryKing_base_R")
	self.Sprite_14_0_0 = SoraDGetChildByName(self, "Sprite_14_0_0")
	self.Top_frame_lord = SoraDGetChildByName(self, "Top_frame_lord")
	self.frame_lord_T = SoraDGetChildByName(self, "frame_lord_T")
	self.Node_over = SoraDGetChildByName(self, "Top_Node_over")
	self.node_alliance = SoraDGetChildByName(self, "node_alliance")
	self.bg_alliance_name = SoraDGetChildByName(self, "bg_alliance_name")
	self.text_alliance_name = SoraDGetChildByName(self, "text_alliance_name")
	self.bg_king_name = SoraDGetChildByName(self, "bg_king_name")
	self.text_king_name = SoraDGetChildByName(self, "text_king_name")
	self.text_kingdom_name = SoraDGetChildByName(self, "text_kingdom_name")
	self.sprite_kingdom_icon = SoraDGetChildByName(self, "sprite_kingdom_icon")
	self.sprite_king_icon = SoraDGetChildByName(self, "sprite_king_icon")
	self.Top_Node_war = SoraDGetChildByName(self, "Top_Node_war")
	self.sprite_war_bg = SoraDGetChildByName(self, "sprite_war_bg")
	self.text_war_status = SoraDGetChildByName(self, "text_war_status")
	self.sprite_war_icon = SoraDGetChildByName(self, "sprite_war_icon")
	self.Node_war = SoraDGetChildByName(self, "Top_Node_war_info")
	self.img_war_bg = SoraDGetChildByName(self, "img_war_bg")
	self.img_war_sheer = SoraDGetChildByName(self, "img_war_sheer")
	self.img_war_sheer_red = SoraDGetChildByName(self, "img_war_sheer_red")
	self.sprite_war_time_bg = SoraDGetChildByName(self, "sprite_war_time_bg")
	self.sprite_war_sheer_red_b = SoraDGetChildByName(self, "sprite_war_sheer_red_b")
	self.Button_War_Rank = SoraDGetChildByName(self, "Button_War_Rank")
	self.Text_warRank = SoraDGetChildByName(self, "Text_warRank")
	self.text_war_time = SoraDGetChildByName(self, "text_war_time")
	self.sprite_alliance_flag = SoraDGetChildByName(self, "sprite_alliance_falg")
	self.icon_fight_expedition = SoraDGetChildByName(self, "icon_fight_expedition")
	self.sprite_fight_bg = SoraDGetChildByName(self, "sprite_fight_bg")
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.node_head_base = SoraDGetChildByName(self, "node_head_base")
	self.node_head_icon = SoraDGetChildByName(self, "node_head_icon")
	self.node_head_frame = SoraDGetChildByName(self, "node_head_frame")
	self.btn_occupier = SoraDGetChildByName(self, "btn_head")
	self.sprite_alliance_bg = SoraDGetChildByName(self, "sprite_alliance_bg")
	self.sprite_player_bg = SoraDGetChildByName(self, "sprite_player_bg")
	self.text_player_name = SoraDGetChildByName(self, "text_player_name")
	self.text_fight_power = SoraDGetChildByName(self, "text_fight_power")
	self.text_war_alliance_name = SoraDGetChildByName(self, "text_war_alliance_name")
	self.img_war_line = SoraDGetChildByName(self, "img_war_line")
	self.text_war_title = SoraDGetChildByName(self, "text_war_title")
	self.Top_Node_peace = SoraDGetChildByName(self, "Top_Node_peace")
	self.sprite_peace_bg = SoraDGetChildByName(self, "sprite_peace_bg")
	self.sprite_peace_icon = SoraDGetChildByName(self, "sprite_peace_icon")
	self.text_peace_status = SoraDGetChildByName(self, "text_peace_status")
	self.Node_peace = SoraDGetChildByName(self, "Top_Node_peace_info")
	self.frame_LegendaryKing_word = SoraDGetChildByName(self, "frame_LegendaryKing_word")
	self.img_peace_time_bg = SoraDGetChildByName(self, "img_peace_time_bg")
	self.img_peace_tip_bg = SoraDGetChildByName(self, "img_peace_tip_bg")
	self.text_peace_tip = SoraDGetChildByName(self, "text_peace_status")
	self.text_peace_time = SoraDGetChildByName(self, "text_peace_time")
	self.Node_Operate_btns = SoraDGetChildByName(self, "Node_Operate_btns")
	self.nodeOp_opReward = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_opReward")
	self.nodeOp_opKingom = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_opKingom")
	self.nodeOp_opWorld = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_opWorld")
	self.nodeOp_opGift = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_opGift")
	self.nodeOp_opHistory = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_opHistory")
	self.nodeOp_opArmy = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_opArmy")
	self.Node_over_myself = SoraDGetChildByName(self, "Node_over_myself")
	self.nodeReward_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeReward_node")
	self.node_reward_info = SoraDGetChildByName(self, "node_reward_info")
	self.text_reward_title = SoraDGetChildByName(self, "text_reward_title")
	self.frame_reward_R = SoraDGetChildByName(self, "frame_reward_R")
	self.frame_reward_L = SoraDGetChildByName(self, "frame_reward_L")
	self.text_reward_des = SoraDGetChildByName(self, "text_reward_des")
	self.nodeOp_warRank = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_warRank")
	self.nodeOp_manage = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_manage")
	self.nodeOp_History = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_History")
	self.nodeOp_land = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOp_land")
	self.commonFramTitleNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.Panel_Content = SoraDGetChildByName(self, "Panel_Content")
	self.Scroll_Content = SoraDGetChildByName(self, "Scroll_Content")
	self.Top_Btn_King = SoraDGetChildByName(self, "Top_Btn_King")
	self.btn_node_alliance = SoraDGetChildByName(self, "btn_node_alliance")
	self.Top_Button_Reward = SoraDGetChildByName(self, "Top_Button_Reward")
	self.Top_Label_Reward = SoraDGetChildByName(self, "Top_Label_Reward")
	self.node_bottom_ops = SoraDGetChildByName(self, "node_bottom_ops")
	self.node_bottom_ops:setVisible(false)
	self.Top_Label_Reward:setString(i18n("common_text_4218"))
	self.Top_Button_Reward:addTouchEventListener(handler(self, self.onClick_Button_Reward))
	self.btn_king_reward = SoraDGetChildByName(self, "Button_KingAward")
	self.btn_exchange_shop = SoraDGetChildByName(self, "Button_ExchangeShop")
	self.exchangeRedPoint = SoraDGetChildByName(self.btn_exchange_shop, "Image_redPoint")
	SoraDGetChildByName(self, "Button_KingAward_2"):setVisible(false)
	SoraDGetChildByName(self, "Button_ExchangeShop_2"):setVisible(false)
	_UPVALUE2_ = SoraDGetChildByName(self, "Button_ExchangeShop_2").setVisible
	self.tbRewardNodes, SoraDGetChildByName(self, "Button_ExchangeShop_2").setVisible[1] = SoraDGetChildByName(self, "Button_ExchangeShop_2").setVisible, self.Top_Button_Reward
	self.tbRewardNodes, SoraDGetChildByName(self, "Button_ExchangeShop_2").setVisible[2] = SoraDGetChildByName(self, "Button_ExchangeShop_2").setVisible, self.Top_Label_Reward
	SoraDSetNodeArrayVisible(self.tbRewardNodes, false)
	self.Node_power = SoraDGetChildByName(self, "Node_power")
	self.Button_War_Rank:addTouchEventListener(handler(self, self.onClick_Button_War_Rank))
	_UPVALUE3_ = self.Button_War_Rank.addTouchEventListener
	_UPVALUE3_, self.tbActivityOver, self.Button_War_Rank.addTouchEventListener[1] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Node_over
	_UPVALUE3_, self.tbActivityOver, self.Button_War_Rank.addTouchEventListener[2] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Node_over_myself
	_UPVALUE3_, self.tbActivityOver, self.Button_War_Rank.addTouchEventListener[3] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Top_Sprite_king_nor
	_UPVALUE3_, self.tbWar, self.Button_War_Rank.addTouchEventListener[1] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Top_Node_war
	_UPVALUE3_, self.tbWar, self.Button_War_Rank.addTouchEventListener[2] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Node_war
	_UPVALUE3_, self.tbWar, self.Button_War_Rank.addTouchEventListener[3] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Top_Sprite_king_gray
	_UPVALUE2_, self.tbPeace, self.Button_War_Rank.addTouchEventListener[1] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Top_Node_peace
	_UPVALUE2_, self.tbPeace, self.Button_War_Rank.addTouchEventListener[2] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Node_peace
	_UPVALUE2_, self.tbPeace, self.Button_War_Rank.addTouchEventListener[3] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Top_Sprite_king_nor
	legendLordWarltCtrl, self.tbSettle, self.Button_War_Rank.addTouchEventListener[1] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Node_over
	legendLordWarltCtrl, self.tbSettle, self.Button_War_Rank.addTouchEventListener[2] = self.Button_War_Rank.addTouchEventListener, self.Button_War_Rank.addTouchEventListener, self.Top_Sprite_king_nor
	self.tbBtnOps, self.Button_War_Rank.addTouchEventListener[1] = self.Button_War_Rank.addTouchEventListener, self.Node_Operate_btns
	legendLordWarltCtrl, self.tbRewardInUse, _ENV, self.templateNodeReward = self.nodeReward_node, self.nodeReward_node, self.nodeReward_node, self.nodeReward_node
	self.tbRewardNotInUse, self.nodeReward_node[1] = self.nodeReward_node, self.nodeReward_node
	self.kingReward = legendLordWarltCtrl.getLegendLordWarRankReward(1)
	_ENV = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor.id = gLegendOpType.OP_REWARD
	self.Top_Sprite_king_nor.handle = handler(self, self.onBtnClickOpReward)
	self.nodeOp_opReward:init(self.Top_Sprite_king_nor)
	_ENV = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor.id = gLegendOpType.OP_KINGDOM
	self.Top_Sprite_king_nor.handle = handler(self, self.onBtnClickOpKingdom)
	self.nodeOp_opKingom:init(self.Top_Sprite_king_nor)
	_ENV = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor.id = gLegendOpType.OP_WORLD
	self.Top_Sprite_king_nor.handle = handler(self, self.onBtnClickOpWorld)
	self.nodeOp_opWorld:init(self.Top_Sprite_king_nor)
	_ENV = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor.id = gLegendOpType.OP_GIFT
	self.Top_Sprite_king_nor.handle = handler(self, self.onBtnClickOpGift)
	self.nodeOp_opGift:init(self.Top_Sprite_king_nor)
	_ENV = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor.id = gLegendOpType.OP_HISTORY
	self.Top_Sprite_king_nor.handle = handler(self, self.onBtnClickOpHistory)
	self.nodeOp_opHistory:init(self.Top_Sprite_king_nor)
	_ENV = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor.id = gLegendOpType.OP_ARMY
	self.Top_Sprite_king_nor.handle = handler(self, self.onBtnClickOpArmy)
	self.nodeOp_opArmy:init(self.Top_Sprite_king_nor)
	self.nodeOp_opGift.oriPosX = self.nodeOp_opGift:getPositionX()
	self.nodeOp_opHistory.oriPosX = self.nodeOp_opHistory:getPositionX()
	_ENV = self.nodeOp_opHistory
	self.nodeOp_opHistory.id = gLegendOpType.OP_WAR_RANK
	self.nodeOp_opHistory.handle = handler(self, self.onBtnClickOpWarRank)
	self.nodeOp_warRank:init(self.nodeOp_opHistory)
	_ENV = self.nodeOp_opHistory
	self.nodeOp_opHistory.id = gLegendOpType.OP_MANAGE
	self.nodeOp_opHistory.handle = handler(self, self.onBtnClickOpManage)
	self.nodeOp_manage:init(self.nodeOp_opHistory)
	_ENV = self.nodeOp_opHistory
	self.nodeOp_opHistory.id = gLegendOpType.OP_HISTORY
	self.nodeOp_opHistory.handle = handler(self, self.onBtnClickOpHistory)
	self.nodeOp_History:init(self.nodeOp_opHistory)
	_ENV = self.nodeOp_opHistory
	self.nodeOp_opHistory.id = gLegendOpType.OP_LAND
	self.nodeOp_opHistory.handle = handler(self, self.onBtnClickOpLand)
	self.nodeOp_land:init(self.nodeOp_opHistory)
	self.imgRed = SoraDGetChildByName(self.nodeOp_land, "Image_redPoint")
	self.remainTime = SoraDGetChildByName(self, "txtTime")
	self.remainTime = SoraDCreateTimerLabel(self, self.remainTime)
	self.imgRed:setVisible(false)
	self.remainTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.remainTime:setTimeEndListener(function()
		self:updateBtnPos(false)
		self = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self)
		self = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.LEGEND_LORD
		SoraDSendMessage(self)
	end)
	self:hideAll()
	SoraDCreateFireEffectNode(self.frame_lace_base_L, self.frame_lace_base_R)
	self.Image_Tile_bg_pp:setFillType(1)
	SoraDGetChildByName(self, "frame_throne_contend"):setFillType(1)
	self.Panel_Content.oriSize = self.Panel_Content:getContentSize()
	if display.height >= 960 then
		local scrollSize = self.Scroll_Content:getContentSize()
		self.Scroll_Content:setContentSize(cc.size(scrollSize.width, scrollSize.height + SoraDGetDeltaFitHeight()))
		scrollSize = self.Scroll_Content:getContentSize()
		local panelContentSize = self.Panel_Content:getContentSize()
		if scrollSize.height > panelContentSize.height then
			self.Scroll_Content:setInnerContainerSize(scrollSize)
		else
			self.Scroll_Content:setInnerContainerSize(panelContentSize)
		end
		local innerContainerSize = self.Scroll_Content:getInnerContainerSize()
		self.Panel_Content:setPositionY(innerContainerSize.height)
		_UPVALUE2_ = self.Panel_Content
		self.Panel_Content[1] = self.Image_Tile_bg_pp
		self.Panel_Content[2] = self.Image_Frame_bg
		SoraDAdjustFitHeightArray(self.Panel_Content)
	else
		_UPVALUE5_ = self.Panel_Content:getContentSize()
		self.Panel_Content:getContentSize()[1] = self.Node_war
		self.Panel_Content:getContentSize()[2] = self.Top_Node_Status
		self.Panel_Content:getContentSize()[3] = self.Node_peace
		self.Panel_Content:getContentSize()[4] = self.Top_Button_Reward
		self.Panel_Content:getContentSize()[5] = self.Top_Label_Reward
		SoraDAdjustFitPosArray(self.Panel_Content:getContentSize(), true)
	end
	_UPVALUE3_ = SoraDAdjustFitPosArray
	self.tbContentNodes, SoraDAdjustFitPosArray[1] = SoraDAdjustFitPosArray, self.node_reward_info
	self.tbContentNodes, SoraDAdjustFitPosArray[2] = SoraDAdjustFitPosArray, self.text_reward_des
	self.tbContentNodes, SoraDAdjustFitPosArray[3] = SoraDAdjustFitPosArray, self.nodeReward_node
	for i, v in pairs(self.tbContentNodes) do
		v.oriPosY = v:getPositionY()
	end
	self.Button_help = SoraDGetChildByName(self, "Top_Button_help")
	if self.Button_help then
		local helpImg = self.Button_help:getChildByName("Img_help")
		if helpImg then
			helpImg:setVisible(false)
		end
		self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	end
	self.Top_Btn_King:addTouchEventListener(handler(self, self.onClickBtnKing))
	self.btn_occupier:addTouchEventListener(handler(self, self.onClickBtnOccupier))
	self.btn_node_alliance:addTouchEventListener(handler(self, self.onClickBtnAlliance))
	self.btn_king_reward:addTouchEventListener(handler(self, self.onClick_btn_king_reward))
	self.btn_exchange_shop:addTouchEventListener(handler(self, self.onClick_btn_exchange_shop))
	self:setLegendEffect()
end
function legendaryKingView:setLegendEffect()
	local eBg = SoraDGetChildByName(self, "Node_eBg")
	local eTop = SoraDGetChildByName(self, "Node_eTop")
	local showEffect = function()
		local act_eBg = SoraDCreatAnimation("junwanghgBg")
		local bgLight = SoraDGetChildByName(act_eBg, "Sprite_light")
		for k, v in ipairs(act_eBg:getChildren()) do
			if v:isOpacityModifyRGB() then
				v:setBlendFunc(gl.ONE, gl.ONE)
			else
				v:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
		act_eBg:addTo(eBg)
		local act_eTop = SoraDCreatAnimation("junwanghgTop")
		for k, v in ipairs(act_eTop:getChildren()) do
			if v:getName() ~= "Particle_src" then
				if v:isOpacityModifyRGB() then
					v:setBlendFunc(gl.ONE, gl.ONE)
				else
					v:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
				end
			end
		end
		act_eTop:addTo(eTop)
	end
	if SoraDIsFileExistByKey("LegendaryFrame") then
		_ENV, _UPVALUE1_ = "LegendaryFrame", SoraDIsFileExistByKey("LegendaryFrame")
		;("LegendaryFrame").name = "Common/LegendaryFrame"
		local SoraDIsFileExistByKey("LegendaryFrame")[1], imgArray = "LegendaryFrame", SoraDIsFileExistByKey("LegendaryFrame")
		self:loadImages(imgArray, function()
			showEffect()
		end)
	end
end
function legendaryKingView:hideAll()
	SoraDSetNodeArrayVisible(self.tbActivityOver, false)
	SoraDSetNodeArrayVisible(self.tbWar, false)
	SoraDSetNodeArrayVisible(self.tbPeace, false)
	SoraDSetNodeArrayVisible(self.tbBtnOps, false)
end
function legendaryKingView:createUI()
end
function legendaryKingView:init(data)
	self.viewType = data.viewType
	if self.viewType == LEGENDLORD_VIEW_TYPE.activity then
		self:initWithActivity()
	elseif self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		self:initWithLord()
	end
end
function legendaryKingView:initWithActivity()
	SoraDShowLoading(self)
	legendLordCtrl:reqLegendKingInfo()
	landOfSoulCtrl:reqDeadArmyList(gActivityTimeActivityID.LEGEND_LORD)
	local mapId = worldMapDefine.getKingStarMapid(gActivityTimeActivityID.LEGEND_LORD)
	legendLordWarCtrl:reqLegendLordData(mapId)
end
function legendaryKingView:initWithLord()
	local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
		local legendLordState = param.curState
		local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			self:initViewLordBattle()
		elseif legendLordState == ACTIVITY_STATE.SETTLE then
			SoraDShowLoading(self)
			legendLordCtrl:reqLegendKingInfo()
		end
	elseif legendLordActivityStatus == gActivityState.PREPARE then
		local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
		self:initViewLordPrepare()
	elseif legendLordActivityStatus == gActivityState.CLOSE then
		SoraDShowLoading(self)
		legendLordCtrl:reqLegendKingInfo()
	end
end
function legendaryKingView:recycleRewards()
	for i = 1, #self.tbRewardInUse do
		self.tbRewardInUse[i]:setVisible(false)
		self.tbRewardInUse[i]:removeGlow()
		table.insert(self.tbRewardNotInUse, self.tbRewardInUse[i])
	end
	self.tbRewardInUse, _ENV = 1, (for index)
end
function legendaryKingView:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	cloneNode = include("nodeReward").new(cloneNode)
	cloneNode:addTo(self.templateNodeReward:getParent())
	cloneNode:setPosition(cc.p(self.templateNodeReward:getPosition()))
	return cloneNode
end
function legendaryKingView:showLegendReward()
	local ua = include("utilAlign")
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
	if self.Scroll_Content:getInnerContainerSize().height < self.Panel_Content:getContentSize().height then
		self.Scroll_Content:setInnerContainerSize(cc.size(self.Scroll_Content:getInnerContainerSize().width, self.Panel_Content:getContentSize().height))
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
	local offsetx = numx == 3 and 60 or 30
	local marginx = math.max(0, (640 - 120 * scale * numx - 30 * (numx - 1)) / 2)
	_ENV = 0
	;(0).directionx = ua.Direction.LEFT
	;(0).directiony = ua.Direction.DOWN
	;(0).totalWidth = 640
	;(0).itemWidth = 120 * scale
	;(0).itemHeight = 150
	;(0).numx = numx
	;(0).beginx = 0
	;(0).offsetx = -60.0 * scale
	;(0).beginy = 156
	;(0).offsety = -75.0
	;(0).marginx = marginx
	;(0).marginy = 0
	;(0).totalNum = #self.tbRewardInUse
	;(0).paddingy = paddingy
	local (0).isSamePadding, param = true, 0
	ua.alignHFits(self.tbRewardInUse, param)
end
function legendaryKingView:updateLegendKingInfo()
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		self.text_king_name:setString(i18n("common_text_480"))
		self.text_kingdom_name:setVisible(false)
		self.sprite_kingdom_icon:setVisible(false)
		self.bg_alliance_name:setVisible(false)
		self.node_alliance:setVisible(false)
		self.text_alliance_name:setVisible(false)
		return
	end
	local strKingdomInfo = kingdomInfo.kname
	self.text_kingdom_name:setString(strKingdomInfo)
	local flagImg = nationalFlagRead.getImgByID(kingdomInfo.kflag)
	if flagImg then
		self.sprite_kingdom_icon:setSpriteFrame(flagImg)
	end
	local playerInfo = self.legendKingInfo.playerInfo
	local strPlayerInfo = playerInfo.nickName
	_ENV = i18n("common_text_480")
	i18n("common_text_480").name = strPlayerInfo
	self.text_king_name:setString(i18n("legendaryking_text_07", i18n("common_text_480")))
	local portrait = lordLocalData.getPortrait(playerInfo.imageId)
	self.Top_Sprite_king_nor:setSpriteFrame(portrait)
	local allianceInfo = self.legendKingInfo.allianceInfo
	_UPVALUE3_ = self.Top_Sprite_king_nor
	self.Top_Sprite_king_nor[1] = self.bg_alliance_name
	self.Top_Sprite_king_nor[2] = self.text_alliance_name
	local self.Top_Sprite_king_nor[3], tbNodeAlliance = self.node_alliance, self.Top_Sprite_king_nor
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
	lordLocalData = tbNodeAlliance
	tbNodeAlliance[1] = self.text_kingdom_name
	tbNodeAlliance[2] = self.sprite_kingdom_icon
	nationalFlagRead = self.sprite_kingdom_icon
	self.sprite_kingdom_icon[1] = 10
	SoraDAlignNodeArray(tbNodeAlliance, not SoraDFIsRA(), self.sprite_kingdom_icon)
	lordLocalData = tbNodeAlliance
	tbNodeAlliance[1] = self.text_king_name
	tbNodeAlliance[2] = self.sprite_king_icon
	nationalFlagRead = self.sprite_king_icon
	self.sprite_king_icon[1] = 10
	SoraDAlignNodeArray(tbNodeAlliance, not SoraDFIsRA(), self.sprite_king_icon)
end
function legendaryKingView:getLegendKingName()
	if next(self.legendKingInfo) == nil then
		return i18n("common_text_480")
	end
	local playerInfo = self.legendKingInfo.playerInfo
	local allianceInfo = self.legendKingInfo.allianceInfo
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	local strInfo = ""
	if allianceInfo and allianceInfo.abbr then
		_ENV = nil
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
function legendaryKingView:updateRewardNodes()
	local lordRank = legendLordCtrl:getLordRank()
	if lordRank and lordRank <= 3 then
		SoraDSetNodeArrayVisible(self.tbRewardNodes, true)
	end
end
function legendaryKingView:initView()
	self.legendKingInfo = legendLordCtrl:getLegendKingInfo()
	self.btn_king_reward:setVisible(true)
	self.btn_exchange_shop:setVisible(true)
	self:updateExchangeNum()
	if self.viewType == LEGENDLORD_VIEW_TYPE.activity then
		SoraDSetNodeArrayVisible(self.tbWar, false)
		SoraDSetNodeArrayVisible(self.tbPeace, false)
		SoraDSetNodeArrayVisible(self.tbActivityOver, true)
		LEGENDLORD_VIEW_TYPE = nil
		;(nil)[1] = cca.delay(0.5)
		;(nil)[2] = cca.callFunc(function()
			self.node_bottom_ops:setVisible(true)
			self.nodeOp_warRank:setVisible(true)
			self.nodeOp_History:setVisible(true)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.node_bottom_ops:setVisible(true)
			self.nodeOp_warRank:setVisible(true)
			self.nodeOp_History:setVisible(true)
		end)
		self:runAction(cca.seq(nil))
		self:updateRewardNodes()
		self.commonFramTitleNode:setTitle(i18n("common_text_4212"))
		self:updateLegendKingInfo()
		local strName = self:getLegendKingName()
		if next(self.legendKingInfo) then
			self.text_reward_title:setString(i18n("common_text_4211"))
		else
			self.text_reward_title:setString("")
		end
		legendLordCtrl = i18n("common_text_4211")
		i18n("common_text_4211").name = strName
		self.text_reward_des:setString(i18n("common_text_4214", i18n("common_text_4211")))
		if next(self.legendKingInfo) == nil then
			self.text_reward_des:setString(i18n("mail_text_478"))
		end
		self:showLegendReward()
		_ENV = self
		self[1] = self.text_reward_title
		self[2] = self.frame_reward_L
		LEGENDLORD_VIEW_TYPE = self.frame_reward_L
		self.frame_reward_L[1] = 15
		SoraDAlignNodeArray(self, true, self.frame_reward_L)
		_ENV = self
		self[1] = self.text_reward_title
		self[2] = self.frame_reward_R
		LEGENDLORD_VIEW_TYPE = self.frame_reward_R
		self.frame_reward_R[1] = 15
		SoraDAlignNodeArray(self, false, self.frame_reward_R)
	elseif self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		self.commonFramTitleNode:setTitle(i18n("common_text_4207"))
		SoraDSetNodeArrayVisible(self.tbActivityOver, false)
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
		if legendLordActivityStatus == gActivityState.OPEN then
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
			local legendLordState = param.curState
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				self:initViewLordBattle()
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				self:initViewLordSettle()
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
			self:initViewLordPrepare()
		elseif legendLordActivityStatus == gActivityState.CLOSE then
			self:initViewLordSettle()
			self.btn_king_reward:setVisible(false)
			self.btn_exchange_shop:setVisible(false)
		end
	end
end
function legendaryKingView:updateBtnPos(isShowLang)
	local _ENV, showBtns
	local nums = 2
	if isShowLang then
		self.nodeOp_land:setVisible(true)
		table.insert(showBtns, self.nodeOp_land)
		nums = nums + 1
	else
		self.nodeOp_land:setVisible(false)
	end
	table.insert(showBtns, self.nodeOp_warRank)
	if legendLordCtrl:getIsSelfLegendKing() then
		self.nodeOp_manage:setVisible(true)
		table.insert(showBtns, self.nodeOp_manage)
		nums = nums + 1
	else
		self.nodeOp_manage:setVisible(false)
	end
	table.insert(showBtns, self.nodeOp_History)
	local scale = nums == 4 and 0.8 or 1
	local beginPosX = nums == 4 and 125 or 145
	local offsetX = nums == 4 and 390 / (nums - 1) or 345 / (nums - 1)
	for index, btn in ipairs(showBtns) do
		print("beginPosX+(index-1)*offsetX", beginPosX + (index - 1) * offsetX)
		btn:setPositionX(SoraDFPosX(beginPosX + (index - 1) * offsetX, 640))
		btn:setScale(scale)
	end
end
function legendaryKingView:initViewLordPrepare()
	self.commonFramTitleNode:setTitle(i18n("common_text_4207"))
	SoraDSetNodeArrayVisible(self.tbWar, false)
	SoraDSetNodeArrayVisible(self.tbPeace, true)
	SoraDSetNodeArrayVisible(self.tbBtnOps, true)
	self.nodeOp_opArmy:setVisible(false)
	self.nodeOp_opGift:setPositionX(self.nodeOp_opGift.oriPosX)
	self.nodeOp_opHistory:setPositionX(self.nodeOp_opHistory.oriPosX)
	self.text_peace_status:setString(i18n("common_text_4210"))
	self.text_peace_tip:setString(i18n("common_text_608"))
	self:beginTime()
end
function legendaryKingView:initViewLordBattle()
	self.commonFramTitleNode:setTitle(i18n("common_text_4207"))
	SoraDSetNodeArrayVisible(self.tbWar, true)
	SoraDSetNodeArrayVisible(self.tbPeace, false)
	SoraDSetNodeArrayVisible(self.tbBtnOps, true)
	_UPVALUE3_ = self.tbBtnOps
	self.tbBtnOps[1] = self.text_king_name
	self.tbBtnOps[2] = self.bg_king_name
	self.tbBtnOps[3] = self.sprite_king_icon
	SoraDSetNodeArrayVisible(self.tbBtnOps, false)
	self.nodeOp_opArmy:setVisible(false)
	self.nodeOp_opGift:setPositionX(self.nodeOp_opGift.oriPosX)
	self.nodeOp_opHistory:setPositionX(self.nodeOp_opHistory.oriPosX)
	self.text_war_title:setString(i18n("common_text_1426"))
	self.Text_warRank:setString(i18n("common_text_4232"))
	self.text_war_status:setString(i18n("common_text_1446"))
	self:beginTime()
	self:reqOccupierInfo()
end
function legendaryKingView:reqOccupierInfo()
	SoraDShowLoading(self)
	self.occupier = nil
	legendLordWarCtrl:getOccupyInfo(self.buildID)
end
function legendaryKingView:showOccupierInfo(target, data)
	SoraDCloseLoading(self)
	self.occupier = data.occupier
	if data.occupier then
		local occupier = data.occupier
		local allianceInfo = occupier.allianceInfo
		local playerInfo = occupier.playerInfo
		self.text_war_alliance_name:setVisible(false)
		self.sprite_alliance_flag:setVisible(false)
		if allianceInfo and allianceInfo.alliance then
			if allianceInfo.alliance then
				self.text_war_alliance_name:setVisible(true)
				self.text_war_alliance_name:setString(allianceInfo.alliance)
			end
			if allianceInfo.flag and allianceDesRead.getFlagIcon(allianceInfo.flag) then
				self.sprite_alliance_flag:setVisible(true)
				self.sprite_alliance_flag:setSpriteFrame(allianceDesRead.getFlagIcon(allianceInfo.flag))
			end
		end
		if playerInfo and playerInfo.nickName then
			self.text_player_name:setVisible(true)
			local textName = playerInfo.nickName
			if textName then
				if allianceInfo and allianceInfo.aid and allianceInfo.aid > 0 and allianceInfo.abbr then
					_ENV = allianceDesRead.getFlagIcon(allianceInfo.flag)
					allianceDesRead.getFlagIcon(allianceInfo.flag).abbr = allianceInfo.abbr
					allianceDesRead.getFlagIcon(allianceInfo.flag).name = playerInfo.nickName
					textName = i18n("common_text_186", allianceDesRead.getFlagIcon(allianceInfo.flag))
				end
				if occupier.kingdomInfo and occupier.kingdomInfo.kid and 0 < occupier.kingdomInfo.kid then
					textName = textName .. "#" .. occupier.kingdomInfo.kid
				end
				self.text_player_name:setString(textName)
			else
				textName = i18n("common_text_480")
				self.text_player_name:setString(textName)
			end
			self.Node_head:setVisible(true)
			SoraDGetHeadFromManager(self.node_head_icon, playerInfo.imageId, playerInfo.avatar)
		else
			self.Node_head:setVisible(false)
			self.text_player_name:setVisible(false)
		end
		if occupier.maxNum then
			self.Node_power:setVisible(true)
			self.text_fight_power:setString(occupier.curNum .. "/" .. occupier.maxNum)
		else
			self.Node_power:setVisible(false)
		end
	end
end
function legendaryKingView:initViewLordSettle()
	SoraDSetNodeArrayVisible(self.tbWar, false)
	SoraDSetNodeArrayVisible(self.tbPeace, false)
	SoraDSetNodeArrayVisible(self.tbSettle, true)
	SoraDSetNodeArrayVisible(self.tbBtnOps, true)
	self.nodeOp_opArmy:setVisible(true)
	self.nodeOp_opGift:setPositionX(SoraDFIsRA() and self.nodeOp_opGift.oriPosX - 65 or self.nodeOp_opGift.oriPosX + 65)
	self.nodeOp_opHistory:setPositionX(SoraDFIsRA() and self.nodeOp_opHistory.oriPosX + 65 or self.nodeOp_opHistory.oriPosX - 65)
	self:updateLegendKingInfo()
	local strName = self:getLegendKingName()
	self.commonFramTitleNode:setTitle(i18n("common_text_4212"))
	_ENV = i18n("common_text_4212")
	i18n("common_text_4212").name = strName
	self.text_reward_des:setString(i18n("common_text_4214", i18n("common_text_4212")))
	self.text_reward_title:setString(i18n("common_text_4211"))
	_UPVALUE2_ = self.text_reward_title
	self.text_reward_title[1] = self.text_reward_title
	self.text_reward_title[2] = self.frame_reward_L
	_UPVALUE1_ = self.frame_reward_L
	self.frame_reward_L[1] = 15
	SoraDAlignNodeArray(self.text_reward_title, true, self.frame_reward_L)
	_UPVALUE2_ = self.text_reward_title
	self.text_reward_title[1] = self.text_reward_title
	self.text_reward_title[2] = self.frame_reward_R
	_UPVALUE1_ = self.frame_reward_R
	self.frame_reward_R[1] = 15
	SoraDAlignNodeArray(self.text_reward_title, false, self.frame_reward_R)
end
function legendaryKingView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function legendaryKingView:updateTime()
	if self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
		local textTarget
		local textKey = ""
		if legendLordActivityStatus == gActivityState.OPEN then
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
			local legendLordState = param.curState
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				textTarget = self.text_war_time
				textKey = "common_text_607"
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			textTarget = self.text_peace_time
			textKey = "common_text_606"
		end
		local eid = gActivityTimeActivityID.LEGEND_LORD
		local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
		if eventLeftTime then
			local timerNode = eventLeftTime.timerNode
			if textTarget and timerNode then
				LEGENDLORD_VIEW_TYPE = nil
				;(nil).time = SoraDConvertSecondToString(timerNode.timer:getRemainTime())
				textTarget:setString(i18n(textKey, nil))
			end
		end
	end
end
function legendaryKingView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function legendaryKingView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK", handler(self, self.sMsgActivityDataBack))
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKING_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_INFO", handler(self, self.showOccupierInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_CHANGE", handler(self, self.reqOccupierInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_INIT", handler(self, self.refreshIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_REFRESH", handler(self, self.refreshIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.updateExchangeNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updateExchangeNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WAR_DATA", handler(self, self.onMsgUpdateLegendData))
end
function legendaryKingView:refreshIcon()
	local isSatisfy, num = landOfSoulCtrl:getReceiveStatusAndNum()
	self.imgRed:setVisible(isSatisfy)
	local remainTime = landOfSoulCtrl:getSoulRemainTime()
	print("remainTime", remainTime)
	if 0 < remainTime then
		self.remainTime:setString(SoraDConvertSecondToString(remainTime))
		self.remainTime:beginTime(remainTime)
	end
	self:updateBtnPos(0 < remainTime)
end
function legendaryKingView:openItemInfoMsg(data)
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
function legendaryKingView:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function legendaryKingView:onClick_Button_War_Rank(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingRank")
		panel:init(gLegendBuildID)
		panel:show()
	end
end
function legendaryKingView:onBtnClickOpReward(sender)
	local panel = SoraDCreatePanel("legendaryKingReward")
	panel:init()
	panel:show()
end
function legendaryKingView:onBtnClickOpKingdom(sender)
	local legendaryKingGrantViewLayer = SoraDCreatePanel("legendaryKingGrantView")
	legendaryKingGrantViewLayer:show()
	_ENV = nil
	;(nil).grantType = 1
	legendaryKingGrantViewLayer:init(nil)
end
function legendaryKingView:onBtnClickOpWorld(sender)
	local legendaryKingGrantViewLayer = SoraDCreatePanel("legendaryKingGrantView")
	legendaryKingGrantViewLayer:show()
	_ENV = nil
	;(nil).grantType = 2
	legendaryKingGrantViewLayer:init(nil)
end
function legendaryKingView:onBtnClickOpGift(sender)
	local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
	panel:show()
	_ENV = nil
	;(nil).viewType = 2
	panel:init(nil)
end
function legendaryKingView:onBtnClickOpWarRank(sender)
	local panel = SoraDCreatePanel("legendaryKingRank")
	panel:init(gLegendBuildID)
	panel:show()
end
function legendaryKingView:onBtnClickOpManage(sender)
	local legendaryKingView = SoraDCreatePanel("legendaryKingView")
	legendaryKingView:show()
	_ENV = nil
	;(nil).viewType = 2
	legendaryKingView:init(nil)
end
function legendaryKingView:onBtnClickOpHistory(sender)
	local panel = SoraDCreatePanel("legendaryKingHistory")
	panel:init(gLegendBuildID)
	panel:show()
end
function legendaryKingView:onBtnClickOpLand(sender)
	local deadArmyList = landOfSoulCtrl:getDeadArmyList()
	if not next(deadArmyList) then
		SoraDShowMsgTip(i18n("heroicSouls_text_5"))
		return
	end
	local panel = SoraDCreatePanel("heroicLandView")
	panel:initData(deadArmyList, gActivityTimeActivityID.LEGEND_LORD)
	panel:show()
end
function legendaryKingView:onBtnClickOpArmy(sender)
	local panel = SoraDCreatePanel("legendaryKingAlliance")
	panel:init(gLegendBuildID)
	panel:show()
end
function legendaryKingView:sMsgActivityDataBack(target, data)
	print("数据返回了 ----------")
	SoraDCloseLoading(self)
	self:initView()
end
function legendaryKingView:msgShowItemInfo(target, data)
	dump(data, "显示itemInfo")
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function legendaryKingView:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID and type(data.activityID) == "table" then
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == gActivityTimeActivityID.LEGEND_LORD then
				local activityState = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
				print("activityState = ", activityState)
				print("self.viewType = ", self.viewType)
				if activityState == gActivityState.CLOSE then
					self:closePanel()
					break
				end
				if activityState == gActivityState.OPEN then
					local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
					local legendState = param.curState
					if legendState == ACTIVITY_STATE.PREPARE then
						self:closePanel()
						break
					end
					if legendState == ACTIVITY_STATE.ACTIVE then
						self:closePanel()
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
function legendaryKingView:onClick_Button_help(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.LEGGEND_LORD)
	end
end
function legendaryKingView:onClick_Button_Reward(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
		panel:show()
		_ENV = nil
		;(nil).viewType = 2
		panel:init(nil)
	end
end
function legendaryKingView:onClick_btn_king_reward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("legendaryKingAwardView"):show()
	end
end
function legendaryKingView:onClick_btn_exchange_shop(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local legendTeamUtil = include("legendTeamUtil")
		if not legendTeamUtil.isWarTest() then
			local panel = SoraDCreatePanel("legendaryExchangeShopView")
			panel:setActivityID(gActivityTimeActivityID.LEGEND_LORD)
			panel:show()
		else
			SoraDShowMsgTip(i18n("Battlefield_queue_text_005"))
		end
	end
end
function legendaryKingView:onClickBtnOccupier(sender, event)
	if event == ccui.TouchEventType.ended then
		if not self.occupier then
			return
		end
		local playerInfo = self.occupier.playerInfo
		if playerInfo == nil or next(playerInfo) == nil then
			return
		end
		local kingdomInfo = self.occupier.kingdomInfo
		SoraDPlaySound()
		local kid = kingdomInfo and kingdomInfo.kid or playerInfo.kid
		local uid = playerInfo.uid
		self:reqPlayerInfo(uid, kid)
	end
end
function legendaryKingView:onClickBtnKing(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if not self.legendKingInfo then
			return
		end
		local kingdomInfo = self.legendKingInfo.kingdomInfo
		if kingdomInfo == nil or next(kingdomInfo) == nil then
			return
		end
		SoraDPlaySound()
		local playerInfo = self.legendKingInfo.playerInfo
		local kid = kingdomInfo.kid
		local uid = playerInfo.uid
		self:reqPlayerInfo(uid, kid)
	end
end
function legendaryKingView:updateExchangeNum()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local retShop, num = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.LEGEND_LORD)
	self.exchangeRedPoint:setVisible(retShop and 0 < num)
	print("legendaryKingView:updateExchangeNum", retShop, num)
	self.exchangeRedPoint:getChildByName("Text_redPointInt"):setString(num)
end
function legendaryKingView:reqPlayerInfo(uid, kid)
	SoraDShowLoading(self)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local key = "fromLegendaryKingView_" .. self.viewType
	_ENV = nil
	;(nil)[key] = true
	;(nil).targetName = self.__cname
	lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
end
function legendaryKingView:onClickBtnAlliance(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		local kingdomInfo = self.legendKingInfo.kingdomInfo
		if kingdomInfo == nil or next(kingdomInfo) == nil then
			return
		end
		SoraDPlaySound()
		SoraDShowLoading(self)
		local kid = kingdomInfo.kid
		local allianceInfo = self.legendKingInfo.allianceInfo
		local aid = allianceInfo.aid
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		print("请求联盟信息, kid = ", kid, ", aid = ", aid)
		_ENV = aid
		aid.from = "legendaryKingView"
		allianceQuery:reqAllianceInfo(kid, aid, aid)
	end
end
function legendaryKingView:msgGetLordInfo(target, data)
	if data.clientData and data.lord then
		local keyName = "fromLegendaryKingView_" .. self.viewType
		local keyValue = data.clientData[keyName]
		if keyValue == true then
			SoraDCloseLoading(self)
			SoraDOpenLordView(data.lord)
		end
	end
end
function legendaryKingView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "legendaryKingView" then
			SoraDCloseLoading(self)
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function legendaryKingView:onMsgUpdateLegendData(target, event)
	if self.viewType ~= LEGENDLORD_VIEW_TYPE.activity then
		return
	end
	if not legendLordWarCtrl:checkBackPlayerTime() then
		return
	end
	if not self.btn_hospital then
		local obj = fguiHelper.createObject("KingStarBattle", "Button_hospital")
		obj:addTo(self.Top_Node_Status)
		obj:setPivot(0.5, 0.5, true)
		obj:setPosition(SoraDFPoint(60, -650, 640))
		obj:setScale(0.8)
		LEGENDLORD_VIEW_TYPE = 0.8
		;(0.8).warType = gKingdomClassType.legendLord
		;(0.8).hideText = true
		;(0.8).style = 1
		obj:initData(0.8)
		self.btn_hospital = obj
	end
	self.btn_hospital:onMsgUpdateWarData()
end
return legendaryKingView
