local Tree = class("Tree")
local TreeNode = class("TreeNode")
local rectScale = 3
local rectThreshold = 1
local C = function(value)
	return math.floor(value / rectScale + 0.5) .. WrapBrace(value)
end
function Tree:ctor(from, to)
	self.from = from
	self.leafs, TreeNode, self.to = nil, nil, to
	self.root = TreeNode.new(from, to, self.leafs)
end
function Tree:Insert(from, to, value)
	self.root:Insert(from, to, value)
end
function Tree:GetProjects()
	local _UPVALUE0_, projects
	for i = self.from, self.to - 1 do
		if self.leafs[i].value > 0 then
			projects[i] = true
		end
	end
	return projects
end
function Tree:GetProjectSegments()
	local _ENV, segments
	local start
	for i = self.from, self.to - 1 do
		if self.leafs[i].value > 0 then
			if not start then
				start = i
			end
		elseif start then
			_UPVALUE2_ = nil
			;(nil)[1] = start
			;(nil)[2] = i
			table.insert(segments, nil)
			start = nil
		end
	end
	if start then
		_UPVALUE2_ = 1
		;(1)[1] = start
		;(1)[2] = self.to
		table.insert(segments, 1)
		start = nil
	end
	return segments
end
function Tree:GetProjectsDelta(projects1, projects2)
	local _ENV, delta
	local start
	for i = self.from, self.to - 1 do
		if projects1[i] ~= projects2[i] then
			if not start then
				start = i
			end
		elseif start then
			_UPVALUE2_ = nil
			;(nil)[1] = start
			;(nil)[2] = i
			table.insert(delta, nil)
			start = nil
		end
	end
	if start then
		_UPVALUE2_ = 1
		;(1)[1] = start
		;(1)[2] = self.to
		table.insert(delta, 1)
		start = nil
	end
	return delta
end
function TreeNode:ctor(from, to, leafs)
	self.from = from
	self.to = to
	local length = to - from
	if 1 < length then
		self.middle = from + math.floor((to - from) / 2)
		self.left = TreeNode.new(from, self.middle, leafs)
		self.right = TreeNode.new(self.middle, to, leafs)
	else
		self.value = 0
		leafs[from] = self
	end
end
function TreeNode:Insert(from, to, value)
	if self.middle then
		if from < self.middle then
			self.left:Insert(from, to, value)
		end
		if to > self.middle then
			self.right:Insert(from, to, value)
		end
	else
		self.value = self.value + value
	end
end
local Joints = class("Joints")
Joints.scale = 100000
function Joints:ctor()
	self.joints, _UPVALUE0_ = nil, nil
end
function Joints:GetOutlines()
	local _ENV, outlines
	while true do
		local lines = self:GetOutline()
		if not lines then
			return outlines
		end
		table.insert(outlines, lines)
	end
end
local AddJointToOutline = function(joint, outlines)
	table.insert(outlines, joint.x)
	table.insert(outlines, joint.y)
end
function Joints:friendPrint()
	for _, joint in pairs(self.joints) do
		local joint1 = self.joints[joint[1]]
		local joint2 = self.joints[joint[2]]
		print(C(joint.x) .. " " .. C(joint.y) .. " j1: " .. C(joint1.x) .. " " .. C(joint1.y) .. " j2: " .. C(joint2.x) .. " " .. C(joint2.y))
	end
end
function Joints:GetOutline()
	if next(self.joints) == nil then
		return
	end
	local _ENV, outlines = next(self.joints), next(self.joints)
	local startJoint
	for _, joint in pairs(self.joints) do
		startJoint = joint
		break
	end
	AddJointToOutline(startJoint, outlines)
	local from = startJoint
	local to = self.joints[from[1]]
	while to ~= startJoint do
		AddJointToOutline(to, outlines)
		self.joints[to.index] = nil
		local nextIndex = from.index == to[1] and to[2] or to[1]
		from = to
		to = self.joints[nextIndex]
	end
	self.joints[startJoint.index] = nil
	return outlines
end
function Joints.GetIndex(x, y)
	return x * Joints.scale + y
end
function Joints.GetXY(index)
	local x = math.round(index / Joints.scale)
	local y = index - x * Joints.scale
	return x, y
end
function Joints:Add(joint)
	if self.joints[joint.index] then
		local joint2 = self.joints[joint.index]
		if joint2:Update(joint, self.joints) then
			return true
		end
	else
		self.joints[joint.index] = joint
	end
end
local Joint = class("Joint")
function Joint:ctor(x, y)
	self.x = x
	self.y = y
	self.index = Joints.GetIndex(x, y)
end
function Joint:Connect(joint)
	if joint.x == self.x then
		self[1] = joint.index
		joint[1] = self.index
	elseif joint.y == self.y then
		self[2] = joint.index
		joint[2] = self.index
	else
		error("Cannot joint")
	end
end
function Joint:Update(joint, joints)
	for connect = 1, 2 do
		local nextIndex1 = self[connect]
		local nextIndex2 = joint[connect]
		if nextIndex2 then
			if not joints[nextIndex2] then
				local x, y = Joints.GetXY(nextIndex2)
				local newJoint = Joint.new(x, y)
				joints[nextIndex2] = newJoint
			end
			if not nextIndex1 then
				self[connect] = nextIndex2
				joints[nextIndex2][connect] = self.index
				return true
			else
				joints[nextIndex1][connect] = nextIndex2
				joints[nextIndex2][connect] = nextIndex1
				joints[self.index] = nil
				return true
			end
		end
	end
end
local CreateSegment = function(from, to, x, flag)
	_UPVALUE0_ = nil
	;(nil).from = from
	;(nil).to = to
	;(nil).x = x
	;(nil).flag = flag
	return nil
end
local GetRectInfo = function(left, top, width, height)
	left = math.round(left * rectScale) - rectThreshold
	top = math.round(top * rectScale) - rectThreshold
	width = math.round(width * rectScale) + rectThreshold * 2
	height = math.round(height * rectScale) + rectThreshold * 2
	local right = left + width
	local bottom = top + height
	return top, bottom, CreateSegment(top, bottom, left, 1), CreateSegment(top, bottom, right, -1)
end
local CreateJoints = function(x0, y0, x1, y1, joints)
	local joint0 = Joint.new(x0, y0)
	local joint1 = Joint.new(x1, y1)
	joint0:Connect(joint1)
	if not joints:Add(joint0) then
		joints:Add(joint1)
	end
end
local AddHorizonOutlines = function(projects, fromX, toX, joints)
	for _, segment in pairs(projects) do
		CreateJoints(fromX, segment[1], toX, segment[1], joints)
		CreateJoints(fromX, segment[2], toX, segment[2], joints)
	end
end
local AddVerticalOutlines = function(deltas, x, joints)
	for _, item in ipairs(deltas) do
		CreateJoints(x, item[1], x, item[2], joints)
	end
end
local Analyze = function(previousProjects, fromX, toX, tree, joints)
	local projects = tree:GetProjects()
	local deltas = tree:GetProjectsDelta(previousProjects, projects)
	if next(projects) ~= nil then
		AddHorizonOutlines(tree:GetProjectSegments(), fromX, toX, joints)
	end
	if next(deltas) ~= nil then
		AddVerticalOutlines(deltas, fromX, joints)
	end
	return projects
end
local ConvertBack = function(value)
	value = value / rectScale
	local major = math.round(value)
	local minor = (value - major) * 0.2
	return major + minor
end
local RevertLine = function(line)
	local count = #line / 2
	local pairCount = math.floor(count / 2)
	for i = 1, pairCount do
		local x1, x2 = i * 2 - 1, (count - i + 1) * 2 - 1
		local y1, y2 = i * 2, (count - i + 1) * 2
		line[x1], line[x2] = line[x2], line[x1]
		line[y1], line[y2] = line[y2], line[y1]
	end
end
local IsInside = function(x, y, data)
	local count = #data / 4
	for i = 0, count - 1 do
		local left, top, width, height = data[i * 4 + 1], data[i * 4 + 2], data[i * 4 + 3], data[i * 4 + 4]
		if x >= left and x < left + width and y >= top and y < top + height then
			return true
		end
	end
end
local GetOffset = function(num0, num1)
	if num0 == num1 then
		return 0
	elseif num1 < num0 then
		return 0.8
	else
		return -0.8
	end
end
local SortLine = function(line, data)
	local count = #line / 2
	local maxX, maxIndex
	for i = 1, count do
		local x = line[i * 2 - 1]
		if not maxX or maxX < x then
			maxX = x
			maxIndex = i
		end
	end
	local i0, i1, i2 = maxIndex - 1, maxIndex, maxIndex + 1
	if i0 < 1 then
		i0 = count
	end
	if count < i2 then
		i2 = 1
	end
	local x0 = line[i0 * 2 - 1]
	local x1 = line[i1 * 2 - 1]
	local x2 = line[i2 * 2 - 1]
	local y0 = line[i0 * 2]
	local y1 = line[i1 * 2]
	local y2 = line[i2 * 2]
	local clockwise = 0 < (x1 - x0) * (y2 - y1) - (y1 - y0) * (x2 - x1)
	local offsetX = GetOffset(x0, x1)
	local offsetY = GetOffset(y0, y1)
	local offsetX2 = GetOffset(x2, x1)
	local offsetY2 = GetOffset(y2, y1)
	local xInside = x1 + (offsetX + offsetX2) * 0.5
	local yInside = y1 + (offsetY + offsetY2) * 0.5
	local inside = IsInside(xInside, yInside, data)
	if clockwise then
		if inside then
			RevertLine(line)
		end
	elseif not inside then
		RevertLine(line)
	end
end
local RecognizeOutline = class("RecognizeOutline")
function RecognizeOutline:GetOutline(data)
	local GetRectInfo, segments
	local max, min
	local count = #data / 4
	for i = 0, count - 1 do
		local top, bottom, segmentLeft, segmentRight = GetRectInfo(data[i * 4 + 1], data[i * 4 + 2], data[i * 4 + 3], data[i * 4 + 4])
		table.insert(segments, segmentLeft)
		table.insert(segments, segmentRight)
		if not max or max < bottom then
			max = bottom
		end
		if not min or min > top then
			min = top
		end
	end
	table.sort(segments, function(a, b)
		return a.x < b.x
	end)
	local joints = Joints.new()
	local tree = Tree.new(min, max)
	local GetRectInfo, previousProjects = min, min
	local previousX
	for _, segment in ipairs(segments) do
		local cal
		if previousX and segment.x ~= previousX then
			cal = true
		end
		if cal then
			previousProjects = Analyze(previousProjects, previousX, segment.x, tree, joints)
		end
		tree:Insert(segment.from, segment.to, segment.flag)
		previousX = segment.x
	end
	Analyze(previousProjects, previousX, max, tree, joints)
	local outlines = joints:GetOutlines()
	for _, line in ipairs(outlines) do
		for i = 1, #line do
			line[i] = ConvertBack(line[i])
		end
	end
	for _, line in ipairs(outlines) do
		SortLine(line, data)
	end
	return outlines
end
return RecognizeOutline
