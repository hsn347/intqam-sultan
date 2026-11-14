local gametop = gModuleMgr.getObject("gametop")
local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local endlessTrialsRank = class("endlessTrialsRank", function(target)
	if target == nil then
		return SoraDCreateBasePanel("endlessTrialsRank")
	end
	return target
end)
function endlessTrialsRank:ctor()
	self.uid = gametop.playertop_:getPlayerID()
	self:initWidget()
end
function endlessTrialsRank:resetData(...)
	self.rankInfo, _UPVALUE0_, self.selfInfo, _UPVALUE0_ = nil, nil, nil, nil
	self.idx = 1
	self.count = 100
end
function endlessTrialsRank:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ENDLESSTRIALSRANK_REFRESH", function(target, event)
		SoraDCloseLoading(self)
		if self.rType == 1 then
			self:refreshData(event.personalRankInfo)
		else
			self:refreshData(event.allianceRankInfo)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function endlessTrialsRank:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function endlessTrialsRank:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	local kid = alliance:getProperty("sourceKid")
	SoraDOpenAllianceInfoView(alliance, kid)
end
function endlessTrialsRank:initWidget(...)
	local root = self._ccsView
	_UPVALUE1_ = nil
	;(nil)[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(root, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Top_Node, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.Top_Node, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "btn_moreReward"
	self.btn_moreReward = SoraDGetChildByFullPath(self.Top_Node, nil)
	self.btn_moreReward:addTouchEventListener(handler(self, self.btnMoreRewardCallBack))
	self.btn_moreReward:setTitleText(i18n("Endless_trial_text_13"))
	SoraDAutoSizeButtonText(self.btn_moreReward)
	if SoraDFIsRA() then
		self.btn_moreReward:setPositionX(display.width - self.btn_moreReward:getPositionX())
		_UPVALUE1_ = display.width - self.btn_moreReward:getPositionX()
		;(display.width - self.btn_moreReward:getPositionX())[1] = "Image_title"
		self.Image_title = SoraDGetChildByFullPath(self.Top_Node, display.width - self.btn_moreReward:getPositionX())
		_UPVALUE1_ = display.width - self.btn_moreReward:getPositionX()
		;(display.width - self.btn_moreReward:getPositionX())[1] = "Image_title_en"
		SoraDGetChildByFullPath(self.Top_Node, display.width - self.btn_moreReward:getPositionX()):setVisible(false)
	else
		_UPVALUE1_ = false
		;(false)[1] = "Image_title_en"
		self.Image_title = SoraDGetChildByFullPath(self.Top_Node, false)
		_UPVALUE1_ = false
		;(false)[1] = "Image_title"
		SoraDGetChildByFullPath(self.Top_Node, false):setVisible(false)
	end
	_UPVALUE1_ = false
	;(false)[1] = "Text_rankTip"
	SoraDGetChildByFullPath(self.Image_title, false):setString(i18n("common_text_2193"))
	_UPVALUE1_ = i18n("common_text_2193")
	i18n("common_text_2193")[1] = "Text_nameTip"
	SoraDGetChildByFullPath(self.Image_title, i18n("common_text_2193")):setString(i18n("common_text_264"))
	_UPVALUE1_ = i18n("common_text_264")
	i18n("common_text_264")[1] = "Text_desTip"
	self.Text_desTip = SoraDGetChildByFullPath(self.Image_title, i18n("common_text_264"))
	_UPVALUE1_ = i18n("common_text_264")
	i18n("common_text_264")[1] = "Top_Size_ScrollView_rankings"
	self.scroll = SoraDGetChildByFullPath(root, i18n("common_text_264"))
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setScrollBottomFun(handler(self, self.scrollEventCallBack))
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	_UPVALUE1_ = handler(self, self.createSingle)
	handler(self, self.createSingle)[1] = "Center_noRecord"
	self.Center_noRecord = SoraDGetChildByFullPath(root, handler(self, self.createSingle))
	self.Center_noRecord:setString(i18n("herobattle_text_05"))
	_UPVALUE1_ = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, i18n("herobattle_text_05"))
	_UPVALUE1_ = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Node_single"
	self.Node_single = SoraDGetChildByFullPath(root, i18n("herobattle_text_05"))
	_UPVALUE1_ = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Node_personal"
	self.Node_personal = SoraDGetChildByFullPath(root, i18n("herobattle_text_05"))
	_UPVALUE1_ = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Node_personal_en"
	self.Node_personal_en = SoraDGetChildByFullPath(root, i18n("herobattle_text_05"))
	_UPVALUE1_ = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Node_alliance"
	self.Node_alliance = SoraDGetChildByFullPath(root, i18n("herobattle_text_05"))
	_UPVALUE1_ = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Node_alliance_en"
	self.Node_alliance_en = SoraDGetChildByFullPath(root, i18n("herobattle_text_05"))
	self.Button_jump = SoraDGetChildByName(self.Bottom_Node, "Button_jump")
	self.Button_jump:addTouchEventListener(function(target, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local index = self.selfInfo.rank
			if index ~= 0 then
				self.scroll:jumpIndexToTop(index)
			end
		end
	end)
	self.Button_join = SoraDGetChildByName(self.Bottom_Node, "Button_join")
	self.Button_join:setVisible(false)
	self.Button_join:setTitleText(i18n("common_text_167"))
	self.Button_join:addTouchEventListener(function(target, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			SoraDRemoveAllPanelFromManager()
			uiManager:show("AllianceJoinView")
		end
	end)
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf05")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.Bottom_Node, 1)
	effect:setPosition(320, 568.0)
end
function endlessTrialsRank:initData(bType)
	_ENV = nil
	;(nil)[2] = 1
	local (nil)[3], bType2rType = 2, nil
	self.rType = bType2rType[bType]
	self:resetData()
	self:req4Data(self.idx)
	if self.bType and self.bType == bType then
		return
	end
	self.bType = bType
	if bType == 2 then
		self.Text_des:setString(i18n("god_beast_text_08"))
		self.Text_desTip:setString(i18n("common_text_2195"))
		self.Node_info = SoraDFIsRA() and self.Node_personal or self.Node_personal_en
	elseif bType == 3 then
		self.Text_des:setString(i18n("Endless_trial_text_14"))
		self.Text_desTip:setString(i18n("common_text_032"))
		self.Node_info = SoraDFIsRA() and self.Node_alliance or self.Node_alliance_en
	else
		return
	end
	local config = endlessTrialsCtrl:getRewardsConfig(self.rType)
	_UPVALUE2_ = i18n("common_text_032")
	i18n("common_text_032")[1] = "id"
	i18n("common_text_032")[2] = "count"
	local rewards = serviceFunctions.tableFormat(config[1].rewards, i18n("common_text_032"))
	local itemW = 100
	for i, v in ipairs(rewards) do
		local single = SoraDCreatePanel("commonItemAward")
		single:addTo(self.Node_rewards)
		single:setScale(0.85)
		single:setOwnView(display.getRunningScene())
		single:initData(v.id, v.count)
		local posx = itemW * (i - 0.5 - #rewards / 2)
		single:setPosition(SoraDFSign(-posx), 0)
	end
end
function endlessTrialsRank:refreshData(rankData)
	if not rankData then
		return
	end
	self.selfInfo = rankData.selfInfo
	self:refreshSelfInfo()
	for i, v in ipairs(rankData.rankInfo) do
		table.insert(self.rankInfo, v)
	end
	self.scroll:updateScrollView(cc.size(640, 115), self.rankInfo)
	self.scroll:jumpIndexToTop(1)
	if next(self.rankInfo) then
		self.Center_noRecord:setVisible(false)
	else
		self.Center_noRecord:setVisible(true)
	end
	self.idx = rankData.idx
	self.nTotal = rankData.nTotal
end
function endlessTrialsRank:refreshSelfInfo(...)
	if self.rType == 1 then
		local item = self.selfItem
		if not item then
			item = self:createSingle(self.Bottom_Node)
			item.Node_info:setPositionY(50)
			self.selfItem = item
		end
		local lordInfo = lordInfoCtrl:getLordInfo()
		lordInfoCtrl = lordInfoCtrl
		lordInfoCtrl.abbr = lordInfo.abbr
		lordInfoCtrl.avatar = lordInfo.base.avatar
		lordInfoCtrl.iconID = lordInfo.base.imageId
		lordInfoCtrl.nickName = lordInfo.base.nickName
		lordInfoCtrl.rank = self.selfInfo.rank
		lordInfoCtrl.score = self.selfInfo.score
		local lordInfoCtrl.uid, data = self.uid, lordInfoCtrl
		lordInfoCtrl = nil
		;(nil).isSelf = true
		item:initData(data, nil)
	else
		local alliance = allianceMgr:getAlliance()
		if alliance ~= nil then
			local item = self.selfItem
			if not item then
				item = self:createSingle(self.Bottom_Node)
				item.Node_info:setPositionY(50)
				self.selfItem = item
			end
			lordInfoCtrl = item.Node_info.setPositionY
			item.Node_info.setPositionY.rank = self.selfInfo.rank
			item.Node_info.setPositionY.score = self.selfInfo.score
			item.Node_info.setPositionY.flag = allianceMgr:getAllianceProperty("flag")
			item.Node_info.setPositionY.abbr = alliance:getProperty("abbr")
			item.Node_info.setPositionY.name = alliance:getProperty("name")
			item.Node_info.setPositionY.leadername = alliance:getProperty("leaderName")
			local item.Node_info.setPositionY.aid, data = allianceMgr:getOwnTeamID(), item.Node_info.setPositionY
			lordInfoCtrl = nil
			;(nil).isSelf = true
			item:initData(data, nil)
		else
			self.Button_join:setVisible(true)
		end
	end
end
function endlessTrialsRank:btnMoreRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("endlessTrialsRankAward")
		panel:initData(self.rType)
		panel:show()
	end
end
_ENV, endlessTrialsRank.createSingle = function(self, widget)
	local item = widget or self.Node_single:clone()
	SoraDGetAllChildFromWidget(item, item)
	local Node_info = self.Node_info:clone()
	SoraDGetAllChildFromWidget(Node_info, item)
	Node_info:addTo(item)
	Node_info:setPosition(320, 56)
	item.Node_info = Node_info
	if self.rType == 1 then
		item.commonHead_head = SoraDGetExtendChildFromCCSByName(Node_info, "CCS_commonHead_head")
		item.commonHead_head:setScale(1.0)
		item.commonHead_head:setScroll(self.scroll)
	else
		item.Button_flag:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = SoraDGetCtrl("allianceQuery")
				_ENV = nil
				_ENV, (nil).aid = item.data.aid, item.data.aid
				item.data.aid.from = "endlessTrialsRank"
				allianceQuery:reqAllianceByID(nil, item.data.aid)
				SoraDShowLoading(self)
			end
		end)
	end
	function item.initData(target, data, otherData)
		self:initItemData(target, data, otherData)
	end
	return item
end, function(self, widget)
	local item = widget or self.Node_single:clone()
	SoraDGetAllChildFromWidget(item, item)
	local Node_info = self.Node_info:clone()
	SoraDGetAllChildFromWidget(Node_info, item)
	Node_info:addTo(item)
	Node_info:setPosition(320, 56)
	item.Node_info = Node_info
	if self.rType == 1 then
		item.commonHead_head = SoraDGetExtendChildFromCCSByName(Node_info, "CCS_commonHead_head")
		item.commonHead_head:setScale(1.0)
		item.commonHead_head:setScroll(self.scroll)
	else
		item.Button_flag:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = SoraDGetCtrl("allianceQuery")
				_ENV = nil
				_ENV, (nil).aid = item.data.aid, item.data.aid
				item.data.aid.from = "endlessTrialsRank"
				allianceQuery:reqAllianceByID(nil, item.data.aid)
				SoraDShowLoading(self)
			end
		end)
	end
	function item.initData(target, data, otherData)
		self:initItemData(target, data, otherData)
	end
	return item
end
;(function(self, widget)
	local item = widget or self.Node_single:clone()
	SoraDGetAllChildFromWidget(item, item)
	local Node_info = self.Node_info:clone()
	SoraDGetAllChildFromWidget(Node_info, item)
	Node_info:addTo(item)
	Node_info:setPosition(320, 56)
	item.Node_info = Node_info
	if self.rType == 1 then
		item.commonHead_head = SoraDGetExtendChildFromCCSByName(Node_info, "CCS_commonHead_head")
		item.commonHead_head:setScale(1.0)
		item.commonHead_head:setScroll(self.scroll)
	else
		item.Button_flag:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = SoraDGetCtrl("allianceQuery")
				_ENV = nil
				_ENV, (nil).aid = item.data.aid, item.data.aid
				item.data.aid.from = "endlessTrialsRank"
				allianceQuery:reqAllianceByID(nil, item.data.aid)
				SoraDShowLoading(self)
			end
		end)
	end
	function item.initData(target, data, otherData)
		self:initItemData(target, data, otherData)
	end
	return item
end)[1] = "frame_jwdzz_dym.png"
;(function(self, widget)
	local item = widget or self.Node_single:clone()
	SoraDGetAllChildFromWidget(item, item)
	local Node_info = self.Node_info:clone()
	SoraDGetAllChildFromWidget(Node_info, item)
	Node_info:addTo(item)
	Node_info:setPosition(320, 56)
	item.Node_info = Node_info
	if self.rType == 1 then
		item.commonHead_head = SoraDGetExtendChildFromCCSByName(Node_info, "CCS_commonHead_head")
		item.commonHead_head:setScale(1.0)
		item.commonHead_head:setScroll(self.scroll)
	else
		item.Button_flag:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = SoraDGetCtrl("allianceQuery")
				_ENV = nil
				_ENV, (nil).aid = item.data.aid, item.data.aid
				item.data.aid.from = "endlessTrialsRank"
				allianceQuery:reqAllianceByID(nil, item.data.aid)
				SoraDShowLoading(self)
			end
		end)
	end
	function item.initData(target, data, otherData)
		self:initItemData(target, data, otherData)
	end
	return item
end)[2] = "frame_jwdzz_dem.png"
local (function(self, widget)
	local item = widget or self.Node_single:clone()
	SoraDGetAllChildFromWidget(item, item)
	local Node_info = self.Node_info:clone()
	SoraDGetAllChildFromWidget(Node_info, item)
	Node_info:addTo(item)
	Node_info:setPosition(320, 56)
	item.Node_info = Node_info
	if self.rType == 1 then
		item.commonHead_head = SoraDGetExtendChildFromCCSByName(Node_info, "CCS_commonHead_head")
		item.commonHead_head:setScale(1.0)
		item.commonHead_head:setScroll(self.scroll)
	else
		item.Button_flag:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = SoraDGetCtrl("allianceQuery")
				_ENV = nil
				_ENV, (nil).aid = item.data.aid, item.data.aid
				item.data.aid.from = "endlessTrialsRank"
				allianceQuery:reqAllianceByID(nil, item.data.aid)
				SoraDShowLoading(self)
			end
		end)
	end
	function item.initData(target, data, otherData)
		self:initItemData(target, data, otherData)
	end
	return item
end)[3], randFrameIcon = "frame_jwdzz_dsm.png", function(self, widget)
	local item = widget or self.Node_single:clone()
	SoraDGetAllChildFromWidget(item, item)
	local Node_info = self.Node_info:clone()
	SoraDGetAllChildFromWidget(Node_info, item)
	Node_info:addTo(item)
	Node_info:setPosition(320, 56)
	item.Node_info = Node_info
	if self.rType == 1 then
		item.commonHead_head = SoraDGetExtendChildFromCCSByName(Node_info, "CCS_commonHead_head")
		item.commonHead_head:setScale(1.0)
		item.commonHead_head:setScroll(self.scroll)
	else
		item.Button_flag:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					return
				end
				SoraDPlaySound()
				local allianceQuery = SoraDGetCtrl("allianceQuery")
				_ENV = nil
				_ENV, (nil).aid = item.data.aid, item.data.aid
				item.data.aid.from = "endlessTrialsRank"
				allianceQuery:reqAllianceByID(nil, item.data.aid)
				SoraDShowLoading(self)
			end
		end)
	end
	function item.initData(target, data, otherData)
		self:initItemData(target, data, otherData)
	end
	return item
end
function endlessTrialsRank:initItemData(item, data, otherData)
	item.data = data
	item.isSelf = otherData.isSelf
	if not item.isSelf then
		item.Image_rank:setVisible(false)
		item.Node_effect:setVisible(false)
	end
	item.Sprite_index:setVisible(false)
	if data.rank > 0 and data.rank <= 3 then
		item.Text_index:setString("")
		item.Sprite_index:setVisible(true)
		item.Sprite_index:setSpriteFrame(string.format("icon_ranking_%d.png", data.rank))
		if not item.isSelf then
			item.Image_rank:setVisible(true)
			item.Image_rank:loadTexture(randFrameIcon[data.rank], ccui.TextureResType.plistType)
		end
		item.Text_name:setColor(cc.c3b(218, 243, 255))
		item.Text_force:setColor(cc.c3b(255, 255, 255))
		if not item.isSelf and data.rank <= 2 then
			item.Node_effect:setVisible(true)
			if not item.Node_effect:getChildByName("css_effect") then
				local effect = SoraDCreatAnimation("Node_Effect_wjtzjf06")
				SoraDMixtureGLONEByParent(effect)
				effect:addTo(item.Node_effect)
				effect:setName("css_effect")
				item.Node_rank_1 = SoraDGetChildByName(effect, "Node_rank_1")
				item.Node_rank_2 = SoraDGetChildByName(effect, "Node_rank_2")
			end
			item.Node_rank_1:setVisible(data.rank == 1)
			item.Node_rank_2:setVisible(data.rank == 2)
		end
	elseif data.rank > 3 then
		item.Text_index:setString(tostring(data.rank))
		item.Text_name:setColor(cc.c3b(200, 170, 150))
		item.Text_force:setColor(cc.c3b(230, 180, 110))
	else
		item.Text_index:setString(i18n("common_text_827"))
		SoraDSetTextWidthHeight(item.Text_index, cc.size(100, 50))
	end
	item.Text_force:setString(string.formatnumberthousands(data.score))
	if self.rType == 1 then
		item.commonHead_head:setHeadSprite(data.iconID, data.avatar)
		item.commonHead_head:setPlayerID(data.uid)
		if data.abbr and data.abbr ~= "" then
			_ENV = string.formatnumberthousands(data.score)
			string.formatnumberthousands(data.score).abbr = data.abbr
			string.formatnumberthousands(data.score).name = data.nickName
			if i18n("common_text_186", string.formatnumberthousands(data.score)) then
				goto lbl_209
			end
		end
		::lbl_209::
		item.Text_name:setString(data.nickName)
	else
		local nodeFlag = SoraDGetAllianceFlagByFid(data.flag)
		nodeFlag:addTo(item.Node_flag)
		nodeFlag:setScale(0.4)
		_ENV = data.nickName
		data.nickName.abbr = data.abbr
		data.nickName.name = data.name
		item.Text_name:setString(i18n("common_text_186", data.nickName))
		_ENV = i18n("common_text_186", data.nickName)
		i18n("common_text_186", data.nickName).name = data.leadername
		item.Text_name2:setString(i18n("common_text_170", i18n("common_text_186", data.nickName)))
	end
	if not item.isSelf then
		if self.uid == data.uid then
			item.Image_barBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		else
			item.Image_barBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		end
	end
end
function endlessTrialsRank:scrollEventCallBack(target, event)
	if not self.idx or not self.nTotal then
		return
	end
	if self.idx < self.nTotal then
		self:req4Data(self.idx + 1)
	end
end
function endlessTrialsRank:req4Data(idx)
	if self.rType == 1 then
		endlessTrialsCtrl:reqPersonalRank(idx, self.count)
	else
		endlessTrialsCtrl:reqAllianceRank(idx, self.count)
	end
	SoraDShowLoading(self)
end
return endlessTrialsRank
