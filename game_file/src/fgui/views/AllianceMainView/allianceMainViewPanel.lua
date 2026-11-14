local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
local allianceLog = SoraDGetCtrl("allianceLog")
local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMainViewPanel = class("allianceMainViewPanel", baseFguiPanel)
function allianceMainViewPanel:ctor(...)
	allianceMainViewPanel.super.ctor(self, ...)
	print("allianceMainViewPanel:ctor", self.viewName)
end
function allianceMainViewPanel:onInit()
	print("=======allianceMainViewPanel:onInit")
	_ENV, _ENV, self.isHideCurrentSceneView = "=======allianceMainViewPanel:onInit", print, true
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.SCIENCE
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_keji.png"
	_ENV, print[1], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("common_text_191")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.STRONGPOINT
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_judian.png"
	_ENV, print[2], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("alliance_stronghold_text_100")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.STORE
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_shangdian.png"
	_ENV, print[3], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("common_text_192")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_baozang.png"
	_ENV, print[4], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("allitreas_title_01")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.ACTIVE
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_huoyue.png"
	_ENV, print[5], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("alliance_text_21")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.HELP
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_bangzhu.png"
	_ENV, print[6], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("common_text_193")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_zongdongyuan.png"
	_ENV, print[7], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("mail_text_417")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.PET
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_jitan.png"
	_ENV, print[8], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("alliance_beast_text_31")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.HUNT
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_shoulie.png"
	_ENV, print[9], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("alliance_hunt_btn_02")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.MESSAGE
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_liuyan.png"
	_ENV, print[10], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("common_text_181")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_fanji.png"
	_ENV, print[11], ("=======allianceMainViewPanel:onInit").title = "=======allianceMainViewPanel:onInit", "=======allianceMainViewPanel:onInit", i18n("CounterSystem_btn_05")
	;("=======allianceMainViewPanel:onInit").enum = ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_WAREHOUSE
	;("=======allianceMainViewPanel:onInit").png = "icon_alliance_cangku.png"
	self.enumList, print[12], ("=======allianceMainViewPanel:onInit").title = print, "=======allianceMainViewPanel:onInit", i18n("common_text_3012")
	self.fields.Com_title:initData(i18n("common_text_069"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_postSeasonBg:addClickListener(handler(self, self.btnPostSeasonClick))
	self.fields.Button_manage:setString(i18n("common_text_187"))
	self.fields.Button_manage:addClickListener(handler(self, self.btnManageClick))
	self.fields.Label_reddot:setVisible(false)
	self.fields.Button_member:setString(i18n("common_text_188"))
	self.fields.Button_member:addClickListener(handler(self, self.btnMemberClick))
	self.fields.Button_invite:setString(i18n("common_text_189"))
	self.fields.Button_invite:addClickListener(handler(self, self.btnInviteClick))
	self.fields.Button_mailAll:setString(i18n("common_text_190"))
	self.fields.Button_mailAll:addClickListener(handler(self, self.btnMailAllClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.view:fixChildrenPos()
	self.fields.n1:fix()
end
function allianceMainViewPanel:onShow()
	print("=======allianceMainViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	allianceLog:reqAllianceLogData()
	self:initData()
	self:setLogInfo()
end
function allianceMainViewPanel:checkGuideAlliance()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if not guideCtrl:updateGuideModule(gGuideModule.ALLIANCE, true) then
		print("AllianceMainView触发引导")
		guideCtrl:CompleteGuideStep(66001)
	end
end
function allianceMainViewPanel:endShow()
	self.isNeedGuide = self.param and self.param.isNeedGuide or false
	self.isShowMsg = self.param and self.param.isShowMsg or false
	self.allianceName = self.param and self.param.allianceName or ""
	if self.isShowMsg then
		_ENV = nil
		;(nil).alliance = self.allianceName
		SoraDShowMsgBox(i18n("common_text_813", nil), i18n("common_text_054"), nil, function(type, target)
			if self.checkGuideAlliance then
				self:checkGuideAlliance()
			end
		end)
		return
	end
	if self.isNeedGuide then
		self:checkGuideAlliance()
	end
end
function allianceMainViewPanel:initData()
	self.tableAlliacnePoint = allianceMgr:getAlliance()
	if self.tableAlliacnePoint == nil then
		self:close()
		return
	end
	self:setTopInfo()
	self:setMenuInfo()
	self:updateGreen()
end
function allianceMainViewPanel:updateGreen()
	if not worldMapDefine.isInWarForbid(true) and allianceDesRead.checkRank() then
		local inviteNum = allianceRelationCtrl:getAllyInviteNum()
		self.fields.Label_reddot:initData(0 < inviteNum, inviteNum)
	else
		self.fields.Label_reddot:setVisible(false)
	end
end
function allianceMainViewPanel:setTopInfo()
	self.fields.Node_flag:clearContent()
	local flagNode = allianceDesRead.getFlagNode(allianceMgr:getAllianceProperty("flag"))
	flagNode:setPosition(5, 5)
	self.fields.Node_flag:clearContent()
	self.fields.Node_flag:setContent(flagNode)
	local rank = pyramidWarCtrl:getPostSeasonTop3Rank(self.tableAlliacnePoint:getProperty("aid"))
	if 0 < rank and rank <= RANK_TOP_SPECIAL then
		allianceDesRead = RANK_TOP_SPECIAL
		RANK_TOP_SPECIAL[1] = "icon_battlefield_playoff_gold.png"
		RANK_TOP_SPECIAL[2] = "icon_battlefield_playoff_silver.png"
		local RANK_TOP_SPECIAL[3], tableIcon = "icon_battlefield_playoff_cuprum.png", RANK_TOP_SPECIAL
		self.fields.Button_postSeasonBg:setVisible(true)
		self.fields.Button_postSeasonBg:setIcon(tableIcon[rank])
	else
		self.fields.Button_postSeasonBg:setVisible(false)
	end
	allianceDesRead = self.tableAlliacnePoint:getProperty("aid")
	self.tableAlliacnePoint:getProperty("aid").abbr = self.tableAlliacnePoint:getProperty("abbr")
	self.tableAlliacnePoint:getProperty("aid").name = self.tableAlliacnePoint:getProperty("name")
	self.fields.Text_alliance:setString(i18n("common_text_186", self.tableAlliacnePoint:getProperty("aid")))
	allianceDesRead = i18n("common_text_186", self.tableAlliacnePoint:getProperty("aid"))
	i18n("common_text_186", self.tableAlliacnePoint:getProperty("aid")).name = self.tableAlliacnePoint:getProperty("leaderName")
	self.fields.Text_leader:setString(i18n("common_text_170", i18n("common_text_186", self.tableAlliacnePoint:getProperty("aid"))))
	self.fields.Text_memberCount:setString(self.tableAlliacnePoint:getMemberCount() .. "/" .. self.tableAlliacnePoint:getProperty("limitCount"))
	self.fields.Text_power:setString(string.formatnumberthousands(allianceMgr:getAllianceTotalBattle()))
	self.fields.Text_areaCount:setString(string.formatnumberthousands(allianceTerritoryAPI:getScore()))
	self.fields.Text_language:setString(allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")))
end
function allianceMainViewPanel:setLogInfo(target, data)
	local logListData = allianceLog:getLogList()
	local lastData = logListData[1]
	if lastData then
		self.fields.Text_dateTime:setString(lastData.key)
		self.fields.Btn_log:initData(lastData.data[1], true)
	end
end
function allianceMainViewPanel:onItemRenderer(index, obj)
	obj:initData(self.enumList[index + 1].enum, self.enumList[index + 1].png, self.enumList[index + 1].title)
end
function allianceMainViewPanel:setMenuInfo()
	self.fields.Btn_allianceWar:initData(ALLIANCE_MAIN_MENU_TYPE.BATTLE, "icon_alliance_lianmengzhanzheng.png", i18n("common_text_047"))
	self.fields.Btn_allianceArea:initData(ALLIANCE_MAIN_MENU_TYPE.BUILD, "icon_alliance_lianmenglingdi.png", i18n("alliance_stronghold_text_001"))
	self.fields.List:setNumItems(#self.enumList)
end
function allianceMainViewPanel:btnPostSeasonClick()
	SoraDPlaySound()
	SoraDCreatePanel("pyramidBattleHonourBoard"):show()
end
function allianceMainViewPanel:btnManageClick()
	SoraDPlaySound()
	if not worldMapDefine.isInWarForbid() then
		uiManager:show("allianceManageView")
	end
end
function allianceMainViewPanel:btnMemberClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).aid = self.tableAlliacnePoint:getProperty("aid")
	uiManager:show("allianceMemberList", nil)
end
function allianceMainViewPanel:btnInviteClick()
	SoraDPlaySound()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if not worldMapDefine.isInWarForbid() then
		uiManager:show("allianceInviteView")
	end
end
function allianceMainViewPanel:btnMailAllClick()
	SoraDPlaySound()
	local ownaid = allianceMgr:getOwnAid()
	if not permissionCtrl:hasPlayerPermission(gAPermission.MAIL_ALL) then
		_ENV = nil
		;(nil).des = i18n("common_text_2372")
		SoraDShowMsgTip(i18n("common_text_2371", nil))
	else
		uiManager:show("allianceGroupMailView")
	end
end
function allianceMainViewPanel:onClickHelp()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_WAREHOUSE)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.ALLIANCE)
	end
end
function allianceMainViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "allianceMenuSingle" then
		if parameters.index == ALLIANCE_MAIN_MENU_TYPE.BATTLE then
			return self.fields.Btn_allianceWar
		elseif parameters.index == ALLIANCE_MAIN_MENU_TYPE.BUILD then
			return self.fields.Btn_allianceArea
		else
			local index = 1
			for k, v in ipairs(self.enumList) do
				if parameters.index == v.enum then
					index = k
					break
				end
			end
			return self.fields.List:getChildAt(index - 1)
		end
	end
	if itemName == "CCS_allianceMainScroll_scroll" then
		return self.fields.guide_scroll
	end
	return self.fields[itemName]
end
return allianceMainViewPanel
