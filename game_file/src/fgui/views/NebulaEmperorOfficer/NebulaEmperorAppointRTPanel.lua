local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorAppointRTPanel = class("NebulaEmperorAppointRTPanel", baseFguiPanel)
function NebulaEmperorAppointRTPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorAppointRTPanel:ctor", self.viewName)
end
function NebulaEmperorAppointRTPanel:onInit()
	print("=======NebulaEmperorAppointRTPanel:onInit")
	self.officialID = self.param.officialID
	local officerName = nebulaEmperorRead.getOfficerName(self.officialID)
	self.fields.Panel_bg:setString(officerName)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function NebulaEmperorAppointRTPanel:onShow()
	print("=======NebulaEmperorAppointRTPanel:onShow")
	self.limitListMap, _ENV = print, print
	if not self.param.limitList then
		_ENV = self.param.limitList
	end
	for __, regionId in pairs(self.param.limitList) do
		self.limitListMap[regionId] = true
	end
	local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
	self.regionList = table.ikeys(hegemonyRegion)
	self.fields.List:setNumItems(#self.regionList)
end
function NebulaEmperorAppointRTPanel:onItemRederer(index, obj)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local _fields = fguiHelper.get_fields(obj)
	local c1 = obj:getController("c1")
	local regionId = self.regionList[index + 1]
	local areaName = nebulaWarRead.getAreaName(regionId)
	_fields.Text_name:setString(areaName)
	_fields.Text_appoint:setString(i18n("nebulaemperor_text_239"))
	_fields.Button_appoint:setString(i18n("common_text_687"))
	_fields.Button_appoint:addClickListener(handler(self, self.onClickBtnAppoint))
	_fields.Button_appoint:setTag(regionId)
	if self.limitListMap[regionId] then
		c1:setSelectedIndex(1)
	else
		c1:setSelectedIndex(0)
	end
end
function NebulaEmperorAppointRTPanel:onClickBtnAppoint(EventContext)
	SoraDPlaySound()
	local regionId = EventContext:getSender():getTag()
	if self.limitListMap[regionId] then
		SoraDShowMsgTip(i18n("nebulaemperor_text_28"))
		return
	end
	local areaName = nebulaWarRead.getAreaName(regionId)
	local officerName = nebulaEmperorRead.getOfficerName(self.officialID)
	_ENV = i18n("nebulaemperor_text_28")
	i18n("nebulaemperor_text_28").king = areaName
	i18n("nebulaemperor_text_28").official = officerName
	local showMsg = i18n("nebulaemperor_text_29", i18n("nebulaemperor_text_28"))
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			nebulaEmperorCtrl:reqAppointRegionTitle(regionId, self.officialID)
			SoraDShowLoading(self:displayObject())
		end
	end)
end
return NebulaEmperorAppointRTPanel
