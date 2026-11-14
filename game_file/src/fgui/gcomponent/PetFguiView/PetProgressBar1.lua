local baseComponent = require("fgui.base.baseComponent")
local PetProgressBar1 = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://PetFguiView/PetProgressBar1", PetProgressBar1)
local petltCtrl = include("petltCtrl")
local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
function PetProgressBar1:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.button_more:setTitle(i18n("Dear_pet_main_06"))
	self.fields.button_more:addClickEventListener(handler(self, self.onMore))
	self.fields.btn_add:addClickEventListener(handler(self, self.onGetItem))
end
function PetProgressBar1:onShow()
end
function PetProgressBar1:initData(petId)
	self.petId = petId
	local info = petltCtrl.getPetUnlockInfo(self.petId)
	local isCanUnlock, isCanUnlockRet = petCtrl:petIsCanUnlock(self.petId)
	local curCount = backpackCtrl:getItemCount(info.debrisid)
	local needCount = info.debriscount
	self.info = info
	self.fields.text_progress:setString("" .. curCount .. "/" .. needCount)
	self:setValue(curCount / needCount * 100)
	self.fields.icon:setURL(publicRead.getIcon(info.debrisid))
	self.fields.button_more:setVisible(table.nums(isCanUnlockRet) > 1)
end
function PetProgressBar1:onMore()
	SoraDPlaySound()
	_ENV = nil
	;(nil).pid = self.petId
	uiManager:show("PetUnlockView", nil)
end
function PetProgressBar1:onGetItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_PET_ITEM_GUILD"
	;(nil).itemID = self.info.debrisid
	SoraDSendMessage(nil)
end
return PetProgressBar1
