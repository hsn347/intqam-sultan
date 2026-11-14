local jumpDesRead = include("jumpDesRead")
local activity_9001615_Read = include("activity_9001615_Read")
local publicRead = include("publicRead")
local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001615_ItemGetPanel = class("Activity_9001615_ItemGetPanel", baseFguiPanel)
function Activity_9001615_ItemGetPanel:ctor(...)
	Activity_9001615_ItemGetPanel.super.ctor(self, ...)
	print("Activity_9001615_ItemGetPanel:ctor", self.viewName)
end
function Activity_9001615_ItemGetPanel:onInit()
	print("=======Activity_9001615_ItemGetPanel:onInit")
	self:initSourceJumpFun()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:fixChildrenPos()
	self.arrow1 = SoraDGetChildByName(self, "arrow1")
	self.arrow1:fix()
	self.arrow2 = SoraDGetChildByName(self, "arrow2")
	self.arrow2:fix()
	self.ccs_bg = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitle(i18n("Smelt_text_33"))
	self.text_tip = SoraDGetChildByName(self, "Text_tip")
	self.text_tip:setString(i18n("Smelt_text_34"))
	self.btn_template1 = SoraDGetChildByName(self, "btn_template1")
	self.btn_template1:addTouchEventListener(handler(self, self.onClick_btn_template1))
	self.btn_template2 = SoraDGetChildByName(self, "btn_template2")
	self.btn_template2:addTouchEventListener(handler(self, self.onClick_btn_template2))
	self:initView()
end
function Activity_9001615_ItemGetPanel:onShow()
	print("=======Activity_9001615_ItemGetPanel:onShow")
end
function Activity_9001615_ItemGetPanel:initView()
	local items = activity_9001615_Read:getItems()
	local itemDesRead = include("itemDesRead")
	self.itemID1 = items[1].itemID
	self:setSingleInfo(self.btn_template1, i18n("common_text_675"))
	local parent = SoraDGetChildByName(self, "Node_item1")
	local item = SoraDGetChildByName(self, "Com_item1")
	item:initData(self.itemID1)
	self.item1 = item
	SoraDGetChildByName(parent, "Text_name"):setString(publicRead.getName(self.itemID1))
	self.itemID2 = items[2].itemID
	self:setSingleInfo(self.btn_template2, i18n("jump_activename_19490"))
	local parent2 = SoraDGetChildByName(self, "Node_item2")
	local item2 = SoraDGetChildByName(self, "Com_item2")
	item2:initData(self.itemID2)
	self.item2 = item2
	SoraDGetChildByName(parent2, "Text_name"):setString(publicRead.getName(self.itemID2))
end
function Activity_9001615_ItemGetPanel:setSingleInfo(view, title)
	local text_des = SoraDGetChildByName(view, "text_des")
	text_des:setString(title)
end
function Activity_9001615_ItemGetPanel:onClick_btn_template1(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("Activity_9001615_TaskPopView")
		self:close()
	end
end
function Activity_9001615_ItemGetPanel:onClick_btn_template2(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local packageList = activity_9001615_Ctrl:getPackageList()
		if 0 < #packageList then
			_ENV = nil
			;(nil).group = packageList
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
			;(nil).isPageTurn = false
			;(nil).isHideRechargeCenter = true
			uiManager:show("rechargePopView", nil)
		else
			SoraDShowMsgTip(i18n("Player_Return_test02"))
		end
		self:close()
	end
end
function Activity_9001615_ItemGetPanel:initSourceJumpFun(...)
	_ENV = nil
	;(nil)[39] = handler(self, self.jumpToAllianceShop)
	self.sourceJumpFun, (nil)[40] = nil, handler(self, self.jumpToRechargeView)
end
function Activity_9001615_ItemGetPanel:jumpToAllianceShop(data)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance(true) then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	else
		self:close(nil, ccui.TouchEventType.ended)
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceMainView")
		else
			local panel = SoraDCreatePanel("allianceMainView")
			panel:show()
		end
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		mildGuideManager:starToAllianceShop()
		return true
	end
end
function Activity_9001615_ItemGetPanel:jumpToRechargeView(data)
	self:close()
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
return Activity_9001615_ItemGetPanel
