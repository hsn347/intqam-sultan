local baseProxy = require("fgui.base.baseProxy")
local HeroPayMoneyProxy = class("HeroPayMoneyProxy", baseProxy)
function HeroPayMoneyProxy:onRegisterEvent()
	print("=======HeroPayMoneyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_PAYSUCCESS", handler(self, self.paySuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO", handler(self, self.noticeHeroChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_SERVERNORMALFAIL", function(target, redata)
		SoraDCloseLoading(self.view)
	end)
end
function HeroPayMoneyProxy:refreshRes()
	self.view:refreshRes()
end
function HeroPayMoneyProxy:paySuccess()
	SoraDCloseLoading(self.view)
	SoraDShowMsgBox(i18n("hero_text_88"), i18n("common_text_204"))
	self.view:removeFromParent()
end
function HeroPayMoneyProxy:noticeHeroChange(target, redata)
	if redata and tonumber(redata.heroID) == self.view.heroJailInfo.heroID then
		SoraDRemoveAllAfterPanelFromManager(self.view, true)
		self.view.heroJailInfo = SoraDGetCtrl("heroJailCtrl"):getHerosInOtherPrisonByID(self.view.heroJailInfo.heroID)
		self.view:initView()
	end
end
return HeroPayMoneyProxy
