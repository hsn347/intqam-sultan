local chatConst = include("chatConst")
local chatDesRead = include("chatDesRead")
_ENV = "chatDesRead"
;("chatDesRead").left = 1
;("chatDesRead").center = 2
;("chatDesRead").right = 3
local _ENV, ("chatDesRead").single, MenuBtnType = nil, 4, "chatDesRead"
;(nil).top = 1
local _ENV, (nil).bottom, MenuArrowType = nil, 2, nil
;(nil).width = 100
;(nil).height = 40
;(nil).fontSize = 20
;(nil).arrowPadding = 1
;(nil).sepSize = cc.size(2, 40)
;(nil).arrowSize = cc.size(23, 12)
;(nil).maxScrollWidth = 400
;(nil).maxWidth = 460
;(nil).deltaJudgeW = 40
;(nil).titleDeltaW = 30
_ENV, (nil).arrowOffset = cc.p(-2, 0), cc.p(-2, 0)
_ENV = 0
;(0).size = cc.size(30, 40)
;(0).normal = "frame_LT_kuozhangkuang1.png"
;(0).press = "frame_LT_kuozhangkuang4.png"
cc.p(-2, 0)[MenuBtnType.left], (0).needFlip = 0, false
_ENV = 0
;(0).size = cc.size(30, 40)
;(0).normal = "frame_LT_kuozhangkuang1.png"
;(0).press = "frame_LT_kuozhangkuang4.png"
cc.p(-2, 0)[MenuBtnType.right], (0).needFlip = 0, true
_ENV = 0
;(0).size = cc.size(80, 40)
;(0).normal = "frame_LT_kuozhangkuang2.png"
cc.p(-2, 0)[MenuBtnType.center], (0).press = 0, "frame_LT_kuozhangkuang3.png"
_ENV = 0
;(0).size = cc.size(80, 40)
;(0).normal = "frame_LT_kuozhangkuang6.png"
;(nil).btnCfg, cc.p(-2, 0)[MenuBtnType.single], (0).press = cc.p(-2, 0), 0, "frame_LT_kuozhangkuang5.png"
local _defaultParam
local chatMenu = class("chatMenu", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("chatMenu")
	end
end)
function chatMenu:ctor()
	self.width = _defaultParam.width
	self.height = _defaultParam.height
	self:addTouchEventListener(handler(self, self.layerClickCallBack))
	self:setBackGround(0)
	self:setSwallowTouches(false)
	local layout = ccui.Layout:create()
	layout:setTouchEnabled(true)
	layout:setSwallowTouches(true)
	layout:addTo(self, 2)
	layout:setContentSize(100, _defaultParam.height)
	self.layout = layout
	local leftBtn = self:createBtn(MenuBtnType.left, true)
	local rightBtn = self:createBtn(MenuBtnType.right, true)
	leftBtn:addTo(layout)
	rightBtn:addTo(layout)
	self.leftBtn = leftBtn
	self.rightBtn = rightBtn
	self:createScroll()
	local centerBtn = self:createBtn(MenuBtnType.center, true)
	centerBtn:addTo(self.scrollView)
	centerBtn.sep:setVisible(false)
	centerBtn:setPosition(cc.p(centerBtn:getContentSize().width / 2, centerBtn:getContentSize().height / 2))
	self.centerBtn = centerBtn
	_UPVALUE3_ = centerBtn
	centerBtn[1] = leftBtn
	centerBtn[2] = self.scrollView
	centerBtn[3] = rightBtn
	local accuWidth = SoraDAlignNodeArray(centerBtn)
	self.layout:setContentSize(cc.size(accuWidth, _defaultParam.height))
	local arrowTop = display.newSprite("#frame_LT_kuozhangkuang_jiantouo.png")
	arrowTop:addTo(self, 2)
	arrowTop:setPositionX(50)
	arrowTop:setPositionY(_defaultParam.height + _defaultParam.arrowSize.height / 2 - _defaultParam.arrowPadding)
	self.arrowTop = arrowTop
	self.arrowTop:setVisible(true)
	local arrowDown = display.newSprite("#frame_LT_kuozhangkuang_jiantouo.png")
	arrowDown:addTo(self, 2)
	arrowDown:setFlippedY(true)
	arrowDown:setPositionX(50)
	arrowDown:setPositionY(-_defaultParam.arrowSize.height / 2 + _defaultParam.arrowPadding)
	self.arrowDown = arrowDown
	self.arrowDown:setVisible(false)
	self.layout:setPosition(cc.p(100, 460))
	self.leftBtnCfg = _defaultParam.btnCfg[MenuBtnType.left]
	self.rightBtnCfg = _defaultParam.btnCfg[MenuBtnType.right]
	self.centerBtnCfg = _defaultParam.btnCfg[MenuBtnType.center]
	self.singleBtnCfg = _defaultParam.btnCfg[MenuBtnType.single]
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
end
function chatMenu:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_CLOSE_MENU", handler(self, self.msgCloseMenu))
end
function chatMenu:createScroll()
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setContentSize(cc.size(80, _defaultParam.height))
	self.scrollView:setAnchorPoint(0, 0)
	self.scrollView:setDirection(2)
	self.scrollView:setPosition(cc.p(30, 0))
	self.scrollView:addTo(self.layout, 1)
end
function chatMenu:init(data)
	self.isRA = SoraDFIsRA()
	if data.isRA ~= nil then
		self.isRA = data.isRA
	end
	self.data = data
	self.handle = data.handle
	self.worldPos = data.worldPos
	self.alignv = data.alignv or gMenuAlignVType.top
	self.menus = data.menus
	self.customData = data.customData
	self:initContent()
	self:alignContent()
	self:alignPos()
	self:updateArrow()
end
function chatMenu:initContent()
	self.menuBtns, _ENV = nil, nil
	local btn
	dump(self.menus, "self.menus = ")
	for i, v in ipairs(self.menus) do
		local des = chatDesRead.getMenuName(v, self.customData)
		if i == 1 then
			btn = self.centerBtn
		else
			btn = self:getMenuBtn()
		end
		btn:setTitleText(i18n(des))
		local titleRenderer = btn:getTitleRenderer()
		titleRenderer:setSystemFontSize(20)
		if G_IS_UNITY then
			titleRenderer:setAutoSize(fgui.AutoSizeType.Both)
			titleRenderer:setAnchorPoint(cc.p(0.5, 0.5))
			local btnWidth = titleRenderer:getContentSize().width + _defaultParam.titleDeltaW
			btn:setContentSize(cc.size(btnWidth, self.height))
			titleRenderer:setPosition(cc.p(btn:getContentSize().width / 2, self.height / 2))
		else
			titleRenderer:setWidth(0)
			local btnWidth = titleRenderer:getContentSize().width + _defaultParam.titleDeltaW
			btn:setContentSize(cc.size(btnWidth, self.height))
		end
		btn.menuid = v
		table.insert(self.menuBtns, btn)
		local sep = btn:getChildByName("sep")
		local btnSize = btn:getContentSize()
		local sepSize = _defaultParam.sepSize
		sep:setPositionX(btnSize.width - sepSize.width / 2)
		sep:setVisible(true)
		btn.sep = sep
	end
end
function chatMenu:alignContent()
	local accuWidth = 0
	for i, v in ipairs(self.menuBtns) do
		local btnWidth = v:getContentSize().width
		accuWidth = accuWidth + btnWidth
	end
	print("accuWidth = ", accuWidth)
	local firstBtn = self.menuBtns[1]
	if not firstBtn then
		return
	end
	local lastBtn = self.menuBtns[#self.menuBtns]
	local btnWidth = firstBtn:getContentSize().width
	if self.isRA then
		firstBtn:setPositionX(accuWidth - btnWidth / 2)
	else
		firstBtn:setPositionX(btnWidth / 2)
	end
	SoraDAlignNodeArray(self.menuBtns, self.isRA)
	local leftBtn = firstBtn
	local rightBtn = lastBtn
	if self.isRA then
		leftBtn = lastBtn
		rightBtn = firstBtn
	end
	rightBtn.sep:setVisible(false)
	if accuWidth < _defaultParam.maxScrollWidth then
		if firstBtn == lastBtn then
			firstBtn:loadTextures(self.singleBtnCfg.normal, self.singleBtnCfg.press, self.singleBtnCfg.press, ccui.TextureResType.plistType)
		else
			leftBtn:loadTextures(self.leftBtnCfg.normal, self.leftBtnCfg.press, self.leftBtnCfg.press, ccui.TextureResType.plistType)
			rightBtn:loadTextures(self.rightBtnCfg.normal, self.rightBtnCfg.press, self.rightBtnCfg.press, ccui.TextureResType.plistType)
			rightBtn:getTitleRenderer():setScaleX(-1)
			rightBtn:setFlippedX(true)
		end
		self.leftBtn:setVisible(false)
		self.rightBtn:setVisible(false)
	else
		self.rightBtn:setVisible(true)
		if self.isRA then
			self.leftBtn:setVisible(true)
			self.rightBtn:setVisible(false)
			rightBtn:loadTextures(self.rightBtnCfg.normal, self.rightBtnCfg.press, self.rightBtnCfg.press, ccui.TextureResType.plistType)
			rightBtn:getTitleRenderer():setScaleX(-1)
			rightBtn:setFlippedX(true)
		else
			self.leftBtn:setVisible(false)
			self.rightBtn:setVisible(true)
			leftBtn:loadTextures(self.leftBtnCfg.normal, self.leftBtnCfg.press, self.leftBtnCfg.press, ccui.TextureResType.plistType)
		end
		self.isArrowOn = true
	end
	local scrollWidth = math.min(accuWidth, _defaultParam.maxScrollWidth)
	self.scrollView:setContentSize(cc.size(scrollWidth, _defaultParam.height))
	self.scrollView:setInnerContainerSize(cc.size(accuWidth, _defaultParam.height))
	_UPVALUE3_ = self.scrollView
	self.scrollView[1] = self.leftBtn
	self.scrollView[2] = self.scrollView
	self.scrollView[3] = self.rightBtn
	local accuWidth = SoraDAlignNodeArray(self.scrollView, false)
	self.layout:setContentSize(cc.size(accuWidth, _defaultParam.height))
	if self.isRA then
		self.scrollView:scrollToRight(0.0, false)
	end
end
function chatMenu:alignPos()
	if not self.worldPos then
		return
	end
	local worldPos = self.worldPos
	local alignv = self.alignv
	local nodePos = self:convertToNodeSpace(worldPos)
	local arrowPosX = nodePos.x
	local arrowPosY = nodePos.y
	self.layout:setAnchorPoint(cc.p(0.5, 0))
	if alignv == gMenuAlignVType.top then
		self.arrowTop:setVisible(false)
		self.arrowDown:setVisible(true)
		self.arrowDown:setPositionY(arrowPosY + _defaultParam.arrowSize.height / 2)
		self.arrowDown:setPositionX(arrowPosX)
		self.layout:setPositionY(nodePos.y + _defaultParam.arrowSize.height - _defaultParam.arrowPadding)
	else
		self.arrowTop:setVisible(true)
		self.arrowDown:setVisible(false)
		self.arrowTop:setPositionY(arrowPosY - _defaultParam.arrowSize.height / 2)
		self.arrowTop:setPositionX(arrowPosX)
		self.layout:setPositionY(nodePos.y - _defaultParam.arrowSize.height + _defaultParam.arrowPadding - _defaultParam.height)
	end
	local layoutPosX = nodePos.x
	local layoutSize = self.layout:getContentSize()
	local centerX = layoutSize.width / 2
	local judgeWidth = layoutSize.width / 2 + _defaultParam.deltaJudgeW
	local isLeft = false
	local isRight = false
	if nodePos.x - judgeWidth < 0 then
		local offsetX = math.abs(nodePos.x - judgeWidth)
		layoutPosX = layoutPosX + offsetX
		isLeft = true
	else
		if nodePos.x > 640 - judgeWidth then
			local offsetX = -math.abs(nodePos.x + judgeWidth - 640)
			layoutPosX = layoutPosX + offsetX
			isRight = true
		else
		end
	end
	self.layout:setPositionX(layoutPosX)
	for i, v in ipairs(self.menuBtns) do
		local btnPos = SoraDCoverToPoint(self.scrollView:getInnerContainer(), cc.p(v:getPosition()), self)
		local btnR = cc.p(v:getPositionX() + v:getContentSize().width / 2, v:getPositionY())
		local btnPosR = SoraDCoverToPoint(self.scrollView:getInnerContainer(), btnR, self)
		if math.abs(btnPosR.x - nodePos.x) < _defaultParam.arrowSize.width then
			if btnPosR.x <= nodePos.x then
				do
					local deltaX = -(_defaultParam.arrowSize.width / 2 - (nodePos.x - btnPosR.x)) - _defaultParam.arrowSize.width
					layoutPosX = layoutPosX + deltaX
				end
				break
			end
			do
				local deltaX = nodePos.x - btnPosR.x + _defaultParam.arrowSize.width
				layoutPosX = layoutPosX + deltaX
			end
			break
		end
	end
	self.layout:setPositionX(layoutPosX)
end
function chatMenu:getMenuBtn()
	local newBtn = self.centerBtn:clone()
	newBtn:addTo(self.scrollView)
	return newBtn
end
function chatMenu:layerClickCallBack(layer, type)
	if type == ccui.TouchEventType.began then
	elseif type == ccui.TouchEventType.ended then
		self:closePanel()
	end
end
function chatMenu:createBtn(menuBtnType, needSep, btnSize)
	local btn = ccui.Button:create()
	btn:setTouchEnabled(true)
	local btnCfg = _defaultParam.btnCfg
	local normal = btnCfg[menuBtnType].normal
	local press = btnCfg[menuBtnType].press
	local needFlip = btnCfg[menuBtnType].needFlip
	local btnSize = btnSize or btnCfg[menuBtnType].size
	btn:loadTextures(normal, press, press, ccui.TextureResType.plistType)
	if needFlip then
		btn:setFlippedX(true)
	end
	btn:setScale9Enabled(true)
	btn:setContentSize(btnSize)
	btn:setSwallowTouches(false)
	if needSep then
		local sep = display.newSprite("#frame_LT_fenggexian.png")
		sep:setScaleY(0.95)
		sep:addTo(btn)
		local sepSize = sep:getContentSize()
		if menuBtnType == MenuBtnType.left then
			sep:setPositionX(btnSize.width - sepSize.width / 2)
		elseif menuBtnType == MenuBtnType.right then
			sep:setPositionX(btnSize.width - sepSize.width / 2)
		elseif menuBtnType == MenuBtnType.center then
			sep:setPositionX(btnSize.width - sepSize.width / 2)
		end
		sep:setPositionY(btnSize.height / 2)
		btn.sep = sep
		sep:setName("sep")
	end
	btn:addTouchEventListener(handler(self, self.buttonEvent))
	if menuBtnType == MenuBtnType.left or menuBtnType == MenuBtnType.right then
		local arrow = display.newSprite("#Icon_LT_baisejiantou.png")
		arrow:addTo(btn)
		arrow:setPosition(cc.p(btnSize.width / 2 + _defaultParam.arrowOffset.x, btnSize.height / 2 + _defaultParam.arrowOffset.y))
		btn:addTouchEventListener(handler(self, self.buttonPageEvent))
		btn.arrow = arrow
	end
	if menuBtnType == MenuBtnType.left then
		btn:setPositionX(btnSize.width / 2)
	end
	btn:setPositionY(btnSize.height / 2)
	btn.menuBtnType = menuBtnType
	return btn
end
function chatMenu:resetArrow(target)
	target:setSpriteFrame("frame_LT_kuozhangkuang_jiantouo.png")
end
function chatMenu:downArrow(target)
	target:setSpriteFrame("frame_LT_kuozhangkuang_jiantouo2.png")
end
function chatMenu:setHandle(handle)
	self.handle = handle
end
function chatMenu:buttonPageEvent(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("点击了翻页---", target.menuBtnType)
		local scrollW = self.scrollView:getContentSize().width
		local container = self.scrollView:getInnerContainer()
		local containerWidth = container:getContentSize().width
		local containerX = container:getPositionX()
		local totalW = containerWidth
		if target.menuBtnType == MenuBtnType.left then
			local isFind = false
			local btnX = -containerX
			for i, v in ipairs(self.menuBtns) do
				local btnOffsetXL = v:getPositionX() - v:getContentSize().width / 2
				local btnOffsetXR = v:getPositionX() + v:getContentSize().width / 2
				if btnX > btnOffsetXL and btnX < btnOffsetXR then
					isFind = true
					containerX = -btnOffsetXR
					break
				end
			end
			local offsetX = -scrollW - containerX
			local percent = math.min(math.max(0, 100 * offsetX / math.abs(totalW - scrollW)), 100)
			self.scrollView:scrollToPercentHorizontal(percent, 0.2, false)
		elseif target.menuBtnType == MenuBtnType.right then
			local isFind = false
			local btnX = -containerX + scrollW
			for i, v in ipairs(self.menuBtns) do
				local btnOffsetXL = v:getPositionX() - v:getContentSize().width / 2
				local btnOffsetXR = v:getPositionX() + v:getContentSize().width / 2
				if btnX > btnOffsetXL and btnX < btnOffsetXR then
					isFind = true
					containerX = -btnOffsetXL + scrollW
					break
				end
			end
			local offsetX = scrollW - containerX
			local percent = math.min(math.max(0, 100 * offsetX / math.abs(totalW - scrollW)), 100)
			self.scrollView:scrollToPercentHorizontal(percent, 0.2, false)
		end
	end
end
function chatMenu:buttonEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("点击了菜单咯--------", target.menuid)
		if self.handle then
			self.handle(target.menuid, self.data)
		else
			local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
			if chatMenuHandlerMgr then
				chatMenuHandlerMgr:onMenuClick(self, target.menuid, self.data)
			end
		end
		if not tolua.isnull(self) and self.closePanel then
			self:closePanel()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatMenu:scrollEventCallBack(target, event)
	self:updateArrow()
end
function chatMenu:updateArrow()
	if not self.isArrowOn then
		return
	end
	local firstBtn = self.menuBtns[1]
	local lastBtn = self.menuBtns[#self.menuBtns]
	local leftBtn = firstBtn
	local rightBtn = lastBtn
	if self.isRA then
		leftBtn = lastBtn
		rightBtn = firstBtn
	end
	local scrollWidth = self.scrollView:getContentSize().width
	local container = self.scrollView:getInnerContainer()
	local containerWidth = container:getContentSize().width
	local containerX = container:getPositionX()
	local deltaX = 5
	if containerX < -deltaX then
		self.leftBtn:setVisible(true)
		leftBtn:loadTextures(self.centerBtnCfg.normal, self.centerBtnCfg.press, self.centerBtnCfg.press, ccui.TextureResType.plistType)
	elseif containerX >= deltaX then
		self.leftBtn:setVisible(false)
		leftBtn:loadTextures(self.leftBtnCfg.normal, self.leftBtnCfg.press, self.leftBtnCfg.press, ccui.TextureResType.plistType)
	end
	local judgeX = scrollWidth - containerWidth + deltaX
	if containerX > judgeX then
		self.rightBtn:setVisible(true)
		rightBtn:loadTextures(self.centerBtnCfg.normal, self.centerBtnCfg.press, self.centerBtnCfg.press, ccui.TextureResType.plistType)
		rightBtn:getTitleRenderer():setScaleX(1)
		rightBtn:setFlippedX(false)
	elseif containerX <= judgeX then
		self.rightBtn:setVisible(false)
		rightBtn:loadTextures(self.rightBtnCfg.normal, self.rightBtnCfg.press, self.rightBtnCfg.press, ccui.TextureResType.plistType)
		rightBtn:getTitleRenderer():setScaleX(-1)
		rightBtn:setFlippedX(true)
	end
end
function chatMenu:msgCloseMenu(target, data)
	if self.data.customData then
		if self.data.customData.chatChannel == data.chatChannel then
			self:closePanel()
		end
	else
		self:closePanel()
	end
end
return chatMenu
