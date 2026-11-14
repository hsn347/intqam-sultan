local lordLocalData = include("lordLocalData")
local worldEscortAidAddition = class("worldEscortAidAddition", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldEscortAidAddition")
	end
	return target
end)
function worldEscortAidAddition:ctor()
	self.troopsList, _ENV, self.scrollItems, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2324"))
	self.head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_armyCount = SoraDGetChildByName(self, "text_armyCount")
	self.node_attribute = SoraDGetChildByName(self, "Node_attribute")
	self.text_attr = SoraDGetChildByName(self, "Text_attr")
	SoraDToCenter(self.node_attribute, 80)
	self.text_attr:setString(i18n("common_text_2353"))
	self.text_defense = SoraDGetChildByName(self, "text_def")
	self.text_atk = SoraDGetChildByName(self, "text_atk")
	self.text_life = SoraDGetChildByName(self, "text_life")
	self.scroll = SoraDGetChildByName(self, "ScrollView_troops")
end
function worldEscortAidAddition:initWithData(data)
	dump(data, "援助加成界面===============================", 10)
	if data.assistBattlePlus then
		local akPlus = data.assistBattlePlus.akPlus or 0
		local dfPlus = data.assistBattlePlus.dfPlus or 0
		local hpPlus = data.assistBattlePlus.hpPlus or 0
		_ENV = nil
		;(nil).title = i18n("common_text_320")
		;(nil).value = dfPlus / 10
		self.text_defense:setString(i18n("common_text_1298", nil))
		_ENV = i18n("common_text_1298", nil)
		i18n("common_text_1298", nil).title = i18n("common_text_321")
		i18n("common_text_1298", nil).value = hpPlus / 10
		self.text_life:setString(i18n("common_text_1298", i18n("common_text_1298", nil)))
		_ENV = i18n("common_text_1298", i18n("common_text_1298", nil))
		i18n("common_text_1298", i18n("common_text_1298", nil)).title = i18n("common_text_319")
		i18n("common_text_1298", i18n("common_text_1298", nil)).value = akPlus / 10
		self.text_atk:setString(i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_1298", nil))))
	end
	local playerName = data.assistorInfo.nickName
	local playerID = data.assistorInfo.uid
	local imageId = data.assistorInfo.imageId
	local avatar = data.assistorInfo.avatar
	local level = data.assistorInfo.level
	_ENV = i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_1298", nil)))
	i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_1298", nil))).lv = level
	i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_1298", nil))).name = playerName
	self.text_name:setString(i18n("common_text_134", i18n("common_text_1298", i18n("common_text_1298", i18n("common_text_1298", nil)))))
	self.head:setHeadSprite(imageId, avatar)
	self.head:setPlayerID(playerID)
	if data.assistArmy then
		self.troopsList = data.assistArmy[1]
	end
	if not self.troopsList then
		return
	end
	local listHeight = 0
	if self.troopsList.heroInfo and next(self.troopsList.heroInfo) then
		self.heroShowBanner = include("heroShowBanner").new()
		self.heroShowBanner:addTo(self.scroll)
		self.heroShowBanner:initData(self.troopsList.heroInfo)
		listHeight = listHeight + (120 + self.heroShowBanner:getExtendHeight())
	end
	if self.troopsList.armsInfo and next(self.troopsList.armsInfo) then
		self.artifactShowBanner = include("artifactShowBanner").new()
		self.artifactShowBanner:addTo(self.scroll)
		self.artifactShowBanner:initData(self.troopsList.armsInfo)
	end
	if self.troopsList.divineBeastInfo and next(self.troopsList.divineBeastInfo) then
		self.divineBeastBanner = SoraDCreatePanel("commonDivinebeast")
		self.divineBeastBanner:setScale(0.85)
		self.divineBeastBanner:addTo(self.scroll)
		self.divineBeastBanner:initData(self.troopsList.divineBeastInfo[1], 2)
	end
	if self.artifactShowBanner or self.divineBeastBanner then
		listHeight = listHeight + 120
	end
	local totalCount = 0
	if self.troopsList.armyList then
		for i, v in ipairs(self.troopsList.armyList) do
			local item = include("commonArmySingle").new()
			item:initData(v)
			item:addTo(self.scroll)
			totalCount = totalCount + v.num
			listHeight = listHeight + 100
			self.scrollItems[i] = item
		end
		local count = string.formatnumberthousands(totalCount)
		_ENV = include("commonArmySingle").new()
		include("commonArmySingle").new().count = count
		self.text_armyCount:setString(i18n("common_text_466", (include("commonArmySingle").new())))
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local totalPosY = sH
	if self.heroShowBanner then
		self.heroShowBanner:setPosition(cc.p(sSize.width / 2, totalPosY))
		totalPosY = totalPosY - 120
	end
	if self.artifactShowBanner then
		self.artifactShowBanner:setPosition(cc.p(sSize.width / 2, totalPosY))
	end
	if self.divineBeastBanner then
		if self.artifactShowBanner == nil then
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 490 or 90)
		else
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or 380)
		end
		self.divineBeastBanner:setPositionY(totalPosY - 60)
	end
	if self.artifactShowBanner or self.divineBeastBanner then
		totalPosY = totalPosY - (120 + (self.heroShowBanner and self.heroShowBanner:getExtendHeight() or 0))
	end
	for k, v in ipairs(self.scrollItems) do
		v:setPosition(sSize.width / 2, totalPosY - k * 100 + 10)
	end
end
return worldEscortAidAddition
