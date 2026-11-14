local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceSetting = class("allianceSetting", gameModule)
local _ENV, RSP = "allianceSetting", "allianceSetting"
function allianceSetting:ctor(properties)
	allianceSetting.super.ctor(self, properties)
end
function allianceSetting:EnterGame()
	allianceSetting.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_NOTICE, handler(self, RSP.modifyNotice))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_MANIFESTO, handler(self, RSP.modifyManifestoRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_RECRUIT, handler(self, RSP.modifyRecruitTypeRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_NAME, handler(self, RSP.modifyNameRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_ABBR, handler(self, RSP.modifyAbbrRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_LANGUAGE, handler(self, RSP.modifyLanguageRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_RANK_NAME, handler(self, RSP.modifyRankNameRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_FLAG, handler(self, RSP.modifyFlagRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_RECRUIT_CONDITION, handler(self, RSP.modifyRecruitConditionRsp))
end
function allianceSetting:resetData()
end
function allianceSetting:reqModifyNotice(notice, ...)
	serverproxy = nil
	;(nil).notice = notice
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_NOTICE, nil, ...)
end
function allianceSetting:reqModifyManifesto(manifesto, ...)
	serverproxy = nil
	;(nil).manifesto = manifesto
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_MANIFESTO, nil, ...)
end
function allianceSetting:reqModifyRecruitType(recruitType, ...)
	serverproxy = nil
	;(nil).recruitType = recruitType
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_RECRUIT, nil, ...)
end
function allianceSetting:reqModifyName(name, ...)
	serverproxy = nil
	;(nil).name = name
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_NAME, nil, ...)
end
function allianceSetting:reqModifyAbbr(abbr, ...)
	serverproxy = nil
	;(nil).abbr = abbr
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_ABBR, nil, ...)
end
function allianceSetting:reqModifyLanguage(languageType, ...)
	serverproxy = nil
	;(nil).languageType = languageType
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_LANGUAGE, nil, ...)
end
function allianceSetting:reqModifyRankName(rankNameList, ...)
	serverproxy = nil
	;(nil).rankNameList = rankNameList
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_RANK_NAME, nil, ...)
end
function allianceSetting:reqModifyFlag(flagid, ...)
	serverproxy = nil
	;(nil).flagid = flagid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_FLAG, nil, ...)
end
function allianceSetting:reqModifyRecruitCondition(citylv, power, ...)
	if not citylv or type(citylv) ~= "number" then
		citylv = 0
	end
	if not power or type(power) ~= "number" then
		power = 0
	end
	_ENV = nil
	;(nil).citylv = citylv
	;(nil).power = power
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_RECRUIT_CONDITION, nil, ...)
end
function RSP:modifyNotice(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	else
		local notice = content.data.notice
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local allianceLog = gametop.playertop_:getModule("allianceLog")
		local alliance = allianceMgr:getAlliance()
		alliance:setProperty("notice", notice)
		allianceLog:modifyLogListNotice(notice)
		_ENV = allianceLog
		allianceLog.msg = "MESSAGE_ALLIACNE_NOTICE_CHANGE_SUCCESS"
		SoraDSendMessage(allianceLog)
	end
end
function RSP:modifyManifestoRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	end
end
function RSP:modifyRecruitTypeRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	end
end
function RSP:modifyNameRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	else
		include("msgNotice").notice("notice_0156")
	end
end
function RSP:modifyAbbrRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	else
		include("msgNotice").notice("notice_0157")
	end
end
function RSP:modifyLanguageRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	else
		local languageType = content.data.languageType
		local msgNotice = include("msgNotice")
		_ENV = nil
		;(nil).languageID = languageType
		msgNotice.notice("notice_0075", nil)
	end
end
function RSP:modifyRankNameRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	end
end
function RSP:modifyFlagRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
		if gErrDef.Err_ALLIANCE_FLAG_ID_NOT_LEGAL == content.err then
		else
			if gErrDef.Err_ALLIANCE_FLAG_NOT_BEST_ALLIANCE == content.err then
			else
			end
		end
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS"
	SoraDSendMessage(content.err)
end
function RSP:modifyRecruitConditionRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("rsp err=", content.err)
	else
		SoraDShowMsgTip(i18n("common_text_1457"), "#icon_alliance_recruit.png")
	end
end
return allianceSetting
