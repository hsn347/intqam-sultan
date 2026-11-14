local luckyFlopRead = include("luckyFlopRead")
local luckyFlopPreAwardView = class("luckyFlopPreAwardView", function(target)
	return target or SoraDCreateTouchPanel("luckyFlopPreAwardView")
end)
_ENV, _UPVALUE7_, luckyFlopPreAwardView.ctor = function(target)
	return target or SoraDCreateTouchPanel("luckyFlopPreAwardView")
end, function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end, function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end
;(function(target)
	return target or SoraDCreateTouchPanel("luckyFlopPreAwardView")
end).headEnd = 4
_ENV, (function(target)
	return target or SoraDCreateTouchPanel("luckyFlopPreAwardView")
end).len = nil, 1
;(nil).headEnd = 2
_ENV, (nil).len = nil, 1
;(nil).headEnd = 2
_ENV, (nil).len = nil, 2
;(nil).headEnd = 3
_ENV, (nil).len = nil, 2
;(nil).headEnd = 2
_ENV, (nil).len = nil, 3
;(nil).headEnd = 1
_ENV, (nil).len = nil, 4
;(nil).headEnd = 1
;(nil).len = 3
;(function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[1] = function(target)
	return target or SoraDCreateTouchPanel("luckyFlopPreAwardView")
end
;(function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[2] = nil
;(function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[3] = nil
;(function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[4] = nil
;(function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[5] = nil
;(function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[6] = nil
local (function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end)[7], config = nil, function(self)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self:initData()
end
_UPVALUE3_, luckyFlopPreAwardView.initData = function(self, data)
	local standardNum = 0
	local specialNum = 0
	local normalNum = 1
	local _UPVALUE3_, luckyFlopRead, singleInfo
	;(nil)[1] = standardNum
	;(nil)[2] = specialNum
	local (nil)[3], typeNum = normalNum, nil
	local info = luckyFlopRead.getLuckyNumConfig()
	for i, v in ipairs(info) do
		if not singleInfo[v.type] then
			singleInfo[v.type], luckyFlopRead = nil, nil
		end
		if v.type == gLuckyNumberType.STANDARD then
			v.height = 150
			standardNum = standardNum + 1
		elseif v.type == gLuckyNumberType.SPECIAL then
			v.height = 40
			specialNum = specialNum + 1
		elseif v.type == gLuckyNumberType.NORMAL then
			v.height = 40
		end
		local specialType = v.specialType
		local specialNumStr = v.num
		local str = "*****"
		local paramStr = "%{num}"
		if specialType == 1 then
			str = paramStr
		elseif specialType ~= 0 then
			local headEnd = config[specialType - 1].headEnd
			local head = string.sub(str, 1, headEnd)
			local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
			for j = 1, config[specialType - 1].len - 1 do
				specialNumStr = specialNumStr .. v.num
			end
			local last = string.sub(str, specialEnd + 1)
			str = head .. paramStr .. last
		end
		v.str = str
		v.specialNumStr = specialNumStr
		table.insert(singleInfo[v.type], v)
	end
	local height = 180 + standardNum * 150 + specialNum * 40 + 40
	height = height < 671 and 671 or height
	self.scroll:setInnerContainerSize(cc.size(533, height))
	for i, v in ipairs(singleInfo) do
		local headNode = self:createHead(i)
		headNode:addTo(self.scroll)
		height = height - 60
		headNode:setPosition(266.5, height + 25)
		for index, value in ipairs(v) do
			if index == 1 then
				value.showLine = false
			else
				value.showLine = true
			end
			local singleNode = self:createSingle(value)
			singleNode:addTo(self.scroll)
			singleNode:setPosition(266.5, height)
			height = height - value.height
		end
	end
end, function(self, data)
	local standardNum = 0
	local specialNum = 0
	local normalNum = 1
	local _UPVALUE3_, luckyFlopRead, singleInfo
	;(nil)[1] = standardNum
	;(nil)[2] = specialNum
	local (nil)[3], typeNum = normalNum, nil
	local info = luckyFlopRead.getLuckyNumConfig()
	for i, v in ipairs(info) do
		if not singleInfo[v.type] then
			singleInfo[v.type], luckyFlopRead = nil, nil
		end
		if v.type == gLuckyNumberType.STANDARD then
			v.height = 150
			standardNum = standardNum + 1
		elseif v.type == gLuckyNumberType.SPECIAL then
			v.height = 40
			specialNum = specialNum + 1
		elseif v.type == gLuckyNumberType.NORMAL then
			v.height = 40
		end
		local specialType = v.specialType
		local specialNumStr = v.num
		local str = "*****"
		local paramStr = "%{num}"
		if specialType == 1 then
			str = paramStr
		elseif specialType ~= 0 then
			local headEnd = config[specialType - 1].headEnd
			local head = string.sub(str, 1, headEnd)
			local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
			for j = 1, config[specialType - 1].len - 1 do
				specialNumStr = specialNumStr .. v.num
			end
			local last = string.sub(str, specialEnd + 1)
			str = head .. paramStr .. last
		end
		v.str = str
		v.specialNumStr = specialNumStr
		table.insert(singleInfo[v.type], v)
	end
	local height = 180 + standardNum * 150 + specialNum * 40 + 40
	height = height < 671 and 671 or height
	self.scroll:setInnerContainerSize(cc.size(533, height))
	for i, v in ipairs(singleInfo) do
		local headNode = self:createHead(i)
		headNode:addTo(self.scroll)
		height = height - 60
		headNode:setPosition(266.5, height + 25)
		for index, value in ipairs(v) do
			if index == 1 then
				value.showLine = false
			else
				value.showLine = true
			end
			local singleNode = self:createSingle(value)
			singleNode:addTo(self.scroll)
			singleNode:setPosition(266.5, height)
			height = height - value.height
		end
	end
end
;(function(self, data)
	local standardNum = 0
	local specialNum = 0
	local normalNum = 1
	local _UPVALUE3_, luckyFlopRead, singleInfo
	;(nil)[1] = standardNum
	;(nil)[2] = specialNum
	local (nil)[3], typeNum = normalNum, nil
	local info = luckyFlopRead.getLuckyNumConfig()
	for i, v in ipairs(info) do
		if not singleInfo[v.type] then
			singleInfo[v.type], luckyFlopRead = nil, nil
		end
		if v.type == gLuckyNumberType.STANDARD then
			v.height = 150
			standardNum = standardNum + 1
		elseif v.type == gLuckyNumberType.SPECIAL then
			v.height = 40
			specialNum = specialNum + 1
		elseif v.type == gLuckyNumberType.NORMAL then
			v.height = 40
		end
		local specialType = v.specialType
		local specialNumStr = v.num
		local str = "*****"
		local paramStr = "%{num}"
		if specialType == 1 then
			str = paramStr
		elseif specialType ~= 0 then
			local headEnd = config[specialType - 1].headEnd
			local head = string.sub(str, 1, headEnd)
			local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
			for j = 1, config[specialType - 1].len - 1 do
				specialNumStr = specialNumStr .. v.num
			end
			local last = string.sub(str, specialEnd + 1)
			str = head .. paramStr .. last
		end
		v.str = str
		v.specialNumStr = specialNumStr
		table.insert(singleInfo[v.type], v)
	end
	local height = 180 + standardNum * 150 + specialNum * 40 + 40
	height = height < 671 and 671 or height
	self.scroll:setInnerContainerSize(cc.size(533, height))
	for i, v in ipairs(singleInfo) do
		local headNode = self:createHead(i)
		headNode:addTo(self.scroll)
		height = height - 60
		headNode:setPosition(266.5, height + 25)
		for index, value in ipairs(v) do
			if index == 1 then
				value.showLine = false
			else
				value.showLine = true
			end
			local singleNode = self:createSingle(value)
			singleNode:addTo(self.scroll)
			singleNode:setPosition(266.5, height)
			height = height - value.height
		end
	end
end)[1] = "luckyFlip_title_04"
;(function(self, data)
	local standardNum = 0
	local specialNum = 0
	local normalNum = 1
	local _UPVALUE3_, luckyFlopRead, singleInfo
	;(nil)[1] = standardNum
	;(nil)[2] = specialNum
	local (nil)[3], typeNum = normalNum, nil
	local info = luckyFlopRead.getLuckyNumConfig()
	for i, v in ipairs(info) do
		if not singleInfo[v.type] then
			singleInfo[v.type], luckyFlopRead = nil, nil
		end
		if v.type == gLuckyNumberType.STANDARD then
			v.height = 150
			standardNum = standardNum + 1
		elseif v.type == gLuckyNumberType.SPECIAL then
			v.height = 40
			specialNum = specialNum + 1
		elseif v.type == gLuckyNumberType.NORMAL then
			v.height = 40
		end
		local specialType = v.specialType
		local specialNumStr = v.num
		local str = "*****"
		local paramStr = "%{num}"
		if specialType == 1 then
			str = paramStr
		elseif specialType ~= 0 then
			local headEnd = config[specialType - 1].headEnd
			local head = string.sub(str, 1, headEnd)
			local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
			for j = 1, config[specialType - 1].len - 1 do
				specialNumStr = specialNumStr .. v.num
			end
			local last = string.sub(str, specialEnd + 1)
			str = head .. paramStr .. last
		end
		v.str = str
		v.specialNumStr = specialNumStr
		table.insert(singleInfo[v.type], v)
	end
	local height = 180 + standardNum * 150 + specialNum * 40 + 40
	height = height < 671 and 671 or height
	self.scroll:setInnerContainerSize(cc.size(533, height))
	for i, v in ipairs(singleInfo) do
		local headNode = self:createHead(i)
		headNode:addTo(self.scroll)
		height = height - 60
		headNode:setPosition(266.5, height + 25)
		for index, value in ipairs(v) do
			if index == 1 then
				value.showLine = false
			else
				value.showLine = true
			end
			local singleNode = self:createSingle(value)
			singleNode:addTo(self.scroll)
			singleNode:setPosition(266.5, height)
			height = height - value.height
		end
	end
end)[2] = "luckyFlip_title_05"
local (function(self, data)
	local standardNum = 0
	local specialNum = 0
	local normalNum = 1
	local _UPVALUE3_, luckyFlopRead, singleInfo
	;(nil)[1] = standardNum
	;(nil)[2] = specialNum
	local (nil)[3], typeNum = normalNum, nil
	local info = luckyFlopRead.getLuckyNumConfig()
	for i, v in ipairs(info) do
		if not singleInfo[v.type] then
			singleInfo[v.type], luckyFlopRead = nil, nil
		end
		if v.type == gLuckyNumberType.STANDARD then
			v.height = 150
			standardNum = standardNum + 1
		elseif v.type == gLuckyNumberType.SPECIAL then
			v.height = 40
			specialNum = specialNum + 1
		elseif v.type == gLuckyNumberType.NORMAL then
			v.height = 40
		end
		local specialType = v.specialType
		local specialNumStr = v.num
		local str = "*****"
		local paramStr = "%{num}"
		if specialType == 1 then
			str = paramStr
		elseif specialType ~= 0 then
			local headEnd = config[specialType - 1].headEnd
			local head = string.sub(str, 1, headEnd)
			local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
			for j = 1, config[specialType - 1].len - 1 do
				specialNumStr = specialNumStr .. v.num
			end
			local last = string.sub(str, specialEnd + 1)
			str = head .. paramStr .. last
		end
		v.str = str
		v.specialNumStr = specialNumStr
		table.insert(singleInfo[v.type], v)
	end
	local height = 180 + standardNum * 150 + specialNum * 40 + 40
	height = height < 671 and 671 or height
	self.scroll:setInnerContainerSize(cc.size(533, height))
	for i, v in ipairs(singleInfo) do
		local headNode = self:createHead(i)
		headNode:addTo(self.scroll)
		height = height - 60
		headNode:setPosition(266.5, height + 25)
		for index, value in ipairs(v) do
			if index == 1 then
				value.showLine = false
			else
				value.showLine = true
			end
			local singleNode = self:createSingle(value)
			singleNode:addTo(self.scroll)
			singleNode:setPosition(266.5, height)
			height = height - value.height
		end
	end
end)[3], titleStr = "luckyFlip_title_06", function(self, data)
	local standardNum = 0
	local specialNum = 0
	local normalNum = 1
	local _UPVALUE3_, luckyFlopRead, singleInfo
	;(nil)[1] = standardNum
	;(nil)[2] = specialNum
	local (nil)[3], typeNum = normalNum, nil
	local info = luckyFlopRead.getLuckyNumConfig()
	for i, v in ipairs(info) do
		if not singleInfo[v.type] then
			singleInfo[v.type], luckyFlopRead = nil, nil
		end
		if v.type == gLuckyNumberType.STANDARD then
			v.height = 150
			standardNum = standardNum + 1
		elseif v.type == gLuckyNumberType.SPECIAL then
			v.height = 40
			specialNum = specialNum + 1
		elseif v.type == gLuckyNumberType.NORMAL then
			v.height = 40
		end
		local specialType = v.specialType
		local specialNumStr = v.num
		local str = "*****"
		local paramStr = "%{num}"
		if specialType == 1 then
			str = paramStr
		elseif specialType ~= 0 then
			local headEnd = config[specialType - 1].headEnd
			local head = string.sub(str, 1, headEnd)
			local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
			for j = 1, config[specialType - 1].len - 1 do
				specialNumStr = specialNumStr .. v.num
			end
			local last = string.sub(str, specialEnd + 1)
			str = head .. paramStr .. last
		end
		v.str = str
		v.specialNumStr = specialNumStr
		table.insert(singleInfo[v.type], v)
	end
	local height = 180 + standardNum * 150 + specialNum * 40 + 40
	height = height < 671 and 671 or height
	self.scroll:setInnerContainerSize(cc.size(533, height))
	for i, v in ipairs(singleInfo) do
		local headNode = self:createHead(i)
		headNode:addTo(self.scroll)
		height = height - 60
		headNode:setPosition(266.5, height + 25)
		for index, value in ipairs(v) do
			if index == 1 then
				value.showLine = false
			else
				value.showLine = true
			end
			local singleNode = self:createSingle(value)
			singleNode:addTo(self.scroll)
			singleNode:setPosition(266.5, height)
			height = height - value.height
		end
	end
end
function luckyFlopPreAwardView:createHead(luckyNumberType)
	local single = self.headNode:clone()
	SoraDGetChildByName(single, "Text_title"):setString(i18n(titleStr[luckyNumberType]))
	return single
end
function luckyFlopPreAwardView:createSingle(data)
	local single = self.singleNode:clone()
	local textLoveNum = SoraDGetChildByName(single, "Text_AddLove")
	local textLuckyNum = SoraDGetChildByName(single, "Text_LuckyNum")
	textLuckyNum = SoraDChangeTextToHtml(textLuckyNum)
	local extraNode = SoraDGetChildByName(single, "Node_Extra")
	local spriteLine = SoraDGetChildByName(single, "Sprite_lineUp")
	local icon = SoraDGetChildByName(single, "icon_score")
	extraNode:setVisible(data.type == gLuckyNumberType.STANDARD)
	textLoveNum:setString(i18n("luckyFlip_text_02") .. "+" .. data.loveNum)
	icon:setPositionX(textLoveNum:getPositionX() + (SoraDFIsRA() and 1 or -1) * textLoveNum:getContentSize().width)
	spriteLine:setVisible(false)
	if data.type == gLuckyNumberType.NORMAL then
		textLuckyNum:setString(i18n("luckyFlip_text_05"))
		textLuckyNum:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		SoraDSetTextWidthHeight(textLuckyNum, cc.size(280, 60))
		textLuckyNum:setColor(cc.c3b(215, 195, 155))
		return single
	elseif data.type == gLuckyNumberType.SPECIAL then
		_ENV = cc.c3b(215, 195, 155)
		_ENV, _ENV, cc.c3b(215, 195, 155).num = cc.c3b(215, 195, 155)
		_ENV, data.specialNumStr.num, cc.c3b(215, 195, 155).color = cc.c3b(215, 195, 155)
		data.specialNumStr.__default, cc.c3b(215, 195, 155).color = cc.c3b(215, 195, 155)
		local str = i18n_html(data.str, cc.c3b(215, 195, 155))
		local textNum = textLuckyNum:clone()
		textNum:addTo(single)
		textNum = SoraDChangeTextToHtml(textNum)
		textNum:setString(str)
		textLuckyNum:setColor(cc.c3b(215, 195, 155))
		textLuckyNum:setString(i18n("luckyFlip_text_03"))
		textNum:setPosition(textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width, (textLuckyNum:getPositionY()))
		return single
	elseif data.type == gLuckyNumberType.STANDARD then
		print("data.showLine", data.showLine)
		spriteLine:setVisible(data.showLine)
		spriteLine:setOpacity(102.0)
		_ENV = 102.0
		_ENV, _ENV, (102.0).num = textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width, data.specialNumStr, data.specialNumStr
		_ENV, data.specialNumStr.num, (textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width).color = textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width, textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width, "#0CD224"
		data.specialNumStr.__default, (textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width).color = textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width, "#FFFFFF"
		local str = i18n_html(data.str, 102.0, data.specialNumStr)
		local textNum = textLuckyNum:clone()
		textNum:addTo(single)
		textNum = SoraDChangeTextToHtml(textNum)
		textNum:setString(str)
		textLuckyNum:setColor(cc.c3b(215, 195, 155))
		textLuckyNum:setString(i18n("luckyFlip_text_03"))
		textNum:setPosition(textLuckyNum:getPositionX() + (SoraDFIsRA() and -1 or 1) * textLuckyNum:getContentSize().width, (textLuckyNum:getPositionY()))
		SoraDGetChildByName(single, "Text_ExtraTip"):setString(i18n("luckyFlip_text_04"))
		self:setAward(extraNode, data.reward)
		return single
	end
end
function luckyFlopPreAwardView:setAward(parent, reward)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(reward, nil)
	for k, v in ipairs(reward) do
		local single = include("commonItemAward").new()
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setPosition(SoraDFPosX(270 - (60 + (k - 1) * 90), 0), -60)
		single:addTo(parent)
		single:initData(v.id, v.count)
	end
end
return luckyFlopPreAwardView
