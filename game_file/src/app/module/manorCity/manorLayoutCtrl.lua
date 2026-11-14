local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local manorLayoutCtrl = class("manorLayoutCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function manorLayoutCtrl:ctor(properties)
	manorLayoutCtrl.super.ctor(self, properties)
	self:resetData()
end
function manorLayoutCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_SAVE, handler(self, self.reqSaveRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_UPLOAD, handler(self, self.reqUploadRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_DOWNLOAD, handler(self, self.reqDownloadRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_USE, handler(self, self.reqUseRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_LIKE, handler(self, self.reqLikeRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_UNLIKE, handler(self, self.reqUnlikeRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_DELETE, handler(self, self.reqDeleteRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_GET, handler(self, self.reqGetRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_RANDOM, handler(self, self.reqRandomRsp))
end
function manorLayoutCtrl:Logout()
	manorLayoutCtrl.super.Logout(self)
	self:resetData()
end
function manorLayoutCtrl:resetData()
	self.otherLayout, _UPVALUE0_, self.uploadMap, _UPVALUE0_, self.layoutMap, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function manorLayoutCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_INIT, nil)
end
function manorLayoutCtrl:reqInitRsp(content)
	dump(content, "manorLayoutCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		if not rspdata.init.layoutMap then
			_ENV = rspdata.init.layoutMap
		end
		self.layoutMap = rspdata.init.layoutMap
		if not rspdata.upload then
			_ENV = rspdata.upload
		end
		self.uploadMap = rspdata.upload
	end
end
function manorLayoutCtrl:reqSave(idx, map, isUpload, isCopy)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).map = map
	local (nil).isUpload, data = isUpload, nil
	serverproxy = nil
	;(nil).isCopy = isCopy
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_SAVE, data, nil)
end
function manorLayoutCtrl:reqSaveRsp(content)
	dump(content, "manorLayoutCtrl:reqSaveRsp(content)", 10)
	local isUpload = content.data.isUpload
	local isSuccessSave = false
	if content.err == gErrDef.Err_None then
		local isCopy = content.clientData.isCopy
		if isUpload then
			SoraDShowMsgTip(i18n("Socialize_text_26"))
		elseif isCopy then
			SoraDShowMsgTip(i18n("Socialize_text_55"))
		else
			SoraDShowMsgTip(i18n("Socialize_text_59"))
		end
		isSuccessSave = true
	elseif isUpload then
		if content.err == gErrDef.Err_GARDEN_LAYOUT_UPLOAD_NOT_COMPLETE then
			SoraDShowMsgTip(i18n("Socialize_text_24"))
			isSuccessSave = true
		elseif content.err == gErrDef.Err_GARDEN_LAYOUT_UPLOAD_FAILD then
			SoraDShowMsgTip(i18n("Socialize_text_25"))
			isSuccessSave = true
		end
	end
	if isSuccessSave then
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		self.layoutMap = rspdata.initData.layoutMap
		local layoutData = rspdata.layoutData
		if layoutData then
			table.insert(self.uploadMap, layoutData)
		end
		local idx = content.data.idx
		_ENV = layoutData
		layoutData.msg = "MESSAGE_MANOR_LAYOUT_SAVE"
		layoutData.idx = idx
		SoraDSendMessage(layoutData)
	end
end
function manorLayoutCtrl:reqUpload(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_UPLOAD, nil)
end
function manorLayoutCtrl:reqUploadRsp(content)
	dump(content, "manorLayoutCtrl:reqUploadRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local layoutData = content.rspdata
		table.insert(self.uploadMap, layoutData)
		SoraDShowMsgTip(i18n("Socialize_text_26"))
	end
end
function manorLayoutCtrl:reqDownload(idx, uid, iid)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).uid = uid
	;(nil).iid = iid
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_DOWNLOAD, nil)
end
function manorLayoutCtrl:reqDownloadRsp(content)
	dump(content, "manorLayoutCtrl:reqDownloadRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		if not rspdata.layoutMap then
			_ENV = rspdata.layoutMap
		end
		self.layoutMap = rspdata.layoutMap
		SoraDShowMsgTip(i18n("Socialize_text_55"))
	elseif content.err == gErrDef.Err_GARDEN_LAYOUT_NOT_EXIST then
		SoraDShowMsgTip(i18n("Socialize_text_51"))
	end
end
function manorLayoutCtrl:reqUse(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_USE, nil)
end
function manorLayoutCtrl:reqUseRsp(content)
	dump(content, "manorLayoutCtrl:reqUseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		if not rspdata.gardenMap then
			local _ENV, gardenMap = rspdata.gardenMap, rspdata.gardenMap
		end
		local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
		manorCityCtrl:setGardenMapData(gardenMap)
		SoraDShowMsgTip(i18n("Socialize_text_29"))
	elseif content.err == gErrDef.Err_GARDEN_LAYOUT_PARTY_HOLDING then
		SoraDShowMsgTip(i18n("Socialize_text_49"))
	end
end
function manorLayoutCtrl:reqLike(uid, iid)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).iid = iid
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_LIKE, nil)
end
function manorLayoutCtrl:reqLikeRsp(content)
	dump(content, "manorLayoutCtrl:reqLikeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateOtherLayout(content, true)
		SoraDShowMsgTip(i18n("Socialize_text_13"))
		local uid = content.data.uid
		local iid = content.data.iid
		_ENV = i18n("Socialize_text_13")
		i18n("Socialize_text_13").msg = "MESSAGE_MANOR_LAYOUT_LIKE"
		i18n("Socialize_text_13").uid = uid
		i18n("Socialize_text_13").iid = iid
		SoraDSendMessage(i18n("Socialize_text_13"))
	elseif content.err == gErrDef.Err_GARDEN_LAYOUT_NOT_EXIST then
		SoraDShowMsgTip(i18n("Socialize_text_51"))
	end
end
function manorLayoutCtrl:reqUnlike(uid, iid)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).iid = iid
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_UNLIKE, nil)
end
function manorLayoutCtrl:reqUnlikeRsp(content)
	dump(content, "manorLayoutCtrl:reqUnlikeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateOtherLayout(content, false)
		SoraDShowMsgTip(i18n("Socialize_text_14"))
		local uid = content.data.uid
		local iid = content.data.iid
		_ENV = i18n("Socialize_text_14")
		i18n("Socialize_text_14").msg = "MESSAGE_MANOR_LAYOUT_LIKE"
		i18n("Socialize_text_14").uid = uid
		i18n("Socialize_text_14").iid = iid
		SoraDSendMessage(i18n("Socialize_text_14"))
	elseif content.err == gErrDef.Err_GARDEN_LAYOUT_NOT_EXIST then
		SoraDShowMsgTip(i18n("Socialize_text_51"))
	end
end
function manorLayoutCtrl:reqDelete(iid)
	serverproxy = nil
	;(nil).iid = iid
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_DELETE, nil)
end
function manorLayoutCtrl:reqDeleteRsp(content)
	dump(content, "manorLayoutCtrl:reqDeleteRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local iid = content.data.iid
		for i, v in ipairs(self.uploadMap) do
			if v.id == iid then
				table.remove(self.uploadMap, i)
				SoraDShowMsgTip(i18n("Socialize_text_34"))
				break
			end
		end
		_ENV = ipairs(self.uploadMap)
		ipairs(self.uploadMap).msg = "MESSAGE_MANOR_LAYOUT_DELETE"
		SoraDSendMessage(ipairs(self.uploadMap))
	end
end
function manorLayoutCtrl:reqGet(nickName)
	serverproxy = nil
	;(nil).nickName = nickName
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_GET, nil)
end
function manorLayoutCtrl:reqGetRsp(content)
	dump(content, "manorLayoutCtrl:reqGetRsp(content)", 10)
	if not content.rspdata then
		local _ENV, rspdata = content.rspdata, content.rspdata
	end
	if content.err == gErrDef.Err_None and rspdata.list and #rspdata.list > 0 then
		self.otherLayout = rspdata
		local searchName = content.data.nickName
		_ENV = 10
		;(10).msg = "MESSAGE_MANOR_LAYOUT_RANDOM"
		;(10).otherLayout = self.otherLayout
		;(10).searchName = searchName
		SoraDSendMessage(10)
	else
		SoraDShowMsgTip(i18n("Socialize_text_16"))
	end
end
function manorLayoutCtrl:reqRandom()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GARDEN_LAYOUT_MODULE, gCmd.REQ_GARDEN_LAYOUT_RANDOM, nil)
end
function manorLayoutCtrl:reqRandomRsp(content)
	dump(content, "manorLayoutCtrl:reqRandomRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.otherLayout = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MANOR_LAYOUT_RANDOM"
		gErrDef.Err_None.otherLayout = self.otherLayout
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function manorLayoutCtrl:getOtherLayout(iid)
	if not self.otherLayout.list then
		local _ENV, layoutList = self.otherLayout.list, self.otherLayout.list
	end
	for __, v in ipairs(layoutList) do
		if v.id == iid then
			return v
		end
	end
end
function manorLayoutCtrl:updateOtherLayout(content, isLike)
	local iid = content.data.iid
	if not content.rspdata then
		local _ENV, rspdata = content.rspdata, content.rspdata
	end
	local likeCount = rspdata.likeNum or 0
	local layoutData = self:getOtherLayout(iid)
	if layoutData then
		layoutData.likeCount = likeCount
		local selfUid = SoraDGetPlayerID()
		layoutData.likeUserMap[tostring(selfUid)] = isLike and 1 or nil
	end
end
function manorLayoutCtrl:getLayoutMap()
	if not self.layoutMap then
		_UPVALUE0_ = self.layoutMap
	end
	return self.layoutMap
end
function manorLayoutCtrl:getLayoutData(idx)
	local layoutMap = self:getLayoutMap()
	if not layoutMap[tostring(idx)] then
		_ENV = layoutMap[tostring(idx)]
	end
	return layoutMap[tostring(idx)]
end
function manorLayoutCtrl:getUploadMap()
	if not self.uploadMap then
		_UPVALUE0_ = self.uploadMap
	end
	return self.uploadMap
end
function manorLayoutCtrl:checkUploadLayoutLimit()
	local manorCityUtil = include("manorCityUtil")
	local layoutNum = manorCityUtil.getLayoutNumLimit()
	if layoutNum <= #self.uploadMap then
		return true
	end
	return false
end
return manorLayoutCtrl
