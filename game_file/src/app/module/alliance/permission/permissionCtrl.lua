local permissionConfig = include("permissionConfig")
local alliancePermissionltCtrl = include("alliancePermissionltCtrl")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local permissionCtrl = class("permissionCtrl", cc.mvc.ModelBase)
local _ENV, RSP = "permissionCtrl", "permissionCtrl"
function permissionCtrl:ctor()
	permissionCtrl.super.ctor(self)
	self.config = permissionConfig.new()
	self:init()
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_PERMISSION, handler(self, RSP.modifyPermissionRsp))
end
function permissionCtrl:Logout()
	self.config:destroy()
end
function permissionCtrl:reqModifyPermission(modifyList)
	local ok, reqModifyList = self:modifyPermission(modifyList)
	if ok and 0 < #reqModifyList then
		serverproxy = nil
		;(nil).modifyList = reqModifyList
		serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_PERMISSION, nil)
	end
end
function permissionCtrl:modifyPermission(modifyList)
	if "table" ~= type(modifyList) or not next(modifyList) then
		return false, gErrDef.Err_ILLEGAL_PARAMS
	end
	local _ENV, reqModifyList = false, false
	for permission, v in pairs(modifyList) do
		if not alliancePermissionltCtrl:isPermission(permission) then
			return false, gErrDef.Err_ILLEGAL_PARAMS
		end
		for rank, status in pairs(v) do
			if "number" ~= type(rank) or rank < gAllianceRank.R1 or rank > gAllianceRank.R5 then
				return false, gErrDef.Err_ILLEGAL_PARAMS
			end
			if status then
				if gErrDef.Err_None == self.config:setPermissionValid(permission, rank) then
					_ENV = self.config
					self.config.permission = permission
					self.config.rank = rank
					self.config.status = gStatus.YES
					table.insert(reqModifyList, self.config)
				end
			elseif gErrDef.Err_None == self.config:setPermissionInvalid(permission, rank) then
				_ENV = self.config
				self.config.permission = permission
				self.config.rank = rank
				self.config.status = gStatus.NO
				table.insert(reqModifyList, self.config)
			end
		end
	end
	return true, reqModifyList
end
function permissionCtrl:getShowList()
	return self.config:getPermissionShowList()
end
_UPVALUE3_, permissionCtrl.getMemberMenu = function(self, mRank, mRfKid)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local rfKid = ownmember:getProperty("rfKid")
	if not ownRank or not mRank then
		return
	end
	local ret = clone(self.memberMenu[ownRank][mRank])
	if rfKid and 0 < rfKid then
		if mRank == gAllianceRank.R5 then
			table.removebyvalue(ret.left, gAPermission.REPLACE_LEADER)
		end
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
	elseif mRfKid and 0 < mRfKid then
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
		table.removebyvalue(ret.left, gAPermission.DEMISE)
	end
	dump(ret, "ret")
	return ret
end, function(self, mRank, mRfKid)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local rfKid = ownmember:getProperty("rfKid")
	if not ownRank or not mRank then
		return
	end
	local ret = clone(self.memberMenu[ownRank][mRank])
	if rfKid and 0 < rfKid then
		if mRank == gAllianceRank.R5 then
			table.removebyvalue(ret.left, gAPermission.REPLACE_LEADER)
		end
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
	elseif mRfKid and 0 < mRfKid then
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
		table.removebyvalue(ret.left, gAPermission.DEMISE)
	end
	dump(ret, "ret")
	return ret
end
;(function(self, mRank, mRfKid)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local rfKid = ownmember:getProperty("rfKid")
	if not ownRank or not mRank then
		return
	end
	local ret = clone(self.memberMenu[ownRank][mRank])
	if rfKid and 0 < rfKid then
		if mRank == gAllianceRank.R5 then
			table.removebyvalue(ret.left, gAPermission.REPLACE_LEADER)
		end
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
	elseif mRfKid and 0 < mRfKid then
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
		table.removebyvalue(ret.left, gAPermission.DEMISE)
	end
	dump(ret, "ret")
	return ret
end)[1] = gAPermission.RECRUIT
;(function(self, mRank, mRfKid)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local rfKid = ownmember:getProperty("rfKid")
	if not ownRank or not mRank then
		return
	end
	local ret = clone(self.memberMenu[ownRank][mRank])
	if rfKid and 0 < rfKid then
		if mRank == gAllianceRank.R5 then
			table.removebyvalue(ret.left, gAPermission.REPLACE_LEADER)
		end
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
	elseif mRfKid and 0 < mRfKid then
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
		table.removebyvalue(ret.left, gAPermission.DEMISE)
	end
	dump(ret, "ret")
	return ret
end)[2] = gAPermission.MAIL_ALL
local (function(self, mRank, mRfKid)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local rfKid = ownmember:getProperty("rfKid")
	if not ownRank or not mRank then
		return
	end
	local ret = clone(self.memberMenu[ownRank][mRank])
	if rfKid and 0 < rfKid then
		if mRank == gAllianceRank.R5 then
			table.removebyvalue(ret.left, gAPermission.REPLACE_LEADER)
		end
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
	elseif mRfKid and 0 < mRfKid then
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
		table.removebyvalue(ret.left, gAPermission.DEMISE)
	end
	dump(ret, "ret")
	return ret
end)[3], newMenuList = gAPermission.REJECT, function(self, mRank, mRfKid)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local rfKid = ownmember:getProperty("rfKid")
	if not ownRank or not mRank then
		return
	end
	local ret = clone(self.memberMenu[ownRank][mRank])
	if rfKid and 0 < rfKid then
		if mRank == gAllianceRank.R5 then
			table.removebyvalue(ret.left, gAPermission.REPLACE_LEADER)
		end
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
	elseif mRfKid and 0 < mRfKid then
		table.removebyvalue(ret.right, gAPermission.HELP_RESOURCE)
		table.removebyvalue(ret.left, gAPermission.DEMISE)
	end
	dump(ret, "ret")
	return ret
end
function permissionCtrl:getNewMemberMenu()
	local _ENV, menu
	if self:checkPermission(gAPermission.RECRUIT) then
		local _ENV, right = self:checkPermission(gAPermission.RECRUIT), self:checkPermission(gAPermission.RECRUIT)
		right[1] = gAPermission.RECRUIT
		right[2] = gAPermission.MAIL_ALL
		right[3] = gAPermission.REJECT
		menu.left, _ENV, menu.right = gAPermission.REJECT, gAPermission.REJECT, right
	end
	return menu
end
function permissionCtrl:hasPlayerPermission(permission, cid)
	assert(permission, "the permission is nil!")
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local cMember = cid and memberMgr:getMember(cid) or memberMgr:getOwnMember()
	local cRank = cMember and cMember:getProperty("rank")
	return self.config:hasPermission(permission, cRank)
end
function permissionCtrl:checkPermission(permission, uRank)
	assert(permission, "the permission is nil!")
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	return self.config:hasPermission(permission, cRank, uRank)
end
function permissionCtrl:initClientData(data)
	self.config:initializeConfig(data)
end
_UPVALUE6_, permissionCtrl.init = function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end, function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end
_UPVALUE4_, (function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end)[1] = gAPermission.EXPEL_MEMBER, gAPermission.EXPEL_MEMBER
_UPVALUE4_, (function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end)[2] = gAPermission.EXPEL_MEMBER, gAPermission.DEMOTE_MEMBER
_UPVALUE4_, (function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end)[3] = gAPermission.EXPEL_MEMBER, gAPermission.ALLIANCE_OFFICIAL_FIRE
_UPVALUE4_, (function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end)[4] = gAPermission.EXPEL_MEMBER, gAPermission.PROMOTE_MEMBER
_UPVALUE4_, (function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end)[5] = gAPermission.EXPEL_MEMBER, gAPermission.DEMISE
local _UPVALUE4_, (function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end)[6], leftMemberMenu = gAPermission.EXPEL_MEMBER, gAPermission.REPLACE_LEADER, function(self)
	self.memberMenu, _ENV = nil, nil
	for k1, v1 in pairs(gAllianceRank) do
		self.memberMenu[v1], _ENV = nil, nil
		for k2, v2 in pairs(gAllianceRank) do
			self.memberMenu[v1][v2] = self:createMemberMenu(v1, v2)
		end
	end
end
gAPermission.EXPEL_MEMBER[1] = gAPermission.HELP_SOLDIERS
gAPermission.EXPEL_MEMBER[2] = gAPermission.HELP_RESOURCE
gAPermission.EXPEL_MEMBER[3] = gAPermission.MAIL_ALL
local gAPermission.EXPEL_MEMBER[4], rightMemberMenu = gAPermission.INVITE_MOVE_CITY, gAPermission.EXPEL_MEMBER
_UPVALUE7_, permissionCtrl.createMemberMenu = function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end, function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end
;(function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[1] = gAManage.VIEW_BANNER
;(function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[2] = gAManage.OTHER_ALLIANCE
;(function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[3] = gAManage.VIEW_ALLIANCE
;(function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[4] = gAManage.DONATE_RANKINGS
;(function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[5] = gAManage.RANK_INFO
;(function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[6] = gAManage.ALLIANCE_RELATION
local (function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end)[7], baseManageMenu = gAManage.QUIT, function(self, ownRank, mRank)
	local _ENV, menu
	local _ENV, left
	for i, v in ipairs(leftMemberMenu) do
		if v == gAPermission.REPLACE_LEADER and mRank == gAllianceRank.R5 then
			table.insert(left, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(left, v)
					end
				end
			end
		end
	end
	local _ENV, right = (for generator), ipairs(leftMemberMenu)
	for i, v in ipairs(rightMemberMenu) do
		if gAPermission.MAIL_ALL == v then
			table.insert(right, v)
		else
			local rlist = alliancePermissionltCtrl:getPermissionRankConfig(v, ownRank)
			if "table" == type(rlist) then
				for rank, list in pairs(rlist) do
					if rank == mRank then
						table.insert(right, v)
					end
				end
			end
		end
	end
	menu.left = left
	menu.right = right
	return menu
end
_UPVALUE3_, permissionCtrl.getManageMenu = function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, manageMenu = member, member
	local rfKid = member:getProperty("rfKid")
	if rfKid and 0 < rfKid then
		baseManageMenu = member
		member[1] = gAManage.QUIT
		return member
	end
	for i, v in ipairs(baseManageMenu) do
		table.insert(manageMenu, v)
	end
	if cRank >= gAllianceRank.R4 then
		if cRank == gAllianceRank.R5 then
			table.insert(manageMenu, 6, gAManage.UNLOCK_MESSAGES)
		end
		table.insert(manageMenu, 1, gAManage.BWLIST)
		table.insert(manageMenu, 1, gAManage.SETTINGS)
		if 1 >= alliance:getMemberCount() and cRank == gAllianceRank.R5 then
			manageMenu[#manageMenu] = gAManage.DISMISS
		end
	end
	return manageMenu
end, function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, manageMenu = member, member
	local rfKid = member:getProperty("rfKid")
	if rfKid and 0 < rfKid then
		baseManageMenu = member
		member[1] = gAManage.QUIT
		return member
	end
	for i, v in ipairs(baseManageMenu) do
		table.insert(manageMenu, v)
	end
	if cRank >= gAllianceRank.R4 then
		if cRank == gAllianceRank.R5 then
			table.insert(manageMenu, 6, gAManage.UNLOCK_MESSAGES)
		end
		table.insert(manageMenu, 1, gAManage.BWLIST)
		table.insert(manageMenu, 1, gAManage.SETTINGS)
		if 1 >= alliance:getMemberCount() and cRank == gAllianceRank.R5 then
			manageMenu[#manageMenu] = gAManage.DISMISS
		end
	end
	return manageMenu
end
;(function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, manageMenu = member, member
	local rfKid = member:getProperty("rfKid")
	if rfKid and 0 < rfKid then
		baseManageMenu = member
		member[1] = gAManage.QUIT
		return member
	end
	for i, v in ipairs(baseManageMenu) do
		table.insert(manageMenu, v)
	end
	if cRank >= gAllianceRank.R4 then
		if cRank == gAllianceRank.R5 then
			table.insert(manageMenu, 6, gAManage.UNLOCK_MESSAGES)
		end
		table.insert(manageMenu, 1, gAManage.BWLIST)
		table.insert(manageMenu, 1, gAManage.SETTINGS)
		if 1 >= alliance:getMemberCount() and cRank == gAllianceRank.R5 then
			manageMenu[#manageMenu] = gAManage.DISMISS
		end
	end
	return manageMenu
end)[1] = gaSettings.SLOGAN
;(function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, manageMenu = member, member
	local rfKid = member:getProperty("rfKid")
	if rfKid and 0 < rfKid then
		baseManageMenu = member
		member[1] = gAManage.QUIT
		return member
	end
	for i, v in ipairs(baseManageMenu) do
		table.insert(manageMenu, v)
	end
	if cRank >= gAllianceRank.R4 then
		if cRank == gAllianceRank.R5 then
			table.insert(manageMenu, 6, gAManage.UNLOCK_MESSAGES)
		end
		table.insert(manageMenu, 1, gAManage.BWLIST)
		table.insert(manageMenu, 1, gAManage.SETTINGS)
		if 1 >= alliance:getMemberCount() and cRank == gAllianceRank.R5 then
			manageMenu[#manageMenu] = gAManage.DISMISS
		end
	end
	return manageMenu
end)[2] = gaSettings.RECRUITMENT
local (function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, manageMenu = member, member
	local rfKid = member:getProperty("rfKid")
	if rfKid and 0 < rfKid then
		baseManageMenu = member
		member[1] = gAManage.QUIT
		return member
	end
	for i, v in ipairs(baseManageMenu) do
		table.insert(manageMenu, v)
	end
	if cRank >= gAllianceRank.R4 then
		if cRank == gAllianceRank.R5 then
			table.insert(manageMenu, 6, gAManage.UNLOCK_MESSAGES)
		end
		table.insert(manageMenu, 1, gAManage.BWLIST)
		table.insert(manageMenu, 1, gAManage.SETTINGS)
		if 1 >= alliance:getMemberCount() and cRank == gAllianceRank.R5 then
			manageMenu[#manageMenu] = gAManage.DISMISS
		end
	end
	return manageMenu
end)[3], baseSettingsMenu = gaSettings.LANGUAGE, function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, manageMenu = member, member
	local rfKid = member:getProperty("rfKid")
	if rfKid and 0 < rfKid then
		baseManageMenu = member
		member[1] = gAManage.QUIT
		return member
	end
	for i, v in ipairs(baseManageMenu) do
		table.insert(manageMenu, v)
	end
	if cRank >= gAllianceRank.R4 then
		if cRank == gAllianceRank.R5 then
			table.insert(manageMenu, 6, gAManage.UNLOCK_MESSAGES)
		end
		table.insert(manageMenu, 1, gAManage.BWLIST)
		table.insert(manageMenu, 1, gAManage.SETTINGS)
		if 1 >= alliance:getMemberCount() and cRank == gAllianceRank.R5 then
			manageMenu[#manageMenu] = gAManage.DISMISS
		end
	end
	return manageMenu
end
function permissionCtrl:getSettingsMenu()
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local member = memberMgr:getOwnMember()
	local cRank = member:getProperty("rank")
	local _ENV, settingsMenu = member, member
	for i, v in ipairs(baseSettingsMenu) do
		table.insert(settingsMenu, v)
	end
	if cRank >= gAllianceRank.R5 then
		table.insert(settingsMenu, 3, gaSettings.NICKNAME)
		table.insert(settingsMenu, 3, gaSettings.NAME)
		table.insert(settingsMenu, gaSettings.RANK)
	end
	table.insert(settingsMenu, gaSettings.COLOR)
	return settingsMenu
end
function permissionCtrl:getLanguageMenu()
	local _ENV, languageMenu
	local gameName = SoraDGetGameName()
	if gameName == "ROS" or gameName == "ROS_IRAN" or gameName == "ROS_KO" then
		_UPVALUE19_ = nil
		languageMenu, (nil)[1] = nil, gLanguage.ALL
		languageMenu, (nil)[2] = nil, gLanguage.ZH_CN
		languageMenu, (nil)[3] = nil, gLanguage.EN
		languageMenu, (nil)[4] = nil, gLanguage.ARAB
		languageMenu, (nil)[5] = nil, gLanguage.DE
		languageMenu, (nil)[6] = nil, gLanguage.FA
		languageMenu, (nil)[7] = nil, gLanguage.ES
		languageMenu, (nil)[8] = nil, gLanguage.FR
		languageMenu, (nil)[9] = nil, gLanguage.RU
		languageMenu, (nil)[10] = nil, gLanguage.IT
		languageMenu, (nil)[11] = nil, gLanguage.PT
		languageMenu, (nil)[12] = nil, gLanguage.TR
		languageMenu, (nil)[13] = nil, gLanguage.PL
		languageMenu, (nil)[14] = nil, gLanguage.RO
		languageMenu, (nil)[15] = nil, gLanguage.JA
		languageMenu, (nil)[16] = nil, gLanguage.ID
		languageMenu, (nil)[17] = nil, gLanguage.VI
		languageMenu, (nil)[18] = nil, gLanguage.NL
		languageMenu, (nil)[19] = nil, gLanguage.FI
		languageMenu, (nil)[20] = nil, gLanguage.SV
		languageMenu, (nil)[21] = nil, gLanguage.ZH_TW
		languageMenu, (nil)[22] = nil, gLanguage.KO
	else
		_UPVALUE3_ = nil
		languageMenu, (nil)[1] = nil, gLanguage.ALL
		languageMenu, (nil)[2] = nil, gLanguage.EN
		languageMenu, (nil)[3] = nil, gLanguage.ARAB
	end
	return languageMenu
end
function RSP:modifyPermissionRsp(content)
	if gErrDef.Err_None ~= content.err then
		return
	end
end
return permissionCtrl
