local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local beachTreasureCtrl = SoraDGetCtrl("beachTreasureCtrl")
local constantRead = include("constantRead")
local treasureBeachRead = include("treasureBeachRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeachHuntViewPanel = class("BeachHuntViewPanel", baseFguiPanel)
function BeachHuntViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeachHuntViewPanel:ctor", self.viewName)
end
function BeachHuntViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BeachHuntViewPanel:onInit()
	print("=======BeachHuntViewPanel:onInit")
	self.activityID = gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY
	self.costItemID = constantRead.getConstValue("TREASURE_BEACH_ITEM")
	self.fields.Com_have:initData(self.costItemID)
	self.fields.Com_title:initData(i18n("activity_name_9001495"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local param = activityShowCtrl:getParamByID(self.activityID)
	self.fields.Com_title:initSpecialActivityTime(math.max(0, param.timeConfig.settleTime - serviceFunctions.systemTime()))
	self.fields.Text_tip:setString(i18n("treasure_beach_02"))
	self.fields.list_left:setItemRenderer(handler(self, self.onItemRenderer))
	beachTreasureCtrl:reqBeachTreasureInit()
end
function BeachHuntViewPanel:onItemRenderer(index, obj)
	obj:initData(self.showData[index + 1])
end
function BeachHuntViewPanel:onShow()
	print("=======BeachHuntViewPanel:onShow")
end
function BeachHuntViewPanel:digBake(target, data)
	self.fields.Com_beach:doDigAct(data.idx, math.min(1, display.height / self:getHeight()))
end
function BeachHuntViewPanel:updateView(target, data)
	SoraDCloseLoading()
	self.fields.Com_have:initData(self.costItemID)
	self.itemCount = backpackCtrl:getItemCount(self.costItemID)
	self.fields.Com_have:updateNum(self.itemCount)
	self.showData, _ENV = self.fields.Com_have.updateNum, self.fields.Com_have.updateNum
	local poolCfg = treasureBeachRead.getBeachCfg()
	for k, v in ipairs(poolCfg) do
		if not beachTreasureCtrl:isRewarded(v.id) then
			table.insert(self.showData, v)
		end
	end
	self.fields.list_left:setNumItems(#self.showData)
	_ENV = nil
	;(nil).num = #self.showData
	self.fields.Text_left:setString(i18n("treasure_beach_03", nil))
	local idx = data and data.idx or nil
	self.fields.Com_beach:initData(idx)
end
function BeachHuntViewPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("treasure_beach_01")
	uiManager:show("RuleView", nil)
end
return BeachHuntViewPanel
