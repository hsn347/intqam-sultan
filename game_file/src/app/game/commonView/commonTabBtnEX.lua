local commonTabBtnEX = class("commonTabBtnEX", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("commonTabBtnEX")
	end
end)
local MAX_TAB = 6
function commonTabBtnEX:ctor()
	self.commonTabStyle = false
	self.newStyle = false
	self.tabNum = 1
	self.defaultClick = 1
	self.size = cc.size(640, 48)
	self.choosePng = "frame_king_road_base_04.png"
	self.unChoosePng = "bg_transparent.png"
	self.chooseColor = cc.c3b(255, 200, 100)
	self.unChooseColor = cc.c3b(215, 195, 155)
	self.tabArray, _ENV, self.fontSize = cc.c3b(215, 195, 155), cc.c3b(215, 195, 155), 18
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.bg_tab = SoraDGetChildByName(self, "bg_tab")
	self.Node_tab = SoraDGetChildByName(self, "Node_tab")
	self.Button_tab = SoraDGetChildByName(self.Node_tab, "Button_tab")
	self.tabArray[1] = self.Button_tab
end
function commonTabBtnEX:setNewStyle(isShort)
	self.newStyle = true
	self.choosePng = "btn_secondarybtn_long_01.png"
	self.unChoosePng = "btn_secondarybtn_long_02.png"
	self.chooseShortPng = "btn_secondarybtn_long_01.png"
	self.unChooseShortPng = "btn_secondarybtn_long_02.png"
	if isShort then
		self.choosePng = self.chooseShortPng
		self.unChoosePng = self.unChooseShortPng
	end
	SoraDGetChildByName(self.Node_tab, "frame_tab_lineL"):setSpriteFrame("frame_secondarybtn_line_02.png")
	SoraDGetChildByName(self.Node_tab, "frame_tab_lineR"):setSpriteFrame("frame_secondarybtn_line_02.png")
	self.bg_tab:loadTexture("frame_secondarybtn_line_01.png", ccui.TextureResType.plistType)
	local offSetY = self.size.height - 48
	self.Button_tab:setPositionY(-offSetY)
	for i, v in ipairs(self.Button_tab:getChildren()) do
		local vName = v:getName()
		if vName ~= "icon" and vName ~= "title" then
			v:setPositionY(v:getPositionY() + offSetY)
		end
	end
end
function commonTabBtnEX:initView(param)
	self.tabNum = math.min(MAX_TAB, param.tabNum or 1)
	self.defaultClick = param.defaultClick or self.defaultClick
	if not param.tabsetArray then
		_ENV = param.tabsetArray
	end
	self.paramArray = param.tabsetArray
	assert(#self.paramArray >= self.tabNum, "请设置好参数!!!")
	if self.Panel_cut then
		self.Panel_cut:setContentSize(self.size)
	end
	if self.bg_tab then
		if self.newStyle then
			self.bg_tab:setContentSize(cc.size(self.size.width, 2))
			self.bg_tab:setPosition(self.size.width / 2, 8.5)
		else
			self.bg_tab:setContentSize(self.size)
			self.bg_tab:setPosition(self.size.width / 2, self.size.height / 2)
			self.bg_tab:setFillType(1)
		end
	end
	local perWidth = self.size.width / self.tabNum
	if self.commonTabStyle then
		perWidth = (self.size.width + 5 * (self.tabNum - 1)) / self.tabNum
	end
	for i = 1, self.tabNum do
		if i == 1 then
			self.tabArray[i] = self.tabArray[i] or self.Button_tab
		elseif not self.tabArray[i] then
			self.tabArray[i] = self.Button_tab:clone()
			self.tabArray[i]:addTo(self.Node_tab)
		end
		self.tabArray[i]:setVisible(true)
		self.tabArray[i]:loadTextures(self.choosePng, self.choosePng, self.unChoosePng, ccui.TextureResType.plistType)
		self.tabArray[i]:setPressedActionEnabled(false)
		self.tabArray[i]:setContentSize(cc.size(perWidth, self.size.height))
		local Text_name = SoraDGetChildByName(self.tabArray[i], "Text_name")
		Text_name:setContentSize(cc.size(perWidth - 4, self.size.height - 8))
		Text_name:setString(self.paramArray[i].title or "tab" .. i)
		Text_name:setFontSize(self.paramArray[i].fontSize or self.fontSize)
		Text_name:setPositionX(perWidth / 2)
		Text_name:setPositionY(self.size.height / 2)
		local frame_tab_lineL = SoraDGetChildByName(self.tabArray[i], "frame_tab_lineL")
		local frame_tab_lineR = SoraDGetChildByName(self.tabArray[i], "frame_tab_lineR")
		frame_tab_lineL:setPositionX(0)
		frame_tab_lineR:setPositionX(perWidth)
		frame_tab_lineL:setPositionY(self.size.height / 2 + 2)
		frame_tab_lineR:setPositionY(self.size.height / 2 + 2)
		self.tabArray[i]:setTag(self.paramArray[i].tag or i)
		self.tabArray[i]:setName(self.paramArray[i].name or "tab" .. i)
		self.tabArray[i]:addTouchEventListener(handler(self, self.btnTabClick))
		self.tabArray[i].handle = self.paramArray[i].handle
		local Sprite_red = SoraDGetChildByName(self, "Sprite_red")
		if Sprite_red then
			Sprite_red:setVisible(false)
			Sprite_red:setPosition(perWidth - 13, self.size.height - 10)
		end
		local Image_light = SoraDGetChildByName(self, "Image_light")
		if Image_light then
			Image_light:setVisible(false)
			Image_light:setContentSize(cc.size(perWidth, self.size.height - 10))
			Image_light:setPositionX(perWidth / 2)
		end
	end
	for i = self.tabNum + 1, #self.tabArray do
		self.tabArray[i]:setVisible(false)
	end
	if self.commonTabStyle then
		SoraDToCenter(self.Node_tab, -5, SoraDFIsRA(), true)
	else
		SoraDautoSortPos(self.Node_tab, self.tabNum, SoraDFIsRA() and 2 or 0, cc.size(perWidth, self.size.height))
	end
	self:clickByTag(self.defaultClick)
end
function commonTabBtnEX:reset()
	for k, v in ipairs(self.tabArray) do
		if v and k ~= 1 then
			v:removeFromParent()
			self.tabArray[k] = nil
		end
	end
end
function commonTabBtnEX:clickByTag(tag)
	for i, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			self:btnTabClick(v, ccui.TouchEventType.ended, true)
			return
		end
	end
end
function commonTabBtnEX:btnTabClick(target, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		if target and target.handle then
			self:switchTab(target:getTag())
			target.handle(target:getTag(), target:getName())
		end
	end
end
function commonTabBtnEX:switchTab(tag)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			v:setTouchEnabled(false)
			v:setBright(true)
			v:loadTextureNormal(self.choosePng, ccui.TextureResType.plistType)
			SoraDGetChildByName(v, "Text_name"):setColor(self.chooseColor)
			if SoraDGetChildByName(v, "Image_light") then
				SoraDGetChildByName(v, "Image_light"):setVisible(self.isShowLight or false)
			end
		else
			v:setTouchEnabled(true)
			v:setBright(false)
			v:loadTextureNormal(self.unChoosePng, ccui.TextureResType.plistType)
			SoraDGetChildByName(v, "Text_name"):setColor(self.unChooseColor)
			if SoraDGetChildByName(v, "Image_light") then
				SoraDGetChildByName(v, "Image_light"):setVisible(false)
			end
		end
	end
end
function commonTabBtnEX:setRedPointState(tag, isVisible, num)
	local num = num or 0
	for k, v in ipairs(self.tabArray) do
		local Sprite_red = v:getChildByName("Sprite_red")
		if v:getTag() == tag and Sprite_red then
			Sprite_red:setVisible(isVisible)
			if Sprite_red:getChildByName("Text_num") and 0 < num then
				Sprite_red:getChildByName("Text_num"):setString(num)
			end
		end
	end
end
function commonTabBtnEX:setRedPointOffset(offset)
	offset = offset or cc.p(-10, -10)
	for k, v in ipairs(self.tabArray) do
		local Sprite_red = v:getChildByName("Sprite_red")
		if Sprite_red then
			Sprite_red:setPosition(self.size.width / self.tabNum + offset.x, self.size.height + offset.y)
		end
	end
end
function commonTabBtnEX:setTimeLimitState(tag, isVisible, offset)
	offset = offset or cc.p(-10, -10)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			local Sprite_limit = v:getChildByName("Sprite_limit")
			if not Sprite_limit then
				local sprite = display.newSprite("#icon_hdzx_time_01.png")
				sprite:addTo(v)
				sprite:setName("Sprite_limit")
				Sprite_limit = sprite
				sprite:setPosition(self.size.width / self.tabNum + offset.x, self.size.height - sprite:getContentSize().height / 2)
			end
			Sprite_limit:setVisible(isVisible)
		end
	end
end
function commonTabBtnEX:setNewState(tag, isVisible)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			local Sprite_new = v:getChildByName("Sprite_new")
			if not Sprite_new then
				local sprite = display.newSprite("#frame_red_items_new.png")
				sprite:addTo(v)
				sprite:setName("Sprite_new")
				Sprite_new = sprite
				sprite:setScale(0.8)
				sprite:setPosition(sprite:getContentSize().width / 2 * 0.8, self.size.height - sprite:getContentSize().height / 2 * 0.8)
			end
			Sprite_new:setVisible(isVisible)
		end
	end
end
function commonTabBtnEX:getTabByTag(tag)
	for k, v in ipairs(self.tabArray) do
		if v:getTag() == tag then
			return v
		end
	end
end
function commonTabBtnEX:getTabByName(name)
	for k, v in ipairs(self.tabArray) do
		if v:getName() == name then
			return v
		end
	end
end
function commonTabBtnEX:setChooseLight()
	self.isShowLight = true
end
function commonTabBtnEX:setDefaultClick(defaultClick)
	self.defaultClick = defaultClick
	self:btnTabClick(self.tabArray[self.defaultClick], ccui.TouchEventType.ended, true)
end
function commonTabBtnEX:setFontSize(size)
	self.fontSize = size
end
function commonTabBtnEX:setChooseColor(color)
	self.chooseColor = color
end
function commonTabBtnEX:setUnChooseColor(color)
	self.unChooseColor = color
end
function commonTabBtnEX:setChoosePng(png)
	self.choosePng = png
end
function commonTabBtnEX:setUnChoosePng(png)
	self.unChoosePng = png
end
function commonTabBtnEX:setContentSize(size)
	self.size = size
end
function commonTabBtnEX:getContentSize()
	return self.size
end
function commonTabBtnEX:getParamArray()
	return self.paramArray
end
function commonTabBtnEX:hideLineAndBg()
	for i, v in ipairs(self.tabArray) do
		SoraDGetChildByName(v, "frame_tab_lineR"):setVisible(false)
		SoraDGetChildByName(v, "frame_tab_lineL"):setVisible(false)
	end
	self.bg_tab:setVisible(false)
end
function commonTabBtnEX:changeToCommonTabStyle()
	self.commonTabStyle = true
	self.fontSize = 20
	self:hideLineAndBg()
	self.size = cc.size(640, 72)
	self.choosePng = "btn_alliance_special.png"
	self.unChoosePng = "btn_alliance_click.png"
	self.chooseColor = cc.c3b(255, 245, 175)
	self.unChooseColor = cc.c3b(144, 132, 97)
	SoraDGetChildByName(self, "Text_name"):setPositionY(36)
end
function commonTabBtnEX:setSwallow(boolValue)
	if self.Panel_cut then
		self.Panel_cut:setSwallowTouches(boolValue)
	end
	for i, v in ipairs(self.tabArray) do
		v:setSwallowTouches(boolValue)
	end
end
return commonTabBtnEX
