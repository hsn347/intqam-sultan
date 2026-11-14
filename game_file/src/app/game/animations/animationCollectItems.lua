local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local cityBuildConstDef = include("cityBuildConstDef")
local animationCollectItems = class("animationCollectItems", function()
	local baseView = include("baseView")
	return baseView.new(display.size)
end)
function animationCollectItems:ctor()
	self.isHidePrePanel = false
	self:setSwallowTouches(false)
	self.itemListBag, _UPVALUE0_, self.itemList, _UPVALUE0_ = self.setSwallowTouches, self.setSwallowTouches, self.setSwallowTouches, self.setSwallowTouches
	self:startTimer()
end
function animationCollectItems:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_COLLECTITEMS", handler(self, self.msgShowCollectItems))
end
function animationCollectItems:initWithData(data, actType)
	if data ~= nil then
		for i = 1, #data do
			if actType == cityBuildConstDef.itemActType.default or actType == nil then
				table.insert(self.itemList, #self.itemList + 1, data[i])
			elseif actType == cityBuildConstDef.itemActType.actBag then
				table.insert(self.itemListBag, #self.itemListBag + 1, data[i])
			end
		end
	end
end
function animationCollectItems:startTimer()
	self:stopTimer()
	self.timerKey = scheduler.scheduleGlobal(handler(self, self.updateTime), 0.15)
end
function animationCollectItems:stopTimer()
	if self.timerKey then
		scheduler.unscheduleGlobal(self.timerKey)
		self.timerKey = nil
	end
end
function animationCollectItems:updateTime()
	if #self.itemListBag > 0 then
		local item = table.remove(self.itemListBag, 1)
		local itemNode = self:getNewItem(item)
		self:addChild(itemNode)
		self:showAnimationItem(itemNode, cityBuildConstDef.itemActType.actBag)
	end
	if 0 < #self.itemList then
		local item = table.remove(self.itemList, 1)
		local itemNode = self:getNewItem(item)
		self:addChild(itemNode)
		self:showAnimationItem(itemNode, cityBuildConstDef.itemActType.default)
	end
end
function animationCollectItems:onExitOther()
	self:stopTimer()
end
function animationCollectItems:getNewItem(data)
	local fontColor = cc.c3b(0, 255, 0)
	local itemNode = display.newNode()
	local item = data
	local itemDes = ""
	local imgIconName, imgNode
	if false == SoraDJudgeResOrItem(item.id) then
		imgIconName = publicRead.getIcon(item.id)
		_ENV = nil
		;(nil).num = "+"
		;(nil).char = string.formatnumberthousands(item.num)
		itemDes = i18n("common_text_1470", nil)
		local imgIcon = ccui.ImageView:create()
		imgIcon:loadTexture(imgIconName, ccui.TextureResType.plistType)
		imgIcon:ignoreContentAdaptWithSize(false)
		imgIcon:setContentSize(cc.size(64.5, 67.5))
		itemNode:addChild(imgIcon)
		imgIcon:setAnchorPoint(cc.p(0.5, 0.5))
		imgIcon:setPosition(cc.p(0, 0))
		imgNode = imgIcon
	else
		imgIconName = itemDesRead.getIcon(item.id, false)
		_ENV = false
		;(false).num = "+"
		;(false).char = string.formatnumberthousands(item.num)
		itemDes = i18n("common_text_1470", false)
		local mailItemBox = include("mailItemBox")
		local boxNode = mailItemBox.new()
		_ENV = item.num
		item.num.id = item.id
		boxNode:initWithData(item.num)
		boxNode:setContentSize(cc.size(boxNode:getItemWidth(), boxNode:getItemHeight()))
		boxNode:setAnchorPoint(cc.p(0.5, 0.5))
		boxNode:setScale(70 / boxNode:getItemWidth())
		boxNode:setPosition(cc.p(0, 0))
		itemNode:addChild(boxNode)
		imgNode = boxNode
	end
	local labelDes = ccui.Text:create()
	labelDes:setFontSize(16)
	labelDes:setColor(fontColor)
	labelDes:setString(itemDes)
	itemNode:addChild(labelDes)
	labelDes:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelDes:setAnchorPoint(cc.p(0.5, 0))
	labelDes:setPosition(cc.p(0, -30))
	itemNode.imgNode = imgNode
	itemNode.labelDes = labelDes
	function itemNode:runAnimFadeIn(dt)
		if false == SoraDJudgeResOrItem(item.id) then
			self.imgNode:runAction(cca.fadeIn(dt))
		else
			self.imgNode:runAnimFadeIn(dt)
		end
		self.labelDes:runAction(cca.fadeIn(dt))
	end
	function itemNode:runAnimFadeOut(dt)
		if false == SoraDJudgeResOrItem(item.id) then
			self.imgNode:runAction(cca.fadeOut(dt))
		else
			self.imgNode:runAnimFadeOut(dt)
		end
		self.labelDes:runAction(cca.fadeOut(dt))
	end
	function itemNode:setNodeOpacity(o)
		if false == SoraDJudgeResOrItem(item.id) then
			self.imgNode:setOpacity(o)
		else
			self.imgNode:setNodeOpacity(o)
		end
		self.labelDes:setOpacity(o)
	end
	return itemNode
end
function animationCollectItems:showAnimationItem(itemNode, actType)
	local parentSize = self:getContentSize()
	itemNode:setPosition(cc.p(parentSize.width / 2, parentSize.height / 2))
	local aSpeed = 300
	local bSpeed = 650
	local aScale = 0.7
	local bScale = 1.0
	local cScale = 0.6
	local aPos = cc.p(parentSize.width / 2, parentSize.height / 2 - 30)
	local bPos = cc.p(parentSize.width / 2, parentSize.height / 2 + 30)
	local cPos = cc.p(parentSize.width / 2, parentSize.height / 2 - 260)
	if actType == cityBuildConstDef.itemActType.actBag then
		local mainUI = SoraDCurrentMainUI()
		local btnItems = mainUI:getBtnTarget("items")
		if btnItems then
			cPos = btnItems:getParent():convertToWorldSpace(cc.p(btnItems:getPosition()))
			cPos = self:convertToNodeSpace(cPos)
		end
	end
	itemNode:setPosition(aPos)
	itemNode:setScale(aScale)
	itemNode:setLocalZOrder(2)
	local aLen = cc.pGetDistance(bPos, aPos)
	local aDt = aLen / aSpeed
	local aMove = cca.moveTo(aDt, bPos)
	local aBackOut = cc.EaseBounceOut:create(aMove)
	local aScaleTo = cca.scaleTo(aDt, bScale)
	local aFadeIn = cca.fadeIn(aDt)
	local callFuncA = cca.callFunc(function()
		itemNode:setNodeOpacity(0)
		itemNode:runAnimFadeIn(aDt)
	end)
	_UPVALUE3_ = cc.p(btnItems:getPosition())
	cc.p(btnItems:getPosition())[1] = aBackOut
	cc.p(btnItems:getPosition())[2] = aScaleTo
	cc.p(btnItems:getPosition())[3] = callFuncA
	local aSpawn = cca.spawn(cc.p(btnItems:getPosition()))
	local delay = cca.delay(0.15)
	local bLen = cc.pGetDistance(bPos, cPos)
	local bDt = bLen / bSpeed
	local bMove = cca.moveTo(bDt, cPos)
	local bEase = cc.EaseSineIn:create(bMove)
	local bScaleTo = cca.scaleTo(bDt, cScale)
	local callFuncB = cca.callFunc(function()
		itemNode:setLocalZOrder(1)
		itemNode:runAnimFadeOut(bDt * 1.5)
	end)
	_UPVALUE3_ = cc.p(btnItems:getPosition())
	cc.p(btnItems:getPosition())[1] = callFuncB
	cc.p(btnItems:getPosition())[2] = bEase
	cc.p(btnItems:getPosition())[3] = bScaleTo
	local bSpawn = cca.spawn(cc.p(btnItems:getPosition()))
	local callFuncEnd = cca.callFunc(function()
		itemNode:removeFromParent()
	end)
	_UPVALUE4_ = bEase
	bEase[1] = aSpawn
	bEase[2] = delay
	bEase[3] = bSpawn
	bEase[4] = callFuncEnd
	local seq = cca.seq(bEase)
	itemNode:runAction(seq)
end
function animationCollectItems:msgShowCollectItems(target, data)
	local items = data.items
	local actType = data.actTpye
	self:initWithData(items, actType)
end
return animationCollectItems
