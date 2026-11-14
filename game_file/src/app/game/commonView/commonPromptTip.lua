local commonPromptTip = class("commonPromptTip", function()
	local node = display.newNode()
	node:setPosition(display.cx, display.cy)
	return node
end)
_ENV = "commonPromptTip"
commonPromptTip.sOrder_enum, ("commonPromptTip").mapBuff = "commonPromptTip", 1
function commonPromptTip:ctor()
	self.viewName = "commonPromptTip"
	self.maxH = 80
	self.Image_bg = display.newSprite("#img_conmon_tipst.png")
	self.Image_bg:setPosition(0, 0)
	self.Image_bg:setOpacity(178.5)
	self.Image_bg:addTo(self, 0)
	self.Text_message = ccui.Text:create()
	self.Text_message:setAnchorPoint(SoraDFAP(1, 0.5))
	self.Text_message:setPosition(SoraDFPosX(185, 0), 0)
	self.Text_message:setColor(cc.c3b(255, 251, 213))
	self.Text_message:setFontSize(20)
	self.Text_message:ignoreContentAdaptWithSize(false)
	self.Text_message:setTextAreaSize(cc.size(450, 50))
	self.Text_message:setContentSize(cc.size(450, 50))
	self.Text_message:setTextHorizontalAlignment(SoraDFLabelR())
	self.Text_message:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.Text_message:addTo(self, 1)
	self.Image_IconBg = display.newSprite("#img_conmon_tipst01.png")
	self.Image_IconBg:setPosition(SoraDFPosX(240, 0), 0)
	self.Image_IconBg:addTo(self, 2)
	self.Image_IconBg:setVisible(false)
end
function commonPromptTip:showTip(message, iconSprite, target, other)
	self:setScaleY(0.1)
	local showY = display.cy + 40
	if iconSprite ~= nil then
		self.Text_message:setAnchorPoint(SoraDFAP(1, 0.5))
		self.Text_message:setPosition(SoraDFPosX(185, 0), 0)
		self.Text_message:setTextHorizontalAlignment(SoraDFLabelR())
		local offset = cc.p(0, 0)
		if other and other.offset then
			offset = other.offset
		end
		self.Image_IconBg:setVisible(true)
		local iconBgSize = self.Image_IconBg:getContentSize()
		iconSprite:setAnchorPoint(cc.p(0.5, 0.5))
		iconSprite:setPosition(cc.p(iconBgSize.width / 2 + offset.x, iconBgSize.height / 2 + offset.y))
		self.Image_IconBg:addChild(iconSprite, 1)
	else
		self.Text_message:setAnchorPoint(cc.p(0.5, 0.5))
		self.Text_message:setPosition(cc.p(0, 0))
		self.Text_message:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
	if target ~= nil and not tolua.isnull(target) and target.getTouchEndPosition ~= nil then
		local touchEndPoint = target:getTouchEndPosition()
		showY = touchEndPoint.y + 120
		if showY > display.height - 150 then
			showY = touchEndPoint.y - 120
		end
	end
	self.Text_message:setString(message)
	self.maxH = iconSprite and 80 or 120
	local height = SoraDGetAutoHeightLabel(self.Text_message, 450)
	self.Text_message:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	if height + 20 > 50 and height <= self.maxH then
		local deltaH = height + 20 - 50
		self:addHeight(deltaH)
	elseif height > self.maxH then
		height = self.maxH
		SoraDSetTextWidthHeight(self.Text_message, cc.size(450, height))
		self.Text_message:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		local deltaH = height - 50
		self:addHeight(deltaH)
	end
	local _ENV, actionsArray = deltaH, height - 50
	actionsArray[#actionsArray + 1] = cc.ScaleTo:create(0.3, 1.0, 1.0, 1.0)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(2.8)
	actionsArray[#actionsArray + 1] = cc.ScaleTo:create(0.2, 1.0, 0.1, 1.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:removeFromParent(true)
	end)
	local actions = transition.sequence(actionsArray)
	self:runAction(actions)
	self:setPositionY(showY)
	self:show(other)
end
function commonPromptTip:addHeight(deltaH)
	self.Image_bg:setContentSize(self.Image_bg:getContentSize().width, self.Image_bg:getContentSize().height + deltaH + 4)
	self.deltaH = deltaH
end
function commonPromptTip:getViewHeight()
	return (self.deltaH or 0) + 60
end
function commonPromptTip:show(other)
	self.sOrder = other and other.sOrder or 0
	local parent = display.getRunningScene()
	local prePromptTip = parent:getChildByName(self.viewName)
	local preOrder = prePromptTip and prePromptTip.sOrder or 0
	if preOrder > self.sOrder then
		return
	end
	if prePromptTip then
		if other and other.mulit and preOrder == self.sOrder then
			local height = prePromptTip:getViewHeight()
			local posy = prePromptTip:getPositionY() + height + 5
			if posy > display.cy + 230 then
				return
			end
			self:setPositionY(posy)
			prePromptTip:setName(self.viewName .. "prefix")
		else
			prePromptTip:removeFromParent(true)
		end
	end
	self:setName(self.viewName)
	parent:addChild(self, 200)
end
return commonPromptTip
