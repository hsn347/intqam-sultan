_ENV = nil
;(nil).noBox = 1
;(nil).topBoxNoMax = 2
;(nil).topBoxWithMax = 3
;(nil).besideBoxNoMax = 4
local (nil).besideBoxWithMax, showTypeDef = 5, nil
local commonCustomSlider = class("commonCustomSlider", function()
	return display.newNode()
end)
function commonCustomSlider:ctor()
	self.showType = showTypeDef.topBoxNoMax
	self.min = 0
	self.max = 100
	self.cur = 0
	self.percent = 0
	self.perChange = 1
	self.imgBg = ccui.ImageView:create("bg_alliance_spliding.png", ccui.TextureResType.plistType)
	self.imgBg:setAnchorPoint(cc.p(0.5, 0.5))
	self.imgBg:setPosition(cc.p(0, -2))
	self.imgBg:setScale9Enabled(true)
	self.imgBg:setContentSize(cc.size(205, 15))
	self.imgBg:setCapInsets(cc.rect(5, 3, 68, 8))
	self.imgBg:addTo(self, 0)
	self.cutLayer = ccui.Layout:create()
	self.cutLayer:setAnchorPoint(cc.p(0, 0.5))
	self.cutLayer:setPosition(cc.p(-100, 0))
	self.cutLayer:setClippingEnabled(true)
	self.cutLayer:setContentSize(cc.size(0, 6))
	self.cutLayer:addTo(self, 1)
	self.imgColor = ccui.ImageView:create("progressbar_alliance_choose.png", ccui.TextureResType.plistType)
	self.imgColor:setAnchorPoint(cc.p(0, 0.5))
	self.imgColor:setPosition(cc.p(0, self.cutLayer:getContentSize().height / 2))
	self.imgColor:setScale9Enabled(true)
	self.imgColor:setContentSize(cc.size(200, 11))
	self.imgColor:setCapInsets(cc.rect(2, 2, 3, 7))
	self.imgColor:setScaleY(0.5454545454545454)
	self.imgColor:addTo(self.cutLayer)
	self.imgBtn = ccui.ImageView:create("progressbar_09.png", ccui.TextureResType.plistType)
	self.imgBtn:setAnchorPoint(cc.p(0.5, 0.5))
	self.imgBtn:setPosition(cc.p(-100, 0))
	self.imgBtn:setTouchEnabled(true)
	self.imgBtn:addTouchEventListener(handler(self, self.OnSliderBtnClick))
	self.imgBtn:addTo(self, 2)
	self.showNode = display.newNode()
	self.showNode:setPosition(cc.p(0, 50))
	self.showNode:addTo(self, 3)
	self.inputBox = ccui.EditBox:create(cc.size(110, 42), "frame_ltyh_srk.png", ccui.TextureResType.plistType)
	self.inputBox:setPosition(cc.p(25, 0))
	self.inputBox:setFontColor(display.COLOR_BLACK)
	self.inputBox:setMaxLength(10)
	self.inputBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.inputBox:setPlaceHolder("")
	self.inputBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.inputBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
	self.inputBox:addTo(self.showNode, 0)
	self.textMax = ccui.Text:create("", "", 20)
	self.textMax:setAnchorPoint(cc.p(0, 0.5))
	self.textMax:setTextColor(cc.c4b(255, 200, 100, 255))
	self.textMax:setPosition(cc.p(5, 0))
	self.textMax:addTo(self.showNode, 1)
	self.btnUp = ccui.Button:create("btn_yjyh_jiah.png", "btn_yjyh_jiah.png", "btn_yjyh_jiah.png", ccui.TextureResType.plistType)
	self.btnUp:setAnchorPoint(cc.p(0.5, 0.5))
	self.btnUp:setPosition(cc.p(160, 0))
	self.btnUp:addTouchEventListener(handler(self, self.btnUpClick))
	self.btnUp:addTo(self, 4)
	self.btnDown = ccui.Button:create("btn_yjyh_jh.png", "btn_yjyh_jh.png", "btn_yjyh_jh.png", ccui.TextureResType.plistType)
	self.btnDown:setAnchorPoint(cc.p(0.5, 0.5))
	self.btnDown:setPosition(cc.p(-160, 0))
	self.btnDown:addTouchEventListener(handler(self, self.btnDownClick))
	self.btnDown:addTo(self, 4)
	self:setShowType()
	self:initData()
end
function commonCustomSlider:setShowType(sType)
	self.showType = sType or self.showType
	if self.showType == showTypeDef.noBox then
		self.showNode:setVisible(false)
		self.inputBox:setVisible(false)
	elseif self.showType == showTypeDef.topBoxNoMax then
		self.showNode:setVisible(true)
		self.textMax:setVisible(false)
		self.showNode:setPosition(cc.p(0, 50))
	elseif self.showType == showTypeDef.topBoxWithMax then
		self.showNode:setVisible(true)
		self.textMax:setVisible(true)
		self.showNode:setPosition(cc.p(0, 50))
	elseif self.showType == showTypeDef.besideBoxNoMax then
		self.showNode:setVisible(true)
		self.textMax:setVisible(false)
		self.showNode:setPosition(cc.p(SoraDFPosX(-250, 0), 0))
	elseif self.showType == showTypeDef.besideBoxWithMax then
		self.showNode:setVisible(true)
		self.textMax:setVisible(true)
		self.showNode:setPosition(cc.p(SoraDFPosX(-250, 0), 0))
	end
end
function commonCustomSlider:initData(min, max, cur)
	self.min = min or self.min
	self.max = max or self.max
	self.cur = cur or self.cur
	if self.min == self.max then
		self.percent = 1
		self.cur = self.max
	else
		self.percent = (self.cur - self.min) / (self.max - self.min)
	end
	self:setPercent()
	self.textMax:setString(string.formatnumberthousands(self.max))
	SoraDToCenter(self.showNode, 10, SoraDFIsRA())
	if self.handle then
		self.handle(self:getValue())
	end
end
function commonCustomSlider:setMaxStr(maxStr)
	self.textMax:setString(maxStr)
end
function commonCustomSlider:setPerChange(percent)
	self.perChange = percent
end
function commonCustomSlider:setPercent()
	self.inputBox:setText(self.cur)
	self.imgBtn:setPositionX(-100 + 200 * self.percent)
	self.cutLayer:setContentSize(cc.size(200 * self.percent, 6))
end
function commonCustomSlider:getValue()
	return tonumber(self.inputBox:getText())
end
function commonCustomSlider:OnEditBoxTouch(target, event)
	if event == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function commonCustomSlider:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
		self.cur = self:getValue()
		if self.perChange == 1 then
			self.cur = math.ceil(self.cur)
		end
		self.cur = math.min(self.cur, self.max)
		self.cur = math.max(self.cur, self.min)
		self:initData(self.min, self.max, self.cur)
	end
end
function commonCustomSlider:setSliderCallBack(handle)
	self.handle = handle
end
function commonCustomSlider:OnSliderBtnClick(target, event)
	if event == ccui.TouchEventType.ended then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = touchBeganPoint.x - touchmovePoint.x
		if math.abs(tonumber(distance)) > 0 then
			self.singleIsMoved = true
		end
		if self.singleIsMoved then
			local pos = self:convertToNodeSpace(cc.p(touchmovePoint.x, touchmovePoint.y))
			local posX = pos.x
			posX = math.min(posX, 100)
			posX = math.max(posX, -100)
			target:setPositionX(posX)
			self.percent = (100 + posX) / 200
			self.cutLayer:setContentSize(cc.size(200 * self.percent, 6))
			local real = self.min + self.percent * (self.max - self.min)
			local decimal = math.floor(real * 100 + 0.5) * 0.01
			if self.perChange == 1 then
				decimal = math.ceil(decimal)
			end
			self.inputBox:setText(decimal)
			self.cur = decimal
			if self.handle then
				self.handle(self:getValue())
			end
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function commonCustomSlider:btnUpClick(target, event)
	if event == ccui.TouchEventType.ended then
		self.cur = self.cur + self.perChange
		self.cur = math.min(self.cur, self.max)
		self.cur = math.max(self.cur, self.min)
		self:initData(self.min, self.max, self.cur)
	end
end
function commonCustomSlider:btnDownClick(target, event)
	if event == ccui.TouchEventType.ended then
		self.cur = self.cur - self.perChange
		self.cur = math.min(self.cur, self.max)
		self.cur = math.max(self.cur, self.min)
		self:initData(self.min, self.max, self.cur)
	end
end
return commonCustomSlider
