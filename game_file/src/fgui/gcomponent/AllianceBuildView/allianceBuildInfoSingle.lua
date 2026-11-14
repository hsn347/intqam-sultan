local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildInfoSingle", allianceBuildInfoSingle)
function allianceBuildInfoSingle:onInit()
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
	self.baseH = self:getHeight()
	self.layerTouch = self.fields.Panel_touch
	self.spriteArr = self.fields.Sprite_arr
	self.labelCount = self.fields.Text_count
	self.labelName = self.fields.Text_name
	self.labelState = self.fields.Text_state
	self.labelNotice = self.fields.Text_notice
	self.layerTouch:addClickListener(handler(self, self.btnClickCallBack))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.spriteArr:fix()
	end
end
function allianceBuildInfoSingle:registerEvent(...)
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
function allianceBuildInfoSingle:onShow()
end
function allianceBuildInfoSingle:updateOpenShow(isFull)
	if self.type == gAWarRallyMemberType.OPEN then
		if isFull and self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
			self.labelNotice:setString(i18n("common_text_2141"))
		elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
			_ENV = i18n("common_text_2141")
			i18n("common_text_2141").build = allianceDesRead.getBuildName(self.buildSingle:getBID())
			self.labelNotice:setString(i18n("common_text_2138", i18n("common_text_2141")))
		elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
			self.labelNotice:setString(i18n("common_text_2143"))
		end
	end
end
function allianceBuildInfoSingle:setClickCallBack(handle)
	self.handle = handle
end
function allianceBuildInfoSingle:initData(data, type, buildSingle)
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
function allianceBuildInfoSingle:setState(state)
	if self.isLaunched == state then
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
function allianceBuildInfoSingle:getState()
	return self.isLaunched
end
function allianceBuildInfoSingle:showMember(isShow)
	if not isShow then
		self:setState(isShow)
	end
end
function allianceBuildInfoSingle:updateMemberSingle()
	self.fields.Com_head:setHeadSprite(self.tableMemberData.headid, self.tableMemberData.avatar)
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
function allianceBuildInfoSingle:showMemberSingle()
	local memberMgr = SoraDGetCtrl("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank == gAllianceRank.OFFICIAL then
		ownRank = gAllianceRank.R4 + 0.5
	end
	self.controllers.c1:setSelectedIndex(1)
	self:setState(self.isLaunched)
	local rank = self.tableMemberData.rank
	if rank == gAllianceRank.OFFICIAL then
		rank = gAllianceRank.R4 + 0.5
	end
	self.isCaptain = ownRank >= gAllianceRank.R4 and ownRank > rank
	self:updateMemberSingle()
end
function allianceBuildInfoSingle:showLockSingle()
	self.controllers.c1:setSelectedIndex(2)
	self:setState(false)
	self.fields.Com_head:setHeadSprite("")
	if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD and self.buildSingle:getMaxNumOfQueue() == 1 then
		self.labelNotice:setString(i18n("common_text_2285"))
	else
		self.labelNotice:setString(i18n("common_text_304"))
	end
end
function allianceBuildInfoSingle:showClosedSingle()
	self.controllers.c1:setSelectedIndex(2)
	self:setState(false)
	self.fields.Com_head:setHeadSprite("")
	self.labelNotice:setString(i18n("common_text_2141"))
end
function allianceBuildInfoSingle:showOpenSingle()
	self.controllers.c1:setSelectedIndex(0)
	self:setState(false)
	self.fields.Com_head:setHeadSprite("")
	if self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
		_ENV = nil
		;(nil).build = allianceDesRead.getBuildName(self.buildSingle:getBID())
		self.labelNotice:setString(i18n("common_text_2138", nil))
	elseif self.buildSingle:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
		self.labelNotice:setString(i18n("common_text_2143"))
	end
end
function allianceBuildInfoSingle:initArmy()
	if not self.Com_army then
		local Com_army = fgui.UIPackage:createObject("AllianceBuildView", "Com_army")
		Com_army:addTo(self.fields.Com_army)
		self.Com_army = Com_army
		self.Com_army:setBtnBackClick(handler(self, self.btnBackClickCallBack))
		self.Com_army:setTitleText(i18n("common_text_302"))
	else
		self.Com_army:setVisible(true)
	end
	self.Com_army:initMemberData(self.tableMemberData)
	self.Com_army:setIsSelfArmy(self.isCaptain)
	self:setHeight(self.baseH + self.Com_army:getHeight())
end
function allianceBuildInfoSingle:removeArmy()
	if self.Com_army then
		self.Com_army:setVisible(false)
	end
	self:setHeight(self.baseH)
end
function allianceBuildInfoSingle:btnBackClickCallBack(button, type)
	SoraDPlaySound()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	kingdomMapCtrl:reqBackQueueById(self.tableMemberData.queueId)
end
function allianceBuildInfoSingle:btnClickCallBack()
	SoraDPlaySound()
	local state = self.buildSingle:getBuildingStatus()
	if self.type == gAWarRallyMemberType.LOCK then
	elseif self.type == gAWarRallyMemberType.OPEN then
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local cityCtrl = SoraDGetCtrl("cityCtrl")
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
				SoraDShowMsgTip(i18n("common_text_2225", i18n("alliance_build_text_03")))
				return
			end
		end
		if kingdomMapCtrl:hasQueue2AllianceBuild(self.buildSingle:getIID()) then
			SoraDShowMsgTip(i18n("common_text_2223"))
			return
		end
		if SoraDEnoughTroops() then
			local _ENV, _ENV, otherData = i18n("common_text_2223")
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
			self.handle(self.isLaunched)
		end
	elseif self.type == gAWarRallyMemberType.CLOSED then
	end
end
return allianceBuildInfoSingle
