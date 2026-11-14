local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local scrollNode = include("scrollNode")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local buildLogic = include("buildLogic")
local remainsWarRead = include("remainsWarRead")
local teamApprovalListSingle = class("teamApprovalListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApprovalListSingle")
	end
	return target
end)
local TEAM_APPROVAL_TYPE_INVITED = _G.TEAM_APPROVAL_TYPE_INVITED
function teamApprovalListSingle:ctor()
	self.btnJoin = SoraDGetChildByName(self, "Button_join")
	self.btnJoin = scrollNode.new(self.btnJoin)
	self.btnJoin:setSwallowTouches(false)
	self.btnJoin:setPressedActionEnabled(false)
	self.btnJoin:addTouchEventListener(handler(self, self.btnJoinClickCallBack))
	self.imgFlg = SoraDGetChildByName(self, "Image_flg")
	self.spriteCrown = SoraDGetChildByName(self, "Sprite_crown")
	self.imgPortrait = SoraDGetChildByName(self, "Image_portrait")
	self.spriteCastle = SoraDGetChildByName(self, "Sprite_castle")
	self.labelOnline = SoraDGetChildByName(self, "Text_online")
	self.labelOnline:setString(i18n("common_text_224"))
	self.labelLastTime = SoraDGetChildByName(self, "Text_lastTime")
	self.labelCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	local x, y = self.spriteCrown:getPosition()
	_ENV = i18n("common_text_224")
	i18n("common_text_224").parent = self.spriteCrown:getParent()
	i18n("common_text_224").pos = cc.p(x, y - 20)
	i18n("common_text_224").scale = 0.4
	self.tableSingleData, _ENV, self.starNode = SoraDGetRemainsWarStartNodeEx(0, i18n("common_text_224")), SoraDGetRemainsWarStartNodeEx(0, i18n("common_text_224")), SoraDGetRemainsWarStartNodeEx(0, i18n("common_text_224"))
	self.handle = nil
	self.canInvited = true
end
function teamApprovalListSingle:initData(data)
	self.tableSingleData = data
	self:showAllianceMember()
	self:updateView()
end
function teamApprovalListSingle:updateView()
	self:updateBtnStatus()
end
function teamApprovalListSingle:updateBtnStatus()
	local remainNum = remainsTeamCtrl:getTeamRemainNum()
	local canInvited = 0 < remainNum
	local btnTitleID
	if self.tableSingleData.viewType == TEAM_APPROVAL_TYPE_INVITED then
		local noInvite = not self.tableSingleData.hasInvite
		btnTitleID = noInvite and "common_text_189" or "remains_btn_15"
		local enable = noInvite and canInvited
		self.btnJoin:setTouchEnabled(enable)
		self.btnJoin:setBright(enable)
	else
		btnTitleID = "remains_btn_18"
		local isLeader = remainsTeamCtrl:isTeamLeader()
		local enable = isLeader and canInvited
		self.btnJoin:setTouchEnabled(enable)
		self.btnJoin:setBright(enable)
	end
	self.btnJoin:setTitleText(i18n(btnTitleID))
end
function teamApprovalListSingle:btnJoinClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.joinHandle then
			self.joinHandle(self.tableSingleData)
		end
	end
end
function teamApprovalListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
function teamApprovalListSingle:setScroll(scroll)
	self.btnJoin:setScroll(scroll)
end
function teamApprovalListSingle:setHandle(handle)
	self.handle = handle
end
function teamApprovalListSingle:setJoinHandle(handle)
	self.joinHandle = handle
end
function teamApprovalListSingle:showAllianceMember()
	local rank = self.tableSingleData.rank or 1
	self.imgFlg:loadTexture(allianceDesRead.getFlg(rank), ccui.TextureResType.plistType)
	self.imgPortrait:loadTexture(lordLocalData.getBust(self.tableSingleData.headid), ccui.TextureResType.plistType)
	self.labelPower:setString(string.formatnumberthousands(self.tableSingleData.rankScore))
	local iconPath = remainsWarRead.getDanIcon(self.tableSingleData.segment)
	self.spriteCrown:setSpriteFrame(iconPath)
	self.starNode.updateStar(self.tableSingleData.star)
	self:setCastleLv(self.tableSingleData.cityLevel)
	self:showStatus()
	self:showName()
end
function teamApprovalListSingle:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and 1 <= warLv then
		clv = warLv
		castleImg = "301101.png"
	end
	self.spriteCastle:setSpriteFrame(castleImg)
	self.spriteCastle:setScale(35 / self.spriteCastle:getContentSize().width)
	self.labelCastleLv:setString(tostring(math.min(clv, 30)))
end
function teamApprovalListSingle:showName()
	local name = self.tableSingleData.nickName
	local allianceAbbr = self.tableSingleData.allianceAbbr
	if allianceAbbr ~= nil and type(allianceAbbr) == "string" and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = self.tableSingleData.nickName
		name = i18n("common_text_186", nil)
	end
	if self.tableSingleData.kid then
		name = name .. "#" .. tostring(self.tableSingleData.kid)
	end
	self.labelName:setString(name)
end
function teamApprovalListSingle:showStatus()
	local isOnline = (self.tableSingleData.online or 0) == 0
	self.labelOnline:setVisible(isOnline)
	self.labelLastTime:setVisible(not isOnline)
	if not isOnline then
		self.imgFlg:getVirtualRenderer():setState(1)
		self.labelPower:setColor(cc.c3b(145, 145, 145))
		self.labelCastleLv:setColor(cc.c3b(145, 145, 145))
		self.labelLastTime:setString(_G.SoraDConverSecondToDateByTime(self.tableSingleData.online, false, true, true))
	else
		self.imgFlg:getVirtualRenderer():setState(0)
		self.labelPower:setColor(cc.c3b(247, 216, 71))
		self.labelCastleLv:setColor(cc.c3b(255, 210, 138))
	end
end
return teamApprovalListSingle
