local gametop = gModuleMgr.getObject("gametop")
local equipmentCtrl = gametop.playertop_:getModule("equipmentCtrl")
local settingCtrl = gametop.playertop_:getModule("settingCtrl")
local noticeCtrl = gametop.playertop_:getModule("noticeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local commonSettingSwitch = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/commonSettingSwitch", commonSettingSwitch)
_UPVALUE1_, _ENV = "ui://newLordView/commonSettingSwitch", fgui.register_extension
_UPVALUE1_, fgui.register_extension.night, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:nightSwitch~bool"
_UPVALUE1_, fgui.register_extension.noSwitch, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:goOutSwitch~bool"
_UPVALUE1_, fgui.register_extension.warSmoke, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:warSmoke~bool"
_UPVALUE1_, fgui.register_extension.legendMarquee, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:legendMarquee~bool"
_UPVALUE1_, fgui.register_extension.shake, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:shake~bool"
_UPVALUE1_, fgui.register_extension.showBuildName, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:showBuildName~bool"
_UPVALUE1_, fgui.register_extension.hideCastleWarLvEffect, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:hideCastleWarLvEffect~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.demension, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:show3d~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.lod, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:showlod~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.iran3d, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:show3d_iran~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.recharge, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:recharge~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.photo, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:showShareBtn~integer"
_UPVALUE1_, fgui.register_extension.priority, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:prioritySwitch~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.debut, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:privilegeDebut~bool"
;("ui://newLordView/commonSettingSwitch").byUID = true
_UPVALUE1_, fgui.register_extension.bindPhone, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:bindPhoneShow~bool"
_UPVALUE1_, fgui.register_extension.shieldNebula, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:GameOptionsView:shieldNebula~bool"
_UPVALUE1_, fgui.register_extension.alliance, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:Alliance~bool"
_UPVALUE1_, fgui.register_extension.noDisturb, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:NoDisturb~bool"
_UPVALUE1_, fgui.register_extension.event, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:Event~bool"
_UPVALUE1_, fgui.register_extension.mail, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:Mail~bool"
_UPVALUE1_, fgui.register_extension.allianceMail, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:allianceAllMail~bool"
_UPVALUE1_, fgui.register_extension.levelTrain, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:LevelTrain~bool"
_UPVALUE1_, fgui.register_extension.fightTroop, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:FightTroop~bool"
_UPVALUE1_, fgui.register_extension.resource, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:Resource~bool"
_UPVALUE1_, fgui.register_extension.price, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:Price~bool"
_UPVALUE1_, fgui.register_extension.redBag, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:RedBag~bool"
_UPVALUE1_, fgui.register_extension.warGuard, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:WarGuard~bool"
_UPVALUE1_, fgui.register_extension.allianceAttacked, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:AllianceAttacked~bool"
_UPVALUE1_, fgui.register_extension.tradeBoard, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:TradeBoard~bool"
_UPVALUE1_, fgui.register_extension.prisonerExcute, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:heroJail:heroCanExecute~bool"
_UPVALUE1_, fgui.register_extension.heroTrainFinish, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "Game:heroTrain:heroTrainFinish~bool"
_UPVALUE1_, fgui.register_extension.voiceChatRoom, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "ui://newLordView/commonSettingSwitch", "System:GameMessageView:voiceChatRoomInvite~bool"
fgui.register_extension.radianceWarBuildAttacked, ("ui://newLordView/commonSettingSwitch")[1] = "ui://newLordView/commonSettingSwitch", "System:GameMessageView:radianceWarBuildAttacked~bool"
local configKeyTable = fgui.register_extension
function commonSettingSwitch:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_ISSHOW_BACK", handler(self, self.updateEquipView))
end
function commonSettingSwitch:updateEquipView()
	if self.curValue.isEquip then
		self.fields.Button_switch:setVal(self:getConfigValue())
	end
end
function commonSettingSwitch:onInit()
	self:fixChildrenPos()
end
function commonSettingSwitch:onShow()
end
function commonSettingSwitch:initData(switchKey, curValue)
	self.curValue = curValue
	self.switchKey = switchKey
	self.fields.Text_content:setString(curValue.content)
	self.fields.Button_switch:setCallBack(handler(self, self.onSwitchCallBack))
	self.fields.Button_switch:setVal(self:getConfigValue())
end
function commonSettingSwitch:getConfigValue()
	local func = self["getConfigValue_" .. self.switchKey]
	if func then
		return func(self)
	elseif configKeyTable[self.switchKey] then
		configKeyTable = nil
		;(nil).byUID = configKeyTable[self.switchKey].byUID
		return SoraDConfigGet(configKeyTable[self.switchKey][1], nil)
	end
end
function commonSettingSwitch:getConfigValue_equip()
	return equipmentCtrl:isEquipmentShow()
end
function commonSettingSwitch:getConfigValue_noMarchingLine()
	return settingCtrl:getQueueShowSwitch() == 0 and true or false
end
function commonSettingSwitch:getConfigValue_noMarchingSolider()
	return settingCtrl:getQueueShowSolider() == 0 and true or false
end
function commonSettingSwitch:getConfigValue_photo()
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	return SoraDConfigGet(configKeyTable[self.switchKey][1], nil) == 1
end
function commonSettingSwitch:getConfigValue_showGiftNickName()
	return not settingCtrl:isHideAllianceGiftMailNickname()
end
function commonSettingSwitch:getConfigValue_showGiftName()
	return not settingCtrl:isHideAllianceGiftMailGiftName()
end
function commonSettingSwitch:onSwitchCallBack(type)
	print("self.switchKey", self.switchKey)
	local func = self["setConfigValue_" .. self.switchKey]
	if func then
		return func(self, type)
	else
		if self.curValue.flag then
			self:funToSaveServer(type, self.curValue.flag)
		end
		if configKeyTable[self.switchKey] then
			_ENV = self.curValue.flag
			self.curValue.flag.byUID = configKeyTable[self.switchKey].byUID
			SoraDConfigSet(configKeyTable[self.switchKey][1], type, self.curValue.flag)
		end
	end
end
function commonSettingSwitch:setConfigValue_noDisturb(type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	if type then
		noticeCtrl:openNotDisturb()
		SoraDShowMsgTip(i18n("common_text_1071"))
	else
		noticeCtrl:closeNotDisturb()
		SoraDShowMsgTip(i18n("common_text_1072"))
	end
end
function commonSettingSwitch:setConfigValue_equip(type)
	equipmentCtrl:setEquipmentShowOrHideRsp(type)
end
function commonSettingSwitch:setConfigValue_night(type)
	print("GameOptionsView:btnNightClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	if type then
		SoraDShowMsgTip(i18n("common_text_2012"))
	else
		SoraDShowMsgTip(i18n("common_text_2013"))
	end
	_ENV = i18n("common_text_2013")
	i18n("common_text_2013").msg = "MESSAGE_MAINCITYVIEW_UPDATE_NIGHT_CFG"
	SoraDSendMessage(i18n("common_text_2013"))
end
function commonSettingSwitch:setConfigValue_noMarchingLine(type)
	print("GameOptionsView:btnNoLineClick", type)
	settingCtrl:setQueueShowSwitch(type and 0 or 1)
	_ENV = type and 0 or 1
	;(type and 0 or 1).enable = type
	userSDKManager.logEvent(gSDKDef.TDonEvent.game_option_noline, type and 0 or 1)
end
function commonSettingSwitch:setConfigValue_noMarchingSolider(type)
	print("GameOptionsView:btnNoLineSoldier", type)
	settingCtrl:setQueueShowSolider(type and 0 or 1)
end
function commonSettingSwitch:setConfigValue_warSmoke(type)
	print("GameOptionsView:btnNoSmokeClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	_ENV = configKeyTable[self.switchKey][1]
	configKeyTable[self.switchKey][1].msg = "MESSAGE_WORLD_MAP_ENEMY_CASTLE_EFFECT"
	SoraDSendMessage(configKeyTable[self.switchKey][1])
end
function commonSettingSwitch:setConfigValue_shake(type)
	print("GameOptionsView:btnShakeClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	if type then
		SoraDShowMsgTip(i18n("common_text_2840"))
	else
		SoraDShowMsgTip(i18n("common_text_2841"))
	end
	_ENV = i18n("common_text_2841")
	i18n("common_text_2841").msg = "MESSAGE_MAINCITYVIEW_SHAKE_CONTROL"
	SoraDSendMessage(i18n("common_text_2841"))
end
function commonSettingSwitch:setConfigValue_showGiftNickName(type)
	print("GameOptionsView:btnGiftClick", type)
	if type then
		settingCtrl:showAllianceGiftMailNickname()
	else
		settingCtrl:hideAllianceGiftMailNickname()
	end
end
function commonSettingSwitch:setConfigValue_showGiftName(oType)
	print("GameOptionsView:btnGiftNameClick", oType)
	if oType then
		settingCtrl:showAllianceGiftMailGiftName()
	else
		settingCtrl:hideAllianceGiftMailGiftName()
	end
end
function commonSettingSwitch:setConfigValue_showBuildName(type)
	print("GameOptionsView:btnBuildClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	if type then
		SoraDShowMsgTip(i18n("common_text_3519"))
	else
		SoraDShowMsgTip(i18n("common_text_3520"))
	end
end
function commonSettingSwitch:setConfigValue_hideCastleWarLvEffect(type)
	print("GameOptionsView:btnBuildClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	_UPVALUE2_ = configKeyTable[self.switchKey][1]
	configKeyTable[self.switchKey][1][1] = configKeyTable[self.switchKey][1]
	configKeyTable[self.switchKey][1][2] = type
	dump(configKeyTable[self.switchKey][1], "setConfigValue_hideCastleWarLvEffect")
	_ENV = configKeyTable[self.switchKey][1]
	configKeyTable[self.switchKey][1].msg = "MESSAGE_LOCAL_OPTION_CATLE_WAR_LV_SHOW"
	SoraDSendMessage(configKeyTable[self.switchKey][1])
end
function commonSettingSwitch:setConfigValue_demension(type)
	print("GameOptionsView:btnDemensionClick", type)
end
function commonSettingSwitch:setConfigValue_lod(type)
	print("GameOptionsView:btnLodClick", type)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("nebula_war_text_0194"))
		self.fields.Button_switch:setVal(not type)
		return
	end
	_ENV = i18n("nebula_war_text_0194")
	i18n("nebula_war_text_0194").byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, i18n("nebula_war_text_0194"))
	local worldMapUtil = include("worldMapUtil")
	worldMapUtil.setLodOpen(type)
end
function commonSettingSwitch:setConfigValue_priority(type)
	print("commonSettingSwitchView:btnPriorityClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	local worldMapUtil = include("worldMapUtil")
	worldMapUtil.setTroopPriority(type)
end
function commonSettingSwitch:setConfigValue_photo(type)
	print("commonSettingSwitchView:setConfigValue_photo", type)
	self.boolShowShareBtn = type
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], self.boolShowShareBtn and 1 or 2, nil)
	if self.boolShowShareBtn then
		SoraDShowMsgTip(i18n("screen_text_07"))
	else
		SoraDShowMsgTip(i18n("screen_text_06"))
	end
	_ENV = i18n("screen_text_06")
	i18n("screen_text_06").msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
	SoraDSendMessage(i18n("screen_text_06"))
end
function commonSettingSwitch:setConfigValue_recharge(switchType)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], switchType, nil)
	GLOBAL_GAME_RECHARGE_MODE = switchType
	_ENV = switchType
	switchType.choose = GLOBAL_GAME_RECHARGE_MODE and 2 or 1
	userSDKManager.logEvent(gSDKDef.TDonEvent.recharge_interface_selection, switchType)
end
function commonSettingSwitch:setConfigValue_bindPhone(type)
	print("commonSettingSwitchView:btnBindPhoneClick", type)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], type, nil)
	_ENV = configKeyTable[self.switchKey][1]
	configKeyTable[self.switchKey][1].msg = "MESSAGE_LORDINFO_BIND_AWARD"
	SoraDSendMessage(configKeyTable[self.switchKey][1])
end
function commonSettingSwitch:setConfigValue_event(type)
	if type then
		SoraDShowMsgBoxNew(i18n("common_text_4806"), i18n("common_text_204"), i18n("common_text_185"), function(exitType, other)
			if tolua.isnull(self) then
				return
			end
			if exitType ~= MSGBOX_CALLBACK_YES then
				self.fields.Button_switch:setVal(not type)
				return
			end
			if self.curValue.flag then
				self:funToSaveServer(type, self.curValue.flag)
			end
			if configKeyTable[self.switchKey] then
				_ENV = self.curValue.flag
				self.curValue.flag.byUID = configKeyTable[self.switchKey].byUID
				SoraDConfigSet(configKeyTable[self.switchKey][1], type, self.curValue.flag)
			end
		end)
	else
		if self.curValue.flag then
			self:funToSaveServer(type, self.curValue.flag)
		end
		if configKeyTable[self.switchKey] then
			_ENV = self.curValue.flag
			self.curValue.flag.byUID = configKeyTable[self.switchKey].byUID
			SoraDConfigSet(configKeyTable[self.switchKey][1], type, self.curValue.flag)
		end
	end
end
function commonSettingSwitch:funToSaveServer(arg, flag)
	if arg then
		noticeCtrl:openNoticeStatus(flag)
	else
		noticeCtrl:closeNoticeStatus(flag)
	end
end
function commonSettingSwitch:setIsNeedToSave(isNeedToSave)
	self.isNeedToSave = isNeedToSave
end
function commonSettingSwitch:onHide()
	if self.isNeedToSave then
		self:saveLocalSettings()
	end
end
function commonSettingSwitch:setVal(value)
	self.fields.Button_switch:setVal(value)
end
function commonSettingSwitch:saveLocalSettings()
	_ENV = self
	self.byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], self:getConfigValue(), self)
end
function commonSettingSwitch:initLabelAndSwitch(curValue, curConfigValue)
	self.fields.Text_content:setString(curValue.content)
	self.fields.Button_switch:setCallBack(curValue.handle)
	self.fields.Button_switch:setVal(curConfigValue)
end
return commonSettingSwitch
