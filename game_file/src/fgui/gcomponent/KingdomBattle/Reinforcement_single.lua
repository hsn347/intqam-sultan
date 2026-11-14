local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Reinforcement_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Reinforcement_single", Reinforcement_single)
function Reinforcement_single:onInit()
	self:fixChildrenPos()
	self.fields.Image_bust:addClickListener(handler(self, self.onClickHead))
end
function Reinforcement_single:onShow()
end
function Reinforcement_single:initData(data)
	self.uid = data.uid
	self.kid = data.kid
	self.fields.Image_bust:setURL(lordLocalData.getBust(data.iconID))
	self.fields.Text_name:setString(textParser.formatPlayerName(data.abbr, data.nickName, data.kid))
	self.fields.Text_power:setString(string.formatnumberthousands(data.strength))
	self.fields.Com_CastleLv:initData(data.cityLevel, data.starLv)
end
function Reinforcement_single:onClickHead()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.uid
	;(nil).kid = self.kid
	SoraDSendMessage(nil)
end
return Reinforcement_single
