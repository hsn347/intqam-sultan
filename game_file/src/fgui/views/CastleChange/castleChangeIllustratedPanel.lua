local publicRead = include("publicRead")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local dressltCtrl = include("dressltCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local castleSkinRead = include("castleSkinRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local castleChangeIllustratedPanel = class("castleChangeIllustratedPanel", baseFguiPanel)
function castleChangeIllustratedPanel:ctor(...)
	castleChangeIllustratedPanel.super.ctor(self, ...)
	print("castleChangeIllustratedPanel:ctor", self.viewName)
end
function castleChangeIllustratedPanel:onInit()
	print("=======castleChangeIllustratedPanel:onInit")
	self.listData, _ENV, self.skinFilterType = gSkinFilterType.ALL, gSkinFilterType.ALL, gSkinFilterType.ALL
	self.fields.Com_title:initData(i18n("skin_text_11"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_attr:setString(i18n("skin_text_14"))
	self.fields.Button_attr:addClickListener(handler(self, self.btnAttrClick))
	self.fields.Text_HaveNum:setString(i18n("skin_text_12"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onSkinRenderer))
	self.fields.Label_banner:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_num:fixPos()
	self.fields.Text_HaveNum:fixPos()
	self.fields.Com_item:fixPos()
end
function castleChangeIllustratedPanel:onSkinRenderer(index, obj)
	obj:initData(self.listData[index + 1], self.listData)
end
function castleChangeIllustratedPanel:onShow()
	print("=======castleChangeIllustratedPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.curTableData = dressCtrl:getIllustratedCastle()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.skinFilterType, self.skinFilterType
	;(nil).title = i18n("common_text_635")
	_ENV, self.skinFilterType[1], (nil).tag = nil, nil, gSkinFilterType.ALL
	;(nil).title = i18n("recharge_label_011")
	_ENV, self.skinFilterType[2], (nil).tag = nil, nil, gSkinFilterType.HOLIDAY
	;(nil).title = i18n("complete_text_02")
	_ENV, self.skinFilterType[3], (nil).tag = nil, nil, gSkinFilterType.LIMIT
	;(nil).title = i18n("begging_text_02")
	_ENV, self.skinFilterType[4], (nil).tag = nil, nil, gSkinFilterType.SUPREME
	;(nil).title = i18n("common_text_2697")
	;(nil).tabsetArray, self.skinFilterType[5], (nil).tag = self.skinFilterType, nil, gSkinFilterType.NORMAL
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_Tab:initView(nil)
	self:initData()
end
function castleChangeIllustratedPanel:onTabClick(tag)
	self.skinFilterType = tag
	local index = 1
	self.listData, _ENV = nil, nil
	for i, v in ipairs(self.curTableData) do
		if self:isFilterPass(v.subType, self.skinFilterType) and castleSkinRead.isAvailableBySubType(v.subType) == 1 and dressltCtrl.isShowDress(v.dressID) then
			_ENV = v.subType
			v.subType.index = index
			v.subType.subType = v.subType
			v.subType.dressType = 1
			v.subType.selType = 1
			v.subType.data = v
			table.insert(self.listData, v.subType)
			index = index + 1
		else
			print("subType 没找到", i, v.dressID, v.subType)
		end
	end
	self.fields.List:setNumItems(#self.listData)
	self.fields.List:jumpToTop()
end
function castleChangeIllustratedPanel:isFilterPass(subType, filterType)
	if filterType == gSkinFilterType.ALL then
		return true
	end
	local skinQuality = castleSkinRead.getSkinQualityBySubType(subType)
	if filterType == gSkinFilterType.NORMAL then
		if skinQuality == gSkinQuality.NONE or skinQuality == gSkinQuality.OHTER then
			return true
		end
	else
		return skinQuality == filterType
	end
end
function castleChangeIllustratedPanel:initData(target, data)
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
	end
	local numCanGet, showStage = dressCtrl:getLastCanGet()
	self.dressNums = dressCtrl:getPermanentCastleDressNum()
	self.rewardConfig = castleSkinRead.getStageInfo(showStage)
	self.fields.Text_num:setString(string.formatnumberthousands(self.dressNums))
	self.fields.Com_item:initData(self.rewardConfig, 0 < numCanGet)
end
function castleChangeIllustratedPanel:btnAttrClick()
	SoraDPlaySound()
	uiManager:show("castleChangeAttrView")
end
function castleChangeIllustratedPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("skin_text_20")
	;(nil).content = i18n("skin_text_21")
	uiManager:show("RuleView", nil)
end
return castleChangeIllustratedPanel
