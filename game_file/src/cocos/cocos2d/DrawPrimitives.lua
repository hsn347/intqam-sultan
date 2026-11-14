local dp_initialized = false
local dp_shader
local dp_colorLocation = -1
_UPVALUE4_ = nil
;(nil)[1] = 1.0
;(nil)[2] = 1.0
;(nil)[3] = 1.0
local (nil)[4], dp_color = 1.0, nil
local dp_pointSizeLocation = -1
local dp_pointSize = 1.0
local SHADER_NAME_POSITION_U_COLOR = "ShaderPosition_uColor"
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local lazy_init = function()
	if not dp_initialized and nil ~= dp_shader then
		dp_Initialized = true
	end
	if nil == dp_shader then
		print("Error:dp_shader is nil!")
		return false
	end
	return true
end
local setDrawProperty = function()
	gl.glEnableVertexAttribs(CCConstants.VERTEX_ATTRIB_FLAG_POSITION)
	dp_shader:use()
	dp_shader:setUniformsForBuiltins()
	dp_shader:setUniformLocationWith4fv(dp_colorLocation, dp_color, 1)
end
function ccDrawInit()
	lazy_init()
end
function ccDrawFree()
end
function ccDrawColor4f(r, g, b, a)
	dp_color[1] = r
	dp_color[2] = g
	dp_color[3] = b
	dp_color[4] = a
end
function ccPointSize(pointSize)
end
function ccDrawColor4B(r, g, b, a)
	dp_color[1] = r / 255.0
	dp_color[2] = g / 255.0
	dp_color[3] = b / 255.0
	dp_color[4] = a / 255.0
end
function ccDrawPoint(point)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local initBuffer = function()
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		point = gl.bindBuffer
		gl.bindBuffer[1] = point.x
		local gl.bindBuffer[2], vertices = point.y, gl.bindBuffer
		gl.bufferData(gl.ARRAY_BUFFER, 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	dp_shader:setUniformLocationWith1f(dp_pointSizeLocation, dp_pointSize)
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.POINTS, 0, 1)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawPoints(points, numOfPoint)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local i = 1
	local initBuffer = function()
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		local vertexBuffer, vertices = gl.bindBuffer, gl.bindBuffer
		for i = 1, numOfPoint do
			vertices[2 * i - 1] = points[i].x
			vertices[2 * i] = points[i].y
		end
		gl.bufferData(gl.ARRAY_BUFFER, numOfPoint * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	dp_shader:setUniformLocationWith1f(dp_pointSizeLocation, dp_pointSize)
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.POINTS, 0, numOfPoint)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawLine(origin, destination)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local initBuffer = function()
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		_UPVALUE4_ = gl.bindBuffer
		gl.bindBuffer[1] = origin.x
		gl.bindBuffer[2] = origin.y
		gl.bindBuffer[3] = destination.x
		local gl.bindBuffer[4], vertices = destination.y, gl.bindBuffer
		gl.bufferData(gl.ARRAY_BUFFER, 4, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.LINES, 0, 2)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawPoly(points, numOfPoints, closePolygon)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local i = 1
	local initBuffer = function()
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		local vertexBuffer, vertices = gl.bindBuffer, gl.bindBuffer
		for i = 1, numOfPoints do
			vertices[2 * i - 1] = points[i].x
			vertices[2 * i] = points[i].y
		end
		gl.bufferData(gl.ARRAY_BUFFER, numOfPoints * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	if closePolygon then
		gl.drawArrays(gl.LINE_LOOP, 0, numOfPoints)
	else
		gl.drawArrays(gl.LINE_STRIP, 0, numOfPoints)
	end
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawSolidPoly(points, numOfPoints, color)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local i = 1
	local initBuffer = function()
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		local vertexBuffer, vertices = gl.bindBuffer, gl.bindBuffer
		for i = 1, numOfPoints do
			vertices[2 * i - 1] = points[i].x
			vertices[2 * i] = points[i].y
		end
		gl.bufferData(gl.ARRAY_BUFFER, numOfPoints * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	gl.glEnableVertexAttribs(CCConstants.VERTEX_ATTRIB_FLAG_POSITION)
	dp_shader:use()
	dp_shader:setUniformsForBuiltins()
	dp_shader:setUniformLocationWith4fv(dp_colorLocation, color, 1)
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.TRIANGLE_FAN, 0, numOfPoints)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawRect(origin, destination)
	ccDrawLine(CCPoint:__call(origin.x, origin.y), CCPoint:__call(destination.x, origin.y))
	ccDrawLine(CCPoint:__call(destination.x, origin.y), CCPoint:__call(destination.x, destination.y))
	ccDrawLine(CCPoint:__call(destination.x, destination.y), CCPoint:__call(origin.x, destination.y))
	ccDrawLine(CCPoint:__call(origin.x, destination.y), CCPoint:__call(origin.x, origin.y))
end
function ccDrawSolidRect(origin, destination, color)
	_UPVALUE3_ = nil
	;(nil)[1] = origin
	;(nil)[2] = CCPoint:__call(destination.x, origin.y)
	;(nil)[3] = destination
	;(nil)[4] = CCPoint:__call(origin.x, destination.y)
	;(nil)[5] = CCPoint:__call(origin.x, destination.y)
	;(nil)[6] = CCPoint:__call(origin.x, destination.y)
	local (nil)[7], vertices = CCPoint:__call(origin.x, destination.y)
	ccDrawSolidPoly(vertices, 4, color)
end
function ccDrawCircleScale(center, radius, angle, segments, drawLineToCenter, scaleX, scaleY)
	if not lazy_init() then
		return
	end
	local additionalSegment = 1
	if drawLineToCenter then
		additionalSegment = additionalSegment + 1
	end
	local lazy_init, vertexBuffer
	local initBuffer = function()
		local coef = 2.0 * math.pi / segments
		local i = 1
		local _ENV, vertices
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		for i = 1, segments + 1 do
			local rads = (i - 1) * coef
			local j = radius * math.cos(rads + angle) * scaleX + center.x
			local k = radius * math.sin(rads + angle) * scaleY + center.y
			vertices[i * 2 - 1] = j
			vertices[i * 2] = k
		end
		vertices[(segments + 2) * 2 - 1] = center.x
		vertices[(segments + 2) * 2] = center.y
		gl.bufferData(gl.ARRAY_BUFFER, (segments + 2) * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.LINE_STRIP, 0, segments + additionalSegment)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawCircle(center, radius, angle, segments, drawLineToCenter)
	ccDrawCircleScale(center, radius, angle, segments, drawLineToCenter, 1.0, 1.0)
end
function ccDrawSolidCircle(center, radius, angle, segments, scaleX, scaleY)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local initBuffer = function()
		local coef = 2.0 * math.pi / segments
		local i = 1
		local _ENV, vertices
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		for i = 1, segments + 1 do
			local rads = (i - 1) * coef
			local j = radius * math.cos(rads + angle) * scaleX + center.x
			local k = radius * math.sin(rads + angle) * scaleY + center.y
			vertices[i * 2 - 1] = j
			vertices[i * 2] = k
		end
		vertices[(segments + 2) * 2 - 1] = center.x
		vertices[(segments + 2) * 2] = center.y
		gl.bufferData(gl.ARRAY_BUFFER, (segments + 2) * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.TRIANGLE_FAN, 0, segments + 1)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawQuadBezier(origin, control, destination, segments)
	if not lazy_init() then
		return
	end
	local lazy_init, vertexBuffer = lazy_init(), lazy_init()
	local initBuffer = function()
		local segments, vertices
		local i = 1
		local t = 0.0
		for i = 1, segments do
			vertices[2 * i - 1] = math.pow(1 - t, 2) * origin.x + 2.0 * (1 - t) * t * control.x + t * t * destination.x
			vertices[2 * i] = math.pow(1 - t, 2) * origin.y + 2.0 * (1 - t) * t * control.y + t * t * destination.y
			t = t + 1.0 / segments
		end
		vertices[2 * (segments + 1) - 1] = destination.x
		vertices[2 * (segments + 1)] = destination.y
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		gl.bufferData(gl.ARRAY_BUFFER, (segments + 1) * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.LINE_STRIP, 0, segments + 1)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
function ccDrawCubicBezier(origin, control1, control2, destination, segments)
	if not lazy_init then
		return
	end
	local lazy_init, vertexBuffer = lazy_init, lazy_init
	local initBuffer = function()
		local segments, vertices
		local t = 0
		local i = 1
		for i = 1, segments do
			vertices[2 * i - 1] = math.pow(1 - t, 3) * origin.x + 3.0 * math.pow(1 - t, 2) * t * control1.x + 3.0 * (1 - t) * t * t * control2.x + t * t * t * destination.x
			vertices[2 * i] = math.pow(1 - t, 3) * origin.y + 3.0 * math.pow(1 - t, 2) * t * control1.y + 3.0 * (1 - t) * t * t * control2.y + t * t * t * destination.y
			t = t + 1.0 / segments
		end
		vertices[2 * (segments + 1) - 1] = destination.x
		vertices[2 * (segments + 1)] = destination.y
		vertexBuffer.buffer_id = gl.createBuffer()
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
		gl.bufferData(gl.ARRAY_BUFFER, (segments + 1) * 2, vertices, gl.STATIC_DRAW)
		gl.bindBuffer(gl.ARRAY_BUFFER, 0)
	end
	initBuffer()
	setDrawProperty()
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer.buffer_id)
	gl.vertexAttribPointer(CCConstants.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
	gl.drawArrays(gl.LINE_STRIP, 0, segments + 1)
	gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end
