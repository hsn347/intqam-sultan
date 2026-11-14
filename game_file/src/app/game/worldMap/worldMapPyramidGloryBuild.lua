local gametop = gModuleMgr.getObject("gametop")
local worldMapPyramidGloryBuild = class("worldMapPyramidGloryBuild", function(target)
	local target = include("worldMapInstance").new("worldMapPyramidGloryBuild")
	return target
end)
function worldMapPyramidGloryBuild:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapPyramidGloryBuild:_initData()
	self.level = 0
end
function worldMapPyramidGloryBuild:_initUI()
	local offsetX = 5
	local offsetY = 5
	self.occupyIcon = display.newSprite("#icon_map_res_me.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self.resourceImage = display.newSprite("#map_building_honor.png")
	self.resourceImage:setScale(0.8)
	self.resourceImage:setPosition(cc.p(offsetX, offsetY))
	self:addChild(self.resourceImage, -1)
	self.image_nameLv = display.newSprite("#frame_map_07.png")
	self.image_nameLv:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_nameLv:setPosition(cc.p(self.centerPoint.x + offsetX, self.centerPoint.y - 70 + offsetY))
	self.image_nameLv:addTo(self, 1)
	local buldName = i18n("pyramid_title_08")
	_ENV = self
	self.UILabelType = 2
	self.text = buldName
	self.size = 20
	self.text_NameLv = cc.ui.UILabel.new(self)
	self.text_NameLv:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_NameLv:setPosition(cc.p(self.centerPoint.x + offsetX, self.centerPoint.y - 73 + offsetY))
	self.text_NameLv:addTo(self, 2)
	self.text_NameLv:setColor(cc.c3b(255, 200, 100))
	self.text_NameLv:setGroupID(worldMapDefine.GROU_ID.group_text)
	local textLen = self.text_NameLv:getContentSize().width
	local maxWidth = math.max(textLen + 120, self.image_nameLv:getContentSize().width)
	print("textLen = ", textLen, "maxWidth = ", maxWidth)
	self.image_nameLv:setScaleX(maxWidth / self.image_nameLv:getContentSize().width)
	self:updateActivityState()
end
function worldMapPyramidGloryBuild:onMessageListener()
end
function worldMapPyramidGloryBuild:addCacheBefore()
end
function worldMapPyramidGloryBuild:setBatchNodeGroupID(groupID)
	self.resourceImage:setGroupID(groupID)
end
function worldMapPyramidGloryBuild:initInstanceData(buildData)
	dump(buildData, "worldMapPyramidGloryBuild:initInstanceData(buildData)")
	if not buildData then
		return
	end
	self:updateData(buildData)
end
function worldMapPyramidGloryBuild:updateData(data)
	dump(data, "worldMapPyramidGloryBuild:updateData")
	if not data then
		return
	end
	if data.level then
		self.level = data.level
		self.isUnlock = data.isUnlock
	end
	self:updateLevel()
end
function worldMapPyramidGloryBuild:updateLevel()
end
function worldMapPyramidGloryBuild:playClickSound()
	SoraDPlaySound("worldmap", 18)
end
function worldMapPyramidGloryBuild:updateActivityState()
end
function worldMapPyramidGloryBuild:onClickInstance(onShowView)
	SoraDCreatePanel("alliancePBLHonorView"):show()
end
return worldMapPyramidGloryBuild
