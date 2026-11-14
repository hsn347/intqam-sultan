local KWKingdomCell = class("KWKingdomCell")
local gametop = gModuleMgr.getObject("gametop")
function KWKingdomCell:changeKingdomName(newName)
	print("KWKingdomCell:changeKingdomName(newName)", newName)
	self.data.kingdomName = newName
	self.data.canChangeName = false
	return gErrDef.Err_None
end
function KWKingdomCell:changeKingdomFlag(newFlag)
	print("KWKingdomCell:changeKingdomFlag(newName)", newFlag)
	self.data.kingdomFlag = newFlag
	self.data.canChangeFlag = false
	return gErrDef.Err_None
end
function KWKingdomCell:changeKingdomPlace(newPlace)
	print("KWKingdomCell:changeKingdomPlace(newPlace)", newPlace)
	self.data.kingdomPlace = newPlace
	self.data.canChangePlace = false
	return gErrDef.Err_None
end
function KWKingdomCell:canChangeKingdomName()
	return self.data.canChangeName
end
function KWKingdomCell:canChangeKingdomFlag()
	return self.data.canChangeFlag
end
function KWKingdomCell:canChangeKingdomPlace()
	return self.data.canChangePlace
end
function KWKingdomCell:getKingdomName()
	local gametop = gModuleMgr.getObject("gametop")
	local kindomId = gametop.playertop_:getKingdomID() or 0
	return serviceFunctions.getKingdomFormatName(self.data.kingdomName or self.kingdomInfo.kingdomName, kindomId)
end
function KWKingdomCell:getKingdomFlag()
	return self.data.kingdomFlag or self.kingdomInfo.kingdomFlag
end
function KWKingdomCell:getKingdomPlace()
	return self.data.kingdomPlace or self.kingdomInfo.placeModel
end
function KWKingdomCell:setKingInfo(kingInfo)
	self.kingInfo = kingInfo
end
function KWKingdomCell:getKingInfo()
	return self.kingInfo
end
function KWKingdomCell:setKingdomInfo(kingdomInfo)
	self.kingdomInfo = kingdomInfo
end
function KWKingdomCell:getKingdomInfo()
	return self.kingdomInfo
end
local instance
function KWKingdomCell.sharedInstance()
	return instance
end
function KWKingdomCell:getDefaultData()
	_UPVALUE0_ = nil
	;(nil).kindUid = 0
	;(nil).kingAid = 0
	;(nil).kingdomName = nil
	;(nil).kingdomFlag = nil
	;(nil).kingdomPlace = nil
	;(nil).kingdomTitle = 0
	;(nil).atlantisTitle = nil
	;(nil).canChangeName = false
	;(nil).canChangeFlag = false
	;(nil).canChangePlace = false
	;(nil).oldKindUid = 0
	;(nil).oldKingAid = 0
	;(nil).oldKingdomName = ""
	;(nil).oldKingdomFlag = 0
	;(nil).oldKingdomPlace = 0
	return nil
end
function KWKingdomCell:ctor()
	self.kingdomInfo, _UPVALUE0_, self.kingInfo, _UPVALUE0_, self.data = self:getDefaultData(), self:getDefaultData(), self:getDefaultData(), self:getDefaultData(), self:getDefaultData()
end
function KWKingdomCell:checkKingdomName(kingdomName)
	local err = gErrDef.Err_None
	local name = self:strtrim(kingdomName)
	if name then
		local nameSize = string.utf8len(name)
		if 10 < nameSize then
			err = gErrDef.Err_KW_NAME_MAX_SIZE
		elseif nameSize < 1 then
			err = gErrDef.Err_KW_NAME_MIN_SIZE
		elseif string.sub(name, 1, 1) == "(" then
			err = gErrDef.Err_KW_NAME_BRACKET
		elseif string.match(name, "[%%%*%^%$%[%]%*%+%-%?#&]+") then
			err = gErrDef.Err_KW_NAME_IIIEGAL_CHARACTER
		elseif gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(name) then
			err = gErrDef.Err_KW_NAME_IIIEGAL_CHARACTER
		elseif gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedEmoji(name) then
			err = gErrDef.Err_KW_NAME_IIIEGAL_CHARACTER
		end
	else
		err = gErrDef.Err_NICKNAME_MIN_SIZE
	end
	return err
end
function KWKingdomCell:strtrim(str)
	return string.match(str, "%s*(.-)%s*$")
end
function KWKingdomCell:checkKingdomFlag(kingdomFlag)
	return true
end
function KWKingdomCell:checkKingdomPlace(kingdomPlace)
	return true
end
function KWKingdomCell:cancelKing()
	self.data = self:getDefaultData()
end
function KWKingdomCell:becomeKing(data)
	self.data = data
end
function KWKingdomCell:setAtlantisTitle(title)
	self.data.atlantisTitle = title
end
function KWKingdomCell:getAtlantisTitle()
	return self.data.atlantisTitle
end
return KWKingdomCell
