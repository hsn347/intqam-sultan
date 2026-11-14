local nebulaEmperorRead = include("nebulaEmperorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorTitleBoxPanel = class("NebulaEmperorTitleBoxPanel", baseFguiPanel)
function NebulaEmperorTitleBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorTitleBoxPanel:ctor", self.viewName)
end
function NebulaEmperorTitleBoxPanel:onInit()
	print("=======NebulaEmperorTitleBoxPanel:onInit")
	local giftID = self.param.giftID
	local cfg = nebulaEmperorRead.getPackageConfig(giftID)
	self.fields.Panel_bg:setString(i18n(cfg.name))
	_ENV = i18n(cfg.name)
	i18n(cfg.name).num = cfg.num
	self.fields.Text_num:setString(i18n("treasure_beach_03", i18n(cfg.name)))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_UPVALUE2_ = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer)[1] = "id"
	handler(self, self.onItemRenderer)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(cfg.rewards, handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(#self.rewards)
end
function NebulaEmperorTitleBoxPanel:onShow()
	print("=======NebulaEmperorTitleBoxPanel:onShow")
end
function NebulaEmperorTitleBoxPanel:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
return NebulaEmperorTitleBoxPanel
