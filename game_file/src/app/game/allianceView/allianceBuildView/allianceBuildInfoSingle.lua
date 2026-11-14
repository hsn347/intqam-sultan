local gametop = gModuleMgr.getObject("gametop")
local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local AllianceBuildInfoSingle = class("allianceBuildInfoSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildInfoSingle")
	end
	return target
end)
function AllianceBuildInfoSingle:ctor()
	self.tableArmy, _ENV, self.tableMemberData, _ENV = nil, nil, nil, nil
	self.type = gAWarRallyMemberType.LOCK
	self.buildSingle = nil
	self.handle = nil
	self.isCaptain = false
	self.isLaunched = false
	self.maxCount = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.dispatchPanel = nil
	self.imgMemberBg = SoraDGetChildByName(self, "Image_memberBg")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeMemeber = SoraDGetChildByName(self, "Node_memeber")
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.imgFrame = SoraDGetChildByName(self, "Image_4")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.layerMember = SoraDGetChildByName(self, "Panel_member")
	self.layerTouch:setSwallowTouches(false)
	self.layerMember:setSwallowTouches(false)
	self.btnRepatriate = SoraDGetChildByName(self, "Button_repatriate")
	self.btnRepatriate:setTitleText(i18n("common_text_302"))
	self.btnRepatriate:setVisible(false)
	if self.btnRepatriate then
		self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnRepatriate:addTouchEventListener(handler(self, self.btnBackClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE", function(target, data)
		if data.maxMassNum and data.massNum and self.maxCount ~= data.maxMassNum - data.massNum then
			self.maxCount = data.maxMassNum - data.massNum
			if data.maxMassNum == 0 then
				self.maxCount = nil
				self.dispatchPanel = nil
			end
			if self.dispatchPanel and SoraDSearchPanelFromManager(self.dispatchPanel) then
				self.dispatchPanel:updateMaxCount(self.maxCount)
			else
				self.dispatchPanel = nil
			end
			self:updateOpenShow(data.maxMassNum > 0 and self.maxCount <= 0)
		end
	end)
end
function AllianceBuildInfoSingle:updateOpenShow(isFull)
	if self.type == gAWarRallyMemberType.OPEN then
		if isFull and self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
			self.imgHead:getVirtualRenderer():setState(1)
			self.labelNotice:setString(i18n("common_text_2141"))
		else
			self.imgHead:getVirtualRenderer():setState(0)
			if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
				_ENV = i18n("common_text_2141")
				i18n("common_text_2141").build = allianceDesRead.getBuildName(self.buildSingle:getBID())
				self.labelNotice:setString(i18n("common_text_2138", i18n("common_text_2141")))
			elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
				self.labelNotice:setString(i18n("common_text_2143"))
			end
		end
	end
end
function AllianceBuildInfoSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBuildInfoSingle:getSingleH()
	return self.layerTouch:getContentSize().height + (self.layerMember:getContentSize().height > 0 and self.layerMember:getContentSize().height or 0)
end
function AllianceBuildInfoSingle:setClickCallBack(handle)
	self.handle = handle
end
function AllianceBuildInfoSingle:initData(data, type, buildSingle)
	self.tableMemberData = data
	self.type = type
	self.buildSingle = buildSingle
	if self.type == gAWarRallyMemberType.LOCK then
		self:showLockSingle()
	elseif self.type == gAWarRallyMemberType.OPEN then
		self:showOpenSingle()
	elseif self.type == gAWarRallyMemberType.FULL then
		self:showMemberSingle()
	elseif self.type == gAWarRallyMemberType.CLOSED then
		self:showClosedSingle()
	end
end
function AllianceBuildInfoSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeArmy()
		self.spriteArr:setRotation(SoraDFPosX(90, 0))
	else
		self:initArmy()
		self.spriteArr:setRotation(0)
	end
	self.isLaunched = state
end
function AllianceBuildInfoSingle:getState()
	return self.isLaunched
end
function AllianceBuildInfoSingle:showMember(isShow)
	self.nodeMemeber:setVisible(isShow)
	self.labelNotice:setVisible(not isShow)
	if not isShow then
		self:setState(isShow)
	end
end
function AllianceBuildInfoSingle:updateMemberSingle()
	SoraDGetHeadFromManager(self.imgHead, self.tableMemberData.headid, self.tableMemberData.avatar)
	self.imgHead:setLocalZOrder(1)
	self.imgFrame:setLocalZOrder(2)
	self.labelName:setString(self.tableMemberData.name)
	local armyCount = 0
	for i, v in ipairs(self.tableMemberData.army) do
		armyCount = armyCount + v.num
	end
	_ENV = nil
	;(nil).cur = string.formatnumberthousands(armyCount)
	self.labelCount:setString(i18n("common_text_297", nil))
	if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
		self.labelState:setString(i18n("common_text_043"))
	elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
		self.labelState:setString(i18n("common_text_830"))
	end
end
function AllianceBuildInfoSingle:showMemberSingle()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank == gAllianceRank.OFFICIAL then
		ownRank = gAllianceRank.R4 + 0.5
	end
	self:showMember(true)
	self:setState(self.isLaunched)
	local rank = self.tableMemberData.rank
	if rank == gAllianceRank.OFFICIAL then
		rank = gAllianceRank.R4 + 0.5
	end
	self.isCaptain = ownRank >= gAllianceRank.R4 and ownRank > rank
	self:updateMemberSingle()
end
function AllianceBuildInfoSingle:showLockSingle()
	self:showMember(false)
	self:setState(false)
	self.imgHead:loadTexture("icon_fight_block.png", ccui.TextureResType.plistType)
	self.imgHead:setLocalZOrder(2)
	self.imgFrame:setLocalZOrder(1)
	if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD and self.buildSingle:getMaxNumOfQueue() == 1 then
		self.labelNotice:setString(i18n("common_text_2285"))
	else
		self.labelNotice:setString(i18n("common_text_304"))
	end
end
function AllianceBuildInfoSingle:showClosedSingle()
	self:showMember(false)
	self:setState(false)
	self.imgHead:loadTexture("icon_fight_block.png", ccui.TextureResType.plistType)
	self.imgHead:setLocalZOrder(2)
	self.imgFrame:setLocalZOrder(1)
	self.labelNotice:setString(i18n("common_text_2141"))
end
function AllianceBuildInfoSingle:showOpenSingle()
	self:showMember(false)
	self:setState(false)
	self.imgHead:loadTexture("icon_fight_add.png", ccui.TextureResType.plistType)
	self.imgHead:setLocalZOrder(2)
	self.imgFrame:setLocalZOrder(1)
	if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
		_ENV = nil
		;(nil).build = allianceDesRead.getBuildName(self.buildSingle:getBID())
		self.labelNotice:setString(i18n("common_text_2138", nil))
	elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
		self.labelNotice:setString(i18n("common_text_2143"))
	end
end
function AllianceBuildInfoSingle:initArmy()
	local heroData = self.tableMemberData.heroInfo
	local armsData = self.tableMemberData.armsInfo
	local divineBeastData = self.tableMemberData.divineBeastInfo
	local captainH = self.isCaptain and 70 or 0
	local panelH = 100 * math.ceil(#self.tableMemberData.army) + captainH + 30
	local hArmy = 100
	local hHero = 0
	local hArms = 0
	local posX = SoraDFPosX(320)
	if heroData and next(heroData) then
		local heroShowBanner = include("heroShowBanner").new()
		heroShowBanner:addTo(self.layerMember)
		heroShowBanner:initData(heroData)
		hHero = 140 + heroShowBanner:getExtendHeight()
		panelH = panelH + hHero
		self.heroShowBanner = heroShowBanner
	end
	if armsData and next(armsData) then
		local armsShowBanner = include("artifactShowBanner").new()
		armsShowBanner:addTo(self.layerMember)
		armsShowBanner:initData(armsData)
		self.armsShowBanner = armsShowBanner
	end
	if divineBeastData and next(divineBeastData) then
		self.divineBeastBanner = SoraDCreatePanel("commonDivinebeast")
		self.divineBeastBanner:setScale(0.85)
		self.divineBeastBanner:addTo(self.layerMember)
		self.divineBeastBanner:initData(divineBeastData[1], 2)
	end
	if self.armsShowBanner or self.divineBeastBanner then
		hArms = 140
		panelH = panelH + hArms
	end
	if self.heroShowBanner then
		self.heroShowBanner:setPosition(cc.p(posX, panelH + 70 - hArmy))
	end
	if self.armsShowBanner then
		self.armsShowBanner:setPosition(cc.p(posX, panelH + 70 - hArmy - hHero))
	end
	if self.divineBeastBanner then
		if self.armsShowBanner == nil then
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 550 or 90)
		else
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or 450)
		end
		self.divineBeastBanner:setPositionY(panelH + 10 - hArmy - hHero)
	end
	self.layerMember:setContentSize(cc.size(640, panelH))
	self.imgMemberBg:setContentSize(cc.size(640, panelH + 30))
	self.imgMemberBg:setPositionY(panelH + 30)
	if self.isCaptain then
		self.btnRepatriate:setVisible(true)
		self.btnRepatriate:setPositionY(-self:getSingleH() + 40)
	else
		self.btnRepatriate:setVisible(false)
	end
	for i, v in ipairs(self.tableMemberData.army) do
		local posY = panelH - i * 100 - hHero - hArms
		local single = self.tableArmy[i]
		if single == nil then
			single = include("commonArmySingle").new()
			single:addTo(self.layerMember)
			table.insert(self.tableArmy, single)
		end
		single:initData(v)
		single:setPosition(cc.p(posX, posY))
	end
end
function AllianceBuildInfoSingle:removeArmy()
	self.btnRepatriate:setVisible(false)
	self.imgMemberBg:setContentSize(cc.size(640, 30))
	self.imgMemberBg:setPositionY(30)
	for k, v in pairs(self.tableArmy) do
		v:removeFromParent()
	end
	self.layerMember:setContentSize(cc.size(640, 0))
	self.tableArmy, _ENV = self.layerMember.setContentSize, self.layerMember.setContentSize
	if self.heroShowBanner then
		self.heroShowBanner:removeFromParent()
		self.heroShowBanner = nil
	end
	if self.armsShowBanner then
		self.armsShowBanner:removeFromParent()
		self.armsShowBanner = nil
	end
	if self.divineBeastBanner then
		self.divineBeastBanner:removeFromParent()
		self.divineBeastBanner = nil
	end
end
function AllianceBuildInfoSingle:btnBackClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqBackQueueById(self.tableMemberData.queueId)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceBuildInfoSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local state = self.buildSingle:getBuildingStatus()
		if self.type == gAWarRallyMemberType.LOCK then
		elseif self.type == gAWarRallyMemberType.OPEN then
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			local ownUid = lordInfoCtrl:getLordInfo().base.uid
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
				if self.maxCount and self.maxCount <= 0 then
					return
				end
			elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
				local castleLv = tonumber(cityCtrl:getBuildCellByIndex(1050).info.lv)
				local bid = self.buildSingle:getBID()
				_ENV = self.buildSingle
				self.buildSingle[3721] = 6
				self.buildSingle[3722] = 6
				self.buildSingle[3723] = 10
				self.buildSingle[3724] = 15
				local self.buildSingle[3725], buildLv = 60, self.buildSingle
				if bid == 3725 and castleLv < buildLv[bid] then
					SoraDShowMsgTip(i18n("alliance_build_text_03"))
					return
				end
				if castleLv < buildLv[bid] then
					_ENV = i18n("alliance_build_text_03")
					i18n("alliance_build_text_03").lv = buildLv[bid]
					i18n("alliance_build_text_03").build = allianceDesRead.getBuildName(self.buildSingle:getBID())
					SoraDShowMsgTip(i18n("common_text_2225", i18n("alliance_build_text_03")), nil, button)
					return
				end
			end
			if kingdomMapCtrl:hasQueue2AllianceBuild(self.buildSingle:getIID()) then
				SoraDShowMsgTip(i18n("common_text_2223"), nil, button)
				return
			end
			if SoraDEnoughTroops() then
				local _ENV, _ENV, otherData = i18n("common_text_2223"), SoraDEnoughTroops(), SoraDEnoughTroops()
				i18n("common_text_2223")[3721] = gIDDef.FOOD
				i18n("common_text_2223")[3722] = gIDDef.WOOD
				i18n("common_text_2223")[3723] = gIDDef.IRON
				i18n("common_text_2223")[3724] = gIDDef.MITHRIL
				local i18n("common_text_2223")[3725], tableResID = gIDDef.ALLIANCE_CRYSTAL_MINE, i18n("common_text_2223")
				otherData.resourceType = tableResID[self.buildSingle:getBID()]
				self.dispatchPanel = uiManager:show("WorldDispatchArmyView").view
				_ENV = "WorldDispatchArmyView"
				;("WorldDispatchArmyView").toPoint = self.buildSingle:getPos()
				;("WorldDispatchArmyView").dispatchType = state == gAllianceBuildingStatus.BUILD and worldMapDefine.worldMapTipButtonType_jianzao or worldMapDefine.worldMapTipButtonType_caiji
				;("WorldDispatchArmyView").instanceID = self.buildSingle:getIID()
				;("WorldDispatchArmyView").instanceType = gMapObjTypeDef.mapObjTypeSuperResource
				;("WorldDispatchArmyView").maxCount = self.maxCount
				;("WorldDispatchArmyView").otherData = otherData
				self.dispatchPanel:initData("WorldDispatchArmyView")
			end
		elseif self.type == gAWarRallyMemberType.FULL then
			self:setState(not self.isLaunched)
			if self.handle then
				self.handle()
			end
		elseif self.type == gAWarRallyMemberType.CLOSED then
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceBuildInfoSingle
