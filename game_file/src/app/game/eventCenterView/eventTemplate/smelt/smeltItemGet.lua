local jumpDesRead = include("jumpDesRead")
local smeltRead = include("smeltRead")
local publicRead = include("publicRead")
local smeltItemGet = class("smeltItemGet", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("smeltItemGet")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function smeltItemGet:ctor()
	self:initSourceJumpFun()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Smelt_text_33"))
	self.text_tip = SoraDGetChildByName(self, "Text_tip")
	self.text_tip:setString(i18n("Smelt_text_34"))
	self.btn_template1 = SoraDGetChildByName(self, "btn_template1")
	self.btn_template1:addTouchEventListener(handler(self, self.onClick_btn_template1))
	self.btn_template1:setPressedActionEnabled(false)
	self.btn_template2 = SoraDGetChildByName(self, "btn_template2")
	self.btn_template2:addTouchEventListener(handler(self, self.onClick_btn_template2))
	self.btn_template2:setPressedActionEnabled(false)
	self:init()
end
function smeltItemGet:init()
	local items = smeltRead:getItems()
	local itemDesRead = include("itemDesRead")
	self.itemID1 = items[1].itemID
	local data = itemDesRead.getOutput(self.itemID1)
	self.sourceId1 = data[1]
	self:setSingleInfo(self.btn_template1, self.sourceId1)
	local parent = SoraDGetChildByName(self, "Node_item1")
	local item = SoraDPopItemAward()
	item:setPosition(0, 0)
	item:addTo(parent, 0)
	item:setBaseScale(0.9)
	item:initData(self.itemID1)
	self.item1 = item
	SoraDGetChildByName(parent, "Text_name"):setString(publicRead.getName(self.itemID1))
	self.itemID2 = items[2].itemID
	local data = itemDesRead.getOutput(self.itemID2)
	self.sourceId2 = data[1]
	self:setSingleInfo(self.btn_template2, self.sourceId2)
	local parent2 = SoraDGetChildByName(self, "Node_item2")
	local item2 = SoraDPopItemAward()
	item2:setPosition(0, 0)
	item2:addTo(parent2, 0)
	item2:setBaseScale(0.9)
	item2:initData(self.itemID2)
	self.item2 = item2
	SoraDGetChildByName(parent2, "Text_name"):setString(publicRead.getName(self.itemID2))
end
function smeltItemGet:setSingleInfo(view, sourceId)
	local text_des = SoraDGetChildByName(view, "text_des")
	local img_icon = SoraDGetChildByName(view, "img_icon")
	local btn_jump = view
	local itemCfg = jumpDesRead.getCfg(sourceId)
	if itemCfg then
		text_des:setString(i18n(itemCfg.des))
		img_icon:loadTexture(itemCfg.icon, ccui.TextureResType.plistType)
		img_icon:ignoreContentAdaptWithSize(false)
	end
end
function smeltItemGet:onClick_btn_template1(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local jumpFun = self.sourceJumpFun[self.sourceId1]
		if jumpFun then
			_ENV = self.sourceId1
			local self.sourceId1.itemID, data = self.itemID1, self.sourceId1
			return jumpFun(data)
		end
		if SoraDJumpBySourceId(self.sourceId1) then
			self:closePanel()
		end
	end
end
function smeltItemGet:onClick_btn_template2(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local jumpFun = self.sourceJumpFun[self.sourceId2]
		if jumpFun then
			_ENV = self.sourceId2
			local self.sourceId2.itemID, data = self.itemID2, self.sourceId2
			return jumpFun(data)
		end
		if SoraDJumpBySourceId(self.sourceId2) then
			self:closePanel()
		end
	end
end
function smeltItemGet:initSourceJumpFun(...)
	_ENV = nil
	;(nil)[39] = handler(self, self.jumpToAllianceShop)
	self.sourceJumpFun, (nil)[40] = nil, handler(self, self.jumpToRechargeView)
end
function smeltItemGet:jumpToAllianceShop(data)
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
function smeltItemGet:jumpToRechargeView(data)
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
return smeltItemGet
