local KWPacksCell = class("KWPacksCell")
local gametop = gModuleMgr.getObject("gametop")
function KWPacksCell:canGivePacks(uid, type)
	local ret = gErrDef.Err_None
	local pack = self.data.packs[tostring(type)]
	if not pack then
		ret = gErrDef.Err_KW_NOT_EXISTS_ERROR
	end
	for type, packs in pairs(self.data.packs) do
		if packs[tostring(uid)] then
			ret = gErrDef.Err_KW_REPEAT_ERROR
			break
		end
	end
	local kingPacksRead = include("kingPacksRead")
	local packsSetting = kingPacksRead.getItem(type)
	if packsSetting.num <= table.nums(self.data.packs[tostring(type)]) then
		ret = gErrDef.Err_KW_NOT_ENOUGH_ERROR
	end
	print("KWPacksCell:canGivePacks(uid, type)", uid, type, ret)
	return ret
end
function KWPacksCell:givePacks(uid, type)
	print("KWPacksCell:givePacks(uid, type)", uid, type)
	self.data.packs[tostring(type)][tostring(uid)] = 1
	return gErrDef.Err_None
end
function KWPacksCell:getPacks()
	return self.data.packs
end
function KWPacksCell:getLeftCountByType(myRank)
	local kingPacksRead = include("kingPacksRead")
	local ret = 0
	if myRank then
		local nType = myRank + 2
		local packsSetting = kingPacksRead.getItem(nType)
		if packsSetting and packsSetting.num and self.data.packs and self.data.packs[tostring(nType)] then
			ret = packsSetting.num - table.nums(self.data.packs[tostring(nType)])
		end
	end
	return ret
end
function KWPacksCell:canGivePack(uid)
	local ret = true
	for _, packs in pairs(self.data.packs) do
		if packs[tostring(uid)] then
			ret = false
			break
		end
	end
	return ret
end
local instance
function KWPacksCell.sharedInstance()
	return instance
end
function KWPacksCell:getDefaultData()
	;(nil).packs, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	return nil
end
function KWPacksCell:ctor()
	self.data = self:getDefaultData()
	self.lastDateTime = 0
end
function KWPacksCell:cancelKing()
	self.data = self:getDefaultData()
end
function KWPacksCell:becomeKing(data)
	self.data = data
end
return KWPacksCell
