local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamCreatePanel = class("NebulaWarTeamCreatePanel", baseFguiPanel)
function NebulaWarTeamCreatePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamCreatePanel:ctor", self.viewName)
end
function NebulaWarTeamCreatePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTeamCreatePanel:onInit()
	print("=======NebulaWarTeamCreatePanel:onInit")
	self.costGold = 200
	local Com_name = self.fields.Com_name
	self.fieldsName = fguiHelper.get_fields(Com_name)
	self.fieldsName.Text_name:setString(i18n("nebula_war_text_0019"))
	self.fieldsName.Input:setMaxLength(ALLIANCE_NAME_MAX)
	self.fieldsName.Input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputNameChanged))
	self.fieldsName.Input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onInputTextSubmit))
	_ENV = handler(self, self.onInputTextSubmit)
	handler(self, self.onInputTextSubmit).count = ALLIANCE_NAME_MAX
	self.fieldsName.Text_err:setString(i18n("common_text_364", handler(self, self.onInputTextSubmit)))
	local Com_abbr = self.fields.Com_abbr
	self.fieldsAbbr = fguiHelper.get_fields(Com_abbr)
	self.fieldsAbbr.Text_name:setString(i18n("free_team_text_37"))
	self.fieldsAbbr.Input:setMaxLength(ALLIANCE_NAME_MIN)
	self.fieldsAbbr.Input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputAbbrChanged))
	self.fieldsAbbr.Input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onInputTextSubmit))
	_ENV = handler(self, self.onInputTextSubmit)
	handler(self, self.onInputTextSubmit).count = ALLIANCE_NAME_MIN
	self.fieldsAbbr.Text_err:setString(i18n("common_text_364", handler(self, self.onInputTextSubmit)))
	self.fields.Button_create:addClickListener(handler(self, self.onClickBtnCreate))
end
function NebulaWarTeamCreatePanel:onShow()
	print("=======NebulaWarTeamCreatePanel:onShow")
	local param = self.proxy.param
	if param and param.isChange then
		self.isChange = true
		self.oldName = param.name
		self.oldAbbr = param.abbr
		self.fields.Panel_bg:setString(i18n("free_team_text_57"))
		self.fields.Button_create:setString(i18n("nebula_war_text_0220"))
		self.fields.Button_create:setCost(gIDDef.GOLD, 0)
		self.fields.Button_create:setEnabled(false)
		self.fieldsName.Input:setText(self.oldName)
		self.fieldsAbbr.Input:setText(self.oldAbbr)
	else
		self.fields.Panel_bg:setString(i18n("nebula_war_text_0221"))
		self.fields.Button_create:setString(i18n("remains_btn_04"))
		self.fields.Button_create:setCost(gIDDef.GOLD, self.costGold)
		self.fieldsName.Input:setPrompt(i18n("nebula_war_text_0021"))
		self.fieldsAbbr.Input:setPrompt(i18n("free_team_text_39"))
	end
end
function NebulaWarTeamCreatePanel:onInputNameChanged(...)
	local name = self.fieldsName.Input:getText()
	_ENV = nil
	;(nil).count = ALLIANCE_NAME_MAX - string.utf8len(name)
	self.fieldsName.Text_err:setString(i18n("common_text_364", nil))
end
function NebulaWarTeamCreatePanel:onInputTextSubmit(...)
	if self.isChange then
		local name = self.fieldsName.Input:getText()
		local abbr = self.fieldsAbbr.Input:getText()
		local isEnable = name ~= self.oldName or abbr ~= self.oldAbbr
		self.fields.Button_create:setEnabled(isEnable)
	end
end
function NebulaWarTeamCreatePanel:onInputAbbrChanged(...)
	local abbr = self.fieldsAbbr.Input:getText()
	_ENV = nil
	;(nil).count = ALLIANCE_NAME_MIN - string.utf8len(abbr)
	self.fieldsAbbr.Text_err:setString(i18n("common_text_364", nil))
end
function NebulaWarTeamCreatePanel:onClickBtnCreate(...)
	SoraDPlaySound()
	if not SoraDEnoughGold(self.costGold) then
		return
	end
	local name = self.fieldsName.Input:getText()
	local abbr = self.fieldsAbbr.Input:getText()
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if self.isChange then
		self.changeCount = 0
		if name ~= self.oldName then
			myTeamInfo:reqTeamSetName(name)
			self.changeCount = self.changeCount + 1
		end
		if abbr ~= self.oldAbbr then
			myTeamInfo:reqTeamSetAbbr(abbr)
			self.changeCount = self.changeCount + 1
		end
		if self.changeCount > 0 then
			SoraDShowLoading(self:displayObject())
		end
		return
	end
	local nebulaWarUtil = include("nebulaWarUtil")
	if not nebulaWarUtil.checkJoinTeamState() then
		SoraDShowMsgTip(i18n("nebula_war_text_0512"))
		self:closePanel()
		return
	end
	local teamDef = include("teamDef")
	_ENV = i18n("nebula_war_text_0512")
	i18n("nebula_war_text_0512").lenMax = ALLIANCE_NAME_MAX
	i18n("nebula_war_text_0512").lenMin = ALLIANCE_NAME_MIN
	local ok1, err1 = teamDef.namkVailidCheck(name, i18n("nebula_war_text_0512"))
	_ENV = i18n("nebula_war_text_0512")
	i18n("nebula_war_text_0512").lenMax = ALLIANCE_NAME_MIN
	i18n("nebula_war_text_0512").lenMin = ALLIANCE_NAME_MIN
	local ok2, err2 = teamDef.namkVailidCheck(abbr, i18n("nebula_war_text_0512"))
	if ok1 and ok2 then
		_ENV = i18n("nebula_war_text_0512")
		i18n("nebula_war_text_0512").name = name
		i18n("nebula_war_text_0512").abbr = abbr
		local i18n("nebula_war_text_0512").flag, areaData = 1, i18n("nebula_war_text_0512")
		myTeamInfo:reqTeamCreate(areaData)
		SoraDShowLoading(self:displayObject())
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0223"))
	end
end
function NebulaWarTeamCreatePanel:onMsgCreateBack(target, event)
	if self.isChange then
		return
	end
	SoraDCloseLoading(self:displayObject())
	if event.err == gErrDef.Err_None then
		self:closePanel()
	elseif event.err == gErrDef.Err_NEBULA_WAR_SIGN_UP then
		SoraDShowMsgTip(i18n("nebula_war_text_0370"))
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0223"))
	end
end
function NebulaWarTeamCreatePanel:onMsgChangeInfo(target, event)
	if not self.isChange then
		return
	end
	self.changeCount = self.changeCount - 1
	if self.changeCount ~= 0 then
		return
	end
	SoraDCloseLoading(self:displayObject())
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0033"))
		self:closePanel()
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0223"))
	end
end
return NebulaWarTeamCreatePanel
