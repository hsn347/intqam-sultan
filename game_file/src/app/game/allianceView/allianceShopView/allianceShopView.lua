local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceltCtrl = include("allianceltCtrl")
local HeadSingleX = SoraDFPosX(532.5)
local AllianceShopView = class("allianceShopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceShopView")
	end
	return target
end)
function AllianceShopView:ctor()
	self.tableItemSingle, _ENV, self.tableItemList, _ENV, self.curType = gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR
	self.curPoint = 0
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_192"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnLog = SoraDGetChildByName(self, "Button_log")
	self.btnLog:setTitleText(i18n("common_text_836"))
	self.btnList = SoraDGetChildByName(self, "Button_list")
	self.btnList:setTitleText(i18n("allianceshop_btn_02"))
	self.btnStore = SoraDGetChildByName(self, "Button_shop")
	self.btnStore:setTitleText(i18n("common_text_192"))
	self.labelType = SoraDGetChildByName(self, "Text_type")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_930"))
	self.spriteType = SoraDGetChildByName(self, "Sprite_type")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btnLog:addTouchEventListener(handler(self, self.btnLogClickCallBack))
	self.btnList:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnStore:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	self:changeState(true)
end
function AllianceShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_STORE_LIST_SUCCESS", handler(self, self.updateScrollWithData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.updateScrollWithData))
end
function AllianceShopView:updatePoint()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	else
		self.curPoint = allianceMgr:getAllianceProperty("bonus")
	end
	self.labelPoint:setString(string.formatnumberthousands(self.curPoint))
	if SoraDFIsRA() then
		self.labelPoint:setPositionX(self.labelType:getPositionX() - self.labelType:getContentSize().width - 10)
	else
		self.labelPoint:setPositionX(self.labelType:getPositionX() + self.labelType:getContentSize().width + 10)
	end
end
function AllianceShopView:changeState(isStore)
	local checkColor = cc.c3b(144, 132, 97)
	local uncheckColor = cc.c3b(255, 245, 176)
	self.btnList:setTouchEnabled(isStore)
	self.btnList:setBright(not isStore)
	self.btnList:setTitleColor(isStore and checkColor or uncheckColor)
	self.btnStore:setTouchEnabled(not isStore)
	self.btnStore:setBright(isStore)
	self.btnStore:setTitleColor(isStore and uncheckColor or checkColor)
	if isStore then
		self.curType = gIDDef.ALLIANCE_HONOR
		self.labelType:setString(i18n("common_text_266"))
		self.spriteType:setSpriteFrame("icon_alliance_honor.png")
	else
		self.curType = gIDDef.ALLIANCE_SCORE
		self.labelType:setString(i18n("common_text_032"))
		self.spriteType:setSpriteFrame("icon_alliance_point.png")
	end
end
function AllianceShopView:updateScrollWithData(target, data)
	self:updatePoint()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.tableItemList = allianceStore:getItemList()
	else
		self.tableItemList = allianceStore:getShopList()
	end
	self.labelNotice:setVisible(#self.tableItemList <= 0)
	local floorCount = math.ceil(#self.tableItemList / 2)
	local scrollH = math.max(self.scroll:getContentSize().height, 170 * floorCount)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for i = 1, floorCount do
		if not self.tableItemSingle[i] then
			local single = SoraDCreatePanel("allianceShopSingle")
			single:initData(self.curType, self.tableItemList[i * 2 - 1], self.tableItemList[i * 2])
			single:setTopLineVisible(i == 1)
			single:setScroll(self.scroll)
			single:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - (i - 1) * 170))
			single:addTo(self.scroll, 1)
			self.tableItemSingle[i] = single
		else
			local single = self.tableItemSingle[i]
			single:setVisible(true)
			single:initData(self.curType, self.tableItemList[i * 2 - 1], self.tableItemList[i * 2])
			single:setScroll(self.scroll)
			single:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - (i - 1) * 170))
			single:setTopLineVisible(i == 1)
		end
	end
	if next(self.tableItemSingle) and floorCount < #self.tableItemSingle then
		for i = floorCount + 1, #self.tableItemSingle do
			self.tableItemSingle[i]:setVisible(false)
		end
	end
	self.scroll:jumpToTop()
	SoraDCloseLoading(self.scroll)
end
function AllianceShopView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curType == gIDDef.ALLIANCE_HONOR then
			_UPVALUE1_ = "common_text_266"
			;("common_text_266")[1] = i18n("common_text_658")
			;("common_text_266")[2] = i18n("common_text_659")
			;("common_text_266")[3] = i18n("common_text_659")
			;("common_text_266")[4] = i18n("common_text_659")
			SoraDShowFixWindow(i18n("common_text_266"), "common_text_266", cc.c3b(215, 195, 155))
		else
			_UPVALUE1_ = "common_text_032"
			;("common_text_032")[1] = i18n("common_text_274")
			;("common_text_032")[2] = i18n("common_text_275")
			;("common_text_032")[3] = i18n("common_text_275")
			;("common_text_032")[4] = i18n("common_text_275")
			SoraDShowFixWindow(i18n("common_text_032"), "common_text_032", cc.c3b(215, 195, 155))
		end
	end
end
function AllianceShopView:btnLogClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceShopLogView")
		panel:initData(self.curType)
		panel:show()
	end
end
function AllianceShopView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cType = self.curType
		self:changeState(self.btnStore == button)
		if self.curType ~= cType then
			self.scroll:removeAllChildren()
			self.tableItemSingle, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
		end
		self:updateScrollWithData()
	end
end
function AllianceShopView:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	else
		allianceStore:reqAllianceItemStoreData()
	end
end
return AllianceShopView
