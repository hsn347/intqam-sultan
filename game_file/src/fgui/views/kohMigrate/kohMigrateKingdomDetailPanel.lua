local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateKingdomDetailPanel = class("kohMigrateKingdomDetailPanel", baseFguiPanel)
_ENV = "kohMigrateKingdomDetailPanel"
;("kohMigrateKingdomDetailPanel").ISCLOSEMOVEIN = 1
;("kohMigrateKingdomDetailPanel").COOLING = 2
;("kohMigrateKingdomDetailPanel").PLAYERSTRENGTHLIMIT = 3
;("kohMigrateKingdomDetailPanel").MOVEINCOUNTLIMIT = 4
;("kohMigrateKingdomDetailPanel").MOVE_IN_LEGEND = 5
local ("kohMigrateKingdomDetailPanel").MOVE_IN_STRENGTH, condType = 6, "kohMigrateKingdomDetailPanel"
function kohMigrateKingdomDetailPanel:ctor(...)
	kohMigrateKingdomDetailPanel.super.ctor(self, ...)
	print("kohMigrateKingdomDetailPanel:ctor", self.viewName)
	self.applyAccepted = false
	self.condList, kohMigrateKingdomDetailPanel, self.isPrivilege = print, print, false
	self.playerType = kohMigrateCtrl:getMyPlayerType()
end
function kohMigrateKingdomDetailPanel:onInit()
	print("=======kohMigrateKingdomDetailPanel:onInit")
	_ENV = nil
	;(nil).kid = 1
	self.fields.Com_title:initData(i18n("migrant_move_text34", nil), handler(self, self.onClickClose))
	self.fields.List_condition:setItemRenderer(handler(self, self.onConditionItemRenderer))
	self.fields.Node_king:setVisible(false)
	local _fields = fguiHelper.get_fields(self.fields.Node_king)
	_fields.Button_chat:setString(i18n("prison_btn_02"))
	_fields.Button_chat:addClickListener(handler(self, self.btnChatClick))
	_fields.Button_apply:setString(i18n("common_text_182"))
	_fields.Button_apply:addClickListener(handler(self, self.btnApplyClick))
	_fields.Text_isAgree:setString(i18n("across_move_approved_name"))
	self.fields.Text_noKing:setString(i18n("across_notKingInfo_desc"))
	self.fields.Text_noKing:setVisible(false)
	self.fields.Text_tipDes:setString(i18n("arossDesc_text_009"))
	self.fields.Button_migrate:setString(i18n("across_move_title"))
	self.fields.Button_migrate:addClickListener(handler(self, self.btnMigrateClick))
	self.fields.Button_migrateCD:setString(i18n("arossDesc_text_008"))
	self.fields.Button_migrateCD:addClickListener(handler(self, self.btnMigrateClick))
end
function kohMigrateKingdomDetailPanel:onShow()
	print("=======kohMigrateKingdomDetailPanel:onShow")
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	self:initData(param.kid, param.isPrivilege)
end
function kohMigrateKingdomDetailPanel:initData(kid, isPrivilege)
	self.kid = kid
	self.isPrivilege = isPrivilege
	if self.isPrivilege then
		_ENV = nil
		;(nil).kid = self.kid
		self.fields.Com_title:setString(i18n("migrant_move_text52", nil))
		self.fields.Text_invite:setVisible(true)
		_ENV = true
		_ENV, _ENV, (true).var1 = "#%d", string.format("#%d", self.kid), string.format("#%d", self.kid)
		_ENV, string.format("#%d", self.kid).var1, ("#%d").color = "#%d", "#%d", "#FFD719"
		string.format("#%d", self.kid).__default, ("#%d").color = "#%d", "#E5DBC7"
		local inviteStr = i18n_html("kingPower_invited_desc", true, (string.format("#%d", self.kid)))
		self.fields.Text_invite:setString(inviteStr)
	else
		_ENV = "#%d"
		;("#%d").kid = self.kid or gametop.playertop_:getKingdomID()
		self.fields.Com_title:setString(i18n("migrant_move_text34", "#%d"))
		self.fields.Text_invite:setVisible(false)
	end
	kohMigrateCtrl:reqKingdomData(self.kid)
	SoraDShowLoading(self)
end
function kohMigrateKingdomDetailPanel:refreshData(...)
	SoraDCloseLoading(self)
	local data = kohMigrateCtrl:getKingdomDataByID(self.kid)
	self.data = data
	self:getConditionList(data)
	_ENV = data
	data.kingdomData = data
	data.isPrivilege = self.isPrivilege
	self.fields.Com_kingdomInfo:initKingdomData(data)
	local checkConfig
	if self.isPrivilege then
		_ENV, _UPVALUE4_ = data, self.isPrivilege
		_ENV, data.condType = condType.COOLING, condType.COOLING
		_ENV, condType.COOLING.condType = condType.ISCLOSEMOVEIN, condType.ISCLOSEMOVEIN
		condType.ISCLOSEMOVEIN.condType = condType.MOVE_IN_LEGEND
		_ENV, condType.ISCLOSEMOVEIN.des = i18n("migrant_move_text35"), i18n("migrant_move_text35")
		i18n("migrant_move_text35").condType = condType.MOVE_IN_STRENGTH
		i18n("migrant_move_text35").des = i18n("migrant_move_text37")
		checkConfig, self.isPrivilege[1] = self.isPrivilege, data
		checkConfig, self.isPrivilege[2] = self.isPrivilege, condType.COOLING
		checkConfig, self.isPrivilege[3] = self.isPrivilege, condType.ISCLOSEMOVEIN
		checkConfig, self.isPrivilege[4] = self.isPrivilege, i18n("migrant_move_text35")
	else
		_ENV, _UPVALUE4_ = data, self.isPrivilege
		data.condType = condType.COOLING
		_ENV, data.des = i18n("tips_across_moveCD"), i18n("tips_across_moveCD")
		i18n("tips_across_moveCD").condType = condType.ISCLOSEMOVEIN
		_ENV, i18n("tips_across_moveCD").des = i18n("across_move_wayClosed_desc02"), i18n("across_move_wayClosed_desc02")
		i18n("across_move_wayClosed_desc02").condType = condType.MOVE_IN_LEGEND
		_ENV, i18n("across_move_wayClosed_desc02").des = i18n("migrant_move_text35"), i18n("migrant_move_text35")
		i18n("migrant_move_text35").condType = condType.MOVE_IN_STRENGTH
		i18n("migrant_move_text35").des = i18n("migrant_move_text37")
		_ENV, checkConfig, self.isPrivilege[1] = self.isPrivilege, self.isPrivilege, data
		_ENV, checkConfig, self.isPrivilege[2] = self.isPrivilege, self.isPrivilege, i18n("tips_across_moveCD")
		_ENV, checkConfig, self.isPrivilege[3] = self.isPrivilege, self.isPrivilege, i18n("across_move_wayClosed_desc02")
		_ENV, checkConfig, self.isPrivilege[4] = self.isPrivilege, self.isPrivilege, i18n("migrant_move_text35")
		self.isPrivilege[gKohMigratePlayerType.T1] = i18n("migrant_move_text36")
		self.isPrivilege[gKohMigratePlayerType.T2] = i18n("migrant_move_text38")
		local self.isPrivilege[gKohMigratePlayerType.T3], config = i18n("migrant_move_text39"), self.isPrivilege
		_ENV = "migrant_move_text39"
		;("migrant_move_text39").condType = condType.MOVEINCOUNTLIMIT
		;("migrant_move_text39").des = config[self.playerType]
		table.insert(checkConfig, "migrant_move_text39")
		_ENV = "migrant_move_text39"
		;("migrant_move_text39").condType = condType.PLAYERSTRENGTHLIMIT
		_ENV = "migrant_move_text37"
		;("migrant_move_text37").var1 = string.formatnumberthousands(data.setup.playerStrengthLimit)
		;("migrant_move_text39").des = i18n("across_move_overPower_desc", "migrant_move_text37")
		table.insert(checkConfig, "migrant_move_text39")
	end
	local isreach = true
	for i, v in ipairs(checkConfig) do
		if not self.condList[v.condType] then
			self.fields.Text_close:setString(v.des)
			isreach = false
			break
		end
	end
	if isreach then
		if self.isPrivilege then
			self.fields.Text_close:setVisible(true)
			self.fields.Text_close:setString(i18n("migrant_move_text54"))
		else
			self.fields.Text_close:setString(i18n("across_move_allContent_desc"))
		end
	end
	local c_type = self.fields.Node_condition:getController("c_type")
	if isreach then
		c_type:setSelectedIndex(0)
		self.fields.Node_condition:setString(i18n("across_move_conditionMet_name"))
	else
		c_type:setSelectedIndex(1)
		self.fields.Node_condition:setString(i18n("across_move_conditionNotMet_name"))
	end
	if data.kingUid and 0 < data.kingUid then
		self.fields.Node_king:setVisible(true)
		self:initKingInfo(data)
		self.fields.Text_noKing:setVisible(false)
	else
		self.fields.Node_king:setVisible(false)
		self.fields.Text_noKing:setVisible(true)
	end
	local cdValue = kohMigrateCtrl:getMigrateCDLeftTime()
	local isInCD = 0 < cdValue
	if not (self:checkMigrate() and self.kid) or isInCD then
		self.fields.Button_migrate:setBright(false)
		self.fields.Button_migrateCD:setBright(false)
	end
	self.fields.Button_migrate:setVisible(not isInCD)
	self.fields.Button_migrateCD:setVisible(isInCD)
	local itemIDList = kohMigrateCtrl:getItemIDList()
	local itemCount = kohMigrateCtrl:getItemCount()
	local needCount = kohMigrateCtrl:getItemCost()
	self.fields.Button_migrate:setCost2(itemIDList[1], needCount, itemCount)
end
function kohMigrateKingdomDetailPanel:getConditionList(data)
	local _ENV, condConfig
	local _isreach = not data.setup.isCloseMoveIn
	local _value = _isreach and i18n("common_text_246") or i18n("common_text_247")
	_ENV = nil
	;(nil).condType = condType.ISCLOSEMOVEIN
	;(nil).style = 1
	;(nil).key = i18n("across_move_wayState_name")
	;(nil).value = _value
	;(nil).isreach = _isreach
	table.insert(condConfig, nil)
	if self.isPrivilege then
	else
		local _value = data.setup.playerStrengthLimit
		local beginStrength = kohMigrateCtrl:getBeginStrength()
		self.applyAccepted = kohMigrateCtrl:checkApplyAccepted(data.kid)
		local _isreach = _value >= beginStrength or self.applyAccepted
		_ENV = nil
		;(nil).condType = condType.PLAYERSTRENGTHLIMIT
		;(nil).style = 2
		;(nil).key = i18n("across_move_powerLimit_name")
		;(nil).icon = "icon_powerLimit.png"
		;(nil).value = string.formatnumberthousands(_value)
		;(nil).isreach = _isreach
		table.insert(condConfig, nil)
	end
	self.condConfig = condConfig
	self.fields.List_condition:setNumItems(#self.condConfig)
	local _ENV, ret = self.fields.List_condition.setNumItems, self.fields.List_condition.setNumItems
	for i, v in ipairs(condConfig) do
		ret[v.condType] = v.isreach
	end
	if ret[condType.COOLING] == nil then
		ret[condType.COOLING] = true
	end
	if self.isPrivilege then
		ret[condType.MOVEINCOUNTLIMIT] = true
	else
		local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(data, self.playerType)
		local isreach = 0 < canMoveInCount
		ret[condType.MOVEINCOUNTLIMIT] = isreach
	end
	if self.playerType == gKohMigratePlayerType.T1 then
		local canMoveInLegend = kohMigrateCtrl:getCanMoveInLegend(data)
		local legend = kohMigrateCtrl:getMyLegend() or 0
		local isreach = canMoveInLegend >= legend
		ret[condType.MOVE_IN_LEGEND] = isreach
		ret[condType.MOVE_IN_STRENGTH] = true
	elseif self.playerType == gKohMigratePlayerType.T2 then
		ret[condType.MOVE_IN_LEGEND] = true
		local canMoveInStrength = kohMigrateCtrl:getCanMoveInStrength(data)
		local beginStrength = kohMigrateCtrl:getBeginStrength()
		local isreach = canMoveInStrength >= beginStrength
		ret[condType.MOVE_IN_STRENGTH] = isreach
	else
		ret[condType.MOVE_IN_LEGEND] = true
		ret[condType.MOVE_IN_STRENGTH] = true
	end
	self.condList = ret
end
function kohMigrateKingdomDetailPanel:onConditionItemRenderer(index, obj)
	local config = self.condConfig[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_key:setString(config.key)
	_fields.Icon_yes:setVisible(false)
	_fields.Icon_no:setVisible(false)
	if config.isreach then
		_fields.Icon_yes:setVisible(true)
		_fields.Text_value:setString(config.value)
	else
		_fields.Icon_no:setVisible(true)
		if config.condType == condType.COOLING then
			_fields.Text_value = SoraDCreateTimerLabel(obj, _fields.Text_value)
			_fields.Text_value:setTimeEndListener(function()
				SoraDRemoveAllPanelFromManager()
			end)
			_fields.Text_value:beginTime(config.value)
		else
			_fields.Text_value:setString(config.value)
		end
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function kohMigrateKingdomDetailPanel:initKingInfo(data)
	local _fields = fguiHelper.get_fields(self.fields.Node_king)
	_fields.Button_chat:setVisible(data.kingUid ~= gametop.playertop_:getPlayerID())
	_fields.Com_head:setHeadSprite(data.kingIcon, data.kingAvatar)
	_fields.Com_head:setPlayerID(data.kingUid)
	local kingName = data.kingName
	if data.kingAbbr then
		_ENV = data.kingAvatar
		data.kingAvatar.abbr = data.kingAbbr
		data.kingAvatar.name = kingName
		kingName = i18n("common_text_186", data.kingAvatar)
	end
	_ENV = nil
	;(nil).kingName = kingName
	_fields.Text_kingName:setString(i18n("common_text_529", nil))
	_ENV = i18n("common_text_529", nil)
	i18n("common_text_529", nil).power = string.formatnumberthousands(data.kingTotalFc)
	_fields.Text_kingPower:setString(i18n("common_text_1418", i18n("common_text_529", nil)))
	_fields.Text_isAgree:setVisible(false)
	if self.isPrivilege then
		_fields.Button_apply:setVisible(false)
	elseif self.condList[condType.PLAYERSTRENGTHLIMIT] then
		_fields.Button_apply:setVisible(false)
		if self.applyAccepted then
			_fields.Text_isAgree:setVisible(true)
		end
	else
		_fields.Button_apply:setVisible(true)
		_fields.Button_apply:setString(i18n("common_text_182"))
		if not self:checkApply() then
			_fields.Button_apply:setBright(false)
		end
		if not kohMigrateCtrl:checkApplySendTimeCD(self.kid) and not kohMigrateCtrl:checkApplyRejected(self.kid) then
			_fields.Button_apply:setString(i18n("alliance_office_btn_02"))
		end
	end
	if not self.kid then
		_fields.Button_apply:setVisible(false)
	end
	if not SoraDFIsRA() then
		self.fields.Node_king:fixChildrenPos()
	end
end
function kohMigrateKingdomDetailPanel:btnChatClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.targetType = gMailType.CHAT
	SoraDPlaySound.target = self.data.kingUid
	SoraDPlaySound.nickName = self.data.kingName
	local SoraDPlaySound.allianceAbbr, data = self.data.kingAbbr, SoraDPlaySound
	SoraDCreateChatView(data)
end
function kohMigrateKingdomDetailPanel:checkApply(showTip)
	condType, _UPVALUE3_ = nil, nil
	;(nil).condType = condType.COOLING
	condType, (nil).des = i18n("tips_apply_moveCD"), i18n("tips_apply_moveCD")
	i18n("tips_apply_moveCD").condType = condType.MOVEINCOUNTLIMIT
	condType, i18n("tips_apply_moveCD").des = i18n("tips_across_applyNumMax"), i18n("tips_across_applyNumMax")
	i18n("tips_across_applyNumMax").condType = condType.ISCLOSEMOVEIN
	i18n("tips_across_applyNumMax").des = i18n("tips_across_wayClosed")
	;(nil)[1] = nil
	;(nil)[2] = i18n("tips_apply_moveCD")
	local (nil)[3], checkConfig = i18n("tips_across_applyNumMax"), nil
	for i, v in ipairs(checkConfig) do
		if not self.condList[v.condType] then
			if showTip then
				SoraDShowMsgTip(v.des)
			end
			return false
		end
	end
	local leftcount = kohMigrateCtrl:getTodayApplySendCountLeft()
	if leftcount <= 0 then
		if showTip then
			SoraDShowMsgTip(i18n("tips_apply_dailyTimesMax"))
		end
		return false
	end
	if not kohMigrateCtrl:checkApplySendTimeCD(self.kid) then
		if showTip then
			local constValue = kohMigrateCtrl:getAcrossParam("across_applyCoolDown")
			condType = i18n("tips_apply_dailyTimesMax")
			i18n("tips_apply_dailyTimesMax").var1 = math.ceil(constValue / 60)
			SoraDShowMsgTip(i18n("tips_applyAgain_timeLimit", i18n("tips_apply_dailyTimesMax")))
		end
		return false
	end
	return true
end
function kohMigrateKingdomDetailPanel:btnApplyClick()
	SoraDPlaySound()
	if not self:checkApply(true) then
		return
	end
	local cdValue = kohMigrateCtrl:getMigrateCDLeftTime()
	if 0 < cdValue then
		SoraDShowMsgTip(i18n("tips_apply_moveCD"))
		return
	end
	local msgKey = "across_move_applySure_desc"
	if not self.condList[condType.MOVE_IN_LEGEND] then
		msgKey = "migrant_move_text55"
	elseif not self.condList[condType.MOVE_IN_STRENGTH] then
		msgKey = "migrant_move_text56"
	end
	local leftcount = kohMigrateCtrl:getTodayApplySendCountLeft()
	_ENV = i18n("tips_apply_moveCD")
	i18n("tips_apply_moveCD").var1 = self.kid
	i18n("tips_apply_moveCD").var2 = leftcount
	local showMsg = i18n(msgKey, i18n("tips_apply_moveCD"))
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			kohMigrateCtrl:reqSendExtraApply(self.kid)
		end
	end)
end
function kohMigrateKingdomDetailPanel:checkMigrate(showTip)
	condType, _UPVALUE4_ = nil, nil
	;(nil).condType = condType.ISCLOSEMOVEIN
	condType, (nil).des = i18n("across_move_wayClosed_desc02"), i18n("across_move_wayClosed_desc02")
	i18n("across_move_wayClosed_desc02").condType = condType.COOLING
	condType, i18n("across_move_wayClosed_desc02").des = i18n("tips_across_moveCD"), i18n("tips_across_moveCD")
	i18n("tips_across_moveCD").condType = condType.MOVE_IN_LEGEND
	condType, i18n("tips_across_moveCD").des = i18n("migrant_move_text35"), i18n("migrant_move_text35")
	i18n("migrant_move_text35").condType = condType.MOVE_IN_STRENGTH
	i18n("migrant_move_text35").des = i18n("migrant_move_text37")
	;(nil)[1] = nil
	;(nil)[2] = i18n("across_move_wayClosed_desc02")
	;(nil)[3] = i18n("tips_across_moveCD")
	local (nil)[4], checkConfig = i18n("migrant_move_text35"), nil
	if self.isPrivilege then
	else
		condType = self.isPrivilege
		self.isPrivilege[gKohMigratePlayerType.T1] = i18n("migrant_move_text36")
		self.isPrivilege[gKohMigratePlayerType.T2] = i18n("migrant_move_text38")
		local self.isPrivilege[gKohMigratePlayerType.T3], config = i18n("migrant_move_text39"), self.isPrivilege
		condType = "migrant_move_text39"
		;("migrant_move_text39").condType = condType.MOVEINCOUNTLIMIT
		;("migrant_move_text39").des = config[self.playerType]
		table.insert(checkConfig, "migrant_move_text39")
		condType = "migrant_move_text39"
		;("migrant_move_text39").condType = condType.PLAYERSTRENGTHLIMIT
		;("migrant_move_text39").des = i18n("tips_acs_move_overPower")
		table.insert(checkConfig, "migrant_move_text39")
	end
	for i, v in ipairs(checkConfig) do
		if not self.condList[v.condType] then
			if showTip then
				SoraDShowMsgTip(v.des)
			end
			return false
		end
	end
	return true
end
function kohMigrateKingdomDetailPanel:btnMigrateClick()
	SoraDPlaySound()
	if not self.kid then
		SoraDShowMsgTip(i18n("tips_across_sameKingdom"))
		return
	end
	if not self:checkMigrate(true) then
		return
	end
	local cdValue = kohMigrateCtrl:getMigrateCDLeftTime()
	if 0 < cdValue then
		SoraDShowMsgTip(i18n("tips_across_moveCD"))
		return
	end
	_ENV = i18n("tips_across_moveCD")
	i18n("tips_across_moveCD").kingdomId = self.kid
	i18n("tips_across_moveCD").isInvitedMove = self.isInvite
	i18n("tips_across_moveCD").isExtraMove = self.applyAccepted
	i18n("tips_across_moveCD").isPrivilege = self.isPrivilege
	uiManager:show("kohMigrateSure", i18n("tips_across_moveCD"))
end
function kohMigrateKingdomDetailPanel:onMsgUpdateApplyStatus(...)
	local _fields = fguiHelper.get_fields(self.fields.Node_king)
	_fields.Button_apply:setBright(false)
	_fields.Button_apply:setString(i18n("alliance_office_btn_02"))
end
return kohMigrateKingdomDetailPanel
