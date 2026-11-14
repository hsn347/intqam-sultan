local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local WorldMapTroopsDetailsSingle = class("worldMapTroopsDetailsSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapTroopsDetailsSingle")
	end
	return target
end)
function WorldMapTroopsDetailsSingle:ctor()
	self.armyList, _ENV = nil, nil
	self.txtCount = SoraDGetChildByName(self, "Text_armyCount")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.icon_head = SoraDGetChildByName(self, "icon_head")
	self.spLeader = SoraDGetChildByName(self, "Sprite_leader")
end
function WorldMapTroopsDetailsSingle:initData(armyList, allianceName, mapInstance, scroll)
	self.armyList = armyList
	local _ENV, selfarmyList
	if self.armyList.armyList then
		for _, v in ipairs(self.armyList.armyList) do
			if v.num > 0 then
				table.insert(selfarmyList, v)
			end
		end
	end
	self.armyList.armyList = selfarmyList
	allianceName = self.armyList.abbr or allianceName or ""
	local aName = allianceName == "" and "" or "(" .. allianceName .. ")"
	local nickName = self.armyList.nickName or ""
	self.txtName:setString(nickName .. aName)
	local hArmy = 100
	if self.armyList.imageId then
		SoraDGetHeadFromManager(self.icon_head, self.armyList.imageId, self.armyList.avatar)
	elseif self.armyList.buildIcon then
		self.icon_head:setSpriteFrame(self.armyList.buildIcon)
		self.icon_head:setScale(1.2)
	else
		self.icon_head:setVisible(false)
	end
	local armyUid = self.armyList.uid or 0
	if self.armyList.isNpc or worldMapDefine.isInNewTrial() and armyUid == 0 then
		local namekey = "devilvalley_text_20"
		if mapInstance and mapInstance:getSiteClassID() == _G.gMapNewTrialBuildType.subMapTypeDVWCastle then
			namekey = "devilvalley_text_22"
		end
		self.txtName:setString(i18n(namekey))
		self.icon_head:setSpriteFrame("qlzjt_full.png")
		self.icon_head:setScale(1.1)
		self.icon_head:setVisible(true)
	end
	local heroData = self.armyList.heroInfo
	if heroData and next(heroData) then
		self.heroShowBanner = include("heroShowBanner").new()
		self.heroShowBanner:addTo(self)
		self.heroShowBanner:initData(heroData, scroll)
		hArmy = hArmy + (140 + self.heroShowBanner:getExtendHeight())
		self.heroShowBanner:setPosition(cc.p(0, -(hArmy - (120 + self.heroShowBanner:getExtendHeight()))))
		self.heroShowBanner:setLineVisible(true)
	end
	local armsData = self.armyList.armsInfo
	local divineBeastData = self.armyList.divineBeastInfo
	if armsData and next(armsData) or divineBeastData and next(divineBeastData) then
		hArmy = hArmy + 120
	end
	local artifactShowBanner
	if armsData and next(armsData) then
		artifactShowBanner = include("artifactShowBanner").new()
		artifactShowBanner:addTo(self)
		artifactShowBanner:setPosition(cc.p(0, -(hArmy - 120)))
		artifactShowBanner:initData(armsData, scroll)
		artifactShowBanner:setLineVisible(true)
	end
	if divineBeastData and next(divineBeastData) then
		local divineBeastBanner = include("commonDivinebeast").new()
		divineBeastBanner:addTo(self)
		if artifactShowBanner == nil then
			divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or -200)
		else
			divineBeastBanner:setPositionX(SoraDFIsRA() and -90 or 90)
		end
		divineBeastBanner:setPositionY(-(hArmy - 60))
		divineBeastBanner:initData(divineBeastData[1], 2)
	end
	local totalCount = 0
	if self.armyList.armyList then
		for i, v in ipairs(self.armyList.armyList) do
			local item = include("commonArmySingle").new()
			item:initData(v)
			item:addTo(self)
			item:setPosition(0, -i * 100 - hArmy)
			totalCount = totalCount + v.num
		end
		local count = string.formatnumberthousands(totalCount)
		_ENV = include("commonArmySingle").new()
		include("commonArmySingle").new().count = count
		self.txtCount:setString(i18n("common_text_466", (include("commonArmySingle").new())))
	else
		self.txtCount:setString("")
	end
	if self.spLeader then
		self.spLeader:setVisible(self.armyList.isCaptain)
	end
	if self.armyList.hp and self.armyList.prehp then
		local num = math.ceil(self.armyList.hp / self.armyList.prehp)
		if 0 < num then
			local txtNum = SoraDGetChildByName(self, "Text_num")
			txtNum:setVisible(true)
			_ENV = i18n("common_text_466", (include("commonArmySingle").new()))
			i18n("common_text_466", (include("commonArmySingle").new())).num = num
			txtNum:setString(i18n("brightWar_text_148", i18n("common_text_466", (include("commonArmySingle").new()))))
		end
	end
end
function WorldMapTroopsDetailsSingle:getSingleH()
	local height = 100
	if self.armyList.heroInfo and next(self.armyList.heroInfo) then
		height = height + 140 + self.heroShowBanner:getExtendHeight()
	end
	if self.armyList.armsInfo and next(self.armyList.armsInfo) or self.armyList.divineBeastInfo and next(self.armyList.divineBeastInfo) then
		height = height + 140
	end
	if self.armyList.armyList then
		height = height + math.ceil(#self.armyList.armyList) * 100
	end
	return height
end
function WorldMapTroopsDetailsSingle:setBackHandle(handle)
	self.backHandle = handle
	if not self.button then
		self:initBackButton()
	end
	self.button:setVisible(true)
end
function WorldMapTroopsDetailsSingle:onBtnClick(target, event)
	local armyUid = self.armyList.uid
	if self.backHandle then
		self.backHandle(armyUid)
	end
end
function WorldMapTroopsDetailsSingle:initBackButton(...)
	local Panel_1 = SoraDGetChildByName(self, "Panel_1")
	local button = ccui.Button:create("btn_red_small_01.png", "btn_red_small_02.png", nil, ccui.TextureResType.plistType)
	button:setPosition(cc.p(SoraDFPosX(100, 576), 50))
	button:addTo(Panel_1)
	button:setSwallowTouches(false)
	button:setTitleText(i18n("common_text_302"))
	button:setTitleFontSize(24)
	SoraDAutoSizeButtonTextByContent(button)
	button = SoraDCreatePanelByCloneNode(button, "commonBtnInstance")
	button:setHandle(handler(self, self.onBtnClick))
	self.button = button
end
return WorldMapTroopsDetailsSingle
