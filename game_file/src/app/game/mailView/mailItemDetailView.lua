local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailDesRead = include("mailDesRead")
local mailFunctions = include("mailFunctions")
local mailLogic = include("mailLogic")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailDesParser = include("mailDesParser")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local mailItemDetailView = class("mailItemDetailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailItemDetailView")
	end
	return target
end)
function mailItemDetailView:onEnterPanel()
	mailMgr:setDetailView(self)
end
function mailItemDetailView:onExitPanel()
	mailMgr:setDetailView(nil)
end
function mailItemDetailView:ctor()
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.title:setTitle(i18n("mail_text_25"))
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.detailScrollView = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_mailItemDetailScrollView_node")
	self.detailScrollView:setCascadeOpacityEnabled(true)
	self.itemScrollView = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_mailItemScrollView_node")
	self.itemScrollView:setCascadeOpacityEnabled(true)
	self.btnLeft = SoraDGetChildByName(self, "Button_Left")
	self.btnRight = SoraDGetChildByName(self, "Button_Right")
	self.btnRight:addTouchEventListener(handler(self, self.btnRightClick))
	self.btnLeft:addTouchEventListener(handler(self, self.btnLeftClick))
	self.nodeDown = SoraDGetChildByName(self, "Node_down")
	self.nodeDown:setVisible(false)
	self.nodeBottom = SoraDGetChildByName(self, "Node_Buttom")
	self.btn_counter_atk = SoraDGetChildByName(self.nodeBottom, "btn_counter_atk")
	self.btn_share = SoraDGetChildByName(self.nodeBottom, "btn_share")
	self.btn_collect = SoraDGetChildByName(self.nodeBottom, "btn_collect")
	self.btn_delete = SoraDGetChildByName(self.nodeBottom, "btn_delete")
	self.btn_shot = SoraDGetChildByName(self.nodeBottom, "btn_Shot")
	self.btn_chat = SoraDGetChildByName(self.nodeBottom, "btn_Chat")
	self.btn_translate = SoraDGetChildByName(self.nodeBottom, "btn_Translate")
	self.btn_copy = SoraDGetChildByName(self.nodeBottom, "btn_Copy")
	self.btn_counter_atk:addTouchEventListener(handler(self, self.btnCounterAtkClick))
	self.btn_share:addTouchEventListener(handler(self, self.btnShareClick))
	self.btn_collect:addTouchEventListener(handler(self, self.btnCollectClick))
	self.btn_delete:addTouchEventListener(handler(self, self.btnDeleteClick))
	self.btn_shot:addTouchEventListener(handler(self, self.btnShotClick))
	self.btn_chat:addTouchEventListener(handler(self, self.btnChatClick))
	self.btn_translate:addTouchEventListener(handler(self, self.btnTranslateClick))
	self.btn_copy:addTouchEventListener(handler(self, self.btnCopyClick))
	self:fitView()
	self:initAnimation()
end
function mailItemDetailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_SINGLE_MAIL_BACK", handler(self, self.onSingleMailBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_NEW_MAIL", handler(self, self.msgUpdataState))
	SoraDAddMessage(self, "MESSAGE_MAIL_CLOSE_VIEW", function()
		SoraDRemoveAllPanelFromManager()
	end)
	SoraDAddMessage(self, "MESSAGE_MAIL_CLOSE_DETAIL_VIEW", handler(self, self.msgCloseView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_TOP_COMMON_SHARE_BACK", handler(self, self.msgShareBack))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_TRANSLATE_BACK", handler(self, self.sMsgTranslateBack))
end
function mailItemDetailView:fitView()
end
function mailItemDetailView:initAnimation()
end
function mailItemDetailView:updateBtnLeftAndRight()
	if self.senderId then
		return
	end
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		self.btnRight:setVisible(false)
		self.btnLeft:setVisible(false)
	else
		local isLastLoadMid = mailMgr:isLastLoadMid(self.mid, self.mailSetKey)
		local isFirstLoadMid = mailMgr:isFirstLoadMid(self.mid, self.mailSetKey)
		if gErrDef.Err_MAIL_NOT_FOUND == isLastLoadMid or gErrDef.Err_MAIL_NOT_FOUND == isFirstLoadMid then
			self:removeFromParent()
			return
		end
		self.btnRight:setVisible(not isLastLoadMid)
		self.btnLeft:setVisible(not isFirstLoadMid)
	end
end
function mailItemDetailView:hideRightAndLeftBtn()
	SoraDGetChildByName(self, "Bottom_Node"):setVisible(false)
	self.centerNode:setVisible(false)
	self.detailScrollView:resetContentSize(cc.size(640, self.detailScrollView:getContentSize().height + 100))
	SoraDGetChildByName(self, "Size_ImageBg"):setPositionY(0)
	SoraDGetChildByName(self, "Size_ImageBg"):setContentSize(cc.size(640, display.height - 79))
end
function mailItemDetailView:updatBottomBtn()
	self.btn_shot:setVisible(false)
	self.btn_delete:setVisible(true)
	if self.mailType == gMailType.ALLIANCE_GROUP_MAIL then
		self.btn_translate:setVisible(true)
		self.btn_translate:loadTextures("icon_yjyh_fy_06.png", "icon_yjyh_fy_06.png", "icon_yjyh_fy_06.png", ccui.TextureResType.plistType)
	end
	if gMailSetTypeFunc.checkNeedShareBtn(self.mailSource) then
		self.btn_shot:setVisible(self.mailType == gMailType.BATTLE_REPORT)
		self.btn_share:setVisible(true)
	else
		self.btn_share:setVisible(false)
	end
	if not gMailSetTypeFunc.checkCanCollect(self.mailSetType) then
		self.btn_collect:setVisible(true)
	else
		self.btn_collect:setVisible(false)
	end
	if self.mailType == gMailType.ALLIANCE_GROUP_MAIL then
		self.btn_chat:setVisible(self.mail:getProperty("sender") ~= lordInfoCtrl:getLordInfo().base.uid)
		self.btn_translate:setVisible(true)
		self.btn_copy:setVisible(true)
	else
		self.btn_chat:setVisible(false)
		self.btn_translate:setVisible(false)
		self.btn_copy:setVisible(false)
	end
	self:updateBtnbCounterAtk()
	local visibleNum = 0
	local targets = self.nodeBottom:getChildren()
	for k, v in pairs(targets) do
		if v:isVisible() then
			visibleNum = visibleNum + 1
		end
	end
	SoraDToCenter(self.nodeBottom, (gMailDetaiViewWidth - 53 * visibleNum) / visibleNum)
end
function mailItemDetailView:updateBtnbCounterAtk()
	if gMailSetTypeFunc.checkNeedAtkBtn(self.mailSource) then
		local isOwnKid = true
		local otherKid = self.mail.property.brief.playerInfo1 and self.mail.property.brief.playerInfo1.uinfo and self.mail.property.brief.playerInfo1.uinfo.kid
		if otherKid then
			if lordInfoCtrl:getMapSourceKid() > 0 then
				if lordInfoCtrl:getMapSourceKid() ~= otherKid then
					isOwnKid = false
				end
			elseif otherKid ~= gametop.playertop_:getMapID() then
				isOwnKid = false
			end
		end
		if isOwnKid then
			self.btn_counter_atk:setVisible(true)
			local uid = self.mail.property.brief.playerInfo1 and self.mail.property.brief.playerInfo1.uinfo and self.mail.property.brief.playerInfo1.uinfo.id
			if uid and allianceCounterSysCtrl:checkOwnEnemy(uid) then
				SoraDGetChildByName(self.btn_counter_atk, "icon_LT_guangbixiaobiao"):setVisible(true)
			else
				SoraDGetChildByName(self.btn_counter_atk, "icon_LT_guangbixiaobiao"):setVisible(false)
			end
		else
			self.btn_counter_atk:setVisible(false)
		end
	else
		self.btn_counter_atk:setVisible(false)
	end
end
function mailItemDetailView:updateTitle()
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		local mailTitle = mailDesRead.getMailSetTitle(self.mailSetType)
		local cur, total = mailCtrl:getMailCountPer(self.mailSetType)
		_ENV = nil
		;(nil).member = cur
		;(nil).total = total
		local titleCenter = i18n(mailTitle) .. "(" .. i18n("common_text_155", nil) .. ")"
		self.title:setTitle(titleCenter)
	elseif self.mail:isMailReport() then
		self.title:setTitle(i18n("common_text_504"))
	else
		local mailTitle = mailDesParser.getMailTitle(self.mail)
		if self.senderId then
			self.title:setTitle(i18n("common_text_504") .. "\n" .. mailTitle)
		else
			self.title:setTitle(mailTitle)
		end
	end
end
function mailItemDetailView:initWithData(mail, mailSetKey, senderId)
	dump(mail, "mailItemDetailView:initWithData", 100)
	if not mail then
		return
	end
	print("senderId", senderId)
	self.senderId = senderId
	self.mail = mail
	self.mid = self.mail:getProperty("mid")
	self.mailSetKey = mailSetKey
	self.mailType = self.mail:getProperty("mailType")
	self.mailSetType = self.mail:getProperty("mailSetType")
	self.mailSource = self.mail:getProperty("source")
	print("mail-info,mailType mailSetType ,sourceType ,contentType", self.mailType, self.mailSetType, self.mailSource, self.mail:getProperty("data").contentType)
	self.detailScrollView:cleanInnerContents()
	self.itemScrollView:cleanInnerContents()
	if self.mailType == gMailType.ALLIANCE_GROUP_MAIL then
		self.mail:setShowTransLate(false)
	end
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		self.itemScrollView:setVisible(true)
		self.detailScrollView:setVisible(false)
	else
		self.itemScrollView:setVisible(false)
		self.detailScrollView:setVisible(true)
	end
	if not self.mail:isMailReport() and not self.senderId then
		self:updateBtnLeftAndRight()
		self:updatBottomBtn()
	end
	self:updateTitle()
	self:delayInit()
end
function mailItemDetailView:delayInit()
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		SoraDShowLoading(self)
		local actDelay = cca.delay(0.35)
		local callFunc = cca.callFunc(function()
			self.itemScrollView:setMailSetType(self.mailSetType)
			self.itemScrollView:initWithData(self.mail)
			SoraDCloseLoading(self)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = actDelay
		;(nil)[2] = callFunc
		self:runAction(cca.seq(nil))
	elseif self.mail.property.data == nil or not next(self.mail.property.data) then
		if self.mail.property.brief and next(self.mail.property.brief) ~= nil then
			SoraDShowLoading(self)
			if self.mail:isMailReport() then
				mailFunctions:doRequestMailReport(self.mid)
			else
				mailFunctions:doRequestSingleMail(self.mid)
			end
		end
	else
		SoraDShowLoading(self)
		local delayTime = self.mailType == gMailType.BATTLE_REPORT and 0.35 or 0
		local actDelay = cca.delay(delayTime)
		local callFunc = cca.callFunc(function()
			self.detailScrollView:initWithData(self.mail, self.senderId)
			SoraDCloseLoading(self)
		end)
		_UPVALUE2_ = cca.seq(nil)
		cca.seq(nil)[1] = actDelay
		cca.seq(nil)[2] = callFunc
		self:runAction(cca.seq(cca.seq(nil)))
	end
end
function mailItemDetailView:cleanView()
	self.isShotting = false
	self.itemScrollView:cleanAll()
	self.detailScrollView:cleanAll()
end
function mailItemDetailView:btnRightClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if mailMgr:hasMoreMail(nil, self.mailSetType) then
			SoraDShowLoading()
			_ENV = nil
			;(nil).setType = self.mailSetType
			;(nil).key = self.mailSetKey
			mailCtrl:reqMoreMail(nil)
		end
		local newMid = mailMgr:getNextMail(self.mid, self.mailSetKey)
		self:initWithData(mailMgr:queryMail(newMid), self.mailSetKey)
		mailCtrl:viewMail(newMid)
	end
end
function mailItemDetailView:btnLeftClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local newMid = mailMgr:getPreMail(self.mid, self.mailSetKey)
		self:initWithData(mailMgr:queryMail(newMid), self.mailSetKey)
		mailCtrl:viewMail(newMid)
	end
end
function mailItemDetailView:btnCounterAtkClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local uid = self.mail.property.brief.playerInfo1.uinfo.id
		if allianceCounterSysCtrl:checkOwnEnemy(uid) then
			SoraDGetChildByName(self.btn_counter_atk, "icon_LT_guangbixiaobiao"):setVisible(false)
			allianceCounterSysCtrl:delPersonalEnemy(uid)
			SoraDShowLoading()
		elseif allianceCounterSysCtrl.ownListData and #allianceCounterSysCtrl.ownListData >= 10 then
			SoraDShowMsgTip(i18n("CounterSystem_text_02"))
		else
			allianceCounterSysCtrl:addPersonalEnemy(self.mail:getProperty("mid"))
			SoraDGetChildByName(self.btn_counter_atk, "icon_LT_guangbixiaobiao"):setVisible(true)
			SoraDShowLoading()
		end
	end
end
function mailItemDetailView:btnShareClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = SoraDPlaySound
		SoraDPlaySound[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS] = true
		SoraDPlaySound[gMailSource.ATTACK_PYRAMIDBUILD_FAILED] = true
		SoraDPlaySound[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS] = true
		local SoraDPlaySound[gMailSource.DEFENSE_PYRAMIDBUILD_FAILED], config = true, SoraDPlaySound
		if worldMapDefine.isInPyramid() and config[self.mailSource] then
			_ENV = nil
			;(nil).mailID = self.mail:getProperty("mid")
			_UPVALUE3_, (nil).kingdomID = self.mail:getKingdomID(), self.mail:getKingdomID()
			;(nil).channelList, self.mail:getKingdomID()[1] = self.mail:getKingdomID(), gChatChannel.KINGDOM
			;(nil).channelList, self.mail:getKingdomID()[2] = self.mail:getKingdomID(), gChatChannel.ALLIANCE
			;(nil).channelList, self.mail:getKingdomID()[3] = self.mail:getKingdomID(), gChatChannel.TEAM
			uiManager:show("mailSharePopView", nil)
			return
		end
		if worldMapDefine.isInTeamChannel() then
			local panel = SoraDCreatePanel("mailShareBox")
			panel:init(self.mail:getProperty("mid"))
			panel:show()
		else
			_ENV = self.mail:getProperty("mid")
			self.mail:getProperty("mid").mailID = self.mail:getProperty("mid")
			uiManager:show("mailSharePopView", self.mail:getProperty("mid"))
		end
	end
end
function mailItemDetailView:btnCollectClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		mailCtrl:collectMail(self.mail:getProperty("mid"))
		self:removeFromParent()
	end
end
function mailItemDetailView:btnShotClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local leftMem = SoraDGetSystemFreeMem()
		print("SoraDGetSystemFreeMem", leftMem)
		if leftMem ~= "macosx" and tonumber(leftMem) / 1048576 < 100 then
			SoraDShowMsgTip(i18n("mail_2_text_71"))
			return
		end
		if self.isShotting then
			return
		end
		self.isShotting = true
		self:createShotNode()
		self:shotBattleReport()
	end
end
function mailItemDetailView:btnDeleteClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_162"), i18n("common_text_054"), nil, handler(self, self.confirmDel))
	end
end
function mailItemDetailView:confirmDel(type)
	if type == MSGBOX_CALLBACK_YES then
		if not gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
			local err = mailCtrl:removeMail(self.mailSetType, self.mid)
			print("err", err)
			if err == gErrDef.Err_None then
				SoraDShowMsgTip(i18n("common_text_633"))
				if not tolua.isnull(self) then
					self:removeFromParent()
				end
			elseif err == gErrDef.Err_MAIL_NOT_GET_EXTRA then
				SoraDShowMsgTip(i18n("notice_0100"))
			end
		else
			mailCtrl:removeMailList(self.mail:getProperty("mailSetType"))
			if not tolua.isnull(self) then
				self:removeFromParent()
			end
		end
	end
end
function mailItemDetailView:btnTranslateClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentData = self.mail:getProperty("data")
		if not self.mail:getShowTransLate() then
			self.btn_translate:setTouchEnabled(false)
			self.mail:setShowTransLate(true)
			local message = contentData.content
			if message then
				local client_tl = SoraDGetCtrl("settingCtrl"):getTranslateLanguage()
				if contentData.translation and contentData.translation.tText[client_tl] then
					print("本地数据")
					self.detailScrollView:cleanInnerContents()
					self.detailScrollView:initWithData(self.mail)
					self.btn_translate:setTouchEnabled(true)
					self.btn_translate:loadTextures("icon_yjyh_fy_dj_06.png", "icon_yjyh_fy_dj_06.png", "icon_yjyh_fy_dj_06.png", ccui.TextureResType.plistType)
				else
					print("请求服务器翻译")
					SoraDShowLoading()
					local translateCtrl = SoraDGetCtrl("translateCtrl")
					_ENV = "icon_yjyh_fy_dj_06.png"
					_ENV, ("icon_yjyh_fy_dj_06.png")[1] = self.mail:getProperty("mid")
					_ENV, ("icon_yjyh_fy_dj_06.png")[2] = self.mail:getProperty("mid")
					_ENV, ("icon_yjyh_fy_dj_06.png")[3] = self.mail:getProperty("mid")
					_ENV, ("icon_yjyh_fy_dj_06.png")[4] = self.mail:getProperty("mid")
					self.mail:getProperty("mid").from = "chatMail"
					self.mail:getProperty("mid").mid = self.mail:getProperty("mid")
					translateCtrl:translate("icon_yjyh_fy_dj_06.png", self.mail:getProperty("mid"))
				end
			end
		else
			self.btn_translate:setTouchEnabled(false)
			print("显示原文=================")
			self.mail:setShowTransLate(false)
			self.detailScrollView:cleanInnerContents()
			self.detailScrollView:initWithData(self.mail)
			self.btn_translate:setTouchEnabled(true)
			self.btn_translate:loadTextures("icon_yjyh_fy_06.png", "icon_yjyh_fy_06.png", "icon_yjyh_fy_06.png", ccui.TextureResType.plistType)
		end
	end
end
function mailItemDetailView:btnCopyClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentData = self.mail:getProperty("data")
		SoraDCopyText(contentData.content)
	end
end
function mailItemDetailView:btnChatClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentData = self.mail:getProperty("data")
		_ENV = "data"
		;("data").targetType = gMailType.CHAT
		;("data").target = self.mail:getProperty("sender")
		;("data").nickName = contentData.playerInfo.nickName
		;("data").allianceAbbr = contentData.playerInfo.allianceAbbr
		SoraDCreateChatView("data")
	end
end
function mailItemDetailView:closeView(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function mailItemDetailView:onSingleMailBack(target, data)
	SoraDCloseLoading(self)
	if not self.mail then
		self:removeFromParent()
		return
	end
	local mail = mailMgr:queryMail(self.mail:getProperty("mid"))
	if not mail then
		self:removeFromParent()
		return
	end
	self.mail = mail
	mailFunctions:resetMailSource(self.mail)
	self.detailScrollView:initWithData(self.mail)
end
function mailItemDetailView:msgShareBack(target, data)
	SoraDCloseLoading(self)
	if "saveSuccess" == data.result then
		local isLongShot = true or device.platform == "mac"
		SoraDShowMsgTip(isLongShot and i18n("mail_2_text_72") or i18n("mail_2_text_73"), "#icon_jt_3.png")
	elseif "saveFail_NEM" == data.result then
		SoraDShowMsgTip(i18n("mail_2_text_71"))
	end
end
function mailItemDetailView:checkSetTypeEqual(setType1, setType2)
	if tolua.type(setType1) == "table" then
		return setType1[1] == setType2[1]
	else
		return setType1 == setType2
	end
end
function mailItemDetailView:msgUpdataState(target, data)
	if self:checkSetTypeEqual(data.mailSetType, self.mailSetType) then
		self:updateBtnLeftAndRight()
	end
end
function mailItemDetailView:msgCloseView(target, data)
	if data.mid == self.mid then
		self:removeFromParent()
	end
end
function mailItemDetailView:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			SoraDOpenLordView(data.lord)
		end
	end
end
function mailItemDetailView:sMsgTranslateBack(target, data)
	SoraDCloseLoading()
	if data.target.mid == self.mail:getProperty("mid") then
		local mail = mailMgr:queryMail(self.mail:getProperty("mid"))
		if not mail then
			self:removeFromParent()
			return
		end
		self.mail = mail
		mailFunctions:resetMailSource(self.mail)
		dump(self.mail:getProperty("data"), "sMsgTranslateBack")
		local contentData = self.mail:getProperty("data")
		local client_tl = SoraDGetCtrl("settingCtrl"):getTranslateLanguage()
		if contentData.translation and contentData.translation.tText[client_tl] then
			self.detailScrollView:cleanInnerContents()
			self.detailScrollView:initWithData(self.mail)
			self.btn_translate:loadTextures("icon_yjyh_fy_dj_06.png", "icon_yjyh_fy_dj_06.png", "icon_yjyh_fy_dj_06.png", ccui.TextureResType.plistType)
		else
			print("没有翻译返回")
			self.mail:setShowTransLate(false)
		end
	end
	self.btn_translate:setTouchEnabled(true)
end
function mailItemDetailView:judge2move()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveBy(1, _forward * 15, 0)
	;(nil)[2] = cca.moveBy(1, -_forward * 15, 0)
	;(nil)[3] = cca.moveBy(1, -_forward * 15, 0)
	;(nil)[4] = cca.moveBy(1, -_forward * 15, 0)
	;(nil)[5] = cca.moveBy(1, -_forward * 15, 0)
	local seqList = cca.seq(nil)
	local acList = cc.RepeatForever:create(seqList)
	_sprite:runAction(acList)
end
function mailItemDetailView:initDownShotInfo()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local playerInfo = lordInfoCtrl:getLordInfo()
	SoraDGetChildByName(self.nodeDown, "Text_url"):setString(self:getShareUrl())
	if playerInfo.base.sourceKid and playerInfo.base.sourceKid > 0 then
		_ENV = self:getShareUrl()
		self:getShareUrl().kid = playerInfo.base.sourceKid
		SoraDGetChildByName(self.nodeDown, "Text_king"):setString(i18n("common_text_342", self:getShareUrl()))
	else
		_ENV = i18n("common_text_342", self:getShareUrl())
		i18n("common_text_342", self:getShareUrl()).kid = playerInfo.base.partition
		SoraDGetChildByName(self.nodeDown, "Text_king"):setString(i18n("common_text_342", i18n("common_text_342", self:getShareUrl())))
	end
	if 0 >= string.utf8len(playerInfo.abbr) then
		SoraDGetChildByName(self.nodeDown, "Text_name"):setString(playerInfo.base.nickName)
	else
		_ENV = i18n("common_text_342", i18n("common_text_342", self:getShareUrl()))
		i18n("common_text_342", i18n("common_text_342", self:getShareUrl())).abbr = playerInfo.abbr
		i18n("common_text_342", i18n("common_text_342", self:getShareUrl())).name = playerInfo.base.nickName
		SoraDGetChildByName(self.nodeDown, "Text_name"):setString(i18n("common_text_186", i18n("common_text_342", i18n("common_text_342", self:getShareUrl()))))
	end
	SoraDGetHeadFromManager(SoraDGetChildByName(self, "Image_head"), playerInfo.base.imageId, playerInfo.base.avatar)
	local spriteGame = SoraDGetChildByName(self.nodeDown, "Sprite_game")
	spriteGame:setSpriteFrame(IsArClient and "icon_game.png" or "icon_ros_game.png")
	spriteGame:setScale(0.6)
	SoraDGetChildByName(self.nodeDown, "Text_Time"):setString(string.format("UTC+0  %s", os.date("!%Y-%m-%d %H:%M:%S", serviceFunctions.systemTime())))
end
function mailItemDetailView:getShareUrl()
	_ENV = nil
	;(nil).ko_ios = "https://bit.ly/roskoios"
	;(nil).ko_android = "https://bit.ly/roskoand"
	;(nil).ko_onestore = "https://bit.ly/roskoos"
	;(nil).ar = "https://app.adjust.com/x2m9iw6"
	local (nil).en, cfg = "https://bit.ly/2shareros", nil
	local lang = userSDKManager.getChannel()
	if cfg[lang] then
		return cfg[lang]
	end
	return "https://bit.ly/shareslateen"
end
function mailItemDetailView:shotBattleReport()
	local isLongShot = true or device.platform == "mac"
	if isLongShot then
		local winSize = cc.Director:getInstance():getWinSize()
		local winSizeP = cc.Director:getInstance():getWinSizeInPixels()
		local fileName = "share.jpg"
		local height, realHeight = self:getShotHeight()
		self:prepareScreenShot(true, isLongShot)
		_UPVALUE3_ = isLongShot
		isLongShot[1] = cca.delay(0.016666666666666666)
		isLongShot[2] = cca.callFunc(function()
			local scale = isLongShot and math.min(1, 4096 / realHeight) or 1
			local renderTexture = cc.RenderTexture:create(640 * scale, height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 35056)
			renderTexture:setVirtualViewport(cc.p(0, display.iPhoneXBottom), cc.rect(0, 0, 640 * scale, height + display.iPhoneXBottom), cc.rect(0, 0, 640 * scale, height + display.iPhoneXBottom))
			renderTexture:beginWithClear(0, 0, 0, 0)
			self:visit()
			self.whiteView:setVisible(true)
			realHeight = 0
			;(0)[1] = cca.delay(0.2)
			;(0)[2] = cca.fadeOut(0.2)
			;(0)[3] = cca.callFunc(function(...)
				self.whiteView:setVisible(false)
			end)
			;(0)[4] = cca.callFunc(function(...)
				self.whiteView:setVisible(false)
			end)
			;(0)[5] = cca.callFunc(function(...)
				self.whiteView:setVisible(false)
			end)
			;(0)[6] = cca.callFunc(function(...)
				self.whiteView:setVisible(false)
			end)
			self.whiteView:runAction(cca.seq(0))
			renderTexture:endToLua()
			renderTexture:saveToFile(fileName, 0, false)
		end)
		isLongShot[3] = cca.delay(0.016666666666666666)
		isLongShot[4] = cca.callFunc(function()
			self:prepareScreenShot(false, isLongShot)
		end)
		isLongShot[5] = cca.callFunc(function()
			self:prepareScreenShot(false, isLongShot)
		end)
		self:runAction(cca.seq(isLongShot))
		_ENV = cca.seq(isLongShot)
		cca.seq(isLongShot).delay = 0.1
		cca.seq(isLongShot).onComplete = function()
			if device.platform ~= "mac" then
				userSDKManager.saveShareImage(fileName)
			end
			_ENV = nil
			;(nil).entrance = 3
			userSDKManager.logEvent(gSDKDef.TDonEvent.share_pic_save, nil)
			self.isShotting = false
		end
		transition.execute(self, nil, cca.seq(isLongShot))
	else
		local panel = SoraDCreatePanel("commonSharePic")
		panel:initData(SoraDCreateScreenShot(), 1)
		panel:show(self)
		self.isShotting = false
	end
end
function mailItemDetailView:createShotNode()
	if not self.whiteView then
		self.whiteView = ccui.Layout:create()
		self.whiteView:addTo(self, 1)
	end
	self.whiteView:setVisible(false)
	self.whiteView:setContentSize(display.size)
	self.whiteView:setBackGroundColorType(1)
	self.whiteView:setBackGroundColor(display.COLOR_WHITE)
	self.whiteView:setBackGroundColorOpacity(255)
	self.whiteView:setAnchorPoint(0.5, 0.5)
	self.whiteView:setPosition(display.cx, display.cy)
end
function mailItemDetailView:prepareScreenShot(isShot, isLongShot)
	local view = cc.Director:getInstance():getOpenGLView()
	if isShot then
		self.nodeDown:setVisible(true)
		self.centerNode:setVisible(false)
		SoraDGetChildByName(self, "Bottom_Node"):setVisible(false)
		self:initDownShotInfo()
		if isLongShot then
			local height, realHeight, heightOffset = self:getShotHeight()
			local offsetY = self.detailScrollView.scrollView:getInnerContainerSize().height - self.detailScrollView.scrollView:getContentSize().height - heightOffset
			SoraDGetChildByName(self, "Size_ImageBg"):setPositionY(190)
			self.detailScrollView:setPositionY(height - 79)
			self.title:setPositionY(height)
			SoraDGetChildByName(self, "Size_ImageBg"):setContentSize(cc.size(640, height - 269))
			SoraDGetChildByName(self, "Image_frame"):setContentSize(cc.size(640, realHeight))
			if 4096 < realHeight then
				local scale = 4096 / realHeight
				self._ccsView:setScale(scale)
				SoraDGetChildByName(self, "Size_ImageBg"):setPositionY(190)
				self.detailScrollView:setPositionY(realHeight - 79)
				self.title:setPositionY(realHeight)
				SoraDGetChildByName(self, "Size_ImageBg"):setContentSize(cc.size(640, realHeight - 269))
			end
			if SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Report") then
				SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Report"):setVisible(false)
			end
			if SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Detail") then
				SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Detail"):setVisible(false)
			end
			if SoraDGetChildByName(self.detailScrollView.scrollView, "Button_SpeedDetail") then
				SoraDGetChildByName(self.detailScrollView.scrollView, "Button_SpeedDetail"):setVisible(false)
			end
			self.detailScrollView.scrollView:jumpToTop()
			self.detailScrollView.scrollView:setClippingEnabled(false)
		end
		cc.Director:getInstance():setRenderVisibleCheck(false)
	else
		self.nodeDown:setVisible(false)
		self.centerNode:setVisible(true)
		SoraDGetChildByName(self, "Bottom_Node"):setVisible(true)
		if isLongShot then
			local height, realHeight, heightOffset = self:getShotHeight()
			local offsetY = self.detailScrollView.scrollView:getInnerContainerSize().height - self.detailScrollView.scrollView:getContentSize().height - heightOffset
			if 4096 < realHeight then
				self._ccsView:setScale(1)
			end
			SoraDGetChildByName(self, "Size_ImageBg"):setPositionY(95)
			SoraDGetChildByName(self, "Size_ImageBg"):setContentSize(cc.size(640, display.height - 164))
			self.detailScrollView:setPositionY(display.height - 79)
			self.title:setPositionY(display.height)
			if SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Detail") then
				SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Detail"):setVisible(true)
			end
			if SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Report") then
				SoraDGetChildByName(self.detailScrollView.scrollView, "Button_Report"):setVisible(true)
			end
			if SoraDGetChildByName(self.detailScrollView.scrollView, "Button_SpeedDetail") then
				SoraDGetChildByName(self.detailScrollView.scrollView, "Button_SpeedDetail"):setVisible(true)
			end
			self.detailScrollView.scrollView:setClippingEnabled(true)
		end
		cc.Director:getInstance():setRenderVisibleCheck(true)
	end
end
function mailItemDetailView:getShotHeight()
	if true or device.platform == "mac" then
		local offSetY = 0
		_UPVALUE3_ = nil
		;(nil)[1] = "Button_Detail"
		;(nil)[2] = "Button_Report"
		;(nil)[3] = "Button_SpeedDetail"
		for i, v in ipairs(nil) do
			if SoraDGetChildByName(self.detailScrollView.scrollView, v) then
				offSetY = offSetY + 77
			end
		end
		local realHeight = self.detailScrollView.scrollView:getInnerContainerSize().height + 190 + 80 - offSetY
		return math.min(4096, realHeight), realHeight, offSetY
	else
		return display.height + 190, display.height + 190
	end
end
return mailItemDetailView
