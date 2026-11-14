local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local AllianceMainView = class("allianceMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMainView")
	end
	return target
end)
function AllianceMainView:ctor()
	self.isHideCurrentSceneView = true
	self:setName("AllianceMainView")
	self.tableAlliacnePoint = nil
	self.labelAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.labelLeader = SoraDGetChildByName(self, "Text_leader")
	self.labelLeaderName = SoraDGetChildByName(self, "Text_leader_name")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelMemberCount = SoraDGetChildByName(self, "Text_memberCount")
	self.labelAreaCount = SoraDGetChildByName(self, "Text_areaCount")
	self.labelLanguage = SoraDGetChildByName(self, "Text_language")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.btnManage = SoraDGetChildByName(self, "Button_manage")
	self.btnMember = SoraDGetChildByName(self, "Button_member")
	self.btnInvite = SoraDGetChildByName(self, "Button_invite")
	self.btnMailAll = SoraDGetChildByName(self, "Button_mailAll")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.spriteGreen = SoraDGetChildByName(self.btnManage, "Sprite_green")
	self.spriteGreen:setVisible(false)
	self.labelNum = SoraDGetChildByName(self.spriteGreen, "Text_num")
	self.labelManage = SoraDGetChildByName(self, "Text_manage")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelInvite = SoraDGetChildByName(self, "Text_invite")
	self.labelMailAll = SoraDGetChildByName(self, "Text_mailAll")
	self.labelManage:setString(i18n("common_text_187"))
	self.labelMember:setString(i18n("common_text_188"))
	self.labelInvite:setString(i18n("common_text_189"))
	self.labelMailAll:setString(i18n("common_text_190"))
	SoraDGetChildByName(self, "Image_tile_line"):setFillType(1)
	self.scrollMain = SoraDGetExtendChildFromCCSByName(self, "CCS_allianceMainScroll_scroll", true)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_069"))
	self.scrollMain:setHandle(function(isMainScrollShow)
		self.bottomNode:setVisible(isMainScrollShow)
	end)
	self.btnInvite:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnManage:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnMember:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnMailAll:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnHelp:addTouchEventListener(handler(self, self.btnClickCallBack))
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS", handler(self, self.updateFlag))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreen))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(...)
		SoraDRemoveAllPanelFromManager()
	end)
end
function AllianceMainView:updateGreen()
	if not worldMapDefine.isInWarForbid(true) and allianceDesRead.checkRank() then
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		local inviteNum = allianceRelationCtrl:getAllyInviteNum()
		if not tolua.isnull(self.spriteGreen) then
			self.spriteGreen:setVisible(0 < inviteNum)
			self.labelNum:setString(tostring(inviteNum))
		end
	elseif not tolua.isnull(self.spriteGreen) then
		self.spriteGreen:setVisible(false)
	end
end
function AllianceMainView:click2View()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
	;(nil).step = 66001
	SoraDSendMessage(nil)
end
function AllianceMainView:updateFlag()
	local curFlag = allianceMgr:getAllianceProperty("flag")
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(curFlag, self.nodeFlag)
	allianceDesRead.showPyramidPlayoffsTop3(self.tableAlliacnePoint:getProperty("aid"), self)
end
function AllianceMainView:initData()
	self.tableAlliacnePoint = allianceMgr:getAlliance()
	if self.tableAlliacnePoint == nil then
		SoraDRemoveMessageByTarget(self)
		self:removeFromParent()
		return
	end
	allianceMgr = nil
	;(nil).abbr = self.tableAlliacnePoint:getProperty("abbr")
	;(nil).name = self.tableAlliacnePoint:getProperty("name")
	self.labelAlliance:setString(i18n("common_text_186", nil))
	self.labelLeader:setString(i18n("common_text_526") .. ": ")
	self.labelLeaderName:setString(self.tableAlliacnePoint:getProperty("leaderName") or "")
	self.labelLeaderName:setPositionX(self.labelLeader:getPositionX() + self.labelLeader:getContentSize().width)
	if SoraDFIsRA() then
		self.labelLeaderName:setPositionX(self.labelLeader:getPositionX() - self.labelLeader:getContentSize().width)
	end
	self.labelPower:setString(string.formatnumberthousands(allianceMgr:getAllianceTotalBattle()))
	self.labelMemberCount:setString(self.tableAlliacnePoint:getMemberCount() .. "/" .. self.tableAlliacnePoint:getProperty("limitCount"))
	self.labelLanguage:setString(allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")))
	self.labelAreaCount:setString(string.formatnumberthousands(allianceTerritoryAPI:getScore()))
	self:updateFlag()
	self:updateGreen()
end
local reportAllianceControl2Firebase = function(...)
	userSDKManager.report2firebase("reportAlliance")
end
function AllianceMainView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		reportAllianceControl2Firebase()
		if self.btnMember == button then
			if GLOBAL_GAME_ALLIANCE_MODE then
				_ENV = nil
				;(nil).aid = self.tableAlliacnePoint:getProperty("aid")
				uiManager:show("allianceMemberList", nil)
			else
				local panel = SoraDCreatePanel("allianceMemberList")
				panel:initData(self.tableAlliacnePoint:getProperty("aid"))
				panel:show()
			end
		elseif self.btnInvite == button then
			if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				return
			end
			if not worldMapDefine.isInWarForbid() then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("allianceInviteView")
				else
					SoraDCreatePanel("allianceInviteView"):show()
				end
			end
		elseif self.btnManage == button then
			if not worldMapDefine.isInWarForbid() then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("allianceManageView")
				else
					SoraDCreatePanel("allianceManageView"):show()
				end
			end
		elseif self.btnMailAll == button then
			local ownaid = allianceMgr:getOwnAid()
			if not permissionCtrl:hasPlayerPermission(gAPermission.MAIL_ALL) then
				_ENV = self.tableAlliacnePoint:getProperty("aid")
				self.tableAlliacnePoint:getProperty("aid").des = i18n("common_text_2372")
				SoraDShowMsgTip(i18n("common_text_2371", self.tableAlliacnePoint:getProperty("aid")), nil, button)
			elseif GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceGroupMailView")
			else
				SoraDCreatePanel("allianceGroupMailView"):show()
			end
			return
		elseif self.btnHelp == button then
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_WAREHOUSE)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.ALLIANCE)
			end
		end
	end
end
function AllianceMainView:mainScrollMenuCall(menuType)
	self.scrollMain:menuCallBack(menuType)
end
function AllianceMainView:gameGuide_getTarget(itemName, parameters)
	if itemName == "allianceMenuSingle" then
		return self.scrollMain.tableMainSingle[parameters.index].nodeTouch
	end
	if itemName == "CCS_allianceMainScroll_scroll" then
		return SoraDGetChildByName(self.scrollMain, "ScrollView_alliance")
	end
	if itemName == "Image_1" then
		local img = SoraDGetChildByName(self.bottomNode, "Image_1")
		img:setPositionY(1)
		return img
	end
	return SoraDGetChildByName(self, itemName)
end
return AllianceMainView
