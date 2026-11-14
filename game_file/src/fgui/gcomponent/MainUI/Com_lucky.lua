local effectEventGift = include("effectEventGift")
local baseComponent = require("fgui.base.baseComponent")
local Com_lucky = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_lucky", Com_lucky)
function Com_lucky:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.Text_luckyTime)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Label_reddot:fixPos()
end
function Com_lucky:onShow()
end
function Com_lucky:setTime(time)
	self.Text_Time:beginTime(time)
end
function Com_lucky:setName(name)
	self.Text_Time:endTime()
	self.Text_Time:setString(name)
end
function Com_lucky:setModel(eType, eventIndex)
	self.eventIndex = eventIndex
	local giftNode = effectEventGift.getGiftNode(eType)
	self.fields.Loader3D:clearContent()
	self.fields.Loader3D:setContent(giftNode)
end
function Com_lucky:setRed(num)
	self.fields.Label_reddot:initData(0 < num, num)
end
function Com_lucky:onBtnClick()
	SoraDPlaySound("uicontrol", 18)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_lucky_gift)
	self:popLuckyFrame()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(self)
end
function Com_lucky:popLuckyFrame()
	local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
	local newLuckyGift = luckyGiftCtrl:getNewLuckyGiftData()
	if next(newLuckyGift) ~= nil then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).id = newLuckyGift.luckyGiftID
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD02
			uiManager:show("rechargePopFrame", nil)
		else
			local panel = SoraDCreatePanel("rechargePopFrame")
			panel:initData(newLuckyGift.luckyGiftID, gRechargeActiveFromEnum.ROAD02)
			panel:show()
		end
	end
end
return Com_lucky
