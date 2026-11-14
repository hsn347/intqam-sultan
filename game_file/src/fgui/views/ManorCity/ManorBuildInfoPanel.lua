local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorBuildInfoPanel = class("ManorBuildInfoPanel", baseFguiPanel)
function ManorBuildInfoPanel:ctor(...)
	self.isLRU = true
	ManorBuildInfoPanel.super.ctor(self, ...)
	print("ManorBuildInfoPanel:ctor", self.viewName)
end
function ManorBuildInfoPanel:onInit()
	print("=======ManorBuildInfoPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_moreInfo:setString(i18n("common_text_376"))
	self.fields.Button_moreInfo:addClickListener(handler(self, self.onClickBtnMoreInfo))
	self.fields.Label_title:setString(i18n("common_text_059"))
end
function ManorBuildInfoPanel:endShow()
	print("=======ManorBuildInfoPanel:endShow")
	self.buildID = self.param.buildID
	self.realId = self.param.realId
	self.extra = self.param.extra
	self:initPublicInfo()
	local buildType = manorCityRead.getBuildType(self.buildID)
	if buildType == MANOR_BUILD_TYPE.BUILD then
		self.controllers.viewType:setSelectedIndex(0)
		self:initBuildInfo()
	else
		self.controllers.viewType:setSelectedIndex(1)
	end
end
function ManorBuildInfoPanel:initPublicInfo()
	local buildName = manorCityRead.getBuildName(self.buildID, self.extra)
	self.fields.Panel_bg:setString(buildName)
	self.fields.Panel_bg2:setString(buildName)
	local buildImage = manorCityRead.getBuildSmallImage(self.buildID, self.extra)
	self.fields.Image_build:setURL(buildImage)
	local buildDes = manorCityRead.getBuildDes(self.buildID, self.extra)
	self.fields.Text_des:setString(buildDes)
end
function ManorBuildInfoPanel:initBuildInfo()
	local buildLv = manorCityCtrl:getBuildLv(self.realId)
	manorCityCtrl = nil
	;(nil).lv = buildLv
	self.fields.Text_lv:setString(i18n("common_text_100", nil))
	self.buildInfo = manorCityUtil.getBuildInfo(self.buildID, buildLv)
	dump(self.buildInfo, "==self.buildInfo==")
	self.fields.List:setNumItems(#self.buildInfo)
	local showList = #self.buildInfo > 0
	self.fields.Label_title:setVisible(showList)
end
function ManorBuildInfoPanel:onItemRenderer(index, obj)
	local data = self.buildInfo[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Image_icon:setURL("icon_building_research.png")
	_fields.Text_des:setString(data.title)
	_fields.Text_value:setString(data.value)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function ManorBuildInfoPanel:onClickBtnMoreInfo(context)
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.bid = self.buildID
	SoraDPlaySound.blv = manorCityCtrl:getBuildLv(self.realId)
	local SoraDPlaySound.extra, manorInfo = self.extra, SoraDPlaySound
	_ENV = nil
	;(nil).manorInfo = manorInfo
	uiManager:show("BuildMoreInfo", nil)
end
return ManorBuildInfoPanel
