local pageObject = include("pageObject")
local pageAnimate = class("pageAnimate", pageObject)
local worldMapAnimateRead = include("worldMapAnimateRead")
local instanceCacheMgr = include("instanceCacheMgr")
local animateFactory = include("animateFactory")
local BEGIN_TYPE = instanceCacheMgr.BEGIN_TYPE.ANIMATE_BEGIN_TYPE
function pageAnimate:ctor(comInstance)
	pageAnimate.super.ctor(self)
	self.comInstance = comInstance
end
function pageAnimate:createObjectByPage(pageID)
	local configData = worldMapAnimateRead.getAnimatePage(pageID)
	local comInstance = self.comInstance
	if configData then
		for _, v in pairs(configData) do
			local gid = v.gid
			local tag = gid + BEGIN_TYPE
			local beginPos = cc.p(v.x, v.y)
			local animateNode = instanceCacheMgr.getInstance(tag)
			if not animateNode then
				animateNode = animateFactory.createAnimateInstanace(v)
				animateNode:setTag(tag)
				animateNode:setName(tag)
				comInstance:addAnimateNode(animateNode, beginPos)
				self:addObjectByPage(pageID, animateNode)
				print("animateNode create ", gid)
			else
				comInstance:addAnimateNode(animateNode, beginPos)
				animateNode:release()
				self:addObjectByPage(pageID, animateNode)
				print("animateNode get from cache", gid)
			end
		end
	end
end
function pageAnimate:delObject(object)
	if object then
		if object:getTag() > BEGIN_TYPE then
			instanceCacheMgr.addAnimateNode(object)
			object:removeFromParent(false)
		else
			object:removeFromParent()
		end
	end
end
return pageAnimate
