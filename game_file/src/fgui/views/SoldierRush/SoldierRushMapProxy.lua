local baseProxy = require("fgui.base.baseProxy")
local SoldierRushMapProxy = class("SoldierRushMapProxy", baseProxy)
function SoldierRushMapProxy:onRegisterEvent()
	print("=======SoldierRushMapProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_RESTART_GAME", handler(self, self.reStartGame))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_END_GAME", handler(self, self.endGame))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_CONTINUE_GAME", handler(self, self.onGameContinue))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_SKILL_INFO", handler(self, self.showSkillInfo))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_ARROW", handler(self, self.showArrow))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_DISPATCH_ARMY", handler(self, self.showArmy))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_BUILD_MENU", handler(self, self.menuShow))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_GUIDE_OCCUPY", handler(self, self.guideOccupy))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_BUILD_UPGRADE", handler(self, self.upgradeBuild))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_BUILD_CHANGE", handler(self, self.changeBuild))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_GUIDE_UPGRADE", handler(self, self.guideUpgradeBuild))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_HIDE_MINE_GUIDE", handler(self, self.hideMineGuideArrow))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_CONTINUE_PLAY", handler(self, self.continuePlay))
end
function SoldierRushMapProxy:reStartGame(target, data)
	self.view:reStartGame(target, data)
end
function SoldierRushMapProxy:endGame(target, data)
	self.view:endGame(target, data)
end
function SoldierRushMapProxy:onGameContinue(target, data)
	self.view:onGameContinue(target, data)
end
function SoldierRushMapProxy:showSkillInfo(target, data)
	self.view:showSkillInfo(target, data)
end
function SoldierRushMapProxy:showArrow(target, data)
	self.view:showArrow(target, data)
end
function SoldierRushMapProxy:showArmy(target, data)
	self.view:showArmy(target, data)
end
function SoldierRushMapProxy:upgradeBuild(target, data)
	self.view:upgradeBuild(target, data)
end
function SoldierRushMapProxy:changeBuild(target, data)
	self.view:changeBuild(target, data)
end
function SoldierRushMapProxy:menuShow(target, data)
	self.view:menuShow(target, data)
end
function SoldierRushMapProxy:guideOccupy(target, data)
	self.view:guideOccupy(target, data)
end
function SoldierRushMapProxy:guideUpgradeBuild(target, data)
	self.view:guideUpgradeBuild(target, data)
end
function SoldierRushMapProxy:hideMineGuideArrow(target, data)
	self.view:hideMineGuideArrow(target, data)
end
function SoldierRushMapProxy:continuePlay(target, data)
	self.view:continuePlay(target, data)
end
return SoldierRushMapProxy
