local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local languageConfig = include("languageConfig")
local kingdomSettingAPI = include("kingdomSettingAPI")
local translateCtrl = class("translateCtrl", gameModule)
local _ENV, REQ = "translateCtrl", "translateCtrl"
local _ENV, RSP = gameModule, gameModule
function translateCtrl:translate(msgList, target)
	REQ.reqTranslate(msgList, target)
end
function translateCtrl:needTranslate(translation)
	if "table" ~= type(translation) or not next(translation) then
		return true
	end
	local sl = translation.sl
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	if not settingCtrl:getTranslateLanguageStatus(sl) then
		return false, nil
	end
	local client_tl = settingCtrl:getTranslateLanguage()
	local tl = client_tl
	local tText = translation.tText
	if tText and tText[tl] and tText[tl].text then
		return false, tText[tl].text
	end
	return true
end
function translateCtrl:getSupportTLArray()
	return languageConfig:getTranslateLanguageArray()
end
function translateCtrl:getTranslateTLArray()
	return languageConfig:getTranslateTargetLanguageArray()
end
function translateCtrl:isAutoTranslateOpen()
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	return kingdomSettingAPI:isAutoTranslateSwitchOn() and settingCtrl:isAutoTranslateSwitchOn()
end
function REQ.reqTranslate(msgList, target)
	serverproxy = nil
	;(nil).msgList = msgList
	local (nil).target, data = target, nil
	serverproxy:Request(gCmd.CMD_TRANSLATE_MODULE, gCmd.REQ_TRANSLATE_TEXT, data)
end
function RSP:translateRsp(content)
	dump(content, "translateCtrl.translateRsp", 10)
	if content.err == gErrDef.Err_None then
		local translationList = content.data.translationList
		local target = content.data.target
		local msgList = content.data.msgList
		local from = target.from
		if from == "chatMail" then
			for i, v in ipairs(translationList) do
				local mid = v.chatId
				local mailMgr = gModuleMgr.sharedMgr("mailMgr")
				local mail = mailMgr:queryMail(mid)
				if mail then
					local properties = mail:getProperties()
					if not properties.data.translation then
						properties.data.translation = v
					else
						for tl, tlData in pairs(v.tText) do
							if not properties.data.translation.tText then
								_ENV = properties.data.translation.tText
							end
							properties.data.translation.tText = properties.data.translation.tText
							properties.data.translation.tText[tl] = tlData
						end
					end
				end
			end
		elseif from == "chatRoomMsg" then
			local crid = target.crid
			local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
			local chatroom = chatroomCtrl.chatroomMgr:getChatRoom(crid)
			if chatroom then
				for i, v in ipairs(translationList) do
					local msgid = v.chatId
					local msg = chatroom:getMsg(msgid)
					if msg then
						print("更新了----------聊天室翻译")
						if not msg.data.translation then
							msg.data.translation = v
						else
							for tl, tlData in pairs(v.tText) do
								msg.data.translation.tText[tl] = tlData
							end
						end
					end
				end
			end
		elseif from == "allianceMark" then
			local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
			collectMapCtrl:setAllianceMarkTranslate(translationList)
			_ENV = collectMapCtrl
			collectMapCtrl.msg = "MESSAGE_SERVER_ALLIANCE_MARK_TRANSLATE"
			SoraDSendMessage(collectMapCtrl)
			return
		elseif from == gChatTypeUIFrom.teamMsg then
			for i, v in ipairs(translationList) do
				self:setTranslationByChatId(target.dataKey, v.chatId, v)
				self:setIsShowTranslate(target.dataKey, v.chatId, true)
			end
		end
		local translationList = content.data.translationList
		_ENV = ipairs(translationList)
		ipairs(translationList).msg = "MESSAGE_CHAT_SERVER_TRANSLATE_BACK"
		ipairs(translationList).translation = translationList
		ipairs(translationList).target = target
		SoraDSendMessage(ipairs(translationList))
	else
		_ENV = content.data.target
		content.data.target.msg = "MESSAGE_CHAT_SERVER_TRANSLATE_BACK"
		content.data.target.target = content.data.target
		SoraDSendMessage(content.data.target)
	end
end
function translateCtrl:setTranslationByChatId(key, chatId, translation)
	local mapKey = key .. "_" .. chatId
	if not self.translationMap[mapKey] then
		_UPVALUE0_ = self.translationMap[mapKey]
	end
	self.translationMap[mapKey] = self.translationMap[mapKey]
	self.translationMap[mapKey].translation = translation
end
function translateCtrl:getTranslationByChatId(key, chatId)
	local mapKey = key .. "_" .. chatId
	if self.translationMap[mapKey] then
		return self.translationMap[mapKey].translation
	end
end
function translateCtrl:setIsShowTranslate(key, chatId, isShow)
	local mapKey = key .. "_" .. chatId
	if not self.translationMap[mapKey] then
		_UPVALUE0_ = self.translationMap[mapKey]
	end
	self.translationMap[mapKey] = self.translationMap[mapKey]
	self.translationMap[mapKey].isShowTranslate = isShow
end
function translateCtrl:getIsShowTranslate(key, chatId)
	local mapKey = key .. "_" .. chatId
	if self.translationMap[mapKey] then
		return self.translationMap[mapKey].isShowTranslate
	end
end
function translateCtrl:ctor(properties)
	translateCtrl.super.ctor(self, properties)
	self.translationMap, translateCtrl = translateCtrl.super.ctor, translateCtrl.super.ctor
end
function translateCtrl:EnterGame()
	translateCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_TRANSLATE_MODULE, gCmd.REQ_TRANSLATE_TEXT, handler(self, RSP.translateRsp))
end
function translateCtrl:resetData()
	self.translationMap, _UPVALUE0_ = nil, nil
end
function translateCtrl:Logout()
	translateCtrl.super.Logout(self)
	self:resetData()
end
return translateCtrl
