local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local dashToSkyShopView = class("dashToSkyShopView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local itemSize = cc.size(630, 165)
function dashToSkyShopView:ctor()
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.txtToken = SoraDGetChildByName(self, "Text_token")
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	self.img_icon = SoraDGetChildByName(self, "Image_icon")
	self.img_icon:loadTexture("1035_2.png", ccui.TextureResType.plistType)
	self.txtActivieyTime = SoraDCreateTimerLabel(self, self.txtActivieyTime)
	self.txtActivieyTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_4451", nil)
	end)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:setSingleCCS("royalSummonsMainShopSingle")
	self.tableCurItems, _ENV = self.scroll.setSingleCCS, self.scroll.setSingleCCS
end
function dashToSkyShopView:showEffect()
	local cssFileName = "dashToSkyShopView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
	self.cloud_1 = SoraDGetChildByName(self, "Node_Yun_1")
	self.cloud_2 = SoraDGetChildByName(self, "Node_Yun_2")
	local formPoX = SoraDFIsRA() and -800 or 800
	self.cloud_1:setPositionX(-formPoX)
	self.cloud_2:setPositionX(0)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.moveTo(55.5, formPoX, 20)
	;(nil)[2] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	;(nil)[3] = cca.moveTo(27.75, 0, 20)
	;(nil)[4] = cca.moveTo(27.75, 0, 20)
	;(nil)[5] = cca.moveTo(27.75, 0, 20)
	;(nil)[6] = cca.moveTo(27.75, 0, 20)
	self.cloud_1:runAction(cca.repeatForever(cca.seq(nil)))
	_UPVALUE2_ = cca.repeatForever(cca.seq(nil))
	cca.repeatForever(cca.seq(nil))[1] = cca.moveTo(27.75, formPoX, 20)
	cca.repeatForever(cca.seq(nil))[2] = cca.callFunc(function()
		self.cloud_2:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(nil))[3] = cca.moveTo(27.75, 0, 20)
	cca.repeatForever(cca.seq(nil))[4] = cca.moveTo(27.75, 0, 20)
	cca.repeatForever(cca.seq(nil))[5] = cca.moveTo(27.75, 0, 20)
	cca.repeatForever(cca.seq(nil))[6] = cca.moveTo(27.75, 0, 20)
	self.cloud_2:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
end
function dashToSkyShopView:init()
	SoraDCloseLoading(self)
	self:updateTokenInfo()
	self:updateActivityTime()
	self:initScrollList()
end
function dashToSkyShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_SHOP", handler(self, self.init))
end
function dashToSkyShopView:updateActivityTime()
	local time = royalSummonsCtrl:getActivityStatusTime()
	if 0 < time then
		self.txtActivieyTime:beginTime(time)
	end
end
function dashToSkyShopView:updateTokenInfo()
	local tokenNum = royalSummonsCtrl:getKingTokenNum()
	royalSummonsCtrl = nil
	;(nil).num = string.formatnumberthousands(tokenNum)
	self.txtToken:setString(i18n("summoned_text_62", nil))
	SoraDSetTextWidthHeight(self.txtToken, cc.size(180, 50))
	_UPVALUE3_ = 590
	;(590)[1] = self.img_icon
	;(590)[2] = self.txtToken
	;(590)[3] = self.btnHelp
	_UPVALUE2_ = self.txtToken
	self.txtToken[1] = 10
	self.txtToken[2] = 5
	_G.SoraDAlignNodeArrayOnBeginX(SoraDFPosX(590), 590, SoraDFIsRA(), self.txtToken)
end
function dashToSkyShopView:initScrollList()
	self:updateScrollData()
	self.scroll:jumpToTop()
end
function dashToSkyShopView:updateScrollData()
	local royalSummonsRead = include("royalSummonsRead")
	self.tableCurItems = royalSummonsRead:getShopItemList(royalSummonsCtrl:getClassType())
	_ENV = royalSummonsCtrl:getClassType()
	royalSummonsCtrl:getClassType().scroll = self.scroll
	royalSummonsCtrl:getClassType().view = self
	royalSummonsCtrl:getClassType().mainView = self
	self.scroll:updateScrollView(itemSize, self.tableCurItems, 1, royalSummonsCtrl:getClassType())
end
function dashToSkyShopView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("summoned_text_68")
		;("common_text_1173")[2] = i18n("summoned_text_68")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
function dashToSkyShopView:scrollMove()
	self.topLeftImage:setPositionY(-90 + (1136 - self:getPanelOffsetHeight() + 300) / 100 * self.scroll:getScrolledPercentVertical())
end
return dashToSkyShopView
