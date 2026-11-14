local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local exclusiveVipRead = include("exclusiveVipRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local exclusiveVipViewPanel = class("exclusiveVipViewPanel", baseFguiPanel)
local MAX_AWARD_NUM = 20
function exclusiveVipViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("exclusiveVipViewPanel:ctor", self.viewName)
end
function exclusiveVipViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewServerReturn"
	end
	return self._packageList
end
function exclusiveVipViewPanel:onInit()
	print("=======exclusiveVipViewPanel:onInit")
	self:initControls()
	self:checkButtonState()
	self:initData()
end
function exclusiveVipViewPanel:onShow()
	print("=======exclusiveVipViewPanel:onShow")
end
function exclusiveVipViewPanel:initControls()
	self.fields.Com_title:initData(i18n("privilege_text_06"), handler(self, self.onClickClose))
	_ENV = self.fields.Com_title.initData
	self.fields.Com_title.initData[gExaltedPrivilegeSwitchType.WELFARE] = self.fields.nodeBirthday
	self.fields.Com_title.initData[gExaltedPrivilegeSwitchType.WEEKLY_RECHARGE] = self.fields.nodeWeekly
	self.fields.Com_title.initData[gExaltedPrivilegeSwitchType.PRIVILEGE_PACKAGE] = self.fields.nodePackage
	self.fields.Com_title.initData[gExaltedPrivilegeSwitchType.HISTORY_PAY] = self.fields.nodeHistory
	self.tableMenu, _ENV, self.nodeList, self.fields.Com_title.initData[gExaltedPrivilegeSwitchType.PRIVILEGE] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.nodeVip
	self.curScrollIndex = gExaltedPrivilegeSwitchType.PRIVILEGE
	self.frameInterval = 20
	_ENV = self.fields.nodeVip
	self.fields.nodeVip.byUID = true
	local ret = SoraDConfigGet("Game:exclusiveVipView:firstGuide~bool", self.fields.nodeVip)
	local inputTel = exaltedPrivilegeCtrl:getTelephoneNum()
	if exaltedPrivilegeCtrl:isGotSuperVIP() and ret and inputTel == 0 then
		self.curScrollIndex = gExaltedPrivilegeSwitchType.WELFARE
		self:superVipGuide()
	end
end
function exclusiveVipViewPanel:fitDevice()
end
function exclusiveVipViewPanel:initData()
	for i, v in pairs(self.nodeList) do
		if v:isVisible() then
			v:initData()
		end
	end
	self:updateTabRedDot()
end
function exclusiveVipViewPanel:judge2move(sprite, forward)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveBy(1, forward * 15, 0)
	;(nil)[2] = cca.moveBy(1, -forward * 15, 0)
	;(nil)[3] = cca.moveBy(1, -forward * 15, 0)
	;(nil)[4] = cca.moveBy(1, -forward * 15, 0)
	;(nil)[5] = cca.moveBy(1, -forward * 15, 0)
	local seqList = cca.seq(nil)
	local acList = cc.RepeatForever:create(seqList)
	sprite:runAction(acList)
end
function exclusiveVipViewPanel:checkButtonState()
	self.totalButtonNums = 0
	local privilegeTab = 0
	local historyTab = 0
	local welfareTab = 0
	local giftTab = 0
	local weekTab = 0
	local totalScore = exaltedPrivilegeCtrl:getTotalScores()
	local curPrivilegeList, curSore = exclusiveVipRead:getPrivilegeList(totalScore)
	local totalRecharge = premiumStoreCtrl:getDollor()
	local needWeekGold = exclusiveVipRead:getWeeklyRechargeNeedGold()
	local weekNeedHistoryRechargeGold = exclusiveVipRead:getweeklyHistoryRechargeNeedGold()
	local weekTotalRecharge = exaltedPrivilegeCtrl:getWeekRechargeGold()
	local packageList, isPackageExit = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	premiumStoreCtrl = nil
	;(nil)[1] = packageList
	;(nil)[2] = isPackageExit
	dump(nil, "packageList, isPackageExit")
	local isWeekReach = false
	if totalRecharge >= weekNeedHistoryRechargeGold then
		isWeekReach = true
	end
	if 0 < table.nums(curPrivilegeList) then
		self.totalButtonNums = self.totalButtonNums + 2
		privilegeTab = gExaltedPrivilegeSwitchType.PRIVILEGE
		welfareTab = gExaltedPrivilegeSwitchType.WELFARE
	end
	if isWeekReach then
		self.totalButtonNums = self.totalButtonNums + 1
		weekTab = gExaltedPrivilegeSwitchType.WEEKLY_RECHARGE
	end
	if isPackageExit then
		self.totalButtonNums = self.totalButtonNums + 1
		giftTab = gExaltedPrivilegeSwitchType.PRIVILEGE_PACKAGE
	end
	exaltedPrivilegeCtrl, exaltedPrivilegeCtrl = curPrivilegeList, gExaltedPrivilegeSwitchType
	curPrivilegeList.title = i18n("privilege_text_01")
	exaltedPrivilegeCtrl, gExaltedPrivilegeSwitchType[1], curPrivilegeList.tag = curPrivilegeList, curPrivilegeList, privilegeTab
	exaltedPrivilegeCtrl, gExaltedPrivilegeSwitchType[2], curPrivilegeList.tag = curPrivilegeList, curPrivilegeList, 0
	curPrivilegeList.title = i18n("privilege_text_05")
	exaltedPrivilegeCtrl, gExaltedPrivilegeSwitchType[3], curPrivilegeList.tag = curPrivilegeList, curPrivilegeList, welfareTab
	curPrivilegeList.title = i18n("privilege_text_04")
	exaltedPrivilegeCtrl, gExaltedPrivilegeSwitchType[4], curPrivilegeList.tag = curPrivilegeList, curPrivilegeList, giftTab
	curPrivilegeList.title = i18n("privilege_text_03")
	gExaltedPrivilegeSwitchType[5], curPrivilegeList.tag = curPrivilegeList, weekTab
	local tab = gExaltedPrivilegeSwitchType
	local exaltedPrivilegeCtrl, tabsetArray = curPrivilegeList, curPrivilegeList
	for i, v in ipairs(tab) do
		if v.tag ~= 0 then
			table.insert(tabsetArray, v)
		end
	end
	exaltedPrivilegeCtrl = (for generator)
	ipairs(tab).defaultClick = self.curScrollIndex
	ipairs(tab).tabsetArray = tabsetArray
	local ipairs(tab).callback, param = function(tag)
		self.curScrollIndex = tag
		self:refreshNode()
	end, ipairs(tab)
	self.fields.Com_Tab:initView(param)
	self.tabsetArray = tabsetArray
	self:updateTabRedDot()
	self:refreshNode()
end
function exclusiveVipViewPanel:updateTabRedDot()
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	for i, v in ipairs(self.tabsetArray) do
		local isImgRed = v.tag == gExaltedPrivilegeSwitchType.WELFARE and (table.nums(welfareInfo) > 0 or not exaltedPrivilegeCtrl:hasBirthdayYearSet())
		local isNew = exaltedPrivilegeCtrl:isHavingNewFlagInAnyTab(v.tag)
		self.fields.Com_Tab:setBtnRedDot(i, isImgRed or isNew)
	end
end
function exclusiveVipViewPanel:refreshNode()
	print("self.curScrollIndex===", self.curScrollIndex)
	local tag = self.curScrollIndex
	for k, v in pairs(self.nodeList) do
		v:setVisible(tag == k)
		if tag == k then
			v:initData()
		end
	end
	local isNew = exaltedPrivilegeCtrl:isHavingNewFlagInAnyTab(tag)
	if isNew then
		exaltedPrivilegeCtrl:reqCleanNewFlag(tag)
		SoraDShowLoading(self)
	end
end
function exclusiveVipViewPanel:superVipGuide()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
	;(nil).step = 69001
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:exclusiveVipView:firstGuide~bool", false, nil)
end
function exclusiveVipViewPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.rechargeID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Panel_1)
			self.outAppPurchaseButtons:setPosition(cc.p(290.0, 38))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.Bottom_Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.rechargeID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.rechargeID
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.fields.nodePackage, cc.p(SoraDFPosX(314, 0), 144), 1.0, 4)
	else
		_ENV, _UPVALUE1_ = self.fields.nodePackage, self.outAppPurchaseButtons
		self.fields.nodePackage.rechargeID = self.rechargeID
		self.outAppPurchaseButtons[1] = self.fields.nodePackage
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.fields.nodePackage, cc.p(SoraDFPosX(-205, 0), -385), 1.0, nil, 280)
	end
end
function exclusiveVipViewPanel:purchaseBack()
	SoraDCloseLoading()
	self.fields.nodePackage:purchaseBack()
end
function exclusiveVipViewPanel:gameGuide_getTarget(itemName, parameters)
	if "btnInputTelephone" == itemName then
		return self.fields.nodeBirthday.btnInputTelephone
	end
	if "btnInputBirthday" == itemName then
		return self.fields.nodeBirthday.btnInputBirthday
	end
	return SoraDGetChildByName(self, itemName)
end
return exclusiveVipViewPanel
