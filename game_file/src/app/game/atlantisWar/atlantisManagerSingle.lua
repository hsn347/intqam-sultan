local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisManagerSingle = class("atlantisManagerSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisManagerSingle")
	end
	return target
end)
function atlantisManagerSingle:ctor()
	self:initWidget()
end
function atlantisManagerSingle:initWidget(...)
	self.ccs_member = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisMemberSingle")
	self.ccs_member:setShowOnline(false)
	local Button_change = SoraDGetChildByName(self, "Button_change")
	Button_change:setTitleText(i18n("common_text_243"))
	Button_change:addTouchEventListener(handler(self, self.btnChangeClick))
end
function atlantisManagerSingle:initData(data, otherData)
	self.index = data.index
	self.shieldUidMap = otherData.shieldUidMap
	otherData.viewType = "atlantisManagerSingle"
	self.ccs_member:initData(data, otherData)
end
function atlantisManagerSingle:btnChangeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not atlantisActivityCtrl:isManager() then
			SoraDShowMsgTip(i18n("atlantiswar_text_0245"))
			return
		end
		if atlantisActivityCtrl:getActivityCurState() == ATLANTIS_WAR_STATE.BATTLE then
			SoraDShowMsgTip(i18n("atlantiswar_text_0025"))
			return
		end
		local layer = uiManager:show("LordSelectView").view
		layer:showAbbr(true)
		layer:setOwnSelect(true)
		layer:setTitleText(i18n("atlantiswar_text_0030"))
		layer:setLimitCasteLV(ATLANTIS_WAR_CASTLE_LEVEL)
		layer:setIsSortPower(true)
		layer:setLimitTips("atlantiswar_text_0008")
		layer:initData(gSearchStyle.LORD_KINGDOM, 1, i18n("common_text_1417"))
		layer:setSearchType(lordSearchType.PIGEON)
		layer:setCloseSelfType(true)
		layer:setShieldMap(self.shieldUidMap)
		layer:setHandle(function(tableUID)
			atlantisActivityCtrl:reqModifyManager(self.index, tableUID[1])
		end)
	end
end
return atlantisManagerSingle
