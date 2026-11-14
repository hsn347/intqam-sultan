local GameModule = include("GameModule")
local communityPopCtrl = class("communityPopCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function communityPopCtrl:ctor(properties)
	communityPopCtrl.super.ctor(self, properties)
end
function communityPopCtrl:EnterGame()
	communityPopCtrl.super.EnterGame(self)
	self:resetData()
	self:registerNotify()
end
function communityPopCtrl:resetData()
	self.popList, _UPVALUE0_ = nil, nil
end
function communityPopCtrl:initClientData(event)
	if event and next(event) then
		for _, v in pairs(event) do
			table.insert(self.popList, v)
		end
	end
end
function communityPopCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.COMMUNITY_BUBBLE, handler(self, self.notifyHandler))
end
function communityPopCtrl:notifyHandler(event)
	if event and event.data and type(event.data) == "table" then
		self.popList, _ENV = type(event.data), type(event.data)
		for _, data in pairs(event.data) do
			for k, v in pairs(data.communityContent) do
				table.insert(self.popList, v)
			end
		end
	end
end
function communityPopCtrl:getPopData(language)
	local _ENV, ret
	for i, v in ipairs(self.popList) do
		if language then
			table.insert(ret, v[language])
		else
			table.insert(ret, v)
		end
	end
	return ret
end
function communityPopCtrl:Logout()
	self:resetData()
	communityPopCtrl.super.Logout(self)
end
return communityPopCtrl
