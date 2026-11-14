_ENV, _redPointMgrInstance = nil, nil
;(nil).redWithOutNum = 1
;(nil).redWithNum = 2
;(nil).blueWithOutNum = 3
gRedPointStyle, (nil).blueWithNum = nil, 4
redPointMgr = class("redPointMgr")
function redPointMgr:getInstance()
	if _redPointMgrInstance == nil then
		_redPointMgrInstance = redPointMgr.new()
	end
	return _redPointMgrInstance
end
function redPointMgr:ctor()
	self.redPointRelateList, _ENV, self.redPointList, _ENV = nil, nil, nil, nil
	_ENV = nil
	;(nil).__mode = "kv"
	setmetatable(self.redPointList, nil)
	_ENV = nil
	;(nil).__mode = "kv"
	setmetatable(self.redPointRelateList, nil)
end
function redPointMgr:add(keyName, _num, _fatherName)
	if self.redPointList[keyName] then
		self.redPointList[keyName].num = _num
	else
		_UPVALUE0_ = nil
		self.redPointList[keyName], (nil).num = nil, _num
	end
	if _fatherName then
		if self.redPointRelateList[_fatherName] then
			self.redPointRelateList[_fatherName].child[keyName] = true
		else
			_UPVALUE0_, _UPVALUE0_ = nil, nil
			self.redPointRelateList[_fatherName], (nil).child, (nil)[keyName] = nil, nil, true
		end
		if self.redPointRelateList[keyName] then
			self.redPointRelateList[keyName].father = _fatherName
		else
			_UPVALUE0_ = nil
			self.redPointRelateList[keyName], (nil).father = nil, _fatherName
		end
	end
end
local getPropNum = function(vtbl, key)
	local baseNum = vtbl[key]
	return baseNum and baseNum.num or 0
end
local findEveryChildGetNum = function(vtbl, rtbl, key)
	local children = rtbl[key]
	local retNum = 0
	if children and children.child then
		for k, _ in pairs(children.child) do
			retNum = retNum + getPropNum(vtbl, k)
		end
	end
	return retNum
end
local getNumByConfig = function(vtbl, rtbl, key, config)
	if config and config.needChildNum then
		local baseNum = getPropNum(vtbl, key)
		print("baseNum=", baseNum)
		local branchNum = findEveryChildGetNum(vtbl, rtbl, key)
		print("branchNum=", branchNum)
		return baseNum + branchNum
	else
		local baseNum = getPropNum(vtbl, key)
		print("baseNum=", baseNum)
		return baseNum
	end
end
function redPointMgr.makeIconByStyle(_style, _num)
	if gRedPointStyle.redWithOutNum == _style then
		return "一个红点"
	elseif gRedPointStyle.redWithNum == _style then
		return "一个红点=" .. _num
	elseif gRedPointStyle.blueWithOutNum == _style then
		return "一个蓝点"
	elseif gRedPointStyle.blueWithNum == _style then
		return "一个蓝点=" .. _num
	end
end
function redPointMgr:pop(keyName, _style)
	getNumByConfig = nil
	;(nil).needChildNum = true
	local totalNum = getNumByConfig(self.redPointList, self.redPointRelateList, keyName, nil)
	print(redPointMgr.makeIconByStyle(_style, totalNum))
end
local function wipeRelateChildFloor(vtbl, rtbl, key)
	local redPointRelateVal = rtbl[key]
	if redPointRelateVal and redPointRelateVal.child then
		for k, v in pairs(redPointRelateVal.child) do
			if rtbl[k] and rtbl[k].child and next(rtbl[k].child) then
				wipeRelateChildFloor(vtbl, rtbl, k)
			else
				rtbl[k] = nil
				vtbl[k] = nil
			end
		end
	end
end
local wipeRelateFather = function(rtbl, key)
	local selfRedPointRelateVal = rtbl[key]
	if selfRedPointRelateVal and selfRedPointRelateVal.father and rtbl[selfRedPointRelateVal.father] and rtbl[selfRedPointRelateVal.father].child then
		rtbl[selfRedPointRelateVal.father].child[key] = nil
	end
	rtbl[key] = nil
end
function redPointMgr:wipe(keyName)
	if self.redPointList[keyName] then
		self.redPointList[keyName] = nil
	end
	wipeRelateChildFloor(self.redPointList, self.redPointRelateList, keyName)
	wipeRelateFather(self.redPointRelateList, keyName)
end
