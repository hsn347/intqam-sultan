local baseFguiPanel = require("fgui.base.baseFguiPanel")
local OBBTestPanel = class("OBBTestPanel", baseFguiPanel)
_ENV = "OBBTestPanel"
;("OBBTestPanel").center = cc.p(0, 0)
;("OBBTestPanel").halfExtents = cc.p(0, 0)
local ("OBBTestPanel").rotation, struct_OBB = 0, "OBBTestPanel"
function OBBTestPanel:ctor(...)
	self.debug = true
	OBBTestPanel.super.ctor(self, ...)
	print("OBBTestPanel:ctor", self.viewName)
end
local step = 50
local zero = cc.p(display.cx, display.cy)
local color = cc.c4b(255, 255, 255, 125)
function OBBTestPanel:onInit()
	print("=======OBBTestPanel:onInit")
	self.fields.Com_title:initData(i18n("OBB碰撞检测"), handler(self, self.onClickClose))
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(self.fields.drawNode)
	self.drawNode = drawNode
	self.drawNode:setLineWidth(2)
	local axis_x1 = cc.p(0, zero.y)
	local axis_x2 = cc.p(zero.x * 2, zero.y)
	self.drawNode:drawLine(axis_x1, axis_x2, color)
	local axis_y1 = cc.p(zero.x, 0)
	local axis_y2 = cc.p(zero.x, zero.y * 2)
	self.drawNode:drawLine(axis_y1, axis_y2, color)
	self.drawNode:setLineWidth(1)
	for i = -10, 10 do
		local posx = axis_y1.x + i * step
		local posy = axis_x1.y + i * step
		self.drawNode:drawLine(cc.p(posx, axis_y1.y), cc.p(posx, axis_y2.y), color)
		self.drawNode:drawLine(cc.p(axis_x1.x, posy), cc.p(axis_x2.x, posy), color)
	end
end
function OBBTestPanel:endShow()
	print("=======OBBTestPanel:endShow")
	self.obb_a = self:newOBB(self.fields.rect1, cc.p(0, 0), cc.p(2, 1), 0)
	self.obb_b = self:newOBB(self.fields.rect2, cc.p(3, 2), cc.p(2, 1), math.pi / 4)
	self:checkCollide()
	self.timer = SoradCreateTimer(self, handler(self, self.updateTime), true)
end
function OBBTestPanel:updateTime(dt)
	local rotation = self.obb_b.rotation
	self.obb_b.rotation = rotation + dt * math.pi / 10
	self.fields.rect2:setRotation(self.obb_b.rotation / math.pi * 180)
	self:checkCollide()
end
function OBBTestPanel:checkCollide(...)
	if self:isOBBColliding(self.obb_a, self.obb_b) then
		self.fields.rect1:setColor(display.COLOR_RED)
		self.fields.rect2:setColor(display.COLOR_RED)
	else
		self.fields.rect1:setColor(display.COLOR_GREEN)
		self.fields.rect2:setColor(display.COLOR_GREEN)
	end
end
function OBBTestPanel:newOBB(obj, center, halfExtents, rotation)
	local OBB = clone(struct_OBB)
	OBB.center = center or OBB.center
	OBB.halfExtents = halfExtents or OBB.halfExtents
	OBB.rotation = rotation or OBB.rotation
	obj:setPosition(cc.p(OBB.center.x * step + zero.x, OBB.center.y * step + zero.y))
	obj:setContentSize(cc.size(OBB.halfExtents.x * 2 * step, OBB.halfExtents.y * 2 * step))
	obj:setRotation(OBB.rotation / math.pi * 180)
	return OBB
end
function OBBTestPanel:isOBBColliding(obb_a, obb_b)
	local verticesA = self:getOBBVertices(obb_a)
	dump(verticesA, "==OBBTestPanel:isOBBColliding=verticesA=")
	local verticesB = self:getOBBVertices(obb_b)
	dump(verticesB, "==OBBTestPanel:isOBBColliding=verticesB=")
	_ENV = dump
	dump[1] = cc.p(verticesA[1].x - verticesA[0].x, verticesA[1].y - verticesA[0].y)
	dump[2] = cc.p(verticesA[3].x - verticesA[0].x, verticesA[3].y - verticesA[0].y)
	dump[3] = cc.p(verticesB[1].x - verticesB[0].x, verticesB[1].y - verticesB[0].y)
	local dump[4], axes = cc.p(verticesB[3].x - verticesB[0].x, verticesB[3].y - verticesB[0].y), dump
	for __, axis in ipairs(axes) do
		if self:isSeparatedOnAxis(axis, verticesA, verticesB) then
			return false
		end
	end
	return true
end
function OBBTestPanel:getOBBVertices(obb)
	local cosTheta = math.cos(obb.rotation)
	local sinTheta = math.sin(obb.rotation)
	print("==OBBTestPanel:getOBBVertices==", obb.rotation, cosTheta, sinTheta)
	local extentsX = cc.p(obb.halfExtents.x * cosTheta, obb.halfExtents.x * sinTheta)
	local extentsY = cc.p(-obb.halfExtents.y * sinTheta, obb.halfExtents.y * cosTheta)
	_ENV = -obb.halfExtents.y * sinTheta
	;(-obb.halfExtents.y * sinTheta)[0] = cc.p(obb.center.x - extentsX.x - extentsY.x, obb.center.y - extentsX.y - extentsY.y)
	;(-obb.halfExtents.y * sinTheta)[1] = cc.p(obb.center.x + extentsX.x - extentsY.x, obb.center.y + extentsX.y - extentsY.y)
	;(-obb.halfExtents.y * sinTheta)[2] = cc.p(obb.center.x + extentsX.x + extentsY.x, obb.center.y + extentsX.y + extentsY.y)
	;(-obb.halfExtents.y * sinTheta)[3] = cc.p(obb.center.x - extentsX.x + extentsY.x, obb.center.y - extentsX.y + extentsY.y)
	return -obb.halfExtents.y * sinTheta
end
function OBBTestPanel:isSeparatedOnAxis(axis, verticesA, verticesB)
	local minA = cc.pDot(axis, verticesA[0])
	local maxA = minA
	for i = 1, 3 do
		local projection = cc.pDot(axis, verticesA[i])
		minA = math.min(minA, projection)
		maxA = math.max(maxA, projection)
	end
	local minB = cc.pDot(axis, verticesB[0])
	local maxB = minB
	for i = 1, 3 do
		local projection = cc.pDot(axis, verticesB[i])
		minB = math.min(minB, projection)
		maxB = math.max(maxB, projection)
	end
	_ENV = 3
	;(3).minA = minA
	;(3).maxA = maxA
	;(3).minB = minB
	;(3).maxB = maxB
	;(3).ret = not (minA <= maxB) or not (maxA >= minB)
	dump(3, "==OBBTestPanel:isSeparatedOnAxis==")
	return not (minA <= maxB) or not (maxA >= minB)
end
return OBBTestPanel
