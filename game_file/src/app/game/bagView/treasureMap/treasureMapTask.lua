local collectSalaryRead = include("collectSalaryRead")
local itemDesRead = include("itemDesRead")
local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local treasureMapTask = class("treasureMapTask", function(target)
	return target or SoraDCreateTouchPanel("treasureMapTask")
end)
_ENV = "treasureMapTask"
;("treasureMapTask").NOTBIND = 1
local ("treasureMapTask").BINDTASK, ItemStatus = 2, "treasureMapTask"
function treasureMapTask:ctor()
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.boxBg:setTitleName(i18n("treasuremap_text_15"))
	self.imageLast = SoraDGetChildByName(self, "Image_LastInfo")
	self.textItemName = SoraDGetChildByName(self, "Text_ItemName")
	self.bindNode = SoraDGetChildByName(self, "Node_BindTask")
	self.noBindNode = SoraDGetChildByName(self, "Node_NoBindTask")
	self.textRedWarning = SoraDGetChildByName(self.bindNode, "Text_BindTask")
	self.textTips = SoraDGetChildByName(self.bindNode, "Text_Tips")
	self.textPos = SoraDGetChildByName(self.bindNode, "Text_Position")
	self.textPos = SoraDChangeTextToHtml(self.textPos)
	self.textLeftTime = SoraDGetChildByName(self.bindNode, "Text_LeftTime")
	self.timerLabel = SoraDGetExtendChildFromCCSByName(self.bindNode, "CCS_timerLabelActivity_cooling")
	self.btnGoWorld = SoraDGetChildByName(self.bindNode, "Button_Dig")
	self.btnGoWorld:setTitleText(i18n("AncienTreasure_btn_08"))
	self.btnGoWorld:setSwallowTouches(false)
	self.btnGoWorld:addTouchEventListener(handler(self, self.btnClickGoWorld))
	self.textExplainUp = SoraDGetChildByName(self.noBindNode, "Text_Explain_Up")
	self.textExplainDown = SoraDGetChildByName(self.noBindNode, "Text_Explain_Down")
	self.textOpenTime = SoraDGetChildByName(self.noBindNode, "Text_OpenTime")
	self.textBlessOpenTime = SoraDGetChildByName(self.noBindNode, "Text_OpenTime_0")
	self.textBtn = SoraDGetChildByName(self.noBindNode, "Text_title")
	self.textGold = SoraDGetChildByName(self.noBindNode, "Text_gold")
	self.btnBlessOpen = SoraDGetExtendChildFromCCSByName(self.noBindNode, "CCS_commonGoldNormalBtn")
	self.btnBlessOpen:setTag(1)
	self.btnBlessOpen:addTouchEventListener(handler(self, self.btnClickOpenTask))
	self.btnOpen = SoraDGetChildByName(self.noBindNode, "Button_Open")
	self.btnOpen:setTag(2)
	self.btnOpen:setTitleText(i18n("common_text_246"))
	self.btnOpen:addTouchEventListener(handler(self, self.btnClickOpenTask))
end
function treasureMapTask:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.showSuccessView))
end
function treasureMapTask:showSuccessView(target, data)
	if data.subMsg == "showOpenSuccess" then
		SoraDCloseLoading(self)
		local panel = SoraDCreatePanel("treasureMapRqSuccess")
		panel:initData(2, self.itemID)
		panel:show()
		self:close(self, ccui.TouchEventType.ended)
	end
end
function treasureMapTask:initData(itemID, mapTaskInfo)
	self.itemID = itemID
	self.itemStatus = mapTaskInfo.dataFromItem.isInUseLimitedItem and ItemStatus.BINDTASK or ItemStatus.NOTBIND
	self.itemLimitedTime = mapTaskInfo.dataFromItem.isInUseLimitedItem or mapTaskInfo.dataFromItem.isLimitedItem
	self.textItemName:setString(itemDesRead.getName(self.itemID))
	self.textItemName:setColor(itemDesRead.getColor(self.itemID))
	self.bindNode:setVisible(self.itemStatus == ItemStatus.BINDTASK)
	self.noBindNode:setVisible(self.itemStatus == ItemStatus.NOTBIND)
	if self.itemStatus == ItemStatus.BINDTASK then
		self:initBindNode()
	else
		self:initNoBindNode()
	end
end
function treasureMapTask:initBindNode()
	print("itemLimitedTime", self.itemLimitedTime)
	self.imageLast:setScale(3)
	_ENV = nil
	;(nil)[1] = cca.scaleTo(0.1, 1)
	;(nil)[2] = cca.scaleTo(0.1, 1)
	;(nil)[3] = cca.scaleTo(0.1, 1)
	;(nil)[4] = cca.scaleTo(0.1, 1)
	self.imageLast:runAction(cca.seq(nil))
	self.taskInfo = collectSalaryCtrl:getTaskInfo(self.itemID, self.itemLimitedTime)
	self.textTips:setString(i18n("treasuremap_text_21"))
	_ENV = i18n("treasuremap_text_21")
	_ENV, _ENV, i18n("treasuremap_text_21").name = (self.taskInfo.x or 1) - 1, "(" .. (self.taskInfo.x or 1) - 1 .. "," .. (self.taskInfo.y or 1) - 1 .. ")", "(" .. (self.taskInfo.x or 1) - 1 .. "," .. (self.taskInfo.y or 1) - 1 .. ")"
	;(self.taskInfo.x or 1) - 1.color = "#FFC864"
	;(self.taskInfo.x or 1) - 1.u = "true"
	;(self.taskInfo.x or 1) - 1.c = "true"
	;("(" .. (self.taskInfo.x or 1) - 1 .. "," .. (self.taskInfo.y or 1) - 1 .. ")").name, (self.taskInfo.x or 1) - 1.name = (self.taskInfo.x or 1) - 1, "posXY"
	str = i18n_html("common_text_035", i18n("treasuremap_text_21"))
	self.textPos:setString(str)
	self.textPos:setTouchEnabled(true)
	self.textPos:addTouchEventListener(handler(self, self.btnClickText))
	self.timerLabel:beginTime(self.itemLimitedTime - serviceFunctions.systemTime())
	self.textLeftTime:setString(i18n("treasuremap_text_22"))
	self.textRedWarning:setString(i18n("complete_text_02"))
end
function treasureMapTask:initNoBindNode()
	self.textExplainUp:setString(i18n("treasuremap_dec_01"))
	local limitTime = collectSalaryRead.getPropertyByID(self.itemID, "limitTime")
	_ENV = i18n("treasuremap_dec_01")
	i18n("treasuremap_dec_01").num = limitTime / 60
	self.textExplainDown:setString(i18n("treasuremap_text_16", i18n("treasuremap_dec_01")))
	local excavateTime = collectSalaryRead.getPropertyByID(self.itemID, "excavateTime")
	_ENV = i18n("treasuremap_text_16", i18n("treasuremap_dec_01"))
	i18n("treasuremap_text_16", i18n("treasuremap_dec_01")).num = excavateTime / 60
	self.textOpenTime:setString(i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01"))))
	local wishTime = collectSalaryRead.getPropertyByID(self.itemID, "wishTime")
	_ENV = i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01")))
	i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01"))).num = wishTime / 60
	self.textBlessOpenTime:setString(i18n("treasuremap_text_18", i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01")))))
	local wishGold = collectSalaryRead.getPropertyByID(self.itemID, "wishGold")
	_ENV = i18n("treasuremap_text_18", i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01"))))
	i18n("treasuremap_text_18", i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01")))).title = i18n("treasuremap_text_19")
	i18n("treasuremap_text_18", i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01")))).gold = wishGold
	self.btnBlessOpen:initData(i18n("treasuremap_text_18", i18n("treasuremap_text_17", i18n("treasuremap_text_16", i18n("treasuremap_dec_01")))))
	self.btnBlessOpen:setTextGoldColor(SoraDEnoughGold(wishGold, true) and COLOR3.YELLOW or display.COLOR_RED)
end
function treasureMapTask:btnClickGoWorld(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(cc.p((self.taskInfo.x or 1) - 1, (self.taskInfo.y or 1) - 1), true)
		SoraDRemoveAllPanelFromManager()
	end
end
function treasureMapTask:btnClickOpenTask(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		if tag ~= 1 or SoraDEnoughGold(collectSalaryRead.getPropertyByID(self.itemID, "wishGold")) then
			_ENV = collectSalaryRead.getPropertyByID(self.itemID, "wishGold")
			collectSalaryRead.getPropertyByID(self.itemID, "wishGold").isWish = tag == 1
			collectSalaryRead.getPropertyByID(self.itemID, "wishGold").itemID = self.itemID
			collectSalaryRead.getPropertyByID(self.itemID, "wishGold").createTime = self.itemLimitedTime
			collectSalaryCtrl:reqGetBeginTaskData(collectSalaryRead.getPropertyByID(self.itemID, "wishGold"))
		end
	end
end
function treasureMapTask:btnClickText(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local metaInfo = button:getTouchMetaInfo(button:getTouchEndPosition())
		if metaInfo and metaInfo.name == "posXY" then
			SoraDGotoWorldMapPoint(cc.p((self.taskInfo.x or 1) - 1, (self.taskInfo.y or 1) - 1), true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return treasureMapTask
