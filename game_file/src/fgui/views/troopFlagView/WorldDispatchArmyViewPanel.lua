local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local buildLogic = include("buildLogic")
local armyLogic = include("armyLogic")
local armyDesRead = include("armyDesRead")
local resDesRead = include("resDesRead")
local alliancePetRead = include("alliancePetRead")
local cityEffectInfoRead = include("cityEffectInfoRead")
local armyltCtrl = include("armyltCtrl")
local epicBattleDef = include("epicBattleDef")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local gSoldierSelectType = _G.gSoldierSelectType
local gHeroSelectBannerStyle = _G.gHeroSelectBannerStyle
local MIN_DUEL_ARMY_NUM = 150000
_ENV = nil
_ENV = nil
;(nil).noTime = true
;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001680], (nil).freeTitle = nil, "common_text_008"
local activitySetting
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldDispatchArmyViewPanel = class("WorldDispatchArmyViewPanel", baseFguiPanel)
function WorldDispatchArmyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	self.isInNebulaAllStar = worldMapDefine.isInNebulaAllStar()
	print("WorldDispatchArmyViewPanel:ctor", self.viewName)
end
function WorldDispatchArmyViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function WorldDispatchArmyViewPanel:onInit()
	print("=======WorldDispatchArmyViewPanel:onInit")
	self.fields.slider:setInpuBoxFixPos(96, 96)
	include("worldMapDefine")
	include("worldMapFunction")
	self.activitySetting, _ENV = include, include
	self.nodeTitle = self.fields.Com_title
	self.fields.Com_title:initData(i18n("common_text_481"), handler(self, self.onClickClose))
	self.fields.List_troops:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_army:setVirtual()
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyRenderer))
	self.controllers.c1:setSelectedIndex(1)
	self.btnQuickChoose = self.fields.Button_quick
	self.btnQuickChoose:setTitle(i18n("common_text_852"))
	self.btnGo = self.fields.Button_go
	self.labelNotice = self.fields.Text_notice
	self.labelNotice:setString(i18n("common_text_858"))
	self.btn_convene = self.fields.Button_convene
	self.btn_convene:setTitle(i18n("common_text_3616"))
	self.imageWeight = self.fields.Com_weight
	self.btnFiler = self.fields.Button_select
	self.btnFiler:setTitle(i18n("common_text_4924"))
	self.btnCountPlus = self.fields.Button_countPlus
	self.labelWeight = self.fields.Com_weight
	self.labelWeight:setString("0")
	self.spriteWeight = self.fields.Com_weight
	self.btnPhysicalPlus = self.fields.Button_physicalPlus
	self.labelTip = self.fields.Text_tip
	self.btnGo:setBeginTime(0, false)
	self.labelTime = self.btnGo.text_time
	self.moveTime = 0
	self.armySlider = self.fields.slider
	_ENV = 0
	;(0).maxValue = 100
	;(0).minValue = 0
	;(0).curValue = 0
	self.armySlider:initData(0)
	self.armySlider:setMinValue(0)
	self.armySlider:setSliderCallBack(handler(self, self.armyChange))
	self.btnTeam = self.fields.Button_team
	self.btnQuickChoose:addTouchEventListener(handler(self, self.btnQuickClickCallBack))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClickCallBack))
	self.btnCountPlus:addTouchEventListener(handler(self, self.btnCountPlusClickCallBack))
	self.btnPhysicalPlus:addTouchEventListener(handler(self, self.btnPhysicalPlusClickCallBack))
	self.btn_convene:addTouchEventListener(handler(self, self.btnConveneClickCallBack))
	self.btnFiler:addTouchEventListener(handler(self, self.OnBtnFilerClick))
	self.labelGoTitle = self.btnGo
	self.labelGoTitle:setString(i18n("common_text_481"))
	self.nodeHero = self.fields.heroBanner
	self.nodeHero:setMode(gHeroSelectBannerStyle.dispatch)
	self.nodeHero:setInnerSelectCallBack(handler(self, self.updateHero))
	self.nodeHero:setRemoveCallBack(handler(self, self.updateHero))
	self.nodeHero:setArtifactUpdateCallBack(handler(self, self.updateMoveTime))
	self.nodeHero:setDivineBeastUpdateCallBack(handler(self, self.updateHero))
	self.nodeMass = self.fields.Node_mass
	self.nodeMass:setVisible(false)
	self.isInRemains = worldMapDefine.isInRemains()
	self.btnMilitary = self.fields.Button_Military
	self.btnMilitary:addTouchEventListener(handler(self, self.btnClickMilitary))
	self.btnMilitary:setVisible(false)
	self.textMilitary = self.btnMilitary
	_ENV = handler(self, self.btnClickMilitary)
	_ENV, _ENV, handler(self, self.btnClickMilitary).commonStr = "fortress_name_01", i18n("fortress_name_01"), i18n("fortress_name_01")
	;("fortress_name_01").c = "true"
	i18n("fortress_name_01").commonStr, ("fortress_name_01").u = "fortress_name_01", "true"
	self.textMilitary:setString(i18n_html("common_text_034", handler(self, self.btnClickMilitary)))
	self:createTeamBtns()
	if self.isInNebulaAllStar then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("dispatchArmy")
		self.fields.Com_title:setHelpCallBack(handlerHelp)
		self.btnPhysicalPlus:setIcon("btn_question.png")
		self.spriteWeight:setIcon("frame_qmx_zaiyingshibing.png")
		self.labelNotice:setString(i18n("NebulaAllstar_393"))
		self.btn_convene:setVisible(false)
	end
end
function WorldDispatchArmyViewPanel:endShow()
	self:createTeamBtns()
end
function WorldDispatchArmyViewPanel:armyChange(armyPer)
	self:resetArmySelect()
	local canUseCount = 0
	for _, v in pairs(self.tableArmyData) do
		canUseCount = canUseCount + v.armycount
	end
	local allCount = self.allCount
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTotalArmy()
		allCount = math.min(totalArmy, allCount)
	end
	armyPer = math.min(armyPer, allCount * 100 / canUseCount)
	for armyid in pairs(self.tableArmyData) do
		local singleMax = self:getArmyCount(armyid)
		local canUseSingle = math.ceil(singleMax * armyPer / 100)
		self:setCurValByArmyid(armyid, canUseSingle)
	end
	dump(armyPer, "WorldDispatchArmyViewPanel:armyChange")
	_ENV = armyPer
	armyPer.notBack = true
	self.armySlider:setSliderCurValue(math.ceil(armyPer), armyPer)
	self:updateView()
	return true
end
function WorldDispatchArmyViewPanel:updateExpArmyCountRet()
	self.expArmyCountRet = buildLogic.getExpArmyCount(self.mapMoveLineType)
end
function WorldDispatchArmyViewPanel:updateCountLabel()
	local totoalCount = self.expArmyCountRet.total
	if self.allowMaxCount then
		self.allCount = math.min(totoalCount + self.heroCount + self.armRuneCount + self.armyDivineBeastCount, self.allowMaxCount)
	else
		self.allCount = totoalCount + self.heroCount + self.armRuneCount + self.armyDivineBeastCount
	end
	_ENV = self.allowMaxCount
	self.allowMaxCount.var1 = self.curCount
	self.allowMaxCount.var2 = fguiHelper.getColorString(totoalCount > self.expArmyCountRet.unchangesize and "#00FF00" or "#F0E6D2", self.allCount)
	local countStr = i18n("%{var1}/%{var2}", self.allowMaxCount)
	self.fields.Com_count:setString(countStr)
end
function WorldDispatchArmyViewPanel:createTeamBtns()
	local totalNum = armyCtrl:getArmyCompileCount()
	self.fields.List_troops:setNumItems(totalNum)
	self.fields.List_troops:resizeToFit(totalNum)
end
function WorldDispatchArmyViewPanel:onItemRenderer(index, obj)
	local compiletype = index + 1
	local tName = armyCtrl:getArmyCompileName(compiletype) or compiletype
	obj:setString(tName)
	obj:setTag(compiletype)
	obj:setClickCallback(handler(self, self.btnTeamClickCallBack))
end
function WorldDispatchArmyViewPanel:btnTeamClickCallBack(button, type)
	SoraDPlaySound()
	armyCtrl:getArmyCompile(button:getTag())
	SoraDShowLoading(self)
end
function WorldDispatchArmyViewPanel:checkArmsList(amrsList)
	local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
	local gametop, ret = gametop.playertop_, gametop.playertop_
	for i, v in ipairs(amrsList) do
		local data = godArmsCtrl:getArmsListByID(v)
		if data.info.marchCount >= 1 and data.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_NORMAL then
			SoraDShowMsgTip(i18n("artifact_text_27"), data.icon)
		else
			table.insert(ret, v)
		end
	end
	return ret
end
function WorldDispatchArmyViewPanel:adaptTeam(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "redata.redata====", 10)
	if redata and redata.redata then
		local compile = redata.redata
		local heroList = redata.heroList
		local armsList = redata.armsList
		local divineBeastList = redata.divineBeastList
		local treamType = redata.type
		local notEnough = false
		local noneCompile = true
		if next(compile) ~= nil then
			for _, v in pairs(compile) do
				if 0 < v then
					noneCompile = false
					break
				end
			end
		end
		if noneCompile then
			SoraDShowMsgBox(i18n("common_text_1449"), i18n("common_text_204"))
			return
		end
		self.isNotEnoughArmy = false
		local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(heroList)
		self.nodeHero:filterHerosByMode(heroIDList, self:checkArmsList(armsList), lieutenantList, divineBeastList)
		self:updateHeroEx()
		for k, v in pairs(compile) do
			if 0 < v then
				local data = self.tableArmyData[tonumber(k)]
				if data then
					notEnough = v > data.armycount
				else
					self.isNotEnoughArmy = true
				end
				if notEnough then
					self.isNotEnoughArmy = true
				end
			end
		end
		print("self.heroNotIn,self.isNotEnoughArmy====", self.heroNotIn, self.isNotEnoughArmy, self.isDivineBeastNotInCity)
		if self.heroNotIn or self.isDivineBeastNotInCity or self.isNotEnoughArmy then
			self:resetArmySelect()
			local recordCount = 0
			local scaleCount = 1
			local needAdd = self.allCount
			for _, v in pairs(compile) do
				recordCount = recordCount + v
			end
			if recordCount > self.allCount then
				scaleCount = self.allCount / recordCount
			end
			self:updateCountLabel()
			self:updateScroll()
			if self.isNotEnoughArmy then
				_ENV = i18n("common_text_204")
				i18n("common_text_204").closeCancel = true
				SoraDShowMsgBox(i18n("formation_no_soldier_desc"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if tolua.isnull(self) then
						return
					end
					if callType == MSGBOX_CALLBACK_YES then
						local addedCount = 0
						local _ENV, armyTypeList = self, self
						dump(compile, "compile=======")
						for k, v in pairs(compile) do
							if 0 < v then
								local armyid = tonumber(k)
								local data = self.tableArmyData[armyid]
								if data and 0 < data.armycount then
									self:setCurValByArmyid(armyid, math.min(v, data.armycount))
									addedCount = addedCount + math.min(v, data.armycount)
								end
								armyTypeList[armyltCtrl.getSoldierType(armyid)] = true
							end
						end
						local armyCount = math.min(recordCount, self.allCount)
						if addedCount < armyCount then
							local _ENV, armyData = recordCount, recordCount
							for id, info in pairs(self.tableArmyData) do
								if info.curCount == 0 then
									_ENV = data.armycount
									data.armycount.id = id
									data.armycount.count = info.armycount
									data.armycount.armyType = armyltCtrl.getSoldierType(id)
									data.armycount.lv = id % 100
									table.insert(armyData, data.armycount)
								end
							end
							table.sort(armyData, function(a, b)
								return a.armyType < b.armyType
							end)
							local _ENV, sortData = table.sort, table.sort
							local _ENV, ownData = armyData, armyData
							local _ENV, otherData = function(a, b)
								return a.armyType < b.armyType
							end, function(a, b)
								return a.armyType < b.armyType
							end
							for k, v in ipairs(armyData) do
								if armyTypeList[v.armyType] then
									table.insert(ownData, v)
								else
									table.insert(otherData, v)
								end
							end
							table.sort(ownData, function(a, b)
								if a.armyType == b.armyType then
									return a.lv > b.lv
								else
									return a.armyType < b.armyType
								end
							end)
							table.sort(otherData, function(a, b)
								if a.armyType == b.armyType then
									return a.lv > b.lv
								else
									return a.armyType < b.armyType
								end
							end)
							for k, v in ipairs(ownData) do
								table.insert(sortData, v)
							end
							for k, v in ipairs(otherData) do
								table.insert(sortData, v)
							end
							local added = 0
							dump(sortData, "sortData=====")
							for k, v in ipairs(sortData) do
								print("added ======= ", added, armyCount, addedCount, armyCount - addedCount)
								if added < armyCount - addedCount then
									self:setCurValByArmyid(v.id, math.min(v.count, armyCount - addedCount - added))
									added = added + math.min(v.count, armyCount - addedCount - added)
								end
							end
						end
						self:updateCountLabel()
						self:updateScroll()
					elseif callType == MSGBOX_CALLBACK_NO then
						local armyCount = math.min(recordCount, self.allCount)
						local addedCount = 0
						dump(compile, "compile=======")
						for k, v in pairs(compile) do
							if 0 < v then
								local armyid = tonumber(k)
								local data = self.tableArmyData[armyid]
								if data and 0 <= data.armycount then
									self:setCurValByArmyid(armyid, math.min(v, data.armycount))
								end
							end
						end
						self:updateCountLabel()
						self:updateScroll()
					end
				end, i18n("common_text_204"))
			else
				_ENV = i18n("common_text_204")
				i18n("common_text_204").closeCancel = true
				SoraDShowMsgBox(i18n("formation_hero_notInCity_desc"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if tolua.isnull(self) then
						print("对象已经被释放")
						return
					end
					if callType == MSGBOX_CALLBACK_YES then
						local addedCount = 0
						local armyCount = math.min(recordCount, self.allCount)
						local _ENV, armyTypeList = recordCount, recordCount
						dump(compile, "compile=======")
						for k, v in pairs(compile) do
							if 0 < v then
								local armyid = tonumber(k)
								local data = self.tableArmyData[armyid]
								if data and 0 <= data.armycount then
									self:setCurValByArmyid(armyid, math.min(v, data.armycount))
									addedCount = addedCount + math.min(v, data.armycount)
								end
								armyTypeList[armyltCtrl.getSoldierType(armyid)] = true
							end
						end
						print("addedCount,armyCount===", addedCount, armyCount)
						if armyCount > addedCount then
							local _ENV, armyData = print, print
							for id, info in pairs(self.tableArmyData) do
								_ENV = armyid
								armyid.id = id
								armyid.count = info.armycount
								armyid.armyType = armyltCtrl.getSoldierType(id)
								armyid.lv = id % 100
								table.insert(armyData, armyid)
							end
							table.sort(armyData, function(a, b)
								return a.armyType < b.armyType
							end)
							local _ENV, sortData = table.sort, table.sort
							local _ENV, ownData = armyData, armyData
							local _ENV, otherData = function(a, b)
								return a.armyType < b.armyType
							end, function(a, b)
								return a.armyType < b.armyType
							end
							for k, v in ipairs(armyData) do
								if armyTypeList[v.armyType] then
									table.insert(ownData, v)
								else
									table.insert(otherData, v)
								end
							end
							table.sort(ownData, function(a, b)
								if a.armyType == b.armyType then
									return a.lv > b.lv
								else
									return a.armyType < b.armyType
								end
							end)
							table.sort(otherData, function(a, b)
								if a.armyType == b.armyType then
									return a.lv > b.lv
								else
									return a.armyType < b.armyType
								end
							end)
							for k, v in ipairs(ownData) do
								table.insert(sortData, v)
							end
							for k, v in ipairs(otherData) do
								table.insert(sortData, v)
							end
							local added = 0
							dump(sortData, "sortData=====")
							for k, v in ipairs(sortData) do
								if added < armyCount - addedCount then
									self:setCurValByArmyid(v.id, math.min(v.count, armyCount - added))
									added = added + math.min(v.count, armyCount - added)
								end
							end
						end
						self:updateCountLabel()
						self:updateScroll()
					elseif callType == MSGBOX_CALLBACK_NO then
						local armyCount = math.min(recordCount, self.allCount)
						local addedCount = 0
						dump(compile, "compile=======")
						for k, v in pairs(compile) do
							if 0 < v then
								local armyid = tonumber(k)
								local data = self.tableArmyData[armyid]
								if data and 0 <= data.armycount then
									self:setCurValByArmyid(armyid, math.min(v, data.armycount))
								end
							end
						end
						self:updateCountLabel()
						self:updateScroll()
					end
				end, i18n("common_text_204"))
			end
			return
		end
		self:resetArmySelect()
		local recordCount = 0
		local scaleCount = 1
		local needAdd = self.allCount
		for _, v in pairs(compile) do
			recordCount = recordCount + v
		end
		if recordCount > self.allCount then
			scaleCount = self.allCount / recordCount
		end
		for k, v in pairs(compile) do
			if 0 < v then
				local notFind = true
				local armyid = tonumber(k)
				local data = self.tableArmyData[armyid]
				if data then
					if v > data.armycount then
						notEnough = true
					end
					self:setCurValByArmyid(armyid, math.floor(v * scaleCount))
					needAdd = needAdd - math.floor(v * scaleCount)
					notFind = false
				end
				if notFind then
					notEnough = true
				end
			end
		end
		if scaleCount < 1 and 0 < needAdd then
			for k, v in pairs(compile) do
				if 0 < v then
					local armyid = tonumber(k)
					local data = self.tableArmyData[armyid]
					if data then
						local armycount = self:getArmyCount(armyid)
						self:setCurValByArmyid(armyid, armycount)
						needAdd = needAdd - (armycount - math.floor(v * scaleCount))
					end
				end
				if needAdd <= 0 then
					break
				end
			end
		end
		if scaleCount < 1 then
			SoraDShowMsgBox(i18n("common_text_2025"), i18n("common_text_204"))
		elseif notEnough then
			SoraDShowMsgBox(i18n("common_text_1447"), i18n("common_text_204"))
		end
		self:updateHero()
		self:updateScroll()
	end
end
function WorldDispatchArmyViewPanel:getNpcPower(npcID)
	local npcData = require_data("npc", true).data
	for i, v in ipairs(npcData) do
		if v.id == npcID then
			return v.fc
		end
	end
	return 0
end
function WorldDispatchArmyViewPanel:isForbidSolider(armyId, armyLv, isMass)
	local bRet = false
	local forbidType
	local occupyQueueArmyMinLv = self:getOccupyQueueArmyMinLv()
	if isMass then
		if 0 < occupyQueueArmyMinLv and armyLv < occupyQueueArmyMinLv then
			bRet = true
			forbidType = 1
		else
		end
	elseif self.otherData then
		forbidType = 2
		local armyMinLv = self.otherData.massSlaveArmyMinLv or 1
		if 0 < occupyQueueArmyMinLv and occupyQueueArmyMinLv > armyMinLv then
			armyMinLv = occupyQueueArmyMinLv
			forbidType = 1
		end
		if armyLv < armyMinLv then
			bRet = true
		elseif self.otherData.massSlaveForbidArmyClass then
			local curArmyClass = serviceFunctions.getArmyTypeByArmyId(armyId)
			if curArmyClass then
				local armyType = tostring(curArmyClass)
				if self.otherData.massSlaveForbidArmyClass[armyType] then
					bRet = true
				end
			end
		end
	end
	return bRet, forbidType
end
function WorldDispatchArmyViewPanel:_initDispatchArmyListFromCtrl(isMass, silent)
	local list = armyCtrl:getArmyIDList()
	self.armyIDList, armyCtrl = armyCtrl, armyCtrl
	local needLvFilter = self:needLegendWarSoldierLvFilter()
	local limitLv = needLvFilter and self:getLegendWarSoldierLimitLv()
	for _, v in ipairs(list) do
		if not silent then
			print("id,lv=======", v, serviceFunctions.getArmyViewLev(v))
		end
		local armyID = v % 1000
		local armyLv = serviceFunctions.getArmyViewLev(v) / 10
		if not limitLv or limitLv < armyLv then
			local biographyAdd = armyLogic.getArmySpecialWeight(v)
			local weight = armyDesRead.getFreeWeightAndSp(v, biographyAdd)
			local soldierType = armyltCtrl.getSoldierType(v)
			armyCtrl = v
			v.id = v
			v.armyID = armyID
			v.level = armyLv
			v.weight = weight
			local v.soldierType, row = soldierType, v
			local isForbid, forbidType = self:isForbidSolider(v, armyLv, isMass)
			row.isForbid, row.forbidType = isForbid, forbidType
			table.insert(self.armyIDList, row)
		end
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.isForbid ~= army2.isForbid then
			return army2.isForbid
		end
		if army1.sortOrder ~= army2.sortOrder then
			return army1.sortOrder > army2.sortOrder
		end
		if army1.level ~= army2.level then
			return army2.level < army1.level
		end
		return army1.armyID < army2.armyID
	end)
	self.curCount = 0
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local haveCount = self.isInNebulaAllStar and nebulaAllStarCtrl:getTotalArmy() or armyCtrl:getArmyCount(id, ARMY_OPTYPE.NORMAL_ARMY)
		if 0 < haveCount then
			table.insert(self.tableArmy, id)
			armyCtrl = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = haveCount
			self.tableArmy.curCount = 0
			self.tableArmy.weight = v.weight
			self.tableArmy.isForbid = v.isForbid
			self.tableArmyData[id], self.tableArmy.forbidType = self.tableArmy, v.forbidType
		end
	end
	self:sortTableArmy()
	self.labelNotice:setVisible(0 >= #self.tableArmy)
	if not self.isInNebulaAllStar then
		self.btn_convene:setVisible(0 >= #self.tableArmy)
	end
end
function WorldDispatchArmyViewPanel:isTargetPlayerCastle()
	if self.otherData and self.otherData.mainInstanceType then
		return self.otherData.mainInstanceType == gMapObjTypeDef.mapObjTypePlayer
	end
	return self.instanceType == gMapObjTypeDef.mapObjTypePlayer
end
function WorldDispatchArmyViewPanel:needLegendWarSoldierLvFilter()
	if not worldMapDefine.isInLegendLord() then
		return false
	end
	if not self:isTargetPlayerCastle() then
		return false
	end
	if self.dispatchType == worldMapDefine.worldMapTipButtonType_gongJi then
		return true
	end
	if self.dispatchType == worldMapDefine.worldMapTipButtonType_xuanZhan then
		return true
	end
	return false
end
function WorldDispatchArmyViewPanel:needLegendWarSoldierNumCheck()
	if not worldMapDefine.isInLegendLord() then
		return false
	end
	if not self:isTargetPlayerCastle() then
		return false
	end
	if self.dispatchType == worldMapDefine.worldMapTipButtonType_gongJi then
		return true
	end
	if self.dispatchType == worldMapDefine.worldMapTipButtonType_xuanZhan then
		return not self.isJoinMass
	end
	return false
end
function WorldDispatchArmyViewPanel:getLegendWarSoldierLimitLv()
	return CONST_VALUE.LEGEND_WAR_SOLDIERS_LIMIT_LV
end
function WorldDispatchArmyViewPanel:getLegendWarSoldierLimitNum()
	return CONST_VALUE.LEGEND_WAR_SOLDIERS_LIMIT_NUM
end
function WorldDispatchArmyViewPanel:_setLabelTipByRemainsNebula()
	self.labelTip:setVisible(not self.isInRemains and not worldMapDefine.isInNebula())
end
function WorldDispatchArmyViewPanel:_setExtraAttrFromViewData(armyViewData)
	if not armyViewData.attr then
		local _ENV, attr = armyViewData.attr, armyViewData.attr
	end
	self.extraAttrAdd = (attr[tostring(gAttributeEnum.MASS_SLAVE_SPEED_RATE)] or 0) / 10
end
function WorldDispatchArmyViewPanel:_setControllerC1ByTextTip()
	if self:needLegendWarSoldierLvFilter() then
		self.controllers.c1:setSelectedIndex(2)
		local limitLv = self:getLegendWarSoldierLimitLv()
		local warLimitStr
		if self:needLegendWarSoldierNumCheck() then
			local limitNum = self:getLegendWarSoldierLimitNum()
			local num2Str = string.formatnumberthousands(limitNum)
			_ENV = nil
			;(nil).num1 = limitLv
			;(nil).num2 = num2Str
			warLimitStr = i18n("legendaryking_text_110", nil)
		else
			_ENV = i18n("legendaryking_text_110", nil)
			i18n("legendaryking_text_110", nil).num = limitLv
			warLimitStr = i18n("legendaryking_text_111", (i18n("legendaryking_text_110", nil)))
		end
		self.fields.Text_warLimit:setString(warLimitStr)
		return
	end
	if self:check_showTextTip() then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function WorldDispatchArmyViewPanel:_defaultHeroAndArmyQuick()
	if self.isGuide then
		self:quickChoose_army(false)
	else
		local isSelected = true
		_ENV = nil
		;(nil).byUID = true
		local defaultHero = SoraDConfigGet("Game:worldDispatchArmySelectViewPanel:defaultHero~bool", nil)
		if defaultHero ~= nil then
			isSelected = defaultHero
		end
		self:quickChoose_hero(isSelected)
		self:quickChoose_army(true)
		self:updateBtnText()
	end
end
function WorldDispatchArmyViewPanel:_maybeCommandHallGuide()
	if #self.tableArmy <= 0 and SoraDIsGameGuide() then
		include("commandHallUtil").checkFinishGuide()
	end
end
function WorldDispatchArmyViewPanel:initData(armyViewData, isMass)
	if armyViewData and armyViewData.isKipchaks then
		return self:initDataKipchaks(armyViewData, isMass)
	end
	self.isKipchaks = false
	dump(armyViewData, "armyViewData====", 10)
	self.toPoint = armyViewData.toPoint
	self.dispatchType = armyViewData.dispatchType
	self.instanceID = armyViewData.instanceID
	self.instanceType = armyViewData.instanceType
	self.bossType = armyViewData.bossType
	self.isJoinMass = armyViewData.isJoinMass
	self.isRaiderLostArk = armyViewData.isRaiderLostArk or false
	self.isBeastCanyon = armyViewData.isBeastCanyon or false
	self.isPhoenix = armyViewData.bossType and armyViewData.bossType == gBossType.phoenixChallengeBoss
	self.activityID = armyViewData.activityID or 0
	if not activitySetting[self.activityID] then
		_ENV = activitySetting[self.activityID]
	end
	self.activitySetting = activitySetting[self.activityID]
	self.dispatchCallback = armyViewData.dispatchCallback
	self.isGuide = armyViewData.isGuide or false
	self.targetID = armyViewData.targetID
	self.itemID = armyViewData.itemID
	self.feastAid = armyViewData.aid
	self.feastLeftTime = armyViewData.leftTime
	self.isKillLeaderNpc = armyViewData.isKillLeaderNpc or nil
	self.killNormalNpcLv = armyViewData.killNormalNpcLv
	self.mapMoveLineType = worldMapDefine.convetToMapMoveLineType(self.instanceType, self.dispatchType, self.toPoint, self.isJoinMass)
	self.allCount = buildLogic.getExpArmyCount(self.mapMoveLineType).total
	if self.isRaiderLostArk or self.isBeastCanyon or self.isPhoenix or self.activitySetting.freeTitle then
		if self.isBeastCanyon then
			self.btnGo:setFreeTitle(i18n("arena_btn_04"), 1)
		elseif self.isPhoenix then
			self.btnGo:setFreeTitle(i18n("Phonex_Challenge_text_33"), 1)
		elseif self.activitySetting.freeTitle then
			self.btnGo:setFreeTitle(i18n(self.activitySetting.freeTitle), 1)
		else
			self.btnGo:setFreeTitle(i18n("Martial_arts_text_25"), 1)
		end
		self.spriteWeight:setVisible(false)
		self.labelWeight:setVisible(false)
		self.btnPhysicalPlus:setVisible(false)
		self.imageWeight:setVisible(false)
	end
	self:_setExtraAttrFromViewData(armyViewData)
	self.npcPower = 0
	if self.instanceID then
		local tableNpc = SoraDStringSplit(self.instanceID, "-")
		self.npcID = tonumber(tableNpc[#tableNpc])
		self.npcPower = self:getNpcPower(self.npcID)
	end
	self:_setLabelTipByRemainsNebula()
	if armyViewData.otherData then
		self.otherData = armyViewData.otherData
	end
	self:initMassView(armyViewData.isJoinMass)
	if armyViewData.maxCount then
		self.allowMaxCount = armyViewData.maxCount
	end
	self:_initDispatchArmyListFromCtrl(isMass, false)
	self:updateCountLabel()
	local physical = self:getPhysical_initData()
	if physical then
		self.labelWeight:setString(tostring(physical))
		self.spriteWeight:setIcon("icon_lord_sp.png")
		self.btnPhysicalPlus:setIcon("icon_fight_population.png")
	elseif not self.isInNebulaAllStar then
		self.spriteWeight:setIcon("icon_fight_weight.png")
		self.btnPhysicalPlus:setIcon("icon_battle_add.png")
	end
	self:_setControllerC1ByTextTip()
	if self.instanceType == gMapObjTypeDef.mapObjTypeResource or self.dispatchType == worldMapDefine.worldMapTipButtonType_caiji then
		if self.instanceID then
			local bid = string.split(self.instanceID, "_")
			if tonumber(bid[2]) == 3725 then
				self.spriteWeight:setIcon("icon_small_crystal.png")
			else
				self.spriteWeight:setIcon(resDesRead.getMIcon(self.otherData.resourceType))
			end
		else
			self.spriteWeight:setIcon(resDesRead.getMIcon(self.otherData.resourceType))
		end
	elseif self.dispatchType == worldMapDefine.worldMapTipButtonType_xuanZhan then
		self.btnMilitary:setVisible(SoraDIsMilitaryFOpen())
		self.nodeTitle:updateTitle(i18n("common_text_292"))
		self.labelGoTitle:setString(i18n("common_text_292"))
	elseif self.dispatchType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu then
		self.nodeTitle:updateTitle(i18n("common_text_483"))
		self.labelGoTitle:setString(i18n("common_text_483"))
	elseif self.dispatchType == worldMapDefine.worldMapTipButtonType_xiefang then
	elseif self.dispatchType == worldMapDefine.worldMapTipButtonType_zuduiwajue or self.dispatchType == worldMapDefine.worldMapTipButtonType_wajue then
		self.nodeTitle:updateTitle(i18n("AncienTreasure_text_55"))
	else
		if self.dispatchType == worldMapDefine.worldMapTipButtonType_duel then
			self.nodeTitle:updateTitle(i18n("lordskill_name_11055"))
		else
		end
	end
	if self.instanceType == gMapObjTypeDef.mapTypeWrathBeast or self.instanceType == gMapObjTypeDef.mapTypeRadianceWarResource or self.otherData.mainInstanceType == gMapObjTypeDef.mapTypeWrathBeast then
		self.spriteWeight:setVisible(false)
		self.btnPhysicalPlus:setVisible(false)
		self.labelWeight:setVisible(false)
	end
	self:initScroll()
	self:_defaultHeroAndArmyQuick()
	if worldMapDefine.worldMapTipButtonType_alliancepet_3 == self.otherData.realDispatchType then
		local petType = alliancePetCtrl:getAlliancePetType()
		local petLv = alliancePetCtrl:getAlliancePetLv()
		self.needPhysical = alliancePetRead.getStamina(petType, petLv)
	end
	self:_maybeCommandHallGuide()
end
function WorldDispatchArmyViewPanel:sortTableArmy(isNeedUpdate)
	self.sortType = SoraDConfigGet("Game:worldDispatchArmySelectViewPanel:saveSort~integer")
	for _, v in ipairs(self.armyIDList) do
		v.sortOrder = v.soldierType == self.sortType and 100 or 0
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.isForbid ~= army2.isForbid then
			return army2.isForbid
		end
		if army1.sortOrder ~= army2.sortOrder then
			return army1.sortOrder > army2.sortOrder
		end
		if army1.level ~= army2.level then
			return army2.level < army1.level
		end
		return army1.armyID < army2.armyID
	end)
	local _ENV, newTableArmy = table.sort, table.sort
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local isInTableArmy = false
		for _, v2 in ipairs(self.tableArmy) do
			if v2 == id then
				isInTableArmy = true
				break
			end
		end
		if isInTableArmy then
			table.insert(newTableArmy, id)
		end
	end
	self.tableArmy = newTableArmy
	if isNeedUpdate then
		self:updateScrollList()
	end
end
function WorldDispatchArmyViewPanel:initMassView(isJoinMass)
	local offset = 0
	local showMass = false
	local occupyQueueArmyMinLv = self:getOccupyQueueArmyMinLv()
	if isJoinMass then
		local store = fguiHelper.get_fields(self.nodeMass)
		store.Text_title_mass:setString(i18n("common_text_4524"))
		for i = 4, 1, -1 do
			local node = store["icon_mass_army_0" .. i]
			if node then
				if self.otherData and self.otherData.massSlaveForbidArmyClass and self.otherData.massSlaveForbidArmyClass[tostring(i)] then
					node:setVisible(false)
				else
					node:setVisible(true)
				end
			end
		end
		local massSlaveArmyMinLv = self.otherData and self.otherData.massSlaveArmyMinLv or 1
		local lvStr = "atlantiswar_text_0277"
		if 0 < occupyQueueArmyMinLv and occupyQueueArmyMinLv > massSlaveArmyMinLv then
			massSlaveArmyMinLv = occupyQueueArmyMinLv
			lvStr = "atlantiswar_text_0301"
		end
		_ENV = store["icon_mass_army_0" .. i]
		_ENV, _ENV, store["icon_mass_army_0" .. i].var = massSlaveArmyMinLv, armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv), armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv)
		armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv).var, massSlaveArmyMinLv.color = massSlaveArmyMinLv, "#FFD43E"
		local curLvStr = i18n_html(lvStr, store["icon_mass_army_0" .. i], (armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv)))
		store.Text_title_lv:setString(curLvStr)
		offset = 135
		showMass = true
	elseif 0 < occupyQueueArmyMinLv then
		local store = fguiHelper.get_fields(self.nodeMass)
		store.Text_title_mass:setVisible(false)
		store.Node_mass_army:setVisible(false)
		_ENV = false
		_ENV, _ENV, (false).var = occupyQueueArmyMinLv, armyDesRead.getMassLimitArmyLvStr(occupyQueueArmyMinLv), armyDesRead.getMassLimitArmyLvStr(occupyQueueArmyMinLv)
		armyDesRead.getMassLimitArmyLvStr(occupyQueueArmyMinLv).var, occupyQueueArmyMinLv.color = occupyQueueArmyMinLv, "#FFD43E"
		local curLvStr = i18n_html("atlantiswar_text_0301", false, (armyDesRead.getMassLimitArmyLvStr(occupyQueueArmyMinLv)))
		store.Text_title_lv:setString(curLvStr)
		offset = 135
		showMass = true
	end
	self.massSlaveArmyMinNum = nil
	self.massSlaveArmyMaxNum = nil
	if showMass then
		local store = fguiHelper.get_fields(self.nodeMass)
		store.Text_title_count:setString(i18n("common_text_4887"))
		if self.otherData and self.otherData.massSlaveArmyMaxNum then
			self.massSlaveArmyMinNum = self.otherData.massSlaveArmyMinNum or 0
			self.massSlaveArmyMaxNum = self.otherData.massSlaveArmyMaxNum or 0
			store.Text_title_value:setString(string.format("%d-%d", self.otherData.massSlaveArmyMinNum or 0, self.otherData.massSlaveArmyMaxNum or 0))
		else
			store.Text_title_value:setString(i18n("common_text_4886"))
		end
	end
	self.nodeMass:setVisible(showMass)
	self.nodeHero:addMassHeight(offset)
end
function WorldDispatchArmyViewPanel:getOccupyQueueArmyMinLv(...)
	if worldMapDefine.isInAtlantis() and (self.otherData and self.otherData.mainInstanceType == gMapObjTypeDef.mapTypeAtlantisWarBuilding or self.instanceType == gMapObjTypeDef.mapTypeAtlantisWarBuilding) then
		local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
		local occupyQueueArmyMinLv = atlantisWarCtrl:getOccupyQueueArmyMinLv()
		if 1 < occupyQueueArmyMinLv then
			return occupyQueueArmyMinLv
		end
	end
	return 0
end
function WorldDispatchArmyViewPanel:updateMaxCount(maxCount)
	self.allowMaxCount = maxCount
	self:updateCountLabel()
	if self.isSelectFull and self.curCount > self.allCount then
		self:quickChoose(self.isSelectFull)
	end
end
function WorldDispatchArmyViewPanel:initScroll()
	self:updateScrollList()
end
function WorldDispatchArmyViewPanel:onArmyRenderer(index, obj)
	if self.isUpdateView then
		obj:updateView()
	else
		local armyid = self.tableArmy[index + 1]
		obj:initData(self.tableArmyData[armyid], index + 1)
	end
end
function WorldDispatchArmyViewPanel:updateScrollList()
	for __, v in pairs(self.tableArmyData) do
		v.sliderChangeHandle = handler(self, self.singleSliderChange)
	end
	self.isScrollInited = true
	self.fields.List_army:setNumItems(#self.tableArmy)
end
function WorldDispatchArmyViewPanel:singleSliderChange(target, data)
	dump(data, "singleSliderChange======")
	local curCount = self:setCurValByArmyid(data.armyid, data.armycount)
	self:updateView()
	if curCount ~= data.armycount then
		return true
	end
	return false
end
function WorldDispatchArmyViewPanel:updateView()
	self:updateLabelAndWeight()
	self:updateMoveTime()
	self:updateScroll()
end
_ENV, WorldDispatchArmyViewPanel.updateScroll = function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end, function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end
;(function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end)[1] = "report_tip_01"
;(function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end)[2] = "report_tip_02"
;(function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end)[3] = "report_tip_03"
;(function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end)[4] = "report_tip_04"
local (function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end)[5], textTips = "report_tip_05", function(self)
	if not self.isScrollInited then
		return
	end
	self.isUpdateView = true
	self.fields.List_army:setNumItems(#self.tableArmy)
	self.isUpdateView = false
end
function WorldDispatchArmyViewPanel:getTip()
	if self.npcPower == nil or self.npcPower == 0 then
		self.labelTip:setColor(display.COLOR_GREEN)
		return textTips[1]
	end
	local numTmp = self.armyPower / self.npcPower
	if 2 < numTmp then
		self.labelTip:setColor(display.COLOR_GREEN)
		return textTips[1]
	elseif 1.5 <= numTmp then
		self.labelTip:setColor(display.COLOR_GREEN)
		return textTips[2]
	elseif 0.9 <= numTmp then
		self.labelTip:setColor(display.COLOR_WHITE)
		return textTips[3]
	elseif 0.5 <= numTmp then
		self.labelTip:setColor(display.COLOR_RED)
		return textTips[4]
	elseif numTmp < 0.5 then
		self.labelTip:setColor(display.COLOR_RED)
		return textTips[5]
	end
end
function WorldDispatchArmyViewPanel:updateLabelAndWeight()
	self:updateCountLabel()
	self.armyPower = self:getPowerTotal()
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTotalArmy()
		local remainCount = math.max(0, totalArmy - self.curCount)
		self.labelWeight:setString(string.formatnumberthousands(remainCount))
		return
	end
	if self.bossType and self.bossType == gBossType.phoenixChallengeBoss then
		self.labelTip:setString(i18n("Phonex_Challenge_text_24"))
		self.labelTip:setColor(display.COLOR_GREEN)
	elseif self.bossType and self.bossType == gBossType.danateMeterialBoss then
		self.labelTip:setString(i18n("collect_activity_028"))
		self.labelTip:setColor(display.COLOR_GREEN)
	elseif self.bossType and self.bossType == gBossType.monkeyBoss then
		self.labelTip:setString(i18n("worldboss_monkey_13"))
		self.labelTip:setColor(display.COLOR_GREEN)
	else
		self.labelTip:setString(i18n(self:getTip()))
	end
	local physical = self:getPhysical_initData()
	if not physical then
		self.curWeight = 0
		local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus() + self.heroWeightAdd
		for _, v in pairs(self.tableArmyData) do
			self.curWeight = self.curWeight + v.weight * v.curCount * addWeight
		end
		if self.instanceType == gMapObjTypeDef.mapObjTypeResource or self.dispatchType == worldMapDefine.worldMapTipButtonType_caiji then
			if self.otherData.resourceType == gIDDef.GOLD then
				self.curWeight = self.curWeight / 1000
			elseif self.otherData.resourceType == gIDDef.IRON then
				self.curWeight = self.curWeight / 6
			elseif self.otherData.resourceType == gIDDef.MITHRIL then
				self.curWeight = self.curWeight / 24
			elseif self.otherData.resourceType == gIDDef.ALLIANCE_CRYSTAL_MINE or self.otherData.resourceType == gIDDef.CRYSTAL then
				self.curWeight = self.curWeight / 96
			end
		end
		self.labelWeight:setString(string.formatnumberthousands(math.floor(self.curWeight)))
	end
end
function WorldDispatchArmyViewPanel:updateMoveTime()
	local _ENV, needGetList
	for _, v in pairs(self.tableArmyData) do
		if v.curCount > 0 then
			_ENV = nil
			;(nil).id = v.armyid
			;(nil).num = v.curCount
			table.insert(needGetList, nil)
		end
	end
	if 0 < #needGetList then
		if self.isKipchaks then
			self.moveTime = 0
			self.labelTime:setString(SoraDConvertSecondToString(0))
		else
			local _ENV, godArmsList = self.labelTime.setString, self.labelTime.setString
			if self.nodeHero then
				if not self.nodeHero:exportArms() then
					_ENV = self.nodeHero:exportArms()
				end
				godArmsList = serviceFunctions.table_copy_table((self.nodeHero:exportArms()))
			end
			if not self.isGuide and not self.isRaiderLostArk and not self.isBeastCanyon and not self.activitySetting.noTime then
				_ENV = SoraDConvertSecondToString(0)
				SoraDConvertSecondToString(0).mainInstanceType = self.otherData.mainInstanceType
				SoraDConvertSecondToString(0).heroSpeedAdd = self.heroSpeedAdd
				SoraDConvertSecondToString(0).realDispatchType = self.otherData.realDispatchType
				SoraDConvertSecondToString(0).heroMarchMonsterAdd = self.heroMarchMonsterAdd
				SoraDConvertSecondToString(0).godArmsList = godArmsList
				SoraDConvertSecondToString(0).extraAttrAdd = self.extraAttrAdd
				SoraDConvertSecondToString(0).bossType = self.bossType
				SoraDConvertSecondToString(0).isJoinMass = self.isJoinMass
				SoraDConvertSecondToString(0).commandHallTaskID = self.otherData.commandHallTaskID
				SoraDConvertSecondToString(0).npcID = self.npcID
				local ret = kingdomMapCtrl:getArmyMoveTime(self.instanceType, self.dispatchType, needGetList, self.toPoint, SoraDConvertSecondToString(0))
				ret = math.ceil(ret)
				self.labelTime:setString(SoraDConvertSecondToString(ret))
				self.moveTime = ret
			end
		end
	else
		self.moveTime = 0
		self.labelTime:setString(SoraDConvertSecondToString(0))
	end
	self.armRuneCount = 0
	local armsList = self.nodeHero:exportArms()
	for k, v in ipairs(armsList) do
		local buffList = godArmsRuneCtrl:getRuneBuff(v)
		local runeAdd = buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] and buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST].val or 0
		self.armRuneCount = self.armRuneCount + runeAdd
	end
	local divineBeastInfo = self.nodeHero:exportDivineBeast()
	self.armyDivineBeastCount, self.isDivineBeastNotInCity = divineBeastCtrl:getDispatchAddCount(divineBeastInfo, gBuffEffect.MARCH_VALUE_LIMIT_BOOST, gHeroSelectBannerStyle.dispatch)
	self:updateCountLabel()
end
function WorldDispatchArmyViewPanel:btnCountPlusClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buffid = 19
		buffCtrl:queryCityBuff(buffid)
		_ENV = buffCtrl.queryCityBuff
		buffCtrl.queryCityBuff.bid = buffid
		buffCtrl.queryCityBuff.buffname = cityEffectInfoRead.getName(buffid)
		buffCtrl.queryCityBuff.bufdes = cityEffectInfoRead.getDes(buffid)
		local buffCtrl.queryCityBuff.buftip, tableBuff = cityEffectInfoRead.getTip(buffid), buffCtrl.queryCityBuff
		_ENV = nil
		;(nil).tableBuff = tableBuff
		uiManager:show("citybuffItemView", nil)
	end
end
function WorldDispatchArmyViewPanel:btnPhysicalPlusClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isInNebulaAllStar then
			uiManager:show("NebulaAllStarHospitalHelp")
			return
		end
		local physical = self:getPhysical_initData()
		if physical then
			self:physicalNotEnough()
		else
			SoraDShowHelpMsgTip(i18n("common_text_987"))
		end
	end
end
function WorldDispatchArmyViewPanel:btnConveneClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("召集士兵")
		SoraDCreatePanel("armyBuildingsView"):show()
	end
end
function WorldDispatchArmyViewPanel:btnFatClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:resetArmySelect()
		local _ENV, tableWeight = self.resetArmySelect, self.resetArmySelect
		for i, v in pairs(self.tableArmyData) do
			local curWeight = v.weight
			local insertI = #tableWeight + 1
			for j, w in ipairs(tableWeight) do
				if curWeight > w.weight then
					insertI = j
					break
				end
			end
			_ENV = nil
			;(nil).armyid = i
			;(nil).weight = curWeight
			table.insert(tableWeight, insertI, nil)
		end
		if self.dispatchType == worldMapDefine.worldMapTipButtonType_zhanLing and self.instanceType == gMapObjTypeDef.mapObjTypeResource then
			local multiple = self.otherData.resourceType == gIDDef.GOLD and 1000 or self.otherData.resourceType == gIDDef.IRON and 6 or self.otherData.resourceType == gIDDef.MITHRIL and 24 or self.otherData.resourceType == gIDDef.CRYSTAL and 96 or 1
			local curResCount = self.otherData.currentSourceNum * multiple
			local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus() + self.heroWeightAdd
			for _, v in ipairs(tableWeight) do
				local armyMax = self:getArmyCount(v.armyid)
				local armyWeight = v.weight * addWeight
				local armyCount = math.min(armyMax, math.ceil(curResCount / armyWeight))
				self:setCurValByArmyid(v.armyid, armyCount)
				curResCount = math.max(0, curResCount - armyCount * armyWeight)
			end
		else
			for _, v in ipairs(tableWeight) do
				self:setCurValMax(v.armyid)
			end
		end
		self:updateView()
	end
end
function WorldDispatchArmyViewPanel:showTip(target)
	self.imgFatTip:setOpacity(0)
	self.imgFatTip:stopAllActions()
	self.imgFastTip:setOpacity(0)
	self.imgFastTip:stopAllActions()
	_UPVALUE2_ = nil
	;(nil)[1] = cca.fadeIn(0.5)
	;(nil)[2] = cca.delay(3)
	;(nil)[3] = cca.fadeOut(0.5)
	;(nil)[4] = cca.fadeOut(0.5)
	target:runAction(cca.seq(nil))
end
function WorldDispatchArmyViewPanel:btnFastClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local haveQB = false
		for _, armyid in ipairs(self.tableArmy) do
			if armyltCtrl.getSoldierType(armyid) == gSoldierType.SOLDIER_TYPE_QIBING then
				haveQB = true
				break
			end
		end
		if haveQB then
			self:resetArmySelect()
			for _, armyid in ipairs(self.tableArmy) do
				if armyltCtrl.getSoldierType(armyid) == gSoldierType.SOLDIER_TYPE_QIBING then
					self:setCurValMax(armyid)
				end
			end
			self:updateView()
		else
			SoraDShowMsgTip(i18n("common_text_2751"), "#icon_fight_speed_rank.png")
		end
	end
end
function WorldDispatchArmyViewPanel:physicalNotEnough(type)
	if type == nil or type == MSGBOX_CALLBACK_YES then
		SoraDCreatePanel("physicalBuyView"):show()
	end
end
function WorldDispatchArmyViewPanel:updateBtnText()
	if self.isSelectFull then
		self.btnQuickChoose:setTitle(i18n("common_btn_18"))
	else
		self.btnQuickChoose:setTitle(i18n("common_text_852"))
	end
end
function WorldDispatchArmyViewPanel:quickChoose(isFull)
	self:quickChoose_hero(isFull)
	self:quickChoose_army(isFull)
	self:updateBtnText()
end
function WorldDispatchArmyViewPanel:quickChoose_hero(isFull)
	if isFull then
		self.nodeHero:autoFillHeros()
	else
		self.nodeHero:clearHeros()
	end
	self:updateHeroEx()
end
function WorldDispatchArmyViewPanel:quickChoose_army(isFull)
	local armyData = gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname, "armyData")
	if armyData then
		for armyid in pairs(self.tableArmyData) do
			if armyData[armyid] then
				local singleMax = self:getArmyCount(armyid)
				self:setCurValByArmyid(armyid, math.min(singleMax, armyData[armyid]))
			else
				self:setCurValByArmyid(armyid, 0)
			end
		end
	elseif isFull then
		if self.instanceType == gMapObjTypeDef.mapTypeRamadanFeast then
			local totalSoldierCount = 100
			for _, armyid in pairs(self.tableArmy) do
				local armyData = self.tableArmyData[armyid]
				if armyData and armyltCtrl.getSoldierType(armyid) == gSoldierType.SOLDIER_TYPE_QIBING and 0 < totalSoldierCount then
					local armyCount = math.min(armyData.armycount, 100)
					self:setCurValByArmyid(armyid, armyCount)
					totalSoldierCount = totalSoldierCount - armyCount
				end
			end
			for _, armyid in pairs(self.tableArmy) do
				local armyData = self.tableArmyData[armyid]
				if armyData and armyltCtrl.getSoldierType(armyid) ~= gSoldierType.SOLDIER_TYPE_QIBING and 0 < totalSoldierCount then
					local armyCount = math.min(armyData.armycount, totalSoldierCount)
					self:setCurValByArmyid(armyid, armyCount)
					totalSoldierCount = totalSoldierCount - armyCount
				end
			end
			self:updateView()
			return
		end
		if self.dispatchType == worldMapDefine.worldMapTipButtonType_zhanLing and self.instanceType == gMapObjTypeDef.mapObjTypeResource then
			local multiple = self.otherData.resourceType == gIDDef.GOLD and 1000 or self.otherData.resourceType == gIDDef.IRON and 6 or self.otherData.resourceType == gIDDef.MITHRIL and 24 or self.otherData.resourceType == gIDDef.CRYSTAL and 96 or 1
			local curResCount = self.otherData.currentSourceNum * multiple
			local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus() + self.heroWeightAdd
			for _, armyid in pairs(self.tableArmy) do
				local armyData = self.tableArmyData[armyid]
				if armyData then
					local armyWeight = armyData.weight * addWeight
					local armyCount = math.min(armyData.armycount, math.ceil(curResCount / armyWeight))
					self:setCurValByArmyid(armyid, armyCount)
					curResCount = math.max(0, curResCount - armyCount * armyWeight)
				end
			end
		else
			for _, armyid in pairs(self.tableArmy) do
				self:setCurValMax(armyid)
			end
		end
	else
		self:resetArmySelect()
	end
	self:updateView()
	self.isSelectFull = isFull
end
function WorldDispatchArmyViewPanel:btnQuickClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:quickChoose(not self.isSelectFull)
	end
end
function WorldDispatchArmyViewPanel:checkPhysicalEnough(needPhysical)
	local physical = lordInfoCtrl:getBaseInfo().physical
	if needPhysical > physical then
		SoraDShowMsgBox(i18n("common_text_988"), i18n("common_text_204"), nil, handler(self, self.physicalNotEnough))
		return false
	end
	return true
end
function WorldDispatchArmyViewPanel:btnGoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isKipchaks then
			self:tryDispatchKipchaks()
			return
		end
		if self.isGuide then
			self:removeFromParent()
			return
		end
		local _ENV, dispatchArmyList = self.removeFromParent, self.removeFromParent
		for _, v in pairs(self.tableArmyData) do
			if v.curCount > 0 then
				_ENV = nil
				;(nil).id = v.armyid
				;(nil).num = math.floor(v.curCount)
				table.insert(dispatchArmyList, nil)
			end
		end
		local heroInfo = self.nodeHero:exportNewHeros()
		local armsInfo = self.nodeHero:exportArms()
		local divineBeastInfo = self.nodeHero:exportDivineBeast()
		local _ENV, ret = self.nodeHero, self.nodeHero
		for _, v in ipairs(heroInfo) do
			local hInfo = heroCtrl:getHeroInfoByID(v.heroID)
			if v.slaveHeroID then
				local slaveHeroInfo = heroCtrl:getHeroInfoByID(v.slaveHeroID)
				if slaveHeroInfo.state ~= gHeroState.HERO_STATE_NORMAL and slaveHeroInfo.state ~= gHeroState.HERO_STATE_DEFEND then
					v.slaveHeroID = nil
				end
			end
			if hInfo and (hInfo.state == gHeroState.HERO_STATE_NORMAL or hInfo.state == gHeroState.HERO_STATE_DEFEND) then
				table.insert(ret, v)
			end
		end
		heroInfo = ret
		local _ENV, ret = ipairs(heroInfo)
		for i, v in ipairs(divineBeastInfo) do
			if divineBeastCtrl:getIsInCity(v) then
				table.insert(ret, v)
			end
		end
		divineBeastInfo = ret
		if self.isRaiderLostArk then
			raidersLostArkCtrl:reqRobbery(self.targetID, self.itemID, armsInfo, dispatchArmyList, heroInfo, divineBeastInfo)
			SoraDShowLoading(self)
			SoraDRemoveAllAfterPanelFromManager(self)
			return
		end
		if self.massSlaveArmyMinNum and self.massSlaveArmyMaxNum and (self.curCount < self.massSlaveArmyMinNum or self.curCount > self.massSlaveArmyMaxNum) then
			SoraDShowMsgTip(i18n("common_text_4902"))
			return
		end
		if self.otherData.mainInstanceType ~= gMapObjTypeDef.sweetMeatRobber and (self.dispatchType == worldMapDefine.worldMapTipButtonType_xuanZhan or self.dispatchType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu) and not allianceMgr:hasJoinAlliance(true) then
			SoraDShowMsgTip(i18n("common_text_583"))
			return
		elseif self.curCount > self.allCount and self.heroChange then
			SoraDShowMsgTip(i18n("hero_text_02"))
			self:resetArmySelect()
			self:updateView()
			self.isSelectFull = false
			self:updateBtnText()
			return
		elseif 0 < #dispatchArmyList then
			if self.dispatchCallback then
				_ENV = self
				self.armyList = dispatchArmyList
				self.heroInfo = heroInfo
				self.armsInfo = armsInfo
				self.divineBeastInfo = divineBeastInfo
				if self.dispatchCallback(self) then
					SoraDShowLoading(self)
					SoraDRemoveAllAfterPanelFromManager(self)
					return
				end
			end
			if self.isBeastCanyon then
				local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
				_ENV = i18n("hero_text_02")
				i18n("hero_text_02").bossType = self.targetID
				i18n("hero_text_02").armyList = dispatchArmyList
				i18n("hero_text_02").heroInfo = heroInfo
				i18n("hero_text_02").armsInfo = armsInfo
				i18n("hero_text_02").divineBeastInfo = divineBeastInfo
				beastCanyonCtrl:reqDivineBeastCanyonChallenge(self.isBeastCanyon, i18n("hero_text_02"))
				SoraDShowLoading(self)
				SoraDRemoveAllAfterPanelFromManager(self)
				return
			end
			local physical = self:getPhysical_initData()
			if physical and not self:checkPhysicalEnough(physical) then
				return
			end
			if self.instanceType == gMapObjTypeDef.mapTypeHuntFair then
				local curKillIceHuntingNum = lordInfoCtrl:getKillSnowMansNum()
				local totalKill = include("constantRead").getConstValue("HUNTFAIR_DAY_KILLMAX")
				if curKillIceHuntingNum > totalKill then
					SoraDShowMsgTip(i18n("hero_text_02"))
					return
				end
			elseif self.instanceType == gMapObjTypeDef.mapTypeWrathBeast or self.otherData.mainInstanceType == gMapObjTypeDef.mapTypeWrathBeast then
				if not self:checkAttackNumEnough() then
					SoraDRemoveAllPrePanelFromManager(self)
					return
				end
			elseif self.dispatchType == worldMapDefine.worldMapTipButtonType_duel and self.curCount < MIN_DUEL_ARMY_NUM then
				SoraDShowMsgTip(i18n("lordskill_text_10"))
				return
			end
			if self:needLegendWarSoldierNumCheck() then
				local limitNum = self:getLegendWarSoldierLimitNum()
				if limitNum > self.curCount then
					local numStr = string.formatnumberthousands(limitNum)
					local tipStr = ""
					if self.dispatchType == worldMapDefine.worldMapTipButtonType_gongJi then
						_ENV = i18n("lordskill_text_10")
						i18n("lordskill_text_10").num = numStr
						tipStr = i18n("legendaryking_text_112", i18n("lordskill_text_10"))
					elseif self.dispatchType == worldMapDefine.worldMapTipButtonType_xuanZhan then
						_ENV = i18n("lordskill_text_10")
						i18n("lordskill_text_10").num = numStr
						tipStr = i18n("legendaryking_text_113", i18n("lordskill_text_10"))
					end
					SoraDShowMsgTip(tipStr)
					return
				end
			end
			local dispatchFun = function(callType)
				if callType == nil or callType == MSGBOX_CALLBACK_YES then
					SoraDCheckSecondaryLock(function(isVerified)
						if tolua.isnull(self) then
							print("对象已经被释放")
							return
						end
						_ENV = print
						print.dispatchType = self.dispatchType
						print.otherData = self.otherData
						print.toPoint = self.toPoint
						print.instanceID = self.instanceID
						print.heroInfo = heroInfo
						print.armsInfo = armsInfo
						print.divineBeastInfo = divineBeastInfo
						print.armyList = dispatchArmyList
						print.isKillLeaderNpc = self.isKillLeaderNpc
						local print.killNormalNpcLv, armyData = self.killNormalNpcLv, print
						worldMapFunction.gotoDispatch(armyData, true, isVerified)
						if self.dispatchType == worldMapDefine.worldMapTipButtonType_xuanZhan then
							SoraDPlaySound("worldmap", 15)
						else
							SoraDPlaySound("worldmap", 2)
						end
						local physical = self:getPhysical_initData()
						if physical then
							_ENV = 2
							;(2).msg = "MESSAGE_WORLD_MAP_DISPATCH_ARMY"
							;(2).hp = physical
							SoraDSendMessage(2)
						end
						local guideStep = gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname, "isGuide")
						if guideStep then
							local guideCtrl = gametop.playertop_:getModule("guideCtrl")
							guideCtrl:CompleteGuideStep(guideStep)
						end
						local guideCtrl = gametop.playertop_:getModule("guideCtrl")
						local firstKill = guideCtrl:isGuideOpen(gGuideModule.FIRST_ATTACK_MONSTER) and guideCtrl:isStep(gGuideStep.FIRST_ATTACK_MONSTER_STEP_1) and self.instanceType == gMapObjTypeDef.mapObjTypeNpc
						print("是第一次击杀怪物", firstKill)
						if firstKill then
							local view = include("gameGuideView").new()
							view:startGuideWithStep(650001)
							view:show()
							guideCtrl:CompleteGuideStep(650001)
						end
						if worldMapDefine.worldMapTipButtonType_gongJi == self.dispatchType or worldMapDefine.worldMapTipButtonType_xuanZhan == self.dispatchType or worldMapDefine.worldMapTipButtonType_lueduo == self.dispatchType then
							userSDKManager.report2firebase("reportPvp")
						end
						SoraDRemoveAllPrePanelFromManager(self)
					end, gSecondaryLockType.DispatchArmy)
				end
			end
			if self.dispatchType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
				local commandHallUtil = include("commandHallUtil")
				local taskID = self.otherData.commandHallTaskID
				_ENV = i18n("lordskill_text_10")
				i18n("lordskill_text_10").heroInfo = heroInfo
				i18n("lordskill_text_10").armyList = dispatchArmyList
				local isEnough, ret = commandHallUtil.checkRecommend(taskID, i18n("lordskill_text_10"))
				if not isEnough then
					_ENV = i18n("lordskill_text_10")
					i18n("lordskill_text_10").data = ret
					i18n("lordskill_text_10").callback = dispatchFun
					uiManager:show("CommandHallRecommend", i18n("lordskill_text_10"))
					return
				end
			end
			if self.instanceType == gMapObjTypeDef.mapTypeRamadanFeast then
				local gametop = gModuleMgr.getObject("gametop")
				local memberMgr = gametop.playertop_:getModule("memberMgr")
				local jointime = memberMgr:getOwnMember():getProperty("joinTime")
				local curtime = serviceFunctions.systemTime()
				local needtime = 43200
				if needtime > curtime - jointime then
					SoraDShowMsgTip(i18n("tips_hjyt_joinUnionTime_limit"))
					return
				end
				if self.feastAid then
					local selfLeagueID = allianceMgr:getOwnAid() or 0
					if selfLeagueID ~= self.feastAid then
						SoraDShowMsgTip(i18n("tips_feast_toDinnerUnion_limit"))
						return
					end
				end
				if self.feastLeftTime and self.feastLeftTime - serviceFunctions.systemTime() <= 300 then
					SoraDShowMsgTip(i18n("tips_feast_toDinnerTime_limit"))
					return
				end
			end
			if self.otherData and self.otherData.endTime and self.otherData.endTime <= self.moveTime + serviceFunctions.systemTime() then
				local showMsg = i18n("common_text_4278")
				SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), dispatchFun)
			else
				dispatchFun()
			end
		else
			SoraDShowMsgBox(i18n("notice_0158"), i18n("common_text_204"))
		end
	end
end
function WorldDispatchArmyViewPanel:btnClickMilitary(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("fortressBuffHaveView")
		panel:initData(self.isJoinMass and 1 or 2)
		panel:show()
	end
end
function WorldDispatchArmyViewPanel:onShow()
	local guideStep = SoraDIsGameGuide()
	if guideStep and guideStep == 2031 then
		buildLogic = nil
		;(nil)[1] = ffa.delay(0.1)
		;(nil)[2] = ffa.callFunc(function(...)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;(nil).step = 2032
			SoraDSendMessage(nil)
		end)
		;(nil)[3] = ffa.callFunc(function(...)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;(nil).step = 2032
			SoraDSendMessage(nil)
		end)
		self:runAction(ffa.seq(nil))
	end
	self.toPoint = nil
	self.dispatchType = nil
	self.instanceID = nil
	self.tableArmyData, _ENV, self.tableArmy, _ENV, self.tableSpare, _ENV, self.tableArmySingle, _ENV, self.otherData, _ENV, self.instanceType = self.runAction, self.runAction, self.runAction, self.runAction, self.runAction, self.runAction, self.runAction, self.runAction, self.runAction, self.runAction, nil
	self.allowMaxCount = nil
	self.heroCount = 0
	self.armRuneCount = 0
	self.armyDivineBeastCount = 0
	self.heroSpeedAdd = 0
	self.heroMarchMonsterAdd = 0
	self.heroWeightAdd = 0
	self.heroChange = true
	self.heroNotIn = false
	self.isNotEnoughArmy = false
	self.isKipchaks = false
	self.curCount = 0
	self.curWeight = 0
	self.isSelectFull = false
	self.extraAttrAdd = 0
	self.expArmyCountRet = buildLogic.getExpArmyCount(self.mapMoveLineType)
	self.labelGoTitle:setString(i18n("common_text_481"))
	self.nodeHero:clearHerosAndArms()
end
function WorldDispatchArmyViewPanel:onHide()
	SoraDCloseLoading(self)
end
function WorldDispatchArmyViewPanel:resetArmySelect()
	for _, v in pairs(self.tableArmyData) do
		v.curCount = 0
	end
	self.curCount = 0
end
function WorldDispatchArmyViewPanel:getArmyCurCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.curCount
	end
	return 0
end
function WorldDispatchArmyViewPanel:getArmyCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.armycount
	end
	return 0
end
function WorldDispatchArmyViewPanel:getPowerTotal()
	local armyltCtrl = include("armyltCtrl")
	local count = 0
	local power = 0
	local totalPower = 0
	for i, v in pairs(self.tableArmyData) do
		count = v.curCount
		power = armyltCtrl.getArmyAttrAndSp(v.armyid, ARMY_ATTR.POWER)
		totalPower = totalPower + count * power
	end
	return totalPower
end
function WorldDispatchArmyViewPanel:setCurValMax(armyid)
	local armyMax = self:getArmyCount(armyid)
	self:setCurValByArmyid(armyid, armyMax)
end
function WorldDispatchArmyViewPanel:setCurValByArmyid(armyid, curCount)
	local armyData = self.tableArmyData[armyid]
	if not armyData then
		print("setCurValByArmyid error", armyid, curCount)
		return 0
	end
	if curCount > armyData.armycount then
		print("setCurValByArmyid armycount error", armyid, curCount)
		return 0
	end
	if armyData.isForbid then
		return 0
	end
	local curArmyCount = self.curCount
	if 0 < armyData.curCount then
		curArmyCount = self.curCount - armyData.curCount
		if curArmyCount < 0 then
			print("setCurValByArmyid curCount error", armyid, curCount)
			return 0
		end
	end
	local allCount = self.allCount
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTotalArmy()
		allCount = math.min(totalArmy, allCount)
	end
	if allCount < curArmyCount + curCount and 0 < curCount then
		curCount = allCount - curArmyCount
		curCount = math.max(curCount, 0)
	end
	armyData.curCount = curCount
	self.curCount = curArmyCount + curCount
	return curCount
end
function WorldDispatchArmyViewPanel:setCurValByIndex(index, curCount)
	local armyid = self.tableArmy[index]
	if checknumber(armyid) > 0 then
		return self:setCurValByArmyid(armyid, curCount)
	else
		print("setCurValByIndex error", index, curCount)
	end
	return 0
end
function WorldDispatchArmyViewPanel:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
function WorldDispatchArmyViewPanel:selectArmyTypeByFun(sortFun)
	table.sort(self.armyIDList, sortFun)
	self:resetArmySelect()
	if self.dispatchType == worldMapDefine.worldMapTipButtonType_zhanLing and self.instanceType == gMapObjTypeDef.mapObjTypeResource then
		local multiple = self.otherData.resourceType == gIDDef.GOLD and 1000 or self.otherData.resourceType == gIDDef.IRON and 6 or self.otherData.resourceType == gIDDef.MITHRIL and 24 or self.otherData.resourceType == gIDDef.CRYSTAL and 96 or 1
		local curResCount = self.otherData.currentSourceNum * multiple
		local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus() + self.heroWeightAdd
		for _, v in ipairs(self.armyIDList) do
			local armyid = v.id
			local armyData = self.tableArmyData[armyid]
			if armyData then
				local armyWeight = armyData.weight * addWeight
				local armyCount = math.min(armyData.armycount, math.ceil(curResCount / armyWeight))
				self:setCurValByArmyid(armyid, armyCount)
				curResCount = math.max(0, curResCount - armyCount * armyWeight)
			end
		end
	else
		for _, v in ipairs(self.armyIDList) do
			self:setCurValMax(v.id)
		end
	end
	self:updateView()
end
function WorldDispatchArmyViewPanel:selectArmyType_imp(selectType)
	local createFunBytype = function(armyType)
		local sortFun = function(army1, army2)
			if army1.isForbid ~= army2.isForbid then
				return army2.isForbid
			end
			if army1.soldierType ~= army2.soldierType and (army1.soldierType == armyType or army2.soldierType == armyType) then
				return army1.soldierType == armyType
			end
			if army1.level ~= army2.level then
				return army1.level > army2.level
			end
			return army1.armyID < army2.armyID
		end
		return sortFun
	end
	if selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_BUBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_BUBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_QIBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_QIBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_GONGBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_GONGBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_CHEBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_CHEBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_WEIGHT then
		local sortFun = function(army1, army2)
			if army1.isForbid ~= army2.isForbid then
				return army2.isForbid
			end
			if army1.weight ~= army2.weight then
				return army1.weight > army2.weight
			end
			if army1.level ~= army2.level then
				return army1.level > army2.level
			end
			return army1.armyID < army2.armyID
		end
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_LEVEL then
		local sortFun = function(army1, army2)
			if army1.isForbid ~= army2.isForbid then
				return army2.isForbid
			end
			if army1.level ~= army2.level then
				return army1.level > army2.level
			end
			return army1.armyID < army2.armyID
		end
		self:selectArmyTypeByFun(sortFun)
	end
end
function WorldDispatchArmyViewPanel:OnBtnFilerClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("worldDispatchArmySelectView")
	end
end
function WorldDispatchArmyViewPanel:selectArmyType(target, redata)
	if redata and redata.selectType then
		self:selectArmyType_imp(redata.selectType)
	elseif redata and redata.sort then
		self:sortTableArmy(true)
	elseif redata and redata.defaultHero then
		self:quickChoose_hero(redata.defaultHero > 0)
	end
end
function WorldDispatchArmyViewPanel:updateHero()
	self:stopActionByTag(996)
	local seq = ffa.seq(ffa.delay(0), ffa.callFunc(handler(self, self.updateHeroEx)))
	seq:setTag(996)
	self:runAction(seq)
end
function WorldDispatchArmyViewPanel:updateHeroEx()
	self:stopActionByTag(996)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroInfo = self.nodeHero:exportHeros()
	local lieutenantInfo = self.nodeHero:exportLieutenantHeros()
	local revertHeros = self.nodeHero:exporLieutenant2MainHeroMap()
	local heroBuff = heroltCtrl:getSomeSkillValue(heroInfo, nil, lieutenantInfo, revertHeros)
	local heroSpeedAdd = heroBuff[gBuffEffect.MARCH_SPEED_BOOST] or 0
	local heroWeightAdd = heroBuff[gBuffEffect.SOLDIER_LOAD_BOOST] or 0
	local heroMarchMonsterAdd = heroBuff[gBuffEffect.MARCH_MONSTER_SPEED_BOOST] or 0
	local heroCount = heroltCtrl:getHerosMarchCapacity(heroInfo, true)
	local hero_dressAdd = 0
	local ret, add = heroltCtrl:isHaveDressHero(heroInfo)
	if next(heroBuff) and ret then
		hero_dressAdd = add
		local _ENV, lieRetTab = next(heroBuff), next(heroBuff)
		if commonCheck.HERO_COMBOS_SKILL then
			for _, v in ipairs(lieutenantInfo) do
				local hInfo = heroCtrl:getHeroInfoByID(v)
				local mainHeroID = revertHeros and revertHeros[tostring(v)]
				lieRetTab = heroCtrl:getLieutenantBuffList(lieRetTab, hInfo, nil, true, mainHeroID)
			end
		end
		if lieRetTab[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] then
			heroCount = heroCount + lieRetTab[gBuffEffect.MARCH_VALUE_LIMIT_BOOST]
		end
		local _ret, _add = heroltCtrl:isHaveDressHero(lieutenantInfo)
		if _ret then
			heroCount = heroCount - _add
		end
	end
	self.heroCount = heroCount - hero_dressAdd
	self.heroSpeedAdd = heroSpeedAdd
	self.heroWeightAdd = heroWeightAdd / 1000
	self.heroMarchMonsterAdd = heroMarchMonsterAdd
	self.armRuneCount = 0
	local armsList = self.nodeHero:exportArms()
	for k, v in ipairs(armsList) do
		local buffList = godArmsRuneCtrl:getRuneBuff(v)
		local runeAdd = buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] and buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST].val or 0
		self.armRuneCount = self.armRuneCount + runeAdd
	end
	local divineBeastInfo = self.nodeHero:exportDivineBeast()
	self.armyDivineBeastCount, self.isDivineBeastNotInCity = divineBeastCtrl:getDispatchAddCount(divineBeastInfo, gBuffEffect.MARCH_VALUE_LIMIT_BOOST, gHeroSelectBannerStyle.dispatch)
	print("容量：" .. self.heroCount, self.armRuneCount, self.heroWeightAdd, self.heroSpeedAdd, self.heroMarchMonsterAdd, self.armyDivineBeastCount)
	self.heroNotIn = false
	for k, v in ipairs(heroInfo) do
		local hInfo = heroCtrl:getHeroInfoByID(v)
		if hInfo.state ~= gHeroState.HERO_STATE_NORMAL then
			self.heroNotIn = true
			break
		end
	end
	if 0 < self.heroCount + self.armRuneCount + self.armyDivineBeastCount then
		self.heroChange = true
	end
	self:updateCountLabel()
	self:updateLabelAndWeight()
	self:updateMoveTime()
end
function WorldDispatchArmyViewPanel:checkAttackNumEnough(...)
	local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
	local atkTimes = wrathBeastCtrl:getActivityData("atkTimes")
	if 1 <= atkTimes then
		return true
	end
	if wrathBeastCtrl:getLeftBuyTimes() <= 0 then
		SoraDShowMsgBox(i18n("god_beast_text_27"), i18n("common_text_204"))
		return false
	else
		SoraDCreatePanel("worldMapWrathBeastBuy"):show()
		return false
	end
	return false
end
function WorldDispatchArmyViewPanel:getPhysical_initData(...)
	if self.otherData.realDispatchType == worldMapDefine.worldMapTipButtonType_alliancepet_3 then
		return self.needPhysical
	end
	if self.dispatchType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
		local commandHallRead = include("commandHallRead")
		local taskID = self.otherData.commandHallTaskID
		local physical = taskID and commandHallRead.getTaskConsume(taskID) or 0
		return physical
	end
	if worldMapDefine.isInNebula() and self.instanceType == gMapObjTypeDef.mapObjTypeNpc then
		local nebulaWarRead = include("nebulaWarRead")
		local physical = nebulaWarRead.getMonsterConsume(self.npcID)
		return physical
	end
	if self.instanceType == gMapObjTypeDef.roaringFlameWarNpc then
		local roaringFlameWarUtil = include("roaringFlameWarUtil")
		local rate = roaringFlameWarUtil.getMonsterRate()
		local physical = HP_MIN_MONSTER_CHEST * rate
		return physical
	end
	_ENV = roaringFlameWarUtil
	include("roaringFlameWarUtil")[gBossType.fireDragon1] = true
	local _ENV, include("roaringFlameWarUtil")[gBossType.monsterInvasionBoss], config1 = gBossType.monsterInvasionBoss, true, include("roaringFlameWarUtil")
	local gBossType.monsterInvasionBoss[gMapObjTypeDef.fireDragon2], config2 = true, gBossType.monsterInvasionBoss
	if config1[self.bossType] or config2[self.otherData.mainInstanceType] then
		local physical = worldMapDefine.getWorldBossStamina(self.bossType, 1)
		return physical
	end
	_ENV = physical
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.mapObjTypeNpc] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.nebulaNpc] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.mapTypeMonsterFiesta] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.mapTypeFortyThieves] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.mapTypeSemluk] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.footballMonster] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.mapTypeHuntFair] = true
	worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.fireDragon1] = true
	local _ENV, worldMapDefine.getWorldBossStamina(self.bossType, 1)[gMapObjTypeDef.nebulaDefenceWarBuilding], config1 = gMapObjTypeDef.nebulaDefenceWarBuilding, true, worldMapDefine.getWorldBossStamina(self.bossType, 1)
	local gMapObjTypeDef.nebulaDefenceWarBuilding[gMapObjTypeDef.nebulaDefenceWarBuilding], config2 = true, gMapObjTypeDef.nebulaDefenceWarBuilding
	if config1[self.instanceType] or config2[self.otherData.mainInstanceType] then
		local physical = self.isInRemains and 1 or HP_MIN_MONSTER_CHEST
		return physical
	end
	_ENV = physical
	HP_MIN_MONSTER_CHEST[gMapObjTypeDef.mapObjTypeBoss] = true
	HP_MIN_MONSTER_CHEST[gMapObjTypeDef.mapTypeHeroBattleBoss1] = true
	HP_MIN_MONSTER_CHEST[gMapObjTypeDef.mapTypeHeroBattleBoss2] = true
	HP_MIN_MONSTER_CHEST[gMapObjTypeDef.mapTypeWerewolf] = true
	HP_MIN_MONSTER_CHEST[gMapObjTypeDef.fireDragon2] = true
	HP_MIN_MONSTER_CHEST[gMapObjTypeDef.wastelandBoss] = true
	local HP_MIN_MONSTER_CHEST[gMapObjTypeDef.sweetMeatRobber], config = true, HP_MIN_MONSTER_CHEST
	if config[self.otherData.mainInstanceType] then
		local physical = self.isInRemains and 1 or HP_MIN_BOSS
		return physical
	end
	if worldMapDefine.isWorldBossCanAttackAlone(self.bossType, 1) then
		local physical = self.isInRemains and 1 or HP_MIN_BOSS
		return physical
	end
end
function WorldDispatchArmyViewPanel:check_showTextTip(...)
	_ENV = nil
	;(nil)[gMapObjTypeDef.mapObjTypeNpc] = true
	;(nil)[gMapObjTypeDef.nebulaNpc] = true
	;(nil)[gMapObjTypeDef.mapTypeMonsterFiesta] = true
	;(nil)[gMapObjTypeDef.mapTypeFortyThieves] = true
	;(nil)[gMapObjTypeDef.mapTypeSemluk] = true
	;(nil)[gMapObjTypeDef.footballMonster] = true
	;(nil)[gMapObjTypeDef.mapTypeHuntFair] = true
	;(nil)[gMapObjTypeDef.roaringFlameWarNpc] = true
	local (nil)[gMapObjTypeDef.captureMonkey], config = true, nil
	if config[self.instanceType] then
		return true
	end
	if worldMapDefine.isWorldBossCanAttackAlone(self.bossType, 1) then
		return true
	end
end
function WorldDispatchArmyViewPanel:initDataKipchaks(armyViewData, isMass)
	self.isKipchaks = true
	self.kipchaksBuildIndex = armyViewData.kipchaksBuildIndex or armyViewData.buildIndex
	self.toPoint, self.dispatchType, self.instanceID, self.instanceType, self.bossType = nil, nil, nil, nil, nil
	self.isJoinMass = false
	self.isRaiderLostArk, self.isBeastCanyon, self.isPhoenix = false, false, false
	self.activitySetting, buildLogic, self.activityID = false, false, 0
	self.dispatchCallback, self.isGuide = nil, false
	self.isKillLeaderNpc, self.killNormalNpcLv = nil, nil
	self.mapMoveLineType = nil
	self.expArmyCountRet = buildLogic.getExpArmyCount(nil)
	self.otherData, buildLogic, self.npcPower, self.npcID = 0, 0, 0, nil
	self:_setLabelTipByRemainsNebula()
	self:initMassView(false)
	if armyViewData.maxCount then
		self.allowMaxCount = armyViewData.maxCount
	end
	self:_setExtraAttrFromViewData(armyViewData)
	self:_initDispatchArmyListFromCtrl(isMass, true)
	self:updateCountLabel()
	if not self.isInNebulaAllStar then
		self.spriteWeight:setIcon("icon_fight_weight.png")
		self.btnPhysicalPlus:setIcon("icon_battle_add.png")
	end
	self:_setControllerC1ByTextTip()
	self:initScroll()
	self:_defaultHeroAndArmyQuick()
	self:_maybeCommandHallGuide()
	self.btnMilitary:setVisible(false)
	self.moveTime = 0
	self.labelTime:setString(SoraDConvertSecondToString(0))
	self.labelGoTitle:setString(i18n("Semruk_text_08"))
	self:updateView()
end
function WorldDispatchArmyViewPanel:tryDispatchKipchaks()
	local _ENV, dispatchArmyList
	for _, v in pairs(self.tableArmyData) do
		if v.curCount > 0 then
			_ENV = nil
			;(nil).id = v.armyid
			;(nil).num = math.floor(v.curCount)
			table.insert(dispatchArmyList, nil)
		end
	end
	local heroInfo = self.nodeHero:exportNewHeros()
	local _ENV, ret = self.nodeHero, self.nodeHero
	for _, v in ipairs(heroInfo) do
		local hInfo = heroCtrl:getHeroInfoByID(v.heroID)
		if v.slaveHeroID then
			local slaveHeroInfo = heroCtrl:getHeroInfoByID(v.slaveHeroID)
			if slaveHeroInfo.state ~= gHeroState.HERO_STATE_NORMAL and slaveHeroInfo.state ~= gHeroState.HERO_STATE_DEFEND then
				v.slaveHeroID = nil
			end
		end
		if hInfo and (hInfo.state == gHeroState.HERO_STATE_NORMAL or hInfo.state == gHeroState.HERO_STATE_DEFEND) then
			table.insert(ret, v)
		end
	end
	heroInfo = ret
	if self.curCount > self.allCount and self.heroChange then
		SoraDShowMsgTip(i18n("hero_text_02"))
		self:resetArmySelect()
		self:updateView()
		self.isSelectFull = false
		self:updateBtnText()
		return
	end
	if #dispatchArmyList == 0 then
		SoraDShowMsgBox(i18n("notice_0158"), i18n("common_text_204"))
		return
	end
	if not self.nodeHero:exportArms() then
		local _ENV, armsInfo = self.nodeHero:exportArms(), self.nodeHero:exportArms()
	end
	cityCtrl:reqKipchaksAttackReq(self.kipchaksBuildIndex, heroInfo, armsInfo, dispatchArmyList)
	SoraDShowLoading()
	SoraDRemoveAllAfterPanelFromManager(self)
end
function WorldDispatchArmyViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_go" then
		self.curCount = 0
		if parameters.armyData then
			for armyid, v in pairs(self.tableArmyData) do
				if parameters.armyData[armyid] then
					v.curCount = math.min(v.armycount, parameters.armyData[armyid])
				else
					v.curCount = 0
				end
				self.curCount = self.curCount + v.curCount
			end
		end
		if self.curCount <= 0 then
			self:quickChoose(true)
		else
			self:updateView()
		end
	elseif itemName == "Button_go2" then
		return self.fields.Button_go
	elseif itemName == "army_1" then
		return self.fields.List_army:getChildAt(0)
	elseif itemName == "hero_1" then
		return self.nodeHero.fields.List_hero:getChildAt(0).fields.Button_add
	end
	return SoraDGetChildByName(self, itemName)
end
return WorldDispatchArmyViewPanel
