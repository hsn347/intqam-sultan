local allianceDesRead = include("allianceDesRead")
local lordSpineDef = include("lordSpineDef")
local memberMgr = SoraDGetCtrl("memberMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMemberSettingPanel = class("allianceMemberSettingPanel", baseFguiPanel)
function allianceMemberSettingPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceMemberSettingPanel:ctor", self.viewName)
end
function allianceMemberSettingPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceMemberSettingPanel:onInit()
	print("=======allianceMemberSettingPanel:onInit")
	self.tableBtnRightSingle, _ENV, self.tableBtnLeftSingle, _ENV = print, print, print, print
	self.fields.Btn_kingAppoint:setVisible(false)
	for i = 1, 4 do
		self.tableBtnLeftSingle[i] = self.fields["Btn_left_" .. i]
		self.tableBtnRightSingle[i] = self.fields["Btn_right_" .. i]
		self.fields["Btn_left_" .. i]:fixPos()
		self.fields["Btn_right_" .. i]:fixPos()
	end
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClick))
end
function allianceMemberSettingPanel:onShow()
	print("=======allianceMemberSettingPanel:onShow")
	self.isOwnAlliance = self.param.isOwnAlliance
	self.tableSingleData = self.param.singleData
	self:initData()
end
function allianceMemberSettingPanel:initData()
	self.official = self.tableSingleData:getProperty("official") or gAllianceOfficial.NONE
	self.rank = self.tableSingleData:getProperty("rank")
	self:initView()
end
function allianceMemberSettingPanel:initView()
	if self.official >= gAllianceOfficial.COMMANDER and self.official <= gAllianceOfficial.RECRUITER then
		self.fields.Sprite_title:setVisible(false)
		self.fields.Button_official:setVisible(true)
		self.fields.Button_official:setString(allianceDesRead.getOfficialName(self.official))
	else
		self.fields.Sprite_title:setVisible(true)
		self.fields.Button_official:setVisible(false)
		self.fields.Sprite_title:setSpriteFrame(allianceDesRead.getCrown(self.tableSingleData:getProperty("rank")))
	end
	self.fields.Spine_lord:initData(self.tableSingleData:getProperty("iconID"))
	self.fields.Text_name:setString(self.tableSingleData:getProperty("nickName"))
	self:initMenu()
	self:showHonorBackNode()
end
function allianceMemberSettingPanel:initMenu()
	;(nil).left, memberMgr, (nil).right, memberMgr, (nil).right, memberMgr, (nil).left, memberMgr, memberMgr = nil, nil, nil, nil, nil, nil, nil, nil, nil
	local menuList
	if self.isOwnAlliance then
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		local ownMapId = ownmember:getProperty("mapId")
		if ownMapId and self.tableSingleData:getProperty("mapId") == nil then
			menuList.right[1] = gAPermission.MAIL_ALL
		else
			local rank = self.tableSingleData:getProperty("rank")
			local rfKid = self.tableSingleData:getProperty("rfKid")
			if self.tableSingleData:getProperty("uid") ~= lordInfoCtrl:getLordInfo().base.uid then
				if rank == gAllianceRank.R0 then
					menuList = permissionCtrl:getNewMemberMenu()
				else
					menuList = permissionCtrl:getMemberMenu(rank, rfKid)
				end
			end
			if ownRank == gAllianceRank.R5 and KWKingdomCtrl:isProxyKing() then
				self.fields.Btn_kingAppoint:initData(gAPermission.APPOINT_KING, self.tableSingleData)
				self.fields.Btn_kingAppoint:setVisible(true)
			else
				self.fields.Btn_kingAppoint:setVisible(false)
			end
		end
	else
		menuList.right[1] = gAPermission.MAIL_ALL
	end
	self:refreshMenuBtn(menuList)
end
function allianceMemberSettingPanel:refreshMenuBtn(menuList)
	for i, v in ipairs(self.tableBtnLeftSingle) do
		if menuList.right[i] then
			v:setVisible(true)
			v:initData(menuList.right[i], self.tableSingleData)
		else
			v:setVisible(false)
		end
	end
	for i, v in ipairs(self.tableBtnRightSingle) do
		if menuList.left[i] then
			v:setVisible(true)
			v:initData(menuList.left[i], self.tableSingleData)
		else
			v:setVisible(false)
		end
	end
end
function allianceMemberSettingPanel:updateData()
	self.tableSingleData = memberMgr:getMember(self.tableSingleData:getProperty("uid"))
	if self.tableSingleData == nil or self.tableSingleData.getProperty == nil then
		self:close()
		return
	end
	local rank = self.tableSingleData:getProperty("rank")
	self.official = self.tableSingleData:getProperty("official") or gAllianceOfficial.NONE
	self.rank = rank
	self:initView()
end
function allianceMemberSettingPanel:btnClick()
	local gametop = gModuleMgr.getObject("gametop")
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.tableSingleData:getProperty("uid")
	;(nil).kid = gametop.playertop_:getKingdomID()
	SoraDSendMessage(nil)
end
function allianceMemberSettingPanel:memberSettingClose(target, data)
	if data.uid == self.tableSingleData:getProperty("uid") then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function allianceMemberSettingPanel:kingdomusrChanged(target, data)
	SoraDRemoveAllAfterPanelFromManager(self)
end
function allianceMemberSettingPanel:showHonorBackNode(...)
	if self.node_honorBack then
		self.node_honorBack:setVisible(false)
	end
end
return allianceMemberSettingPanel
