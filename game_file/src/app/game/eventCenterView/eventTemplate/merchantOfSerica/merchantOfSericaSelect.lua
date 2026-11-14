local merchantOfSericaCtrl = SoraDGetCtrl("merchantOfSericaCtrl")
local merchantOfSericaSelect = class("merchantOfSericaSelect", function(target)
	if target == nil then
		target = "Node_Serica_Select"
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(getCCSPath(target))
	end
	return target
end)
_ENV = "merchantOfSericaSelect"
;("merchantOfSericaSelect").minbgW = 200
;("merchantOfSericaSelect").minbgH = 112
;("merchantOfSericaSelect").deltaLong = 0.3
local ("merchantOfSericaSelect").menuOffsetY, _defaultParam = 10, "merchantOfSericaSelect"
local longActTag = 100
function merchantOfSericaSelect:ctor()
	self.offsetX = 0
	self.maxNum = 4
	self.leftNum = self.maxNum
	self.CCS_commonItemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.Button_item = SoraDGetChildByName(self, "Button_item")
	self.Node_7 = SoraDGetChildByName(self, "Node_7")
	self.Text_num = SoraDGetChildByName(self.Node_7, "Text_num")
	self.Node_particle = SoraDGetChildByName(self.CCS_commonItemAward, "Node_particle")
	SoraDStopEffectNode(self.Node_particle)
	self.CCS_commonItemAward:setVisible(false)
	self.Button_item:addTouchEventListener(handler(self, self.onTouchBg))
	self.Button_item:setTouchEnabled(false)
end
function merchantOfSericaSelect:initWithData(data)
	local flag = merchantOfSericaCtrl:getServerFlag()
	self.CCS_commonItemAward:setColor(flag and cc.c3b(77, 77, 77) or cc.c3b(255, 255, 255))
	self.commodityID = data.data.commodityID
	self.itemId = data.data.prop[1]
	self.itemNum = data.data.prop[2]
	self.pView = data.view
	self.CCS_commonItemAward:setTouchEnabled(false)
	self.CCS_commonItemAward:setVisible(true)
	self:changeNum()
	self.CCS_commonItemAward:initData(self.itemId, self.itemNum)
	self.Button_item:setTouchEnabled(true)
end
function merchantOfSericaSelect:changeNum()
	local num = merchantOfSericaCtrl:getTotalSelect(self.itemId)
	local flag = merchantOfSericaCtrl:getServerFlag()
	if not flag then
		num = merchantOfSericaCtrl:getTotalSelect(self.itemId)
	else
		num = merchantOfSericaCtrl:getTotalGet(self.commodityID)
	end
	self.leftNum = self.maxNum - num
	self.Text_num:setString(tostring(self.leftNum))
	self.Text_num:setColor(cc.c3b(255, 165, 0))
	if self.leftNum == 0 then
		self.Text_num:setColor(cc.c3b(255, 0, 0))
		self.CCS_commonItemAward:setColor(cc.c3b(77, 77, 77))
		self.CCS_commonItemAward:hideCoolSquare()
	else
		self.CCS_commonItemAward:showNewCoolSquare()
	end
end
function merchantOfSericaSelect:onTouchBg(target, event)
	if event == ccui.TouchEventType.began then
		self.tBegin = SoraDGetSocketTime()
		_defaultParam = nil
		;(nil)[1] = cca.delay(_defaultParam.deltaLong)
		;(nil)[2] = cca.callFunc(function()
			self:OnBtnLongClick(target)
		end)
		;(nil)[3] = cca.callFunc(function()
			self:OnBtnLongClick(target)
		end)
		local seqLong = cca.seq(nil)
		seqLong:setTag(longActTag)
		self:runAction(seqLong)
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		else
		end
		goto lbl_51
		::lbl_51::
		self:stopActionByTag(longActTag)
		self.tEnd = SoraDGetSocketTime()
		local dt = self.tEnd - self.tBegin
		local isLongClick = dt > _defaultParam.deltaLong
		if isLongClick then
			if self.pFloor then
				self.pFloor:setVisible(false)
			end
		else
			SoraDPlaySound()
			self:OnBtnClick()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
		end
	elseif event == ccui.TouchEventType.canceled then
		self:stopActionByTag(longActTag)
		self.singleIsMoved = false
		if self.pFloor then
			self.pFloor:setVisible(false)
		end
	end
end
function merchantOfSericaSelect:OnBtnLongClick(target)
	print("长按", self.itemId)
	SoraDPlaySound()
	self:showTips(target)
end
function merchantOfSericaSelect:OnBtnClick()
	SoraDPlaySound()
	local flag = merchantOfSericaCtrl:getServerFlag()
	if flag then
		return false
	end
	local list = merchantOfSericaCtrl:getSelectList()
	if not list or not list then
		list, _ENV = merchantOfSericaCtrl, merchantOfSericaCtrl
	end
	if self.leftNum > 0 and #list < 4 then
		if self.itemId and self.commodityID then
			merchantOfSericaCtrl:setSelectList(self.itemId, self.commodityID)
			self:changeNum()
		end
	elseif #list == 4 then
		SoraDShowMsgTip(i18n("serica_text_05"))
	else
		SoraDShowMsgTip(i18n("notice_0120"))
	end
end
function merchantOfSericaSelect:showTips(target)
	local parent = self.pView
	if not self.pFloor then
		print("创建！！！！！！！！")
		self.pFloor = SoraDCreatePanel("commonItemTips")
		self.pFloor:addTo(parent or self, 99)
		self.pFloor:initData(self.itemId)
		local pos = cc.p(0, 0)
		local height = 0
		if parent then
			pos = parent:convertToNodeSpace(target:getTouchBeganPosition())
			height = parent:getContentSize().height
			local containerSize = parent:getContentSize()
			local size = self.pFloor:getBgSize()
			pos.x = SoraDFIsRA() and math.min(math.max(pos.x + 0.5 * size.width, size.width + self.offsetX), containerSize.width - self.offsetX) or math.max(self.offsetX, math.min(pos.x - 0.5 * size.width, containerSize.width - size.width - self.offsetX))
			pos.y = math.max(math.min(pos.y + size.height, height), size.height)
		end
		self.pFloor:setPosition(pos)
	else
		self.pFloor:setVisible(true)
	end
end
return merchantOfSericaSelect
