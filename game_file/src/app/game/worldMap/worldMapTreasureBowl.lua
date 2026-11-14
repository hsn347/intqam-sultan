local worldMapTreasureBowl = class("worldMapTreasureBowl", function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end)
_ENV = "worldMapTreasureBowl"
;("worldMapTreasureBowl")[1] = 851501
;("worldMapTreasureBowl")[2] = 851601
;("worldMapTreasureBowl")[3] = 851701
local _ENV, ("worldMapTreasureBowl")[4], treeId = function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end, 851801, "worldMapTreasureBowl"
;(function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end)[1] = "8515.png"
;(function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end)[2] = "8516.png"
;(function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end)[3] = "8517.png"
local (function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end)[4], treeName = "8518.png", function(target)
	local target = include("worldMapInstance").new("worldMapTreasureBowl")
	return target
end
function worldMapTreasureBowl:ctor()
	self.treasureBowlClassID = nil
	self.treasureImg = "zhouniangz_egg.png"
	self:_initUI()
	self:_initData()
end
function worldMapTreasureBowl:_initData()
	self.isColl = false
	self.treasureBowlLevel = 0
	self.lockStatus = false
	self.cooltime = 5
	self.maxcount = 10
	self.treasureState = 1
	self.treeData = nil
	self.tilePoint = nil
	self.instanceID = nil
end
function worldMapTreasureBowl:_initUI()
	if IsArClient then
		self.treasureBowlImg = display.newSprite("#" .. self.treasureImg)
	else
		self.treasureBowlImg = display.newSprite("#zhouniangz_03.png")
	end
	self:addChild(self.treasureBowlImg, -1)
	_ENV = self
	self.UILabelType = 2
	self.text = ""
	self.size = 16
	self.nameLabel = SoraDCreateLabel(self)
	self.nameLabel:setColor(cc.c3b(82, 51, 21))
	self.nameLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.nameLabel:setPosition(cc.p(self.centerPoint.x + 10, self.centerPoint.y - 65))
	self.nameLabel:addTo(self, 1)
	self.nameLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.image_level = display.newSprite("#frame_YX_kapaidengji.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x - 65, self.centerPoint.y - 62))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_monster)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = ""
	self.image_level.size = 14
	self.levelLabel = SoraDCreateLabel(self.image_level)
	self.levelLabel:setColor(cc.c3b(255, 251, 213))
	self.levelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.levelLabel:setPosition(cc.p(self.centerPoint.x - 66, self.centerPoint.y - 58))
	self.levelLabel:addTo(self, 1)
	self.levelLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
end
function worldMapTreasureBowl:addCacheBefore()
	self.treasureBowlImg:stopAllActions()
	if self.image_Hammer then
		self.image_Hammer:stopAllActions()
		self.image_Hammer:setVisible(false)
	end
	if self.pyramidProtectNode then
		self.pyramidProtectNode:removeFromParent()
		self.pyramidProtectNode = nil
	end
end
function worldMapTreasureBowl:setBatchNodeGroupID(groupID)
	self.treasureBowlImg:setGroupID(groupID)
end
function worldMapTreasureBowl:initInstanceData(treasureBowlClassID, treasureBowlData)
	if not treasureBowlData then
		return
	end
	self.treasureBowlClassID = treasureBowlClassID
	self.treasureBowlshow = worldMapDefine.getTreasureBowlpackShow(self.treasureBowlClassID)
	dump(self.treasureBowlshow, "初始化数据1")
	self.nameLabel:setString(i18n(self.treasureBowlshow.name))
	self.treasureBowlImg:setSpriteFrame(self.treasureImg)
	self:updateData(treasureBowlData)
end
function worldMapTreasureBowl:updateData(treasureBowlData)
	if not treasureBowlData then
		return
	end
	if treasureBowlData.collUids then
		local gametop = gModuleMgr.getObject("gametop")
		local selfPlayerID = gametop.playertop_:getPlayerID() or 0
		self.isColl = treasureBowlData.collUids[tostring(selfPlayerID)]
	end
	if treasureBowlData.level then
		self.treasureBowlLevel = treasureBowlData.level
		self.levelLabel:setString(self.treasureBowlLevel)
	end
	if nil ~= treasureBowlData.lockStatus then
		self.lockStatus = treasureBowlData.lockStatus
		self:showHammer(self.lockStatus)
	end
	if treasureBowlData.clickcount then
		self.maxcount = treasureBowlData.clickcount
	end
	if treasureBowlData.cooltime then
		self.cooltime = treasureBowlData.cooltime
	end
	if treasureBowlData.status then
		self.treasureState = treasureBowlData.status
	end
	if self.treasureState == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		self:doDieingAnimation()
	end
	if self.treeData then
		self.treeData.isColl = treasureBowlData.isColl
	end
	if treasureBowlData.mapType and treasureBowlData.mapType == gMapObjTypeDef.mapObjTypeChristmasTree then
		local itemDesRead = include("itemDesRead")
		self.nameLabel:setString(itemDesRead.getName(treeId[treasureBowlData.level]))
		self.treasureBowlImg:setSpriteFrame("sds_bust_outside.png")
		self.treeData = treasureBowlData
		self.treasureBowlImg:setPosition(cc.p(-10, 60))
		self.image_level:setPosition(cc.p(self.centerPoint.x - 65, self.centerPoint.y - 80))
		self.levelLabel:setPosition(cc.p(self.centerPoint.x - 66, self.centerPoint.y - 80))
		self.nameLabel:setPosition(cc.p(self.centerPoint.x - 30, self.centerPoint.y - 80))
		self.nameLabel:setAnchorPoint(cc.p(0, 0.5))
	end
end
function worldMapTreasureBowl:getTreasureBowlClassID()
	return self.treasureBowlClassID
end
function worldMapTreasureBowl:showHammer(show)
	if show then
		if not self.image_Hammer then
			self.image_Hammer = display.newSprite("#znqchuizi_01.png")
			self.image_Hammer:setPosition(cc.p(self.centerPoint.x + 22.5, self.centerPoint.y + 55))
			self.image_Hammer:addTo(self, 1)
		end
		self.image_Hammer:setVisible(true)
		self.image_Hammer:stopAllActions()
		local frames = display.newFrames("znqchuizi_0%d.png", 1, 4)
		frames[#frames + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame("znqchuizi_01.png")
		local animation = display.newAnimation(frames, 0.1)
		self.image_Hammer:playAnimationForever(animation)
	elseif self.image_Hammer then
		self.image_Hammer:stopAllActions()
		self.image_Hammer:setVisible(false)
	end
end
function worldMapTreasureBowl:doDieingAnimation()
	self.treasureBowlImg:stopAllActions()
	local _ENV, actionsArray = self.treasureBowlImg.stopAllActions, self.treasureBowlImg.stopAllActions
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.1)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		if IsArClient then
			self.treasureBowlImg:setSpriteFrame("zhouniangz_02.png")
		else
			self.treasureBowlImg:setSpriteFrame("zhouniangz_03.png")
		end
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(1.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_MAPINSTANCE"
		;(nil).instance = self
		SoraDSendMessage(nil)
	end)
	local actions = transition.sequence(actionsArray)
	self.treasureBowlImg:runAction(actions)
	self:posuitxEffect()
end
function worldMapTreasureBowl:posuitxEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_posuitx_01.plist"
	_ENV, (nil)[2], (nil).plist = nil, nil, "et_posuitx_02.plist"
	_ENV, (nil)[3], (nil).plist = nil, nil, "et_posuitx_03.plist"
	;(nil)[4], (nil).plist = nil, "et_posuitx_04.plist"
	local param
	if self.pyramidProtectNode then
		SoraDResetEffectNode(self.pyramidProtectNode)
	else
		self.pyramidProtectNode = SoraDCreateEffectNode(param)
		self:addChild(self.pyramidProtectNode, 5)
		self.pyramidProtectNode:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 50))
	end
end
local REWARD_TREE_MAX_COUNT = 30
function worldMapTreasureBowl:onClickInstance()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local sourceKid = lordInfoCtrl:getSourceKid()
	if sourceKid and sourceKid <= 0 then
		sourceKid = gametop.playertop_:getKingdomID()
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if sourceKid == self.kingdomID then
		if self.treeData then
			local christmasTreeCtrl = SoraDGetCtrl("christmasTreeCtrl")
			local myData = christmasTreeCtrl:getChristmasTreeData()
			if myData.rewardTree >= REWARD_TREE_MAX_COUNT then
				_ENV = nil
				;(nil).count = REWARD_TREE_MAX_COUNT
				SoraDShowMsgTip(i18n("notice_0192", nil))
				return
			end
		else
			local bowldata = kingdomMapCtrl:getTreasureBowlInfo()
			if bowldata and not bowldata.isCanClick then
				_ENV = i18n("notice_0192", nil)
				i18n("notice_0192", nil).count = bowldata.rewardLimit
				SoraDShowMsgTip(i18n("notice_0192", i18n("notice_0192", nil)))
				return
			end
		end
	end
	local selectShowPanel = include("worldMapTreasureBowlView").new()
	selectShowPanel:setPosition(cc.p(display.width / 2, display.height / 2))
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	if self.treeData then
		selectShowPanel:initData(self, self.treeData, self.tilePoint, self.instanceID)
	else
		selectShowPanel:initData(self, nil, self.tilePoint)
	end
	selectShowPanel:show()
	return selectShowPanel, true
end
return worldMapTreasureBowl
