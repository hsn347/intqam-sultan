local starTreasureCtrl = SoraDGetCtrl("starTreasureCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarTreasurePanel = class("StarTreasurePanel", baseFguiPanel)
function StarTreasurePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarTreasurePanel:ctor", self.viewName)
end
function StarTreasurePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarTreasurePanel:onInit()
	print("=======StarTreasurePanel:onInit")
	starTreasureCtrl:sendInitMsg()
	self.functionCol = self:initFunc()
end
function StarTreasurePanel:initFunc()
	_ENV = nil
	;(nil).init = function()
		self.fields.com_main:initData()
	end
	;(nil).reset = function()
		self.fields.com_main:initData()
	end
	;(nil).merge = function()
		SoraDShowMsgTip(i18n("common_text_3896"))
		self:showRewards()
		self.fields.com_main:initData()
	end
	;(nil).use = function()
		SoraDGotoWorldMapPoint(cc.p(starTreasureCtrl:getPosX(), starTreasureCtrl:getPosY()), true)
		SoraDRemoveAllPrePanelFromManager(self)
	end
	;(nil).notEnoughItem = function()
	end
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	;(nil).useFail = function()
		SoraDShowMsgTip(i18n("endless_treasures_text_13"))
	end
	local (nil).notSelfKingdom, functionCol = function()
		SoraDShowMsgTip(i18n("common_text_2180"))
	end, nil
	return functionCol
end
function StarTreasurePanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function StarTreasurePanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "StarTreasurePanel:refreshView")
	self.rewards = data.reward
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function StarTreasurePanel:onShow()
	print("=======StarTreasurePanel:onShow")
end
function StarTreasurePanel:onHide()
	print("=======StarTreasurePanel:onHide")
end
function StarTreasurePanel:onDispose()
	print("=======StarTreasurePanel:onDispose")
end
return StarTreasurePanel
