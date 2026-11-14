local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildPetCenter = class("cityBuildPetCenter", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildPetCenter:ctor()
	self:setBuildIndex(cityBuildConstDef.fixedBuildDef.PetCenter)
	self.bid = cityBuildConstDef.fixedBuildDef.PetCenter
end
function cityBuildPetCenter:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_PET_CENTER_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.sMsgChangeItemType))
	self:updateView()
end
function cityBuildPetCenter:sMsgChangeItemType(target, data)
	if data and data.itemType == gItemType.PET_FRAGMENT then
		self:updateView()
	end
end
function cityBuildPetCenter:loadView()
	self:loadBaseView()
	local offSetX = 0
	local offSetY = 0
	local scale = 1.0
	_ENV = nil
	_ENV, (nil).name = i18n("common_text_2915"), i18n("common_text_2915")
	i18n("common_text_2915").x = 0 + offSetX
	;(nil).pos, i18n("common_text_2915").y = i18n("common_text_2915"), -100 + offSetY
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildPetCenter:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_PET_CENTER_VIEW")
	self:updateView()
end
function cityBuildPetCenter:onAfterReconnected()
	self:updateView()
end
function cityBuildPetCenter:updateView()
	self:updateIsLock()
	self:checkPetUnlock()
	self:checkPetSkillSend()
end
function cityBuildPetCenter:checkPetUnlock()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	local hasCanUnlockPet = self:hasCanUnlockPet()
	print("---------checkPetUnlock =", hasCanUnlockPet)
	if hasCanUnlockPet then
		_ENV = "---------checkPetUnlock ="
		;("---------checkPetUnlock =").msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;("---------checkPetUnlock =").buildIndex = self.buildIndex
		;("---------checkPetUnlock =").buildEntity = self
		;("---------checkPetUnlock =").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PET_UNLOCK
		SoraDSendMessage("---------checkPetUnlock =")
	else
		if self:getIsCanSpeedUpFree() then
			return
		elseif self:getIsNeedReqHelp() then
			return
		end
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self.buildIndex
		self.buildEntity = self
		self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PET_UNLOCK
		SoraDSendMessage(self)
	end
end
function cityBuildPetCenter:hasCanUnlockPet()
	return petCtrl:getHasCanUnlockPet()
end
function cityBuildPetCenter:hasCanClaimGoodid()
	return petCtrl:getCanReceiveSpecialSkillToolNum() > 0
end
function cityBuildPetCenter:hasCanAdvancePet()
	return petCtrl:getHasCanAdvancePet()
end
function cityBuildPetCenter:checkPetSkillSend()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	if self:hasCanUnlockPet() then
		return
	end
	local hasCanClaimGoodid = self:hasCanClaimGoodid() or self:hasCanAdvancePet()
	if hasCanClaimGoodid then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;(nil).buildIndex = self.buildIndex
		;(nil).buildEntity = self
		;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PET_SKILL_SEND
		SoraDSendMessage(nil)
	else
		if self:getIsCanSpeedUpFree() then
			return
		elseif self:getIsNeedReqHelp() then
			return
		end
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self.buildIndex
		self.buildEntity = self
		self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PET_SKILL_SEND
		SoraDSendMessage(self)
	end
end
function cityBuildPetCenter:isCustomIdle()
	local isIdle = true
	if self:getIsLocked() then
		isIdle = false
	end
	if isIdle and self:hasCanUnlockPet() then
		isIdle = false
	end
	if isIdle and (self:hasCanClaimGoodid() or self:hasCanAdvancePet()) then
		isIdle = false
	end
	return isIdle
end
return cityBuildPetCenter
