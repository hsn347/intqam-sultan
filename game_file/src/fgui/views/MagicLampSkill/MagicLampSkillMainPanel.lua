local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillMainPanel = class("MagicLampSkillMainPanel", baseFguiPanel)
function MagicLampSkillMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillMainPanel:ctor", self.viewName)
	self.skillMap, _ENV, self.skillList, _ENV = print, print, print, print
	self.isHideCurrentSceneView = true
	self.needItemID = magicLampSkillRead.getUpgradeLvNeedItemID()
	_ENV, self.needItemID2 = magicLampSkillRead.getUpgradeLvNeedItemID2(), magicLampSkillRead.getUpgradeLvNeedItemID2()
	magicLampSkillRead.getUpgradeLvNeedItemID2().sort = 1
	magicLampSkillRead.getUpgradeLvNeedItemID2().choose1 = true
	magicLampSkillRead.getUpgradeLvNeedItemID2().choose2 = true
	self.sortCfg, magicLampSkillRead.getUpgradeLvNeedItemID2().searchName = magicLampSkillRead.getUpgradeLvNeedItemID2(), nil
	_ENV = self.viewName
	self.viewName.byUID = true
	if not SoraDConfigGet("Game:MagicLampSkill:searchList~table", self.viewName) then
		_ENV = SoraDConfigGet("Game:MagicLampSkill:searchList~table", self.viewName)
	end
	self.searchList = SoraDConfigGet("Game:MagicLampSkill:searchList~table", self.viewName)
end
function MagicLampSkillMainPanel:onInit()
	print("=======MagicLampSkillMainPanel:onInit")
	self.is3SSwitchOpen = constantRead.getConstValue("MAGIC_SKILL_3S_SWITCH", 0) == 1
	self.fields.Com_title:initData(i18n("jinn_skill_1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_item1:setIcon(publicRead.getIcon(self.needItemID))
	self.fields.Com_item1:getChild("Button_add"):addClickListener(handler(self, self.onClickBtnAdd))
	if self.is3SSwitchOpen then
		self.fields.Com_item2:setIcon(publicRead.getIcon(self.needItemID2))
		self.fields.Com_item2:getChild("Button_add"):addClickListener(handler(self, self.onClickBtnAdd2))
	else
		self.fields.Com_item2:setVisible(false)
	end
	self.fields.Button_sort:setString(i18n("jinn_skill_4"))
	self.fields.Button_sort:addClickListener(handler(self, self.onClickBtnSort))
	self.fields.Load_click:addClickListener(handler(self, self.onClickCloseFilter))
	self.fields.Load_click:setVisible(false)
	self:initComSortFilter()
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRenderer))
	self.fields.List_skill:setVirtual()
	self.fields.Text_noData:setString(i18n("jinn_skill_3"))
	self.fields.Button_tujian:setString(i18n("common_text_2935"))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_resolve:setString(i18n("common_text_1378"))
	_UPVALUE4_ = self.fields.Button_resolve.setString
	self.fields.Button_resolve.setString[1] = self.fields.Button_tujian
	self.fields.Button_resolve.setString[2] = self.fields.Button_exchange
	self.fields.Button_resolve.setString[3] = self.fields.Button_resolve
	local self.fields.Button_resolve.setString[4], config = self.fields.Button_search, self.fields.Button_resolve.setString
	for i, v in ipairs(config) do
		v:addClickListener(handler(self, self.onClickOperateBtn))
	end
	_ENV = ipairs(config)
	ipairs(config).prompt = i18n("lordequip_text_05")
	ipairs(config).cleanHandler = handler(self, self.onCleanSearchName)
	ipairs(config).mask = self.fields.Load_mask
	self.fields.Label_input:initInputData(ipairs(config))
	_ENV = self.fields.Load_mask
	self.fields.Load_mask.items = self.searchList
	self.fields.Load_mask.changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox_history, self.fields.Load_mask)
	self.fields.ComboBox_history:addEventListener(fgui.UIEventType.Click, handler(self, self.onClickComboBox))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
		self.fields.ComboBox_history:fixChildrenPos()
	end
end
function MagicLampSkillMainPanel:onShow()
	print("=======MagicLampSkillMainPanel:onShow")
	self.curSelectIndex = 1
	_ENV = nil
	;(nil).defaultSelect = self.curSelectIndex
	;(nil).callback = handler(self, self.onClickQualityTab)
	;(nil).autoColumnGap = true
	self.fields.Com_qualityMenu:initMenuData(nil)
	self:updateSkillList()
	self:updateEnergyCount()
	self:updateButtonState()
end
function MagicLampSkillMainPanel:onClickQualityTab(selectIndex)
	self.sortCfg.searchName = nil
	self.fields.Label_input:cleanInput()
	self.curSelectIndex = selectIndex
	self:updateSelectIndex()
end
function MagicLampSkillMainPanel:updateSelectIndex()
	if self.is3SSwitchOpen then
		_UPVALUE6_ = self.is3SSwitchOpen
		self.is3SSwitchOpen[1] = 0
		self.is3SSwitchOpen[2] = 5
		self.is3SSwitchOpen[3] = 4
		self.is3SSwitchOpen[4] = 3
		self.is3SSwitchOpen[5] = 2
		self.is3SSwitchOpen[6] = 1
		if self.is3SSwitchOpen then
			goto lbl_21
		end
	end
	_UPVALUE5_ = self.is3SSwitchOpen
	self.is3SSwitchOpen[1] = 0
	self.is3SSwitchOpen[2] = 4
	self.is3SSwitchOpen[3] = 3
	self.is3SSwitchOpen[4] = 2
	local self.is3SSwitchOpen[5], config = 1, self.is3SSwitchOpen
	::lbl_21::
	if not self.skillList[self.sortCfg.sort][config[self.curSelectIndex]] then
		local _ENV, showListBase = self.skillList[self.sortCfg.sort][config[self.curSelectIndex]], self.skillList[self.sortCfg.sort][config[self.curSelectIndex]]
	end
	local _ENV, ret = config[self.curSelectIndex], config[self.curSelectIndex]
	if self.sortCfg.choose1 and self.sortCfg.choose2 then
		ret = showListBase
	else
		for i, v in ipairs(showListBase) do
			local classify = magicLampSkillRead.getSkillClassify(v.skillType)
			if self.sortCfg.choose1 and classify == 1 or self.sortCfg.choose2 and classify == 2 then
				table.insert(ret, v)
			end
		end
	end
	local searchName = self.sortCfg.searchName
	if searchName then
		ret, _ENV, showListBase = ipairs(showListBase)
		for i, v in ipairs(showListBase) do
			local skillName = magicLampSkillRead.getSkillName(v.skillType)
			if string.find(string.lower(skillName), string.lower(searchName), 1, true) then
				table.insert(ret, v)
			end
		end
	end
	self.showList = ret
	self.fields.List_skill:setNumItems(#self.showList)
	self.fields.Text_noData:setVisible(#self.showList == 0)
	if 0 < #self.showList then
		self.fields.List_skill:scrollToView(0)
	end
end
function MagicLampSkillMainPanel:onIntoPanel(...)
	print("=======MagicLampSkillMainPanel:onIntoPanel")
	self:updateSkillList()
end
function MagicLampSkillMainPanel:onClickHelp(...)
	SoraDPlaySound()
	local rate = magicLampSkillCtrl:getSkillResolvePro()
	_ENV = nil
	;(nil).num = rate * 100 .. "%"
	SoraDShowHelpMsgTip(i18n("jinn_skill_2", nil))
end
function MagicLampSkillMainPanel:onClickBtnAdd(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.needItemID
	uiManager:show("CommonSourceGuide", nil)
end
function MagicLampSkillMainPanel:onClickBtnAdd2(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.needItemID2
	uiManager:show("CommonSourceGuide", nil)
end
function MagicLampSkillMainPanel:onClickBtnSort(...)
	SoraDPlaySound()
	self.fields.Load_click:setVisible(true)
	self.fields.Com_sortFilter:setVisible(true)
end
function MagicLampSkillMainPanel:onClickCloseFilter(...)
	self.fields.Button_sort:setSelected(false)
	self.fields.Load_click:setVisible(false)
	self.fields.Com_sortFilter:setVisible(false)
end
function MagicLampSkillMainPanel:updateSkillList(...)
	local skillList = magicLampSkillCtrl:getSkillList()
	self.skillMap, magicLampSkillCtrl = magicLampSkillCtrl, magicLampSkillCtrl
	for i, data in ipairs(skillList) do
		local skillID = data.id
		magicLampSkillCtrl = nil
		local (nil).quality, ret = magicLampSkillRead.getSkillQuality(data.skillType), nil
		if magicLampCtrl:getIsUsing(skillID) then
			ret.isUsing = true
			ret.isRed = magicLampSkillCtrl:checkSkillShowRed(data)
		end
		self.skillMap[skillID] = ret
	end
	local max = magicLampSkillCtrl:getSkillStorageMax()
	magicLampSkillCtrl = data.id
	data.id.num = #skillList
	data.id.max = max
	self.fields.Text_skill:setString(i18n("jinn_skill_8", data.id))
	for sortType = 1, 2 do
		magicLampSkillRead.sortMainSkillList(skillList, sortType, self.skillMap)
		local magicLampSkillCtrl, ret = magicLampSkillRead.sortMainSkillList, magicLampSkillRead.sortMainSkillList
		for i, v in ipairs(skillList) do
			local quality = magicLampSkillRead.getSkillQuality(v.skillType)
			if not ret[quality] then
				magicLampSkillCtrl = ret[quality]
			end
			ret[quality] = ret[quality]
			table.insert(ret[quality], v)
		end
		ret[0] = clone(skillList)
		self.skillList[sortType] = ret
	end
	self:updateSelectIndex()
end
function MagicLampSkillMainPanel:onSkillItemRenderer(index, obj)
	local _index = index + 1
	local data = self.showList[_index]
	obj:initData(data)
	obj:setClickHandle(function()
		_ENV = nil
		;(nil).index = _index
		;(nil).skillList = self.showList
		uiManager:show("MagicLampSkillDetails", nil)
	end)
	if self.skillMap[data.id].isRed then
		obj:setReddot(true)
	else
		obj:setReddot(false)
	end
end
function MagicLampSkillMainPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_tujian then
		uiManager:show("MagicLampSkillHandbook")
	elseif sender == self.fields.Button_exchange then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010011, true) then
			_ENV = nil
			;(nil).id = gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER
			uiManager:show("ExchangeEventPage", nil)
		end
	elseif sender == self.fields.Button_resolve then
		uiManager:show("MagicLampSkillResolve")
	elseif sender == self.fields.Button_search then
		self.fields.Label_input:closeKeyboard()
		self:clickBtnSearch()
	end
end
function MagicLampSkillMainPanel:clickBtnSearch()
	local searchName = self.fields.Label_input:getText()
	print("==searchName==", searchName)
	if string.utf8len(searchName) <= 0 then
		return
	end
	self:onCleanSearchName()
	local _ENV, ret = self.onCleanSearchName, self.onCleanSearchName
	for i, v in ipairs(self.showList) do
		local skillName = magicLampSkillRead.getSkillName(v.skillType)
		if string.find(string.lower(skillName), string.lower(searchName), 1, true) then
			table.insert(ret, v)
		end
	end
	if next(ret) then
		self.sortCfg.searchName = searchName
		self.showList = ret
		self.fields.List_skill:setNumItems(#self.showList)
		self:updateSeachHistory(searchName)
	else
		SoraDShowMsgTip(i18n("jinn_skill_6"))
	end
end
function MagicLampSkillMainPanel:updateEnergyCount(...)
	if self.is3SSwitchOpen then
		local itemCount = magicLampSkillCtrl:getItemCount(self.needItemID)
		self.fields.Com_item1:setString(string.formatnumberthousands(itemCount))
		local itemCount2 = magicLampSkillCtrl:getItemCount(self.needItemID2)
		self.fields.Com_item2:setString(string.formatnumberthousands(itemCount2))
	else
		local itemName = publicRead.getName(self.needItemID)
		local itemCount = magicLampSkillCtrl:getItemCount(self.needItemID)
		magicLampSkillCtrl = string.formatnumberthousands(itemCount2)
		string.formatnumberthousands(itemCount2).name = itemName
		string.formatnumberthousands(itemCount2).msg = string.formatnumberthousands(itemCount)
		self.fields.Com_item1:setString(i18n("common_text_1000", string.formatnumberthousands(itemCount2)))
	end
end
function MagicLampSkillMainPanel:initComSortFilter(...)
	self.fields.Com_sortFilter:setVisible(false)
	local fields = fguiHelper.get_fields(self.fields.Com_sortFilter)
	self.fieldsSort = fields
	fields.Text_sort:setString(i18n("jinn_skill_4"))
	fields.Button_sort1:setString(i18n("commandhall_text_52"))
	fields.Button_sort2:setString(i18n("common_text_748"))
	fields.Text_choose:setString(i18n("gem_btn_01"))
	fields.Button_choose1:setString(i18n("common_text_370"))
	fields.Button_choose2:setString(i18n("common_text_372"))
	_UPVALUE4_ = fields.Button_choose2
	fields.Button_choose2[1] = fields.Button_sort1
	fields.Button_choose2[2] = fields.Button_sort2
	fields.Button_choose2[3] = fields.Button_choose1
	fields.Button_choose2[4] = fields.Button_choose2
	for i, v in ipairs(fields.Button_choose2) do
		v:setTag(i)
		v:addClickListener(handler(self, self.onClickSortFilter))
	end
	local sort = self.sortCfg.sort
	if sort == 1 then
		fields.Button_sort1:setSelected(true)
		fields.Button_sort2:setSelected(false)
	else
		fields.Button_sort1:setSelected(false)
		fields.Button_sort2:setSelected(true)
	end
	if self.sortCfg.choose1 then
		fields.Button_choose1:setSelected(true)
	end
	if self.sortCfg.choose2 then
		fields.Button_choose2:setSelected(true)
	end
	if not SoraDFIsRA() then
		self.fields.Com_sortFilter:fixChildrenPos()
		fields.Button_choose1:fixChildrenPos()
		fields.Button_choose2:fixChildrenPos()
	end
end
function MagicLampSkillMainPanel:onClickSortFilter(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	print("==onClickSortFilter index==", index)
	local fields = self.fieldsSort
	if index == 1 or index == 2 then
		local sort = self.sortCfg.sort
		if sort == index then
			return
		end
		local Button_sort = fields["Button_sort" .. sort]
		if Button_sort then
			Button_sort:setSelected(false)
		end
		self.sortCfg.sort = index
	else
		if index == 3 then
			self.sortCfg.choose1 = not self.sortCfg.choose1
		end
		if index == 4 then
			self.sortCfg.choose2 = not self.sortCfg.choose2
		end
	end
	self:updateSelectIndex()
end
function MagicLampSkillMainPanel:onCleanSearchName(...)
	if self.sortCfg.searchName then
		self.sortCfg.searchName = nil
		self:updateSelectIndex()
	end
end
function MagicLampSkillMainPanel:onComboBoxChanged(...)
	local index = self.fields.ComboBox_history:getSelectedIndex()
	if self.searchList[index + 1] then
		self.fields.Label_input:setString(self.searchList[index + 1])
		self:clickBtnSearch()
	end
end
function MagicLampSkillMainPanel:updateSeachHistory(searchName)
	local index = table.indexof(self.searchList, searchName)
	if index then
		table.remove(self.searchList, index)
	end
	table.insert(self.searchList, 1, searchName)
	local constantRead = include("constantRead")
	local max = constantRead.getConstValue("JINN_SKILL_SEARCH_MAX", 10)
	for i = #self.searchList, max + 1, -1 do
		table.remove(self.searchList, i)
	end
	self.fields.ComboBox_history:setItems(self.searchList)
	self.fields.ComboBox_history:refresh()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:MagicLampSkill:searchList~table", self.searchList, nil)
end
function MagicLampSkillMainPanel:onClickComboBox(...)
	SoraDPlaySound()
	if #self.searchList == 0 then
		self.fields.ComboBox_history:hideDropdown()
		SoraDShowMsgTip(i18n("jinn_skill_78"))
	end
end
function MagicLampSkillMainPanel:updateButtonState(...)
	local enough = magicLampSkillCtrl:checkMergeItemEnough() or false
	self.fields.Button_tujian:setReddot(enough)
	if self.is3SSwitchOpen then
		local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
		local receiveStatus, exchangeNum = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010011)
		local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
		local receiveStatus2, exchangeNum2 = newExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER)
		local allExchangeNum = exchangeNum + exchangeNum2
		self.fields.Button_exchange:setReddot((receiveStatus or receiveStatus2) and 0 < allExchangeNum, allExchangeNum)
	end
end
function MagicLampSkillMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "skill" then
		return self.fields.List_skill:getChildAt(0)
	end
	return self.fields[itemName]
end
return MagicLampSkillMainPanel
