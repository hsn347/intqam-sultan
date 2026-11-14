gIsAnimationGainItemShowingCount = 0
local AnimationGainItem = class("animationGainItem", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("animationGainItem")
	end
	return target
end)
function AnimationGainItem:ctor()
	self.isHidePrePanel = false
	self:setSwallowTouches(false)
	self.nodeAni = SoraDGetChildByName(self, "Node_animation")
	self.nodeEffct = SoraDGetChildByName(self, "Node_Effect")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.txtCount = SoraDGetChildByName(self, "Text_count")
	self.itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.itemFrm = SoraDGetChildByName(self, "Image_itemFrm")
	self.particleNode = SoraDGetChildByName(self, "Node_particle")
	self.particleNode:setVisible(false)
	self.imgItem:ignoreContentAdaptWithSize(false)
	self.nodeAni:setPosition(320, display.height / 2 + 160)
	self.nodeAni:setScale(0.1)
	self.nodeAni:setOpacity(0)
	self.nodeEffct:setPosition(320, display.height / 2 + 160)
	self.isShowBackGround = false
end
function AnimationGainItem:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ANIMATION_GAIN_ITEM_CLOSE", handler(self, self.updateBackGround))
end
function AnimationGainItem:updateBackGround()
	if gIsAnimationGainItemShowingCount ~= 0 then
		self:setBackGround(0)
		self.isShowBackGround = false
	else
		if not self.isHideBg then
			self:setBackGround(127.5)
		end
		self.isShowBackGround = true
		gIsAnimationGainItemShowingCount = 1
	end
end
function AnimationGainItem:onEnterPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_ANIMATION_GAIN_ITEM_SHOW"
	SoraDSendMessage(nil)
	self:updateBackGround()
end
function AnimationGainItem:onExitPanel()
	if self.isShowBackGround then
		gIsAnimationGainItemShowingCount = 0
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_ANIMATION_GAIN_ITEM_CLOSE"
	SoraDSendMessage(nil)
end
function AnimationGainItem:initData(itemData, isHideBg, isShowFrameBg)
	self.enableTouchCloseSelf = true
	self:setCloseCallBack(handler(self, self.stopAction))
	local publicRead = include("publicRead")
	local itemIcon, itemBg
	self.txtCount:setString("x" .. itemData.itemCount)
	itemIcon = publicRead.getIcon(itemData.itemID)
	itemBg = publicRead.getBg(itemData.itemID)
	self.imgItem:loadTexture(itemIcon, ccui.TextureResType.plistType)
	self.imgItem:ignoreContentAdaptWithSize(true)
	self.imgItem:setScale(85 / self.imgItem:getContentSize().width)
	if itemBg then
		self.itemBg:loadTexture(itemBg, ccui.TextureResType.plistType)
	end
	self.isHideBg = isHideBg
	if isHideBg then
		self:setBackGround(0)
		if not isShowFrameBg then
			self.itemBg:setVisible(false)
			self.itemFrm:setVisible(false)
		end
	end
	SoraDPlaySound("normalcontrol", 4)
	self:palyAnimation()
end
function AnimationGainItem:initDataByIcon(data, pos)
	self.txtCount:setString("x" .. data.itemCount)
	self.imgItem:loadTexture(data.icon, ccui.TextureResType.plistType)
	self.imgItem:ignoreContentAdaptWithSize(true)
	self.imgItem:setScale(85 / self.imgItem:getContentSize().width)
	if data.bg then
		self.itemBg:loadTexture(data.bg, ccui.TextureResType.plistType)
	end
	SoraDPlaySound("normalcontrol", 4)
	self:palyAnimation(pos)
end
function AnimationGainItem:show()
	local parent = display.getRunningScene()
	self:setName("AnimationGainItem")
	parent:addChild(self, 201)
end
function AnimationGainItem:palyAnimation(pos)
	local effect = SoraDCreatAnimation("animationGainItemEffect", nil, false)
	self:setMixtureGLONE(effect)
	effect:setPosition(0, 0)
	self.nodeEffct:addChild(effect)
	if pos then
		self.nodeEffct:setPosition(pos)
		self.nodeAni:setPosition(pos)
	end
	local action1 = cca.scaleTo(0.2, 1)
	local action2 = cca.fadeIn(0.2)
	_UPVALUE2_ = 0
	;(0)[1] = action1
	;(0)[2] = action2
	local swa1 = cca.spawn(0)
	local func1 = cca.callFunc(function()
		self = nil
		;(nil).x = 320
		;(nil).y = 0
		self:scaleIn(self.nodeAni, nil)
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = swa1
	;(nil)[2] = func1
	self.nodeAni:runAction(cca.seq(nil))
end
function AnimationGainItem:stopAction()
	if not self.playAgain then
		_ENV = self.playAgain
		self.playAgain.x = 320
		local self.playAgain.y, pos = 0, self.playAgain
		self.playAgain = true
		self.nodeAni:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveTo(0.4, pos)
		;(nil)[2] = cca.scaleTo(0.4, 0.1)
		;(nil)[3] = cca.scaleTo(0.4, 0.1)
		;(nil)[4] = cca.scaleTo(0.4, 0.1)
		_ENV = nil
		;(nil).delay = 0.0
		;(nil).easing = "BACKIN"
		;(nil).onComplete = function()
			self:removeFromParent()
		end
		transition.execute(self.nodeAni, cca.spawn(nil), nil)
	end
end
function AnimationGainItem:scaleIn(obj, pos)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveTo(0.5, pos)
	;(nil)[2] = cca.scaleTo(0.5, 0.1)
	;(nil)[3] = cca.scaleTo(0.5, 0.1)
	;(nil)[4] = cca.scaleTo(0.5, 0.1)
	_ENV = nil
	;(nil).delay = 1.1
	;(nil).easing = "BACKIN"
	;(nil).onComplete = function()
		self:removeFromParent()
	end
	transition.execute(obj, cca.spawn(nil), nil)
end
function AnimationGainItem:setMixtureGLONE(parent)
	local children = parent:getChildren()
	for _, v in pairs(children) do
		SoraDMixtureGLONE(v)
	end
end
return AnimationGainItem
