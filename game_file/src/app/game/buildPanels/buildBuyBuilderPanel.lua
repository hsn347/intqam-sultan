local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local BuildBuyBuilderPanel = class("buildBuyBuilderPanel", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("buildBuyBuilderPanel")
	end
	return target
end)
function BuildBuyBuilderPanel:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.btnBuyBuilder = SoraDGetChildByName(self, "CCS_commonItemUse_buy")
	self.nodeGold = SoraDGetChildByName(self, "Node_gold")
	self.labelGold = SoraDGetChildByName(self, "Text_gold")
	self.labelMsg = SoraDGetChildByName(self, "Text_msg")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.btn_tool = SoraDGetChildByName(self, "Button_useTool")
	self.btn_tool:setVisible(false)
	self.Node_check = SoraDGetChildByName(self, "Node_check")
	if self.Node_check then
		self.Node_check:setVisible(false)
	end
	self.timer = nil
	self.callBackHandle = nil
	self.buildTime = nil
	self.builderCount = 1
	self.labelTitle:setString(i18n("common_text_843"))
	self.btnBuyBuilder:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btn_tool:addTouchEventListener(handler(self, self.btnToolCallBack))
	self:setCloseCallBack(handler(self, self.exitView))
	SoraDAddMessage(self, "MESSAGE_BUILDER_OPEN", function(...)
		if not tolua.isnull(self) then
			if self.timer then
				SoraDManagerRemoveTimer(self, self.timer)
				self.timer = nil
			end
			self:exitView(MSGBOX_CALLBACK_YES)
			self:removeFromParent()
		end
	end)
	self:checkTools()
end
function BuildBuyBuilderPanel:initData(buildTime)
	self.buildTime = buildTime
	self:openTimeUp()
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
end
function BuildBuyBuilderPanel:checkTools()
	local itemId = 500501
	local itemCount = backpackCtrl:getItemCount(itemId)
	if 0 < itemCount then
		self.btn_tool:setVisible(true)
		self.btn_tool:setTitleText(i18n("common_text_3527"))
		if SoraDFIsRA() then
			self.btn_tool:setPositionX(-120)
			self.btnBuyBuilder:setPositionX(120)
		else
			self.btn_tool:setPositionX(120)
			self.btnBuyBuilder:setPositionX(-120)
		end
	else
		self.btn_tool:setVisible(false)
		self.btn_tool:setPositionX(0)
		self.btnBuyBuilder:setPositionX(0)
	end
end
function BuildBuyBuilderPanel:btnToolCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local itemId = 500501
		local itemCount = backpackCtrl:getItemCount(itemId)
		if 0 < itemCount then
			_ENV, _ENV = nil, nil
			;(nil).id = itemId
			;(nil).count = itemCount
			;(nil).itemData, (nil).bestNum = nil, math.min(math.ceil(self.buildTime / 28800), itemCount)
			uiManager:show("newItemSingleUse", nil)
		end
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		self:close(button, event)
	end
end
function BuildBuyBuilderPanel:openTimeUp(dt)
	local buildchargequeue = cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue)
	local leftTime = buildchargequeue and buildchargequeue.timerNode.timer:getRemainTime() or 0
	self.builderCount = math.ceil((self.buildTime - leftTime) / 172800)
	if 0 < leftTime then
		cityCtrl = nil
		;(nil).day = self.builderCount * 2
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.labelMsg:setString(i18n("common_text_861", nil))
	else
		cityCtrl = i18n("common_text_861", nil)
		i18n("common_text_861", nil).day = self.builderCount * 2
		i18n("common_text_861", nil).gold = self.builderCount * gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
		self.labelMsg:setString(i18n("common_text_842", i18n("common_text_861", nil)))
	end
	self.labelGold:setString(string.formatnumberthousands(self.builderCount * gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD))
	SoraDToCenter(self.nodeGold)
	if leftTime <= 0 and self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function BuildBuyBuilderPanel:setHandle(handle)
	self.callBackHandle = handle
end
function BuildBuyBuilderPanel:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended and SoraDEnoughGold(self.builderCount * gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD) then
		SoraDPlaySound()
		gametop.playertop_:getModule("cityCtrl"):openChargeQueueReq(self.builderCount)
		SoraDShowLoading(self)
	end
end
function BuildBuyBuilderPanel:exitView(exitType)
	if self.callBackHandle then
		self.callBackHandle(exitType)
	end
end
return BuildBuyBuilderPanel
