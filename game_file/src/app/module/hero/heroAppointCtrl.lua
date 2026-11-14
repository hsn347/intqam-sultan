local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local heroAppointCtrl = class("heroAppointCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function heroAppointCtrl:ctor(properties)
	heroAppointCtrl.super.ctor(self, properties)
end
function heroAppointCtrl:Logout()
	heroAppointCtrl.super.Logout(self)
	self:resetData()
end
function heroAppointCtrl:resetData()
	self.buffMap, _UPVALUE0_, self.defaultData, _UPVALUE0_ = nil, nil, nil, nil
end
function heroAppointCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_APPOINT_MODULE, gCmd.REQ_HERO_APPOINT, handler(self, self.appointRsp))
	msgCtrl.register(gCmd.CMD_HERO_APPOINT_MODULE, gCmd.REQ_HERO_APPOINT_DISMISS, handler(self, self.dismissRsp))
end
function heroAppointCtrl:initClientData(data)
	dump(data, "heroAppointCtrl:initClientData===", 10)
	if data then
		self.defaultData = data
		self:resetBuff()
	end
end
function heroAppointCtrl:reqAppoint(bid, heroId)
	serverproxy = nil
	;(nil).bid = bid
	;(nil).heroId = heroId
	serverproxy:Request(gCmd.CMD_HERO_APPOINT_MODULE, gCmd.REQ_HERO_APPOINT, nil)
end
function heroAppointCtrl:reqDismiss(bid)
	serverproxy = nil
	;(nil).bid = bid
	serverproxy:Request(gCmd.CMD_HERO_APPOINT_MODULE, gCmd.REQ_HERO_APPOINT_DISMISS, nil)
end
function heroAppointCtrl:appointRsp(content)
	dump(content, "heroAppointCtrl:appointRsp", 5)
	if gErrDef.Err_None == content.err then
		self.defaultData = content.rspdata
		self:resetBuff()
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_HERO_APPOINT_UPDATE"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP"
	self.bid = content.data.bid
	SoraDSendMessage(self)
end
function heroAppointCtrl:dismissRsp(content)
	dump(content, "heroAppointCtrl:dismissRsp", 5)
	if gErrDef.Err_None == content.err then
		self.defaultData = content.rspdata
		self:resetBuff()
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_HERO_APPOINT_UPDATE"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP"
	self.bid = content.data.bid
	SoraDSendMessage(self)
end
function heroAppointCtrl:getAppointHero(bid)
	return self.defaultData[tostring(bid)]
end
function heroAppointCtrl:isHeroBeAppoint(heroID)
	for k, v in pairs(self.defaultData) do
		if v == heroID then
			return k
		end
	end
	return false
end
function heroAppointCtrl:getBuffVale(buffType)
	return self.buffMap[buffType] or 0
end
function heroAppointCtrl:resetBuff()
	local cityltCtrl = include("cityltCtrl")
	local buffDesRead = include("buffDesRead")
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	self.buffMap, _ENV = "heroltCtrl", "heroltCtrl"
	for bid, heroID in pairs(self.defaultData) do
		local cfg = cityltCtrl.getBuildHeroAppointCfg(tonumber(bid))
		if cfg then
			local attrTb = heroltCtrl:getHeroAppointAttr(tonumber(heroID))
			_UPVALUE2_ = tonumber(heroID)
			tonumber(heroID)[1] = "buffType"
			tonumber(heroID)[2] = "buffValue"
			local buildAttrTb = serviceFunctions.tableFormat(cfg.attribute, tonumber(heroID))
			local _ENV, buildAttrStrTb = cfg.attribute, cfg.attribute
			for k, v in ipairs(buildAttrTb) do
				local value = v.buffValue * (1 + attrTb[cfg.direction] / 1000)
				local base, data = buffDesRead.getTitleBase(v.buffType, true)
				if data and data.effectType == 2 then
					value = math.floor(value)
				end
				if self.buffMap[v.buffType] then
					self.buffMap[v.buffType] = self.buffMap[v.buffType] + value
				else
					self.buffMap[v.buffType] = value
				end
			end
		end
	end
end
return heroAppointCtrl
