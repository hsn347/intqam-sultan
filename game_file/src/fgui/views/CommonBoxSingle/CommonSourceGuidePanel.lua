local jumpDesRead = include("jumpDesRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonSourceGuidePanel = class("CommonSourceGuidePanel", baseFguiPanel)
function CommonSourceGuidePanel:ctor(...)
	CommonSourceGuidePanel.super.ctor(self, ...)
	print("CommonSourceGuidePanel:ctor", self.viewName)
	self:initSourceJumpFun()
end
function CommonSourceGuidePanel:onInit()
	print("=======CommonSourceGuidePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("common_text_4619"))
end
function CommonSourceGuidePanel:onShow()
	print("=======CommonSourceGuidePanel:onShow")
	local title = self.param.title
	if title then
		self.fields.Panel_bg:setString(title)
	else
		local itemID = self.param.itemID
		if itemID then
			local itemName = publicRead.getName(itemID)
			_ENV = nil
			;(nil).name = itemName
			self.fields.Panel_bg:setString(i18n("Bubble_Bobble_text_13", nil))
		end
	end
	local itemID = self.param.itemID
	if itemID then
		self:initWithItemID(itemID, self.param.otherData)
	elseif self.param.itemList then
		self.otherData = self.param.otherData
		local itemDesRead = include("itemDesRead")
		local sources = itemDesRead.getItemListOutput(self.param.itemList)
		self:init(sources, self.param.desStr)
	else
		self:init(self.param.sources, self.param.desStr)
	end
end
function CommonSourceGuidePanel:initWithItemID(itemID, otherData)
	self.itemID = itemID
	self.otherData = otherData
	local itemDesRead = include("itemDesRead")
	self:init(itemDesRead.getOutput(itemID), self.param.desStr)
end
function CommonSourceGuidePanel:init(sourcesData, desStr)
	dump(sourcesData, "==CommonSourceGuidePanel:init==")
	if desStr then
		self.fields.Text_none:setString(desStr)
	end
	self.sourcesData = sourcesData
	self.fields.List:setNumItems(#self.sourcesData)
	self.fields.Text_none:setVisible(#self.sourcesData == 0)
end
function CommonSourceGuidePanel:onItemRenderer(index, obj)
	local sourceId = self.sourcesData[index + 1]
	local itemCfg = jumpDesRead.getCfg(sourceId)
	local _fields = fguiHelper.get_fields(obj)
	if itemCfg then
		if sourceId == 14 then
			_fields.Text_des:setString(i18n("dress_text_200"))
		elseif sourceId == 239 then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			local countStr = nebulaAllStarUtil.getGiftBandageStr()
			local desStr = i18n(itemCfg.des) .. "\n" .. countStr
			_fields.Text_des:setString(desStr)
		elseif sourceId == 283 then
			local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
			local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001638
			local buyCount, buyMax = activityCommonBubbleCtrl:getBuyCountAndMax(activityID)
			jumpDesRead = i18n("dress_text_200")
			i18n("dress_text_200").num = buyCount
			i18n("dress_text_200").max = buyMax
			_fields.Text_des:setString(i18n("Bubble_Bobble_text_06", i18n("dress_text_200")))
		else
			_fields.Text_des:setString(i18n(itemCfg.des))
		end
		_fields.icon:setURL(itemCfg.icon)
		if string.find(itemCfg.icon, "icon_activity_") then
			_fields.icon:setScale(1.3)
		else
			_fields.icon:setScale(1.0)
		end
	end
	if jumpDesRead.hasJump(sourceId) then
		if sourceId == 283 then
			_fields.Button_go:setString(i18n("common_text_282"))
			local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
			local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001638
			if not activityCommonBubbleCtrl:checkBuyCount(activityID) then
				_fields.Button_go:setEnabled(false)
			end
		else
			_fields.Button_go:setString(i18n("common_text_477"))
		end
		_fields.Button_go:setTag(sourceId)
		_fields.Button_go:addClickListener(handler(self, self.onClick_btn_template))
	else
		_fields.Button_go:setVisible(false)
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function CommonSourceGuidePanel:onClick_btn_template(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	self:jumpBySourceType(tag)
end
function CommonSourceGuidePanel:jumpBySourceType(sourceId)
	if not self:jumpConditionBySouceID(sourceId) then
		return
	end
	local jumpFun = self.sourceJumpFun[sourceId]
	if jumpFun then
		_ENV = self
		self.itemID = self.itemID
		local self.sourceId, data = sourceId, self
		return jumpFun(data)
	end
	if SoraDJumpBySourceId(sourceId, self.otherData) then
		self:closePanel()
	end
end
function CommonSourceGuidePanel:jumpConditionBySouceID(sourceId)
	local guide = jumpDesRead.getGuide(sourceId)
	if not guide.gift_id then
		return true
	end
	local isActRid = false
	local activityTimeRead = include("activityTimeRead")
	local giftID = activityTimeRead.getRechargeId(gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL)
	for i, rid in ipairs(giftID) do
		if guide.gift_id == rid then
			isActRid = true
		end
	end
	if not isActRid then
		return true
	end
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local leftBuyTime = 0
	for i, rid in ipairs(giftID) do
		local info = rechargeActivityCtrl:getRechargeActivityData(rid)
		if info and info.extraData then
			leftBuyTime = leftBuyTime + info.extraData
		end
	end
	if leftBuyTime <= 0 then
		SoraDShowMsgTip(i18n("StarlitNight_text_10"))
		return false
	end
	return true
end
function CommonSourceGuidePanel:initSourceJumpFun(...)
	_ENV = nil
	;(nil)[39] = handler(self, self.jumpToAllianceShop)
	;(nil)[40] = handler(self, self.jumpToRechargeView)
	;(nil)[170] = handler(self, self.jumpToMLSkillResolveView)
	;(nil)[171] = handler(self, self.jumpToMLMaigcPowerView)
	;(nil)[177] = handler(self, self.jumpToMagicRechargeView)
	;(nil)[240] = handler(self, self.jumpToNebulaAllStarGiftView)
	;(nil)[256] = handler(self, self.jumpTo9001619Task)
	;(nil)[283] = handler(self, self.jumpTo9001638Buy)
	;(nil)[350] = handler(self, self.jumpTo9001675Shop)
	;(nil)[353] = handler(self, self.jumpToAngerSign)
	;(nil)[394] = handler(self, self.jumpToHeroWeaponShop)
	self.sourceJumpFun, (nil)[398] = nil, handler(self, self.jumpToMonthlyRecharge)
end
function CommonSourceGuidePanel:jumpToAllianceShop(data)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance(true) then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	else
		self:closePanel()
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
function CommonSourceGuidePanel:jumpToRechargeView(data)
	self:closePanel()
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
function CommonSourceGuidePanel:jumpToMLSkillResolveView(...)
	uiManager:show("MagicLampSkillResolve")
	self:closePanel()
end
function CommonSourceGuidePanel:jumpToMLMaigcPowerView(...)
	SoraDRemoveAllPanelFromManager()
	uiManager:show("MagicLampMaigcPowerMain")
end
function CommonSourceGuidePanel:jumpToMagicRechargeView()
	self:closePanel()
	_UPVALUE3_ = self.closePanel
	self.closePanel[1] = 19202
	self.closePanel[2] = 19203
	local self.closePanel[3], giftArray = 19204, self.closePanel
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = giftArray
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(29, giftArray)
		panel:show()
	end
	return true
end
function CommonSourceGuidePanel:jumpToNebulaAllStarGiftView(...)
	self:closePanel()
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	nebulaAllStarUtil.openGiftView()
end
function CommonSourceGuidePanel:jumpTo9001619Task(...)
	self:closePanel()
	if clientEventMgr.singleClickEvent(gActivityTimeActivityID.RAMADAN_RHAPSODY) then
		uiManager:show("Activity_9001619_TaskView")
	end
end
function CommonSourceGuidePanel:jumpTo9001638Buy(...)
	self:closePanel()
	local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
	activityCommonBubbleCtrl:jumpToBuyItem(gActivityTimeActivityID.NORMAL_ACTIVITY_9001638)
end
function CommonSourceGuidePanel:jumpTo9001675Shop()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, true) then
		uiManager:show("RoaringFlame_Shop")
	end
end
function CommonSourceGuidePanel:jumpToAngerSign()
	self:closePanel()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY, true) then
		_ENV = nil
		;(nil).tag = 2
		uiManager:show("angerMapView", nil)
	end
end
function CommonSourceGuidePanel:jumpToHeroWeaponShop()
	self:closePanel()
	uiManager:show("HeroWeaponShop")
end
function CommonSourceGuidePanel:jumpToMonthlyRecharge(data)
	self:closePanel()
	local itemCfg = jumpDesRead.getCfg(data.sourceId)
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local gift_list = itemCfg.guide.gift_list
	local isOnSale = false
	for _, rechargeID in ipairs(gift_list) do
		if rechargeActivityCtrl:getRechargeActivityData(rechargeID) then
			isOnSale = true
			break
		end
	end
	if isOnSale then
		if GLOBAL_GAME_RECHARGE_MODE then
			jumpDesRead = nil
			;(nil).toCategory = gRechargeCenterCategory.MONTH
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:expect2SelectTab(gRechargeCenterCategory.MONTH)
			panel:show()
		end
	else
		SoraDShowMsgTip(i18n("StarlitNight_text_10"))
	end
end
return CommonSourceGuidePanel
