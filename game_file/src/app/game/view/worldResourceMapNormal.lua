local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local worldMapDefine = include("worldMapDefine")
local nationalFlagRead = include("nationalFlagRead")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local worldResourceMapNormal = class("worldResourceMapNormal", function(target)
	return target
end)
function worldResourceMapNormal:ctor()
end
function worldResourceMapNormal:initScroll(mapName)
	self.containerView = cc.CSLoader:createNode(getCCSPath(mapName))
	self.viewScrollView = cc.ScrollView:create(self:getContentSize())
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setMinScale(1.0)
	self.viewScrollView:setMaxScale(1.0)
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setClippingToBounds(false)
	self.viewScrollView:setAnchorPoint(cc.p(0.5, 0.5))
	local containerViewSize = self.containerView:getContentSize()
	local containerViewscale = self.viewScrollView:getZoomScale()
	self.viewScrollView:setContentOffset(cc.p(-(containerViewSize.width - display.width) / 2 * containerViewscale, -(containerViewSize.height - display.height) / 2 * containerViewscale), false)
	self.viewScrollView:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
	self:addChild(self.viewScrollView, 0)
	self.containerViewCenterPoint = cc.p(containerViewSize.width / 2, containerViewSize.height / 2)
end
function worldResourceMapNormal:initTouchlayer(...)
	self.touchlayer = ccui.Layout:create()
	self.touchlayer:setContentSize(self.containerView:getContentSize())
	self.touchlayer:addTo(self.containerView, 10)
	self.touchlayer:setTouchEnabled(true)
	self.touchlayer:setSwallowTouches(false)
	self.touchlayer:addTouchEventListener(function(ref, type)
		self:viewOnClick(ref, type)
	end)
end
function worldResourceMapNormal:initBgArea(...)
	self.bgArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, self.containerView:getContentSize().width * 2, self.containerView:getContentSize().height * 2))
	self.bgArea:ignoreAnchorPointForPosition(false)
	self.bgArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.bgArea:setPosition(cc.p(-self.containerView:getContentSize().width / 2, -self.containerView:getContentSize().height / 2))
	self.containerView:addChild(self.bgArea, -1)
end
function worldResourceMapNormal:moveMapPointToCenter(point, duration)
	duration = duration or 0
	local zoomScale = self.viewScrollView:getZoomScale()
	local centerPoint = cc.p(display.cx, display.cy)
	local covertPoint = self.touchlayer:convertToNodeSpace(centerPoint)
	local offsetPoint = self.viewScrollView:getContentOffset()
	local subPoint = cc.pSub(covertPoint, point)
	local containerSize = self.containerView:getContentSize()
	local newOffsetPoint = cc.pAdd(offsetPoint, subPoint)
	newOffsetPoint = cc.p(newOffsetPoint.x * zoomScale, newOffsetPoint.y * zoomScale)
	if 0 < newOffsetPoint.x then
		newOffsetPoint.x = 0
	end
	if newOffsetPoint.x < display.width - containerSize.width then
		newOffsetPoint.x = display.width - containerSize.width
	end
	if 0 < newOffsetPoint.y then
		newOffsetPoint.y = 0
	end
	if newOffsetPoint.y < display.height - containerSize.height then
		newOffsetPoint.y = display.height - containerSize.height
	end
	if containerSize.height <= display.height then
		newOffsetPoint.y = 0
	end
	if 0 < duration then
		self.viewScrollView:setContentOffsetInDuration(newOffsetPoint, duration)
	else
		self.viewScrollView:setContentOffset(newOffsetPoint)
	end
end
function worldResourceMapNormal:moveSubPointToCenter(target, data)
	local subPoint = data.subPoint
	if self.ratioToResource then
		subPoint.x = subPoint.x * self.ratioToResource
		subPoint.y = subPoint.y * self.ratioToResource
	end
	local targetPoint = cc.pSub(self.containerViewCenterPoint, subPoint)
	print("subPoint.x,subPoint.y=", subPoint.x, subPoint.y)
	local arrowAction = function(...)
		self.node_arrow = display.newNode()
		self.node_arrow:setPosition(targetPoint)
		self.node_arrow:addTo(self.containerView, 11)
		for i = 1, 4 do
			local arrowSprite = display.newSprite("#UI_map_Arrow.png")
			arrowSprite:setAnchorPoint(cc.p(1.0, 0.5))
			arrowSprite:setScaleX(1.0)
			arrowSprite:setScaleY(0.5)
			arrowSprite:addTo(self.node_arrow)
			local numLength = 20
			local point1 = cc.p(numLength, 0)
			local point2 = cc.p(numLength, 0)
			if i == 1 then
				point1 = cc.p(-numLength, 0)
				point2 = cc.p(numLength, 0)
				arrowSprite:setRotation(0)
			elseif i == 2 then
				point1 = cc.p(0, numLength)
				point2 = cc.p(0, -numLength)
				arrowSprite:setRotation(90)
			elseif i == 3 then
				point1 = cc.p(numLength, 0)
				point2 = cc.p(-numLength, 0)
				arrowSprite:setRotation(180)
			elseif i == 4 then
				point1 = cc.p(0, -numLength)
				point2 = cc.p(0, numLength)
				arrowSprite:setRotation(-90)
			end
			local self, actionsArray = arrowSprite.setRotation, arrowSprite.setRotation
			actionsArray[#actionsArray + 1] = cc.MoveBy:create(1.0, point1)
			actionsArray[#actionsArray + 1] = cc.MoveBy:create(1.0, point2)
			local action = transition.sequence(actionsArray)
			arrowSprite:stopAllActions()
			arrowSprite:runAction(cc.RepeatForever:create(action))
		end
	end
	local _ENV, actionsArray = "subPoint.x,subPoint.y=", "subPoint.x,subPoint.y="
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		SoraDShowLoading(self)
		self:moveMapPointToCenter(targetPoint, 1.0)
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.5)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		SoraDCloseLoading(self)
		if self.mapKindomID == worldMapDefine.currentMapKindomID then
			arrowAction()
		end
	end)
	local actions = transition.sequence(actionsArray)
	self.viewScrollView:runAction(actions)
end
function worldResourceMapNormal:showJumpAction(covertPoint, hander)
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:moveMapPointToCenter(covertPoint, 0.5)
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.6)
	actionsArray[#actionsArray + 1] = cc.ScaleTo:create(0.5, 2, 2)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.1)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(hander)
	local actions = transition.sequence(actionsArray)
	self.viewScrollView:runAction(actions)
end
function worldResourceMapNormal:addResourcePoint(offsetX, offsetY)
	local containerViewSize = self.containerView:getContentSize()
	_UPVALUE2_, _UPVALUE4_ = nil, self.containerView
	_UPVALUE2_, (nil)[1] = 0 + offsetX, 0 + offsetX
	_UPVALUE2_, (nil)[2] = 0 + offsetX, containerViewSize.height / 2
	_UPVALUE2_, (0 + offsetX)[1] = containerViewSize.width / 2, containerViewSize.width / 2
	_UPVALUE2_, (0 + offsetX)[2] = containerViewSize.width / 2, containerViewSize.height - offsetY
	_UPVALUE2_, (containerViewSize.width / 2)[1] = containerViewSize.width - offsetX, containerViewSize.width - offsetX
	_UPVALUE2_, (containerViewSize.width / 2)[2] = containerViewSize.width - offsetX, containerViewSize.height / 2
	;(containerViewSize.width - offsetX)[1] = containerViewSize.width / 2
	;(containerViewSize.width - offsetX)[2] = offsetY
	self.containerView[1] = nil
	self.containerView[2] = 0 + offsetX
	self.containerView[3] = containerViewSize.width / 2
	local self.containerView[4], resourcePoints = containerViewSize.width - offsetX, self.containerView
	self.resourcePolygonPtArray, _ENV, self.resourcePoints = nil, nil, resourcePoints
	for k, v in pairs(resourcePoints) do
		self.resourcePolygonPtArray[#self.resourcePolygonPtArray + 1] = cc.p(v[1], v[2])
	end
end
function worldResourceMapNormal:addPolygonPoint(point, weight, height)
	_UPVALUE2_, _UPVALUE4_ = nil, nil
	_UPVALUE2_, (nil)[1] = point.x - weight, point.x - weight
	_UPVALUE2_, (nil)[2] = point.x - weight, point.y
	_UPVALUE2_, (point.x - weight)[1] = point.x, point.x
	_UPVALUE2_, (point.x - weight)[2] = point.x, point.y - height
	_UPVALUE2_, point.x[1] = point.x + weight, point.x + weight
	_UPVALUE2_, point.x[2] = point.x + weight, point.y
	;(point.x + weight)[1] = point.x
	;(point.x + weight)[2] = point.y + height
	;(nil)[1] = nil
	;(nil)[2] = point.x - weight
	;(nil)[3] = point.x
	local (nil)[4], cityPoints = point.x + weight, nil
	local _ENV, cityPolygonPtArray
	for _, v in pairs(cityPoints) do
		cityPolygonPtArray[#cityPolygonPtArray + 1] = cc.p(v[1], v[2])
	end
	_ENV = pairs(cityPoints)
	pairs(cityPoints).cityPolygonPtArray = cityPolygonPtArray
	pairs(cityPoints).point = point
	table.insert(self.cityPolygonPtArray, pairs(cityPoints))
end
function worldResourceMapNormal:createBorder(width)
	if self.Node_border then
		self.Node_border:removeFromParent()
		self.Node_border = nil
	end
	width = width or worldMapDefine.worldResourceMapSize.width
	self.Node_border = SoraDCreateDiamondNode(width, false, "bluelight.png")
	self.Node_border:setPosition(cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height / 2))
	self.Node_border:addTo(self.containerView)
end
function worldResourceMapNormal:initColorLayer()
	self.colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
	self.colorLayer:setContentSize(cc.size(self.containerView:getContentSize().width * 2, self.containerView:getContentSize().height * 2))
	self.colorLayer:setPosition(cc.p(self.containerViewCenterPoint.x - self.colorLayer:getContentSize().width / 2, self.containerViewCenterPoint.y - self.colorLayer:getContentSize().height / 2))
	self.mapViewcliperNode = cc.ClippingNode:create()
	self.containerView:addChild(self.mapViewcliperNode, 1)
	self.mapViewcliperNode:addChild(self.colorLayer)
	self.mapViewcliperNode:setInverted(true)
	_ENV = self.mapViewcliperNode.setInverted
	self.mapViewcliperNode.setInverted.fillColor = cc.c4f(1, 1, 1, 0.5)
	self.mapViewcliperNode.setInverted.borderColor = cc.c4f(0, 1, 0, 0)
	local self.mapViewcliperNode.setInverted.borderWidth, params = 0, self.mapViewcliperNode.setInverted
	local points = self.resourcePoints
	local shapNode = display.newPolygon(points, params)
	self.mapViewcliperNode:setStencil(shapNode)
end
function worldResourceMapNormal:addCloudAction()
	local showCloud = function()
		math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
		local Node_cloud = SoraDGetChildByName(self, "Node_cloud")
		Node_cloud:setLocalZOrder(100)
		for i = 1, 8 do
			local img_cloud = SoraDGetChildByName(Node_cloud, "Image_" .. i)
			if img_cloud then
				local x, _ = img_cloud:getPosition()
				local offsetSpeed = math.random(-20, 20)
				self:addCloudActionSingle(img_cloud, x, offsetSpeed + 50)
			end
		end
	end
	showCloud()
end
function worldResourceMapNormal:addCloudActionSingle(img, x, speed)
	local _ENV, actionsArray
	local sizeX = img:getContentSize().width / 2
	local maxsizeX = self.containerView:getContentSize().width / 2
	local length = maxsizeX - x + sizeX
	local time = length / speed
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.6)
	actionsArray[#actionsArray + 1] = cc.MoveBy:create(time, cc.p(length, 0))
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.1)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local newx = -(maxsizeX + sizeX)
		img:setPositionX(newx)
		self:addCloudActionSingle(img, newx, speed)
	end)
	local actions = transition.sequence(actionsArray)
	img:runAction(actions)
end
return worldResourceMapNormal
