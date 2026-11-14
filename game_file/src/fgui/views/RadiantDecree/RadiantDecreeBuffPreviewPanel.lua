local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeBuffPreviewPanel = class("RadiantDecreeBuffPreviewPanel", baseFguiPanel)
function RadiantDecreeBuffPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantDecreeBuffPreviewPanel:ctor", self.viewName)
end
function RadiantDecreeBuffPreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RadiantDecreeBuffPreviewPanel:onInit()
	print("=======RadiantDecreeBuffPreviewPanel:onInit")
	_ENV = print
	_ENV, _ENV, print.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("GloriousDecree_29")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("GloriousDecree_30")
	print.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	local print.callback, param = handler(self, self.onClickTab), print
	self.fields.Com_Tab:initView(param)
	self.fields.Text_Tips:setString(i18n("GloriousDecree_42"))
end
function RadiantDecreeBuffPreviewPanel:onClickTab(tag)
	self.tag = tag
	self.fields.Com_buff:initData(tag)
end
function RadiantDecreeBuffPreviewPanel:onShow()
	print("=======RadiantDecreeBuffPreviewPanel:onShow")
	self.fields.panel_normal:setTitle(self.proxy.param.title)
	if self.proxy.param.isStatue then
		self.fields.Com_Tab:setDefaultClick(2, 2)
	end
end
return RadiantDecreeBuffPreviewPanel
