local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanLetterMainPanel = class("RamadanLetterMainPanel", baseFguiPanel)
local ramadanLetterRead = include("ramadanLetterRead")
local ramadanLetterCtrl = SoraDGetCtrl("ramadanLetterCtrl")
function RamadanLetterMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("RamadanLetterMainPanel:ctor", self.viewName)
end
function RamadanLetterMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanLetterMainPanel:onInit()
	print("=======RamadanLetterMainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001415"), handler(self, self.onClickClose))
	ramadanLetterCtrl:sendDataMsg()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function RamadanLetterMainPanel:onShow()
	print("=======RamadanLetterMainPanel:onShow")
	self.cfgs = ramadanLetterRead:getLetters()
	self.fields.list:setNumItems(#self.cfgs)
end
function RamadanLetterMainPanel:onHide()
	print("=======RamadanLetterMainPanel:onHide")
end
function RamadanLetterMainPanel:onDispose()
	print("=======RamadanLetterMainPanel:onDispose")
end
function RamadanLetterMainPanel:refreshView()
	self.fields.list:setNumItems(#self.cfgs)
end
function RamadanLetterMainPanel:onItemRenderer(index, obj)
	local cfg = self.cfgs[index + 1]
	obj:initData(cfg)
end
return RamadanLetterMainPanel
