local gametop = gModuleMgr.getObject("gametop")
local PerlinNoiseView = class("PerlinNoiseView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("PerlinNoiseView")
	end
	return target
end)
function PerlinNoiseView:ctor()
	self.isHideCurrentSceneView = true
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_chat")
	self.btnApply = SoraDGetChildByName(self, "Button_Apply")
	self.tfPersistense = SoraDGetChildByName(self, "tf_persitence")
	self.tfOctaves = SoraDGetChildByName(self, "tf_octaves")
	self.tfDelta = SoraDGetChildByName(self, "tf_delta")
	print("self.btnApply = ", self.btnApply:getName())
	self.btnApply:addTouchEventListener(handler(self, self.btnApplyClick))
	self.persistence = 0.25
	self.octaves = 2
	self.delta = 0.01
	self.widthImg = 640
	local drawNode = cc.DrawNode:create()
	self:addChild(drawNode, 9)
	drawNode:setPosition(cc.p(0, 300))
	self.step = 10
	self.drawNode = drawNode
	self.tfPersistense:setString(tostring(self.persistence))
	self.tfOctaves:setString(tostring(self.octaves))
	self.tfDelta:setString(tostring(self.step))
end
function PerlinNoiseView:updateDrawNode()
	local getNV = function(vBegin, vEnd)
		local n = cc.p(0, 1)
		if math.abs(vEnd.y - vBegin.y) < 0.001 then
			n = cc.p(0, 1)
		else
			n = cc.p(1, -(vEnd.x - vBegin.x) / (vEnd.y - vBegin.y))
		end
		n = cc.pNormalize(n)
		rn = cc.p(-n.x, -n.y)
		local v = cc.pSub(vEnd, vBegin)
		if 0 < cc.pGetAngle(v, n) then
			return n, rn
		else
			return rn, n
		end
	end
	local vStart = cc.p(0, 0)
	local vTarget = cc.p(500, 400)
	local numOfStep = cc.pGetDistance(vStart, vTarget) / self.step
	local _ENV, posArray = self.step, self.step
	local n, rn = getNV(vStart, vTarget)
	for i = 1, numOfStep do
		local x = Linear_Interpolate(vStart.x, vTarget.x, i / numOfStep)
		local y = Linear_Interpolate(vStart.y, vTarget.y, i / numOfStep)
		local perlinValue = PerlinNoise(x, y, self.persistence, self.octaves)
		local nDelta
		if i == 1 or i == numOfStep then
			nDelta = cc.p(0, 0)
		else
			nDelta = cc.pMul(n, perlinValue * 50)
		end
		local Vi = cc.pAdd(cc.p(x, y), nDelta)
		table.insert(posArray, #posArray + 1, Vi)
	end
	self.drawNode:clear()
	local color = cc.c3b(255, 255, 255)
	_ENV = 255
	;(255).x = vStart.x
	_ENV, (255).y = vStart.y, vStart.y
	vStart.y.x = vTarget.x
	_ENV, vStart.y.y = vTarget.y, vTarget.y
	vTarget.y.r = color.r / 255
	vTarget.y.g = color.g / 255
	vTarget.y.b = color.b / 255
	vTarget.y.a = 1.0
	self.drawNode:drawLine(255, vStart.y, vTarget.y)
	local vBegin, vEnd
	local color = cc.c3b(255, 0, 0)
	local _ENV, linearPosArray = 255, 255
	for i = 1, #posArray - 1 do
		vBegin = posArray[i]
		vEnd = posArray[i + 1]
		table.insert(linearPosArray, #linearPosArray + 1, vBegin)
		local sepCos = 10
		for j = 1, sepCos do
			if 1 < j and j < sepCos then
				local vj = SoraDLinearInterpolate(vBegin, vEnd, j / sepCos)
				table.insert(linearPosArray, #linearPosArray + 1, vj)
			end
		end
		table.insert(linearPosArray, #linearPosArray + 1, vEnd)
	end
	color = cc.c3b(255, 0, 0)
	print("#linearPosArray = ", #linearPosArray)
	for i = 1, #linearPosArray - 1 do
		vBegin = linearPosArray[i]
		vEnd = linearPosArray[i + 1]
		_ENV = vEnd
		vEnd.r = color.r / 255
		vEnd.g = color.g / 255
		vEnd.b = color.b / 255
		vEnd.a = 1.0
		self.drawNode:drawLine(vBegin, vEnd, vEnd)
	end
	local _ENV, newPosArray = (for index), 1
	print("#posArray = ", #posArray)
	for i = 1, #posArray - 1 do
		vBegin = posArray[i]
		vEnd = posArray[i + 1]
		table.insert(newPosArray, #newPosArray + 1, vBegin)
		local sepCos = 10
		for j = 1, sepCos do
			if 1 < j and j < sepCos then
				local vj = SoraDCalcCosine(vBegin, vEnd, j / sepCos)
				table.insert(newPosArray, #newPosArray + 1, vj)
			end
		end
		table.insert(newPosArray, #newPosArray + 1, vEnd)
	end
	color = cc.c3b(0, 255, 0)
	print("#newPosArray = ", #newPosArray)
	for i = 1, #newPosArray - 1 do
		vBegin = newPosArray[i]
		vEnd = newPosArray[i + 1]
		_ENV = vEnd
		vEnd.r = color.r / 255
		vEnd.g = color.g / 255
		vEnd.b = color.b / 255
		vEnd.a = 1.0
		self.drawNode:drawLine(vBegin, vEnd, vEnd)
	end
	local _ENV, cubicPosArray = (for index), 1
	print("#posArray = ", #posArray)
	for i = 1, #posArray - 1 do
		local v1, v2, v3, v4
		vBegin = posArray[i]
		vEnd = posArray[i + 1]
		table.insert(cubicPosArray, #cubicPosArray + 1, vBegin)
		v2 = vBegin
		v3 = vEnd
		if i == 1 then
			v1 = cc.pAdd(v2, cc.pSub(v2, v3))
		else
			v1 = posArray[i - 1]
		end
		if i == #posArray - 1 then
			v4 = cc.pAdd(v3, cc.pSub(v3, v2))
		else
			v4 = posArray[i + 2]
		end
		local sepCos = 10
		for j = 1, sepCos do
			if 1 < j and j < sepCos then
				local vj = SoraDCubicInterpolate(v1, v2, v3, v4, j / sepCos)
				table.insert(cubicPosArray, #cubicPosArray + 1, vj)
			end
		end
		table.insert(cubicPosArray, #cubicPosArray + 1, vEnd)
	end
	color = cc.c3b(0, 0, 255)
	print("#cubicPosArray = ", #cubicPosArray)
	for i = 1, #cubicPosArray - 1 do
		vBegin = cubicPosArray[i]
		vEnd = cubicPosArray[i + 1]
		_ENV = 10
		;(10).r = color.r / 255
		;(10).g = color.g / 255
		;(10).b = color.b / 255
		;(10).a = 1.0
		self.drawNode:drawLine(vBegin, vEnd, 10)
	end
	color = cc.c3b(255, 255, 255)
	_ENV = 255
	;(255).x = vStart.x
	_ENV, (255).y = vStart.y, vStart.y
	vStart.y.x = vTarget.x
	_ENV, vStart.y.y = vTarget.y, vTarget.y
	vTarget.y.r = color.r / 255
	vTarget.y.g = color.g / 255
	vTarget.y.b = color.b / 255
	vTarget.y.a = 1.0
	self.drawNode:drawLine(255, vStart.y, vTarget.y)
end
function PerlinNoiseView:btnApplyClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local persistence = tonumber(self.tfPersistense:getString())
		if persistence then
			self.persistence = persistence
		end
		local octaves = tonumber(self.tfOctaves:getString())
		if octaves then
			self.octaves = octaves
		end
		local step = tonumber(self.tfDelta:getString())
		if step then
			self.step = step
		end
		self:updateDrawNode()
	end
end
return PerlinNoiseView
