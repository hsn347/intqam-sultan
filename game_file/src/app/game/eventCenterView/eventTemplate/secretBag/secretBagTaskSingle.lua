local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local secretBagCtrl = gametop.playertop_:getModule("secretBagCtrl")
local publicRead = include("publicRead")
local secretBagTaskSingle = class("secretBagTaskSingle", function(target)
	local targetType = type(target)
	if targetType == "userdata" then
		target = SoraDCreateCloneBasePanel(target, "secretBagTaskSingle")
		target:setAnchorPoint(cc.p(0.5, 1))
		return target
	end
	return target
end)
function secretBagTaskSingle:ctor()
	self.useOcx, _ENV, self.unusedOcx, _ENV = nil, nil, nil, nil
	self.mainBtn = SoraDGetChildByName(self, "btn_operate")
	self.mainBtn:addTouchEventListener(handler(self, self.singleBtnClick))
	self.btnGoto = SoraDGetChildByName(self, "btn_goto")
	self.btnGoto:addTouchEventListener(handler(self, self.singleBtnGotoClick))
	self.btnGoto:setTitleText(i18n("common_text_477"))
	SoraChangeButtonImage(self.btnGoto, "btn_blue_small_01.png")
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.nodeTotalDay = SoraDGetChildByName(self, "Node_totalDay")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
	self.nodeItem:setVisible(false)
end
function secretBagTaskSingle:initData(data)
	self.singleData = data
	local group = activityShowCtrl:getParamByID(gActivityTimeActivityID.KITS_ACTIVITY).classtype or 1
	self.taskData = secretBagCtrl.localClass.getTaskData(self.singleData.taskId, group)
	self:initView()
end
function secretBagTaskSingle:initView(...)
	if not self.textProgress then
		self.textProgress = HtmlRichText:create("", "", 20)
		self.textProgress:setTextHorizontalAlignment(SoraDFLabelL())
		self.textProgress:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		self.textProgress:setTextColor(cc.c3b(255, 255, 255))
		self.textProgress:setIsHtml(true)
		self.textProgress:setAnchorPoint(SoraDFAP(cc.p(0, 0.5)))
		self.textProgress:addTo(self.nodeProgress)
		self.textTotal = HtmlRichText:create("", "", 20)
		self.textTotal:setTextHorizontalAlignment(SoraDFLabelL())
		self.textTotal:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		self.textTotal:setTextColor(cc.c3b(255, 255, 255))
		self.textTotal:setIsHtml(true)
		self.textTotal:setAnchorPoint(SoraDFAP(cc.p(1, 0.5)))
		self.textTotal:addTo(self.nodeTotalDay)
	end
	local str = ""
	local finishNum = self.singleData.finishCount
	if self.singleData.finishCount >= self.taskData.amount then
		finishNum = self.taskData.amount
		_ENV = "common_text_3780"
		;("common_text_3780").color = "#a79681"
		_ENV = finishNum
		finishNum.color = "#fbbe02"
		_ENV = string.formatnumberthousands(self.taskData.amount)
		string.formatnumberthousands(self.taskData.amount).color = "#a79681"
		str = SoraDWrapHtmlTagByStyle(i18n("common_text_3780"), "common_text_3780") .. SoraDWrapHtmlTagByStyle(string.formatnumberthousands(finishNum), finishNum) .. SoraDWrapHtmlTagByStyle("/" .. string.formatnumberthousands(self.taskData.amount), (string.formatnumberthousands(self.taskData.amount)))
	else
		_ENV = "common_text_3780"
		;("common_text_3780").color = "#a79681"
		_ENV = self.singleData.finishCount
		self.singleData.finishCount.color = "#bc282d"
		_ENV = string.formatnumberthousands(self.taskData.amount)
		string.formatnumberthousands(self.taskData.amount).color = "#a79681"
		str = SoraDWrapHtmlTagByStyle(i18n("common_text_3780"), "common_text_3780") .. SoraDWrapHtmlTagByStyle(string.formatnumberthousands(self.singleData.finishCount), self.singleData.finishCount) .. SoraDWrapHtmlTagByStyle("/" .. string.formatnumberthousands(self.taskData.amount), (string.formatnumberthousands(self.taskData.amount)))
	end
	self.textProgress:setString(str)
	if SoraDFIsRA() then
		_ENV = str
		_ENV, _ENV, str.num = self.taskData.amount, string.formatnumberthousands(self.taskData.amount), string.formatnumberthousands(self.taskData.amount)
		_ENV, string.formatnumberthousands(self.taskData.amount).num, self.taskData.amount.color = self.taskData.amount, self.taskData.amount, "#f4ba05"
		string.formatnumberthousands(self.taskData.amount).__default, self.taskData.amount.color = self.taskData.amount, "#a79681"
		_ENV = str
		str.param = "#frame_lace_09_01.png"
		str.name = "icon"
		str.width = 32
		str.height = 32
		str.custom = "Sprite"
		str.offsety = 10
		str.scale = 1.0
		local str1 = i18n_html(self.taskData.taskcontent, str, (string.formatnumberthousands(self.taskData.amount))) .. SoraDWrapReplaceTag(str)
		self.textTotal:setString(str1)
	else
		_ENV = self.textTotal.setString
		self.textTotal.setString.param = "#frame_lace_09_01.png"
		self.textTotal.setString.name = "icon"
		self.textTotal.setString.width = 32
		self.textTotal.setString.height = 32
		self.textTotal.setString.custom = "Sprite"
		self.textTotal.setString.offsety = 10
		self.textTotal.setString.scale = 1.0
		_ENV = str1
		_ENV, _ENV, str1.num = self.taskData.amount, string.formatnumberthousands(self.taskData.amount), string.formatnumberthousands(self.taskData.amount)
		_ENV, string.formatnumberthousands(self.taskData.amount).num, self.taskData.amount.color = self.taskData.amount, self.taskData.amount, "#f4ba05"
		string.formatnumberthousands(self.taskData.amount).__default, self.taskData.amount.color = self.taskData.amount, "#a79681"
		local str1 = SoraDWrapReplaceTag(self.textTotal.setString) .. i18n_html(self.taskData.taskcontent, str1, (string.formatnumberthousands(self.taskData.amount)))
		self.textTotal:setString(str1)
	end
	self:cleanItems()
	_UPVALUE2_ = self.textTotal
	self.textTotal[1] = "id"
	self.textTotal[2] = "count"
	local itemList = serviceFunctions.tableFormat(self.taskData.award, self.textTotal)
	for i, v in ipairs(itemList) do
		local item = self:getItem()
		item:setPosition(SoraDFPosX(600 - (i - 1) * 75 - 37.5, 620), 40)
		item:setScale(0.7)
		item:setBaseScale(1.0)
		item:setOwnView(self.fNode)
		item:initData(v.id, tostring(v.count))
	end
	if self.singleData.receive then
		self.mainBtn:setVisible(true)
		self.btnGoto:setVisible(false)
		self.mainBtn:setBright(false)
		self.mainBtn:setTitleText(i18n("common_text_1892"))
	elseif self.singleData.finishCount >= self.taskData.amount then
		self.mainBtn:setVisible(true)
		self.btnGoto:setVisible(false)
		self.mainBtn:setBright(true)
		self.mainBtn:setTitleText(i18n("common_text_1146"))
	else
		self.mainBtn:setVisible(false)
		if secretBagCtrl.localClass.checkToDo(self.singleData.taskId) then
			self.btnGoto:setVisible(true)
		else
			self.btnGoto:setVisible(false)
		end
	end
end
function secretBagTaskSingle:setFather(node)
	self.fNode = node
end
function secretBagTaskSingle:setScroll(scroll)
	self.scroll = scroll
end
function secretBagTaskSingle:cleanItems(...)
	for i, v in ipairs(self.useOcx) do
		v:setVisible(false)
		table.insert(self.unusedOcx, v)
	end
	self.useOcx, _ENV = ipairs(self.useOcx)
end
function secretBagTaskSingle:getItem(...)
	local item
	if next(self.unusedOcx) then
		item = table.remove(self.unusedOcx)
	else
		item = include("commonItemAward").new()
		item:addTo(self)
	end
	table.insert(self.useOcx, item)
	item:setVisible(true)
	return item
end
function secretBagTaskSingle:singleBtnClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.singleData.receive then
			SoraDShowMsgTip(i18n("common_text_1892"))
		elseif self.singleData.finishCount >= self.taskData.amount then
			SoraDShowLoading(self.fNode)
			secretBagCtrl:gainReward(self.singleData.taskId)
		end
	end
end
function secretBagTaskSingle:singleBtnGotoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		secretBagCtrl.localClass.jumpToDo(self.singleData.taskId)
	end
end
return secretBagTaskSingle
