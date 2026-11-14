local gametop = gModuleMgr.getObject("gametop")
local accountExtCtrl = gametop.playertop_:getModule("accountExtCtrl")
local gameInviteltCtrl = include("gameInviteltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_collectTab = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_collectTab", Com_collectTab)
function Com_collectTab:onInit()
	accountExtCtrl = nil
	accountExtCtrl, (nil).invited = accountExtCtrl:getBeInvite(), accountExtCtrl:getBeInvite()
	accountExtCtrl:getBeInvite().uid = accountExtCtrl:getinviteUid()
	accountExtCtrl:getBeInvite().name = accountExtCtrl:getInviteName()
	accountExtCtrl:getBeInvite().abbr = accountExtCtrl:getInviteAllianceName()
	self.inviteData, (nil).otherData, accountExtCtrl:getBeInvite().king = nil, accountExtCtrl:getBeInvite(), accountExtCtrl:getInviteKingdomid()
	self.fields.TextField_word:setPrompt(i18n("common_text_1068"))
	self.fields.Button_get:setString(i18n("common_text_854"))
	self.fields.Text_notice:setString(i18n("common_text_982"))
	self.fields.Text_code:setString(i18n("common_text_977"))
	self.fields.Button_get:addClickListener(handler(self, self.btnGetPriceClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	local tmpTbl = gameInviteltCtrl.getShowItemListByType(gGameInviteType.MYSELF)
	self.dataList = SoraDIntArr2FormatTable(tmpTbl)
	self.fields.List:setNumItems(#self.dataList)
	self.fields.Text_deleteTip:setString(i18n("invite_text_14"))
	self.fields.Text_txt1:setString(i18n("common_text_973"))
	accountExtCtrl = i18n("common_text_973")
	i18n("common_text_973").name = ""
	self.fields.Text_inviter:setString(i18n("common_text_972", i18n("common_text_973")))
	self.fields.Button_changeInviter:setString(i18n("common_text_1520"))
	self.fields.Button_changeInviter:addClickListener(handler(self, self.btnChangeInviterClick))
	self.fields.Button_deleteInviter:setString(i18n("invite_text_12"))
	self.fields.Button_deleteInviter:addClickListener(handler(self, self.btnDeleteInviterClick))
end
function Com_collectTab:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_INPUTTHEINVITECODE", handler(self, self.doInvite))
end
function Com_collectTab:onShow()
	self:updateView()
end
function Com_collectTab:onItemRederer(index, target)
	target:initData(self.dataList[index + 1].id, self.dataList[index + 1].num)
end
function Com_collectTab:doInvite()
	SoraDCloseLoading(self)
	_ENV = SoraDCloseLoading
	_ENV, SoraDCloseLoading.invited = accountExtCtrl:getBeInvite(), accountExtCtrl:getBeInvite()
	accountExtCtrl:getBeInvite().uid = accountExtCtrl:getinviteUid()
	accountExtCtrl:getBeInvite().name = accountExtCtrl:getInviteName()
	accountExtCtrl:getBeInvite().abbr = accountExtCtrl:getInviteAllianceName()
	self.inviteData, SoraDCloseLoading.otherData, accountExtCtrl:getBeInvite().king = SoraDCloseLoading, accountExtCtrl:getBeInvite(), accountExtCtrl:getInviteKingdomid()
	self:updateView()
end
function Com_collectTab:updateView()
	if self.inviteData.otherData.uid == -1 then
		self.controllers.c1:setSelectedIndex(2)
		self:showCDTime()
	elseif self.inviteData.invited then
		self.controllers.c1:setSelectedIndex(1)
		_ENV = nil
		;(nil).name = self.inviteData.otherData.king
		self.fields.Text_kingdom:setString(i18n("common_text_971", nil))
		_ENV = i18n("common_text_971", nil)
		i18n("common_text_971", nil).name = self.inviteData.otherData.name
		self.fields.Text_name:setString(i18n("common_text_970", i18n("common_text_971", nil)))
		self:showCDTime()
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_collectTab:showCDTime()
	local cdTime = accountExtCtrl:getInviteCD()
	print("cdTime====", cdTime)
	if cdTime and 0 < cdTime then
		self.fields.Button_changeInviter:setEnabled(false)
		self.fields.Label_Time:setVisible(true)
		self.fields.Label_Time:beginTime(cdTime)
		self.fields.Label_Time:setTimeEndListener(function()
			self.fields.Button_changeInviter:setEnabled(true)
			self.fields.Label_Time:setVisible(false)
		end)
	else
		self.fields.Button_changeInviter:setEnabled(true)
		self.fields.Label_Time:setVisible(false)
	end
end
function Com_collectTab:btnGetPriceClick()
	SoraDPlaySound()
	local setDevelop = function()
		SoraDConfigSet("System:GameDevelopMode~bool", true)
	end
	local setLangCN = function()
		SoraDConfigSet("System:GameDevelopLangCN~bool", true)
	end
	local setService = function()
		SoraDConfigSet("System:GameDevelopService~bool", true)
	end
	local setReport = function()
		SoraDConfigSet("System:RepotrError~bool", true)
		SoraDShowMsgTip("success")
	end
	local enterCode = self.fields.TextField_word:getText()
	if enterCode == "" then
		SoraDShowMsgTip(i18n("common_text_1068"))
	else
		SoraDShowMsgBox(i18n("common_text_1506"), i18n("common_text_204"), nil, function(type)
			if MSGBOX_CALLBACK_YES == type then
				accountExtCtrl:setInviteCode(enterCode)
				SoraDShowLoading(self)
				if enterCode == "develop:true" then
					SoraDHttpRequest(setDevelop, gSvrConfig.insideNewArea, "GET")
				elseif enterCode == "develop:false" then
					SoraDConfigSet("System:GameDevelopMode~bool", false)
				elseif enterCode == "langcn:true" then
					SoraDHttpRequest(setLangCN, gSvrConfig.insideNewArea, "GET")
				elseif enterCode == "langcn:false" then
					SoraDConfigSet("System:GameDevelopLangCN~bool", false)
				elseif enterCode == "service:true" then
					SoraDHttpRequest(setService, gSvrConfig.insideNewArea, "GET")
				elseif enterCode == "service:false" then
					SoraDConfigSet("System:GameDevelopService~bool", false)
				elseif enterCode == "report:true" then
					SoraDHttpRequest(setReport, gSvrConfig.insideNewArea, "GET")
				else
					if enterCode == "report:false" then
						SoraDConfigSet("System:RepotrError~bool", false)
						SoraDShowMsgTip("success")
					else
					end
				end
			end
		end)
	end
end
function Com_collectTab:btnChangeInviterClick()
	SoraDPlaySound()
	SoraDInputBox(i18n("common_text_1520"), i18n("common_text_1521"), i18n("common_text_1522"), 24, handler(self, self.changeInviterCB), true)
end
function Com_collectTab:changeInviterCB(str)
	if str and str ~= "" then
		accountExtCtrl:replaceInviteCode(str)
		SoraDShowLoading(self)
	else
		SoraDShowMsgTip(i18n("common_text_967"))
	end
end
function Com_collectTab:btnDeleteInviterClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("invite_text_13"), i18n("common_text_204"), nil, function(event)
		if event == MSGBOX_CALLBACK_YES then
			print("发送删除邀请者指令====")
			accountExtCtrl:reqDeleteInviter()
		end
	end)
end
return Com_collectTab
