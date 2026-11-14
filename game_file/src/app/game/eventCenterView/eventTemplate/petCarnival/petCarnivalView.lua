local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = SoraDGetCtrl("petCarnivalCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local petCarnivalRead = include("petCarnivalRead")
_ENV = "petCarnivalRead"
;("petCarnivalRead").noClaim = 1
;("petCarnivalRead").noReach = 2
local ("petCarnivalRead").claimed, giftStatus = 3, "petCarnivalRead"
local petCarnivalView = class("petCarnivalView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end)
function petCarnivalView:ctor(properties)
	petCarnivalCtrl:reqInitData()
	self.cardTbl, petCarnivalCtrl, self.pointTbl, petCarnivalCtrl = petCarnivalCtrl.reqInitData, petCarnivalCtrl.reqInitData, petCarnivalCtrl.reqInitData, petCarnivalCtrl.reqInitData
	self.isOpen = false
	self.isFly = false
	self.curCard, petCarnivalCtrl, self.curReward, petCarnivalCtrl, self.curDouble = petCarnivalCtrl.reqInitData, petCarnivalCtrl.reqInitData, petCarnivalCtrl.reqInitData, petCarnivalCtrl.reqInitData, false
	self.curType = 0
	self.diffIndex = 0
	self.activityID = gActivityTimeActivityID.MAGICAL_DOMINO
	self.activityItemID = 833801
	self:initView()
end
function petCarnivalView:fitDevice(...)
	local dis = display.height - 960
	local height = display.height - 1160
	print("-900 = 1164.00" .. dis)
	if 0 < dis then
	elseif dis == 0 then
	else
		self.Top_Node_btn_top:setPositionY(display.height - 130)
		self.Center_Node_card:setPositionY(510 + dis / 2)
	end
end
function petCarnivalView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemChange))
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_OPENCARD", handler(self, self.openCard))
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_OPENCARD_BATCH", function(target, data)
		SoraDCloseLoading(self)
		self:showOrHideBfTen(false)
		self.drawPanel = SoraDSearchPanelFromManagerByName("petCarnivalOpenTenView")
		if self.drawPanel then
			self.drawPanel:removeFromParent()
		end
		dump(data, "sldkjfslkdjfksldjf222")
		self.drawPanel = SoraDCreatePanel("petCarnivalOpenTenView")
		self.drawPanel:initData(data.list, self)
		self.drawPanel:showDouble(data.double)
		self.drawPanel:show()
	end)
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_OPENONE", handler(self, self.openCardDone))
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_ERR", handler(self, self.judgeIsOpen))
end
function petCarnivalView:judgeIsOpen()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function petCarnivalView:initData()
	self:setSlider()
	self:itemChange()
	local data = petCarnivalCtrl:getAllData()
	petCarnivalCtrl = nil
	;(nil).num = string.formatnumberthousands(petCarnivalCtrl:getTotalPoint())
	self.Text_point:setString(i18n("pet_flip_text_03", nil))
end
function petCarnivalView:initView()
	self.icon_double = SoraDGetChildByName(self, "icon_double")
	self.icon_double_10 = SoraDGetChildByName(self, "icon_double_10")
	self.Top_Node_p1 = SoraDGetChildByName(self, "Top_Node_p1")
	self.zhe_16 = SoraDGetChildByName(self, "zhe_16")
	self.Top_Node_btn_top = SoraDGetChildByName(self, "Top_Node_btn_top")
	self.icon_double:setVisible(false)
	self.icon_double_10:setVisible(false)
	self.Image_BG = SoraDGetChildByName(self, "Image_BG")
	self.Button_preview = SoraDGetChildByName(self, "Button_preview")
	self.Button_record = SoraDGetChildByName(self, "Button_record")
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_star = SoraDGetChildByName(self, "Button_star")
	self.Button_star_ten = SoraDGetChildByName(self, "Button_star_ten")
	self.Text_star = SoraDGetChildByName(self, "Text_star")
	self.Text_star_10 = SoraDGetChildByName(self, "Text_star_10")
	self.Text_need = SoraDGetChildByName(self, "Text_need")
	self.Text_need_10 = SoraDGetChildByName(self, "Text_need_10")
	self.Node_add = SoraDGetChildByName(self, "Node_add")
	self.Text_leftNum = SoraDGetChildByName(self, "Text_leftNum")
	self.Text_leftNum:setString(i18n("equip_text_09"))
	self.Text_Num = SoraDGetChildByName(self, "Text_Num")
	self.Text_point = SoraDGetChildByName(self, "Text_point")
	self.Text_21 = SoraDGetChildByName(self, "Text_21")
	self.Text_21_0 = SoraDGetChildByName(self, "Text_21_0")
	self.Text_21:setString(i18n("luckyFlip_btn_02"))
	self.Text_21_0:setString(i18n("pet_flip_text_09"))
	self.Text_lefttime = SoraDGetChildByName(self, "Text_lefttime")
	self.text_time = SoraDCreateTimerLabel(self, self.Text_lefttime)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.text_time:setString(SoraDConvertSecondToString(leftTime))
		self.text_time:beginTime(leftTime)
	end
	self.frame_sszz_starblack_01_1 = SoraDGetChildByName(self, "frame_sszz_starblack_01_1")
	self.frame_sszz_starblack_01_1:setVisible(false)
	self.Node_spe = SoraDGetChildByName(self, "Node_spe")
	self.Node_spe:setVisible(false)
	self.Node_normal = SoraDGetChildByName(self, "Node_normal")
	_G.SoraDSetParticleAutoCull(self.Node_spe:getChildren(), false)
	_G.SoraDSetParticleAutoCull(self.Node_normal:getChildren(), false)
	self.Text_star:setString(i18n("luckyFlip_title_01"))
	_ENV = i18n("luckyFlip_title_01")
	i18n("luckyFlip_title_01").num = 10
	self.Text_star_10:setString(i18n("luckyFlip_btn_01", i18n("luckyFlip_title_01")))
	self.Text_need:setString("1")
	self.Text_need_10:setString("10")
	self.Center_Node_card = SoraDGetChildByName(self, "Center_Node_card")
	self.Bottom_frame_slide = SoraDGetChildByName(self, "Bottom_frame_slide")
	self.Bottom_Node_btn = SoraDGetChildByName(self, "Bottom_Node_btn")
	self.Button_star:addTouchEventListener(handler(self, self.clickStarBtn))
	self.Button_star_ten:addTouchEventListener(handler(self, self.clientStarTenBtn))
	self.Button_go:addTouchEventListener(handler(self, self.clickGoBtn))
	self.Button_record:addTouchEventListener(handler(self, self.clickRecordBtn))
	self.Button_preview:addTouchEventListener(handler(self, self.clickPreviewBtn))
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("activity_name_9001302"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.clickFAQBtn))
	self.ScrollView_reward = SoraDGetChildByName(self, "ScrollView_reward")
	self.Node_pro = SoraDGetChildByName(self, "Node_pro")
	self.Slider_count = SoraDGetChildByName(self, "Slider_count")
	self.Slider_count:setTouchEnabled(false)
	self.Slider_count:getChildByName("grip"):setTouchEnabled(false)
	self.Image_slider_bg = SoraDGetChildByName(self, "Image_slider_bg")
	self.frame_cjxt_square_zs_l = SoraDGetChildByName(self, "frame_cjxt_square_zs_l")
	self.frame_cjxt_square_zs_r = SoraDGetChildByName(self, "frame_cjxt_square_zs_r")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.pointTbl[1] = self.Node_tip
	self.Button_left = SoraDGetChildByName(self, "Button_left")
	self.Button_left:addTouchEventListener(handler(self, self.clickLeftBtn))
	self.Button_right = SoraDGetChildByName(self, "Button_right")
	self.Button_right:addTouchEventListener(handler(self, self.clickRightBtn))
	self.ScrollView_reward:addEventListener(handler(self, self.scrollEvent))
	self:initCard()
	self:initSlider()
	self:addAni()
	self:fitDevice()
	SoraDCreatAnimation(self.__cname, self, true)
end
function petCarnivalView:addAni()
	local spine_bird = sp.SkeletonAnimation:create("spine/shumu.skel", "spine/shumu.atlas", 1)
	spine_bird:setPosition(cc.p(320, display.height - 960 >= 0 and -(display.height / 2 - 55) or -420))
	spine_bird:setAnimation(0, "animation", true)
	self.zhe_16:getParent():reorderChild(self.zhe_16, 2)
	spine_bird:addTo(self.Top_Node_p1, 0)
end
function petCarnivalView:initCard()
	for i = 1, 3 do
		card = SoraDCreatePanel("petCarnivalCard")
		card:addTo(self.Center_Node_card, 4 - i)
		card:setVisible(false)
		table.insert(self.cardTbl, card)
	end
end
function petCarnivalView:setFlyCard()
	self.isFly = true
	local flyCard = SoraDCreatePanel("petCarnivalCardFly")
	self.image_ani_card = flyCard
	flyCard:setPosition(cc.p(0, 0))
	flyCard:addTo(self.Center_Node_card)
	flyCard:setHandle(handler(self, self.setCard))
	flyCard:showFly()
end
function petCarnivalView:setCard()
	print("播放结束")
	self.isFly = false
	self.image_ani_card:setVisible(false)
	for k, v in ipairs(self.cardTbl) do
		local card = v
		card:setPosition(cc.p(157 * (k - 2), 0))
		card:setVisible(true)
	end
end
function petCarnivalView:setCardInit()
	for k, v in ipairs(self.cardTbl) do
		local card = v
		card:setPosition(cc.p(157 * (k - 2), 0))
		card:setVisible(true)
		card:showOneSide(false)
	end
end
function petCarnivalView:flyCard(target, data)
	local done = data.doneIndex
	local index = done + 1
	print("接着飞", index)
	if index < 4 then
		self.cardTbl[index]:flyCard(false)
	end
	if index == 4 then
		self.isFly = false
	end
end
function petCarnivalView:openCard(target, data)
	self.isOpen = true
	self:showOrHideBfTen(true)
	dump(data, "开牌slkdfjklsdjflkds")
	local card = data.card
	local _ENV, cardList = data, data
	self.curReward = data.reward
	self.curCard = card
	self.curType = data.type
	self.diffIndex = 0
	self.curDouble = data.double
	if #card == 3 then
		cardList = card
	elseif #card == 2 then
		local rad = SoraDGetRandNum(1, 1, 3)[1]
		print("随机数", rad)
		self.diffIndex = rad
		for i = 1, 3 do
			cardList[i] = i == rad and card[2] or card[1]
		end
	else
		for i = 1, 3 do
			cardList[i] = card[1]
		end
	end
	dump(cardList, "开牌list")
	for k, v in ipairs(cardList) do
		local card = self.cardTbl[k]
		card:setPoint(v, k, self.curTyp)
		card:setPosition(cc.p(157 * (k - 2), 0))
		if k == 1 then
			card:show3DFlip(self.curDouble)
		end
	end
end
function petCarnivalView:showOrHideBfTen(flag)
	self.Center_Node_card:setVisible(flag)
	self.Top_Node_btn_top:setVisible(flag)
	self.Bottom_frame_slide:setVisible(flag)
	self.Bottom_Node_btn:setVisible(flag)
	if flag then
		self:setCardInit()
	end
end
function petCarnivalView:openCardDone(target, data)
	local done = data.doneIndex
	local index = done + 1
	print("接着开", index, self.diffIndex)
	if index < 4 then
		if index == 3 then
			SoraDCreateDelayTimer(self, function()
				self.cardTbl[index]:show3DFlip(self.curDouble, self.diffIndex == 3 or #self.curCard == 1)
			end, 0.2)
		else
			self.cardTbl[index]:show3DFlip(self.curDouble)
		end
	end
	if self.diffIndex > 0 and self.curType == 2 then
		if done == 3 and self.diffIndex == 1 then
			self.cardTbl[2]:showAnimal(2)
			self.cardTbl[3]:showAnimal(2)
		end
		if done == 3 and self.diffIndex == 2 then
			self.cardTbl[1]:showAnimal(2)
			self.cardTbl[3]:showAnimal(2)
		end
		if done == 2 and self.diffIndex == 3 then
			self.cardTbl[1]:showAnimal(2)
			self.cardTbl[2]:showAnimal(2)
		end
	end
	if done == 2 and self.curType == 3 then
		self.cardTbl[1]:showAnimal(2)
		self.cardTbl[2]:showAnimal(2)
	end
	if done == 3 and self.curType == 3 then
		print("播放3的动画!!!!!!!")
		self.cardTbl[1]:showAnimal(3)
		self.cardTbl[2]:showAnimal(3)
		self.cardTbl[3]:showAnimal(3)
	end
	if index == 4 and 0 < self.curType then
		local _ENV, itemData = self.curType, self.curType
		local double = self.curDouble
		for i, v in ipairs(self.curReward) do
			_ENV = nil
			;(nil).id = v.id
			;(nil).count = v.count
			table.insert(itemData, nil)
		end
		SoraDCreateDelayTimer(self, function()
			self:showReward(itemData)
		end, 0.3)
		self.curCard, _ENV, self.curReward, _ENV = SoraDCreateDelayTimer, SoraDCreateDelayTimer, SoraDCreateDelayTimer, SoraDCreateDelayTimer
		self.curType = 0
		self.curDouble = false
	end
end
function petCarnivalView:showDouble(flag)
	self.Node_spe:setVisible(flag)
	self.icon_double:setVisible(flag)
	self.icon_double_10:setVisible(flag)
	for i, v in ipairs(self.cardTbl) do
		v:showCoverFlash(flag)
	end
	if self.tneView and self.tneView.showDouble then
		self.tneView:showDouble(flag)
	end
end
function petCarnivalView:stopAllCardActions()
	for k, v in ipairs(self.cardTbl) do
		self.cardTbl[k]:stopAnimal()
	end
end
function petCarnivalView:showReward(data)
	local mul = #data
	for k, v in ipairs(data) do
		local showItem = include("commonItemAward").new()
		print("lskdjfskldjflsk", self.curDouble)
		if self.curDouble then
			local x2 = cc.Sprite:createWithSpriteFrameName("icon_mcdkh_double_01.png")
			x2:setPosition(50, 50)
			x2:addTo(showItem, 15)
		end
		showItem:initData(v.id, v.count)
		showItem:setScale(0.9)
		showItem:setBaseScale(1.0)
		showItem:setPosition(0, 0)
		showItem:addTo(self.Center_Node_card, 6)
		local targetPos = cc.p(SoraDFPosX(50 * (mul - 1 - 2 * (k - 1)), 0), 200)
		_UPVALUE6_ = 200
		;(200)[1] = cca.delay((k - 1) * 0.2)
		;(200)[2] = cca.callFunc(function()
			SoraDPlaySound("normalcontrol", 4)
			showItem:showEffect()
		end)
		;(200)[3] = cc.EaseExponentialOut:create(cca.moveTo(0.5, targetPos.x, targetPos.y))
		;(200)[4] = cca.delay(1.0 - (k - 1) * 0.2)
		;(200)[5] = cc.EaseExponentialIn:create(cca.moveTo(0.5, 0, -display.height))
		;(200)[6] = cca.delay(0.5)
		;(200)[7] = cca.callFunc(function()
			self:stopAllCardActions()
			self.isOpen = false
			showItem:removeFromParent()
		end)
		;(200)[8] = cca.callFunc(function()
			self:stopAllCardActions()
			self.isOpen = false
			showItem:removeFromParent()
		end)
		;(200)[9] = cca.callFunc(function()
			self:stopAllCardActions()
			self.isOpen = false
			showItem:removeFromParent()
		end)
		;(200)[10] = cca.callFunc(function()
			self:stopAllCardActions()
			self.isOpen = false
			showItem:removeFromParent()
		end)
		local seq = cca.seq(200)
		showItem:runAction(seq)
	end
end
function petCarnivalView:clearCard()
	for k, v in ipairs(self.cardTbl) do
		if v then
			v:hideCard()
		end
	end
end
_ENV, _ENV, petCarnivalView.itemChange = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end, function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end
_ENV, (function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[1], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "icon_KingGroupbuy_lv1_small.png"
_ENV, (function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[2], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "icon_KingGroupbuy_lv2_small.png"
_ENV, (function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[3], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "zsjdh_box3.png"
_ENV, (function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[4], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "zsjdh_box4.png"
_ENV, (function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[5], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "zsjdh_box5.png"
_ENV, (function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[6], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "zsjdh_box5.png"
;(function(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end)[7], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end).imgBox = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("petCarnivalView")
end, "zsjdh_box5.png"
local function rechargePhasesCfg(self)
	print("petCarnivalView道具数量", backpackCtrl:getItemCount(self.activityItemID))
	local num = backpackCtrl:getItemCount(self.activityItemID)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.Node_add)
end
function petCarnivalView:scrollEvent(target, event)
	if event == ccui.ScrollviewEventType.containerMoved or event == ccui.ScrollviewEventType.scrollingEnd then
		local inner = self.ScrollView_reward:getInnerContainer()
		local newWidth = inner:getContentSize().width
		local posX = inner:getPositionX()
		if posX <= -newWidth + 560 then
			self.Button_right:setVisible(false)
			self.Button_left:setVisible(true)
		elseif 0 <= posX then
			self.Button_left:setVisible(false)
			self.Button_right:setVisible(true)
		else
			self.Button_right:setVisible(true)
			self.Button_left:setVisible(true)
		end
	end
end
function petCarnivalView:initSlider()
	local maxPoint = petCarnivalRead.getBiggestPoint()
	local data = petCarnivalRead.getRewardConfig()
	local newWidth = math.max(560, #data * 120)
	self.ScrollView_reward:setInnerContainerSize(cc.size(newWidth, 120))
	self.Node_pro:setPositionX(newWidth / 2)
	self.Image_slider_bg:setContentSize(cc.size(newWidth - 20, 16))
	self.Slider_count:setContentSize(cc.size(newWidth - 20, 10))
	self.frame_cjxt_square_zs_l:setPositionX(-newWidth / 2 + 10)
	self.frame_cjxt_square_zs_r:setPositionX(newWidth / 2 - 10)
	self.perPercent = newWidth / #data
	for k, v in ipairs(data) do
		if not self.pointTbl[k] then
			self.pointTbl[k] = self.Node_tip:clone()
			self.pointTbl[k]:addTo(self.Node_items)
		end
		local txt = self.pointTbl[k]:getChildByName("Text_p")
		local img = self.pointTbl[k]:getChildByName("Image_box")
		img:loadTexture("icon_KingGroupbuy_lv1_small.png", ccui.TextureResType.plistType)
		if v.num == petCarnivalRead.getBiggestPoint() then
			img:loadTexture("zsjdh_box5.png", ccui.TextureResType.plistType)
		end
		img:setTag(v.index)
		img:setTouchEnabled(true)
		img:setSwallowTouches(false)
		img = include("commonBtnInstance").new(img)
		img:setScroll(self.ScrollView_reward)
		img:setHandle(handler(self, self.pointClick))
		self.pointTbl[k].img = img
		self.pointTbl[k].effectNode = self:createRoundEffect(self.pointTbl[k])
		self.pointTbl[k].effectNode:setVisible(false)
		txt:setFontSize(18)
		txt:setString(string.formatnumberthousands(v.num))
		local ratio = SoraDPreciseDecimal(v.num / maxPoint, 2)
		self.pointTbl[k]:setPosition(SoraDFPosX(newWidth / 2 - k * 120 + 50, 0), 0)
	end
end
function petCarnivalView:createRoundEffect(pNode)
	_ENV, _ENV = nil, nil
	;(nil).png = "dh_xsyd_01.png"
	;(nil).scale = 2.75
	;(nil).opacity = 178.5
	_UPVALUE1_ = nil
	;(nil)[1] = cca.fadeTo(0.55, 0.2)
	;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
	_ENV, (nil)[1], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	_ENV, (nil)[2], (nil).scale = nil, nil, 2
	;(nil).png = "dh_xsyd_02.png"
	;(nil).scale = 2.4
	_ENV = nil
	;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[3], (nil).seq = nil, cca.seq(nil)
	local actionConfig
	local roundNode = display.newNode()
	if pNode then
		local nSize = pNode:getContentSize()
		roundNode:setPosition(0, 5)
		roundNode:addTo(pNode, 1)
	end
	for k, v in ipairs(actionConfig) do
		if v.png then
			local sprite = display.newSprite("#" .. v.png)
			if v.scale then
				sprite:setScale(v.scale)
			end
			if v.opacity then
				sprite:setOpacity(v.opacity)
			end
			if v.rotation then
				sprite:setRotation(v.rotation)
			end
			if v.seq then
				sprite:runAction(cc.RepeatForever:create(v.seq))
			end
			sprite:addTo(roundNode, k)
		end
	end
	roundNode:setScale(0.4)
	return roundNode
end
function petCarnivalView:pointClick(target, eventType)
	local index = target:getTag()
	local view = SoraDCreatePanel("petCarnivalRewardView")
	view:show()
	_ENV = nil
	;(nil).view = self
	view:initIndex(index, nil)
end
function petCarnivalView:setSlider()
	local stage = petCarnivalRead.getRewardCfg()
	local percent = SoraDGetStagePercentNew(petCarnivalCtrl:getTotalPoint(), stage)
	self.Slider_count:setPercent(percent)
	self:showDouble(false)
	local toIndex = 0
	for k, v in ipairs(self.pointTbl) do
		local status = petCarnivalCtrl:getStageRewardStauts(k)
		local stype = petCarnivalRead.getRewardConfig(k).type
		local num = petCarnivalRead.getRewardConfig(k).num
		v.effectNode:setVisible(status == 1 and stype == 1)
		if status == 3 then
			v.img:loadTexture(num == petCarnivalRead.getBiggestPoint() and "zsjdh_global_box1.png" or "icon_zsjcb_box_open.png", ccui.TextureResType.plistType)
		else
			v.img:loadTexture(num == petCarnivalRead.getBiggestPoint() and "zsjdh_global_box2.png" or "icon_zsjcb_box_close.png", ccui.TextureResType.plistType)
		end
		if stype == 2 and num == petCarnivalCtrl:getTotalPoint() then
			print("叨叨", k)
			self.icon_double:setVisible(true)
			self.icon_double_10:setVisible(true)
			v.effectNode:setVisible(true)
			self:showDouble(true)
		elseif stype == 2 then
			v.effectNode:setVisible(false)
		end
		if num == petCarnivalRead.getBiggestPoint() then
			v.img:setPositionY(3)
		end
		if (status == 1 or status == 2) and toIndex == 0 then
			toIndex = k
		end
	end
	if not self.isInitTo then
		self:scrollToIndex(math.max(toIndex - 1, 0))
		self.isInitTo = true
	end
end
function petCarnivalView:scrollToIndex(index)
	local inner = self.ScrollView_reward:getInnerContainer()
	local newWidth = inner:getContentSize().width
	local newPosX = math.max(-newWidth + 560, math.min(-index * self.perPercent, 0))
	if SoraDFIsRA() then
		newPosX = math.min(-newWidth + 560 + index * self.perPercent, 0)
	end
	inner:setPositionX(newPosX)
	self.Button_left:setVisible(newPosX < 0)
	self.Button_right:setVisible(newPosX > -newWidth + 560)
end
function petCarnivalView:clickLeftBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("点击左边")
		local inner = self.ScrollView_reward:getInnerContainer()
		local newWidth = inner:getContentSize().width
		local posX = inner:getPositionX()
		local newPosX = math.min(posX + self.perPercent, 0)
		inner:setPositionX(newPosX)
		self.Button_left:setVisible(newPosX < 0)
		self.Button_right:setVisible(newPosX > -newWidth + 560)
	end
end
function petCarnivalView:clickRightBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("点击右边")
		local inner = self.ScrollView_reward:getInnerContainer()
		local newWidth = inner:getContentSize().width
		local posX = inner:getPositionX()
		local newPosX = math.max(posX - self.perPercent, -newWidth + 560)
		inner:setPositionX(newPosX)
		self.Button_left:setVisible(newPosX < -60)
		self.Button_right:setVisible(newPosX > -newWidth + 560)
	end
end
function petCarnivalView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("pet_flip_text_01"))
	end
end
function petCarnivalView:clickGoBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not include("activityTimeRead").getRechargeId(self.activityID) then
			local _ENV, idTbl = include("activityTimeRead").getRechargeId(self.activityID), include("activityTimeRead").getRechargeId(self.activityID)
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = idTbl[1] or 19293
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, idTbl[1] or 19293)
			panel:show()
		end
	end
end
function petCarnivalView:clickStarBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isOpen or self.isFly then
			return
		end
		if backpackCtrl:getItemCount(self.activityItemID) > 0 then
			self:showDouble(false)
			petCarnivalCtrl:reqOpenCard()
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function petCarnivalView:clientStarTenBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isOpen or self.isFly then
			return
		end
		if backpackCtrl:getItemCount(self.activityItemID) >= 10 then
			self:showDouble(false)
			petCarnivalCtrl:reqOpenTenCard()
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function petCarnivalView:clickRecordBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("petCarnivalRecordView"):show()
	end
end
function petCarnivalView:clickPreviewBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("petCarnivalPreviewView"):show()
	end
end
function petCarnivalView:onEnterPanel()
	self.curType = 0
	self:setFlyCard()
end
function petCarnivalView:onExitPanel()
end
return petCarnivalView
