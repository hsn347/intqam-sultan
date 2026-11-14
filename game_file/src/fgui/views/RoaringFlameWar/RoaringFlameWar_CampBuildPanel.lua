local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_CampBuildPanel = class("RoaringFlameWar_CampBuildPanel", baseFguiPanel)
function RoaringFlameWar_CampBuildPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_CampBuildPanel.super.ctor(self, ...)
	print("RoaringFlameWar_CampBuildPanel:ctor", self.viewName)
	_UPVALUE9_ = print
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[1] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarPalace
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[2] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarFort
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[3] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarWoods
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[4] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarMine
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[5] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[6] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarRuins
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[7] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarStation
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[8] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarGate
	self.subTypeMap, RoaringFlameWar_CampBuildPanel, self.subTypeList, print[9] = print, print, print, gWorldTypeServerDef.subTypeRoaringFlameWarGateway
end
function RoaringFlameWar_CampBuildPanel:onInit()
	print("=======RoaringFlameWar_CampBuildPanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text94"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_log = self.fields.Mod_Bottom:getChild("Button_add")
	self.fields.Button_log:setString(i18n("common_text_836"))
	self.fields.Button_log:addClickListener(handler(self, self.onClickBtnLog))
end
function RoaringFlameWar_CampBuildPanel:endShow()
	print("=======RoaringFlameWar_CampBuildPanel:endShow")
	local endTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.FINISH)
	local timeStr = os.date("!%Y-%m-%d", endTime)
	_ENV = nil
	;(nil).time = timeStr
	self.fields.Text_time:setString(i18n("brightWar_text_32", nil))
	roaringFlameWarCtrl:reqCampOccupyList()
end
function RoaringFlameWar_CampBuildPanel:onClickBtnLog(...)
	SoraDPlaySound()
	uiManager:show("RoaringFlameWar_BuildLog")
end
function RoaringFlameWar_CampBuildPanel:onItemRenderer(index, obj)
	local subType = self.subTypeList[index + 1]
	if not self.subTypeMap[subType] then
		local _UPVALUE0_, objIdList = self.subTypeMap[subType], self.subTypeMap[subType]
	end
	obj:initData(subType, objIdList)
end
function RoaringFlameWar_CampBuildPanel:onMsgUpdateBuildList(target, event)
	if not event.rspdata then
		local _ENV, occupyList = event.rspdata, event.rspdata
	end
	local _ENV, ret
	for __, objId in ipairs(occupyList) do
		local subType = roaringFlameWarRead.getBuildSubType(objId)
		if not ret[subType] then
			_ENV = ret[subType]
		end
		ret[subType] = ret[subType]
		table.insert(ret[subType], objId)
	end
	self.subTypeMap = ret
	self.fields.List:setNumItems(#self.subTypeList)
end
return RoaringFlameWar_CampBuildPanel
