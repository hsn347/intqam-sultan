local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local RomanSoulNewProxy = class("RomanSoulNewProxy", baseProxy)
function RomanSoulNewProxy:onRegisterEvent()
	print("=======RomanSoulNewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_EVENTREFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ROMAN_POINT_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ROMAN_POINT_UPDATE", handler(self, self.initData))
end
function RomanSoulNewProxy:initData()
	if self and self.view then
		self.view:initData()
	end
end
return RomanSoulNewProxy
