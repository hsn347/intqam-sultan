local GameModule = include("GameModule")
local cityHorseCtrl = class("cityHorseCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function cityHorseCtrl:ctor(properties)
	cityHorseCtrl.super.ctor(self, properties)
end
function cityHorseCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HORSE_FLAG_MODULE, gCmd.REQ_HORSE_FLAG_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HORSE_FLAG_MODULE, gCmd.REQ_HORSE_FLAG_CLICK, handler(self, self.reqClickRsp))
	msgCtrl.register(gCmd.CMD_HORSE_FLAG_MODULE, gCmd.REQ_HORSE_FLAG_RECEIVE, handler(self, self.reqReceiveRsp))
	self:resetData()
	self:registerNotify()
end
function cityHorseCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).canClick = true
	self.initData, (nil).canReceive = nil, false
end
function cityHorseCtrl:Logout()
	self:resetData()
	cityHorseCtrl.super.Logout(self)
end
function cityHorseCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOTIFY_HORSE_FLAG, handler(self, self.notifyHandler))
end
function cityHorseCtrl:notifyHandler(event)
	for _, content in ipairs(event.data) do
		if content.initData then
			self.initData = content.initData
		end
	end
end
function cityHorseCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HORSE_FLAG_MODULE, gCmd.REQ_HORSE_FLAG_INIT, nil)
end
function cityHorseCtrl:sendClick()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HORSE_FLAG_MODULE, gCmd.REQ_HORSE_FLAG_CLICK, nil)
end
function cityHorseCtrl:sendReceive(area)
	serverproxy = nil
	;(nil).area = area
	serverproxy:Request(gCmd.CMD_HORSE_FLAG_MODULE, gCmd.REQ_HORSE_FLAG_RECEIVE, nil)
end
function cityHorseCtrl:reqInitRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.initData = ret.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MAINCITYVIEW_HORSE_FLAG_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function cityHorseCtrl:reqClickRsp(ret)
	dump(ret, "cityHorseCtrl:reqClickRsp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		if not ret.rspdata.initData then
			_ENV = ret.rspdata.initData
		end
		self.initData = ret.rspdata.initData
		if self:isCanReceive() then
			SoraDShowMsgTip(i18n("guide_text_157"))
		end
		_ENV = i18n("guide_text_157")
		i18n("guide_text_157").msg = "MESSAGE_MAINCITYVIEW_HORSE_FLAG_UPDATE"
		SoraDSendMessage(i18n("guide_text_157"))
	end
end
function cityHorseCtrl:reqReceiveRsp(ret)
	dump(ret, "cityHorseCtrl:reqReceiveRsp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.initData = ret.rspdata.initData
		local reward = ret.rspdata.reward
		_ENV = "cityHorseCtrl:reqReceiveRsp"
		;("cityHorseCtrl:reqReceiveRsp").msg = "MESSAGE_MAINCITYVIEW_HORSE_FLAG_UPDATE"
		SoraDSendMessage("cityHorseCtrl:reqReceiveRsp")
		if ret.rspdata.bLuckArea then
			local panel = SoraDCreatePanel("cityHorseFlagLucky")
			panel:setReward(reward)
			panel:show()
		else
			_ENV = panel
			panel.isArray = true
			SoraDOpenGiftView(reward, panel)
		end
	end
end
function cityHorseCtrl:isCanClick()
	return self.initData.canClick
end
function cityHorseCtrl:isCanReceive()
	return self.initData.canReceive
end
return cityHorseCtrl
