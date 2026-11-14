local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubeGetTreasurePanel = class("StarEnergyCubeGetTreasurePanel", baseFguiPanel)
function StarEnergyCubeGetTreasurePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyCubeGetTreasurePanel:ctor", self.viewName)
end
function StarEnergyCubeGetTreasurePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarEnergyCubeGetTreasurePanel:onInit()
	print("=======StarEnergyCubeGetTreasurePanel:onInit")
	self.functionCol = self:initFunc()
	self.buyItemID = constantRead.getConstValue("STAR_CUBE_TICKET_ID", 833001)
	self.totalFreeTimes = constantRead.getConstValue("STAR_CUBE_FREE_COUNT", 1)
	self.buyTimesPrice = constantRead.getConstValue("STAR_CUBE_PRICE", 1000)
	self.buyLimitTime = constantRead.getConstValue("STAR_CUBE_TICKET_LIMIT", 1)
	self.fields.Com_title:initData(i18n("activity_name_9001446"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.title:setString(i18n("Martial_arts_text_11"))
	self.fields.Button_refresh:setTitleText(i18n("common_text_911"))
	self.fields.Label_ownNum:getChild("Button_add"):addClickListener(handler(self, self.onClickBuy))
	self.fields.Label_ownNum:setIcon(publicRead.getIcon(self.buyItemID))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClickRefresh))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemInfo))
	self.fields.List_info:setItemRenderer(handler(self, self.onItemRendererInfo))
end
function StarEnergyCubeGetTreasurePanel:initData(itemID)
	self.itemID = itemID or self.itemID
	self.fields.icon:setURL(publicRead.getIcon(self.itemID))
	self.data = starCubeCtrl:getTargetListInfo()
	self.openTime = self:updateItem()
	self.fields.List_info:setNumItems(table.nums(self.data))
end
function StarEnergyCubeGetTreasurePanel:updateItem()
	local remainTimes = starCubeCtrl:getTodayRemainTimes()
	local ticketCount = backpackCtrl:getItemCount(self.buyItemID)
	self.fields.Label_ownNum:fixChildrenPos()
	if 0 < remainTimes then
		self.fields.Label_ownNum:getController("c1"):setSelectedIndex(0)
		self.fields.Label_ownNum:setString(i18n("star_cube_13"))
		self.fields.Label_ownNum:getChild("Text_num"):setString(remainTimes)
	else
		starCubeCtrl = i18n("star_cube_13")
		i18n("star_cube_13").num = ticketCount
		self.fields.Label_ownNum:setString(i18n("Martial_arts_text_43", i18n("star_cube_13")))
		local text = self.fields.Label_ownNum:getChild("title")
		self.fields.Label_ownNum:getController("c1"):setSelectedIndex(1)
		self.fields.Label_ownNum:getChild("title"):setPositionX(self.fields.Label_ownNum:getWidth() / 2)
	end
	return 0 < remainTimes and remainTimes or ticketCount
end
function StarEnergyCubeGetTreasurePanel:updateGetBtnState()
	local remainTimes = starCubeCtrl:getTodayRemainTimes()
	local ticketCount = backpackCtrl:getItemCount(self.buyItemID)
	local openTime = 0 < remainTimes and remainTimes or ticketCount
	local num = self.fields.List_info:getNumItems()
	for i = 1, num do
		self.fields.List_info:getChildAt(i - 1):updateGetBtnState(openTime)
	end
end
function StarEnergyCubeGetTreasurePanel:onItemRendererInfo(index, object)
	self.data[index + 1].itemID = self.itemID
	self.data[index + 1].openTime = self.openTime
	object:initData(index + 1, self.data[index + 1], handler(self, self.onClickSnatch))
end
function StarEnergyCubeGetTreasurePanel:onPressItemInfo(button, startPos, endPos)
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = self.itemID
	;(nil).num = 1
	;(nil).pos = startPos
	;(nil).customName = nil
	;(nil).customTip = nil
	SoraDSendMessage(nil)
end
function StarEnergyCubeGetTreasurePanel:onClickSnatch(target, targetID, itemID)
	SoraDPlaySound()
	local remainTimes = starCubeCtrl:getTodayRemainTimes()
	local ticketCount = backpackCtrl:getItemCount(self.buyItemID)
	if 0 < remainTimes or 0 < ticketCount then
		SoraDPlaySound()
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		_ENV = nil
		;(nil).isStarEnergyCube = true
		;(nil).targetID = targetID
		;(nil).itemID = itemID
		dispatchPanel:initData(nil)
	else
		self:onClickBuy()
	end
end
function StarEnergyCubeGetTreasurePanel:refreshView(data)
	if not data then
		return self:initData()
	end
	self.rewards = data.reward
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function StarEnergyCubeGetTreasurePanel:initFunc()
	_ENV = nil
	;(nil).initData = function()
		self:initData(self.itemID)
	end
	;(nil).snatchSuccess = function()
		if self.keyID then
			self:close()
			return
		else
			self = nil
			;(nil).reward = self.rewards
			;(nil).isWin = true
			;(nil).keyID = self.keyID
			uiManager:show("StarEnergyCubeBattle", nil):setOwnerKey(self)
		end
		self.keyID = nil
	end
	;(nil).snatchFail = function()
		_ENV = nil
		;(nil).reward = self.rewards
		;(nil).isWin = false
		;(nil).keyID = self.keyID
		uiManager:show("StarEnergyCubeBattle", nil):setOwnerKey(self)
	end
	;(nil).times = function()
		self:updateItem()
	end
	local (nil).refreshTarget, functionCol = function()
		self:initData(self.itemID)
	end, nil
	return functionCol
end
function StarEnergyCubeGetTreasurePanel:onClickRefresh()
	SoraDPlaySound()
	starCubeCtrl:reqStarCubeRefresh()
end
function StarEnergyCubeGetTreasurePanel:onClickBuy()
	SoraDPlaySound()
	local ownGold = lordInfoCtrl:getBaseInfo().gold
	dump(starCubeCtrl:getHadBuyTicketTimes(), "Fjksdjfkdjfk")
	local leftTime = self.buyLimitTime - starCubeCtrl:getHadBuyTicketTimes()
	local timesLimit = math.min(leftTime, 10, math.max(1, math.floor(ownGold / self.buyTimesPrice)))
	if leftTime == 0 then
		SoraDShowMsgTip(i18n("star_cube_14"))
		return
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.targetID = self.buyItemID
	SoraDShowMsgTip.exchangeID = 1001
	SoraDShowMsgTip.singCount = self.buyTimesPrice
	SoraDShowMsgTip.curNum = timesLimit
	SoraDShowMsgTip.huntCount = 10
	SoraDShowMsgTip.singleGet = 1
	SoraDShowMsgTip.ownText = true
	function SoraDShowMsgTip.exchangeHandler(buyCount)
		if SoraDEnoughGold(buyCount * self.buyTimesPrice) then
			starCubeCtrl:reqStarCubeTimes(buyCount)
		end
	end
	SoraDShowMsgTip.panelFixFlag = true
	local SoraDShowMsgTip.inputFixFlag, param = true, SoraDShowMsgTip
	uiManager:show("ShopSingleBuy", param):setOwnerKey(self)
end
function StarEnergyCubeGetTreasurePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("star_cube_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function StarEnergyCubeGetTreasurePanel:onShow()
	print("=======StarEnergyCubeGetTreasurePanel:onShow")
	self:initData(self.proxy.param.itemID)
end
return StarEnergyCubeGetTreasurePanel
