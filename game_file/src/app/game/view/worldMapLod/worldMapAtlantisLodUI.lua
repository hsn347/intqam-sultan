local worldLodDef = worldMapDefine.worldLodDef
local worldMapNebulaLodUI = include("worldMapNebulaLodUI")
local worldMapAtlantisLodUI = class("worldMapAtlantisLodUI", worldMapNebulaLodUI)
function worldMapAtlantisLodUI:getLodConfig(...)
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
function worldMapAtlantisLodUI:initNodeInfo(...)
	self.Image_1:setContentSize(cc.size(self.Image_1:getContentSize().width, 200))
	_ENV, _ENV = self.Image_1, self.Image_1.setContentSize
	self.Image_1.title = i18n("common_text_188")
	self.Image_1.icon = "lod_base_blue.png"
	_ENV, self.Image_1.setContentSize[1], self.Image_1.posy = self.Image_1, self.Image_1, 160
	self.Image_1.title = i18n("common_text_142")
	self.Image_1.icon = "lod_base_green.png"
	_ENV, self.Image_1.setContentSize[2], self.Image_1.posy = self.Image_1, self.Image_1, 100
	self.Image_1.title = i18n("common_text_638")
	self.Image_1.icon = "lod_base_red.png"
	self.Image_1.setContentSize[3], self.Image_1.posy = self.Image_1, 40
	local config = self.Image_1.setContentSize
	for i, v in ipairs(config) do
		local single = self.Node_camp_Single:clone()
		single:setVisible(true)
		single:addTo(self.Node_mapInfo)
		single:setPosition(0, v.posy)
		SoraDGetAllChildFromWidget(single, single)
		single.Sprite_camp:setSpriteFrame(v.icon)
		single.Sprite_camp:setPositionY(-20)
		single.Text_camp:setString(v.title)
	end
end
return worldMapAtlantisLodUI
