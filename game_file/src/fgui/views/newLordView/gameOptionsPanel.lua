local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameOptionsPanel = class("gameOptionsPanel", baseFguiPanel)
function gameOptionsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameOptionsPanel:ctor", self.viewName)
end
_ENV, gameOptionsPanel.getPackageList = function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).COMMON = 1
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).VIEW = 2
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).OPERATION = 3
local (function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).OTHER, SETTING_TYPE = 4, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameOptionsPanel:onInit()
	print("=======gameOptionsPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_713"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.localSettingTable, _ENV = self.fields.List.setItemRenderer, self.fields.List.setItemRenderer
	lordInfoCtrl, _ENV, _UPVALUE3_ = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).tabName, handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).tabName, handler(self, self.onItemRederer)[2] = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).title = i18n("common_text_920")
	handler(self, self.onItemRederer).content = nil
	handler(self, self.onItemRederer).setType = "slider"
	SETTING_TYPE, _ENV, handler(self, self.onItemRederer).isNeedToSave = "common_text_920", i18n("common_text_920"), true
	i18n("common_text_920").tabName, ("common_text_920")[1] = "common_text_920", "quality"
	i18n("common_text_920").title = i18n("common_text_4814")
	i18n("common_text_920").content = nil
	i18n("common_text_920").setType = "quality"
	SETTING_TYPE, _ENV, i18n("common_text_920").isNeedToSave = "common_text_4814", i18n("common_text_4814"), true
	i18n("common_text_4814").tabName, ("common_text_4814")[1] = "common_text_4814", "inputBox"
	i18n("common_text_4814").title = i18n("common_text_4862")
	i18n("common_text_4814").content = nil
	SETTING_TYPE, SETTING_TYPE, i18n("common_text_4814").setType = "common_text_4862", i18n("common_text_4862"), "choose"
	;("common_text_4862")[1] = i18n("common_text_4863")
	;("common_text_4862")[2] = i18n("common_text_4864")
	;("common_text_4862")[3] = i18n("common_text_4864")
	;("common_text_4862")[4] = i18n("common_text_4864")
	;("common_text_4862")[5] = i18n("common_text_4864")
	;("common_text_4862")[6] = i18n("common_text_4864")
	;("common_text_4862")[7] = i18n("common_text_4864")
	;("common_text_4862")[8] = i18n("common_text_4864")
	;("common_text_4862")[9] = i18n("common_text_4864")
	;("common_text_4862")[10] = i18n("common_text_4864")
	;("common_text_4862")[11] = i18n("common_text_4864")
	;("common_text_4862")[12] = i18n("common_text_4864")
	;("common_text_4862")[13] = i18n("common_text_4864")
	;("common_text_4862")[14] = i18n("common_text_4864")
	i18n("common_text_4814").data, i18n("common_text_4862")[1] = i18n("common_text_4862"), "common_text_4862"
	self.localSettingTable[SETTING_TYPE.COMMON], handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.COMMON], handler(self, self.onItemRederer)[2] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.COMMON], handler(self, self.onItemRederer)[3] = handler(self, self.onItemRederer)
	SETTING_TYPE, _ENV, _UPVALUE8_ = i18n("common_text_920"), handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).tabName, i18n("common_text_920")[1] = i18n("common_text_920"), "equip"
	handler(self, self.onItemRederer).title = i18n("common_text_1295")
	handler(self, self.onItemRederer).content = i18n("common_text_1296")
	SETTING_TYPE, _ENV, handler(self, self.onItemRederer).isEquip = "common_text_1296", i18n("common_text_1296"), true
	i18n("common_text_1296").tabName, ("common_text_1296")[1] = "common_text_1296", "night"
	i18n("common_text_1296").title = i18n("common_text_2010")
	i18n("common_text_1296").content = i18n("common_text_2011")
	lordInfoCtrl, _ENV, i18n("common_text_1296").isNeedToSave = "common_text_2011", i18n("common_text_2011"), true
	i18n("common_text_2011").tabName, ("common_text_2011")[1] = "common_text_2011", "noMarchingLine"
	i18n("common_text_2011").tabName, ("common_text_2011")[2] = "common_text_2011", "noMarchingSolider"
	i18n("common_text_2011").title = i18n("common_text_2423")
	_ENV, lordInfoCtrl, i18n("common_text_2011").setType = "common_text_2423", i18n("common_text_2423"), "switch_march"
	_ENV, ("common_text_2423").content = i18n("common_text_2424"), i18n("common_text_2424")
	i18n("common_text_2424").content = i18n("set_up_des_01")
	SETTING_TYPE, _ENV, i18n("common_text_2011").data, i18n("common_text_2423")[1] = "common_text_2423", i18n("common_text_2423"), i18n("common_text_2423"), "common_text_2423"
	SETTING_TYPE, _ENV, i18n("common_text_2011").data, i18n("common_text_2423")[2] = "common_text_2423", i18n("common_text_2423"), i18n("common_text_2423"), i18n("common_text_2424")
	i18n("common_text_2423").tabName, ("common_text_2423")[1] = "common_text_2423", "noSwitch"
	i18n("common_text_2423").title = i18n("common_text_2551")
	SETTING_TYPE, _ENV, i18n("common_text_2423").content = "common_text_2552", i18n("common_text_2552"), i18n("common_text_2552")
	i18n("common_text_2552").tabName, ("common_text_2552")[1] = "common_text_2552", "warSmoke"
	i18n("common_text_2552").title = i18n("common_text_2630")
	lordInfoCtrl, _ENV, i18n("common_text_2552").content = "common_text_2631", i18n("common_text_2631"), i18n("common_text_2631")
	i18n("common_text_2631").tabName, ("common_text_2631")[1] = "common_text_2631", "showGiftNickName"
	i18n("common_text_2631").tabName, ("common_text_2631")[2] = "common_text_2631", "showGiftName"
	i18n("common_text_2631").title = i18n("common_text_3357")
	_ENV, lordInfoCtrl, i18n("common_text_2631").setType = "common_text_3357", i18n("common_text_3357"), "switch_march"
	_ENV, ("common_text_3357").content = i18n("common_text_3358"), i18n("common_text_3358")
	i18n("common_text_3358").content = i18n("set_text_09")
	SETTING_TYPE, _ENV, i18n("common_text_2631").data, i18n("common_text_3357")[1] = "common_text_3357", i18n("common_text_3357"), i18n("common_text_3357"), "common_text_3357"
	SETTING_TYPE, _ENV, i18n("common_text_2631").data, i18n("common_text_3357")[2] = "common_text_3357", i18n("common_text_3357"), i18n("common_text_3357"), i18n("common_text_3358")
	i18n("common_text_3357").tabName, ("common_text_3357")[1] = "common_text_3357", "showBuildName"
	i18n("common_text_3357").title = i18n("common_text_3504")
	SETTING_TYPE, _ENV, i18n("common_text_3357").content = "common_text_3505", i18n("common_text_3505"), i18n("common_text_3505")
	i18n("common_text_3505").tabName, ("common_text_3505")[1] = "common_text_3505", "hideCastleWarLvEffect"
	i18n("common_text_3505").title = i18n("common_text_4830")
	i18n("common_text_3505").content = i18n("common_text_4829")
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[2] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[3] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[4] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[5] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[6] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[7] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.VIEW], handler(self, self.onItemRederer)[8] = handler(self, self.onItemRederer)
	SETTING_TYPE, _ENV, _UPVALUE3_ = i18n("common_text_1296"), handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).tabName, i18n("common_text_1296")[1] = i18n("common_text_1296"), "lod"
	handler(self, self.onItemRederer).title = i18n("common_text_4583")
	SETTING_TYPE, _ENV, handler(self, self.onItemRederer).content = "common_text_4584", i18n("common_text_4584"), i18n("common_text_4584")
	i18n("common_text_4584").tabName, ("common_text_4584")[1] = "common_text_4584", "shake"
	i18n("common_text_4584").title = i18n("common_text_2831")
	SETTING_TYPE, _ENV, i18n("common_text_4584").content = "common_text_2832", i18n("common_text_2832"), i18n("common_text_2832")
	i18n("common_text_2832").tabName, ("common_text_2832")[1] = "common_text_2832", "priority"
	i18n("common_text_2832").title = i18n("common_text_4349")
	i18n("common_text_2832").content = i18n("common_text_4350")
	self.localSettingTable[SETTING_TYPE.OPERATION], handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.OPERATION], handler(self, self.onItemRederer)[2] = handler(self, self.onItemRederer)
	self.localSettingTable[SETTING_TYPE.OPERATION], handler(self, self.onItemRederer)[3] = handler(self, self.onItemRederer)
	SETTING_TYPE, _ENV, SETTING_TYPE = i18n("common_text_4584"), handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).tabName, i18n("common_text_4584")[1] = i18n("common_text_4584"), "photo"
	handler(self, self.onItemRederer).title = i18n("screen_title_01")
	handler(self, self.onItemRederer).content = i18n("screen_text_04")
	self.localSettingTable[SETTING_TYPE.OTHER], handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
	if SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.ANCHOR_ENTER_ROOM) then
		SETTING_TYPE, _ENV = handler(self, self.onItemRederer)
		SETTING_TYPE.VIEW.tabName, handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
		SETTING_TYPE.VIEW.title = i18n("privilege_text_115")
		SETTING_TYPE.VIEW.content = i18n("privilege_text_116")
		table.insert(self.localSettingTable[SETTING_TYPE.VIEW], SETTING_TYPE.VIEW)
	end
	if worldMapDefine.isInNebula() then
		SETTING_TYPE, _ENV = i18n("privilege_text_116"), SETTING_TYPE.VIEW
		SETTING_TYPE.VIEW.tabName, i18n("privilege_text_116")[1] = i18n("privilege_text_116"), "shieldNebula"
		SETTING_TYPE.VIEW.title = i18n("nebula_war_text_0338")
		SETTING_TYPE.VIEW.content = i18n("nebula_war_text_0339")
		table.insert(self.localSettingTable[SETTING_TYPE.VIEW], SETTING_TYPE.VIEW)
	end
	local isPhoneBind = userSDKManager.returnAccountBindType(gSDKDef.platformType.mobile)
	local isBindPhone = lordInfoCtrl:getBaseInfo().receiveBindPhone or false
	if IsArClient and SoraDGetCastleLv() >= CASTLE_LV10_LIMITED and not isPhoneBind then
		SETTING_TYPE, _ENV = "screen_text_04", SETTING_TYPE.OTHER
		SETTING_TYPE.OTHER.tabName, ("screen_text_04")[1] = "screen_text_04", "bindPhone"
		SETTING_TYPE.OTHER.title = i18n("bind_phone_text_04")
		SETTING_TYPE.OTHER.content = i18n("bind_phone_text_05")
		table.insert(self.localSettingTable[SETTING_TYPE.OTHER], SETTING_TYPE.OTHER)
	end
	if worldMapDefine.isInAnchorMode() then
		_UPVALUE5_ = worldMapDefine.isInAnchorMode()
		worldMapDefine.isInAnchorMode()[1] = "music"
		worldMapDefine.isInAnchorMode()[2] = "priority"
		worldMapDefine.isInAnchorMode()[3] = "lod"
		worldMapDefine.isInAnchorMode()[4] = "noMarchingLine"
		local worldMapDefine.isInAnchorMode()[5], setKeys = "noMarchingSolider", worldMapDefine.isInAnchorMode()
		local _ENV, settingTable = "music", "music"
		for i, v in ipairs(setKeys) do
			for m, n in pairs(self.localSettingTable) do
				if not settingTable[m] then
					_ENV = settingTable[m]
				end
				settingTable[m] = settingTable[m]
				for k2, v2 in pairs(n) do
					if v == v2.tabName[1] then
						table.insert(settingTable[m], v2)
						break
					end
				end
			end
		end
		self.localSettingTable = settingTable
	end
	SETTING_TYPE, _ENV = ipairs(setKeys)
	SETTING_TYPE.VIEW.tabName, ipairs(setKeys)[1] = ipairs(setKeys)
	SETTING_TYPE.VIEW.title = i18n("common_text_4790")
	SETTING_TYPE.VIEW.content = i18n("common_text_4791")
	table.insert(self.localSettingTable[SETTING_TYPE.VIEW], SETTING_TYPE.VIEW)
	self:clearUnOpenCfg()
	local jumpName = self.proxy.param and self.proxy.param.jumpName or nil
	local defaultClick = 1
	self.scrollToIdx = nil
	if jumpName then
		for k, v in ipairs(self.localSettingTable) do
			for k2, v2 in ipairs(v) do
				if v2.tabName[1] == jumpName then
					defaultClick = k
					self.scrollToIdx = k2
					break
				end
			end
		end
	end
	_ENV, _ENV, self.ccs_tab = ipairs(self.localSettingTable)
	ipairs(self.localSettingTable).title = i18n("common_text_4813")
	_ENV, self.fields.com_Tab[1], ipairs(self.localSettingTable).tag = ipairs(self.localSettingTable)
	ipairs(self.localSettingTable).title = i18n("common_text_4812")
	_ENV, self.fields.com_Tab[2], ipairs(self.localSettingTable).tag = ipairs(self.localSettingTable)
	ipairs(self.localSettingTable).title = i18n("common_text_4811")
	_ENV, self.fields.com_Tab[3], ipairs(self.localSettingTable).tag = ipairs(self.localSettingTable)
	ipairs(self.localSettingTable).title = i18n("common_text_4810")
	_ENV, self.tabsetArray, self.fields.com_Tab[4], ipairs(self.localSettingTable).tag = self.fields.com_Tab, self.fields.com_Tab, ipairs(self.localSettingTable)
	self.fields.com_Tab.tabNum = 2
	self.fields.com_Tab.defaultClick = defaultClick
	self.fields.com_Tab.tabsetArray = self.tabsetArray
	local self.fields.com_Tab.callback, param = handler(self, self.onClickTab), self.fields.com_Tab
	self.ccs_tab:initView(param)
end
function gameOptionsPanel:onClickTab(tag)
	dump(tag, "gameOptionsPanel:onClickTab")
	self.curTag = tag
	self.fields.List:setNumItems(#self.localSettingTable[tag])
	if self.scrollToIdx then
		self.fields.List:scrollToView(self.scrollToIdx - 1)
		self.scrollToIdx = nil
	end
end
function gameOptionsPanel:clearUnOpenCfg()
	if not commonCheck.SCREEN_SHOT then
		local removeK
		for k, v in ipairs(self.localSettingTable) do
			for k2, v2 in ipairs(v) do
				if v2.tabName[1] == "photo" then
					table.remove(v, k2)
					removeK = true
					break
				end
			end
			if removeK then
				break
			end
		end
	end
end
function gameOptionsPanel:onShow()
	print("=======gameOptionsPanel:onShow")
end
function gameOptionsPanel:endShow()
	local showRechargeFinger = self.proxy.param and self.proxy.param.showRechargeFinger
	if showRechargeFinger then
		local target
		for i, v in ipairs(self.localSettingTable[self.curTag]) do
			if SoraDisInList("recharge", v.tabName) then
				target = self.fields.List:getChildAt(i - 1):getChild("List"):getChildAt(0):getChild("Button_switch")
			end
		end
		if target then
			_ENV = nil
			gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(target, nil)
		end
	end
end
function gameOptionsPanel:onItemRederer(index, target)
	target:initData(self.localSettingTable[self.curTag][index + 1])
end
function gameOptionsPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "VIEW" then
		for i, v in ipairs(self.tabsetArray) do
			if v.tag == SETTING_TYPE.VIEW then
				return self.ccs_tab:getBtn(i)
			end
		end
	elseif itemName == "recharge" then
		for i, v in ipairs(self.localSettingTable[self.curTag]) do
			if SoraDisInList("recharge", v.tabName) then
				self.fields.List:scrollToView(i - 1)
				return self.fields.List:getChildAt(i - 1)
			end
		end
	end
end
return gameOptionsPanel
