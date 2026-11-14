local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_BuildsPanel = class("Activity_9001573_BuildsPanel", baseFguiPanel)
local activity_9001573_Read = include("activity_9001573_Read")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
function Activity_9001573_BuildsPanel:ctor(...)
	Activity_9001573_BuildsPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001573_BuildsPanel:ctor", self.viewName)
end
function Activity_9001573_BuildsPanel:onInit()
	print("=======Activity_9001573_BuildsPanel:onInit")
	self.fields.Com_title:initData(i18n("Celestial_defense_build_001"), handler(self, self.onClickClose))
	self.fields.txt_des:setString(i18n("Celestial_defense_text_046"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	activity_9001573_Ctrl:sendReqInitDataMsg()
end
function Activity_9001573_BuildsPanel:onShow()
	print("=======Activity_9001573_BuildsPanel:onShow")
	SoraDShowLoading(self.view:displayObject())
end
function Activity_9001573_BuildsPanel:initData()
	SoraDCloseLoading(self.view:displayObject())
	local powerRatio = activity_9001573_Ctrl:getPowerRatio()
	_ENV = self.view:displayObject()
	self.view:displayObject().lv = powerRatio
	self.fields.txt_title:setTitle(i18n("Celestial_defense_text_047", self.view:displayObject()))
	local mapBuildsData = activity_9001573_Ctrl:getMapBuildsData()
	self.buildDatas, _ENV = activity_9001573_Ctrl, activity_9001573_Ctrl
	for k, v in pairs(mapBuildsData) do
		local _ENV, data = i18n("Celestial_defense_text_047", self.view:displayObject())
		data.cfg = v.buildID and activity_9001573_Read.getBuild(v.buildID) or activity_9001573_Read.getGateCfg()
		data.data = v
		table.insert(self.buildDatas, data)
	end
	self.fields.list:setNumItems(#self.buildDatas)
end
function Activity_9001573_BuildsPanel:onItemRenderer(index, obj)
	obj:initData(self.buildDatas[index + 1])
end
return Activity_9001573_BuildsPanel
