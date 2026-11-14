local luckyFlopCtrl = SoraDGetCtrl("luckyFlopCtrl")
local luckyFlopRead = include("luckyFlopRead")
local luckyFlopRewardView = class("luckyFlopRewardView", function(target)
	return target or SoraDCreateTouchPanel("luckyFlopRewardView")
end)
function luckyFlopRewardView:ctor()
	self.haveStandardNum = false
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textPoint = SoraDGetChildByName(self, "Text_Have")
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_LuckNum")
	self.btnFlopOne = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_One")
	self.btnFlopTen = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_Ten")
	self.btnFlopOne:setTag(1)
	self.btnFlopOne:setColor(gBtnColorDef.YELLOW)
	_ENV = gBtnColorDef.YELLOW
	_ENV = nil
	;(nil).num = 1
	gBtnColorDef.YELLOW.title = i18n("luckyFlip_btn_01", nil)
	gBtnColorDef.YELLOW.gold = 1 * luckyFlopRead.getFlipNum()
	gBtnColorDef.YELLOW.icon = "icon_filp_score.png"
	self.btnFlopOne:initData(gBtnColorDef.YELLOW, 1)
	self.btnFlopOne:setTitleSize(cc.size(210, 21))
	self.btnFlopOne:addTouchEventListener(handler(self, self.btnClickFlop))
	self.btnFlopTen:setTag(10)
	_ENV = 10
	_ENV = handler(self, self.btnClickFlop)
	handler(self, self.btnClickFlop).num = 10
	;(10).title = i18n("luckyFlip_btn_01", handler(self, self.btnClickFlop))
	;(10).gold = 10 * luckyFlopRead.getFlipNum()
	;(10).icon = "icon_filp_score.png"
	self.btnFlopTen:initData(10, 1)
	self.btnFlopTen:setTitleSize(cc.size(210, 21))
	self.btnFlopTen:addTouchEventListener(handler(self, self.btnClickFlop))
	self.nodeTitleNum = SoraDGetChildByName(self, "Node_UpReward")
	self.nodeTitleExtra = SoraDGetChildByName(self, "Node_ExtraAward")
	self.nodeTitleLove = SoraDGetChildByName(self, "Node_LoveAward")
	self.nodeExtra = SoraDGetChildByName(self.nodeTitleExtra, "Node_ExtraAward")
	self.textTip = SoraDGetChildByName(self.nodeTitleExtra, "Text_Tips")
	self.nodeNumSingle = SoraDGetChildByName(self.nodeTitleNum, "Node_Num_Single")
	self.textTitle:setString(i18n("godGift_text_20"))
	self.textTip:setString(i18n("luckyFlip_text_09"))
	SoraDGetAutoHeightLabel(self.textTip, 525)
	if SoraDGetDefaultLanguage() ~= "ar" and SoraDGetDefaultLanguage() ~= "en" then
		local str = "bg_spiritual_gift_pop_" .. SoraDGetDefaultLanguage() .. ".png"
		SoraDGetChildByName(self, "frame_title_congratulation_ar_22"):setSpriteFrame(str)
	end
	self:initData()
end
function luckyFlopRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS", handler(self, self.updataData))
end
function luckyFlopRewardView:updataData(target, data)
	if data.subMsg == "notify" then
		self:initData()
	end
end
function luckyFlopRewardView:initData(data)
	self.lottoryScore = luckyFlopCtrl:getLottoryScore()
	self.btnFlopOne:setTextGoldColor(luckyFlopRead.isScoreEnough(self.lottoryScore, 1) and COLOR3.YELLOW or display.COLOR_RED)
	self.btnFlopTen:setTextGoldColor(luckyFlopRead.isScoreEnough(self.lottoryScore, 10) and COLOR3.YELLOW or display.COLOR_RED)
	self.textPoint:setString(i18n("common_text_3893") .. string.formatnumberthousands(self.lottoryScore))
	SoraDGetChildByName(self.btnFlopOne, "icon_score"):setPositionX((SoraDFIsRA() and 1 or -1) * self.textPoint:getContentSize().width / 2)
	self:setButtonTitleColor(self.btnFlopTen)
	self:setButtonTitleColor(self.btnFlopOne)
end
_UPVALUE3_, luckyFlopRewardView.setButtonTitleColor = function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end, function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[1] = "luckyFlip_title_04"
;(function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[2] = "luckyFlip_title_05"
local (function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end)[3], titleStr = "luckyFlip_title_06", function(self, target)
	if luckyFlopRead.isScoreEnough(self.lottoryScore, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end
function luckyFlopRewardView:createNodeNumSingle(data, index, posY)
	local nodeParent = self.nodeNumSingle:clone()
	if table.nums(data) > 0 then
		nodeParent:addTo(self.nodeTitleNum)
		nodeParent:setPosition(0, -posY)
	else
		return -10
	end
	local height = math.ceil(table.nums(data) / 3) * 45
	SoraDGetChildByName(nodeParent, "Text_NumberName"):setString(i18n(titleStr[index]))
	local nodeNum = SoraDGetChildByName(nodeParent, "Node_Num")
	for i, v in ipairs(data) do
		local single = self:createSingleNum()
		self:refreshSingleNum(single, v)
		single:addTo(nodeNum)
		print(math.floor(i / 4))
		single:setPosition(SoraDFPosX(135 * (1 - (i - 1) % 3), 0), -math.floor((i - 1) / 3) * 45)
	end
	return height
end
function luckyFlopRewardView:updataDataScroll(data)
	local height = 0
	local luckyNumbers = data.luckyNumbers
	local nums = table.nums(luckyNumbers)
	local _ENV, reward = luckyNumbers, luckyNumbers
	local _ENV, specialNumTbl
	local _ENV, standardNumTbl
	local _ENV, normalNumTbl
	for i, v in ipairs(luckyNumbers) do
		if v.type == gLuckyNumberType.STANDARD then
			table.insert(standardNumTbl, v)
		elseif v.type == gLuckyNumberType.SPECIAL then
			table.insert(specialNumTbl, v)
		else
			table.insert(normalNumTbl, v)
		end
		if v.type == gLuckyNumberType.STANDARD then
			if not v.reward then
				local _ENV, tmp = v.reward, v.reward
			end
			for _, value in ipairs(tmp) do
				reward[table.nums(reward) + 1] = value
			end
		end
	end
	self.haveStandardNum = 0 < table.nums(standardNumTbl)
	local posY = 40
	_UPVALUE3_ = ipairs(luckyNumbers)
	ipairs(luckyNumbers)[1] = standardNumTbl
	ipairs(luckyNumbers)[2] = specialNumTbl
	ipairs(luckyNumbers)[3] = normalNumTbl
	for i, v in ipairs(ipairs(luckyNumbers)) do
		posY = self:createNodeNumSingle(v, i, posY) + posY + 10
	end
	height = posY
	SoraDGetChildByName(self.nodeTitleLove, "Text_Title"):setString(i18n("luckyFlip_title_08"))
	local textLoveNum = SoraDGetChildByName(self.nodeTitleLove, "Text_AddLove")
	textLoveNum:setString(i18n("luckyFlip_text_02") .. "+" .. data.addLoveNum)
	SoraDGetChildByName(self.nodeTitleLove, "icon_score"):setPositionX((SoraDFIsRA() and 1 or -1) * textLoveNum:getContentSize().width / 2)
	height = height + 65
	self.nodeTitleExtra:setVisible(self.haveStandardNum)
	local extraHeight = 0
	if self.haveStandardNum then
		extraHeight = self.textTip:getContentSize().height + 65
		SoraDGetChildByName(self.nodeTitleExtra, "Text_Title"):setString(i18n("luckyFlip_title_09"))
		for k, v in ipairs(reward) do
			local single = include("commonItemAward").new()
			single:setScale(0.8)
			single:setBaseScale(1.0)
			single:setOwnView(self)
			single:addTo(self.nodeExtra)
			single:initData(v.id, v.count)
		end
		SoraDautoSortPos(self.nodeExtra, 5, SoraDFIsRA() and 2 or 0, cc.size(100, 90))
		local num = math.ceil(table.nums(reward) / 5)
		extraHeight = extraHeight + num * 90
		self.nodeExtra:setPositionY((num + 1) * -48)
		self.textTip:setPositionY((num * 2 + 1) * -50)
	end
	height = extraHeight + height
	local innerHeight = 338 < height and height or 338
	self.nodeTitleNum:setPositionY(innerHeight)
	self.nodeTitleLove:setPositionY(innerHeight - posY + 20)
	self.nodeTitleExtra:setPositionY(extraHeight)
	self.scroll:setInnerContainerSize(cc.size(510, innerHeight))
end
_ENV, _UPVALUE7_, luckyFlopRewardView.createSingleNum = "luckyFlip_title_05", function(self)
	local single = self.singleNode:clone()
	return single
end, function(self)
	local single = self.singleNode:clone()
	return single
end
;("luckyFlip_title_05").headEnd = 4
_ENV, ("luckyFlip_title_05").len = "luckyFlip_title_06", 1
;("luckyFlip_title_06").headEnd = 2
_ENV, ("luckyFlip_title_06").len = nil, 1
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
_UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[1] = "luckyFlip_title_05", "luckyFlip_title_05"
_UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[2] = "luckyFlip_title_05", "luckyFlip_title_06"
_UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[3] = "luckyFlip_title_05"
_UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[4] = "luckyFlip_title_05"
_UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[5] = "luckyFlip_title_05"
_UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[6] = "luckyFlip_title_05"
local _UPVALUE3_, (function(self)
	local single = self.singleNode:clone()
	return single
end)[7], config = "luckyFlip_title_05", nil, function(self)
	local single = self.singleNode:clone()
	return single
end
;("luckyFlip_title_05")[1] = "frame_hyfp_shhw3.png"
;("luckyFlip_title_05")[2] = "frame_hyfp_shhw2.png"
local ("luckyFlip_title_05")[3], imagBg = "frame_hyfp_shhw.png", "luckyFlip_title_05"
function luckyFlopRewardView:refreshSingleNum(parent, data)
	local textNum = SoraDGetChildByName(parent, "Text_Num")
	local frameBg = SoraDGetChildByName(parent, "frame_Bg")
	frameBg:setSpriteFrame(imagBg[data.type])
	textNum = SoraDChangeTextToHtml(textNum)
	local specialType = data.specialType
	local str = string.format("%05d", data.luckyNumber)
	local specialNumStr = data.luckyNumber
	local paramStr = "%{num}"
	if specialType == 1 then
		str = paramStr
	elseif specialType ~= 0 then
		local headEnd = config[specialType - 1].headEnd
		local head = string.sub(str, 1, headEnd)
		local specialEnd = headEnd + 1 + config[specialType - 1].len - 1
		specialNumStr = string.sub(str, headEnd + 1, specialEnd)
		local last = string.sub(str, specialEnd + 1)
		str = head .. paramStr .. last
	end
	print("···str,specialNumStr,specialType", str, specialNumStr, specialType)
	local color = data.type == gLuckyNumberType.STANDARD and "#0CD224" or "#FF9B0D"
	_ENV = paramStr
	_ENV, _ENV, paramStr.num = nil, last, specialNumStr
	_ENV, last.num, (nil).color = nil, nil, color
	last.__default, (nil).color = nil, "#FAEFBD"
	textNum:setString(i18n_html(str, paramStr, last))
end
function luckyFlopRewardView:btnClickFlop(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local flopTimes = button:getTag()
		if luckyFlopRead.isScoreEnough(self.lottoryScore or 0, flopTimes) then
			_ENV = self.lottoryScore or 0
			;(self.lottoryScore or 0).msg = "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS"
			;(self.lottoryScore or 0).subMsg = "clickFlop"
			;(self.lottoryScore or 0).flopTimes = flopTimes
			SoraDSendMessage(self.lottoryScore or 0)
			self:close(self, eventType)
		else
			SoraDShowMsgTip(i18n("luckyFlip_text_08"))
		end
	end
end
return luckyFlopRewardView
