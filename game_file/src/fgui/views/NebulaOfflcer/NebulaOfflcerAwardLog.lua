local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
local NebulaOfflcerAwardLog = class("NebulaOfflcerAwardLog", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisPrivilegeLogView")
end)
function NebulaOfflcerAwardLog:onEnterPanel()
	SoraDShowLoading(self)
	nebulaPrivilegeCtrl:sendRecord()
end
function NebulaOfflcerAwardLog:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("atlantiswar_privilege_text_0011"))
	self.scrollList = SoraDGetChildByName(self, "ScrollView_list")
	self.scrollList = include("commonAutoScrollList").new(self.scrollList)
	self.scrollList:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollList:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.textWarn = SoraDGetChildByName(self, "Text_warn")
	self.textWarn:setString(i18n("common_text_1464"))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
end
function NebulaOfflcerAwardLog:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEBULA_PRIVILEGE_LOG", handler(self, self.initData))
end
function NebulaOfflcerAwardLog:initData(target, data)
	SoraDCloseLoading(self)
	local _ENV, logList = SoraDCloseLoading, SoraDCloseLoading
	if data.rspdata then
		if not data.rspdata.info then
			local _ENV, info = data.rspdata.info, data.rspdata.info
		end
		if not data.rspdata.record then
			local _ENV, record = data.rspdata.record, data.rspdata.record
		end
		logList = record
		self.kingInfo = info
	end
	if not next(logList) then
		self.textWarn:setVisible(true)
		self.scrollList:setVisible(false)
	else
		self.textWarn:setVisible(false)
		self.scrollList:setVisible(true)
		_ENV = nil
		;(nil).scroll = self.scrollList
		;(nil).view = self
		self.scrollList:updateScrollView(cc.size(520, 100), logList, 1, nil)
	end
end
function NebulaOfflcerAwardLog:createScrollSingle()
	return self.nodeSingle:clone()
end
local textParser = _G.textParser
function NebulaOfflcerAwardLog:refreshScrollSingle(parent, data)
	local textLog = SoraDGetChildByName(parent, "Text_Log")
	textLog = _G.SoraDChangeTextToHtml(textLog)
	local kingInfo = self.kingInfo[tostring(data.sendUid)]
	if kingInfo then
		_ENV = nil
		;(nil).var = i18n(nebulaPrivilegelRead.getOfficialNameByGiftID(data.treasureID))
		;(nil).var1 = textParser.formatPlayerName(kingInfo.allianceAbbr, kingInfo.nickName, kingInfo.kid)
		;(nil).var2 = textParser.formatPlayerName(data.allianceAbbr, data.nickName, data.kid)
		_ENV, _ENV, (nil).var3 = data.treasureID, nebulaPrivilegelRead.getPackageName(data.treasureID), nebulaPrivilegelRead.getPackageName(data.treasureID)
		_ENV, nebulaPrivilegelRead.getPackageName(data.treasureID).var1, data.treasureID.color = data.treasureID, data.treasureID, "#D9B067"
		_ENV, nebulaPrivilegelRead.getPackageName(data.treasureID).var2, data.treasureID.color = data.treasureID, data.treasureID, "#D9B067"
		_ENV, nebulaPrivilegelRead.getPackageName(data.treasureID).var3, data.treasureID.color = data.treasureID, data.treasureID, "#D9B067"
		nebulaPrivilegelRead.getPackageName(data.treasureID).__default, data.treasureID.color = data.treasureID, "#4EAD3B"
		textLog:setString(_G.i18n_html("nebula_officer_text_003", nil, (nebulaPrivilegelRead.getPackageName(data.treasureID))))
	end
end
return NebulaOfflcerAwardLog
