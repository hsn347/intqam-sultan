local gametop = gModuleMgr.getObject("gametop")
local cityEffectInfoRead = include("cityEffectInfoRead")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local legendMCtrl = SoraDGetCtrl("legendMCtrl")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local mapBuffCtrl = SoraDGetCtrl("mapBuffCtrl")
local legendLordCtrl = SoraDGetCtrl("legendLordCtrl")
local kingStarCtrl = SoraDGetCtrl("kingStarCtrl")
local hegemonCtrl = SoraDGetCtrl("hegemonCtrl")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local intetiorCtrl = SoraDGetCtrl("intetiorCtrl")
local intetiorRead = include("intetiorRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local itemLogic = include("itemLogic")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
_ENV = "rechargeActivityCtrl"
;("rechargeActivityCtrl").CITYBUFF = 1
;("rechargeActivityCtrl").NEWPLAYER = 2
local ("rechargeActivityCtrl").OTHER, tabType = 3, "rechargeActivityCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local citybuffViewPanel = class("citybuffViewPanel", baseFguiPanel)
function citybuffViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("citybuffViewPanel:ctor", self.viewName)
end
function citybuffViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function citybuffViewPanel:onInit()
	print("=======citybuffViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.singleTbl, _ENV, self.curTabType = tabType.CITYBUFF, tabType.CITYBUFF, tabType.CITYBUFF
	self.fields.Com_title:initData(i18n("common_text_014"), handler(self, self.onClickClose))
	self.fields.Text_newKingTip:setString(i18n("guide_text_161"))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function citybuffViewPanel:onListRenderer(index, obj)
	obj:initData(self.singleTbl[index + 1])
end
function citybuffViewPanel:onShow()
	print("=======citybuffViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.curTabType = self.param and self.param.tab or tabType.CITYBUFF
	self:suitView()
	if not self.refreshTimer then
		self.refreshTimer = SoradCreateTimer(self, handler(self, self.refreshTimeUp))
	end
end
function citybuffViewPanel:refreshTimeUp(dt)
	if not self.refreshMark then
		return
	end
	self.refreshMark = false
	self:updateOther()
end
function citybuffViewPanel:updateOther()
	local isShowOtherTab = self:checkShowOtherTab()
	if isShowOtherTab then
		if self.curTabType ~= tabType.OTHER then
			return
		end
		self.fields.Com_tab:clickTab(tabType.OTHER)
	else
		self:suitView()
	end
end
function citybuffViewPanel:suitView()
	local isNewPlayer = buffCtrl:isNewPlayerBuffOpen()
	local isShowOtherTab = self:checkShowOtherTab()
	local buffCtrl, tabsetArray = self, self
	buffCtrl = nil
	;(nil).title = i18n("common_text_014")
	;(nil).tag = tabType.CITYBUFF
	table.insert(tabsetArray, nil)
	if isNewPlayer then
		buffCtrl = nil
		;(nil).title = i18n("guide_text_159")
		;(nil).tag = tabType.NEWPLAYER
		table.insert(tabsetArray, nil)
	end
	if isShowOtherTab then
		buffCtrl = nil
		;(nil).title = i18n("buff_title_01")
		;(nil).tag = tabType.OTHER
		table.insert(tabsetArray, nil)
	end
	if 1 < #tabsetArray then
		self.controllers.c1:setSelectedIndex(0)
		buffCtrl = 0
		;(0).defaultClick = self.curTabType
		;(0).tabsetArray = tabsetArray
		;(0).callback = handler(self, self.onTabClick)
		self.fields.Com_tab:initView(0)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.curTabType = tabType.CITYBUFF
		self:initData()
	end
end
function citybuffViewPanel:onTabClick(tag)
	self.curTabType = tag
	if tag == tabType.CITYBUFF then
		self:initData()
		self.fields.List:jumpToTop()
		self.controllers.c2:setSelectedIndex(0)
	elseif tag == tabType.NEWPLAYER then
		self.singleTbl, tabType = tabType.NEWPLAYER, tabType.NEWPLAYER
		local isNewPlayer = buffCtrl:isNewPlayerBuffOpen()
		if isNewPlayer then
			local buffDesRead = include("buffDesRead")
			local newPlayerBuff = buffDesRead.getNewPlayerBuff()
			for k, v in ipairs(newPlayerBuff) do
				local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
				local buffType = buffltCtrl:getEffectType(v.buffID)
				local buffData = buffCtrl:queryNewPlayerBuff(buffType)
				if buffData then
					tabType = nil
					;(nil).type = 9
					;(nil).buffID = v.buffID
					table.insert(self.singleTbl, nil)
				end
			end
		end
		self.fields.List:setNumItems(#self.singleTbl)
		self.fields.List:jumpToTop()
		self.controllers.c2:setSelectedIndex(1)
	elseif tag == tabType.OTHER then
		self.singleTbl, tabType = tabType.OTHER, tabType.OTHER
		local kingdomBuff = legendMCtrl:isHaveKingdomAchieveData()
		if next(kingdomBuff) then
			for k, v in ipairs(kingdomBuff) do
				if v.finishTime and v.finishTime > serviceFunctions.systemTime() and not v.isPass then
					tabType = gModuleMgr.sharedMgr("buffltCtrl")
					gModuleMgr.sharedMgr("buffltCtrl").type = 10
					gModuleMgr.sharedMgr("buffltCtrl").data = v
					table.insert(self.singleTbl, (gModuleMgr.sharedMgr("buffltCtrl")))
				end
			end
		end
		if worldMapDefine.isInAtlantis() then
			local selfMapId = gametop.playertop_:getMapID()
			local selfTeamId = SoraDGetCtrl("allianceMgr"):getOwnTeamID() or 0
			local tabType, buffIdMark = SoraDGetCtrl("allianceMgr"), SoraDGetCtrl("allianceMgr")
			local usedSkills = atlantisActivityCtrl:getSkillData("usedSkills")
			for k, v in pairs(usedSkills) do
				local config = atlantisActivityCtrl:getSkillConfig(v.skillId)
				local buffId = atlantisActivityCtrl:skillTypeToAttr(config.type)
				if buffId then
					local maxBuff = mapBuffCtrl:getMaxBuff(selfMapId, tostring(buffId), selfTeamId)
					local valueType = atlantisActivityCtrl:getMapBufValueType(buffId)
					local skillValue = config.value
					if valueType == 1 then
						skillValue = skillValue * 10
					end
					if not maxBuff or not (skillValue < maxBuff.plus) then
						tabType = nil
						;(nil).type = 11
						;(nil).data = v
						table.insert(self.singleTbl, nil)
						buffIdMark[tostring(buffId)] = true
					end
				else
					tabType = skillValue * 10
					;(skillValue * 10).type = 11
					;(skillValue * 10).data = v
					table.insert(self.singleTbl, skillValue * 10)
				end
			end
			local mapBuff = mapBuffCtrl:getMapBuff(tostring(selfMapId))
			for buffId, v in pairs(mapBuff) do
				if not buffIdMark[buffId] then
					local maxBuff = mapBuffCtrl:getMaxBuff(selfMapId, buffId, selfTeamId)
					if maxBuff then
						local skillType = atlantisActivityCtrl:attrToSkillType(tonumber(buffId))
						local valueType = atlantisActivityCtrl:getMapBufValueType(tonumber(buffId))
						local skillValue = maxBuff.plus
						if valueType == 1 then
							skillValue = maxBuff.plus / 10
						end
						local skillId = atlantisActivityCtrl:getSkillIdByTypeAndValue(skillType, skillValue)
						tabType = skillValue
						tabType, skillValue.type = tonumber(buffId)
						tonumber(buffId).skillId = skillId
						tonumber(buffId).buffId = tonumber(buffId)
						skillValue.data, tonumber(buffId).plus = tonumber(buffId)
						table.insert(self.singleTbl, skillValue)
					end
				end
			end
			local buffList = atlantisWarCtrl:getPlayerBuffList()
			for k, v in pairs(buffList) do
				if not ATLANTIS_WAR_BOSS_ACTIVE_BUFF[v.effect] and v.endTime > serviceFunctions.systemTime() then
					tabType = maxBuff.plus / 10
					;(maxBuff.plus / 10).type = 13
					;(maxBuff.plus / 10).data = v
					table.insert(self.singleTbl, maxBuff.plus / 10)
				end
			end
			local teamBuffList = atlantisWarCtrl:getAtlentisWarData()
			for k, v in pairs(teamBuffList) do
				if not ATLANTIS_WAR_BOSS_ACTIVE_BUFF[v.effect] and v.endTime > serviceFunctions.systemTime() then
					tabType = atlantisActivityCtrl:getSkillIdByTypeAndValue(skillType, skillValue)
					atlantisActivityCtrl:getSkillIdByTypeAndValue(skillType, skillValue).type = 13
					atlantisActivityCtrl:getSkillIdByTypeAndValue(skillType, skillValue).data = v
					table.insert(self.singleTbl, (atlantisActivityCtrl:getSkillIdByTypeAndValue(skillType, skillValue)))
				end
			end
		elseif worldMapDefine.isInRoaringFlame() then
			local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
			local roaringFlameWarRead = include("roaringFlameWarRead")
			local selfMapId = gametop.playertop_:getMapID()
			local selfTeamId = SoraDGetCtrl("allianceMgr"):getOwnTeamID() or 0
			local tabType, buffIdMark = SoraDGetCtrl("allianceMgr"), SoraDGetCtrl("allianceMgr")
			local usedSkills = roaringFlameWarCtrl:getUsedSkills()
			for k, v in pairs(usedSkills) do
				local config = roaringFlameWarRead.getSkillConfig(v.skillId)
				local buffId = roaringFlameWarRead.skillTypeToAttr(config.type)
				if buffId then
					local maxBuff = mapBuffCtrl:getMaxBuff(selfMapId, tostring(buffId), selfTeamId)
					local maxBuffPlus = roaringFlameWarRead.configValue2maxBuffPlus(buffId, config.value)
					if not maxBuff or not (maxBuffPlus < maxBuff.plus) then
						tabType = selfTeamId
						selfTeamId.type = 15
						selfTeamId.data = v
						table.insert(self.singleTbl, selfTeamId)
						buffIdMark[tostring(buffId)] = true
					end
				else
					tabType = tostring(buffId)
					tostring(buffId).type = 15
					tostring(buffId).data = v
					table.insert(self.singleTbl, (tostring(buffId)))
				end
			end
			local mapBuff = mapBuffCtrl:getMapBuff(tostring(selfMapId))
			for buffId, v in pairs(mapBuff) do
				if not buffIdMark[buffId] then
					local maxBuff = mapBuffCtrl:getMaxBuff(selfMapId, buffId, selfTeamId)
					if maxBuff then
						local skillType = roaringFlameWarRead.attrToSkillType(tonumber(buffId))
						local skillValue = roaringFlameWarRead.maxBuffPlus2configValue(tonumber(buffId), maxBuff.plus)
						local skillId = roaringFlameWarRead.getSkillIdByTypeAndValue(skillType, skillValue)
						tabType = tonumber(buffId)
						tabType, tonumber(buffId).type = tonumber(buffId)
						tonumber(buffId).isMapBuff = true
						tonumber(buffId).skillId = skillId
						tonumber(buffId).buffId = tonumber(buffId)
						tonumber(buffId).data, tonumber(buffId).plus = tonumber(buffId)
						table.insert(self.singleTbl, tonumber(buffId))
					end
				end
			end
		end
		local rechargeBuff = rechargeActivityCtrl:getRechargeBuff()
		if rechargeBuff and next(rechargeBuff) then
			local tabType, buffList = next(rechargeBuff), next(rechargeBuff)
			for buffID, endTime in pairs(rechargeBuff) do
				local leftTime = endTime - serviceFunctions.systemTime()
				if 0 < leftTime then
					local buffValue, buffMode = buffltCtrl:getEffect(tonumber(buffID))
					local buffType = buffltCtrl:getEffectType(tonumber(buffID))
					tabType = tonumber(buffID)
					tonumber(buffID).buffID = tonumber(buffID)
					tonumber(buffID).endTime = endTime
					tonumber(buffID).buffType = buffType
					tonumber(buffID).buffValue = buffValue
					table.insert(buffList, tonumber(buffID))
				end
			end
			table.sort(buffList, function(a, b)
				return a.buffID < b.buffID
			end)
			for k, v in ipairs(buffList) do
				tabType = buffltCtrl:getEffect(tonumber(buffID))
				buffltCtrl:getEffect(tonumber(buffID)).type = 14
				buffltCtrl:getEffect(tonumber(buffID)).data = v
				table.insert(self.singleTbl, buffltCtrl:getEffect(tonumber(buffID)))
			end
		end
		if #self.singleTbl == 0 then
			self:suitView()
			return
		end
		self.fields.List:setNumItems(#self.singleTbl)
		self.fields.List:jumpToTop()
		self.controllers.c2:setSelectedIndex(0)
	end
end
function citybuffViewPanel:checkShowOtherTab()
	local kingdomBuff = legendMCtrl:isHaveKingdomAchieveData()
	if not IsArClient then
		kingdomBuff, legendMCtrl = IsArClient, IsArClient
	end
	if kingdomBuff and next(kingdomBuff) then
		for i, v in ipairs(kingdomBuff) do
			if v.finishTime and v.finishTime > serviceFunctions.systemTime() and not v.isPass then
				return true
			end
		end
	end
	if worldMapDefine.isInAtlantis() then
		local selfMapId = gametop.playertop_:getMapID()
		local selfTeamId = SoraDGetCtrl("allianceMgr"):getOwnTeamID() or 0
		local usedSkills = atlantisActivityCtrl:getSkillData("usedSkills")
		if usedSkills and next(usedSkills) then
			return true
		end
		local mapBuff = mapBuffCtrl:getMapBuff(tostring(selfMapId))
		for buffId, v in pairs(mapBuff) do
			local maxBuff = mapBuffCtrl:getMaxBuff(selfMapId, buffId, selfTeamId)
			if maxBuff then
				return true
			end
		end
		local buffList = atlantisWarCtrl:getPlayerBuffList()
		for k, v in pairs(buffList) do
			if not ATLANTIS_WAR_BOSS_ACTIVE_BUFF[v.effect] and v.endTime > serviceFunctions.systemTime() then
				return true
			end
		end
		local teamBuffList = atlantisWarCtrl:getAtlentisWarData()
		for k, v in pairs(teamBuffList) do
			if not ATLANTIS_WAR_BOSS_ACTIVE_BUFF[v.effect] and v.endTime > serviceFunctions.systemTime() then
				return true
			end
		end
	elseif worldMapDefine.isInRoaringFlame() then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local usedSkills = roaringFlameWarCtrl:getUsedSkills()
		if usedSkills and next(usedSkills) then
			return true
		end
		local selfMapId = gametop.playertop_:getMapID()
		local selfTeamId = SoraDGetCtrl("allianceMgr"):getOwnTeamID() or 0
		local mapBuff = mapBuffCtrl:getMapBuff(tostring(selfMapId))
		for buffId, v in pairs(mapBuff) do
			local maxBuff = mapBuffCtrl:getMaxBuff(selfMapId, buffId, selfTeamId)
			if maxBuff then
				return true
			end
		end
	end
	local rechargeBuff = rechargeActivityCtrl:getRechargeBuff()
	if rechargeBuff and next(rechargeBuff) then
		for buffID, endTime in pairs(rechargeBuff) do
			local leftTime = endTime - serviceFunctions.systemTime()
			if 0 < leftTime then
				return true
			end
		end
	end
end
function citybuffViewPanel:initData()
	self.singleTbl, legendLordCtrl = nil, nil
	local lordTitleID = legendLordCtrl:getLordTitleID()
	if lordTitleID and 0 < lordTitleID then
		legendLordCtrl = nil
		;(nil).type = 1
		;(nil).officialID = lordTitleID
		table.insert(self.singleTbl, nil)
	end
	local kingLordTitleID = kingStarCtrl:getLordTitleID()
	if kingLordTitleID and 0 < kingLordTitleID then
		local mapid = worldMapDefine.getKingStarMapid(kingStarCtrl:getTitleActivityId())
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 1
		kingStarCtrl:getTitleActivityId().officialID = kingLordTitleID
		kingStarCtrl:getTitleActivityId().mapid = mapid
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	local hegemonTitleID = hegemonCtrl:getLordTitleID()
	if hegemonTitleID and 0 < hegemonTitleID then
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 2
		kingStarCtrl:getTitleActivityId().officialID = hegemonTitleID
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	local kingdomTitleID = legendLordCtrl:getKingdomTitleID()
	if kingdomTitleID and 0 < kingdomTitleID then
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 3
		kingStarCtrl:getTitleActivityId().officialID = kingdomTitleID
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	local kingKingdomTitleID = kingStarCtrl:getKingdomTitleID()
	if kingKingdomTitleID and 0 < kingKingdomTitleID then
		local mapid = worldMapDefine.getKingStarMapid(kingStarCtrl:getTitleActivityId())
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 3
		kingStarCtrl:getTitleActivityId().officialID = kingKingdomTitleID
		kingStarCtrl:getTitleActivityId().mapid = mapid
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	local titleID = nebulaEmperorCtrl:getLordTitleID()
	if titleID and 0 < titleID then
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 4
		kingStarCtrl:getTitleActivityId().officialID = titleID
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	local regionTitleID = nebulaEmperorCtrl:getRegionTitleID()
	if regionTitleID and 0 < regionTitleID then
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 4
		kingStarCtrl:getTitleActivityId().officialID = regionTitleID
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	if conquestWarCtrl:isConquestWarWinBuffActive() then
		legendLordCtrl = kingStarCtrl:getTitleActivityId()
		kingStarCtrl:getTitleActivityId().type = 5
		table.insert(self.singleTbl, kingStarCtrl:getTitleActivityId())
	end
	local config = intetiorRead:getTrickSkillTable()
	local trickDataTable = intetiorCtrl:getTrickData()
	for _, v in ipairs(config) do
		if intetiorCtrl:isSelfInTrick(v.type) then
			local trickData = trickDataTable[tostring(v.type)]
			if trickData then
				local configView = intetiorRead:getTrickSkillView(v.type)
				legendLordCtrl = intetiorRead
				intetiorRead.config = v
				local intetiorRead.configView, data = configView, intetiorRead
				local skill = include("intetiorTrickSkill").new(data)
				skill:setSkillPolicyData(trickData)
				if skill:isSkillEffect() then
					legendLordCtrl = trickData
					trickData.type = 6
					trickData.skill = skill
					table.insert(self.singleTbl, trickData)
				end
			end
		end
	end
	local bufflist = cityEffectInfoRead.getList()
	for i, v in ipairs(bufflist) do
		if self:judgeCanShow(v) or buffCtrl:queryCityBuff(v) then
			legendLordCtrl = v
			v.type = 0
			v.buffid = v
			table.insert(self.singleTbl, v)
		end
	end
	intetiorRead = ipairs(bufflist)
	ipairs(bufflist)[1] = 302204
	ipairs(bufflist)[2] = 302205
	ipairs(bufflist)[3] = 302206
	ipairs(bufflist)[4] = 302301
	ipairs(bufflist)[5] = 302401
	ipairs(bufflist)[6] = 302501
	for i, v in ipairs(ipairs(bufflist)) do
		if 0 < backpackCtrl:getItemCount(v) or self:checkHasHalloweenBuff(v) then
			legendLordCtrl = v
			v.type = 7
			v.itemID = v
			table.insert(self.singleTbl, v)
		end
	end
	local atkitemID = 820203
	if 0 < backpackCtrl:getItemCount(atkitemID) or self:checkHasAttackMonsterBuff(atkitemID) then
		legendLordCtrl = atkitemID
		atkitemID.type = 8
		atkitemID.itemID = atkitemID
		table.insert(self.singleTbl, atkitemID)
	end
	self.fields.List:setNumItems(#self.singleTbl)
end
function citybuffViewPanel:updateNewPlayer()
	local isNewPlayer = buffCtrl:isNewPlayerBuffOpen()
	if isNewPlayer then
		if self.curTabType ~= tabType.NEWPLAYER then
			return
		end
		self.fields.Com_tab:clickTab(tabType.NEWPLAYER)
	else
		self:suitView()
	end
end
function citybuffViewPanel:setRefreshMark()
	self.refreshMark = true
end
function citybuffViewPanel:checkHasAttackMonsterBuff(itemID)
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local buffData = buffCtrl:queryCityBuff(buffEffect)
	if buffData then
		return true
	end
end
function citybuffViewPanel:checkHasHalloweenBuff(itemID)
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local buffData = buffCtrl:queryHalloweenBuff(buffEffect)
	if buffData then
		return true
	end
end
function citybuffViewPanel:judgeCanShow(bid)
	local ret = false
	local judgeOne = function(itemID)
		local isAllowShow = true
		local backpackCtrl, _initData
		local itemCount = backpackCtrl:getItemCount(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
		local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
		if itemCount <= 0 and not itemInfo then
			isAllowShow = false
		end
		if not itemLogic.checkUseCond(itemID) then
			isAllowShow = false
		end
		return isAllowShow
	end
	local tblBuffList = buffCtrl:getBuffItemArray(bid)
	for i, v in ipairs(tblBuffList) do
		if judgeOne(v) then
			ret = true
			break
		end
	end
	return ret
end
return citybuffViewPanel
