local baseProxy = require("fgui.base.baseProxy")
local newHeroDetailViewProxy = class("newHeroDetailViewProxy", baseProxy)
function newHeroDetailViewProxy:onRegisterEvent()
	print("=======newHeroDetailViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_HERODETAIL_SKILL_STUDY", handler(self, self.uiSkillStudy))
	SoraDAddMessage(self, "MESSAGE_UI_HERODETAIL_SKILLPOP", handler(self, self.uiSkillPop))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.upgradeBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STARTUPGRADE", handler(self, self.upgradeBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_FEEDHEROSUCCESS", handler(self, self.feedHeroBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_RESURGENCESUCCESS", handler(self, self.resurgenceBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.noticeRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO", handler(self, self.jailNoticeRefresh))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_RECRUITSUCCESS", handler(self, self.recruitSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_EXCHANGE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORYTASK_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORY_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_WEAR", handler(self, self.initHeadSpine))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GET_EXTRA_SUCCESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_WEAPON_WEAR", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_HERO_NEW_TRIAL_UPDATE", handler(self, self.onMsgUpdateHeroNewTrial))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STAGE_GIFT", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_WEAPON_WEAR", handler(self, self.updateView))
end
function newHeroDetailViewProxy:uiSkillStudy(target, data)
	self.view:uiSkillStudy(target, data)
end
function newHeroDetailViewProxy:uiSkillPop(target, data)
	self.view:uiSkillPop(data)
end
function newHeroDetailViewProxy:recruitSuccess(target, data)
	self.view:updateView()
	_ENV = nil
	;(nil).heroID = data.heroID
	uiManager:show("HeroGainHeroView", nil)
end
function newHeroDetailViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function newHeroDetailViewProxy:initHeadSpine(target, data)
	self.view:initHeadSpine()
end
function newHeroDetailViewProxy:feedHeroBack(target, data)
	self.view:feedHeroBack(data)
end
function newHeroDetailViewProxy:upgradeBack(target, data)
	self.view:upgradeBack()
end
function newHeroDetailViewProxy:resurgenceBack(target, data)
	self.view:resurgenceBack()
end
function newHeroDetailViewProxy:noticeRefresh(target, data)
	self.view:noticeRefresh(data)
end
function newHeroDetailViewProxy:jailNoticeRefresh(target, data)
	self.view:jailNoticeRefresh()
end
function newHeroDetailViewProxy:recevieItemChangeMsg(target, data)
	self.view:recevieItemChangeMsg(data)
end
function newHeroDetailViewProxy:onMsgUpdateHeroNewTrial(...)
	self.view:onMsgUpdateHeroNewTrial(...)
end
return newHeroDetailViewProxy
