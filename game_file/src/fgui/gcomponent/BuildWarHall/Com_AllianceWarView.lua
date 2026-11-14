local baseComponent = require("fgui.base.baseComponent")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
_ENV = "lordInfoCtrl"
;("lordInfoCtrl").TIME = 1
;("lordInfoCtrl").ARMY = 2
;("lordInfoCtrl").SPACE = 3
local ("lordInfoCtrl").DISTANCE, SORT_TYPE = 4, "lordInfoCtrl"
local base = fgui.GComponent
local Com_AllianceWarView = fgui.extension_class(base, baseComponent, include("allianceWarBase"))
fgui.register_extension("ui://BuildWarHall/Com_AllianceWarView", Com_AllianceWarView)
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local socket = require("socket")
local gAllianceQueueClassType = _G.gAllianceQueueClassType
local worldMapWarDef = include("worldMapWarDef")
function Com_AllianceWarView:onInit()
	print("Com_AllianceWarView:onInit")
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.scroll:setItemProvider(handler(self, self.onItemProvider))
	self.fields.btnRecord:setTitle(i18n("common_text_285"))
	self.fields.btnRecord:addClickEventListener(handler(self, self.btnClickCallBack))
end
function Com_AllianceWarView:onShow()
	self:onMessageListener()
	self.queueDatas, _ENV = self.onMessageListener, self.onMessageListener
	self.tableSingleUI, _ENV, self.needCallBack2SDK = self.onMessageListener, self.onMessageListener, true
	self.curClassType = nil
	self.subCurClassType = nil
	self.greenCount, _ENV, self.tableSpare_normal, _ENV, self.tableSpare_rally, _ENV, self.curWarData = self.onMessageListener, self.onMessageListener, self.onMessageListener, self.onMessageListener, self.onMessageListener, self.onMessageListener, nil
	self.fields.scroll:setNumItems(0)
	self:initQueue(self.scrollH, self.isWar)
	if self.queueRoot:isWarQueueRoot() then
		self.fields.labelNotice:setString(i18n("common_text_305"))
		_ENV = i18n("common_text_305")
		i18n("common_text_305").byUID = true
		self.openWarning = SoraDConfigGet("Game:radianceWar:openWarning~bool", i18n("common_text_305"))
		self:refreshRecordText()
	else
		local title, notice = worldMapWarDef.getAllianceWarViewTitle()
		self.fields.labelNotice:setString(notice)
	end
	if worldMapDefine.isInNewTrial() then
		self.fields.btnRecord:setVisible(false)
	end
	if self.titleUI then
		if self.queueRoot:isWarQueueRoot() then
			self.titleUI:updateTitle(i18n("brightWar_text_21"))
		else
			local title, notice = worldMapWarDef.getAllianceWarViewTitle()
			self.titleUI:updateTitle(title)
		end
	end
	_ENV = title
	_ENV, _ENV, worldMapWarDef.getAllianceWarViewTitle().unDefaultClick = self.titleUI.updateTitle, worldMapWarDef.getAllianceWarViewTitle()
	self.titleUI.updateTitle.title = i18n("common_text_008")
	_ENV, worldMapWarDef.getAllianceWarViewTitle()[1], self.titleUI.updateTitle.tag = self.titleUI.updateTitle, self.titleUI.updateTitle, gAllianceQueueClassType.pvp
	self.titleUI.updateTitle.title = i18n("common_text_041")
	_ENV, worldMapWarDef.getAllianceWarViewTitle()[2], self.titleUI.updateTitle.tag = self.titleUI.updateTitle, self.titleUI.updateTitle, gAllianceQueueClassType.pvp_def
	self.titleUI.updateTitle.title = i18n("common_text_835")
	worldMapWarDef.getAllianceWarViewTitle().tabsetArray, worldMapWarDef.getAllianceWarViewTitle()[3], self.titleUI.updateTitle.tag = worldMapWarDef.getAllianceWarViewTitle()
	local worldMapWarDef.getAllianceWarViewTitle().callback, param = handler(self, self.btnTabelClickCallBack), worldMapWarDef.getAllianceWarViewTitle()
	if not worldMapWarDef.showWarViewActivityTag() or self.queueRoot:isWarQueueRoot() then
		param.tabsetArray[3] = nil
	end
	self.fields.tableBtn:initView(param)
	self.tabBtnParam = param
	local cityBuildData = include("cityBuildData")
	cityBuildData:cleanFighting()
	self.curSortIndex = 1
	local addIndex = self.isShowTeamTab and 1 or 0
	for i = 1, 3 do
		if i <= self.fields.tableBtn:getTabNum() then
			self.fields.tableBtn:setBtnRedDot(i + addIndex, false, 0)
		end
	end
	self.fields.ccs_tab:setBtnRedDot(1, false, 0)
	self.fields.ccs_tab:setBtnRedDot(2, false, 0)
	self.fields.scroll:setNumItems(0)
	print("=======Com_AllianceWarView:onShow")
	print("=======AllianceWarViewProxy:onRegisterEvent")
	self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(handler(self, self.onImageLoaded))))
end
function Com_AllianceWarView:initComboBox(panel)
	self.curSortIndex = 1
	local _ENV, items
	local _ENV, values
	_ENV = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	panel:setComboBox(self.fields.ComboBox_sort, nil)
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortIndex - 1)
	end)
	self.fields.ComboBox_sort:setTitle(i18n("jinn_skill_4"))
	self.fields.ComboBox_sort:fixPos()
	self.fields.ComboBox_sort:fixChildrenPos()
end
function Com_AllianceWarView:setRedDotUpdateCallback(callback, isHideTableBtn)
	self.redDotUpdateCallback = callback
	self.fields.tableBtn:setVisible(not isHideTableBtn)
end
function Com_AllianceWarView:updateSortItems()
	self.showItems = nil
	self.sortValues = nil
	local values
	if self.curClassType == gAllianceQueueClassType.pvp_def then
		_ENV = self.curClassType
		SORT_TYPE, self.showItems, self.curClassType[1] = self.curClassType, self.curClassType, i18n("mass_ui_text1")
		SORT_TYPE, self.showItems, self.curClassType[2] = self.curClassType, self.curClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.showItems, self.curClassType[3] = self.curClassType, self.curClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.showItems, self.curClassType[4] = self.curClassType, self.curClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.showItems, self.curClassType[5] = self.curClassType, self.curClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.sortValues, self.curClassType[1] = self.curClassType, self.curClassType, SORT_TYPE.TIME
		SORT_TYPE, self.sortValues, self.curClassType[2] = self.curClassType, self.curClassType, SORT_TYPE.ARMY
		values, self.curClassType[1] = self.curClassType, 1
		values, self.curClassType[2] = self.curClassType, 2
	elseif self.subCurClassType == gAllianceQueueSubClassType.sub_massing then
		_UPVALUE3_ = self.subCurClassType
		_UPVALUE4_, self.showItems, self.subCurClassType[1] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text1")
		_UPVALUE4_, self.showItems, self.subCurClassType[2] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text2")
		_UPVALUE4_, self.showItems, self.subCurClassType[3] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text3")
		_UPVALUE4_, self.showItems, self.subCurClassType[4] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text5")
		_UPVALUE4_, self.showItems, self.subCurClassType[5] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text5")
		_UPVALUE4_, self.sortValues, self.subCurClassType[1] = self.subCurClassType, self.subCurClassType, SORT_TYPE.TIME
		_UPVALUE4_, self.sortValues, self.subCurClassType[2] = self.subCurClassType, self.subCurClassType, SORT_TYPE.SPACE
		_UPVALUE4_, self.sortValues, self.subCurClassType[3] = self.subCurClassType, self.subCurClassType, SORT_TYPE.ARMY
		_UPVALUE4_, self.sortValues, self.subCurClassType[4] = self.subCurClassType, self.subCurClassType, SORT_TYPE.DISTANCE
		values, self.subCurClassType[1] = self.subCurClassType, 1
		values, self.subCurClassType[2] = self.subCurClassType, 2
		values, self.subCurClassType[3] = self.subCurClassType, 3
		values, self.subCurClassType[4] = self.subCurClassType, 4
	else
		_ENV = self.subCurClassType
		SORT_TYPE, self.showItems, self.subCurClassType[1] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text1")
		SORT_TYPE, self.showItems, self.subCurClassType[2] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.showItems, self.subCurClassType[3] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.showItems, self.subCurClassType[4] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.showItems, self.subCurClassType[5] = self.subCurClassType, self.subCurClassType, i18n("mass_ui_text3")
		SORT_TYPE, self.sortValues, self.subCurClassType[1] = self.subCurClassType, self.subCurClassType, SORT_TYPE.TIME
		SORT_TYPE, self.sortValues, self.subCurClassType[2] = self.subCurClassType, self.subCurClassType, SORT_TYPE.ARMY
		values, self.subCurClassType[1] = self.subCurClassType, 1
		values, self.subCurClassType[2] = self.subCurClassType, 2
	end
	gAllianceQueueClassType = "Game:Com_AllianceWarView:SortIndex%d_%d~integer"
	;("Game:Com_AllianceWarView:SortIndex%d_%d~integer").byUID = true
	self.curSortIndex = SoraDConfigGet(string.format("Game:Com_AllianceWarView:SortIndex%d_%d~integer", self.curClassType, self.subCurClassType), "Game:Com_AllianceWarView:SortIndex%d_%d~integer") or 1
	self.comboBoxList:setSelectedIndex(self.curSortIndex - 1)
	self.fields.ComboBox_sort:setItems(self.showItems)
	self.fields.ComboBox_sort:setValues(values)
	self.fields.ComboBox_sort:refresh()
	self.fields.ComboBox_sort:setTitle(self.showItems[self.curSortIndex])
end
function Com_AllianceWarView:onComboBoxClick()
	SoraDPlaySound()
	local sortType = tonumber(self.fields.ComboBox_sort:getValue())
	self.curSortIndex = sortType
	_ENV = self.curClassType
	self.curClassType.byUID = true
	SoraDConfigSet(string.format("Game:Com_AllianceWarView:SortIndex%d_%d~integer", self.curClassType, self.subCurClassType), sortType, self.curClassType)
	self.comboBoxList:setSelectedIndex(self.curSortIndex - 1)
	self.fields.ComboBox_sort:setTitle(self.showItems[self.curSortIndex])
	self:refreshScroll()
end
function Com_AllianceWarView:updateCCSTabTitle()
	if self.curClassType == gAllianceQueueClassType.pvp_def then
		gAllianceQueueClassType, gAllianceQueueClassType = gAllianceQueueClassType.pvp_def, self.curClassType
		gAllianceQueueClassType.pvp_def.title = i18n("common_text_3869")
		gAllianceQueueClassType, self.curClassType[1], gAllianceQueueClassType.pvp_def.tag = gAllianceQueueClassType.pvp_def, gAllianceQueueClassType.pvp_def, gAllianceQueueSubClassType.sub_moving
		gAllianceQueueClassType.pvp_def.title = i18n("common_text_299")
		self.curClassType[2], gAllianceQueueClassType.pvp_def.tag = gAllianceQueueClassType.pvp_def, gAllianceQueueSubClassType.sub_massing
		if self.curClassType then
			goto lbl_45
		end
	end
	gAllianceQueueClassType, gAllianceQueueClassType = gAllianceQueueClassType.pvp_def, self.curClassType
	gAllianceQueueClassType.pvp_def.title = i18n("common_text_299")
	gAllianceQueueClassType, self.curClassType[1], gAllianceQueueClassType.pvp_def.tag = gAllianceQueueClassType.pvp_def, gAllianceQueueClassType.pvp_def, gAllianceQueueSubClassType.sub_massing
	gAllianceQueueClassType.pvp_def.title = i18n("common_text_3869")
	gAllianceQueueClassType, self.curClassType[2], gAllianceQueueClassType.pvp_def.tag = gAllianceQueueClassType.pvp_def, gAllianceQueueClassType.pvp_def, gAllianceQueueSubClassType.sub_moving
	local tabsetArray = self.curClassType
	::lbl_45::
	gAllianceQueueClassType.pvp_def.unDefaultClick = true
	gAllianceQueueClassType.pvp_def.tabsetArray = tabsetArray
	local gAllianceQueueClassType.pvp_def.callback, param = handler(self, self.btn_onClick_btns), gAllianceQueueClassType.pvp_def
	self.fields.ccs_tab:initView(param)
end
function Com_AllianceWarView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_SETTING", handler(self, self.updateViewBySetting))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH", handler(self, self.updateByMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_DELETE_NEW", handler(self, self.updateByMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_UPDATE_STATUS_NEW", handler(self, self.updateByMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_DELETE_NEW", handler(self, self.updateByMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_ADD_NEW", handler(self, self.updateByMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE_NEW", handler(self, self.updateByMsg))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreen))
end
function Com_AllianceWarView:onImageLoaded()
	self:initData()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:addWarBaseMsg()
end
function Com_AllianceWarView:setShowTeamTab(mapid)
	self.isShowTeamTab = true
	self.controllers.c1:setSelectedIndex(1)
	if self.titleUI then
		self.titleUI:updateTitle(i18n("free_team_text_41"))
	end
	self.mapid = mapid
	_ENV = i18n("free_team_text_41")
	i18n("free_team_text_41").title = i18n("remains_text_85")
	i18n("free_team_text_41").tag = -1
	table.insert(self.tabBtnParam.tabsetArray, 1, i18n("free_team_text_41"))
	self.fields.tableBtn:initView(self.tabBtnParam)
end
function Com_AllianceWarView:btn_onClick_btns(tag, name)
	self.subCurClassType = tag
	if self.curClassType == gAllianceQueueClassType.pve or self.curClassType == gAllianceQueueClassType.pve_moving then
		self.curClassType = self.subCurClassType == gAllianceQueueSubClassType.sub_massing and gAllianceQueueClassType.pve or gAllianceQueueClassType.pve_moving
	end
	self:updateSortItems()
	self.curWarData = self:getQueue(self.curClassType)
	if self.ignoreRefresh then
		self.ignoreRefresh = false
	else
		self:clearScrollData()
		self:refreshScroll(true)
	end
end
function Com_AllianceWarView:updateGreenPointAlliance()
end
function Com_AllianceWarView:refreshScroll(toTop)
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	self:updateScrollSize()
	self.massingCount = 0
	self.movingCount = 0
	if self.fields.labelNotice:isVisible() then
		self.fields.scroll:scrollToView(0)
	else
		print("Com_AllianceWarView:refreshScroll", toTop)
		if toTop then
			self.fields.scroll:scrollToView(0)
		end
		self:initWarOnScroll()
	end
	self:updateGreen()
end
function Com_AllianceWarView:btnTabelClickCallBack(tag)
	if tag == -1 then
		self:btnTeamClick(2)
	else
		self:tabChange(tag, true)
	end
end
function Com_AllianceWarView:setCurClassType(classType)
	self.curClassType = classType
	if self.curClassType == gAllianceQueueClassType.pve then
		self.controllers.c1:setSelectedIndex(1)
		self.ignoreRefresh = true
	else
		self.controllers.c1:setSelectedIndex(0)
		self.ignoreRefresh = true
	end
	self:updateCCSTabTitle()
	self.fields.ccs_tab:setTabIndex(1, true)
	self.scrollH = 0
	self:updateQueueScrollH(self.scrollH)
end
function Com_AllianceWarView:initData()
	self:initQueueData()
	if not self.curClassType then
		local curClassType
		for i, v in ipairs(self.greenCount) do
			if 0 < v then
				curClassType = self.fields.tableBtn:getBtn(i):getTag()
				break
			end
		end
		curClassType = curClassType or gAllianceQueueClassType.pvp
		self.fields.tableBtn:setTabByTag(curClassType, true)
	else
		self:tabChange(self.curClassType, true)
	end
end
function Com_AllianceWarView:updateGreen()
	local _ENV, greenCount
	greenCount[1] = self.queueRoot:getWarHallAttackCount()
	greenCount[2] = self.queueRoot:getWarHallDefendCount()
	greenCount[3] = self.queueRoot:getWarHallActivityCount()
	self.greenCount = greenCount
	local addIndex = self.isShowTeamTab and 1 or 0
	for i = 1, 3 do
		if i <= self.fields.tableBtn:getTabNum() then
			self.fields.tableBtn:setBtnRedDot(i + addIndex, 0 < greenCount[i], string.formatnumberthousands(greenCount[i]))
		end
	end
	self:updateCCSTabRedDot()
	self:updateGreenPointAlliance()
	if self.redDotUpdateCallback then
		self.redDotUpdateCallback(gAllianceQueueClassType.pvp, greenCount[1])
		self.redDotUpdateCallback(gAllianceQueueClassType.pvp_def, greenCount[2])
	end
end
function Com_AllianceWarView:updateCCSTabRedDot()
	if self.curClassType == gAllianceQueueClassType.pve or self.curClassType == gAllianceQueueClassType.pve_moving then
		print("Com_AllianceWarView:updateCCSTabRedDot1")
		_UPVALUE2_ = "Com_AllianceWarView:updateCCSTabRedDot1"
		;("Com_AllianceWarView:updateCCSTabRedDot1")[1] = gAllianceQueueClassType.pve
		;("Com_AllianceWarView:updateCCSTabRedDot1")[2] = gAllianceQueueClassType.pve_moving
		for i, classType in ipairs("Com_AllianceWarView:updateCCSTabRedDot1") do
			local count = self.queueRoot:getWarHallCountByClassType(classType)
			self.fields.ccs_tab:setBtnRedDot(i, 0 < count, count)
		end
	else
		print("Com_AllianceWarView:updateCCSTabRedDot2", self.massingCount, self.movingCount)
		if self.curClassType == gAllianceQueueClassType.pvp_def then
			self.fields.ccs_tab:setBtnRedDot(2, 0 < self.massingCount, self.massingCount)
			self.fields.ccs_tab:setBtnRedDot(1, 0 < self.movingCount, self.movingCount)
		else
			self.fields.ccs_tab:setBtnRedDot(1, 0 < self.massingCount, self.massingCount)
			self.fields.ccs_tab:setBtnRedDot(2, 0 < self.movingCount, self.movingCount)
		end
	end
end
function Com_AllianceWarView:jumpToWarSingle_imp()
end
function Com_AllianceWarView:jumpToWarSingle(eventID, classType)
end
function Com_AllianceWarView:tabChange(classType, force)
	_UPVALUE2_ = nil
	;(nil)[1] = self.curClassType
	;(nil)[2] = classType
	dump(nil, "self.curClassType == classType")
	if not force and self.curClassType == classType then
		return
	end
	self.fields.tableBtn:setTabByTag(classType)
	self:setCurClassType(classType)
	self:clearScrollData()
	self:refreshScroll(true)
end
function Com_AllianceWarView:updateScrollSize()
	self.fields.labelNotice:setVisible(self.curWarData == nil or not self.curWarData:isHasQueue())
	self.fields.scroll:setVisible(not self.fields.labelNotice:isVisible())
end
function Com_AllianceWarView:onItemProvider(index)
	local data
	if self.filterIdx ~= -1 and index > self.filterIdx - 1 then
		data = self.itemDatas[index]
	elseif index ~= self.filterIdx - 1 then
		data = self.itemDatas[index + 1]
	end
	if data then
		if data.isMass then
			return "ui://BuildWarHall/Com_WHV_rallySingle"
		else
			return "ui://BuildWarHall/Com_WHV_single"
		end
	else
		return "ui://BuildWarHall/Com_WHV_filter"
	end
end
function Com_AllianceWarView:onItemRenderer(index, obj)
	local data
	if self.filterIdx ~= -1 and index > self.filterIdx - 1 then
		data = self.itemDatas[index]
	elseif index ~= self.filterIdx - 1 then
		data = self.itemDatas[index + 1]
	end
	if data then
		obj:setScroll(self.fields.scroll, self.queueRoot)
		obj:initData(data.indexID, data.data, data.isFilter)
	else
		obj:setTitle(i18n("commom_text_4300"))
	end
end
function Com_AllianceWarView:initWarOnScroll()
	local tableData = self.curWarData:getTableData()
	self.itemDatas, _ENV = self.curWarData, self.curWarData
	self.filterIdx = -1
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for i, v in ipairs(queueData) do
			if self.curClassType == gAllianceQueueClassType.pve or self.curClassType == gAllianceQueueClassType.pve_moving then
				table.insert(self.itemDatas, v)
			else
				local isInMass = self:getIsInMass(v.indexID, v.data)
				if isInMass then
					self.massingCount = self.massingCount + 1
				else
					self.movingCount = self.movingCount + 1
				end
				if self.subCurClassType == gAllianceQueueSubClassType.sub_massing and isInMass then
					table.insert(self.itemDatas, v)
				elseif self.subCurClassType == gAllianceQueueSubClassType.sub_moving and not isInMass then
					table.insert(self.itemDatas, v)
				end
			end
			if v.isFilter and self.filterIdx == -1 then
				self.filterIdx = #self.itemDatas
			end
		end
	end
	local num = self.filterIdx ~= -1 and #self.itemDatas + 1 or #self.itemDatas or 0
	self:sortItemDatas()
	print("Com_AllianceWarView:refreshScroll2", self.isUpdateByMsg)
	if not self.isUpdateByMsg then
		self.fields.scroll:setNumItems(0)
		self.fields.scroll:removeChildrenToPool()
	end
	self.fields.scroll:setNumItems(num)
end
function Com_AllianceWarView:btnClickCallBack(button, type)
	SoraDPlaySound()
	if self.queueRoot:isWarQueueRoot() then
		if self.openWarning then
			SoraDShowMsgBox(i18n("brightWar_text_114"), i18n("common_text_054"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					self.openWarning = not self.openWarning
					self:refreshOpenWarning()
				end
			end)
		else
			self.openWarning = not self.openWarning
			self:refreshOpenWarning()
		end
	else
		uiManager:show("AllianceWarHistory")
	end
end
function Com_AllianceWarView:refreshOpenWarning()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:radianceWar:openWarning~bool", self.openWarning, nil)
	self:refreshRecordText()
	_ENV = self
	self.msg = "MESSAGE_SERVER_RADIANCE_WAR_WARNING"
	SoraDSendMessage(self)
end
function Com_AllianceWarView:refreshRecordText()
	if self.openWarning then
		self.fields.btnRecord:setTitle(i18n("brightWar_text_146"))
	else
		self.fields.btnRecord:setTitle(i18n("brightWar_text_147"))
	end
end
function Com_AllianceWarView:btnSettingClick(button, type)
	SoraDPlaySound()
	_ENV = nil
	;(nil).viewType = 2
	uiManager:show("AllianceWarSettingView", nil)
end
function Com_AllianceWarView:btnTeamClick(tag)
	if tag == 2 then
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openView(self.mapid)
		self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(function()
			uiManager:close("AllianceWarView")
		end)))
	end
end
function Com_AllianceWarView:clearScrollData()
end
function Com_AllianceWarView:updateByMsg(target, data)
	self:updateViewBySetting(target, data, true)
end
function Com_AllianceWarView:updateViewBySetting(target, data, isUpdateByMsg)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	self:stopActionByTag(991)
	local action = ffa.seq(ffa.delay(0.16666666666666666), ffa.callFunc(function()
		self:clearScrollData()
		if self.curWarData then
			self.curWarData:clean()
		end
		self:initQueueData()
		self.isUpdateByMsg = isUpdateByMsg
		self:refreshScroll()
		self.isUpdateByMsg = false
	end))
	action:setTag(991)
	self:runAction(action)
end
function Com_AllianceWarView:refreshByData(classType, queue, isDelete)
	if self.curClassType ~= classType then
		return
	end
	self:stopActionByTag(992)
	local action = ffa.seq(ffa.delay(0.16666666666666666), ffa.callFunc(function()
		self.isUpdateByMsg = true
		self:refreshScroll()
		self.isUpdateByMsg = false
	end))
	action:setTag(992)
	self:runAction(action)
end
function Com_AllianceWarView:refreshSinggleByData(classType, queue)
	if self.curClassType ~= classType then
		return
	end
	local point = self.tableSingleUI[queue]
	if point then
		point:updateData(queue.indexID, queue.data, queue.isFilter)
	end
end
function Com_AllianceWarView:openTimeUp(dt)
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if self.delay_time <= 0 then
			self.is_delay = false
			self:clearScrollData()
			self:refreshScroll()
		end
	end
end
local MIN_TIME = 2.0
function Com_AllianceWarView:needRefresh()
	if self.is_delay then
		return false
	end
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if time < MIN_TIME then
			self.is_delay = true
			self.delay_time = MIN_TIME
			return false
		end
	end
	self.preClockTime = curTime
	return true
end
function Com_AllianceWarView:setTitleUI(titleUI)
	self.titleUI = titleUI
	if self.queueRoot == nil then
		return
	end
	print("Com_AllianceWarView:setTitleUI")
	if self.queueRoot:isWarQueueRoot() then
		self.titleUI:updateTitle(i18n("brightWar_text_21"))
	else
		local title, notice = worldMapWarDef.getAllianceWarViewTitle()
		self.titleUI:updateTitle(title)
	end
end
function Com_AllianceWarView:initAtlantisWarView(...)
end
function Com_AllianceWarView:getQueueMainData(indexID, warHallData)
	local warHallQueues
	if warHallData then
		warHallQueues = warHallData
	else
		warHallData = self.queueRoot:getWarHallData(indexID)
		if warHallData then
			warHallQueues, _ENV = warHallData.queues, warHallData.queues
			warHallQueues = warHallData and warHallData.queues or warHallData
		end
	end
	local tableMainData
	if warHallQueues then
		local index, queue = next(warHallQueues)
		if index and queue then
			tableMainData = queue
		end
	end
	return tableMainData
end
function Com_AllianceWarView:getIsInMass(indexID, warHallData)
	local tableMainData = self:getQueueMainData(indexID, warHallData)
	if tableMainData and tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally then
		return true, tableMainData
	end
	return false, tableMainData
end
function Com_AllianceWarView:getTotalArmyCount(tableMainData)
	local fromAid = tableMainData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local warQueue = fromAid == selfAid and self.queueRoot:getMassQueuesAttackQueues(tableMainData) or self.queueRoot:getMassQueuesDefendQueues(tableMainData)
	local armyCount = 0
	for _, v in ipairs(warQueue) do
		if not v.from or not v.from.army then
			_ENV = v.from.army
		end
		for _, v2 in ipairs(v.from.army) do
			armyCount = armyCount + v2.num
		end
	end
	return armyCount
end
function Com_AllianceWarView:sortItemDatas()
	if not self.sortValues then
		return
	end
	local sortType = self.sortValues[self.curSortIndex]
	local myCityTilePoint = SoraDGetCtrl("cityCtrl"):getCurCityPos()
	local totalMember = allianceMgr:getAllianceBattlePeopleCount()
	for i, v in ipairs(self.itemDatas) do
		local _ENV, sortData
		v.sortData = sortData
		sortData.space = 0
		sortData.timeValue = 9999999
		sortData.totalArmyCount = 0
		sortData.distance = 9999999
		local isInMass, tableMainData = self:getIsInMass(v.indexID, v.data)
		if isInMass and tableMainData ~= nil then
			local memberData = self.queueRoot:getMassQueuesAttacker(tableMainData)
			sortData.space = totalMember - #memberData
		end
		if tableMainData then
			local queueObj = tableMainData
			local statuRemainTime = queueObj:getStatusRemainTime()
			sortData.timeValue = statuRemainTime and statuRemainTime or 9999999
			sortData.totalArmyCount = self:getTotalArmyCount(tableMainData)
			sortData.distance = queueObj:getFrom() and cc.pGetDistance(queueObj:getFrom(), myCityTilePoint) or 9999999
		end
	end
	table.sort(self.itemDatas, function(a, b)
		local aSortData = a.sortData
		local bSortData = b.sortData
		if sortType == SORT_TYPE.TIME then
			if aSortData.timeValue ~= bSortData.timeValue then
				return aSortData.timeValue < bSortData.timeValue
			else
				return aSortData.totalArmyCount > bSortData.totalArmyCount
			end
		elseif sortType == SORT_TYPE.ARMY then
			if aSortData.totalArmyCount ~= bSortData.totalArmyCount then
				return aSortData.totalArmyCount > bSortData.totalArmyCount
			else
				return aSortData.timeValue < bSortData.timeValue
			end
		elseif sortType == SORT_TYPE.SPACE then
			if aSortData.space ~= bSortData.space then
				return aSortData.space > bSortData.space
			elseif aSortData.timeValue ~= bSortData.timeValue then
				return aSortData.timeValue < bSortData.timeValue
			elseif aSortData.distance ~= bSortData.distance then
				return aSortData.distance < bSortData.distance
			else
				return aSortData.totalArmyCount > bSortData.totalArmyCount
			end
		elseif sortType == SORT_TYPE.DISTANCE then
			if aSortData.distance ~= bSortData.distance then
				return aSortData.distance < bSortData.distance
			elseif aSortData.timeValue ~= bSortData.timeValue then
				return aSortData.timeValue < bSortData.timeValue
			elseif aSortData.space ~= bSortData.space then
				return aSortData.space > bSortData.space
			else
				return aSortData.totalArmyCount > bSortData.totalArmyCount
			end
		end
	end)
end
return Com_AllianceWarView
