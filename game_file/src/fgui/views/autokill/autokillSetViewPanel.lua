local armyCtrl = SoraDGetCtrl("armyCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local autokillCtrl = SoraDGetCtrl("autokillCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local buildLogic = include("buildLogic")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
local constantRead = include("constantRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local autokillSetViewPanel = class("autokillSetViewPanel", baseFguiPanel)
function autokillSetViewPanel:ctor(...)
	autokillSetViewPanel.super.ctor(self, ...)
	print("autokillSetViewPanel:ctor", self.viewName)
end
function autokillSetViewPanel:onInit()
	print("=======autokillSetViewPanel:onInit")
	self.maxQueue = constantRead.getConstValue("AUTO_KILL_MAX_QUEUE_NUM")
	self.tBtns, _ENV, self.compileIndex = constantRead.getConstValue("AUTO_KILL_MAX_QUEUE_NUM"), constantRead.getConstValue("AUTO_KILL_MAX_QUEUE_NUM"), nil
	self.setMaxQueue = 1
	self.fields.Panel_bg:setString(i18n("automatic_title_01"))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Button_troops_help:addClickListener(handler(self, self.btnTroopsHelpClick))
	self.fields.Button_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.CheckBox_autolv:addClickListener(handler(self, self.btnCheckAutoLvClick))
	self.fields.CheckBox_autoitem:addClickListener(handler(self, self.btnCheckAutoItemClick))
	self.fields.Text_title_army:setString(i18n("automatic_text_03"))
	self.fields.Text_title_name:setString(i18n("automatic_text_04"))
	self.fields.Lab_team:setString(i18n("automatic_text_07"))
	self.fields.Lab_queue:setString(i18n("automatic_text_30"))
	self.fields.Lab_lv:setString(i18n("automatic_text_05"))
	self.fields.Lab_item:setString(i18n("automatic_text_09"))
	self.fields.Text_t:setString(i18n("~"))
	self.fields.Text_maxTroops:setString(i18n("automatic_text_31"))
	self.fields.Text_lvRange:setString(i18n("automatic_text_16"))
	self.fields.Text_item_tips:setString(i18n("automatic_text_22"))
	self.fields.Text_tips:setString(i18n("automatic_text_15"))
	self.fields.List_troops:setItemRenderer(handler(self, self.onTeamRenderer))
	self.fields.List_troops:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseTeam))
	self.TextField_troops = self.fields.TextField_troops:getChildByName("input")
	self.TextField_troops:setMaxLength(1)
	self.TextField_troops:setAlign(cc.TEXT_ALIGNMENT_CENTER)
	self.TextField_troops:addEventListener(fgui.UIEventType.Submit, handler(self, self.onMaxQueueChanged))
	self.TextField_downNum = self.fields.TextField_downNum:getChildByName("input")
	self.TextField_downNum:setMaxLength(2)
	self.TextField_downNum:setAlign(cc.TEXT_ALIGNMENT_CENTER)
	self.TextField_downNum:addEventListener(fgui.UIEventType.Submit, handler(self, self.onDownNumChanged))
	self.TextField_upNum = self.fields.TextField_upNum:getChildByName("input")
	self.TextField_upNum:setMaxLength(2)
	self.TextField_upNum:setAlign(cc.TEXT_ALIGNMENT_CENTER)
	self.TextField_upNum:addEventListener(fgui.UIEventType.Submit, handler(self, self.onUpNumChanged))
	self.fields.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("automatic_text_08", nil)
	end)
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_help:fixPos()
	self.fields.Button_troops_help:fixPos()
	self.fields.Button_add:fixPos()
	self.fields.Text_maxTroops:fixPos()
	self.fields.Text_lvRange:fixPos()
	self.fields.CheckBox_autolv:fixPos()
	self.fields.Text_item_tips:fixPos()
	self.fields.CheckBox_autoitem:fixPos()
	self.fields.TextField_upNum:fixPos()
	self.fields.TextField_downNum:fixPos()
end
function autokillSetViewPanel:onMaxQueueChanged()
	local newInput = tonumber(self.TextField_troops:getText()) or 1
	local maxtroops = math.min(buildLogic.getExpQueueCount().total, self.maxQueue)
	if newInput > maxtroops then
		newInput = maxtroops
	elseif newInput < 1 then
		newInput = 1
	end
	self.newTroopsInput = newInput
	self.TextField_troops:setText(self.newTroopsInput)
	self.data.userQueueNum = self.newTroopsInput
	self:reqSetData()
end
function autokillSetViewPanel:onDownNumChanged()
	local newInput = tonumber(self.TextField_downNum:getText()) or 1
	local highestLv = self.limitLv or gMaxNpcLevel
	local maxLv = autokillCtrl:getMonsterMaxLv()
	if highestLv > maxLv or worldMapDefine.isInKingdomBattle() then
		if newInput > highestLv then
			newInput = highestLv
			_ENV = self.TextField_downNum:getText()
			self.TextField_downNum:getText().num = highestLv
			SoraDShowMsgTip(i18n("automatic_text_17", self.TextField_downNum:getText()))
		elseif newInput < 1 then
			newInput = 1
		elseif maxLv < newInput then
			newInput = maxLv
			_ENV = i18n("automatic_text_17", self.TextField_downNum:getText())
			i18n("automatic_text_17", self.TextField_downNum:getText()).num = maxLv
			SoraDShowMsgTip(i18n("automatic_text_37", i18n("automatic_text_17", self.TextField_downNum:getText())))
		elseif newInput > self.newUpInput then
			newInput = self.newDownInput
			SoraDShowMsgTip(i18n("automatic_text_18"))
		end
	elseif newInput < 1 then
		newInput = 1
	elseif highestLv < newInput then
		newInput = self.newDownInput
		_ENV = i18n("automatic_text_18")
		i18n("automatic_text_18").num = highestLv
		SoraDShowMsgTip(i18n("automatic_text_17", i18n("automatic_text_18")))
	elseif newInput > self.newUpInput then
		newInput = self.newDownInput
		SoraDShowMsgTip(i18n("automatic_text_18"))
	end
	self.newDownInput = newInput
	self.TextField_downNum:setText(self.newDownInput)
	self.data.minLevel = self.newDownInput
	self:reqSetData()
end
function autokillSetViewPanel:onUpNumChanged()
	local newInput = tonumber(self.TextField_upNum:getText()) or 1
	local highestLv = self.limitLv or gMaxNpcLevel
	local maxLv = autokillCtrl:getMonsterMaxLv()
	if highestLv > maxLv or worldMapDefine.isInKingdomBattle() then
		if newInput > highestLv then
			newInput = highestLv
			_ENV = self.TextField_upNum:getText()
			self.TextField_upNum:getText().num = highestLv
			SoraDShowMsgTip(i18n("automatic_text_17", self.TextField_upNum:getText()))
		elseif newInput < 1 or newInput < self.newDownInput then
			newInput = self.newUpInput
			SoraDShowMsgTip(i18n("automatic_text_19"))
		elseif maxLv < newInput then
			newInput = maxLv
			_ENV = i18n("automatic_text_19")
			i18n("automatic_text_19").num = maxLv
			SoraDShowMsgTip(i18n("automatic_text_37", i18n("automatic_text_19")))
		end
	elseif highestLv < newInput then
		newInput = highestLv
		_ENV = i18n("automatic_text_37", i18n("automatic_text_19"))
		i18n("automatic_text_37", i18n("automatic_text_19")).num = highestLv
		SoraDShowMsgTip(i18n("automatic_text_17", i18n("automatic_text_37", i18n("automatic_text_19"))))
	elseif newInput < self.newDownInput or newInput < 1 then
		newInput = self.newUpInput
		SoraDShowMsgTip(i18n("automatic_text_19"))
	end
	self.newUpInput = newInput
	self.TextField_upNum:setText(self.newUpInput)
	self.data.maxLevel = self.newUpInput
	self:reqSetData()
end
function autokillSetViewPanel:onTeamRenderer(index, obj)
	local tName = armyCtrl:getArmyCompileName(self.tBtns[index + 1]) or index + 1
	obj:setTitle(tName)
	obj:setSelected(self.compileIndex and self.compileIndex == index + 1)
end
function autokillSetViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], self.data.itemList)
end
function autokillSetViewPanel:onShow()
	print("=======autokillSetViewPanel:onShow")
	for i = 1, 4 do
		table.insert(self.tBtns, i)
	end
	if exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.ARMY_COMPILE_LIMIT) then
		local totalNum = armyCtrl:getArmyCompileCount()
		for i = 5, totalNum do
			table.insert(self.tBtns, i)
		end
	end
	local dir = SoraDFIsRA() and -1 or 1
	self.fields.TextField_troops:setPositionX(self.fields.Text_maxTroops:getPositionX() - (self.fields.Text_maxTroops:getTextAreaWidth() / 2 + 40) * dir)
	self.fields.CheckBox_autolv:setPositionX(self.fields.Text_lvRange:getPositionX() - (self.fields.Text_lvRange:getTextAreaWidth() / 2 + 30) * dir)
	self.fields.CheckBox_autoitem:setPositionX(self.fields.Text_item_tips:getPositionX() - (self.fields.Text_item_tips:getTextAreaWidth() / 2 + 30) * dir)
	self:renameFunc()
	self:initView()
end
function autokillSetViewPanel:onChooseTeam()
	SoraDPlaySound()
	self.compileIndex = self.fields.List_troops:getSelectedIndex() + 1
	self.reqArmy = true
	armyCtrl:getArmyCompile(self.compileIndex)
	SoraDShowLoading(self)
end
function autokillSetViewPanel:initView()
	self.data = autokillCtrl:getSetData()
	self.limitLv = kingdomMapCtrl:getMaxCanKillLevel()
	self.autoState = self.data.autoState or false
	local towerLv = nebulaActivityCtrl:getTowerLv()
	if 1 <= towerLv and self.limitLv >= gMaxNpcLevel then
		self.limitLv = nebulaTowerLvDesRead.getMonsterMaxLv(towerLv)
	end
	self:fixItemList()
	self:setAward()
	self:initText()
	self:initUiStatue()
end
function autokillSetViewPanel:fixItemList()
	local maxtroops = math.min(buildLogic.getExpQueueCount().total, self.maxQueue)
	if self.data.userQueueNum == nil or self.data.userQueueNum == 0 then
		self.data.userQueueNum = 1
	end
	if maxtroops < self.data.userQueueNum then
		self.data.userQueueNum = maxtroops
		self.newTroopsInput = maxtroops
		self.TextField_troops:setText(self.newTroopsInput)
	end
	if not self.data.itemList then
		return
	end
	for i, v in pairs(self.data.itemList) do
		local max = backpackCtrl:getItemCount(tonumber(i))
		if v > max then
			self.data.itemList[i] = max
		end
	end
end
function autokillSetViewPanel:setAward()
	local itemIDArray = backpackltCtrl:getItemArray(gItemType.STAMINA)
	self.itemList, backpackltCtrl = backpackltCtrl, backpackltCtrl
	if not self.data.itemList then
		self.data.itemList, backpackltCtrl = gItemType.STAMINA, gItemType.STAMINA
	end
	for k, v in ipairs(itemIDArray) do
		backpackltCtrl = nil
		;(nil).id = v
		;(nil).count = backpackCtrl:getItemCount(v)
		;(nil).num = self.data.itemList[tostring(v)] or 0
		table.insert(self.itemList, nil)
	end
	self.fields.List_item:setNumItems(#self.itemList)
end
function autokillSetViewPanel:initText()
	if not self.data then
		local _ENV, result = self.data, self.data
	end
	if not (result and next(result)) or result.minLevel == 0 or result.maxLevel == 0 then
		result.minLevel = 1
		result.maxLevel = self.limitLv
	end
	local towerLv = nebulaActivityCtrl:getTowerLv()
	if 1 <= towerLv and result.maxLevel >= gMaxNpcLevel then
		result.maxLevel = math.min(self.limitLv, result.maxLevel)
	end
	result.minLevel = math.min(self.limitLv, result.minLevel)
	result.maxLevel = math.min(self.limitLv, result.maxLevel)
	if result.userQueueNum == nil or result.userQueueNum == 0 then
		result.userQueueNum = 1
	end
	self.TextField_downNum:setText(result.minLevel)
	self.TextField_upNum:setText(result.maxLevel)
	self.TextField_troops:setText(result.userQueueNum)
	self.newDownInput = result.minLevel
	self.newUpInput = result.maxLevel
	self.newTroopsInput = result.userQueueNum
end
function autokillSetViewPanel:initUiStatue()
	self.fields.CheckBox_autolv:setSelected(self.data.attackMaxLev)
	self.fields.CheckBox_autoitem:setSelected(self.data.autoUseItem)
	if self.data.autoState then
		self.fields.Button_go:setString(i18n("automatic_text_12"))
	else
		self.fields.Button_go:setString(i18n("automatic_text_10"))
	end
	local leftTime = buffCtrl:getRemainTimeByBuffID(5148)
	if leftTime and 0 <= leftTime then
		self.fields.Text_time:beginTime(leftTime)
	end
	self:showEffect(self.data.compileIndex)
end
function autokillSetViewPanel:showEffect(index)
	self.compileIndex = index
	self.fields.List_troops:setNumItems(#self.tBtns)
end
function autokillSetViewPanel:handleSetItem(target, data)
	if data and data.itemSetList then
		self.data.itemList = data.itemSetList
		self:reqSetData()
	end
end
function autokillSetViewPanel:updateTroopList(...)
	self.tBtns, _ENV = nil, nil
	for i = 1, 4 do
		table.insert(self.tBtns, i)
	end
	if exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.ARMY_COMPILE_LIMIT) then
		local totalNum = armyCtrl:getArmyCompileCount()
		for i = 5, totalNum do
			table.insert(self.tBtns, i)
		end
	end
	local width = self.fields.List_troops:getWidth()
	self.fields.List_troops:setColumnGap((width - 54 * #self.tBtns) / (#self.tBtns - 1))
	self.fields.List_troops:setNumItems(#self.tBtns)
end
function autokillSetViewPanel:adaptTeam(target, data)
	if not self.reqArmy then
		return
	end
	self.reqArmy = false
	SoraDCloseLoading(self)
	if data and data.redata then
		local compile = data.redata
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
			SoraDShowMsgBox(i18n("automatic_text_11"), i18n("common_text_477"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					uiManager:show("troopFlagView")
				end
			end)
			return
		end
		if self.compileIndex then
			self.data.compileIndex = self.compileIndex
			self:reqSetData()
		else
			local notEnough = false
			for k, v in pairs(compile) do
				if 0 < v then
					local armyid = tonumber(k)
					local haveCount = armyCtrl:getArmyCount(armyid, ARMY_OPTYPE.NORMAL_ARMY)
					if haveCount <= 0 or v > haveCount then
						notEnough = true
						break
					end
				end
			end
			if not notEnough then
				self.data.autoState = not self.data.autoState
				self:reqSetData()
			else
				SoraDShowMsgBox(i18n("automatic_text_11"), i18n("common_text_477"), nil, function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						uiManager:show("troopFlagView")
					end
				end)
			end
		end
		self.compileIndex = nil
	end
end
function autokillSetViewPanel:renameFunc(target, data)
	local width = self.fields.List_troops:getWidth()
	self.fields.List_troops:setColumnGap((width - 54 * #self.tBtns) / (#self.tBtns - 1))
	self.fields.List_troops:setNumItems(#self.tBtns)
end
function autokillSetViewPanel:reqSetData()
	SoraDShowLoading(self)
	self:fixItemList()
	autokillCtrl:reqAutokillStart(self.data)
end
function autokillSetViewPanel:reqSetDataRSP(target, data)
	SoraDCloseLoading(self)
	if not self.autoState then
		local data = autokillCtrl:getSetData()
		local autoState = data.autoState or false
		if autoState ~= self.autoState then
			SoraDGotoWorldMapPoint()
			self:close()
			return
		end
	end
	self:initView()
end
function autokillSetViewPanel:btnGoClick()
	SoraDPlaySound()
	local maxLv = autokillCtrl:getMonsterMaxLv()
	if worldMapDefine.isInKingdomBattle() and (maxLv < self.newDownInput or maxLv < self.newUpInput) then
		_ENV = nil
		;(nil).num = maxLv
		SoraDShowMsgTip(i18n("automatic_text_35", nil))
		return
	end
	if not self.data.autoState then
		if not self.data.compileIndex or self.data.compileIndex <= 0 then
			SoraDShowMsgTip(i18n("automatic_text_11"))
			return
		end
		local physical = lordInfoCtrl:getBaseInfo().physical
		if physical < HP_MIN_MONSTER_CHEST then
			if self.data.autoUseItem then
				local count = 0
				for k, v in pairs(self.data.itemList) do
					count = count + v
				end
				if count <= 0 then
					SoraDShowMsgTip(i18n("common_text_988"))
					return
				end
			else
				SoraDShowMsgTip(i18n("common_text_988"))
				return
			end
		end
		self.compileIndex = nil
		self.reqArmy = true
		armyCtrl:getArmyCompile(self.data.compileIndex)
		SoraDShowLoading(self)
	else
		SoraDShowMsgBox(i18n("automatic_text_25"), i18n("common_text_054"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				self.data.autoState = false
				self:reqSetData()
			end
		end)
	end
end
function autokillSetViewPanel:btnCheckAutoLvClick()
	SoraDPlaySound()
	if self.fields.CheckBox_autolv:isSelected() then
		self.fields.CheckBox_autolv:setSelected(false)
		SoraDShowMsgBox(i18n("automatic_text_21"), i18n("common_text_054"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				self.fields.CheckBox_autolv:setSelected(true)
				self.data.attackMaxLev = self.fields.CheckBox_autolv:isSelected()
				self:reqSetData()
			end
		end)
	else
		self.data.attackMaxLev = self.fields.CheckBox_autolv:isSelected()
		self:reqSetData()
	end
end
function autokillSetViewPanel:btnCheckAutoItemClick()
	SoraDPlaySound()
	self.data.autoUseItem = self.fields.CheckBox_autoitem:isSelected()
	self:reqSetData()
end
function autokillSetViewPanel:btnAddClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).toCategory = gRechargeCenterCategory.MONTH
		;(nil).toNodeTag = 0
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToWeeklyTakeTab()
		panel:show()
	end
end
function autokillSetViewPanel:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_1173")
	;(nil).content = i18n("automatic_text_02")
	uiManager:show("RuleView", nil)
end
function autokillSetViewPanel:btnTroopsHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_1173")
	_ENV = nil
	;(nil).num = self.maxQueue
	;(nil).content = i18n("automatic_text_32", nil)
	uiManager:show("RuleView", nil)
end
return autokillSetViewPanel
