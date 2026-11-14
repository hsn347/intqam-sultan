local gametop = gModuleMgr.getObject("gametop")
local worldMapWarDef = include("worldMapWarDef")
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local worldMapDefine = include("worldMapDefine")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapBookMarkPanel = class("WorldMapBookMarkPanel", baseFguiPanel)
function WorldMapBookMarkPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapBookMarkPanel:ctor", self.viewName)
end
function WorldMapBookMarkPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapBookMarkPanel:onInit()
	print("=======WorldMapBookMarkPanel:onInit")
	self.isHideCurrentSceneView = true
	self.isInWar = false
	self.tblTempFlagBookMark, _ENV, self.curTblBookMark, _ENV, self.tblBookMark, _ENV, self.curIndex = print, print, print, print, print, print, 0
	self.selectMode = false
	self.fields.Button_edit:addClickListener(handler(self, self.btnEditClick))
	self.fields.Button_all:addClickListener(handler(self, self.btnAllClick))
	self.fields.Button_del:addClickListener(handler(self, self.btnDelClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Com_title:initData(i18n("common_text_631"), handler(self, self.onClickClose))
	local favoriteTitle = worldMapWarDef.getFavoriteTitle()
	if favoriteTitle then
		self.fields.Com_title:setString(i18n(favoriteTitle))
	end
end
function WorldMapBookMarkPanel:onShow()
	print("=======WorldMapBookMarkPanel:onShow")
	self:initData()
	self:initView()
end
function WorldMapBookMarkPanel:initData(isRefresh)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId()
	if worldMapWarDef.isInWarForbidBookMark(mapClassType) then
		self.isInWar = true
	else
		self.isInWar = false
	end
	local worldMapWarDef, ret = worldMapWarDef.isInWarForbidBookMark(mapClassType), worldMapWarDef.isInWarForbidBookMark(mapClassType)
	if not collectMapCtrl:getCollectMapData() then
		local worldMapWarDef, collectMapData = collectMapCtrl:getCollectMapData(), collectMapCtrl:getCollectMapData()
	end
	for k, v in pairs(collectMapData) do
		table.insert(ret, v)
	end
	if collectMapCtrl:showAllianceMark() then
		if not collectMapCtrl:getAllianceMarkData() then
			local worldMapWarDef, allianceMarkData = collectMapCtrl:getAllianceMarkData(), collectMapCtrl:getAllianceMarkData()
		end
		for k, v in pairs(allianceMarkData) do
			table.insert(ret, v)
		end
	end
	if activity_9001573_Ctrl:getIsActivityOpen() and not worldMapDefine.inInCrossWar() then
		if not activity_9001573_Ctrl:getCampMarkList() then
			local worldMapWarDef, campMarkList = activity_9001573_Ctrl:getCampMarkList(), activity_9001573_Ctrl:getCampMarkList()
		end
		for k, v in pairs(campMarkList) do
			worldMapWarDef = v
			v.mapID = gametop.playertop_:getMapID()
			v.positionType = gCollectType.nebulaDefence
			v.markType = tonumber(k)
			_ENV, v.name = v.desc, v.desc
			v.position, v.desc[1] = v.desc, v.x
			v.position, v.desc[2] = v.desc, v.y
			v.time = 0
			table.insert(ret, v)
		end
	end
	dump(ret, "==WorldMapBookMarkPanel:initData==")
	local worldMapWarDef, tableBookMark = dump, dump
	local kid = worldMapDefine.currentMapKindomID
	for _, v in pairs(ret) do
		local _kid
		if self.isInWar then
			if v.mapID >= GAME_KINGDOM_ID_ASSIGN.RUINS.START and mapClassType == worldMapDefine.getKingdomMapClassByKingdomId(v.mapID) then
				_kid = kid
			end
		elseif v.mapID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
			_kid = v.mapID
		end
		if _kid then
			worldMapWarDef = v.x
			v.x.id = v.id
			v.x.time = v.time
			v.x.type = v.positionType
			v.x.markType = v.markType
			worldMapWarDef, v.x.name = v.name, v.name
			v.name.x = v.position[1]
			v.name.y = v.position[2]
			v.name.k = _kid
			v.x.pos, v.name.mapID = v.name, v.mapID
			v.x.isLook = true
			v.x.posY = 0
			table.insert(tableBookMark, v.x)
		end
	end
	for _, v in pairs(gCollectTempData) do
		if v.isLook == false then
			for _, val in pairs(tableBookMark) do
				if val.pos.x == v.x and val.pos.y == v.y and val.pos.k == v.k then
					if not isRefresh then
						worldMapWarDef = nil
						;(nil).x = v.x
						;(nil).y = v.y
						;(nil).k = v.k
						table.insert(self.tblTempFlagBookMark, nil)
					end
					val.isLook = false
				end
			end
		end
		v.isLook = true
	end
	if isRefresh then
		for _, v in pairs(self.tblTempFlagBookMark) do
			for _, val in pairs(tableBookMark) do
				if val.pos.x == v.x and val.pos.y == v.y and val.pos.k == v.k then
					val.isLook = false
				end
			end
		end
	end
	worldMapWarDef = pairs(self.tblTempFlagBookMark)
	pairs(self.tblTempFlagBookMark).msg = "MESSAGE_SERVER_COLLECTMAP_SUCCESS"
	pairs(self.tblTempFlagBookMark).checkData = true
	SoraDSendMessage(pairs(self.tblTempFlagBookMark))
	self.tblBookMark = tableBookMark
end
function WorldMapBookMarkPanel:initView()
	local defaultClick = 1
	local posData = collectMapCtrl:getCollectPos()
	if posData.curIndex then
		defaultClick = posData.curIndex
	end
	collectMapCtrl, collectMapCtrl = nil, posData.curIndex
	collectMapCtrl, posData.curIndex[1], (nil).title = nil, nil, i18n("common_text_635")
	_ENV, (nil).title = i18n("common_text_636"), i18n("common_text_636")
	collectMapCtrl, posData.curIndex[2], (nil).types, i18n("common_text_636")[1] = nil, nil, i18n("common_text_636"), gCollectType.favorite
	_ENV, (nil).title = i18n("common_text_637"), i18n("common_text_637")
	collectMapCtrl, posData.curIndex[3], (nil).types, i18n("common_text_637")[1] = nil, nil, i18n("common_text_637"), gCollectType.friends
	_ENV, (nil).title = i18n("common_text_638"), i18n("common_text_638")
	self.tabsetArray, posData.curIndex[4], (nil).types, i18n("common_text_638")[1] = posData.curIndex, nil, i18n("common_text_638"), gCollectType.enemy
	if collectMapCtrl:showAllianceMark() then
		collectMapCtrl = gCollectType.enemy
		_ENV, gCollectType.enemy.title = i18n("alliance_mapmark_text_002"), i18n("alliance_mapmark_text_002")
		gCollectType.enemy.types, i18n("alliance_mapmark_text_002")[1] = i18n("alliance_mapmark_text_002"), gCollectType.alliance
		table.insert(self.tabsetArray, 2, gCollectType.enemy)
	end
	if activity_9001573_Ctrl:getIsActivityOpen() then
		collectMapCtrl = gCollectType.enemy
		_ENV, gCollectType.enemy.title = i18n("Celestial_defense_text_064"), i18n("Celestial_defense_text_064")
		gCollectType.enemy.types, i18n("Celestial_defense_text_064")[1] = i18n("Celestial_defense_text_064"), gCollectType.nebulaDefence
		table.insert(self.tabsetArray, 2, gCollectType.enemy)
	end
	collectMapCtrl = 2
	;(2).callback = handler(self, self.btnTabClick)
	;(2).defaultClick = defaultClick
	;(2).tabsetArray = self.tabsetArray
	self.fields.com_Tab:initView(2)
	if defaultClick <= 4 then
		self.fields.com_Tab.fields.List:scrollToView(0)
	end
end
function WorldMapBookMarkPanel:btnTabClick(tag)
	local posData = collectMapCtrl:getCollectPos()
	local inner = self.fields.List:getInnerContainer()
	if self.curIndex >= 1 then
		local scrollInnerYPos = inner:getPositionY()
		print("scrollInnerYPos", scrollInnerYPos)
		posData[self.curIndex] = scrollInnerYPos
	end
	self.curIndex = tag
	self:recoverCheck()
	self:refreshTable()
	self:updateScroll()
	local jumpToTop = true
	if posData[self.curIndex] then
		local innerHeight = inner:getContentSize().height
		local scrollContentH = self.fields.List:getContentSize().height
		if innerHeight > scrollContentH then
			local itemInfoYPos = posData[self.curIndex]
			inner:setPositionY(itemInfoYPos)
			jumpToTop = false
		end
	end
	if jumpToTop then
		self.fields.List:jumpToTop()
	end
end
function WorldMapBookMarkPanel:refreshTable()
	self.curTblBookMark, _ENV = nil, nil
	local curTypes = self.tabsetArray[self.curIndex].types
	if self.curIndex == 1 then
		self.curTblBookMark = self.tblBookMark
	else
		for _, v in pairs(self.tblBookMark) do
			if table.indexof(curTypes, v.type) then
				table.insert(self.curTblBookMark, v)
			end
		end
	end
	if next(self.curTblBookMark) ~= nil then
		self.fields.Text_tip:setVisible(false)
	else
		self.fields.Text_tip:setVisible(true)
		if curTypes and table.indexof(curTypes, gCollectType.alliance) then
			self.fields.Text_tip:setString(i18n("alliance_mapmark_text_011"))
		else
			self.fields.Text_tip:setString(i18n("common_text_696"))
		end
	end
	table.sort(self.curTblBookMark, function(a, b)
		return a.time > b.time
	end)
end
function WorldMapBookMarkPanel:updateScroll()
	self.fields.List:setNumItems(#self.curTblBookMark)
end
function WorldMapBookMarkPanel:onItemRender(index, target)
	target:initIsInWar(self.isInWar)
	target:initData(self.curTblBookMark[index + 1])
	target:showCheck(self.selectMode)
end
function WorldMapBookMarkPanel:btnEditClick()
	SoraDPlaySound()
	if self.selectMode then
		self.selectMode = false
		self:recoverCheck()
		self:updateScroll()
	else
		self.selectMode = true
		self:updateScroll()
	end
end
function WorldMapBookMarkPanel:btnAllClick()
	SoraDPlaySound()
	local isSelectAll = true
	for _, v in pairs(self.curTblBookMark) do
		if not v.isCheck then
			isSelectAll = false
			break
		end
	end
	if isSelectAll then
		for _, v in pairs(self.curTblBookMark) do
			v.isCheck = false
		end
	else
		for _, v in pairs(self.curTblBookMark) do
			v.isCheck = true
		end
	end
	self:updateScroll()
end
function WorldMapBookMarkPanel:btnDelClick()
	SoraDPlaySound()
	local _ENV, delArray = SoraDPlaySound, SoraDPlaySound
	local mapID = gametop.playertop_:getMapID()
	if mapID ~= worldMapDefine.currentMapKindomID then
		mapID = worldMapDefine.currentMapKindomID
	end
	for i, v in ipairs(self.curTblBookMark) do
		if self.fields.List:getChildAt(i - 1):isItemCheck() and self:checkCanBatchDelete(v.type) then
			worldMapDefine, _ENV = nil, v.type
			v.type.position, (nil)[1] = nil, v.pos.x
			v.type.position, (nil)[2] = nil, v.pos.y
			v.type.mapID = v.pos.k
			table.insert(delArray, v.type)
		end
	end
	if next(delArray) ~= nil then
		local showMsg = i18n("common_text_4327")
		SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				collectMapCtrl:deleteCollectMap(delArray)
			end
		end)
	end
end
function WorldMapBookMarkPanel:checkCanBatchDelete(collectType)
	_ENV = nil
	;(nil)[gCollectType.favorite] = true
	;(nil)[gCollectType.friends] = true
	local (nil)[gCollectType.enemy], config = true, nil
	return config[collectType]
end
function WorldMapBookMarkPanel:recoverCheck()
	for _, v in pairs(self.tblBookMark) do
		if v.isCheck then
			v.isCheck = false
		end
	end
end
function WorldMapBookMarkPanel:onHide()
	local posData = collectMapCtrl:getCollectPos()
	posData.curIndex = self.curIndex
	local scrollInnerYPos = self.fields.List:getInnerContainer():getPositionY()
	posData[self.curIndex] = scrollInnerYPos
	collectMapCtrl:setCollectPos(posData)
end
function WorldMapBookMarkPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "closeButton" then
		return self.fields.Com_title:getChild("Button_close")
	end
	return self.fields[itemName]
end
return WorldMapBookMarkPanel
