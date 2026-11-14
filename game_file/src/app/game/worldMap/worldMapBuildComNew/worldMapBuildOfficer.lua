local gametop = gModuleMgr.getObject("gametop")
local legendLordCtrl = SoraDGetCtrl("legendLordCtrl")
local kingStarCtrl = SoraDGetCtrl("kingStarCtrl")
local hegemonCtrl = SoraDGetCtrl("hegemonCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildOfficer = class("worldMapBuildOfficer", worldMapBuildComNew)
local gShowOfficialType = _G.gShowOfficialType
function worldMapBuildOfficer:ctor(...)
	worldMapBuildOfficer.super.ctor(self, ...)
end
function worldMapBuildOfficer:_initData(...)
	self.showOfficialType = nil
	self.officialType = 0
	self.leaguedOfficialType = 0
	self.kingStarOfficialType = 0
	self.hegemonOfficialType = 0
	self.atlantisOfficialType = 0
	self.nebulaOfficialID = 0
	self.nebulaOfficialID2 = 0
	self.emperorOfficial = 0
	_ENV = nil
	;(nil).byUID = true
	local isShowOfficeIcon = SoraDConfigGet("Game:worldMapOfficeIcon:OfficeIcon~bool", nil)
	if isShowOfficeIcon == nil then
		isShowOfficeIcon = true
	end
	self.isShowOffice = isShowOfficeIcon
end
function worldMapBuildOfficer:addCacheBefore(...)
	if self.officalImage then
		self.officalImage:setVisible(false)
		self.officalIcon:removeAllChildren()
	end
end
function worldMapBuildOfficer:updateData(data)
	if data.official or data.showOfficialType or data.worldOfficial or data.hegemonOfficial or data.atlantisOfficialType or data.nebulaOfficialID or data.nebulaOfficialID2 or data.legendForSepOfficial or data.emperorOfficial then
		if data.official then
			self.officialType = data.official
		end
		if data.worldOfficial then
			self.leaguedOfficialType = data.worldOfficial
		end
		if data.legendForSepOfficial then
			self.kingStarOfficialType = data.legendForSepOfficial
		end
		if data.hegemonOfficial then
			self.hegemonOfficialType = data.hegemonOfficial
		end
		if data.showOfficialType then
			self.showOfficialType = data.showOfficialType
		end
		if data.atlantisOfficialType then
			self.atlantisOfficialType = data.atlantisOfficialType
		end
		if data.nebulaOfficialID then
			self.nebulaOfficialID = data.nebulaOfficialID
		end
		if data.nebulaOfficialID2 then
			self.nebulaOfficialID2 = data.nebulaOfficialID2
		end
		if data.emperorOfficial then
			self.emperorOfficial = data.emperorOfficial
		end
		self:updateOfficial()
		return true
	end
end
function worldMapBuildOfficer:updateOfficial()
	self.target_:updateBuildingImg()
	local hide = true
	if self.isShowOffice then
		if self.lastTbOfficialInfo ~= nil and self.lastTbOfficialInfo.official == self.officialType and self.lastTbOfficialInfo.legendTitle == self.leaguedOfficialType and self.lastTbOfficialInfo.legendForSepTitle == self.kingStarOfficialType and self.lastTbOfficialInfo.hegemonTitle == self.hegemonOfficialType and self.lastTbOfficialInfo.atlantisOfficialType == self.atlantisOfficialType and self.lastTbOfficialInfo.nebulaOfficialID == self.nebulaOfficialID and self.lastTbOfficialInfo.nebulaOfficialID2 == self.nebulaOfficialID2 and self.lastTbOfficialInfo.emperorOfficial == self.emperorOfficial and self.lastTbOfficialInfo.showOfficialType == self.showOfficialType then
			return
		end
		local lordInfoCtrl, tbOfficialInfo = self.lastTbOfficialInfo.showOfficialType, self.lastTbOfficialInfo.showOfficialType
		tbOfficialInfo.official = self.officialType
		tbOfficialInfo.legendTitle = self.leaguedOfficialType
		tbOfficialInfo.legendForSepTitle = self.kingStarOfficialType
		tbOfficialInfo.hegemonTitle = self.hegemonOfficialType
		tbOfficialInfo.atlantisOfficialType = self.atlantisOfficialType
		tbOfficialInfo.nebulaOfficialID = self.nebulaOfficialID
		tbOfficialInfo.nebulaOfficialID2 = self.nebulaOfficialID2
		tbOfficialInfo.emperorOfficial = self.emperorOfficial
		tbOfficialInfo.showOfficialType = self.showOfficialType
		self.lastTbOfficialInfo = tbOfficialInfo
		local showOfficialType = lordInfoCtrl:getShowOfficialTypeForLord(tbOfficialInfo)
		print("showOfficialType2", showOfficialType, self.showOfficialType)
		hide = false
		if showOfficialType == gShowOfficialType.KING then
			self:lazyCreateOfficalImage()
			local officialInfoRead = include("officialInfoRead")
			local officialInfo = officialInfoRead.getInfoByType(self.officialType)
			if officialInfo then
				self.officalIcon:setSpriteFrame(officialInfo.img)
				print("----------")
				dump(officialInfo, "officialInfo")
				if officialInfo.class < 2 then
					self.officalImage:setSpriteFrame("frame_king_23.png")
					self:crownUpEffect(self.officalIcon)
				else
					self.officalImage:setSpriteFrame("frame_king_22.png")
					self:crownDownEffect(self.officalIcon)
				end
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.LEGEND then
			self:lazyCreateOfficalImage()
			local legendKingRead = include("legendKingRead")
			local officialInfo = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, self.leaguedOfficialType)
			if officialInfo then
				self.officalIcon:setSpriteFrame(officialInfo.img)
				self.officalImage:setSpriteFrame("icon_LegendaryKing_honor.png")
				self:crownUpEffect(self.officalIcon)
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.KINGSTAR then
			self:lazyCreateOfficalImage()
			local legendKingRead = include("legendKingRead")
			local officialInfo = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, self.kingStarOfficialType, worldMapDefine.KINGSTAR_KINGDOM_ID)
			if officialInfo then
				self.officalIcon:setSpriteFrame(officialInfo.img)
				self.officalImage:setSpriteFrame("icon_LegendaryKing_honor.png")
				self:crownUpEffect(self.officalIcon)
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.HEGEMON then
			self:lazyCreateOfficalImage()
			self.officalImage:setScale(1.0)
			local hegemonRead = include("hegemonRead")
			local officialImage = hegemonRead.getOfficialIcon(self.hegemonOfficialType)
			local isGood = hegemonRead.judgeIsGood(self.hegemonOfficialType)
			if officialImage then
				self.officalIcon:setSpriteFrame(officialImage)
				if isGood then
					self.officalImage:setSpriteFrame("frame_touxiangkuang_01.png")
				else
					self.officalImage:setSpriteFrame("frame_touxiangkuang_02.png")
				end
				if self.hegemonOfficialType == 1 then
					self.officalIcon:setScale(0.45)
				end
				if isGood then
					self:crownUpEffect(self.officalIcon)
				end
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.ATLANTIS or showOfficialType == gShowOfficialType.NEBULA or showOfficialType == gShowOfficialType.NEBULA2 or showOfficialType == gShowOfficialType.NEBULA_EMPEROR then
			lordInfoCtrl = gShowOfficialType.NEBULA_EMPEROR
			gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.ATLANTIS] = self.atlantisOfficialType
			gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.NEBULA] = self.nebulaOfficialID
			gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.NEBULA2] = self.nebulaOfficialID2
			local gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.NEBULA_EMPEROR], config = self.emperorOfficial, gShowOfficialType.NEBULA_EMPEROR
			self:lazyCreateOfficalImage()
			self.officalImage:setScale(1.0)
			if showOfficialType == gShowOfficialType.NEBULA or showOfficialType == gShowOfficialType.NEBULA2 then
				self.officalIcon:setScale(0.5384615384615384)
			end
			local lordOfficialRead = include("lordOfficialRead")
			local officialImage = lordOfficialRead.getOfficialIcon(showOfficialType, config[showOfficialType])
			if officialImage then
				self.officalIcon:setSpriteFrame(officialImage)
				self.officalImage:setSpriteFrame("frame_touxiangkuang_01.png")
				self:crownUpEffect(self.officalIcon)
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		else
			hide = true
		end
	end
	if hide and self.officalImage and self.officalImage:isVisible() then
		self.officalImage:setVisible(false)
		self.officalIcon:removeAllChildren()
	end
end
function worldMapBuildOfficer:lazyCreateOfficalImage()
	if self.officalImage == nil then
		local officalImage = display.newSprite("#frame_king_22.png")
		officalImage:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 150))
		officalImage:setScale(0.75)
		officalImage:addTo(self.target_, 5)
		local officialImaSize = officalImage:getContentSize()
		local officalIcon = display.newSprite("#icon_king.png")
		officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
		officalIcon:addTo(officalImage, 2)
		self.officalImage = officalImage
		self.officalIcon = officalIcon
	else
		self.officalImage:setScale(0.75)
		self.officalIcon:setScale(1.0)
		self.officalImage:setVisible(true)
		self.officalIcon:removeAllChildren()
	end
end
function worldMapBuildOfficer:updateOfficeIcon(...)
	if self.officalImage then
		_ENV = nil
		;(nil).byUID = true
		local isShow = SoraDConfigGet("Game:worldMapOfficeIcon:OfficeIcon~bool", nil)
		if isShow == nil then
			isShow = true
		end
		local worldMapBuildEffect = self.target_:getBuildCom("worldMapBuildEffect")
		self.node_snowMan = worldMapBuildEffect:getNodeSnowMan()
		if self.node_snowMan then
			isShow = false
		end
		self.isShowOffice = isShow
		self:updateOfficial()
	end
end
function worldMapBuildOfficer:crownUpEffect(node)
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_castle_officer_01.plist"
	_ENV, (nil)[1], (nil).scale = nil, nil, 1.1
	;(nil).plist = "et_castle_officer_02.plist"
	;(nil)[2], (nil).scale = nil, 1.3
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(node:getContentSize().width / 2, node:getContentSize().height / 2))
	parNode:addTo(node)
end
function worldMapBuildOfficer:crownDownEffect(node)
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_cwgz_01.plist"
	;(nil)[1], (nil).scale = nil, 1.45
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(node:getContentSize().width / 2, node:getContentSize().height / 2))
	parNode:addTo(node)
end
function worldMapBuildOfficer:checkLeaguedOfficialType(...)
	return self.leaguedOfficialType <= 0 and legendLordCtrl:getIsSelfLegendKing()
end
function worldMapBuildOfficer:checkKingStarOfficialType(...)
	return self.kingStarOfficialType <= 0 and kingStarCtrl:getIsSelfLegendKing()
end
function worldMapBuildOfficer:checkHegemonOfficialType(...)
	return self.hegemonOfficialType <= 0 and hegemonCtrl:getIsSelfHegemon()
end
function worldMapBuildOfficer:getOfficalImage(...)
	return self.officalImage
end
return worldMapBuildOfficer
