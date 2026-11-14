local commonTabBtn = class("commonTabBtn", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("commonTabBtn")
	end
end)
local MAX_TAB = 6
function commonTabBtn:ctor()
	self.tabNum = 1
	self.defaultClick = 1
	self.size = cc.size(640, 72)
	self.choosePng = "btn_alliance_special.png"
	self.unChoosePng = "btn_alliance_click.png"
	self.chooseColor = cc.c3b(255, 245, 175)
	self.unChooseColor = cc.c3b(144, 132, 97)
	self.tabArray, _ENV, self.fontSize = cc.c3b(144, 132, 97), cc.c3b(144, 132, 97), 24
	self.Node_tab = SoraDGetChildByName(self, "Node_tab")
	self.Button_tab = SoraDGetChildByName(self.Node_tab, "Button_tab")
end
function commonTabBtn:initView(param)
	self.tabNum = math.min(MAX_TAB, param.tabNum or 1)
	self.defaultClick = param.defaultClick or 1
	if not param.tabsetArray then
		_ENV = param.tabsetArray
	end
	self.paramArray = param.tabsetArray
	self.curTab = nil
	assert(#self.paramArray >= self.tabNum, "请设置好参数!!!")
	self:clearOld()
	self.Button_tab:setVisible(false)
	for i = 1, self.tabNum do
		if self.tabArray[i] == nil then
			self.tabArray[i] = self.Button_tab:clone()
			self.tabArray[i]:addTo(self.Node_tab)
			self.tabArray[i]:setVisible(true)
		end
		self.tabArray[i]:setAnchorPoint(cc.p(0.5, 0.5))
		self.tabArray[i]:setPosition(0, 0)
		local choosePng = self.paramArray[i].choosePng or self.choosePng
		local unChoosePng = self.paramArray[i].unChoosePng or self.unChoosePng
		self.tabArray[i]:loadTextures(choosePng, unChoosePng, unChoosePng, ccui.TextureResType.plistType)
		self.tabArray[i]:setContentSize(cc.size((self.size.width + 5 * (self.tabNum - 1)) / self.tabNum, self.size.height))
		self.tabArray[i]:setTitleText(self.paramArray[i].title or "tab" .. i)
		SoraDAutoSizeButtonText(self.tabArray[i], param.textSize or cc.size(self.size.width / self.tabNum - 20, self.size.height - 10))
		self.tabArray[i]:setTitleFontSize(self.paramArray[i].fontSize or self.fontSize)
		self.tabArray[i]:setTag(self.paramArray[i].tag or i)
		self.tabArray[i]:setName(self.paramArray[i].name or "tab" .. i)
		self.tabArray[i]:addTouchEventListener(handler(self, self.btnTabClick))
		self.tabArray[i].handle = self.paramArray[i].handle
		self.tabArray[i]:getChildByName("Sprite_redPoint"):setVisible(false)
		self.tabArray[i]:getChildByName("Sprite_redPoint"):setPosition(SoraDFPosX(20, self.size.width / self.tabNum), self.size.height - 20)
		self.tabArray[i]:getChildByName("Sprite_bigRedPoint"):setVisible(false)
		self.tabArray[i]:getChildByName("Sprite_bigRedPoint"):setPosition(SoraDFPosX(16, self.size.width / self.tabNum), self.size.height - 18)
		self.tabArray[i]:setTouchEnabled(true)
		self.tabArray[i]:setBright(false)
		self.tabArray[i]:setTitleColor(self.unChooseColor)
	end
	SoraDToCenter(self.Node_tab, -5, SoraDFIsRA(), true)
	if param.unDefaultClick == nil then
		self:clickByTag(self.defaultClick)
	end
end
function commonTabBtn:openAutoSize()
	for i, v in ipairs(self.tabArray) do
		SoraDAutoSizeButtonTextByContent(v)
	end
end
function commonTabBtn:clickByIndex(index)
	if self.tabArray[index] then
		self:btnTabClick(self.tabArray[index], ccui.TouchEventType.ended, true)
	end
end
function commonTabBtn:clickByTag(tag)
	for i, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			self:btnTabClick(v, ccui.TouchEventType.ended, true)
			return
		end
	end
	self:clickByIndex(1)
end
function commonTabBtn:clearOld()
	if #self.tabArray > self.tabNum then
		for i = #self.tabArray, self.tabNum + 1, -1 do
			self.tabArray[i]:removeFromParent()
			self.tabArray[i] = nil
		end
	end
end
function commonTabBtn:btnTabClick(target, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		if target.handle then
			self:switchTab(target:getTag())
			target.handle(target:getTag(), target:getName())
		end
	end
end
function commonTabBtn:switchTab(tag)
	if self.curTab then
		self.curTab:setTouchEnabled(true)
		self.curTab:setBright(false)
		self.curTab:setTitleColor(self.unChooseColor)
	end
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			v:setTouchEnabled(false)
			v:setBright(true)
			v:setTitleColor(self.chooseColor)
			self.curTab = v
			return
		end
	end
end
function commonTabBtn:setRedPointState(tag, isVisible)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			v:getChildByName("Sprite_redPoint"):setVisible(isVisible)
		end
	end
end
function commonTabBtn:setBigRedPointCount(tag, count)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			v:getChildByName("Sprite_bigRedPoint"):setVisible(0 < count)
			SoraDGetChildByName(v, "Text_redNum"):setString(tostring(count))
		end
	end
end
function commonTabBtn:getTabByTag(tag)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			return v, k
		end
	end
end
function commonTabBtn:getTabByName(name)
	for k, v in ipairs(self.tabArray) do
		if v:getName() == name then
			return v
		end
	end
end
function commonTabBtn:getCurTab(...)
	return self.curTab
end
function commonTabBtn:setFontSize(size)
	self.fontSize = size
end
function commonTabBtn:setChooseColor(color)
	self.chooseColor = color
end
function commonTabBtn:setUnChooseColor(color)
	self.unChooseColor = color
end
function commonTabBtn:setChoosePng(png)
	self.choosePng = png
end
function commonTabBtn:setUnChoosePng(png)
	self.unChoosePng = png
end
function commonTabBtn:setContentSize(size)
	self.size = size
end
function commonTabBtn:getContentSize()
	return self.size
end
function commonTabBtn:getParamArray()
	return self.paramArray
end
function commonTabBtn:setBtnTouchEnabled(index, enabled)
	if self.tabArray[index] then
		self.tabArray[index]:setTouchEnabled(enabled or false)
	end
end
function commonTabBtn:setBtnTitleText(index, str)
	if self.tabArray[index] then
		self.tabArray[index]:setTitleText(str)
	end
end
function commonTabBtn:setOtherSprite(index, spriteName)
	if self.tabArray[index] then
		local sprite = self.tabArray[index]:getChildByName("Sprite_other")
		if sprite then
			sprite:setVisible(true)
		else
			local size = self.tabArray[index]:getContentSize()
			sprite = display.newSprite("#" .. spriteName)
			sprite:setName("Sprite_other")
			sprite:addTo(self.tabArray[index])
			sprite:setPosition(0.5 * size.width, 0.5 * size.height)
			sprite:setScale(size.height / sprite:getContentSize().height)
		end
		return sprite
	end
end
function commonTabBtn:setOtherSpriteHiddle(index)
	if self.tabArray[index] and self.tabArray[index]:getChildByName("Sprite_other") then
		self.tabArray[index]:getChildByName("Sprite_other"):setVisible(false)
	end
end
function commonTabBtn:setOtherSpritePosition(index, position, scale)
	if self.tabArray[index] and self.tabArray[index]:getChildByName("Sprite_other") then
		local sprite = self.tabArray[index]:getChildByName("Sprite_other")
		local size = sprite:getContentSize()
		sprite:setPosition(position.x * size.width, position.y * size.height)
		sprite:setScale(scale)
	end
end
return commonTabBtn
