local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local NARD = require_data("new_accumulate_recharge", true)
local publicRead = include("publicRead")
local ITEM_HEIGHT = 90
local SCALE_IN_PAGE = 5
local totalPayActivityView = class("totalPayActivityView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("totalPayActivityView")
	end
	return target
end)
local gametop = gModuleMgr.getObject("gametop")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
function totalPayActivityView:ctor()
	self.maxPoint = TOTAL_ACTIVITY_MAX_POINTS
	self.totoalScale = 0
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_gold")
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_bag")
	self.title:setFontSize(24)
	self.btnHelp = SoraDGetChildByName(self, "Top_Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.getHelpInfo))
	self.totalGold = SoraDGetChildByName(self, "Text_total")
	self.labTime = SoraDGetChildByName(self, "Text_labTime")
	self.labTime = SoraDCreateTimerLabel(self, self.labTime)
	self.progressBar = SoraDGetChildByName(self, "LoadingBar")
	self.progressBar:setLocalZOrder(1)
	self.cumu_line = SoraDGetChildByName(self, "cumu_line")
	self.cumu_line:setLocalZOrder(3)
	self.curPoint = SoraDGetChildByName(self, "Text_point")
	self.freeSend = SoraDGetChildByName(self, "Top_Text_free")
	self.bottomTip = SoraDGetChildByName(self, "Bottom_Text_tips")
	self.bottomIOSTip = SoraDGetChildByName(self, "Bottom_Text_ios_tips")
	self.bottomIOSTip:setVisible(false)
	self.progressBarBg = SoraDGetChildByName(self, "Top_Node_progressBar")
	self.scaleScroll = SoraDGetChildByName(self, "Size_ScrollView_move")
	self.inner = self.scaleScroll:getInnerContainer()
	self.inner:setPositionX(-400)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_items")
	self.singleItem = SoraDGetChildByName(self, "singleItem")
	self.leftPageBtn = SoraDGetChildByName(self, "leftPageBtn")
	self.leftPageBtn:addTouchEventListener(handlerEx(self, self.clickPageBtn, true))
	self.rightPageBtn = SoraDGetChildByName(self, "rightPageBtn")
	self.rightPageBtn:addTouchEventListener(handlerEx(self, self.clickPageBtn, false))
	activityShowCtrl:sendRechargeFeedBack()
	SoraDShowLoading(self)
	self.itemList, _ENV = SoraDShowLoading, SoraDShowLoading
	local bgSizeH = self:getPanelOffsetHeight() - 474
	bgSizeH = math.max(bgSizeH, 586)
	SoraDGetChildByName(self, "Bottom_bg_down"):setContentSize(cc.size(640, bgSizeH))
end
function totalPayActivityView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_TOTAL_PAY_ACTIVITY_REFRESH", handler(self, self.refreshView))
end
function totalPayActivityView:initData(data)
	SoraDCloseLoading(self)
	self.payData = data.data.actData
	self.leftTime = self.payData.endtime - serviceFunctions.systemTime()
	self.curAmount = self.payData.addGold
	self.totoalScale = table.nums(NARD.data)
	self.maxPage = math.ceil(self.totoalScale / SCALE_IN_PAGE)
	self.curPage = self.maxPage
	self.cumuScale = self.totoalScale
	for i, v in ipairs(NARD.data) do
		if v.amount > self.curAmount then
			self.curPage = math.floor((i - 1) / 5) + 1
			self.cumuScale = i
			break
		end
	end
	self.selectTag = self.cumuScale % SCALE_IN_PAGE
	if self.selectTag == 0 then
		self.selectTag = SCALE_IN_PAGE
	end
end
function totalPayActivityView:refreshView(target, data)
	dump(data, "refreshView", 5)
	self:initData(data)
	if self.leftTime > 0 then
		self:bindData()
	else
		self:removeFromParent()
	end
end
function totalPayActivityView:bindData()
	self.title:setTitle(i18n("accumulate_recharge_text_01"))
	self.totalGold:setString(i18n("common_text_1175"))
	self.bottomTip:setString(i18n("common_text_1176"))
	self.bottomTip:setPositionY(15)
	self.freeSend:setString(i18n("common_text_1170"))
	self.labTime:beginTime(self.leftTime)
	self.curPoint:setString(i18n("common_text_448") .. self.curAmount)
	if not self.scaleLine then
		self.scaleLine, _ENV = self.scaleLine, self.scaleLine
	end
	self:updatePage()
end
function totalPayActivityView:refreshScale()
	local startIndex = (self.curPage - 1) * SCALE_IN_PAGE + 1
	local scaleInPage = math.min(SCALE_IN_PAGE, self.totoalScale - startIndex + 1)
	local maxWidth = 480
	local offsetX = maxWidth / (scaleInPage + 1)
	for i = 1, SCALE_IN_PAGE do
		local item = self.scaleLine[i]
		if not item then
			if i == 1 then
				item = self.cumu_line
			else
				item = self.cumu_line:clone()
				item:addTo(self.progressBarBg, 3)
			end
			local btn = item:getChildByName("Button_scale")
			btn:setTag(i)
			btn:addTouchEventListener(handler(self, self.showReward))
			self.scaleLine[i] = item
		end
		item:setPositionX(offsetX * i - 240)
		item:setVisible(i <= scaleInPage)
	end
	local persent = 0
	if self.curAmount >= NARD.data[self.totoalScale].amount then
		persent = 100
	else
		local curScale = self.cumuScale - (self.curPage - 1) * SCALE_IN_PAGE
		local lastAmount = 0
		if NARD.data[self.cumuScale - 1] then
			lastAmount = NARD.data[self.cumuScale - 1].amount
		end
		local targetAmount = NARD.data[self.cumuScale].amount
		persent = (self.curAmount - lastAmount) / (targetAmount - lastAmount)
		persent = (curScale - 1) * (100 / (scaleInPage + 1)) + 100 / (scaleInPage + 1) * persent
	end
	self.progressBar:setPercent(persent)
end
function totalPayActivityView:refreshScaleVale()
	for i = 1, self.totoalScale do
		if i <= self.cumuScale then
			self.scaleBtn[i]:loadTextureNormal("btn_xfczhk_01.png", ccui.TextureResType.plistType)
		else
			self.scaleBtn[i]:loadTextureNormal("btn_xfczhk_02.png", ccui.TextureResType.plistType)
		end
		self.scaleBtn[i]:loadTexturePressed("btn_xfczhk_01.png", ccui.TextureResType.plistType)
		local point = NARD.data[i].amount
		self.scaleText[i]:setString(SoraDConvertNumberWithUnit(point))
	end
	local curPoxScale = math.min(self.cumuScale + 1, self.totoalScale)
	local newPosX = self.scaleBtn[curPoxScale]:getParent():getPositionX()
	self.frameScale:setPositionX(newPosX)
	self:refreshRewardList(curPoxScale)
end
function totalPayActivityView:refreshRewardList(cumuScale)
	cumuScale = math.max(cumuScale, 1)
	cumuScale = math.min(cumuScale, self.totoalScale)
	local reward = SoraDIntArr2FormatTable(NARD.data[cumuScale].reward)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #reward * ITEM_HEIGHT)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	print("size ", sSize.width, sH)
	for _, v in ipairs(self.itemList) do
		v:setVisible(false)
	end
	for i = 1, #reward do
		local item = self.itemList[i]
		if not item then
			item = self.singleItem:clone()
			item:addTo(self.scroll)
			self.itemList[i] = item
			local itemBtn = SoraDGetChildByName(item, "Button_item")
			itemBtn:setSwallowTouches(false)
			itemBtn:addTouchEventListener(handlerEx(self, self.clickRewardItem, i))
		end
		item:setPosition(250.0, sH - i * ITEM_HEIGHT)
		item:setVisible(true)
		item:setLocalZOrder(#reward - i + 99)
		self:updateItem(item, reward[i])
	end
end
function totalPayActivityView:showReward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self.selectTag = tag
		self:refreshRewardList((self.curPage - 1) * SCALE_IN_PAGE + tag)
		self:refreshBtnstatus()
	end
end
function totalPayActivityView:refreshBtnstatus()
	for k, v in ipairs(self.scaleLine) do
		local itemBtn = v:getChildByName("Button_scale")
		local itemText = v:getChildByName("Button_text")
		local realIndex = k + (self.curPage - 1) * SCALE_IN_PAGE
		local info = NARD.data[realIndex]
		if info then
			itemText:setString(SoraDConvertNumberWithUnit(info.amount))
			if k == self.selectTag then
				itemBtn:loadTextureNormal("btn_xfczhk_02.png", ccui.TextureResType.plistType)
			else
				itemBtn:loadTextureNormal("btn_xfczhk_01.png", ccui.TextureResType.plistType)
			end
		end
	end
end
function totalPayActivityView:getHelpInfo(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("common_text_1177")
		;("common_text_1173")[2] = i18n("common_text_1177")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
function totalPayActivityView:updateItem(item, itemInfo)
	local itemBg = SoraDGetChildByName(item, "Image_itemBg")
	local itemImage = SoraDGetChildByName(item, "Image_item")
	local itemName = SoraDGetChildByName(item, "Text_name")
	local itemCount = SoraDGetChildByName(item, "Text_count")
	local itemBtn = SoraDGetChildByName(item, "Button_item")
	itemBg:loadTexture(publicRead.getBg(itemInfo.id), ccui.TextureResType.plistType)
	itemImage:loadTexture(publicRead.getIcon(itemInfo.id), ccui.TextureResType.plistType)
	itemName:setString(publicRead.getName(itemInfo.id))
	itemCount:setString("x" .. itemInfo.num)
end
function totalPayActivityView:clickRewardItem(index, button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		SoraDCloseCommonTips()
	elseif type == ccui.TouchEventType.began then
		self.tips = SoraDCreatePanel("commonItemTips")
		local cumuScale = (self.curPage - 1) * SCALE_IN_PAGE + self.selectTag
		local reward = SoraDIntArr2FormatTable(NARD.data[cumuScale].reward)
		SoraDShowCommonTips(button, reward[index].id)
	end
end
function totalPayActivityView:clickPageBtn(isLeft, target, eventType)
	if eventType == ccui.TouchEventType.began then
		local newPage = self.curPage
		if isLeft then
			newPage = math.max(self.curPage - 1, 1)
		else
			newPage = math.min(self.curPage + 1, self.maxPage)
		end
		if self.curPage ~= newPage then
			self.curPage = newPage
			self.selectTag = 1
			self:updatePage()
		end
	end
end
function totalPayActivityView:updatePage()
	self:refreshScale()
	self:refreshRewardList((self.curPage - 1) * SCALE_IN_PAGE + self.selectTag)
	self:refreshBtnstatus()
	self.leftPageBtn:setVisible(self.curPage ~= 1)
	self.rightPageBtn:setVisible(self.curPage ~= self.maxPage)
end
return totalPayActivityView
