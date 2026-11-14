local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local armyltCtrl = include("armyltCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local buildLogic = include("buildLogic")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local epicWarDispatchView = class("epicWarDispatchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarDispatchView")
	end
	return target
end)
function epicWarDispatchView:ctor()
	self.limitArmy = 0
	self.armySelectData, buildLogic, self.tableArmyData, buildLogic, self.tableArmy, buildLogic, self.tableSpare, buildLogic, self.tableArmySingle, buildLogic, self.singleData, buildLogic, self.selectArmyNum = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.allCount = buildLogic.getExpArmyCount().total
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_army")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.Button_challenge = SoraDGetChildByName(self, "Button_challenge")
	self.Button_challenge:setTitleText(i18n("arena_btn_04"))
	self.Button_challenge:addTouchEventListener(handler(self, self.btnChallengeClick))
	self.Button_fast = SoraDGetChildByName(self, "Button_fast")
	self.Button_fast:addTouchEventListener(handler(self, self.btnFastClick))
	self.Text_tip = SoraDGetChildByName(self.Button_fast, "Text_tip")
	self.Text_tip:setString(i18n("common_text_852"))
	self.Node_army = SoraDGetChildByName(self.Button_fast, "Node_army")
	self.Text_num = SoraDGetChildByName(self.Node_army, "Text_num")
	self.Text_limit = SoraDGetChildByName(self.Node_army, "Text_limit")
	self.ccs_heroBanner = SoraDGetExtendChildFromCCSByName(self, "CCS_heroSelectBanner_hero")
	self.ccs_heroBanner:setMode(gHeroSelectBannerStyle.epicDispatch)
	self.ccs_heroBanner:setInnerSelectCallBack(handler(self, self.updateHero))
	self.ccs_heroBanner:setRemoveCallBack(handler(self, self.updateHero))
	self.Node_team = SoraDGetChildByName(self, "Node_team")
	self.Button_team = SoraDGetChildByName(self, "Button_team")
	self:createTeamBtns()
	self:updataLieutenantUIPos()
end
function epicWarDispatchView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA", handler(self, self.adaptTeam))
end
function epicWarDispatchView:adaptTeam(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "redata.redata====", 10)
	if redata and redata.redata then
		local compile = redata.redata
		local heroList = redata.heroList
		local armsList = redata.armsList
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
		_ENV = i18n("common_text_204")
		self.ccs_heroBanner:filterHerosByMode(heroIDList, i18n("common_text_204"))
		self:updateHero()
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
		print("self.heroNotIn,self.isNotEnoughArmy====", self.heroNotIn, self.isNotEnoughArmy)
		if self.heroNotIn or self.isNotEnoughArmy then
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
			self:updateView()
			if self.isNotEnoughArmy then
				_ENV = i18n("common_text_204")
				i18n("common_text_204").closeCancel = true
				SoraDShowMsgBox(i18n("formation_no_soldier_desc"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						local addedCount = 0
						local _ENV, armyTypeList
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
						self:updateView()
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
						self:updateView()
					end
				end, i18n("common_text_204"))
			else
				_ENV = i18n("common_text_204")
				i18n("common_text_204").closeCancel = true
				SoraDShowMsgBox(i18n("formation_hero_notInCity_desc"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
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
						self:updateView()
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
						self:updateView()
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
		self:updateHero()
		self:updateView()
	end
end
function epicWarDispatchView:createTeamBtns()
	local totalNum = armyCtrl:getArmyCompileCount()
	for i = 1, totalNum do
		local btnTeam
		if i == 1 then
			btnTeam = self.Button_team
		else
			btnTeam = self.Button_team:clone()
			btnTeam:addTo(self.Node_team)
		end
		local Text_teamNum = btnTeam:getChildByName("Text_teamNum")
		SoraDSetTextWidthHeight(Text_teamNum, cc.size(50, 40))
		local tName = armyCtrl:getArmyCompileName(i)
		Text_teamNum:setString(tName or i)
		btnTeam:setPosition(0, 0)
		btnTeam:setLocalZOrder(i)
		btnTeam:setTag(i)
		btnTeam:addTouchEventListener(handler(self, self.btnTeamClickCallBack))
	end
	SoraDToCenter(self.Node_team, 10, SoraDFIsRA())
end
function epicWarDispatchView:btnTeamClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		armyCtrl:getArmyCompile(button:getTag())
		SoraDShowLoading(self)
	end
end
function epicWarDispatchView:updateHero()
	_UPVALUE1_ = nil
	_UPVALUE1_, (nil)[1] = self.scroll, self.scroll
	self.scroll[1] = self.scroll
	self.ccs_heroBanner:setFitHeroTacticUIs(nil, self.scroll)
end
function epicWarDispatchView:updataLieutenantUIPos()
	_UPVALUE1_ = nil
	;(nil)[1] = self.scroll
	for _, v in ipairs(nil) do
		v.originPosY = v:getPositionY()
	end
	self.scroll.originHeight = self.scroll:getContentSize().height
	self:updateHero()
end
function epicWarDispatchView:initData(curChapter, data)
	self.curChapter = curChapter
	self.singleData = data
	dump(self.singleData, "self.singleData====")
	self.nodeTitle:setTitle(self.singleData.Chaptername)
	self.limitArmy = epicWarltCtrl.getChapterLimitArmy(self.singleData.index)
	self.Text_limit:setString("/" .. self.limitArmy)
	local armyIDList = armyCtrl:getArmyIDList()
	local beginStep = guideCtrl:getStepByGuideModule(gGuideModule.NEW_EPIC_WAR)
	if guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR) and beginStep < 74001 then
		armyltCtrl = guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR)
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR)[1] = guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR), 401
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR)[2] = guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR), 501
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR)[3] = guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR), 601
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR)[4] = guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR), 701
	end
	self.armyIDList, _ENV = guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR), guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR)
	for _, v in ipairs(armyIDList) do
		local armyID = v % 1000
		local armyLv = armyID % 100
		local soldierType = armyltCtrl.getSoldierType(v)
		_ENV = v
		v.id = v
		v.armyID = armyID
		v.level = armyLv
		local v.soldierType, tableArmyID = soldierType, v
		table.insert(self.armyIDList, tableArmyID)
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.level ~= army2.level then
			return army2.level < army1.level
		end
		return army1.armyID < army2.armyID
	end)
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local haveCount = armyCtrl:getArmyCount(id, ARMY_OPTYPE.ALL_ARMY)
		if guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR) and beginStep < 74001 then
			local troopLimit = epicWarltCtrl.getChapterLimitArmy(1)
			table.insert(self.tableArmy, id)
			_ENV = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = troopLimit / #armyIDList
			self.tableArmyData[id], self.tableArmy.curCount = self.tableArmy, 0
		elseif 0 < haveCount then
			table.insert(self.tableArmy, id)
			_ENV = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = haveCount
			self.tableArmyData[id], self.tableArmy.curCount = self.tableArmy, 0
		end
	end
	self:initScroll()
	self:btnFastClick(self.Button_fast, ccui.TouchEventType.ended, true)
end
function epicWarDispatchView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
function epicWarDispatchView:initScroll()
	local scrollH = math.max(self.scroll:getContentSize().height, #self.tableArmy * 130)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	for i, armyid in ipairs(self.tableArmy) do
		local posY = scrollH - (i - 1) * 130
		_ENV = cc.size(640, scrollH)
		cc.size(640, scrollH).armyid = armyid
		cc.size(640, scrollH).posY = posY
		cc.size(640, scrollH).point = nil
		table.insert(self.tableArmySingle, cc.size(640, scrollH))
	end
	self:updateScrollList()
end
function epicWarDispatchView:updateScrollList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableArmySingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("worldDispatchArmySingle")
				single:setSliderChangeBack(handler(self, self.singleSliderChange))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				single:setVisible(true)
			end
			local armyData = self.tableArmyData[v.armyid]
			if armyData then
				single:initData(armyData)
			end
			single:setPosition(cc.p(0, v.posY))
			single:setLocalZOrder(i)
			v.point = single
		end
	end
end
function epicWarDispatchView:setCurValByArmyid(armyid, curCount)
	local armyData = self.tableArmyData[armyid]
	if not armyData then
		print("setCurValByArmyid error", armyid, curCount)
		return 0
	end
	if curCount > armyData.armycount then
		print("setCurValByArmyid armycount error", armyid, curCount)
		return 0
	end
	local curArmyCount = self.selectArmyNum
	if 0 < armyData.curCount then
		curArmyCount = self.selectArmyNum - armyData.curCount
		if curArmyCount < 0 then
			print("setCurValByArmyid curCount error", armyid, curCount)
			return 0
		end
	end
	if curArmyCount + curCount > self.limitArmy and 0 < curCount then
		curCount = self.limitArmy - curArmyCount
	end
	armyData.curCount = curCount
	self.selectArmyNum = curArmyCount + curCount
	self.armySelectData[tostring(armyid)] = curCount
	return curCount
end
function epicWarDispatchView:singleSliderChange(target, data)
	local curCount = self:setCurValByArmyid(data.armyid, data.armycount)
	if 0 <= curCount then
		self.armySelectData[tostring(data.armyid)] = curCount
	end
	self:updateView()
end
function epicWarDispatchView:updateView()
	self.Text_num:setString(self.selectArmyNum)
	self.Text_num:setColor(self.selectArmyNum < self.limitArmy and cc.c3b(255, 200, 100) or cc.c3b(255, 255, 255))
	SoraDToCenter(self.Node_army, 0)
	self:updateScroll()
end
function epicWarDispatchView:updateScroll()
	for k, v in ipairs(self.tableArmySingle) do
		if v.point then
			v.point:updateView()
		end
	end
end
function epicWarDispatchView:resetArmySelect()
	for _, v in pairs(self.tableArmyData) do
		v.curCount = 0
	end
	self.armySelectData, _ENV = pairs(self.tableArmyData)
	self.selectArmyNum = 0
	self:updateView()
end
function epicWarDispatchView:getArmyCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.armycount
	end
	return 0
end
function epicWarDispatchView:setCurValMax(armyid)
	local armyMax = self:getArmyCount(armyid)
	local curCount = self:setCurValByArmyid(armyid, armyMax)
	if 0 <= curCount then
		self.armySelectData[tostring(armyid)] = curCount
	end
end
function epicWarDispatchView:quickChoose()
	for _, armyid in pairs(self.tableArmy) do
		self:setCurValMax(armyid)
	end
	self:updateView()
end
function epicWarDispatchView:btnChallengeClick(button, event)
	if event == ccui.TouchEventType.ended then
		local challenge = function()
			SoraDPlaySound("epicControl", 4)
			for k, v in pairs(self.armySelectData) do
				if v <= 0 then
					self.armySelectData[k] = nil
				end
			end
			local heroList = self.ccs_heroBanner:exportNewHeros()
			dump(self.armySelectData, "self.armySelectData===")
			dump(heroList, "heroList===")
			epicWarCtrl:sendReqEnterChapter(self.curChapter, self.armySelectData, heroList)
			_ENV = epicWarCtrl
			epicWarCtrl.msg = "MESSAGE_UI_EPICBATTLE_CLOSE_CHALLENGE"
			epicWarCtrl.noAct = true
			SoraDSendMessage(epicWarCtrl)
			self:removeFromParent()
		end
		if self.selectArmyNum > 0 then
			if self.selectArmyNum < self.limitArmy then
				SoraDPlaySound()
				SoraDShowMsgBox(i18n("epicbattle_text_48"), i18n("common_text_204"), i18n("common_text_185"), function(event)
					if event == MSGBOX_CALLBACK_YES then
						challenge()
					end
				end)
			else
				challenge()
			end
		else
			SoraDPlaySound()
			SoraDShowMsgTip(i18n("common_text_4412"))
		end
	end
end
function epicWarDispatchView:btnFastClick(button, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		if self.selectArmyNum > 0 then
			self:resetArmySelect()
		else
			self:quickChoose()
		end
	end
end
function epicWarDispatchView:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
return epicWarDispatchView
