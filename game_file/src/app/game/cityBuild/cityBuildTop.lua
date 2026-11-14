local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildNodeCreator = include("cityBuildNodeCreator")
local cityBuildTop = class("cityBuildTop", function()
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
function cityBuildTop:ctor()
	self:setSwallowTouches(false)
	self.tblNodeRelyOn, _ENV, self.basePos = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	self.buildInfo, _ENV, self.singleIsMoved = cc.p(0, 0), cc.p(0, 0), false
end
function cityBuildTop:initWithTopType(topType, viewNodes, basePos, autoDelete)
	self.topType = topType
	self.viewNodes = viewNodes
	self.basePos = basePos or cc.p(0, 0)
	self.autoDelete = autoDelete
	self:loadViewByTopType(topType)
	if self.autoDelete then
		self:setAutoDelete()
	end
end
function cityBuildTop:recycleNode()
	cityBuildNodeCreator:recycleNode(self.createdNodes)
	self.createdNodes, cityBuildNodeCreator = cityBuildNodeCreator.recycleNode, cityBuildNodeCreator.recycleNode
end
function cityBuildTop:setBuildInfo(buildInfo)
	self.buildInfo = buildInfo
end
function cityBuildTop:setAutoDelete()
	self:stopAllActions()
	local delayTime = 9
	local actDelay = cca.delay(delayTime)
	local actCallFunc = cca.callFunc(function()
		self:recycleNode()
		self:removeFromParent()
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = actDelay
	;(nil)[2] = actCallFunc
	local seq = cca.seq(nil)
	self:runAction(seq)
end
function cityBuildTop:startTimer()
	self:stopTimer()
	self.timerKey = scheduler.scheduleGlobal(handler(self, self.updateTime), 0.02)
end
function cityBuildTop:stopTimer()
	if self.timerKey then
		scheduler.unscheduleGlobal(self.timerKey)
		self.timerKey = nil
	end
end
function cityBuildTop:updateTime()
end
function cityBuildTop:setBasePos(basePos)
	self.basePos = basePos
	self:udpateViewWithBasePos()
end
function cityBuildTop:udpateViewWithBasePos()
	cityBuildFunction:updateViewWithBasePos(self)
end
function cityBuildTop:loadViewByTopType(_topType)
	self.tblNodeRelyOn, cityBuildConstDef = nil, nil
	local topType = _topType
	if _topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_NEW or _topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_FARM_REWARD or _topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_CULTIVATE_FULL then
		topType = cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER
	end
	local cfg = cityBuildViewDef.getBuildTopCfg(topType)
	if cfg == nil or cfg.baseView == nil then
		print("cityBduilTop: 没有找到相应的配置: topType = ", topType)
		return
	end
	cfg = cfg.baseView
	if self.viewNodes == nil then
		return
	end
	self.createdNodes, cityBuildConstDef = self.viewNodes, self.viewNodes
	for i = 1, #cfg do
		local nodeCfgItem = cfg[i]
		local node, isFromCache = cityBuildNodeCreator:createNode(nodeCfgItem)
		if node then
			cityBuildFunction:loadNodeForParent(self, node, nodeCfgItem)
			if not self.createdNodes[nodeCfgItem.nodeType] then
				cityBuildConstDef = self.createdNodes[nodeCfgItem.nodeType]
			end
			self.createdNodes[nodeCfgItem.nodeType] = self.createdNodes[nodeCfgItem.nodeType]
			table.insert(self.createdNodes[nodeCfgItem.nodeType], node)
			if isFromCache then
				node:release()
			end
		end
	end
	if _topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_NEW then
		_ENV = 1
		;(1)[1] = "ar"
		;(1)[2] = "en"
		local tipImg = SoraDGetImageNameByLang("img_common_new_%s.png", 1)
		self:setIcon(tipImg, nil, cc.p(0, 18))
		if self.imgIcon then
			self.imgIcon:setScale(1)
		end
	end
end
function cityBuildTop:setTipText(strTip)
	if self.textTip then
		self.textTip:setString(strTip)
	end
end
function cityBuildTop:removeNodeRelyOn()
	for k, v in pairs(self.tblNodeRelyOn) do
		if v and v.node then
			self[v.node:getName()] = nil
		end
	end
	self.tblNodeRelyOn, _ENV = pairs(self.tblNodeRelyOn)
end
function cityBuildTop:setIcon(iconName, size, pos)
	if self.imgIcon then
		self.imgIcon:setSpriteFrame((SoraDCheckPNG(iconName, "icon_item_common.png")))
		if size then
			self.imgIcon:setScaleX(size.width / self.imgIcon:getContentSize().width)
			self.imgIcon:setScaleY(size.height / self.imgIcon:getContentSize().height)
		end
		if pos then
			self.imgIcon:setPosition(pos)
		end
	end
end
function cityBuildTop:setImgBg(imgBgName)
	if self.imgBg then
		self.imgBg:setSpriteFrame((SoraDCheckPNG(imgBgName, "frame_main_receive.png")))
	end
end
function cityBuildTop:setAutoNpcRemove(delayTime, handle)
	self.handle = handle
	local actDelay = cca.delay(delayTime)
	local actCallFunc = cca.callFunc(function()
		self:stopTimer()
		self = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_NPC_TOP_TIP"
		self.bid = self.buildInfo.bid
		self.bIndex = self.buildInfo.bIndex
		SoraDSendMessage(self)
		if self.handle then
			self.handle()
		end
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = actDelay
	;(nil)[2] = actCallFunc
	local seq = cca.seq(nil)
	self:runAction(seq)
end
return cityBuildTop
