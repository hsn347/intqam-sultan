local chatNodeCache = include("chatNodeCache")
chatNodeCacheMgr, _ENV = "chatNodeCache", "chatNodeCache"
function chatNodeCacheMgr.add(node, nodeType, caches, tag)
	if not caches then
		return
	end
	if tag then
		nodeType = gChatNodeTypeTag[nodeType] + tag
	end
	local cache = caches[nodeType]
	if not cache then
		cache = chatNodeCache:new()
		caches[nodeType] = cache
	end
	if cache then
		cache:add(node)
	end
end
function chatNodeCacheMgr.get(nodeType, caches, tag)
	if not caches then
		return
	end
	if tag then
		nodeType = gChatNodeTypeTag[nodeType] + tag
	end
	local cache = caches[nodeType]
	if not cache then
		return
	end
	if cache then
		return cache:get()
	end
end
function chatNodeCacheMgr.clearCache(caches)
	if not caches then
		return
	end
	for _, cache in pairs(caches) do
		cache:clean()
	end
	caches, _ENV = pairs(caches)
end
return chatNodeCacheMgr
