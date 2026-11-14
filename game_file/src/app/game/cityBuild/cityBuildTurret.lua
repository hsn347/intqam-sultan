local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildWallDef = include("cityBuildWallDef")
local mainCityDefine = include("mainCityDefine")
local cityBuildTurret = class("cityBuildTurret", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildTurret:ctor()
	self.posEtUpgradeOffset = cc.p(0, -10)
end
function cityBuildTurret:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_103"), i18n("buildDes_name_103")
	i18n("buildDes_name_103").x = 0
	;(nil).pos, i18n("buildDes_name_103").y = i18n("buildDes_name_103"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildTurret:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_TURRET_OFFSET", handler(self, self.msgUpdateTurretOffset))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_LOCK_TURRET", handler(self, self.hideLock))
end
function cityBuildTurret:updateViewModel()
	local bid = self:getBuildBid()
	local viewModel = self:getViewModel()
	if self.viewModel ~= viewModel then
		self.viewModel = viewModel
		self:updateViewByModel(viewModel)
	end
end
function cityBuildTurret:updateViewByModel(viewModel)
	local bid = self:getBuildBid()
	if bid ~= BUILDID.TURRET then
		return
	end
	if self.buildImg == nil then
		return
	end
	local imgName
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
		imgName = string.format("jianta_lv%d_ex.png", viewModel)
	end
	local spriteFrame = display.newSpriteFrame(imgName)
	if spriteFrame == nil then
		return
	end
	self.buildImg:setSpriteFrame(spriteFrame)
	self:updateLvPos()
end
function cityBuildTurret:getViewModel()
	local tblViewModelCfg = cityBuildViewDef.tblViewModelWall
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		tblViewModelCfg = cityBuildViewDef.tblViewBZTModelWall
	end
	local lv = self:getBuildLv()
	local buildIndex = 1053
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCellByIndex(buildIndex)
	if buildCell ~= nil then
		lv = tonumber(buildCell.info.lv)
	end
	return self:getViewModelByLv(lv, tblViewModelCfg)
end
function cityBuildTurret:msgUpdateTurretOffset(target, data)
	local targetViewModel = data.viewModel
	if targetViewModel == nil then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local wallLv = cityCtrl:getBuildMaxLv(BUILDID.WALLS)
	local tblViewModelCfg = cityBuildViewDef.tblViewModelWall
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		tblViewModelCfg = cityBuildViewDef.tblViewBZTModelWall
	end
	local wallModel = cityBuildViewDef.getViewModelByLv(wallLv, tblViewModelCfg)
	local dir = "left"
	local buildIndex = self:getBuildIndex()
	if buildIndex == 1054 then
		dir = "right"
	end
	local offset = cityBuildWallDef.getJiantaOffset(wallModel, dir)
	self:updateNodeOffsetByName("buildImg", offset)
	self:updateViewModel()
end
function cityBuildTurret:showLock()
	local buildIndex = self:getBuildIndex()
	_ENV = nil
	;(nil).msg = "MESSAEG_MANCITYYVIEW_SHOW_TURRET_LOCK"
	;(nil).buildIndex = buildIndex
	SoraDSendMessage(nil)
	print("箭塔隐藏了等级牌子")
	self:hideBuildLv()
end
function cityBuildTurret:hideLock()
	local buildIndex = self:getBuildIndex()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_HDIE_TURRET_LOCK"
	;(nil).buildIndex = buildIndex
	SoraDSendMessage(nil)
	print("箭塔显示了等级牌子")
	self:showBuildLv()
	self:updateLvPos()
end
return cityBuildTurret
