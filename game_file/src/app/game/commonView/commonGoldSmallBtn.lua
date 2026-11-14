_ENV = nil
;(nil).normal = 0
;(nil).gold = 1
;(nil).resource = 2
local (nil).time, showType = 3, nil
local commonGoldSmallBtn = class("commonGoldSmallBtn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonGoldSmallBtn")
	end
	return target
end)
function commonGoldSmallBtn:ctor()
	self.btnType = showType.normal
	self.btnColor = gBtnColorDef.GREEN
	self.interval = 10
	self.Button_small = SoraDGetChildByName(self, "Button_small")
	self.Button_small:setSwallowTouches(false)
	self.Button_small:addTouchEventListener(handler(self, self.onBtnClickBack))
	self.Button_small:setTitleColor(cc.c3b(255, 251, 213))
	self.Text_title = SoraDGetChildByName(self.Button_small, "Text_title")
	self.Text_title:setColor(cc.c3b(255, 251, 213))
	self.Node_gold = SoraDGetChildByName(self.Button_small, "Node_gold")
	self.Text_gold = SoraDGetChildByName(self.Node_gold, "Text_gold")
	self.Text_gold:setColor(cc.c3b(255, 251, 213))
	self.icon = SoraDGetChildByName(self.Node_gold, "icon")
end
function commonGoldSmallBtn:initData(param, sType)
	local realType = sType or 1
	local _ENV, showParam = nil, param or nil
	showParam.text = param.text or ""
	showParam.title = param.title or i18n("common_text_426")
	showParam.gold = param.gold or 0
	self:setShowType(realType)
	self:initView(showParam)
end
function commonGoldSmallBtn:initView(showParam)
	if self.btnType == showType.normal then
		self.Text_title:setVisible(false)
		self.Node_gold:setVisible(false)
		self.Button_small:setTitleText(showParam.text)
		local size = self.Button_small:getContentSize()
		SoraDAutoSizeButtonText(self.Button_small, cc.size(math.max(0, size.width - 20), math.max(0, size.height - 14)))
	elseif self.btnType == showType.gold then
		self.Text_title:setVisible(true)
		self.Node_gold:setVisible(true)
		self.Button_small:setTitleText("")
		self.Text_title:setString(showParam.title)
		local size = self.Button_small:getContentSize()
		SoraDSetTextWidthHeight(self.Text_title, cc.size(size.width - 10, 22))
		self.Text_gold:setString(string.formatnumberthousands(showParam.gold))
		SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
	elseif self.btnType == showType.resource then
		self.Text_title:setVisible(false)
		self.Node_gold:setVisible(true)
		self.Button_small:setTitleText("")
		local size = self.Button_small:getContentSize()
		self.Node_gold:setPositionY(size.height / 2)
		self.Text_gold:setString(string.formatnumberthousands(showParam.gold))
		self.icon:loadTexture(showParam.icon, ccui.TextureResType.plistType)
		SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
	elseif self.btnType == showType.time then
		self.Text_title:setVisible(true)
		self.Node_gold:setVisible(true)
		self.Button_small:setTitleText("")
		self.Text_title:setString(showParam.title)
		local size = self.Button_small:getContentSize()
		SoraDSetTextWidthHeight(self.Text_title, cc.size(size.width - 10, 22))
		if not self.Text_gold_timer then
			self.Text_gold_timer = SoraDCreateTimerLabel(self, self.Text_gold)
		end
		if self.Text_gold_timer then
			if showParam.timeEndListener then
				self.Text_gold_timer:setTimeEndListener(showParam.timeEndListener)
			end
			if showParam.timeLast then
				self.Text_gold_timer:setTimeLast(showParam.timeLast)
			end
			self.Text_gold_timer:beginTime(showParam.time or 0)
		end
		self.icon:loadTexture("icon_hourglass.png")
		self.icon:setScale(0.75)
		SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
	end
end
function commonGoldSmallBtn:setIconTexture(png)
	local png = png or "icon_small_gold.png"
	self.icon:loadTexture(png, ccui.TextureResType.plistType)
end
function commonGoldSmallBtn:setTitleStr(str)
	self.Text_title:setString(str)
end
function commonGoldSmallBtn:getTitleStr()
	return self.Text_title:getString()
end
function commonGoldSmallBtn:setTitleFontSize(size)
	self.Text_title:setFontSize(size or 18)
end
function commonGoldSmallBtn:getGoldValue()
	return tonumber(self.Text_gold:getString()) or 0
end
function commonGoldSmallBtn:setGoldText(str)
	self.Text_gold:setString(type(str) == "number" and string.formatnumberthousands(str) or str)
	SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
end
function commonGoldSmallBtn:setTextGoldColor(color)
	self.Text_gold:setColor(color)
end
function commonGoldSmallBtn:setColor(color)
	_ENV, self.btnColor = nil, color
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.GREEN], (nil)[1] = nil, "btn_green_small_01.png"
	;(nil)[gBtnColorDef.GREEN], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.GREEN], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.RED], (nil)[1] = nil, "btn_red_small_01.png"
	;(nil)[gBtnColorDef.RED], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.RED], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.YELLOW], (nil)[1] = nil, "btn_yellow_small_01.png"
	;(nil)[gBtnColorDef.YELLOW], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.YELLOW], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.BLUE], (nil)[1] = nil, "btn_blue_small_01.png"
	;(nil)[gBtnColorDef.BLUE], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.BLUE], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.GRAY], (nil)[1] = nil, ""
	;(nil)[gBtnColorDef.GRAY], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.GRAY], (nil)[3] = nil, ""
	local frameConfig
	local frame = frameConfig[self.btnColor]
	if frame then
		self.Button_small:loadTextures(frame[1], frame[2], frame[3], ccui.TextureResType.plistType)
	end
end
function commonGoldSmallBtn:changeToSmall()
	_ENV = nil
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.GREEN], (nil)[1] = nil, "btn_green_normal_01.png"
	;(nil)[gBtnColorDef.GREEN], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.GREEN], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.RED], (nil)[1] = nil, "btn_red_normal_01.png"
	;(nil)[gBtnColorDef.RED], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.RED], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.YELLOW], (nil)[1] = nil, "btn_yellow_normal_01.png"
	;(nil)[gBtnColorDef.YELLOW], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.YELLOW], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.BLUE], (nil)[1] = nil, "btn_blue_normal_01.png"
	;(nil)[gBtnColorDef.BLUE], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.BLUE], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.GRAY], (nil)[1] = nil, ""
	;(nil)[gBtnColorDef.GRAY], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.GRAY], (nil)[3] = nil, ""
	local frameConfig
	local frame = frameConfig[self.btnColor]
	if frame then
		self.Button_small:loadTextures(frame[1], frame[2], frame[3], ccui.TextureResType.plistType)
	end
	self.Button_small:setContentSize(cc.size(156, 66))
	self.Node_gold:setPosition(78, 46)
	self.Text_title:setPosition(78, 22)
end
function commonGoldSmallBtn:changeToNormal()
	_ENV = nil
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.GREEN], (nil)[1] = nil, "btn_green_normal_01.png"
	;(nil)[gBtnColorDef.GREEN], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.GREEN], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.RED], (nil)[1] = nil, "btn_red_normal_01.png"
	;(nil)[gBtnColorDef.RED], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.RED], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.YELLOW], (nil)[1] = nil, "btn_yellow_normal_01.png"
	;(nil)[gBtnColorDef.YELLOW], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.YELLOW], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.BLUE], (nil)[1] = nil, "btn_blue_normal_01.png"
	;(nil)[gBtnColorDef.BLUE], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.BLUE], (nil)[3] = nil, ""
	_UPVALUE3_ = nil
	;(nil)[gBtnColorDef.GRAY], (nil)[1] = nil, ""
	;(nil)[gBtnColorDef.GRAY], (nil)[2] = nil, ""
	;(nil)[gBtnColorDef.GRAY], (nil)[3] = nil, ""
	local frameConfig
	local frame = frameConfig[self.btnColor]
	if frame then
		self.Button_small:loadTextures(frame[1], frame[2], frame[3], ccui.TextureResType.plistType)
	end
	self.Button_small:setContentSize(cc.size(216, 72))
	self.Node_gold:setPosition(108, 46)
	self.Text_title:setPosition(108, 22)
end
function commonGoldSmallBtn:setBtnSize(size)
	local norSize = self.Button_small:getContentSize()
	self.Button_small:setContentSize(size)
	local offsetH = size.height - norSize.height
	local ratioD = 0.3
	local ratioU = 0.7
	self.Text_title:setPosition(cc.p(size.width / 2, math.max(23, offsetH * ratioD + 22)))
	self.Node_gold:setPosition(cc.p(size.width / 2, math.max(norSize.height - 20, offsetH * ratioU + norSize.height - 20)))
	self.Button_small:setScale9Enabled(true)
	self.Button_small:setCapInsets(cc.rect(15, 11, 122, 40))
end
function commonGoldSmallBtn:setRedPoint(ret)
	if not self.redPoint then
		local commonRedPoint = SoraDCreatePanel("commonRedPoint")
		commonRedPoint:setPosition(cc.p(64, 20))
		commonRedPoint:setScale(0.8)
		commonRedPoint:addTo(self, 1)
		self.redPoint = commonRedPoint
	end
	self.redPoint:updateRedPoint(ret and -1 or 0)
end
function commonGoldSmallBtn:getBoundingBox()
	local boundingBox = self.Button_small:getBoundingBox()
	return cc.rect(self:getPositionX() - 0.5 * boundingBox.width, self:getPositionY() - 0.5 * boundingBox.height, boundingBox.width, boundingBox.height)
end
function commonGoldSmallBtn:setTouchEnabled(enable)
	self.Button_small:setTouchEnabled(enable)
end
function commonGoldSmallBtn:getContentSize()
	return self.Button_small:getContentSize()
end
function commonGoldSmallBtn:setTitleText(title)
	self.Button_small:setTitleText(title)
end
function commonGoldSmallBtn:setTitleColor(color)
	self.Button_small:setTitleColor(color)
end
function commonGoldSmallBtn:setBright(isBright)
	self.Button_small:setBright(isBright)
end
function commonGoldSmallBtn:setEnabled(isEnable)
	self.Button_small:setEnabled(isEnable)
end
function commonGoldSmallBtn:isBright()
	return self.Button_small:isBright()
end
function commonGoldSmallBtn:setTag(tag)
	self.Button_small:setTag(tag)
end
function commonGoldSmallBtn:getTag()
	return self.Button_small:getTag()
end
function commonGoldSmallBtn:setSwallowTouches(ret)
	self.Button_small:setSwallowTouches(ret or false)
end
function commonGoldSmallBtn:getBtnInstance()
	return self.Button_small
end
function commonGoldSmallBtn:setInterval(interval)
	self.interval = interval
end
function commonGoldSmallBtn:setShowType(sType)
	self.btnType = sType
end
function commonGoldSmallBtn:setScroll(scroll)
	self.scroll = scroll
end
function commonGoldSmallBtn:setHandle(handle)
	self.handle = handle
end
function commonGoldSmallBtn:addTouchEventListener(handle)
	self.handle = handle
end
function commonGoldSmallBtn:onBtnClickBack(button, event)
	if self.handle then
		self.handle(button, event)
	end
end
return commonGoldSmallBtn
