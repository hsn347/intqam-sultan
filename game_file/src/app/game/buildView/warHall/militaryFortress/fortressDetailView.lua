local militaryFortressRead = include("militaryFortressRead")
local fortressDetailView = class("fortressDetailView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("fortressDetailView")
end)
function fortressDetailView:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.topUINode = SoraDGetChildByName(self, "Top_UI_Node")
	self.imgIcon = SoraDGetChildByName(self.topUINode, "Image_Icon_Fortress")
	self.imgIcon:ignoreContentAdaptWithSize(true)
	self.btnLeft = SoraDGetChildByName(self, "Button_Left")
	self.btnLeft:addTouchEventListener(handler(self, self.btnClickLeft))
	self.btnRight = SoraDGetChildByName(self, "Button_Right")
	self.btnRight:addTouchEventListener(handler(self, self.btnClickRight))
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("campDetailSingle")
	self:initEffect()
end
function fortressDetailView:initEffect()
	local judge2move = function(_sprite, _forward)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveBy(0.9333333333333333, _forward * 15, 0)
		;(nil)[2] = cca.moveBy(0.9333333333333333, -_forward * 15, 0)
		;(nil)[3] = cca.moveBy(0.9333333333333333, -_forward * 15, 0)
		;(nil)[4] = cca.moveBy(0.9333333333333333, -_forward * 15, 0)
		;(nil)[5] = cca.moveBy(0.9333333333333333, -_forward * 15, 0)
		local seqList = cca.seq(nil)
		local acList = cc.RepeatForever:create(seqList)
		_sprite:runAction(acList)
	end
	judge2move(self.btnRight:getChildByName("Sprite_arrow"), -1)
	judge2move(self.btnLeft:getChildByName("Sprite_arrow"), 1)
	local loop = true
	local cssFilePath = getCCSPath(self._name)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, loop)
	self:runAction(self.action)
end
function fortressDetailView:initData(fortessType)
	self.fortessType = fortessType
	self.nodeCommonFramTitle:setTitle(i18n(militaryFortressRead.getFortessTitle(fortessType)))
	self.imgIcon:loadTexture(militaryFortressRead.getFortessIcon(fortessType), ccui.TextureResType.plistType)
	_ENV, _UPVALUE2_ = 330, 640
	_ENV, (330).campType = gMilitaryCampType.ORDER_CAMP, gMilitaryCampType.ORDER_CAMP
	gMilitaryCampType.ORDER_CAMP.campType = gMilitaryCampType.CHARGE_CAMP
	;(640)[1] = 330
	;(640)[2] = gMilitaryCampType.ORDER_CAMP
	_ENV = gMilitaryCampType.ORDER_CAMP
	gMilitaryCampType.ORDER_CAMP.fortessType = fortessType
	self.scroll:updateScrollView(cc.size(640, 330), 640, 1, gMilitaryCampType.ORDER_CAMP)
end
function fortressDetailView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("fortress_text_18"))
	end
end
function fortressDetailView:btnClickLeft(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.fortessType = self.fortessType - 1
		if self.fortessType == 0 then
			self.fortessType = 4
		end
		self:initData(self.fortessType)
	end
end
function fortressDetailView:btnClickRight(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.fortessType = self.fortessType + 1
		if self.fortessType == 5 then
			self.fortessType = 1
		end
		self:initData(self.fortessType)
	end
end
return fortressDetailView
