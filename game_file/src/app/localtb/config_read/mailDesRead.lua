local mailDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	mailDesRead = nil
	;(nil)[1] = "mailtypeinfo"
	mailDesRead:defineValue("mailtypeinfo", nil)
	mailDesRead = nil
	;(nil)[1] = "mailcontentdescribe"
	mailDesRead:defineValue("mailContentDescribe", nil)
	mailDesRead = nil
	;(nil)[1] = "mailsetinfo"
	mailDesRead:defineValue("mailsetinfo", nil)
	mailDesRead = nil
	;(nil)[1] = "attranalysislist"
	mailDesRead:defineValue("attranalysislist", nil)
	mailDesRead = nil
	;(nil)[1] = "attranalysisdata"
	mailDesRead:defineValue("attranalysisdata", nil)
	mailDesRead = nil
	;(nil)[1] = "battlelog_special"
	mailDesRead:defineValue("battlelog_special", nil)
end
init()
require("app.constdef.mailDef")
function mailDesRead.getMailTypeInfo(isPage, mailType, mailSource)
	if type(isPage) == "boolean" then
		if isPage == true then
			isPage = 1
		elseif isPage == false then
			isPage = 0
		end
	end
	if mailSource == nil or mailSource == 0 then
		isPage = 1
	end
	local bFinded = false
	for i, v in ipairs(mailDesRead.mailtypeinfo) do
		if isPage == 1 and v.isPage == isPage and v.mailType == mailType then
			bFinded = true
			return v
		elseif isPage == 0 and v.isPage == isPage and v.mailType == mailSource then
			bFinded = true
			return v
		end
	end
	if bFinded == false then
		print("not finded ", isPage, mailType)
		return nil
	end
end
function mailDesRead.getMailDesInfo(mailType, mailSource, mailContentType)
	for i, v in ipairs(mailDesRead.mailContentDescribe) do
		if mailType == v.mailType and mailSource == v.mailSource and mailContentType == v.mailContentType then
			return v
		end
	end
	for i, v in ipairs(mailDesRead.mailContentDescribe) do
		if mailContentType == v.mailContentType then
			return v
		end
	end
	return nil
end
function mailDesRead.getMailGoActivityId(mailType, mailSource, mailContentType)
	local desInfo = mailDesRead.getMailDesInfo(mailType, mailSource, mailContentType)
	if not desInfo then
		return
	end
	local goActivityId = desInfo.goActivityId
	if goActivityId and 0 < goActivityId then
		return goActivityId
	end
end
function mailDesRead.getMailSetInfo(setType)
	for i, v in ipairs(mailDesRead.mailsetinfo) do
		if v.setType == setType then
			return v
		end
	end
	return nil
end
function mailDesRead.getMailSetIcon(setType)
	local icon = "icon_mail_first_envelope.png"
	local info = mailDesRead.getMailSetInfo(setType)
	if info and info.icon and info.icon ~= "" then
		icon = info.icon
	end
	return icon
end
function mailDesRead.getMailSetColor(setType)
	local colorBg = "frame_mail_base_06.png"
	local info = mailDesRead.getMailSetInfo(setType)
	if info and info.bg and info.bg ~= "" then
		colorBg = info.bg
	end
	return colorBg
end
function mailDesRead.getMailSetTitle(setType)
	if tolua.type(setType) == "table" then
		return "mail_text_147"
	end
	local title = "NA"
	local info = mailDesRead.getMailSetInfo(setType)
	if info then
		title = info.title
	end
	return title
end
function mailDesRead.getMailSetTopTitle(setType)
	local topTitle = "NA"
	local info = mailDesRead.getMailSetInfo(setType)
	if info then
		topTitle = info.topTitle
	end
	return topTitle
end
function mailDesRead.getAttranalysislist()
	return mailDesRead.attranalysislist
end
function mailDesRead.getAttranAlysisDataById(id)
	return mailDesRead.attranalysisdata[id]
end
function mailDesRead.getAttranalysislistById(id)
	return mailDesRead.attranalysislist[tonumber(id)]
end
function mailDesRead.getBattleLogSpecial(skillType)
	for i, v in ipairs(mailDesRead.battlelog_special) do
		if v.skillType == skillType then
			return i18n(v.skillName), v.attacked
		end
	end
	return nil
end
return mailDesRead
