local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorEnergyPanel = class("NebulaEmperorEnergyPanel", baseFguiPanel)
function NebulaEmperorEnergyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorEnergyPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.buffIDList, _ENV, self.buffEnergy = print, print, 0
end
function NebulaEmperorEnergyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaEmperorEnergyPanel:onInit()
	print("=======NebulaEmperorEnergyPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	local handlerHelp
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		self.fields.Image_bg:setURL("bg_qmx_nengliang.png")
		self.fields.Usm_bg:setEffectPath("G_qmx_nengliangjiacheng.usm")
		self.fields.Text_des:setString(i18n("NebulaAllstar_291"))
		handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("energyBuff")
	else
		self.fields.Image_bg:setURL("bg_xydw_nengliang.png")
		self.fields.Usm_bg:setEffectPath("G_xydw_nengliangjc.usm")
		local build1 = nebulaEmperorRead.getBuildNameByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace)
		local build2 = nebulaEmperorRead.getBuildNameByType(gWorldTypeServerDef.subTypeNebulaEmperorWarTower)
		_ENV = i18n("NebulaAllstar_291")
		i18n("NebulaAllstar_291").build1 = build1
		i18n("NebulaAllstar_291").build2 = build2
		local desStr = i18n("nebulaemperor_text_112", i18n("NebulaAllstar_291"))
		self.fields.Text_des:setString(desStr)
		handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	end
	self.fields.Com_title:initData(i18n("nebulaemperor_text_22"), handler(self, self.onClickClose), handlerHelp)
	self.fields.List_build:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	_ENV = self.fields.List_buff.setItemRenderer
	_ENV, _ENV, self.fields.List_buff.setItemRenderer.defaultClick = handler(self, self.onBuffItemRenderer)
	_ENV, self.fields.List_buff[1], handler(self, self.onBuffItemRenderer).title = handler(self, self.onBuffItemRenderer)
	self.fields.List_buff.setItemRenderer.tabsetArray, self.fields.List_buff[2], handler(self, self.onBuffItemRenderer).title = self.fields.List_buff, handler(self, self.onBuffItemRenderer)
	local self.fields.List_buff.setItemRenderer.callback, param = handler(self, self.onClickTab), self.fields.List_buff.setItemRenderer
	self.fields.com_Tab:initView(param)
	if not SoraDFIsRA() then
		self.fields.Com_energy:fixChildrenPos()
		self.fields.Image_bg:fix()
		self.fields.Usm_bg:setScaleX(-1)
	end
end
function NebulaEmperorEnergyPanel:onShow()
	print("=======NebulaEmperorEnergyPanel:onShow")
	self:updateBtnEnergyState()
end
function NebulaEmperorEnergyPanel:onClickTab(tag)
	if self.tabIndex == tag then
		return
	end
	self.tabIndex = tag
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	if self.tabIndex == 2 then
		self.fields.List_buff:setNumItems(#self.buffIDList)
	end
	if not self.isInit or not self:getCtrl():getStartPalaceWar() then
		self:getCtrl():reqEnergyData()
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaEmperorEnergyPanel:updateComEnergy(...)
	self.buffEnergy = self:getCtrl():getBuffEnergy()
	local energyMax = self:getRead().getAreaEnergyMax()
	_ENV = nil
	;(nil).num = self.buffEnergy
	;(nil).max = energyMax
	self.fields.Com_energy:setString(i18n("nebulaemperor_text_104", nil))
	local obj = self.fields.Com_energy:getChild("title")
	fguiHelper.setTextWidthHeight(obj, cc.size(500, 40))
end
function NebulaEmperorEnergyPanel:onItemRenderer(index, obj)
	local data = self.buildList[index + 1]
	obj:initData(data, self.activityID)
end
function NebulaEmperorEnergyPanel:onBuffItemRenderer(index, obj)
	local buffID = self.buffIDList[index + 1]
	local cfg = self:getRead().getEnergyBuffConfig(buffID)
	_ENV = nil
	;(nil).cfg = cfg
	;(nil).buffEnergy = self.buffEnergy
	;(nil).handler = handler(self, self.clickExchangeHandler)
	;(nil).activityID = self.activityID
	obj:initData(nil)
end
function NebulaEmperorEnergyPanel:clickExchangeHandler(buffID)
	self:getCtrl():reqExchangeBuff(buffID)
	SoraDShowLoading(self:displayObject())
end
function NebulaEmperorEnergyPanel:onMsgEnergyDataBack(...)
	SoraDCloseLoading(self:displayObject())
	self:updateComEnergy()
	self:updateBuildList()
	self:updateBuffList()
	if not self.isInit and self:getCtrl():getStartPalaceWar() then
		self.isInit = true
		self.fields.com_Tab:setDefaultClick(2)
	end
end
function NebulaEmperorEnergyPanel:onMsgEnergyExchangeBack(...)
	SoraDCloseLoading(self:displayObject())
	self:updateComEnergy()
	self:updateBuffList()
	self:updateBtnEnergyState()
end
function NebulaEmperorEnergyPanel:updateBuildList(...)
	local _ENV, buildIDList
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		buildIDList = nebulaAllStarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaAllStarWarPalace)
	else
		buildIDList = nebulaEmperorRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace)
	end
	_ENV = nebulaEmperorRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace)
	local nebulaEmperorRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace).buildID, data = buildIDList[1], nebulaEmperorRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace)
	self.fields.Com_build1:initData(data, self.activityID)
	self.buildList, _ENV = self.fields.Com_build1.initData, self.fields.Com_build1.initData
	local _ENV, buildIDList = self.fields.Com_build1.initData, self.fields.Com_build1.initData
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		buildIDList = nebulaAllStarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaAllStarWarTower)
	else
		buildIDList = nebulaEmperorRead.getBuildIDListByType(gWorldTypeServerDef.subTypeNebulaEmperorWarTower)
	end
	for __, buildID in ipairs(buildIDList) do
		_ENV = nil
		;(nil).buildID = buildID
		table.insert(self.buildList, nil)
	end
	self.fields.List_build:setNumItems(#self.buildList)
end
function NebulaEmperorEnergyPanel:updateBuffList(...)
	local buffIDList = self:getRead().getEnergyBuffIDList()
	local _ENV, config = self, self
	for __, buffID in ipairs(buffIDList) do
		local buffTime = self:getCtrl():getEnergyBuffTime(buffID)
		local exchangeCount = self:getCtrl():getEnergyExchangeCount(buffID)
		local cfg = self:getRead().getEnergyBuffConfig(buffID)
		local count = math.max(0, cfg.limitNum - exchangeCount)
		_ENV = 0
		;(0).isActive = 0 < buffTime
		config[buffID], (0).hasCount = 0, 0 < count
	end
	table.sort(buffIDList, function(a, b)
		local dataA = config[a]
		local dataB = config[b]
		if dataA.isActive ~= dataB.isActive then
			return dataA.isActive
		end
		if dataA.hasCount ~= dataB.hasCount then
			return dataA.hasCount
		end
		return a < b
	end)
	self.buffIDList = buffIDList
	self.fields.List_buff:setNumItems(#self.buffIDList)
end
function NebulaEmperorEnergyPanel:updateBtnEnergyState(...)
	local red = self:getCtrl():getEnergyStatusAndNum()
	self.fields.com_Tab:setBtnRedDot(2, red)
end
function NebulaEmperorEnergyPanel:getCtrl(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarCtrl
	else
		return nebulaEmperorCtrl
	end
end
function NebulaEmperorEnergyPanel:getRead(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarRead
	else
		return nebulaEmperorRead
	end
end
return NebulaEmperorEnergyPanel
