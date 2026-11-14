local vipLocalData = include("vipLocalData")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_VIP = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_VIP", Btn_VIP)
function Btn_VIP:onInit()
	self.fields.et_vip:setAllFrameName("dh_zjmjinbik_%.2d.png", 1)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_VIP:onShow()
end
function Btn_VIP:initData()
	local data = lordInfoCtrl:getVip()
	local vipLv = data[1]
	local isActive = data[2]
	self.fields.title:setString(vipLocalData:getVipSmallFntChar(vipLv))
	if isActive then
		self.controllers.c1:setSelectedIndex(1)
		if vipLv >= VIP_LV5_LIMITED and not lordInfoCtrl:vipDailyGiftBeGot() then
			self.fields.Sprite_red:setVisible(true)
		else
			self.fields.Sprite_red:setVisible(false)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_VIP:onBtnClick()
	SoraDPlaySound("uicontrol", 22)
	uiManager:show("vipCenterView")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(uiManager)
end
return Btn_VIP
