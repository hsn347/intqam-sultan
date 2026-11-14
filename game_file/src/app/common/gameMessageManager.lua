local queue = require("app.common.luaQueue")
local _ENV, _tMsgvectorList = "app.common.luaQueue", "app.common.luaQueue"
local _ENV, _tMsgObjListionerList
function SoraDAddMessage(target, msgDefine, backFunc)
	if target == nil or backFunc == nil then
		return
	end
	local msg = getMessageByDefine(msgDefine)
	if msg == nil then
		return
	end
	if not _tMsgObjListionerList[target] then
		_tMsgObjListionerList[target], _ENV = _tMsgObjListionerList[target], _tMsgObjListionerList[target]
	end
	_tMsgObjListionerList[target][msg] = true
	if not _tMsgvectorList[msg] then
		_tMsgvectorList[msg] = queue.new()
	end
	_tMsgvectorList[msg]:pushFront(target, backFunc)
end
function SoraDSendMessage(data, content)
	local msg = getMessageByDefine(data.msg)
	if msg == nil then
		return
	end
	if content and content.clientData then
		data.clientData = content.clientData
	end
	local listioner = _tMsgvectorList[msg]
	if listioner then
		local node = listioner.cacheTail
		while node do
			local obj = node.key
			local func = node.value
			func(obj, data)
			node = node.preNode
			while node and not listioner:get(node.key) do
				node = node.preNode
			end
		end
	end
end
function SoraDRemoveMessageByTarget(target)
	if target == nil then
		return
	end
	if not _tMsgObjListionerList[target] then
		_ENV = _tMsgObjListionerList[target]
	end
	for k in pairs(_tMsgObjListionerList[target]) do
		local listioner = _tMsgvectorList[k]
		if listioner then
			listioner:remove(target)
		end
	end
	_tMsgObjListionerList[target] = nil
end
function SoraDRemoveMessageFromTargetByName(target, msgDefine)
	if target == nil then
		return
	end
	local msg = getMessageByDefine(msgDefine)
	if msg == nil then
		return
	end
	if _tMsgObjListionerList[target] then
		_tMsgObjListionerList[target][msg] = nil
	end
	if _tMsgvectorList[msg] then
		_tMsgvectorList[msg]:remove(target)
	end
end
function SorDRemoveAllMessage(...)
	_tMsgvectorList = nil
	_tMsgvectorList = {}
end
function SorDIsMessageAddByTarget(target, msgDefine)
	local ret = false
	if target == nil then
		return ret
	end
	local msg = getMessageByDefine(msgDefine)
	if msg == nil then
		return ret
	end
	if not _tMsgObjListionerList[target] then
		return ret
	end
	if _tMsgObjListionerList[target][msg] then
		ret = true
	end
	return ret
end
function SorDHasMessageByTarget(target)
	local ret = false
	if target == nil then
		return ret
	end
	if not _tMsgObjListionerList[target] then
		return ret
	else
		ret = true
	end
	return ret
end
function SorDIsMessageAdd(msgDefine)
	local ret = false
	if msgDefine == nil then
		return ret
	end
	local msg = getMessageByDefine(msgDefine)
	if msg == nil then
		return ret
	end
	for _, v in pairs(_tMsgObjListionerList) do
		if v[msg] then
			ret = true
			break
		end
	end
	return ret
end
