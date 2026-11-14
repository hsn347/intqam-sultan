local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local CityEffectInfoRead = include("cityEffectInfoRead")
local worldMapDefine = include("worldMapDefine")
local armyDesRead = include("armyDesRead")
local WorldMapResOccupyView = class("worldMapResOccupyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapResOccupyView")
	end
	return target
end)
function WorldMapResOccupyView:ctor()
	self.occupyData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch")
	self.collSpeed = 0
	self.alreadyCollCount = 0
	self.canMaxWeight = 0
	self.allTime = 0
	self.currentAllCollCount = 0
	self.totalArmyCount = 0
	self.timer = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.imgRes = SoraDGetChildByName(self, "Image_res")
	self.txtCollected = SoraDGetChildByName(self, "Text_alreadyCollect")
	self.txtCollSpeed = SoraDGetChildByName(self, "Text_collectSpeed")
	self.txtResTotalTip = SoraDGetChildByName(self, "Text_resTotalTip")
	self.txtResTotal = SoraDGetChildByName(self, "Text_resTotal")
	self.txtAddColl = SoraDGetChildByName(self, "Text_additionCollect")
	self.btnAddition = SoraDGetChildByName(self, "Button_btnAddition")
	self.scroll = SoraDGetChildByName(self, "ScrollView_armyList")
	self.imgBg = SoraDGetChildByName(self, "Image_frmBg")
	self.spResType = SoraDGetChildByName(self, "Sprite_resType")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtArmyTip = SoraDGetChildByName(self, "Text_armyTip")
	self.txtAllianceOwnerTip = SoraDGetChildByName(self, "Text_allianceOwnerTip")
	self.txtBelongAlliance = SoraDGetChildByName(self, "Text_allianceOwner")
	self.txtAllianceTaxTip = SoraDGetChildByName(self, "Text_allianceTaxTip")
	self.txtAllianceTax = SoraDGetChildByName(self, "Text_allianceTax")
	self.txtPlayerName = SoraDGetChildByName(self, "Text_collectPerson")
	self.imgAdditionBg = SoraDGetChildByName(self, "Image_additionBg")
	self.txtAdditionCollectTip = SoraDGetChildByName(self, "Text_additionCollectTip")
	self.txtAlreadyCollectTip = SoraDGetChildByName(self, "Text_alreadyCollectTip")
	self.imgAlreadyBg = SoraDGetChildByName(self, "Image_alreadyBg")
	self.nodeSpeed = SoraDGetChildByName(self, "Node_speed")
	self.txtResTotalTip:setString(i18n("common_text_574"))
	SoraDGetChildByName(self, "Text_collectSpeedTip"):setString(i18n("common_text_572"))
	self.txtAllianceOwnerTip:setString(i18n("common_text_2907"))
	self.txtAllianceTaxTip:setString(i18n("common_text_2908"))
	SoraDGetChildByName(self, "Text_collectPersonTip"):setString(i18n("common_text_2909"))
	self.txtAlreadyCollectTip:setString(i18n("common_text_573"))
	self.txtAdditionCollectTip:setString(i18n("common_text_571"))
	self.txtTip:setString(i18n("common_text_469"))
	self.txtArmyTip:setString(i18n("common_text_474"))
	self.txtBelongAlliance:setString(i18n("common_text_480"))
	self.txtPlayerName:setString(i18n("common_text_480"))
	self.txtAllianceTax:setString("0%")
	self.txtCollSpeed:setString("0/h")
	self.btnAddition:setVisible(false)
	self.btnAddition:setTitleText(i18n("common_text_473"))
	self.btnAddition:addTouchEventListener(handler(self, self.btnAdditionClick))
end
function WorldMapResOccupyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_COLLECTING_INFO", handler(self, self.bindData))
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.handle = buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.req4BuffAdd))
end
function WorldMapResOccupyView:onExitPanel()
	if self.handle then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		buffCtrl:removeEventListener(self.handle)
	end
end
function WorldMapResOccupyView:req4BuffAdd(...)
	SoraDShowLoading(self.imgBg)
	if self.occupyData then
		local getMapCtrl = kingdomMapCtrl:reqGetCollectingInfo(self.occupyData.bPos.x, self.occupyData.bPos.y, self.occupyData.insID)
	end
end
function WorldMapResOccupyView:initData(reData)
	dump(reData, "WorldMapResOccupyView:initData", 10)
	self.occupyData.insID = reData.insID
	self.occupyData.name = worldMapDefine.getResourceName(reData.classID)
	self.occupyData.level = worldMapDefine.getResourceLevel(reData.classID)
	self.occupyData.resType = worldMapDefine.getResourceType(reData.classID)
	self.occupyData.bPos = reData.resPos
	if self.occupyData.resType == 1 then
		self.txtAdditionCollectTip:setVisible(false)
		self.imgAdditionBg:setVisible(false)
		self.btnAddition:setVisible(false)
		self.txtAddColl:setVisible(false)
		self.txtTip:setVisible(false)
	else
		self.btnAddition:setVisible(true)
	end
	local resDesRead = include("resDesRead")
	_UPVALUE6_ = "resDesRead"
	_ENV, ("resDesRead")[1] = gIDDef.GOLD, gIDDef.GOLD
	_ENV, ("resDesRead")[2] = gIDDef.GOLD, gIDDef.FOOD
	_ENV, ("resDesRead")[3] = gIDDef.GOLD, gIDDef.WOOD
	_ENV, ("resDesRead")[4] = gIDDef.GOLD, gIDDef.IRON
	_ENV, ("resDesRead")[5] = gIDDef.GOLD, gIDDef.MITHRIL
	local _ENV, ("resDesRead")[6], tableResID = gIDDef.GOLD, gIDDef.CRYSTAL, "resDesRead"
	gIDDef.GOLD[gIDDef.GOLD] = "Map_build_gold.png"
	gIDDef.GOLD[gIDDef.FOOD] = "Map_build_food.png"
	gIDDef.GOLD[gIDDef.WOOD] = "Map_build_wood.png"
	gIDDef.GOLD[gIDDef.IRON] = "Map_build_iron.png"
	gIDDef.GOLD[gIDDef.MITHRIL] = "Map_build_silver.png"
	local gIDDef.GOLD[gIDDef.CRYSTAL], tableResPng = "Map_build_crystal.png", gIDDef.GOLD
	local _ENV, tableResImg = gIDDef.CRYSTAL, gIDDef.CRYSTAL
	for _, v in ipairs(tableResID) do
		table.insert(tableResImg, resDesRead.getIcon(v))
	end
	self.spResType:setSpriteFrame(tableResImg[self.occupyData.resType])
	self.imgRes:loadTexture(tableResPng[tableResID[self.occupyData.resType]], ccui.TextureResType.plistType)
	_ENV = nil
	;(nil).level = self.occupyData.level
	;(nil).resName = self.occupyData.name
	self.ccs_bg:setTitleName(i18n("common_text_472", nil) .. "(" .. self.occupyData.bPos.x .. "," .. self.occupyData.bPos.y .. ")")
	SoraDShowLoading(self.imgBg)
	local getMapCtrl = kingdomMapCtrl:reqGetCollectingInfo(self.occupyData.bPos.x, self.occupyData.bPos.y, self.occupyData.insID)
end
function WorldMapResOccupyView:initDataFromWar(redata)
	dump(redata, "WorldMapResOccupyView:initData", 10)
	self.occupyData.insID = redata.insID
	self.occupyData.name = worldMapDefine.getWarTreasureBuildingName(redata.classID)
	self.occupyData.icon = worldMapDefine.getWarTreasureBuildingIcon(redata.classID)
	self.occupyData.level = worldMapDefine.getWarTreasureBuildingLv(redata.classID)
	self.occupyData.image = worldMapDefine.getWarTreasureBuildingImage(redata.classID)
	self.occupyData.bPos = redata.resPos
	self.occupyData.classID = redata.classID
	self.occupyData.reward = worldMapDefine.getWarTreasureReward(redata.classID)
	self.txtAdditionCollectTip:setVisible(false)
	self.imgAdditionBg:setVisible(false)
	self.btnAddition:setVisible(false)
	self.txtAddColl:setVisible(false)
	self.txtTip:setVisible(false)
	self.spResType:setSpriteFrame(self.occupyData.icon)
	self.spResType:setScale(0.4)
	self.imgRes:ignoreContentAdaptWithSize(true)
	self.imgRes:setPositionY(550)
	self.imgRes:loadTexture(self.occupyData.image, ccui.TextureResType.plistType)
	_ENV = nil
	;(nil).level = self.occupyData.level
	;(nil).resName = self.occupyData.name
	self.ccs_bg:setTitleName(i18n("common_text_472", nil) .. "(" .. self.occupyData.bPos.x .. "," .. self.occupyData.bPos.y .. ")")
	self.occupyData.total = redata.data.outputNum
	self.occupyData.baseTotal = redata.data.remainNum
	self.occupyData.collSpeedRaw = (redata.data.outputSpeed or 0) * 60
	self.occupyData.collSpeedPlus = math.floor(redata.data.collectTerrPlusSpeed or 0)
	self.occupyData.collSpeed = math.floor(self.occupyData.collSpeedRaw)
	if not redata.data.army or not redata.data.army[1].armyList then
		_ENV = redata.data.army[1].armyList
	end
	self.occupyData.armyList = redata.data.army[1].armyList
	if not redata.data.heroInfo or not redata.data.heroInfo then
		_ENV = redata.data.heroInfo
	end
	self.occupyData.heroList = redata.data.heroInfo
	if not redata.data.armsInfo or not redata.data.armsInfo then
		_ENV = redata.data.armsInfo
	end
	self.occupyData.armsList = redata.data.armsInfo
	if not redata.data.divineBeastInfo or not redata.data.divineBeastInfo then
		_ENV = redata.data.divineBeastInfo
	end
	self.occupyData.divineBeastList = redata.data.divineBeastInfo
	self.occupyData.playerName = redata.playerName
	self.occupyData.allianceAbbr = redata.leagueName
	self.occupyData.playerWeight = 999999
	self.occupyData.isOccupied = self.occupyData.playerName and true or false
	self.beginCollectTime = redata.data.collStartTime or 0
	self.occupyData.alreadyColl = (serviceFunctions.systemTime() - self.beginCollectTime) * self.occupyData.collSpeed / 3600
	_ENV = self.occupyData.bPos.x
	self.occupyData.bPos.x.name = self.occupyData.name
	self.txtTip:setString(i18n("warSecrit_text_31", self.occupyData.bPos.x))
	self:initView()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function WorldMapResOccupyView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WAR_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function WorldMapResOccupyView:bindData(target, redata)
	SoraDCloseLoading(self.imgBg)
	dump(redata, "WorldMapResOccupyView:bindData")
	local multiple = self.occupyData.resType == 1 and 1000 or self.occupyData.resType == 4 and 6 or self.occupyData.resType == 5 and 24 or self.occupyData.resType == 6 and 96 or 1
	self.occupyData.total = redata.data.totalSourceNum
	self.occupyData.baseTotal = self.occupyData.total * multiple
	self.occupyData.alreadyColl = redata.data.currentCollectNum
	self.occupyData.collSpeedRaw = redata.data.collectSpeed
	self.occupyData.collSpeed = math.floor(redata.data.collectSpeed)
	self.occupyData.collSpeedPlus = math.floor(redata.data.collectTerrPlusSpeed)
	if not redata.data.army then
		_ENV = redata.data.army
	end
	self.occupyData.armyList = redata.data.army
	if not redata.data.heroInfo then
		_ENV = redata.data.heroInfo
	end
	self.occupyData.heroList = redata.data.heroInfo
	if not redata.data.armsInfo then
		_ENV = redata.data.armsInfo
	end
	self.occupyData.armsList = redata.data.armsInfo
	if not redata.data.divineBeastInfo then
		_ENV = redata.data.divineBeastInfo
	end
	self.occupyData.divineBeastList = redata.data.divineBeastInfo
	self.occupyData.tax = redata.data.taxRate
	self.occupyData.allianceAbbr = redata.data.allianceAbbr
	self.occupyData.playerName = redata.data.playerName
	self.occupyData.belongAlliance = redata.data.terr[1]
	self.occupyData.playerWeight = redata.data.armyWeight
	self.occupyData.isOccupied = redata.data.playerName and true or false
	self:initView()
end
local getFormatedString = function(num)
	local formatnum = string.format("%0.2f", (num * 100 + 0.05) * 0.01)
	local formatted = formatnum
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	print(num, formatnum, formatted, string.formatnumberthousands(formatnum))
	return formatted
end
function WorldMapResOccupyView:initView(...)
	if self.occupyData.playerName then
		if self.occupyData.allianceAbbr then
			_ENV = nil
			;(nil).abbr = self.occupyData.allianceAbbr
			;(nil).name = self.occupyData.playerName
			self.txtPlayerName:setString(i18n("common_text_186", nil))
		else
			self.txtPlayerName:setString(self.occupyData.playerName)
		end
	else
		self.txtPlayerName:setString(i18n("common_text_480"))
	end
	if self.occupyData.belongAlliance and next(self.occupyData.belongAlliance) then
		self.txtBelongAlliance:setString("(" .. self.occupyData.belongAlliance.leagueAbbrName .. ")" .. self.occupyData.belongAlliance.leagueName)
	else
		self.txtBelongAlliance:setString(i18n("common_text_480"))
	end
	if self.occupyData.resType ~= 6 and self.occupyData.tax then
		self.txtAllianceTax:setString(self.occupyData.tax / 10 .. "%")
	else
		self.txtAllianceTax:setString("0%")
	end
	self.txtResTotal:setString(string.formatnumberthousands(self.occupyData.total))
	self.txtCollSpeed:setString(getFormatedString(self.occupyData.collSpeedRaw) .. "+" .. string.formatnumberthousands(self.occupyData.collSpeedPlus) .. "/h")
	if SoraDFIsRA() then
		self.txtBelongAlliance:setPositionX(self.txtAllianceOwnerTip:getPositionX() - self.txtAllianceOwnerTip:getContentSize().width - 10)
		self.txtAllianceTax:setPositionX(self.txtAllianceTaxTip:getPositionX() - self.txtAllianceTaxTip:getContentSize().width - 10)
		self.spResType:setPositionX(self.txtResTotalTip:getPositionX() - self.txtResTotalTip:getContentSize().width - 30)
		self.txtResTotal:setPositionX(self.spResType:getPositionX() - self.spResType:getContentSize().width / 2 * self.spResType:getScaleX())
	else
		self.txtBelongAlliance:setPositionX(self.txtAllianceOwnerTip:getPositionX() + self.txtAllianceOwnerTip:getContentSize().width + 10)
		self.txtAllianceTax:setPositionX(self.txtAllianceTaxTip:getPositionX() + self.txtAllianceTaxTip:getContentSize().width + 10)
		self.spResType:setPositionX(self.txtResTotalTip:getPositionX() + self.txtResTotalTip:getContentSize().width + 30)
		self.txtResTotal:setPositionX(self.spResType:getPositionX() + self.spResType:getContentSize().width / 2 * self.spResType:getScaleX())
	end
	self.collSpeed = (self.occupyData.collSpeed + self.occupyData.collSpeedPlus) / 3600
	if self.occupyData.alreadyColl then
		self.alreadyCollCount = self.occupyData.alreadyColl
		self.txtCollected:setString(self.occupyData.alreadyColl)
	else
		self.txtCollected:setString("0")
	end
	if self.occupyData.playerWeight then
		self.canMaxWeight = self.occupyData.playerWeight
	end
	if self.occupyData.armyList and next(self.occupyData.armyList) then
		self.txtTip:setVisible(false)
	else
		self.txtTip:setVisible(true)
	end
	self.totalArmyCount = self:updateScroll()
	self.txtArmyTip:setColor(cc.c3b(255, 255, 255))
	if self.totalArmyCount > 0 then
		_ENV = cc.c3b(255, 255, 255)
		cc.c3b(255, 255, 255).count = self.totalArmyCount
		self.txtArmyTip:setString(i18n("common_text_466", cc.c3b(255, 255, 255)))
	elseif self.occupyData.isOccupied then
		self.btnAddition:setVisible(false)
		self.txtAddColl:setVisible(false)
		self.txtAdditionCollectTip:setVisible(false)
		self.imgAdditionBg:setVisible(false)
		self.txtAlreadyCollectTip:setVisible(false)
		self.imgAlreadyBg:setVisible(false)
		self.nodeSpeed:setPositionY(370)
		self.txtCollected:setVisible(false)
		_ENV = i18n("common_text_466", cc.c3b(255, 255, 255))
		i18n("common_text_466", cc.c3b(255, 255, 255)).count = "???"
		self.txtArmyTip:setString(i18n("common_text_466", i18n("common_text_466", cc.c3b(255, 255, 255))))
	else
		self.txtArmyTip:setString(i18n("common_text_2911"))
		self.txtArmyTip:setColor(cc.c3b(200, 155, 100))
	end
	self:additionTime()
	SoradCreateTimer(self, handler(self, self.additionTime))
	if self.occupyData.isOccupied then
		self.timer = SoradCreateTimer(self, handler(self, self.showCollect), true)
	else
		self.txtCollected:setVisible(false)
		self.txtAlreadyCollectTip:setVisible(false)
		self.imgAlreadyBg:setVisible(false)
		self.nodeSpeed:setPositionY(370)
	end
	if self.occupyData.reward and next(self.occupyData.reward) and not self.occupyData.isOccupied then
		local nodeParent = display.newNode()
		dump(self.occupyData.reward, "self.occupyData.reward", 10)
		for i, v in ipairs(self.occupyData.reward) do
			local item = include("commonItemAward").new()
			item:setScale(0.8)
			item:setBaseScale(1.0)
			item:setOwnView(self)
			item:setPosition(0, 0)
			item:addTo(nodeParent)
			item:initData(v.id, v.count)
		end
		SoraDToCenter(nodeParent, 100, SoraDFIsRA())
		nodeParent:addTo(self.txtTip:getParent())
		nodeParent:setPosition(self.txtTip:getPositionX(), self.txtTip:getPositionY() - 30)
		self.txtTip:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	end
end
function WorldMapResOccupyView:updateScroll()
	self.scroll:removeAllChildren()
	local totalH = #self.occupyData.armyList * 100
	if self.occupyData.heroList and next(self.occupyData.heroList) then
		local herosBanner = SoraDCreatePanel("heroShowBanner")
		herosBanner:setScale(0.85)
		herosBanner:initData(self.occupyData.heroList)
		herosBanner:addTo(self.scroll)
		totalH = totalH + (100 + herosBanner:getExtendHeight())
		self.herosBanner = herosBanner
	end
	if self.occupyData.armsList and next(self.occupyData.armsList) then
		totalH = totalH + 100
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, totalH)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	if self.occupyData.heroList and next(self.occupyData.heroList) then
		self.herosBanner:setPosition(260, sH - 10)
		sH = sH - (100 + self.herosBanner:getExtendHeight())
	end
	if self.occupyData.armsList and next(self.occupyData.armsList) then
		local artifactBanner = SoraDCreatePanel("artifactShowBanner")
		artifactBanner:setScale(0.85)
		artifactBanner:initData(self.occupyData.armsList)
		artifactBanner:setPosition(260, sH - 10)
		artifactBanner:addTo(self.scroll)
		self.artifactBanner = artifactBanner
	end
	if self.occupyData.divineBeastList and next(self.occupyData.divineBeastList) then
		self.divineBeastBanner = SoraDCreatePanel("commonDivinebeast")
		self.divineBeastBanner:setScale(0.85)
		if self.artifactBanner == nil then
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 450 or 60)
		else
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or 340)
		end
		self.divineBeastBanner:setPositionY(sH - 60)
		self.divineBeastBanner:addTo(self.scroll)
		self.divineBeastBanner:initData(self.occupyData.divineBeastList[1], 2)
	end
	if self.artifactBanner or self.divineBeastBanner then
		sH = sH - 100
	end
	local totalArmyCount = 0
	for i, v in ipairs(self.occupyData.armyList) do
		local item = include("commonArmySingle").new()
		item:initData(v)
		item:setPosition(260, sH - i * 100)
		item:addTo(self.scroll)
		totalArmyCount = totalArmyCount + v.num
	end
	return totalArmyCount
end
function WorldMapResOccupyView:showCollect(dt)
	self.allTime = self.allTime + dt
	self.currentAllCollCount = self.collSpeed * self.allTime
	local judgeCount = self.currentAllCollCount + self.alreadyCollCount
	if self.occupyData.baseTotal == nil or self.canMaxWeight == nil or judgeCount >= self.occupyData.baseTotal or judgeCount >= self.canMaxWeight then
		SoraDManagerRemoveTimer(self, self.timer)
		self:removeFromParent()
		return
	end
	self.txtCollected:setString(string.formatnumberthousands(math.floor(judgeCount)))
end
function WorldMapResOccupyView:additionTime(dt)
	self.occupyData.additionTime = buffCtrl:queryCityBuff(17)
	if self.occupyData.additionTime then
		local timeCount = self.occupyData.additionTime:getRemainTime()
		self.txtAddColl:setString(SoraDConvertSecondToString(timeCount or 0))
	else
		self.txtAddColl:setString(SoraDConvertSecondToString(0))
	end
end
function WorldMapResOccupyView:btnAdditionClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buffid = 17
		local buffData = buffCtrl:queryCityBuff(buffid)
		_ENV = buffCtrl
		buffCtrl.bid = buffid
		buffCtrl.buffname = CityEffectInfoRead.getName(buffid)
		buffCtrl.bufdes = CityEffectInfoRead.getDes(buffid)
		local buffCtrl.buftip, tableBuff = CityEffectInfoRead.getTip(buffid), buffCtrl
		_ENV = nil
		;(nil).tableBuff = tableBuff
		uiManager:show("citybuffItemView", nil)
	end
end
return WorldMapResOccupyView
