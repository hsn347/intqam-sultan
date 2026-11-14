local allianceltCtrl = include("allianceltCtrl")
local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local AllianceShopSingleBuy = class("allianceShopSingleBuy", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("shopSingleBuy")
	end
	return target
end)
function AllianceShopSingleBuy:ctor()
	self.tableData, _ENV, self.type = gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR
	self.labelPay = SoraDGetChildByName(self, "Text_needPay")
	self.Node_next = SoraDGetChildByName(self, "Node_next")
	self.Node_next:setVisible(false)
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.Node_ori = SoraDGetChildByName(self, "Node_ori")
	self.Node_ori:setVisible(false)
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labNotice = SoraDGetChildByName(self, "Text_notice")
	self.btnBuy = SoraDGetChildByName(self, "Button_Buy")
	self.bagShopSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.bagShopSlider:setSliderCallBack(handler(self, self.payGoldChange))
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItems_item")
	self.imgGole = SoraDGetChildByName(self, "Image_gold")
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.textLimit = ccui.Text:create()
	self.textLimit:setColor(cc.c3b(165, 129, 70))
	self.textLimit:setAnchorPoint(cc.p(0.5, 0.5))
	self.textLimit:setPosition(320, 35)
	self.textLimit:setFontSize(20)
	self.textLimit:addTo(self.Panel_touch, 10)
	SoraDChangeTextToHtml(self.textLimit)
	self.Text_time = ccui.Text:create()
	self.Text_time:setColor(cc.c3b(165, 129, 70))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setAnchorPoint(cc.p(SoraDFIsRA() and 1 or 0, 0.5))
	self.Text_time:setPosition(SoraDFPosX(425, 640), 270)
	self.Text_time:setFontSize(20)
	self.Text_time:addTo(self.Panel_touch, 10)
	self.Text_time:setVisible(false)
	self.needBuy = 0
	self.handle = nil
	self.btnBuy:addTouchEventListener(handler(self, self.onBuy))
end
function AllianceShopSingleBuy:setHandle(handle)
	self.handle = handle
end
function AllianceShopSingleBuy:setActionData(fromPos)
	_ENV = nil
	;(nil).x = self.item:getPositionX()
	self.oldPos, (nil).y = nil, self.item:getPositionY()
	fromPos = self.item:getParent():convertToNodeSpace(fromPos)
	self.item:setPosition(fromPos)
	self.item:setScale(0.5)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.3, 1)
	;(nil)[2] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[3] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[4] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[5] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	self.item:runAction(cca.spawn(nil))
end
function AllianceShopSingleBuy:onBuy(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.needBuy > 0 then
			if self.type == gIDDef.ALLIANCE_HONOR then
				allianceStore:reqAllianceStoreBuy(self.tableData.itemID, self.needBuy)
			else
				allianceStore:reqAllianceItemShopBuy(self.tableData.itemID, self.needBuy)
			end
			if self.handle then
				self.handle()
			end
		else
			SoraDShowMsgTip(i18n("common_text_2632"), itemDesRead.getIcon(self.tableData.itemID, true))
		end
		self:removeFromParent()
	end
end
function AllianceShopSingleBuy:setLimited(endtime)
	self.Text_time:setVisible(true)
	self.labelDes:setTextAreaSize(cc.size(380, 90))
	self.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).var1 = time
		return i18n("allianceShop_timeLimit_name", nil)
	end)
	local leftTime = endtime - serviceFunctions.systemTime()
	self.Text_time:beginTime(leftTime)
	self.Text_time:setTimeEndListener(function()
		self:removeFromParent()
	end)
end
function AllianceShopSingleBuy:initData(data, type)
	self.type = type
	self.tableData = data.itemData
	local havePoint = data.totalPoint
	allianceltCtrl = nil
	;(nil).itemID = self.tableData.itemID
	self.item:initData(nil)
	local personalLimit = allianceltCtrl:getMaxBuyCount(self.tableData.itemID)
	local cMember = memberMgr:getOwnMember()
	local itemCount = math.min(self.tableData.itemCount or 9999, math.max(1, math.floor(havePoint / self.tableData.pay)))
	if personalLimit and self.type == gIDDef.ALLIANCE_HONOR then
		local aStoreBuyInfo = cMember:getProperty("aStoreBuyInfo")
		local itemID = tostring(self.tableData.itemID)
		local lastBuyTime = aStoreBuyInfo[itemID] and aStoreBuyInfo[itemID].time or 0
		local buyCount = 0
		if serviceFunctions.isSameDay(lastBuyTime) then
			buyCount = aStoreBuyInfo[itemID] and aStoreBuyInfo[itemID].count or 0
		end
		itemCount = math.min(itemCount, personalLimit - buyCount)
		self.textLimit:setVisible(true)
		allianceltCtrl = math.max(1, math.floor(havePoint / self.tableData.pay))
		math.max(1, math.floor(havePoint / self.tableData.pay)).left = personalLimit - buyCount
		allianceltCtrl, allianceltCtrl, math.max(1, math.floor(havePoint / self.tableData.pay)).total = math.max(1, math.floor(havePoint / self.tableData.pay))
		;(personalLimit - buyCount).left, math.max(1, math.floor(havePoint / self.tableData.pay)).color = math.max(1, math.floor(havePoint / self.tableData.pay))
		self.textLimit:setString(i18n_html("pray_text_14", math.max(1, math.floor(havePoint / self.tableData.pay))))
		self.btnBuy:setPositionY(90)
	else
		self.textLimit:setVisible(false)
		self.btnBuy:setPositionY(65)
	end
	local maxCount = itemCount
	if self.type == gIDDef.ALLIANCE_HONOR then
		if false then
			maxCount = count
			local labelMaxCount = self.labNotice:clone()
			self.labNotice:setPositionY(210)
			labelMaxCount:setPositionY(180)
			labelMaxCount:addTo(self.labNotice:getParent())
			allianceltCtrl = self.labNotice:getParent()
			self.labNotice:getParent().count = maxCount
			labelMaxCount:setString(i18n("common_text_2842", self.labNotice:getParent()))
		end
		allianceltCtrl = i18n("common_text_2842", self.labNotice:getParent())
		i18n("common_text_2842", self.labNotice:getParent()).item = itemDesRead.getName(self.tableData.itemID)
		self.labNotice:setString(i18n("common_text_662", i18n("common_text_2842", self.labNotice:getParent())))
		self.imgGole:loadTexture("icon_alliance_honor.png", ccui.TextureResType.plistType)
	else
		self.labelPay:setColor(cc.c3b(255, 255, 0))
		allianceltCtrl = cc.c3b(255, 255, 0)
		cc.c3b(255, 255, 0).item = itemDesRead.getName(self.tableData.itemID)
		self.labNotice:setString(i18n("common_text_663", cc.c3b(255, 255, 0)))
		self.imgGole:loadTexture("icon_alliance_point.png", ccui.TextureResType.plistType)
	end
	allianceltCtrl = "icon_alliance_point.png"
	;("icon_alliance_point.png").maxValue = math.min(itemCount, maxCount)
	;("icon_alliance_point.png").minValue = 1
	;("icon_alliance_point.png").curValue = 1
	self.bagShopSlider:initData("icon_alliance_point.png")
	self.labelName:setString(itemDesRead.getName(self.tableData.itemID))
	self.labelDes:setString(itemDesRead.getDes(self.tableData.itemID))
	self.imgGole:ignoreContentAdaptWithSize(true)
	self.imgGole:setScale(0.9)
end
function AllianceShopSingleBuy:payGoldChange(needBuy)
	self.needBuy = needBuy
	self.labelPay:setString(string.formatnumberthousands(self.needBuy * self.tableData.pay))
	SoraDToCenter(self.Node_gold)
end
return AllianceShopSingleBuy
