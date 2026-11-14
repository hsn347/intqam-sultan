local activity_9001746_Read = include("activity_9001746_Read")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001746_GetwayPanel = class("Activity_9001746_GetwayPanel", baseFguiPanel)
local GETWAY_SOURCE_ID_GIFT = 380
function Activity_9001746_GetwayPanel:ctor(...)
	self.isLRU = true
	Activity_9001746_GetwayPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY
end
function Activity_9001746_GetwayPanel:onInit()
	self:fixChildrenPos()
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.itemRenderer_list))
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.btnDetail:addClickListener(handler(self, self.onClick_btnDetail))
	self.fields.comItem:addClickListener(handler(self, self.onClick_btnDetail))
	self.fields.btnDetail:fixPos()
	self.fields.comItem:fixPos()
	self.fields.txtName:fixPos()
	self.fields.txtNum:fixPos()
end
function Activity_9001746_GetwayPanel:endShow()
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	self.itemID = tonumber(param.itemID) or 0
	self.needNum = tonumber(param.itemNum) or 0
	self.listData = activity_9001746_Read.getGetwayList(self.itemID)
	self:updateView()
end
function Activity_9001746_GetwayPanel:updateView()
	local ownNum = backpackCtrl and backpackCtrl:getItemCount(self.itemID) or 0
	local ownNumText = tostring(ownNum)
	self.fields.comItem:initData(self.itemID)
	self.fields.txtName:setString(publicRead.getName(self.itemID) or "")
	if 0 < self.needNum then
		if ownNum < self.needNum then
			ownNumText = string.format("[color=#ff6b6b]%s[/color]", ownNum)
		end
		self.fields.txtNum:setString(string.format("%s/%s", ownNumText, self.needNum))
	else
		self.fields.txtNum:setString(ownNumText)
	end
	self.fields.list:setNumItems(#self.listData)
end
function Activity_9001746_GetwayPanel:handleJump(data)
	if not data then
		return
	end
	local needClose = false
	if data.sourceId == GETWAY_SOURCE_ID_GIFT then
		GETWAY_SOURCE_ID_GIFT = nil
		;(nil).activityID = self.activityID
		uiManager:show("CommonBuyGift", nil)
		needClose = true
	elseif data.sourceId then
		GETWAY_SOURCE_ID_GIFT = "CommonBuyGift"
		;("CommonBuyGift").activityID = self.activityID
		;("CommonBuyGift").itemID = self.itemID
		needClose = SoraDJumpBySourceId(data.sourceId, "CommonBuyGift")
	end
	if needClose then
		self:close()
	end
end
function Activity_9001746_GetwayPanel:itemRenderer_list(index, obj)
	obj:initData(self.listData[index + 1], handler(self, self.handleJump))
end
function Activity_9001746_GetwayPanel:onClick_btnDetail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = publicRead.getName(self.itemID)
	;(nil).content = publicRead.getDes(self.itemID)
	uiManager:show("RuleView", nil)
end
return Activity_9001746_GetwayPanel
