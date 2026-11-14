local gametop = gModuleMgr.getObject("gametop")
local castleSkinRead = include("castleSkinRead")
local dressltCtrl = include("dressltCtrl")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildNebulaAllStarValue = class("worldMapBuildNebulaAllStarValue", worldMapBuildComNew)
local GROU_ID = worldMapDefine.GROU_ID
function worldMapBuildNebulaAllStarValue:ctor(...)
	worldMapBuildNebulaAllStarValue.super.ctor(self, ...)
end
function worldMapBuildNebulaAllStarValue:_initData(...)
end
function worldMapBuildNebulaAllStarValue:updateData(data)
	self:updateNebulaAllStarValue(data)
end
function worldMapBuildNebulaAllStarValue:updateNebulaAllStarValue(data)
	local nebulaAllStarValue = data.nebulaAllStarValue
	if not nebulaAllStarValue then
		if self.nebulaAllStarPlayer then
			self.nebulaAllStarPlayer:removeFromParent()
			self.nebulaAllStarPlayer = nil
		end
		return
	end
	local node = self.nebulaAllStarPlayer
	if not node then
		node = self:createNodeLabel()
		self.nebulaAllStarPlayer = node
		node:setPosition(cc.p(self.centerPoint.x, -120))
		node:addTo(self.target_)
	end
	local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
	if nebulaAllStarCtrl:checkIsAllStarTeam(data.leagueID) then
		_ENV = cc.p(self.centerPoint.x, -120)
		cc.p(self.centerPoint.x, -120).num = string.formatnumberthousands(nebulaAllStarValue)
		node.Text_name:setString(i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120)))
	else
		_ENV = i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120))
		i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120)).num = string.formatnumberthousands(nebulaAllStarValue)
		node.Text_name:setString(i18n("NebulaAllstar_358", i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120))))
	end
end
function worldMapBuildNebulaAllStarValue:createNodeLabel(...)
	local node = display.newNode()
	local Image_bg = display.newSprite("#frame_map_07.png")
	node.Image_bg = Image_bg
	Image_bg:addTo(node)
	Image_bg:setGroupID(GROU_ID.group_level_build)
	_ENV = Image_bg
	Image_bg.UILabelType = 2
	Image_bg.text = ""
	Image_bg.size = 20
	Image_bg.align = cc.TEXT_ALIGNMENT_CENTER
	Image_bg.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	local Text_name = SoraDCreateLabel(Image_bg)
	node.Text_name = Text_name
	Text_name:addTo(node)
	Text_name:setVisible(true)
	Text_name:setColor(cc.c3b(255, 235, 185))
	Text_name:setGroupID(GROU_ID.group_text)
	SoraDSetTextWidthHeight(Text_name, cc.size(240, 26))
	return node
end
return worldMapBuildNebulaAllStarValue
