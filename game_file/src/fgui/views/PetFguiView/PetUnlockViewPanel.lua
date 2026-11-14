local petCtrl = SoraDGetCtrl("petCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetUnlockViewPanel = class("PetUnlockViewPanel", baseFguiPanel)
function PetUnlockViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetUnlockViewPanel:ctor", self.viewName)
end
function PetUnlockViewPanel:onInit()
	print("=======PetUnlockViewPanel:onInit")
	self.fields.ScrollView_unlock:setItemRenderer(handler(self, self.onItemRenderer))
end
function PetUnlockViewPanel:onShow()
	print("=======PetUnlockViewPanel:onShow")
	local isExchange = self.param.isExchange
	if isExchange then
		self.fields.Panel_bg:setString(i18n("common_text_3802"))
		self.unlockData = self.param.tblUnlock
		self.fields.ScrollView_unlock:setNumItems(#self.unlockData)
	else
		self.fields.Panel_bg:setString(i18n("common_text_2931"))
		self:init(self.param)
	end
end
function PetUnlockViewPanel:init(data)
	if data ~= nil then
		self.petId = data.pid
	end
	if self.petId == 1253 then
		lordInfoCtrl:getLordBattleInfoReq()
	else
		self:updateUnlockInfo()
	end
end
function PetUnlockViewPanel:updateUnlockInfo()
	local canUnlock, tableUnlockData = petCtrl:petIsCanUnlock(self.petId)
	self.unlockData = table.values(tableUnlockData)
	dump(self.unlockData, "==PetUnlockViewPanel:updateUnlockInfo==")
	self.fields.ScrollView_unlock:setNumItems(#self.unlockData)
end
function PetUnlockViewPanel:onItemRenderer(index, obj)
	local data = self.unlockData[index + 1]
	obj:initData(data)
end
function PetUnlockViewPanel:onMsgUpdateFcInfo(...)
	print("请求最新击杀消息========")
	self:updateUnlockInfo()
end
return PetUnlockViewPanel
