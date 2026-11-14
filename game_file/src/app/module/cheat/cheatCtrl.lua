local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local cheatCtrl = class("cheatCtrl", gamemodulec)
function cheatCtrl:ctor(properties)
	cheatCtrl.super.ctor(self, properties)
end
function cheatCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CHEAT_MODULE, gCmd.REQ_CHEAT, handler(self, self.cheatRsp))
	msgCtrl.register(gCmd.CMD_CHEAT_MODULE, gCmd.REQ_GAME_ITEM, handler(self, self.addGameItemRsp))
	msgCtrl.register(gCmd.CMD_CHEAT_MODULE, gCmd.REQ_DEL_GAME_ITEM, handler(self, self.addGameItemRsp))
	msgCtrl.register(gCmd.CMD_MNZD_MODULE, gCmd.REQ_MNZD_BEGIN, handler(self, self.mnzdBeginRsp))
end
function cheatCtrl:resetData()
end
function cheatCtrl:reqCheat(cheatType, param)
	serverproxy = nil
	;(nil).cheatType = cheatType
	local (nil).param, data = param, nil
	serverproxy:Request(gCmd.CMD_CHEAT_MODULE, gCmd.REQ_CHEAT, data)
end
function cheatCtrl:reqAddGameItem(data, ...)
	_ENV = nil
	local _ENV, dataAdd, dataDel
	for _, item in ipairs(data) do
		if item.count < 0 then
			local _item = clone(item)
			_item.count = -item.count
			table.insert(dataDel, _item)
		else
			table.insert(dataAdd, item)
		end
	end
	if 0 < #dataAdd then
		serverproxy:Request(gCmd.CMD_CHEAT_MODULE, gCmd.REQ_GAME_ITEM, dataAdd, ...)
	end
	if 0 < #dataDel then
		dump(dataDel, "dataDel=====")
		serverproxy:Request(gCmd.CMD_CHEAT_MODULE, gCmd.REQ_DEL_GAME_ITEM, dataDel, ...)
	end
end
function cheatCtrl:reqMnzdBegin(data)
	serverproxy:Request(gCmd.CMD_MNZD_MODULE, gCmd.REQ_MNZD_BEGIN, data)
end
function cheatCtrl:cheatRsp(content)
	dump(content, "cheatCtrl:cheatRsp", 10)
	local data = content.data
	local err = content.err
	if err ~= gErrDef.Err_None then
	else
		if data.cheatType == "CLEAR_EQUIPMENT" then
			local equipmentCtrl = gametop.playertop_:getModule("equipmentCtrl")
			equipmentCtrl:clean()
		end
		if content.rspdata and content.rspdata.show then
			_ENV = equipmentCtrl
			equipmentCtrl.align = cc.TEXT_ALIGNMENT_LEFT
			SoraDShowHelpMsgTip(content.rspdata.show, equipmentCtrl)
			return
		end
		_ENV = content.rspdata.show
		content.rspdata.show.msg = "MESSAGE_CHEAT_ADDITEM_SUCCESS"
		SoraDSendMessage(content.rspdata.show)
	end
end
function cheatCtrl:addGameItemRsp(content)
	dump(content, "cheatCtrl:addGameItemRsp", 10)
	local data = content.data
	local err = content.err
	if err ~= gErrDef.Err_None then
	else
		_ENV = 10
		;(10).msg = "MESSAGE_CHEAT_ADDITEM_SUCCESS"
		SoraDSendMessage(10)
	end
end
function cheatCtrl:mnzdBeginRsp(content)
	dump(content.rspdata, "cheatCtrl:mnzdBeginRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip("模拟战斗完成")
		local mailId = content.rspdata.mailId
		if mailId then
			_ENV = "cheatCtrl:mnzdBeginRsp"
			;("cheatCtrl:mnzdBeginRsp").msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_MAIL"
			;("cheatCtrl:mnzdBeginRsp").mailId = mailId
			SoraDSendMessage("cheatCtrl:mnzdBeginRsp")
		end
	end
end
return cheatCtrl
