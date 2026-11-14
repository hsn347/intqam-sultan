local sinbadTreasureRead = include("sinbadTreasureRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local itemDesRead = include("itemDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local sinbadTreasureRankView = class("sinbadTreasureRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sinbadTreasureRankView")
	end
	return target
end)
local singleRankH = 120
function sinbadTreasureRankView:ctor()
	self:initControls()
	self:fitDevice()
	self:showRankEffect()
end
function sinbadTreasureRankView:showRankEffect()
	local effectOne = SoraDCreatAnimation("rank_one", nil, true)
	effectOne:setPosition(cc.p(-7, 3))
	self.Node_rank_1:addChild(effectOne)
	local effectTwo = SoraDCreatAnimation("rank_two", nil, true)
	effectTwo:setPosition(cc.p(0, 88))
	self.Node_rank_2:addChild(effectTwo)
	local effectThree = SoraDCreatAnimation("rank_three", nil, true)
	effectThree:setPosition(cc.p(-2, 90))
	self.Node_rank_3:addChild(effectThree)
end
function sinbadTreasureRankView:fitDevice()
	if math.floor(display.height) == 853 then
		self.Node_rank_1:setScale(0.8)
		self.Node_rank_2:setScale(0.8)
		self.Node_rank_3:setScale(0.8)
		self.Node_rank_1:setPositionY(self.Node_rank_1:getPositionY() + 50)
		self.Node_rank_2:setPositionY(self.Node_rank_1:getPositionY() + 20)
		self.Node_rank_3:setPositionY(self.Node_rank_1:getPositionY() + 20)
		self.Image_2:setPositionY(self.Image_2:getPositionY() + 70)
		self.bg_dytx_01_19:setPositionY(self.bg_dytx_01_19:getPositionY() + 60)
		self.bg_dytx_02_18:setPositionY(self.bg_dytx_02_18:getPositionY() + 60)
		self.Top_Size_ScrollView:setPositionY(self.Top_Size_ScrollView:getPositionY() + 70)
		self.Top_Size_ScrollView:setContentSize(cc.size(640, self.Top_Size_ScrollView:getContentSize().height + 70))
	end
end
function sinbadTreasureRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_KINGDOM_RANK_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		SoraDCreatAnimation(self.__cname, self, false)
		local topRankInfo, remainRankInfo = sinbadTreasureCtrl:getPersonalRankInfo()
		self:initPersonalScroll(topRankInfo, remainRankInfo)
		self:initMyPersonalData()
	end)
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_GLOBAL_RANK_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		SoraDCreatAnimation(self.__cname, self, false)
		local topRankInfo, remainRankInfo = sinbadTreasureCtrl:getAllianceRankInfo()
		self:initAllianceScroll(topRankInfo, remainRankInfo)
		self:initMyAllianceData()
	end)
end
function sinbadTreasureRankView:initControls()
	self.rankType = 1
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	self.Text_reward_ins:setVisible(false)
	self.frame_hphy_szd_15:setVisible(false)
	_ENV = false
	;(false).tabNum = 2
	_ENV, _ENV, (false).defaultClick = nil, self.rankType, self.rankType
	;(nil).title = i18n("Sinbad_text_13")
	;(nil).tag = 1
	_ENV, self.rankType[1], (nil).handle = nil, nil, handler(self, self.onPersonClick)
	;(nil).title = i18n("Sinbad_text_12")
	;(nil).tag = 2
	;(false).tabsetArray, self.rankType[2], (nil).handle = self.rankType, nil, handler(self, self.onAllianceClick)
	self.ccs_tab:initView(false)
	self.text_noData:setString(i18n("herobattle_text_05"))
	self.ccs_title:setTitle(i18n("pyramid_btn_29"))
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
	self.Button_rewards:addTouchEventListener(handler(self, self.buttonRewardCallBack))
	self.Button_alliance:addTouchEventListener(handler(self, self.buttonAllianceCallBack))
	self.btn_help_tip:addTouchEventListener(handler(self, self.btnTipClick))
	self.Text_rank:setString(i18n("common_text_2193"))
	self.Text_rank_name:setString(i18n("common_text_264"))
	self.Text_des:setString(i18n("Sinbad_text_21"))
	self.Text_reward_ins:setString(i18n("warmHeart_text_05"))
	SoraDSetTextWidthHeight(self.Text_reward_ins, cc.size(400, 60))
	self.Text_reward_ins:setPositionY(self.Text_reward_ins:getPositionY() + 10)
	self.Button_alliance:setTitleText(i18n("common_text_167"))
	self.Button_rewards:setTitleText(i18n("common_text_1235"))
end
function sinbadTreasureRankView:initData()
end
function sinbadTreasureRankView:initAllianceScroll(topList, remainList)
	self.text_noData:setVisible(false)
	self.Image_head_1:setContentSize(cc.size(68, 86))
	self.Image_head_2:setContentSize(cc.size(68, 86))
	self.Image_head_3:setContentSize(cc.size(68, 86))
	self.Node_flag_1:setVisible(false)
	self.Node_flag_2:setVisible(false)
	self.Node_flag_3:setVisible(false)
	self.Image_head_1:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Image_head_2:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Image_head_3:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Node_flag_1:setScale(0.7)
	self.Node_flag_2:setScale(0.5)
	self.Node_flag_3:setScale(0.5)
	self.Text_score_1:setString(i18n("herobattle_text_05"))
	self.Text_score_2:setString(i18n("herobattle_text_05"))
	self.Text_score_3:setString(i18n("herobattle_text_05"))
	self.Text_name_1:setString("")
	self.Text_name_2:setString("")
	self.Text_name_3:setString("")
	if topList[1] then
		self.Image_head_1:setContentSize(cc.size(120, 120))
		SoraDGetHeadFromManager(self.Image_head_1, topList[1].headid, topList[1].avatar)
		local firstName = topList[1].name
		if topList[1].allianceAbb then
			_ENV = topList[1].avatar
			topList[1].avatar.abbr = _q(topList[1].allianceAbb)
			topList[1].avatar.name = topList[1].name
			firstName = i18n("common_text_186", topList[1].avatar)
		end
		self.Text_name_1:setString(firstName)
		_ENV = topList[1].allianceAbb
		topList[1].allianceAbb.var = string.formatnumberthousands(topList[1].score)
		self.Text_score_1:setString(i18n("Sinbad_text_26", topList[1].allianceAbb))
		self.Image_head_1:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[1].uid
				;(nil).kid = topList[1].kid
				SoraDSendMessage(nil)
			end
		end)
	end
	if topList[2] then
		self.Image_head_2:setContentSize(cc.size(95, 95))
		SoraDGetHeadFromManager(self.Image_head_2, topList[2].headid, topList[2].avatar)
		local secondName = topList[2].name
		if topList[2].allianceAbb then
			_ENV = topList[2].avatar
			topList[2].avatar.abbr = _q(topList[2].allianceAbb)
			topList[2].avatar.name = topList[2].name
			secondName = i18n("common_text_186", topList[2].avatar)
		end
		self.Text_name_2:setString(secondName)
		_ENV = topList[2].allianceAbb
		topList[2].allianceAbb.var = string.formatnumberthousands(topList[2].score)
		self.Text_score_2:setString(i18n("Sinbad_text_26", topList[2].allianceAbb))
		self.Image_head_2:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[2].uid
				;(nil).kid = topList[2].kid
				SoraDSendMessage(nil)
			end
		end)
	end
	if topList[3] then
		self.Image_head_3:setContentSize(cc.size(95, 95))
		SoraDGetHeadFromManager(self.Image_head_3, topList[3].headid, topList[3].avatar)
		local thirdName = topList[3].name
		if topList[3].allianceAbb then
			_ENV = topList[3].avatar
			topList[3].avatar.abbr = _q(topList[3].allianceAbb)
			topList[3].avatar.name = topList[3].name
			thirdName = i18n("common_text_186", topList[3].avatar)
		end
		self.Text_name_3:setString(thirdName)
		_ENV = topList[3].allianceAbb
		topList[3].allianceAbb.var = string.formatnumberthousands(topList[3].score)
		self.Text_score_3:setString(i18n("Sinbad_text_26", topList[3].allianceAbb))
		self.Image_head_3:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[3].uid
				;(nil).kid = topList[3].kid
				SoraDSendMessage(nil)
			end
		end)
	end
	if not next(remainList) then
		self.text_noData:setVisible(true)
	end
	self.Top_Size_ScrollView:removeAllChildren()
	local scrollH = math.max(self.Top_Size_ScrollView:getContentSize().height, singleRankH * #remainList)
	self.Top_Size_ScrollView:setInnerContainerSize(cc.size(640, scrollH))
	for i, v in ipairs(remainList) do
		local cellRank = self.Node_rank_single:clone()
		local Panel_touch = SoraDGetChildByName(cellRank, "Panel_touch")
		local Image_head = SoraDGetChildByName(cellRank, "Image_head")
		local Node_flag = SoraDGetChildByName(cellRank, "Node_flag")
		Node_flag:setCascadeOpacityEnabled(true)
		Image_head:setCascadeOpacityEnabled(true)
		Panel_touch:setCascadeOpacityEnabled(true)
		cellRank:setCascadeOpacityEnabled(true)
		cellRank:addTo(self.Top_Size_ScrollView)
		cellRank:setOpacity(0)
		cellRank:setPosition(cc.p(320, scrollH - (i - 1) * singleRankH + 5 - 12))
		self:runCellAction(cellRank, i)
		local txtScore = SoraDGetChildByName(cellRank, "Text_num")
		txtScore:setString(string.formatnumberthousands(v.score))
		local imgHead = SoraDGetChildByName(cellRank, "Image_head")
		imgHead:setVisible(false)
		imgHead:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				if not SoraDIsNodeVisibleOnScroll(ref, self.Top_Size_ScrollView) then
					print("node is not on view")
					return
				end
				_ENV = "node is not on view"
				;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;("node is not on view").playerID = v.uid
				;("node is not on view").kid = v.kid
				SoraDSendMessage("node is not on view")
			end
		end)
		SoraDGetHeadFromManager(imgHead, v.headid, v.avatar)
		local txtRanking = SoraDGetChildByName(cellRank, "Text_index")
		local txtComName = SoraDGetChildByName(cellRank, "Text_name")
		local name = v.name
		if v.allianceAbb then
			_ENV = string.formatnumberthousands(v.score)
			string.formatnumberthousands(v.score).abbr = _q(v.allianceAbb)
			string.formatnumberthousands(v.score).name = v.name
			name = i18n("common_text_186", string.formatnumberthousands(v.score))
		end
		txtComName:setString(name)
		local spIndex = SoraDGetChildByName(cellRank, "Sprite_index")
		local imgBarBg = SoraDGetChildByName(cellRank, "Image_barBg")
		local uid = lordInfoCtrl:getLordInfo().base.uid
		if v.rank <= RANK_TOP_SPECIAL then
			txtRanking:setVisible(false)
			spIndex:setSpriteFrame("icon_ranking_" .. i .. ".png")
			imgBarBg:loadTexture("frame_alliance_pank_0" .. i .. ".png", ccui.TextureResType.plistType)
		else
			spIndex:setVisible(false)
			txtRanking:setString(v.rank)
			imgBarBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		end
		if tonumber(v.uid) == uid then
			imgBarBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		end
	end
end
function sinbadTreasureRankView:runCellAction(cell, index)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay((21 + (index - 1) * 4) / 60)
	;(nil)[2] = cca.callFunc(function(...)
		if tolua.isnull(cell) then
			return
		end
		cell = nil
		;(nil)[1] = cca.fadeIn(0.1)
		;(nil)[2] = cca.moveBy(0.1, 0, 12)
		;(nil)[3] = cca.moveBy(0.1, 0, 12)
		;(nil)[4] = cca.moveBy(0.1, 0, 12)
		;(nil)[5] = cca.moveBy(0.1, 0, 12)
		cell:runAction(cca.spawn(nil))
	end)
	;(nil)[3] = cca.callFunc(function(...)
		if tolua.isnull(cell) then
			return
		end
		cell = nil
		;(nil)[1] = cca.fadeIn(0.1)
		;(nil)[2] = cca.moveBy(0.1, 0, 12)
		;(nil)[3] = cca.moveBy(0.1, 0, 12)
		;(nil)[4] = cca.moveBy(0.1, 0, 12)
		;(nil)[5] = cca.moveBy(0.1, 0, 12)
		cell:runAction(cca.spawn(nil))
	end)
	self.Top_Size_ScrollView:runAction(cca.seq(nil))
end
function sinbadTreasureRankView:initPersonalScroll(topList, remainList)
	self.text_noData:setVisible(false)
	self.Image_head_1:setContentSize(cc.size(68, 86))
	self.Image_head_2:setContentSize(cc.size(68, 86))
	self.Image_head_3:setContentSize(cc.size(68, 86))
	self.Node_flag_1:setVisible(false)
	self.Node_flag_2:setVisible(false)
	self.Node_flag_3:setVisible(false)
	self.Image_head_1:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Image_head_2:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Image_head_3:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Text_score_1:setString(i18n("herobattle_text_05"))
	self.Text_score_2:setString(i18n("herobattle_text_05"))
	self.Text_score_3:setString(i18n("herobattle_text_05"))
	self.Text_name_1:setString("")
	self.Text_name_2:setString("")
	self.Text_name_3:setString("")
	if topList[1] then
		self.Image_head_1:setContentSize(cc.size(120, 120))
		SoraDGetHeadFromManager(self.Image_head_1, topList[1].headid, topList[1].avatar)
		local firstName = topList[1].name
		if topList[1].allianceAbb then
			_ENV = topList[1].avatar
			topList[1].avatar.abbr = _q(topList[1].allianceAbb)
			topList[1].avatar.name = topList[1].name
			firstName = i18n("common_text_186", topList[1].avatar)
		end
		self.Text_name_1:setString(firstName)
		_ENV = topList[1].allianceAbb
		topList[1].allianceAbb.var = string.formatnumberthousands(topList[1].score)
		self.Text_score_1:setString(i18n("Sinbad_text_26", topList[1].allianceAbb))
		self.Image_head_1:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[1].uid
				;(nil).kid = topList[1].kid
				SoraDSendMessage(nil)
			end
		end)
	end
	if topList[2] then
		self.Image_head_2:setContentSize(cc.size(95, 95))
		SoraDGetHeadFromManager(self.Image_head_2, topList[2].headid, topList[2].avatar)
		local secondName = topList[2].name
		if topList[2].allianceAbb then
			_ENV = topList[2].avatar
			topList[2].avatar.abbr = _q(topList[2].allianceAbb)
			topList[2].avatar.name = topList[2].name
			secondName = i18n("common_text_186", topList[2].avatar)
		end
		self.Text_name_2:setString(secondName)
		_ENV = topList[2].allianceAbb
		topList[2].allianceAbb.var = string.formatnumberthousands(topList[2].score)
		self.Text_score_2:setString(i18n("Sinbad_text_26", topList[2].allianceAbb))
		self.Image_head_2:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[2].uid
				;(nil).kid = topList[2].kid
				SoraDSendMessage(nil)
			end
		end)
	end
	if topList[3] then
		self.Image_head_3:setContentSize(cc.size(95, 95))
		SoraDGetHeadFromManager(self.Image_head_3, topList[3].headid, topList[3].avatar)
		local thirdName = topList[3].name
		if topList[3].allianceAbb then
			_ENV = topList[3].avatar
			topList[3].avatar.abbr = _q(topList[3].allianceAbb)
			topList[3].avatar.name = topList[3].name
			thirdName = i18n("common_text_186", topList[3].avatar)
		end
		self.Text_name_3:setString(thirdName)
		_ENV = topList[3].allianceAbb
		topList[3].allianceAbb.var = string.formatnumberthousands(topList[3].score)
		self.Text_score_3:setString(i18n("Sinbad_text_26", topList[3].allianceAbb))
		self.Image_head_3:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[3].uid
				;(nil).kid = topList[3].kid
				SoraDSendMessage(nil)
			end
		end)
	end
	if not next(remainList) then
		self.text_noData:setVisible(true)
	end
	self.Top_Size_ScrollView:removeAllChildren()
	local scrollH = math.max(self.Top_Size_ScrollView:getContentSize().height, singleRankH * #remainList)
	self.Top_Size_ScrollView:setInnerContainerSize(cc.size(640, scrollH))
	for i, v in ipairs(remainList) do
		local cellRank = self.Node_rank_single:clone()
		local Panel_touch = SoraDGetChildByName(cellRank, "Panel_touch")
		local Image_head = SoraDGetChildByName(cellRank, "Image_head")
		local Node_flag = SoraDGetChildByName(cellRank, "Node_flag")
		Image_head:setCascadeOpacityEnabled(true)
		Panel_touch:setCascadeOpacityEnabled(true)
		cellRank:setCascadeOpacityEnabled(true)
		Node_flag:setCascadeOpacityEnabled(true)
		cellRank:addTo(self.Top_Size_ScrollView)
		cellRank:setOpacity(0)
		cellRank:setPosition(cc.p(320, scrollH - (i - 1) * singleRankH + 5 - 12))
		self:runCellAction(cellRank, i)
		local txtScore = SoraDGetChildByName(cellRank, "Text_num")
		txtScore:setString(string.formatnumberthousands(v.score))
		local imgHead = SoraDGetChildByName(cellRank, "Image_head")
		imgHead:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				if not SoraDIsNodeVisibleOnScroll(ref, self.Top_Size_ScrollView) then
					print("node is not on view")
					return
				end
				_ENV = "node is not on view"
				;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;("node is not on view").playerID = v.uid
				;("node is not on view").kid = v.kid
				SoraDSendMessage("node is not on view")
			end
		end)
		SoraDGetHeadFromManager(imgHead, v.headid, v.avatar)
		local txtRanking = SoraDGetChildByName(cellRank, "Text_index")
		local txtComName = SoraDGetChildByName(cellRank, "Text_name")
		local name = v.name
		if v.allianceAbb then
			_ENV = string.formatnumberthousands(v.score)
			string.formatnumberthousands(v.score).abbr = _q(v.allianceAbb)
			string.formatnumberthousands(v.score).name = v.name
			name = i18n("common_text_186", string.formatnumberthousands(v.score))
		end
		txtComName:setString(name .. " " .. "#" .. v.kid)
		local spIndex = SoraDGetChildByName(cellRank, "Sprite_index")
		local imgBarBg = SoraDGetChildByName(cellRank, "Image_barBg")
		local uid = lordInfoCtrl:getLordInfo().base.uid
		if v.rank <= RANK_TOP_SPECIAL then
			txtRanking:setVisible(false)
			spIndex:setSpriteFrame("icon_ranking_" .. i .. ".png")
			imgBarBg:loadTexture("frame_alliance_pank_0" .. i .. ".png", ccui.TextureResType.plistType)
		else
			spIndex:setVisible(false)
			txtRanking:setString(v.rank)
			imgBarBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		end
		if tonumber(v.uid) == uid then
			imgBarBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		end
	end
end
function sinbadTreasureRankView:onPersonClick(tag, name)
	self.rankType = tag
	self.Top_Size_ScrollView:stopAllActions()
	self.Top_Size_ScrollView:jumpToTop()
	sinbadTreasureCtrl:reqKingdomRank()
	SoraDShowLoading(self)
end
function sinbadTreasureRankView:onAllianceClick(tag, name)
	self.rankType = tag
	self.Top_Size_ScrollView:stopAllActions()
	self.Top_Size_ScrollView:jumpToTop()
	sinbadTreasureCtrl:reqGlobalRank()
	SoraDShowLoading(self)
end
function sinbadTreasureRankView:initMyAllianceData()
	local myAllianceData = sinbadTreasureCtrl:getMyAllianceRankInfo()
	if next(myAllianceData) then
		SoraDGetHeadFromManager(self.Image_main_head, myAllianceData.headid, myAllianceData.avatar)
		dump(myAllianceData, "myAllianceData======", 10)
		if myAllianceData.rank == 0 then
			self.Sprite_myHead:setVisible(false)
			self.Text_myRank:setVisible(true)
			self.Text_myRank:setString(i18n("common_text_827"))
		elseif myAllianceData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_myHead:setSpriteFrame("icon_ranking_" .. myAllianceData.rank .. ".png")
			self.Sprite_myHead:setVisible(true)
			self.Text_myRank:setVisible(false)
		else
			self.Sprite_myHead:setVisible(false)
			self.Text_myRank:setVisible(true)
			self.Text_myRank:setString(myAllianceData.rank)
		end
		local name = myAllianceData.name
		if myAllianceData.allianceAbb then
			sinbadTreasureCtrl = myAllianceData.rank
			myAllianceData.rank.abbr = _q(myAllianceData.allianceAbb)
			myAllianceData.rank.name = myAllianceData.name
			name = i18n("common_text_186", myAllianceData.rank)
		end
		self.Text_myName:setString(name)
		local myData = sinbadTreasureCtrl:getMyPersonalRankInfo()
		local score = myData.score
		if next(myData) and myAllianceData.rank == 0 then
			score = myData.score
		end
		sinbadTreasureCtrl = i18n("common_text_827")
		i18n("common_text_827").var = string.formatnumberthousands(score)
		self.Text_myLordName:setString(i18n("Sinbad_text_20", i18n("common_text_827")))
	end
end
function sinbadTreasureRankView:initMyPersonalData()
	local myData = sinbadTreasureCtrl:getMyPersonalRankInfo()
	if next(myData) then
		SoraDGetHeadFromManager(self.Image_main_head, myData.headid, myData.avatar)
		dump(myData, "myData======", 10)
		if myData.rank == 0 then
			self.Sprite_myHead:setVisible(false)
			self.Text_myRank:setVisible(true)
			self.Text_myRank:setString(i18n("common_text_827"))
		elseif myData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_myHead:setSpriteFrame("icon_ranking_" .. myData.rank .. ".png")
			self.Sprite_myHead:setVisible(true)
			self.Text_myRank:setVisible(false)
		else
			self.Sprite_myHead:setVisible(false)
			self.Text_myRank:setVisible(true)
			self.Text_myRank:setString(myData.rank)
		end
		local name = myData.name
		if myData.allianceAbb then
			sinbadTreasureCtrl = myData.rank
			myData.rank.abbr = _q(myData.allianceAbb)
			myData.rank.name = myData.name
			name = i18n("common_text_186", myData.rank)
		end
		self.Text_myName:setString(name)
		sinbadTreasureCtrl = myData.allianceAbb
		myData.allianceAbb.var = string.formatnumberthousands(myData.score)
		self.Text_myLordName:setString(i18n("Sinbad_text_20", myData.allianceAbb))
	end
end
function sinbadTreasureRankView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Sinbad_text_04"
		;("Sinbad_text_04").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Sinbad_text_04"), "Sinbad_text_04")
	end
end
function sinbadTreasureRankView:buttonAllianceCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPrePanelFromManager(self)
		uiManager:show("AllianceJoinView")
	end
end
function sinbadTreasureRankView:buttonRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).str = i18n("hero_title_02")
		;(nil).rankType = self.rankType
		uiManager:show("sinbadTreasureRankRewardView", nil)
	end
end
return sinbadTreasureRankView
