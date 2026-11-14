local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local legendKingRead = include("legendKingRead")
local GROUP_ID = 100
local GROUP_WAR = 101
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaRegionPanel = class("NebulaRegionPanel", baseFguiPanel)
function NebulaRegionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaRegionPanel:ctor", self.viewName)
	self.kingStarObjList, _ENV = print, print
end
function NebulaRegionPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaRegionPanel:close(...)
	_ENV = nil
	;(nil).handler = function()
		self:closePanel()
	end
	uiManager:show("NebulaRegionSwitch", nil)
end
function NebulaRegionPanel:onInit()
	print("=======NebulaRegionPanel:onInit")
	self.fields.Button_return:fixPos()
	self.fields.Button_return:addClickListener(handler(self, self.onClickClose))
	_ENV = handler(self, self.onClickClose)
	handler(self, self.onClickClose).scroll = self.fields.Com_map
	handler(self, self.onClickClose).innerSize = cc.size(1707, 2272)
	handler(self, self.onClickClose).minScale = 0.62
	handler(self, self.onClickClose).maxScale = 1.0
	handler(self, self.onClickClose).zoomScale = 0.7
	handler(self, self.onClickClose).afterInitScroll = handler(self, self.afterInitScroll)
	self.fields.scroll_zoom:initData(handler(self, self.onClickClose))
	local nebulaEmperorUtil = include("nebulaEmperorUtil")
	local showGlory = nebulaEmperorCtrl:getGlorySeasonMax() > 0 and not nebulaEmperorUtil.isWarTest()
	self.fields.Button_glory:setVisible(showGlory)
	if showGlory then
		self.fields.Button_glory:setString(i18n("nebulaemperor_text_20"))
		self.fields.Button_glory:addClickListener(handler(self, self.onClickBtnGlory))
		self.fields.Button_glory:fixPos()
	end
	self.fieldsMap = fguiHelper.get_fields(self.fields.Com_map)
	self.fieldsMap.Com_legendLord:setString(i18n("common_text_4244"))
	self.fieldsMap.Com_kingStar:setString(i18n("kingstarbattle_text_20"))
	self.fieldsMap.Com_region_gjq:setString(i18n("nebula_war_text_0138"))
	self.fieldsMap.Com_region_bzq:setString(i18n("nebula_war_text_0139"))
	self.fieldsMap.Com_legendLord:addClickListener(handler(self, self.onClickBtnBattlefield))
	self.fieldsMap.Com_kingStar:addClickListener(handler(self, self.onClickBtnBattlefield))
	self.fieldsMap.Com_region_gjq:addClickListener(handler(self, self.onClickBtnRegion))
	self.fieldsMap.Com_region_bzq:addClickListener(handler(self, self.onClickBtnRegion))
	self.fieldsMap.Com_kingStar:setVisible(IsArClient)
	_ENV = self.fieldsMap.Com_kingStar.setVisible
	self.fieldsMap.Com_kingStar.setVisible[worldMapDefine.LEGENDLORD_KINGDOM_ID] = self.fieldsMap.Com_legendLord
	local self.fieldsMap.Com_kingStar.setVisible[worldMapDefine.KINGSTAR_KINGDOM_ID], config = self.fieldsMap.Com_kingStar, self.fieldsMap.Com_kingStar.setVisible
	for mapid, obj in pairs(config) do
		local imageName = legendKingRead.getImage(gLegendBuildID, mapid)
		obj:setIcon(imageName)
	end
	self:initGroupNode()
	local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
	for regionId = 1, 10 do
		local Com_region = self.fieldsMap["Com_region_" .. regionId]
		local title = Com_region:getChild("title")
		title:setGroupAuto(true)
		title:setGroupID(GROUP_ID)
		if hegemonyRegion[regionId] then
			Com_region:setTag(regionId)
			Com_region:setString(nebulaWarRead.getAreaName(regionId))
			Com_region:addClickListener(handler(self, self.onClickBtnRegion))
			local cfg = nebulaWarRead.getExtraAreaCfg(regionId)
			if cfg then
				local obj = fgui.UIPackage:createObject("NebulaRegion", "Com_legendLord")
				obj:addTo(self.fields.Com_map)
				obj:setAnchorPoint(0.5, 0)
				local pos = Com_region:getPosition()
				local size = Com_region:getContentSize()
				title:setPositionY(title:getPositionY() + 70)
				obj:setPosition(cc.p(pos.x + size.width / 2, pos.y + title:getPositionY() + 2))
				obj:addClickListener(handler(self, self.onClickBtnBattlefield))
				_ENV = handler(self, self.onClickBtnBattlefield)
				handler(self, self.onClickBtnBattlefield).ranklist = i18n(cfg.rankname)
				obj:setTitle(i18n("king_star_rank_text2", handler(self, self.onClickBtnBattlefield)))
				local mapid = worldMapDefine.getKingStarMapid(cfg.servertype)
				local imageName = legendKingRead.getImage(gLegendBuildID, mapid)
				obj:setIcon(imageName)
				obj:setGroupAuto(true)
				obj:setGroupID(GROUP_WAR)
				self.kingStarObjList[regionId] = obj
			end
		else
			Com_region:setVisible(false)
		end
	end
	local __, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local obj = self:getComRegionById(regionId)
	local Image_own = self.fieldsMap.Image_own
	local posX = obj:getX() + obj:getWidth() / 2 - Image_own:getWidth() / 2
	local posY = obj:getY() + obj:getHeight() / 2 - Image_own:getHeight() - 34
	Image_own:setPosition(cc.p(posX, posY))
end
function NebulaRegionPanel:onShow()
	print("=======NebulaRegionPanel:onShow")
	self:updateKingStar()
	self:updateLegendLord()
	nebulaEmperorCtrl:reqAllTitleInfo()
	local kingStarCtrl = SoraDGetCtrl("kingStarCtrl")
	_UPVALUE3_ = "kingStarCtrl"
	;("kingStarCtrl")[1] = gActivityTimeActivityID.KING_STAR_BATTLE
	;("kingStarCtrl")[2] = gActivityTimeActivityID.LEGEND_LORD_9001646
	local ("kingStarCtrl")[3], activityIDList = gActivityTimeActivityID.LEGEND_LORD_9001647, "kingStarCtrl"
	kingStarCtrl:reqLegendKingInfo(activityIDList)
	local legendLordCtrl = SoraDGetCtrl("legendLordCtrl")
	legendLordCtrl:reqLegendKingInfo()
end
function NebulaRegionPanel:onHide()
	print("=======NebulaRegionPanel:onHide")
end
function NebulaRegionPanel:onClickBtnBattlefield(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender.isHeadClicked then
		return
	end
	local activityID = sender:getActivityID()
	local mapid = worldMapDefine.getKingStarMapid(activityID)
	print("==onClickBtnBattlefield==", sender, activityID, mapid)
	if activityID == gActivityTimeActivityID.LEGEND_LORD_9001646 or activityID == gActivityTimeActivityID.LEGEND_LORD_9001647 then
		local legendKingInfo = SoraDGetCtrl("kingStarCtrl"):getLegendKingInfo(activityID)
		if legendKingInfo.forbidEnter then
			SoraDShowMsgTip(i18n("king_star_rank_text15"))
			return
		end
	end
	SorDCloseWordResourceMap()
	SoraDRemoveAllPanelFromManager()
	SoraDGotoWorldMapPoint(cc.p(150, 150), false, mapid)
end
function NebulaRegionPanel:onClickBtnRegion(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	local regionId = 0
	if sender == self.fieldsMap.Com_region_gjq then
		regionId = 102
	elseif sender == self.fieldsMap.Com_region_bzq then
		regionId = 101
	else
		regionId = sender:getTag()
	end
	local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
	if regionType ~= NEBULA_REGION_TYPE.HEGEMONY_REGION and not self:checkNeedShowBigWorld(regionId) then
		return
	end
	_ENV = nil
	;(nil).handler = function()
		if tolua.isnull(self) then
			return
		end
		self:showBigWorldView(regionId)
	end
	uiManager:show("NebulaRegionSwitch", nil)
end
function NebulaRegionPanel:checkNeedShowBigWorld(regionId)
	local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
	local realKingdomList = nebulaWarUtil.getBigWorldKingdomList(regionType, regionId)
	if #realKingdomList == 0 then
		SoraDShowMsgTip(i18n("nebula_war_text_0240"))
		return false
	end
	return true
end
function NebulaRegionPanel:showBigWorldView(regionId)
	local panel = SoraDSearchPanelFromManagerByName("bigWorldView")
	if panel then
		panel:removeFromParent()
	end
	self:closePanel()
	local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
	_ENV = nil
	;(nil).regionType = regionType
	;(nil).regionId = regionId
	uiManager:show("BigWorldView", nil)
end
function NebulaRegionPanel:afterInitScroll(...)
	local param = self.proxy.param
	local legendLord = param.legendLord
	local kingStar = param.kingStar
	local regionId = param.regionId
	local obj = self.fieldsMap.Com_legendLord
	if legendLord then
		obj = self.fieldsMap.Com_legendLord
	elseif kingStar then
		obj = self.fieldsMap.Com_kingStar
	else
		obj = self:getComRegionById(regionId)
	end
	self:scrollToCenter(obj, false)
end
function NebulaRegionPanel:scrollToCenter(obj, ani)
	local scale = self.fields.scroll_zoom:getZoomScale()
	local scrollPane = self.fields.Com_map:getScrollPane()
	local objW = obj:getContentSize().width
	local posX = (obj:getX() + objW / 2) * scale - display.cx
	scrollPane:setPosX(posX, ani)
	local objH = obj:getContentSize().height
	local posY = (obj:getY() + objH / 2) * scale - display.cy
	scrollPane:setPosY(posY, ani)
end
function NebulaRegionPanel:getComRegionById(regionId)
	if regionId == 101 then
		return self.fieldsMap.Com_region_bzq
	elseif regionId == 102 then
		return self.fieldsMap.Com_region_gjq
	else
		return self.fieldsMap["Com_region_" .. regionId]
	end
end
function NebulaRegionPanel:updateKingStar()
	self.fieldsMap.Com_kingStar:updateView()
	for regionId, obj in pairs(self.kingStarObjList) do
		local cfg = nebulaWarRead.getExtraAreaCfg(regionId)
		if cfg then
			obj:updateView(cfg.servertype)
		end
	end
end
function NebulaRegionPanel:updateLegendLord()
	self.fieldsMap.Com_legendLord:updateView()
end
function NebulaRegionPanel:onClickBtnGlory(...)
	SoraDPlaySound()
	uiManager:show("NebulaEmperorGlory")
end
function NebulaRegionPanel:onMsgReqAllTitleBack(target, event)
	local rspdata = event.rspdata
	local regionTitle = rspdata.regionTitle
	for k, regionId in pairs(regionTitle) do
		local titleID = tonumber(k)
		local obj = self:getComRegionById(regionId)
		obj:updateRegionTitle(titleID)
	end
end
function NebulaRegionPanel:initGroupNode(...)
	local node = self.fieldsMap["GROUP" .. GROUP_ID]:displayObject()
	node:setGroupID(GROUP_ID, true)
	local nodeWar = self.fieldsMap["GROUP" .. GROUP_WAR]:displayObject()
	nodeWar:setGroupID(GROUP_WAR, true)
end
return NebulaRegionPanel
