local newExchangeMallRead = include("newExchangeMallRead")
local baseComponent = require("fgui.base.baseComponent")
local ComEventInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ComEventInfo", ComEventInfo)
function ComEventInfo:onInit()
	_ENV = nil
	_ENV = nil
	;(nil).timerY = 7
	;(nil).wholeX = 12
	;(nil)[gActivityTimeActivityID.EXCHANGE_MALL_PAY_DRESS_UP], (nil).subBg = nil, "bg_exchange_9001236_long.png"
	_ENV = nil
	;(nil).timerY = 7
	;(nil).wholeX = 12
	;(nil)[gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT_NEW], (nil).subBg = nil, "bg_exchange_9001180.png"
	_ENV = nil
	;(nil).timerY = 5
	self.specialDeal, (nil)[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY], (nil).wholeX = nil, nil, 0
	self.timer = self.fields.Label_timer
	self.fields.com_line:setVisible(false)
end
function ComEventInfo:isNewExchange(activityID)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.EXCHANGE_MALL_HYFL] = true
	local (nil)[gActivityTimeActivityID.EXCHANGE_MALL_ICEDRADON_MARCH], newExchangeID = true, nil
	return newExchangeID[activityID] or false
end
function ComEventInfo:initData(actID)
	if not newExchangeMallRead.getNewCfg(actID) then
		local newExchangeMallRead, newCfg = newExchangeMallRead.getNewCfg(actID), newExchangeMallRead.getNewCfg(actID)
	end
	local isNewExID = newCfg.new and newCfg.new == 1 or false
	self.isNewExID = isNewExID or self:isNewExchange(actID)
	self.fields.com_line:setVisible(self.isNewExID)
	if actID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		self.fields.Text_tip:setVisible(true)
		self.fields.Text_tip:setString(i18n("common_text_4865"))
	else
		self.fields.Text_tip:setVisible(false)
	end
end
function ComEventInfo:setTimeFont(size, color)
	local size = size or 20
	local color = color or cc.c3b(255, 255, 255)
	self.fields.Label_timer:setTimeFontSize(size)
	self.fields.Label_timer:setTimeColor(color)
end
function ComEventInfo:setTimeIconScale(scale)
	self.fields.Label_timer:setIconScale(scale)
end
function ComEventInfo:setTime(time)
	self.fields.Label_timer:beginTime(time)
end
function ComEventInfo:setTimeVisible(flag)
	if self.fields.com_line then
		self.fields.com_line:setVisible(self.isNewExID and flag)
	end
	self.fields.Label_timer:setVisible(flag)
end
function ComEventInfo:setBg(URL)
	self.fields.bg:setURL(URL)
end
function ComEventInfo:replaceBg(actID)
	if self.specialDeal[actID] and self.specialDeal[actID].subBg then
		self.fields.bg:setURL(self.specialDeal[actID].subBg)
	end
end
function ComEventInfo:setIcon(URL)
	self.fields.icon:setURL(URL)
end
function ComEventInfo:setIconScale(scaler)
	self.fields.icon:setScale(scaler)
end
function ComEventInfo:onShow()
end
function ComEventInfo:getLabelTimer(...)
	return self.fields.Label_timer
end
return ComEventInfo
