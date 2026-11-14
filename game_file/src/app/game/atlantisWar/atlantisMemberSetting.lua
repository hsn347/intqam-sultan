local gametop = gModuleMgr.getObject("gametop")
local lordSpineDef = include("lordSpineDef")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local allianceMemberSetting = include("allianceMemberSetting")
local atlantisMemberSetting = class("atlantisMemberSetting", allianceMemberSetting)
function atlantisMemberSetting:ctor(...)
	atlantisMemberSetting.super.ctor(self, ...)
	self.tableBtnRightSingle, atlantisMemberSetting, self.tableBtnLeftSingle, atlantisMemberSetting = atlantisMemberSetting.super.ctor, atlantisMemberSetting.super.ctor, atlantisMemberSetting.super.ctor, atlantisMemberSetting.super.ctor
	for i = 1, 4 do
		local settingIcon = SoraDGetChildByName(self, "CCS_allianceSettingIcon_left_" .. i)
		self.tableBtnLeftSingle[i] = SoraDCreatePanelByCloneNode(settingIcon, "atlantisMemberSettingIcon")
	end
	for i = 1, 4 do
		local settingIcon = SoraDGetChildByName(self, "CCS_allianceSettingIcon_right_" .. i)
		self.tableBtnRightSingle[i] = SoraDCreatePanelByCloneNode(settingIcon, "atlantisMemberSettingIcon")
	end
end
function atlantisMemberSetting:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_MEMBERCLASS", handler(self, self.updateMemberClass))
end
function atlantisMemberSetting:initData(singleData)
	self:setTableSingleData(singleData)
	self.memberClass = self.tableSingleData.memberClass
	self:initView()
end
function atlantisMemberSetting:initView()
	self.spriteTitle:setVisible(false)
	self.Node_officialName:setVisible(false)
	self:refreshLordSpine(self.tableSingleData.headid)
	self.lableName:setString(self.tableSingleData.nickName)
	self:initMenu()
end
function atlantisMemberSetting:setTableSingleData(singleData)
	local _ENV, member
	_ENV = nil
	;(nil).__index = singleData
	setmetatable(member, nil)
	function member.getProperty(target, key)
		return target[key]
	end
	self.tableSingleData = member
end
function atlantisMemberSetting:updateMemberClass(target, event)
	if not event.uid or event.uid ~= self.tableSingleData.uid then
		return
	end
	if event.err == gErrDef.Err_ATLANTIS_WAR_MEMBER_CLASS_HAS_CHANGED then
		SoraDShowMsgTip(i18n("notice_0026"))
		self:close(nil, ccui.TouchEventType.ended)
		return
	end
	local singleData = atlantisWarCtrl:getCampPlayerByUid(self.tableSingleData.uid)
	local memberClass = singleData.memberClass
	if memberClass == self.memberClass then
		return
	end
	if memberClass > self.memberClass then
		self:addUpRankEffect()
	elseif memberClass < self.memberClass then
		self:addDownRankEffect()
	end
	self:setTableSingleData(singleData)
	self.memberClass = memberClass
	self:initView()
end
function atlantisMemberSetting:initMenu()
	;(nil).right, gametop, (nil).left, gametop, gametop = nil, nil, nil, nil, nil
	local menuList
	local selfUid = gametop.playertop_:getPlayerID()
	if selfUid ~= self.tableSingleData.uid and self.memberClass ~= gAtlantisRankType.R0 then
		gametop = self.memberClass
		self.memberClass[1] = gAPermission.HELP_SOLDIERS
		menuList.right, self.memberClass[3] = self.memberClass, gAPermission.MAIL_ALL
	end
	gametop = self.memberClass
	gametop = nil
	gametop = nil
	;(nil)[gAtlantisRankType.R1], (nil)[2] = nil, gAPermission.PROMOTE_MEMBER
	gametop = nil
	;(nil)[1] = gAPermission.DEMOTE_MEMBER
	;(nil)[gAtlantisRankType.R2], (nil)[2] = nil, gAPermission.PROMOTE_MEMBER
	gametop = nil
	self.memberClass[gAtlantisRankType.Manager], (nil)[gAtlantisRankType.R3], (nil)[1] = nil, nil, gAPermission.DEMOTE_MEMBER
	local menuLeftConfig = self.memberClass
	local selfMemberClass = atlantisWarCtrl:getSelfMemberClass()
	if not menuLeftConfig[selfMemberClass] or not menuLeftConfig[selfMemberClass][self.memberClass] then
		gametop = menuLeftConfig[selfMemberClass][self.memberClass]
	end
	menuList.left = menuLeftConfig[selfMemberClass][self.memberClass]
	self:refreshMenuBtn(menuList)
end
return atlantisMemberSetting
