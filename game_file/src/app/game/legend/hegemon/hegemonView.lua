local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local lordLocalData = include("lordLocalData")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local nationalFlagRead = include("nationalFlagRead")
local allianceDesRead = include("allianceDesRead")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local hegemonRead = include("hegemonRead")
_ENV = "hegemonRead"
;("hegemonRead").activity = 1
local ("hegemonRead").lord, LEGENDLORD_VIEW_TYPE = 2, "hegemonRead"
local hegemonView = class("hegemonView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("hegemonView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function hegemonView:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Bg_King = SoraDGetChildByName(self, "Top_Bg_King")
	self.Top_Bg_King:loadTexture("bg_bzzz_01.png", ccui.TextureResType.plistType)
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
	self.img_peace_time_bg = SoraDGetChildByName(self, "img_peace_time_bg")
	self.img_peace_tip_bg = SoraDGetChildByName(self, "img_peace_tip_bg")
	self.text_peace_tip = SoraDGetChildByName(self, "text_peace_status")
	self.text_peace_time = SoraDGetChildByName(self, "text_peace_time")
	self.Node_Operate_btns = SoraDGetChildByName(self, "Node_Operate_btns")
	self.nodeOp_opReward = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_reward")
	self.nodeOp_opKingom = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_kingdom")
	self.nodeOp_opWorld = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_world")
	self.nodeOp_opGift = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_gift")
	self.nodeOp_opHistory = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_history")
	self.nodeOp_opArmy = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeOpHegemon_army")
	self.Top_Node_Rank = SoraDGetChildByName(self, "Top_Node_Rank")
	self.btn_hegemon_rank = SoraDGetChildByName(self, "btn_hegemon_rank")
	self.label_rank = SoraDGetChildByName(self, "label_rank")
	self.Node_over_myself = SoraDGetChildByName(self, "Node_over_myself")
	self.nodeReward_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeReward_node")
	self.node_reward_info = SoraDGetChildByName(self, "node_reward_info")
	self.text_reward_title = SoraDGetChildByName(self, "text_reward_title")
	self.frame_reward_R = SoraDGetChildByName(self, "frame_reward_R")
	self.frame_reward_L = SoraDGetChildByName(self, "frame_reward_L")
	self.text_reward_des = SoraDGetChildByName(self, "text_reward_des")
	self.commonFramTitleNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.Panel_Content = SoraDGetChildByName(self, "Panel_Content")
	self.Scroll_Content = SoraDGetChildByName(self, "Scroll_Content")
	self.Top_Btn_King = SoraDGetChildByName(self, "Top_Btn_King")
	self.btn_node_alliance = SoraDGetChildByName(self, "btn_node_alliance")
	self.sp_activity_text = SoraDGetChildByName(self, "sprite_activity_text")
	self.btn_hegemon_rank:addTouchEventListener(handler(self, self.onClick_Button_War_Rank))
	_UPVALUE3_, self.Node_power = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power")
	_UPVALUE4_, self.tbActivityOver, SoraDGetChildByName(self, "Node_power")[1] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Node_over
	_UPVALUE4_, self.tbActivityOver, SoraDGetChildByName(self, "Node_power")[2] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Node_over_myself
	_UPVALUE4_, self.tbActivityOver, SoraDGetChildByName(self, "Node_power")[3] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Top_Sprite_king_nor
	_UPVALUE3_, self.tbWar, SoraDGetChildByName(self, "Node_power")[1] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Top_Node_war
	_UPVALUE3_, self.tbWar, SoraDGetChildByName(self, "Node_power")[2] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Node_war
	_UPVALUE3_, self.tbWar, SoraDGetChildByName(self, "Node_power")[3] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Top_Sprite_king_gray
	_UPVALUE3_, self.tbWar, SoraDGetChildByName(self, "Node_power")[4] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Top_Node_Rank
	_UPVALUE2_, self.tbPeace, SoraDGetChildByName(self, "Node_power")[1] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Top_Node_peace
	_UPVALUE2_, self.tbPeace, SoraDGetChildByName(self, "Node_power")[2] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Node_peace
	_UPVALUE2_, self.tbPeace, SoraDGetChildByName(self, "Node_power")[3] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.sp_activity_text
	legendLordWarltCtrl, self.tbSettle, SoraDGetChildByName(self, "Node_power")[1] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Node_over
	legendLordWarltCtrl, self.tbSettle, SoraDGetChildByName(self, "Node_power")[2] = SoraDGetChildByName(self, "Node_power"), SoraDGetChildByName(self, "Node_power"), self.Top_Sprite_king_nor
	self.tbBtnOps, SoraDGetChildByName(self, "Node_power")[1] = SoraDGetChildByName(self, "Node_power"), self.Node_Operate_btns
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
	self:hideAll()
	local nodeFireL = SoraDGetCommonJetFireNode()
	nodeFireL:addTo(self.frame_lace_base_L)
	nodeFireL:setPositionY(120)
	nodeFireL:setPositionX(34)
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:addTo(self.frame_lace_base_R)
	nodeFireR:setPositionY(120)
	nodeFireR:setPositionX(40)
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
		_UPVALUE3_ = self.Panel_Content:getContentSize()
		self.Panel_Content:getContentSize()[1] = self.Node_war
		self.Panel_Content:getContentSize()[2] = self.Top_Node_Status
		self.Panel_Content:getContentSize()[3] = self.Node_peace
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
		self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	end
	self.Top_Btn_King:addTouchEventListener(handler(self, self.onClickBtnKing))
	self.btn_occupier:addTouchEventListener(handler(self, self.onClickBtnOccupier))
	self.btn_node_alliance:addTouchEventListener(handler(self, self.onClickBtnAlliance))
	self:setLegendEffect()
end
function hegemonView:setLegendEffect()
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
function hegemonView:hideAll()
	SoraDSetNodeArrayVisible(self.tbActivityOver, false)
	SoraDSetNodeArrayVisible(self.tbWar, false)
	SoraDSetNodeArrayVisible(self.tbPeace, false)
	SoraDSetNodeArrayVisible(self.tbBtnOps, false)
end
function hegemonView:createUI()
end
function hegemonView:init(data)
	self.bid = data.bid
	local buildName = hegemonRead.getName(self.bid)
	self.commonFramTitleNode:setTitle(buildName)
	self.activityID = hegemonRead.getActivityIdByBuildID(self.bid)
	self:initWithLord()
end
function hegemonView:initWithLord()
	local legendLordActivityStatus = activityShowCtrl:getStateByID(self.activityID)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(self.activityID)
		local legendLordState = param.curState
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			self:initViewLordBattle()
		elseif legendLordState == ACTIVITY_STATE.SETTLE then
			SoraDShowLoading(self)
			hegemonCtrl:reqHegemonInfo(self.bid)
		end
	elseif legendLordActivityStatus == gActivityState.PREPARE then
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		self:initViewLordPrepare()
	elseif legendLordActivityStatus == gActivityState.CLOSE then
		SoraDShowLoading(self)
		hegemonCtrl:reqHegemonInfo(self.bid)
	end
end
function hegemonView:recycleRewards()
	for i = 1, #self.tbRewardInUse do
		self.tbRewardInUse[i]:setVisible(false)
		self.tbRewardInUse[i]:removeGlow()
		table.insert(self.tbRewardNotInUse, self.tbRewardInUse[i])
	end
	self.tbRewardInUse, _ENV = 1, (for index)
end
function hegemonView:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	cloneNode = include("nodeReward").new(cloneNode)
	cloneNode:addTo(self.templateNodeReward:getParent())
	cloneNode:setPosition(cc.p(self.templateNodeReward:getPosition()))
	return cloneNode
end
function hegemonView:showLegendReward()
	local ua = include("utilAlign")
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
		table.insert(self.tbRewardInUse, nodeReward)
		nodeReward:init(self.kingReward[i])
	end
	for i = 1, 3 do
		if self.kingReward[i].id == 6200111 then
			self.tbRewardInUse[i]:showGlow()
			break
		end
	end
	local marginx = (640 - 120 * numx - 60 * (numx - 1)) / 2
	if numx == 4 then
		marginx = 50
	end
	_ENV = 60 * (numx - 1)
	;(60 * (numx - 1)).directionx = ua.Direction.LEFT
	;(60 * (numx - 1)).directiony = ua.Direction.UP
	;(60 * (numx - 1)).totalWidth = 640
	;(60 * (numx - 1)).itemWidth = 120
	;(60 * (numx - 1)).itemHeight = 150
	;(60 * (numx - 1)).numx = numx
	;(60 * (numx - 1)).beginx = 0
	;(60 * (numx - 1)).offsetx = -60
	;(60 * (numx - 1)).beginy = 156
	;(60 * (numx - 1)).offsety = -75.0
	;(60 * (numx - 1)).marginx = marginx
	;(60 * (numx - 1)).marginy = 0
	;(60 * (numx - 1)).totalNum = #self.tbRewardInUse
	local (60 * (numx - 1)).paddingy, param = paddingy, 60 * (numx - 1)
	ua.alignHFits(self.tbRewardInUse, param)
end
function hegemonView:updateLegendKingInfo()
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		self.text_king_name:setString(i18n("common_text_480"))
		self.text_kingdom_name:setVisible(false)
		self.sprite_kingdom_icon:setVisible(false)
		self.bg_alliance_name:setVisible(false)
		self.node_alliance:setVisible(false)
		self.text_alliance_name:setVisible(false)
		self.Top_Sprite_king_nor:setVisible(false)
		self.Top_Sprite_king_gray:setVisible(false)
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
	self.text_king_name:setString(i18n("hegemon_title_18", i18n("common_text_480")))
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
	lordLocalData = false
	;(false)[1] = self.text_kingdom_name
	;(false)[2] = self.sprite_kingdom_icon
	nationalFlagRead = self.sprite_kingdom_icon
	self.sprite_kingdom_icon[1] = 10
	SoraDAlignNodeArrayOnCenterX(320, false, not SoraDFIsRA(), self.sprite_kingdom_icon)
	lordLocalData = 320
	;(320)[1] = self.text_king_name
	;(320)[2] = self.sprite_king_icon
	nationalFlagRead = self.sprite_king_icon
	self.sprite_king_icon[1] = 10
	SoraDAlignNodeArray(320, not SoraDFIsRA(), self.sprite_king_icon)
end
function hegemonView:getLegendKingName()
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
function hegemonView:updateRewardNodes()
	local lordRank = legendLordCtrl:getLordRank()
	if lordRank and lordRank <= 3 then
		SoraDSetNodeArrayVisible(self.tbRewardNodes, true)
	end
end
function hegemonView:initView()
	self.legendKingInfo = hegemonCtrl:getHegemonInfoByBid(self.bid)
	SoraDSetNodeArrayVisible(self.tbActivityOver, false)
	local legendLordActivityStatus = activityShowCtrl:getStateByID(self.activityID)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(self.activityID)
		local legendLordState = param.curState
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			self:initViewLordBattle()
		elseif legendLordState == ACTIVITY_STATE.SETTLE then
			self:initViewLordSettle()
		end
	elseif legendLordActivityStatus == gActivityState.PREPARE then
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		self:initViewLordPrepare()
	elseif legendLordActivityStatus == gActivityState.CLOSE then
		self:initViewLordSettle()
	end
end
function hegemonView:initViewLordPrepare()
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
function hegemonView:initViewLordBattle()
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
	self.label_rank:setString(i18n("common_text_4232"))
	self.text_war_status:setString(i18n("common_text_1446"))
	self:beginTime()
	self:reqOccupierInfo()
end
function hegemonView:reqOccupierInfo()
	SoraDShowLoading(self)
	self.occupier = nil
	legendLordWarCtrl:getOccupyInfo(self.bid)
end
function hegemonView:showOccupierInfo(target, data)
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
function hegemonView:initViewLordSettle()
	SoraDSetNodeArrayVisible(self.tbWar, false)
	SoraDSetNodeArrayVisible(self.tbPeace, false)
	SoraDSetNodeArrayVisible(self.tbSettle, true)
	SoraDSetNodeArrayVisible(self.tbBtnOps, true)
	self.nodeOp_opArmy:setVisible(true)
	self.nodeOp_opGift:setPositionX(SoraDFIsRA() and self.nodeOp_opGift.oriPosX - 65 or self.nodeOp_opGift.oriPosX + 65)
	self.nodeOp_opHistory:setPositionX(SoraDFIsRA() and self.nodeOp_opHistory.oriPosX + 65 or self.nodeOp_opHistory.oriPosX - 65)
	self:updateLegendKingInfo()
	local strName = self:getLegendKingName()
	self.commonFramTitleNode:setTitle(i18n("hegemon_title_02"))
end
function hegemonView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function hegemonView:updateTime()
	local legendLordActivityStatus = activityShowCtrl:getStateByID(self.activityID)
	local textTarget
	local textKey = ""
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(self.activityID)
		local legendLordState = param.curState
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			textTarget = self.text_war_time
			textKey = "common_text_607"
		elseif legendLordState == ACTIVITY_STATE.SETTLE then
		end
	elseif legendLordActivityStatus == gActivityState.PREPARE then
		textTarget = self.text_peace_time
		textKey = "common_text_606"
	end
	local eid = self.activityID
	local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
	if eventLeftTime then
		local timerNode = eventLeftTime.timerNode
		if textTarget and timerNode then
			activityShowCtrl = nil
			;(nil).time = SoraDConvertSecondToString(timerNode.timer:getRemainTime())
			textTarget:setString(i18n(textKey, nil))
		end
	end
end
function hegemonView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function hegemonView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_KING_DATA_BACK", handler(self, self.sMsgActivityDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_INFO", handler(self, self.showOccupierInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_CHANGE", handler(self, self.reqOccupierInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function hegemonView:onClick_Button_War_Rank(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingRank")
		panel:init(self.bid)
		panel:show()
	end
end
function hegemonView:onBtnClickOpReward(sender)
	local panel = SoraDCreatePanel("hegemonReward")
	panel:show()
	_ENV = nil
	;(nil).bid = self.bid
	panel:init(nil)
end
function hegemonView:onBtnClickOpKingdom(sender)
	local param = activityShowCtrl:getParamByID(self.activityID)
	local curState = param.curState
	if curState == ACTIVITY_STATE.PREPARE then
		SoraDShowMsgTip(i18n("common_text_4420"))
		return
	end
	local bid = self.bid
	local panel = SoraDCreatePanel("hegemonKingView")
	panel:show()
	activityShowCtrl = i18n("common_text_4420")
	i18n("common_text_4420").bid = bid
	panel:init(i18n("common_text_4420"))
end
function hegemonView:onBtnClickOpWorld(sender)
	local grantView = SoraDCreatePanel("hegemonGrantView")
	grantView:show()
	_ENV = nil
	;(nil).grantType = 2
	;(nil).bid = self.bid
	grantView:init(nil)
end
function hegemonView:onBtnClickOpGift(sender)
	local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
	panel:show()
	_ENV = nil
	;(nil).viewType = 4
	;(nil).bid = self.bid
	panel:init(nil)
end
function hegemonView:onBtnClickOpWarRank(sender)
	local panel = SoraDCreatePanel("legendaryKingRank")
	panel:init(self.bid)
	panel:show()
end
function hegemonView:onBtnClickOpHistory(sender)
	local panel = SoraDCreatePanel("legendaryKingHistory")
	panel:init(self.bid)
	panel:show()
end
function hegemonView:onBtnClickOpArmy(sender)
	local panel = SoraDCreatePanel("legendaryKingAlliance")
	panel:init(self.bid)
	panel:show()
end
function hegemonView:sMsgActivityDataBack(target, data)
	print("数据返回了 ----------")
	SoraDCloseLoading(self)
	self:initView()
end
function hegemonView:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID and type(data.activityID) == "table" then
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == self.activityID then
				local activityState = activityShowCtrl:getStateByID(self.activityID)
				print("activityState = ", activityState)
				print("self.viewType = ", self.viewType)
				if activityState == gActivityState.CLOSE then
					self:closePanel()
					break
				end
				if activityState == gActivityState.OPEN then
					local param = activityShowCtrl:getParamByID(self.activityID)
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
function hegemonView:onClick_Button_help(sender, event)
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
function hegemonView:onClickBtnOccupier(sender, event)
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
function hegemonView:onClickBtnKing(sender, event)
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
function hegemonView:reqPlayerInfo(uid, kid)
	SoraDShowLoading(self)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local key = "fromHegemonView"
	_ENV = nil
	;(nil)[key] = true
	;(nil).targetName = self.__cname
	lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
end
function hegemonView:onClickBtnAlliance(sender, event)
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
		aid.from = "hegemonView"
		allianceQuery:reqAllianceInfo(kid, aid, aid)
	end
end
function hegemonView:msgGetLordInfo(target, data)
	if data.clientData then
		local keyName = "fromHegemonView"
		local keyValue = data.clientData[keyName]
		if keyValue == true then
			SoraDCloseLoading(self)
			SoraDOpenLordView(data.lord)
		end
	end
end
function hegemonView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "hegemonView" then
			SoraDCloseLoading(self)
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function hegemonView:setHegemonEffect()
	local eTop = SoraDGetChildByName(self, "Node_eTop")
	local showEffect = function()
		local act_eBg = SoraDCreatAnimation("etHegemonTop")
		for i = 1, 2 do
			local bgLight = SoraDGetChildByName(act_eBg, "sp_dh_fire_" .. i)
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
return hegemonView
