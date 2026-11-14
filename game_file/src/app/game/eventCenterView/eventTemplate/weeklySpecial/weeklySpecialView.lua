local gametop = gModuleMgr.getObject("gametop")
local rechargeRead = include("rechargeRead")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local weeklySpecialCtrl = gametop.playertop_:getModule("weeklySpecialCtrl")
local weeklySpecialRewardTable = require_data("special_offer_weekly_reward", true)
local weeklySpecialView = class("weeklySpecialView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("weeklySpecialView")
	end
	return target
end)
local PANEL_HEIGHT = 165
function weeklySpecialView:ctor()
	self:initControls()
	self:initScroll()
end
function weeklySpecialView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_recharge")
	self.topAward = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_rechargeFirstAward_node")
	self.scroll = SoraDGetChildByName(self, "Top_Size_Scrollview")
	self.singleNode = SoraDGetChildByName(self, "node_single")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.btnFreeGet = SoraDGetChildByName(self, "btn_freeGet")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.imageRed = SoraDGetChildByName(self, "title_rechareactivity_01_177")
	self.btnSpecialGet = SoraDGetChildByName(self, "btn_specialGet")
	self.spriteBox = SoraDGetChildByName(self, "icon_king_road_box_01_309")
	self.txtDes = SoraDGetChildByName(self, "text_des")
	SoraDSetTextWidthHeight(self.txtDes, cc.size(450, 60))
	self.txtDes:setFontSize(14)
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.txtCanGet = SoraDGetChildByName(self, "text_canGet")
	self.txtTime:beginTime(weeklySpecialCtrl:getSpecialTodayRemainTime())
	if weeklySpecialCtrl:getAlreadyBuyPackageNum() < 3 then
		self.spriteBox:setSpriteFrame("icon_king_road_box_01.png")
	elseif serviceFunctions.isSameYearWeeks(gWeekDay.MONDAY, weeklySpecialCtrl:getSpecialGiftTime()) then
		self.spriteBox:setSpriteFrame("icon_king_road_box_03.png")
	else
		self.spriteBox:setSpriteFrame("icon_king_road_box_01.png")
	end
	self.loadingBar:setPercent(weeklySpecialCtrl:getAlreadyBuyPackageNum() / 3 * 100)
	self.txtProgress:setString(weeklySpecialCtrl:getAlreadyBuyPackageNum() .. "/3")
	self.bg:setFillType(1)
	self.nodeTitle:setTitle(i18n("weekly_sale_text_01"))
	self.txtDes:setString(i18n("weekly_sale_text_02"))
	self.txtCanGet:setString(i18n("weekly_sale_text_03"))
	self.btnBuy:addTouchEventListener(handler(self, self.buyClickCallBack))
	self.btnFreeGet:addTouchEventListener(handler(self, self.freeGetClickCallBack))
	self.btnSpecialGet:addTouchEventListener(handler(self, self.specialGetClickCallBack))
end
function weeklySpecialView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_WEEKLY_SPECIAL_BUY_BACK", handler(self, self.initScroll))
	SoraDAddMessage(self, "MESSAGE_WEEKLY_SPECIAL_GET_REWARD_BACK", handler(self, self.initScroll))
end
function weeklySpecialView:initScroll()
	self.scroll:removeAllChildren()
	local packageList = weeklySpecialCtrl:getPackageList()
	local scrollH = math.max(#packageList * PANEL_HEIGHT, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for i = 1, #packageList do
		local cell = self.singleNode:clone()
		cell:setPosition(cc.p(320, scrollH - (i - 1) * PANEL_HEIGHT - 5))
		cell:addTo(self.scroll)
		local info = rechargeRead.getPageViewData(packageList[i].ID)
		local txtGiftName = SoraDGetChildByName(cell, "text_giftName")
		txtGiftName:setString(i18n(info.activeName))
		local discount = math.floor(packageList[i].originalPrice / packageList[i].price * 100)
		local txtDiscount = SoraDGetChildByName(cell, "text_discount")
		txtDiscount:setString(discount .. "%")
		local rewards = weeklySpecialCtrl:getPackageRewardList(packageList[i].ID)
		for i, v in ipairs(rewards) do
			local single = SoraDCreatePanel("eventGeocentricCell")
			single:initData(rewards[i].rewardId, rewards[i].rewardNum)
			single:setClickDelegate(handler(self, self.singleCellClick))
			single:setPosition(cc.p((i - 1) * 80 - 290, -70))
			single:sendParentToButton(self)
			single:setScale(0.68)
			single:addTo(cell)
		end
		local txtPrice = SoraDGetChildByName(cell, "text_price")
		txtPrice:setString("$" .. packageList[i].price)
		local txtOriPrice = SoraDGetChildByName(cell, "text_oriPrice")
		txtOriPrice:setString("$" .. packageList[i].originalPrice)
		local btnBuy = SoraDGetChildByName(cell, "btn_buy")
		btnBuy:setTag(packageList[i].ID)
		if weeklySpecialCtrl:isPackageAlreadyBuy(packageList[i].ID) then
			btnBuy:setEnabled(false)
			txtPrice:setVisible(false)
			txtOriPrice:setVisible(false)
			btnBuy:getVirtualRenderer():setState(1)
			btnBuy:setTitleText(i18n("common_text_3833"))
		end
		local spriteColor = SoraDGetChildByName(cell, "frame_mrth_flag_01_291")
		spriteColor:setSpriteFrame("frame_mrth_flag_0" .. i .. ".png")
	end
	self.loadingBar:setPercent(weeklySpecialCtrl:getAlreadyBuyPackageNum() / 3 * 100)
	self.txtProgress:setString(weeklySpecialCtrl:getAlreadyBuyPackageNum() .. "/3")
	self.topAward.btn_box:setEnabled(false)
	self.topAward:setVisible(true)
	self.topAward.nodeAll:setVisible(true)
	if serviceFunctions.isSameYearWeeks(gWeekDay.MONDAY, weeklySpecialCtrl:getFreeGiftTime()) then
		self.topAward.img_box:stopAllActions()
		self.topAward:setParticle(false)
		self.txtCanGet:setString(i18n("common_text_1892"))
		self.topAward.img_box:getVirtualRenderer():setState(1)
		SoraDCreateGraySprite(self.topAward.iconBg)
		SoraDCreateGraySprite(self.imageRed)
		self.txtCanGet:setColor(cc.c3b(120, 120, 120))
		self.btnFreeGet:setEnabled(false)
	end
	if weeklySpecialCtrl:getAlreadyBuyPackageNum() < 3 then
		self.spriteBox:setSpriteFrame("icon_king_road_box_01.png")
	elseif serviceFunctions.isSameYearWeeks(gWeekDay.MONDAY, weeklySpecialCtrl:getSpecialGiftTime()) then
		self.spriteBox:setSpriteFrame("icon_king_road_box_03.png")
	else
		self.spriteBox:setSpriteFrame("icon_king_road_box_01.png")
	end
end
function weeklySpecialView:singleCellClick(pItem)
end
function weeklySpecialView:buyClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(button:getTag())
	end
end
function weeklySpecialView:freeGetClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rewardList, number = weeklySpecialView:getFreeRewardListByCover(weeklySpecialCtrl:getPackageSettingCover())
		local panel = SoraDCreatePanel("dailySpecialPopView")
		panel:initData(rewardList, number, true)
		panel:show()
	end
end
function weeklySpecialView:specialGetClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rewardList, number = weeklySpecialView:getSpecialRewardListByCover(weeklySpecialCtrl:getPackageSettingCover())
		local panel = SoraDCreatePanel("dailySpecialPopView")
		panel:initData(rewardList, number, true)
		panel:show()
	end
end
function weeklySpecialView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WEEKLY_SPECIAL) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function weeklySpecialView:getFreeRewardListByCover(cover)
	local _ENV, freeRewards
	for i, v in ipairs(weeklySpecialRewardTable.data) do
		if v.number == 0 and cover == v.cover then
			_UPVALUE2_ = nil
			;(nil)[1] = "rewardId"
			;(nil)[2] = "rewardNum"
			freeRewards = serviceFunctions.tableFormat(v.reward, nil)
			break
		end
	end
	return freeRewards, 0
end
function weeklySpecialView:getSpecialRewardListByCover(cover)
	local _ENV, specialRewards
	for i, v in ipairs(weeklySpecialRewardTable.data) do
		if v.number == 3 and cover == v.cover then
			_UPVALUE2_ = nil
			;(nil)[1] = "rewardId"
			;(nil)[2] = "rewardNum"
			specialRewards = serviceFunctions.tableFormat(v.reward, nil)
			break
		end
	end
	return specialRewards, 3
end
return weeklySpecialView
