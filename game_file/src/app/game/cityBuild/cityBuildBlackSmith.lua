local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildBlackSmith = class("cityBuildBlackSmith", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildBlackSmith:ctor()
	local et_ani = SoraDCreatAnimation("animationBlackSmith")
	et_ani:setPosition(16, -79)
	et_ani:addTo(self, 2)
end
function cityBuildBlackSmith:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_115"), i18n("buildDes_name_115")
	i18n("buildDes_name_115").x = 0
	;(nil).pos, i18n("buildDes_name_115").y = i18n("buildDes_name_115"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildBlackSmith:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_BLACKSMITH_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_UNLOCK", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_REFINE_BACK", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_AWAKE_BACK", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgUpdateView))
end
function cityBuildBlackSmith:getIsOpening()
	return false
end
function cityBuildBlackSmith:showTopTipEffect()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_TRAIN_EQUIP
	SoraDSendMessage(nil)
end
function cityBuildBlackSmith:jumpToArtifact(...)
	local gametop = gModuleMgr.getObject("gametop")
	local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
	local ret, index = false
	ret, index = godArmsCtrl:isCanUnlock()
	if not ret then
		ret, index = godArmsCtrl:isCanFreeRefine()
	end
	_ENV = nil
	;(nil).index = ret and index or 1
	uiManager:show("ArtifactView", nil)
end
function cityBuildBlackSmith:checkBlackSmithAuction()
	if SoraDIsGameGuide() then
		print("有引导按钮，不显示")
		return false
	end
	local gametop = gModuleMgr.getObject("gametop")
	local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
	local cityBuildConstDef = include("cityBuildConstDef")
	local funUnlockRead = include("funUnlockRead")
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ARTIFACT)
	if unlockLv <= SoraDGetCastleLv() then
		if godArmsCtrl:isCanUnlock() then
			_ENV = godArmsCtrl
			godArmsCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
			godArmsCtrl.buildIndex = self.buildIndex
			godArmsCtrl.buildEntity = self
			godArmsCtrl.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_GOD_UNLOCK
			SoraDSendMessage(godArmsCtrl)
			return true
		end
		if godArmsCtrl:isCanFreeRefine() then
			_ENV = godArmsCtrl
			godArmsCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
			godArmsCtrl.buildIndex = self.buildIndex
			godArmsCtrl.buildEntity = self
			godArmsCtrl.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_GOD_UNLOCK
			SoraDSendMessage(godArmsCtrl)
			return true
		end
	end
	_ENV = godArmsCtrl
	godArmsCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
	godArmsCtrl.buildIndex = self.buildIndex
	godArmsCtrl.buildEntity = self
	godArmsCtrl.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_GOD_UNLOCK
	SoraDSendMessage(godArmsCtrl)
	return false
end
function cityBuildBlackSmith:msgUpdateView(target, data)
	local buildState = self:getBuildState()
	if buildState == BUILD_STATE.BUILDING then
		return
	end
	self:updateView()
end
function cityBuildBlackSmith:onAfterInitWithBuildCell()
	self:checkBlackSmithAuction()
end
function cityBuildBlackSmith:updateTopTip()
	self:checkBlackSmithAuction()
end
function cityBuildBlackSmith:updateViewAfterReset()
	self:updateTopTip()
end
function cityBuildBlackSmith:updateView()
	self:checkBlackSmithAuction()
	self:updateIsLock()
end
return cityBuildBlackSmith
