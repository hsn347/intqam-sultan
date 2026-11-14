local gametop = gModuleMgr.getObject("gametop")
local heroWarCtrl = gametop.playertop_:getModule("heroWarCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local findMonsterCtrl = gametop.playertop_:getModule("findMonsterCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local publicRead = include("publicRead")
local eventHeroWarView = class("eventHeroWarView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventHeroWarView")
	end
	return target
end)
function eventHeroWarView:ctor()
	self:bindBtnClose()
	self.tabTag = 1
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventHero")
	self.ccs_title:setTitle(i18n("activityname_20"))
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Image_event:loadTexture(SoraDCheckPNG("bg_activity_9001075.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.Button_eventDetail = SoraDGetChildByName(self, "Button_eventDetail")
	self.Button_eventDetail:setTitleText(i18n("common_text_779"))
	self.Button_eventDetail:setTag(1)
	SoraDAutoSizeButtonText(self.Button_eventDetail, cc.size(200, 70))
	self.Button_allianceRank = SoraDGetChildByName(self, "Button_allianceRank")
	self.Button_allianceRank:setTitleText(i18n("common_text_3573"))
	self.Button_allianceRank:setTag(2)
	SoraDAutoSizeButtonText(self.Button_allianceRank, cc.size(200, 70))
	self.Button_rankAward = SoraDGetChildByName(self, "Button_rankAward")
	self.Button_rankAward:setTitleText(i18n("common_text_2194"))
	self.Button_rankAward:setTag(3)
	SoraDAutoSizeButtonText(self.Button_rankAward, cc.size(200, 70))
	self.Button_eventDetail:addTouchEventListener(handler(self, self.onBtnClick))
	self.Button_allianceRank:addTouchEventListener(handler(self, self.onBtnClick))
	self.Button_rankAward:addTouchEventListener(handler(self, self.onBtnClick))
	self.Top_Size_ScrollView_detail = SoraDGetChildByName(self, "Top_Size_ScrollView_detail")
	self.Top_Node_allianceRank = SoraDGetChildByName(self, "Top_Node_allianceRank")
	self.Top_Node_rankAward = SoraDGetChildByName(self, "Top_Node_rankAward")
	self.Top_Size_ScrollView_detail:setVisible(false)
	self.Top_Size_ScrollView_detail:setTouchEnabled(false)
	self.Top_Node_allianceRank:setVisible(false)
	self.Top_Node_rankAward:setVisible(false)
	self:suitView()
	self:starLoadImage()
	self:onBtnClick(self.Button_eventDetail, ccui.TouchEventType.ended, true)
end
function eventHeroWarView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROWAR_REFRESH", handler(self, self.showAllianceRankView))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.findBossBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROWAR_INIT_BACK", handler(self, self.refreshBoxNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROWAR_RECEIVE_BACK", handler(self, self.refreshBoxNum))
end
function eventHeroWarView:starLoadImage()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).name = "Common/herowarBorder"
	;(nil).key = "herowarBorder"
	local (nil)[1], imgArray
	local canLoad = true
	for _, v in ipairs(imgArray) do
		local ret = SoraDIsFileExistByKey(v.key)
		if not ret then
			canLoad = false
		end
	end
	if canLoad then
		self:loadImages(imgArray, function()
			local ret = SoraDIsFileExistByKey("herowarBorder")
			if ret then
				local dh_border = display.newSprite("#dh_yingxiongzhizhan_01.png")
				dh_border:setScale(2.01)
				local Node_detail = SoraDGetChildByName(self.Top_Size_ScrollView_detail, "Node_detail")
				local Node_difficult = SoraDGetChildByName(Node_detail, "Node_difficult")
				local Node_border = SoraDGetChildByName(Node_difficult, "Node_border")
				dh_border:addTo(Node_border)
				local frames = display.newFrames("dh_yingxiongzhizhan_%.2d.png", 1, 14)
				local animation = display.newAnimation(frames, 1.5 / #frames)
				dh_border:stopAllActions()
				dh_border:playAnimationForever(animation)
			end
		end)
	end
end
function eventHeroWarView:suitView()
	local Size_Panel_bgCut = SoraDGetChildByName(self, "Size_Panel_bgCut")
	local Image_LT = SoraDGetChildByName(Size_Panel_bgCut, "Image_LT")
	local Image_RT = SoraDGetChildByName(Size_Panel_bgCut, "Image_RT")
	local Image_LB = SoraDGetChildByName(Size_Panel_bgCut, "Image_LB")
	local Image_RB = SoraDGetChildByName(Size_Panel_bgCut, "Image_RB")
	Size_Panel_bgCut:setContentSize(cc.size(640, display.height - 270))
	Image_LT:setPositionY(Size_Panel_bgCut:getContentSize().height)
	Image_RT:setPositionY(Size_Panel_bgCut:getContentSize().height)
	Image_LB:setPositionY(Size_Panel_bgCut:getContentSize().height - Image_LT:getContentSize().height)
	Image_RB:setPositionY(Size_Panel_bgCut:getContentSize().height - Image_RT:getContentSize().height)
end
function eventHeroWarView:onBtnClick(target, event, isNoSound)
	if event == ccui.TouchEventType.ended then
		if not isNoSound then
			SoraDPlaySound()
		end
		self.tabTag = target:getTag()
		self:updateTabBtns()
		self:initViewByTag()
	end
end
function eventHeroWarView:updateTabBtns()
	_UPVALUE3_ = nil
	;(nil)[1] = self.Button_eventDetail
	;(nil)[2] = self.Button_allianceRank
	local (nil)[3], btns = self.Button_rankAward, nil
	for k, v in pairs(btns) do
		if self.tabTag ~= k then
			v:setBright(false)
			v:setTitleColor(cc.c3b(100, 80, 40))
			v:setTouchEnabled(true)
		else
			v:setBright(true)
			v:setTitleColor(cc.c3b(255, 200, 100))
			v:setTouchEnabled(false)
		end
	end
end
function eventHeroWarView:initViewByTag()
	if self.tabTag == 1 then
		self:showEventDetailView()
		heroWarCtrl:sendReqInitMsg()
	elseif self.tabTag == 2 then
		SoraDShowLoading(self)
		heroWarCtrl:sendReqRankMsg()
	elseif self.tabTag == 3 then
		self:showRankAwardlView()
	end
end
function eventHeroWarView:showEventDetailView()
	self.Top_Size_ScrollView_detail:setVisible(true)
	self.Top_Node_allianceRank:setVisible(false)
	self.Top_Node_rankAward:setVisible(false)
	local Node_detail = SoraDGetChildByName(self.Top_Size_ScrollView_detail, "Node_detail")
	Node_detail:setPositionY(self.Top_Size_ScrollView_detail:getInnerContainerSize().height)
	local Text_detailTitle = SoraDGetChildByName(Node_detail, "Text_detailTitle")
	Text_detailTitle:setString(i18n("herobattle_text_03"))
	local textW = Text_detailTitle:getContentSize().width
	if 500 < textW then
		SoraDSetTextWidthHeight(Text_detailTitle, cc.size(500, 35))
	end
	local Button_help = SoraDGetChildByName(Node_detail, "Button_help")
	Button_help:setPositionX(Text_detailTitle:getPositionX() + Text_detailTitle:getContentSize().width / 2 + 30)
	Button_help:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			_ENV = "herobattle_text_17"
			;("herobattle_text_17").align = SoraDFLabelR()
			SoraDShowHelpMsgTip(i18n("herobattle_text_17"), "herobattle_text_17")
		end
	end)
	local Text_info = SoraDGetChildByName(Node_detail, "Text_info")
	Text_info:setString(i18n("herobattle_text_04"))
	local Node_easy = SoraDGetChildByName(Node_detail, "Node_easy")
	local Node_difficult = SoraDGetChildByName(Node_detail, "Node_difficult")
	SoraDGetChildByName(Node_easy, "Panel_cut"):setSwallowTouches(false)
	SoraDGetChildByName(Node_difficult, "Panel_cut"):setSwallowTouches(false)
	local bg_spine_easy = SoraDGetChildByName(Node_easy, "bg_spine")
	bg_spine_easy:loadTexture(SoraDCheckPNG("bg_huodong_yingxiongzhizhan_tu1.png", "bg_transparent.png"), ccui.TextureResType.plistType)
	local bg_spine_difficult = SoraDGetChildByName(Node_difficult, "bg_spine")
	bg_spine_difficult:loadTexture(SoraDCheckPNG("bg_huodong_yingxiongzhizhan_tu1.png", "bg_transparent.png"), ccui.TextureResType.plistType)
	local Node_spine_easy = SoraDGetChildByName(Node_easy, "Node_spine_easy")
	if not Node_spine_easy:getChildByName("spine_easy") then
		local spine_easy = sp.SkeletonAnimation:create("spine/liuxingchui.skel", "spine/liuxingchui.atlas", 1)
		spine_easy:setName("spine_easy")
		spine_easy:addTo(Node_spine_easy)
		spine_easy:setAnimation(0, "animation", true)
	end
	local Node_spine_difficult = SoraDGetChildByName(Node_difficult, "Node_spine_difficult")
	if not Node_spine_difficult:getChildByName("spine_difficult") then
		local spine_difficult = sp.SkeletonAnimation:create("spine/qishi.skel", "spine/qishi.atlas", 1)
		spine_difficult:setName("spine_difficult")
		spine_difficult:addTo(Node_spine_difficult)
		spine_difficult:setAnimation(0, "animation", true)
	end
	local Text_name_easy = SoraDGetChildByName(Node_easy, "Text_name")
	Text_name_easy:setString(i18n("npc_name_011"))
	local Button_go_easy = SoraDGetChildByName(Node_easy, "Button_go")
	Button_go_easy:setSwallowTouches(false)
	Button_go_easy:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if target.singleIsMoved then
				target.singleIsMoved = false
				return
			end
			SoraDPlaySound()
			SoraDShowLoading(self)
			findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeBoss, gBossType.heroBattleBoss1, nil, nil, nil, nil, nil, nil, true)
		elseif event == ccui.TouchEventType.moved then
			local touchBeganPoint = target:getTouchBeganPosition()
			local touchmovePoint = target:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				target.singleIsMoved = true
			end
		elseif event == ccui.TouchEventType.canceled then
			target.singleIsMoved = false
		end
	end)
	local Text_name_difficult = SoraDGetChildByName(Node_difficult, "Text_name")
	Text_name_difficult:setString(i18n("npc_name_012"))
	local Button_go_difficult = SoraDGetChildByName(Node_difficult, "Button_go")
	Button_go_difficult:setSwallowTouches(false)
	Button_go_difficult:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if target.singleIsMoved then
				target.singleIsMoved = false
				return
			end
			SoraDPlaySound()
			SoraDShowLoading(self)
			findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeBoss, gBossType.heroBattleBoss2, nil, nil, nil, nil, nil, nil, true)
		elseif event == ccui.TouchEventType.moved then
			local touchBeganPoint = target:getTouchBeganPosition()
			local touchmovePoint = target:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				target.singleIsMoved = true
			end
		elseif event == ccui.TouchEventType.canceled then
			target.singleIsMoved = false
		end
	end)
	self:refreshBoxNum()
	local Button_reward = SoraDGetChildByName(Node_detail, "Button_reward")
	Button_reward:setTitleText(i18n("herobattle_text_28"))
	SoraDAutoSizeButtonTextByContent(Button_reward)
	Button_reward:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			SoraDCreatePanel("eventHeroWarPopView"):show()
		end
	end)
	if not self.isEventDetailViewInit then
		self.isEventDetailViewInit = true
		local frame_zhuangshi_huawen01_11 = SoraDGetChildByName(Node_detail, "frame_zhuangshi_huawen01_11")
		local frame_line = SoraDGetChildByName(Node_detail, "frame_line")
		local textH = display.height - 890
		if display.height < 900 then
			local scale = 0.78
			Node_detail:setScale(scale)
			Button_reward:setScale(1 / scale)
			textH = 80
		elseif display.height < 1000 then
			local scale = 0.93
			Node_detail:setScale(scale)
			Button_reward:setScale(1 / scale)
			textH = 100
		end
		local textW = Text_info:getContentSize().width
		local autoH = SoraDGetAutoHeightLabel(Text_info, textW)
		if textH < autoH then
			SoraDSetTextWidthHeight(Text_info, cc.size(textW, textH))
			autoH = textH
		end
		if display.height > 1250 then
			Text_detailTitle:setAnchorPoint(cc.p(0.5, 0.5))
			Text_detailTitle:setPositionY(-26)
			Text_info:setFontSize(24)
			SoraDSetTextWidthHeight(Text_info, cc.size(textW, 210))
			Node_detail:setScaleY(1.4)
			for k, v in pairs(Node_detail:getChildren()) do
				v:setScaleY(v:getScaleY() / 1.4)
			end
		else
			frame_line:setPositionY(Text_info:getPositionY() - autoH - 12)
			Node_easy:setPositionY(frame_line:getPositionY() - 196)
			Node_difficult:setPositionY(frame_line:getPositionY() - 196)
			Button_reward:setPositionY(Node_easy:getPositionY() - 230)
		end
	end
end
function eventHeroWarView:refreshBoxNum(...)
	local Node_detail = SoraDGetChildByName(self.Top_Size_ScrollView_detail, "Node_detail")
	local data = heroWarCtrl:getKillRewardData()
	local Text_box_easy = SoraDGetChildByName(Node_detail, "Text_box_easy")
	Text_box_easy:setString("x" .. string.formatnumberthousands(data.receive1))
	if data.receive1 <= 0 then
		Text_box_easy:setColor(cc.c3b(190, 30, 30))
	else
		Text_box_easy:setColor(cc.c3b(255, 200, 100))
	end
	local Text_box_difficult = SoraDGetChildByName(Node_detail, "Text_box_difficult")
	Text_box_difficult:setString("x" .. string.formatnumberthousands(data.receive2))
	if 0 >= data.receive2 then
		Text_box_difficult:setColor(cc.c3b(190, 30, 30))
	else
		Text_box_difficult:setColor(cc.c3b(255, 200, 100))
	end
end
function eventHeroWarView:showAllianceRankView(target, data)
	SoraDCloseLoading(self)
	self.Top_Size_ScrollView_detail:setVisible(false)
	self.Top_Node_allianceRank:setVisible(true)
	self.Top_Node_rankAward:setVisible(false)
	local isJoinAllliance = allianceMgr:hasJoinAlliance() and true or false
	local Top_Size_ScrollView_allianceRank = SoraDGetChildByName(self.Top_Node_allianceRank, "Top_Size_ScrollView_allianceRank")
	Top_Size_ScrollView_allianceRank:setPositionY(0)
	Top_Size_ScrollView_allianceRank:setContentSize(cc.size(640, display.height - 460))
	local Bottom_Node_allianceRank = SoraDGetChildByName(self.Top_Node_allianceRank, "Bottom_Node_allianceRank")
	Bottom_Node_allianceRank:setPositionY(-Top_Size_ScrollView_allianceRank:getContentSize().height - 110)
	local Node_allianceInfo = SoraDGetChildByName(Bottom_Node_allianceRank, "Node_allianceInfo")
	local Button_join = SoraDGetChildByName(Bottom_Node_allianceRank, "Button_join")
	Button_join:setTitleText(i18n("common_text_167"))
	Button_join:setVisible(not isJoinAllliance)
	Node_allianceInfo:setVisible(isJoinAllliance)
	Button_join:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			uiManager:show("AllianceJoinView")
		end
	end)
	if isJoinAllliance then
		if not heroWarCtrl:getselfInfo() then
			local _ENV, selfInfo = heroWarCtrl:getselfInfo(), heroWarCtrl:getselfInfo()
		end
		local allianceInfo = allianceMgr:getAlliance()
		Node_allianceInfo:setVisible(true)
		local Node_allianceFlag = SoraDGetChildByName(Node_allianceInfo, "Node_allianceFlag")
		Node_allianceFlag:addChild(SoraDGetAllianceFlagByFid(selfInfo.allianceFlag or allianceInfo:getProperty("flag")))
		local Text_rank = SoraDGetChildByName(Node_allianceInfo, "Text_rank")
		if selfInfo.rank and 0 < selfInfo.rank then
			Text_rank:setString(selfInfo.rank)
		else
			Text_rank:setString(i18n("herobattle_text_05"))
		end
		local Text_alliance = SoraDGetChildByName(Node_allianceInfo, "Text_alliance")
		_ENV = i18n("herobattle_text_05")
		i18n("herobattle_text_05").abbr = selfInfo.allianceAbbr or allianceInfo:getProperty("abbr")
		i18n("herobattle_text_05").name = selfInfo.allianceName or allianceInfo:getProperty("name")
		Text_alliance:setString(i18n("common_text_186", i18n("herobattle_text_05")))
		local Text_myScore = SoraDGetChildByName(Node_allianceInfo, "Text_myScore")
		Text_myScore:setString(selfInfo.totalPoint or 0)
	end
	local Panel_allianceRank_single = SoraDGetChildByName(self.Top_Node_allianceRank, "Panel_allianceRank_single")
	local Text_noInfo = SoraDGetChildByName(self.Top_Node_allianceRank, "Text_noInfo")
	Text_noInfo:setString(i18n("herobattle_text_05"))
	Text_noInfo:setVisible(false)
	local getSingle = function(data)
		local single = Panel_allianceRank_single:clone()
		local rank_bg = SoraDGetChildByName(single, "rank_bg")
		local Text_score = SoraDGetChildByName(single, "Text_score")
		local Text_allianceName = SoraDGetChildByName(single, "Text_allianceName")
		local Image_rank = SoraDGetChildByName(single, "Image_rank")
		local Text_rank = SoraDGetChildByName(single, "Text_rank")
		local Node_flag = SoraDGetChildByName(single, "Node_flag")
		Text_score:setString(string.formatnumberthousands(data.totalPoint))
		Panel_allianceRank_single = string.formatnumberthousands(data.totalPoint)
		string.formatnumberthousands(data.totalPoint).abbr = data.allianceAbbr
		string.formatnumberthousands(data.totalPoint).name = data.allianceName
		Text_allianceName:setString(i18n("common_text_186", string.formatnumberthousands(data.totalPoint)))
		Node_flag:addChild(SoraDGetAllianceFlagByFid(data.allianceFlag))
		single.aid = data.aid
		if data.rank > RANK_TOP_SPECIAL then
			Image_rank:setVisible(false)
			Text_rank:setVisible(true)
			Text_rank:setString(data.rank)
			rank_bg:setSpriteFrame("frame_alliance_pank_04.png")
			if data.rank == data.ownRank then
				rank_bg:setSpriteFrame("frame_alliance_pank_05.png")
			end
		else
			Image_rank:setVisible(true)
			Image_rank:loadTexture("icon_ranking_" .. data.rank .. ".png", ccui.TextureResType.plistType)
			Text_rank:setVisible(false)
			rank_bg:setSpriteFrame("frame_alliance_pank_0" .. data.rank .. ".png")
		end
		single:addTouchEventListener(function(target, event)
			if event == ccui.TouchEventType.ended then
				if not SoraDIsNodeVisibleOnScroll(target, Top_Size_ScrollView_allianceRank) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = gametop.playertop_:getModule("allianceQuery")
				local kid = gametop.playertop_:getKingdomID()
				allianceQuery:reqAllianceInfo(kid, single.aid)
			end
		end)
		return single
	end
	local topInfo = heroWarCtrl:getTopInfo()
	if topInfo and next(topInfo) then
		Text_noInfo:setVisible(false)
		local scrollH = math.max(Top_Size_ScrollView_allianceRank:getContentSize().height, 89 * #topInfo)
		Top_Size_ScrollView_allianceRank:setInnerContainerSize(cc.size(Top_Size_ScrollView_allianceRank:getContentSize().width, scrollH))
		for k, v in ipairs(topInfo) do
			local single = getSingle(v)
			single:setPosition(cc.p(-4, scrollH - k * 89))
			single:addTo(Top_Size_ScrollView_allianceRank)
		end
	else
		Text_noInfo:setVisible(true)
	end
end
function eventHeroWarView:showRankAwardlView()
	self.Top_Size_ScrollView_detail:setVisible(false)
	self.Top_Node_allianceRank:setVisible(false)
	self.Top_Node_rankAward:setVisible(true)
	local Top_Size_ScrollView_rankAward = SoraDGetChildByName(self.Top_Node_rankAward, "Top_Size_ScrollView_rankAward")
	Top_Size_ScrollView_rankAward:setPositionY(-40)
	Top_Size_ScrollView_rankAward:setContentSize(cc.size(640, display.height - 390))
	local Text_rankTip = SoraDGetChildByName(self.Top_Node_rankAward, "Text_rankTip")
	Text_rankTip:setString(i18n("herobattle_text_06"))
	local Text_rank = SoraDGetChildByName(self.Top_Node_rankAward, "Text_rank")
	local Node_rankInfo = SoraDGetChildByName(self.Top_Node_rankAward, "Node_rankInfo")
	function getSingle(id, num)
		local single = Node_rankInfo:clone()
		local BitmapFontLabel_num = SoraDGetChildByName(single, "BitmapFontLabel_num")
		local Text_name = SoraDGetChildByName(single, "Text_name")
		local item = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward")
		item:setScale(0.6)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:initData(id)
		BitmapFontLabel_num:setString("x" .. num)
		Text_name:setString(publicRead.getName(id))
		return single
	end
	function getTitle(rank)
		local titleRank = Text_rank:clone()
		local str = ""
		if rank[1] == rank[2] then
			str = "NO." .. rank[1]
		else
			str = "NO." .. rank[1] .. "~" .. "NO." .. rank[2]
		end
		titleRank:setString(str)
		local Image_titleLine = SoraDGetChildByName(titleRank, "Image_titleLine")
		Image_titleLine:setPosition(cc.p(titleRank:getContentSize().width / 2, -10))
		return titleRank
	end
	local newActivityRead = include("newActivityRead")
	local awardInfo = newActivityRead.getHeroBossAward()
	local height = 0
	for k, v in ipairs(awardInfo) do
		height = height + 80
		height = height + #v.attack_rewards * 80 / 2
	end
	height = height + 20 * (#awardInfo - 1)
	local scrollH = math.max(Top_Size_ScrollView_rankAward:getContentSize().height, height)
	Top_Size_ScrollView_rankAward:setInnerContainerSize(cc.size(Top_Size_ScrollView_rankAward:getContentSize().width, scrollH))
	local tempHeight = scrollH
	for k, v in ipairs(awardInfo) do
		local titleRank = getTitle(v.rank)
		titleRank:setPosition(cc.p(320, tempHeight - 40))
		titleRank:addTo(Top_Size_ScrollView_rankAward)
		tempHeight = tempHeight - 80
		for i = 1, #v.attack_rewards - 1, 2 do
			local single = getSingle(v.attack_rewards[i], v.attack_rewards[i + 1])
			single:setPosition(cc.p(320, tempHeight))
			single:addTo(Top_Size_ScrollView_rankAward)
			tempHeight = tempHeight - 80
		end
		tempHeight = tempHeight - 20
	end
end
function eventHeroWarView:findBossBack(target, data)
	SoraDCloseLoading(self)
	if not data.err or data.err and data.err == gErrDef.Err_None then
		if data.retdate.x == -1 or data.retdate.y == -1 then
			SoraDShowMsgTip(i18n("common_text_2870"))
			return
		end
		SoraDGotoWorldMapPoint(cc.p(data.retdate.x, data.retdate.y), true)
		SoraDRemoveAllPanelFromManager()
	else
		SoraDShowMsgTip(i18n("herobattle_text_18"))
	end
end
function eventHeroWarView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if alliance then
		local kid = alliance:getProperty("sourceKid")
		SoraDOpenAllianceInfoView(alliance, kid)
	end
end
function eventHeroWarView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_BATTLE_BOSS) then
		self:removeFromParent()
	end
end
return eventHeroWarView
