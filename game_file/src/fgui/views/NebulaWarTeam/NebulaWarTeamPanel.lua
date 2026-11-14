local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamPanel = class("NebulaWarTeamPanel", baseFguiPanel)
_ENV = "NebulaWarTeamPanel"
;("NebulaWarTeamPanel").TYPE_TEAM = 1
;("NebulaWarTeamPanel").TYPE_WAR_ATK = 2
local ("NebulaWarTeamPanel").TYPE_WAR_DEF, VIEW_TYPE = 3, "NebulaWarTeamPanel"
function NebulaWarTeamPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaWarTeamPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWarHall"
	end
	return self._packageList
end
function NebulaWarTeamPanel:onInit()
	print("=======NebulaWarTeamPanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_war_text_0025"), handler(self, self.onClickClose))
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo:getIsSuperTeam() then
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0371"))
	elseif not nebulaWarUtil.checkSuperTeamSignUpState() then
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0593"))
	end
	self.fields.Button_setting:addClickListener(handler(self, self.onClickBtnSetting))
	local defaultClick = VIEW_TYPE.TYPE_TEAM
	if self.proxy.param and self.proxy.param.enterWarView then
		defaultClick = VIEW_TYPE.TYPE_WAR
	end
	_ENV = self.proxy.param.enterWarView
	_ENV, _ENV, self.proxy.param.enterWarView.defaultClick = handler(self, self.onClickBtnSetting)
	handler(self, self.onClickBtnSetting).title = i18n("remains_title_05")
	_ENV, handler(self, self.onClickBtnSetting)[1], handler(self, self.onClickBtnSetting).tag = handler(self, self.onClickBtnSetting)
	handler(self, self.onClickBtnSetting).title = i18n("common_text_008")
	_ENV, handler(self, self.onClickBtnSetting)[2], handler(self, self.onClickBtnSetting).tag = handler(self, self.onClickBtnSetting)
	handler(self, self.onClickBtnSetting).title = i18n("common_text_041")
	self.proxy.param.enterWarView.tabsetArray, handler(self, self.onClickBtnSetting)[3], handler(self, self.onClickBtnSetting).tag = handler(self, self.onClickBtnSetting)
	local self.proxy.param.enterWarView.callback, param = handler(self, self.onClickTab), self.proxy.param.enterWarView
	self.fields.com_Tab:initView(param)
	if not worldMapDefine.isInNebula() then
	end
	self.fields.Com_teamWar:initComboBox(self)
	self.fields.Com_teamWar:setRedDotUpdateCallback(handler(self, self.onRedDotUpdate), true)
end
function NebulaWarTeamPanel:onShow()
	print("=======NebulaWarTeamPanel:onShow")
end
function NebulaWarTeamPanel:onClickTab(tag)
	self.showViewType = tag
	if self.showViewType == VIEW_TYPE.TYPE_WAR then
	end
	local showTeamInfo = self.showViewType == 1
	self.fields.Com_teamWar:setVisible(not showTeamInfo)
	self.fields.Com_teamInfo:setVisible(showTeamInfo)
	if not showTeamInfo then
		VIEW_TYPE = self.fields.Com_teamInfo.setVisible
		self.fields.Com_teamInfo.setVisible[VIEW_TYPE.TYPE_WAR_ATK] = gAllianceQueueClassType.pvp
		local self.fields.Com_teamInfo.setVisible[VIEW_TYPE.TYPE_WAR_DEF], tabMap = gAllianceQueueClassType.pvp_def, self.fields.Com_teamInfo.setVisible
		self.fields.Com_teamWar:tabChange(tabMap[tag], true)
	end
end
function NebulaWarTeamPanel:onClickBtnSetting(EventContext)
	SoraDPlaySound()
	uiManager:show("NebulaWarTeamSetting")
end
function NebulaWarTeamPanel:onRedDotUpdate(tag, num)
	local tabIndex = 2
	if tag == gAllianceQueueClassType.pvp_def then
		tabIndex = 3
	end
	if not worldMapDefine.isInNebula() then
		return
	end
	self.fields.com_Tab:setBtnRedDot(tabIndex, 0 < num, string.formatnumberthousands(num))
end
return NebulaWarTeamPanel
