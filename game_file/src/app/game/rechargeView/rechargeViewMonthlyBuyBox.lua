local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local RechargeViewMonthlyBuyBox = class("rechargeViewMonthlyBuyBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, "rechargeViewMonthlyBuyBox"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableBg = "frame_item_base_05.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableIcon = "icon_monthcard_30.png"
_ENV, ("rechargeViewMonthlyBuyBox")[11485], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableName = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, "monthCard_name_03"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableBg = "frame_item_base_05.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableIcon = "icon_monthcard_30.png"
_ENV, ("rechargeViewMonthlyBuyBox")[14080], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableName = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, "monthCard_name_03"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableBg = "frame_item_base_03.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableIcon = "icon_monthcard_15.png"
_ENV, ("rechargeViewMonthlyBuyBox")[12934], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableName = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, "monthCard_name_02"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableBg = "frame_item_base_03.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableIcon = "icon_monthcard_7.png"
monthCardInfo, ("rechargeViewMonthlyBuyBox")[12933], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end).tableName = "rechargeViewMonthlyBuyBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeViewMonthlyBuyBox")
	end
	return target
end, "monthCard_name_01"
function RechargeViewMonthlyBuyBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.canRenew = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2460"))
	self.tableSinge = SoraDGetChildsArrayByName(self, "Node_single_", 3, 1, false)
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelTime = SoraDCreateTimerLabel(self, self.labelTime)
	self:initView()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", function(...)
		self:removeFromParent()
	end)
end
function RechargeViewMonthlyBuyBox:initView()
	self.monthData = rechargeActivityCtrl:getMonthActivityList()
	dump(self.monthData, "slkdjflksjdlfkjs")
	local rechargeActivityCtrl, monthList = dump, dump
	local isOpen = false
	for k, v in pairs(self.monthData) do
		if tonumber(k) == 14080 then
			isOpen = true
		end
	end
	for k, v in pairs(self.monthData) do
		if isOpen and tonumber(k) ~= 11485 then
			table.insert(monthList, v)
		elseif not isOpen then
			table.insert(monthList, v)
		end
	end
	for i, v in ipairs(monthList) do
		v.sortWeight = 0
		if v.ID == 14080 or v.ID == 11485 then
			v.sortWeight = 1
		end
	end
	table.sort(monthList, function(l, r)
		if l.sortWeight == r.sortWeight then
			return l.ID > r.ID
		else
			return l.sortWeight > r.sortWeight
		end
	end)
	dump(monthList, "iorutoiruoieru")
	self.canRenew = monthList[1].canRenew
	for i, v in ipairs(monthList) do
		self:initSingleView(i, v)
	end
	self.nodeTime:setVisible(self.canRenew)
	if self.canRenew then
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(monthList[1].ID)
		self.labelTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_4179", nil)
		end)
		self.labelTime:beginTime(leftTime)
	end
	self.ccs_bg:setSize(self.canRenew and cc.size(542, 485) or cc.size(542, 450))
	self.ccs_bg:setPositionY(self.canRenew and -260 or -225)
end
function RechargeViewMonthlyBuyBox:initSingleView(index, data)
	local info = monthCardInfo[data.ID]
	local single = self.tableSinge[index]
	local btn = single:getChildByName("Button_buy")
	local icon = single:getChildByName("Image_icon")
	local name = single:getChildByName("Text_name")
	local bg = single:getChildByName("Image_quality")
	local gold = single:getChildByName("Node_gold")
	local title = gold:getChildByName("Text_title")
	local labelGole = gold:getChildByName("Text_gold")
	local Node_monthCard = btn:getChildByName("Node_monthCard")
	local Sprite_item = single:getChildByName("Sprite_item")
	local textTime = single:getChildByName("Text_stime")
	SoraDAutoSizeButtonText(btn, cc.size(150, 60))
	btn:addTouchEventListener(handler(self, self.giftBuy))
	btn:setTag(data.ID)
	icon:loadTexture(info.tableIcon, ccui.TextureResType.plistType)
	bg:loadTexture(info.tableBg, ccui.TextureResType.plistType)
	name:setString(i18n(info.tableName))
	local showPrice = paymentManager.judgePrice(data.ID, data.price)
	btn:setTitleText(showPrice)
	if data.ID == 14080 then
		btn:setTitleText("")
		if Node_monthCard then
			local originPrice = paymentManager.judgePrice(11485, 19.99)
			Node_monthCard:setVisible(true)
			local Text_now = Node_monthCard:getChildByName("Text_now")
			local Text_origin = Node_monthCard:getChildByName("Text_origin")
			Text_now:setString(showPrice)
			Text_origin:setString(originPrice)
			Text_origin:setFontSize(16)
			Text_now:setFontSize(20)
			Sprite_item:setVisible(true)
			local txtSale = Sprite_item:getChildByName("BitmapFontLabel_3")
			txtSale:setString("50 OFF")
			textTime:setVisible(true)
			local labelTime = SoraDCreateTimerLabel(self, textTime)
			local leftTime = data.endtime - serviceFunctions.systemTime()
			labelTime:setTimeLast(function(ticket, timeNumber)
				if timeNumber <= 0 then
					self:removeFromParent()
				end
				self = nil
				;(nil).time = ticket
				return i18n("common_text_766", nil)
			end)
			labelTime:beginTime(leftTime)
		end
	else
		textTime:setVisible(false)
	end
	if index == 1 and (data.ID == 14080 or data.ID == 11485) then
		local coolSquare = include("effectUI").getCoolSuqare()
		coolSquare:setPosition(48, 53)
		coolSquare:setScale(1.2)
		coolSquare:addTo(single:getChildByName("Image_frm"), 9)
	end
	gold:setVisible(self.canRenew)
	name:setPositionY(self.canRenew and 32 or 0)
	title:setString(i18n("rechare_text_01"))
	labelGole:setString(string.formatnumberthousands(data.renewalsgift[2]))
	single:setVisible(true)
end
function RechargeViewMonthlyBuyBox:giftBuy(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ID = button:getTag()
		paymentManager.normalGiftBuyClassify(ID)
		paymentManager.OnemtReadyBuy(ID, gRechargeActiveFromEnum.ROAD04, false)
	end
end
return RechargeViewMonthlyBuyBox
