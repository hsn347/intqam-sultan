local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local mapResExplainRead = include("mapResExplainRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local activity_9001573_Read = include("activity_9001573_Read")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local Com_content = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/Com_content", Com_content)
_ENV = fgui.register_extension
fgui.register_extension.personal = 1
fgui.register_extension.alliance = 2
local _ENV, fgui.register_extension.nebulaDefence, viewType = "ui://WorldMap/Com_content", 3, fgui.register_extension
;("ui://WorldMap/Com_content")[viewType.alliance] = true
local ("ui://WorldMap/Com_content")[viewType.nebulaDefence], helpVisibleConfig = true, "ui://WorldMap/Com_content"
function Com_content:onInit()
	self.markItemList, _ENV, self.curIndexList, _ENV = nil, nil, nil, nil
	_ENV, _ENV, self.saveLastInput = nil, nil, nil
	;(nil).name = i18n("common_text_636")
	_ENV, (nil)[1], (nil).icon = nil, nil, "icon_map_favorite_01.png"
	;(nil).name = i18n("common_text_637")
	_ENV, (nil)[2], (nil).icon = nil, nil, "icon_map_favorite_02.png"
	;(nil).name = i18n("common_text_638")
	self.personalConfig, (nil)[3], (nil).icon = nil, nil, "icon_map_favorite_03.png"
	self.campMarkList = activity_9001573_Ctrl:getCampMarkList()
	self.allianceMarkData = collectMapCtrl:getAllianceMarkData()
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Began, handler(self, self.OnEditBoxTouch))
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	self.fields.Text_notice:setString(i18n("common_text_642"))
	self.fields.Text_choose:setString(i18n("common_text_643"))
	self.fields.Button_yes:setTitleText(i18n("common_text_204"))
	self.fields.Button_yes:addClickListener(handler(self, self.btnYesClick))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickBtnItem))
end
function Com_content:onShow()
end
function Com_content:initData(curType, bookMarkData)
	self.curType = curType
	self.bookMarkData = bookMarkData
	self.fields.TextField_name:setText(self.bookMarkData.name)
	_ENV = nil
	;(nil).x = self.bookMarkData.pos.x
	;(nil).y = self.bookMarkData.pos.y
	self.fields.Text_pos:setString(i18n("common_text_465", nil))
	self:updateView(self.curType)
	if self.curType == viewType.alliance then
		local markIndex = collectMapCtrl:isAllianceMark(self.bookMarkData.pos.k, self.bookMarkData.pos.x, self.bookMarkData.pos.y) or 1
		self:setCurIndex(markIndex)
	else
		self:setCurIndex(self.bookMarkData.type)
	end
end
function Com_content:updateView(curType)
	self.curType = curType
	if helpVisibleConfig[self.curType] then
		self.fields.Button_help:setVisible(true)
	else
		self.fields.Button_help:setVisible(false)
	end
	self.saveLastInput = nil
	self:refreshTxtField()
	helpVisibleConfig = self.refreshTxtField
	self.refreshTxtField[viewType.personal] = 30
	self.refreshTxtField[viewType.alliance] = 20
	local self.refreshTxtField[viewType.nebulaDefence], config = 20, self.refreshTxtField
	if worldMapDefine.isInRoaringFlame() then
		config[viewType.alliance] = 100
	end
	self.maxLength = config[self.curType]
	self.fields.TextField_name:setMaxLength(self.maxLength)
	helpVisibleConfig = self.fields.TextField_name.setMaxLength
	self.fields.TextField_name.setMaxLength[viewType.personal] = 3
	local self.fields.TextField_name.setMaxLength[viewType.alliance], numConfig = mapResExplainRead:getAlliancemapmarkNums(), self.fields.TextField_name.setMaxLength
	if self.curType == viewType.nebulaDefence then
		numConfig[viewType.nebulaDefence] = activity_9001573_Read.getMarkNums()
	end
	self.fields.List:removeAllChildren()
	self.fields.List:setNumItems(numConfig[self.curType])
	self:setCurIndex(self:getCheckBoxVal())
end
function Com_content:onItemProvider(index)
	if self.curType == viewType.personal then
		return "ui://WorldMap/Com_typeSingle2"
	else
		return "ui://WorldMap/Com_typeSingle"
	end
end
function Com_content:onItemRender(index, target)
	local viewType, markData
	if self.curType == viewType.personal then
		target:setText(self.personalConfig[index + 1].name)
		target:setIcon(self.personalConfig[index + 1].icon)
	elseif self.curType == viewType.alliance then
		target:setIcon(mapResExplainRead.getAlliancemapmarkIcon(index + 1))
		markData = self.allianceMarkData
	elseif self.curType == viewType.nebulaDefence then
		target:setIcon(activity_9001573_Read.getCampMarkIcon(index + 1))
		markData = self.campMarkList
	end
	local data = markData[tostring(index + 1)]
	local controllers1 = target:getController("c1")
	if data and controllers1 then
		controllers1:setSelectedIndex(1)
	elseif controllers1 then
		controllers1:setSelectedIndex(0)
	end
end
function Com_content:refreshTxtField(...)
	if self.curType == viewType.alliance then
		local curIndex = self:getCheckBoxVal()
		local data = self.allianceMarkData[tostring(curIndex)]
		if data then
			self.fields.TextField_name:setText(data.name)
			return
		end
	end
	if self.saveLastInput then
		self.fields.TextField_name:setText(self.saveLastInput)
	else
		self.fields.TextField_name:setText(self.bookMarkData.name)
	end
end
function Com_content:btnHelpClick()
	SoraDPlaySound()
	if self.curType == viewType.alliance then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = nil
		;(nil).align = SoraDFLabelR()
		SoraDShowHelpMsgTip(worldMapWarDef.getAllianceMarkHelp(), nil)
	elseif self.curType == viewType.nebulaDefence then
		_ENV = "Celestial_defense_text_016"
		;("Celestial_defense_text_016").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Celestial_defense_text_016"), "Celestial_defense_text_016")
	end
end
function Com_content:btnYesClick()
	SoraDPlaySound()
	if self.curType == viewType.alliance then
		local worldMapWarDef = include("worldMapWarDef")
		if not worldMapWarDef.checkAllianceMarkRank(true) then
			if self.yesBackHandler then
				self.yesBackHandler()
			end
			return
		end
		collectMapCtrl, _ENV = nil, nil
		;(nil).position, (nil)[1] = nil, self.bookMarkData.pos.x
		;(nil).position, (nil)[2] = nil, self.bookMarkData.pos.y
		;(nil).markType = self:getCheckBoxVal()
		;(nil).name = self.fields.TextField_name:getText()
		;(nil).mapID = self.bookMarkData.pos.k
		;(nil).maxLength = self.maxLength
		collectMapCtrl:reqAddAllianceMark(nil)
		if self.yesBackHandler then
			self.yesBackHandler()
		end
		return
	end
	if self.curType == viewType.nebulaDefence then
		if not worldMapDefine.checkCurrentKingdomIsMyKingdom() then
			SoraDShowMsgTip(i18n("Celestial_defense_text_073"))
			return
		end
		print("self.fields.TextField_name:getText()", self.fields.TextField_name:getText())
		local markType = self:getCheckBoxVal()
		_ENV = self.fields.TextField_name:getText()
		self.fields.TextField_name:getText().key = self:getCheckBoxVal()
		self.fields.TextField_name:getText().desc = self.fields.TextField_name:getText()
		self.fields.TextField_name:getText().x = self.bookMarkData.pos.x
		self.fields.TextField_name:getText().y = self.bookMarkData.pos.y
		activity_9001573_Ctrl:reqSetMark(self.fields.TextField_name:getText())
		_ENV = activity_9001573_Ctrl
		activity_9001573_Ctrl.name1 = lordInfoCtrl:getLordInfo().base.nickName
		activity_9001573_Ctrl.name2 = activity_9001573_Read.getCampMarkName(markType)
		activity_9001573_Ctrl.txt = self.fields.TextField_name:getText()
		dump(activity_9001573_Ctrl, "号角数据：")
		_ENV = self.fields.TextField_name
		self.fields.TextField_name.name1 = lordInfoCtrl:getLordInfo().base.nickName
		self.fields.TextField_name.name2 = activity_9001573_Read.getCampMarkName(markType)
		self.fields.TextField_name.txt = self.fields.TextField_name:getText()
		chatCtrl:sendServiceMessageByGold(i18n("Celestial_defense_text_069", self.fields.TextField_name))
		if self.yesBackHandler then
			self.yesBackHandler()
		end
		return
	end
	if collectMapCtrl:getMapDataCount() >= MAX_COLLECT_NUM then
		_ENV = i18n("Celestial_defense_text_069", self.fields.TextField_name)
		i18n("Celestial_defense_text_069", self.fields.TextField_name).count = MAX_COLLECT_NUM
		SoraDShowMsgTip(i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)))
		return
	end
	if self.bookMarkData.isEdit then
		collectMapCtrl, _ENV = i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).position, i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))[1] = i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).position, i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))[2] = i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).positionType = self:getCheckBoxVal()
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).name = self.fields.TextField_name:getText()
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).mapID = self.bookMarkData.pos.k
		collectMapCtrl:editCollectMap(i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)))
	else
		collectMapCtrl, _ENV = self.bookMarkData.pos.k, i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).position, self.bookMarkData.pos.k[1] = self.bookMarkData.pos.k, self.bookMarkData.pos.x
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).position, self.bookMarkData.pos.k[2] = self.bookMarkData.pos.k, self.bookMarkData.pos.y
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).positionType = self:getCheckBoxVal()
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).name = self.fields.TextField_name:getText()
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).mapID = self.bookMarkData.pos.k
		collectMapCtrl:collectMap(i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)))
		_ENV = i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name))
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).x = self.bookMarkData.pos.x
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).y = self.bookMarkData.pos.y
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).k = self.bookMarkData.pos.k
		i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)).isLook = false
		table.insert(gCollectTempData, i18n("common_text_1519", i18n("Celestial_defense_text_069", self.fields.TextField_name)))
	end
	if self.yesBackHandler then
		self.yesBackHandler()
	end
end
function Com_content:setYesBackHandle(handler)
	self.yesBackHandler = handler
end
function Com_content:getCheckBoxVal()
	return self.curIndexList[self.curType] or 1
end
function Com_content:setCurIndex(index)
	self.fields.List:setSelectedIndex(index - 1)
	self.curIndexList[self.curType] = index
	if self.curType == viewType.alliance then
		self.fields.Text_choose:setString(i18n(mapResExplainRead.getAlliancemapmarkName(index)))
	elseif self.curType == viewType.personal then
		self.fields.Text_choose:setString(i18n("common_text_643"))
	elseif self.curType == viewType.nebulaDefence then
		self.fields.Text_choose:setString(i18n(activity_9001573_Read.getCampMarkName(index)))
	end
end
function Com_content:onSubmit()
	local inputText = self.fields.TextField_name:getText()
	if inputText ~= "" then
		if not self:checkInputText(inputText) then
			self.fields.TextField_name:setText(self.bookMarkData.name)
		else
			self.saveLastInput = inputText
		end
	end
end
function Com_content:checkInputText(inputText)
	local err = gErrDef.Err_None
	if inputText ~= "" then
		local name = string.match(inputText, "%s*(.-)%s*$")
		if string.sub(name, 1, 1) == "(" then
			err = gErrDef.Err_NICKNAME_BRACKET
		elseif string.match(name, "$SoarDragon&") then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif not gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameLegality(name) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif not SoraDIsUtf8String(name) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(inputText) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(inputText) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		end
	end
	if err ~= gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0071"))
		return false
	end
	return true
end
function Com_content:OnEditBoxTouch()
	SoraDPlaySound()
	if self.fields.TextField_name:getText() == self.bookMarkData.name then
		self.fields.TextField_name:setText("")
	end
end
function Com_content:onClickBtnItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex()
	self:setCurIndex(index + 1)
	if self.curType == viewType.personal then
	elseif self.curType == viewType.alliance then
		self:refreshTxtField()
	end
end
return Com_content
