local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordOfficialRead = include("lordOfficialRead")
local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Com_official = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_official", Com_official)
function Com_official:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_official:onShow()
end
function Com_official:initData(officialData, data)
	self.officialData = officialData
	self.tablePlayerInfo = data
	self.isOwnData = self.tablePlayerInfo.base.uid == lordInfoCtrl:getLordInfo().base.uid
	self.officialType = officialData.officialType
	local showOfficialType = lordInfoCtrl:getShowOfficialTypeForLord(self.tablePlayerInfo)
	if self.officialType == showOfficialType then
		self.fields.Text_show:setString(i18n("common_text_4356"))
		self.fields.imgSel:setVisible(true)
	else
		self.fields.imgSel:setVisible(false)
		self.fields.Text_show:setString("")
	end
	local itemsConfig = lordLocalData.getLordPowerTableByKey("officialItemConfig")
	local officialRank = lordOfficialRead.getOfficialRankType(self.officialType, officialData.officialId)
	local itemConfig = itemsConfig[self.officialType][officialRank]
	self.fields.img_official_bg:setSpriteFrame(itemConfig.bgName)
	self.fields.imgBottomBg:setVisible(itemConfig.isShowBottomBg)
	self.fields.img_official_icon:setSpriteFrame(lordOfficialRead.getOfficialIcon(self.officialType, officialData.officialId))
	self.fields.img_official_icon:setScale(itemConfig.iconscale)
	self.controllers.c1:setSelectedIndex(officialData.officialId == 1 and 0 or 1)
end
function Com_official:btnClick()
	SoraDPlaySound()
	if self.officialType == gShowOfficialType.KING then
		local panel = SoraDCreatePanel("worldMapKingdomCityOfficialPop")
		local isShowMode = self.isOwnData
		panel:initData(self.tablePlayerInfo.official, self.tablePlayerInfo.base, isShowMode)
		SoraDGetChildByName(panel, "Image_head"):setVisible(false)
		SoraDGetChildByName(panel, "Image_official"):setVisible(true)
		panel:show()
	elseif self.officialType == gShowOfficialType.HEGEMON then
		local panel = SoraDCreatePanel("hegemonOfficial")
		local hegemonRead = include("hegemonRead")
		local titleBuff = hegemonRead.getOfficialInfo(self.tablePlayerInfo.hegemonTitle)
		local titleInfo
		if self.tablePlayerInfo.hegemonTitle then
			_ENV, _ENV = self.tablePlayerInfo.base, self.tablePlayerInfo.hegemonTitle
			titleInfo, self.tablePlayerInfo.hegemonTitle.playerInfo, self.tablePlayerInfo.base.uid = self.tablePlayerInfo.hegemonTitle, self.tablePlayerInfo.base, self.tablePlayerInfo.base.uid
		end
		_ENV = self.tablePlayerInfo.hegemonTitle
		self.tablePlayerInfo.hegemonTitle.titleBuff = titleBuff
		self.tablePlayerInfo.hegemonTitle.bid = tonumber(self.tablePlayerInfo.hegemonBid)
		local self.tablePlayerInfo.hegemonTitle.titleInfo, itemData = titleInfo, self.tablePlayerInfo.hegemonTitle
		local isShowMode = self.isOwnData
		local isHideOp = self.isOwnData
		panel:init(itemData, isHideOp, isShowMode)
		panel:show()
	elseif self.officialType == gShowOfficialType.LEGEND then
		local panel = SoraDCreatePanel("legendaryOfficial")
		local legendKingRead = include("legendKingRead")
		local titleBuff = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, self.tablePlayerInfo.legendTitle)
		local titleInfo
		if self.tablePlayerInfo.legendTitle then
			_ENV, _ENV = self.isOwnData, self.tablePlayerInfo.legendTitle
			titleInfo, self.tablePlayerInfo.legendTitle.playerInfo, self.isOwnData.uid = self.tablePlayerInfo.legendTitle, self.isOwnData, self.tablePlayerInfo.base.uid
		end
		_ENV = self.tablePlayerInfo.legendTitle
		self.tablePlayerInfo.legendTitle.titleBuff = titleBuff
		local self.tablePlayerInfo.legendTitle.titleInfo, itemData = titleInfo, self.tablePlayerInfo.legendTitle
		local isShowMode = self.isOwnData
		local isHideOp = self.isOwnData
		panel:init(itemData, isHideOp, isShowMode)
		panel:show()
	elseif self.officialType == gShowOfficialType.KINGSTAR then
		local panel = SoraDCreatePanel("legendaryOfficial")
		local legendKingRead = include("legendKingRead")
		local mapId = self.officialData.mapid or worldMapDefine.KINGSTAR_KINGDOM_ID
		local titleBuff = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, self.tablePlayerInfo.legendForSepTitle, mapId)
		local titleInfo
		if self.tablePlayerInfo.legendForSepTitle then
			_ENV, _ENV = mapId, self.tablePlayerInfo.legendForSepTitle
			titleInfo, self.tablePlayerInfo.legendForSepTitle.playerInfo, mapId.uid = self.tablePlayerInfo.legendForSepTitle, mapId, self.tablePlayerInfo.base.uid
		end
		_ENV = self.tablePlayerInfo.legendForSepTitle
		self.tablePlayerInfo.legendForSepTitle.titleBuff = titleBuff
		local self.tablePlayerInfo.legendForSepTitle.titleInfo, itemData = titleInfo, self.tablePlayerInfo.legendForSepTitle
		local isShowMode = self.isOwnData
		local isHideOp = self.isOwnData
		panel:init(itemData, isHideOp, isShowMode, mapId)
		panel:show()
	elseif self.officialType == gShowOfficialType.ATLANTIS then
		local panel = SoraDCreatePanel("atlantisPrivilegeDetailPop")
		local isShowMode = self.isOwnData
		panel:initData(self.tablePlayerInfo.base, self.tablePlayerInfo.atlantisOfficialType, isShowMode)
		panel:show()
	elseif self.officialType == gShowOfficialType.NEBULA then
		local panel = SoraDCreatePanel("NebulaOfflcerDetailPop")
		local isShowMode = self.isOwnData
		panel:initData(self.tablePlayerInfo.base, self.tablePlayerInfo.nebulaOfficialID, isShowMode, self.officialType, self.tablePlayerInfo)
		panel:show()
	elseif self.officialType == gShowOfficialType.NEBULA2 then
		local panel = SoraDCreatePanel("NebulaOfflcerDetailPop")
		local isShowMode = self.isOwnData
		panel:initData(self.tablePlayerInfo.base, self.tablePlayerInfo.nebulaOfficialID2, isShowMode, self.officialType, self.tablePlayerInfo)
		panel:show()
	end
end
return Com_official
