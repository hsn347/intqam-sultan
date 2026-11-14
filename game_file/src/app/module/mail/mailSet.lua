local maillist = include("maillist")
local mailSet = class("mailSet")
function mailSet:ctor(mailSetType)
	self.mailNodes, _UPVALUE0_, self.mailLists, _UPVALUE0_, self.mailSetType = nil, nil, nil, nil, mailSetType
end
function mailSet:init(setNumInfo)
	if setNumInfo then
		local numInfo = setNumInfo.numInfo
		self:resetNumInfo(numInfo)
	end
end
function mailSet:resetNumInfo(numInfo)
	for key, v in pairs(numInfo) do
		local list = self:getMailListByKey(key)
		list:setNumOfNewMail(v.newNum)
		list:setNumOfMail(v.num)
	end
end
function mailSet:getMailList(mid, num, key)
	key = key or "key"
	local node
	if mid then
		node = self.mailNodes[key][mid]
	end
	return self:getMailListByKey(key):getList(node, num)
end
function mailSet:getFontMailNode(key)
	return self:getMailListByKey(key):front()
end
function mailSet:getLastMailNode(key)
	return self:getMailListByKey(key):last()
end
function mailSet:addMail(mid, key, isNewMail, isNotView)
	local mailList = self:getMailListByKey(key)
	if self:checkIsFullMail(key) then
		local lastNode = mailList:last()
		self:removeMail(lastNode.mid, key)
	end
	local mailNode = mailList:insert(mid, isNewMail, isNotView)
	if not self.mailNodes[key] then
		self.mailNodes[key], _ENV = mid, mid
	end
	self.mailNodes[key][mid] = mailNode
	print("mailSet:addMa", table.nums(self.mailNodes[key]))
end
function mailSet:removeMail(mid, key)
	local mailNode = self.mailNodes[key] and self.mailNodes[key][mid] or nil
	if not mailNode then
		return
	end
	self:getMailListByKey(key):remove(mailNode)
	self.mailNodes[key][mid] = nil
end
function mailSet:subNumOfNew(key, num)
	self:getMailListByKey(key):subNumOfNew(num)
end
function mailSet:subNum(key, num)
	self:getMailListByKey(key):subNum(num)
end
function mailSet:setNumOfNewMail(key, num)
	self:getMailListByKey(key):setNumOfNewMail(num)
end
function mailSet:hasMoreMail(mid, key)
	return self:getMailListByKey(key):hasMoreMail(mid)
end
function mailSet:checkIsFullMail(key)
	local total = self:getMailListByKey(key):localNum()
	local limit = gMailSetTypeFunc.getSetLimitNum(self.mailSetType)
	return total == limit
end
function mailSet:num(key)
	local limit = gMailSetTypeFunc.getSetLimitNum(self.mailSetType)
	local n = math.min(limit, self:getMailListByKey(key):num() or 0)
	return n
end
function mailSet:newNum(key)
	local n = self:getMailListByKey(key):newNum() or 0
	return n
end
function mailSet:getMailNumPer()
	local total = self:num()
	local limit = gMailSetTypeFunc.getSetLimitNum(self.mailSetType)
	local per = math.ceil(total / limit * 100)
	return per
end
function mailSet:getMailListByKey(key)
	key = key or "key"
	if not self.mailLists[key] then
		self.mailLists[key] = maillist.new()
	end
	return self.mailLists[key]
end
function mailSet:getMailNode(mid, key)
	return self.mailNodes[key][mid]
end
function mailSet:clean()
	self.mailNodes, _UPVALUE0_, self.mailLists, _UPVALUE0_ = nil, nil, nil, nil
end
function mailSet:dump()
	print(">>>>>mailSet" .. self.mailSetType)
	print("num of mailSet = ", self:num())
	print("num of new mail in the mailSet= ", self:newNum())
	for key, v in pairs(self.mailLists) do
		print("list key = ", key)
		v:dump()
		dump(self.mailNodes[key], "self.mailNodes")
	end
end
return mailSet
