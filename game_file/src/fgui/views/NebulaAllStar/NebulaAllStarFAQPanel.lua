local nebulaAllStarRead = include("nebulaAllStarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarFAQPanel = class("NebulaAllStarFAQPanel", baseFguiPanel)
function NebulaAllStarFAQPanel:ctor(...)
	NebulaAllStarFAQPanel.super.ctor(self, ...)
	print("NebulaAllStarFAQPanel:ctor", self.viewName)
end
function NebulaAllStarFAQPanel:onInit()
	print("=======NebulaAllStarFAQPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_001"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	local FAQType = self.param and self.param.FAQType
	if FAQType == "allStarTeam" then
		self.controllers.c1:setSelectedIndex(0)
		_ENV, _ENV = self.controllers.c1, self.controllers.c1.setSelectedIndex
		self.controllers.c1.TitleKey = "NebulaAllstar_rule_msg1"
		_ENV, self.controllers.c1.setSelectedIndex[1], self.controllers.c1.DesKey = self.controllers.c1, self.controllers.c1, "NebulaAllstar_rule_msg2"
		self.controllers.c1.TitleKey = "NebulaAllstar_rule_msg3"
		self.sonConfig, self.controllers.c1.setSelectedIndex[2], self.controllers.c1.DesKey = self.controllers.c1.setSelectedIndex, self.controllers.c1, "NebulaAllstar_rule_msg4"
		self.fields.List:setNumItems(#self.sonConfig)
		return
	end
	if FAQType == "backupTeam" then
		self.controllers.c1:setSelectedIndex(0)
		_ENV, _ENV = self.controllers.c1, self.controllers.c1.setSelectedIndex
		self.controllers.c1.TitleKey = "NebulaAllstar_rule_msg6"
		_ENV, self.controllers.c1.setSelectedIndex[1], self.controllers.c1.DesKey = self.controllers.c1, self.controllers.c1, "NebulaAllstar_rule_msg7"
		self.controllers.c1.TitleKey = "NebulaAllstar_rule_msg8"
		self.sonConfig, self.controllers.c1.setSelectedIndex[2], self.controllers.c1.DesKey = self.controllers.c1.setSelectedIndex, self.controllers.c1, "NebulaAllstar_rule_msg9"
		self.fields.List:setNumItems(#self.sonConfig)
		return
	end
	self.config = nebulaAllStarRead.getFAQConfig()
	local _ENV, defaultClick = self.fields.List, self.param and self.param.defaultClick or 1
	_ENV, _ENV, self.fields.List.defaultClick = handler(self, self.onItemRenderer)
	_ENV, (#self.sonConfig)[1], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	_ENV, (#self.sonConfig)[2], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	_ENV, (#self.sonConfig)[3], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	self.fields.List.tabsetArray, (#self.sonConfig)[4], handler(self, self.onItemRenderer).title = #self.sonConfig, handler(self, self.onItemRenderer)
	local self.fields.List.callback, param = handler(self, self.onClickTab), self.fields.List
	self.fields.com_Tab:initView(param)
end
function NebulaAllStarFAQPanel:onShow()
	print("=======NebulaAllStarFAQPanel:onShow")
end
function NebulaAllStarFAQPanel:onClickTab(tag)
	print("==NebulaAllStarFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not self.config[self.curSelect] then
		_ENV = self.config[self.curSelect]
	end
	self.curConfig = self.config[self.curSelect]
	local _ENV, ret = self.config[self.curSelect], self.config[self.curSelect]
	local needSonPage = false
	for i, v in ipairs(self.curConfig) do
		if v.SonPage ~= 0 then
			if not ret[v.SonPage] then
				_ENV = ret[v.SonPage]
			end
			ret[v.SonPage] = ret[v.SonPage]
			table.insert(ret[v.SonPage], v)
			needSonPage = true
		end
	end
	if not needSonPage then
		self.controllers.c1:setSelectedIndex(1)
		self.sonConfig = self.curConfig
		self.fields.List:setNumItems(#self.sonConfig)
	else
		self.controllers.c1:setSelectedIndex(2)
		local _ENV, tabsetArray = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
		local _ENV, map = self.controllers.c1, self.controllers.c1
		for i, v in ipairs(self.curConfig) do
			if not map[v.SonPage] then
				map[v.SonPage] = true
				_ENV = nil
				;(nil).title = i18n(v.SonPageKey)
				table.insert(tabsetArray, nil)
			end
		end
		_ENV, self.curConfig = ipairs(self.curConfig)
		ipairs(self.curConfig).defaultClick = 1
		ipairs(self.curConfig).tabsetArray = tabsetArray
		local ipairs(self.curConfig).callback, param = handler(self, self.onClickTab2), ipairs(self.curConfig)
		self.fields.com_Tab2:initView(param)
	end
end
function NebulaAllStarFAQPanel:onClickTab2(tag)
	print("==NebulaAllStarFAQPanel:onClickTab2==", tag)
	self.curSelect2 = tag
	self.sonConfig = self.curConfig[self.curSelect2]
	self.fields.List:setNumItems(#self.sonConfig)
end
function NebulaAllStarFAQPanel:onItemRenderer(index, obj)
	local cfg = self.sonConfig[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local c2 = obj:getController("c2")
	local TitleKey = cfg.TitleKey
	if TitleKey and TitleKey ~= "" then
		c2:setSelectedIndex(0)
		_fields.Com_title:setString(i18n(TitleKey))
	else
		c2:setSelectedIndex(1)
	end
	_fields.Text_des:setString(i18n(cfg.DesKey))
	local c1 = obj:getController("c1")
	if cfg.BuildBg and cfg.BuildBg ~= "" then
		c1:setSelectedIndex(1)
		_fields.Image_bg:setIcon(cfg.BuildBg)
	else
		c1:setSelectedIndex(0)
	end
	self:updateBuildImage(_fields.Image_bg, cfg.BuildingType)
end
function NebulaAllStarFAQPanel:updateBuildImage(obj, buildType)
	local _fields = fguiHelper.get_fields(obj)
	if not buildType or buildType == 0 then
		_fields.Load_build:setVisible(false)
	else
		_fields.Load_build:setVisible(true)
		local buildImage = nebulaAllStarRead.getBuildImageByType(buildType)
		_fields.Load_build:setURL(buildImage)
	end
end
return NebulaAllStarFAQPanel
