local RichText = class("RichText")
local spriteFrameCache = cc.SpriteFrameCache:getInstance()
function RichText:ctor()
	_ENV, self.fontDefines, _ENV, self.letterCache, _ENV = nil, nil, nil, nil, nil
	;(nil).text = ""
	;(nil).fontName = "Arial"
	;(nil).fontSize = 16
	self.defaultFont, (nil).fontColor = nil, cc.c3b(255, 255, 255)
	self.limitWidth = 512
	self.limitHeight = 512
	self.container = self:createContainer()
	self.margin = 3
end
function RichText:destroy()
	for fontStr, font in pairs(self.letterCache) do
		for char, rect in pairs(font) do
			local frame = cc.SpriteFrame:createWithTexture(texture, rect)
			spriteFrameCache:removeSpriteFrameByName(char .. "_" .. fontStr)
		end
	end
end
function RichText:createContainer()
	local container = cc.Node:create()
	container:setAnchorPoint(cc.p(0, 0))
	container.curY = 0
	container.curX = 0
	container.maxHeight = 0
	container.maxWidth = 0
	container.lineHeight = 0
	return container
end
function RichText:preBuildTexture(strArr)
	for i, v in ipairs(strArr) do
		local fontName = v.fontName or self.defaultFont.fontName
		local fontSize = v.fontSize or self.defaultFont.fontSize
		local fontStr = fontName .. "_" .. fontSize
		if not self.fontDefines[fontStr] then
			_ENV = fontSize
			fontSize.fontName = fontName
			self.fontDefines[fontStr], fontSize.fontSize = fontSize, fontSize
		end
		if not self.letterCache[fontStr] then
			self.letterCache[fontStr], _ENV = fontSize, fontSize
		end
		local str = ""
		if type(v.str) == "table" then
			for _, strUnit in ipairs(v.str) do
				if type(strUnit) == "string" then
					str = str .. strUnit
				end
			end
		elseif type(v.str) == "string" then
			str = v.str
		end
		local list = self:splitString(str)
		for i, char in ipairs(list) do
			if not self.letterCache[fontStr][char] then
				self.letterCache[fontStr][char], _ENV = nil, nil
			end
		end
	end
	self:createLabels()
end
function RichText:createLabels()
	for fontStr, font in pairs(self.letterCache) do
		local fontName = self.fontDefines[fontStr].fontName
		local fontSize = self.fontDefines[fontStr].fontSize
		for char, obj in pairs(font) do
			local letter = cc.Label:createWithSystemFont(char, fontName, fontSize)
			local rect = self:pushContainer(letter, self.container, self.limitWidth, self.limitHeight, self.margin)
			obj.x = rect.x
			obj.y = rect.y
			obj.width = rect.width
			obj.height = rect.height
		end
	end
	self.container:setContentSize(cc.size(self.container.maxWidth, self.container.maxHeight))
	local contentSize = self.container:getContentSize()
	local renderTexture = cc.RenderTexture:create(contentSize.width, contentSize.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	renderTexture:begin()
	self.container:visit()
	renderTexture:endToLua()
	renderTexture:getSprite():getTexture():setAntiAliasTexParameters()
	self:addSpriteFrames(renderTexture:getSprite():getTexture())
end
function RichText:addSpriteFrames(texture)
	for fontStr, font in pairs(self.letterCache) do
		for char, rect in pairs(font) do
			local frame = cc.SpriteFrame:createWithTexture(texture, rect)
			spriteFrameCache:addSpriteFrame(frame, char .. "_" .. fontStr)
		end
	end
end
function RichText:pushContainer(letter, container, limitWidth, limitHeight, margin)
	if container.isFull then
		return
	end
	letter:setAnchorPoint(cc.p(0, 0))
	container:addChild(letter)
	return self:Layout(letter, container, limitWidth, limitHeight, margin)
end
function RichText:Layout(letter, container, limitWidth, limitHeight, margin)
	margin = margin or 0
	local contentSize = letter:getContentSize()
	local x = container.curX
	local y = container.curY
	if limitWidth < container.curX + contentSize.width then
		container.curY = container.curY + container.lineHeight + margin
		container.curX = 0
		x = container.curX
		y = container.curY
		if limitHeight and limitHeight < container.curY then
			container.isFull = true
			return
		end
		container.lineHeight = math.max(container.lineHeight, contentSize.height)
		container.maxHeight = math.max(container.maxHeight, container.curY + container.lineHeight)
		letter:setPosition(cc.p(x, y))
		container.curX = container.curX + contentSize.width + margin
	else
		container.curX = container.curX + contentSize.width + margin
		container.lineHeight = math.max(container.lineHeight, contentSize.height)
		container.maxWidth = math.max(container.maxWidth, container.curX)
		container.maxHeight = math.max(container.maxHeight, container.curY + container.lineHeight)
		letter:setPosition(cc.p(x, y))
	end
	return cc.rect(x - 1, y - 1, contentSize.width + 2, contentSize.height + 2)
end
function RichText:Layoutlt(container)
	local children = container:getChildren()
	local contentSize = container:getContentSize()
	for _, child in ipairs(children) do
		local childSize = child:getContentSize()
		child:setPositionY(contentSize.height - child:getPositionY() - childSize.height)
	end
end
function RichText:createRichText(text, width)
	local _ENV, elements
	local _ENV, arr
	if type(text) == "string" then
		_ENV = nil
		;(nil).text = text
		table.insert(arr, nil)
	elseif type(text) == "table" then
		arr = text
	else
		return nil
	end
	local _ENV, default
	for key, value in pairs(self.defaultFont) do
		default[key] = value
	end
	if arr.default then
		for key, value in pairs(default) do
			default[key] = arr.default[key] or value
		end
	end
	local container = self:createContainer()
	for i, data in ipairs(arr) do
		for key, value in pairs(default) do
			data[key] = data[key] or value
		end
		local list = self:splitString(data.text)
		local letter
		for _, char in ipairs(list) do
			local fontStr = data.fontName .. "_" .. data.fontSize
			if self.letterCache[fontStr] and self.letterCache[fontStr][char] then
				letter = display.newSprite("#" .. char .. "_" .. fontStr)
				letter:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
				letter:setFlippedY(true)
				letter:setColor(data.fontColor)
				if data.func then
					data.func(letter)
				end
				self:pushContainer(letter, container, width)
			end
		end
	end
	container:setContentSize(cc.size(container.maxWidth, container.maxHeight))
	self:Layoutlt(container)
	return container
end
function RichText:setString(container, text, width)
	local _ENV, elements
	local _ENV, arr
	if type(text) == "string" then
		_ENV = nil
		;(nil).text = text
		table.insert(arr, nil)
	elseif type(text) == "table" then
		arr = text
	else
		return nil
	end
	local _ENV, default
	for key, value in pairs(self.defaultFont) do
		default[key] = value
	end
	if arr.default then
		for key, value in pairs(default) do
			default[key] = arr.default[key] or value
		end
	end
	local children = container:getChildren()
	for _, child in ipairs(children) do
		child:setVisible(false)
	end
	local count = 1
	container.curY = 0
	container.curX = 0
	container.maxHeight = 0
	container.maxWidth = 0
	container.lineHeight = 0
	for i, data in ipairs(arr) do
		for key, value in pairs(default) do
			data[key] = data[key] or value
		end
		local list = self:splitString(data.text)
		local letter
		for _, char in ipairs(list) do
			local fontStr = data.fontName .. "_" .. data.fontSize
			if self.letterCache[fontStr] and self.letterCache[fontStr][char] then
				if children[count] then
					letter = children[count]
					letter:setVisible(true)
					letter:setColor(data.fontColor)
					letter:setSpriteFrame(char .. "_" .. fontStr)
					count = count + 1
					self:Layout(letter, container, width)
				else
					letter = display.newSprite("#" .. char .. "_" .. fontStr)
					letter:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
					letter:setFlippedY(true)
					letter:setColor(data.fontColor)
					self:pushContainer(letter, container, width)
				end
				if data.func then
					data.func(letter)
				end
			end
		end
	end
	container:setContentSize(cc.size(container.maxWidth, container.maxHeight))
	self:Layoutlt(container)
end
function RichText:splitString(str)
	local _ENV, list
	local len = string.len(str)
	local i = 1
	while len >= i do
		local c = string.byte(str, i)
		local shift = 1
		if 0 < c and c <= 127 then
			shift = 1
		elseif 192 <= c and c <= 223 then
			shift = 2
		elseif 224 <= c and c <= 239 then
			shift = 3
		elseif 240 <= c and c <= 247 then
			shift = 4
		end
		local char = string.sub(str, i, i + shift - 1)
		i = i + shift
		table.insert(list, char)
	end
	return list
end
return RichText
