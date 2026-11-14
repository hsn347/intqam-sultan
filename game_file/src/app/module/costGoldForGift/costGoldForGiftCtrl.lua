local GameModule = include("GameModule")
local costGoldForGiftCtrl = class("costGoldForGiftCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function costGoldForGiftCtrl:ctor(properties)
	costGoldForGiftCtrl.super.ctor(self, properties)
end
function costGoldForGiftCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	self:resetData()
end
function costGoldForGiftCtrl:resetData()
	self.handle_notify = nil
	self.costData = nil
	self.spendData = nil
	self.openCount = 0
end
function costGoldForGiftCtrl:Logout()
	self:resetData()
	costGoldForGiftCtrl.super.Logout(self)
end
function costGoldForGiftCtrl:initClientData(data)
	if not data then
		return
	end
	self.spendData = data
	self:registerNotify()
end
function costGoldForGiftCtrl:initSpendData(data)
	if not data then
		return
	end
	self.openCount = data.opencount
	self.costData = data
end
function costGoldForGiftCtrl:dump()
end
function costGoldForGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SPEND_GOLD_ACTIVITY, handler(self, self.notifyHandler))
end
function costGoldForGiftCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			if content.spendGold then
				self.spendData = content
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_COST_GOLD_REFRESH_BACK"
			SoraDSendMessage(nil)
		end
	end
end
function costGoldForGiftCtrl:setCostGoldInfo(data)
	if not data then
		return
	end
	if type(data.openCount) == "number" and data.openCount ~= self.openCount then
		self.spendData.spendGold = 0
	end
	self.costData = data
end
function costGoldForGiftCtrl:getCostGoldInfo()
	local _ENV, ret
	if self.costData and self.costData.param and next(self.costData.param) then
		for k, v in pairs(self.costData.param) do
			local index = tonumber(k)
			if not ret[index] then
				ret[index], _ENV = ret[index], ret[index]
				ret[index] = v
			end
		end
		table.sort(ret, function(l, r)
			return l.needgold < r.needgold
		end)
	end
	return ret
end
function costGoldForGiftCtrl:getPlayerSpendGoldNum()
	local spendGold = 0
	if self.spendData and next(self.spendData) then
		spendGold = self.spendData.spendGold
	end
	return spendGold
end
return costGoldForGiftCtrl
