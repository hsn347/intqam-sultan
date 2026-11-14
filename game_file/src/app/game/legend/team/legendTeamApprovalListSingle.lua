local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local scrollNode = include("scrollNode")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local buildLogic = include("buildLogic")
local legendTeamUtil = include("legendTeamUtil")
local legendTeamApprovalListSingle = class("legendTeamApprovalListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamApprovalListSingle")
	end
	return target
end)
local TEAM_APPROVAL_TYPE_INVITED = _G.TEAM_APPROVAL_TYPE_INVITED
function legendTeamApprovalListSingle:ctor()
	local getBtn = function(name)
		local btn = SoraDGetChildByName(self, name)
		btn = scrollNode.new(btn)
		btn:setSwallowTouches(false)
		return btn
	end
	self.btnJoin = getBtn("Button_join")
	self.btnJoin:setPressedActionEnabled(false)
	self.btnJoin:addTouchEventListener(handler(self, self.btnJoinClickCallBack))
	self.btnReject = getBtn("Button_reject")
	self.btnReject:setString(i18n("legendaryking_text_83"))
	self.btnReject:addTouchEventListener(handler(self, self.btnRejectClickCallBack))
	self.btnAgree = getBtn("Button_agree")
	self.btnAgree:setString(i18n("remains_btn_18"))
	self.btnAgree:addTouchEventListener(handler(self, self.btnAgreeClickCallBack))
	self.checkBox = getBtn("CheckBox")
	self.checkBox:addTouchEventListener(handler(self, self.onClickCheckBox))
	self.imgFlg = SoraDGetChildByName(self, "Image_flg")
	self.spriteCrown = SoraDGetChildByName(self, "Sprite_crown")
	self.imgPortrait = SoraDGetChildByName(self, "Image_portrait")
	self.spriteCastle = SoraDGetChildByName(self, "Sprite_castle")
	self.spriteStar = SoraDGetChildByName(self, "Sprite_star")
	self.labelOnline = SoraDGetChildByName(self, "Text_online")
	self.labelOnline:setString(i18n("common_text_224"))
	self.labelLastTime = SoraDGetChildByName(self, "Text_lastTime")
	self.labelCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self.labelStarLv = SoraDGetChildByName(self, "Text_starLv")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.tableSingleData, _ENV, self.labelName = SoraDGetChildByName(self, "Text_name"), SoraDGetChildByName(self, "Text_name"), SoraDGetChildByName(self, "Text_name")
	self.handle = nil
	self.canInvited = true
	local Node_jinnBeastLv = SoraDGetChildByName(self, "Node_jinnBeastLv")
	local obj = fgui.UIPackage:createObject("CommonUI", "Com_jinnBeastLv")
	obj:addTo(Node_jinnBeastLv, 1)
	obj:setScale(0.8)
	self.Com_jinnBeastLv = obj
end
function legendTeamApprovalListSingle:initOtherData(otherData)
	self.isBatch = otherData.isBatch or false
	local scroll = otherData.scroll
	if scroll then
		self:setScroll(scroll)
	end
	local joinHandle = otherData.joinHandle
	if joinHandle then
		self:setJoinHandle(joinHandle)
	end
end
function legendTeamApprovalListSingle:initData(data)
	dump(data, "==legendTeamApprovalListSingle:initData==")
	self.tableSingleData = data
	self:showAllianceMember()
	self:updateView()
end
function legendTeamApprovalListSingle:updateView()
	self:updateIsBatch()
	if not self.isBatch then
		self:updateBtnStatus()
	end
end
function legendTeamApprovalListSingle:updateBtnStatus()
	local remainNum = legendTeamCtrl:getTeamRemainNum()
	local canInvited = 0 < remainNum
	local btnTitleID
	if self.tableSingleData.viewType == TEAM_APPROVAL_TYPE_INVITED then
		local noInvite = not self.tableSingleData.hasInvite
		btnTitleID = noInvite and "common_text_189" or "remains_btn_15"
		local enable = noInvite and canInvited
		self.btnJoin:setTouchEnabled(enable)
		self.btnJoin:setBright(enable)
		self.btnJoin:setVisible(true)
		self.btnAgree:setVisible(false)
		self.btnReject:setVisible(false)
	else
		btnTitleID = "remains_btn_18"
		local isLeader = legendTeamCtrl:isTeamLeader()
		local enable = isLeader and canInvited
		self.btnJoin:setVisible(false)
		self.btnAgree:setVisible(true)
		self.btnAgree:setTouchEnabled(enable)
		self.btnAgree:setBright(enable)
		self.btnReject:setVisible(true)
		self.btnReject:setTouchEnabled(enable)
		self.btnReject:setBright(enable)
	end
	self.btnJoin:setTitleText(i18n(btnTitleID))
end
function legendTeamApprovalListSingle:btnJoinClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.joinHandle then
			self.joinHandle(self.tableSingleData)
		end
	end
end
function legendTeamApprovalListSingle:btnRejectClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.joinHandle then
			self.joinHandle(self.tableSingleData, true)
		end
	end
end
function legendTeamApprovalListSingle:btnAgreeClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.joinHandle then
			self.joinHandle(self.tableSingleData)
		end
	end
end
function legendTeamApprovalListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
function legendTeamApprovalListSingle:setScroll(scroll)
	self.btnJoin:setScroll(scroll)
	self.btnReject:setScroll(scroll)
	self.btnAgree:setScroll(scroll)
	self.checkBox:setScroll(scroll)
end
function legendTeamApprovalListSingle:setHandle(handle)
	self.handle = handle
end
function legendTeamApprovalListSingle:setJoinHandle(handle)
	self.joinHandle = handle
end
function legendTeamApprovalListSingle:showAllianceMember()
	local rank = self.tableSingleData.rank or 1
	self.imgFlg:loadTexture(allianceDesRead.getFlg(rank), ccui.TextureResType.plistType)
	self.imgPortrait:loadTexture(lordLocalData.getBust(self.tableSingleData.headid), ccui.TextureResType.plistType)
	self.labelPower:setString(string.formatnumberthousands(self.tableSingleData.totalFc))
	self:setCastleLv(self.tableSingleData.cityLevel)
	self:setStarLv(self.tableSingleData.starLv)
	self:showStatus()
	self:showName()
	self.Com_jinnBeastLv:initData(self.tableSingleData)
end
function legendTeamApprovalListSingle:setCastleLv(clv)
	self.spriteCastle:setVisible(false)
	self.labelCastleLv:setVisible(false)
end
function legendTeamApprovalListSingle:setStarLv(starLv)
	self.spriteStar:setVisible(false)
	self.labelStarLv:setVisible(false)
end
function legendTeamApprovalListSingle:showName()
	local name = legendTeamUtil.getMemberName(self.tableSingleData)
	self.labelName:setString(name)
end
function legendTeamApprovalListSingle:showStatus()
	local isOnline = self.tableSingleData.online == 0
	self.labelOnline:setVisible(false)
	self.labelLastTime:setVisible(false)
	self.imgFlg:getVirtualRenderer():setState(0)
	self.labelPower:setColor(cc.c3b(247, 216, 71))
	self.labelCastleLv:setColor(cc.c3b(255, 210, 138))
	self.labelStarLv:setColor(cc.c3b(255, 210, 138))
end
function legendTeamApprovalListSingle:updateIsBatch()
	self.checkBox:setVisible(self.isBatch)
	self.btnJoin:setVisible(not self.isBatch)
	self.btnAgree:setVisible(not self.isBatch)
	self.btnReject:setVisible(not self.isBatch)
end
function legendTeamApprovalListSingle:getIsSelected()
	return self.checkBox:isSelected()
end
function legendTeamApprovalListSingle:setIsSelected(isSelected)
	self.checkBox:setSelected(isSelected)
end
function legendTeamApprovalListSingle:getSelectedUid()
	return self.tableSingleData.uid
end
function legendTeamApprovalListSingle:onClickCheckBox(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
return legendTeamApprovalListSingle
