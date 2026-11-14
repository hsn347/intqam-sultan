local jumpDesRead = include("jumpDesRead")
local sheepRunItemGet = class("sheepRunItemGet", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("sheepRunItemGet")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function sheepRunItemGet:ctor()
	self:initSourceJumpFun()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.btn_receive = SoraDGetChildByName(self, "Button_receive")
	self.scrollView = SoraDGetChildByName(self, "scrollView")
	self.Text_Name = SoraDGetChildByName(self, "Text_Name")
	self.Text_Name:setString(i18n("king_tri_text_27"))
	self.btn_receive:addTouchEventListener(handler(self, self.jumpBySourceType))
	self.btn_receive:setTitleText(i18n("common_text_477"))
	self.ccs_bg:setTitleName(i18n("common_text_4342"))
	self:setBackGround(204.0)
	self:init()
end
function sheepRunItemGet:init()
	local itemID = 839901
	local itemDesRead = include("itemDesRead")
	local data = itemDesRead.getOutput(itemID)
	self.sourceId = data[1]
end
function sheepRunItemGet:jumpBySourceType(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local jumpFun = self.sourceJumpFun[self.sourceId]
		if jumpFun then
			_ENV = self.sourceId
			local self.sourceId.itemID, data = self.itemID, self.sourceId
			return jumpFun(data)
		end
		if SoraDJumpBySourceId(self.sourceId) then
			self:closePanel()
		end
	end
end
function sheepRunItemGet:initSourceJumpFun(...)
	_ENV = nil
	;(nil)[39] = handler(self, self.jumpToAllianceShop)
	self.sourceJumpFun, (nil)[40] = nil, handler(self, self.jumpToRechargeView)
end
function sheepRunItemGet:jumpToAllianceShop(data)
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
function sheepRunItemGet:jumpToRechargeView(data)
	self:close(nil, ccui.TouchEventType.ended)
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
return sheepRunItemGet
