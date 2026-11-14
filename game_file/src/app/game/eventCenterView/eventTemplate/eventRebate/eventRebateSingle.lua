local gametop = gModuleMgr.getObject("gametop")
local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
local eventRebateSingle = class("eventRebateSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRebateSingle")
	end
	return target
end)
function eventRebateSingle:ctor()
	self.data, _ENV = nil, nil
	self.isReach = false
	self.Button_receive = SoraDGetChildByName(self, "Button_receive")
	self.Button_receive = include("commonBtnInstance").new(self.Button_receive)
	self.Button_receive:setHandle(handler(self, self.btnReceiveClick))
	SoraDAutoSizeButtonTextByContent(self.Button_receive)
	self.Text_condition = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_condition"))
	self.Text_gold = SoraDGetChildByName(self, "Text_gold")
	self.Image_box = SoraDGetChildByName(self, "Image_box")
	self.boxEffect = SoraDCreatAnimation("czflBox")
	self.boxEffect:addTo(self.Image_box, 2)
	self.boxEffect:setPosition(67, 74)
	self.boxEffect:setVisible(false)
end
function eventRebateSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.hasBuy = otherData.hasBuy
	self.packageID = otherData.packageID
	self.Button_receive:setScroll(self.scroll)
	local needCastleLv = data.castleLevel
	local curCastleLv = math.min(SoraDGetCastleLv(), CASTLE_MAXLV_NOWAR)
	self.isReach = needCastleLv <= curCastleLv
	local goldNum = self.data.reward[2] or 0
	self.Text_gold:setString(string.formatnumberthousands(goldNum))
	if not self.hasBuy then
		self.Button_receive:setTouchEnabled(false)
		self.Button_receive:setTitleText(i18n("common_text_1146"))
		self.Button_receive:setTitleColor(display.COLOR_WHITE)
	else
		self.Button_receive:setTouchEnabled(true)
		if self.isReach then
			if not self.data.hasReceive then
				self.Button_receive:setTitleText(i18n("common_text_1146"))
				self.Button_receive:setTitleColor(display.COLOR_WHITE)
			else
				self.Button_receive:setTitleText(i18n("common_text_1892"))
				self.Button_receive:setTouchEnabled(false)
				self.Button_receive:setTitleColor(cc.c3b(120, 120, 120))
			end
		else
			self.Button_receive:setTitleText(i18n("common_text_2274"))
			self.Button_receive:setTitleColor(display.COLOR_RED)
		end
	end
	local str = ""
	local textColor = cc.c3b(215, 195, 155)
	if self.isReach then
		self.Text_condition:setColor(textColor)
		_ENV = textColor
		textColor.num = curCastleLv
		textColor.num1 = needCastleLv
		str = i18n("Gather_text_17", textColor)
	else
		self.Text_condition:setColor(display.COLOR_WHITE)
		_ENV = display.COLOR_WHITE
		display.COLOR_WHITE.num = curCastleLv
		_ENV, _ENV, display.COLOR_WHITE.num1 = i18n("common_text_2274")
		_ENV, i18n("common_text_2274").num, i18n("common_text_2274").color = i18n("common_text_2274")
		i18n("common_text_2274").__default, i18n("common_text_2274").color = i18n("common_text_2274")
		str = i18n_html("Gather_text_17", display.COLOR_WHITE, i18n("common_text_2274"))
	end
	self.Text_condition:setString(str)
	if self.hasBuy and self.isReach then
		if self.data.hasReceive then
			self.Image_box:loadTexture("icon_coinbox_clear.png", ccui.TextureResType.plistType)
			self.boxEffect:setVisible(false)
		else
			self.Image_box:loadTexture("icon_coinbox_open.png", ccui.TextureResType.plistType)
			self.boxEffect:setVisible(true)
		end
		self.Image_box:setPositionY(83)
	else
		self.Image_box:loadTexture("icon_coinbox_close.png", ccui.TextureResType.plistType)
		self.Image_box:setPositionY(93)
		self.boxEffect:setVisible(false)
	end
end
function eventRebateSingle:btnReceiveClick()
	if self.isReach then
		ladderGiftCtrl:receiveGrowUpReward(self.packageID, self.data.castleLevel)
	else
		SoraDShowMsgTip(i18n("remains_text_20"))
	end
end
return eventRebateSingle
