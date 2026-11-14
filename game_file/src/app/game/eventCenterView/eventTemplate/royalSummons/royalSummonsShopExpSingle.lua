local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local scrollNode = include("scrollNode")
local royalSummonsShopExpSingle = class("royalSummonsShopExpSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("royalSummonsShopExpSingle")
	end
	return target
end)
function royalSummonsShopExpSingle:ctor()
	self.textLimit = SoraDGetChildByName(self, "text_limit")
	self.textDes = SoraDGetChildByName(self, "text_des")
	local nodeItem = SoraDGetChildByName(self, "nodeItem")
	self.commonItemNode = include("commonItemAward").new(nodeItem)
	self.Button_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_gold")
	if self.Button_buy then
		self.Button_buy = scrollNode.new(self.Button_buy)
		_ENV = "CCS_commonGoldSmallBtn_gold"
		;("CCS_commonGoldSmallBtn_gold").title = i18n("common_text_4436")
		self.Button_buy:initData("CCS_commonGoldSmallBtn_gold", 1)
		self.Button_buy:addTouchEventListener(handler(self, self.onClick_btnBuy))
		self.Button_buy:setSwallowTouches(false)
	end
end
function royalSummonsShopExpSingle:initData(data)
	self.data = data
	local itemdata = self.data.itemdata
	local exp = itemdata.exp[2] or 0
	self.commonItemNode:initData(itemdata.exp[1], exp)
	self.Button_buy:setGoldText(string.formatnumberthousands(itemdata.coin[2]))
	local expStr = string.formatnumberthousands(exp)
	_ENV = royalSummonsCtrl
	royalSummonsCtrl.num = expStr
	self.textDes:setString(i18n(royalSummonsCtrl:getClassType() == 1 and "item_name_97" or "item_des_422603", royalSummonsCtrl))
	local lv = royalSummonsCtrl:getLevelAddExp(exp)
	local awardCur = royalSummonsCtrl:getAwardNum()
	local awardAdd = royalSummonsCtrl:getAwardNum(nil, lv)
	_ENV = i18n(royalSummonsCtrl:getClassType() == 1 and "item_name_97" or "item_des_422603", royalSummonsCtrl)
	i18n(royalSummonsCtrl:getClassType() == 1 and "item_name_97" or "item_des_422603", royalSummonsCtrl).exp = expStr
	i18n(royalSummonsCtrl:getClassType() == 1 and "item_name_97" or "item_des_422603", royalSummonsCtrl).lv = lv
	i18n(royalSummonsCtrl:getClassType() == 1 and "item_name_97" or "item_des_422603", royalSummonsCtrl).num = math.max(0, awardAdd - awardCur)
	self.textLimit:setString(i18n("summoned_text_49", i18n(royalSummonsCtrl:getClassType() == 1 and "item_name_97" or "item_des_422603", royalSummonsCtrl)))
end
function royalSummonsShopExpSingle:onClick_btnBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local coint = self.data.itemdata.coin[2]
		if SoraDEnoughGold(coint) then
			SoraDShowMsgBox(i18n("circus_text_26"), i18n("common_text_204"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					self:sureBuy(1)
				end
			end)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function royalSummonsShopExpSingle:setHandle(handle)
	self.handle = handle
end
function royalSummonsShopExpSingle:setScroll(scroll)
	self.scroll = scroll
	self.Button_buy:setScroll(scroll)
	self.commonItemNode:setOwnScroll(scroll)
end
function royalSummonsShopExpSingle:setView(view)
	self.commonItemNode:setOwnView(view)
end
function royalSummonsShopExpSingle:setParentView(parentView)
	self.parentView = parentView
end
function royalSummonsShopExpSingle:sureBuy(num)
	print("选择了数量:", num)
	royalSummonsCtrl:reqActivityBuyExp(self.data.itemdata.shopID, num)
	if self.parentView then
		self.parentView:showLoading()
	end
end
return royalSummonsShopExpSingle
