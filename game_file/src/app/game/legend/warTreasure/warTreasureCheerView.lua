local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local publicRead = include("publicRead")
local warTreasureCtrl = SoraDGetCtrl("warTreasureCtrl")
local warTreasureCheerView = class("warTreasureCheerView", function(target)
	return target or SoraDCreateBasePanel("warTreasureCheerView")
end)
_ENV = "warTreasureCheerView"
;("warTreasureCheerView").DRUM = 827101
local ("warTreasureCheerView").VULN, VIEW_TYPE = 827201, "warTreasureCheerView"
function warTreasureCheerView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("warSecrit_btn_01"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.singleNode = SoraDGetChildByName(self, "Node_clone")
	self.btnRank = SoraDGetChildByName(self, "Button_Rank")
	self.btnRankAward = SoraDGetChildByName(self, "Button_Award")
	self.textHaveTitle = SoraDGetChildByName(self, "Text_Have_Title")
	self.textTips = SoraDGetChildByName(self, "Text_tip")
	self.textTitleName = SoraDGetChildByName(self, "Text_name")
	self.textPower = SoraDGetChildByName(self, "Text_donation")
	self.textHave = SoraDGetChildByName(self, "Text_Have")
	self.nodeHave = SoraDGetChildByName(self, "Node_Have")
	self.imageIcon = SoraDGetChildByName(self.nodeHave, "Image_Icon")
	SoraDShowLoading(self)
	warTreasureCtrl:reqWarTreasureAllianceRank()
end
function warTreasureCheerView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WAR_TREASURE_REFRESH", handler(self, self.updataDataScroll))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItemNum))
end
function warTreasureCheerView:refreshItemNum(target, data)
	self.haveItems = backpackCtrl:getItemCount(self.itemID)
	self.textHave:setString(string.formatnumberthousands(self.haveItems))
	SoraDToCenter(self.nodeHave, 10, SoraDFIsRA())
end
function warTreasureCheerView:initData(itemID)
	self.itemID = itemID
	self.ccs_title:setTitle(i18n(self.itemID == VIEW_TYPE.DRUM and "warSecrit_btn_01" or "warSecrit_btn_03"))
	_ENV = VIEW_TYPE.DRUM
	VIEW_TYPE.DRUM.num = ""
	self.textHaveTitle:setString(i18n(self.itemID == VIEW_TYPE.DRUM and "warSecrit_text_05" or "warSecrit_text_11", VIEW_TYPE.DRUM))
	self.imageIcon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self:refreshItemNum()
	self.textTips:setString(i18n("common_text_1464"))
	self.textTitleName:setString(i18n("common_text_2037"))
	self.textPower:setString(i18n(self.itemID == VIEW_TYPE.DRUM and "warSecrit_text_06" or "warSecrit_text_12"))
	self.btnRank:setTitleText(i18n("warSecrit_title_02"))
	self.btnRankAward:setTitleText(i18n("hero_title_02"))
	self.btnRank:addTouchEventListener(handler(self, self.btnClickOpenRank))
	self.btnRankAward:addTouchEventListener(handler(self, self.btnClickOpenRankAward))
end
function warTreasureCheerView:updataDataScroll(target, data)
	if data.subMsg == "rankList" then
		SoraDCloseLoading(self)
		self.textTips:setVisible(not next(data.rankList))
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		;(nil).itemID = self.itemID
		self.scroll:updateScrollView(cc.size(640, 110), data.rankList, 1, nil)
	elseif data.subMsg == "refresh" then
		self.haveItems = backpackCtrl:getItemCount(self.itemID)
		self.textHave:setString(string.formatnumberthousands(self.haveItems))
		_ENV = string.formatnumberthousands(self.haveItems)
		string.formatnumberthousands(self.haveItems).scroll = self.scroll
		string.formatnumberthousands(self.haveItems).view = self
		string.formatnumberthousands(self.haveItems).itemID = self.itemID
		self.scroll:updateScrollView(cc.size(640, 110), warTreasureCtrl:getRankList(), 1, string.formatnumberthousands(self.haveItems))
	end
end
function warTreasureCheerView:createSingle()
	local single = self.singleNode:clone()
	single = include("warTreasureCheerSingle").new(single)
	return single
end
function warTreasureCheerView:btnClickOpenRank(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("warTreasureRank")
		panel:setDefaultClick(self.itemID)
		panel:show()
	end
end
function warTreasureCheerView:btnClickOpenRankAward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("warTreasureRankAward")
		panel:setDefaultClick(self.itemID)
		panel:show()
	end
end
return warTreasureCheerView
