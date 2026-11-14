local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local starGiftCtrl = SoraDGetCtrl("starGiftCtrl")
local starGiftRead = include("starGiftRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarGiftPanel = class("StarGiftPanel", baseFguiPanel)
function StarGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarGiftPanel:ctor", self.viewName)
end
function StarGiftPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "StarEnergyCube"
		self._packageList, self._packageList[2] = self._packageList, "NebulaTreasureA"
		self._packageList, self._packageList[3] = self._packageList, "StarryNightCarnival"
	end
	return self._packageList
end
function StarGiftPanel:onInit()
	print("=======StarGiftPanel:onInit")
	starGiftCtrl:sendReqInitDataMsg()
	_ENV, _ENV = starGiftCtrl, starGiftCtrl.sendReqInitDataMsg
	starGiftCtrl.icon = "frame_xclh_lv_guan.png"
	starGiftCtrl.iconOpen = "frame_xclh_lv_kai.png"
	starGiftCtrl.ani = "bx_1"
	starGiftCtrl.x = 162
	starGiftCtrl.y = 167
	starGiftCtrl.des = "celebrationgift_text_2"
	starGiftCtrl.scale = 1
	_ENV, starGiftCtrl.sendReqInitDataMsg[1], starGiftCtrl.openScale = starGiftCtrl, starGiftCtrl, 1.1
	starGiftCtrl.icon = "frame_xclh_lan_guan.png"
	starGiftCtrl.iconOpen = "frame_xclh_lan_kai.png"
	starGiftCtrl.ani = "bx_0"
	starGiftCtrl.x = 162
	starGiftCtrl.y = 167
	starGiftCtrl.des = "celebrationgift_text_3"
	starGiftCtrl.scale = 1
	_ENV, starGiftCtrl.sendReqInitDataMsg[2], starGiftCtrl.openScale = starGiftCtrl, starGiftCtrl, 1.2
	starGiftCtrl.icon = "frame_xclh_zi_guan.png"
	starGiftCtrl.iconOpen = "frame_xclh_zi_kai.png"
	starGiftCtrl.ani = "bx_2"
	starGiftCtrl.x = 162
	starGiftCtrl.y = 165
	starGiftCtrl.des = "celebrationgift_text_4"
	starGiftCtrl.scale = 1
	_ENV, starGiftCtrl.sendReqInitDataMsg[3], starGiftCtrl.openScale = starGiftCtrl, starGiftCtrl, 1
	starGiftCtrl.icon = "frame_xclh_cheng_guan.png"
	starGiftCtrl.iconOpen = "frame_xclh_cheng_kai.png"
	starGiftCtrl.ani = "bx"
	starGiftCtrl.x = 162
	starGiftCtrl.y = 167
	starGiftCtrl.des = "celebrationgift_text_5"
	starGiftCtrl.scale = 1
	self.boxConfig, starGiftCtrl.sendReqInitDataMsg[4], starGiftCtrl.openScale = starGiftCtrl.sendReqInitDataMsg, starGiftCtrl, 1
	self.activityID = gActivityTimeActivityID.STARS_GIFT_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001455"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tipNo:setString(i18n("celebrationgift_text_11"))
	self:adjustTextTipNo()
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.List_box:setItemRenderer(handler(self, self.onItemRedererBox))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRedererReward))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_buyOAP:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_get:setTitleText(i18n("common_text_1146"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function StarGiftPanel:initData()
	self.giftConfig = starGiftRead.getGiftConfig(starGiftCtrl:getType(), starGiftCtrl:getOpenLv())
	for i, v in ipairs(self.giftConfig) do
		local count = 0
		for j = 1, 5 do
			if v["reward" .. j] and next(v["reward" .. j]) then
				count = count + 1
			end
		end
		v.max = count
	end
	for i, v in ipairs(self.boxConfig) do
		v.rid = self.giftConfig[i].recharge
	end
	if not self.first then
		self.selectIndex = starGiftCtrl:getDefaultIndex(table.nums(self.giftConfig))
		self.first = true
	end
	self.fields.List_box:setNumItems(table.nums(self.giftConfig))
	self.fields.List_box:setSelectedIndex(self.selectIndex - 1)
	self:initPage()
end
function StarGiftPanel:refreshPageInZero()
	starGiftCtrl:sendReqInitDataMsg()
end
function StarGiftPanel:initPage(index)
	self.selectIndex = index or self.selectIndex
	self.reward, _ENV, self.configs = self.giftConfig[self.selectIndex], self.giftConfig[self.selectIndex], self.giftConfig[self.selectIndex]
	for i = 1, 5 do
		if self.configs["reward" .. i] and next(self.configs["reward" .. i]) then
			table.insert(self.reward, self.configs["reward" .. i])
		end
	end
	if self.reward and next(self.reward) then
		self.fields.List_reward:setNumItems(table.nums(self.reward))
		self.fields.List_reward:scrollToView(starGiftCtrl:scorllToViewIndex(self.configs.recharge, table.nums(self.reward)))
	end
	self.fields.Text_box:setString(i18n(self.boxConfig[self.selectIndex].des))
	self.buyState = starGiftCtrl:getDayRewardState(self.configs.recharge, table.nums(self.reward), self.selectIndex)
	self.controllers.hadBought:setSelectedIndex(self.buyState - 1)
	if self.buyState == 1 then
		self:updateBuyButton()
	end
	if self.buyState == 5 then
		self.fields.Text_tip:setString(i18n("Loudlydressed_text_11"))
	elseif self.selectIndex > 1 then
		_ENV = i18n("Loudlydressed_text_11")
		i18n("Loudlydressed_text_11").name = i18n(self.boxConfig[self.selectIndex - 1].des)
		self.fields.Text_tip:setString(i18n("celebrationgift_text_8", i18n("Loudlydressed_text_11")))
	end
	self:adjustTextTip()
	self.fields.Button_get:setGrayed(self.buyState == 3)
	self.fields.Button_get:setTouchable(self.buyState ~= 3)
	if self.buyState == 3 then
		self:setBtnTime()
	else
		self:stopBtnTime()
		self.fields.Button_get:setTitleText(i18n("common_text_1146"))
	end
	self:updateBigBox()
end
function StarGiftPanel:adjustTextTip()
	if self.fields.Text_tip:getWidth() > self:getWidth() * 0.8 then
		self.fields.Text_tip:setAutoSize(fgui.AutoSizeType.SHRINK)
		self.fields.Text_tip:setWidth(self:getWidth() * 0.8)
	else
		self.fields.Text_tip:setAutoSize(fgui.AutoSizeType.BOTH)
	end
end
function StarGiftPanel:adjustTextTipNo()
	if self.fields.Text_tipNo:getWidth() > self:getWidth() * 0.8 then
		self.fields.Text_tipNo:setAutoSize(fgui.AutoSizeType.HEIGHT)
		self.fields.Text_tipNo:setWidth(self:getWidth() * 0.8)
	else
		self.fields.Text_tipNo:setAutoSize(fgui.AutoSizeType.BOTH)
	end
end
function StarGiftPanel:updateBigBox(index)
	local state = starGiftCtrl:getBoxState(self.selectIndex, self.giftConfig[self.selectIndex].recharge, self.giftConfig[self.selectIndex].max)
	self.fields.Com_box:setIcon(self.boxConfig[self.selectIndex].icon)
	self.fields.Com_box:getChild("Effect_1"):setEffectPath(self.boxConfig[self.selectIndex].ani)
	self.fields.Com_box:getChild("Effect_1"):setPosition(cc.p(self.boxConfig[self.selectIndex].x, self.boxConfig[self.selectIndex].y))
	self.fields.Com_box:getController("c1"):setSelectedIndex(state - 1)
	if state == 3 then
		self.fields.Com_box:setIcon(self.boxConfig[self.selectIndex].iconOpen)
	end
end
function StarGiftPanel:setBtnTime()
	if not self.txt_time then
		local txt_time = self.fields.Button_get:getChild("title")
		txt_time = SoraDCreateTimerLabel(self, txt_time)
		txt_time:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).time = strTime
			return i18n("celebrationgift_text_9", nil)
		end)
		self.txt_time = txt_time
	end
	local leftTime = serviceFunctions.getTodayRemainTime()
	self.txt_time:beginTime(leftTime)
	self.txt_time:setTimeEndListener(function()
		self:initPage()
	end)
end
function StarGiftPanel:stopBtnTime()
	if self.txt_time then
		self.txt_time:removeTime()
	end
end
function StarGiftPanel:onItemRedererBox(index, object)
	object:initData(index + 1, self.boxConfig[index + 1], starGiftCtrl:getBoxState(index + 1, self.giftConfig[index + 1].recharge, self.giftConfig[index + 1].max), handler(self, self.initPage))
end
function StarGiftPanel:onItemRedererReward(index, object)
	object:initData(index + 1, self.reward[index + 1], starGiftCtrl:getRewardState(self.configs.recharge, index + 1))
end
function StarGiftPanel:updateBuyButton()
	self.fields.Button_buyOAP:initData(nil, nil, self.configs.recharge)
	local nowPrice = paymentManager.judgePrice(self.configs.recharge, self.configs.price)
	self.fields.Button_buy:initData(nowPrice, nil, self.configs.recharge)
end
function StarGiftPanel:popReward(data)
	dump(data, "Fkldkfld")
	dump(self.boxConfig, "fkdlfkldkl")
	local name = ""
	local icon = ""
	for i, v in ipairs(self.boxConfig) do
		if v.rid == data.rid then
			name = v.des
			icon = v.icon
			break
		end
	end
	_ENV = nil
	;(nil).reward = data.rewards
	;(nil).name = i18n(name)
	;(nil).icon = icon
	uiManager:show("StarGiftReward", nil):setOwnerKey(self)
end
function StarGiftPanel:onClickBuy(eventContext)
	local name = eventContext:getSender():getName()
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	local day = SoraDConverSecondToDayAndHours(timer.timerNode.timer:getRemainTime()) + 1
	if day < table.nums(self.reward) then
		activityShowCtrl = timer.timerNode.timer:getRemainTime()
		timer.timerNode.timer:getRemainTime().num = day
		SoraDShowMsgBox(i18n("celebrationgift_text_12", timer.timerNode.timer:getRemainTime()), i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				self:buyGift(name)
			end
		end)
	else
		self:buyGift(name)
	end
end
function StarGiftPanel:buyGift(name)
	if name == "Button_buy" then
		starGiftCtrl:sendGiftBuyMsg()
		paymentManager.OnemtReadyBuy(self.configs.recharge, gRechargeActiveFromEnum.ROAD32)
	elseif name == "Button_buyOAP" then
		starGiftCtrl = nil
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD32
		SoraDShowH5PurchaseView(self.configs.recharge, param, nil)
	end
end
function StarGiftPanel:onClickGet()
	starGiftCtrl:sendGiftRewardMsg(self.configs.recharge)
end
function StarGiftPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("celebrationgift_text_1")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function StarGiftPanel:onShow()
	print("=======StarGiftPanel:onShow")
end
return StarGiftPanel
