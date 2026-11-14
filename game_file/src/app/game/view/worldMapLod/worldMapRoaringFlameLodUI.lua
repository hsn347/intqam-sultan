local worldLodDef = worldMapDefine.worldLodDef
local roaringFlameWarRead = include("roaringFlameWarRead")
local worldMapViewDef = include("worldMapViewDef")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local worldMapNebulaLodUI = include("worldMapNebulaLodUI")
local worldMapRoaringFlameLodUI = class("worldMapRoaringFlameLodUI", worldMapNebulaLodUI)
function worldMapRoaringFlameLodUI:getLodConfig(...)
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
function worldMapRoaringFlameLodUI:initNodeInfo(...)
	local totalH = 400
	self.Image_1:setContentSize(cc.size(self.Image_1:getContentSize().width, totalH))
	self.singleList1, _ENV = self.Image_1.setContentSize, self.Image_1.setContentSize
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	for camp = 1, roaringFlameWarRead.getCampCount() do
		local obj = fguiHelper.createObject("RoaringFlameWorldMap", "Com_mapInfoSingle")
		obj:addTo(self.Node_mapInfo)
		obj:setPosition(0, -totalH + 120 + (camp - 1) * 60)
		local campName = roaringFlameWarRead.getCampName(camp)
		if camp == selfCamp then
			campName = i18n("flames_dunes_text33")
		end
		obj:setString(campName)
		local campColor = roaringFlameWarRead.getCampColor(camp)
		obj:getChild("title"):setColor(campColor)
		local campImage = roaringFlameWarRead.getCampBuildLvImage(camp)
		obj:setIcon(campImage)
		table.insert(self.singleList1, obj)
	end
	_ENV, _ENV = roaringFlameWarRead.getCampCount(), (for index)
	roaringFlameWarRead.getCampCount().title = i18n("common_text_188")
	roaringFlameWarRead.getCampCount().icon = "lod_base_blue.png"
	_ENV, (1)[1], roaringFlameWarRead.getCampCount().posy = roaringFlameWarRead.getCampCount(), roaringFlameWarRead.getCampCount(), 160
	roaringFlameWarRead.getCampCount().title = i18n("common_text_187")
	roaringFlameWarRead.getCampCount().icon = "lod_base_purple.png"
	_ENV, (1)[2], roaringFlameWarRead.getCampCount().posy = roaringFlameWarRead.getCampCount(), roaringFlameWarRead.getCampCount(), 100
	roaringFlameWarRead.getCampCount().title = i18n("common_text_142")
	roaringFlameWarRead.getCampCount().icon = "lod_base_green.png"
	self.singleList2, _ENV, (1)[3], roaringFlameWarRead.getCampCount().posy = roaringFlameWarRead.getCampCount(), roaringFlameWarRead.getCampCount(), roaringFlameWarRead.getCampCount(), 40
	local config = 1
	for i, v in ipairs(config) do
		local single = self:initNodeInfoSingle(v)
		single.Sprite_camp:setPositionY(-20)
		table.insert(self.singleList2, single)
	end
	_ENV, _ENV = ipairs(config)
	ipairs(config).title = i18n("common_text_4581")
	_ENV, ipairs(config)[1], ipairs(config).tag = ipairs(config)
	ipairs(config).title = i18n("common_text_3079")
	ipairs(config)[2], ipairs(config).tag = ipairs(config)
	local config = ipairs(config)
	self.buttonList, _ENV, self.buttonConfig = ipairs(config)
	for i, v in ipairs(config) do
		local obj = fguiHelper.createObject("RoaringFlameWorldMap", "Button_mapInfoSelect")
		obj:addTo(self.Node_mapInfo)
		obj:setPosition(0, -totalH + 20 + (i - 1) * 40)
		obj:setString(v.title)
		obj:addClickListener(function(...)
			self:updateNodeInfo(i)
		end)
		table.insert(self.buttonList, obj)
	end
	self:updateNodeInfo(1)
end
function worldMapRoaringFlameLodUI:updateNodeInfo(index)
	local tag = self.buttonConfig[index].tag
	worldMapDefine.curSelectNodeInfo = tag
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_NODEINFO_SELECT_CHANGE"
	;(nil).tag = tag
	SoraDSendMessage(nil)
	for i, v in ipairs(self.singleList1) do
		v:setVisible(tag == worldMapViewDef.NODEINFO_TYPE_MANORLINE)
	end
	for i, v in ipairs(self.singleList2) do
		v:setVisible(tag == worldMapViewDef.NODEINFO_TYPE_ALLIANCE)
	end
	for i, v in ipairs(self.buttonList) do
		v:setSelected(index == i)
	end
end
return worldMapRoaringFlameLodUI
