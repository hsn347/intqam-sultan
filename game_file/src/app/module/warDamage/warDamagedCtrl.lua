local GameModule = include("GameModule")
local warDamagedCtrl = class("warDamagedCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
function warDamagedCtrl:ctor(properties)
	warDamagedCtrl.super.ctor(self, properties)
end
function warDamagedCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	self:registerNotify()
end
function warDamagedCtrl:resetData()
	self.handle_notify = nil
end
function warDamagedCtrl:Logout()
	self:resetData()
	warDamagedCtrl.super.Logout(self)
end
_ENV, warDamagedCtrl.registerNotify = function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end, function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.FOOD] = gIDDef.FOOD
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.WOOD] = gIDDef.WOOD
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.IRON] = gIDDef.IRON
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.MITHRIL] = gIDDef.MITHRIL
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.CRYSTAL] = gIDDef.CRYSTAL
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.FOOD_SAFE] = gIDDef.FOOD
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.WOOD_SAFE] = gIDDef.WOOD
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.IRON_SAFE] = gIDDef.IRON
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.MITHRIL_SAFE] = gIDDef.MITHRIL
local (function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end)[gIDDef.CRYSTAL_SAFE], safeResIDToResIDMap = gIDDef.CRYSTAL, function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_DAMAGED, handler(self, self.notifyHandler))
end
function warDamagedCtrl:notifyHandler(event)
	for index, content in pairs(event.data) do
		if content and content.mid and content.reward then
			local mid = content.mid
			local _ENV, reward
			for k, v in pairs(content.reward) do
				local id = safeResIDToResIDMap[v.id]
				if id then
					v.id = id
					if reward[id] then
						reward[id].count = reward[id].count + v.count
					else
						reward[id] = v
					end
				end
			end
			SoraDCreateDelayTimer(self, function()
				gametop.playertop_:getModule("kingdomMapCtrl"):reqAddWarLossCompensateQueue(reward, mid)
			end, 0.1)
		end
	end
end
return warDamagedCtrl
