local nebulaEmperorUtil = include("nebulaEmperorUtil")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorPlayerResultPanel = class("NebulaEmperorPlayerResultPanel", baseFguiPanel)
function NebulaEmperorPlayerResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorPlayerResultPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaEmperorPlayerResultPanel:onInit()
	print("=======NebulaEmperorPlayerResultPanel:onInit")
	if not self.param or not self.param.notifyData then
		_ENV = self.param.notifyData
	end
	self.notifyData = self.param.notifyData
	local regionId = self.notifyData.area
	local teamName = nebulaEmperorUtil.getTeamNameRaw(regionId)
	local areaIcon = nebulaEmperorUtil.getAreaIcon(regionId)
	self.fields.Com_area:setString(teamName)
	self.fields.Com_area:setIcon(areaIcon)
	local _fields = fguiHelper.get_fields(self.fields.Com_player)
	_fields.icon:setURL(lordLocalData.getPortrait(self.notifyData.leaderIconID))
	_fields.Text_name:setString(self.notifyData.leaderName)
	_fields.Text_team:setString(teamName)
	local areaName = nebulaEmperorUtil.getAreaName(regionId)
	_ENV = lordLocalData.getPortrait(self.notifyData.leaderIconID)
	lordLocalData.getPortrait(self.notifyData.leaderIconID).area = areaName
	_ENV, _ENV, lordLocalData.getPortrait(self.notifyData.leaderIconID).time = self.notifyData.time, SoraDConvertSecondToString(self.notifyData.time), SoraDConvertSecondToString(self.notifyData.time)
	_ENV, SoraDConvertSecondToString(self.notifyData.time).area, self.notifyData.time.color = self.notifyData.time, self.notifyData.time, "#FFD43E"
	SoraDConvertSecondToString(self.notifyData.time).time, self.notifyData.time.color = self.notifyData.time, "#FFD43E"
	local desStr = i18n_html("nebulaemperor_text_152", lordLocalData.getPortrait(self.notifyData.leaderIconID))
	self.fields.Label_tip:setString(desStr)
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
	if not SoraDFIsRA() then
		self.fields.Com_area:fixChildrenPos()
	end
end
function NebulaEmperorPlayerResultPanel:onShow()
	print("=======NebulaEmperorPlayerResultPanel:onShow")
end
function NebulaEmperorPlayerResultPanel:initTestData(...)
	_UPVALUE0_ = nil
	;(nil).area = 1
	;(nil).leaderIconID = 1505
	;(nil).leaderName = "zw1"
	self.notifyData, (nil).time = nil, 9999
end
return NebulaEmperorPlayerResultPanel
