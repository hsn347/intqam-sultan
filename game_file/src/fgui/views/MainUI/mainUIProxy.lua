local baseProxy = require("fgui.base.baseProxy")
local mainUIProxy = class("mainUIProxy", baseProxy)
function mainUIProxy:onRegisterEvent()
	print("=======mainUIProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAIN_UI_HIDDLE", handler(self, self.setMainUIHiddle))
	SoraDAddMessage(self, "MESSAGE_MAIN_UI_ANIMATION", handler(self, self.playAnimation))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.reLoginFinish))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.changeMainScene))
	SoraDAddMessage(self, "MESSAGE_TRIGGER_SKILLS", handler(self, self.lordSkillEffect))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_REWARD", handler(self, self.msgNoticeCumuReward))
	SoraDAddMessage(self, "MESSAGE_EVALUATION_NOTIFY", handler(self, self.showEveluationView))
	SoraDAddMessage(self, "MESSAGE_HALLOWEEN_ACTION", handler(self, self.showHalloweenActionView))
	SoraDAddMessage(self, "MESSAGE_MAIN_AGREEMENT_BOX", handler(self, self.showAgreementBox))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_CASTLE_GIFT_POP_MSG", handler(self, self.msgCastleGift))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.castleLevelUp))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER", handler(self, self.refreshEventModule))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_EVENTREFRESH", handler(self, self.refreshEventModule))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.refreshEventModule))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_DEVICERANK_REFRESH", handler(self, self.refreshEventModule))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH", handler(self, self.refreshEventModule))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDayReset))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_UPDATE", handler(self, self.newChapterTaskOpen))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_WARNING_UPDATE", handler(self, self.updateWarning))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HP", handler(self, self.showLordHPChange))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_DISPATCH_ARMY", handler(self, self.showLordHPChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_START", handler(self, self.pyramidBattleStartFun))
	SoraDAddMessage(self, "MESSAGE_MAINCITYGUIDE_UPDATE_MAINUI", handler(self, self.setMainCityGuideUI))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.onMsgBuildStarUpgrade))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK", handler(self, self.onMsgBuildStarUpgrade))
end
function mainUIProxy:playAnimation(target, data)
	self.view:playAnimation()
end
function mainUIProxy:setMainUIHiddle(target, data)
	self.view:setMainUIHiddle(data)
end
function mainUIProxy:reLoginFinish(target, data)
	self.view:reLoginFinish(data)
end
function mainUIProxy:changeMainScene(target, data)
	self.view:changeMainScene(data)
end
function mainUIProxy:lordSkillEffect(target, data)
	self.view:lordSkillEffect(data)
end
function mainUIProxy:msgNoticeCumuReward(target, data)
	self.view:msgNoticeCumuReward(data)
end
function mainUIProxy:showEveluationView(target, data)
	self.view:showEveluationView(data)
end
function mainUIProxy:showHalloweenActionView(target, data)
	self.view:showHalloweenActionView(data)
end
function mainUIProxy:showAgreementBox(target, data)
	self.view:showAgreementBox(data)
end
function mainUIProxy:msgCastleGift(target, data)
	self.view:msgCastleGift(data)
end
function mainUIProxy:castleLevelUp(target, data)
	self.view:castleLevelUp(data)
end
function mainUIProxy:refreshEventModule(target, data)
	self.view:refreshEventModule(data)
end
function mainUIProxy:newDayReset(target, data)
	self.view:newDayReset(data)
end
function mainUIProxy:newChapterTaskOpen(target, data)
	self.view:newChapterTaskOpen(data)
end
function mainUIProxy:updateWarning(target, data)
	self.view:updateWarning(data)
end
function mainUIProxy:showLordHPChange(target, data)
	self.view:showLordHPChange(data)
end
function mainUIProxy:pyramidBattleStartFun()
	self.view:pyramidBattleStartFun()
end
function mainUIProxy:setMainCityGuideUI(target, data)
	self.view:setMainCityGuideUI(data.index)
end
function mainUIProxy:onMsgBuildStarUpgrade(target, event)
	local activityIDList = clientEventMgr.getStarLvLimitActivityIDList()
	_ENV = nil
	;(nil).activityID = activityIDList
	self.view:refreshEventModule(nil)
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:checkAllGuide()
end
return mainUIProxy
