local cityBuildCastleSkinConfig = include("cityBuildCastleSkinConfig")
local castleSkinRead = include("castleSkinRead")
local jumpDesRead = include("jumpDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local castleChangeDetailViewPanel = class("castleChangeDetailViewPanel", baseFguiPanel)
function castleChangeDetailViewPanel:ctor(...)
	self.isLRU = true
	castleChangeDetailViewPanel.super.ctor(self, ...)
	print("castleChangeDetailViewPanel:ctor", self.viewName)
end
function castleChangeDetailViewPanel:onInit()
	print("=======castleChangeDetailViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("skin_text_18"))
	self.fields.Button_Left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Button_Right:addClickListener(handler(self, self.btnRightClick))
	self.fields.Button_Source:setString(i18n("common_text_477"))
	self.fields.Button_Source:addClickListener(handler(self, self.btnSourceClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_Source:fixPos()
end
function castleChangeDetailViewPanel:onItemRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function castleChangeDetailViewPanel:endShow()
	print("=======castleChangeDetailViewPanel:endShow")
	self.listData = self.param.listData
	self.selIndex = self.param.selIndex
	self:initData()
end
function castleChangeDetailViewPanel:initData()
	self.dressID = self.listData[self.selIndex].data.dressID
	self.fields.Text_CastleName:setString(i18n(castleSkinRead.getNameBySubType(self.listData[self.selIndex].subType)))
	self:updateCastle()
	self:refreshAttr()
	self:refreshSourceList()
end
function castleChangeDetailViewPanel:getSourceWayName(source)
	if table.nums(source) == 1 and source[1] == 14 then
		return i18n("common_text_4506")
	elseif source[1] == 14 then
		return i18n("dress_text_200")
	else
		local itemCfg = jumpDesRead.getCfg(source[1])
		return itemCfg.des
	end
end
function castleChangeDetailViewPanel:refreshSourceList()
	local subData = self.listData[self.selIndex]
	local subType = subData.subType
	local source = castleSkinRead.getSourceBySubType(subType)
	if source and next(source) ~= nil then
		self.fields.Text_Source:setVisible(true)
		self.fields.Button_Source:setVisible(true)
		self.fields.Text_Source:setString(i18n(self:getSourceWayName(source)))
	else
		self.fields.Text_Source:setVisible(false)
		self.fields.Button_Source:setVisible(false)
	end
end
function castleChangeDetailViewPanel:refreshAttr()
	local subType = self.listData[self.selIndex].subType
	self.attrList, castleSkinRead = self.selIndex, self.selIndex
	local ownAttr = castleSkinRead.getOwnAttrBySubType(subType)
	local useAttr = castleSkinRead.getUseAttrBySubType(subType)
	local subData = self.listData[self.selIndex]
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
end
function castleChangeDetailViewPanel:updateCastle()
	self.castleModel = castleSkinRead.getCastleType(self.dressID)
	if self.castleSkin then
		self.castleSkin:removeRelation()
		self.castleSkin:removeFromParent()
		self.castleSkin = nil
	end
	local skinInfo = cityBuildCastleSkinConfig.getSkinInfo(self.castleModel)
	local offset = cityBuildCastleSkinConfig.getSkinOffset(skinInfo)
	if skinInfo.isFgui then
		self.castleSkin = fgui.UIPackage:createObject("CastleSkin", skinInfo.csb)
		self.castleSkin:init(skinInfo)
		self.castleSkin:setPosition(offset.x - 414, offset.y - 355)
	else
		self.castleSkin = include("mainCityCastleSkin").new(cityBuildCastleSkinConfig.getSkinCsb(skinInfo))
		self.castleSkin:initModel(self.castleModel, self, skinInfo)
		self.castleSkin:setPosition(offset.x - 414, offset.y - 205)
	end
	self.castleSkin:addTo(self.fields.Com_castlePre:getChild("Com_castle"))
end
function castleChangeDetailViewPanel:btnLeftClick()
	self.selIndex = self.selIndex - 1
	if self.selIndex < 1 then
		self.selIndex = #self.listData
	end
	self:initData()
end
function castleChangeDetailViewPanel:btnRightClick()
	self.selIndex = self.selIndex + 1
	if self.selIndex > #self.listData then
		self.selIndex = 1
	end
	self:initData()
end
function castleChangeDetailViewPanel:btnSourceClick()
	SoraDPlaySound()
	local subType = self.listData[self.selIndex].subType
	local sources = castleSkinRead.getSourceBySubType(subType)
	if sources and table.nums(sources) == 1 then
		SoraDJumpBySourceId(sources[1])
	else
		_ENV = nil
		;(nil).sources = sources
		uiManager:show("CommonSourceGuide", nil)
	end
end
return castleChangeDetailViewPanel
