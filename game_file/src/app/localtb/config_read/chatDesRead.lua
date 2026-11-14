local chatDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	chatDesRead = nil
	;(nil)[1] = "emoticon_list"
	chatDesRead:defineValue("emoticon_list", nil)
	chatDesRead = nil
	;(nil)[1] = "emoticon_cfg"
	chatDesRead:defineValue("emoticon_cfg", nil)
	chatDesRead = nil
	;(nil)[1] = "chatsys_cfg"
	chatDesRead:defineValue("chatsys_cfg", nil)
	chatDesRead = nil
	;(nil)[1] = "chatnotice_cfg"
	chatDesRead:defineValue("chatnotice_cfg", nil)
	chatDesRead:defineValue("emoticonList", function()
		local _ENV, indexTb
		local _ENV, emoticonList
		for _, v in ipairs(chatDesRead.emoticon_cfg) do
			if not emoticonList[v.packageid] then
				emoticonList[v.packageid], _ENV = nil, nil
				indexTb[v.packageid] = 1
			end
			local index = indexTb[v.packageid]
			emoticonList[v.packageid][index] = v
			indexTb[v.packageid] = index + 1
		end
		return emoticonList
	end)
end
init()
function chatDesRead.getEmotionList()
	return chatDesRead.emoticon_list
end
function chatDesRead.getEmotionListCfg(packageid)
	return chatDesRead.emoticon_list[packageid]
end
function chatDesRead.getEmotionData(packageid)
	return chatDesRead.emoticonList[packageid]
end
function chatDesRead.getEmotionImgByName(packagename, imgid)
	local packageid = chatDesRead.getPackageIdByName(packagename)
	return chatDesRead.getEmotionImgById(packageid, imgid)
end
function chatDesRead.getPackageIdByName(packagename)
	for i, v in ipairs(chatDesRead.emoticon_list) do
		if v.packagename == packagename then
			return v.packageid
		end
	end
end
function chatDesRead.getEmotionCfgById(packageid, imgid)
	local ret
	if chatDesRead.emoticonList[packageid] then
		local tb = chatDesRead.emoticonList[packageid]
		for _, v in ipairs(tb) do
			if v.id == imgid then
				ret = v
				break
			end
		end
	end
	return ret
end
function chatDesRead.getEmotionImgById(packageid, imgid)
	local splitRet = string.split(imgid, ".")
	imgid = splitRet[1]
	local ret = "chat_face_1.png"
	local packagecfg = chatDesRead.getEmotionListCfg(packageid)
	local emoticoncfg = chatDesRead.getEmotionCfgById(packageid, imgid)
	if packagecfg.emoticontype == gChatEmoticonType.normal then
		if emoticoncfg then
			if emoticoncfg.imgEn and emoticoncfg.imgEn ~= "" and GameLanguageCopy ~= "ar" then
				ret = emoticoncfg.imgEn
			else
				ret = emoticoncfg.img
			end
		end
	elseif packagecfg.emoticontype == gChatEmoticonType.animation and emoticoncfg then
		local imgformat = emoticoncfg.imgformat
		ret = string.format(imgformat, emoticoncfg.astart)
	end
	return ret
end
function chatDesRead.getMenuName(id, custom, index)
	local chatConst = include("chatConst")
	local btnName = ""
	local opCfg = chatConst.OpConfig[tostring(id)]
	if opCfg then
		btnName = opCfg.des
		if not opCfg.isCustom then
			btnName = i18n(opCfg.des)
			return btnName
		end
		if opCfg.isCustom then
			if id == chatConst.OpId.OpViewPlayer then
				if custom and custom.players and custom.players[index] then
					local mailFunctions = include("mailFunctions")
					local name = mailFunctions:getWrappedName(custom.players[index].alliance, custom.players[index].nickName)
					btnName = name
				end
			elseif id == chatConst.OpId.OpCoordinate and custom and custom.coordinates and custom.coordinates[index] then
				_ENV = mailFunctions
				mailFunctions.x = custom.coordinates[index].x
				mailFunctions.y = custom.coordinates[index].y
				btnName = i18n("common_text_465", mailFunctions)
			end
		end
	end
	return btnName
end
function chatDesRead.getChatSysCfg(sysType)
	if sysType then
		return chatDesRead.chatsys_cfg[sysType]
	end
end
function chatDesRead.getChatNoticeCfg(noticeType)
	if noticeType then
		return chatDesRead.chatnotice_cfg[noticeType]
	end
end
return chatDesRead
