local commonAgreementBox = class("commonAgreementBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonAgreementBox")
	end
	return target
end)
function commonAgreementBox:ctor()
	self.isSelected = true
	self.isAddToPopManager = true
	self:setBackGround(204.0, cc.c3b(0, 0, 0))
	self.tableData, _ENV, self.tablePrizeSinge, _ENV = self.setBackGround, self.setBackGround, self.setBackGround, self.setBackGround
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setContentSize(display.size)
	self.layerTouch:setPositionY(-90)
	self.img4 = SoraDGetChildByName(self, "Image_4")
	self.nodeBg = SoraDGetChildByName(self, "Node_bg")
	self.nodeEffect = SoraDGetChildByName(self, "Node_effect")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.btnTitleText = SoraDGetChildByName(self, "Text_1")
	self.nodeItemParent = SoraDGetChildByName(self, "Node_item_parent")
	self.img_title = SoraDGetChildByName(self, "Image_title")
	_UPVALUE2_ = cc.c3b(0, 0, 0)
	cc.c3b(0, 0, 0)[1] = "ar"
	cc.c3b(0, 0, 0)[2] = "en"
	self.img_title:setSpriteFrame(SoraDGetImageNameByLang("frame_zjjl_zhangjiejiangli_%s.png", cc.c3b(0, 0, 0)))
	self.labelDes:setString(i18n("common_text_3679"))
	self.labelNotice:setString(i18n("common_text_3678"))
	for i, v in ipairs(self.nodeItemParent:getChildren()) do
		local single = include("commonItems").new(v)
		single:setOpacity(0)
		single:setCascadeOpacityEnabled(true)
		single.btnItem = SoraDGetChildByName(v, "Button_item")
		single.btnItem:addTouchEventListener(handler(self, self.itemClickCallBack))
		table.insert(self.tablePrizeSinge, single)
	end
	self.itemTip = SoraDCreatePanel("commonItemTips")
	self.itemTip:addTo(self.nodeItemParent, 2)
	self.itemTip:setVisible(false)
	self.itemTip:setScale(0.8)
	SoraDPlaySound("normalcontrol", 3)
	self.lab_look = SoraDGetChildByName(self, "Text_look")
	self.lab_look_0 = SoraDGetChildByName(self, "Text_look_0")
	self.lab_look:setTouchEnabled(true)
	self.lab_look:setTouchScaleChangeEnabled(true)
	self.lab_look:addTouchEventListener(handler(self, self.onLookClick))
	self.lab_tip = SoraDGetChildByName(self, "Text_tip")
	self.btn_select = SoraDGetChildByName(self, "Button_select")
	self.btn_select:addTouchEventListener(handler(self, self.btnSelectClickCallBack))
	self.img_select = SoraDGetChildByName(self, "icon_select")
	self.img_select:setVisible(self.isSelected)
	self.btn_contine = SoraDGetChildByName(self, "Button_ok")
	self.btnTitleText:setString(i18n("common_text_1146"))
	self.btn_contine:addTouchEventListener(handler(self, self.onBtnContinueClick))
	self.btn_close = SoraDGetChildByName(self, "Button_closeBox")
	self.btn_close:addTouchEventListener(handler(self, self.onBtnCloseClick))
	self.btn_close:setVisible(false)
	self:initData()
	userSDKManager.onGuideEvent(2038)
	userSDKManager.onGuideEvent(2801)
	self:playAnimate()
end
function commonAgreementBox:playAnimate()
	local gametop = gModuleMgr.getObject("gametop")
	local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	local animationName = curChapterID == 4103100 and "animation01" or "animation02"
	local delayF = curChapterID == 4103100 and 70 or 10
	self.centerBg = SoraDGetChildByName(self, "Center_Bg")
	self.spine_bg = sp.SkeletonAnimation:create("spine/dakai.skel", "spine/dakai.atlas", 1)
	self.spine_bg:addTo(self.centerBg, 1)
	self.spine_bg:setAnimation(0, animationName, false)
	self.spine_bg:setPosition(319, -125)
	_UPVALUE5_ = self.spine_bg.setPosition
	self.spine_bg.setPosition[1] = self.lab_look
	self.spine_bg.setPosition[2] = self.lab_look_0
	self.spine_bg.setPosition[3] = self.btn_contine
	self.spine_bg.setPosition[4] = self.lab_tip
	local self.spine_bg.setPosition[5], aniNodes = self.btn_select, self.spine_bg.setPosition
	for i, v in ipairs(aniNodes) do
		v:setVisible(false)
		v:setOpacity(0)
	end
	_UPVALUE1_ = self.lab_tip
	self.lab_tip[1] = cca.delay(delayF / 60)
	self.lab_tip[2] = cca.callFunc(function()
		for i, v in ipairs(self.tablePrizeSinge) do
			v:setScale(0.25)
			self = nil
			self = nil
			;(nil)[1] = cca.scaleTo(0.16666666666666666, 0.6)
			;(nil)[2] = cca.scaleTo(0.25, 0.55)
			;(nil)[3] = cca.scaleTo(0.25, 0.55)
			;(nil)[4] = cca.scaleTo(0.25, 0.55)
			;(nil)[1] = cca.fadeIn(0.16666666666666666)
			;(nil)[2] = cca.seq(nil)
			;(nil)[3] = cca.seq(nil)
			;(nil)[4] = cca.seq(nil)
			;(nil)[5] = cca.seq(nil)
			;(nil)[6] = cca.seq(nil)
			;(nil)[7] = cca.seq(nil)
			v:runAction(cca.spawn(nil))
		end
		for i, v in ipairs(aniNodes) do
			v:setVisible(true)
			v:runAction(cca.fadeIn(0.16666666666666666))
		end
		SoraDDrawTextUnderLine(self.lab_look_0, cc.c4b(1, 1, 1, 200), 1.5, cc.p(0, 0), cc.p(self.lab_look_0:getContentSize().width, 0))
		SoraDDrawTextUnderLine(self.lab_look, cc.c4b(92, 138, 153, 255), 1.5, cc.p(0, 0), cc.p(self.lab_look:getContentSize().width, 0))
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = cc.p(self.lab_look:getContentSize().width, 0)
		cc.p(self.lab_look:getContentSize().width, 0)[1] = cca.delay(1.25)
		cc.p(self.lab_look:getContentSize().width, 0)[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[4] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[5] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[6] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[7] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[8] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[9] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[10] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		self:runAction(cca.seq(cc.p(self.lab_look:getContentSize().width, 0)))
	end)
	self.lab_tip[3] = cca.callFunc(function()
		for i, v in ipairs(self.tablePrizeSinge) do
			v:setScale(0.25)
			self = nil
			self = nil
			;(nil)[1] = cca.scaleTo(0.16666666666666666, 0.6)
			;(nil)[2] = cca.scaleTo(0.25, 0.55)
			;(nil)[3] = cca.scaleTo(0.25, 0.55)
			;(nil)[4] = cca.scaleTo(0.25, 0.55)
			;(nil)[1] = cca.fadeIn(0.16666666666666666)
			;(nil)[2] = cca.seq(nil)
			;(nil)[3] = cca.seq(nil)
			;(nil)[4] = cca.seq(nil)
			;(nil)[5] = cca.seq(nil)
			;(nil)[6] = cca.seq(nil)
			;(nil)[7] = cca.seq(nil)
			v:runAction(cca.spawn(nil))
		end
		for i, v in ipairs(aniNodes) do
			v:setVisible(true)
			v:runAction(cca.fadeIn(0.16666666666666666))
		end
		SoraDDrawTextUnderLine(self.lab_look_0, cc.c4b(1, 1, 1, 200), 1.5, cc.p(0, 0), cc.p(self.lab_look_0:getContentSize().width, 0))
		SoraDDrawTextUnderLine(self.lab_look, cc.c4b(92, 138, 153, 255), 1.5, cc.p(0, 0), cc.p(self.lab_look:getContentSize().width, 0))
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = cc.p(self.lab_look:getContentSize().width, 0)
		cc.p(self.lab_look:getContentSize().width, 0)[1] = cca.delay(1.25)
		cc.p(self.lab_look:getContentSize().width, 0)[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[4] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[5] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[6] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[7] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[8] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[9] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[10] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		self:runAction(cca.seq(cc.p(self.lab_look:getContentSize().width, 0)))
	end)
	self.lab_tip[4] = cca.callFunc(function()
		for i, v in ipairs(self.tablePrizeSinge) do
			v:setScale(0.25)
			self = nil
			self = nil
			;(nil)[1] = cca.scaleTo(0.16666666666666666, 0.6)
			;(nil)[2] = cca.scaleTo(0.25, 0.55)
			;(nil)[3] = cca.scaleTo(0.25, 0.55)
			;(nil)[4] = cca.scaleTo(0.25, 0.55)
			;(nil)[1] = cca.fadeIn(0.16666666666666666)
			;(nil)[2] = cca.seq(nil)
			;(nil)[3] = cca.seq(nil)
			;(nil)[4] = cca.seq(nil)
			;(nil)[5] = cca.seq(nil)
			;(nil)[6] = cca.seq(nil)
			;(nil)[7] = cca.seq(nil)
			v:runAction(cca.spawn(nil))
		end
		for i, v in ipairs(aniNodes) do
			v:setVisible(true)
			v:runAction(cca.fadeIn(0.16666666666666666))
		end
		SoraDDrawTextUnderLine(self.lab_look_0, cc.c4b(1, 1, 1, 200), 1.5, cc.p(0, 0), cc.p(self.lab_look_0:getContentSize().width, 0))
		SoraDDrawTextUnderLine(self.lab_look, cc.c4b(92, 138, 153, 255), 1.5, cc.p(0, 0), cc.p(self.lab_look:getContentSize().width, 0))
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = cc.p(self.lab_look:getContentSize().width, 0)
		cc.p(self.lab_look:getContentSize().width, 0)[1] = cca.delay(1.25)
		cc.p(self.lab_look:getContentSize().width, 0)[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[4] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[5] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[6] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[7] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[8] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[9] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		cc.p(self.lab_look:getContentSize().width, 0)[10] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		self:runAction(cca.seq(cc.p(self.lab_look:getContentSize().width, 0)))
	end)
	self:runAction(cca.seq(self.lab_tip))
end
function commonAgreementBox:initData()
	local mainCityGuideRead = include("mainCityGuideRead")
	self.tableData = mainCityGuideRead:getReward(813500)
	for i, v in ipairs(self.tablePrizeSinge) do
		if self.tableData[i] then
			v:initData(self.tableData[i])
			v.btnItem:setTag(self.tableData[i].itemID)
			v.name:setVisible(false)
		else
			v:setVisible(false)
		end
	end
	self:suitView()
end
function commonAgreementBox:itemClickCallBack(button, type)
	if type == ccui.TouchEventType.began then
		local btnParent = button:getParent()
		self.itemTip:initData(button:getTag())
		self.itemTip:setVisible(true)
		self.itemTip:setPosition(cc.p(btnParent:getPositionX() + SoraDFSign(110), btnParent:getPositionY() + 170))
	elseif type ~= ccui.TouchEventType.moved then
		self.itemTip:setVisible(false)
	end
end
function commonAgreementBox:suitView()
	self.titleKey = i18n("common_text_3422")
	self.url = gSvrConfig.linkUrlConfig.policy
	_ENV = nil
	;(nil).rule = self.titleKey
	self.lab_look:setString(i18n("common_text_3424", nil))
	_ENV = i18n("common_text_3424", nil)
	i18n("common_text_3424", nil).rule = self.titleKey
	self.lab_look_0:setString(i18n("common_text_3424", i18n("common_text_3424", nil)))
	_ENV = i18n("common_text_3424", i18n("common_text_3424", nil))
	i18n("common_text_3424", i18n("common_text_3424", nil)).rule = self.titleKey
	self.lab_tip:setString(i18n("common_text_3426", i18n("common_text_3424", i18n("common_text_3424", nil))))
	local period = SoraDGetDayPeriod()
	if period == gDay.DAY_TIME then
		self:setBackGround(204.0, cc.c3b(0, 0, 0))
	else
		self:setBackGround(127.5, cc.c3b(0, 0, 0))
	end
end
function commonAgreementBox:btnSelectClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isSelected = true
		self.img_select:setVisible(self.isSelected)
		self.btn_contine:setBright(self.isSelected)
		self:closeConfirm()
	end
end
function commonAgreementBox:onLookClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local channel = userSDKManager.getChannel()
		if channel == "ar" and SoraDFIsRA() then
			userSDKManager.openSDKLink(self.url)
		else
			userSDKManager.openSDKLink(self.url)
		end
	end
end
function commonAgreementBox:onBtnContinueClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isSelected then
			_ENV = nil
			;(nil).rule = self.titleKey
			SoraDShowMsgTip(i18n("common_text_3449", nil))
		else
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			lordInfoCtrl:sendCheckUserAgreement()
			_ENV = i18n("common_text_3449", nil)
			_ENV, i18n("common_text_3449", nil).isAgree = i18n("common_text_3449", nil)
			i18n("common_text_3449", nil).byUID = true
			SoraDConfigSet("Game:GetCrashlytics:track~table", i18n("common_text_3449", nil))
			_ENV = i18n("common_text_3449", nil)
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_continue_game, i18n("common_text_3449", nil))
			userSDKManager.reportFinishGuide()
			local _ENV, itemData = userSDKManager.reportFinishGuide, userSDKManager.reportFinishGuide
			for i, v in ipairs(self.tableData) do
				_ENV = i18n("common_text_3449", nil)
				i18n("common_text_3449", nil).id = v.itemID
				i18n("common_text_3449", nil).count = v.itemCount
				table.insert(itemData, i18n("common_text_3449", nil))
			end
			SoraDMailGainItems(itemData, true)
			self:removeFromParent()
		end
	end
end
function commonAgreementBox:showGirl()
	local gametop = gModuleMgr.getObject("gametop")
	local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if curChapterID == 4103100 then
		userSDKManager.onGuideEvent(2039)
	end
	SoraDNewChapterOpen()
end
function commonAgreementBox:closeConfirm()
	_ENV = nil
	;(nil).rule = self.titleKey
	local panel = SoraDShowMsgBox(i18n("common_text_3427", nil), i18n("common_text_185"), i18n("common_text_204"), function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
		elseif eventType == MSGBOX_CALLBACK_NO then
			print("退出游戏===")
			if device.platform == "android" or device.platform == "mac" then
				app:exit()
			else
				os.exit()
			end
		end
	end)
	panel:setLocalZOrder(202)
end
function commonAgreementBox:onBtnCloseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closeConfirm()
	end
end
function commonAgreementBox:show(parent)
	parent = parent or display.getRunningScene().panelView
	if parent then
		SoraDAddPanelToManager(self)
		parent:addChild(self, 201)
	end
end
return commonAgreementBox
