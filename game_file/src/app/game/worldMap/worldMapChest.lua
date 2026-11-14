local worldMapChest = class("worldMapChest", function(target)
	local target = include("worldMapInstance").new("worldMapChest")
	return target
end)
function worldMapChest:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapChest:_initData()
	self.chestClassID = nil
	self.isColl = false
	self.chestLevel = 0
	self.leftCount = 0
	self.dailyMaxCount = 0
end
function worldMapChest:_initUI()
	self.chestImg = display.newSpriteNoChild("#zwbx_01.png")
	self:addChild(self.chestImg, -1)
	_ENV = self
	self.UILabelType = 2
	self.text = ""
	self.size = 16
	self.nameLabel = SoraDCreateLabelNoChild(self)
	self.nameLabel:setColor(cc.c3b(82, 51, 21))
	self.nameLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.nameLabel:setPosition(cc.p(self.centerPoint.x + 10, self.centerPoint.y - 70))
	self.nameLabel:addTo(self, 1)
	self.nameLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.image_level = display.newSpriteNoChild("#frame_YX_kapaidengji.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x - 65, self.centerPoint.y - 62))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_monster)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = ""
	self.image_level.size = 14
	self.levelLabel = SoraDCreateLabelNoChild(self.image_level)
	self.levelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.levelLabel:setPosition(cc.p(self.centerPoint.x - 66, self.centerPoint.y - 58))
	self.levelLabel:addTo(self, 1)
	self.levelLabel:setColor(cc.c3b(255, 251, 213))
	self.levelLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.countLabelBg = display.newSpriteNoChild("#frame_map_18.png")
	self.countLabelBg:setScale(0.6)
	self.countLabelBg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 35))
	self.countLabelBg:addTo(self, 0)
	self.countLabelBg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.countLabelBg
	self.countLabelBg.UILabelType = 2
	self.countLabelBg.text = ""
	self.countLabelBg.size = 18
	self.countLabel = SoraDCreateLabelNoChild(self.countLabelBg)
	self.countLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.countLabel:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 35))
	self.countLabel:setColor(cc.c3b(0, 255, 85))
	self.countLabel:addTo(self, 1)
	self.countLabel:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapChest:addCacheBefore()
	self.chestImg:setVisible(true)
	self.chestImg:stopAllActions()
end
function worldMapChest:setBatchNodeGroupID(groupID)
	self.chestImg:setGroupID(groupID)
end
function worldMapChest:initInstanceData(chestClassID, chestData)
	if not chestData then
		return
	end
	self.chestClassID = chestClassID
	self.chestshow = worldMapDefine.getChestpackShow(self.chestClassID)
	self.nameLabel:setString(i18n(self.chestshow.name))
	self.chestImg:setSpriteFrame(self.chestshow.effects .. "_01.png")
	local animation
	if 2 == self.chestClassID and worldMapDefine._hasCamelHdRes then
		local frames = display.newFrames("zyluotuo0" .. chestData.level .. "_dj_ws_%.2d.png", 1, 24)
		animation = display.newAnimation(frames, 0.05)
	else
		local frames = display.newFrames(self.chestshow.effects .. "_%.2d.png", 1, 6)
		if self.chestshow.effects == "zwbx" then
			frames[#frames + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.chestshow.effects .. "_01.png")
		elseif self.chestshow.effects == "sdlr" then
			if SoraDIsFileExistByKey("worldMapBossNormal") then
				print("存在圣诞老人，触发下载")
			end
			frames = display.newFrames(self.chestshow.effects .. "_ws_%.2d.png", 1, 8)
			frames[#frames + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.chestshow.effects .. "_ws_01.png")
			self.countLabel:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 35))
			self.countLabelBg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 35))
		end
		animation = display.newAnimation(frames, 1.2 / #frames)
	end
	self.chestImg:stopAllActions()
	self.chestImg:playAnimationForever(animation, self.chestshow.delay)
	self:updateData(chestData)
end
function worldMapChest:updateData(chestData)
	if not chestData then
		return
	end
	if chestData.collUids then
		local gametop = gModuleMgr.getObject("gametop")
		local selfPlayerID = gametop.playertop_:getPlayerID() or 0
		self.isColl = chestData.collUids[tostring(selfPlayerID)]
	end
	if chestData.level then
		self.chestLevel = chestData.level
		self.levelLabel:setString(self.chestLevel)
	end
	if chestData.leftCount then
		self.leftCount = chestData.leftCount
		_ENV = selfPlayerID
		selfPlayerID.count = self.leftCount
		self.countLabel:setString(i18n("common_text_1673", selfPlayerID))
	end
	if chestData.chestRewardLimit then
		self.dailyMaxCount = chestData.chestRewardLimit
	end
end
function worldMapChest:getChestClassID()
	return self.chestClassID
end
function worldMapChest:onClickInstance()
	local selectShowPanel = include("worldMapChestView").new()
	selectShowPanel:setPosition(cc.p(display.width / 2, display.height / 2))
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initData(self)
	selectShowPanel:show()
	return selectShowPanel, true
end
return worldMapChest
