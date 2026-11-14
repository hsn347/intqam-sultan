local jumpDesRead = include("jumpDesRead")
local baseComponent = require("fgui.base.baseComponent")
local List_getWay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_getWay", List_getWay)
function List_getWay:onInit()
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function List_getWay:onShow()
end
function List_getWay:initData(sourceId, itemID, parent)
	self.sourceId = sourceId
	self.itemID = itemID
	self.parent = parent
	if type(self.sourceId) == "table" then
		self.fields.Text_name:setString(self.sourceId.des)
		self.fields.icon:setSpriteFrame(self.sourceId.icon)
		self.needNum = self.sourceId.needNum
		self.needCount = self.sourceId.needCount
		if self.sourceId.isItemUse then
			self.fields.Btn_go:setString(i18n("common_text_314"))
		else
			self.fields.Btn_go:setString(i18n("common_text_477"))
		end
	else
		local itemCfg = jumpDesRead.getCfg(self.sourceId)
		self.fields.Text_name:setString(self.sourceId == 14 and i18n("dress_text_200") or i18n(itemCfg.des))
		self.fields.icon:setSpriteFrame(itemCfg.icon)
	end
end
function List_getWay:jumpConditionBySouceID()
	local guide = jumpDesRead.getGuide(self.sourceId)
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
function List_getWay:btnGoClick()
	SoraDPlaySound()
	if type(self.sourceId) == "table" then
		local sourceId = self.sourceId.sourceid
		if sourceId == 1 then
			local activityStatus = SoraDGetCtrl("activityShowCtrl"):getStateByID(self.sourceId.activityID)
			if gActivityState.OPEN == activityStatus then
				if self.sourceId.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
					clientEventMgr.singleClickEvent(self.sourceId.activityID)
				else
					uiManager:show("EventCenterView")
				end
				self.parent:close()
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		elseif sourceId == 2 then
			_ENV = i18n("common_text_2486")
			_ENV, i18n("common_text_2486").itemType = gItemType.CAT_EYE_GEM, gItemType.CAT_EYE_GEM
			i18n("common_text_2486").troopData, gItemType.CAT_EYE_GEM.itemID = gItemType.CAT_EYE_GEM, self.sourceId.itemID
			uiManager:show("PropBuyView", i18n("common_text_2486"))
			self.parent:close()
		elseif sourceId == 0 then
			_ENV = i18n("common_text_2486")
			i18n("common_text_2486").itemID = 299201
			i18n("common_text_2486").selectedItemID = self.itemID
			i18n("common_text_2486").curCount = self.needNum
			i18n("common_text_2486").needCount = self.needCount
			uiManager:show("CommonSelectResourceBox", i18n("common_text_2486"))
			self.parent:close()
		end
		return
	end
	if not self:jumpConditionBySouceID(self.sourceId) then
		return
	end
	if self.sourceId == 39 then
		local allianceMgr = SoraDGetCtrl("allianceMgr")
		if not allianceMgr:hasJoinAlliance(true) then
			SoraDShowMsgTip(i18n("tips_place_noUnion"))
		else
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceMainView")
			else
				SoraDCreatePanel("allianceMainView"):show()
			end
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			mildGuideManager:starToAllianceShop()
			self.parent:close()
		end
	elseif self.sourceId == 40 then
		local category
		if self.itemID and table.indexof(SoraDGetCtrl("kohMigrateCtrl"):getItemIDList(), self.itemID) then
			category = 25
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = i18n("tips_place_noUnion")
			i18n("tips_place_noUnion").menuEnum = category
			uiManager:show("rechargeView", i18n("tips_place_noUnion"))
		else
			local rechargeView = SoraDCreatePanel("rechargeView")
			if category then
				rechargeView:jumpToLimitNodeByType(category)
			end
			rechargeView:show()
		end
		self.parent:close()
	elseif self.sourceId == 170 then
		uiManager:show("MagicLampSkillResolve")
		self:close()
	elseif self.sourceId == 171 then
		SoraDRemoveAllPanelFromManager()
		uiManager:show("MagicLampMaigcPowerMain")
	elseif self.sourceId == 177 then
		_UPVALUE3_ = self.sourceId
		self.sourceId[1] = 19202
		self.sourceId[2] = 19203
		local self.sourceId[3], giftArray = 19204, self.sourceId
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = category
			category.rechargeIDList = giftArray
			uiManager:show("rechargeView", category)
		else
			local rechargeView = SoraDCreatePanel("rechargeView")
			rechargeView:jumpToLimitNodeByList(29, giftArray)
			rechargeView:show()
		end
		self.parent:close()
	elseif SoraDJumpBySourceId(self.sourceId) then
		self.parent:close()
	end
end
return List_getWay
