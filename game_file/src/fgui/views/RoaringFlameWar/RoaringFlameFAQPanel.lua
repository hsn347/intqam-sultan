local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameFAQPanel = class("RoaringFlameFAQPanel", baseFguiPanel)
function RoaringFlameFAQPanel:ctor(...)
	self.isLRU = true
	RoaringFlameFAQPanel.super.ctor(self, ...)
	print("RoaringFlameFAQPanel:ctor", self.viewName)
	self.config = roaringFlameWarRead.getFAQConfig()
end
function RoaringFlameFAQPanel:onInit()
	print("=======RoaringFlameFAQPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_001"), handler(self, self.onClickClose))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	local _ENV, defaultClick = self.fields.List, self.param and self.param.defaultClick or 1
	_ENV, _ENV, self.fields.List.defaultClick = handler(self, self.onItemRenderer)
	_ENV, handler(self, self.onItemRenderer)[1], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	_ENV, handler(self, self.onItemRenderer)[2], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	_ENV, handler(self, self.onItemRenderer)[3], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	self.fields.List.tabsetArray, handler(self, self.onItemRenderer)[4], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	local self.fields.List.callback, param = handler(self, self.onClickTab), self.fields.List
	self.fields.com_Tab:initView(param)
end
function RoaringFlameFAQPanel:endShow()
	print("=======RoaringFlameFAQPanel:endShow")
end
_ENV, RoaringFlameFAQPanel.onClickTab = function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end, function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end
;(function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end)[1] = "ui://RoaringFlameWar/Com_FAQtitle"
;(function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end)[2] = "ui://RoaringFlameWar/Com_FAQtext"
;(function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end)[3] = "ui://RoaringFlameWar/Com_FAQbuild"
;(function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end)[4] = "ui://RoaringFlameWar/Com_FAQtype2"
local (function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end)[5], itemType2url = "ui://RoaringFlameWar/Com_FAQtype1", function(self, tag)
	print("==RoaringFlameFAQPanel:onClickTab==", tag)
	self.curSelect = tag
	if not clone(self.config[self.curSelect]) then
		_ENV = clone(self.config[self.curSelect])
	end
	self.curConfig = clone(self.config[self.curSelect])
	if self.curSelect == 2 then
		_ENV = self.curSelect
		self.curSelect.type = 4
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(2)
		table.insert(self.curConfig, self.curSelect)
	elseif self.curSelect == 3 then
		_ENV = self.curSelect
		self.curSelect.type = 5
		self.curSelect.cfg = roaringFlameWarRead.getFAQPointConfig(1)
		table.insert(self.curConfig, self.curSelect)
	end
	self.fields.List:setNumItems(#self.curConfig)
	self.fields.List:jumpToTop()
end
function RoaringFlameFAQPanel:onItemProvider(index)
	local cfg = self.curConfig[index + 1]
	local itemType = cfg.type
	return itemType2url[itemType]
end
function RoaringFlameFAQPanel:onItemRenderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local cfg = self.curConfig[index + 1]
	self.cfg, _ENV = index + 1, index + 1
	local itemType = cfg.type
	if itemType == 1 or itemType == 2 then
		obj:setString(i18n(cfg.des_key))
	elseif itemType == 3 then
		obj:fixChildrenPos()
		local subType = cfg.build_type
		local buildImage = roaringFlameWarRead.getBuildImage(subType)
		_fields.Load_build:setURL(buildImage)
		local buildName = roaringFlameWarRead.getBuildName(subType)
		_fields.Text_build:setString(buildName)
		local buildDes = roaringFlameWarRead.getBuildDes(subType)
		_fields.Text_des:setString(buildDes)
	elseif itemType == 4 then
		obj:fixChildrenPos()
		_fields.Text_build:setString(i18n("mail_2_text_51"))
		_fields.Text_first:setString(i18n("flames_dunes_text346"))
		_fields.Text_score:setString(i18n("flames_dunes_text347"))
		_fields.List:setItemRenderer(handler(self, self.onSingle2Renderer))
		self.cfg = cfg.cfg
		_fields.List:setNumItems(#self.cfg)
		_fields.List:setHeight(#self.cfg * 40)
	elseif itemType == 5 then
		obj:fixChildrenPos()
		_fields.Text_build:setString(i18n("recharge_label_003"))
		_fields.Text_score:setString(i18n("atlantiswar_text_0129"))
		_fields.List:setItemRenderer(handler(self, self.onSingle1Renderer))
		self.cfg = cfg.cfg
		_fields.List:setNumItems(#self.cfg)
		_fields.List:setHeight(#self.cfg * 40)
	end
end
function RoaringFlameFAQPanel:onSingle1Renderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	obj:fixChildrenPos()
	local armyLv = self.cfg[index + 1].part[1]
	local score = self.cfg[index + 1].point[1]
	local armyCount = self.cfg[index + 1].point[2] or 1
	_ENV = nil
	;(nil).count = armyCount
	;(nil).lv = armyLv
	_fields.Text_build:setString(i18n("flames_dunes_text348", nil))
	_fields.Text_score:setString(string.formatnumberthousands(score))
	_fields.bg:setVisible(index % 2 == 0)
end
function RoaringFlameFAQPanel:onSingle2Renderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	obj:fixChildrenPos()
	local buildType = self.cfg[index + 1].part[1]
	local buildLv = self.cfg[index + 1].part[2]
	local firstPoint = self.cfg[index + 1].point[1]
	local score = self.cfg[index + 1].point[2]
	_ENV = nil
	;(nil).lv = buildLv
	;(nil).name = roaringFlameWarRead.getBuildName(buildType)
	_fields.Text_build:setString(i18n("common_text_134", nil))
	_fields.Text_first:setString(string.formatnumberthousands(firstPoint))
	_fields.Text_score:setString(score and string.formatnumberthousands(score) or "")
	_fields.bg:setVisible(index % 2 == 0)
end
return RoaringFlameFAQPanel
