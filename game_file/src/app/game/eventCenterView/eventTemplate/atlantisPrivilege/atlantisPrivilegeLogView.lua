local atlantisActivityRead = include("atlantisActivityRead")
local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
local atlantisPrivilegeLogView = class("atlantisPrivilegeLogView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisPrivilegeLogView")
end)
function atlantisPrivilegeLogView:onEnterPanel()
	SoraDShowLoading(self)
	atlantisPrivilegeCtrl:reqAtlantisPrivilegeRecord()
end
function atlantisPrivilegeLogView:ctor(properties)
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
function atlantisPrivilegeLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH", handler(self, self.initData))
end
function atlantisPrivilegeLogView:initData(target, data)
	SoraDCloseLoading(self)
	local _ENV, logList = SoraDCloseLoading, SoraDCloseLoading
	if data.rspdata then
		logList = data.rspdata.record
		self.kingInfo = data.rspdata.info
	else
		return
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
function atlantisPrivilegeLogView:createScrollSingle()
	return self.nodeSingle:clone()
end
function atlantisPrivilegeLogView:refreshScrollSingle(parent, data)
	local textLog = SoraDGetChildByName(parent, "Text_Log")
	textLog = SoraDChangeTextToHtml(textLog)
	_ENV = nil
	;(nil).var1 = textParser.formatPlayerName(self.kingInfo.allianceAbbr, self.kingInfo.nickName, self.kingInfo.kid)
	;(nil).var2 = textParser.formatPlayerName(data.allianceAbbr, data.nickName, data.kid)
	_ENV, _ENV, (nil).var3 = data.treasureID, atlantisActivityRead.getPackageName(data.treasureID), atlantisActivityRead.getPackageName(data.treasureID)
	_ENV, atlantisActivityRead.getPackageName(data.treasureID).var1, data.treasureID.color = data.treasureID, data.treasureID, "#D9B067"
	_ENV, atlantisActivityRead.getPackageName(data.treasureID).var2, data.treasureID.color = data.treasureID, data.treasureID, "#D9B067"
	_ENV, atlantisActivityRead.getPackageName(data.treasureID).var3, data.treasureID.color = data.treasureID, data.treasureID, "#D9B067"
	atlantisActivityRead.getPackageName(data.treasureID).__default, data.treasureID.color = data.treasureID, "#4EAD3B"
	textLog:setString(i18n_html("atlantiswar_privilege_text_0012", nil, (atlantisActivityRead.getPackageName(data.treasureID))))
end
return atlantisPrivilegeLogView
