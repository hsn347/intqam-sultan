local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteTipsPanel = class("MeteoriteTipsPanel", baseFguiPanel)
local publicRead = include("publicRead")
function MeteoriteTipsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MeteoriteTipsPanel:ctor", self.viewName)
end
function MeteoriteTipsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteTipsPanel:onInit()
	print("=======MeteoriteTipsPanel:onInit")
	self.itemID = self.param.itemID
	self.callback = self.param.callback
	self.tip = self.param.tip
	local itemName = publicRead.getName(self.itemID)
	self.fields.text_tips:setString(self.tip)
	self.fields.button_use:setCost(self.itemID, 1, true)
	self.fields.button_use:setTitle(i18n("common_text_204"))
	self.fields.button_use:addClickEventListener(handler(self, self.onClick))
end
function MeteoriteTipsPanel:onShow()
	print("=======MeteoriteTipsPanel:onShow")
end
function MeteoriteTipsPanel:onClick()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if itemNum <= 0 then
		local itemName = publicRead.getName(self.itemID)
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgBoxNew(i18n("meteoritesmagic_text_56", nil), i18n("common_text_477"), nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local curState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
			if curState == gActivityState.OPEN then
				uiManager:show("Shiftingstars")
				return
			end
			SoraDShowMsgTip(i18n("nebula_war_text_0175"))
			return
		end)
		self:close()
		return
	end
	if self.callback then
		self.callback()
	end
	self:close()
end
return MeteoriteTipsPanel
