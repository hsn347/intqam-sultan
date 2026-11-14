local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailUIConstDef = include("mailUIConstDef")
local mailDesRead = include("mailDesRead")
local mailFunctions = include("mailFunctions")
local mailNodeFactory = include("mailNodeFactory")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local mailContentAllianceInfo = class("mailContentAllianceInfo", function()
	return ccui.Layout:create()
end)
function mailContentAllianceInfo:ctor()
	self:setSwallowTouches(false)
	self:setCascadeOpacityEnabled(true)
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 0
	self.singleIsMoved = false
	self.tblRewardItems, _ENV, self.btnReceive = gMailDetaiViewWidth, gMailDetaiViewWidth, nil
end
function mailContentAllianceInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAIL_LOCK_UPDATE", handler(self, self.msgMailLockUpdate))
end
function mailContentAllianceInfo:initWithData(mail)
	self.scroll = SoraDGetChildByName(gModuleMgr.sharedMgr("mailMgr"):getDetaiView(), "Size_scrollView")
	self.mail = mail
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	self.mailType = self.mail:getProperty("mailType")
	self.mailSource = self.mail:getProperty("source")
	self.contentData = self.mail:getProperty("data")
	if self.mailType == gMailType.INVITE_MOVE_CITY then
		self:createContentInviteMoveCity()
	elseif self.mailType == gMailType.ALLIANCE_APPLICATION then
		self:createContentAllianceApplication()
	elseif self.mailType == gMailType.QUIT_ALLIANCE then
		self:createContentAllianceQuit()
	elseif self.mailType == gMailType.ALLIANCE_INVITATION then
		self:createContentAllianceInvite()
	end
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailContentAllianceInfo:createContentInviteMoveCity()
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	_ENV = nil
	;(nil).name = self.contentData.uinfo.nickName
	local strInfo = i18n("common_text_681", nil)
	_ENV = self.contentData.uinfo.nickName
	self.contentData.uinfo.nickName.fontSize = 24
	self.contentData.uinfo.nickName.color = cc.c3b(57, 11, 11)
	self.contentData.uinfo.nickName.str = strInfo
	self.contentData.uinfo.nickName.AlignH = SoraDFLabelR()
	self.contentData.uinfo.nickName.autoHeight = true
	self.contentData.uinfo.nickName.linearLayoutType = ccui.LinearGravity.centerHorizontal
	local labelDes, autoHeight = mailNodeFactory:createTextLayout(self.contentData.uinfo.nickName)
	totalHeight = totalHeight + autoHeight
	self:addChild(labelDes)
	local layoutBtnOkCancel, autoHeight = self:createBtnOKCancel(i18n("common_text_702"), i18n("common_text_091"))
	self:addChild(layoutBtnOkCancel)
	totalHeight = totalHeight + autoHeight
	self.itemHeight = totalHeight
end
function mailContentAllianceInfo:createContentAllianceApplication()
	local itemNode = include("mailItemDetailAlliancePlayer").new()
	itemNode:initWithData(self.mail)
	self:addChild(itemNode)
	local totalHeight = itemNode:getItemHeight()
	_ENV = nil
	;(nil).name = self.contentData.uinfo.nickName
	local strInfo = i18n("common_text_139", nil)
	_ENV = self.contentData.uinfo.nickName
	self.contentData.uinfo.nickName.fontSize = 24
	self.contentData.uinfo.nickName.color = cc.c3b(57, 11, 11)
	self.contentData.uinfo.nickName.str = strInfo
	self.contentData.uinfo.nickName.AlignH = cc.TEXT_ALIGNMENT_CENTER
	self.contentData.uinfo.nickName.autoHeight = true
	_ENV, self.contentData.uinfo.nickName.linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 10
	ccui.LinearGravity.centerHorizontal.right = 0
	self.contentData.uinfo.nickName.margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 0
	local labelDes, autoHeight = mailNodeFactory:createTextLayout(self.contentData.uinfo.nickName)
	totalHeight = totalHeight + autoHeight
	self:addChild(labelDes)
	local targetAid = self.contentData.aid
	local isPermit = false
	if allianceMgr:getAlliance() ~= nil then
		local alliance = allianceMgr:getAlliance()
		local ownAid = alliance:getProperty("aid")
		local leaderId = alliance:getProperty("leader")
		local ownuid = lordInfoCtrl:getLordInfo().base.uid
		if ownAid == targetAid and leaderId == ownuid then
			isPermit = true
		end
	end
	if isPermit then
		local layoutBtnOkCancel, autoHeight = self:createBtnOKCancel(i18n("common_text_140"), i18n("common_text_091"))
		self:addChild(layoutBtnOkCancel)
		totalHeight = totalHeight + autoHeight
	end
	print(totalHeight, "totalHeight")
	self.itemHeight = totalHeight
end
function mailContentAllianceInfo:createContentAllianceInvite()
	local totalHeight = 0
	_ENV = nil
	;(nil).name = self.contentData.allianceInfo.property.name
	local strInfo = i18n("common_text_138", nil)
	_ENV = self.contentData.allianceInfo.property.name
	self.contentData.allianceInfo.property.name.fontSize = 24
	self.contentData.allianceInfo.property.name.color = cc.c3b(57, 11, 11)
	self.contentData.allianceInfo.property.name.str = strInfo
	self.contentData.allianceInfo.property.name.AlignH = SoraDFLabelR()
	self.contentData.allianceInfo.property.name.autoHeight = true
	self.contentData.allianceInfo.property.name.linearLayoutType = ccui.LinearGravity.centerHorizontal
	local labelDes, autoHeight = mailNodeFactory:createTextLayout(self.contentData.allianceInfo.property.name)
	totalHeight = totalHeight + autoHeight
	self:addChild(labelDes)
	local itemNode = include("mailItemDetailAllianceInfo").new()
	itemNode:initWithData(self.mail)
	local frameNode = include("mailItemDetailFrameBox").new()
	_ENV = 11
	_ENV, (11).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(11).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, itemNode
	frameNode:initWithData(11)
	self:addChild(frameNode)
	totalHeight = totalHeight + frameNode:getItemHeight()
	local layoutBtnOkCancel, autoHeight = self:createBtnOKCancel(i18n("common_text_140"), i18n("common_text_091"))
	self:addChild(layoutBtnOkCancel)
	totalHeight = totalHeight + autoHeight
	self.itemHeight = totalHeight
end
function mailContentAllianceInfo:createContentAllianceQuit()
	local totalHeight = 0
	local itemNode = include("mailItemDetailAllianceInfo").new()
	itemNode:initWithData(self.mail)
	local frameNode = include("mailItemDetailFrameBox").new()
	_ENV = nil
	_ENV, (nil).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(nil).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, itemNode
	frameNode:initWithData(nil)
	self:addChild(frameNode)
	totalHeight = totalHeight + frameNode:getItemHeight()
	local name = mailFunctions:getWrappedName(self.contentData.allianceInfo.property.abbr, self.contentData.uinfo.nickName)
	_ENV = self.contentData.uinfo.nickName
	self.contentData.uinfo.nickName.name = name
	local strInfo = i18n("common_text_141", self.contentData.uinfo.nickName)
	_ENV = "mailUIConstDef"
	;("mailUIConstDef").fontSize = 24
	;("mailUIConstDef").color = cc.c3b(57, 11, 11)
	;("mailUIConstDef").str = strInfo
	;("mailUIConstDef").AlignH = SoraDFLabelR()
	;("mailUIConstDef").autoHeight = true
	;("mailUIConstDef").linearLayoutType = ccui.LinearGravity.centerHorizontal
	local labelDes, autoHeight = mailNodeFactory:createTextLayout("mailUIConstDef")
	totalHeight = totalHeight + autoHeight
	self:addChild(labelDes)
	self.itemHeight = totalHeight
end
function mailContentAllianceInfo:createBtnOKCancel(okTitle, cancelTitle)
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 100
	local hLayout = ccui.HBox:create()
	hLayout:setCascadeOpacityEnabled(true)
	local layoutBtnOk = self:createBtnOk(okTitle)
	local layoutBtnCancel = self:createBtnCancel(cancelTitle)
	if SoraDFIsRA() then
		_UPVALUE2_ = SoraDFIsRA()
		SoraDFIsRA()[1] = layoutBtnCancel
		SoraDFIsRA()[2] = layoutBtnOk
		if SoraDFIsRA() then
			goto lbl_31
		end
	end
	_UPVALUE2_ = SoraDFIsRA()
	SoraDFIsRA()[1] = layoutBtnOk
	SoraDFIsRA()[2] = layoutBtnCancel
	::lbl_31::
	for i, v in ipairs((SoraDFIsRA())) do
		local lp1 = ccui.LinearLayoutParameter:create()
		v:setLayoutParameter(lp1)
		lp1:setGravity(ccui.LinearGravity.centerVertical)
		hLayout:addChild(v)
	end
	hLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return hLayout, totalHeight
end
function mailContentAllianceInfo:createBtnOk(title)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalWidth = gMailDetaiViewWidth / 2
	local totalHeight = 0
	_ENV = nil
	;(nil).name = "btn_cancel"
	;(nil).normalImgName = "btn_alliance_green.png"
	;(nil).color = cc.c3b(255, 255, 255)
	;(nil).fontSize = 26
	;(nil).titleText = title
	;(nil).handler = handler(self, self.onBtnOk)
	;(nil).buttonSize = cc.size(169, 57)
	local button, autoHeight = mailNodeFactory:createButtonLayout(nil)
	vLayout:addChild(button)
	totalHeight = totalHeight + autoHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailContentAllianceInfo:createBtnCancel(title)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalWidth = gMailDetaiViewWidth / 2
	local totalHeight = 0
	_ENV = nil
	;(nil).titleText = title
	;(nil).name = "btn_ok"
	;(nil).normalImgName = "btn_alliance_red.png"
	;(nil).color = cc.c3b(255, 255, 255)
	;(nil).fontSize = 26
	;(nil).handler = handler(self, self.onBtnCancel)
	;(nil).buttonSize = cc.size(169, 57)
	local button, autoHeight = mailNodeFactory:createButtonLayout(nil)
	vLayout:addChild(button)
	totalHeight = totalHeight + autoHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailContentAllianceInfo:onBtnCancel(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.mailType == gMailType.INVITE_MOVE_CITY then
			local aid = self.contentData.allianceInfo.aid
			allianceMgr:reqRejectInviteMoveCity(aid)
		elseif self.mailType == gMailType.ALLIANCE_INVITATION then
			_ENV = aid
			aid.mid = mid
			allianceMgr:reqRejectInviteJoin(self.contentData.allianceInfo.property.aid, aid)
			SoraDShowLoading()
		elseif self.mailType == gMailType.ALLIANCE_APPLICATION then
			_ENV = aid
			aid.mid = mid
			allianceMgr:reqRejectApplication(self.mail.property.sender, aid)
			SoraDShowLoading()
		end
		mailCtrl:removeMail(self.mail:getProperty("mailSetType"), self.mail:getProperty("mid"))
		_ENV = mailCtrl
		mailCtrl.msg = "MESSAGE_MAIL_CLOSE_DETAIL_VIEW"
		mailCtrl.mid = self.mail:getProperty("mid")
		SoraDSendMessage(mailCtrl)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailContentAllianceInfo:onBtnOk(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.mailType == gMailType.INVITE_MOVE_CITY then
			local targetPoint = cc.p(self.contentData.uinfo.coordinate.x, self.contentData.uinfo.coordinate.y)
			local selfKingdomID = gametop.playertop_:getMapID()
			local targetKingdomId = self.contentData.kingdomId
			local targetAid = self.contentData.allianceInfo.aid
			local selfAid = allianceMgr:getOwnAid()
			if selfKingdomID ~= targetKingdomId or targetAid ~= selfAid then
				SoraDShowMsgTip(i18n("common_text_992"), "#icon_mail_lock.png", target)
				return
			else
				_ENV = i18n("common_text_992")
				i18n("common_text_992").msg = "MESSAGE_MAIL_CLOSE_VIEW"
				SoraDSendMessage((i18n("common_text_992")))
				SoraDGotoWorldMapPoint(targetPoint, false, selfKingdomID, worldMapLayInstanceTypeDef.layInstanceCity)
			end
		elseif self.mailType == gMailType.ALLIANCE_INVITATION then
			local funUnlockRead = include("funUnlockRead")
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ALLIANCE)
			if unlockLv <= SoraDGetCastleLv() then
				_ENV = targetPoint
				targetPoint.mid = mid
				allianceMgr:reqAgreeInviteJoin(self.contentData.allianceInfo.property.aid, self.contentData.uid, targetPoint)
				SoraDShowLoading()
			else
				_ENV = self.contentData.uid
				self.contentData.uid.name = i18n("common_text_069")
				self.contentData.uid.lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", self.contentData.uid))
			end
		elseif self.mailType == gMailType.ALLIANCE_APPLICATION then
			_ENV = i18n("common_text_2122", self.contentData.uid)
			i18n("common_text_2122", self.contentData.uid).mid = mid
			allianceMgr:reqAgreeApplication(self.mail.property.sender, i18n("common_text_2122", self.contentData.uid))
			SoraDShowLoading()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailContentAllianceInfo:msgMailLockUpdate(target, data)
	if self.mailType == gMailType.INVITE_MOVE_CITY then
		local btnOk = SoraDGetChildByName(self, "btn_ok")
		local btnCancel = SoraDGetChildByName(self, "btn_cancel")
		_UPVALUE1_ = "btn_cancel"
		;("btn_cancel")[1] = btnCancel
		for i, v in ipairs("btn_cancel") do
			v:getVirtualRenderer():setState(0)
			v:setEnabled(true)
			v:setTitleColor(cc.c3b(255, 255, 0))
		end
	end
end
function mailContentAllianceInfo:getItemWidth()
	return self.itemWidth
end
function mailContentAllianceInfo:getItemHeight()
	return self.itemHeight
end
return mailContentAllianceInfo
