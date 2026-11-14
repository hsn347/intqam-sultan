local baseProxy = require("fgui.base.baseProxy")
local RuneMainProxy = class("RuneMainProxy", baseProxy)
function RuneMainProxy:onRegisterEvent()
	print("=======RuneMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_RUNE_PREVIEW", handler(self, self.updatePreView))
end
function RuneMainProxy:updateView(target, data)
	self.view:updatePower()
	self.view:updateArtifactAction()
	local uid = data and data.uid or nil
	local group = data and data.group or nil
	self.view:initMenu(data and data.preview, group)
	self.view:setSlotInfo(uid, group)
	self.view:setSuitSkill(group)
end
function RuneMainProxy:updatePreView(target, data)
	dump(data, "updatePreView====")
	local uid = data.uid
	if uid then
		for k, v in pairs(self.view.runePreArray) do
			if v == uid then
				self.view.runePreArray[k] = 0
			end
		end
		self.view.runePreArray[tostring(data.godArmsCell)] = uid
	elseif data.detail then
		self.view.runePreArray = clone(data.detail)
	else
		self.view.runePreArray[tostring(data.godArmsCell)] = 0
	end
	self.view:setSlotInfo(uid, data.group)
	self.view:setSuitSkill(data.group)
	self.view:updateSaveBtn()
end
return RuneMainProxy
