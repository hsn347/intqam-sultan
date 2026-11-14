local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local summerPrayersFailedView = class("summerPrayersFailedView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("summerPrayersFailedView")
end)
function summerPrayersFailedView:ctor(properties)
	self.itemID = summerPrayCtrl:getItemID()
	self.enableTouchCloseSelf = true
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.scaleActTarget, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("pray_text_07"))
	self.nodeAward = SoraDGetChildByName(self.scaleActTarget, "Node_Award")
	self.textDescribe = SoraDGetChildByName(self.scaleActTarget, "Text_Describe")
	self.btnSure = SoraDGetChildByName(self.scaleActTarget, "Button_Sure")
	self.btnSure:setTouchEnabled(true)
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnClickSure))
	self.btnPray = SoraDGetChildByName(self.scaleActTarget, "Button_Pray")
	self.btnPray:setTouchEnabled(true)
	self.btnPray:addTouchEventListener(handler(self, self.btnPrayerClick))
	self:setSwallowTouches(true)
	self.nodePray = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self, "Text_Pray")
	SoraDGetChildByName(self, "Text_1"):setString("*1")
	self.textPray:setString(i18n("pray_text_26"))
	SoraDToCenter(self.nodePray, 0, not SoraDFIsRA())
	print("lth--------summerPrayersFailedView-open")
end
function summerPrayersFailedView:initData(data)
	SoraDPrint(data)
	self.textDescribe:setString(i18n("pray_text_16"))
	self.award = data.packreward
	for i, v in ipairs(data.packreward) do
		local single = include("commonItemAward").new()
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setPositionY(0)
		single:addTo(self.nodeAward)
		single:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeAward, 100, SoraDFIsRA())
end
function summerPrayersFailedView:btnClickSure(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_SUMMER_PRAY_VIEW"
		;(nil).subMsg = "updateView"
		SoraDSendMessage(nil)
		SoraDMailGainItems(self.award, true)
		self:removeFromParent()
	end
end
function summerPrayersFailedView:btnPrayerClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_SUMMER_PRAY_VIEW"
		;(nil).subMsg = "updateView"
		SoraDSendMessage(nil)
		local tag = target:getTag()
		if backpackCtrl:getItemCount(self.itemID) <= 0 then
			SoraDShowMsgBox(i18n("pray_text_15"), i18n("common_text_204"), nil, handler(self, self.openShopView))
		else
			summerPrayCtrl:reqSummerPrayBless()
		end
		self:removeFromParent()
	end
end
function summerPrayersFailedView:openShopView(type)
	if MSGBOX_CALLBACK_YES == type then
		uiManager:show("summerPrayersShop")
	end
end
return summerPrayersFailedView
