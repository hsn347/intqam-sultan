local publicRead = include("publicRead")
local badgeExchangeCtrl = SoraDGetCtrl("badgeExchangeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_icon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CollegeView/Com_icon", Com_icon)
function Com_icon:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_icon:onShow()
end
function Com_icon:initData(costArray, selectID)
	self.resID = costArray.id
	self.resNum = costArray.count
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.resID))
	self.fields.title:setString(string.formatnumberthousands(self.resNum))
	local isEnough = badgeExchangeCtrl:getOwnCount(self.resID) >= self.resNum
	self.fields.title:setColor(isEnough and cc.c3b(240, 230, 210) or cc.c3b(224, 43, 43))
	local index = not ((not selectID or selectID ~= self.resID) and selectID) and 0 or 1
	self.controllers.c1:setSelectedIndex(index)
end
function Com_icon:runIconAct(ret)
	self.fields.icon:stopAllActions()
	self.fields.icon:setScale(1)
	if ret then
		local baseScale = 1
		_UPVALUE4_ = 1
		;(1)[1] = ffa.scaleTo(0.3, baseScale + 0.2)
		;(1)[2] = ffa.scaleTo(0.3, baseScale - 0.1)
		;(1)[3] = ffa.scaleTo(0.2, baseScale + 0.1)
		;(1)[4] = ffa.scaleTo(0.2, baseScale - 0.05)
		;(1)[5] = ffa.scaleTo(0.1, baseScale)
		;(1)[6] = ffa.scaleTo(0.1, baseScale)
		;(1)[7] = ffa.scaleTo(0.1, baseScale)
		local seq = ffa.seq(1)
		self.fields.icon:runAction(seq)
	end
end
function Com_icon:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_BADGEBOURSE_RES_SELECT"
	;(nil).exchangeID = self.resID
	SoraDSendMessage(nil)
end
return Com_icon
