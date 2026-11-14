local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameSettingViewPanel = class("gameSettingViewPanel", baseFguiPanel)
function gameSettingViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameSettingViewPanel:ctor", self.viewName)
end
function gameSettingViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameSettingViewPanel:onInit()
	print("=======gameSettingViewPanel:onInit")
	self.showList, _ENV, self.settingList, _ENV = print, print, print, print
	self.fields.Com_title:initData(i18n("common_text_713"), handler(self, self.onClickClose))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeLast(function(strTime)
		return os.date("!%Y-%m-%d %H:%M:%S", serviceFunctions.systemTime())
	end)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function gameSettingViewPanel:onShow()
	print("=======gameSettingViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.Text_time:beginTime(serviceFunctions.systemTime(), true)
	_ENV = self.Text_time.beginTime
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.account
	serviceFunctions.systemTime().str = i18n("common_text_714")
	self.Text_time.beginTime[GameSettingKey.account], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_account.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.language
	serviceFunctions.systemTime().str = i18n("common_text_715")
	self.Text_time.beginTime[GameSettingKey.language], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_language2.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.explain
	serviceFunctions.systemTime().str = i18n("common_text_716")
	self.Text_time.beginTime[GameSettingKey.explain], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_explain.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.message
	serviceFunctions.systemTime().str = i18n("common_text_717")
	self.Text_time.beginTime[GameSettingKey.message], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_message.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.seting
	serviceFunctions.systemTime().str = i18n("common_text_718")
	self.Text_time.beginTime[GameSettingKey.seting], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_seting2.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.invite
	serviceFunctions.systemTime().str = i18n("common_text_189")
	self.Text_time.beginTime[GameSettingKey.invite], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_invite.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.search
	serviceFunctions.systemTime().str = i18n("common_text_166")
	self.Text_time.beginTime[GameSettingKey.search], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_search_01.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.fans
	serviceFunctions.systemTime().str = i18n("common_text_719")
	self.Text_time.beginTime[GameSettingKey.fans], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_fans.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.shield
	serviceFunctions.systemTime().str = i18n("common_text_720")
	self.Text_time.beginTime[GameSettingKey.shield], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_shield.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.key
	serviceFunctions.systemTime().str = i18n("common_text_721")
	self.Text_time.beginTime[GameSettingKey.key], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_key.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.feedback
	serviceFunctions.systemTime().str = i18n("common_text_1029")
	self.Text_time.beginTime[GameSettingKey.feedback], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_language.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.policy
	serviceFunctions.systemTime().str = i18n("common_text_2028")
	self.Text_time.beginTime[GameSettingKey.policy], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_bbs.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.replay
	serviceFunctions.systemTime().str = i18n("common_text_2297")
	self.Text_time.beginTime[GameSettingKey.replay], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_video.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.pyramidWar_desert
	serviceFunctions.systemTime().str = i18n("worldwar_text_12")
	self.Text_time.beginTime[GameSettingKey.pyramidWar_desert], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "btn_desert.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.pyramidWar_remains
	serviceFunctions.systemTime().str = i18n("offline_btn_01")
	self.Text_time.beginTime[GameSettingKey.pyramidWar_remains], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "btn_desert.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.back
	serviceFunctions.systemTime().str = i18n("worldwar_text_15")
	self.Text_time.beginTime[GameSettingKey.back], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "btn_back_castle.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.friend
	serviceFunctions.systemTime().str = i18n("friend_name_01")
	self.Text_time.beginTime[GameSettingKey.friend], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_friend.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.remains_mode_anchor
	serviceFunctions.systemTime().str = i18n("Anchor_btn_01")
	self.Text_time.beginTime[GameSettingKey.remains_mode_anchor], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "btn_anchor.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.remains_mode_player
	serviceFunctions.systemTime().str = i18n("Anchor_btn_02")
	self.Text_time.beginTime[GameSettingKey.remains_mode_player], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_playermode.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.remains_field
	serviceFunctions.systemTime().str = i18n("Anchor_btn_03")
	self.Text_time.beginTime[GameSettingKey.remains_field], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_changeround.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.dj_mode
	serviceFunctions.systemTime().str = i18n("Anchor_text_17")
	self.Text_time.beginTime[GameSettingKey.dj_mode], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "btn_livechat_enter.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.secondary_lock
	serviceFunctions.systemTime().str = i18n("Safety_lock_text_01")
	self.Text_time.beginTime[GameSettingKey.secondary_lock], serviceFunctions.systemTime().icon = serviceFunctions.systemTime(), "icon_set_erjisuo.png"
	_ENV = serviceFunctions.systemTime()
	serviceFunctions.systemTime().tag = GameSettingKey.verification_code
	serviceFunctions.systemTime().str = i18n("Safety_lock_text_16")
	self.settingList, self.Text_time.beginTime[GameSettingKey.verification_code], serviceFunctions.systemTime().icon = self.Text_time.beginTime, serviceFunctions.systemTime(), "icon_set_thirdparty.png"
	local _ENV, tagKey = self.Text_time.beginTime, self.Text_time.beginTime
	if worldMapDefine.isInAnchorMode() then
		_UPVALUE5_ = worldMapDefine.isInAnchorMode()
		tagKey, worldMapDefine.isInAnchorMode()[1] = worldMapDefine.isInAnchorMode(), GameSettingKey.account
		tagKey, worldMapDefine.isInAnchorMode()[2] = worldMapDefine.isInAnchorMode(), GameSettingKey.language
		tagKey, worldMapDefine.isInAnchorMode()[3] = worldMapDefine.isInAnchorMode(), GameSettingKey.seting
		tagKey, worldMapDefine.isInAnchorMode()[4] = worldMapDefine.isInAnchorMode(), GameSettingKey.remains_mode_player
		tagKey, worldMapDefine.isInAnchorMode()[5] = worldMapDefine.isInAnchorMode(), GameSettingKey.remains_field
	else
		_UPVALUE12_ = worldMapDefine.isInAnchorMode()
		tagKey, worldMapDefine.isInAnchorMode()[1] = worldMapDefine.isInAnchorMode(), GameSettingKey.account
		tagKey, worldMapDefine.isInAnchorMode()[2] = worldMapDefine.isInAnchorMode(), GameSettingKey.language
		tagKey, worldMapDefine.isInAnchorMode()[3] = worldMapDefine.isInAnchorMode(), GameSettingKey.explain
		tagKey, worldMapDefine.isInAnchorMode()[4] = worldMapDefine.isInAnchorMode(), GameSettingKey.message
		tagKey, worldMapDefine.isInAnchorMode()[5] = worldMapDefine.isInAnchorMode(), GameSettingKey.seting
		tagKey, worldMapDefine.isInAnchorMode()[6] = worldMapDefine.isInAnchorMode(), GameSettingKey.fans
		tagKey, worldMapDefine.isInAnchorMode()[7] = worldMapDefine.isInAnchorMode(), GameSettingKey.invite
		tagKey, worldMapDefine.isInAnchorMode()[8] = worldMapDefine.isInAnchorMode(), GameSettingKey.search
		tagKey, worldMapDefine.isInAnchorMode()[9] = worldMapDefine.isInAnchorMode(), GameSettingKey.shield
		tagKey, worldMapDefine.isInAnchorMode()[10] = worldMapDefine.isInAnchorMode(), GameSettingKey.key
		tagKey, worldMapDefine.isInAnchorMode()[11] = worldMapDefine.isInAnchorMode(), GameSettingKey.feedback
		tagKey, worldMapDefine.isInAnchorMode()[12] = worldMapDefine.isInAnchorMode(), GameSettingKey.policy
		if userSDKManager.isSupportReplay() then
			table.insert(tagKey, GameSettingKey.replay)
		end
		if userSDKManager.getIsSecondaryLockShow() then
			table.insert(tagKey, GameSettingKey.secondary_lock)
		end
		for k, v in ipairs(tagKey) do
			if v == GameSettingKey.invite and commonCheck.CLOSE_SETTING_INVITE then
				table.remove(tagKey, k)
			elseif v == GameSettingKey.key and commonCheck.CLOSE_SETTING_KEY and device.platform == "ios" then
				table.remove(tagKey, k)
			end
		end
		local pwStatus = pyramidWarCtrl:getPwXianXiaSaiStatus()
		if pwStatus == 1 then
			if pyramidWarCtrl:getIsInPwXianXiaSai() then
				table.insert(tagKey, GameSettingKey.pyramidWar_desert)
			else
				table.insert(tagKey, GameSettingKey.pyramidWar_remains)
			end
		elseif pwStatus == 2 then
			table.insert(tagKey, GameSettingKey.back)
		end
		if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			table.insert(tagKey, GameSettingKey.friend)
		end
		if worldMapDefine.isCanSwitchToAnchor() then
			table.insert(tagKey, GameSettingKey.remains_mode_anchor)
		end
		if IsArClient and djCtrl.isDJ and not worldMapDefine.isInGardenSystem() then
			table.insert(tagKey, GameSettingKey.dj_mode)
		end
	end
	for k, v in ipairs(tagKey) do
		table.insert(self.showList, self.settingList[v])
	end
	table.sort(self.showList, function(a, b)
		return a.tag < b.tag
	end)
	self.fields.List:setNumItems(#self.showList)
	local lineCount = math.ceil(#self.showList / 3)
	self.fields.List:setScrollEnable(lineCount * 178 + (lineCount - 1) * 14 > self.fields.List:getHeight())
end
function gameSettingViewPanel:onItemRenderer(index, obj)
	obj:initData(self.showList[index + 1])
end
function gameSettingViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "secondary_lock" then
		for i, v in ipairs(self.showList) do
			if v.tag == GameSettingKey.secondary_lock then
				return self.fields.List:getChildAt(i - 1)
			end
		end
	elseif itemName == "seting" then
		for i, v in ipairs(self.showList) do
			if v.tag == GameSettingKey.seting then
				return self.fields.List:getChildAt(i - 1):getBtnTouch()
			end
		end
	end
end
return gameSettingViewPanel
