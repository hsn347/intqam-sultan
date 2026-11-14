local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local itemDesRead = include("itemDesRead")
local allianceltCtrl = include("allianceltCtrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local AllianceShopSingle = class("allianceShopSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceShopSingle")
	end
	return target
end)
function AllianceShopSingle:ctor()
	self.curType = gIDDef.ALLIANCE_HONOR
	self.panelFloor = SoraDGetChildByName(self, "Panel_floor")
	self.panelFloor:setSwallowTouches(false)
	self.nodeItemLeft = SoraDGetChildByName(self, "Node_item_left")
	self.nodeItemRight = SoraDGetChildByName(self, "Node_item_right")
	self.topLine = SoraDGetChildByName(self, "frame_line_top")
	self.topLine:setVisible(false)
	self.scroll = nil
	self.handle = nil
	self.singleIsMoved = false
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.updatePoint))
end
function AllianceShopSingle:setItemData(target, data)
	local imgBase = SoraDGetChildByName(target, "frame_item_base")
	local imgItem = SoraDGetChildByName(target, "Image_item")
	local labName = SoraDGetChildByName(target, "Text_name")
	local labNum = SoraDGetChildByName(target, "Text_num")
	local nodeNum = SoraDGetChildByName(target, "Node_num")
	local nodePoint = SoraDGetChildByName(target, "Node_point")
	local iconPoint = SoraDGetChildByName(target, "icon_point")
	local labPoint = SoraDGetChildByName(target, "Text_point")
	local labTitle = SoraDGetChildByName(target, "Text_title")
	local btnBuy = SoraDGetChildByName(target, "Button_buy")
	local btnReturn = SoraDGetChildByName(target, "Button_return")
	local Button_notice = SoraDGetChildByName(target, "Button_notice")
	local icon_shalou = SoraDGetChildByName(target, "icon_shalou")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	btnReturn:setVisible(ownRank >= gAllianceRank.R4 and self.curType == gIDDef.ALLIANCE_HONOR)
	btnReturn:addTouchEventListener(handler(self, self.btnReturnGoodsClick))
	btnReturn.data = data
	Button_notice:setVisible(false)
	icon_shalou:setVisible(false)
	if data.endtime then
		Button_notice:setVisible(true)
		icon_shalou:setVisible(true)
		btnReturn:setSwallowTouches(true)
	else
		btnReturn:setSwallowTouches(false)
	end
	Button_notice:setSwallowTouches(false)
	Button_notice.endtime = data.endtime
	Button_notice:addTouchEventListener(handler(self, self.btnNoticeClick))
	local pay = allianceltCtrl.getPrice(data.itemID, self.curType)
	local count = data.itemCount or 1
	local endtime = data.endtime
	btnBuy.pay = pay
	if self.curType == gIDDef.ALLIANCE_HONOR then
		nodeNum:setVisible(true)
		_ENV, _ENV = nodeNum, nodeNum.setVisible
		nodeNum.itemID = data.itemID
		nodeNum.itemCount = count
		nodeNum.setVisible.itemData, nodeNum.pay = nodeNum, pay
		nodeNum.setVisible.totalPoint = self.totalPoint
		btnBuy.data, nodeNum.setVisible.endtime = nodeNum.setVisible, endtime
	else
		nodeNum:setVisible(false)
		_ENV, _ENV = nodeNum, nodeNum.setVisible
		nodeNum.itemID = data.itemID
		nodeNum.setVisible.itemData, nodeNum.pay = nodeNum, pay
		nodeNum.setVisible.totalPoint = self.totalPoint
		btnBuy.data, nodeNum.setVisible.endtime = nodeNum.setVisible, endtime
	end
	btnBuy:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
				print("node is not on view")
				return
			end
			if self.singleIsMoved then
				self.singleIsMoved = false
				return
			end
			SoraDPlaySound()
			self:showMessage(button)
		elseif type == ccui.TouchEventType.moved then
			local touchBeganPoint = button:getTouchBeganPosition()
			local touchmovePoint = button:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				self.singleIsMoved = true
			end
		elseif type == ccui.TouchEventType.canceled then
			self.singleIsMoved = false
		end
	end)
	btnBuy:setSwallowTouches(false)
	imgBase:setSpriteFrame(publicRead.getBg(data.itemID))
	imgItem:loadTexture(publicRead.getIcon(data.itemID), ccui.TextureResType.plistType)
	labName:setString(publicRead.getName(data.itemID))
	labNum:setString(string.formatnumberthousands(count))
	if self.curType == gIDDef.ALLIANCE_HONOR then
		iconPoint:setSpriteFrame("icon_alliance_honor.png")
		labTitle:setString(i18n("common_text_1889"))
	else
		iconPoint:setSpriteFrame("icon_alliance_point.png")
		labTitle:setString(i18n("common_text_4290"))
	end
	labPoint:setString(string.formatnumberthousands(pay))
end
function AllianceShopSingle:setTopLineVisible(isVisible)
	self.topLine:setVisible(isVisible)
end
function AllianceShopSingle:initData(curType, dataL, dataR)
	self.curType = curType
	self:updatePoint()
	if dataL then
		self:setItemData(self.nodeItemLeft, dataL)
	else
		self.nodeItemLeft:setVisible(false)
	end
	if dataR then
		self:setItemData(self.nodeItemRight, dataR)
	else
		self.nodeItemRight:setVisible(false)
	end
end
function AllianceShopSingle:updatePoint()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.totalPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	else
		self.totalPoint = allianceMgr:getAllianceProperty("bonus")
	end
end
function AllianceShopSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceShopSingle:setHandle(handle)
	self.handle = handle
end
function AllianceShopSingle:showMessage(target)
	if self.curType == gIDDef.ALLIANCE_HONOR then
		local itemID = target.data.itemData.itemID
		local personalLimit = allianceltCtrl:getMaxBuyCount(itemID)
		local cMember = memberMgr:getOwnMember()
		local aStoreBuyInfo = cMember:getProperty("aStoreBuyInfo")
		local buyCount = aStoreBuyInfo[tostring(itemID)] and aStoreBuyInfo[tostring(itemID)].count or 0
		local lastBuyTime = aStoreBuyInfo[tostring(itemID)] and aStoreBuyInfo[tostring(itemID)].time or 0
		if personalLimit and serviceFunctions.isSameDay(lastBuyTime) and personalLimit - buyCount <= 0 then
			SoraDShowMsgTip(i18n("opt_package_text_11"))
			return
		end
		if self.totalPoint >= target.pay then
			self:showBuyView(target)
		else
			SoraDShowMsgBox(i18n("notice_0085"), i18n("common_text_1684"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					SoraDCreatePanel("allianceScienceView"):show()
				end
			end)
		end
	elseif memberMgr:getOwnMember():getProperty("rank") < gAllianceRank.R4 then
		SoraDShowMsgTip(i18n("common_text_661"), "#icon_alliance_point.png", target)
	elseif self.totalPoint >= target.pay then
		self:showBuyView(target)
	else
		SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				SoraDCreatePanel("allianceScienceView"):show()
			end
		end)
	end
end
function AllianceShopSingle:showBuyView(target)
	local allianceShopSingleBuy = SoraDCreatePanel("allianceShopSingleBuy")
	allianceShopSingleBuy:initData(target.data, self.curType)
	if target.data.endtime then
		allianceShopSingleBuy:setLimited(target.data.endtime)
	end
	allianceShopSingleBuy:show()
	allianceShopSingleBuy:setHandle(handler(self, self.sureBuy))
	allianceShopSingleBuy:setActionData(self:convertToWorldSpace(cc.p(target:getPositionX(), target:getPositionY())))
end
function AllianceShopSingle:sureBuy()
	if self.handle then
		self.handle()
	end
	if self.scroll then
		SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	end
end
function AllianceShopSingle:btnReturnGoodsClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank < gAllianceRank.R4 then
			SoraDShowMsgTip(i18n("alliance_store_returns_description_5"))
			return
		end
		local cdValue = constantRead.getConstValue("ALLIANCE_RETURN_CD")
		local lastTime = ownmember:getProperty("lastReturnGoodsTime") or 0
		if lastTime + cdValue > serviceFunctions.systemTime() then
			_ENV = i18n("alliance_store_returns_description_5")
			i18n("alliance_store_returns_description_5").var = math.ceil((lastTime + cdValue - serviceFunctions.systemTime()) / 60)
			SoraDShowMsgTip(i18n("alliance_store_returns_description_6", i18n("alliance_store_returns_description_5")))
		else
			print("显示退货框")
			local allianceShopReturnGoodsView = SoraDCreatePanel("allianceShopReturnGoodsView")
			allianceShopReturnGoodsView:initData(target.data)
			allianceShopReturnGoodsView:show()
			allianceShopReturnGoodsView:setActionData(self:convertToWorldSpace(cc.p(target:getPositionX(), target:getPositionY())))
		end
	end
end
function AllianceShopSingle:btnNoticeClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceShopLimitedView")
		panel:setTime(target.endtime)
		panel:show()
	end
end
return AllianceShopSingle
