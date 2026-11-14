local luckyFlopCtrl = SoraDGetCtrl("luckyFlopCtrl")
local luckyFlopLogView = class("luckyFlopLogView", function(target)
	return target or SoraDCreateTouchPanel("luckyFlopLogView")
end)
function luckyFlopLogView:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("luckyFlip_btn_02"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.textNoLog = SoraDGetChildByName(self, "text_no_rank_tip")
	self.textNoLog:setString(i18n("god_beast_text_16"))
	SoraDShowLoading(self)
	luckyFlopCtrl:reqLuckyFlipRecord()
end
function luckyFlopLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS", handler(self, self.updataData))
end
function luckyFlopLogView:updataData(target, data)
	if data.subMsg == "record" then
		SoraDCloseLoading(self)
		self.textNoLog:setVisible(not next(data.record))
		self.scroll:updateScrollView(cc.size(534, 140), data.record, 1)
	end
end
function luckyFlopLogView:createSingle()
	local single = self.singleNode:clone()
	return single
end
function luckyFlopLogView:refreshSingle(parent, data)
	local bg = SoraDGetChildByName(parent, "Image_bg")
	bg:setVisible(parent:getTag() % 2 == 0)
	local textTitle = SoraDGetChildByName(parent, "Text_Title")
	local textTime = SoraDGetChildByName(parent, "Text_Time")
	local scrollView = SoraDGetChildByName(parent, "ScrollView_num")
	scrollView:setSwallowTouches(false)
	scrollView:removeAllChildren()
	scrollView = include("commonAutoScrollList").new(scrollView)
	scrollView:setSingleCreate(handler(self, self.createSingleLabel))
	scrollView:setSingleRefresh(handler(self, self.refreshSingleLabel))
	scrollView:setIsRight(SoraDFIsRA())
	scrollView:updateScrollView(cc.size(60, 30), data.luckyNumbers, 6, nil, SoraDFIsRA())
	textTime:setString(os.date("!%Y/%m/%d %H:%M:%S", data.time))
	_ENV = os.date("!%Y/%m/%d %H:%M:%S", data.time)
	os.date("!%Y/%m/%d %H:%M:%S", data.time).num = table.nums(data.luckyNumbers)
	textTitle:setString(i18n("luckyFlip_btn_01", os.date("!%Y/%m/%d %H:%M:%S", data.time)))
end
_ENV, _UPVALUE7_, luckyFlopLogView.createSingleLabel = function(target)
	return target or SoraDCreateTouchPanel("luckyFlopLogView")
end, function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end, function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end
;(function(target)
	return target or SoraDCreateTouchPanel("luckyFlopLogView")
end).headEnd = 4
_ENV, (function(target)
	return target or SoraDCreateTouchPanel("luckyFlopLogView")
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
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[1] = function(target)
	return target or SoraDCreateTouchPanel("luckyFlopLogView")
end
;(function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[2] = nil
;(function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[3] = nil
;(function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[4] = nil
;(function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[5] = nil
;(function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[6] = nil
local (function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end)[7], config = nil, function(self)
	local single = ccui.Text:create("", "", 22)
	single:setAnchorPoint(cc.p(0, 0))
	return single
end
function luckyFlopLogView:refreshSingleLabel(parent, data)
	local textNum = SoraDChangeTextToHtml(parent)
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
return luckyFlopLogView
