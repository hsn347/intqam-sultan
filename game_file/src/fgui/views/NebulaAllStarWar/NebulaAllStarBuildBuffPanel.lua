local nebulaAllStarRead = include("nebulaAllStarRead")
local buffDesRead = include("buffDesRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarBuildBuffPanel = class("NebulaAllStarBuildBuffPanel", baseFguiPanel)
function NebulaAllStarBuildBuffPanel:ctor(...)
	NebulaAllStarBuildBuffPanel.super.ctor(self, ...)
	print("NebulaAllStarBuildBuffPanel:ctor", self.viewName)
end
function NebulaAllStarBuildBuffPanel:onInit()
	print("=======NebulaAllStarBuildBuffPanel:onInit")
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_136"))
	self.fields.Text_build:setString(i18n("NebulaAllstar_137"))
	self.fields.List_build:setItemRenderer(handler(self, self.onBuildItemRenderer))
	self.fields.Text_buff:setString(i18n("alliance_office_title_05"))
	self.fields.List_buff:setItemRenderer(handler(self, self.onbuffItemRenderer))
	self.fields.Text_noData:setString(i18n("NebulaAllstar_385"))
end
function NebulaAllStarBuildBuffPanel:onShow()
	print("=======NebulaAllStarBuildBuffPanel:onShow")
	SoraDShowLoading(self:displayObject())
	nebulaAllStarCtrl:reqCampBuildingCount()
end
function NebulaAllStarBuildBuffPanel:onBuildItemRenderer(index, obj)
	local cfg = self.buildConfig[index + 1]
	self:updateObj(obj, cfg, index)
end
function NebulaAllStarBuildBuffPanel:onbuffItemRenderer(index, obj)
	local cfg = self.buffConfig[index + 1]
	self:updateObj(obj, cfg, index)
end
function NebulaAllStarBuildBuffPanel:updateObj(obj, cfg, index)
	local c_title = obj:getController("c_title")
	if cfg.isTitle then
		c_title:setSelectedIndex(1)
	else
		c_title:setSelectedIndex(0)
	end
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_name:setString(cfg.name)
	_fields.Text_value:setString(cfg.value)
	_fields.Image_line:setVisible(index % 2 ~= 0)
end
function NebulaAllStarBuildBuffPanel:onMsgUpdateBuildingCount(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	_UPVALUE6_ = self:displayObject()
	_ENV, _ENV, self:displayObject()[1] = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring
	_ENV, _ENV, self:displayObject()[2] = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring
	_ENV, _ENV, self:displayObject()[3] = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarObservation
	_ENV, _ENV, self:displayObject()[4] = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarEngine
	_ENV, _ENV, self:displayObject()[5] = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarCrossbow
	local _ENV, _ENV, self:displayObject()[6], config = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarWorkshop, self:displayObject()
	gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring.name = i18n("NebulaAllstar_138")
	gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring.value = i18n("NebulaAllstar_139")
	self.buildConfig, gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring[1], gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring.isTitle = gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring, gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring, true
	for __, buildType in ipairs(config) do
		_ENV = self:displayObject()
		self:displayObject().name = nebulaAllStarRead.getBuildNameByType(buildType)
		self:displayObject().value = rspdata[tostring(buildType)] or 0
		table.insert(self.buildConfig, self:displayObject())
	end
	self.fields.List_build:setNumItems(#self.buildConfig)
	self.buffConfig, _ENV = self.fields.List_build.setNumItems, self.fields.List_build.setNumItems
	local bandage = 0
	nebulaAllStarCtrl = #self.buildConfig
	;(#self.buildConfig)[1] = gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring
	;(#self.buildConfig)[2] = gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring
	for __, buildType in ipairs(#self.buildConfig) do
		local buildNum = rspdata[tostring(buildType)] or 0
		if 0 < buildNum then
			local count = nebulaAllStarRead.getBuildBandageByType(buildType)
			bandage = bandage + count * buildNum
		end
	end
	if 0 < bandage then
		_ENV = ipairs(#self.buildConfig)
		ipairs(#self.buildConfig).name = i18n("NebulaAllstar_386")
		ipairs(#self.buildConfig).value = string.formatnumberthousands(bandage)
		table.insert(self.buffConfig, ipairs(#self.buildConfig))
	end
	local buffList = nebulaAllStarCtrl:getOccupyBuffList()
	for __, v in ipairs(buffList) do
		_ENV = buildType
		buildType.name = buffDesRead.getTitleBase(v.effect)
		buildType.value = buffDesRead.getTitleValueWithValue(v.effect, v.value)
		table.insert(self.buffConfig, buildType)
	end
	self.fields.List_buff:setNumItems(#self.buffConfig)
	self.fields.Text_noData:setVisible(#self.buffConfig == 0)
end
return NebulaAllStarBuildBuffPanel
