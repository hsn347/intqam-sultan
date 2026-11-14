local remainsTeamCtrl = SoraDGetCtrl("remainsTeamCtrl")
local ctGridScroll = include("ctGridScroll")
local remainsWarRead = include("remainsWarRead")
local remainsWarRankTitleView = class("remainsWarRankTitleView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local MAX_REQ_NUM = 10
function remainsWarRankTitleView:ctor()
	self.wGet, _ENV, self.sIndex, _ENV, self.rankList, _ENV, self.rankData, _ENV, self.myRankData, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.initScroll = false
	self.titleType = RUINS_TITLE_TYPE.KILL_ARMY_FC
	self:initWidget()
end
function remainsWarRankTitleView:initWidget()
	self.node_self = SoraDGetExtendChildFromCCSByName(self, "Bottom_CCS_remainsWarRankScoreSingle_node")
	self.node_self:setPositionY(-self:getPanelOffsetHeight() + 195)
	self.node_bottom = SoraDGetChildByName(self, "Bottom_Node")
	self.node_bottom:setPositionY(-self:getPanelOffsetHeight() + 190)
	self.single = SoraDGetChildByName(self, "Node_score")
	self.single:setVisible(false)
	self.textTitleScore = SoraDGetChildByName(self, "text_title_score")
	self.textTitleName = SoraDGetChildByName(self, "text_title_name")
	self.textTitleScore:setString(i18n("remains_text_94"))
	self.textTitleName:setString(i18n("common_text_264"))
	self.textTitleScore:setString(i18n("common_text_2709"))
	SoraDGetChildByName(self, "text_title_rank"):setString(i18n("common_text_2193"))
	SoraDGetChildByName(self, "text_title_times"):setString(i18n("remains_text_337"))
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.scroll = ctGridScroll.new(self.scroll)
	self.scrollTitle = SoraDGetChildByName(self, "ScrollView_title")
	self.title_single = SoraDGetChildByName(self.scrollTitle, "Node_title_single")
	self.title_single:setVisible(false)
	self.Panel_black = SoraDGetChildByName(self.scrollTitle, "Panel_black")
	self.Panel_black:setLocalZOrder(2)
	self:initScrollTitle()
end
function remainsWarRankTitleView:initScrollTitle(...)
	local itemW = 130
	local itemN = 5
	local sSize = self.scrollTitle:getContentSize()
	local sW = math.max(sSize.width, itemW * itemN)
	self.scrollTitle:setInnerContainerSize(cc.size(sW, sSize.height))
	self.Panel_black:setContentSize(cc.size(sW, sSize.height))
	self.itemList, _ENV = self.Panel_black.setContentSize, self.Panel_black.setContentSize
	for i = 1, itemN do
		local item = self.title_single:clone()
		item:setVisible(true)
		item:addTo(self.scrollTitle, 1)
		local posx = itemW * (i - 0.5)
		if SoraDFIsRA() then
			posx = itemW * itemN - itemW * (i - 0.5)
		end
		item:setPosition(posx, 30)
		self.itemList[i] = item
		SoraDGetChildByName(item, "Text_title"):setString(remainsWarRead.getRuinsTitleName(i))
		SoraDGetChildByName(item, "Sprite_icon"):setSpriteFrame(remainsWarRead.getRuinsTitleIcon(i))
		item.Button_touch = SoraDGetChildByName(item, "Button_touch")
		item.Button_touch:setTag(i)
		item.Button_touch:addTouchEventListener(handler(self, self.onBtnTouchClick))
	end
	self:switchTitleBtn(self.titleType)
end
function remainsWarRankTitleView:onBtnTouchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchTitleBtn(button:getTag())
		if self.wGet[self.titleType] ~= false then
			self:req4Data(self.sIndex[self.titleType])
		else
			self.rankList, _ENV = self.req4Data, self.req4Data
			for i, v in ipairs(self.rankData[self.titleType]) do
				v.rank = i
				_ENV = button:getTag()
				button:getTag().index = i
				button:getTag().data = v
				table.insert(self.rankList, button:getTag())
			end
			self:initView(true)
		end
		self:setSelfInfo()
	end
end
function remainsWarRankTitleView:switchTitleBtn(titleType)
	print("==switchTitleBtn==", titleType)
	self.titleType = titleType
	for i, v in ipairs(self.itemList) do
		v:setLocalZOrder(1)
		v.Button_touch:setTouchEnabled(true)
		v.Button_touch:setSwallowTouches(false)
	end
	local curItem = self.itemList[titleType]
	curItem:setLocalZOrder(3)
	curItem.Button_touch:setTouchEnabled(false)
	if titleType == RUINS_TITLE_TYPE.MOVE_CITY then
		if SoraDFIsRA() then
			self.scrollTitle:jumpToLeft()
		else
			self.scrollTitle:jumpToRight()
		end
	elseif titleType == RUINS_TITLE_TYPE.KILL_ARMY_FC then
		if SoraDFIsRA() then
			self.scrollTitle:jumpToRight()
		else
			self.scrollTitle:jumpToLeft()
		end
	end
end
function remainsWarRankTitleView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_RANK_TITLE_LIST", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function remainsWarRankTitleView:init()
	self:setSelfInfo()
	self:req4Data(self.sIndex[self.titleType])
end
function remainsWarRankTitleView:setSelfInfo()
	if not self.myRankData[self.titleType] then
		_UPVALUE0_ = self.myRankData[self.titleType]
	end
	self.node_self:initSelfTitleData(self.myRankData[self.titleType])
end
function remainsWarRankTitleView:req4Data(index)
	remainsTeamCtrl:reqTitleRank(index or 1, MAX_REQ_NUM, self.titleType)
	local loading = SoraDShowLoading(self)
	local x, y = self.text_tips:getPosition()
	loading:setPosition(cc.p(x, y))
end
function remainsWarRankTitleView:initData(target, data)
	SoraDCloseLoading(self)
	local titleType = data.titleType
	if data.myInfo and next(data.myInfo) then
		self.myRankData[titleType] = data.myInfo
	end
	self.sIndex[titleType] = data.idx
	self.wGet[titleType] = data.wget
	self:setSelfInfo()
	if not self.rankData[titleType] then
		_ENV = self.rankData[titleType]
	end
	self.rankData[titleType] = self.rankData[titleType]
	local jumpToTop = not next(self.rankData[titleType])
	if next(data.rankList) ~= nil then
		local cpyTbl = clone(data.rankList)
		for _, v in ipairs(cpyTbl) do
			table.insert(self.rankData[titleType], v)
		end
	end
	self.rankList, _ENV = clone(data.rankList), cpyTbl
	for i, v in ipairs(self.rankData[titleType]) do
		v.rank = i
		_ENV = self.rankData[titleType]
		self.rankData[titleType].index = i
		self.rankData[titleType].data = v
		table.insert(self.rankList, self.rankData[titleType])
	end
	self:initView(jumpToTop)
end
function remainsWarRankTitleView:initView(jumpToTop)
	if #self.rankList <= 0 then
		self.text_tips:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.text_tips:setVisible(false)
		self.scroll:setVisible(true)
		if not self.initScroll then
			self.scroll:init(self.rankList, handler(self, self.createSingle), cc.size(640, 115))
			self.scroll:begin2Run()
			self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
			self.initScroll = true
		else
			self.scroll:setNewTable(self.rankList)
			if jumpToTop then
				self.scroll:jumpToTop()
			end
		end
	end
end
function remainsWarRankTitleView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.wGet[self.titleType] then
		self:req4Data(self.sIndex[self.titleType])
	end
end
function remainsWarRankTitleView:createSingle(info, index)
	local ocx = self.single:clone()
	local single = include("remainsWarRankScoreSingle").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setHandle(handler(self, self.queryPlayerInfo))
	info.rank = index
	single:initTitleData(info)
	return ocx
end
function remainsWarRankTitleView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function remainsWarRankTitleView:queryPlayerInfo(data)
	if data then
		self._queryInfo = true
		_ENV = nil
		;(nil).targetName = self.__cname
		SoraDGetCtrl("lordInfoCtrl"):getLordInfoByUid(data.uid, data.kid, nil)
		SoraDShowLoading(self)
	end
end
return remainsWarRankTitleView
