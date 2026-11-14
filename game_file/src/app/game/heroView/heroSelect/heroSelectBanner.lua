local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local HeroSelectBanner = class("heroSelectBanner", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroSelectBanner")
	end
	return target
end)
function HeroSelectBanner:ctor()
	self.isHideAllExtendUI = false
	self.myMode = gHeroSelectBannerStyle.inner
	self.totalHeight = 0
	_ENV, self.curDivineBeastList, _ENV, self.curHeroList, _ENV, self.curArtifactList, _ENV, self.unLockNum = gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, 0
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_NORMAL] = true
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_DEAD] = false
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_CAPTURED] = false
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_BATTLE] = false
	gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_DEFEND] = true
	self.stateList, gHeroSelectBannerStyle.inner[gHeroState.HERO_STATE_ESCAPE] = gHeroSelectBannerStyle.inner, false
	self.items = SoraDGetChildsArrayByName(self, "CCS_heroLockItem_", 5, 1, true, true)
	self.artifact = SoraDGetExtendChildFromCCSByName(self, "CCS_artifactSelectBtn_artifact")
	self.isTacticOpen = heroltCtrl:getIsHeroTacticOpen()
	self.tacticNode = SoraDGetExtendChildFromCCSByName(self, "CCS_heroTacticsBanner")
	self.tacticNode:setVisible(self.isTacticOpen and not self.isHideAllExtendUI)
	self.isLieutenantShow = false
	self.lieutenantNode = SoraDGetExtendChildFromCCSByName(self, "CCS_heroLieutenantBanner")
	self.lieutenantNode:setParent(self)
	self.lieutenantNode:setLieutAddCallBack(handler(self, self.lieutAddCallBack))
	self.lieutenantNode:setVisible(false)
	self.isDivineBeastShow = false
end
function HeroSelectBanner:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.stateChange))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.collegeChage))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_SELECT", handler(self, self.selectEquipBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_DIVINEBEAST_SELECT", handler(self, self.selectDivineBeastBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.refreshPanel))
end
function HeroSelectBanner:setMode(mode, args)
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
		self.openSites = heroCtrl:getMaxBattleHeroNum()
		self.stateList[gHeroState.HERO_STATE_BATTLE] = true
		self.stateList[gHeroState.HERO_STATE_ESCAPE] = true
		self:initBeforeView(self.openSites)
		_ENV = self.openSites
		self:initHeros(self.openSites)
		self.artifact:setVisible(false)
		for i, v in ipairs(self.items) do
			v:setScale(1)
			v:setPositionX(SoraDFSign(250 - (i - 1) * 125))
		end
		self.lieutenantNode:fitEpicDispatchView()
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
	self.lieutenantNode:setFilteHeroState(self.stateList)
	self:initArtifactNode()
end
function HeroSelectBanner:initBeforeView(unLockNum)
	for i, v in ipairs(self.items) do
		v:setShowMilitaryStatus(gHeroSelectBannerStyle.dispatch == self.myMode)
		if i <= unLockNum then
			v:initData(gHeroItemLockStyle.none)
			v:setRemoveClick(handler(self, self.removeHeroFun))
			v:setAddClick(handler(self, self.setAddCallBack))
		else
			v:initData(gHeroItemLockStyle.lock)
			v:setAddClick(handlerEx(self, self.setLockCallBack, i))
		end
		v:setFilteHeroState(self.stateList)
	end
	self.unLockNum = math.min(unLockNum, gHeroDispatchSite)
end
function HeroSelectBanner:initHeros(heros, arms, isCopy, lieutenantList, divineBeasts)
