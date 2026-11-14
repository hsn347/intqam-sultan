local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local armyltCtrl = include("armyltCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local buildLogic = include("buildLogic")
local epicBattleDispatchView = class("epicBattleDispatchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleDispatchView")
	end
	return target
end)
function epicBattleDispatchView:ctor()
	self.limitArmy = 0
	self.armySelectData, _ENV, self.tableArmyData, _ENV, self.tableArmy, _ENV, self.tableSpare, _ENV, self.tableArmySingle, _ENV, self.singleData, _ENV, self.selectArmyNum = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.nodeAction = SoraDGetExtendChildFromCCSByName(self, "CCS_epicBattleActionNode_action")
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
end
function epicBattleDispatchView:initData(data)
	self.singleData = data
	local gateName = string.format("%d-%d %s", self.singleData.chapter, self.singleData.index, self.singleData.name)
	self.nodeTitle:setTitle(gateName)
	self.limitArmy = epicWarltCtrl.getStageLimitArmy(self.singleData.stage)
	self.Text_limit:setString("/" .. self.limitArmy)
	local armyIDList = armyCtrl:getArmyIDList()
	if guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR) then
		armyltCtrl = guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR)
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR)[1] = guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR), 401
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR)[2] = guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR), 501
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR)[3] = guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR), 601
		armyIDList, guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR)[4] = guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR), 701
	end
	self.armyIDList, _ENV = guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR), guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR)
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
		if guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR) then
			table.insert(self.tableArmy, id)
			_ENV = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = 200
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
function epicBattleDispatchView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
function epicBattleDispatchView:initScroll()
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
function epicBattleDispatchView:updateScrollList()
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
function epicBattleDispatchView:setCurValByArmyid(armyid, curCount)
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
	return curCount
end
function epicBattleDispatchView:singleSliderChange(target, data)
	local curCount = self:setCurValByArmyid(data.armyid, data.armycount)
	if 0 <= curCount then
		self.armySelectData[tostring(data.armyid)] = curCount
	end
	self:updateView()
end
function epicBattleDispatchView:updateView()
	self.Text_num:setString(self.selectArmyNum)
	self.Text_num:setColor(self.selectArmyNum < self.limitArmy and cc.c3b(255, 200, 100) or cc.c3b(255, 255, 255))
	SoraDToCenter(self.Node_army, 0)
	self:updateScroll()
end
function epicBattleDispatchView:updateScroll()
	for k, v in ipairs(self.tableArmySingle) do
		if v.point then
			v.point:updateView()
		end
	end
end
function epicBattleDispatchView:resetArmySelect()
	for _, v in pairs(self.tableArmyData) do
		v.curCount = 0
	end
	self.armySelectData, _ENV = pairs(self.tableArmyData)
	self.selectArmyNum = 0
	self:updateView()
end
function epicBattleDispatchView:getArmyCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.armycount
	end
	return 0
end
function epicBattleDispatchView:setCurValMax(armyid)
	local armyMax = self:getArmyCount(armyid)
	local curCount = self:setCurValByArmyid(armyid, armyMax)
	if 0 <= curCount then
		self.armySelectData[tostring(armyid)] = curCount
	end
end
function epicBattleDispatchView:quickChoose()
	for _, armyid in pairs(self.tableArmy) do
		self:setCurValMax(armyid)
	end
	self:updateView()
end
function epicBattleDispatchView:btnChallengeClick(button, event)
	if event == ccui.TouchEventType.ended then
		local challenge = function()
			SoraDPlaySound("epicControl", 4)
			for k, v in pairs(self.armySelectData) do
				if v <= 0 then
					self.armySelectData[k] = nil
				end
			end
			if guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR_2) then
				epicWarCtrl:sendReqEnterStage(1500101, self.armySelectData)
			else
				epicWarCtrl:sendReqEnterStage(self.singleData.stage, self.armySelectData)
			end
			_ENV = epicWarCtrl
			epicWarCtrl.msg = "MESSAGE_UI_EPICBATTLE_CLOSE_CHALLENGE"
			epicWarCtrl.noAct = true
			SoraDSendMessage(epicWarCtrl)
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
function epicBattleDispatchView:btnFastClick(button, event, isTest)
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
function epicBattleDispatchView:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
return epicBattleDispatchView
