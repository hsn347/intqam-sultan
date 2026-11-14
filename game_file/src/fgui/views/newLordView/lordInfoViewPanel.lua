local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local accountExtCtrl = SoraDGetCtrl("accountExtCtrl")
local lordLocalData = include("lordLocalData")
local achiDesRead = include("achiDesRead")
local militaryRankRead = include("militaryRankRead")
local lordOfficialRead = include("lordOfficialRead")
local funUnlockRead = include("funUnlockRead")
local chatConst = include("chatConst")
local legendTeamUtil = include("legendTeamUtil")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordInfoViewPanel = class("lordInfoViewPanel", baseFguiPanel)
function lordInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordInfoViewPanel:ctor", self.viewName)
end
function lordInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordInfoViewPanel:onInit()
	print("=======lordInfoViewPanel:onInit")
	self.copyUID = nil
	self.fields.Com_title:initData(i18n("common_text_368"), handler(self, self.onClickClose))
	self.fields.Com_head:setHandle(handler(self, self.btnHeadClickCallBack))
	self.fields.Image_headInfo:addClickListener(handler(self, self.onHeadMenuClick))
	self.fields.Button_copyUID:addClickListener(handler(self, self.btnCopyUIDClick))
	self.fields.Button_alliance:setString(i18n("common_text_069"))
	self.fields.Button_alliance:addClickListener(handler(self, self.btnAllianceClickCallBack))
	self.fields.Button_sendMail:setString(i18n("chat_text_69"))
	self.fields.Button_sendMail:addClickListener(handler(self, self.btnSendMailClickCallBack))
	self.fields.Com_head:fixPos()
	self.fields.Image_rafresh:fixPos()
	self.fields.Image_headInfo:fixPos()
	self.fields.Com_name:fixPos()
	self.fields.Text_kingdom:fixPos()
	self.fields.Text_uid:fixPos()
	self.fields.Button_copyUID:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_castleLv:fixPos()
	self.fields.Lab_power:fixPos()
	self.fields.Lab_completeness:fixPos()
	self.fields.Lab_kills:fixPos()
	self.fields.Lab_collect:fixPos()
	self.fields.Lab_killsHero:fixPos()
	self.fields.Button_alliance:fixPos()
	self.fields.Button_sendMail:fixPos()
end
function lordInfoViewPanel:onShow()
	print("=======lordInfoViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tablePlayerInfo = self.param and self.param.playerInfo or lordInfoCtrl:getLordInfo()
	self.isOwnData = self.tablePlayerInfo.base.uid == lordInfoCtrl:getLordInfo().base.uid
	if self.isOwnData then
		lordInfoCtrl:getLordBattleInfoReq()
	end
	self.controllers.c1:setSelectedIndex(self.isOwnData and 0 or 1)
	self:showPublicInfo()
end
function lordInfoViewPanel:showPublicInfo()
	self.fields.Com_head:setHeadSprite(self.tablePlayerInfo.base.imageId, self.tablePlayerInfo.base.avatar)
	self.fields.Image_rafresh:setVisible(self.isOwnData)
	self.fields.Com_name:initData(self.tablePlayerInfo, self.isOwnData)
	if self.tablePlayerInfo.base.sourceKid and self.tablePlayerInfo.base.sourceKid > 0 then
		_ENV = nil
		;(nil).kid = self.tablePlayerInfo.base.sourceKid
		self.fields.Text_kingdom:setString(i18n("common_text_342", nil))
	else
		_ENV = i18n("common_text_342", nil)
		i18n("common_text_342", nil).kid = self.tablePlayerInfo.base.partition
		self.fields.Text_kingdom:setString(i18n("common_text_342", i18n("common_text_342", nil)))
	end
	self.copyUID = self.isOwnData and accountExtCtrl:getAccountPid() or self.tablePlayerInfo.base.pid
	_ENV = i18n("common_text_342", i18n("common_text_342", nil))
	i18n("common_text_342", i18n("common_text_342", nil)).uid = self.copyUID
	self.fields.Text_uid:setString(i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))
	_ENV = i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))
	i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))).lv = self.tablePlayerInfo.base.level
	self.fields.Text_lv:setString(i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))
	self.fields.Text_castleLv:initData(self.tablePlayerInfo, self.isOwnData)
	_ENV = i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))
	i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))).power = string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc)
	self.fields.Lab_power:setString(i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))))
	_ENV = i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))
	i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))).val = string.format("%.2f%%", self.tablePlayerInfo.achieveInfo.doneRatio)
	self.fields.Lab_completeness:setString(i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))))
	_ENV = i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))))
	i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))).kills = string.formatnumberthousands(self.tablePlayerInfo.fcInfo.killCount)
	self.fields.Lab_kills:setString(i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))))))
	_ENV = i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))))
	i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))))).val = string.formatnumberthousands(self.tablePlayerInfo.achieveInfo.metalNum)
	self.fields.Lab_collect:setString(i18n("common_text_1979", i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))))))
	_ENV = i18n("common_text_1979", i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))))))
	i18n("common_text_1979", i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil)))))))).num = string.formatnumberthousands(self.tablePlayerInfo.fcInfo.killHeroCount)
	self.fields.Lab_killsHero:setString(i18n("prison_text_22", i18n("common_text_1979", i18n("common_text_344", i18n("common_text_1978", i18n("common_text_710", i18n(IsArClient and "common_text_2485" or "common_text_2485_ros", i18n("common_text_1041", i18n("common_text_342", i18n("common_text_342", nil))))))))))
	self.fields.Com_info:initData(self.tablePlayerInfo)
	self:updateBtn()
end
function lordInfoViewPanel:updateBtn()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local kid = self.tablePlayerInfo.base.partition or 0
	local teamId = self.tablePlayerInfo.base.teamId
	if teamId and worldMapDefine.isLegendLordKingdomID(kid) then
		self.fields.Button_alliance:setEnabled(true)
		self.fields.Button_alliance:setString(i18n("remains_text_85"))
	elseif worldMapDefine.isInTeamWarForbid() then
		self.fields.Button_alliance:setEnabled(false)
	else
		self.fields.Button_alliance:setEnabled(true)
		self.fields.Button_alliance:setString(i18n("common_text_069"))
		local aid = tonumber(self.tablePlayerInfo.aid)
		if aid == nil or kid ~= lordInfoCtrl:getLordInfo().base.partition then
			if allianceMgr:hasJoinAlliance() and ownRank >= gAllianceRank.R4 and kid == lordInfoCtrl:getLordInfo().base.partition and self.tablePlayerInfo.base.sourceKid == 0 then
				self.fields.Button_alliance:setString(i18n("common_text_202"))
			else
				self.fields.Button_alliance:setEnabled(false)
			end
		end
		if kid ~= lordInfoCtrl:getLordInfo().base.partition then
			self.fields.Button_alliance:setEnabled(false)
		end
	end
	self.fields.Image_headInfo:setVisible(not self.isOwnData and self.tablePlayerInfo.base.avatar and self.tablePlayerInfo.base.avatar ~= "")
	self.fields.Com_head:setTouchEnabled(self.isOwnData or not self.isOwnData and self.fields.Image_headInfo:isVisible())
end
function lordInfoViewPanel:updateLordInfo(target, data)
	if self.isOwnData then
		self.tablePlayerInfo = lordInfoCtrl:getLordInfo()
		self:showPublicInfo()
	end
end
function lordInfoViewPanel:sMsgDismissTitleBack(target, data)
end
function lordInfoViewPanel:serverMessageGetLordInfo(target, data)
	_ENV = nil
	;(nil).otherData = data.data
	uiManager:show("honourWallView", nil)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_HONOUR_BY_UID")
end
function lordInfoViewPanel:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	SoraDOpenAllianceInfoView(data.alliance)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK")
end
function lordInfoViewPanel:btnHeadClickCallBack()
	SoraDPlaySound()
	if self.fields.Image_headInfo:isVisible() then
		if self.tablePlayerInfo.base.avatar and self.tablePlayerInfo.base.avatar ~= "" then
			local panel = SoraDCreatePanel("lordBigHeadView")
			panel:updateBigHead(self.tablePlayerInfo.base.avatar, self.tablePlayerInfo.base.imageId)
			panel:show()
		else
			self:onHeadMenuClick()
		end
	else
		uiManager:show("lordChangeHeadView")
	end
end
function lordInfoViewPanel:onHeadMenuClick()
	SoraDPlaySound()
	if self.fields.Image_headInfo:isVisible() then
		chatConst = self.tablePlayerInfo.abbr
		_ENV, self.tablePlayerInfo.abbr[1] = chatConst.OpId.OpReportHeadImg, chatConst.OpId.OpReportHeadImg
		chatConst.OpId.OpReportHeadImg.avatarUrl = self.tablePlayerInfo.base.avatar
		chatConst.OpId.OpReportHeadImg.playerId = self.tablePlayerInfo.base.uid
		SoraDShowPlayerOperatePanel(textParser.formatPlayerName(self.tablePlayerInfo.abbr, self.tablePlayerInfo.base.nickName), self.tablePlayerInfo.abbr, chatConst.OpId.OpReportHeadImg)
	end
end
function lordInfoViewPanel:btnCopyUIDClick()
	SoraDPlaySound()
	if self.copyUID then
		SoraDCopyText(tostring(self.copyUID))
		SoraDShowMsgTip(i18n("common_text_1062"))
	end
end
function lordInfoViewPanel:btnAllianceClickCallBack()
	SoraDPlaySound()
	local kid = self.tablePlayerInfo.base.partition or 0
	local teamId = self.tablePlayerInfo.base.teamId
	if teamId and worldMapDefine.isLegendLordKingdomID(kid) then
		legendTeamUtil.openPreView(teamId, worldMapDefine.currentMapKindomID)
	else
		local aid = tonumber(self.tablePlayerInfo.aid)
		if aid == nil and not allianceDesRead.getPlayerConquestWarMigration() and not allianceDesRead.getPlayerBattleGroundMigration() then
			SoraDShowMsgBox(i18n("common_text_2301"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					allianceMgr:reqInviteJoin(self.tablePlayerInfo.base.uid)
				end
			end)
		else
			SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
			_ENV = "MESSAGE_ALLIANCE_REQ_INFO_BACK"
			;("MESSAGE_ALLIANCE_REQ_INFO_BACK").aid = aid
			allianceQuery:reqAllianceByID("MESSAGE_ALLIANCE_REQ_INFO_BACK")
		end
	end
end
function lordInfoViewPanel:btnSendMailClickCallBack()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.targetType = gMailType.CHAT
	SoraDPlaySound.target = self.tablePlayerInfo.base.uid
	SoraDPlaySound.nickName = self.tablePlayerInfo.base.nickName
	local SoraDPlaySound.allianceAbbr, data = self.tablePlayerInfo.abbr, SoraDPlaySound
	SoraDCreateChatView(data)
end
return lordInfoViewPanel
