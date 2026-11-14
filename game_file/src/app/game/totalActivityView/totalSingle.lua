local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
local MAX_ITEM_SHOW = 8
local totalSingle = class("totalSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("totalSingle")
	end
	return target
end)
function totalSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.Node_keyPoint = SoraDGetChildByName(self, "Node_keyPoint")
	self.Node_keyPoint:setVisible(false)
	self.Text_cur = SoraDGetChildByName(self, "Text_cur")
	self.Text_target = SoraDGetChildByName(self, "Text_target")
	self.Image_shade = SoraDGetChildByName(self, "Image_shade")
	self.Image_shade:setVisible(false)
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setVisible(false)
	self.Button_go:addTouchEventListener(handler(self, self.btnGoCallBack))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Node_complete = SoraDGetChildByName(self, "Node_complete")
	self.Text_complete = SoraDGetChildByName(self, "Text_complete")
	self.Text_complete:setString(i18n("common_text_1892"))
	self.Node_complete:setVisible(false)
end
function totalSingle:initData(data, otherData)
	self.singleData = data
	self:setScroll(otherData and otherData.scroll)
	self.view = otherData.view
	self:setCumuType(otherData and otherData.cumuType)
	local isNeedSortPos = false
	local keypoint = self.singleData.keypoint or 0
	self.Node_keyPoint:setVisible(tonumber(keypoint) == 1)
	local desMsg = self.aType and "common_text_4409" or "return_text_21"
	_ENV = keypoint
	_ENV, _ENV, keypoint.num = self.singleData.amount, string.formatnumberthousands(self.singleData.amount), string.formatnumberthousands(self.singleData.amount)
	self.singleData.amount.color = "#ffff00"
	_ENV, string.formatnumberthousands(self.singleData.amount).num, self.singleData.amount.i = self.singleData.amount, self.singleData.amount, "true"
	string.formatnumberthousands(self.singleData.amount).__default, self.singleData.amount.color = self.singleData.amount, "#c8aa96"
	local str = i18n_html(desMsg, keypoint, (string.formatnumberthousands(self.singleData.amount)))
	if not self.textRichDes then
		_ENV = keypoint
		keypoint.anchor = SoraDFAP(1, 0.5)
		keypoint.pos = cc.p(SoraDFPosX(590), 227)
		keypoint.fontSize = 18
		self.textRichDes = SoraDCreateHtmlRichText(keypoint)
		self.textRichDes:addTo(self, 2)
	end
	self.textRichDes:setString(str)
	local curAmount = cumuActiveCtrl:getCumuAmount(otherData.activityID)
	self.Text_cur:setString(string.formatnumberthousands(curAmount))
	self.Text_target:setString("/" .. string.formatnumberthousands(self.singleData.amount))
	self.Text_cur:setColor(curAmount < self.singleData.amount and cc.c3b(190, 40, 40) or cc.c3b(200, 170, 150))
	if SoraDFIsRA() then
		self.Text_cur:setPositionX(self.Text_target:getPositionX() - self.Text_target:getContentSize().width)
	else
		self.Text_target:setPositionX(self.Text_cur:getPositionX() + self.Text_cur:getContentSize().width)
	end
	self.Button_go:setVisible(curAmount < self.singleData.amount)
	self.Node_complete:setVisible(curAmount >= self.singleData.amount)
	self.Image_shade:setVisible(curAmount >= self.singleData.amount)
	MAX_ITEM_SHOW = curAmount >= self.singleData.amount
	;(curAmount >= self.singleData.amount)[1] = "id"
	;(curAmount >= self.singleData.amount)[2] = "count"
	local award = serviceFunctions.tableFormat(self.singleData.reward, curAmount >= self.singleData.amount)
	for k, v in ipairs(award) do
		if k <= MAX_ITEM_SHOW then
			if not self.itemArray[k] then
				local item = include("commonItemAward").new()
				item:setScale(0.9)
				item:setBaseScale(1.0)
				item:setOwnView(self.view)
				item:setOwnScroll(self.scroll)
				item:addTo(self.Node_items)
				self.itemArray[k] = item
				isNeedSortPos = true
			else
				self.itemArray[k]:setVisible(true)
			end
			self.itemArray[k]:initData(v.id, v.count)
		else
			break
		end
	end
	if #self.itemArray > #award then
		for k = #self.itemArray, #award + 1, -1 do
			self.itemArray[k]:setVisible(false)
		end
	end
	if isNeedSortPos then
		SoraDautoSortPos(self.Node_items, 4, SoraDFIsRA() and 2 or 0, cc.size(100, 100))
	end
end
function totalSingle:setCumuType(cumuType)
	self.cumuType = cumuType
	self.aType = self.cumuType % 2 == 1
end
function totalSingle:setScroll(scroll)
	self.scroll = scroll
end
function totalSingle:btnGoCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.aType then
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
		else
			_ENV = nil
			;(nil).type = 1
			uiManager:show("bagView", nil)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return totalSingle
