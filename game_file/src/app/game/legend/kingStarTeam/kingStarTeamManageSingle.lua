local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local scrollNode = include("scrollNode")
local legendTeamDef = include("legendTeamDef")
local legendTeamUtil = include("legendTeamUtil")
local teamManageType = legendTeamDef.TeamManageType
_ENV = nil
_ENV = nil
;(nil).name = "free_team_text_43"
;(nil).icon = "icon_alliance_list.png"
;(nil)[teamManageType.CHANGE_LEADER], (nil).fun = nil, function()
	local panel = SoraDCreatePanel("kingStarTeamChangeLeaderView")
	panel:show()
end
_ENV = nil
;(nil).name = "free_team_text_59"
;(nil).icon = "icon_alliance_out.png"
;(nil)[teamManageType.DISMISS], (nil).fun = nil, function()
	local err = legendTeamUtil.checkDismissTeam(worldMapDefine.KINGSTAR_KINGDOM_ID)
	if err == gErrDef.Err_None then
		SoraDShowMsgBox(i18n("remains_text_34"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				kingStarTeamCtrl:reqDismissTeam()
			end
		end)
	elseif err == gErrDef.Err_TEAM_NOT_IN_SELF_KID then
		SoraDShowMsgTip(i18n("free_team_text_62"))
	elseif err == gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER then
		SoraDShowMsgTip(i18n("free_team_text_64"))
	elseif err == gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("free_team_text_63"))
	else
		legendTeamUtil.errShowTips(err)
	end
end
_ENV = nil
;(nil).name = "free_team_text_60"
;(nil).icon = "icon_alliance_set.png"
;(nil)[teamManageType.VIEW_APPROLY], (nil).fun = nil, function()
	local panel = SoraDCreatePanel("kingStarTeamApprovalListView")
	panel:show()
end
_ENV = nil
;(nil).name = "free_team_text_61"
;(nil).icon = "icon_alliance_flag.png"
;(nil)[teamManageType.CHANGE_FLAG], (nil).fun = nil, function()
	local panel = SoraDCreatePanel("kingStarTeamChangeFlagView")
	panel:show()
end
local teamManageCfg
local getManageName = function(mID)
	return teamManageCfg[mID] and i18n(teamManageCfg[mID].name) or nil
end
local getManageIcon = function(mID, fromMemory)
	return teamManageCfg[mID].icon
end
local getManageFun = function(mID)
	return teamManageCfg[mID].fun
end
local kingStarTeamManageSingle = class("kingStarTeamManageSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingStarTeamManageSingle")
	end
	return target
end)
function kingStarTeamManageSingle:ctor()
	self.mid = 0
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnIcon = SoraDGetChildByName(self, "Button_icon")
	self.btnIcon:setSwallowTouches(false)
	self.spriteGreen = SoraDGetChildByName(self, "Sprite_green")
	self.spriteGreen:setVisible(false)
	if self.btnIcon then
		self.btnIcon = scrollNode.new(self.btnIcon)
		self.btnIcon:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function kingStarTeamManageSingle:onMessageListener()
	if self.mid == teamManageType.VIEW_APPROLY then
		SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateGreen))
	end
end
function kingStarTeamManageSingle:initData(data, otherData)
	self.mid = data and data.mid
	self.btnIcon:setScroll(otherData.scroll)
	self.spriteIcon:setSpriteFrame(getManageIcon(self.mid))
	self.labelName:setString(getManageName(self.mid))
	self:updateGreen()
end
function kingStarTeamManageSingle:updateGreen()
	if self.mid == teamManageType.VIEW_APPROLY then
		local isTeamApproval = kingStarTeamCtrl:isTeamHasApproval()
		local isNotFull = kingStarTeamCtrl:getTeamRemainNum() > 0
		self.spriteGreen:setVisible(isTeamApproval and isNotFull)
	end
end
function kingStarTeamManageSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local fun = getManageFun(self.mid)
		if fun then
			fun()
		end
	end
end
return kingStarTeamManageSingle
