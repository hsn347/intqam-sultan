local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyGetWayPanel = class("StarEnergyGetWayPanel", baseFguiPanel)
function StarEnergyGetWayPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyGetWayPanel:ctor", self.viewName)
end
function StarEnergyGetWayPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarEnergyGetWayPanel:onInit()
	print("=======StarEnergyGetWayPanel:onInit")
	self.fields.List_getWay:setItemRenderer(handler(self, self.onItemRenderer))
end
function StarEnergyGetWayPanel:initData(itemID)
	self.fields.Panel_bg:setTitle(publicRead.getName(itemID))
	self.fields.Text_des:setString(publicRead.getDes(itemID))
	publicRead, self.sourceId = itemDesRead.getOutput(itemID), itemDesRead.getOutput(itemID)
	itemDesRead.getOutput(itemID)[39] = handler(self, self.jumpToAllianceShop)
	self.sourceJumpFun, itemDesRead.getOutput(itemID)[40] = itemDesRead.getOutput(itemID), handler(self, self.jumpToRechargeView)
	self.fields.List_getWay:setNumItems(table.nums(self.sourceId))
end
function StarEnergyGetWayPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.sourceId[index + 1], handler(self, self.onClickGo))
end
function StarEnergyGetWayPanel:onClickGo(sourceId)
	SoraDPlaySound()
	self:jumpBySourceType(sourceId)
end
function StarEnergyGetWayPanel:jumpBySourceType(sourceId)
	local jumpFun = self.sourceJumpFun[sourceId]
	if jumpFun then
		_ENV = nil
		local (nil).itemID, data = self.itemID, nil
		return jumpFun(data)
	end
	SoraDJumpBySourceId(sourceId, self.otherData)
	if self and self.view then
		self:close()
	end
end
function StarEnergyGetWayPanel:jumpToAllianceShop(data)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance(true) then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	else
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceMainView")
		else
			SoraDCreatePanel("allianceMainView"):show()
		end
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		mildGuideManager:starToAllianceShop()
		return true
	end
end
function StarEnergyGetWayPanel:jumpToRechargeView(data)
	local category
	if data.itemID and table.indexof(SoraDGetCtrl("kohMigrateCtrl"):getItemIDList(), data.itemID) then
		category = 25
	end
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).menuEnum = category
		uiManager:show("rechargeView", nil)
	else
		local rechargeView = SoraDCreatePanel("rechargeView")
		if category then
			rechargeView:jumpToLimitNodeByType(category)
		end
		rechargeView:show()
	end
	return true
end
function StarEnergyGetWayPanel:onShow()
	print("=======StarEnergyGetWayPanel:onShow")
	self:initData(self.proxy.param.itemID)
end
return StarEnergyGetWayPanel
