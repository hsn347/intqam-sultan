condParser, _ENV = nil, nil
function condParser.verify(data)
	if not data.condtype then
		return true
	end
	local condFunc = condParser[data.condtype]
	if condFunc then
		return condFunc(data)
	else
		return true
	end
end
condParser[gCondType.buildlv] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(data.id)
	return curLevel >= data.condvalue
end
condParser[gCondType.itemcount] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local curCount = 0
	if include("resDesRead").checkResID(data.id) then
		return SoraDEnoughRes(data.id, data.condvalue)
	else
		curCount = backpackCtrl:getItemCount(data.id)
	end
	return curCount >= data.condvalue
end
condParser[gCondType.artifactlv] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
	local curLevel = godArmsCtrl:getArmLvByID(data.id)
	return curLevel >= data.condvalue
end
condParser[gCondType.castlelv] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	return curLevel >= data.condvalue
end
condParser[gCondType.allianceRank] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	return rank >= data.condvalue
end
condParser[gCondType.allianceRankEqual] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	return rank == data.condvalue
end
condParser[gCondType.allianceInShield] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	return allianceMsg:isAllianceInShieldList(data.condvalue)
end
condParser[gCondType.playerInShiled] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local chatCtrl = gametop.playertop_:getModule("chatCtrl")
	local shieldList = chatCtrl:getAllianceShield()
	local uid = data.condvalue
	if shieldList and shieldList[tostring(uid)] ~= nil then
		return true
	end
	return false
end
condParser[gCondType.alliancePermission] = function(data)
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	local ok, err = permissionCtrl:checkPermission(data.condvalue)
	return ok, err
end
condParser[gCondType.playerInAllianceShiled] = function(data)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	return allianceMsg:isLordInShieldList(data.condvalue)
end
return condParser
