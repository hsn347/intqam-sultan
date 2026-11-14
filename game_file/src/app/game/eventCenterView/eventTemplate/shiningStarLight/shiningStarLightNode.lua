local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local shiningStarLightNode = class("shiningStarLightNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	target = target or SoraDCreateBasePanel("shiningStarLightNode")
	SoraDDeviceFitOffset(target)
	return target
end)
local maxLightNum = 5
function shiningStarLightNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
	self.itemID = 829601
	self.nodeScale = 1
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.nodeLine = SoraDGetChildByName(self.nodeBottom, "Node_line")
	self.nodeBar = SoraDGetChildByName(self.nodeBottom, "Node_Bar")
	self.imageIconBox = SoraDGetChildByName(self, "Image_IconBox")
	self.boxEffect_1 = SoraDGetChildByName(self, "Node_BoxEffect")
	self.boxEffect_2 = SoraDGetChildByName(self, "Node_BoxEffect_Get")
	self.boxEffect_3 = SoraDGetChildByName(self, "Node_BeforeEffect")
	self.boxEffect_4 = SoraDGetChildByName(self, "Node_BeforeEffect_Get")
	self.nodeT = SoraDGetChildByName(self, "Top_Node_T")
	self.nodeTimer = SoraDGetChildByName(self.nodeT, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self.nodeTimer, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.nodeStarLight = SoraDGetChildByName(self.nodeT, "Node_StarLight")
	self.starLampList = SoraDGetChildsArrayByName(self.nodeStarLight, "CCS_shiningStarLightSingle_", 5, 1, true, true)
	self.nodeDown = SoraDGetChildByName(self, "Node_Bottom_Down")
	self.textTips = SoraDGetChildByName(self.nodeDown, "Text_Tips")
	self.textTips:setString(i18n("Glorious_text_10"))
	self.nodeNum = SoraDGetChildByName(self.nodeDown, "Node_Num")
	self.textNumDescribe = SoraDGetChildByName(self.nodeNum, "Text_NumDescribe")
	self.textNumDescribe:setString(i18n("Glorious_text_09"))
	self.spScore = SoraDGetChildByName(self.nodeNum, "icon_score")
	self.textNumHave = SoraDGetChildByName(self.nodeNum, "Text_NumHave")
	self.btnAdd = SoraDGetChildByName(self.nodeNum, "Button_Add")
	self.btnAdd:setTouchEnabled(true)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.lBarInter = SoraDGetExtendChildFromCCSByName(self.nodeDown, "CCS_commonProgressBar")
	self.lBarInter:setActionDelay(0.5)
	self.spBar = SoraDGetChildByName(self.lBarInter, "node_probar_head")
	self.panelCutP = SoraDGetChildByName(self.lBarInter, "Panel_1")
	self.lBarInter:setHandle(function(data)
		local curPro = 100 * data.actionValue / data.maxValue
		local posx = SoraDFPosX(0, curPro * 500 / 100)
		print("posxposx,", posx)
		self.spBar:setPositionX(posx)
		self.panelCutP:setContentSize(cc.size(curPro * 500 / 100, 18))
	end)
	self.textBarDes = SoraDGetChildByName(self.lBarInter, "Text_barDes")
	self.nodeFinalAward = SoraDGetChildByName(self.nodeDown, "Node_FinalAward")
	self.btnFinalAward = SoraDGetChildByName(self.nodeFinalAward, "Button_FinalAward")
	self.btnFinalAward:setTouchEnabled(true)
	self.btnFinalAward:addTouchEventListener(handler(self, self.btnFinalAwardClick))
	self:initActivityTime()
	self:fitView()
	self:initEffect()
end
function shiningStarLightNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNums))
	SoraDAddMessage(self, "MESSAGE_SHINING_STAR_LIGHT", handler(self, self.initData))
end
function shiningStarLightNode:initData(target, data)
	self:updateStarLight()
	self:updateItemNums()
end
function shiningStarLightNode:fitView()
	local offsetPosY = math.min(display.height - 960, 100)
	self.nodeStarLight:setPositionY(math.min(82, self.nodeStarLight:getPositionY() - offsetPosY))
	local heightOffset = math.max(display.height - 1182, 0)
	self.lBarInter:setPositionY(180.0 + heightOffset / 2)
	if offsetPosY < 0 then
		self.nodeScale = 0.8
		SoraDGetChildByName(self, "Image_xian"):setPositionY(960 - display.height)
		heightOffset = display.height - 900
		SoraDGetChildByName(self, "Node_ScaleIpad"):setScale(self.nodeScale)
		self.nodeFinalAward:setScale(self.nodeScale)
	end
	SoraDGetChildByName(self, "Image_Right_Size"):setContentSize(cc.size(640, 312 + heightOffset))
	SoraDGetChildByName(self, "Image_Left_Size"):setContentSize(cc.size(640, 312 + heightOffset))
	SoraDGetChildByName(self, "Image_Hua_Size"):setContentSize(cc.size(640, 270 + heightOffset))
	self.nodeLine:setPositionY(self.nodeLine:getPositionY() + heightOffset)
end
function shiningStarLightNode:initEffect()
	local ret = _G.SoraDIsFileExistByKey("shiningStarLight")
	if ret then
		display.addSpriteFrames("Common/shiningStarLight.plist", getImageFileNameByPlatform("Common/shiningStarLight"))
	end
	_UPVALUE2_ = "Common/shiningStarLight.plist"
	;("Common/shiningStarLight.plist")[1] = cca.fadeTo(0, 0.4)
	;("Common/shiningStarLight.plist")[2] = cca.fadeTo(0.6166666666666667, 0.9)
	;("Common/shiningStarLight.plist")[3] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[4] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[5] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[6] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[7] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[8] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[9] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[10] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[11] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[12] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[13] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[14] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[15] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[16] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[17] = cca.fadeTo(0.6166666666666667, 0.4)
	;("Common/shiningStarLight.plist")[18] = cca.fadeTo(0.6166666666666667, 0.4)
	local seq = cca.seq("Common/shiningStarLight.plist")
	self.spBar:runAction(cc.RepeatForever:create(seq))
	local loop = true
	local cssFileName = "shiningStarLightNode"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	local dhJinnew2 = SoraDGetChildByName(self, "G_dh_jinzitanew02")
	local dhJinnew1 = SoraDGetChildByName(self, "G_dh_jinzitanew01")
	local frames_2 = display.newFrames("dh_jinzitanew_%.2d.png", 1, 9)
	local animation_2 = display.newAnimation(frames_2, 1.2 / #frames_2)
	dhJinnew2:playAnimationForever(animation_2)
	_UPVALUE8_ = dhJinnew2.playAnimationForever
	dhJinnew2.playAnimationForever[1] = display.newSpriteFrame("dh_jinzitanew_06.png")
	dhJinnew2.playAnimationForever[2] = display.newSpriteFrame("dh_jinzitanew_07.png")
	dhJinnew2.playAnimationForever[3] = display.newSpriteFrame("dh_jinzitanew_08.png")
	dhJinnew2.playAnimationForever[4] = display.newSpriteFrame("dh_jinzitanew_09.png")
	dhJinnew2.playAnimationForever[5] = display.newSpriteFrame("dh_jinzitanew_01.png")
	dhJinnew2.playAnimationForever[6] = display.newSpriteFrame("dh_jinzitanew_02.png")
	dhJinnew2.playAnimationForever[7] = display.newSpriteFrame("dh_jinzitanew_03.png")
	dhJinnew2.playAnimationForever[8] = display.newSpriteFrame("dh_jinzitanew_04.png")
	dhJinnew2.playAnimationForever[9] = display.newSpriteFrame("dh_jinzitanew_05.png")
	local dhJinnew2.playAnimationForever[10], frames_1 = display.newSpriteFrame("dh_jinzitanew_05.png")
	local animation_1 = display.newAnimation(frames_1, 1.06 / #frames_1)
	dhJinnew1:playAnimationForever(animation_1)
end
function shiningStarLightNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("lucky_text_02", nil)
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 10, SoraDFIsRA())
end
function shiningStarLightNode:updateStarLight()
	self.lampIndex = shiningStarLightCtrl:getStarLampIndex()
	for i, v in ipairs(self.starLampList) do
		v:initData(i, true)
		v:setNodeScale(0.8)
	end
	self.lBarInter:stopAllActions()
	self.lBarInter:setInitState(false)
	shiningStarLightCtrl = false
	;(false).maxValue = maxLightNum
	;(false).curValue = self.lampIndex
	self.lBarInter:setProgressDate(false)
	self.lBarInter:setInitState(true)
	self.boxEffect_2:setVisible(shiningStarLightCtrl:getBoxIsOpen() == 0 and self.lampIndex == maxLightNum)
	self.boxEffect_4:setVisible(shiningStarLightCtrl:getBoxIsOpen() == 0 and self.lampIndex == maxLightNum)
	self.boxEffect_1:setVisible(not self.boxEffect_2:isVisible())
	self.boxEffect_3:setVisible(not self.boxEffect_2:isVisible())
end
function shiningStarLightNode:updateItemNums()
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(self.itemNums)
	SoraDToCenter(self.nodeNum, 10, SoraDFIsRA())
end
function shiningStarLightNode:btnAddClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).msg = "MESSAGE_SHINING_STAR_LIGHT"
		;(nil).subMsg = "Jump_Task"
		SoraDSendMessage(nil)
	end
end
function shiningStarLightNode:btnFinalAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("shiningStarLightFinalAward")
		panel:show()
	end
end
function shiningStarLightNode:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return shiningStarLightNode
