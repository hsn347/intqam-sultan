local djCtrl = SoraDGetCtrl("djCtrl")
local GridScrollView = include("GridScrollView")
local DjRankView = class("djRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("djRankView")
	end
	return target
end)
_ENV = "djRankView"
;("djRankView").ONE_KINGDOM_WEEK = 1
;("djRankView").ONE_KINGDOM_MONTH = 2
;("djRankView").ONE_KINGDOM_TOTAL = 3
;("djRankView").ALL_KINGDOM_WEEK = 4
;("djRankView").ALL_KINGDOM_MONTH = 5
DjRankView.gChatAnchorRankType, ("djRankView").ALL_KINGDOM_TOTAL = "djRankView", 6
function DjRankView:ctor()
	self.djuid = 0
	self.selfuid = include("chatFunctions"):getSelfId()
	self.rankNum = 0
	self.rankSelfData, _ENV, self.rankData, _ENV, self.rankType = djCtrl.isBroadcastDJ and DjRankView.gChatAnchorRankType.ALL_KINGDOM_WEEK or DjRankView.gChatAnchorRankType.ONE_KINGDOM_WEEK, djCtrl.isBroadcastDJ and DjRankView.gChatAnchorRankType.ALL_KINGDOM_WEEK or DjRankView.gChatAnchorRankType.ONE_KINGDOM_WEEK, djCtrl.isBroadcastDJ and DjRankView.gChatAnchorRankType.ALL_KINGDOM_WEEK or DjRankView.gChatAnchorRankType.ONE_KINGDOM_WEEK, djCtrl.isBroadcastDJ and DjRankView.gChatAnchorRankType.ALL_KINGDOM_WEEK or DjRankView.gChatAnchorRankType.ONE_KINGDOM_WEEK, djCtrl.isBroadcastDJ and DjRankView.gChatAnchorRankType.ALL_KINGDOM_WEEK or DjRankView.gChatAnchorRankType.ONE_KINGDOM_WEEK
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.nodeHead = SoraDGetExtendChildFromCCSByName(self, "CCS_djHead_head")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.btnChange:setTitleText(i18n("Anchor_text_43"))
	self.btnChange:setVisible(not djCtrl.isBroadcastDJ)
	self.labelTip = SoraDGetChildByName(self, "Text_tip")
	self.labelTip:setString(i18n("Anchor_text_41"))
	self.labelTip:setVisible(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelDonation = SoraDGetChildByName(self, "Text_donation")
	self.bottomBg1 = SoraDGetChildByName(self, "bottomBg_1")
	self.bottomBg = SoraDGetChildByName(self, "bottomBg")
	self.imageMyHead = SoraDGetChildByName(self, "Image_head")
	self.labelMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.labelMyName = SoraDGetChildByName(self, "Text_myName")
	self.labelMyAlliance = SoraDGetChildByName(self, "Text_myAlliance")
	self.labelMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Top_Size_ScrollView_rank"
	;("Top_Size_ScrollView_rank").col = 1
	;("Top_Size_ScrollView_rank").top = 10
	;("Top_Size_ScrollView_rank").left = 10
	;("Top_Size_ScrollView_rank").h = 15
	self.scroll:init("Top_Size_ScrollView_rank", 0, handler(self, self.createCell), handler(self, self.updateCell))
	self.labelName:setString(i18n("common_text_264"))
	self.labelDonation:setString(i18n("Anchor_text_50"))
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.bottomBg1:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.bottomBg:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.btnChange:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_RANK_UPDATE", handler(self, self.updateView))
	djCtrl:cleanRankList()
end
function DjRankView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.rankNum > 0 and self.rankNum <= #self.rankData[self.djuid][self.rankType] then
			self.scroll:scrollToIndex(self.rankNum)
		end
	end
end
function DjRankView:tabUpdate(tag, name)
	self.rankNum = 0
	self.rankType = tag
	self:getData()
end
function DjRankView:initData(uid)
	self.djuid = uid
	self.nodeHead:initData(self.djuid, gChatDJShowType.OTHER)
	_ENV = nil
	;(nil).name = djCtrl:getDJInfo(self.djuid).nick_name
	self.nodeTitle:setTitle(i18n("Anchor_text_42", nil))
	self:updateTab()
end
function DjRankView:updateTab()
	_ENV = nil
	;(nil).tabNum = 3
	_ENV, _ENV, (nil).defaultClick = nil, nil, 1
	;(nil).title = i18n("Anchor_text_4" .. self.rankType + 3)
	;(nil).tag = self.rankType
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.tabUpdate)
	;(nil).title = i18n("Anchor_text_4" .. self.rankType + 4)
	;(nil).tag = self.rankType + 1
	_ENV, (nil)[2], (nil).handle = nil, nil, handler(self, self.tabUpdate)
	;(nil).title = i18n("Anchor_text_4" .. self.rankType + 5)
	;(nil).tag = self.rankType + 2
	;(nil).tabsetArray, (nil)[3], (nil).handle = nil, nil, handler(self, self.tabUpdate)
	self.nodeTab:initView(nil)
end
function DjRankView:getData()
	if djCtrl:initChatDJRank(self.djuid, self.rankType) then
		SoraDShowLoading(self)
	end
end
function DjRankView:updateView()
	self.rankData = djCtrl:getChatDJRank()
	self.rankSelfData = djCtrl:getChatDJRankSelfInfo()
	self:updateScroll()
	self:updateMine()
	SoraDCloseLoading(self)
end
function DjRankView:updateMine()
	local _ENV, data
	if not self.rankData[self.djuid][self.rankType] then
		_ENV = self.rankData[self.djuid][self.rankType]
	end
	for i, v in ipairs(self.rankData[self.djuid][self.rankType]) do
		if v.uid == self.selfuid then
			data = v
			self.rankNum = i
			break
		end
	end
	if next(data) == nil then
		data = self.rankSelfData[self.djuid][self.rankType]
		self.labelMyRank:setString(i18n("common_text_827"))
	else
		self.labelMyRank:setString(tostring(data.rank))
	end
	if self.rankType <= DjRankView.gChatAnchorRankType.ONE_KINGDOM_TOTAL then
		self.labelMyName:setString(data.nickName)
	else
		self.labelMyName:setString(data.nickName .. "#" .. data.kid)
	end
	local alliance = ""
	if data.allianceName then
		_ENV = "#"
		;("#").conten = data.allianceName
		alliance = i18n("common_text_925", "#")
	else
		_ENV = "#"
		;("#").conten = i18n("common_text_826")
		alliance = i18n("common_text_925", "#")
	end
	self.labelMyAlliance:setString(alliance)
	self.labelMyNum:setString(string.formatnumberthousands(data.score))
	SoraDGetHeadFromManager(self.imageMyHead, data.iconID, data.avatar)
end
function DjRankView:updateScroll()
	local count = 0
	if self.rankData and self.djuid and self.rankData[self.djuid] and self.rankType and self.rankData[self.djuid][self.rankType] then
		count = #self.rankData[self.djuid][self.rankType]
	end
	self.labelTip:setVisible(count <= 0)
	self.scroll:updateNum(count)
	self.scroll:jumpToTop()
end
function DjRankView:createCell()
	local cell = self:createItem()
	cell.setScroll(self.scroll)
	return cell
end
function DjRankView:updateCell(panel, index)
	if self.rankData and self.djuid and self.rankData[self.djuid] and self.rankType and self.rankData[self.djuid][self.rankType] then
		local data = self.rankData[self.djuid][self.rankType][index]
		panel.initData(data)
	end
end
function DjRankView:createItem()
	local single = self.nodeClone:clone()
	single.imgBarBg = SoraDGetChildByName(single, "Image_barBg")
	single.layerTouch = SoraDGetChildByName(single, "Panel_touch")
	single.spriteIndex = SoraDGetChildByName(single, "Sprite_index")
	single.nodeFlag = SoraDGetChildByName(single, "Node_flag")
	single.imgHead = SoraDGetChildByName(single, "Image_head")
	single.imgHeadBg = SoraDGetChildByName(single, "Image_headBg")
	single.labelIndex = SoraDGetChildByName(single, "Text_index")
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.labelAlliance = SoraDGetChildByName(single, "Text_alliance")
	single.labelNum = SoraDGetChildByName(single, "Text_num")
	single.layerTouch:setSwallowTouches(false)
	single.layerTouch:addTouchEventListener(handler(self, self.btnRankClickCallBack))
	function single.initData(data)
		single.labelNum:setString(string.formatnumberthousands(data.score))
		if self.rankType <= DjRankView.gChatAnchorRankType.ONE_KINGDOM_TOTAL then
			single.labelName:setString(data.nickName)
		else
			single.labelName:setString(data.nickName .. "#" .. data.kid)
		end
		SoraDGetHeadFromManager(single.imgHead, data.iconID, data.avatar)
		single.labelIndex:setVisible(data.rank > RANK_TOP_SPECIAL)
		single.spriteIndex:setVisible(data.rank <= RANK_TOP_SPECIAL)
		single.imgBarBg:setVisible(data.rank <= RANK_TOP_SPECIAL or data.uid == self.selfuid)
		single.labelIndex:setString(tostring(data.rank))
		if data.rank <= RANK_TOP_SPECIAL then
			single.spriteIndex:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
			single.imgBarBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
		end
		if data.uid == self.selfuid and data.rank > RANK_TOP_SPECIAL then
			single.imgBarBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		end
		local alliance = ""
		if data.allianceName then
			single = ccui.TextureResType.plistType
			ccui.TextureResType.plistType.conten = data.allianceName
			alliance = i18n("common_text_925", ccui.TextureResType.plistType)
		else
			single = ccui.TextureResType.plistType
			ccui.TextureResType.plistType.conten = i18n("common_text_826")
			alliance = i18n("common_text_925", ccui.TextureResType.plistType)
		end
		single.labelAlliance:setString(alliance)
		single.layerTouch.uid = data.uid
		single.layerTouch.kid = data.kid
		single.layerTouch.isOwn = data.uid == self.selfuid
	end
	function single.setScroll(scroll)
	end
	return single
end
function DjRankView:btnRankClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if not button.isOwn then
			_ENV = "node is not on view"
			;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;("node is not on view").playerID = button.uid
			;("node is not on view").kid = button.kid
			SoraDSendMessage("node is not on view")
		else
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		end
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
function DjRankView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.rankType <= DjRankView.gChatAnchorRankType.ONE_KINGDOM_TOTAL then
			self.rankType = DjRankView.gChatAnchorRankType.ALL_KINGDOM_WEEK
		else
			self.rankType = DjRankView.gChatAnchorRankType.ONE_KINGDOM_WEEK
		end
		self:updateTab()
	end
end
return DjRankView
