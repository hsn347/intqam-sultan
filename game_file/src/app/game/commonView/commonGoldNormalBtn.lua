_ENV = nil
;(nil).normal = 0
;(nil).gold = 1
;(nil).resource = 2
local (nil).item, showType = 3, nil
local commonGoldNormalBtn = class("commonGoldNormalBtn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonGoldNormalBtn")
	end
	return target
end)
function commonGoldNormalBtn:ctor()
	self.btnType = showType.normal
	self.btnColor = gBtnColorDef.GREEN
	self.strValueColor = COLOR3.YELLOW
	self.interval = 10
	self.isEnough = false
	self.Button_normal = SoraDGetChildByName(self, "Button_normal")
	self.Button_normal:setSwallowTouches(false)
	self.Button_normal:addTouchEventListener(handler(self, self.onBtnClickBack))
	self.Button_normal:setTitleColor(cc.c3b(255, 251, 213))
	self.Text_title = SoraDGetChildByName(self.Button_normal, "Text_title")
	self.Text_title:setColor(cc.c3b(255, 251, 213))
	self.Node_gold = SoraDGetChildByName(self.Button_normal, "Node_gold")
	self.Text_gold = SoraDGetChildByName(self.Node_gold, "Text_gold")
	self.Text_gold:setColor(cc.c3b(255, 251, 213))
	self.icon = SoraDGetChildByName(self.Node_gold, "icon")
	self.strTitleColor = self.Text_title:getColor()
end
function commonGoldNormalBtn:initData(param, sType)
	local realType = sType or 1
	local _ENV, param = nil, param or nil
	local showParam = serviceFunctions.table_copy_table(param)
	showParam.text = param.text or ""
	showParam.title = param.title or i18n("common_text_426")
	showParam.gold = param.gold or 0
	showParam.icon = param.icon or "icon_small_gold.png"
	self:setShowType(realType)
	self:initView(showParam)
end
function commonGoldNormalBtn:initView(showParam)
	self.Text_gold:setColor(self.strValueColor)
	if self.btnType == showType.normal then
		self.Text_title:setVisible(false)
		self.Node_gold:setVisible(false)
		self.Button_normal:setTitleText(showParam.text)
		local size = self.Button_normal:getContentSize()
		SoraDAutoSizeButtonText(self.Button_normal, cc.size(math.max(0, size.width - 20), math.max(0, size.height - 14)))
	elseif self.btnType == showType.gold then
		self.Text_title:setVisible(true)
		self.Node_gold:setVisible(true)
		self.Button_normal:setTitleText("")
		self.Text_title:setString(showParam.title)
		self.Text_gold:setString(string.formatnumberthousands(showParam.gold))
		self.icon:loadTexture(showParam.icon, ccui.TextureResType.plistType)
		SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
	elseif self.btnType == showType.resource then
		self.Text_title:setVisible(false)
		self.Node_gold:setVisible(true)
		self.Button_normal:setTitleText("")
		local size = self.Button_normal:getContentSize()
		self.Node_gold:setPositionY(size.height / 2)
		self.Text_gold:setString(string.formatnumberthousands(showParam.gold))
		self.icon:loadTexture(showParam.icon, ccui.TextureResType.plistType)
		SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
	elseif self.btnType == showType.item then
		local gametop = gModuleMgr.getObject("gametop")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local itemDesRead = include("itemDesRead")
		self.Text_title:setVisible(true)
		self.Node_gold:setVisible(true)
		self.Button_normal:setTitleText("")
		self.isEnough = backpackCtrl:getItemCount(showParam.id) >= showParam.gold
		if showParam.have then
			showType = SoraDFIsRA()
			SoraDFIsRA().member = string.formatnumberthousands(backpackCtrl:getItemCount(showParam.id))
			SoraDFIsRA().total = string.formatnumberthousands(showParam.gold)
			self.Text_gold:setString(i18n("common_text_155", SoraDFIsRA()))
		else
			self.Text_gold:setString(string.formatnumberthousands(showParam.gold))
		end
		if showParam.checkColor then
			self.Text_gold:setColor(self.isEnough and self.strValueColor or display.COLOR_RED)
		end
		self.icon:loadTexture(itemDesRead.getIcon(showParam.id), ccui.TextureResType.plistType)
		self.Text_title:setString(showParam.title)
		SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
	end
end
function commonGoldNormalBtn:setIconTexture(png)
	local png = png or "icon_small_gold.png"
	self.icon:loadTexture(png, ccui.TextureResType.plistType)
end
function commonGoldNormalBtn:setIconScale(scale)
	self.icon:setScale(scale)
end
function commonGoldNormalBtn:setTitleStr(str)
	self.Text_title:setString(str)
end
function commonGoldNormalBtn:getTitleStr()
	return self.Text_title:getString()
end
function commonGoldNormalBtn:setTitleFontSize(size)
	self.Text_title:setFontSize(size or 18)
end
function commonGoldNormalBtn:setGoldText(str)
	self.Text_gold:setString(type(str) == "number" and string.formatnumberthousands(str) or str)
	SoraDToCenter(self.Node_gold, self.interval, SoraDFIsRA())
end
function commonGoldNormalBtn:getGoldValue()
	return tonumber(self.Text_gold:getString()) or 0
end
function commonGoldNormalBtn:setTextGoldColor(color)
	self.strValueColor = color
	self.Text_gold:setColor(color)
end
function commonGoldNormalBtn:setColor(color)
	_ENV, self.btnColor = nil, color
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
		self.Button_normal:loadTextures(frame[1], frame[2], frame[3], ccui.TextureResType.plistType)
	end
end
function commonGoldNormalBtn:changeToNormal()
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
		self.Button_normal:loadTextures(frame[1], frame[2], frame[3], ccui.TextureResType.plistType)
	end
	self.Button_normal:setContentSize(cc.size(216, 72))
	self.Node_gold:setPosition(108, 46)
	self.Text_title:setPosition(108, 26)
end
function commonGoldNormalBtn:changeToSmall()
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
		self.Button_normal:loadTextures(frame[1], frame[2], frame[3], ccui.TextureResType.plistType)
	end
	self.Button_normal:setContentSize(cc.size(156, 66))
	self.Node_gold:setPosition(78, 46)
	self.Text_title:setPosition(78, 26)
end
function commonGoldNormalBtn:setBtnSize(size)
	local norSize = self.Button_normal:getContentSize()
	self.Button_normal:setContentSize(size)
	local offsetH = size.height - norSize.height
	local ratioD = 0.3
	local ratioU = 0.7
	self.Text_title:setPosition(cc.p(size.width / 2, math.max(27, offsetH * ratioD + 26)))
	self.Node_gold:setPosition(cc.p(size.width / 2, math.max(norSize.height - 22, offsetH * ratioU + norSize.height - 22)))
	self.Button_normal:setScale9Enabled(true)
	self.Button_normal:setCapInsets(cc.rect(15, 11, 182, 46))
end
function commonGoldNormalBtn:setRedPoint(ret)
	if not self.redPoint then
		local commonRedPoint = SoraDCreatePanel("commonRedPoint")
		commonRedPoint:setPosition(cc.p(95, 25))
		commonRedPoint:setScale(0.8)
		commonRedPoint:addTo(self, 1)
		self.redPoint = commonRedPoint
	end
	self.redPoint:updateRedPoint(ret and -1 or 0)
end
function commonGoldNormalBtn:getBoundingBox()
	local boundingBox = self.Button_normal:getBoundingBox()
	return cc.rect(self:getPositionX() - 0.5 * boundingBox.width, self:getPositionY() - 0.5 * boundingBox.height, boundingBox.width, boundingBox.height)
end
function commonGoldNormalBtn:setTouchEnabled(enable)
	self.Button_normal:setTouchEnabled(enable)
end
function commonGoldNormalBtn:isTouchEnabled()
	return self.Button_normal:isTouchEnabled()
end
function commonGoldNormalBtn:getContentSize()
	return self.Button_normal:getContentSize()
end
function commonGoldNormalBtn:setTitleText(title)
	self.Button_normal:setTitleText(title)
end
function commonGoldNormalBtn:setTitleColor(color)
	self.Button_normal:setTitleColor(color)
end
function commonGoldNormalBtn:setBright(isBright)
	self.Button_normal:setBright(isBright)
end
function commonGoldNormalBtn:isBright()
	return self.Button_normal:isBright()
end
function commonGoldNormalBtn:setTag(tag)
	self.Button_normal:setTag(tag)
end
function commonGoldNormalBtn:getTag()
	return self.Button_normal:getTag()
end
function commonGoldNormalBtn:setSwallowTouches(ret)
	self.Button_normal:setSwallowTouches(ret or false)
end
function commonGoldNormalBtn:getBtnInstance()
	return self.Button_normal
end
function commonGoldNormalBtn:getBtnCheck()
	return self.isEnough
end
function commonGoldNormalBtn:setInterval(interval)
	self.interval = interval
end
function commonGoldNormalBtn:setShowType(sType)
	self.btnType = sType
end
function commonGoldNormalBtn:setScroll(scroll)
	self.scroll = scroll
end
function commonGoldNormalBtn:setHandle(handle)
	self.handle = handle
end
function commonGoldNormalBtn:addTouchEventListener(handle)
	self.handle = handle
end
function commonGoldNormalBtn:onBtnClickBack(button, event)
	if self.handle then
		self.handle(button, event)
	end
end
function commonGoldNormalBtn:setTitleSize(size)
	SoraDSetTextWidthHeight(self.Text_title, size)
end
function commonGoldNormalBtn:checkEnoughGold(needGold)
	if not SoraDEnoughGold(needGold, true) then
		self.Text_gold:setColor(display.COLOR_RED)
		self.Text_title:setColor(display.COLOR_RED)
	end
end
function commonGoldNormalBtn:setEnouhGold(enough)
	if not enough then
		self.Text_gold:setColor(display.COLOR_RED)
		self.Text_title:setColor(display.COLOR_RED)
	else
		self.Text_gold:setColor(self.strValueColor)
		self.Text_title:setColor(self.strTitleColor)
	end
end
function commonGoldNormalBtn:setAmberCollegeVisible(isAmberLack)
	if isAmberLack then
		self.Node_gold:setVisible(false)
		self.Text_title:setPositionY(39)
	else
		self.Node_gold:setVisible(true)
		self.Text_title:setPositionY(24)
	end
end
return commonGoldNormalBtn
