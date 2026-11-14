local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_BuildPanel = class("RoaringFlameWar_BuildPanel", baseFguiPanel)
function RoaringFlameWar_BuildPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_BuildPanel.super.ctor(self, ...)
	print("RoaringFlameWar_BuildPanel:ctor", self.viewName)
end
function RoaringFlameWar_BuildPanel:onInit()
	print("=======RoaringFlameWar_BuildPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_reward:setString(i18n("atlantiswar_text_0019"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Button_free:setString(i18n("flames_dunes_text231"))
	self.fields.Button_free:addClickListener(handler(self, self.onClickBtnFree))
	self.fields.Button_free:setVisible(false)
	local _fields = fguiHelper.get_fields(self.fields.Com_single)
	_fields.Text_connect:setString(i18n("flames_dunes_text183"))
	self.fields.List = _fields.List
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	local _fields = fguiHelper.get_fields(self.fields.Com_single2)
	_fields.Text_des1:setString(i18n("flames_dunes_text184"))
	self.fields.Text_des2 = _fields.Text_des2
end
function RoaringFlameWar_BuildPanel:endShow()
	print("=======RoaringFlameWar_BuildPanel:endShow")
	local objId = self.param and self.param.objId
	self.objId = objId
	local data = self.param and self.param.data
	local camp = data.camp
	local buildStr = self:getBuildStr(objId, camp)
	self.fields.Com_title:setString(buildStr)
	self.fields.Com_build:initObjId(objId)
	self.binding = roaringFlameWarRead.getBuildBinding(objId)
	self.fields.List:setNumItems(#self.binding)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local buildDes = roaringFlameWarRead.getBuildDes(subType)
	self.fields.Text_des2:setString(buildDes)
	if self:checkShowBtnFree() then
		self.fields.Button_free:setVisible(true)
	else
		self.fields.Button_free:setVisible(false)
	end
	_ENV = self.fields.Button_free.setVisible
	self.fields.Button_free.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarGate] = 0.5
	self.fields.Button_free.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarGateway] = 0.5
	self.fields.Button_free.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarPalace] = 0.75
	local self.fields.Button_free.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy], config = 0.5, self.fields.Button_free.setVisible
	local scale = config[subType] or 1
	self.fields.Com_build:setScale(scale * 1.04)
	self.fields.Com_build:runAction(ffa.scaleTo(0.2, scale))
end
function RoaringFlameWar_BuildPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).defaultClick = 2
	uiManager:show("RoaringFlameFAQ", nil)
end
function RoaringFlameWar_BuildPanel:onClickBtnReward()
	SoraDPlaySound()
	_ENV = nil
	;(nil).defaultClick = 2
	;(nil).buildLv = roaringFlameWarRead.getBuildLevel(self.objId)
	uiManager:show("RoaringFlameWar_BuildReward", nil)
end
function RoaringFlameWar_BuildPanel:onClickBtnFree()
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.GIVE_UP_BUILDING, true) then
		return
	end
	local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(self.objId, true)
	if not owner then
		SoraDShowMsgTip(i18n("flames_dunes_text214"))
		return
	end
	if not owner.finishOccupy then
		SoraDShowMsgTip(i18n("flames_dunes_text297"))
		return
	end
	local freeCount = roaringFlameWarCtrl:getFreeOccupyCount()
	local freeMax = roaringFlameWarRead.getConstValue("FLAMES_DUNES_ABANDON_CITY_NUM", 10)
	if freeCount >= freeMax then
		_ENV = i18n("flames_dunes_text297")
		i18n("flames_dunes_text297").val = freeCount
		SoraDShowMsgTip(i18n("flames_dunes_text213", i18n("flames_dunes_text297")))
		return
	end
	local remain = freeMax - freeCount
	_ENV = i18n("flames_dunes_text213", i18n("flames_dunes_text297"))
	_ENV = i18n("flames_dunes_text213", i18n("flames_dunes_text297"))
	i18n("flames_dunes_text213", i18n("flames_dunes_text297")).val1 = remain
	i18n("flames_dunes_text213", i18n("flames_dunes_text297")).val2 = freeMax
	i18n("flames_dunes_text213", i18n("flames_dunes_text297")).content = i18n("flames_dunes_text229", i18n("flames_dunes_text213", i18n("flames_dunes_text297")))
	i18n("flames_dunes_text213", i18n("flames_dunes_text297")).cancel = true
	i18n("flames_dunes_text213", i18n("flames_dunes_text297")).confirmFunc = function()
		roaringFlameWarCtrl:reqFreeOccupy(self.objId)
		self:removeFromParent()
	end
	uiManager:show("MessageBox", i18n("flames_dunes_text213", i18n("flames_dunes_text297")))
end
function RoaringFlameWar_BuildPanel:onItemRenderer(index, obj)
	local objId = self.binding[index + 1]
	local data = self.param and self.param.data
	if not data.connect or not data.connect[tostring(objId)] then
		local _ENV, connect = data.connect[tostring(objId)], data.connect[tostring(objId)]
	end
	local camp = connect.camp
	local buildStr = self:getBuildStr(objId, camp)
	obj:setString(buildStr)
	obj:addClickListener(function(...)
		SoraDPlaySound()
		local tilePos = roaringFlameWarRead.getBuildCoord(objId)
		SoraDGotoWorldMapPoint(tilePos, true)
		SoraDRemoveAllPanelFromManager()
	end)
end
function RoaringFlameWar_BuildPanel:getBuildStr(objId, camp)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local level = roaringFlameWarRead.getBuildLevel(objId)
	local buildName = roaringFlameWarRead.getBuildName(subType)
	local buildStr = string.format("Lv.%d %s", level, buildName)
	local tilePos = roaringFlameWarRead.getBuildCoord(objId)
	local posStr = string.format("(%d,%d)", tilePos.x, tilePos.y)
	roaringFlameWarRead = nil
	;(nil).u = true
	buildStr = buildStr .. SoraDWrapHtmlTagByStyle(posStr, nil)
	if camp and 0 < camp then
		local campName = roaringFlameWarRead.getCampName(camp)
		local campStr = string.format("[%s]", campName)
		local campColor = roaringFlameWarRead.getCampColor(camp)
		roaringFlameWarRead = nil
		;(nil).color = campColor
		buildStr = buildStr .. SoraDWrapHtmlTagByStyle(campStr, nil)
	end
	return buildStr
end
function RoaringFlameWar_BuildPanel:checkShowBtnFree()
	if not roaringFlameWarRead.checkBuildCanAbandon(self.objId) then
		return false
	end
	local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(self.objId, true)
	if not owner then
		return false
	end
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.GIVE_UP_BUILDING) then
		return false
	end
	return true
end
return RoaringFlameWar_BuildPanel
