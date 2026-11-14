local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CoffeeCraftsmanActivityPanel = class("CoffeeCraftsmanActivityPanel", baseFguiPanel)
function CoffeeCraftsmanActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function CoffeeCraftsmanActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function CoffeeCraftsmanActivityPanel:onInit()
	self.fields.Com_title:initData(i18n("activity_name_9001352"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.text_activity_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.text_activity_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_607", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		_ENV = handler(self, self.onClickHelp)
		handler(self, self.onClickHelp).time = SoraDConvertSecondToString(leftTime)
		self.text_activity_time:setString(i18n("common_text_607", handler(self, self.onClickHelp)))
		self.text_activity_time:beginTime(leftTime)
	end
	self.coffeeItems, _ENV = timer.timerNode.timer:getRemainTime(), leftTime
	for i = 1, 4 do
		table.insert(self.coffeeItems, self.fields.List_coffee:getChildAt(i - 1))
	end
	self.fields.Button_awardPreview:setString(i18n("decrypt_text_03"))
	self.fields.Button_shop:setString(i18n("worldboss_monkey_03"))
	self.fields.Button_bakeOne:setString(i18n("coffeeCraftsman_text_05"))
	self.fields.Button_bakeTen:setString(i18n("coffeeCraftsman_text_09"))
	self.fields.Button_awardPreview:addClickListener(handler(self, self.onClickAwardPreview))
	self.fields.Button_shop:addClickListener(handler(self, self.onClickShop))
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
	self.fields.Button_bakeOne:addClickListener(handler(self, self.onClickBackOne))
	self.fields.Button_bakeTen:addClickListener(handler(self, self.onClickBackTen))
	self.fields.Usm_lamp:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_smoke:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_stove:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Button_pool:addClickListener(handler(self, self.onClickPool))
	local height = self.fields.Bg_bottom:getHeight()
	if self.view:getHeight() > 1306 then
		self.fields.Bg_bottom:setHeight(self.view:getHeight() - 1306 + height)
	end
	local showMan = display.width / display.height <= 0.6666666666666666
	self.fields.Icon_man:setVisible(showMan)
	self.fields.Com_leg:setVisible(showMan)
	if showMan then
		local size = self.fields.Icon_man:getSize()
		local contentSize = self.fields.Icon_man:getContentSize()
		local scale = math.min(size.width / contentSize.width, size.height / contentSize.height)
		self.fields.Com_leg:setScale(scale, scale)
	else
		local scale = 0.6666666666666666 / (display.width / display.height) * 1
		print("table=======", scale, self.fields.Bg_table:getHeight() * scale)
		self.fields.Bg_table:setHeight(self.fields.Bg_table:getHeight() * scale)
	end
end
function CoffeeCraftsmanActivityPanel:onClickPool()
	SoraDPlaySound()
	uiManager:show("CoffeeCraftsmanPool")
	if coffeeCraftsmanCtrl:getPoolGuide() then
		coffeeCraftsmanCtrl:setPoolGuide()
		self:updatePoolGuide()
	end
end
function CoffeeCraftsmanActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("coffeeCraftsman_text_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function CoffeeCraftsmanActivityPanel:onClickAwardPreview()
	SoraDPlaySound()
	uiManager:show("CoffeeCraftsmanPreview")
end
function CoffeeCraftsmanActivityPanel:onClickShop()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN, true) then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN)
	end
end
function CoffeeCraftsmanActivityPanel:onClickAdd()
	SoraDPlaySound()
	uiManager:show("CoffeeCraftsmanSpoon")
end
function CoffeeCraftsmanActivityPanel:onClickBackOne()
	SoraDPlaySound()
	print("onClickOne")
	local leftCount = coffeeCraftsmanCtrl:getLeftDrawCount()
	if leftCount <= 0 then
		SoraDShowMsgTip(i18n("coffeeCraftsman_text_06"))
		return
	end
	local oneCost = coffeeCraftsmanCtrl:getBakeOnceGold()
	if not SoraDEnoughGold(oneCost) then
		return
	end
	if 0 < oneCost then
		if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanBake) then
			_ENV = i18n("coffeeCraftsman_text_06")
			_ENV = i18n("coffeeCraftsman_text_06")
			i18n("coffeeCraftsman_text_06").var1 = oneCost
			i18n("coffeeCraftsman_text_06").var2 = 1
			i18n("coffeeCraftsman_text_06").content = i18n("coffeeCraftsman_text_29", i18n("coffeeCraftsman_text_06"))
			i18n("coffeeCraftsman_text_06").confirmFunc = function()
				self:bakeOne()
			end
			i18n("coffeeCraftsman_text_06").remindString = i18n("coffeeCraftsman_text_27")
			i18n("coffeeCraftsman_text_06").remindFunc = function(value)
				if value then
					dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanBake)
				end
			end
			uiManager:show("MessageBox", i18n("coffeeCraftsman_text_06")):setOwnerKey(self)
		else
			self:bakeOne()
		end
	else
		self:bakeOne()
	end
end
function CoffeeCraftsmanActivityPanel:bakeOne()
	local isSpecialCoffeeFull = coffeeCraftsmanCtrl:isSpecialCoffeeFull()
	if isSpecialCoffeeFull then
		coffeeCraftsmanCtrl = nil
		;(nil).content = i18n("coffeeCraftsman_text_07")
		;(nil).confirmFunc = function()
			coffeeCraftsmanCtrl:reqDraw(false)
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
		return
	end
	coffeeCraftsmanCtrl:reqDraw(false)
end
function CoffeeCraftsmanActivityPanel:onClickBackTen()
	SoraDPlaySound()
	print("onClickTen")
	local leftCount = coffeeCraftsmanCtrl:getLeftDrawCount()
	if leftCount <= 0 then
		SoraDShowMsgTip(i18n("coffeeCraftsman_text_06"))
		return
	end
	if leftCount < 10 then
		_ENV = i18n("coffeeCraftsman_text_06")
		i18n("coffeeCraftsman_text_06").var = leftCount
		SoraDShowMsgTip(i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")))
		return
	end
	local oneCost = coffeeCraftsmanCtrl:getBakeTenGold()
	if not SoraDEnoughGold(oneCost) then
		return
	end
	if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanBakeTen) then
		_ENV = i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06"))
		_ENV = i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06"))
		i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")).var1 = oneCost
		i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")).var2 = 10
		i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")).content = i18n("coffeeCraftsman_text_29", i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")))
		i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")).confirmFunc = function()
			self:bakeTen()
		end
		i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")).remindString = i18n("coffeeCraftsman_text_27")
		i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06")).remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanBakeTen)
			end
		end
		uiManager:show("MessageBox", i18n("coffeeCraftsman_text_10", i18n("coffeeCraftsman_text_06"))):setOwnerKey(self)
	else
		self:bakeTen()
	end
end
function CoffeeCraftsmanActivityPanel:bakeTen()
	local isSpecialCoffeeFull = coffeeCraftsmanCtrl:isSpecialCoffeeFull()
	if isSpecialCoffeeFull then
		coffeeCraftsmanCtrl = nil
		;(nil).content = i18n("coffeeCraftsman_text_07")
		;(nil).confirmFunc = function()
			coffeeCraftsmanCtrl:reqDraw(true)
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
		return
	end
	coffeeCraftsmanCtrl:reqDraw(true)
end
function CoffeeCraftsmanActivityPanel:onShow()
	if coffeeCraftsmanCtrl:getGroup() == -1 then
		coffeeCraftsmanCtrl:reqInit()
	else
		self:updateView()
	end
end
function CoffeeCraftsmanActivityPanel:updatePoolGuide()
	self.fields.Button_pool:updateGuide()
end
function CoffeeCraftsmanActivityPanel:onTimeout(index)
	self.coffeeItems[index]:showDisappearEffect()
end
function CoffeeCraftsmanActivityPanel:onBake(data)
	local specialList = data.data.specialList
	local rewards = data.data.rewards
	local diff = data.diff
	dump(diff, "onBake===", 10)
	for _, v in ipairs(diff) do
		self.coffeeItems[v]:setShowFlag(true)
	end
	self.fields.Usm_smoke:play(false)
	for i = #specialList, 1, -1 do
		local pool = specialList[i]
		_ENV = nil
		;(nil).icon = coffeeCraftsmanRead:getCoffeeSmallIcon(pool)
		;(nil).quality = 5
		;(nil).num = 1
		;(nil).effect = true
		;(nil).name = i18n(coffeeCraftsmanRead:getCoffeeName(pool))
		;(nil).tip = i18n(coffeeCraftsmanRead:getCoffeeTip(pool))
		table.insert(rewards, 1, nil)
	end
	self.fireEffectShowed = false
	fguiHelper.showRewardList(rewards, self)
	self.fireEffectShowed = true
	self:updateCount()
end
function CoffeeCraftsmanActivityPanel:onIntoPanel()
	print("onIntoPanel", self.viewName)
	if self.fireEffectShowed then
		print("show effect", self.viewName)
		for i = 1, 4 do
			self.coffeeItems[i]:showAppearEffect()
		end
	end
end
function CoffeeCraftsmanActivityPanel:updateView()
	self:updatePoolGuide()
	self:updateCoffee()
	self:updateCount()
	self:updateBtnPool()
end
function CoffeeCraftsmanActivityPanel:updateBtnPool()
	self.fields.Button_pool:initData()
end
function CoffeeCraftsmanActivityPanel:updateCoffee()
	for i = 1, 4 do
		self.coffeeItems[i]:initData(i)
	end
end
function CoffeeCraftsmanActivityPanel:updateCoffeeCount()
	for i = 1, 4 do
		self.coffeeItems[i]:updateCount()
	end
end
function CoffeeCraftsmanActivityPanel:updateCount()
	local spoonCount = backpackCtrl:getItemCount(coffeeCraftsmanCtrl.SPOON_ID)
	self.fields.Text_num:setString(string.formatnumberthousands(spoonCount))
	local leftNum = coffeeCraftsmanCtrl:getLeftDrawCount()
	backpackCtrl = string.formatnumberthousands(spoonCount)
	string.formatnumberthousands(spoonCount).var = string.formatnumberthousands(leftNum)
	self.fields.Text_leftTime:setString(i18n("coffeeCraftsman_text_11", string.formatnumberthousands(spoonCount)))
	self.controllers.Ctrl_enough:setSelectedIndex(0 < leftNum and 0 or 1)
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	local isFree = coffeeCraftsmanCtrl:isFree()
	local oneCost = coffeeCraftsmanCtrl:getBakeOnceGold()
	local tenCost = coffeeCraftsmanCtrl:getBakeTenGold()
	self.fields.Button_bakeOne:setCostNum(oneCost, haveGold)
	self.fields.Button_bakeOne:setReddot(isFree)
	self.fields.Button_bakeTen:setCostNum(tenCost, haveGold)
end
return CoffeeCraftsmanActivityPanel
