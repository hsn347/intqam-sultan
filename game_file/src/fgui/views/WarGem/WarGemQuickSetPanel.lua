local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemQuickSetPanel = class("WarGemQuickSetPanel", baseFguiPanel)
function WarGemQuickSetPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarGemQuickSetPanel:ctor", self.viewName)
end
function WarGemQuickSetPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WarGem"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function WarGemQuickSetPanel:onInit()
	print("=======WarGemQuickSetPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("gemEnchant_text_66"))
	self.fields.Button_reset:setString(i18n("gemEnchant_text_67"))
	self.fields.Button_reset:addClickListener(handler(self, self.onClickReset))
	self.fields.List_combo:setItemRenderer(handler(self, self.onItemRenderer))
end
function WarGemQuickSetPanel:onItemRenderer(index, obj)
	obj:initData(self.listCombo[index + 1], self)
end
function WarGemQuickSetPanel:onClickReset()
	SoraDPlaySound()
	SoraDShowBuyBox(i18n("gem_text_05"), nil, nil, function(exitType, other)
		if exitType == MSGBOX_CALLBACK_YES then
			warGemCtrl:reqClearPanel(warGemCtrl:getEditPanelId())
			SoraDShowLoading(self:displayObject())
		end
	end)
end
function WarGemQuickSetPanel:onShow()
	print("=======WarGemQuickSetPanel:onShow")
	self.listCombo, _ENV = print, print
	for i = 1, 6 do
		if i ~= warGemCtrl:getEditPanelId() then
			table.insert(self.listCombo, i)
		end
	end
	self.fields.List_combo:setNumItems(#self.listCombo)
end
function WarGemQuickSetPanel:onHide()
	print("=======WarGemQuickSetPanel:onHide")
end
function WarGemQuickSetPanel:onDispose()
	print("=======WarGemQuickSetPanel:onDispose")
end
return WarGemQuickSetPanel
