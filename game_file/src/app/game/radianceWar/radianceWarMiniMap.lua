local radianceWarMiniMap = class("radianceWarMiniMap", function()
	local node = display.newNode()
	return node
end)
local radianceWarRead = include("radianceWarRead")
local TILE_SIZE = 25
local TILE_WIDTH = 1760
local TILE_HEIGHT = 880
local offsetX = 0
local offsetY = TILE_HEIGHT * 0.5
local tileW = TILE_WIDTH / TILE_SIZE
local tileH = TILE_HEIGHT / TILE_SIZE
_UPVALUE16_ = nil
;(nil)[1] = tileW * 0.5
;(nil)[2] = -tileH * 0.5
;(nil)[3] = 0
;(nil)[4] = 0
;(nil)[5] = -tileW * 0.5
;(nil)[6] = -tileH * 0.5
;(nil)[7] = 0
;(nil)[8] = 0
;(nil)[9] = 0
;(nil)[10] = 0
;(nil)[11] = 1
;(nil)[12] = 0
;(nil)[13] = offsetX
;(nil)[14] = offsetY
;(nil)[15] = 0
local (nil)[16], tabmat = 1, nil
local alpha = 0.5
_UPVALUE3_ = -tileH * 0.5
;(-tileH * 0.5)[1] = cc.c4f(0.27450980392156865, 1.0, 0.5529411764705883, alpha)
;(-tileH * 0.5)[2] = cc.c4f(1.0, 0.25098039215686274, 0.16470588235294117, alpha)
;(-tileH * 0.5)[3] = cc.c4f(0.45098039215686275, 0.5686274509803921, 1.0, alpha)
;(-tileH * 0.5)[4] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[5] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[6] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[7] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[8] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[9] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[10] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[11] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[12] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
;(-tileH * 0.5)[13] = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
local (-tileH * 0.5)[14], color_kingdom = cc.c4f(1.0, 0.8901960784313725, 0.42745098039215684, alpha)
local default_color = color_kingdom[1]
local createMatrixFromCocos = function(mat)
	local vector4 = _G.CS.UnityEngine.Vector4
	local v1 = vector4(mat[1], mat[2], mat[3], mat[4])
	local v2 = vector4(mat[5], mat[6], mat[7], mat[8])
	local v3 = vector4(mat[9], mat[10], mat[11], mat[12])
	local v4 = vector4(mat[13], mat[14], mat[15], mat[16])
	local matUnity = _G.CS.UnityEngine.Matrix4x4(v1, v2, v3, v4)
	return matUnity
end
local matUnity = createMatrixFromCocos(tabmat)
function matrix_multiply(p)
	local vector4 = _G.CS.UnityEngine.Vector4
	local v1 = vector4(p.x, p.y, 0, 1)
	local result = matUnity * v1
	return cc.p(result.x, result.y)
end
function radianceWarMiniMap:ctor()
	self.node = display.newNode()
	self.node:addTo(self)
	local drawNode_point = self:createDrawNode()
	self.drawNode_point = drawNode_point
	local drawNode_line = self:createDrawNode()
	self.drawNode_line = drawNode_line
	local color_line = cc.c4f(1.0, 1.0, 1.0, 0.5)
	for i = 0, TILE_SIZE do
		drawNode_line:drawLine(matrix_multiply(cc.p(i, 0)), matrix_multiply(cc.p(i, TILE_SIZE)), color_line)
		drawNode_line:drawLine(matrix_multiply(cc.p(0, i)), matrix_multiply(cc.p(TILE_SIZE, i)), color_line)
	end
end
function radianceWarMiniMap:createDrawNode()
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(self.node)
	return drawNode
end
function radianceWarMiniMap:updateMiniMap(data)
	self.drawNode_point:clear()
	for _, v in ipairs(data) do
		local objectId = math.floor(v / 10)
		local pos = radianceWarRead.getBuildMiniInfo(objectId)
		if pos then
			local x, y = pos % TILE_SIZE, math.floor(pos / TILE_SIZE)
			local kid = v % 10
			local color = color_kingdom[kid] or default_color
			self:addObject(x, y, color)
		end
	end
end
function radianceWarMiniMap:addObject(x, y, color)
	_UPVALUE2_ = nil
	;(nil)[1] = matrix_multiply(cc.p(x, y))
	;(nil)[2] = matrix_multiply(cc.p(x, y + 1))
	;(nil)[3] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[4] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[5] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[6] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[7] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[8] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[9] = matrix_multiply(cc.p(x + 1, y + 1))
	;(nil)[10] = matrix_multiply(cc.p(x + 1, y + 1))
	local (nil)[11], point_draw = matrix_multiply(cc.p(x + 1, y + 1))
	_UPVALUE1_ = matrix_multiply(cc.p(x + 1, y + 1))
	matrix_multiply(cc.p(x + 1, y + 1)).fillColor = color
	matrix_multiply(cc.p(x + 1, y + 1)).borderWidth = 0
	matrix_multiply(cc.p(x + 1, y + 1)).borderColor = cc.c4b(0, 0, 0, 0)
	matrix_multiply(cc.p(x + 1, y + 1))[1] = 3
	self.drawNode_point:drawPolygon(point_draw, matrix_multiply(cc.p(x + 1, y + 1)))
	_UPVALUE2_ = self.drawNode_point.drawPolygon
	self.drawNode_point.drawPolygon[1] = matrix_multiply(cc.p(x, y))
	self.drawNode_point.drawPolygon[2] = matrix_multiply(cc.p(x + 1, y + 1))
	self.drawNode_point.drawPolygon[3] = matrix_multiply(cc.p(x + 1, y))
	self.drawNode_point.drawPolygon[4] = matrix_multiply(cc.p(x + 1, y))
	self.drawNode_point.drawPolygon[5] = matrix_multiply(cc.p(x + 1, y))
	self.drawNode_point.drawPolygon[6] = matrix_multiply(cc.p(x + 1, y))
	self.drawNode_point.drawPolygon[7] = matrix_multiply(cc.p(x + 1, y))
	self.drawNode_point.drawPolygon[8] = matrix_multiply(cc.p(x + 1, y))
	self.drawNode_point.drawPolygon[9] = matrix_multiply(cc.p(x + 1, y))
	local self.drawNode_point.drawPolygon[10], point_draw = matrix_multiply(cc.p(x + 1, y))
	_UPVALUE1_ = matrix_multiply(cc.p(x + 1, y))
	matrix_multiply(cc.p(x + 1, y)).fillColor = color
	matrix_multiply(cc.p(x + 1, y)).borderWidth = 0
	matrix_multiply(cc.p(x + 1, y)).borderColor = cc.c4b(0, 0, 0, 0)
	matrix_multiply(cc.p(x + 1, y))[1] = 3
	self.drawNode_point:drawPolygon(point_draw, matrix_multiply(cc.p(x + 1, y)))
end
return radianceWarMiniMap
