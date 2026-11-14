local gametop = gModuleMgr.getObject("gametop")
local worldLodDef = worldMapDefine.worldLodDef
local nebulaWarRead = include("nebulaWarRead")
local worldMapNebulaLodUI = class("worldMapNebulaLodUI", function()
	return SoraDCreateBasePanel("worldMapNebulaLodUI")
end)
function worldMapNebulaLodUI:ctor()
	self.lodNodeList, _UPVALUE0_ = nil, nil
	self:initWidget()
end
function worldMapNebulaLodUI:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.lodMap = include("worldMapComLodMap").new(self.Panel_info)
	_UPVALUE5_ = self.Panel_info
	self.Panel_info[1] = "Node_camp_Single"
	self.Panel_info[2] = "Node_super"
	self.Panel_info[3] = "Text_occupy1"
	self.Panel_info[4] = "Text_occupy2"
	self.Panel_info[5] = "Node_normal"
	for i, v in ipairs(self.Panel_info) do
		local widget = self[v]
		if widget then
			widget:setVisible(false)
		end
	end
	self:initNodeInfo()
end
function worldMapNebulaLodUI:initLodConfig(...)
	local config = self:getLodConfig()
	for i, v in ipairs(config) do
		if v.widget then
			local widget = SoraDCreatePanelByCloneNode(v.widget, "commonLODInstance")
			widget:initLODData(v)
			table.insert(self.lodNodeList, widget)
		end
	end
end
function worldMapNebulaLodUI:getLodConfig(...)
	local _ENV, config
	_ENV = nil
	;(nil).widget = self.lodMap
	;(nil).showLodMin = worldLodDef.LOD2
	;(nil).offset = cc.p(SoraDFSign(200), 0)
	table.insert(config, nil)
	_ENV = nil
	;(nil).widget = self.Node_mapInfo
	;(nil).showLodMin = worldLodDef.LOD2
	;(nil).offset = cc.p(SoraDFSign(-120), 0)
	table.insert(config, nil)
	return config
end
function worldMapNebulaLodUI:initNodeInfo(...)
	_ENV, _UPVALUE12_ = nil, nil
	;(nil).buildType = gWorldTypeServerDef.subTypeNebulaWarPalace
	_ENV, (nil).isTitle = gWorldTypeServerDef.subTypeNebulaWarPalace, true
	gWorldTypeServerDef.subTypeNebulaWarPalace.buildType = gWorldTypeServerDef.subTypeNebulaWarPalace
	gWorldTypeServerDef.subTypeNebulaWarPalace.title = i18n("nebula_war_text_0304")
	_ENV, gWorldTypeServerDef.subTypeNebulaWarPalace.color = cc.c3b(125, 125, 125), cc.c3b(125, 125, 125)
	cc.c3b(125, 125, 125).buildType = gWorldTypeServerDef.subTypeNebulaWarPalace
	_ENV, cc.c3b(125, 125, 125).title = i18n("nebula_war_text_0303"), i18n("nebula_war_text_0303")
	i18n("nebula_war_text_0303").buildType = gWorldTypeServerDef.subTypeNebulaWarPalace
	i18n("nebula_war_text_0303").title = i18n("common_text_3078")
	_ENV, i18n("nebula_war_text_0303").relationType = gMapAllianceRelationType.ENEMY, gMapAllianceRelationType.ENEMY
	gMapAllianceRelationType.ENEMY.buildType = gWorldTypeServerDef.subTypeNebulaWarPalace
	gMapAllianceRelationType.ENEMY.title = i18n("remains_text_85")
	_ENV, gMapAllianceRelationType.ENEMY.relationType = gMapAllianceRelationType.SELF, gMapAllianceRelationType.SELF
	gMapAllianceRelationType.SELF.buildType = gWorldTypeServerDef.subTypeNebulaWarFort
	_ENV, gMapAllianceRelationType.SELF.isTitle = gWorldTypeServerDef.subTypeNebulaWarFort, true
	gWorldTypeServerDef.subTypeNebulaWarFort.buildType = gWorldTypeServerDef.subTypeNebulaWarFort
	gWorldTypeServerDef.subTypeNebulaWarFort.title = i18n("nebula_war_text_0304")
	_ENV, gWorldTypeServerDef.subTypeNebulaWarFort.color = cc.c3b(125, 125, 125), cc.c3b(125, 125, 125)
	cc.c3b(125, 125, 125).buildType = gWorldTypeServerDef.subTypeNebulaWarFort
	_ENV, cc.c3b(125, 125, 125).title = i18n("nebula_war_text_0303"), i18n("nebula_war_text_0303")
	i18n("nebula_war_text_0303").buildType = gWorldTypeServerDef.subTypeNebulaWarFort
	i18n("nebula_war_text_0303").title = i18n("common_text_3078")
	_ENV, i18n("nebula_war_text_0303").relationType = gMapAllianceRelationType.ENEMY, gMapAllianceRelationType.ENEMY
	gMapAllianceRelationType.ENEMY.buildType = gWorldTypeServerDef.subTypeNebulaWarFort
	gMapAllianceRelationType.ENEMY.title = i18n("remains_text_85")
	_ENV, gMapAllianceRelationType.ENEMY.relationType = gMapAllianceRelationType.SELF, gMapAllianceRelationType.SELF
	gMapAllianceRelationType.SELF.buildType = gWorldTypeServerDef.subTypeNebulaWarSmallMine
	gMapAllianceRelationType.SELF.isTitle = true
	_ENV, gMapAllianceRelationType.SELF.title = i18n("nebula_explain_name_006"), i18n("nebula_explain_name_006")
	i18n("nebula_explain_name_006").buildType = gWorldTypeServerDef.subTypeNebulaWarSmallMine
	i18n("nebula_explain_name_006").title = i18n("nebula_war_text_0545")
	;(nil)[1] = nil
	;(nil)[2] = gWorldTypeServerDef.subTypeNebulaWarPalace
	;(nil)[3] = cc.c3b(125, 125, 125)
	;(nil)[4] = i18n("nebula_war_text_0303")
	;(nil)[5] = gMapAllianceRelationType.ENEMY
	;(nil)[6] = gMapAllianceRelationType.SELF
	;(nil)[7] = gWorldTypeServerDef.subTypeNebulaWarFort
	;(nil)[8] = cc.c3b(125, 125, 125)
	;(nil)[9] = i18n("nebula_war_text_0303")
	;(nil)[10] = gMapAllianceRelationType.ENEMY
	;(nil)[11] = gMapAllianceRelationType.SELF
	local (nil)[12], config = i18n("nebula_explain_name_006"), nil
	for i, v in ipairs(config) do
		v.posy = 542 - (i - 1) * 42
		v.iconColor = true
		if v.isTitle then
			if not v.title then
				v.title = nebulaWarRead.getBuildName(v.buildType)
			end
			self:initNodeTitleSingle(v)
		else
			v.icon = nebulaWarRead.getBuildIconLod(v.buildType)
			self:initNodeInfoSingle(v)
		end
	end
end
function worldMapNebulaLodUI:initNodeInfoSingle(v)
	local single = self.Node_camp_Single:clone()
	single:setVisible(true)
	single:addTo(self.Node_mapInfo)
	single:setPosition(0, v.posy)
	SoraDGetAllChildFromWidget(single, single)
	single.Sprite_camp:setSpriteFrame(v.icon)
	single.Sprite_camp:setScale(30 / single.Sprite_camp:getContentSize().width)
	single.Text_camp:setString(v.title)
	local color = v.color
	if not color then
		local relationType = v.relationType or gMapAllianceRelationType.NORMAL
		color = worldMapDefine.getLeagueManorLineColor(nil, v.relationType)
	end
	single.Text_camp:setColor(color)
	if v.iconColor then
		single.Sprite_camp:setColor(color)
	end
	return single
end
function worldMapNebulaLodUI:initNodeTitleSingle(v)
	local single = self.Node_super:clone()
	single:setVisible(true)
	single:addTo(self.Node_mapInfo)
	single:setPosition(0, v.posy)
	SoraDGetAllChildFromWidget(single, single)
	single.Text_super:setString(v.title)
	return single
end
function worldMapNebulaLodUI:setWorldMapView(worldMapView)
	self.target_ = worldMapView
	self.lodMap:setWorldMapView(worldMapView)
end
function worldMapNebulaLodUI:updateData(data)
	self.lodMap:updateData(data)
	local mapKindomID = worldMapDefine.currentMapKindomID
	if mapKindomID == gametop.playertop_:getMapID() then
		self.lodMap:setSpriteSelfVisible(true)
	else
		self.lodMap:setSpriteSelfVisible(false)
	end
end
function worldMapNebulaLodUI:updateMapLod(event)
	for i, node in ipairs(self.lodNodeList) do
		node:updateMapLod(event)
	end
end
function worldMapNebulaLodUI:initMapLod(lod)
	for i, node in ipairs(self.lodNodeList) do
		node:initMapLod(lod)
	end
end
return worldMapNebulaLodUI
