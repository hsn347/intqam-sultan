local kingPacksRead = include("kingPacksRead")
local WorldMapKingdomCityPlayerGiftBagRecord = class("worldMapKingdomCityPlayerGiftBagRecord", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapKingdomCityPlayerGiftBagRecord")
	end
	return target
end)
function WorldMapKingdomCityPlayerGiftBagRecord:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.txtTitle = SoraDGetChildByName(self, "Text_title"):setString(i18n("kindofwar_title_01"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_listFamous")
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PACK", handler(self, self.updatePack))
end
function WorldMapKingdomCityPlayerGiftBagRecord:initData(_rank)
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	KWKingdomCtrl:getGivePackLog(_rank)
	SoraDShowLoading(self)
end
function WorldMapKingdomCityPlayerGiftBagRecord:updatePack(target, retdate)
	dump(retdate, "retdate======")
	if retdate.retdate then
		local sSize = self.scroll:getContentSize()
		local sH = math.max(sSize.height, #retdate.retdate * 90)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
		if next(retdate.retdate) ~= nil then
			self:delWarnText()
		else
			self:addWarnText(i18n("common_text_927"))
		end
		for i, v in ipairs(retdate.retdate) do
			local aAbbr = v.KAbbr or ""
			local dAbbr = v.abbr or ""
			local aName = v.KName or ""
			local dName = v.name or ""
			local packName = i18n(kingPacksRead.getItem(v.type).name)
			_ENV = i18n("common_text_927")
			i18n("common_text_927").aalliance = aAbbr
			i18n("common_text_927").alord = aName
			i18n("common_text_927").balliance = dAbbr
			i18n("common_text_927").blord = dName
			i18n("common_text_927").giftName = packName
			local addtxt = i18n("common_text_2724", i18n("common_text_927"))
			local item = self:addRecord(addtxt)
			item:setPosition(0, sH - i * 90)
			item:addTo(self.scroll)
		end
		SoraDCloseLoading(self)
	end
end
function WorldMapKingdomCityPlayerGiftBagRecord:addRecord(text)
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
	frmText:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	frmText:setName("Text_content")
	frmText:addTo(imgBg)
	return imgBg
end
function WorldMapKingdomCityPlayerGiftBagRecord:addWarnText(text)
	self.txtWarn:setString(text)
end
function WorldMapKingdomCityPlayerGiftBagRecord:delWarnText()
	if self.txtWarn then
		self.txtWarn:setVisible(false)
	end
end
return WorldMapKingdomCityPlayerGiftBagRecord
