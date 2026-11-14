local customModelBase = include("customModelBase")
local mail = class("mail", customModelBase)
_ENV = "mail"
;("mail").mid = 0
;("mail").sender = 0
;("mail").receiver = 0
;("mail").mailType = 0
;("mail").extra, _ENV, ("mail").brief, _ENV, ("mail").data, _ENV, ("mail").source = customModelBase, customModelBase, customModelBase, customModelBase, customModelBase, customModelBase, 0
;("mail").time = ""
;("mail").isView = gStatus.NO
;("mail").isGetExtra = gStatus.NO
;("mail").isVMsgView = gStatus.NO
;("mail").kid = 0
;("mail").mailSetType = 0
local ("mail").battleMailType, property = 0, "mail"
function mail:ctor(properties)
	mail.super.ctor(self, property)
	properties.mailSetType = properties.mailSetType or gMailSetTypeFunc.getMailSetType(properties.mailType)
	self:setProperties(properties)
end
function mail:view()
	self.property.isView = gStatus.YES
end
function mail:isView()
	return self.property.isView == gStatus.YES
end
function mail:viewVoiceMsg()
	self.property.isVMsgView = gStatus.YES
end
function mail:isVoiceMsgView()
	return self.property.isVMsgView == gStatus.YES
end
function mail:getExtra()
	self.property.isGetExtra = gStatus.YES
end
function mail:setMailSetType(mailSetType)
	self.property.mailSetType = mailSetType
end
function mail:hasExtra()
	if self.property.extra and next(self.property.extra) then
		return true
	end
end
function mail:isGetExtra()
	if self:hasExtra() then
		return self.property.isGetExtra == gStatus.YES
	end
end
function mail:getKeyOfMailList()
	if self.property.mailSetType == gMailSetType.NEW_BATTLE then
		return "battle" .. self.property.battleMailType
	else
		return "key"
	end
end
function mail:getKingdomID()
	local contentData
	if self.property.brief ~= nil and next(self.property.brief) ~= nil then
		contentData = self.property.brief
	else
		contentData = self.property.data
	end
	if contentData then
		local coordinate = contentData.targetCoordinate
		if coordinate ~= nil and coordinate.kid and coordinate.kid ~= 0 then
			return coordinate.kid
		end
	end
	if self.property.kid ~= nil and self.property.kid ~= 0 then
		return self.property.kid
	else
		return nil
	end
end
function mail:isMailReport()
	if self:getProperty("data").mailReportType and self:getProperty("data").mailReportType > 0 then
		return true
	end
end
function mail:setShowTransLate(isShow)
	self.isShowTranslate = isShow
end
function mail:getShowTransLate()
	return self.isShowTranslate
end
return mail
