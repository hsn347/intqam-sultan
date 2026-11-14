local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
local petraRareTreasureShopView = class("petraRareTreasureShopView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local itemSize = cc.size(310, 190)
function petraRareTreasureShopView:ctor()
	self.txtToken = SoraDGetChildByName(self, "Text_token")
	self.img_icon = SoraDGetChildByName(self, "Image_icon")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self.scroll = include("royalSummonsShopScrollList").new(self.scroll)
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:setSingleCCS("petraRareTreasureShopSingle")
	self.nodeBg = SoraDGetChildByName(self, "shopItem_bg")
	self.nodeBg:setVisible(false)
	self.tableCurItems, _ENV = self.nodeBg.setVisible, self.nodeBg.setVisible
end
function petraRareTreasureShopView:init()
	SoraDCloseLoading(self)
	self:updateTokenInfo()
	self:initScrollList()
end
function petraRareTreasureShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_REFRESH", handler(self, self.init))
end
function petraRareTreasureShopView:updateTokenInfo()
	local tokenNum = petraRareTreasureCtrl:getUnLockLuckyCoin()
	petraRareTreasureCtrl = nil
	;(nil).num = string.formatnumberthousands(tokenNum)
	self.txtToken:setString(i18n("petra_text_06", nil))
	_UPVALUE3_ = i18n("petra_text_06", nil)
	i18n("petra_text_06", nil)[1] = self.img_icon
	i18n("petra_text_06", nil)[2] = self.txtToken
	i18n("petra_text_06", nil)[3] = self.btnHelp
	_UPVALUE2_ = self.txtToken
	self.txtToken[1] = 5
	self.txtToken[2] = 10
	_G.SoraDAlignNodeArrayOnCenterX(320, i18n("petra_text_06", nil))
end
function petraRareTreasureShopView:initScrollList()
	self:updateScrollData()
	self.scroll:jumpToTop()
end
function petraRareTreasureShopView:updateScrollData()
	local activityExchangeMallRead = include("activityExchangeMallRead")
	self.tableCurItems = activityExchangeMallRead:getShopItemList(gActivityTimeActivityID.PETRA_RARE_TREASURE)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).mainView = self
	self.scroll:updateScrollView(itemSize, self.tableCurItems, 2, nil)
	local singleBgClone = function()
		local singlebg = self.nodeBg:clone()
		singlebg:setVisible(true)
		return singlebg
	end
	self.scroll:setBgCreateHandle(singleBgClone)
	self.scroll:updateRowBg()
end
function petraRareTreasureShopView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("petraRareTreasureRecordsView"):show()
	end
end
return petraRareTreasureShopView
