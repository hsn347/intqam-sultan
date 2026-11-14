local CommonLimitBox = class("commonLimitBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonLimitBox")
	end
	return target
end)
function CommonLimitBox:ctor()
	self.mainList, _ENV = nil, nil
	self.otherInfoHeight = 100
	self.limitTitle = SoraDGetChildByName(self, "Text_tip")
	self.spLine = SoraDGetChildByName(self, "Sprite_line")
	self.imgSingle = SoraDGetChildByName(self, "Image_single")
	self.imgBg = SoraDGetChildByName(self, "Center_Image_bg")
	self.spUp = SoraDGetChildByName(self, "Sprite_up")
	self.spDown = SoraDGetChildByName(self, "Sprite_down")
end
function CommonLimitBox:setTitle(text)
	self.limitTitle:setString(text)
end
function CommonLimitBox:hideTitle()
	self.limitTitle:setVisible(false)
	self.spLine:setVisible(false)
	self.otherInfoHeight = 40
end
function CommonLimitBox:judgeData(infoList)
	local _ENV, retTbl
	local isOk = false
	for i, v in ipairs(infoList) do
		if v.andCmpTbl then
			for index, val in ipairs(v.andCmpTbl) do
				if not self:valueCmp(val[1], val[2], val[3]) then
					isOk = true
					table.insert(retTbl, i)
				end
			end
		elseif v.orCmpTbl then
			local itemFlag = true
			for index, val in ipairs(v.orCmpTbl) do
				if self:valueCmp(val[1], val[2], val[3]) then
					itemFlag = false
				end
			end
			if itemFlag then
				isOk = true
				table.insert(retTbl, i)
			end
		elseif v.isReach ~= nil then
			isOk = true
			table.insert(retTbl, i)
		end
	end
	return isOk, retTbl
end
function CommonLimitBox:initData(infoList)
	self.mainList = infoList
	self:initView()
end
function CommonLimitBox:initView(...)
	local _ENV, ocxTbl
	local bgHeigh = #self.mainList * 35 + self.otherInfoHeight
	self.imgBg:setContentSize(cc.size(640, bgHeigh))
	self.spUp:setPositionY(bgHeigh)
	self.limitTitle:setPositionY(#self.mainList * 35 + self.otherInfoHeight - 40)
	self.spLine:setPositionY(#self.mainList * 35 + self.otherInfoHeight - 60)
	self.imgBg:setScaleY(0.1)
	for i, v in ipairs(self.mainList) do
		if v.andCmpTbl then
			v.noOk = false
			for index, val in ipairs(v.andCmpTbl) do
				if not self:valueCmp(val[1], val[2], val[3]) then
					v.noOk = true
				end
			end
		elseif v.orCmpTbl then
			v.noOk = true
			for index, val in ipairs(v.orCmpTbl) do
				if self:valueCmp(val[1], val[2], val[3]) then
					v.noOk = false
				end
			end
		elseif v.isReach ~= nil then
			v.noOk = true
			if v.isReach then
				v.noOk = false
			end
		end
		local single = self.imgSingle:clone()
		single:getChildByName("Image_icon"):loadTexture(v.icon, ccui.TextureResType.plistType)
		single:getChildByName("Text_content"):setString(v.content)
		if v.noOk then
			if v.btnFun and v.btnTitle then
				single:getChildByName("Button_goto"):setVisible(true)
				single:getChildByName("Button_goto"):setTitleText(v.btnTitle)
				single:getChildByName("Button_goto"):setTag(i)
				single:getChildByName("Button_goto"):addTouchEventListener(handler(self, self.singleClick))
			else
				single:getChildByName("Button_goto"):setVisible(false)
			end
			single:getChildByName("Text_content"):setColor(display.COLOR_RED)
			single:getChildByName("Image_ok"):loadTexture("icon_no.png", ccui.TextureResType.plistType)
		else
			single:getChildByName("Button_goto"):setVisible(false)
			single:getChildByName("Image_ok"):loadTexture("icon_yes.png", ccui.TextureResType.plistType)
		end
		single:addTo(self.imgBg)
		single:setPosition(-320, bgHeigh - (self.otherInfoHeight - 20) - (i - 1) * 35)
		_ENV = -320
		;(-320).ocx = single
		;(-320).y = bgHeigh - (self.otherInfoHeight - 20) - (i - 1) * 35
		table.insert(ocxTbl, -320)
	end
	_ENV = ipairs(self.mainList)
	ipairs(self.mainList).scaleY = 1
	ipairs(self.mainList).time = 0.1
	ipairs(self.mainList).onComplete = function()
		for i, v in ipairs(ocxTbl) do
			_ENV = nil
			;(nil).x = 320
			;(nil).y = v.y
			;(nil).time = 0.1
			;(nil).delay = i * 0.1
			transition.moveTo(v.ocx, nil)
		end
	end
	transition.scaleTo(self.imgBg, ipairs(self.mainList))
end
function CommonLimitBox:valueCmp(val1, val2, cType)
	local result = false
	if cType == ">" then
		result = val2 < val1
	elseif cType == "<" then
		result = val1 < val2
	elseif cType == "==" then
		result = val1 == val2
	elseif cType == ">=" then
		result = val2 <= val1
	elseif cType == "<=" then
		result = val1 <= val2
	elseif cType == "~=" then
		result = val1 ~= val2
	end
	return result
end
function CommonLimitBox:singleClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button:getTag()
		if self.mainList[index] then
			self.mainList[index].btnFun(self)
		end
	end
end
function CommonLimitBox:setImageTouchEnable()
	self.imgBg:setTouchEnabled(true)
	self.imgBg:setSwallowTouches(true)
end
return CommonLimitBox
