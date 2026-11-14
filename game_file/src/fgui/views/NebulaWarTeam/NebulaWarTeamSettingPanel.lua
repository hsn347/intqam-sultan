local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamSettingPanel = class("NebulaWarTeamSettingPanel", baseFguiPanel)
_ENV = "NebulaWarTeamSettingPanel"
;("NebulaWarTeamSettingPanel").Dismiss = 1
;("NebulaWarTeamSettingPanel").ChangeName = 2
;("NebulaWarTeamSettingPanel").ChangeFlag = 3
local _ENV, ("NebulaWarTeamSettingPanel").Quit, BUTTON_TYPE = baseFguiPanel, 4, "NebulaWarTeamSettingPanel"
_ENV = nil
;(nil).name = "devilvalley_btn_16"
baseFguiPanel[BUTTON_TYPE.Dismiss], (nil).icon = nil, "icon_nebulawars_dissolution.png"
_ENV = nil
;(nil).name = "nebula_war_text_0027"
baseFguiPanel[BUTTON_TYPE.ChangeName], (nil).icon = nil, "icon_nebulawars_modify.png"
_ENV = nil
;(nil).name = "nebula_war_text_0028"
baseFguiPanel[BUTTON_TYPE.ChangeFlag], (nil).icon = nil, "icon_nebulawars_flag.png"
_ENV = nil
;(nil).name = "togetherTeam_text_27"
baseFguiPanel[BUTTON_TYPE.Quit], (nil).icon = nil, "icon_alliance_out.png"
local btnConfig = baseFguiPanel
function NebulaWarTeamSettingPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamSettingPanel:ctor", self.viewName)
	self.btnMap, _ENV, self.myTeamInfo = nebulaActivityCtrl:getMyTeamInfo(), nebulaActivityCtrl:getMyTeamInfo(), nebulaActivityCtrl:getMyTeamInfo()
end
function NebulaWarTeamSettingPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTeamSettingPanel:onInit()
	print("=======NebulaWarTeamSettingPanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_war_text_0025"), handler(self, self.onClickClose))
	if self.myTeamInfo:getIsSuperTeam() then
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0371"))
	end
	self:updateName()
	self:updateFlag()
	self.fields.Com_teamBase:setIsSuperTeam(self.myTeamInfo:getIsSuperTeam())
	self.fields.List_setting:setItemRenderer(handler(self, self.onSettingItemRederer))
	self.fields.List_setting:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.List_setting:setScrollEnable(false)
	if self.myTeamInfo:isTeamLeader() then
		_UPVALUE3_ = self.myTeamInfo:isTeamLeader()
		self.btnList, self.myTeamInfo:isTeamLeader()[1] = self.myTeamInfo:isTeamLeader(), BUTTON_TYPE.Dismiss
		self.btnList, self.myTeamInfo:isTeamLeader()[2] = self.myTeamInfo:isTeamLeader(), BUTTON_TYPE.ChangeName
		self.btnList, self.myTeamInfo:isTeamLeader()[3] = self.myTeamInfo:isTeamLeader(), BUTTON_TYPE.ChangeFlag
	else
		BUTTON_TYPE = self.myTeamInfo:isTeamLeader()
		self.btnList, self.myTeamInfo:isTeamLeader()[1] = self.myTeamInfo:isTeamLeader(), BUTTON_TYPE.Quit
	end
	if not nebulaWarUtil.checkSuperTeamSignUpState() then
		_ENV = BUTTON_TYPE.ChangeName
		self.btnMap[BUTTON_TYPE.Dismiss], BUTTON_TYPE.ChangeName.bright = BUTTON_TYPE.ChangeName, false
		_ENV = BUTTON_TYPE.ChangeName
		self.btnMap[BUTTON_TYPE.Quit], BUTTON_TYPE.ChangeName.bright = BUTTON_TYPE.ChangeName, false
	end
	self.fields.List_setting:setNumItems(#self.btnList)
end
function NebulaWarTeamSettingPanel:onShow()
	print("=======NebulaWarTeamSettingPanel:onShow")
end
function NebulaWarTeamSettingPanel:onSettingItemRederer(index, obj)
	local btnType = self.btnList[index + 1]
	obj:setString(i18n(btnConfig[btnType].name))
	obj:setIcon(btnConfig[btnType].icon)
	local _fields = fguiHelper.get_fields(obj)
	if self.btnMap[btnType] and self.btnMap[btnType].bright == false then
		_fields.Image_bg:setGrayed(true)
		_fields.icon:setGrayed(true)
	else
		_fields.Image_bg:setGrayed(false)
		_fields.icon:setGrayed(false)
	end
end
function NebulaWarTeamSettingPanel:onClickItem(EventContext)
	SoraDPlaySound()
	if worldMapDefine.isInNebula() then
		SoraDShowMsgTip(i18n("nebula_war_text_0194"))
		return
	end
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_setting:getChildIndex(obj)
	local itemIndex = childIndex
	local btnType = self.btnList[itemIndex + 1]
	if btnType == BUTTON_TYPE.Dismiss then
		if not nebulaWarUtil.checkQuitTeamState() then
			SoraDShowMsgTip(i18n("nebula_war_text_0512"))
			return
		end
		if self.myTeamInfo:getIsSignUpSuperTeam() then
			SoraDShowMsgTip(i18n("nebula_war_text_0528"))
			return
		end
		if 1 < self.myTeamInfo:getTeamMemberNum() then
			SoraDShowMsgTip(i18n("nebula_war_text_0029"))
			return
		end
		SoraDShowMsgBox(i18n("remains_text_34"), nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				self.myTeamInfo:reqTeamDismiss()
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.ChangeName then
		if not nebulaWarUtil.checkChangeTeamNameState() then
			SoraDShowMsgTip(i18n("nebula_war_text_0205"))
			return
		end
		_ENV = i18n("nebula_war_text_0205")
		i18n("nebula_war_text_0205").isChange = true
		i18n("nebula_war_text_0205").name = self.myTeamInfo:getTeamNameRaw()
		i18n("nebula_war_text_0205").abbr = self.myTeamInfo:getTeamAbbr()
		uiManager:show("NebulaWarTeamCreate", i18n("nebula_war_text_0205"))
	elseif btnType == BUTTON_TYPE.ChangeFlag then
		if not nebulaWarUtil.checkChangeTeamNameState() then
			SoraDShowMsgTip(i18n("nebula_war_text_0205"))
			return
		end
		uiManager:show("NebulaWarTeamChangeFlag")
	elseif btnType == BUTTON_TYPE.Quit then
		if not nebulaWarUtil.checkQuitTeamState() then
			SoraDShowMsgTip(i18n("nebula_war_text_0512"))
			return
		end
		SoraDShowMsgBox(i18n("nebula_war_text_0049"), nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				self.myTeamInfo:reqTeamQuit()
				SoraDShowLoading(self:displayObject())
			end
		end)
	end
end
function NebulaWarTeamSettingPanel:updateFlag(...)
	self.fields.Loader3D_flag:clearContent()
	local __, nodeFlag = allianceDesRead.getFlagWithParticle(self.myTeamInfo:getTeamFlag())
	self.fields.Loader3D_flag:setContent(nodeFlag)
end
function NebulaWarTeamSettingPanel:updateName(...)
	self.fields.Com_teamBase:setString(self.myTeamInfo:getTeamName())
end
return NebulaWarTeamSettingPanel
