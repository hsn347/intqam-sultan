local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseProxy = require("fgui.base.baseProxy")
local FlyingStarWishProxy = class("FlyingStarWishProxy", baseProxy)
function FlyingStarWishProxy:onRegisterEvent()
	print("=======FlyingStarWishProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_FLYING_STAR_WISH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.initData))
end
function FlyingStarWishProxy:refreshView(target, data)
	if self.view then
		if data.subMsg == "init" then
			self.view:initData()
		elseif data.subMsg == "buySuccess" then
			flyingStarWishCtrl:clearBuyList()
			SoraDShowMsgTip(i18n("giftgiving_text_15"))
			self.view:playGiftAni()
			self.view:initData()
		elseif data.subMsg == "task" then
			self.view:updateBtnRed()
		elseif data.subMsg == "giveTimeEnd" then
			flyingStarWishCtrl:clearBuyList()
		end
	end
end
function FlyingStarWishProxy:initData()
	self.view:refreshPageInZero()
end
function FlyingStarWishProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FLYING_STAR_WISH) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return FlyingStarWishProxy
