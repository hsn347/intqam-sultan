local CommonSharePic = class("commonSharePic", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSharePic")
	end
	return target
end)
function CommonSharePic:ctor()
	self.tableHappleBigDataType = 1
	self.isHidePrePanel = false
	self.rtSprite = nil
	self.basePosY = 0
	self.noOperation = true
	self.cutCount = 0
	self.panelCut = SoraDGetChildByName(self, "Top_Size_Panel_cut")
	self.nodeDown = SoraDGetChildByName(self, "Node_down")
	self.imgBottom = SoraDGetChildByName(self, "Image_bottom")
	self.imgFrame = SoraDGetChildByName(self, "Image_frame")
	self.labelUrl = SoraDGetChildByName(self, "Text_url")
	self.labelKingdom = SoraDGetChildByName(self, "Text_king")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelUid = SoraDGetChildByName(self, "Text_uid")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.imgHeadBg = SoraDGetChildByName(self, "Image_headBg")
	self.btnDown = SoraDGetChildByName(self, "Button_down")
	self.imgDown = SoraDGetChildByName(self, "Image_down")
	self.btnUp = SoraDGetChildByName(self, "Top_Button_up")
	self.imgUp = SoraDGetChildByName(self, "Image_up")
	self.btnSave = SoraDGetChildByName(self, "Button_save")
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	self.btnClose = SoraDGetChildByName(self, "Button_close")
	self.spriteGame = SoraDGetChildByName(self, "Sprite_game")
	self.spriteGame:setSpriteFrame(IsArClient and "icon_game.png" or "icon_ros_game.png")
	self.spriteGame:setScale(0.6)
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node")
	self.labelSize = SoraDGetChildByName(self, "Text_size")
	self.logoIcon = SoraDGetChildByName(self.nodeDown, "logo_25")
	if userSDKManager.isKO() then
		self.logoIcon:setSpriteFrame("switcher_bg_title_ko.png")
	end
	self:setBackGround(204.0)
	self.btnDown:addTouchEventListener(handler(self, self.btnDownClickCallBack))
	self.btnUp:addTouchEventListener(handler(self, self.btnUpClickCallBack))
	self.btnSave:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnShare:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnClose:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnDown:setPressedActionEnabled(false)
	self.btnUp:setPressedActionEnabled(false)
	self.textTime = SoraDGetChildByName(self.nodeDown, "Text_Time")
	self.textTime:setString(string.format("UTC+0  %s", os.date("!%Y-%m-%d %H:%M:%S", serviceFunctions.systemTime())))
	SoraDAddMessage(self, "MESSAGE_TOP_COMMON_SHARE_BACK", handler(self, self.msgShareBack))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
	end)
end
function CommonSharePic:msgShareBack(target, data)
	SoraDCloseLoading(self)
	if "saveSuccess" == data.result then
		SoraDShowMsgTip(i18n("screen_text_02"), "#icon_jt_3.png")
	end
end
function CommonSharePic:initData(rtPoint, type, closeCallBack)
	SoraDPlaySound("uicontrol", 42)
	if SoraDIsGameGuide() then
		self:removeFromParent()
		return
	end
	local scale = 0.703125 * display.realSize.width / display.sizeInPixels.width
	self.tableHappleBigDataType = type
	self.rtSprite = rtPoint
	local scale = 0.703125 * self.rtSprite:getScale()
	self.rtSprite:addTo(self.panelCut)
	self.rtSprite:setScale(scale)
	self.rtSprite:setAnchorPoint(cc.p(0, 0))
	self.rtSprite:setPosition(0, 0)
	_UPVALUE1_ = 0
	;(0)[1] = cca.delay(0)
	;(0)[2] = cca.callFunc(function()
		self.btnUp:setPositionY(self.rtSprite:getContentSize().height * scale + 136 + 110)
		self:updateFrame(true)
		self:initView()
		self.baseDownY = self.nodeDown:getPositionY()
		self.baseUpY = self.btnUp:getPositionY()
		self.baseMinH = self.imgBottom:getContentSize().height
		self = true
		;(true).entrance = self.tableHappleBigDataType
		userSDKManager.logEvent(gSDKDef.TDonEvent.share_button_cut, true)
		self:showGuideFinger()
		self.closeCallBack = closeCallBack
	end)
	;(0)[3] = cca.callFunc(function()
		self.btnUp:setPositionY(self.rtSprite:getContentSize().height * scale + 136 + 110)
		self:updateFrame(true)
		self:initView()
		self.baseDownY = self.nodeDown:getPositionY()
		self.baseUpY = self.btnUp:getPositionY()
		self.baseMinH = self.imgBottom:getContentSize().height
		self = true
		;(true).entrance = self.tableHappleBigDataType
		userSDKManager.logEvent(gSDKDef.TDonEvent.share_button_cut, true)
		self:showGuideFinger()
		self.closeCallBack = closeCallBack
	end)
	self:runAction(cca.seq(0))
end
function CommonSharePic:showGuideFinger(isClose)
	if isClose then
		if self.spriteBottomFinger then
			self.spriteBottomFinger:removeFromParent()
			self.spriteTopFinger:removeFromParent()
			self.guideTips:removeFromParent()
			self.guideTips = nil
			self.spriteBottomFinger = nil
			self.spriteTopFinger = nil
			self.btnUp:setScale(1)
			self.btnDown:setScale(1)
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:Guide:sharePicFirstCut~bool", false, nil)
		end
	else
		_ENV = false
		;(false).byUID = true
		if SoraDConfigGet("Game:Guide:sharePicFirstCut~bool", false) then
			_ENV = "gameGuideView"
			;("gameGuideView").str = i18n("screen_text_08")
			;("gameGuideView").size = cc.size(300, 100)
			;("gameGuideView").offset = cc.p(0, 20)
			;("gameGuideView").arr = "bottom"
			;("gameGuideView").touchRect = self.btnUp:getBoundingBox()
			self.guideTips = include("gameGuideView").createTipFrame("gameGuideView")
			self.guideTips:addTo(self.btnUp:getParent())
			self.spriteTopFinger = SoraDFingerAction(true, true)
			self.spriteTopFinger:setOpacity(0)
			self.spriteTopFinger:addTo(self.btnUp:getParent())
			_UPVALUE4_ = self.btnUp:getParent()
			self.btnUp:getParent()[1] = cca.callFunc(function(...)
				self.spriteTopFinger:setPosition(self.btnUp:getPositionX(), self.btnUp:getPositionY())
			end)
			self.btnUp:getParent()[2] = cca.fadeIn(0.1)
			self.btnUp:getParent()[3] = cca.moveBy(1, 0, -100)
			self.btnUp:getParent()[4] = cca.fadeOut(0.5)
			self.btnUp:getParent()[5] = cca.delay(1.6)
			self.btnUp:getParent()[6] = cca.delay(1.6)
			self.btnUp:getParent()[7] = cca.delay(1.6)
			self.spriteTopFinger:runAction(cca.repeatForever(cca.seq(self.btnUp:getParent())))
			self.spriteBottomFinger = SoraDFingerAction(true, true)
			self.spriteBottomFinger:setOpacity(0)
			self.spriteBottomFinger:addTo(self.nodeDown:getParent())
			_UPVALUE4_ = self.nodeDown:getParent()
			self.nodeDown:getParent()[1] = cca.callFunc(function(...)
				self.spriteBottomFinger:setPosition(self.nodeDown:getPositionX(), self.nodeDown:getPositionY())
			end)
			self.nodeDown:getParent()[2] = cca.delay(1.6)
			self.nodeDown:getParent()[3] = cca.fadeIn(0.1)
			self.nodeDown:getParent()[4] = cca.moveBy(1, 0, 100)
			self.nodeDown:getParent()[5] = cca.fadeOut(0.5)
			self.nodeDown:getParent()[6] = cca.fadeOut(0.5)
			self.nodeDown:getParent()[7] = cca.fadeOut(0.5)
			self.spriteBottomFinger:runAction(cca.repeatForever(cca.seq(self.nodeDown:getParent())))
		end
	end
end
function CommonSharePic:initView()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local playerInfo = lordInfoCtrl:getLordInfo()
	self.labelUrl:setString(self:getShareUrl())
	local posX = self.labelUrl:getContentSize().width / 2
	posX = SoraDFIsRA() and posX or -posX
	self.spriteGame:setPositionX(posX)
	if playerInfo.base.sourceKid and playerInfo.base.sourceKid > 0 then
		_ENV = self:getShareUrl()
		self:getShareUrl().kid = playerInfo.base.sourceKid
		self.labelKingdom:setString(i18n("common_text_342", self:getShareUrl()))
	else
		_ENV = i18n("common_text_342", self:getShareUrl())
		i18n("common_text_342", self:getShareUrl()).kid = playerInfo.base.partition
		self.labelKingdom:setString(i18n("common_text_342", i18n("common_text_342", self:getShareUrl())))
	end
	if 0 >= string.utf8len(playerInfo.abbr) then
		self.labelName:setString(playerInfo.base.nickName)
	else
		_ENV = i18n("common_text_342", i18n("common_text_342", self:getShareUrl()))
		i18n("common_text_342", i18n("common_text_342", self:getShareUrl())).abbr = playerInfo.abbr
		i18n("common_text_342", i18n("common_text_342", self:getShareUrl())).name = playerInfo.base.nickName
		self.labelName:setString(i18n("common_text_186", i18n("common_text_342", i18n("common_text_342", self:getShareUrl()))))
	end
	local accountExtCtrl = SoraDGetCtrl("accountExtCtrl")
	_ENV = i18n("common_text_186", i18n("common_text_342", i18n("common_text_342", self:getShareUrl())))
	i18n("common_text_186", i18n("common_text_342", i18n("common_text_342", self:getShareUrl()))).uid = accountExtCtrl:getAccountPid()
	self.labelUid:setString(i18n("common_text_1041", i18n("common_text_186", i18n("common_text_342", i18n("common_text_342", self:getShareUrl())))))
	SoraDGetHeadFromManager(self.imgHead, playerInfo.base.imageId, playerInfo.base.avatar)
end
function CommonSharePic:getShareUrl()
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
function CommonSharePic:updateFrame(isInit)
	local btnHeight = self.btnUp:getPositionY() - self.nodeDown:getPositionY()
	self.panelCut:setPositionY(self.btnUp:getPositionY())
	self.panelCut:setContentSize(cc.size(450, btnHeight - 136))
	self.imgFrame:setContentSize(cc.size(458, btnHeight + 5))
	if isInit then
		self.basePosY = self.rtSprite:convertToWorldSpace(cc.p(0, 0)).y
	else
		self.rtSprite:setPositionY(self.panelCut:convertToNodeSpace(cc.p(0, self.basePosY)).y)
	end
	if 0 < self.cutCount then
		self.nodeCenter:stopAllActions()
		self.nodeCenter:setOpacity(255)
	else
		self.nodeCenter:runAction(cca.fadeOut(0.5))
	end
	local scale = math.min(display.width / 458, display.height / (btnHeight + 5))
	self.nodeCenter:setPositionY(0.5 * btnHeight + self.nodeDown:getPositionY())
	self.labelSize:setString(tostring(math.floor(458)) .. " x " .. tostring(math.floor(btnHeight + 5)))
end
function CommonSharePic:btnDownClickCallBack(button, type)
	if type == ccui.TouchEventType.moved then
		local touchmovePoint = button:getTouchMovePosition()
		self.nodeDown:setPositionY(math.min(math.max(touchmovePoint.y, self.baseDownY), self.btnUp:getPositionY() - self.baseMinH))
	elseif type == ccui.TouchEventType.ended then
		_ENV = self.nodeDown
		self.nodeDown.entrance = self.tableHappleBigDataType
		userSDKManager.logEvent(gSDKDef.TDonEvent.share_pic_cut, self.nodeDown)
		self.cutCount = self.cutCount - 1
	elseif type == ccui.TouchEventType.canceled then
		self.cutCount = self.cutCount - 1
	elseif type == ccui.TouchEventType.began then
		self.cutCount = self.cutCount + 1
		self:showGuideFinger(true)
	end
	self:updateFrame()
end
function CommonSharePic:btnUpClickCallBack(button, type)
	if type == ccui.TouchEventType.moved then
		local touchmovePoint = button:getTouchMovePosition()
		button:setPositionY(math.max(math.min(touchmovePoint.y, self.baseUpY), self.nodeDown:getPositionY() + self.baseMinH))
	elseif type == ccui.TouchEventType.ended then
		_ENV = button
		button.entrance = self.tableHappleBigDataType
		userSDKManager.logEvent(gSDKDef.TDonEvent.share_pic_cut, button)
		self.cutCount = self.cutCount - 1
	elseif type == ccui.TouchEventType.canceled then
		self.cutCount = self.cutCount - 1
	elseif type == ccui.TouchEventType.began then
		self.cutCount = self.cutCount + 1
		self:showGuideFinger(true)
	end
	self:updateFrame()
end
function CommonSharePic:hiddleOther(isHiddle)
	self.btnDown:setVisible(not isHiddle)
	self.btnUp:setVisible(not isHiddle)
	if self.spriteBottomFinger then
		self.spriteBottomFinger:setVisible(not isHiddle)
		self.spriteTopFinger:setVisible(not isHiddle)
		self.guideTips:setVisible(not isHiddle)
	end
end
function CommonSharePic:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnClose == button then
			if self.noOperation then
				_ENV = nil
				;(nil).parent = self
				SoraDShowMsgBox(i18n("screen_text_01"), i18n("common_text_204"), i18n("common_text_185"), function(type)
					if type == MSGBOX_CALLBACK_YES then
						_ENV = nil
						;(nil).entrance = self.tableHappleBigDataType
						userSDKManager.logEvent(gSDKDef.TDonEvent.share_pic_delete, nil)
						print("关闭按钮")
						if self.closeCallBack then
							self.closeCallBack()
						end
						self:removeFromParent()
					end
				end, nil)
			else
				print("关闭按钮")
				if self.closeCallBack then
					self.closeCallBack()
				end
				self:removeFromParent()
			end
		else
			local leftMem = SoraDGetSystemFreeMem()
			print("SoraDGetSystemFreeMem", leftMem)
			if leftMem ~= "macosx" and tonumber(leftMem) / 1048576 < 100 then
				SoraDShowMsgTip(i18n("mail_2_text_71"))
				return
			end
			self.noOperation = false
			local winSize = cc.Director:getInstance():getWinSize()
			local winSizeP = cc.Director:getInstance():getWinSizeInPixels()
			local fileName = "share.jpg"
			self:hiddleOther(true)
			local frameSize = self.imgFrame:getContentSize()
			frameSize.height = display.iPhoneXBottom ~= 0 and frameSize.height >= 994 and 1120 or frameSize.height
			local renderTexture = cc.RenderTexture:create(frameSize.width, frameSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 35056)
			renderTexture:setKeepMatrix(true)
			renderTexture:setSaveScale(math.max(winSizeP.width / frameSize.width, winSizeP.width / frameSize.width))
			renderTexture:addTo(self.imgFrame:getParent())
			renderTexture:setPosition(0, frameSize.height / 2 + self.imgFrame:getPositionY())
			renderTexture:beginWithClear(0, 0, 0, 0)
			self:visit()
			renderTexture:endToLua()
			renderTexture:saveToFile(fileName, 0, false)
			_ENV = 0
			;(0).onComplete = function()
				if G_IS_UNITY then
					SoraDShowMsgTip(i18n("screen_text_02"), "#icon_jt_3.png")
				end
				renderTexture:removeFromParent()
				self:hiddleOther()
			end
			transition.execute(self, nil, 0)
			SoraDShowLoading(self)
			if self.btnSave == button then
				_ENV = 0
				;(0).delay = 0.1
				;(0).onComplete = function()
					if device.platform ~= "mac" then
						userSDKManager.saveShareImage(fileName)
					end
					SoraDCloseLoading(self)
					_ENV = nil
					;(nil).entrance = self.tableHappleBigDataType
					userSDKManager.logEvent(gSDKDef.TDonEvent.share_pic_save, nil)
				end
				transition.execute(self, nil, 0)
			elseif self.btnShare == button then
				_ENV = 0
				;(0).delay = 0.1
				;(0).onComplete = function()
					if device.platform ~= "mac" then
						_ENV = nil
						;(nil).url = self:getShareUrl()
						userSDKManager.commonShare(i18n("common_text_4332", nil), fileName)
					end
					_ENV = fileName
					fileName.entrance = self.tableHappleBigDataType
					userSDKManager.logEvent(gSDKDef.TDonEvent.share_pic_share, fileName)
				end
				transition.execute(self, nil, 0)
			end
		end
	end
end
function CommonSharePic:endShow()
	if SoraDIsGameGuide() then
		self:removeFromParent()
		return
	end
end
return CommonSharePic
