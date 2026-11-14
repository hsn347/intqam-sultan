local gametop = gModuleMgr.getObject("gametop")
local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local LevelUpInfoList = require("app." .. LocalTblPath .. ".config_server.grownup_found_config")
local eventValueRebateView = class("eventValueRebateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)
_ENV, _UPVALUE9_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end, "eventValueRebateView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end).x = 100
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end).y = nil, 480
;(nil).x = 270
_ENV, (nil).y = nil, 480
;(nil).x = 440
_ENV, (nil).y = nil, 480
;(nil).x = 440
_ENV, (nil).y = nil, 300
;(nil).x = 270
_ENV, (nil).y = nil, 300
;(nil).x = 100
_ENV, (nil).y = nil, 300
;(nil).x = 100
_ENV, (nil).y = nil, 120
;(nil).x = 270
_ENV, (nil).y = nil, 120
;(nil).x = 440
;(nil).y = 120
_ENV, _UPVALUE8_, ("eventValueRebateView")[1] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[2] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[3] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[4] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[5] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[6] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[7] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
_ENV, _UPVALUE8_, ("eventValueRebateView")[8] = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
local _ENV, _UPVALUE8_, ("eventValueRebateView")[9], boxPos = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end, nil, "eventValueRebateView"
;(nil).x = 170
;(nil).y = 480
_ENV, (nil).angle = nil, 0
;(nil).x = 340
;(nil).y = 480
_ENV, (nil).angle = nil, 0
;(nil).x = 440
;(nil).y = 370
_ENV, (nil).angle = nil, 90
;(nil).x = 340
;(nil).y = 300
_ENV, (nil).angle = nil, 0
;(nil).x = 170
;(nil).y = 300
_ENV, (nil).angle = nil, 0
;(nil).x = 100
;(nil).y = 210
_ENV, (nil).angle = nil, 90
;(nil).x = 170
;(nil).y = 120
_ENV, (nil).angle = nil, 0
;(nil).x = 340
;(nil).y = 120
;(nil).angle = 0
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[1] = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[2] = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[3] = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[4] = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[5] = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[6] = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[7] = nil
local (function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end)[8], linePos = nil, function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView")
	end
	return target
end
function eventValueRebateView:ctor()
	self:initControls()
end
function eventValueRebateView:initControls()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.scroll = SoraDGetChildByName(self, "ScrollView_1")
	self.panelBg = SoraDGetChildByName(self, "Panel_17")
	self.imgBgLeft = SoraDGetChildByName(self, "Image_141_0")
	self.imgBgRight = SoraDGetChildByName(self, "Image_141")
	self.imgBlockLeft = SoraDGetChildByName(self, "Image_161")
	self.imgBlockRight = SoraDGetChildByName(self, "Image_161_0")
	self.txtIns = SoraDGetChildByName(self, "text_ins")
	self.nodeAward = SoraDGetChildByName(self, "Node_award")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.ccs_title:setTitle(i18n("activity_name_26"))
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btnTouch:addTouchEventListener(handler(self, self.btnSingleClick))
	self.infoList = self:getLevelUpInfoList()
	self.packageList = ladderGiftCtrl:getGrowUpLadderGiftList()
	self:setFitDevices()
	self:initData()
end
function eventValueRebateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VALUE_REBATE_BUY_REFRESH", function(...)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_VALUE_REBATE_RECEIVE_REFRESH", function(...)
		self:initData()
		self:judgeClose()
	end)
end
function eventValueRebateView:initData()
	local nowPrice = paymentManager.judgePrice(self.packageList[1].ID, self.packageList[1].price)
	if ladderGiftCtrl:getGrowUpBuyRecord(self.packageList[1].ID) then
		self.btnBuy:setTitleText(i18n("common_text_1146"))
		local color = cc.c3b(255, 255, 255)
		local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		local needCastleLv = 1
		for i, v in ipairs(self.infoList) do
			if not ladderGiftCtrl:getGrowUpReceive(self.packageList[1].ID, v.castleLevel) then
				needCastleLv = v.castleLevel
				break
			end
		end
		if curCastleLv < needCastleLv then
			color = cc.c3b(255, 0, 0)
		end
		self.btnBuy:setTitleColor(color)
	else
		self.btnBuy:setTitleText(nowPrice)
	end
	_ENV = self.btnBuy
	self.btnBuy.prise = nowPrice
	self.btnBuy.reward = string.formatnumberthousands(VALUE_REBATE_AWARD_GOLD)
	self.txtIns:setString(i18n("grownup_text_01", self.btnBuy))
	self.txtIns:setFontSize(16)
	SoraDSetTextWidthHeight(self.txtIns, cc.size(600, 60))
	self:initScroll()
	_ENV, ladderGiftCtrl = cc.size(600, 60)
	cc.size(600, 60).rechargeID = self.packageList[1].ID
	self[1] = cc.size(600, 60)
	SoraDCreateRechargeGiftNode(self, SoraDGetChildByName(self, "Panel_cut"), cc.p(50, 100))
end
function eventValueRebateView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(self.scroll:getContentSize().height, 170 * math.ceil(#self.infoList / 3))
	self.scroll:setInnerContainerSize(cc.size(500, scrollH))
	local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local hasBuy = ladderGiftCtrl:getGrowUpBuyRecord(self.packageList[1].ID)
	for i, v in ipairs(self.infoList) do
		local lineEffect
		if i ~= #self.infoList then
			lineEffect = SoraDCreatAnimation("czfl")
			SoraDMixtureGLONE(lineEffect:getChildByName("Sprite_3"))
			lineEffect:setPosition(cc.p(linePos[i].x, linePos[i].y))
			lineEffect:setRotation(linePos[i].angle)
			lineEffect:addTo(self.scroll)
		end
		local cell = self.nodeAward:clone()
		cell:setPosition(cc.p(boxPos[i].x, boxPos[i].y))
		cell:addTo(self.scroll)
		local boxEffect = SoraDCreatAnimation("czflBox")
		SoraDMixtureGLONE(boxEffect:getChildByName("Sprite_1"))
		SoraDMixtureGLONE(boxEffect:getChildByName("Sprite_2"))
		boxEffect:setVisible(false)
		boxEffect:addTo(cell)
		local cellBtn = SoraDGetChildByName(cell, "Button_touch")
		cellBtn:setTag(i)
		cellBtn:setSwallowTouches(false)
		local cellTxt = SoraDGetChildByName(cell, "Text_lv")
		_ENV = boxEffect:getChildByName("Sprite_2")
		boxEffect:getChildByName("Sprite_2").lv = v.castleLevel
		cellTxt:setString(i18n("common_text_100", boxEffect:getChildByName("Sprite_2")))
		local cellGoldTxt = SoraDGetChildByName(cell, "BitmapFontLabel_5")
		local goldNum = v.reward[2] or 0
		cellGoldTxt:setString("x" .. string.formatnumberthousands(goldNum))
		local cellImg = SoraDGetChildByName(cell, "Image_item")
		if curCastleLv < v.castleLevel or not hasBuy then
			if lineEffect then
				lineEffect:setOpacity(102.0)
			end
			cellImg:loadTexture("icon_coinbox_close.png", ccui.TextureResType.plistType)
		else
			if lineEffect then
				if curCastleLv < self.infoList[i + 1].castleLevel then
					lineEffect:setOpacity(102.0)
				else
					lineEffect:setOpacity(255)
				end
			end
			if not ladderGiftCtrl:getGrowUpReceive(self.packageList[1].ID, v.castleLevel) then
				boxEffect:setVisible(true)
				cellImg:loadTexture("icon_coinbox_open.png", ccui.TextureResType.plistType)
			else
				cellImg:loadTexture("icon_coinbox_clear.png", ccui.TextureResType.plistType)
			end
		end
	end
end
function eventValueRebateView:getLevelUpInfoList()
	local _ENV, tbl
	for i, v in ipairs(LevelUpInfoList) do
		if v.type == 2 then
			table.insert(tbl, v)
		end
	end
	return tbl
end
function eventValueRebateView:btnBuyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local needCastleLv = 1
		local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		for i, v in ipairs(self.infoList) do
			if not ladderGiftCtrl:getGrowUpReceive(self.packageList[1].ID, v.castleLevel) then
				needCastleLv = v.castleLevel
				break
			end
		end
		if ladderGiftCtrl:getGrowUpBuyRecord(self.packageList[1].ID) then
			if curCastleLv < needCastleLv then
				_ENV = nil
				;(nil).lv = needCastleLv
				SoraDShowMsgTip(i18n("common_text_2563", nil))
				return
			end
			ladderGiftCtrl:receiveGrowUpReward(self.packageList[1].ID, needCastleLv)
		else
			paymentManager.normalGiftBuyClassify(self.packageList[1].ID)
		end
	end
end
function eventValueRebateView:judgeClose()
	if not ladderGiftCtrl:getGrowUpHasEnter() then
		self:removeFromParent()
	end
end
function eventValueRebateView:btnSingleClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.infoList[button:getTag()] and self.infoList[button:getTag()].reward and next(self.infoList[button:getTag()].reward) then
			local panel = SoraDCreatePanel("rewardDetailView")
			panel:initData(self.infoList[button:getTag()].reward)
			panel:show()
		end
	end
end
function eventValueRebateView:setFitDevices()
	self.panelBg:setContentSize(cc.size(display.width, display.height))
	self.panelBg:setPositionY(-display.height)
	if device.isIphoneXMode() then
		self.imgBgLeft:setContentSize(cc.size(display.width / 2, 1180))
		self.imgBgRight:setContentSize(cc.size(display.width / 2, 1180))
		self.imgBlockLeft:setPositionY(-1180)
		self.imgBlockRight:setPositionY(-1180)
		self.scroll:setContentSize(cc.size(550, 560))
		return
	end
	if display.height > 960 then
		self.imgBgLeft:setContentSize(cc.size(display.width / 2, 1025))
		self.imgBgRight:setContentSize(cc.size(display.width / 2, 1025))
		self.imgBlockLeft:setPositionY(-1025)
		self.imgBlockRight:setPositionY(-1025)
	elseif math.floor(display.height) == 853 then
		self.imgBgLeft:setContentSize(cc.size(display.width / 2, 800))
		self.imgBgRight:setContentSize(cc.size(display.width / 2, 800))
		self.imgBlockLeft:setPositionY(-800)
		self.imgBlockRight:setPositionY(-800)
		self.scroll:setContentSize(cc.size(550, 480))
	end
end
return eventValueRebateView
