local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local questionnaireCtrl = class("questionnaireCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function questionnaireCtrl:ctor(properties)
	questionnaireCtrl.super.ctor(self, properties)
	self:resetData()
end
function questionnaireCtrl:EnterGame()
	print("questionnaireCtrl:EnterGame()---")
	self:reqGetQuestData()
end
function questionnaireCtrl:Logout()
	questionnaireCtrl.super.Logout(self)
	self:resetData()
end
function questionnaireCtrl:resetData()
	self.questInfo, _UPVALUE0_ = nil, nil
end
function questionnaireCtrl:reqGetQuestData()
	local project = IsArClient and "koh" or "ros"
	local kid = SoraDConfigGet("Game:LoginView:setKingdomID~integer")
	local lang = GameLanguageCopy
	print("GameLanguageCopy", GameLanguageCopy, userSDKManager.isBeta())
	local channel = userSDKManager.getPlatformChannel()
	channel = channel == "" and "AppStore" or channel
	local url
	if userSDKManager.isBeta() or device.platform == "mac" then
		url = string.format("https://wjbeta.menaapp.net/activity/list/%s/%s/%s/%s/", project, lang, kid, channel)
	else
		url = string.format("https://wj.menaapp.net/activity/list/%s/%s/%s/%s/", project, lang, kid, channel)
	end
	local id = gametop.playertop_:getPlayerID()
	local uid = cc.Crypto:EncryptToBase64String(tostring(id), "eTYR77JO4LW0TeNW")
	print(url, tostring(uid))
	_ENV = tostring(uid)
	tostring(uid).p = uid
	SoraDHttpRequest(handler(self, self.reqGetQuestDataRsp), url, "POST", tostring(uid))
end
function questionnaireCtrl:reqGetQuestDataRsp(content)
	dump(content, "questionnaireCtrl:reqGetQuestDataRsp(content)", 10)
	if type(content) == "number" then
	elseif content and content.status == "n" then
		print("questionnaireCtrl:reqGetQuestDataRsp - error")
	elseif content then
		if not content.info or not content.info.data then
			_ENV = content.info.data
		end
		self.questInfo = content.info.data
		_ENV = "questionnaireCtrl:reqGetQuestDataRsp - error"
		;("questionnaireCtrl:reqGetQuestDataRsp - error").msg = "MESSAGE_QUESTIONNAIRE_REFRESH"
		SoraDSendMessage("questionnaireCtrl:reqGetQuestDataRsp - error")
	end
end
function questionnaireCtrl:getReceiveStatusAndNum()
	for i, v in ipairs(self.questInfo) do
		local currentTime = serviceFunctions.systemTime()
		if currentTime > tonumber(v.endTime) then
			self.questInfo[i] = nil
		end
	end
	table.sort(self.questInfo, function(l, r)
		return l.weight > r.weight
	end)
	dump(self.questInfo, "questionnaireCtrl:getReceiveStatusAndNum", 10)
	return table.nums(self.questInfo)
end
function questionnaireCtrl:getAllData()
	return self.questInfo
end
function questionnaireCtrl:getDataByIndexAndKey(index, key)
	if self.questInfo[index] then
		return self.questInfo[index][key]
	else
		self:reqGetQuestData()
		if self.questInfo[1] then
			return self.questInfo[1][key]
		end
	end
	return nil
end
function questionnaireCtrl:checkHaveId(id)
	for i, v in ipairs(self.questInfo) do
		if v.id == id then
			return true
		end
	end
end
return questionnaireCtrl
