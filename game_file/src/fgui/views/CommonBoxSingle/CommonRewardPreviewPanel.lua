local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonRewardPreviewPanel = class("CommonRewardPreviewPanel", baseFguiPanel)
function CommonRewardPreviewPanel:ctor(...)
	CommonRewardPreviewPanel.super.ctor(self, ...)
	print("CommonRewardPreviewPanel:ctor", self.viewName)
end
function CommonRewardPreviewPanel:onInit()
	print("=======CommonRewardPreviewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function CommonRewardPreviewPanel:onShow()
	print("=======CommonRewardPreviewPanel:onShow")
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	if not param.rewards then
		_ENV = param.rewards
	end
	self.awardList = param.rewards
	local desc = param.desc
	self.controllers.c1:setSelectedIndex(desc == nil and 0 or 1)
	if desc then
		self.fields.txt_desc:setString(desc)
	end
	self.fields.List:setNumItems(#self.awardList)
end
function CommonRewardPreviewPanel:onItemRenderer(index, obj)
	local data = self.awardList[index + 1]
	obj:initData(data.id, data.count)
end
return CommonRewardPreviewPanel
