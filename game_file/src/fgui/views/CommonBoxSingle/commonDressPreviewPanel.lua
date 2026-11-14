local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local publicRead = include("publicRead")
local castleSkinRead = include("castleSkinRead")
local castleSkinConfigRead = include("castleSkinConfigRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonDressPreviewPanel = class("commonDressPreviewPanel", baseFguiPanel)
function commonDressPreviewPanel:ctor(...)
	self.isLRU = true
	commonDressPreviewPanel.super.ctor(self, ...)
	print("commonDressPreviewPanel:ctor", self.viewName)
end
function commonDressPreviewPanel:onInit()
	print("=======commonDressPreviewPanel:onInit")
	self.Text_ownDress = SoraDCreateTimerLabel(self, self.fields.Text_ownDress)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function commonDressPreviewPanel:onItemRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function commonDressPreviewPanel:endShow()
	print("=======commonDressPreviewPanel:endShow")
	self.itemID = self.param and self.param.itemID
	self.customData = self.param and self.param.customData
	if self.itemID then
		self:initData()
	elseif self.customData then
		self:initCustomData()
	end
end
function commonDressPreviewPanel:initData()
	self.result = backpackltCtrl:getResult(self.itemID)
	self.fields.Panel_bg:setString(publicRead.getName(self.itemID))
	local ret, remainTime, foreverCount, curCount = backpackCtrl:getOwnDressInfo(self.itemID)
	if ret then
		if 0 < remainTime then
			self.Text_ownDress:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_4936", nil)
			end)
			self.Text_ownDress:setTimeEndListener(function()
				self = nil
				;(nil).num = string.formatnumberthousands(curCount)
				self.Text_ownDress:setString(i18n("skin_text_23", nil))
			end)
			self.Text_ownDress:beginTime(remainTime)
			self.Text_ownDress:setColor("#70C723")
		else
			self.Text_ownDress:setString(i18n("common_text_4831"))
			self.Text_ownDress:setColor("#E02B2B")
		end
	elseif 0 < foreverCount then
		self.Text_ownDress:setString(i18n("common_text_4937"))
		self.Text_ownDress:setColor("#70C723")
	else
		backpackltCtrl = i18n("common_text_4937")
		i18n("common_text_4937").num = string.formatnumberthousands(curCount)
		self.Text_ownDress:setString(i18n("skin_text_23", i18n("common_text_4937")))
		self.Text_ownDress:setColor("#E02B2B")
	end
	self.fields.Text_ownDress:setVisible(true)
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	self.skinShow, self.skinType = backpackltCtrl:isSkinShow(self.itemID)
	self:initView()
end
function commonDressPreviewPanel:initView()
	local target = self.fields.Com_pre:getChild("Com_empty")
	target:removeAllChildren()
	if self.skinType == DRESS_PREVIEW_TYPE.CASTLE or self.skinType == DRESS_PREVIEW_TYPE.CASTLECHIPS then
		self.fields.Text_tip:setString(i18n("common_title_04"))
		local _ENV, dressID = backpackltCtrl, self.skinType == DRESS_PREVIEW_TYPE.CASTLE and self.result or backpackltCtrl:getResult(self.result[1])
		backpackltCtrl.isSafe = false
		backpackltCtrl.playerID = SoraDGetPlayerID()
		local backpackltCtrl.castleSkin, ownCityData = dressID, backpackltCtrl
		local castle = include("worldMapBuildingPreview").new()
		castle:setScale(1.0)
		castle:setPosition(30, -50)
		castle:addTo(target)
		castle:initCityData(ownCityData)
		if castle.image_level then
			castle.image_level:setVisible(false)
		end
		self.subType = castleSkinRead.getSubType(dressID)
	elseif self.skinType == DRESS_PREVIEW_TYPE.TROOP or self.skinType == DRESS_PREVIEW_TYPE.TROOPCHIPS then
		self.fields.Text_tip:setString(i18n("common_title_05"))
		local dressID = self.skinType == DRESS_PREVIEW_TYPE.TROOP and self.result or backpackltCtrl:getResult(self.result[1])
		local marchType = castleSkinRead.getMarchType(dressID)
		print("dressID,marchType=======", dressID, marchType)
		local troopsHelper = include("troopsHelper")
		local marchCfg = troopsHelper.getMarchEffect(marchType)
		local armyNode = self:createArmyNode(dressID)
		local offset = cc.p(0, 0)
		if marchCfg then
			offset = marchCfg.preCfg and marchCfg.preCfg.preViewOffset or cc.p(0, 0)
		end
		armyNode:setPosition(offset)
		armyNode:addTo(target)
		self.subType = castleSkinRead.getSubType(dressID)
	end
	self:refreshAttr()
end
function commonDressPreviewPanel:createArmyNode(troopEffect)
	local armyNode = display.newNode()
	local endPos = cc.p(-display.cx - 60, -100)
	local beginPos = cc.p(-60, 0)
	_ENV, _UPVALUE4_ = 0, -60
	;(0).id = 401
	_ENV, (0).num = nil, 1000
	;(nil).id = 501
	_ENV, (nil).num = nil, 1000
	;(nil).id = 601
	_ENV, (nil).num = nil, 1000
	;(nil).id = 710
	;(nil).num = 1000
	;(-60)[1] = 0
	;(-60)[2] = nil
	;(-60)[3] = nil
	local (-60)[4], soldiers = nil, -60
	local troopsMatrix = include("troopsMatrixPreview")
	local warMatrix = troopsMatrix.new()
	warMatrix:addTo(armyNode)
	warMatrix:setName("warMatrix")
	_ENV, castleSkinRead = nil, 0
	;(nil).armyList = soldiers
	;(0)[1] = nil
	warMatrix:initData(beginPos, endPos, cc.p(0, 0), cc.p(0, 0), gMapObjTypeDef.mapObjTypeCampsite, 0)
	warMatrix:marchEffect(castleSkinRead.getMarchType(troopEffect), true, nil, troopEffect)
	warMatrix:setPosition(beginPos)
	warMatrix.beginPos = beginPos
	warMatrix:setVisible(true)
	warMatrix:setTouchEnabled(false)
	warMatrix:setSoliderVisible(true)
	local moveLine = include("worldMapMoveLine").new(beginPos, endPos)
	armyNode:addChild(moveLine, -1)
	warMatrix:setMoveLine(moveLine)
	moveLine:setMoveLineColor(gMapMoveLineColor.moveLineColorGreen)
	moveLine:setPosition(beginPos)
	moveLine:showMoveline(0)
	self.moveLine = moveLine
	_ENV, _ENV, self.moveLine.beginPos = moveLine, self.moveLine, beginPos
	moveLine.distancePrecent = 0.3
	_ENV, self.moveLine[1], moveLine.time = moveLine, moveLine, 10
	moveLine.distancePrecent = 1
	self.moveLine[2], moveLine.time = moveLine, 999999
	local span = self.moveLine
	_ENV = -1
	;(-1).currentMoveTime = 10
	;(-1).moveTimeSpan = span
	warMatrix:setMoveTimeData(-1)
	warMatrix:beginMove(0)
	return armyNode, warMatrix
end
function commonDressPreviewPanel:refreshAttr()
	if not self.subType then
		return
	end
	self.attrList, castleSkinRead = self.subType, self.subType
	local ownAttr = castleSkinRead.getOwnAttrBySubType(self.subType)
	local useAttr = castleSkinRead.getUseAttrBySubType(self.subType)
	if 0 < #ownAttr then
		castleSkinRead = nil
		table.insert(self.attrList, nil)
		self.attrList[#self.attrList].title = i18n("skin_title_02")
		local castleSkinRead, list = self.attrList[#self.attrList], self.attrList[#self.attrList]
		for i, v in ipairs(ownAttr) do
			castleSkinRead = nil
			;(nil).attrID = v.attrID
			;(nil).attrValue = v.attrValue
			table.insert(list, nil)
		end
		self.attrList[#self.attrList].list = list
	end
	if 0 < #useAttr then
		castleSkinRead = #self.attrList
		table.insert(self.attrList, #self.attrList)
		self.attrList[#self.attrList].title = i18n("skin_title_01")
		local castleSkinRead, list = self.attrList[#self.attrList], self.attrList[#self.attrList]
		for i, v in ipairs(useAttr) do
			castleSkinRead = nil
			;(nil).attrID = v.attrID
			;(nil).attrValue = v.attrValue
			table.insert(list, nil)
		end
		self.attrList[#self.attrList].list = list
	end
	self.fields.List:setNumItems(#self.attrList)
	self.fields.List:jumpToTop()
end
function commonDressPreviewPanel:initCustomData()
	self.skinType = self.customData.skinType
	self.fields.Panel_bg:setString(self.customData.title)
	self.fields.Text_ownDress:setVisible(false)
	self.fields.Text_des:setString(self.customData.des)
	self:initCustomView()
end
function commonDressPreviewPanel:initCustomView()
	local target = self.fields.Com_pre:getChild("Com_empty")
	target:removeAllChildren()
	if self.skinType == DRESS_PREVIEW_TYPE.PALACE then
		self.fields.Text_tip:setString(i18n("atlantiswar_text_0421"))
		self.fields.Text_des:setVisible(true)
		self.fields.sheer:setVisible(true)
		local palaceInfoRead = include("palaceInfoRead")
		local sprite = display.newSprite(palaceInfoRead.getImg(13, true))
		sprite:setPosition(-38, 0)
		sprite:setScale(0.7)
		sprite:addTo(target)
		self:refreshPalaceAttr()
	elseif self.skinType == DRESS_PREVIEW_TYPE.SIGN then
		self.fields.Text_tip:setString(i18n("atlantiswar_text_0395"))
		self.fields.Text_des:setVisible(false)
		self.fields.sheer:setVisible(false)
		_ENV = self.fields.sheer.setVisible
		self.fields.sheer.setVisible.isSafe = false
		self.fields.sheer.setVisible.playerID = SoraDGetPlayerID()
		self.fields.sheer.setVisible.cityLevel = SoraDGetBuildLv()
		self.fields.sheer.setVisible.castleSkin = dressCtrl:getCurDressID(gDressType.CASTLE) or 0
		self.fields.sheer.setVisible.starLv = SoraDGetBuildStarLv()
		self.fields.sheer.setVisible.signature = " "
		local self.fields.sheer.setVisible.signatureBox, ownCityData = 1, self.fields.sheer.setVisible
		local castle = include("worldMapBuildingPreview").new()
		castle:setScale(1.0)
		castle:setPosition(30, -50)
		castle:addTo(target)
		castle:initCityData(ownCityData)
		castle:setSignNodeGroupID(0)
		if castle.image_level then
			castle.image_level:setVisible(false)
		end
		self:refreshSignAttr()
	end
end
function commonDressPreviewPanel:refreshPalaceAttr()
	self.attrList, _ENV = nil, nil
	local palaceInfoRead = include("palaceInfoRead")
	if palaceInfoRead.checkAtlantisPalaceBuff() then
		self.fields.Text_des:setVisible(true)
		self.fields.sheer:setVisible(true)
		_UPVALUE3_ = self.fields.sheer.setVisible
		self.fields.sheer.setVisible[1] = "atlantiswar_text_0273"
		self.fields.sheer.setVisible[2] = "atlantiswar_text_0274"
		local self.fields.sheer.setVisible[3], config = "atlantiswar_text_0275", self.fields.sheer.setVisible
		_ENV = "atlantiswar_text_0275"
		table.insert(self.attrList, "atlantiswar_text_0275")
		self.attrList[#self.attrList].title = i18n("skin_title_02")
		local _ENV, list = self.attrList[#self.attrList], self.attrList[#self.attrList]
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).custom = i18n(v)
			table.insert(list, nil)
		end
		self.attrList[#self.attrList].list = list
	else
		self.fields.Text_des:setVisible(false)
		self.fields.sheer:setVisible(false)
		local _ENV, data = self.fields.sheer.setVisible, self.fields.sheer.setVisible
		data.title = i18n("common_text_001")
		local _ENV, list = i18n("common_text_001"), i18n("common_text_001")
		_ENV = ipairs(config)
		ipairs(config).custom = self.customData.des
		ipairs(config).isSingleH = true
		table.insert(list, ipairs(config))
		data.list = list
		table.insert(self.attrList, data)
	end
	self.fields.List:setNumItems(#self.attrList)
	self.fields.List:jumpToTop()
end
function commonDressPreviewPanel:refreshSignAttr()
	self.attrList, _ENV = nil, nil
	local _ENV, data
	data.title = i18n("common_text_001")
	local _ENV, list = i18n("common_text_001"), i18n("common_text_001")
	_ENV = nil
	;(nil).custom = self.customData.des
	;(nil).isSingleH = true
	table.insert(list, nil)
	data.list = list
	table.insert(self.attrList, data)
	self.fields.List:setNumItems(#self.attrList)
	self.fields.List:jumpToTop()
end
return commonDressPreviewPanel
