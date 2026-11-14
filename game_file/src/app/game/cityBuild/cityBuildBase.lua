local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildNodeCreator = include("cityBuildNodeCreator")
local cityBuildFunction = include("cityBuildFunction")
local cityBuildBase = class("cityBuildBase", function()
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
function cityBuildBase:ctor()
	self:setSwallowTouches(false)
	self.tblNodeRelyOn, _ENV, self.basePos = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
end
function cityBuildBase:initWithUIType(bid, uiType, viewNodes, basePos)
	self.uiType = uiType
	if uiType == cityBuildConstDef.uiType.UI_TYPE_ALONE then
		if bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.MILITARY_TENT or bid == BUILDID.HOSTPITAL then
			local batchNodeOuterBuilds = display.newNode()
			self:addChild(batchNodeOuterBuilds, 0)
			cityBuildConstDef = self.addChild
			self.viewNodes, self.addChild.mainCityOuter = self.addChild, batchNodeOuterBuilds
		else
			local defaultBatchNode = display.newNode()
			self:addChild(defaultBatchNode)
			cityBuildConstDef = self.addChild
			self.viewNodes, self.addChild.default = self.addChild, defaultBatchNode
		end
	elseif uiType == cityBuildConstDef.uiType.UI_TYPE_RELYON then
		if viewNodes == nil then
			print("Error! 必须传入依赖的batchNodes~")
			return
		end
		if basePos == nil then
			print("Error! 没有传入basePos，将使用默认 (0,0)")
		end
		self.viewNodes = viewNodes
		self.basePos = basePos or cc.p(0, 0)
	end
end
function cityBuildBase:setBasePos(basePos)
	self.basePos = basePos
	self:udpateViewWithBasePos()
end
function cityBuildBase:udpateViewWithBasePos()
	if self.uiType ~= cityBuildConstDef.uiType.UI_TYPE_RELYON then
		return
	end
	cityBuildFunction:updateViewWithBasePos(self)
end
function cityBuildBase:updateNodeOffsetByName(nodeName, offset)
	if self.uiType ~= cityBuildConstDef.uiType.UI_TYPE_RELYON then
		if self[nodeName] ~= nil then
			local node = self[nodeName]
			node:setPosition(offset)
		end
	else
		local findNode = self[nodeName]
		if findNode ~= nil then
			for i, v in ipairs(parent.tblNodeRelyOn) do
				if v.node == findNode then
					v.offset.x = offset.x
					v.offset.y = offset.y
					v.node:setPosition(parent.basePos.x + v.offset.x, parent.basePos.y + v.offset.y)
					break
				end
			end
		end
	end
end
function cityBuildBase:loadView()
	self:loadBaseView()
end
function cityBuildBase:loadBaseView()
	local bid = self:getBuildBid()
	if bid ~= nil then
		self:loadBaseViewByBid(bid)
	end
end
function cityBuildBase:loadBaseViewByBid(bid)
	self.tblNodeRelyOn, cityBuildViewDef = nil, nil
	local buildViewCfg, baseView = cityBuildViewDef.getBuildViewCfg(bid)
	self.viewCfg = buildViewCfg
	local otherView = buildViewCfg.otherView
	buildViewCfg = buildViewCfg.baseView
	if buildViewCfg == nil then
		print("没有找到相应的配置: bid = ", bid)
		return
	end
	if self.viewNodes == nil then
		return
	end
	self.createdNodes, cityBuildViewDef = self.viewNodes, self.viewNodes
	for i = 1, #buildViewCfg do
		local nodeCfgItem = buildViewCfg[i]
		local info = nodeCfgItem
		if nodeCfgItem.nodeName == "buildImg" and nodeCfgItem.nodeType == "sprite" then
			info = clone(nodeCfgItem, true)
			local ctrl = SoraDGetCtrl("factionCtrl")
			local img = ctrl:getBuildImgWithNation(bid)
			info.nodeImg = img
		end
		local node, isFromCache = cityBuildNodeCreator:createNode(info)
		cityBuildFunction:loadNodeForParent(self, node, nodeCfgItem)
		if not self.createdNodes[nodeCfgItem.nodeType] then
			cityBuildViewDef = self.createdNodes[nodeCfgItem.nodeType]
		end
		self.createdNodes[nodeCfgItem.nodeType] = self.createdNodes[nodeCfgItem.nodeType]
		table.insert(self.createdNodes[nodeCfgItem.nodeType], node)
		if isFromCache then
			node:release()
		end
	end
end
function cityBuildBase:recycleNode()
	cityBuildNodeCreator:recycleNode(self.createdNodes)
	self.createdNodes, cityBuildNodeCreator = cityBuildNodeCreator.recycleNode, cityBuildNodeCreator.recycleNode
end
function cityBuildBase:getNodePosition(nodeName)
	if self[nodeName] then
		return self[nodeName]:getPosition()
	else
		return 0, 0
	end
end
function cityBuildBase:getCfgItemByName(nodeName)
	if not self.viewCfg.otherView then
		local _ENV, otherView = self.viewCfg.otherView, self.viewCfg.otherView
	end
	for i, v in ipairs(otherView) do
		if v.nodeName == nodeName then
			return v
		end
	end
	local baseView = self.viewCfg.baseView
	for i, v in ipairs(baseView) do
		if v.nodeName == nodeName then
			return v
		end
	end
end
function cityBuildBase:loadNodeByName(nodeName)
	print("cityBuildBase:loadNodeByName", nodeName)
	if self[nodeName] ~= nil then
		return
	end
	local cfgItem = self:getCfgItemByName(nodeName)
	if nil == cfgItem then
		return
	end
	local node, isFromCache = cityBuildNodeCreator:createNode(cfgItem)
	cityBuildFunction:loadNodeForParent(self, node, cfgItem)
	if not self.createdNodes then
		_ENV = self.createdNodes
	end
	self.createdNodes = self.createdNodes
	if not self.createdNodes[cfgItem.nodeType] then
		_ENV = self.createdNodes[cfgItem.nodeType]
	end
	self.createdNodes[cfgItem.nodeType] = self.createdNodes[cfgItem.nodeType]
	table.insert(self.createdNodes[cfgItem.nodeType], node)
	if isFromCache then
		node:release()
	end
	return node
end
function cityBuildBase:removeNodeByName(nodeName)
	local node = self[nodeName]
	if node ~= nil then
		cityBuildFunction:removeFromRelyOnTable(self.tblNodeRelyOn, node)
		self[nodeName] = nil
		node:removeFromParent()
	else
	end
end
function cityBuildBase:setBuildBid(bid)
	self.bid = bid
end
function cityBuildBase:setBuildIid(iid)
	self.iid = iid
end
function cityBuildBase:getBuildBid()
	return self.bid
end
function cityBuildBase:getBasePos()
	return self.basePos
end
function cityBuildBase:setTextLv(lv)
	if self.textLv then
		self.textLv:setString(tostring(lv))
	end
end
function cityBuildBase:setBuildIndex(buildIndex)
	self.buildIndex = buildIndex
end
function cityBuildBase:getBuildIndex()
	return self.buildIndex
end
function cityBuildBase:setIsCanUpgrade(isCanUpgrade)
	if self:getIsLocked() then
		self.imgUpgrade:setVisible(false)
		return
	end
	self.isCanUpgrade = isCanUpgrade
	if self.isCanUpgradeStar then
		return
	end
	if isCanUpgrade == true and self.imgUpgrade then
		self.imgUpgrade:setVisible(true)
	elseif isCanUpgrade == false and self.imgUpgrade then
		self.imgUpgrade:setVisible(false)
	end
end
function cityBuildBase:setIsCanUpgradeStar(isCanUpgradeStar)
	self.isCanUpgradeStar = isCanUpgradeStar
	if self.isCanUpgrade then
		return
	end
	if self.imgUpgrade then
		self.imgUpgrade:setVisible(isCanUpgradeStar)
	end
end
function cityBuildBase:showGlow()
	local buildGlow = self.buildGlow
	if buildGlow == nil then
		buildGlow = self:loadNodeByName("buildGlow")
	end
end
function cityBuildBase:showZAnimation()
	if self.buildZ then
		local cfgItem = self:getCfgItemByName("buildZ")
		if cfgItem == nil then
			return
		end
		local offset = cfgItem.offset
		local actionZ = cityBuildNodeCreator:createAction_zAction(offset)
		self.buildZ:stopAllActions()
		self.buildZ:setPosition(offset)
		self.buildZ:setVisible(true)
		self.buildZ:setAnchorPoint(cc.p(0.5, 0))
		self.buildZ:runAction(actionZ)
	end
end
function cityBuildBase:hideZAnimation()
	local buildZ = self.buildZ
	if buildZ then
		buildZ:stopAllActions()
		buildZ:setVisible(false)
	end
end
function cityBuildBase:removeNodeRelyOn()
	for k, v in pairs(self.tblNodeRelyOn) do
		if v and v.node then
			self[v.node:getName()] = nil
		end
	end
	self.tblNodeRelyOn, _ENV = pairs(self.tblNodeRelyOn)
end
return cityBuildBase
