local worldMapDefine = include("worldMapDefine")
local mapResExplainRead = include("mapResExplainRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapExplainPanel = class("WorldMapExplainPanel", baseFguiPanel)
function WorldMapExplainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapExplainPanel:ctor", self.viewName)
end
function WorldMapExplainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function WorldMapExplainPanel:onInit()
	print("=======WorldMapExplainPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function WorldMapExplainPanel:onShow()
	print("=======WorldMapExplainPanel:onShow")
	self:initData(self.proxy.param.instanceType, self.proxy.param.classId, self.proxy.param.title)
	if self.proxy.param.jumpIndex then
		self:jumpIndexToView(self.proxy.param.jumpIndex)
	end
end
function WorldMapExplainPanel:initData(instanceType, classId, title)
	self.instanceType = instanceType
	local titleName
	if classId == nil then
		classId = 0
	end
	self.classId = classId
	if title then
		titleName = title
		self.fields.Panel_bg:setString(titleName)
	else
		if instanceType == gMapObjTypeDef.mapObjTypeRelics then
			titleName = i18n("res_name_yiji")
		elseif instanceType == gMapObjTypeDef.mapObjTypeResource then
			titleName = worldMapDefine.getResourceName(classId)
		elseif instanceType == gMapObjTypeDef.mapObjTypeEscort then
			titleName = i18n("mail_text_228")
		elseif instanceType == gMapObjTypeDef.mapTypeFireTreasure then
			titleName = i18n("treasuremap_text_23")
		elseif instanceType == gMapObjTypeDef.mapTypeRadianceWarResource then
			local radianceWarRead = include("radianceWarRead")
			titleName = radianceWarRead.getResourceName(classId)
		elseif instanceType == gMapObjTypeDef.roaringFlameWarBuilding then
			local roaringFlameWarRead = include("roaringFlameWarRead")
			titleName = roaringFlameWarRead.getBuildName(classId)
		elseif instanceType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
			local pyramidBuildingRead = include("pyramidBuildingRead")
			titleName = pyramidBuildingRead.getName(classId)
		else
			titleName = worldMapDefine.getResourceName(classId)
		end
		_ENV = nil
		;(nil).resName = titleName
		self.fields.Panel_bg:setString(i18n("common_text_630", nil))
	end
	self.tableExplain, _ENV = self.fields.Panel_bg.setString, self.fields.Panel_bg.setString
	print("WorldMapExplainView:initData", instanceType, classId)
	if instanceType == gMapObjTypeDef.mapObjTypeResource then
		self.tableExplain = mapResExplainRead.getResList(instanceType, worldMapDefine.getResourceTpyeID(classId))
	elseif instanceType == gMapObjTypeDef.mapTypeRadianceWarResource then
		self.tableExplain = mapResExplainRead.getResList(instanceType, 102)
	else
		self.tableExplain = mapResExplainRead.getResList(instanceType, classId)
	end
	if #self.tableExplain == 1 then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.List:setNumItems(#self.tableExplain)
end
function WorldMapExplainPanel:onItemRederer(index, target)
	target:initData(self.tableExplain[index + 1], self.instanceType, self.classId)
end
function WorldMapExplainPanel:jumpIndexToView(index)
	self.fields.List:scrollToView(index - 1)
end
return WorldMapExplainPanel
