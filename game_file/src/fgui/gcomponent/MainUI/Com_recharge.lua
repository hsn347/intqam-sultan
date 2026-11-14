local effectEventGift = include("effectEventGift")
local baseComponent = require("fgui.base.baseComponent")
local Com_recharge = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_recharge", Com_recharge)
function Com_recharge:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.Text_rechargeTime)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_recharge:onShow()
end
function Com_recharge:setTime(time)
	self.Text_Time:beginTime(time)
end
function Com_recharge:setName(name)
	self.Text_Time:endTime()
	self.Text_Time:setString(name)
end
function Com_recharge:setModel(eType, eventIndex)
	self.eventIndex = eventIndex
	local giftNode = effectEventGift.getGiftNode(eType)
	self.fields.Loader3D:clearContent()
	giftNode:setPositionX(50)
	self.fields.Loader3D:setContent(giftNode)
end
function Com_recharge:onBtnClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).id = tonumber(self.eventIndex)
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
		uiManager:show("rechargePopFrame", nil)
	else
		local panel = SoraDCreatePanel("rechargePopFrame")
		panel:initData(tonumber(self.eventIndex), gRechargeActiveFromEnum.ROAD01)
		panel:show()
	end
	_ENV = panel.show
	panel.show.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(panel.show)
end
return Com_recharge
