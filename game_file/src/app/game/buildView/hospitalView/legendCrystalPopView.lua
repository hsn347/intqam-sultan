local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local legendCrystalPopView = class("legendCrystalPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("legendCrystalPopView")
	end
	return target
end)
function legendCrystalPopView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Sprite_res = SoraDGetChildByName(self, "Sprite_res")
	self.Text_own = SoraDGetChildByName(self, "Text_own")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy:setTitleText(i18n("sheepFeed_text_13"))
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyCallBack))
	SoraDAutoSizeButtonTextByContent(self.Button_buy)
	local legendKingRead = include("legendKingRead")
	local shopTpye = legendKingRead.shopTpye
	if worldMapDefine.isInLegendLord() and legendKingRead.checkUnlockConditions(shopTpye.LEGEND_CRYSTAL) then
		self.Button_buy:setPositionX(120)
		local button_shop = self.Button_buy:clone()
		button_shop:addTo(self.Button_buy:getParent())
		button_shop:setTitleText(i18n("worldshop_text_09"))
		button_shop:addTouchEventListener(handler(self, self.btnShopCallBack))
		button_shop:setPositionX(-120)
		SoraDAutoSizeButtonTextByContent(button_shop)
	end
end
function legendCrystalPopView:btnBuyCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInNebulaEmperor() then
			local nebulaEmperorUtil = include("nebulaEmperorUtil")
			nebulaEmperorUtil.openGiftView()
			return
		end
		_UPVALUE1_ = nebulaEmperorUtil
		local include("nebulaEmperorUtil")[1], giftArray = 14577, include("nebulaEmperorUtil")
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeIDList = giftArray
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(22, giftArray)
			panel:show()
		end
	end
end
function legendCrystalPopView:btnShopCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			local panel = SoraDCreatePanelByFixName("kingStarShopView")
			panel:jumpToTypeCrystal()
			panel:show()
		else
			local panel = SoraDCreatePanel("legendaryShopView")
			panel:jumpToTypeCrystal()
			panel:show()
		end
	end
end
function legendCrystalPopView:initCrystalID(crystalID)
	self.crystalID = crystalID
	local itemName = publicRead.getName(crystalID)
	self.ccs_bg:setTitleName(itemName)
	local itemIcon = publicRead.getIcon(crystalID)
	self.Sprite_res:setSpriteFrame(itemIcon)
	local resCount = cityCtrl:getResCount(crystalID)
	publicRead = nil
	;(nil).num = SoraDConvertNumberWithUnit(resCount)
	self.Text_own:setString(i18n("common_text_531", nil))
	local itemDes = publicRead.getDes(crystalID)
	self.Text_des:setString(itemDes)
end
return legendCrystalPopView
