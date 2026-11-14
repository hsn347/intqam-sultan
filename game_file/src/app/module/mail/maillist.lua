local linkList = include("linkList")
local maillist = class("maillist")
local sortFunc = function(newNode, oldNode)
	return newNode.mid > oldNode.mid
end
function maillist:ctor()
	self._link_list = linkList.new("mid")
	self._link_list:setCompare(sortFunc)
	self._total = 0
	self._newNum = 0
end
function maillist:insert(mid, isNewMail, isNotView)
	print("maillist:insert", mid, isNewMail, isNotView)
	local node = self._link_list:newNode(mid)
	self._link_list:insert(node)
	if isNewMail then
		self._total = self._total + 1
		if isNotView then
			self._newNum = self._newNum + 1
		end
	end
	return node
end
function maillist:remove(node)
	self._link_list:remove(node)
	local mid = node.mid
	local mail = gModuleMgr.sharedMgr("mailMgr"):queryMail(mid)
	if mail and not mail:isView() then
		self._newNum = self._newNum - 1
	end
	self._total = self._total - 1
end
function maillist:getList(node, num)
	if not node then
		node = self._link_list:front()
	else
		node = node.next
	end
	if not node then
		_ENV = self._link_list
		return gErrDef.Err_HAS_NOT_MORE_MAIL, self._link_list
	end
	local _ENV, ret = gErrDef.Err_HAS_NOT_MORE_MAIL, gErrDef.Err_HAS_NOT_MORE_MAIL
	for i = 1, num do
		_ENV = nil
		;(nil).mid = node.mid
		table.insert(ret, nil)
		node = node.next
		if not node then
			break
		end
	end
	if 0 < #ret then
		return gErrDef.Err_None, ret
	end
	return gErrDef.Err_HAS_NOT_MORE_MAIL, ret
end
function maillist:clean()
	self._link_list:clean()
	self:setNumOfNewMail(0)
end
function maillist:newNum()
	return self._newNum
end
function maillist:num()
	return self._total
end
function maillist:setNumOfNewMail(num)
	self._newNum = num
end
function maillist:setNumOfMail(num)
	self._total = num
end
function maillist:subNum(num)
	num = num or 1
	if num > self._total then
		self._total = 0
	else
		self._total = self._total - num
	end
	return self._total
end
function maillist:subNumOfNew(num)
	num = num or 1
	if num > self._newNum then
		self._newNum = 0
	else
		self._newNum = self._newNum - num
	end
end
function maillist:addNumOfNew(num)
	num = num or 1
	self._newNum = self._newNum + 1
end
function maillist:hasMoreMail(mid)
	if 0 == self._total then
		return false
	end
	if 0 == self._link_list:size() then
		return true
	end
	if mid then
		local node = self._link_list:last()
		if mid ~= node.mid then
			return true
		else
			return self._link_list:size() < self._total
		end
	else
		return self._link_list:size() < self._total
	end
end
function maillist:front()
	return self._link_list:front()
end
function maillist:last()
	return self._link_list:last()
end
function maillist:localNum()
	return self._link_list:size()
end
function maillist:dump()
	print(">>>>>maillist")
	print("num of list = ", self._total)
	print("num of new mail in the list = ", self._newNum)
end
return maillist
