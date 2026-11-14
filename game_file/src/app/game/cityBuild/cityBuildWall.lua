local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local mainCityDefine = include("mainCityDefine")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildWall = class("cityBuildWall", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildWall:ctor()
	self.posEtUpgradeOffset = cc.p(10, -72)
end
function cityBuildWall:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_DEFENDWALL_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_SETLISTDENFEND", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEDEFEND", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_SETSINGLEDENFEND", handler(self, self.msgUpdateView))
end
function cityBuildWall:onAfterInitWithBuildCell()
	self:updateView()
end
function cityBuildWall:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildWall:updateView()
	self:updateIsLock()
	self:checkHasHeroSite()
end
function cityBuildWall:checkHasHeroSite()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	if self:getIsCanSpeedUpFree() then
		return
	elseif self:getIsNeedReqHelp() then
		return
	end
	local hasHeroSite = self:hasHeroSite()
	if hasHeroSite then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;(nil).buildIndex = self.buildIndex
		;(nil).buildEntity = self
		;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_DEFEND_EMPTYSITE
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		;(nil).buildIndex = self.buildIndex
		;(nil).buildEntity = self
		;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_DEFEND_EMPTYSITE
		SoraDSendMessage(nil)
	end
end
function cityBuildWall:hasHeroSite()
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local haveSite = false
	if cityCtrl:getCastleLevel() >= CASTLE_LV7_LIMITED and heroCtrl:isDefendEmptySite() and next(heroCtrl:getHeroInCastleNotDefend()) then
		haveSite = true
	end
	return haveSite
end
function cityBuildWall:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_102"), i18n("buildDes_name_102")
	i18n("buildDes_name_102").x = 20
	;(nil).pos, i18n("buildDes_name_102").y = i18n("buildDes_name_102"), -115
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildWall:updateViewModel()
	local bid = self:getBuildBid()
	local viewModel = self:getViewModel()
	if self.viewModel ~= viewModel then
		self.viewModel = viewModel
		self:updateViewByModel(viewModel)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_VIEW"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_TURRET_OFFSET"
		self.viewModel = self.viewModel
		SoraDSendMessage(self)
	end
end
function cityBuildWall:updateViewByModel(viewModel)
	local bid = self:getBuildBid()
	if bid ~= BUILDID.WALLS then
		return
	end
	if self.buildImg == nil then
		return
	end
	local imgName
	local offSetX = 0
	local offSetY = 0
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
		imgName = string.format("chengmen_lv%d.png", viewModel)
	end
	local spriteFrame = display.newSpriteFrame(imgName)
	if spriteFrame == nil then
		return
	end
	self.buildImg:setSpriteFrame(spriteFrame)
	self.buildImg:setPosition(cc.p(offSetX, offSetY))
end
function cityBuildWall:getViewModel()
	local tblViewModelCfg = cityBuildViewDef.tblViewModelWall
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		tblViewModelCfg = cityBuildViewDef.tblViewBZTModelWall
	end
	local lv = self:getBuildLv()
	return self:getViewModelByLv(lv, tblViewModelCfg)
end
function cityBuildWall:isCustomIdle()
	local isIdle = true
	if self:hasHeroSite() then
		isIdle = false
	end
	return isIdle
end
return cityBuildWall
