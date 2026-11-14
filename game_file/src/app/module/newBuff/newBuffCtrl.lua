local gametop = gModuleMgr.getObject("gametop")
local gamemodulec = include("GameModule")
local buffModule = include("buffModule")
local timerModule = gModuleMgr.getObject("timerList")
local msgCtrl = include("msgCtrl")
local newBuffCtrl = class("newBuffCtrl", gamemodulec)
function newBuffCtrl:ctor(properties)
	newBuffCtrl.super.ctor(self, properties)
end
function newBuffCtrl:init()
	print("newBuffCtrl:init begin")
	self:internalInit()
	self:externalInit()
	print("newBuffCtrl:init end")
end
function newBuffCtrl:registerNotify()
end
function newBuffCtrl:initClientData(retdata)
	dump(retdata, "newBuffCtrl:initClientData", 10)
end
function newBuffCtrl:internalInit()
	local buffEndCallback = function(buffID)
		print("new buff end", buffID)
	end
	local attributeCtrl = gametop.playertop_:getModule("attributeCtrl")
	_ENV = nil
	self.buffModule = buffModule.new(attributeCtrl, timerModule, buffEndCallback, nil)
end
function newBuffCtrl:externalInit()
end
function newBuffCtrl:EnterGame()
	newBuffCtrl.super.EnterGame(self)
	self:init()
end
function newBuffCtrl:Logout()
	newBuffCtrl.super.Logout(self)
	self:resetData()
end
function newBuffCtrl:resetData()
end
function newBuffCtrl:add(...)
	if self.buffModule:add(...) then
		return true
	else
		return false
	end
end
function newBuffCtrl:remove(...)
	if self.buffModule:remove(...) then
		return true
	else
		return false
	end
end
function newBuffCtrl:useAttr(...)
	if self.buffModule:useAttr(...) then
		return true
	else
		return false
	end
end
function newBuffCtrl:registerMsg()
end
function newBuffCtrl:dump()
	dump(self.buffModule, "newBuffCtrl", 10)
	local attributeCtrl = gametop.playertop_:getModule("attributeCtrl")
	attributeCtrl:dump()
end
return newBuffCtrl
