local GameModule = include("GameModule")
local christmasTreeCtrl = class("christmasTreeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function christmasTreeCtrl:ctor(properties)
	christmasTreeCtrl.super.ctor(self, properties)
end
function christmasTreeCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_MAKE_TREE, handler(self, self.reqMaingTreesRsp))
	msgCtrl.register(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_RECOVERY_GARNISH, handler(self, self.reqCycleDecorationsRsp))
	msgCtrl.register(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_COMPOUND_TREE, handler(self, self.reqCompoundTreeRsp))
	msgCtrl.register(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_GET_LIST, handler(self, self.reqAllianceListRsp))
	msgCtrl.register(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_SHARE, handler(self, self.reqTreeShareRsp))
	self:resetData()
end
function christmasTreeCtrl:initClientData(data)
	if not data then
		return
	end
	self.treeData = data
	self:registerNotify()
end
function christmasTreeCtrl:resetData()
	self.handle_notify = nil
	self.treeData = nil
end
function christmasTreeCtrl:Logout()
	self:resetData()
	christmasTreeCtrl.super.Logout(self)
end
function christmasTreeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CHRISTMAS_TREE, handler(self, self.notifyHandler))
end
function christmasTreeCtrl:notifyHandler(event)
	dump(event.data, "christmasTreeCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			self.treeData.rewardTree = content.rewardTree
			self.treeData.material = content.material
			_ENV = content.material
			content.material.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_GET_REWARD"
			SoraDSendMessage(content.material)
			_ENV = content.material
			content.material.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_DECORATION_DEPOSE_REFRESH"
			SoraDSendMessage(content.material)
		end
	end
end
function christmasTreeCtrl:sendMakingTreesMsg(nType, nNum)
	serverproxy = nil
	;(nil).nType = nType
	local (nil).nNum, data = nNum, nil
	serverproxy:Request(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_MAKE_TREE, data)
end
function christmasTreeCtrl:sendcycleDecorationsMsg(idItem, nNum)
	serverproxy = nil
	;(nil).idItem = idItem
	local (nil).nNum, data = nNum, nil
	serverproxy:Request(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_RECOVERY_GARNISH, data)
end
function christmasTreeCtrl:sendCompoundTreeMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_COMPOUND_TREE, data)
end
function christmasTreeCtrl:sendAllianceListMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_GET_LIST, data)
end
function christmasTreeCtrl:sendTreeShareMsg(shareType, treeId)
	serverproxy = nil
	;(nil).inviteShareType = shareType
	local (nil).treeId, data = treeId, nil
	serverproxy:Request(gCmd.CMD_CHRISTMAS_TREE_MODULE, gCmd.REQ_CHRISTMAS_TREE_SHARE, data)
end
function christmasTreeCtrl:reqMaingTreesRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		SoraDPopGainItem(ret.data.treeId, ret.data.nNum)
		_ENV = ret.data.treeId
		ret.data.treeId.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_MAKING_REFRESH"
		SoraDSendMessage(ret.data.treeId)
	end
end
function christmasTreeCtrl:reqCycleDecorationsRsp(ret)
	dump(ret, "christmasTreeCtrl:reqCycleDecorationsRsp", 10)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.treeData.material = ret.data.material
		_ENV = ret.data.material
		ret.data.material.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_DECORATION_DEPOSE_REFRESH"
		SoraDSendMessage(ret.data.material)
	end
end
function christmasTreeCtrl:reqCompoundTreeRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.treeData.material = ret.data.material
		_ENV = ret.data.material
		ret.data.material.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_COMPOUND_REFRESH"
		ret.data.material.rewardInfo = ret.data.rewardinfo[1]
		SoraDSendMessage(ret.data.material)
	end
end
function christmasTreeCtrl:reqAllianceListRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		local _ENV, list = ret.err, ret.err
		local _ENV, listFalse = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(ret.data.list) do
			if v.leftCount > 0 then
				if v.isColl == false then
					table.insert(list, v)
				else
					table.insert(listFalse, v)
				end
			end
		end
		table.sort(list, function(a, b)
			if a.level == b.level then
				return a.createTime > b.createTime
			else
				return a.level > b.level
			end
		end)
		table.sort(listFalse, function(a, b)
			if a.level == b.level then
				return a.createTime > b.createTime
			else
				return a.level > b.level
			end
		end)
		for i, v in ipairs(listFalse) do
			table.insert(list, v)
		end
		_ENV = ipairs(listFalse)
		ipairs(listFalse).msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_LIST_BACK"
		ipairs(listFalse).list = list
		SoraDSendMessage(ipairs(listFalse))
	end
end
function christmasTreeCtrl:reqTreeShareRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	end
end
function christmasTreeCtrl:getChristmasTreeData()
	return self.treeData
end
return christmasTreeCtrl
