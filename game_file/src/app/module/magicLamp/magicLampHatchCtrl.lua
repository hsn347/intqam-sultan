local magicLampRead = include("magicLampRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local magicLampHatchCtrl = class("magicLampHatchCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local worldMapWarDef = include("worldMapWarDef")
local constantRead = include("constantRead")
local magicLampHatchRead = include("magicLampHatchRead")
function magicLampHatchCtrl:ctor(properties)
	magicLampHatchCtrl.super.ctor(self, properties)
	self.desireRatio = constantRead.getConstValue("JINN_HATCH_GETINT_RATIO", 50)
	self:resetData()
end
function magicLampHatchCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_INIT, handler(self, self.reqMagicLampHatchDataRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_UPGRADE, handler(self, self.reqMagicLampHatchUpgradeRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_DESIRE_ITEM, handler(self, self.reqMagicLampHatchDesireItemRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_DESIRE_REWARD, handler(self, self.reqMagicLampHatchDesireRewardRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_DONATE, handler(self, self.reqMagicLampHatchDonateRsp))
	self:initClientData()
	self:registerNotify()
end
function magicLampHatchCtrl:initClientData()
	self:sendReqInitDataMsg()
end
function magicLampHatchCtrl:Logout()
	magicLampHatchCtrl.super.Logout(self)
	self:resetData()
end
function magicLampHatchCtrl:resetData()
	self.msgData = nil
end
function magicLampHatchCtrl:setData(data)
	if self.msgData ~= nil and self.msgData.hatchList ~= nil and data ~= nil and data.hatchList ~= nil then
		for k, v in pairs(self.msgData.hatchList) do
			local newV = data.hatchList[k]
			if newV ~= nil and newV.lv > v.lv then
				_ENV = nil
				;(nil).name = magicLampHatchRead.getHatchName(tonumber(k))
				;(nil).lv = newV.lv
				SoraDShowMsgTip(i18n("Jinn_hatch_text_39", nil))
			end
		end
	end
	self.msgData = data
end
function magicLampHatchCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MAGIC_LAMP_HATCH, handler(self, self.notifyHandler))
end
function magicLampHatchCtrl:notifyHandler(event)
	dump(event.data, "magicLampHatchCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_MAGICLAMP_HATCH_UPDATE"
		SoraDSendMessage(self)
	end
end
function magicLampHatchCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_INIT, nil)
	SoraDShowLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchUpgrade(hatchID, mode)
	serverproxy = nil
	;(nil).hatchID = hatchID
	;(nil).mode = mode
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_UPGRADE, nil)
	SoraDShowLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchDesireItem(hatchID, itemID)
	serverproxy = nil
	;(nil).hatchID = hatchID
	;(nil).itemID = itemID
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_DESIRE_ITEM, nil)
	SoraDShowLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchDesireReward(hatchID)
	serverproxy = nil
	;(nil).hatchID = hatchID
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_DESIRE_REWARD, nil)
	SoraDShowLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchDonate(hatchID, count)
	serverproxy = nil
	;(nil).hatchID = hatchID
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_HATCH_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_DONATE, nil)
	SoraDShowLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchDataRsp(content)
	dump(content, "magicLampHatchCtrl:reqMagicLampHatchDataRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MAGICLAMP_HATCH_UPDATE"
		SoraDSendMessage(self)
	end
end
function magicLampHatchCtrl:reqMagicLampHatchUpgradeRsp(content)
	dump(content, "magicLampHatchCtrl:reqMagicLampHatchUpgradeRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MAGICLAMP_HATCH_UPDATE"
		SoraDSendMessage(self)
	end
end
function magicLampHatchCtrl:reqMagicLampHatchDesireRewardRsp(content)
	dump(content, "magicLampHatchCtrl:reqMagicLampHatchDesireRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MAGICLAMP_HATCH_UPDATE"
		self.extra = content.rspdata.extra
		SoraDSendMessage(self)
	end
	SoraDCloseLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchDonateRsp(content)
	dump(content, "magicLampHatchCtrl:reqMagicLampHatchDonateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MAGICLAMP_HATCH_UPDATE"
		self.extra = content.rspdata.extra
		SoraDSendMessage(self)
	end
	SoraDCloseLoading()
end
function magicLampHatchCtrl:reqMagicLampHatchDesireItemRsp(content)
	dump(content, "magicLampHatchCtrl:reqMagicLampHatchDesireItemRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		local publicRead = include("publicRead")
		_ENV = nil
		;(nil).item = publicRead.getName(content.data.itemID)
		SoraDShowMsgTip(i18n("Jinn_hatch_text_9", nil))
		_ENV = i18n("Jinn_hatch_text_9", nil)
		_UPVALUE1_, i18n("Jinn_hatch_text_9", nil).msg = i18n("Jinn_hatch_text_9", nil)
		i18n("Jinn_hatch_text_9", nil).extra, i18n("Jinn_hatch_text_9", nil)[1] = i18n("Jinn_hatch_text_9", nil)
		SoraDSendMessage(i18n("Jinn_hatch_text_9", nil))
	end
end
function magicLampHatchCtrl:getHatchData(hatchType)
	if self.msgData == nil or self.msgData.hatchList == nil then
		return nil
	end
	return self.msgData.hatchList[tostring(hatchType)]
end
function magicLampHatchCtrl:getRealItemNum(desire, num)
	return num
end
function magicLampHatchCtrl:getIsCanHatchUp(hatchType)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if self.msgData == nil or self.msgData.hatchList == nil then
		return false
	end
	local tmpfunc = function(hatchData)
		local nextCfg = magicLampHatchRead.getDesireCfg(hatchData.id, hatchData.lv + 1)
		if nextCfg == nil then
			return false
		end
		for i, v in ipairs(nextCfg.buildLv) do
			local bid = v.bid
			local starLv = v.lv
			if starLv > SoraDGetBuildStarLv(bid) then
				return false
			end
		end
		for i, v in ipairs(nextCfg.jinnLv) do
			if magicLampCtrl:getJinnLv(v.jinnType) < v.lv then
				return false
			end
		end
		for i, v in ipairs(nextCfg.costItem) do
			local itemNum = backpackCtrl:getItemCount(v.id)
			local curNum = self:getCostBuffValue(hatchData.id, v.id) * v.num
			if itemNum < curNum then
				return false
			end
		end
		for i, v in ipairs(nextCfg.costRes) do
			local isEnough, curRes = SoraDEnoughRes(v.id, v.num)
			if not isEnough then
				return false
			end
		end
		return true
	end
	if hatchType then
		local hatchData = self:getHatchData(hatchType)
		return hatchData ~= nil and tmpfunc(hatchData) or false
	end
	for i, v in pairs(self.msgData.hatchList) do
		if tmpfunc(v) then
			return true, tonumber(i)
		end
	end
	return false
end
function magicLampHatchCtrl:getIsCanGetReaward(hatchType)
	if self.msgData == nil or self.msgData.hatchList == nil then
		return false
	end
	local tmpfunc = function(hatchData)
		local isCanReceive = hatchData.desireInfo.lastChooseItemID and hatchData.desireInfo.isReceive == 0 and hatchData.desireInfo.lastDesire ~= 0
		if isCanReceive then
			return true
		end
		return false
	end
	if hatchType then
		local hatchData = self:getHatchData(hatchType)
		return hatchData ~= nil and tmpfunc(hatchData) or false
	end
	for i, v in pairs(self.msgData.hatchList) do
		if tmpfunc(v) then
			return true, tonumber(i)
		end
	end
	return false
end
function magicLampHatchCtrl:getHatchLv(hatchType)
	hatchType = hatchType or gJinnType.JINN_ONE
	local hatchData = self:getHatchData(hatchType)
	local hatchLv = hatchData and hatchData.lv or 0
	return hatchLv
end
function magicLampHatchCtrl:getCostBuffValue(hatchType, costItemId)
	local getBuffEffect = function(effectType)
		local buffCtrl = SoraDGetCtrl("buffCtrl")
		_UPVALUE2_ = "buffCtrl"
		;("buffCtrl")[1] = gBuffSource.RECHARGE_ACTIVITY
		local ("buffCtrl")[2], sourceList = gBuffSource.ACTIVITY_9001683, "buffCtrl"
		local _ENV, tempList = gBuffSource.RECHARGE_ACTIVITY, gBuffSource.RECHARGE_ACTIVITY
		for __, source in ipairs(sourceList) do
			local value = buffCtrl:getBuffEffect(effectType, source) or 0
			table.insert(tempList, value)
		end
		local ret = 1
		for __, percent in ipairs(tempList) do
			ret = ret * (1 - percent / 1000)
		end
		return ret
	end
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	local buffValue = 1
	if hatchType == gJinnType.JINN_ONE then
		if costItemId == 206801 then
			buffValue = buffValue * getBuffEffect(gBuffEffect.ONE_JINN_HATCHUP_ITEM_REDUCE_LESS1)
		elseif costItemId == 206901 then
			buffValue = buffValue * getBuffEffect(gBuffEffect.ONE_JINN_HATCHUP_ITEM_REDUCE_LESS2)
		end
	end
	return buffValue
end
return magicLampHatchCtrl
