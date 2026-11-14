local KWRankCell = class("KWRankCell")
local gametop = gModuleMgr.getObject("gametop")
function KWRankCell:canAppiontOfficial(uid, oType)
	local ret = gErrDef.Err_None
	if oType == gKingOfficialType.king then
		ret = gErrDef.Err_KW_BAN_OPT_KING
	end
	if not self.data.official[tostring(oType)] or self.data.official[tostring(oType)].uid then
		ret = gErrDef.Err_KW_OFFICIAL_ERROR
	end
	if self:getOfficialTypeByUid(uid) then
		ret = gErrDef.Err_KW_HAS_OFFICIAL
	end
	print("KWRankCell:canAppiontOfficial(uid, oType)", uid, oType, ret)
	return ret
end
function KWRankCell:appiontOfficial(uid, oType, iconID, nickName, allianceName, allianceAbbr, avatar)
	print("KWRankCell:appiontOfficial(uid, oType)", uid, oType)
	if not self.data.official[tostring(oType)] then
		self.data.official[tostring(oType)], _ENV = oType, oType
	end
	self.data.official[tostring(oType)].uid = uid
	self.data.official[tostring(oType)].iconID = iconID
	self.data.official[tostring(oType)].avatar = avatar
	self.data.official[tostring(oType)].nickName = nickName
	self.data.official[tostring(oType)].allianceName = allianceName
	self.data.official[tostring(oType)].allianceAbbr = allianceAbbr
	return gErrDef.Err_None
end
function KWRankCell:canDismissOfficial(uid, oType)
	local ret = gErrDef.Err_None
	if oType == gKingOfficialType.king then
		ret = gErrDef.Err_KW_BAN_OPT_KING
	end
	if not (self.data.official[tostring(oType)] and self.data.official[tostring(oType)].uid) or self.data.official[tostring(oType)].uid ~= uid then
		ret = gErrDef.Err_KW_OFFICIAL_ERROR
	end
	print("KWRankCell:canDismissOfficial(uid, oType)", uid, oType, ret)
	return ret
end
function KWRankCell:dismissOfficial(uid, oType)
	print("KWRankCell:dismissOfficial(uid, oType)", uid, oType)
	self.data.official[tostring(oType)], _ENV = oType, oType
	return gErrDef.Err_None
end
function KWRankCell:getRank()
	return self.data.official
end
function KWRankCell:getOfficialTypeByUid(uid)
	for oType, official in pairs(self.data.official) do
		if official.uid and official.uid == uid then
			return oType
		end
	end
end
function KWRankCell:getOfficialUid(type)
	if self.data.official[tostring(type)] then
		return self.data.official[tostring(type)].uid
	end
end
function KWRankCell:getOfficialUser(type)
	if self.data.official[tostring(type)] then
		_ENV = self.data.official[tostring(type)]
		self.data.official[tostring(type)].uid = self.data.official[tostring(type)].uid
		self.data.official[tostring(type)].iconID = self.data.official[tostring(type)].iconID
		self.data.official[tostring(type)].nickName = self.data.official[tostring(type)].nickName
		self.data.official[tostring(type)].allianceName = self.data.official[tostring(type)].allianceName
		self.data.official[tostring(type)].allianceAbbr = self.data.official[tostring(type)].allianceAbbr
		self.data.official[tostring(type)].avatar = self.data.official[tostring(type)].avatar
		return self.data.official[tostring(type)]
	else
		_ENV = self.data.official[tostring(type)]
		return self.data.official[tostring(type)]
	end
end
local instance
function KWRankCell.sharedInstance()
	return instance
end
function KWRankCell:getDefaultData()
	;(nil).official, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	return nil
end
function KWRankCell:ctor()
	self.data = self:getDefaultData()
	self.lastDateTime = 0
end
function KWRankCell:cancelKing()
	self.data = self:getDefaultData()
end
function KWRankCell:becomeKing(data)
	self.data = data
end
return KWRankCell
