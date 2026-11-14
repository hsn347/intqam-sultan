local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisManagerView = class("atlantisManagerView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisManagerView")
end)
function atlantisManagerView:onEnterPanel()
	atlantisActivityCtrl:reqGetManagerInfo()
end
function atlantisManagerView:ctor(properties)
	self.myKid = gametop.playertop_:getKingdomID()
	self.managerInfo, gametop, self.myUid = gametop.playertop_:getPlayerID(), gametop.playertop_:getPlayerID(), gametop.playertop_:getPlayerID()
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeCommonFramTitle:setTitle(i18n("atlantiswar_text_0244"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.nodeManagerInfo = SoraDGetChildByName(self, "Node_ManagerInfo")
	self.textKindomName = SoraDGetChildByName(self.nodeManagerInfo, "Text_KindomName")
	self.nodeFlag = SoraDGetChildByName(self.nodeManagerInfo, "Node_Flag")
	self.btnChangeFlag = SoraDGetChildByName(self.nodeManagerInfo, "Button_ChangeFlag")
	self.btnChangeFlag:setTitleText(i18n("common_text_243"))
	self.btnChangeFlag:addTouchEventListener(handler(self, self.btnChangeFlagClick))
	self.btnHead = SoraDGetChildByName(self.nodeManagerInfo, "Button_Head")
	self.btnHead:addTouchEventListener(handler(self, self.btnHeadClick))
	self.spHead = SoraDGetChildByName(self.nodeManagerInfo, "Sprite_head")
	self.textTitle = SoraDGetChildByName(self.nodeManagerInfo, "Text_Title")
	self.textTitle:setString(i18n("atlantiswar_text_0023"))
	self.textPlayerName = SoraDGetChildByName(self.nodeManagerInfo, "Text_PlayerName")
	self.textManagerTitle = SoraDGetChildByName(self, "Text_ManagerTitle")
	self.textManagerTitle:setString(i18n("atlantiswar_text_0028"))
	self.btnQuestion = SoraDGetChildByName(self, "Button_question")
	self.btnQuestion:setPositionX(self.textManagerTitle:getPositionX() + SoraDFSign(self.textManagerTitle:getContentSize().width / 2 + 25))
	self.btnQuestion:addTouchEventListener(handler(self, self.btnHelpClick))
	self.scrollTeam = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.scrollTeam = include("commonAutoScrollList").new(self.scrollTeam)
	self.scrollTeam:setSingleCCS("atlantisManagerSingle")
	include("atlantisWarUtil").playFireAnimation(self)
	self.Node_setting = SoraDGetChildByName(self, "Node_setting")
	self.Node_setting:setVisible(false)
	local Button_setting = SoraDGetChildByName(self.Node_setting, "Button_setting")
	Button_setting:setTitleText(i18n("atlantiswar_text_0346"))
	Button_setting:addTouchEventListener(handler(self, self.btnSettingZeroClick))
	SoraDAutoSizeButtonTextByContent(Button_setting)
end
function atlantisManagerView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function atlantisManagerView:initData(target, data)
	self.textKindomName:setString(SoraDGetKingdomName(self.myKid))
	allianceDesRead.getFlagWithParticle(self.managerInfo.flag, self.nodeFlag)
	self.textPlayerName:setString(i18n(textParser.formatPlayerName(self.managerInfo.adminInfo.abbr, self.managerInfo.adminInfo.nickName, self.myKid)))
	SoraDGetHeadFromManager(self.spHead, self.managerInfo.adminInfo.headid, self.managerInfo.adminInfo.avatar)
	local managerList = self:getManagerList()
	local showSetting = atlantisActivityCtrl:isManager() or self.shieldUidMap[self.myUid]
	self.Node_setting:setVisible(showSetting)
	local scorllH = display.height - 465
	if showSetting then
		scorllH = scorllH - 106
	end
	self.scrollTeam:setContentSize(cc.size(self.scrollTeam:getContentSize().width, scorllH))
	_ENV = cc.size(self.scrollTeam:getContentSize().width, scorllH)
	cc.size(self.scrollTeam:getContentSize().width, scorllH).scroll = self.scrollTeam
	cc.size(self.scrollTeam:getContentSize().width, scorllH).view = self
	cc.size(self.scrollTeam:getContentSize().width, scorllH).shieldUidMap = self.shieldUidMap
	self.scrollTeam:updateScrollView(cc.size(320, 260), managerList, 2, cc.size(self.scrollTeam:getContentSize().width, scorllH))
end
function atlantisManagerView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target == self.btnQuestion then
			_ENV = "atlantiswar_text_0022"
			;("atlantiswar_text_0022").title = i18n("atlantiswar_text_0021")
			SoraDShowHelpMsgTip(i18n("atlantiswar_text_0022"), "atlantiswar_text_0022")
		else
			SoraDCreatePanel("atlantisMemberRankInfoView"):show()
		end
	end
end
function atlantisManagerView:btnChangeFlagClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not atlantisActivityCtrl:isManager() then
			SoraDShowMsgTip(i18n("atlantiswar_text_0245"))
		elseif atlantisActivityCtrl:getActivityCurState() == ATLANTIS_WAR_STATE.BATTLE then
			SoraDShowMsgTip(i18n("atlantiswar_text_0025"))
		else
			SoraDCreatePanel("atlantisChangeFlagView"):show()
		end
	end
end
function atlantisManagerView:btnHeadClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading()
		_ENV = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(self.managerInfo.adminInfo.uid, self.myKid, nil)
	end
end
function atlantisManagerView:getManagerList()
	local self.shieldUidMap, _ENV, _ENV, list
	for i, v in pairs(self.managerInfo.managers) do
		local info = v
		info.index = tostring(i)
		table.insert(list, info)
		self.shieldUidMap[v.uid] = true
	end
	for i = #list + 1, 6 do
		_ENV = self.shieldUidMap
		self.shieldUidMap.index = i
		table.insert(list, self.shieldUidMap)
	end
	return list
end
function atlantisManagerView:btnSettingZeroClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisSettingZeroView"):show()
	end
end
function atlantisManagerView:msgCallBack(target, content)
	if content.key == "reqGetManagerInfoRsp" and content.rspdata then
		self.managerInfo = content.rspdata
		self:initData()
		dump(self.managerInfo, "self.managerInfo")
	elseif content.key == "reqStateDataRsp" then
		local curState = atlantisActivityCtrl:getActivityCurState()
		if curState ~= ATLANTIS_WAR_STATE.SETTEAM and curState ~= ATLANTIS_WAR_STATE.BATTLE then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end
end
function atlantisManagerView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading()
	local targetName = data.clientData and data.clientData.targetName
	if targetName == self.__cname and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return atlantisManagerView
