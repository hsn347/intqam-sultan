local gametop = gModuleMgr.getObject("gametop")
local stuffWorkshopCtrl = gametop.playertop_:getModule("stuffWorkshopCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local equipDesRead = include("equipDesRead")
local itemDesRead = include("itemDesRead")
local constantRead = include("constantRead")
local vipLocalData = include("vipLocalData")
local MATERIAL_FACTORY_SCROLL_TYPE_OPEN = 0
local MATERIAL_FACTORY_SCROLL_TYPE_LOCK = 1
local MATERIAL_FACTORY_SCROLL_TYPE_GRAY = 2
local CHANGE_QUALITY_VIP_GREEN = constantRead.getConstValue("WORK_SHOP_QUALITY_GREEN")
local CHANGE_QUALITY_VIP_BLUE = constantRead.getConstValue("WORK_SHOP_QUALITY_BLUE")
local TOTAL_POS = 7
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MaterialFactoryPanel = class("MaterialFactoryPanel", baseFguiPanel)
function MaterialFactoryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MaterialFactoryPanel:ctor", self.viewName)
end
function MaterialFactoryPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildViewCommon"
	end
	return self._packageList
end
function MaterialFactoryPanel:onInit()
	print("=======MaterialFactoryPanel:onInit")
	self.isInit = true
	_ENV = "=======MaterialFactoryPanel:onInit"
	;("=======MaterialFactoryPanel:onInit").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======MaterialFactoryPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2123"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.fields.Button_bag:setString(i18n("common_text_040"))
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Button_speed:setString(i18n("common_text_018"))
	self.fields.Button_speed:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Text_Tab:setString(i18n("common_text_2446"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_Tab:setItemRenderer(handler(self, self.onItemTabRederer))
	self.fields.List_Tab:addClickListener(handler(self, self.onClickTabList))
	_UPVALUE3_ = self.fields.List_Tab.addClickListener
	self.tabList, self.fields.List_Tab.addClickListener[1] = self.fields.List_Tab.addClickListener, "frame_alchemylab_bai.png"
	self.tabList, self.fields.List_Tab.addClickListener[2] = self.fields.List_Tab.addClickListener, "frame_alchemylab_lv.png"
	self.tabList, self.fields.List_Tab.addClickListener[3] = self.fields.List_Tab.addClickListener, "frame_alchemylab_lan.png"
	self.fields.List_Tab:setNumItems(#self.tabList)
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchBegin))
	self:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onTouchMove))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	self.itemTips = self.fields.Com_Tip
	self.touchSprite = self.fields.Sprite_touch
end
function MaterialFactoryPanel:onShow()
	print("=======MaterialFactoryPanel:onShow")
	SoraDPlaySound("innerbuildsound", 210)
	_ENV = "innerbuildsound"
	;("innerbuildsound").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;("innerbuildsound").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	;("innerbuildsound").scale = 1.0
	;("innerbuildsound").yOffset = display.height - self.fields.Button_speed:getPositionY() * self:getScale() + 130
	SoraDSendMessage("innerbuildsound")
	guideCtrl:updateGuideModule(gGuideModule.MATERIAL_FACTORY)
	_ENV = gGuideModule.MATERIAL_FACTORY
	gGuideModule.MATERIAL_FACTORY.byUID = true
	local setQuality = SoraDConfigGet("Game:MaterialFactoryView:materialQuality~integer", gGuideModule.MATERIAL_FACTORY) or 0
	local vipData = lordInfoCtrl:getVip()
	local toIndex = 0
	if setQuality == 2 and vipData[2] and vipData[1] >= CHANGE_QUALITY_VIP_BLUE then
		toIndex = 2
	elseif setQuality == 1 and vipData[2] and vipData[1] >= CHANGE_QUALITY_VIP_GREEN then
		toIndex = 1
	end
	self.preIndex = toIndex
	self.fields.List_Tab:setSelectedIndex(toIndex)
	stuffWorkshopCtrl:sendRefresh()
	self:updateQuality(false, true)
end
function MaterialFactoryPanel:updateQuality(setQuality, isInit)
	if setQuality then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:MaterialFactoryView:materialQuality~integer", setQuality, nil)
	end
	_ENV = setQuality
	setQuality.byUID = true
	setQuality = SoraDConfigGet("Game:MaterialFactoryView:materialQuality~integer", setQuality)
	local vipData = lordInfoCtrl:getVip()
	if setQuality == gQualityDef.GREEN then
		if not (vipData[1] >= CHANGE_QUALITY_VIP_GREEN) or not vipData[2] then
			if not isInit then
				_ENV = nil
				_ENV = nil
				;(nil).lv = CHANGE_QUALITY_VIP_GREEN
				;(nil).content = i18n("common_text_2972", nil)
				;(nil).confirmString = i18n("mail_text_67")
				;(nil).confirmFunc = function()
					uiManager:show("vipCenterView")
				end
				uiManager:show("MessageBox", nil)
				setQuality = self.preIndex
				self.fields.List_Tab:setSelectedIndex(self.preIndex)
			end
		elseif not isInit then
			local qName = equipDesRead.getQualityName(setQuality)
			function _ENV()
				uiManager:show("vipCenterView")
			end
			;(function()
				uiManager:show("vipCenterView")
			end).quality = qName
			SoraDShowMsgTip(i18n("common_text_2359", function()
				uiManager:show("vipCenterView")
			end))
			self.fields.List_Tab:setSelectedIndex(1)
			self.preIndex = 1
		end
	elseif setQuality == gQualityDef.BLUE then
		if not (vipData[1] >= CHANGE_QUALITY_VIP_BLUE) or not vipData[2] then
			if not isInit then
				local num, isVip = vipLocalData:getVipNum(CHANGE_QUALITY_VIP_BLUE)
				_ENV = i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end)
				_ENV = i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end)
				i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end).lv = num
				i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end).content = i18n("common_text_4914", i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end))
				i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end).confirmString = i18n("mail_text_67")
				i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end).confirmFunc = function()
					uiManager:show("vipCenterView")
				end
				uiManager:show("MessageBox", i18n("common_text_2359", function()
					uiManager:show("vipCenterView")
				end))
				setQuality = self.preIndex
				self.fields.List_Tab:setSelectedIndex(self.preIndex)
			end
		elseif not isInit then
			local qName = equipDesRead.getQualityName(setQuality)
			_ENV = self.preIndex
			self.preIndex.quality = qName
			SoraDShowMsgTip(i18n("common_text_2359", self.preIndex))
			self.fields.List_Tab:setSelectedIndex(2)
			self.preIndex = 2
		end
	elseif not isInit then
		local qName = equipDesRead.getQualityName(setQuality)
		_ENV = i18n("common_text_2359", self.preIndex)
		i18n("common_text_2359", self.preIndex).quality = qName
		SoraDShowMsgTip(i18n("common_text_2359", i18n("common_text_2359", self.preIndex)))
		self.preIndex = setQuality
	end
	self.fields.Com_main:initData(setQuality)
	_ENV = i18n("common_text_2359", i18n("common_text_2359", self.preIndex))
	i18n("common_text_2359", i18n("common_text_2359", self.preIndex)).byUID = true
	SoraDConfigSet("Game:MaterialFactoryView:materialQuality~integer", setQuality, i18n("common_text_2359", i18n("common_text_2359", self.preIndex)))
end
function MaterialFactoryPanel:updateView(target, data)
	if data.list then
		if data.haveNew then
			stuffWorkshopCtrl:sendGetStuff()
		end
		self.emptyPos = nil
		self.singleData = data.list
		self.speedCount = data.count
		for i = TOTAL_POS + 1, #self.singleData do
			if self.singleData[i] then
				self.singleData[i] = nil
			end
		end
		dump(self.singleData, "singleData")
		self.fields.List:setNumItems(#self.singleData)
		if self.isInit and SoraDFIsRA() then
			self.fields.List:getScrollPane():setPercX(1)
		end
		self.isInit = false
		local queue = queueCtrl:queryQueue(gQueueTypeDef.stuff_workshop)
		if queue then
			self.fields.Button_speed:setVisible(true)
		else
			self.fields.Button_speed:setVisible(false)
		end
	end
end
function MaterialFactoryPanel:onItemRederer(index, target)
	local v = self.singleData[index + 1]
	print("onItemRederer", self.emptyPos, v.type, v.mid, MATERIAL_FACTORY_SCROLL_TYPE_OPEN)
	if self.emptyPos == nil and v.type == MATERIAL_FACTORY_SCROLL_TYPE_OPEN and v.mid == nil then
		self.emptyPos = index + 1
	end
	target:initData(v, index + 1, self.speedCount)
end
function MaterialFactoryPanel:onItemTabRederer(index, target)
	target:setIcon(self.tabList[index + 1])
end
function MaterialFactoryPanel:onClickTabList()
	SoraDPlaySound()
	local index = self.fields.List_Tab:getSelectedIndex()
	if index == 0 then
		self:updateQuality(gQualityDef.WHITE)
	elseif index == 1 then
		self:updateQuality(gQualityDef.GREEN)
	elseif index == 2 then
		self:updateQuality(gQualityDef.BLUE)
	end
end
function MaterialFactoryPanel:onTouchBegin(context)
	context:captureTouch()
end
function MaterialFactoryPanel:onTouchMove(eventContext)
	local nodePoint = eventContext:getInput():getPosition()
	nodePoint = self:globalToLocal(nodePoint)
	local centerPoint = self.fields.Com_main:getPosition()
	if self.touchSprite:isVisible() then
		local isCanRefinery = cc.rectContainsPoint(cc.rect(centerPoint.x - 170, centerPoint.y - 322, 340, 300), nodePoint)
		if self.emptyPos then
			_ENV = nodePoint
			nodePoint.msg = "MESSAGE_UI_MATERIAL_FACTORY_TOUCH_MOVE"
			nodePoint.mid = self.touchMid
			nodePoint.show = isCanRefinery
			nodePoint.pos = self.emptyPos
			SoraDSendMessage(nodePoint)
		end
		self.touchSprite:setPosition(nodePoint)
	end
end
function MaterialFactoryPanel:onTouchEnd(eventContext)
	local nodePoint = eventContext:getInput():getPosition()
	nodePoint = self:globalToLocal(nodePoint)
	local centerPoint = self.fields.Com_main:getPosition()
	if self.touchSprite:isVisible() then
		_ENV = self.touchSprite
		self.touchSprite.msg = "MESSAGE_UI_MATERIAL_FACTORY_TOUCH_CHANGE"
		self.touchSprite.mid = self.touchMid
		self.touchSprite.show = true
		SoraDSendMessage(self.touchSprite)
		self.touchSprite:setVisible(false)
		self.itemTips:setVisible(false)
		local isCanRefinery = cc.rectContainsPoint(cc.rect(centerPoint.x - 170, centerPoint.y - 322, 340, 300), nodePoint)
		if self.emptyPos then
			_ENV = nodePoint
			nodePoint.msg = "MESSAGE_UI_MATERIAL_FACTORY_TOUCH_MOVE"
			nodePoint.mid = self.touchMid
			nodePoint.show = isCanRefinery
			nodePoint.pos = self.emptyPos
			SoraDSendMessage(nodePoint)
		end
		if isCanRefinery then
			if self.emptyPos == nil then
				SoraDPlaySound()
				SoraDShowMsgTip(i18n("common_text_2220"), itemDesRead.getIcon(self.touchMid, true))
			else
				SoraDPlaySound("materialFactory", math.floor(self.touchMid / 10) * 10 + 1)
				stuffWorkshopCtrl:sendRefinery(self.touchMid)
				if SoraDIsGameGuide() ~= nil then
					guideCtrl:CompleteGuideStep(17001)
				end
			end
		end
		self.touchSprite:setPosition(nodePoint)
	end
end
function MaterialFactoryPanel:btnHelpClickCallBack(button, type)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_2360")
	uiManager:show("RuleView", nil)
end
function MaterialFactoryPanel:btnBagClickCallBack(button, type)
	SoraDPlaySound()
	uiManager:show("storageBoxView")
	self:removeFromParent()
end
function MaterialFactoryPanel:btnClickCallBack()
	SoraDPlaySound()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.stuff_workshop)
	if queue and self.singleData and self.singleData[1].mid then
		if self.speedCount > 0 then
			_ENV = nil
			;(nil).count = self.speedCount
			_ENV = "common_text_2045"
			;("common_text_2045").isMaterialFactory = true
			SoraDShowSpeedUpBox(queue, nil, i18n("common_text_2045", nil), "common_text_2045")
		else
			SoraDShowMsgTip(i18n("common_text_2046"))
		end
	end
end
function MaterialFactoryPanel:showGuide()
	self.fields.Effect_Finger:setVisible(true)
	self:createWheelAction()
end
function MaterialFactoryPanel:createWheelAction()
	local endPos = self.fields.Com_main:getPosition()
	local beginPos = cc.p(endPos.x + 226, endPos.y - 71)
	_UPVALUE10_ = endPos.y - 71
	;(endPos.y - 71)[1] = ffa.callFunc(function(...)
		self.fields.Effect_Finger:setPosition(beginPos)
		self.fields.Effect_Finger:setVisible(true)
	end)
	;(endPos.y - 71)[2] = ffa.fadeIn(0.2)
	;(endPos.y - 71)[3] = ffa.scaleTo(0.2, 1.2)
	;(endPos.y - 71)[4] = ffa.scaleTo(0.2, 1)
	;(endPos.y - 71)[5] = ffa.delay(0.5)
	;(endPos.y - 71)[6] = ffa.moveTo(1, endPos.x, endPos.y - 80)
	;(endPos.y - 71)[7] = ffa.delay(0.5)
	;(endPos.y - 71)[8] = ffa.fadeOut(0.5)
	;(endPos.y - 71)[9] = ffa.callFunc(function(...)
		self.fields.Effect_Finger:setVisible(false)
	end)
	;(endPos.y - 71)[10] = ffa.delay(0.5)
	;(endPos.y - 71)[11] = ffa.callFunc(function(...)
		if guideCtrl:isGuideNotCompleted(gGuideModule.MATERIAL_FACTORY) then
			self:createWheelAction()
		else
			guideCtrl = self
			self.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(self)
		end
	end)
	;(endPos.y - 71)[12] = ffa.callFunc(function(...)
		if guideCtrl:isGuideNotCompleted(gGuideModule.MATERIAL_FACTORY) then
			self:createWheelAction()
		else
			guideCtrl = self
			self.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(self)
		end
	end)
	local newAction = ffa.seq(endPos.y - 71)
	self.fields.Effect_Finger:runAction(newAction)
end
function MaterialFactoryPanel:showTouch(target, data)
	if not self.touchSprite:isVisible() then
		self.touchMid = data.data.mid
		self.touchSprite:setURL(itemDesRead.getIcon(self.touchMid))
		self.touchSprite:setVisible(true)
		self.itemTips:setVisible(true)
		local pos = self.fields.Com_main:localToGlobal(data.pos)
		local centerPoint = self.fields.Com_main:getPosition()
		self.touchSprite:setPosition(cc.p(centerPoint.x + data.pos.x - 279, centerPoint.y + data.pos.y - 176))
		local posX = data.pos.x + 100
		if data.pos.x > 279 then
			posX = data.pos.x - 100
		end
		self.itemTips:setPosition(cc.p(posX, data.pos.y + 170))
		self.itemTips:setString(itemDesRead.getName(self.touchMid))
		local time = data.data.time or 0
		self.itemTips:getChild("Text_Des"):setString(SoraDConvertSecondToString(time * stuffWorkshopCtrl:getDiscount()))
		itemDesRead = self.itemTips:getChild("Text_Des")
		self.itemTips:getChild("Text_Des").msg = "MESSAGE_UI_MATERIAL_FACTORY_TOUCH_CHANGE"
		self.itemTips:getChild("Text_Des").mid = self.touchMid
		self.itemTips:getChild("Text_Des").show = false
		SoraDSendMessage((self.itemTips:getChild("Text_Des")))
	end
end
function MaterialFactoryPanel:onHide()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
	SoraDSendMessage(nil)
end
return MaterialFactoryPanel
