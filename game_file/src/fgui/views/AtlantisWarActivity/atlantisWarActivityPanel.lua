local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local atlantisWarActivityPanel = class("atlantisWarActivityPanel", baseFguiPanel)
function atlantisWarActivityPanel:ctor(...)
	atlantisWarActivityPanel.super.ctor(self, ...)
	print("atlantisWarActivityPanel:ctor", self.viewName)
	self.kindomList, atlantisWarActivityPanel, self.activityID = gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY, gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY, gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY
end
function atlantisWarActivityPanel:onInit()
	print("=======atlantisWarActivityPanel:onInit")
	self.nodeCommonFramTitle = self.fields.Top_CCS_commonFramTitle_1:getChild("Com_title")
	self.nodeCommonFramTitle:initData(i18n("activity_name_9001366"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.Button_cheat = self.fields.Top_CCS_commonFramTitle_1:getChild("Button_cheat")
	if nebulaWarUtil.getIsDebug() then
		self.Button_cheat:setTitleText("切换状态")
		self.Button_cheat:addClickListener(function(target, eventType)
			local cheatCtrl = SoraDGetCtrl("cheatCtrl")
			_ENV = nil
			;(nil).command = "qhjzytldszt"
			cheatCtrl:reqCheat(nil, nil)
		end)
	else
		self.Button_cheat:setVisible(false)
	end
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node_buttons")
	self.imgBg = SoraDGetChildByName(self, "Center_Image_Bg")
	self.imgBlackBg = SoraDGetChildByName(self, "Size_Black")
	self.kindomScroll = SoraDGetChildByName(self, "ScrollView")
	self.nodeKindom = SoraDGetChildByName(self, "Node_Kindom")
	self.nodeFightUI = SoraDGetChildByName(self, "Node_FightUI")
	self.textOperate = SoraDGetChildByName(self.nodeFightUI, "Text_Operate")
	self.textRankFighting = SoraDGetChildByName(self.nodeFightUI, "Text_Rank")
	self.nodeFighting = self.fields.Node_Fighting
	self.textBFRound = SoraDGetChildByName(self.nodeFighting, "BitmapFontLabel_round")
	self.textTime = SoraDGetChildByName(self.nodeFighting, "Text_Time")
	self.textTime:setString(i18n("atlantiswar_text_0358"))
	self.nodeAtlantisTimeNode = include("atlantisTimeNode").new(self.fields.CCS_atlantisTimeNode)
	self.nodeTips = SoraDGetChildByName(self, "Node_Tips")
	self.textTips = SoraDGetChildByName(self.nodeTips, "Text_Tips")
	self.nodeWait = self.fields.Node_Wait
	self.nodeWait:getChildByName("Text_wait"):setString(i18n("Community_text_0011"))
	self.nodeSeason = SoraDGetChildByName(self, "Node_Season")
	self.frame_ytlds_hz_bt_1 = SoraDGetChildByName(self.nodeSeason, "frame_ytlds_hz_bt_1")
	self.winKingdomFlag = SoraDGetChildByName(self.nodeSeason, "Node_Flag")
	self.textInfo = SoraDGetChildByName(self.nodeSeason, "Text_Info")
	self.textBFSeason = SoraDGetChildByName(self.nodeSeason, "BitmapFontLabel_round")
	self.nodeRank = SoraDGetChildByName(self, "Node_Rank")
	self.textRankPrepare = SoraDGetChildByName(self.nodeRank, "Text_Rank")
	self.btnSkill = SoraDGetChildByName(self.topNode, "Button_Skill")
	self.btnSkill:addTouchEventListener(handler(self, self.btnSkillClick))
	SoraDGetChildByName(self.btnSkill, "Text_Skill"):setString(i18n("common_title_03"))
	self.skillRed = SoraDGetChildByName(self.btnSkill, "red_Icon")
	local btnTreasure = SoraDGetChildByName(self.topNode, "Button_Treasure")
	btnTreasure:addTouchEventListener(handler(self, self.btnTreasureClick))
	btnTreasure:setIcon("icon_shmc_precious_deposits.png")
	SoraDGetChildByName(btnTreasure, "Text_Skill"):setString(i18n("atlantiswar_text_0366"))
	SoraDGetChildByName(btnTreasure, "red_Icon"):setVisible(false)
	local btnPoint = SoraDGetChildByName(self.topNode, "Button_Point")
	self.btnPoint = btnPoint
	if not worldMapDefine.isInAtlantis() then
		btnPoint:addTouchEventListener(handler(self, self.btnPointClick))
		btnPoint:setIcon("icon_wjdc_questionnairet.png")
		SoraDGetChildByName(btnPoint, "Text_Skill"):setString(i18n("common_text_1764"))
		SoraDGetChildByName(btnPoint, "red_Icon"):setVisible(false)
	else
		self.btnPoint:setVisible(false)
	end
	local btnPrivilege = SoraDGetChildByName(self.topNode, "Button_Privilege")
	self.btnPrivilege = btnPrivilege
	btnPrivilege:addTouchEventListener(handler(self, self.btnPrivilegeClick))
	btnPrivilege:setIcon("icon_shmc_main_wangzhe.png")
	SoraDGetChildByName(btnPrivilege, "Text_Skill"):setString(i18n("activity_name_9001350"))
	self.privilegeRed = SoraDGetChildByName(btnPrivilege, "red_Icon")
	self:updatePrivilegeBtn()
	self:updatePrivilegeRed()
	self.btnManager = SoraDGetChildByName(self, "Button_Manager")
	self.managerRed = SoraDGetChildByName(self.btnManager, "Sprite_redPoint")
	self.managerRed:setVisible(false)
	self.btnManager:addTouchEventListener(handler(self, self.btnManagerClick))
	SoraDGetChildByName(self.btnManager, "Text_btnTitle"):setString(i18n("common_text_187"))
	self.btnRecord = SoraDGetChildByName(self, "Button_Record")
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	SoraDGetChildByName(self.btnRecord, "Text_btnTitle"):setString(i18n("atlantiswar_text_0425"))
	self.btnShop = SoraDGetChildByName(self, "Button_Shop")
	self.shopRed = SoraDGetChildByName(self.btnShop, "Sprite_redPoint")
	self.textShopRedNum = SoraDGetChildByName(self.shopRed, "Text_RedNum")
	self.shopRed:setVisible(false)
	self.btnShop:addTouchEventListener(handler(self, self.btnShopClick))
	local Text_btnTitle = SoraDGetChildByName(self.btnShop, "Text_btnTitle")
	if atlantisWarUtil.isNewMap() then
		Text_btnTitle:setString(i18n("flames_dunes_text24"))
		self.btnShop:setIcon("icon_9001674_zjm_zzsc.png")
	else
		Text_btnTitle:setString(i18n("allianceWar_shop_title"))
	end
	self.btnRank = SoraDGetChildByName(self, "Button_Rank")
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	SoraDGetChildByName(self.btnRank, "Text_btnTitle"):setString(i18n("common_text_2193"))
	self.btnReward = SoraDGetChildByName(self, "Button_Reward")
	self.btnReward:addTouchEventListener(handler(self, self.btnRewardClick))
	SoraDGetChildByName(self.btnReward, "Text_btnTitle"):setString(i18n("atlantiswar_text_0019"))
	self.btnEnterMap = SoraDGetChildByName(self.nodeFightUI, "Button_EnterMap")
	self.btnEnterMap:addTouchEventListener(handler(self, self.btnEnterMapClick))
	self:creatAnimation()
	_UPVALUE4_ = self.creatAnimation
	self.battleShowEffect, self.creatAnimation[1] = self.creatAnimation, self.effectBg
	self.battleShowEffect, self.creatAnimation[2] = self.creatAnimation, self.btnEffect2
	self.battleShowEffect, self.creatAnimation[3] = self.creatAnimation, self.btnEffect1
	self.battleShowEffect, self.creatAnimation[4] = self.creatAnimation, self.effectShazi
	self:fitView()
	self:updateStateData()
	self:initData()
	if not SoraDFIsRA() then
		self.bottomNode:fixPos()
		self.bottomNode:fixChildrenPos()
	end
end
function atlantisWarActivityPanel:onShow()
	print("=======atlantisWarActivityPanel:onShow")
	self:enterViewAnimation()
	SoraDShowLoading(self)
	atlantisActivityCtrl:reqKindomRank(1)
end
function atlantisWarActivityPanel:fitView()
	local height = display.height
	if height < 1136 then
		self.nodeFightUI:setScale(0.85)
		self.nodeFightUI:setPositionY(height - 140)
		self.criSp_VS:setPositionY(self.criSp_VS:getPositionY() - 100)
		self.criSp_Finish:setPositionY(self.criSp_Finish:getPositionY() - 100)
		self.nodeSeason:setPositionY(self.nodeSeason:getPositionY() + 70.0)
		self.nodeSeason:setScale(0.7)
		self.nodeRank:setPositionY(self.nodeRank:getPositionY() - 34)
		self.nodeRank:setScale(0.8)
		self.nodeKindom:setScale(0.9)
		self.nodeKindom:setPositionY(self.nodeKindom:getPositionY() - 40)
	end
end
function atlantisWarActivityPanel:updateUIPos()
	if self.curState == ATLANTIS_WAR_STATE.BATTLE then
		self.nodeAtlantisTimeNode:setTimeScale(0.8)
		local baseY = 206
		self.nodeTips:setPositionY(baseY)
		self.nodeAtlantisTimeNode:setPositionY(baseY + 58)
		local height = display.height
		if height < 1136 then
			local newH = math.max(190, 380 + height - 960)
			self.kindomScroll:setContentSize(cc.size(640, newH))
			self.kindomScroll:setPositionY(baseY + 104)
		else
			self.kindomScroll:setPositionY(baseY + 104)
		end
	elseif self.curState == ATLANTIS_WAR_STATE.PREPARE then
		self.nodeTips:setPositionY(self.nodeWait:getPositionY() - 75)
	elseif self.curState == ATLANTIS_WAR_STATE.RESULT then
		if display.height < 1136 then
			self.kindomScroll:setContentSize(cc.size(640, 440))
			self.kindomScroll:setPositionY(display.cy - 226)
		else
			self.kindomScroll:setPositionY(display.cy - 280)
		end
	end
	if self.curState ~= ATLANTIS_WAR_STATE.BATTLE then
		self.nodeAtlantisTimeNode:setPositionY(self.nodeWait:getPositionY())
	end
end
function atlantisWarActivityPanel:updateStateData()
	self.curState = atlantisActivityCtrl:getActivityCurState()
	self.round = atlantisActivityCtrl:getNowRound()
	self.season = atlantisActivityCtrl:getSeason()
	if self.curState == ATLANTIS_WAR_STATE.BATTLE then
		atlantisActivityCtrl:reqMatchResult()
		atlantisActivityCtrl:reqGetManagerInfo()
	elseif self.curState == ATLANTIS_WAR_STATE.SETTEAM then
		atlantisActivityCtrl:reqGetManagerInfo()
	elseif self.curState == ATLANTIS_WAR_STATE.RESULT then
		atlantisActivityCtrl:reqMatchResult()
		atlantisActivityCtrl:reqGetManagerInfo()
	end
	if self.btnPoint then
		self.btnPoint:setVisible(not worldMapDefine.isInAtlantis() and atlantisActivityCtrl:checkShowBtnPoint())
		self:sortTopNodeBtns()
	end
	if nebulaWarUtil.getIsDebug() then
		local cheatStr = "切换状态" .. self.curState
		self.Button_cheat:setTitleText(cheatStr)
	end
end
function atlantisWarActivityPanel:initData()
	local kingdomCount = atlantisWarUtil.getKingdomCount()
	for i = 1, kingdomCount do
		local single = fgui.UIPackage:createObject("AtlantisWarActivity", "Node_KingdomSingle")
		single:addTo(self.nodeKindom)
		single:setScale(i == 2 and 1 or 0.85)
		if i == 2 then
			self.myKindomNode = single
		else
			table.insert(self.kindomList, single)
		end
		local lineNum = math.ceil(kingdomCount / 2)
		local line = math.ceil(i / lineNum)
		local row = (i - 1) % lineNum + 1
		if kingdomCount == 4 then
			local singleSize = cc.size(210, 200)
			local posx = singleSize.width * (row - 1.5)
			local posy = singleSize.height * (line - 1.5)
			single:setPosition(posx, posy)
		else
			local singleSize = cc.size(180, 200)
			local posx = singleSize.width * (row - 2)
			local posy = singleSize.height * (line - 1.5)
			single:setPosition(posx, posy)
		end
	end
	self:updateShopRed()
	self:updateSkillRed()
	self:refreshView()
end
function atlantisWarActivityPanel:updateKindomNode()
	local children = SoraDGetChildsArrayByName(self.flagAnimation, "Node_", 5, 1, true)
	local nodeMine = SoraDGetChildByName(self.flagAnimation, "Node_Mine")
	local ownKid = lordInfoCtrl:getMapSourceKid()
	local index = 1
	for _, info in ipairs(self.matchResult) do
		if info.kid == ownKid then
			allianceDesRead.getFlagWithParticle(info.flag, nodeMine)
			self:refreshKingdomSingle(self.myKindomNode, info, true)
		else
			allianceDesRead.getFlagWithParticle(info.flag, children[index])
			self:refreshKingdomSingle(self.kindomList[index], info)
			index = index + 1
		end
	end
end
function atlantisWarActivityPanel:updateSeason(kingInfo)
	self.textBFSeason:setString(self.season)
	if self.curState == ATLANTIS_WAR_STATE.FINISH then
		if kingInfo then
			_ENV = nil
			;(nil).var = serviceFunctions.getKingdomFormatName(kingInfo.kingdomName, kingInfo.kid)
			self.textInfo:setString(i18n("atlantiswar_text_0017", nil))
			self.frame_ytlds_hz_bt_1:setVisible(true)
			self.textInfo:setVisible(true)
		end
	else
		self.frame_ytlds_hz_bt_1:setVisible(false)
		self.textInfo:setVisible(false)
	end
end
function atlantisWarActivityPanel:updateVisible()
	for _, target in ipairs(self.battleShowEffect) do
		local isVisible = self.curState == ATLANTIS_WAR_STATE.BATTLE
		target:setVisible(isVisible)
		if isVisible then
			target:start()
		else
			target:pause()
		end
	end
	if self.curState == ATLANTIS_WAR_STATE.RESULT then
		self.effectShazi:setVisible(true)
		self.effectShazi:start()
	end
end
function atlantisWarActivityPanel:refreshView()
	_ENV = nil
	;(nil)[ATLANTIS_WAR_STATE.PREPARE] = 0
	;(nil)[ATLANTIS_WAR_STATE.MATCH] = 1
	;(nil)[ATLANTIS_WAR_STATE.SETTEAM] = 2
	;(nil)[ATLANTIS_WAR_STATE.RESULT] = 3
	;(nil)[ATLANTIS_WAR_STATE.BATTLE] = 4
	local (nil)[ATLANTIS_WAR_STATE.FINISH], state2index = 5, nil
	self.controllers.c_state:setSelectedIndex(state2index[self.curState] or 0)
	self.textBFRound:setString(self.season)
	self.criSp_Finish:setVisible(self.curState == ATLANTIS_WAR_STATE.FINISH)
	self.criSp_VS:setVisible(self.curState ~= ATLANTIS_WAR_STATE.FINISH and self.curState ~= ATLANTIS_WAR_STATE.BATTLE and self.curState ~= ATLANTIS_WAR_STATE.RESULT)
	if self.criSp_VS:isVisible() then
		self.criSp_VS:start()
	else
		self.criSp_VS:pause()
	end
	if self.criSp_Finish:isVisible() then
		self.criSp_Finish:start()
	else
		self.criSp_Finish:pause()
	end
	self.winKingdomFlag:setVisible(self.curState == ATLANTIS_WAR_STATE.FINISH)
	self:updateVisible()
	if self.curState == ATLANTIS_WAR_STATE.BATTLE then
		if worldMapDefine.isInAtlantis() then
			self.textOperate:setString(i18n("remains_btn_09"))
		else
			self.textOperate:setString(i18n("common_text_4413"))
		end
		_ENV = i18n("common_text_4413")
		i18n("common_text_4413").var = self.round
		self.textTips:setString(i18n("atlantiswar_text_0015", i18n("common_text_4413")))
	elseif self.curState == ATLANTIS_WAR_STATE.FINISH then
		self.textTips:setString(i18n("atlantiswar_text_0242"))
	else
		_ENV = i18n("atlantiswar_text_0242")
		i18n("atlantiswar_text_0242").var = self.round
		self.textTips:setString(i18n("atlantiswar_text_0005", i18n("atlantiswar_text_0242")))
	end
	self:updateUIPos()
	self:updateKindomRank()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function atlantisWarActivityPanel:openTimeUp()
	local time = atlantisActivityCtrl:getStageEndTime()
	self.nodeAtlantisTimeNode:setTime(time)
end
function atlantisWarActivityPanel:updateShopRed()
	local showRed, num = atlantisActivityCtrl:getExchangeShopRedNum(self.activityID)
	self.textShopRedNum:setString(num)
	self.shopRed:setVisible(showRed)
end
function atlantisWarActivityPanel:updateManagerRed()
	if atlantisActivityCtrl:isManager() then
		atlantisActivityCtrl = nil
		;(nil).byUID = true
		if not SoraDConfigGet("Game:atlantisWarActivity:managerRedTip~bool", nil) then
			self.managerRed:setVisible(true)
	end
	else
		self.managerRed:setVisible(false)
	end
end
function atlantisWarActivityPanel:updateSkillRed(...)
	if not self.skillRed:isVisible() then
		return
	end
	local ret = atlantisActivityCtrl:getSkillRedStatus()
	if ret then
		self.skillRed:setVisible(true)
	else
		self.skillRed:setVisible(false)
	end
end
function atlantisWarActivityPanel:updateKindomRank(kingInfo)
	if kingInfo and kingInfo then
		allianceDesRead.getFlagWithParticle(kingInfo.flag, self.winKingdomFlag)
	end
	local myRank = atlantisActivityCtrl:getKindomRank()
	if 0 < myRank and myRank <= 50 then
		allianceDesRead = nil
		allianceDesRead, allianceDesRead, (nil).var = nil, nil, myRank
		;(nil).var, (nil).color = nil, "#FFFF00"
		self.textRankFighting:setString(i18n_html("atlantiswar_text_0006", nil, nil))
		allianceDesRead = i18n_html("atlantiswar_text_0006", nil, nil)
		allianceDesRead, allianceDesRead, i18n_html("atlantiswar_text_0006", nil, nil).var = i18n_html("atlantiswar_text_0006", nil, nil)
		i18n_html("atlantiswar_text_0006", nil, nil).var, i18n_html("atlantiswar_text_0006", nil, nil).color = i18n_html("atlantiswar_text_0006", nil, nil)
		self.textRankPrepare:setString(i18n_html("atlantiswar_text_0006", i18n_html("atlantiswar_text_0006", nil, nil)))
	else
		self.textRankFighting:setString(i18n("common_text_827"))
		self.textRankPrepare:setString(i18n("common_text_827"))
	end
end
function atlantisWarActivityPanel:refreshKingdomSingle(parent, data, isMine)
	local nodeFlag = SoraDGetChildByName(parent, "Node_Flag")
	allianceDesRead.getFlagWithParticle(data.flag, nodeFlag)
	local textKindomName = SoraDGetChildByName(parent, "Text_KindomName")
	textKindomName:setString(serviceFunctions.getKingdomFormatName(data.kingdomName, data.kid))
	textKindomName:setColor(isMine and cc.c3b(255, 206, 57) or cc.c3b(255, 255, 255))
end
function atlantisWarActivityPanel:btnHelpClick(target, eventType)
	SoraDPlaySound()
	SoraDCreatePanel("atlantisWarFAQ"):show()
end
function atlantisWarActivityPanel:btnSkillClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDGetCastleLv() < ATLANTIS_WAR_CASTLE_LEVEL then
			SoraDShowMsgTip(i18n("remains_text_20"))
		else
			SoraDCreatePanel("atlantisSkillView"):show()
		end
	end
end
function atlantisWarActivityPanel:btnTreasureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if atlantisActivityCtrl:getActivityCurState() == ATLANTIS_WAR_STATE.FINISH then
			uiManager:show("AtlantisTreasure")
		else
			uiManager:show("AtlantisTreasurePre")
		end
	end
end
function atlantisWarActivityPanel:btnPointClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not atlantisActivityCtrl:checkShowBtnPoint() then
			return
		end
		_ENV = nil
		;(nil).inOutWar = true
		local panel = include("atlantisBattlePointRank").new(nil, nil)
		panel:show()
	end
end
function atlantisWarActivityPanel:btnManagerClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curState ~= ATLANTIS_WAR_STATE.SETTEAM and self.curState ~= ATLANTIS_WAR_STATE.BATTLE then
			if self.curState == ATLANTIS_WAR_STATE.FINISH then
				SoraDShowMsgTip(i18n("atlantiswar_text_0253"))
			else
				local atlantisWarUtil = include("atlantisWarUtil")
				if atlantisWarUtil.isNewMap() then
					SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020_KOH"))
				else
					SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020"))
				end
			end
		else
			_ENV = i18n("atlantiswar_text_0020")
			i18n("atlantiswar_text_0020").byUID = true
			SoraDConfigSet("Game:atlantisWarActivity:managerRedTip~bool", true, i18n("atlantiswar_text_0020"))
			SoraDCreatePanel("atlantisManagerView"):show()
		end
	end
end
function atlantisWarActivityPanel:btnRecordClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not atlantisActivityCtrl:checkShowRecordView() then
			return
		end
		SoraDShowLoading(target, nil, nil, true, 2)
		uiManager:show("AtlantisRecord")
	end
end
function atlantisWarActivityPanel:btnShopClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		atlantisWarUtil.openExchangeShop()
	end
end
function atlantisWarActivityPanel:btnRankClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisRankView"):show()
	end
end
function atlantisWarActivityPanel:btnRewardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisRewardView"):show()
	end
end
function atlantisWarActivityPanel:btnEnterMapClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isEnterPlaying then
			print("正在播放动画。。。")
			return
		end
		if worldMapDefine.isInAtlantis() then
			SoraDShowMsgBox(i18n("atlantiswar_text_0016"), i18n("common_text_204"), nil, function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					atlantisActivityCtrl:reqQuitBattlefield()
				end
			end)
		elseif atlantisWarUtil.checkEnterBattleField() == gErrDef.Err_None then
			_ENV = i18n("common_text_204")
			i18n("common_text_204").byUID = true
			local num = SoraDConfigGet("Game:atlantisWarActivity:season-round~string", (i18n("common_text_204"))) or ""
			print("num", num, self.season .. "_" .. self.round)
			if num == self.season .. "_" .. self.round then
				atlantisActivityCtrl:reqEnterBattlefield()
			else
				_ENV = "_"
				;("_").byUID = true
				SoraDConfigSet("Game:atlantisWarActivity:season-round~string", self.season .. "_" .. self.round, "_")
				self:playEnterAnimation()
			end
		end
	end
end
function atlantisWarActivityPanel:btnPrivilegeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local eid = gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY
		if clientEventMgr.judgeIsOpen(eid) then
			clientEventMgr.singleClickEvent(eid)
		else
			self:updatePrivilegeBtn()
		end
	end
end
function atlantisWarActivityPanel:updatePrivilegeBtn()
	if not atlantisWarUtil.isNewMap() then
		self.btnPrivilege:setVisible(false)
		return
	end
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY) then
		self.btnPrivilege:setVisible(true)
	else
		self.btnPrivilege:setVisible(false)
	end
	self:sortTopNodeBtns()
end
function atlantisWarActivityPanel:onMsgUpdatePrivilege()
	self:updatePrivilegeRed()
end
function atlantisWarActivityPanel:updatePrivilegeRed()
	if not atlantisWarUtil.isNewMap() then
		return
	end
	local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
	local ret = atlantisPrivilegeCtrl:getReceiveStatusAndNum() or false
	self.privilegeRed:setVisible(ret)
end
function atlantisWarActivityPanel:sortTopNodeBtns()
	_UPVALUE2_ = nil
	;(nil)[1] = self.btnPoint
	local (nil)[2], btnList = self.btnPrivilege, nil
	local posY = 380
	for _, btn in ipairs(btnList) do
		if btn:isVisible() then
			btn:setPositionY(posY)
			posY = posY + 100
		end
	end
end
function atlantisWarActivityPanel:enterViewAnimation()
	_ENV = nil
	;(nil)[1] = ffa.fadeTo(0.25, 0)
	;(nil)[2] = ffa.fadeTo(0.25, 0)
	;(nil)[3] = ffa.fadeTo(0.25, 0)
	;(nil)[4] = ffa.fadeTo(0.25, 0)
	;(nil)[5] = ffa.fadeTo(0.25, 0)
	;(nil)[6] = ffa.fadeTo(0.25, 0)
	;(nil)[7] = ffa.fadeTo(0.25, 0)
	;(nil)[8] = ffa.fadeTo(0.25, 0)
	;(nil)[9] = ffa.fadeTo(0.25, 0)
	;(nil)[10] = ffa.fadeTo(0.25, 0)
	self.imgBlackBg:runAction(ffa.seq(nil))
	self.imgBg:setScale(1.2)
	_ENV = ffa.seq(nil)
	ffa.seq(nil)[1] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[2] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[3] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[4] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[5] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[6] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[7] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[8] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[9] = ffa.scaleTo(0.4, 1)
	ffa.seq(nil)[10] = ffa.scaleTo(0.4, 1)
	self.imgBg:runAction(ffa.seq(ffa.seq(nil)))
	_ENV = ffa.seq(ffa.seq(nil))
	ffa.seq(ffa.seq(nil))[1] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[2] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[3] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[4] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[5] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[6] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[7] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[8] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[9] = cca.scaleTo(0.4, 1)
	ffa.seq(ffa.seq(nil))[10] = cca.scaleTo(0.4, 1)
	self.effectBg:runAction(cca.seq(ffa.seq(ffa.seq(nil))))
	_UPVALUE10_ = self.effectBg.runAction
	self.effectBg.runAction[1] = SoraDGetChildByName(self, "Center_Node_Effect")
	self.effectBg.runAction[2] = self.topNode
	self.effectBg.runAction[3] = self.nodeAtlantisTimeNode
	self.effectBg.runAction[4] = self.nodeTips
	self.effectBg.runAction[5] = self.nodeSeason
	self.effectBg.runAction[6] = self.nodeRank
	self.effectBg.runAction[7] = self.kindomScroll
	self.effectBg.runAction[8] = self.nodeFightUI
	self.effectBg.runAction[9] = self.bottomNode
	local self.effectBg.runAction[10], widgetList = self.nodeCommonFramTitle, self.effectBg.runAction
	if self.nodeWait then
		table.insert(widgetList, self.nodeWait)
	end
	for i, target in ipairs(widgetList) do
		target:setOpacity(0)
		_UPVALUE1_ = self.bottomNode
		self.bottomNode[1] = ffa.delay(0.25)
		self.bottomNode[2] = ffa.fadeTo(0.21666666666666667, 1)
		self.bottomNode[3] = ffa.fadeTo(0.21666666666666667, 1)
		self.bottomNode[4] = ffa.fadeTo(0.21666666666666667, 1)
		target:runAction(ffa.seq(self.bottomNode))
	end
end
function atlantisWarActivityPanel:creatAnimation()
	local Flag_Animation = SoraDGetChildByName(self, "Flag_Animation")
	self.flagAnimation = SoraDCreatAnimationEx("atlantisFlagAnimation")
	self.flagAnimation:addTo(Flag_Animation)
	self.flagAnimation.action:gotoFrameAndPause(0)
	self.flagAnimation:setVisible(false)
	self.flagAnimation:setLocalZOrder(2)
	self.criSp_VS = cc.criSprite.createCriSprite("yatelds_02.usm", false, true, nil)
	self.criSp_VS:addTo(SoraDGetChildByName(self, "Center_Node_Effect"))
	self.criSp_VS:setPosition(0, 0)
	self.criSp_VS:setVisible(false)
	self.criSp_VS:pause()
	self.criSp_Finish = cc.criSprite.createCriSprite("yatelds_01.usm", false, true, nil)
	self.criSp_Finish:addTo(SoraDGetChildByName(self, "Center_Node_Effect"))
	self.criSp_Finish:setPosition(0, 0)
	self.criSp_Finish:setVisible(false)
	self.criSp_Finish:pause()
	self.vsEnter = cc.criSprite.createCriSprite("sp_jrzc_010.usm", false, false, true)
	self.vsEnter:addTo(SoraDGetChildByName(self, "Center_Node_VSEffect"))
	self.vsEnter:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.vsEnter:setLocalZOrder(3)
	self.vsEnter:setPosition(0, 0)
	self.vsEnter:setVisible(false)
	self.vsEnter:pause()
	self.vsEnter:setCompleteCallback(function(...)
		print("vsEnter--End")
		self.vsEnter:setVisible(false)
		self.vsEnter:pause()
	end)
	self.vsEnterBg = cc.criSprite.createCriSprite("sp_jrzc_011.usm", false, false, true)
	self.vsEnterBg:setLocalZOrder(1)
	self.vsEnterBg:addTo(SoraDGetChildByName(self, "Center_Node_VSEffect"))
	self.vsEnterBg:setPosition(0, 0)
	self.vsEnterBg:setVisible(false)
	self.vsEnterBg:pause()
	self.vsEnterBg:setCompleteCallback(function(...)
		print("vsEnterBg--End")
		self.vsEnterBg:pause()
		self.vsEnterBg:setVisible(false)
		self.flagAnimation.action:gotoFrameAndPause(0)
		self.flagAnimation:setVisible(false)
		self.isEnterPlaying = false
		atlantisActivityCtrl:reqEnterBattlefield()
	end)
	self.vsEnterBg:setScale(math.max(1, display.height / 1136))
	self.liuSha = cc.criSprite.createCriSprite("sp_jrzc_009.usm", false, false, true)
	self.liuSha:addTo(SoraDGetChildByName(self, "Node_liusha"))
	self.liuSha:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.liuSha:setAnchorPoint(cc.p(0, 0))
	self.liuSha:setPosition(0, 0)
	self.liuSha:setVisible(false)
	self.liuSha:pause()
	self.liuSha:setCompleteCallback(function(...)
		self.liuSha:setVisible(false)
		self.liuSha:pause()
		self.vsEnterBg:setVisible(true)
		self.vsEnterBg:start()
		self.flagAnimation:setVisible(true)
		self.flagAnimation.action:gotoFrameAndPlay(0, false)
		_ENV = false
		;(false)[1] = ffa.delay(0.1)
		;(false)[2] = ffa.callFunc(function()
			self.vsEnter:setVisible(true)
			self.vsEnter:start()
		end)
		;(false)[3] = ffa.callFunc(function()
			self.vsEnter:setVisible(true)
			self.vsEnter:start()
		end)
		self:runAction(ffa.seq(false))
	end)
	self.effectBg = cc.criSprite.createCriSprite("sp_jrzc_008.usm", false, true, nil)
	self.effectBg:addTo(SoraDGetChildByName(self, "Node_BgEffect"))
	self.effectBg:setPosition(0, 0)
	self.effectBg:setVisible(false)
	self.effectShazi = cc.criSprite.createCriSprite("sp_jrzc_006.usm", false, true, nil)
	self.effectShazi:addTo(SoraDGetChildByName(self, "Node_ShaziEffect"))
	self.effectShazi:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.effectShazi:setPosition(0, 0)
	self.btnEffect2 = cc.criSprite.createCriSprite("G_sp_jrzc_005.usm", false, true, nil)
	self.btnEffect2:addTo(SoraDGetChildByName(self, "Node_BtnEffectUP"))
	self.btnEffect2:setBlendFunc(gl.ONE, gl.ONE)
	self.btnEffect2:setPosition(0, 0)
	self.btnEffect1 = cc.criSprite.createCriSprite("G_sp_jrzc_004.usm", false, true, nil)
	self.btnEffect1:addTo(SoraDGetChildByName(self, "Node_BtnEffect"))
	self.btnEffect1:setBlendFunc(gl.ONE, gl.ONE)
	self.btnEffect1:setPosition(0, 0)
end
function atlantisWarActivityPanel:playEnterAnimation()
	self.isEnterPlaying = true
	self:playFlagScaleAnimation()
	self.liuSha:setVisible(true)
	self.liuSha:start()
	self.btnEffect2:setVisible(false)
	self.btnEffect2:pause()
	self.btnEffect1:setVisible(false)
	self.btnEffect1:pause()
end
function atlantisWarActivityPanel:playFlagScaleAnimation()
	if self.kindomList[4] then
		_ENV = nil
		;(nil)[1] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[2] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[3] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[4] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[5] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[6] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[7] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[8] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[9] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[10] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[11] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[12] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[13] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[14] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[15] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[16] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[17] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[18] = ffa.fadeTo(0.08333333333333333, 0)
		;(nil)[19] = ffa.fadeTo(0.08333333333333333, 0)
		self.kindomList[4]:getChildByName("Node_OtherUI"):runAction(ffa.seq(nil))
	end
	_UPVALUE1_ = ffa.seq(nil)
	ffa.seq(nil)[1] = ffa.delay(0.08333333333333333)
	ffa.seq(nil)[2] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[3] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[4] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[5] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[6] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[7] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[8] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[9] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[10] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[11] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[12] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[13] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[14] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[15] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[16] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[17] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[18] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(nil)[19] = ffa.fadeTo(0.08333333333333333, 0)
	self.kindomList[3]:getChildByName("Node_OtherUI"):runAction(ffa.seq(ffa.seq(nil)))
	if self.kindomList[5] then
		_UPVALUE1_ = ffa.seq(ffa.seq(nil))
		ffa.seq(ffa.seq(nil))[1] = ffa.delay(0.08333333333333333)
		ffa.seq(ffa.seq(nil))[2] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[3] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[4] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[5] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[6] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[7] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[8] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[9] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[10] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[11] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[12] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[13] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[14] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[15] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[16] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[17] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[18] = ffa.fadeTo(0.08333333333333333, 0)
		ffa.seq(ffa.seq(nil))[19] = ffa.fadeTo(0.08333333333333333, 0)
		self.kindomList[5]:getChildByName("Node_OtherUI"):runAction(ffa.seq(ffa.seq(ffa.seq(nil))))
	end
	_UPVALUE1_ = ffa.seq(ffa.seq(ffa.seq(nil)))
	ffa.seq(ffa.seq(ffa.seq(nil)))[1] = ffa.delay(0.16666666666666666)
	ffa.seq(ffa.seq(ffa.seq(nil)))[2] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[3] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[4] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[5] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[6] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[7] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[8] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[9] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[10] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[11] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[12] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[13] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[14] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[15] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[16] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[17] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[18] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(nil)))[19] = ffa.fadeTo(0.08333333333333333, 0)
	self.kindomList[1]:getChildByName("Node_OtherUI"):runAction(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))
	_UPVALUE1_ = ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[1] = ffa.delay(0.16666666666666666)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[2] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[3] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[4] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[5] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[6] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[7] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[8] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[9] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[10] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[11] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[12] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[13] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[14] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[15] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[16] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[17] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[18] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))[19] = ffa.fadeTo(0.08333333333333333, 0)
	self.kindomList[2]:getChildByName("Node_OtherUI"):runAction(ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil))))))
	_UPVALUE1_ = ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[1] = ffa.delay(0.25)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[2] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[3] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[4] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[5] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[6] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[7] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[8] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[9] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[10] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[11] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[12] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[13] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[14] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[15] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[16] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[17] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[18] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))[19] = ffa.fadeTo(0.08333333333333333, 0)
	self.myKindomNode:getChildByName("Node_OtherUI"):runAction(ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(ffa.seq(nil)))))))
	local endPos = self.myKindomNode:convertToNodeSpace(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	_UPVALUE1_ = cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)
	_UPVALUE2_ = cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)
	_UPVALUE2_ = cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[1] = ffa.delay(0.4166666666666667)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[2] = ffa.fadeTo(0.03333333333333333, 0)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[3] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[4] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[5] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[6] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[7] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[8] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[9] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[10] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[11] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[12] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[13] = ffa.callFunc(function(...)
		self.myKindomNode:setVisible(false)
	end)
	_UPVALUE1_ = ffa.delay(0.4166666666666667)
	ffa.delay(0.4166666666666667)[1] = ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)
	ffa.delay(0.4166666666666667)[2] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[3] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[4] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[5] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[6] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[7] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[8] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[9] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[10] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[11] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	ffa.delay(0.4166666666666667)[12] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
	_UPVALUE1_ = ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[1] = ffa.scaleTo(0.16666666666666666, 0.75)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[2] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[3] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[4] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[5] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[6] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[7] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[8] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[9] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[10] = ffa.scaleTo(0.2833333333333333, 0.5)
	ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[11] = ffa.scaleTo(0.2833333333333333, 0.5)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[1] = ffa.seq(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[2] = ffa.seq((ffa.delay(0.4166666666666667)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[3] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[4] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[5] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[6] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[7] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[8] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[9] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[10] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[11] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[12] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[13] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[14] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[15] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[1] = ffa.delay(0.3333333333333333)
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[2] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[3] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[4] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[5] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[6] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[7] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[8] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[9] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[10] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[11] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[12] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[13] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[14] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[15] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[16] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[17] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[18] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
	self.myKindomNode:getChildByName("Node_Flag"):runAction(ffa.seq(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)))
	_UPVALUE5_ = self.myKindomNode:getChildByName("Node_Flag").runAction
	self.myKindomNode:getChildByName("Node_Flag").runAction[1] = 0.25
	self.myKindomNode:getChildByName("Node_Flag").runAction[2] = 0.25
	self.myKindomNode:getChildByName("Node_Flag").runAction[3] = 0.16666666666666666
	self.myKindomNode:getChildByName("Node_Flag").runAction[4] = 0.08333333333333333
	local self.myKindomNode:getChildByName("Node_Flag").runAction[5], delayTime = 0.16666666666666666, self.myKindomNode:getChildByName("Node_Flag").runAction
	for k, target in ipairs(self.kindomList) do
		local endPos = target:convertToNodeSpace(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		_UPVALUE1_ = cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)
		_UPVALUE2_ = cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)
		_UPVALUE2_ = cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[1] = ffa.delay(0.4166666666666667)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[2] = ffa.fadeTo(0.03333333333333333, 0)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[3] = ffa.callFunc(function(...)
			target:setVisible(false)
		end)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[4] = ffa.callFunc(function(...)
			target:setVisible(false)
		end)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[5] = ffa.callFunc(function(...)
			target:setVisible(false)
		end)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[6] = ffa.callFunc(function(...)
			target:setVisible(false)
		end)
		_UPVALUE1_ = ffa.delay(0.4166666666666667)
		ffa.delay(0.4166666666666667)[1] = ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)
		ffa.delay(0.4166666666666667)[2] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
		ffa.delay(0.4166666666666667)[3] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
		ffa.delay(0.4166666666666667)[4] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
		ffa.delay(0.4166666666666667)[5] = ffa.moveTo(0.2833333333333333, endPos.x, endPos.y)
		_UPVALUE1_ = ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)
		ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[1] = ffa.scaleTo(0.16666666666666666, 0.75)
		ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[2] = ffa.scaleTo(0.2833333333333333, 0.5)
		ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[3] = ffa.scaleTo(0.2833333333333333, 0.5)
		ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)[4] = ffa.scaleTo(0.2833333333333333, 0.5)
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[1] = ffa.seq(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[2] = ffa.seq((ffa.delay(0.4166666666666667)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[3] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[4] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[5] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[6] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[7] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[8] = ffa.seq((ffa.moveTo(0.16666666666666666, endPos.x * 3 / 20, 130 + (endPos.y - 130) * 3 / 20)))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[1] = ffa.delay(delayTime[k])
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[2] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[3] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[4] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[5] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[6] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[7] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[8] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[9] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[10] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)[11] = ffa.spawn(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130))
		target:getChildByName("Node_Flag"):runAction(ffa.seq(cc.p(self.nodeFightUI:getPositionX(), self.nodeFightUI:getPositionY() + 130)))
	end
end
function atlantisWarActivityPanel:resetKindomAnimation()
	for i, target in ipairs(self.kindomList) do
		target:getChildByName("Node_OtherUI"):setOpacity(255)
		local nodeFlag = target:getChildByName("Node_Flag")
		target:setVisible(true)
		nodeFlag:setScale(0.8)
		nodeFlag:setOpacity(255)
		nodeFlag:setPosition(cc.p(0, -130))
	end
	local nodeFlag = self.myKindomNode:getChildByName("Node_Flag")
	self.myKindomNode:setVisible(true)
	nodeFlag:setScale(0.8)
	nodeFlag:setOpacity(255)
	nodeFlag:setPosition(cc.p(0, -130))
	self.myKindomNode:getChildByName("Node_OtherUI"):setOpacity(255)
	self.btnEffect2:setVisible(true)
	self.btnEffect2:start()
	self.btnEffect1:setVisible(true)
	self.btnEffect1:start()
end
function atlantisWarActivityPanel:msgDataReqBack(target, content)
	SoraDCloseLoading(self)
	if content.key == "reqStateDataRsp" then
		self:updateStateData()
		self:refreshView()
	elseif content.key == "reqMatchResultRsp" then
		self.matchResult = content.rspdata
		self:updateKindomNode()
	elseif content.key == "reqGetManagerInfoRsp" then
		self:updateManagerRed()
	elseif content.key == "reqRankRsp" and content.isKindomRank then
		local kingInfo
		if content.rspdata and content.rspdata.rankingList then
			kingInfo = content.rspdata.rankingList[1]
		end
		dump(kingInfo, "content.rspdata")
		if not kingInfo or kingInfo and kingInfo.rank == 1 then
			self:updateSeason(kingInfo)
			self:updateKindomRank(kingInfo)
		end
	elseif content.key == "errResetAnimation" then
		self:resetKindomAnimation()
	end
end
function atlantisWarActivityPanel:setPositionY_cocos(obj, posy)
	obj:setPositionY(self:getHeight() - posy)
end
return atlantisWarActivityPanel
