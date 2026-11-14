local worldLodDef = worldMapDefine.worldLodDef
local worldMapNebulaLodUI = include("worldMapNebulaLodUI")
local worldMapNebulaEmperorLodUI = class("worldMapNebulaEmperorLodUI", worldMapNebulaLodUI)
function worldMapNebulaEmperorLodUI:getLodConfig(...)
	local _ENV, config
	_ENV = nil
	;(nil).widget = self.lodMap
	;(nil).showLodMin = worldLodDef.LOD2
	;(nil).offset = cc.p(SoraDFSign(200), 0)
	table.insert(config, nil)
	_ENV = nil
	;(nil).widget = self.Node_mapInfo
	;(nil).showLodMin = worldLodDef.LOD4
	;(nil).offset = cc.p(SoraDFSign(-120), 0)
	table.insert(config, nil)
	return config
end
function worldMapNebulaEmperorLodUI:initNodeInfo(...)
	_ENV, _UPVALUE11_ = nil, nil
	;(nil).title = i18n("nebulaemperor_text_106")
	_ENV, (nil).isTitle = i18n("nebulaemperor_text_106"), true
	i18n("nebulaemperor_text_106").title = i18n("nebula_war_text_0304")
	_ENV, i18n("nebulaemperor_text_106").icon = i18n("nebula_war_text_0304"), "icon_build_dicheng.png"
	i18n("nebula_war_text_0304").title = i18n("common_text_3078")
	_ENV, i18n("nebula_war_text_0304").icon = i18n("common_text_3078"), "icon_build_dicheng_hong.png"
	i18n("common_text_3078").title = i18n("technology_name_24011")
	_ENV, i18n("common_text_3078").icon = i18n("technology_name_24011"), "icon_build_dicheng_lan.png"
	i18n("technology_name_24011").title = i18n("nebulaemperor_text_105")
	_ENV, i18n("technology_name_24011").isTitle = i18n("nebulaemperor_text_105"), true
	i18n("nebulaemperor_text_105").title = i18n("nebula_war_text_0304")
	_ENV, i18n("nebulaemperor_text_105").icon = i18n("nebula_war_text_0304"), "icon_build_gaota.png"
	i18n("nebula_war_text_0304").title = i18n("common_text_3078")
	_ENV, i18n("nebula_war_text_0304").icon = i18n("common_text_3078"), "icon_build_gaota_hong.png"
	i18n("common_text_3078").title = i18n("technology_name_24011")
	_ENV, i18n("common_text_3078").icon = i18n("technology_name_24011"), "icon_build_gaota_lan.png"
	i18n("technology_name_24011").title = i18n("nebula_war_build_0001")
	_ENV, i18n("technology_name_24011").isTitle = i18n("nebula_war_build_0001"), true
	i18n("nebula_war_build_0001").title = i18n("common_text_3078")
	_ENV, i18n("nebula_war_build_0001").icon = i18n("common_text_3078"), "icon_build_shuaifu_hong.png"
	i18n("common_text_3078").title = i18n("technology_name_24011")
	i18n("common_text_3078").icon = "icon_build_shuaifu_lan.png"
	;(nil)[1] = nil
	;(nil)[2] = i18n("nebulaemperor_text_106")
	;(nil)[3] = i18n("nebula_war_text_0304")
	;(nil)[4] = i18n("common_text_3078")
	;(nil)[5] = i18n("technology_name_24011")
	;(nil)[6] = i18n("nebulaemperor_text_105")
	;(nil)[7] = i18n("nebula_war_text_0304")
	;(nil)[8] = i18n("common_text_3078")
	;(nil)[9] = i18n("technology_name_24011")
	;(nil)[10] = i18n("nebula_war_build_0001")
	local (nil)[11], config = i18n("common_text_3078"), nil
	local posY = -10
	for i = #config, 1, -1 do
		local cfg = config[i]
		if cfg.isTitle then
			posY = posY + 40
			cfg.posy = posY
			posY = posY + 10
		else
			posY = posY + 35
			cfg.posy = posY
		end
	end
	local totalH = posY + 10
	self.Image_1:setContentSize(cc.size(self.Image_1:getContentSize().width, totalH))
	for i, v in ipairs(config) do
		if v.isTitle then
			self:initNodeTitleSingle(v)
		else
			local single = self:initNodeInfoSingle(v)
			single.Sprite_camp:setScale(1)
			single.Sprite_camp:setAnchorPoint(cc.p(0.5, 0.5))
			single.Sprite_camp:setPositionY(0)
		end
	end
end
return worldMapNebulaEmperorLodUI
