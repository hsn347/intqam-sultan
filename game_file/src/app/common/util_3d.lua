function cc.pAdd3D(pt1, pt2)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x + pt2.x
	;(nil).y = pt1.y + pt2.y
	;(nil).z = pt1.z + pt2.z
	return nil
end
function cc.pSub3D(pt1, pt2)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x - pt2.x
	;(nil).y = pt1.y - pt2.y
	;(nil).z = pt1.z - pt2.z
	return nil
end
function cc:pDot3D(other)
	return self.x * other.x + self.y * other.y + self.z * other.z
end
function cc.pMul3D(pt1, factor)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x * factor
	;(nil).y = pt1.y * factor
	;(nil).z = pt1.z * factor
	return nil
end
function SoraRayIntersectsPlane(ray, plane)
	local p0 = cc.pSub3D(plane.pos, ray.origin)
	local dotDN = cc.pDot3D(ray.direction, plane.normal)
	if math.abs(dotDN) < 1.0E-6 then
		return false
	end
	local t = cc.pDot3D(p0, plane.normal) / dotDN
	local pt = cc.pAdd3D(ray.origin, cc.pMul3D(ray.direction, t))
	return true, pt
end
function SoraConvertToWorldSpace3D(target, nodePos)
	_ENV = nil
	;(nil).x = nodePos.x
	;(nil).y = nodePos.y
	;(nil).z = 0
	local (nil).w, nodePos3D = 1, nil
	local val_mat4_to_world = target:getNodeToWorldTransform()
	local mat4_to_world = cc.mat4.new(val_mat4_to_world)
	_ENV = nil
	local worldPoint = mat4_to_world:transformVector(nodePos3D, nil)
	return worldPoint
end
function SoraConvertToWorldSpace2DOr3D(target, nodePos)
	if gEnableWorldMap3D then
		return SoraConvertToWorldSpace3D(target, nodePos)
	else
		return target:convertToWorldSpace(nodePos)
	end
end
function SoraConvertToNodeSpace2DOr3D(target, world3DPos)
	if gEnableWorldMap3D then
		return SoraConvertToNodeSpace3D(target, world3DPos)
	else
		return target:convertToNodeSpace(world3DPos)
	end
end
function SoraConvertToNodeSpace3D(target, world3DPos)
	local val_mat4_to_node = target:getWorldToNodeTransform()
	local mat4_to_node = cc.mat4.new(val_mat4_to_node)
	world3DPos.w = 1
	_ENV = nil
	return mat4_to_node:transformVector(world3DPos, nil)
end
function SoraDGet3DTouchPos(target, touchPos, params)
	local rotationX = gWorldMapRotation3D_X
	if params and params.rotationX then
		rotationX = params.rotationX
	end
	local zEye = cc.Director:getInstance():getZEye()
	_ENV = cc.Director:getInstance()
	cc.Director:getInstance().x = display.width / 2
	cc.Director:getInstance().y = display.rheight / 2
	local cc.Director:getInstance().z, rayOrigin = zEye, cc.Director:getInstance()
	_ENV = nil
	;(nil).x = touchPos.x
	;(nil).y = touchPos.y
	;(nil).z = 0
	local rayDirection = cc.pSub3D(nil, rayOrigin)
	_ENV = nil
	;(nil).origin = rayOrigin
	local _ENV, (nil).direction, ray = rayOrigin, rayDirection, nil
	rayOrigin.x = 0
	rayOrigin.y = math.abs(math.sin(math.rad(rotationX)))
	local rayOrigin.z, planeNormal = math.abs(math.cos(math.rad(rotationX))), rayOrigin
	_ENV, planeNormal = cc.vec3normalize(planeNormal), cc.vec3normalize(planeNormal)
	cc.vec3normalize(planeNormal).x = 0
	cc.vec3normalize(planeNormal).y = 0
	cc.vec3normalize(planeNormal).z = 0
	local cc.vec3normalize(planeNormal).w, planePoint = 1, cc.vec3normalize(planeNormal)
	local planeWorldPoint = SoraConvertToWorldSpace3D(target, planePoint)
	_ENV = target
	target.pos = planeWorldPoint
	local target.normal, plane = planeNormal, target
	local ret, touch3DPos = SoraRayIntersectsPlane(ray, plane)
	return ret, touch3DPos
end
function SoraConvertTouchToNodeSpace3D(target, touchPos, params)
	local ret, touch3DPos = SoraDGet3DTouchPos(target, touchPos, params)
	if ret then
		local vec3Node = SoraConvertToNodeSpace3D(target, touch3DPos)
		return vec3Node
	else
	end
end
function SoraConvertTouchToNodeSpace2DOr3D(target, touchPos, params)
	if gEnableWorldMap3D then
		return SoraConvertTouchToNodeSpace3D(target, touchPos, params)
	else
		return target:convertToNodeSpace(touchPos)
	end
end
function SoraDConvertToPoint3D(node1, targetPoint, node2)
	local worldPoint = SoraDVerticalProject2ScreenPos2DOr3D(node1, targetPoint)
	return SoraConvertToNodeSpace2DOr3D(node2, worldPoint)
end
function SoraDCoverToPoint2DOr3D(node1, targetPoint, node2, enable3D)
	local enable3D = enable3D
	if enable3D == nil then
		enable3D = gEnableWorldMap3D
	end
	if enable3D then
		return SoraDConvertToPoint3D(node1, targetPoint, node2)
	else
		return SoraDCoverToPoint(node1, targetPoint, node2)
	end
end
function SoraDConvertoScreenPos3D(target, nodePos)
	local worldPos3D = SoraConvertToWorldSpace3D(target, nodePos)
	local zEye = cc.Director:getInstance():getZEye()
	_ENV = cc.Director:getInstance()
	cc.Director:getInstance().x = display.width / 2
	cc.Director:getInstance().y = display.rheight / 2
	local cc.Director:getInstance().z, rayOrigin = zEye, cc.Director:getInstance()
	local rayDirection = cc.pSub3D(worldPos3D, rayOrigin)
	_ENV = worldPos3D
	worldPos3D.origin = rayOrigin
	local _ENV, worldPos3D.direction, ray = rayOrigin, rayDirection, worldPos3D
	rayOrigin.x = 0
	rayOrigin.y = 0
	local rayOrigin.z, planeNormal = 1, rayOrigin
	_ENV, planeNormal = cc.vec3normalize(planeNormal), cc.vec3normalize(planeNormal)
	cc.vec3normalize(planeNormal).x = 0
	cc.vec3normalize(planeNormal).y = 0
	cc.vec3normalize(planeNormal).z = 0
	local cc.vec3normalize(planeNormal).w, planePoint = 1, cc.vec3normalize(planeNormal)
	local planeWorldPoint = planePoint
	_ENV = nil
	;(nil).pos = planeWorldPoint
	local (nil).normal, plane = planeNormal, nil
	local ret, touch3DPos = SoraRayIntersectsPlane(ray, plane)
	if ret then
		return touch3DPos
	end
end
function SoraDConvertoScreenPos2DOr3D(target, nodePos)
	if gEnableWorldMap3D then
		return SoraDConvertoScreenPos3D(target, nodePos)
	else
		return target:convertToWorldSpace(nodePos)
	end
end
function SoraDProject2ScreenPos3D(target, nodePos)
	local worldPos3D = SoraConvertToWorldSpace3D(target, nodePos)
	return display.getRunningScene():getDefaultCamera():projectGL(worldPos3D)
end
function SoraDProjec2ScreenPos2DOr3D(target, nodePos)
	if gEnableWorldMap3D then
		return SoraDProject2ScreenPos3D(target, nodePos)
	else
		return target:convertToWorldSpace(nodePos)
	end
end
function SoraDVerticalProject2ScreenPos3D(target, nodePos)
	local worldPos3D = SoraConvertToWorldSpace3D(target, nodePos)
	return cc.p(worldPos3D.x, worldPos3D.y)
end
function SoraDVerticalProject2ScreenPos2DOr3D(target, nodePos)
	if gEnableWorldMap3D then
		return SoraDVerticalProject2ScreenPos3D(target, nodePos)
	else
		return target:convertToWorldSpace(nodePos)
	end
end
function SoraDConvertScreenPoint2WorldPos3D(target, screenPos)
	local rotationX = gWorldMapRotation3D_X
	_ENV = nil
	;(nil).x = screenPos.x
	;(nil).y = screenPos.y
	local (nil).z, worldPos3D = 0, nil
	local zEye = cc.Director:getInstance():getZEye()
	_ENV = cc.Director:getInstance()
	cc.Director:getInstance().x = display.width / 2
	cc.Director:getInstance().y = display.rheight / 2
	local cc.Director:getInstance().z, rayOrigin = zEye, cc.Director:getInstance()
	local rayDirection = cc.pSub3D(worldPos3D, rayOrigin)
	_ENV = worldPos3D
	worldPos3D.origin = rayOrigin
	local _ENV, worldPos3D.direction, ray = rayOrigin, rayDirection, worldPos3D
	rayOrigin.x = 0
	rayOrigin.y = math.abs(math.sin(math.rad(rotationX)))
	local rayOrigin.z, planeNormal = math.abs(math.cos(math.rad(rotationX))), rayOrigin
	_ENV, planeNormal = cc.vec3normalize(planeNormal), cc.vec3normalize(planeNormal)
	cc.vec3normalize(planeNormal).x = 0
	cc.vec3normalize(planeNormal).y = 0
	cc.vec3normalize(planeNormal).z = 0
	local cc.vec3normalize(planeNormal).w, planePoint = 1, cc.vec3normalize(planeNormal)
	local planeWorldPoint = planePoint
	_ENV = math.cos(math.rad(rotationX))
	math.cos(math.rad(rotationX)).pos = planeWorldPoint
	local math.cos(math.rad(rotationX)).normal, plane = planeNormal, math.cos(math.rad(rotationX))
	local ret, touch3DPos = SoraRayIntersectsPlane(ray, plane)
	if ret then
		return touch3DPos
	end
end
function SoraDConvertScreenPoint2NodePos3D(target, screenPos)
	local worldPos = SoraDConvertScreenPoint2WorldPos3D(target, screenPos)
	if worldPos then
		return SoraConvertToNodeSpace3D(target, worldPos)
	end
end
function SoraDConvertScreenPoint2NodePos2DOr3D(target, screenPos)
	if gEnableWorldMap3D then
		return SoraDConvertScreenPoint2NodePos3D(target, screenPos)
	else
		return target:convertToNodeSpace(screenPos)
	end
end
