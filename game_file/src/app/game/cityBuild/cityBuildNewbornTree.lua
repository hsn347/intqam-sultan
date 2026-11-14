local buildLogic = include("buildLogic")
local cityBuildNewbornTree = class("cityBuildNewbornTree", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
local cityBuildConstDef = include("cityBuildConstDef")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
function cityBuildNewbornTree:ctor()
	print("cityBuildNewbornTree:ctor")
	self.notAddName = true
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_NewbornTree)
end
function cityBuildNewbornTree:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001547_UPDATE", handler(self, self.updateBubble))
	SoraDAddMessage(self, "MESSAGE_UPDATE_NEBULA_MILESTONE", handler(self, self.updateGuide))
	SoraDAddMessage(self, "MESSAGE_DIVINE_BEAST_2_UNLOCK", handler(self, self.showBeast2UnlockAnimation))
end
function cityBuildNewbornTree:loadView()
	if not divineBeastCtrl:getIsFuncOpen() then
		return
	end
	self:loadBaseView()
	self:updateView()
	local guideStepIndex = SoraDIsGameGuide()
	if guideStepIndex == 1250106 then
		divineBeastCtrl = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		;(nil).step = guideStepIndex
		;(nil).reload = false
		SoraDSendMessage(nil)
	end
end
function cityBuildNewbornTree:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildNewbornTree:updateView()
	self.isNewbornTreeUnlock = divineBeastCtrl:getIsUnlock()
	if not self.isNewbornTreeUnlock then
		return
	end
	self:updateGuide()
	if self.notAddName then
		self.notAddName = false
		divineBeastCtrl = nil
		divineBeastCtrl, (nil).name = i18n("Divine_beast_text_43"), i18n("Divine_beast_text_43")
		i18n("Divine_beast_text_43").x = 0
		;(nil).pos, i18n("Divine_beast_text_43").y = i18n("Divine_beast_text_43"), -100
		SoraDShowNameOnTouchEvent(self, nil)
	end
	self:updateBubble()
end
function cityBuildNewbornTree:updateGuide()
	if not self.isNewbornTreeUnlock then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	local worldMapDefine = include("worldMapDefine")
	local isInCrossWar = worldMapDefine.inInCrossWar()
	local isGuide = not isInCrossWar and guideCtrl:updateGuideModule(gGuideModule.DIVINE_BEAST_UNLOCK)
	if not isGuide and not isInCrossWar and divineBeastCtrl:getIsUnlock(gBestID.TWO) then
		isGuide = guideCtrl:updateGuideModule(gGuideModule.DIVINE_BEAST_2_UNLOCK)
	end
	if isGuide then
		SoraDRemoveAllAfterPanelFromManager(self, true)
	end
end
function cityBuildNewbornTree:updateBubble()
	if not self.isNewbornTreeUnlock then
		return
	end
	_UPVALUE8_ = self.isNewbornTreeUnlock
	self.isNewbornTreeUnlock[1] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_STARUP
	self.isNewbornTreeUnlock[2] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_STEPUP
	self.isNewbornTreeUnlock[3] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_ATTUP
	self.isNewbornTreeUnlock[4] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_TREAT
	self.isNewbornTreeUnlock[5] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_TASK
	self.isNewbornTreeUnlock[6] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_MARK
	self.isNewbornTreeUnlock[7] = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_53
	local self.isNewbornTreeUnlock[8], bubbleDatas = cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_CANYON, self.isNewbornTreeUnlock
	local buildTopTipType, showBeastId
	for k, v in ipairs(bubbleDatas) do
		local isShow, beastId = divineBeastCtrl:getIsShowBubble(v)
		if isShow then
			buildTopTipType = v
			showBeastId = beastId
			break
		end
	end
	print("debug bubbleDatas", buildTopTipType)
	for k, v in ipairs(bubbleDatas) do
		if v ~= buildTopTipType then
			cityBuildConstDef = divineBeastCtrl:getIsShowBubble(v)
			divineBeastCtrl:getIsShowBubble(v).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			divineBeastCtrl:getIsShowBubble(v).buildIndex = self.buildIndex
			divineBeastCtrl:getIsShowBubble(v).buildTopTipType = v
			SoraDSendMessage(divineBeastCtrl:getIsShowBubble(v))
		end
	end
	if buildTopTipType ~= nil then
		cityBuildConstDef = ipairs(bubbleDatas)
		ipairs(bubbleDatas).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		ipairs(bubbleDatas).buildIndex = self.buildIndex
		ipairs(bubbleDatas).buildEntity = self
		ipairs(bubbleDatas).buildTopTipType = buildTopTipType
		ipairs(bubbleDatas).showBeastId = showBeastId
		SoraDSendMessage(ipairs(bubbleDatas))
	end
end
function cityBuildNewbornTree:showBeast2UnlockAnimation()
	divineBeastCtrl:setShowingBeast(gBestID.TWO)
	local criSprite = cc.criSprite.createCriSprite("sssz1_xx.usm", false, false, nil)
	criSprite:addTo(display.getRunningScene(), 999)
	criSprite:setCompleteCallback(function()
		criSprite:removeFromParent()
		local guideStepIndex = SoraDIsGameGuide()
		criSprite = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		;(nil).step = guideStepIndex
		;(nil).reload = false
		SoraDSendMessage(nil)
	end)
	criSprite:setPosition(display.cx, display.cy)
end
return cityBuildNewbornTree
