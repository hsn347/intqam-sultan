local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local memberC = include("member")
local memberMgr = class("memberMgr", gameModule)
function memberMgr:ctor(properties)
	memberMgr.super.ctor(self, properties)
	self:resetData()
end
function memberMgr:resetData()
	self.memberList, _UPVALUE0_ = nil, nil
end
function memberMgr:EnterGame()
end
function memberMgr:Logout()
	self:resetData()
end
function memberMgr:addMember(member)
	if member then
		local uid = member:getProperty("uid")
		self.memberList[tostring(uid)] = member
	end
end
function memberMgr:getMember(uid)
	local member = self.memberList[tostring(uid)]
	return member
end
function memberMgr:getMemberList()
	return self.memberList
end
function memberMgr:getOwnMember()
	local gametop = gModuleMgr.getObject("gametop")
	local uid = gametop.playertop_:getPlayerID()
	return self:getMember(uid)
end
function memberMgr:setMemberMinfo(key, value, uid)
	local uid = uid
	if not uid then
		local gametop = gModuleMgr.getObject("gametop")
		uid = gametop.playertop_:getPlayerID()
	end
	self.memberList[tostring(uid)]:setProperty(key, value)
end
function memberMgr:updateMemberInfo(somemember)
	for k, v in pairs(somemember) do
		if self.memberList[k] then
			self.memberList[k].minfo = v.minfo
			self.memberList[k].uinfo = v.uinfo
		end
	end
end
function memberMgr:isOwnOfficial()
	local ret = false
	local ownInfo = self:getOwnMember()
	if not ownInfo then
		return false
	end
	local ownOfficial = ownInfo.minfo.official
	if ownOfficial and ownOfficial >= gAllianceOfficial.COMMANDER and ownOfficial <= gAllianceOfficial.RECRUITER then
		ret = true
	end
	return ret, ownOfficial
end
function memberMgr:isApplyedOfficial(officialid)
	local ret = false
	local ownInfo = self:getOwnMember()
	local curApplyOfficial = ownInfo.minfo.curApplyOfficial
	if curApplyOfficial and curApplyOfficial == officialid then
		ret = true
	end
	return ret
end
function memberMgr:getOtherAppointMemberList(official)
	local _ENV, mlist
	for k, v in pairs(self.memberList) do
		if v.minfo.rank == gAllianceRank.R0 or v.minfo.rank > gAllianceRank.R4 and v.minfo.official and v.minfo.official > gAllianceOfficial.NONE or v.minfo.curApplyOfficial and v.minfo.curApplyOfficial == official then
		else
			table.insert(mlist, v)
		end
	end
	return mlist
end
function memberMgr:getRankMemberList(memberlist, isself)
	local _ENV, ret
	local keytb = table.values(gAllianceRank)
	for k, v in pairs(keytb) do
		ret[tostring(v)], _ENV = v, v
	end
	for k, v in pairs(memberlist) do
		local rank = v:getProperty("rank")
		if ret[tostring(rank)] then
			table.insert(ret[tostring(rank)], v)
		else
			local _ENV, tb = table.insert, table.insert
			table.insert(tb, v)
			ret[tostring(rank)] = tb
		end
	end
	if isself then
		local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
		local ok, err = permissionCtrl:checkPermission(gAPermission.RECRUIT)
		if not ok then
			ret[tostring(gAllianceRank.R0)] = nil
		end
	else
		ret[tostring(gAllianceRank.R0)] = nil
	end
	return ret
end
function memberMgr:getDonateRank(idlist, ranktype)
	local _ENV, memberlist
	for k, uid in pairs(idlist) do
		local member = self:getMember(uid)
		table.insert(memberlist, member)
	end
	table.sort(memberlist, function(l, r)
		local firstkey = "sciPointDay"
		local secondkey = "honorDay"
		local thirdkey = "rank"
		local forthkey = "uid"
		if ranktype == gARankType.WEEK then
			firstkey = "sciPointWeek"
			secondkey = "honorWeek"
		elseif ranktype == gARankType.HISTORY then
			firstkey = "sciPointTotal"
			secondkey = "honorTotal"
		end
		local ret = true
		if not l then
			ret = true
		elseif not r then
			ret = false
		elseif l:getProperty(firstkey) == r:getProperty(firstkey) then
			if l:getProperty(secondkey) == r:getProperty(secondkey) then
				if l:getProperty(thirdkey) == r:getProperty(thirdkey) then
					ret = l:getProperty(forthkey) < r:getProperty(forthkey)
				else
					ret = l:getProperty(thirdkey) > r:getProperty(thirdkey)
				end
			else
				ret = l:getProperty(secondkey) > r:getProperty(secondkey)
			end
		else
			ret = l:getProperty(firstkey) > r:getProperty(firstkey)
		end
		return ret
	end)
	return memberlist
end
function memberMgr:cleatMemNotSelf()
	local gametop = gModuleMgr.getObject("gametop")
	local uid = gametop.playertop_:getPlayerID()
	for k, v in pairs(self.memberList) do
		if uid ~= tonumber(k) then
			self.memberList[tostring(k)] = nil
		end
	end
end
function memberMgr:dump()
	print("-------------memberList start------------")
	for k, v in pairs(self.memberList) do
		v:dump()
	end
	print("-------------memberList end------------")
end
return memberMgr
