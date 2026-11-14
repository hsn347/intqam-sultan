local mailSet = include("mailSet")
local mailMgr = class("mailMgr")
function mailMgr:ctor()
	self:clean()
end
function mailMgr:initNumInfo(numInfo)
	for mailSetType, mailSet in pairs(self.mailSetList) do
		mailSet:init(numInfo[mailSetType])
	end
end
function mailMgr:clean()
	self.mailList, _ENV = nil, nil
	self.mailSetList, _ENV, self.detaiView = nil, nil, nil
	for _, mailSetType in pairs(gMailSetType) do
		self.mailSetList[mailSetType] = mailSet.new(mailSetType)
	end
end
function mailMgr:addMail(properties, isNewMail)
	local mail = include("mail").new(properties)
	local mid = mail:getProperty("mid")
	local contentType = mail:getProperty("data").contentType
	if contentType and gMailSetTypeFunc.isShieldMail(contentType) then
		return
	end
	if not self.mailList[mid] then
		self.mailList[mid] = mail
		local mailset = self.mailSetList[mail:getProperty("mailSetType")]
		local key = mail:getKeyOfMailList()
		print("mailMgr:addMail", key, mail:getProperty("mailSetType"))
		mailset:addMail(mid, "key", isNewMail, not mail:isView())
		if key ~= "key" then
			mailset:addMail(mid, key, isNewMail, not mail:isView())
		end
		return mail
	end
end
function mailMgr:removeMail(mid)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	if mail:hasExtra() and not mail:isGetExtra() then
		return gErrDef.Err_MAIL_NOT_GET_EXTRA
	end
	local mailset = self.mailSetList[mail:getProperty("mailSetType")]
	local key = mail:getKeyOfMailList()
	mailset:removeMail(mid, "key")
	if key ~= "key" then
		mailset:removeMail(mid, key)
	end
	return gErrDef.Err_None
end
function mailMgr:removeMailList(mailSetType, key)
	if tolua.type(mailSetType) == "table" then
		for _, setType in pairs(mailSetType) do
			self.mailSetList[setType]:clean()
		end
	else
		local node = self:getFontMailNode(mailSetType, key)
		while node do
			local mid = node.mid
			node = node.next
			self:removeMail(mid)
		end
	end
end
function mailMgr:autoRemoveMail(v, mailSetType)
	local mid = v.mid
	print("mailMgr:autoRemoveMail", mid)
	local mail = self.mailList[mid]
	local mailset = self.mailSetList[mailSetType]
	if not mail then
		mailset:subNum(v.key)
		if not v.isView then
			mailset:subNumOfNew(v.key)
		end
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	local key = mail:getKeyOfMailList()
	mailset:removeMail(mid, "key")
	if key ~= "key" then
		mailset:removeMail(mid, key)
	end
	return gErrDef.Err_None
end
function mailMgr:getMailList(mid, num, mailSetType, key)
	if tolua.type(mailSetType) == "table" then
		local _ENV, ret = tolua.type(mailSetType), tolua.type(mailSetType)
		for _, setType in pairs(mailSetType) do
			local node = self:getFontMailNode(setType)
			print("initMailDataRsp", setType, node)
			if node and node.mid then
				_ENV = setType
				setType.mid = node.mid
				table.insert(ret, setType)
			end
		end
		if #ret <= 0 then
			return gErrDef.Err_HAS_NOT_MORE_MAIL, ret
		end
		table.sort(ret, function(l, r)
			return l.mid > r.mid
		end)
		return gErrDef.Err_None, ret
	else
		local mail
		local mailSet = self.mailSetList[mailSetType]
		if mid then
			mail = self.mailList[mid]
			if not mail then
				function _ENV(l, r)
					return l.mid > r.mid
				end
				return gErrDef.Err_NOT_FOUND_MAIL, function(l, r)
					return l.mid > r.mid
				end
			end
		end
		local err, ret = mailSet:getMailList(mid, num, key)
		return err, ret
	end
end
function mailMgr:getNewMailNum(mailSetType, key)
	if tolua.type(mailSetType) == "table" then
		local totalNum = 0
		for _, setType in ipairs(mailSetType) do
			local num = self:getNewMailNum(setType)
			totalNum = totalNum + num
		end
		return totalNum
	else
		if mailSetType then
			return self.mailSetList[mailSetType]:newNum(key)
		end
		local num = 0
		for k, v in pairs(self.mailSetList) do
			if gMailSetTypeFunc.isEffective(k) then
				num = num + v:newNum(key)
			end
		end
		return num
	end
end
function mailMgr:getMailSetNumInfo(mailSetType, key)
	local _ENV, ret
	if tolua.type(mailSetType) == "table" then
		local totalNum = 0
		local totalLimitNum = 0
		for _, setType in ipairs(mailSetType) do
			local num, limitNum = self:getMailSetNumInfo(setType)
			totalNum = totalNum + num
			totalLimitNum = totalLimitNum + limitNum
		end
		return totalNum, totalLimitNum
	else
		local mailSet = self.mailSetList[mailSetType]
		return mailSet:num(key), gMailSetTypeFunc.getSetLimitNum(mailSetType)
	end
end
function mailMgr:queryMail(mid)
	if self.mailList[mid] then
		return self.mailList[mid]
	end
end
function mailMgr:getMailProperty(mid, key)
	local mail = self:queryMail(mid)
	if mail and key then
		return mail:getProperty(key)
	end
end
function mailMgr:getFontMailNode(mailSetType, key)
	local mailset = self.mailSetList[mailSetType]
	return mailset and mailset:getFontMailNode(key)
end
function mailMgr:viewMail(mid)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	if mail:isView() then
		return gErrDef.Err_MAIL_ALREADY_VIEW
	end
	mail:view()
	local mailset = self.mailSetList[mail:getProperty("mailSetType")]
	local key = mail:getKeyOfMailList()
	mailset:subNumOfNew("key", 1)
	if key ~= "key" then
		mailset:subNumOfNew(key, 1)
	end
	return gErrDef.Err_None
end
function mailMgr:viewAllMail(mailSetType, viewKey)
	if tolua.type(mailSetType) == "table" then
		local err
		for _, setType in pairs(mailSetType) do
			if self:viewAllMail(setType, viewKey) == gErrDef.Err_None then
				err = gErrDef.Err_None
			end
		end
		return err
	else
		local mailset = self.mailSetList[mailSetType]
		local newNum = mailset:newNum(viewKey)
		local node = self:getFontMailNode(mailSetType, viewKey)
		local mail
		if not node or not node.mid then
			return
		end
		local mail = self.mailList[node.mid]
		local myKey = mail:getKeyOfMailList()
		while node do
			local mail = self.mailList[node.mid]
			if mail then
				mail:view()
				mail:getExtra()
			end
			node = node.next
		end
		if myKey == "key" then
			mailset:setNumOfNewMail(myKey, 0)
		else
			mailset:setNumOfNewMail(myKey, 0)
			if viewKey == "key" then
				mailset:setNumOfNewMail(viewKey, 0)
			else
				mailset:subNumOfNew("key", newNum)
			end
		end
		return gErrDef.Err_None
	end
end
function mailMgr:collectMail(mid)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	local mailSetType = mail:getProperty("mailSetType")
	if mailSetType ~= gMailSetType.COLLECT then
		local mailset = self.mailSetList[mailSetType]
		local key = mail:getKeyOfMailList()
		mailset:removeMail(mid, "key")
		if key ~= "key" then
			mailset:removeMail(mid, key)
		end
		local mailNewSet = self.mailSetList[gMailSetType.COLLECT]
		mailNewSet:addMail(mid, "key", true)
		mail:setMailSetType(gMailSetType.COLLECT)
	end
end
function mailMgr:viewVoiceMsg(mid)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	if mail:isVoiceMsgView() then
		return gErrDef.Err_MAIL_ALREADY_VIEW
	end
	mail:viewVoiceMsg()
	return gErrDef.Err_None
end
function mailMgr:hasMoreMail(mid, mailSetType, key)
	local mailset = self.mailSetList[mailSetType]
	return mailset:hasMoreMail(mid, key)
end
function mailMgr:isMailFull(mailSetType)
	if include("mailLogic").needNoticeMailNumPer(mailSetType) then
		local mailSet = self.mailSetList[mailSetType]
		local per = mailSet:getMailNumPer()
		if per >= MAIL_WARMING_MAX_COUNT then
			return true
		end
	end
end
function mailMgr:resetNumInfo(mailSetType, numInfo)
	local mailset = self.mailSetList[mailSetType]
	return mailset:resetNumInfo(numInfo)
end
function mailMgr:isLastLoadMid(mid, key)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	local mailSetType = mail:getProperty("mailSetType")
	local mailset = self.mailSetList[mailSetType]
	local nowNode = mailset:getMailNode(mid, key)
	if not nowNode then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	print("isLastLoadMid", mailSetType, key, mid)
	local lastNode = mailset:getLastMailNode(key)
	return lastNode.mid == mid
end
function mailMgr:isFirstLoadMid(mid, key)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	local mailSetType = mail:getProperty("mailSetType")
	local mailset = self.mailSetList[mailSetType]
	local nowNode = mailset:getMailNode(mid, key)
	if not nowNode then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	print("isFirstLoadMid", mailSetType, key, mid)
	local firstNode = mailset:getFontMailNode(key)
	return firstNode.mid == mid
end
function mailMgr:getNextMail(mid, key)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	local mailSetType = mail:getProperty("mailSetType")
	local mailset = self.mailSetList[mailSetType]
	local nowNode = mailset:getMailNode(mid, key)
	return nowNode.next and nowNode.next.mid
end
function mailMgr:getPreMail(mid, key)
	local mail = self.mailList[mid]
	if not mail then
		return gErrDef.Err_MAIL_NOT_FOUND
	end
	local mailSetType = mail:getProperty("mailSetType")
	local mailset = self.mailSetList[mailSetType]
	local nowNode = mailset:getMailNode(mid, key)
	return nowNode.pre and nowNode.pre.mid
end
function mailMgr:setDetailView(view)
	self.detaiView = view
end
function mailMgr:getDetaiView()
	return self.detaiView
end
function mailMgr:getScrollParent()
	if self.detaiView then
		if SoraDGetChildByName(self.detaiView, "Size_scrollView"):isVisible() then
			return SoraDGetChildByName(self.detaiView, "Size_scrollView")
		else
			return SoraDGetChildByName(self.detaiView, "detail_scrollView")
		end
	end
end
function mailMgr:dump()
	print("===========All Mail===========")
	for mailSetType, mailset in pairs(self.mailSetList) do
		mailset:dump()
	end
end
return mailMgr
