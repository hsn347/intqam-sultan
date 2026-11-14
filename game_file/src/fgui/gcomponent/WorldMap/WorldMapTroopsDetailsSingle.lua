local baseComponent = require("fgui.base.baseComponent")
local WorldMapTroopsDetailsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/WorldMapTroopsDetailsSingle", WorldMapTroopsDetailsSingle)
function WorldMapTroopsDetailsSingle:onInit()
	self:fixChildrenPos()
	if not SoraDFIsRA() then
		self.fields.n32:setScaleX(-1)
		self.fields.n33:setScaleX(-1)
	end
	self.divineBeastStarPos = self.fields.Com_armyDetail_divinebeast:getPositionX()
	self.fields.list_hero:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.list_lieutenant:setItemRenderer(handler(self, self.onLieutenantRenderer))
	self.fields.list_army:setTouchEnabled(false)
	self.fields.list_army:setItemRenderer(handler(self, self.onArmyRenderer))
	self.fields.Button_Back:addClickListener(handler(self, self.onBtnClick))
	self.fields.Button_Back:setString(i18n("common_text_302"))
end
function WorldMapTroopsDetailsSingle:onShow()
end
function WorldMapTroopsDetailsSingle:initData(armyList, allianceName, mapInstance)
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
	self.fields.Text_name:setString(nickName .. aName)
	local hArmy = 100
	if self.armyList.imageId then
		self.fields.icon_head:setHeadSprite(self.armyList.imageId, self.armyList.avatar)
	elseif self.armyList.buildIcon then
		self.fields.icon_head:setImage(self.armyList.buildIcon)
	else
		self.fields.icon_head:getLoadHead():setVisible(false)
	end
	local armyUid = self.armyList.uid or 0
	if self.armyList.isNpc or worldMapDefine.isInNewTrial() and armyUid == 0 then
		local namekey = "devilvalley_text_20"
		if mapInstance and mapInstance:getSiteClassID() == _G.gMapNewTrialBuildType.subMapTypeDVWCastle then
			namekey = "devilvalley_text_22"
		end
		self.fields.Text_name:setString(i18n(namekey))
		self.fields.icon_head:setImage("qlzjt_full.png")
	end
	local heroData = self.armyList.heroInfo
	self:setHeros(heroData)
	local armsData = self.armyList.armsInfo
	local divineBeastData = self.armyList.divineBeastInfo
	self:setArmsAndDivineBeast(armsData, divineBeastData)
	local totalCount = 0
	if self.armyList.armyList then
		for i, v in ipairs(self.armyList.armyList) do
			totalCount = totalCount + v.num
		end
		self:setArmyList(self.armyList.armyList)
		local count = string.formatnumberthousands(totalCount)
		_ENV = v.num
		v.num.count = count
		self.fields.Text_armyCount:setString(i18n("common_text_466", v.num))
	else
		self.fields.Text_armyCount:setString("")
	end
	if self.fields.Sprite_leader then
		self.fields.Sprite_leader:setVisible(self.armyList.isCaptain)
	end
	if self.armyList.hp and self.armyList.prehp then
		local num = math.ceil(self.armyList.hp / self.armyList.prehp)
		if 0 < num then
			self.fields.Text_num:setVisible(true)
			_ENV = i18n("common_text_466", v.num)
			i18n("common_text_466", v.num).num = num
			self.fields.Text_num:setString(i18n("brightWar_text_148", i18n("common_text_466", v.num)))
		end
	end
	self.fields.layout:ensureBoundsCorrect()
end
function WorldMapTroopsDetailsSingle:setHeros(heros)
