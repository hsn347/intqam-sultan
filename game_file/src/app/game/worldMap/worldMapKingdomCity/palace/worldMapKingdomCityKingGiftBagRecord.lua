local kingPacksRead = include("kingPacksRead")
_ENV = "kingPacksRead"
;("kingPacksRead").KING_GIFT = 1
;("kingPacksRead").LEGEND_GIFT = 2
;("kingPacksRead").PLAYER_GIFT = 3
;("kingPacksRead").HEGEMON_GIFT = 4
local ("kingPacksRead").KINGSTAR_GIFT, ViewType = 5, "kingPacksRead"
local WorldMapKingdomCityKingGiftBagRecord = class("worldMapKingdomCityKingGiftBagRecord", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapKingdomCityKingGiftBagRecord")
	end
	return target
end)
function WorldMapKingdomCityKingGiftBagRecord:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.panel = SoraDGetChildByName(self, "Center_Panel_frame")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.scroll = SoraDGetChildByName(self, "ScrollView_listFamous")
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PACK", handler(self, self.updatePack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_GIFT_LOG_BACK", handler(self, self.sMsgLegendLordGiftLogBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_GIFT_LOG_BACK", handler(self, self.sMsgHegemonLordGiftLogBack))
	SoraDAddMessage(self, "")
end
function WorldMapKingdomCityKingGiftBagRecord:initData(data, mapid)
	self.viewType = data.viewType or ViewType.KING_GIFT
	self.mapid = mapid
	if self.viewType == ViewType.KING_GIFT then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		KWKingdomCtrl:getGivePackLog()
		self.txtTitle:setString(i18n("common_text_1189"))
		SoraDShowLoading(self)
	elseif self.viewType == ViewType.PLAYER_GIFT then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		KWKingdomCtrl:getPlayerGivePackLog()
		self.txtTitle:setString(i18n("kindofwar_title_01"))
		SoraDShowLoading(self)
	elseif self.viewType == ViewType.LEGEND_GIFT then
		local gametop = gModuleMgr.getObject("gametop")
		local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
		SoraDShowLoading(self)
		legendLordCtrl:reqGiftLog()
		self.txtTitle:setString(i18n("legendaryking_text_02"))
	elseif self.viewType == ViewType.KINGSTAR_GIFT then
		local gametop = gModuleMgr.getObject("gametop")
		local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
		SoraDShowLoading(self)
		kingStarCtrl:reqGiftLog(worldMapDefine.getKingStarActivityID(self.mapid))
		self.txtTitle:setString(i18n("kingstarbattle_text_52"))
	elseif self.viewType == ViewType.HEGEMON_GIFT then
		self.bid = data.bid
		assert(self.bid, "bid 不能为nil")
		local gametop = gModuleMgr.getObject("gametop")
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		SoraDShowLoading(self)
		hegemonCtrl:reqGiftLog(self.bid)
		self.txtTitle:setString(i18n("hegemon_title_09"))
	end
end
function WorldMapKingdomCityKingGiftBagRecord:updatePack(target, retdate)
	if retdate.retdate then
		local sSize = self.scroll:getContentSize()
		local sH = math.max(sSize.height, #retdate.retdate * 90)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
		if next(retdate.retdate) ~= nil then
			self:delWarnText()
		else
			self:addWarnText(i18n("common_text_927"))
		end
		if self.viewType == ViewType.KING_GIFT then
			for i, v in ipairs(retdate.retdate) do
				local aAbbr = v.KAbbr and "(" .. v.KAbbr .. ")" or ""
				local dAbbr = v.abbr and "(" .. v.abbr .. ")" or ""
				local aName = aAbbr .. (v.KName or "")
				local dName = dAbbr .. (v.name or "")
				local packName = i18n(kingPacksRead.getItem(v.type).name)
				_ENV = i18n("common_text_927")
				i18n("common_text_927").king = aName
				i18n("common_text_927").revec = dName
				i18n("common_text_927").giftName = packName
				local addtxt = i18n("common_text_1420", i18n("common_text_927"))
				local item = self:addRecord(addtxt)
				item:setPosition(0, sH - i * 90)
				item:addTo(self.scroll)
			end
		elseif self.viewType == ViewType.PLAYER_GIFT then
			for i, v in ipairs(retdate.retdate) do
				local aAbbr = v.KAbbr or ""
				local dAbbr = v.abbr or ""
				local aName = v.KName or ""
				local dName = v.name or ""
				local packName = i18n(kingPacksRead.getItem(v.type).name)
				_ENV = item.addTo
				item.addTo.aalliance = aAbbr
				item.addTo.alord = aName
				item.addTo.balliance = dAbbr
				item.addTo.blord = dName
				item.addTo.giftName = packName
				local addtxt = i18n("common_text_2724", item.addTo)
				local item = self:addRecord(addtxt)
				item:setPosition(0, sH - i * 90)
				item:addTo(self.scroll)
			end
		end
		SoraDCloseLoading(self)
	end
end
function WorldMapKingdomCityKingGiftBagRecord:sMsgLegendLordGiftLogBack(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	local legendKingRead = include("legendKingRead")
	local giftLog = self.viewType == ViewType.KINGSTAR_GIFT and kingStarCtrl:getGiftLog() or legendLordCtrl:getGiftLog()
	if 0 < #giftLog then
		self:delWarnText()
	else
		self:addWarnText(i18n("common_text_927"))
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #giftLog * 90)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(giftLog) do
		local awardLordInfo = v.awardLordInfo
		local playerInfo = v.playerInfo
		local aName = ""
		if awardLordInfo then
			local aAbbr = awardLordInfo.abbr and "(" .. awardLordInfo.abbr .. ")" or ""
			aName = aAbbr .. (awardLordInfo.nickname or "") .. (awardLordInfo.kid and "#" .. awardLordInfo.kid or "")
		end
		local dAbbr = playerInfo.abbr and "(" .. playerInfo.abbr .. ")" or ""
		local dName = dAbbr .. (playerInfo.nickname or "") .. (playerInfo.kid and "#" .. playerInfo.kid or "")
		local packName = legendKingRead.getPackageName(v.giftID, self.viewType == ViewType.KINGSTAR_GIFT and worldMapDefine.KINGSTAR_KINGDOM_ID or nil)
		if awardLordInfo.rank == 1 then
			if self.viewType == ViewType.KINGSTAR_GIFT then
				_ENV = ViewType.KINGSTAR_GIFT
				ViewType.KINGSTAR_GIFT.name = aName
			end
			_ENV = ViewType.KINGSTAR_GIFT
			ViewType.KINGSTAR_GIFT.name = aName
			aName = i18n("kingstarbattle_text_79", ViewType.KINGSTAR_GIFT) or i18n("legendaryking_text_07", ViewType.KINGSTAR_GIFT)
		end
		_ENV = ViewType.KINGSTAR_GIFT
		ViewType.KINGSTAR_GIFT.name = aName
		ViewType.KINGSTAR_GIFT.target = dName
		ViewType.KINGSTAR_GIFT.box = packName
		local addtxt = i18n("common_text_4230", ViewType.KINGSTAR_GIFT)
		local item = self:addRecord(addtxt)
		item:setPosition(0, sH - i * 90)
		item:addTo(self.scroll)
	end
	SoraDCloseLoading(self)
end
function WorldMapKingdomCityKingGiftBagRecord:sMsgHegemonLordGiftLogBack(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	local hegemonRead = include("hegemonRead")
	local giftLog = hegemonCtrl:getGiftLog(self.bid)
	if 0 < #giftLog then
		self:delWarnText()
	else
		self:addWarnText(i18n("common_text_927"))
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #giftLog * 90)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(giftLog) do
		local awardLordInfo = v.awardLordInfo
		local playerInfo = v.playerInfo
		local aName = ""
		if awardLordInfo then
			local aAbbr = awardLordInfo.abbr and "(" .. awardLordInfo.abbr .. ")" or ""
			aName = aAbbr .. (awardLordInfo.nickname or "") .. (awardLordInfo.kid and "#" .. awardLordInfo.kid or "")
		end
		local dAbbr = playerInfo.abbr and "(" .. playerInfo.abbr .. ")" or ""
		local dName = dAbbr .. (playerInfo.nickname or "") .. (playerInfo.kid and "#" .. playerInfo.kid or "")
		local packName = hegemonRead.getPackageName(v.giftID)
		if awardLordInfo.rank == 1 then
			_ENV = cc.size(sSize.width, sH)
			cc.size(sSize.width, sH).name = aName
			aName = i18n("hegemon_title_18", cc.size(sSize.width, sH))
		end
		_ENV = cc.size(sSize.width, sH)
		cc.size(sSize.width, sH).name = aName
		cc.size(sSize.width, sH).target = dName
		cc.size(sSize.width, sH).box = packName
		local addtxt = i18n("common_text_4230", cc.size(sSize.width, sH))
		local item = self:addRecord(addtxt)
		item:setPosition(0, sH - i * 90)
		item:addTo(self.scroll)
	end
	SoraDCloseLoading(self)
end
function WorldMapKingdomCityKingGiftBagRecord:addRecord(text)
	text = text or "dafault"
	local sSize = cc.size(376, 365)
	local imgBg = ccui.ImageView:create("frame_alliance_note.png", ccui.TextureResType.plistType)
	imgBg:setScale9Enabled(true)
	imgBg:setContentSize(cc.size(sSize.width, 85))
	imgBg:setAnchorPoint(cc.p(0, 0))
	local frmText = ccui.Text:create(text, "", 20)
	frmText:ignoreContentAdaptWithSize(false)
	frmText:setTextAreaSize(cc.size(sSize.width - 30, 75))
	frmText:setColor(cc.c3b(55, 125, 80))
	frmText:setAnchorPoint(cc.p(0, 0))
	frmText:setPosition(15, 10)
	frmText:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	frmText:setTextHorizontalAlignment(SoraDFLabelR())
	frmText:setName("Text_content")
	frmText:addTo(imgBg)
	return imgBg
end
function WorldMapKingdomCityKingGiftBagRecord:addWarnText(text)
	self.txtWarn:setString(text)
end
function WorldMapKingdomCityKingGiftBagRecord:delWarnText(...)
	if self.txtWarn then
		self.txtWarn:setVisible(false)
	end
end
return WorldMapKingdomCityKingGiftBagRecord
