local activity_9001655_Read = include("activity_9001655_Read")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_starSign = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001655/Com_starSign", Com_starSign)
function Com_starSign:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:setTouchEnabled(false)
end
function Com_starSign:onShow()
end
function Com_starSign:init(style, isMine)
	self:setTouchEnabled(false)
	self.fields.starSign:setSpriteFrame(activity_9001655_Read.getStarSignPng(style))
	self.controllers.c1:setSelectedIndex(isMine and 2 or 0)
end
function Com_starSign:initData(position)
	self.controllers.c1:setSelectedIndex(1)
	local item = activity_9001655_Read.getRewardByPos(position)
	self.id = item.id
	self.num = item.count
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.id))
	self:setTouchEnabled(true)
end
function Com_starSign:onLongPress(button, startPos, endPos)
	if self.id and self.num then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		;(nil).id = self.id
		;(nil).num = self.num
		;(nil).pos = startPos
		SoraDSendMessage(nil)
	end
end
return Com_starSign
