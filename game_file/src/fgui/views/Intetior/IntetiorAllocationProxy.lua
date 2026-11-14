local baseProxy = require("fgui.base.baseProxy")
local IntetiorAllocationProxy = class("IntetiorAllocationProxy", baseProxy)
function IntetiorAllocationProxy:onRegisterEvent()
	self.resDataAllocation, _ENV = nil, nil
	print("=======IntetiorAllocationProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_ALLOCATION_RSP", handler(self, self.rspAlloaction))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_PLAYER_DAY_RSP", handler(self, self.rspPlayAward))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_RESOURCE_DATA", handler(self, self.updateResourceInfo))
end
function IntetiorAllocationProxy:rspAlloaction(target, data)
	SoraDCloseLoading(self.view)
	if data.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1190"))
	end
	self.view:removeFromParent()
end
function IntetiorAllocationProxy:rspPlayAward(target, data)
	SoraDCloseLoading(self.view)
	if data.uid then
		if not data.info then
			local _ENV, info = data.info, data.info
		end
		local index = self.view:getIndexByUid(data.uid)
		if data.err == gErrDef.Err_None then
			self.resDataAllocation[index] = info
			self.view:initScrollView()
		else
			self.view:removeFromParent()
		end
	end
end
function IntetiorAllocationProxy:updateResourceInfo(target, data)
	self.view:updateResourceInfo()
	self.view:initScrollView()
	self.view:updateChooseResInfo()
	self.view:updateBtn()
end
function IntetiorAllocationProxy:getResDataAllocation()
	local _ENV, resDataAllocation
	for i, info in pairs(self.resDataAllocation) do
		for key, value in pairs(info) do
			if not resDataAllocation[key] or value > resDataAllocation[key] then
				resDataAllocation[key] = value
			end
		end
	end
	return resDataAllocation
end
function IntetiorAllocationProxy:deletResDataAllocation(index)
	self.resDataAllocation[index] = nil
end
return IntetiorAllocationProxy
