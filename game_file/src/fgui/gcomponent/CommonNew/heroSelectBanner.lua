local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local epicWarCtrl = SoraDGetCtrl("epicWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local heroSelectBanner = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/heroSelectBanner", heroSelectBanner)
function heroSelectBanner:onInit()
	self.isHideAllExtendUI = false
	self.myMode = gHeroSelectBannerStyle.inner
	self.totalHeight = 145
	self.massHeight = 0
	_ENV, self.curDivineBeastList, _ENV, self.curHeroList, _ENV, self.curArtifactList, _ENV, self.unLockNum = gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, 0
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_NORMAL] = true
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_DEAD] = false
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_CAPTURED] = false
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_BATTLE] = false
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_DEFEND] = true
	self.stateList, gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_ESCAPE] = gHeroSelectBannerStyle.inner, false
	self.isLieutenantShow = false
	self.fields.lieutenant:setParent(self)
	self.fields.lieutenant:setLieutAddCallBack(handler(self, self.lieutAddCallBack))
	self.controllers.c2:setSelectedIndex(0)
	self.isDivineBeastShow = false
end
function heroSelectBanner:onShow()
end
function heroSelectBanner:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.stateChange))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.collegeChage))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_SELECT", handler(self, self.selectEquipBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_DIVINEBEAST_SELECT", handler(self, self.selectDivineBeastBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.refreshPanel))
end
function heroSelectBanner:setMode(mode, args)
	self.myMode = mode
	if gHeroSelectBannerStyle.dispatch == self.myMode then
		self.stateList[gHeroState.HERO_STATE_GARRISON] = true
		self.openSites = heroCtrl:getMaxBattleHeroNum()
		self:initBeforeView(self.openSites)
		_ENV = self.openSites
		self:initHeros(self.openSites)
		self:updateGuide()
	elseif gHeroSelectBannerStyle.setteam == self.myMode then
		self.openSites = heroCtrl:getMaxBattleHeroNum()
		self.stateList[gHeroState.HERO_STATE_BATTLE] = true
		self.stateList[gHeroState.HERO_STATE_ESCAPE] = true
		self:initBeforeView(self.openSites)
		_ENV = self.openSites
		self:initHeros(self.openSites)
	elseif gHeroSelectBannerStyle.defend == self.myMode then
		self.openSites = heroCtrl:getMaxBattleHeroNum()
		self:initBeforeView(self.openSites)
		self:initHeros(heroCtrl:getHeroInDefend())
	elseif gHeroSelectBannerStyle.epicDispatch == self.myMode then
	elseif gHeroSelectBannerStyle.arena == self.myMode then
		self.openSites = heroCtrl:getMaxBattleHeroNum()
		self.stateList[gHeroState.HERO_STATE_BATTLE] = true
		self.stateList[gHeroState.HERO_STATE_ESCAPE] = true
		self:initBeforeView(self.openSites)
		_ENV = self.openSites
		self:initHeros(self.openSites)
	elseif gHeroSelectBannerStyle.walldefteam == self.myMode then
		self.openSites = heroCtrl:getMaxBattleHeroNum()
		self.stateList[gHeroState.HERO_STATE_BATTLE] = true
		self.stateList[gHeroState.HERO_STATE_ESCAPE] = true
		self:initBeforeView(self.openSites)
		_ENV = self.openSites
		self:initHeros(self.openSites)
	elseif gHeroSelectBannerStyle.inner == self.myMode then
	end
	if self.fields.lieutenant:isVisible() then
		self.fields.lieutenant:setFilteHeroState(self.stateList)
	end
	self:initArtifactNode()
end
function heroSelectBanner:initBeforeView(unLockNum)
	for i = 1, self.fields.List_hero:getNumItems() do
		local heroSlot = self.fields.List_hero:getChildAt(i - 1)
		heroSlot:setShowMilitaryStatus(gHeroSelectBannerStyle.dispatch == self.myMode)
		if i <= unLockNum then
			heroSlot:initData(gHeroItemLockStyle.none)
			heroSlot:setRemoveClick(handler(self, self.removeHeroFun))
			heroSlot:setAddClick(handler(self, self.setAddCallBack))
		else
			heroSlot:initData(gHeroItemLockStyle.lock)
			heroSlot:setAddClick(handlerEx(self, self.setLockCallBack, i))
		end
		heroSlot:setFilteHeroState(self.stateList)
	end
	self.unLockNum = math.min(unLockNum, gHeroDispatchSite)
end
function heroSelectBanner:initHeros(heros, arms, isCopy, lieutenantList, divineBeasts)
