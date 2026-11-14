local baseComponent = require("fgui.base.baseComponent")
local PetHeadItem = fgui.extension_class(fgui.GComponent, baseComponent)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
fgui.register_extension("ui://PetFguiView/PetHeadItem", PetHeadItem)
function PetHeadItem:onInit()
	self.fields.button_pet:addClickEventListener(handler(self, self.onSelect))
end
function PetHeadItem:onShow()
end
function PetHeadItem:initData(petData, idx, isSelected, petView)
	self.idx = idx
	self.isSelected = isSelected
	self.petView = petView
	local petId = petData.pid
	self.petId = petId
	local isUnlock = petCtrl:isPetUnlock(petId)
	local isCanUnlock = petCtrl:petIsCanUnlock(petId)
	self.fields.lock_1:setVisible(not isUnlock)
	self.fields.lock_2:setVisible(not isUnlock)
	self.fields.lock_3:setVisible(not isUnlock)
	self.fields.icon_selected:setVisible(isSelected)
	local curRank
	if isUnlock then
		local petInfo = petCtrl:getPet(petId)
		curRank = petInfo.rank
	else
		curRank = #petData.rankInfo
	end
	local card = petDesRead.getPetCard(petId, curRank)
	local headIcon = petDesRead.getRankIcon(curRank)
	self.fields.icon_lv:setURL(headIcon)
	self.fields.pet_icon:setURL(card)
	self.fields.lock_2:stopAllActions()
	self.fields.lock_2:setRotation(0)
	self.fields.effet_light:stopAllActions()
	self.fields.effet_light:setAlpha(0)
	self.fields.effet_light:setVisible(not isUnlock and isCanUnlock)
	if not isUnlock and isCanUnlock then
		_UPVALUE6_ = self.fields.effet_light
		self.fields.effet_light[1] = ffa.delay(0.5)
		self.fields.effet_light[2] = ffa.rotateTo(0.25, 20)
		self.fields.effet_light[3] = ffa.rotateTo(0.21666666666666667, -20)
		self.fields.effet_light[4] = ffa.rotateTo(0.2, 8)
		self.fields.effet_light[5] = ffa.rotateTo(0.16666666666666666, -5)
		self.fields.effet_light[6] = ffa.rotateTo(0.15, 2)
		self.fields.effet_light[7] = ffa.rotateTo(0.15, 0)
		self.fields.effet_light[8] = ffa.rotateTo(0.15, 0)
		self.fields.effet_light[9] = ffa.rotateTo(0.15, 0)
		local seq = ffa.seq(self.fields.effet_light)
		self.fields.lock_2:runAction(ffa.repeatForever(seq))
		petDesRead = ffa.repeatForever(seq)
		ffa.repeatForever(seq)[1] = ffa.fadeTo(0.75, 1)
		ffa.repeatForever(seq)[2] = ffa.fadeTo(0.75, 0.5)
		ffa.repeatForever(seq)[3] = ffa.fadeTo(0.75, 0.5)
		ffa.repeatForever(seq)[4] = ffa.fadeTo(0.75, 0.5)
		ffa.repeatForever(seq)[5] = ffa.fadeTo(0.75, 0.5)
		self.fields.effet_light:runAction(ffa.repeatForever(ffa.seq(ffa.repeatForever(seq))))
	end
end
function PetHeadItem:setIsShowPetAdvancePoint(petData, isShowPetAdvancePoint)
	if isShowPetAdvancePoint and petData and petData:getIsCanAdvance() then
		self.fields.red_point:setVisible(true)
	else
		self.fields.red_point:setVisible(false)
	end
end
function PetHeadItem:onSelect()
	SoraDPlaySound()
	self.petView.fields.scroll_attributes:setVisible(true)
	self.petView.fields.com_levelup:isFeedItemClick(false)
	if self.isSelected then
		return
	end
	self.petView:setSelectPetId(self.petId)
end
return PetHeadItem
