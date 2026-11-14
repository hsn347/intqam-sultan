local gametop = gModuleMgr.getObject("gametop")
local allianceDesRead = include("allianceDesRead")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local AllianceListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceCreateView/AllianceListSingle", AllianceListSingle)
function AllianceListSingle:onInit()
	self.flag = nil
	self.uid = gametop.playertop_:getPlayerID()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	self.hasJoin = allianceMgr:hasJoinAlliance()
	self:addClickListener(handler(self, self.btnClickCallBack))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Com_castleLv:fixChildrenPos()
	end
	local nodeFlag = display.newNode()
	nodeFlag:setScale(0.7)
	nodeFlag:setName("Node_flag")
	self.fields.Loader3D_flag:setContent(nodeFlag)
	self.nodeFlag = nodeFlag
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CANCEL_APPLY_JOIN", handler(self, self.refreshJoinAlliance))
end
function AllianceListSingle:onShow()
end
function AllianceListSingle:initData(alliance)
	if alliance == nil then
		return
	end
	self.alliance = alliance
	_ENV = nil
	;(nil).abbr = alliance:getProperty("abbr")
	;(nil).name = alliance:getProperty("name")
	self.fields.Text_name:setString(i18n("common_text_186", nil))
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).name = alliance:getProperty("leaderName")
	self.fields.Text_leader:setString(i18n("common_text_170", i18n("common_text_186", nil)))
	self.fields.Text_power:setString(string.formatnumberthousands(alliance:getProperty("totalBattle")))
	self.fields.Text_member:setString(alliance:getMemberCount() .. "/" .. alliance:getProperty("limitCount"))
	self.fields.Text_language:setString(allianceDesRead.getLanguageName(alliance:getProperty("language")))
	self:initFlag()
	self:initJoinCondition()
	self:updateBWList()
	self:updateApplyLabel()
end
function AllianceListSingle:initFlag(...)
	local newFlag = self.alliance:getProperty("flag")
	if self.flag ~= newFlag then
		self.flag = newFlag
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(newFlag, self.nodeFlag)
	end
end
function AllianceListSingle:initJoinCondition(...)
	if self.hasJoin then
		self.fields.Group_join:setVisible(false)
		return
	end
	if self.alliance:hasInvitation(self.uid) then
		self.fields.Group_join:setVisible(false)
		return
	end
	self.fields.Group_join:setVisible(true)
	local str = i18n("common_text_1160")
	if self.alliance:getProperty("recruitType") == gARecruit.public then
		_ENV = "notice_0206"
		;("notice_0206").color = "#F3CB3B"
		str = string.format("%s(%s)", str, SoraDWrapHtmlTagByStyle(i18n("notice_0206"), "notice_0206"))
	end
	self.fields.Text_join:setString(str)
	local castleLv = self.alliance:getProperty("joinLevel")
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	self.fields.Com_castleLv:setString(castleLv)
	self.fields.Com_castleLv:setIcon(castleImg)
	local joinPower = self.alliance:getProperty("joinPower")
	self.fields.Text_joinPower:setString(string.formatnumberthousands(joinPower))
end
function AllianceListSingle:updateBWList()
	if self.hasJoin then
		local allianceBWList = SoraDGetCtrl("allianceBWList")
		local bwLType = allianceBWList:isInBWList(self.alliance:getProperty("aid"))
		if bwLType ~= nil then
			self.fields.Sprite_list:setURL(bwLType == gAllianceBWListType.BLACK and "icon_alliance_blacklist.png" or "icon_alliance_whitelist.png")
			self.fields.Sprite_list:setVisible(true)
		else
			self.fields.Sprite_list:setVisible(false)
		end
	else
		self.fields.Sprite_list:setVisible(false)
	end
end
function AllianceListSingle:updateApplyLabel(...)
	if self.hasJoin then
		self.fields.Group_apply:setVisible(false)
		return
	end
	if self.alliance:hasInvitation(self.uid) then
		self.fields.Group_apply:setVisible(true)
		self.fields.Text_apply:setString(i18n("notice_0207"))
		return
	end
	local memberMgr = SoraDGetCtrl("memberMgr")
	local member = memberMgr:getOwnMember()
	if member:getProperty("curApplyAid") == self.alliance:getProperty("aid") then
		self.fields.Group_apply:setVisible(true)
		self.fields.Text_apply:setString(i18n("common_text_1051"))
		return
	end
	self.fields.Group_apply:setVisible(false)
end
function AllianceListSingle:btnClickCallBack()
	SoraDPlaySound()
	SoraDOpenAllianceInfoView(self.alliance, self.kid)
end
function AllianceListSingle:refreshJoinAlliance(target, data)
	if self.alliance and data.aid == self.alliance:getProperty("aid") then
		self:updateApplyLabel()
	end
end
function AllianceListSingle:initSearchData(alliance)
	self.kid = alliance.kid
	self:initData(alliance.alliance)
	self.fields.Group_apply:setVisible(true)
	_ENV = nil
	;(nil).kid = self.kid
	self.fields.Text_apply:setString(i18n("common_text_342", nil))
	self:hiddleBWIcon(true)
end
function AllianceListSingle:hiddleBWIcon(isHiddle)
	self.fields.Sprite_list:setVisible(not isHiddle)
end
return AllianceListSingle
