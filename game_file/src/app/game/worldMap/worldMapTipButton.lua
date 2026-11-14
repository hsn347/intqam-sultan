local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceCounterSysCtrl = gametop.playertop_:getModule("allianceCounterSysCtrl")
local worldMapTipButton = class("worldMapTipButton", function()
	return SoraDCreateBasePanel("worldMapTipButton")
end)
function worldMapTipButton:ctor()
	self.tipButtonData, _ENV, self.tipButtonType = nil, nil, nil
	self.isButtonEnabled = true
	self.kingdomID = 0
	self.mapInstance = nil
	self.tilePoint = nil
	self.tipButtonNameLabel = SoraDGetChildByName(self, "Text_name")
	self.tipButtonNameLabel:enableOutline(cc.c3b(0, 0, 0), 1)
	self.tipButtonNameLabel:enableShadow()
	self.tipButtonNameBg = SoraDGetChildByName(self, "Image_1")
	self.tipButtonImage = SoraDGetChildByName(self, "image_button")
	self.bgButton = SoraDGetChildByName(self, "Button_Bg")
	if self.bgButton then
		self.bgButton:addTouchEventListener(function(ref, type)
			self:bgButtonCallFun(ref, type)
		end)
	end
end
function worldMapTipButton:initData(tipButtonData, mapInstance, tilePoint, kingdomID)
	self.tipButtonType = tipButtonData.buttonType
	if not tipButtonData.data then
		_ENV = tipButtonData.data
	end
	self.tipButtonData = tipButtonData.data
	if not tipButtonData.extra then
		_ENV = tipButtonData.extra
	end
	self.tipButtonExtra = tipButtonData.extra
	self.mapInstance = mapInstance
	self.tilePoint = tilePoint
	self.kingdomID = kingdomID
	if tipButtonData.isButtonEnabled ~= nil then
		self.isButtonEnabled = tipButtonData.isButtonEnabled
	end
	if tipButtonData.msgTipsKey ~= nil then
		self.msgTipsKey = tipButtonData.msgTipsKey
	end
	local buttonName = worldMapDefine.getMapTipButtonName(self.tipButtonType)
	buttonName = allianceCounterSysCtrl:getMapTipButtonName(self.tipButtonType, self.mapInstance, buttonName)
	self.tipButtonNameLabel:setString(buttonName)
	local sSize = self.tipButtonNameLabel:getVirtualRendererSize()
	local bgSize = self.tipButtonNameBg:getContentSize()
	local bgWidth = math.max(sSize.width + 50, bgSize.width)
	local bgHeight = bgSize.height
	if sSize.width > 160 then
		bgHeight = 40
		bgWidth = 210
	end
	self.tipButtonNameBg:setContentSize(cc.size(bgWidth, bgHeight))
	local buttonImgName = worldMapDefine.getTipButtonImageName(self.tipButtonType)
	buttonImgName = allianceCounterSysCtrl:getTipButtonImageName(self.tipButtonType, self.mapInstance, buttonImgName)
	self.tipButtonImage:loadTexture(buttonImgName, ccui.TextureResType.plistType)
	self.tipButtonImage:ignoreContentAdaptWithSize(true)
	if self.tipButtonType == worldMapDefine.worldMapTipButtonType_hegemonrenMing then
		self.tipButtonImage:setScale(0.5)
	else
		self.tipButtonImage:setScale(0.8)
	end
	if self.isButtonEnabled then
		self.tipButtonImage:getVirtualRenderer():setState(0)
	else
		self.tipButtonImage:getVirtualRenderer():setState(1)
	end
	if self.tipButtonType == worldMapDefine.worldMapTipButtonType_decorate then
		local dressCtrl = SoraDGetCtrl("dressCtrl")
		if dressCtrl:isShowMenuRed() then
			self:showDecorateEffect()
		end
	end
	self:updateGuide()
end
function worldMapTipButton:showDecorateEffect()
	if self:getChildByName("et_effect_vip") then
		self:getChildByName("et_effect_vip"):setVisible(true)
		return
	end
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:setName("et_effect_vip")
	sprite:setPosition(0, 0)
	sprite:addTo(self, 2)
	_ENV, _ENV = sprite, sprite.addTo
	_ENV, sprite.addTo[1], sprite.plist = sprite, sprite, "et_pyramid_active_01.plist"
	sprite.addTo[2], sprite.plist = sprite, "et_pyramid_active_01.plist"
	local param = sprite.addTo
	local et_node1 = SoraDCreateEffectNode(param)
	et_node1:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node1:setScale(1.2)
	et_node1:addTo(sprite)
	local et_node2 = SoraDCreateEffectNode(param)
	et_node2:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
	et_node2:setScale(1.2)
	et_node2:setRotation(180)
	et_node2:addTo(sprite)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
end
function worldMapTipButton:updateGuide()
	local guideStep = SoraDIsGameGuide()
	if guideStep then
		if guideStep == 2030 then
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;(nil).step = 2031
			SoraDSendMessage(nil)
		elseif guideStep == 28006 then
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;(nil).step = 28007
			SoraDSendMessage(nil)
		end
	end
end
function worldMapTipButton:showMsgTips()
	if self.msgTipsKey then
		if type(self.msgTipsKey) == "function" then
			self.msgTipsKey(self)
		else
			SoraDShowMsgTip(self.msgTipsKey)
		end
	end
end
function worldMapTipButton:bgButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound(nil, nil, true)
		if worldMapDefine.isInNebulaAllStar() then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			if nebulaAllStarUtil.checkForbitTipButtonType(self.tipButtonType) then
				return
			end
		end
		if self.isButtonEnabled == false then
			if self.tipButtonType == worldMapDefine.worldMapTipButtonType_zhanLing then
				if self.msgTipsKey then
					self:showMsgTips()
				else
					SoraDShowMsgTip(i18n("common_text_485"))
				end
			elseif self.tipButtonType == worldMapDefine.worldMapTipButtonType_lingdiqianCheng then
				SoraDShowMsgBox(i18n("common_text_3111"), i18n("common_text_054"), nil, nil)
			elseif self.tipButtonType == worldMapDefine.worldMapTipButtonType_shibingYuabzhu or self.tipButtonType == worldMapDefine.worldMapTipButtonType_qianru or self.tipButtonType == worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu then
				if self.msgTipsKey then
					self:showMsgTips()
				else
					SoraDShowMsgTip(i18n("common_text_3400"))
				end
			elseif self.tipButtonType == worldMapDefine.worldMapTipButtonType_gongJi or self.tipButtonType == worldMapDefine.worldMapTipButtonType_xuanZhan then
				if self.msgTipsKey then
					self:showMsgTips()
				elseif worldMapDefine.isInRadiance() then
					local objId = self.mapInstance:getSiteClassID()
					local msgNotice = include("msgNotice")
					_ENV = i18n("common_text_3400")
					_ENV, i18n("common_text_3400").err = gErrDef.Err_RADIANCE_WAR_BUILD_CAN_NOT_OCCUPY, gErrDef.Err_RADIANCE_WAR_BUILD_CAN_NOT_OCCUPY
					i18n("common_text_3400").data, gErrDef.Err_RADIANCE_WAR_BUILD_CAN_NOT_OCCUPY.objId = gErrDef.Err_RADIANCE_WAR_BUILD_CAN_NOT_OCCUPY, objId
					msgNotice.rspNotice(i18n("common_text_3400"))
				end
			elseif self.msgTipsKey then
				self:showMsgTips()
			end
			_ENV = self
			self.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
			SoraDSendMessage(self)
		elseif self.tipButtonType == worldMapDefine.worldMapTipButtonType_lingdiqianCheng then
			self:reqCheckCanMoveCity()
		else
			self:sendMessageTipButtonTouchCall()
		end
	end
end
function worldMapTipButton:sendMessageTipButtonTouchCall()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_TIPBUTTON_TOUCHCALL"
	;(nil).tipButtonType = self.tipButtonType
	;(nil).tipButtonData = self.tipButtonData
	;(nil).tipButtonExtra = self.tipButtonExtra
	;(nil).mapInstance = self.mapInstance
	;(nil).targetPoint = self.tilePoint
	;(nil).kingdomID = self.kingdomID
	SoraDSendMessage(nil)
end
function worldMapTipButton:reqCheckCanMoveCity()
	self:addMessage()
	kingdomMapCtrl:reqCanMoveCityInTerr(self.tilePoint.x, self.tilePoint.y)
	local loading = SoraDShowLoading(self, cc.size(150, 150))
	loading:setPosition(cc.p(0, 0))
end
function worldMapTipButton:addMessage()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_CAN_MOVE_CITY", handler(self, self.serverMessage_RequestCanMoveCity))
end
function worldMapTipButton:serverMessage_RequestCanMoveCity(target, data)
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		if data.canMove then
			self:sendMessageTipButtonTouchCall()
		else
			_ENV = self
			self.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
			SoraDSendMessage(self)
		end
	end
end
return worldMapTipButton
