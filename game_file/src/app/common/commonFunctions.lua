function SoraDPrintLuaTable(lua_table, indent)
	indent = indent or 0
	for k, v in pairs(lua_table) do
		if type(k) == "string" then
			k = string.format("%q", k)
		end
		local szSuffix = ""
		if type(v) == "table" then
			szSuffix = "{"
		end
		local szPrefix = string.rep("    ", indent)
		formatting = szPrefix .. "[" .. k .. "]" .. " = " .. szSuffix
		if type(v) == "table" then
			print(formatting)
			SoraDPrintLuaTable(v, indent + 1)
			print(szPrefix .. "},")
		else
			local szValue = ""
			if type(v) == "string" then
				szValue = string.format("%q", v)
			else
				szValue = tostring(v)
			end
			print(formatting .. szValue .. ",")
		end
	end
end
function SoraDTimeToDate(time)
	local date = os.date("*t", time)
	return date
end
function SoraDDateToTime(date)
	local time = os.time(date)
	return time
end
function SoraDNowDate()
	local nowTime = os.time()
	local nowDate = os.date("*t", nowTime)
	return nowDate
end
function SoraCollectgarbage(target)
end
function SoraDGetWinSize()
	local winSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
	return winSize
end
function SoraDrawBoundingBox(target, color)
	local cbb = target:getCascadeBoundingBox()
	local left, bottom, width, height = 0, 0, cbb.size.width, cbb.size.height
	_UPVALUE2_, _UPVALUE5_ = nil, nil
	_UPVALUE2_, (nil)[1] = left, left
	_UPVALUE2_, (nil)[2] = left, bottom
	_UPVALUE2_, left[1] = left + width, left + width
	_UPVALUE2_, left[2] = left + width, bottom
	_UPVALUE2_, (left + width)[1] = left + width, left + width
	_UPVALUE2_, (left + width)[2] = left + width, bottom + height
	_UPVALUE2_, (left + width)[1] = left, left
	_UPVALUE2_, (left + width)[2] = left, bottom + height
	left[1] = left
	left[2] = bottom
	;(nil)[1] = nil
	;(nil)[2] = left
	;(nil)[3] = left + width
	;(nil)[4] = left + width
	local (nil)[5], points = left, nil
	_ENV = left + width
	;(left + width).borderColor = color
	local box = display.newPolygon(points, left + width)
	target:addChild(box, 1000)
end
function SoraDCreateColorLayer(size, color)
	local layer = display.newSprite()
	layer:setContentSize(size)
	layer:setTouchEnabled(true)
	layer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	layer:setTouchSwallowEnabled(false)
	if color then
		local colorLayer = cc.LayerColor:create(color)
		colorLayer:setContentSize(size)
		layer:addChild(colorLayer)
	end
	return layer
end
function SoraDCreateMaskSprite(maskName, bgName)
	local bgImg = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
	bgImg:setContentSize(display.width, display.height)
	bgImg:setPosition(0, 0)
	local maskImg = cc.Sprite:createWithSpriteFrameName(maskName)
	maskImg:setPosition(bgImg:getContentSize().width / 2, bgImg:getContentSize().height / 2)
	maskImg:setBlendFunc(GL_ONE, GL_ZERO)
	bgImg:setBlendFunc(GL_DST_ALPHA, GL_ZERO)
	local rt = cc.RenderTexture:create(bgImg:getContentSize().width, bgImg:getContentSize().height)
	rt:setAnchorPoint(0.5, 0.5)
	rt:setPosition(bgImg:getContentSize().width / 2, bgImg:getContentSize().height / 2)
	rt:begin()
	maskImg:visit()
	bgImg:visit()
	rt:endToLua()
	local nSp = cc.Sprite:createWithTexture(rt:getSprite():getTexture())
	nSp:setFlippedY(true)
	return nSp
end
function SoraDCreateClipNode()
	local bgImg = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
	bgImg:setContentSize(display.width, display.height)
	bgImg:setPosition(0, 0)
	local radius = 100
	_ENV = bgImg
	bgImg.x = 0
	bgImg.y = 0
	local bgImg.color, params = cc.c4f(1, 1, 1, 0.05), bgImg
	local circle = display.newSolidCircle(radius, params)
	circle:setPosition(480, 650)
	local cliperNode = cc.ClippingNode:create()
	cliperNode:setStencil(circle)
	cliperNode:setInverted(true)
	cliperNode:addChild(bgImg, 0)
	cliperNode:setAnchorPoint(cc.p(0.0, 0.0))
	cliperNode:setPosition(cc.p(0, 0))
	return cliperNode
end
function SoraDCreateButton(imageName, params)
	local sprite = display.newSprite(imageName)
	local name, movable, listener
	if params then
		name = params.name
		movable = params.movable
		listener = params.listener
	end
	if name then
		local cs = sprite:getContentSize()
		_ENV = nil
		;(nil).UILabelType = 2
		;(nil).text = name
		;(nil).color = display.COLOR_BLACK
		local label = cc.ui.UILabel.new(nil)
		label:setPosition(cs.width / 2, cs.height / 2)
		sprite:addChild(label)
	end
	sprite:setTouchEnabled(true)
	sprite:setTouchSwallowEnabled(true)
	sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
		if name == "began" then
			sprite:setOpacity(128)
		elseif name == "moved" then
			sprite:setOpacity(128)
			if movable then
				local offsetX = x - prevX
				local offsetY = y - prevY
				local sx, sy = sprite:getPosition()
				sprite:setPosition(sx + offsetX, sy + offsetY)
			end
		elseif name == "ended" then
			local touchInSprite = cc.rectContainsPoint(sprite:getCascadeBoundingBox(), cc.p(x, y))
			if touchInSprite and listener then
				listener(sprite)
			end
			sprite:setOpacity(255)
		else
			sprite:setOpacity(255)
		end
		return true
	end)
	return sprite
end
function SoraDIsEqualColors(color1, color2)
	if color1.r == color2.r and color1.g == color2.g and color1.b == color2.b then
		return true
	end
	return false
end
function SoraDIsEqualPoints(point1, point2)
	if point1.x == point2.x and point1.y == point2.y then
		return true
	end
	return false
end
function SoraDGetAngleByPos(p1, p2)
	local _ENV, p
	p.x = p2.x - p1.x
	p.y = p2.y - p1.y
	local r = math.atan2(p.y, p.x) * 180 / math.pi
	return r
end
function SoraDGetAngleByPos1(p1, p2)
	local angle = cc.pGetAngle(cc.p(0, 0), cc.pSub(p2, p1))
	local radian = math.radian2angle(angle)
	return radian
end
function SorDGetRadianByPos(p1, p2)
	return cc.pGetAngle(cc.p(0, 0), cc.pSub(p2, p1))
end
function SoraGetAngleByVector(p1, p2, p3, p4)
	local r1 = SoraDGetAngleByPos1(p1, p2)
	local r2 = SoraDGetAngleByPos1(p3, p4)
	local r = r2 - r1
	print("向量夹角：" .. r)
	return r
end
function SoraDStringSplit(str, split_char)
	local _ENV, sub_str_tab
	while true do
		local pos = string.find(str, split_char)
		if not pos then
			local size_t = table.getn(sub_str_tab)
			table.insert(sub_str_tab, size_t + 1, str)
			break
		end
		local sub_str = string.sub(str, 1, pos - 1)
		local size_t = table.getn(sub_str_tab)
		table.insert(sub_str_tab, size_t + 1, sub_str)
		local t = string.len(str)
		str = string.sub(str, pos + 1, t)
	end
	return sub_str_tab
end
function SoraDRemoveTableEx(tab, pos)
	pos = tonumber(pos) or #tab
	if type(tab) ~= "table" then
		return tab
	end
	pos = pos or #tab
	if pos > table.maxn(tab) then
		return tab
	end
	if pos <= 0 then
		return tab
	end
	local _ENV, nTab = table.maxn(tab), table.maxn(tab)
	local len = table.maxn(tab) - 1
	for i = len, 1, -1 do
		if i < pos then
			nTab[i] = tab[i]
		else
			nTab[i] = tab[i + 1]
		end
	end
	tab = nTab
	return nTab
end
function SoraDStringsSplit(s, delim)
	if type(delim) ~= "string" or string.len(delim) <= 0 then
		return
	end
	local start = 1
	local _ENV, t = delim, delim
	while true do
		local pos = string.find(s, delim, start, true)
		if not pos then
			break
		end
		table.insert(t, string.sub(s, start, pos - 1))
		start = pos + string.len(delim)
	end
	table.insert(t, string.sub(s, start))
	return t
end
function SoraDCoverToPoint(node1, targetPoint, node2)
	local worldPoint = node1:convertToWorldSpace(targetPoint)
	local nodePoint = node2:convertToNodeSpace(worldPoint)
	return nodePoint
end
function SoraDIsPointInPolygonAll(p, poly)
	local px = p.x
	local py = p.y
	local flag = false
	local l = #poly
	local i = 0
	local j = l
	for i = 1, l do
		local sx = poly[i].x
		local sy = poly[i].y
		local tx = poly[j].x
		local ty = poly[j].y
		if sx == px and sy == py or tx == px and ty == py then
			return true
		end
		if py > sy and py <= ty or py <= sy and py > ty then
			local x = sx + (py - sy) * (tx - sx) / (ty - sy)
			if x == px then
				return true
			end
			if px < x then
				flag = not flag
			end
		end
		j = i
	end
	return flag
end
function SorDIsPointInPolygon(polygonPtArray, touchPoint)
	local _ENV, lineArray
	local targetPoint = cc.pMidpoint(polygonPtArray[1], polygonPtArray[3])
	for i = 1, #polygonPtArray do
		local point1 = polygonPtArray[i]
		local point2 = polygonPtArray[1]
		if i < #polygonPtArray then
			point2 = polygonPtArray[i + 1]
		end
		if cc.pIsSegmentIntersect(point1, point2, touchPoint, targetPoint) then
			return false
		end
	end
	return true
end
function SoraDIsLineOutRect(lineBeginPoint, lineEndPoint, rect)
	local isind = cc.rectContainsPoint(rect, lineBeginPoint)
	if cc.rectContainsPoint(rect, lineBeginPoint) then
		return false
	end
	if cc.rectContainsPoint(rect, lineEndPoint) then
		return false
	end
	local rectLineBeignPoint = cc.p(rect.x, rect.y)
	local rectLineEndPoint = cc.p(rect.x + rect.width, rect.y)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		return false
	end
	rectLineBeignPoint = cc.p(rect.x + rect.width, rect.y)
	rectLineEndPoint = cc.p(rect.x + rect.width, rect.y + rect.height)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		return false
	end
	rectLineBeignPoint = cc.p(rect.x + rect.width, rect.y + rect.height)
	rectLineEndPoint = cc.p(rect.x, rect.y + rect.height)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		return false
	end
	rectLineBeignPoint = cc.p(rect.x, rect.y + rect.height)
	rectLineEndPoint = cc.p(rect.x, rect.y)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		return false
	end
	return true
end
function SoraDLineIntersectRect(lineBeginPoint, lineEndPoint, rect)
	local isIntersect = false
	local _ENV, intersectPointArray
	local rectLineBeignPoint = cc.p(rect.x, rect.y)
	local rectLineEndPoint = cc.p(rect.x + rect.width, rect.y)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		local intersectPoint = cc.pGetIntersectPoint(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint)
		table.insert(intersectPointArray, intersectPoint)
		isIntersect = true
	end
	rectLineBeignPoint = cc.p(rect.x + rect.width, rect.y)
	rectLineEndPoint = cc.p(rect.x + rect.width, rect.y + rect.height)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		local intersectPoint = cc.pGetIntersectPoint(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint)
		table.insert(intersectPointArray, intersectPoint)
		isIntersect = true
	end
	rectLineBeignPoint = cc.p(rect.x + rect.width, rect.y + rect.height)
	rectLineEndPoint = cc.p(rect.x, rect.y + rect.height)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		local intersectPoint = cc.pGetIntersectPoint(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint)
		table.insert(intersectPointArray, intersectPoint)
		isIntersect = true
	end
	rectLineBeignPoint = cc.p(rect.x, rect.y + rect.height)
	rectLineEndPoint = cc.p(rect.x, rect.y)
	if cc.pIsSegmentIntersect(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint) then
		local intersectPoint = cc.pGetIntersectPoint(lineBeginPoint, lineEndPoint, rectLineBeignPoint, rectLineEndPoint)
		table.insert(intersectPointArray, intersectPoint)
		isIntersect = true
	end
	return isIntersect, intersectPointArray
end
function SoraDRectIntersectsRect(rect1, rect2, haveBorder)
	if haveBorder == nil then
		haveBorder = false
	end
	local x11 = rect1.x
	local y11 = rect1.y
	local x12 = rect1.x + rect1.width
	local y12 = rect1.y + rect1.height
	local x21 = rect2.x
	local y21 = rect2.y
	local x22 = rect2.x + rect2.width
	local y22 = rect2.y + rect2.height
	if haveBorder then
		if x12 >= x21 and x11 <= x22 and y12 >= y21 and y11 <= y22 then
			return true
		end
	elseif x12 > x21 and x11 < x22 and y12 > y21 and y11 < y22 then
		return true
	end
	return false
end
function SoraDCircleRectIntersect(cx, cy, radius, rect)
	local rect_right = rect.x + rect.width
	local rect_bottom = rect.y + rect.height
	local closest_x = math.max(rect.x, math.min(cx, rect_right))
	local closest_y = math.max(rect.y, math.min(cy, rect_bottom))
	local dx = cx - closest_x
	local dy = cy - closest_y
	local distance_squared = dx * dx + dy * dy
	return distance_squared <= radius * radius
end
function SoraDRectFullInRect(rect1, rect2, haveBorder)
	if haveBorder == nil then
		haveBorder = false
	end
	local x11 = rect1.x
	local y11 = rect1.y
	local x12 = rect1.x + rect1.width
	local y12 = rect1.y + rect1.height
	local x21 = rect2.x
	local y21 = rect2.y
	local x22 = rect2.x + rect2.width
	local y22 = rect2.y + rect2.height
	if haveBorder then
		if x11 <= x21 and x12 >= x22 and y12 <= y21 and y12 >= y22 or x11 >= x21 and x12 <= x22 and y11 >= y22 and y12 <= y22 then
			return true
		end
	elseif x11 < x21 and x12 > x22 and y12 < y21 and y12 > y22 or x11 > x21 and x12 < x22 and y11 > y22 and y12 < y22 then
		return true
	end
	return false
end
function SoraDCalculateIntersectionPoint(x1, y1, x2, y2, cx, cy, r)
	local dx = x2 - x1
	local dy = y2 - y1
	local a = dx * dx + dy * dy
	local b = 2 * (dx * (x1 - cx) + dy * (y1 - cy))
	local c = (x1 - cx) * (x1 - cx) + (y1 - cy) * (y1 - cy) - r * r
	local discriminant = b * b - 4 * a * c
	if 0 <= discriminant then
		local value = math.sqrt(discriminant)
		local t1 = (-b + value) / (2 * a)
		local t2 = (-b - value) / (2 * a)
		if 0 <= t1 and t1 <= 1 then
			local x = x1 + t1 * dx
			local y = y1 + t1 * dy
			return x, y
		elseif 0 <= t2 and t2 <= 1 then
			local x = x1 + t2 * dx
			local y = y1 + t2 * dy
			return x, y
		end
	end
	return nil
end
function SoraDGetRandNum(count, minNum, maxNum, needFloat)
	local _ENV, tableNum
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local plusFloat = needFloat and math.random() or 0
	if maxNum then
		for i = 1, count do
			table.insert(tableNum, math.random(minNum, maxNum) + plusFloat)
		end
	else
		for i = 1, count do
			table.insert(tableNum, math.random() * minNum + plusFloat)
		end
	end
	return tableNum
end
function SoraChangeButtonImage(button, image)
	button:loadTextureNormal(image, ccui.TextureResType.plistType)
end
function SoraChangeSpriteImage(sprite, image)
	sprite:loadTexture(image, ccui.TextureResType.plistType)
end
function SoraDGetStagePercent(score, stageList)
	if score == nil then
		return 0
	end
	local percent = 0
	local minVar = stageList[1]
	local maxVar = stageList[#stageList]
	local per = 100 / (#stageList - 1)
	local index = 1
	for k, v in ipairs(stageList) do
		if score < v then
			index = k
			break
		end
	end
	if score <= minVar then
		percent = 0
	elseif score >= maxVar then
		percent = 100
	else
		percent = math.floor((score - stageList[index - 1]) / (stageList[index] - stageList[index - 1]) * per + per * (index - 2))
	end
	return percent
end
function SoraDGetStageValue(score, stageList, isFromZero)
	score = score or 0
	local percent = 0
	local index = 1
	local minVar = stageList[1]
	local maxVar = stageList[#stageList]
	if isFromZero then
		for k, v in ipairs(stageList) do
			if v > score then
				index = k
				break
			end
		end
		local per = 100 / (#stageList - 1)
		if score <= minVar then
			percent = 0
		elseif score >= maxVar then
			percent = 100
		else
			percent = (score - stageList[index - 1]) / (stageList[index] - stageList[index - 1]) * per + per * (index - 2)
		end
	else
		for k, v in ipairs(stageList) do
			if v >= score then
				index = k
				break
			end
		end
		local per = 100 / #stageList
		if score >= maxVar then
			percent = 100
		else
			local val = stageList[index - 1] or 0
			percent = (score - val) / (stageList[index] - val) * per + per * (index - 1)
		end
	end
	return percent
end
function SoraDGetStagePercentNew(score, stageList)
	if stageList == nil or stageList[1] == 0 or stageList[1] == nil then
		return 0
	end
	local percent = 0
	local minVar = stageList[1]
	local maxVar = stageList[#stageList]
	local per = 100 / ((#stageList - 1) * 2 + 1)
	local index = 1
	for k, v in ipairs(stageList) do
		if score < v then
			index = k
			break
		end
	end
	if score <= minVar then
		percent = score / minVar * per
	elseif score >= maxVar then
		percent = 100
	elseif index < 3 then
		percent = per + (score - stageList[index - 1]) * per * 2 / (stageList[index] - stageList[index - 1])
	else
		percent = per + 2 * per * (index - 2) + (score - stageList[index - 1]) * per * 2 / (stageList[index] - stageList[index - 1])
	end
	return percent
end
function SoraDisInList(data, dataList)
	if type(dataList) ~= "table" then
		print("dataList is not a table value !")
		return false
	end
	local isIn = false
	if type(data) == "number" or type(data) == "string" then
		for i = 1, #dataList do
			if dataList[i] == data then
				isIn = true
				break
			end
		end
		return isIn
	elseif type(data) == "table" then
		isIn = true
		for i = 1, #data do
			if SoraDisInList(data[i], dataList) == false then
				isIn = false
				break
			end
		end
		return isIn
	else
		print("data is invalid !")
	end
end
function SoraDSortMessTable(tb)
	local _ENV, newTb
	local _ENV, keys
	for k, v in pairs(tb) do
		table.insert(keys, k)
	end
	table.sort(keys)
	for i = 1, #keys do
		newTb[i] = tb[keys[i]]
	end
	return newTb
end
function SoraDchangeToMap(list)
	if type(list) ~= "table" then
		print("list is not a table value !")
		return false, list
	elseif #list % 2 ~= 0 then
		print("list is invalid !")
		return false, list
	end
	local _ENV, data = false, false
	local index = 1
	for i = 1, #list - 1, 2 do
		_ENV = nil
		;(nil).key = list[i]
		data[index], (nil).value = nil, list[i + 1]
		index = index + 1
	end
	return true, data
end
function SoraDCreateShaderEffect(cfg, target, zOrder)
	local _shader = require(cfg.shader)
	local _meshData = require(cfg.meshData)
	local _param = require(cfg.param)
	local effectNode = SoraDCreateMeshNode(_meshData, cc.size(1, 1), _shader, _param.param)
	effectNode:setPosition(cc.p(unpack(cfg.position)))
	effectNode:setScale(unpack(cfg.scale))
	effectNode:setVisible(true)
	if not target.isCocos and target.setContent then
		target:setContent(effectNode)
	else
		effectNode:addTo(target, zOrder or 0)
	end
	if cfg.rotation then
		effectNode:setRotation3D(cc.vec3(unpack(cfg.rotation)))
	end
	if cfg.rotation2D then
		effectNode:setRotation(cfg.rotation2D)
	end
	if cfg.scaleZ then
		effectNode:setScaleZ(cfg.scaleZ)
	end
	if cfg.blend then
		effectNode:setBlendFunc(cfg.blend[1], cfg.blend[2])
	end
	return effectNode
end
function SoraDCreateEffectNode(param, folder, isAutoRemoveOnfinish, groupID)
	folder = folder or "Particle/"
	local particle_node = display.newNode()
	local isAutoRemoveOnfinish = isAutoRemoveOnfinish or false
	for k, v in pairs(param) do
		local fileType = v.fileType
		fileType = fileType or "particle"
		if tolua.isnull(particle_node) then
			return nil
		end
		if fileType == "csb" then
			local csbNode = SoraDCreateCSBNode(v.fileName)
			if csbNode then
				if not v.pos then
					_ENV = v.pos
					v.pos.x = 0
					local v.pos.y, pos = 0, v.pos
				end
				local rotate = v.rotate or 0
				local zorder = v.zorder or 0
				if not v.scale then
					_ENV = v.scale
					v.scale.x = 1
					local v.scale.y, scale = 1, v.scale
				end
				if type(v.scale) == "number" then
					_ENV = type(v.scale)
					type(v.scale).x = v.scale
					scale, type(v.scale).y = type(v.scale), v.scale
				end
				csbNode:addTo(particle_node, zorder)
				csbNode:setRotation(rotate)
				csbNode:setPosition(cc.p(pos.x, pos.y))
				if scale.x then
					csbNode:setScaleX(scale.x)
				end
				if scale.y then
					csbNode:setScaleY(scale.y)
				end
			end
			if v.autocull ~= nil then
				local effectNode = SoraDGetChildByName(csbNode, "nodeEffect")
				if effectNode then
					local children = effectNode:getChildren()
					for _, cnode in ipairs(children) do
						if cnode.setAutoCull then
							cnode:setAutoCull(v.autocull)
						end
					end
				end
			end
		elseif fileType == "frames" then
			local sp = display.newSprite(string.format("#%s", string.format(v.imgName, v.beginFrame or 1)))
			local frames = display.newFrames(v.imgName, v.beginFrame or 1, v.endFrame or v.imagNum)
			sp:stopAllActions()
			local animation = display.newAnimation(frames, 1.0 / v.fNum)
			sp:playAnimationForever(animation)
			if not v.pos then
				_ENV = v.pos
				v.pos.x = 0
				local v.pos.y, pos = 0, v.pos
			end
			if not v.scale then
				_ENV = v.scale
				v.scale.x = 1
				local v.scale.y, scale = 1, v.scale
			end
			if type(v.scale) == "number" then
				_ENV = type(v.scale)
				type(v.scale).x = v.scale
				scale, type(v.scale).y = type(v.scale), v.scale
			end
			local zorder = v.zorder or 0
			local rotate = v.rotate or 0
			sp:setScale(scale.x, scale.y)
			sp:setPosition(pos)
			sp:setRotation(rotate)
			if v.blendOne then
				sp:setBlendFunc(gl.ONE, gl.ONE)
			end
			if v.autocull ~= nil and sp.setAutoCull then
				sp:setAutoCull(v.autocull)
			end
			if groupID then
				sp:setGroupID(groupID)
			end
			sp:addTo(particle_node, zorder)
		else
			local plist = folder .. v.plist
			if not v.pos then
				_ENV = v.pos
				v.pos.x = 0
				local v.pos.y, pos = 0, v.pos
			end
			if not v.scale then
				_ENV = v.scale
				v.scale.x = 1
				local v.scale.y, scale = 1, v.scale
			end
			if type(v.scale) == "number" then
				_ENV = type(v.scale)
				type(v.scale).x = v.scale
				scale, type(v.scale).y = type(v.scale), v.scale
			end
			local posType = v.posType or cc.POSITION_TYPE_RELATIVE
			local rotate = v.rotate or 0
			local zorder = v.zorder or 0
			local delay = v.delay or 0
			local tpScale = v.tpScale or 1
			local particle_effect = cc.ParticleSystemQuad:create(plist)
			if particle_effect ~= nil then
				particle_effect:setPosition(cc.p(pos.x, pos.y))
				if scale.x then
					particle_effect:setScaleX(scale.x)
				end
				if scale.y then
					particle_effect:setScaleY(scale.y)
				end
				particle_effect:setPositionType(posType)
				particle_effect:setRotation(rotate)
				particle_effect:setAutoRemoveOnFinish(isAutoRemoveOnfinish)
				if v.autocull ~= nil and particle_effect.setAutoCull then
					particle_effect:setAutoCull(v.autocull)
				end
				if v.tp then
					particle_effect:setTotalParticles(v.tp)
				else
					particle_effect:setTotalParticles(math.floor(particle_effect:getTotalParticles() * tpScale))
				end
				if v.name then
					particle_effect:setName(v.name)
				end
				if 0 < delay then
					particle_effect:stopSystem()
					_UPVALUE1_ = particle_effect
					particle_effect[1] = cca.delay(delay)
					particle_effect[2] = cca.callFunc(function()
						particle_effect:resetSystem()
					end)
					particle_effect[3] = cca.callFunc(function()
						particle_effect:resetSystem()
					end)
					local seq = cca.seq(particle_effect)
					particle_effect:runAction(seq)
				end
				if v.blend then
					particle_effect:setBlendFunc(v.blend[1], v.blend[2])
				end
				if groupID then
					particle_effect:setGroupID(groupID)
				end
				particle_effect:addTo(particle_node, zorder)
			end
		end
	end
	return particle_node
end
function SoraDResetEffectTime(target, time)
	if target then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(time)
		;(nil)[2] = cca.callFunc(function()
			target:resetSystem()
		end)
		;(nil)[3] = cca.callFunc(function()
			target:resetSystem()
		end)
		;(nil)[4] = cca.callFunc(function()
			target:resetSystem()
		end)
		local seq = cca.seq(nil)
		target:runAction(cc.RepeatForever:create(seq))
	end
end
function SoraDResetEffectNode(node)
	if node then
		if node.resetSystem then
			node:resetSystem()
		end
		local children = node:getChildren()
		for _, v in ipairs(children) do
			if v and v.resetSystem then
				v:resetSystem()
			end
		end
	end
end
function SoraDStopEffectNode(node)
	if node then
		if node.stopSystem then
			node:stopSystem()
		end
		local children = node:getChildren()
		if type(children) == "table" then
			for _, v in ipairs(children) do
				if v and v.stopSystem then
					v:stopSystem()
				end
			end
		elseif children and children.count and children.objectAtIndex then
			for i = 0, children:count() - 1 do
				local v = children:objectAtIndex(i)
				if v and v.stopSystem then
					v:stopSystem()
				end
			end
		end
	end
end
function SoraDCreateFireEffectNode(target1, target2)
	if not target1 or not target2 then
		return
	end
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33.78
	_ENV, (nil).pos, (nil).y = nil, nil, 41.28
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 34.25
	_ENV, (nil).pos, (nil).y = nil, nil, 70.5
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 36.07
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 106.15
	local param
	local parNodeFire1 = SoraDCreateEffectNode(param)
	parNodeFire1:addTo(target1, 2)
	local parNodeFire2 = SoraDCreateEffectNode(param)
	parNodeFire2:addTo(target2, 2)
end
function SoraDRechargeBtnEffect(ocx, scale, offsetX)
end
function SoraDGetFightingEffect(isShowEffect)
	local showEffect = true
	if isShowEffect ~= nil then
		showEffect = isShowEffect
	end
	local node = display.newNode()
	local runParticle = function()
		if not showEffect then
			return
		end
		local et_node = node:getChildByName("et_node")
		if et_node then
			SoraDResetEffectNode(et_node)
		else
			showEffect, showEffect = et_node, SoraDResetEffectNode
			showEffect, et_node.plist = nil, "et_kegongdatx_02.plist"
			;(nil).x = 0
			showEffect, SoraDResetEffectNode[1], et_node.pos, (nil).y = et_node, et_node, nil, 50
			showEffect, et_node.plist = nil, "et_kegongdatx_03.plist"
			;(nil).x = 0
			SoraDResetEffectNode[2], et_node.pos, (nil).y = et_node, nil, 50
			local param = SoraDResetEffectNode
			local et_node = SoraDCreateEffectNode(param)
			et_node:setName("et_node")
			et_node:addTo(node)
		end
	end
	local dh1 = display.newSprite("#image_kegongdatx_special_01.png")
	dh1:setAnchorPoint(cc.p(0, 0))
	dh1:setPosition(cc.p(-61, 0))
	dh1:addTo(node)
	local dh2 = display.newSprite("#image_kegongdatx_special_02.png")
	dh2:setAnchorPoint(cc.p(1, 0))
	dh2:setPosition(cc.p(61, 0))
	dh2:addTo(node)
	_UPVALUE3_ = dh2
	dh2[1] = cca.rotateTo(0.5833333333333334, -40)
	dh2[2] = cca.rotateTo(0.08333333333333333, 0)
	dh2[3] = cca.callFunc(runParticle)
	dh2[4] = cca.delay(1.3333333333333333)
	dh2[5] = cca.delay(1.3333333333333333)
	local seq1 = cca.seq(dh2)
	dh1:runAction(cc.RepeatForever:create(seq1))
	_UPVALUE2_ = dh1
	dh1[1] = cca.rotateTo(0.5833333333333334, 36.5)
	dh1[2] = cca.rotateTo(0.08333333333333333, 0)
	dh1[3] = cca.delay(1.3333333333333333)
	dh1[4] = cca.delay(1.3333333333333333)
	local seq2 = cca.seq(dh1)
	dh2:runAction(cc.RepeatForever:create(seq2))
	return node
end
function SoraDGetFightingEffectNew(...)
	local node = display.newNode()
	local sprite = display.newSprite("#dh_GQ_ALPHA_01.png")
	local frames = display.newFrames("dh_GQ_ALPHA_%02d.png", 1, 40)
	local animation = display.newAnimation(frames, 0.06666666666666667)
	sprite:playAnimationForever(animation)
	sprite:addTo(node)
	return node
end
function SoraDFadeINOUT(target, param)
	if not target then
		return
	end
	local _ENV, param = nil, param or nil
	local time_in = param.fadeIn or 1
	local time_out = param.fadeOut or 1
	local time_delay = param.delay or 0.5
	local beginOpacity = param.beginOpacity
	local endOpacity = param.endOpacity
	if target.displayObject == nil or target.isCocos then
		if beginOpacity and endOpacity then
			_UPVALUE3_ = nil
			;(nil)[1] = cca.fadeTo(time_out, endOpacity)
			;(nil)[2] = cca.delay(time_delay)
			;(nil)[3] = cca.fadeTo(time_in, beginOpacity)
			;(nil)[4] = cca.delay(time_delay)
			;(nil)[5] = cca.delay(time_delay)
			local seq = cca.seq(nil)
			target:runAction(cc.RepeatForever:create(seq))
		else
			_UPVALUE3_ = target.runAction
			target.runAction[1] = cca.fadeOut(time_out)
			target.runAction[2] = cca.delay(time_delay)
			target.runAction[3] = cca.fadeIn(time_in)
			target.runAction[4] = cca.delay(time_delay)
			target.runAction[5] = cca.delay(time_delay)
			local seq = cca.seq(target.runAction)
			target:runAction(cc.RepeatForever:create(seq))
		end
	elseif beginOpacity and endOpacity then
		_UPVALUE3_ = target.runAction
		target.runAction[1] = ffa.fadeTo(time_out, endOpacity)
		target.runAction[2] = ffa.delay(time_delay)
		target.runAction[3] = ffa.fadeTo(time_in, beginOpacity)
		target.runAction[4] = ffa.delay(time_delay)
		target.runAction[5] = ffa.delay(time_delay)
		local seq = ffa.seq(target.runAction)
		target:runAction(ffa.repeatForever(seq))
	else
		_UPVALUE3_ = target.runAction
		target.runAction[1] = ffa.fadeOut(time_out)
		target.runAction[2] = ffa.delay(time_delay)
		target.runAction[3] = ffa.fadeIn(time_in)
		target.runAction[4] = ffa.delay(time_delay)
		target.runAction[5] = ffa.delay(time_delay)
		local seq = ffa.seq(target.runAction)
		target:runAction(ffa.repeatForever(seq))
	end
end
function SoraDCreateActionDiamondNode(maxWidth, isAct, color, opacity)
	local node = display.newNode()
	local imgWidth = 115
	local imgHeight = 130
	local count = math.ceil(maxWidth / 2 / imgWidth)
	local createALine = function(lineNode)
		local cutLayer = ccui.Layout:create()
		cutLayer:setAnchorPoint(cc.p(0, 0))
		cutLayer:setClippingEnabled(true)
		cutLayer:setContentSize(cc.size(0, 0))
		if not isAct then
			cutLayer:setContentSize(cc.size(maxWidth / 2, maxWidth / 2))
		end
		for i = 1, count do
			local line = display.newSprite("#light_border.png")
			local posX = (i - 1) * (imgWidth - 0.5)
			local posY = (i - 1) * (imgHeight / 2 - 9)
			line:setAnchorPoint(cc.p(0, 0))
			line:setPosition(cc.p(posX, posY))
			if color then
				line:setColor(color)
			end
			if opacity then
				line:setOpacity(opacity)
			end
			line:addTo(cutLayer)
		end
		return cutLayer
	end
	local line_1 = createALine()
	line_1:setAnchorPoint(cc.p(0, 0.5))
	line_1:addTo(node)
	local line_2 = createALine()
	line_2:setScaleX(-1)
	line_2:setAnchorPoint(cc.p(0, 0.5))
	line_2:addTo(node)
	local line_3 = createALine()
	line_3:setAnchorPoint(cc.p(1, 0))
	line_3:addTo(node)
	local line_4 = createALine()
	line_4:setScaleX(-1)
	line_4:setAnchorPoint(cc.p(1, 0))
	line_4:addTo(node)
	if isAct then
		local dt = 0
		local actTime = 2
		_UPVALUE2_ = cc.p(1, 0)
		cc.p(1, 0)[1] = cca.callFunc(function()
			local width = dt / actTime * maxWidth / 2
			line_1:setContentSize(cc.size(width, width))
			line_2:setContentSize(cc.size(width, width))
			line_3:setContentSize(cc.size(width, width))
			line_4:setContentSize(cc.size(width, width))
		end)
		cc.p(1, 0)[2] = cca.delay(0.016666666666666666)
		cc.p(1, 0)[3] = cca.callFunc(function()
			if dt > actTime then
			end
		end)
		cc.p(1, 0)[4] = cca.callFunc(function()
			if dt > actTime then
			end
		end)
		local seq = cca.seq(cc.p(1, 0))
		node:runAction(cc.RepeatForever:create(seq))
	end
	return node
end
function SoraDCreateActionRectangleNode(size, isAct, color, opacity)
	local node = display.newNode()
	local imgWidth = 115
	local imgHeight = 130
	local maxW, maxH
	if type(size) == "table" then
		maxW, maxH = size.height, size.width
	else
		maxW, maxH = size, size
	end
	local countW = math.ceil(maxW / 2 / imgWidth)
	local countH = math.ceil(maxH / 2 / imgWidth)
	local createALine = function(count, maxS)
		local cutLayer = ccui.Layout:create()
		cutLayer:setAnchorPoint(cc.p(0, 0))
		cutLayer:setClippingEnabled(true)
		cutLayer:setContentSize(cc.size(0, 0))
		if not isAct then
			cutLayer:setContentSize(cc.size(maxS / 2, maxS / 2))
		end
		for i = 1, count do
			local line = display.newSpriteNoChild("#light_border.png")
			local posX = (i - 1) * (imgWidth - 0.5)
			local posY = (i - 1) * (imgHeight / 2 - 8)
			line:setAnchorPoint(cc.p(0, 0))
			line:setPosition(cc.p(posX, posY))
			if color then
				line:setColor(color)
			end
			if opacity then
				line:setOpacity(opacity)
			end
			line:addTo(cutLayer)
		end
		return cutLayer
	end
	local line_1 = createALine(countW, maxW)
	line_1:setAnchorPoint(cc.p(0, 0.5))
	line_1:addTo(node)
	local line_2 = createALine(countH, maxH)
	line_2:setScaleX(-1)
	line_2:setAnchorPoint(cc.p(0, 0.5))
	line_2:addTo(node)
	local line_3 = createALine(countW, maxW)
	line_3:setAnchorPoint(cc.p(1, 0))
	line_3:addTo(node)
	local line_4 = createALine(countH, maxH)
	line_4:setScaleX(-1)
	line_4:setAnchorPoint(cc.p(1, 0))
	line_4:addTo(node)
	local offsetHW = maxH - maxW
	local offsetX = offsetHW / 4
	local offsetY = offsetHW / 8
	line_1:setPosition(cc.p(offsetX, -offsetY))
	line_2:setPosition(cc.p(offsetX, offsetY))
	line_3:setPosition(cc.p(-offsetX, offsetY))
	line_4:setPosition(cc.p(-offsetX, -offsetY))
	if isAct then
		local dt = 0
		local actTime = 2
		_UPVALUE2_ = cc.p(-offsetX, -offsetY)
		cc.p(-offsetX, -offsetY)[1] = cca.callFunc(function()
			local width = dt / actTime * maxW / 2
			local height = dt / actTime * maxH / 2
			line_1:setContentSize(cc.size(width, width))
			line_2:setContentSize(cc.size(height, height))
			line_3:setContentSize(cc.size(width, width))
			line_4:setContentSize(cc.size(height, height))
			local offsetHW = (height - width) * 2
			local offsetX = offsetHW / 4
			local offsetY = offsetHW / 8
			line_1:setPosition(cc.p(offsetX, -offsetY))
			line_2:setPosition(cc.p(offsetX, offsetY))
			line_3:setPosition(cc.p(-offsetX, offsetY))
			line_4:setPosition(cc.p(-offsetX, -offsetY))
		end)
		cc.p(-offsetX, -offsetY)[2] = cca.delay(0.016666666666666666)
		cc.p(-offsetX, -offsetY)[3] = cca.callFunc(function()
			if dt > actTime then
			end
		end)
		cc.p(-offsetX, -offsetY)[4] = cca.callFunc(function()
			if dt > actTime then
			end
		end)
		local seq = cca.seq(cc.p(-offsetX, -offsetY))
		node:runAction(cc.RepeatForever:create(seq))
	end
	return node
end
function SoraDCreateDiamondNode(width, isAct, imgName)
	local imgWidth = 115
	local diamondNode = display.newNode()
	local img = imgName or "bluelight_1.png"
	local frames = display.newFrames("bluelight_%d.png", 1, 5)
	local animation = display.newAnimation(frames, 2.0 / #frames)
	local count = math.ceil(width / 2 / imgWidth)
	local derlta = 0
	if 1 < count then
		derlta = (imgWidth * count - width / 2) / (count - 1)
	end
	local createALine = function(batchNode)
		for i = 1, count do
			local line = display.newSprite("#" .. img)
			line:setAnchorPoint(cc.p(0, 0))
			line:setPosition(cc.p((imgWidth - derlta) * (i - 1), -width / 4 + (imgWidth / 2 - derlta / 2) * (i - 1)))
			line:addTo(batchNode)
			if isAct then
				line:playAnimationForever(animation)
			end
		end
	end
	local diamondBitchNodeRD = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"))
	createALine(diamondBitchNodeRD)
	diamondBitchNodeRD:addTo(diamondNode)
	local diamondBitchNodeLD = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"))
	createALine(diamondBitchNodeLD)
	diamondBitchNodeLD:setScaleX(-1)
	diamondBitchNodeLD:addTo(diamondNode)
	local diamondBitchNodeRU = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"))
	createALine(diamondBitchNodeRU)
	diamondBitchNodeRU:setPosition(cc.p(width / 2, width / 4))
	diamondBitchNodeRU:setScaleX(-1)
	diamondBitchNodeRU:addTo(diamondNode)
	local diamondBitchNodeLU = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"))
	createALine(diamondBitchNodeLU)
	diamondBitchNodeLU:setPosition(cc.p(-width / 2, width / 4))
	diamondBitchNodeLU:addTo(diamondNode)
	return diamondNode
end
function SoraDToVerticalCenter(node, interval)
	local targets = node:getChildren()
	local totalLen = 0
	local interval = interval or 10
	local len = 0
	for k, v in pairs(targets) do
		local height = 0
		if v.getVirtualRendererSize then
			height = math.min(v:getVirtualRendererSize().height, v:getContentSize().height)
		else
			height = v:getContentSize().height * v:getScaleY()
		end
		if v:isVisible() then
			totalLen = totalLen + height
			len = len + 1
		end
	end
	totalLen = totalLen + (len - 1) * interval
	local tempLen = 0
	for i = 1, #targets do
		local height = 0
		if targets[i].getVirtualRendererSize then
			height = math.min(targets[i]:getVirtualRendererSize().height, targets[i]:getContentSize().height)
		else
			height = targets[i]:getContentSize().height * targets[i]:getScaleY()
		end
		if targets[i]:isVisible() then
			targets[i]:setAnchorPoint(cc.p(0.5, 0.5))
			targets[i]:setPositionY(totalLen / 2 - height / 2 - tempLen)
			tempLen = tempLen + height + interval
		end
	end
	return node
end
function SoraDToCenterEx(nodes, interval, isReverse, isSize)
	local targets = nodes
	local totalLen = 0
	local interval = interval or 10
	local isReverse = isReverse or false
	local len = 0
	for k, v in pairs(targets) do
		local width = 0
		if not isSize and v.getVirtualRendererSize then
			width = math.min(v:getVirtualRendererSize().width, v:getContentSize().width)
			width = width * v:getScaleX()
		else
			width = v:getContentSize().width * v:getScaleX()
		end
		if v:isVisible() then
			totalLen = totalLen + width
			len = len + 1
		end
	end
	totalLen = totalLen + (len - 1) * interval
	local tempLen = 0
	if isReverse then
		for i = #targets, 1, -1 do
			local width = 0
			if not isSize and targets[i].getVirtualRendererSize then
				width = math.min(targets[i]:getVirtualRendererSize().width, targets[i]:getContentSize().width)
				width = width * targets[i]:getScaleX()
			else
				width = targets[i]:getContentSize().width * targets[i]:getScaleX()
			end
			if targets[i]:isVisible() then
				targets[i]:setAnchorPoint(cc.p(0.5, 0.5))
				targets[i]:setPositionX(-totalLen / 2 + width / 2 + tempLen)
				tempLen = tempLen + width + interval
			end
		end
	else
		for i = 1, #targets do
			local width = 0
			if not isSize and targets[i].getVirtualRendererSize then
				width = math.min(targets[i]:getVirtualRendererSize().width, targets[i]:getContentSize().width)
				width = width * targets[i]:getScaleX()
			else
				width = targets[i]:getContentSize().width * targets[i]:getScaleX()
			end
			if targets[i]:isVisible() then
				targets[i]:setAnchorPoint(cc.p(0.5, 0.5))
				targets[i]:setPositionX(-totalLen / 2 + width / 2 + tempLen)
				tempLen = tempLen + width + interval
			end
		end
	end
	return nodes, tempLen
end
function SoraDToCenterTarges(targets, interval, isReverse, isSize)
	local totalLen = 0
	local interval = interval or 10
	local isReverse = isReverse or false
	local len = 0
	for k, v in pairs(targets) do
		local width = 0
		if not isSize and v.getVirtualRendererSize then
			width = math.min(v:getVirtualRendererSize().width, v:getContentSize().width)
			width = width * v:getScaleX()
		else
			width = v:getContentSize().width * v:getScaleX()
		end
		if v:isVisible() then
			totalLen = totalLen + width
			len = len + 1
		end
	end
	totalLen = totalLen + (len - 1) * interval
	local tempLen = 0
	if isReverse then
		for i = #targets, 1, -1 do
			local width = 0
			if not isSize and targets[i].getVirtualRendererSize then
				width = math.min(targets[i]:getVirtualRendererSize().width, targets[i]:getContentSize().width)
				width = width * targets[i]:getScaleX()
			else
				width = targets[i]:getContentSize().width * targets[i]:getScaleX()
			end
			if targets[i]:isVisible() then
				targets[i]:setAnchorPoint(cc.p(0.5, 0.5))
				targets[i]:setPositionX(-totalLen / 2 + width / 2 + tempLen)
				tempLen = tempLen + width + interval
			end
		end
	else
		for i = 1, #targets do
			local width = 0
			if not isSize and targets[i].getVirtualRendererSize then
				width = math.min(targets[i]:getVirtualRendererSize().width, targets[i]:getContentSize().width)
				width = width * targets[i]:getScaleX()
			else
				width = targets[i]:getContentSize().width * targets[i]:getScaleX()
			end
			if targets[i]:isVisible() then
				targets[i]:setAnchorPoint(cc.p(0.5, 0.5))
				targets[i]:setPositionX(-totalLen / 2 + width / 2 + tempLen)
				tempLen = tempLen + width + interval
			end
		end
	end
	return tempLen
end
function SoraDToCenter(node, interval, isReverse, isSize)
	local targets = node:getChildren()
	local tempLen = SoraDToCenterTarges(targets, interval, isReverse, isSize)
	return node, tempLen
end
function SoraDautoSortPos(target, lineNum, align, singleSize, isReverse)
	if not target then
		return
	end
	local children = target:getChildren()
	local lineNum = lineNum or 4
	local align = align or 1
	singleSize = singleSize or children[1]:getContentSize()
	local visibleNum = 0
	local _ENV, showList = children[1], children[1]
	for k, v in ipairs(children) do
		if v:isVisible() then
			visibleNum = visibleNum + 1
			table.insert(showList, v)
		end
	end
	local maxH = math.ceil(visibleNum / lineNum)
	local totalW = lineNum * singleSize.width
	local totalH = maxH * singleSize.height
	for k, v in ipairs(showList) do
		local line = math.ceil(k / lineNum)
		local row = k % lineNum == 0 and lineNum or k % lineNum
		local curLineNum = math.min(lineNum, #showList - lineNum * (line - 1))
		local pascalH = maxH - 1 - 2 * (line - 1)
		local pascalW = align == 1 and curLineNum - 1 - 2 * (row - 1) or lineNum - 1 - 2 * (row - 1)
		if align == 2 then
			v:setPosition(singleSize.width * pascalW / 2, singleSize.height * pascalH / 2)
		elseif align == 1 then
			v:setPosition((isReverse and -1 or 1) * singleSize.width * pascalW / 2, singleSize.height * pascalH / 2)
		elseif align == 0 then
			v:setPosition(-singleSize.width * pascalW / 2, singleSize.height * pascalH / 2)
		end
	end
	_ENV = (for generator)
	ipairs(showList).totalH = totalH
	return ipairs(showList)
end
function SoraDCreateEllipseRunNode(img, length, width, isCW, speed)
	speed = speed or 1
	isCW = isCW or false
	local _r = 0
	local dir = 1
	if isCW then
		dir = -1
	end
	local node = display.newNode()
	local sprite
	if type(img) == "userdata" then
		sprite = img
	elseif type(img) == "string" then
		sprite = display.newSprite("#" .. img)
	end
	local update = function()
		local x = length * math.cos(_r)
		local y = width * math.sin(_r)
		sprite:setPosition(cc.p(x, y))
	end
	if sprite then
		sprite:setPosition(cc.p(length, 0))
		sprite:addTo(node)
		_UPVALUE1_ = sprite
		sprite[1] = cca.callFunc(update)
		sprite[2] = cca.delay(0.016666666666666666)
		sprite[3] = cca.delay(0.016666666666666666)
		sprite[4] = cca.delay(0.016666666666666666)
		local seq = cca.seq(sprite)
		sprite:runAction(cc.RepeatForever:create(seq))
	end
	return node
end
function SoraDHttpRequest(callBack, url, method, postDataInfo, errCallBack, notNeedJsonDecode, timeout)
	method = method or "GET"
	local onResponseGet = function(event)
		local request = event.request
		if event.name ~= "completed" then
			if request:getErrorCode() ~= 0 and event.name ~= "progress" and errCallBack then
				errCallBack(event.name)
			end
			return
		end
		local code = request:getResponseStatusCode()
		if code < 200 or 207 < code then
			print("request:code ", code)
			if errCallBack then
				errCallBack(code)
			end
			return
		end
		local strResponse = string.trim(request:getResponseString())
		print("strResponse:" .. strResponse)
		if not notNeedJsonDecode then
			local tabel = json.decode(strResponse)
			callBack(tabel)
		else
			callBack(strResponse)
		end
	end
	local request = network.createHTTPRequest(function(event)
		onResponseGet(event)
		if event.name ~= "progress" then
			event.request:release()
		end
	end, url, method)
	if string.upper(tostring(method)) == "GET" then
	elseif postDataInfo then
		if type(postDataInfo) == "string" then
			request:setPOSTData(postDataInfo)
		else
			for key, value in pairs(postDataInfo) do
				request:addPOSTValue(key, value)
			end
		end
	end
	request:setTimeout(timeout or 30)
	request:retain()
	request:start()
	return request
end
function SoraDClipCircleImg(img, radius)
	local judgeObj = type(img)
	if judgeObj == "string" then
		img = display.newSprite(img)
		radius = radius or img:getContentSize().width / 2
		local circle = cc.DrawNode:create()
		circle:drawSolidCircle(cc.p(0, 0), radius or img:getContentSize().width / 2, 0, 360, cc.c4f(1, 1, 1, 1))
		local cliperNode = cc.ClippingNode:create()
		cliperNode:setStencil(circle)
		cliperNode:setInverted(false)
		cliperNode:addChild(img, 0)
		return cliperNode, img
	elseif judgeObj == "table" or judgeObj == "userdata" then
		local image = img:clone()
		image:setPosition(0, 0)
		local circle = cc.DrawNode:create()
		circle:drawSolidCircle(cc.p(0, 0), radius or img:getContentSize().width / 2, 0, 360, cc.c4f(0, 0, 0, 1))
		local cliperNode = cc.ClippingNode:create()
		cliperNode:setStencil(circle)
		cliperNode:setInverted(false)
		cliperNode:addChild(image, 0)
		cliperNode:setAnchorPoint(cc.p(0.0, 0.0))
		cliperNode:setPosition(cc.p(img:getPositionX(), img:getPositionY()))
		cliperNode:addTo(img:getParent(), img:getLocalZOrder())
		img:removeFromParent()
		return image, cliperNode
	else
		return img
	end
end
function SoraDPreciseDecimal(nNum, n)
	if type(nNum) ~= "number" then
		return nNum
	end
	n = n or 0
	n = math.floor(n)
	local fmt = "%." .. n .. "f"
	local nRet = tonumber(string.format(fmt, nNum))
	return nRet
end
function SoraDCheckPNG(fileName, defaultName, singleTexture)
	return fileName
end
function SoraDConvertNum(num)
	if tonumber(num) > 99 then
		return "99+"
	end
	return num
end
function SoraDBezierTest(runNode, starPos, endPos, delay)
	local baseNode = display.newNode()
	local _ENV, tableBtn
	local runSprite = runNode == nil and display.newSprite("#icon_fight_add.png") or runNode
	local actionDelay = delay and delay or 1
	runSprite:setName("run")
	runSprite:addTo(baseNode)
	local drawNode = cc.DrawNode:create()
	drawNode:setPosition(cc.p(0, 0))
	drawNode:addTo(baseNode)
	drawNode:setName("bezier")
	for i = 1, 4 do
		local btnSingle = ccui.Button:create("frame_lordinfo_05.png", "frame_lordinfo_05.png", "frame_lordinfo_05.png", ccui.TextureResType.plistType)
		btnSingle:setPosition(cc.p(i * 5, i * 5))
		if starPos and i == 1 then
			btnSingle:setPosition(starPos)
		end
		if endPos and i == 4 then
			btnSingle:setPosition(endPos)
		end
		btnSingle:addTo(baseNode)
		btnSingle:addTouchEventListener(function(button, type)
			local touchPoint = cc.p(0, 0)
			local needPrint = false
			if type == ccui.TouchEventType.ended then
				touchPoint = button:getTouchEndPosition()
				needPrint = true
			elseif type == ccui.TouchEventType.moved then
				touchPoint = button:getTouchMovePosition()
			elseif type == ccui.TouchEventType.canceled then
				touchPoint = button:getTouchMovePosition()
			else
				touchPoint = button:getTouchBeganPosition()
			end
			touchPoint = button:getParent():convertToNodeSpace(touchPoint)
			button:setPosition(touchPoint)
			if needPrint then
				print("--------------------------------------")
			end
			local _ENV, tablePos = print, print
			for i, v in ipairs(tableBtn) do
				if needPrint then
					print("point " .. i .. " (" .. v:getPositionX() .. "," .. v:getPositionY() .. ")")
				end
				table.insert(tablePos, cc.p(v:getPositionX(), v:getPositionY()))
			end
			local runSprite = button:getParent():getChildByName("run")
			runSprite:setPosition(tablePos[1])
			runSprite:stopAllActions()
			actionDelay = table.insert
			_UPVALUE3_ = cc.p(v:getPositionX(), v:getPositionY())
			cc.p(v:getPositionX(), v:getPositionY())[1] = tablePos[2]
			cc.p(v:getPositionX(), v:getPositionY())[2] = tablePos[3]
			cc.p(v:getPositionX(), v:getPositionY())[3] = tablePos[4]
			table.insert[1] = cc.BezierTo:create(actionDelay, cc.p(v:getPositionX(), v:getPositionY()))
			table.insert[2] = cca.delay(1)
			table.insert[3] = cca.callFunc(function(...)
				runSprite:setPosition(tablePos[1])
			end)
			table.insert[4] = cca.callFunc(function(...)
				runSprite:setPosition(tablePos[1])
			end)
			table.insert[5] = cca.callFunc(function(...)
				runSprite:setPosition(tablePos[1])
			end)
			table.insert[6] = cca.callFunc(function(...)
				runSprite:setPosition(tablePos[1])
			end)
			table.insert[7] = cca.callFunc(function(...)
				runSprite:setPosition(tablePos[1])
			end)
			table.insert[8] = cca.callFunc(function(...)
				runSprite:setPosition(tablePos[1])
			end)
			runSprite:runAction(cca.repeatForever(cca.seq(table.insert)))
			local drawNode = button:getParent():getChildByName("bezier")
			drawNode:clear()
			drawNode:drawCubicBezier(tablePos[1], tablePos[2], tablePos[3], tablePos[4], 100, cc.c4f(1, 1, 1, 1))
		end)
		btnSingle:setTitleText(tostring(i))
		table.insert(tableBtn, btnSingle)
	end
	return baseNode
end
function SoraDGetRectMaxX(rect)
	return rect.x + rect.width
end
function SoraDGetRectMaxY(rect)
	return rect.y + rect.height
end
function SoraDRectMerge(rect1, rect2)
	local minX = math.min(rect1.x, rect2.x)
	local minY = math.min(rect1.y, rect2.y)
	local maxX = math.max(SoraDGetRectMaxX(rect1), SoraDGetRectMaxX(rect2))
	local maxY = math.max(SoraDGetRectMaxY(rect1), SoraDGetRectMaxY(rect2))
	return cc.rect(minX, minY, maxX - minX, maxY - minY)
end
function SoraDIsPointInRect(pos, rect)
	local isIn = false
	if pos.x >= rect.x and pos.x <= rect.x + rect.width and pos.y >= rect.y and pos.y <= rect.y + rect.height then
		isIn = true
	end
	return isIn
end
function SoraDCreateTroopNode(imgName)
	local et_node = display.newSprite(imgName)
	et_node:setOpacity(0)
	_UPVALUE1_ = et_node
	et_node[1] = cca.fadeTo(0.5, 1.0)
	et_node[2] = cca.callFunc(function()
		local seq_action = cca.rotateBy(2.0, 60)
		local rotation = math.random(0, 90)
		et_node:setRotation(rotation)
		et_node:runAction(cc.RepeatForever:create(seq_action))
	end)
	et_node[3] = cca.callFunc(function()
		local seq_action = cca.rotateBy(2.0, 60)
		local rotation = math.random(0, 90)
		et_node:setRotation(rotation)
		et_node:runAction(cc.RepeatForever:create(seq_action))
	end)
	local seq = cca.seq(et_node)
	et_node:runAction(seq)
	return et_node
end
local timer
function SoraDGetCurrentTime()
	if timer == nil then
	end
	return timer.time
end
function SoraDStartUvAnimation(node, timeKuvs)
	for _, timeKuv in ipairs(timeKuvs) do
		if node:getGLProgramState().setUniformTimeAnimation then
			node:getGLProgramState():setUniformTimeAnimation(timeKuv.name, timeKuv.kU, timeKuv.kV)
		end
	end
end
function SoraDGetIsWindows()
	return "\\" == package.config:sub(1, 1)
end
function SoraDStripExtension(filename)
	local idx = filename:match(".+()%.%w+$")
	if idx then
		return filename:sub(1, idx - 1)
	else
		return filename
	end
end
function SoraDGetFileName(filename)
	if SoraDGetIsWindows() then
		if not string.find(filename, "\\", 1, true) then
			return filename
		else
			return string.match(filename, ".+\\([^\\]*%.%w+)$")
		end
	elseif not string.find(filename, "/", 1, true) then
		return filename
	else
		return string.match(filename, ".+/([^/]*%.*%w+)$")
	end
end
function SoraDLerpNumber(v1, v2, alpha)
	return v1 * (1.0 - alpha) + v2 * alpha
end
function SoraDGetRandList(n)
	serviceFunctions.setRandomSeed()
	local _ENV, list = serviceFunctions.setRandomSeed, serviceFunctions.setRandomSeed
	local _ENV, map
	for i = 1, n do
		local rand = math.random(i, n)
		local value = rand
		if map[rand] then
			value = map[rand]
		end
		table.insert(list, value)
		map[rand] = map[i] or i
	end
	return list
end
function SoraDMergeRewards(rewards, exID)
	local _ENV, mergeTb
	local _ENV, map
	for _, v in ipairs(rewards) do
		map[v.id] = (map[v.id] or 0) + v.count
	end
	for k, v in pairs(map) do
		if exID and k == exID then
		else
			_ENV = v.count
			v.count.id = k
			v.count.count = v
			table.insert(mergeTb, v.count)
		end
	end
	table.sort(mergeTb, function(a, b)
		return a.id < b.id
	end)
	return mergeTb
end
local Widget = ccui.Widget
function Widget:addTouchEventListener(callback)
	local onTouch_ = function(...)
		if self.mildGuideCallBack then
			self.mildGuideCallBack(...)
		end
		self._touchEventListener_(...)
	end
	if not self._touchEventListener_ then
		self:addTouchEventListener_(onTouch_)
	end
	self._touchEventListener_ = callback
end
local Node = cc.Node
function _p(str)
	if SoraDFIsRA() and str then
		return TextDirectionMarkStr.ALM .. str
	end
	return str
end
function _q(str)
	if SoraDFIsRA() and str then
		return str .. TextDirectionMarkStr.ALM
	end
	return str
end
function _pq(str)
	if SoraDFIsRA() and str then
		return TextDirectionMarkStr.LRO .. str .. TextDirectionMarkStr.ALM
	end
	return str
end
function SoradNumStringNoZero(num, format)
	local t0, t1 = math.modf(num)
	if 0 < t1 then
		return string.format(format or "%.1f%%", t0 + t1)
	else
		return string.format("%d%%", t0 + t1)
	end
end
