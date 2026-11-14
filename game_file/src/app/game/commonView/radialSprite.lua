local RadialSprite = class("RadialSprite", function()
	return gl.glNodeCreate()
end)
function RadialSprite:ctor(img)
	local sprite
	if type(img) == "string" then
		sprite = display.newSprite(img)
	elseif type(img) == "userdata" then
		sprite = img
	end
	self.spriteFrame = sprite:getSpriteFrame()
	self.spriteTexture = self.spriteFrame:getTexture()
	self.spriteRect = self.spriteFrame:getRect()
	self.isRotated = self.spriteFrame:isRotated()
	self:setContentSize(cc.size(self.spriteRect.width, self.spriteRect.height))
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self.midPos = cc.p(0.5, 0.5)
	self.topPos = cc.pAdd(self.midPos, cc.p(0, 3))
	self.beginAngle = 0
	_UPVALUE3_, self.endAngle = cc.pAdd(self.midPos, cc.p(0, 3)), 0
	self.displayVertexs, _ENV, self.vertexs, cc.pAdd(self.midPos, cc.p(0, 3))[1] = cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.p(0, 0)
	self.displayVertexs, _ENV, self.vertexs, cc.pAdd(self.midPos, cc.p(0, 3))[2] = cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.p(1, 0)
	self.displayVertexs, _ENV, self.vertexs, cc.pAdd(self.midPos, cc.p(0, 3))[3] = cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.p(1, 1)
	self.displayVertexs, _ENV, self.vertexs, cc.pAdd(self.midPos, cc.p(0, 3))[4] = cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.p(0, 1)
	self.displayVertexs, _ENV, self.vertexs, cc.pAdd(self.midPos, cc.p(0, 3))[5] = cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.p(0, 1)
	self.displayVertexs, _ENV, self.vertexs, cc.pAdd(self.midPos, cc.p(0, 3))[6] = cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.pAdd(self.midPos, cc.p(0, 3)), cc.p(0, 1)
	self:initGL(sprite)
end
function RadialSprite:initGL(sprite)
	self.posBufferId = gl.createBuffer()
	self.texBufferId = gl.createBuffer()
	self.colorBufferId = gl.createBuffer()
	self:registerScriptDrawHandler(handler(self, self.onDraw))
	local program, maskTexture
	maskTexture = sprite:getTexture():getAlphaTexture()
	if maskTexture then
		program = cc.GLProgramCache:getInstance():getGLProgram("sorad_normalPkm_mvp")
		if not program then
			program = cc.GLProgram:createWithFilenames("Shaders/normal_mvp.vsh", "Shaders/normal_pkm.fsh")
			cc.GLProgramCache:getInstance():addGLProgram(program, "sorad_normalPkm_mvp")
		end
	else
		program = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor")
	end
	self.program = program
	self.state = cc.GLProgramState:create(program)
	self:setGLProgramState(self.state)
	if maskTexture then
		self.state:setUniformTexture("mask_texture", maskTexture)
	end
end
function RadialSprite:vertexFromNormalizePoint(point)
	return cc.p(point.x * self.spriteRect.width, point.y * self.spriteRect.height)
end
function RadialSprite:texcoodFromNormalizePoint(point)
	local atlasWidth = self.spriteTexture:getPixelsWide()
	local atlasHeight = self.spriteTexture:getPixelsHigh()
	local pos = cc.p(0, 0)
	local min = cc.p(0, 0)
	local max = cc.p(0, 0)
	if self.isRotated then
		min.x = self.spriteRect.x / atlasWidth
		max.x = (self.spriteRect.x + self.spriteRect.height) / atlasWidth
		max.y = self.spriteRect.y / atlasHeight
		min.y = (self.spriteRect.y + self.spriteRect.width) / atlasHeight
		pos.x, pos.y = point.y, point.x
	else
		min.x = self.spriteRect.x / atlasWidth
		max.x = (self.spriteRect.x + self.spriteRect.width) / atlasWidth
		max.y = self.spriteRect.y / atlasHeight
		min.y = (self.spriteRect.y + self.spriteRect.height) / atlasHeight
		pos.x, pos.y = point.x, point.y
	end
	return cc.p(min.x * (1 - pos.x) + max.x * pos.x, min.y * (1 - pos.y) + max.y * pos.y)
end
function RadialSprite:setBeginAngle(beginAngle)
	beginAngle = util.clampf(beginAngle, 0, 360)
	if self.beginAngle ~= beginAngle then
		self.beginAngle = beginAngle
		self.dirty = true
	end
end
function RadialSprite:setEndAngle(endAngle)
	endAngle = util.clampf(endAngle, 0, 360)
	if self.endAngle ~= endAngle then
		self.endAngle = endAngle
		self.dirty = true
	end
end
function RadialSprite:setAngle(beginAngle, endAngle)
	self:setBeginAngle(beginAngle)
	self:setEndAngle(endAngle)
end
function RadialSprite:setMidpoint(point)
	point.x = util.clampf(point.x, 0, 1)
	point.y = util.clampf(point.y, 0, 1)
	if not util.vec2Equal(point, self.midPos) then
		self.midPos = point
		self.topPos = cc.pAdd(self.midPos, cc.p(0, 3))
		self.dirty = true
	end
end
function RadialSprite:rayCast(a, angle, c, d)
	local b = util.rotatePoint(self.topPos, a, angle)
	local denominator = (b.y - a.y) * (d.x - c.x) - (a.x - b.x) * (c.y - d.y)
	if util.correctZero(denominator) == 0 then
		return nil
	end
	local x = ((b.x - a.x) * (d.x - c.x) * (c.y - a.y) + (b.y - a.y) * (d.x - c.x) * a.x - (d.y - c.y) * (b.x - a.x) * c.x) / denominator
	local y = -((b.y - a.y) * (d.y - c.y) * (c.x - a.x) + (b.x - a.x) * (d.y - c.y) * a.y - (d.x - c.x) * (b.y - a.y) * c.y) / denominator
	x = util.correctZero(x)
	y = util.correctZero(y)
	if self:pointOnSegment(cc.p(x, y), c, d) and self:pointOnSegment(cc.p(x, y), a, b) and (x ~= a.x or y ~= a.y) then
		return cc.p(x, y)
	else
		return nil
	end
end
function RadialSprite:isPointIn(beginAngle, endAngle, midPoint, p)
	local angle = util.getAngle(midPoint, p)
	if angle == 0 or angle == 360 then
		if beginAngle == 0 or beginAngle == 360 then
			p.angle = beginAngle
			return true
		end
		if endAngle == 0 or endAngle == 360 then
			p.angle = endAngle
			return true
		end
	end
	if beginAngle < endAngle then
		if endAngle >= angle and beginAngle <= angle then
			p.angle = angle
			return true
		end
	elseif endAngle < beginAngle and (not (beginAngle > angle) or not (endAngle < angle)) then
		p.angle = angle
		return true
	end
	return false
end
function RadialSprite:pointOnSegment(p, a, b)
	if p.x >= math.min(a.x, b.x) and p.x <= math.max(a.x, b.x) and p.y >= math.min(a.y, b.y) and p.y <= math.max(a.y, b.y) then
		return true
	else
		return false
	end
end
function RadialSprite:updateRadial()
	self.displayVertexs, _ENV = nil, nil
	if self.beginAngle == self.endAngle then
		return
	end
	if math.abs(self.endAngle - self.beginAngle) < 360 then
		for i, v in ipairs(self.vertexs) do
			if not util.vec2Equal(v, self.midPos) and self:isPointIn(self.beginAngle, self.endAngle, self.midPos, v) then
				table.insert(self.displayVertexs, v)
			end
		end
		local hitBegin, hitEnd
		for i = 1, 4 do
			local j = i + 1
			if 4 < j then
				j = 1
			end
			hitBegin = hitBegin or self:rayCast(self.midPos, self.beginAngle, self.vertexs[i], self.vertexs[j])
			hitEnd = hitEnd or self:rayCast(self.midPos, self.endAngle, self.vertexs[i], self.vertexs[j])
		end
		for i = 1, 4 do
			if hitBegin and util.vec2Equal(self.vertexs[i], hitBegin) then
				hitBegin = nil
			end
			if hitEnd and util.vec2Equal(self.vertexs[i], hitEnd) then
				hitEnd = nil
			end
		end
		if hitBegin then
			hitBegin.angle = self.beginAngle
			table.insert(self.displayVertexs, hitBegin)
		end
		if hitEnd then
			hitEnd.angle = self.endAngle
			table.insert(self.displayVertexs, hitEnd)
		end
		if self.beginAngle > self.endAngle then
			for i, v in ipairs(self.displayVertexs) do
				if v.angle > self.endAngle then
					v.angle = -(360 - v.angle)
				end
			end
		end
		table.sort(self.displayVertexs, function(a, b)
			return a.angle < b.angle
		end)
		table.insert(self.displayVertexs, 1, self.midPos)
	else
		_UPVALUE5_ = nil
		self.displayVertexs, (nil)[1] = nil, self.midPos
		self.displayVertexs, (nil)[2] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[3] = nil, cc.p(1, 0)
		self.displayVertexs, (nil)[4] = nil, cc.p(0, 0)
		self.displayVertexs, (nil)[5] = nil, cc.p(0, 1)
		self.displayVertexs, (nil)[6] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[7] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[8] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[9] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[10] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[11] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[12] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[13] = nil, cc.p(1, 1)
		self.displayVertexs, (nil)[14] = nil, cc.p(1, 1)
	end
	local _ENV, vertices
	local _ENV, texcoords = self.midPos, self.midPos
	local _ENV, colors = cc.p(1, 1), cc.p(1, 1)
	local color = self:getColor()
	local opacity = self:getOpacity()
	for i, v in ipairs(self.displayVertexs) do
		local pos = self:vertexFromNormalizePoint(v)
		table.insert(vertices, pos.x)
		table.insert(vertices, pos.y)
		local tex = self:texcoodFromNormalizePoint(v)
		table.insert(texcoords, tex.x)
		table.insert(texcoords, tex.y)
		table.insert(colors, color.r / 255)
		table.insert(colors, color.g / 255)
		table.insert(colors, color.b / 255)
		table.insert(colors, opacity / 255)
	end
	gl.bindBuffer(gl.ARRAY_BUFFER, self.posBufferId)
	gl.bufferData(gl.ARRAY_BUFFER, table.getn(vertices), vertices, gl.DYNAMIC_DRAW)
	gl.bindBuffer(gl.ARRAY_BUFFER, self.texBufferId)
	gl.bufferData(gl.ARRAY_BUFFER, table.getn(texcoords), texcoords, gl.STATIC_DRAW)
	gl.bindBuffer(gl.ARRAY_BUFFER, self.colorBufferId)
	gl.bufferData(gl.ARRAY_BUFFER, table.getn(colors), colors, gl.STATIC_DRAW)
end
function RadialSprite:onDraw(transform, transformUpdated)
	if self.dirty then
		self.dirty = false
		self:updateRadial()
	end
	if #self.displayVertexs < 3 then
		return
	end
	self.program:use()
	self.program:setUniformsForBuiltins(transform)
	self.state:applyUniforms()
	local textureId = self.spriteTexture:getName()
	if gl._bindTexture2D then
		gl._bindTexture2D(gl.TEXTURE_2D, textureId)
	else
		gl.bindTexture(gl.TEXTURE_2D, textureId)
	end
	gl.glEnableVertexAttribs(cc.VERTEX_ATTRIB_FLAG_POS_COLOR_TEX)
	gl.bindBuffer(gl.ARRAY_BUFFER, self.posBufferId)
	gl.vertexAttribPointer(cc.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.bindBuffer(gl.ARRAY_BUFFER, self.texBufferId)
	gl.vertexAttribPointer(cc.VERTEX_ATTRIB_TEX_COORD, 2, gl.FLOAT, false, 0, 0)
	gl.bindBuffer(gl.ARRAY_BUFFER, self.colorBufferId)
	gl.vertexAttribPointer(cc.VERTEX_ATTRIB_COLOR, 4, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.TRIANGLE_FAN, 0, #self.displayVertexs)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function RadialSprite:getPointByRadius(angle, r)
	if r == 0 then
		return self.midPos
	end
	local hitPos
	for i = 1, 4 do
		local j = i + 1
		if 4 < j then
			j = 1
		end
		hitPos = hitPos or self:rayCast(self.midPos, angle, self.vertexs[i], self.vertexs[j])
	end
	local midPos = self:vertexFromNormalizePoint(self.midPos)
	hitPos = self:vertexFromNormalizePoint(hitPos)
	local dis = cc.pGetDistance(hitPos, midPos)
	if r <= dis then
		return cc.pAdd(cc.pMul(cc.pSub(hitPos, midPos), r / dis), midPos)
	else
		return nil
	end
end
return RadialSprite
