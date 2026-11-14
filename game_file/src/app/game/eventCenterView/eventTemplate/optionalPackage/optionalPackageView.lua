local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local manualGiftCtrl = SoraDGetCtrl("manualGiftCtrl")
local optionalPackageRead = include("optionalPackageRead")
local publicRead = include("publicRead")
local optionalPackageView = class("optionalPackageView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("optionalPackageView")
	end
	return target
end)
MAX_CLOCKWISE = 30
MAX_COUNTER_CLOCKWISE = 60
singleNodeW = 600
_ENV, MAX_AWARD_NUM = "optionalPackageView", 5
;("optionalPackageView").fixed = 1
packageType, ("optionalPackageView").optional = "optionalPackageView", 2
function optionalPackageView:ctor()
	self:initControls()
	self:fitDevice()
	self:initData()
end
function optionalPackageView:initControls()
	self.bg = SoraDGetChildByName(self, "Top_Image_bg")
	self.btnTip = SoraDGetChildByName(self, "btn_help_tip")
	self.bgFixed = SoraDGetChildByName(self, "Top_Size_Image_bg_0")
	self.panelFixed = SoraDGetChildByName(self, "Top_Size_Panel")
	self.mustGet1 = SoraDGetChildByName(self, "Top_frame_mrth_bg_01")
	self.mustGet2 = SoraDGetChildByName(self, "Top_frame_mrth_bg_02")
	self.txtMustGet1 = SoraDGetChildByName(self, "text_mustGet1")
	self.txtMustGet2 = SoraDGetChildByName(self, "text_mustGet2")
	self.nodeReward1 = SoraDGetChildByName(self, "Top_mustAward1")
	self.nodeReward2 = SoraDGetChildByName(self, "Top_mustAward2")
	self.nodeMustAction = SoraDGetChildByName(self, "Top_node_action")
	self.txtOptionalTitle = SoraDGetChildByName(self, "text_optionalTitle")
	self.txtInstruct = SoraDGetChildByName(self, "Text_instruct")
	self.txtLimitCount = SoraDGetChildByName(self, "text_limitCount")
	self.txtGold = SoraDGetChildByName(self, "text_gold")
	self.txtFixedTitle = SoraDGetChildByName(self, "text_fixedTitle")
	self.txtDirection = SoraDGetChildByName(self, "text_direction")
	self.txtTime = SoraDGetChildByName(self, "Top_text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.frameAdd = SoraDGetChildByName(self, "frame_zxtc_zhlx_add_2")
	self.frameAdd:setVisible(false)
	if SoraDGetDefaultLanguage() == "ru" then
		self.txtInstruct:setFontSize(12)
	end
	self.bgFont = SoraDGetChildByName(self, "Top_bg_optional_package")
	if SoraDGetDefaultLanguage() == "ko" then
		self.bgFont:setSpriteFrame("bg_optional_package_ko.png")
	end
	self.nodeOptional = SoraDGetChildByName(self, "node_optional")
	self.nodeFixed = SoraDGetChildByName(self, "node_fixed")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.scroll = SoraDGetChildByName(self.nodeOptional, "ScrollView_1")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "eventLimitGiftScrollView")
	self.scroll:setSingleSelectedListener(handler(self, self.equipMenuCallBack))
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.btnBuy = SoraDGetChildByName(self, "Bottom_Button_buy")
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyPackage))
	self.btnTip:addTouchEventListener(handler(self, self.btnTipClick))
	self.giftTouchPanel = SoraDGetChildByName(self, "touch_panel")
	self.giftTouchPanel:addTouchEventListener(handler(self, self.btnSetCallBack))
	self.giftTouchPanel:setLocalZOrder(99)
	self.heroNode = SoraDGetChildByName(self, "hero_node")
	self.equipNode = SoraDGetChildByName(self, "equip_node")
	self.petNode = SoraDGetChildByName(self, "pet_node")
	self.imgHeroIcon = SoraDGetChildByName(self.heroNode, "Image_icon")
	self.imgEquipIcon = SoraDGetChildByName(self.equipNode, "Image_icon")
	self.imgPetIcon = SoraDGetChildByName(self.petNode, "Image_icon")
	self.txtHeroPackage = SoraDGetChildByName(self.heroNode, "text_fixedName")
	self.txtEquipPackage = SoraDGetChildByName(self.equipNode, "text_fixedName")
	self.txtPetPackage = SoraDGetChildByName(self.petNode, "text_fixedName")
	self.nodeAni = SoraDGetChildByName(self, "ani_node")
	self.ccs_title:setTitle(i18n("opt_package_text_01"))
	self.txtMustGet1:setString(i18n("opt_package_text_02"))
	self.txtMustGet2:setString(i18n("opt_package_text_02"))
	SoraDSetTextWidthHeight(self.txtMustGet1, cc.size(160, 60))
	SoraDSetTextWidthHeight(self.txtMustGet2, cc.size(160, 60))
	self.txtMustGet1:setFontSize(16)
	self.txtMustGet2:setFontSize(16)
	self.txtOptionalTitle:setString(i18n("opt_package_text_07"))
	self.txtInstruct:setString(i18n("opt_package_text_09"))
	self.txtLimitCount = SoraDChangeTextToHtml(self.txtLimitCount)
	self.txtFixedTitle:setString(i18n("opt_package_text_08"))
	self.txtDirection:setString(i18n("opt_package_text_10"))
	self.awardArray, _ENV, self.txtFixedArray, _ENV, self.imgIconArray, _ENV, self.itemArray, _ENV = self.txtDirection.setString, self.txtDirection.setString, self.txtDirection.setString, self.txtDirection.setString, self.txtDirection.setString, self.txtDirection.setString, self.txtDirection.setString, self.txtDirection.setString
	self.chooseIndex = 1
	self.fixedSelectIndex = 1
	self.activityID = gActivityTimeActivityID.MANUAL_GIFT_ACTIVITY
	self.packageIDList = manualGiftCtrl:getPackageIDList()
	self.packageID = self.packageIDList[1]
	self.choosePackageType = optionalPackageRead:getPackageTypeBySettingIndex(self.packageID)
	self.optionalList = optionalPackageRead:getOptionalDataBySaleTypeList(self.packageID)
	optionalPackageRead = optionalPackageRead
	optionalPackageRead[1] = self.packageID
	optionalPackageRead[2] = self.optionalList
	dump(optionalPackageRead, "self.optionalList")
	local packageTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if packageTime then
		self.txtTime:beginTime(packageTime.timerNode.timer:getRemainTime())
	end
	table.insert(self.imgIconArray, self.imgHeroIcon)
	table.insert(self.imgIconArray, self.imgEquipIcon)
	table.insert(self.imgIconArray, self.imgPetIcon)
	table.insert(self.txtFixedArray, self.txtHeroPackage)
	table.insert(self.txtFixedArray, self.txtEquipPackage)
	table.insert(self.txtFixedArray, self.txtPetPackage)
	_ENV, _ENV = self.txtFixedArray, table.insert
	self.txtFixedArray.pos = cc.p(0, 0)
	self.txtFixedArray.cpos = cc.p(-20, -103)
	self.txtFixedArray.scale = 1
	_ENV, table.insert.middle, self.txtFixedArray.point = self.txtFixedArray, self.txtFixedArray, self.heroNode
	self.txtFixedArray.pos = cc.p(-150, 110)
	self.txtFixedArray.cpos = cc.p(-20, -60)
	self.txtFixedArray.scale = 0.7
	_ENV, table.insert.left, self.txtFixedArray.point = self.txtFixedArray, self.txtFixedArray, self.equipNode
	self.txtFixedArray.pos = cc.p(150, 110)
	self.txtFixedArray.cpos = cc.p(-20, -60)
	self.txtFixedArray.scale = 0.7
	self.actionPoint, table.insert.right, self.txtFixedArray.point = table.insert, self.txtFixedArray, self.petNode
	if self.choosePackageType == packageType.fixed then
		self:initFixedPackage()
	elseif self.choosePackageType == packageType.optional then
		self:initMustReward()
		self:initPointNode()
		self:initScroll()
	end
	SoraDMixtureGLONEByParent(self.nodeMustAction)
	self:runMustRewardAction()
end
function optionalPackageView:initFixedPackage()
	for i, v in ipairs(self.optionalList) do
		local packageName = optionalPackageRead:getFixedPackageNameByIndex(i)
		local packageIcon = optionalPackageRead:getFixedPackageIconByIndex(i)
		self.txtFixedArray[i]:setString(i18n(packageName))
		self.imgIconArray[i]:loadTexture(packageIcon, ccui.TextureResType.plistType)
	end
	_UPVALUE2_ = self.fixedSelectIndex
	self.fixedSelectIndex[1] = "id"
	self.fixedSelectIndex[2] = "count"
	local fixedReward = serviceFunctions.tableFormat(self.optionalList[self.fixedSelectIndex].reward, self.fixedSelectIndex)
	local rechargePresentUtil = include("rechargePresentUtil")
	local fixData = rechargePresentUtil.fixRechargePresentData(self.packageID, fixedReward)
	local offset = 0
	if fixData.isAdd then
		fixedReward = fixData.gift
		offset = -60
	end
	for k, v in ipairs(fixedReward) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(1.0)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self)
			self.awardArray[k]:addTo(self.nodeFixed)
		end
		if self.awardArray[k] then
			if rechargePresentUtil.checkShowHighLight(v.id) then
				self.awardArray[k]:setCoolSquare()
			else
				self.awardArray[k]:hideCoolSquare()
			end
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
			self.awardArray[k]:setPosition(offset + -120 + (k - 1) * 120, -215)
		end
	end
	for i = 1, #self.awardArray do
		self.awardArray[i]:setVisible(i <= #fixedReward)
	end
end
function optionalPackageView:initMustReward()
	local mustData = optionalPackageRead:getMustDataBySaleTypeList(self.packageID)
	if next(mustData) then
		publicRead = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local rewardList = serviceFunctions.tableFormat(mustData[1].reward, nil)
		local imgIcon1 = SoraDGetChildByName(self.nodeReward1, "Image_icon")
		imgIcon1:loadTexture(publicRead.getIcon(rewardList[1].id), ccui.TextureResType.plistType)
		local txtNum1 = SoraDGetChildByName(self.nodeReward1, "Text_num")
		txtNum1:setString(rewardList[1].count)
		local imgquality1 = SoraDGetChildByName(self.nodeReward1, "Image_quality")
		imgquality1:loadTexture(publicRead.getBg(rewardList[1].id), ccui.TextureResType.plistType)
		local btn1 = SoraDGetChildByName(self.nodeReward1, "Button_item")
		btn1:setTag(rewardList[1].id)
		btn1:addTouchEventListener(handler(self, self.onBtnTouch))
		local imgIcon2 = SoraDGetChildByName(self.nodeReward2, "Image_icon")
		imgIcon2:loadTexture(publicRead.getIcon(rewardList[2].id), ccui.TextureResType.plistType)
		local txtNum2 = SoraDGetChildByName(self.nodeReward2, "Text_num")
		txtNum2:setString(rewardList[2].count)
		local imgquality2 = SoraDGetChildByName(self.nodeReward2, "Image_quality")
		imgquality2:loadTexture(publicRead.getBg(rewardList[2].id), ccui.TextureResType.plistType)
		local btn2 = SoraDGetChildByName(self.nodeReward2, "Button_item")
		btn2:setTag(rewardList[2].id)
		btn2:addTouchEventListener(handler(self, self.onBtnTouch))
	end
end
function optionalPackageView:runMustRewardAction()
	if not self.mustAction then
		self.mustAction = cc.CSLoader:createTimeline(getCCSPath("optionalPackageView"))
		self.mustAction:gotoFrameAndPlay(0, true)
		self:runAction(self.mustAction)
	end
	return self.mustAction
end
function optionalPackageView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_OPTIONAL_PACKAGE_BUY_SUCCESS", function(target, data)
		SoraDCloseLoading()
		SoraDShowMsgTip(i18n("opt_package_text_12"))
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.initFixedPackage))
end
function optionalPackageView:initPointNode()
	local pointNode = cc.Node:create()
	pointNode:setPosition(0, -510)
	pointNode:addTo(self.nodeOptional, 99)
	local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
	imageItemBg:setName("Image_bg")
	imageItemBg:setPosition(0, 0)
	imageItemBg:addTo(pointNode)
	local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
	imageLight:setName("Image_light")
	imageLight:setPosition(0, 0)
	imageLight:addTo(pointNode)
	self.pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
end
function optionalPackageView:initScroll()
	self.scroll:removeAllChildren()
	self.itemArray, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	local scrollW = math.max(self.scroll:getContentSize().width, singleNodeW * #self.optionalList)
	self.scroll:setInnerContainerSize(cc.size(scrollW, 220))
	for i = 1, #self.optionalList do
		local cell = self.nodeSingle:clone()
		function cell.setContentScale(scale)
		end
		function cell.setContentOpacity(opacity)
		end
		cell.needAdjustX = false
		cell.needAdjustY = false
		local frames = display.newFrames("dh_zixuantc_%.2d.png", 0, 13)
		local animation = display.newAnimation(frames, 1.03 / #frames)
		local singleAction = SoraDGetChildByName(cell, "Sprite_singleAction")
		singleAction:setOpacity(255)
		singleAction:playAnimationForever(animation, 1)
		local txtSingleOp = SoraDGetChildByName(cell, "text_singleOptional")
		txtSingleOp:setFontSize(12)
		_ENV = cc.size(scrollW, 220)
		cc.size(scrollW, 220).num = i
		txtSingleOp:setString(i18n("opt_package_text_03", cc.size(scrollW, 220)))
		local txtSingleName = SoraDGetChildByName(cell, "text_singleTitle")
		local optionalPackageName = optionalPackageRead:getFixedPackageNameByIndex(self.optionalList[i].index)
		txtSingleName:setString(i18n(optionalPackageName))
		_UPVALUE2_ = i18n(optionalPackageName)
		i18n(optionalPackageName)[1] = "id"
		i18n(optionalPackageName)[2] = "count"
		local optionalRewardList = serviceFunctions.tableFormat(self.optionalList[i].reward, i18n(optionalPackageName))
		for k, v in ipairs(optionalRewardList) do
			local cellReward = include("commonItemAward").new()
			cellReward:setScale(1.0)
			cellReward:setBaseScale(1.1)
			cellReward:setOwnView(self)
			cellReward:setOwnScroll(self.scroll)
			cellReward:initData(v.id, v.count)
			cellReward:setPosition(-130 + 130 * (k - 1), -130)
			cellReward:addTo(cell)
		end
		table.insert(self.itemArray, cell)
	end
	_ENV = 1
	;(1).count = #self.itemArray
	;(1).intervalWidth = 25
	;(1).begin = self.chooseIndex
	self.pagePoint:initData(1)
	self.scroll:initData(self.chooseIndex, self.itemArray, cc.size(600, 220), 217)
end
function optionalPackageView:fitDevice()
	print("wehrwoeruoweiurio", display.height)
	if math.floor(display.height) == 853 then
		self.nodeAni:setScale(0.7)
		self.nodeAni:setPositionY(150)
		self.bg:setPositionY(980)
		self.mustGet1:setPositionY(670)
		self.mustGet2:setPositionY(542)
		self.bgFont:setVisible(false)
	elseif display.height == 960 then
		self.bg:setPositionY(1080)
		self.mustGet1:setPositionY(770)
		self.mustGet2:setPositionY(642)
		self.bgFont:setVisible(false)
	end
	self.nodeReward1:setPositionY(self.mustGet1:getPositionY() - 60)
	self.nodeReward2:setPositionY(self.mustGet2:getPositionY() - 60)
	self.nodeMustAction:setPositionY(self.mustGet1:getPositionY() - 231)
	self.nodeOptional:setPositionY(self.mustGet2:getPositionY() + 70)
end
function optionalPackageView:initData()
	if not next(self.optionalList) then
		return
	end
	self.nodeOptional:setVisible(self.choosePackageType == packageType.optional)
	self.mustGet1:setVisible(self.choosePackageType == packageType.optional)
	self.mustGet2:setVisible(self.choosePackageType == packageType.optional)
	self.nodeReward1:setVisible(self.choosePackageType == packageType.optional)
	self.nodeReward2:setVisible(self.choosePackageType == packageType.optional)
	self.nodeMustAction:setVisible(self.choosePackageType == packageType.optional)
	self.bg:setVisible(self.choosePackageType == packageType.optional)
	self.bgFixed:setVisible(self.choosePackageType == packageType.fixed)
	self.panelFixed:setVisible(self.choosePackageType == packageType.fixed)
	self.nodeFixed:setVisible(self.choosePackageType == packageType.fixed)
	local packagePrice = optionalPackageRead:getPriceBySettingIndex(self.packageID)
	self.txtGold:setString("US $" .. packagePrice)
	local limitCount = self.optionalList[self.fixedSelectIndex].Limit
	local alreadybuy = manualGiftCtrl:getAlreadyBuyNum(self.packageID)
	local remainCount = limitCount - alreadybuy
	_ENV = nil
	;(nil).cur = remainCount
	_ENV, _ENV, (nil).total = nil, nil, limitCount
	;(nil).cur, (nil).color = nil, "#FFD246"
	self.txtLimitCount:setString(i18n_html("common_text_4417", nil, nil))
	self:updateOutAppPurchase()
end
function optionalPackageView:equipMenuCallBack(index)
	self.chooseIndex = index
	self.pagePoint:setCurLight(self.chooseIndex)
	self.packageID = self.packageIDList[self.chooseIndex]
	print("hhhhhhhh", self.packageID)
	self:initData()
end
function optionalPackageView:btnBuyPackage(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local limitCount = self.optionalList[self.fixedSelectIndex].Limit
		local alreadybuy = manualGiftCtrl:getAlreadyBuyNum(self.packageID)
		local remainCount = limitCount - alreadybuy
		if remainCount <= 0 then
			SoraDShowMsgTip(i18n("opt_package_text_11"))
			return
		end
		paymentManager.normalGiftBuyClassify(self.packageID)
	end
end
function optionalPackageView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("wekjhrjkwehrjkwer", gSDKDef.FAQSingleType.OPTIONAL_PACKAGE)
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.OPTIONAL_PACKAGE)
	end
end
function optionalPackageView:onBtnTouch(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		self.tips = SoraDCreatePanel("commonItemTips")
		self.tips:initData(button:getTag())
		local dt = 140
		if not SoraDFIsRA() then
			dt = -140
		end
		self.tips:setPosition(cc.p(320 + dt, button:getParent():getPositionY()))
		self.tips:addTo(self, 99)
	end
end
function optionalPackageView:btnSetCallBack(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchEndPosition()
		if self.isScorlling then
			return
		end
		if touchBeganPoint.x - touchmovePoint.x < -30 then
			print("向右边滑动")
			self:runScrollAction()
		elseif touchBeganPoint.x - touchmovePoint.x > 30 then
			print("向左边滑动")
			self:runScrollAction(true)
		elseif touchmovePoint.x <= 300 then
			print("向左边滑动")
			self:runScrollAction(true)
		elseif touchmovePoint.x > 300 then
			self:runScrollAction()
		end
	end
end
function optionalPackageView:runScrollAction(isScrollToLeft)
	_UPVALUE3_, self.isScorlling = nil, true
	;(nil)[1] = "middle"
	;(nil)[2] = "right"
	local (nil)[3], tableScrollIndex = "left", nil
	if isScrollToLeft then
		_UPVALUE3_ = "middle"
		tableScrollIndex, ("middle")[1] = "middle", "middle"
		tableScrollIndex, ("middle")[2] = "middle", "left"
		tableScrollIndex, ("middle")[3] = "middle", "right"
	end
	local tmpPoint
	for i = 1, 3 do
		local dataFrom = self.actionPoint[tableScrollIndex[i]]
		local keyTo = tableScrollIndex[i == 2 and 3 or (i + 1) % 3]
		local dataTo = self.actionPoint[keyTo]
		local pointFrom = tmpPoint and tmpPoint or dataFrom.point
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveTo(0.16666666666666666, dataTo.pos.x, dataTo.pos.y)
		;(nil)[2] = cca.scaleTo(0.16666666666666666, dataTo.scale)
		;(nil)[3] = cca.scaleTo(0.16666666666666666, dataTo.scale)
		;(nil)[4] = cca.scaleTo(0.16666666666666666, dataTo.scale)
		pointFrom:runAction(cca.spawn(nil))
		pointFrom:getChildByName("node_singleFixed"):runAction(cca.moveTo(0.16666666666666666, dataTo.cpos.x, dataTo.cpos.y))
		tmpPoint = self.actionPoint[keyTo].point
		self.actionPoint[keyTo].point = pointFrom
	end
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.16666666666666666)
	;(nil)[2] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[3] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[4] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[5] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[6] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[7] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[8] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[9] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[10] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[11] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	;(nil)[12] = cca.callFunc(function(...)
		self:aniEventCallBack()
		self.isScorlling = false
	end)
	self:runAction(cca.seq(nil))
end
function optionalPackageView:aniEventCallBack(aniFrame)
	local middleName = self.actionPoint.middle.point:getName()
	if middleName == "hero_node" then
		self.fixedSelectIndex = 1
	elseif middleName == "equip_node" then
		self.fixedSelectIndex = 2
	elseif middleName == "pet_node" then
		self.fixedSelectIndex = 3
	end
	self.packageID = self.packageIDList[self.fixedSelectIndex]
	print("middleName", middleName, self.packageID)
	self:initData()
	self:initFixedPackage()
end
function optionalPackageView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function optionalPackageView:updateOutAppPurchase(isShow)
	if SoraDCheckOAPIsOpen(self.packageID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self._ccsView)
			self.outAppPurchaseButtons:setPosition(cc.p(320, 100))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnBuy:setVisible(false)
		_ENV = false
		;(false).rid = self.packageID
		;(false).nowPrice = self.txtGold:getString()
		;(false).handleItemBuyClick = handler(self, self.handleItemBuyClick)
		;(false).handleBuyClick = handler(self, self.btnBuyPackage)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.packageID
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self, cc.p(SoraDFPosX(115), 180), 0.9, nil, 300)
	else
		_ENV, _UPVALUE1_ = self, self.outAppPurchaseButtons
		self.rechargeID = self.packageID
		self.outAppPurchaseButtons[1] = self
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self, cc.p(SoraDFPosX(115), 115), 0.9, nil, 300)
		if self.outAppPurchaseButtons then
			self.outAppPurchaseButtons:setVisible(false)
		end
		self.btnBuy:setVisible(true)
	end
end
function optionalPackageView:handleItemBuyClick()
	local limitCount = self.optionalList[self.fixedSelectIndex].Limit
	local alreadybuy = manualGiftCtrl:getAlreadyBuyNum(self.packageID)
	local remainCount = limitCount - alreadybuy
	if remainCount <= 0 then
		SoraDShowMsgTip(i18n("opt_package_text_11"))
		return false
	end
	return true
end
return optionalPackageView
