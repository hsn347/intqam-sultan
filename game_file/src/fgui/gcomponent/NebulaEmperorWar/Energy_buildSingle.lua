local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaWarRead = include("nebulaWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Energy_buildSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperorWar/Energy_buildSingle", Energy_buildSingle)
function Energy_buildSingle:onInit()
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.fields.Text_tip:setString(i18n("nebulaemperor_text_110"))
	self.fields.Button_tip:addClickListener(handler(self, self.onClickBtnTip))
	self.fields.Text_noPlayer:setString(i18n("nebulaemperor_text_109"))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.icon:fix()
	end
end
function Energy_buildSingle:onShow()
end
function Energy_buildSingle:onClickBtnGo(EventContext)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		if not worldMapDefine.isInNebulaAllStar(true) then
			SoraDShowMsgTip(i18n("NebulaAllstar_298"))
			return
		end
		local buildPos = nebulaAllStarRead.getBuildPos(self.buildID)
		SoraDGotoWorldMapPoint(buildPos, true)
		SoraDRemoveAllPanelFromManager()
	else
		if not worldMapDefine.isInNebulaEmperor() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_218"))
			return
		end
		local buildPos = nebulaEmperorRead.getBuildPos(self.buildID)
		SoraDGotoWorldMapPoint(buildPos, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function Energy_buildSingle:onClickBtnTip(EventContext)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		SoraDShowHelpMsgTip(i18n("NebulaAllstar_291"))
	else
		local build1 = nebulaEmperorRead.getBuildNameByType(gWorldTypeServerDef.subTypeNebulaEmperorWarPalace)
		local build2 = nebulaEmperorRead.getBuildNameByType(gWorldTypeServerDef.subTypeNebulaEmperorWarTower)
		_ENV = i18n("NebulaAllstar_291")
		i18n("NebulaAllstar_291").build1 = build1
		i18n("NebulaAllstar_291").build2 = build2
		local msgTip = i18n("nebulaemperor_text_111", i18n("NebulaAllstar_291"))
		SoraDShowHelpMsgTip(msgTip)
	end
end
function Energy_buildSingle:initData(data, activityID)
	self.buildID = data.buildID
	self.activityID = activityID
	local _ENV, cfg = data.buildID, data.buildID
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		cfg = nebulaAllStarRead.getBuildConfig(self.buildID)
		local buildIcon = nebulaAllStarRead.getBuildImage(self.buildID)
		self.fields.icon:setURL(buildIcon)
	else
		cfg = nebulaEmperorRead.getBuildConfig(self.buildID)
	end
	self.fields.Text_name:setString(i18n(cfg.name))
	_ENV = i18n(cfg.name)
	i18n(cfg.name).x = cfg.x
	i18n(cfg.name).y = cfg.y
	self.fields.Text_pos:setString(i18n("common_text_2155", i18n(cfg.name)))
	local ctrl
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		ctrl = nebulaAllStarCtrl
	else
		ctrl = nebulaEmperorCtrl
	end
	if ctrl:getStartPalaceWar() then
		self.controllers.c1:setSelectedIndex(1)
	else
		local owner = ctrl:getBuildOwner(self.buildID)
		if owner then
			self.controllers.c1:setSelectedIndex(0)
			local regionId = owner.camp
			local abbr
			if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
				abbr = nebulaWarRead.getAreaAbbr(regionId)
			else
				abbr = owner.teamAbbr
			end
			_ENV = i18n("common_text_2155", i18n(cfg.name))
			i18n("common_text_2155", i18n(cfg.name)).abbr = abbr
			i18n("common_text_2155", i18n(cfg.name)).name = owner.name
			local player = i18n("common_text_186", i18n("common_text_2155", i18n(cfg.name)))
			self.fields.Text_player:setString(player)
			local teamName = nebulaEmperorUtil.getTeamNameRaw(regionId)
			local areaIcon = nebulaEmperorUtil.getAreaIcon(regionId)
			self.fields.Text_team:setString(teamName)
			self.fields.Load_region:setURL(areaIcon)
			local nameColor
			if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
				nameColor = nebulaAllStarRead.getCampColorRGB(regionId)
			else
				local relationType = nebulaEmperorUtil.getRelationType(regionId)
				nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
			end
			self.fields.Text_player:setColor(nameColor)
			self.fields.Text_team:setColor(nameColor)
		else
			self.controllers.c1:setSelectedIndex(2)
		end
	end
end
return Energy_buildSingle
