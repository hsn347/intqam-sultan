local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_progress", com_Meteorite_progress)
local meteorMagicRead = include("meteorMagicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemLogic = include("itemLogic")
local shopCtrl = SoraDGetCtrl("shopCtrl")
function com_Meteorite_progress:onInit()
	if not SoraDFIsRA() then
		self.fields.progress:fixChildrenPos(false, true)
	end
	self.fields.button_add:addClickEventListener(handler(self, self.addExpClick))
	self.fields.btn_tip:addClickEventListener(handler(self, self.tipClick))
end
function com_Meteorite_progress:onShow()
end
function com_Meteorite_progress:setData(curExp, curLv, curProjectID)
	local lvCfg, isMax = meteorMagicRead.getCurLvCfg(curLv)
	curExp = meteorMagicRead.getCurLvExp(curExp)
	meteorMagicRead = nil
	;(nil).num = curLv
	self.fields.text_lv:setString(i18n("meteoritesmagic_text_3", nil))
	self.fields.button_add:setVisible(not isMax)
	if isMax then
		self.fields.progress:setMax(lvCfg.needExp)
		self.fields.progress:setValue(lvCfg.needExp)
		fguiHelper.get_fields(self.fields.progress).title:setString("MAX")
	else
		self.fields.progress:setMax(lvCfg.needExp)
		self.fields.progress:setValue(curExp)
		fguiHelper.get_fields(self.fields.progress).title:setString(curExp .. "/" .. lvCfg.needExp)
	end
	self.lvCfg = lvCfg
	self.curProjectID = curProjectID
end
function com_Meteorite_progress:addExpClick()
	self.resList = backpackltCtrl:getItemArray(gItemType.METEOR_MAIGC_EXP)
	if not self.resList or not self.resList then
		backpackltCtrl = self.resList
	end
	self.itemSingleInfos, backpackltCtrl, self.resList = self.resList, self.resList, self.resList
	for i, v in ipairs(self.resList) do
		local itemSingleInfo = self:createItemSingleInfo(v)
		if itemSingleInfo then
			table.insert(self.itemSingleInfos, itemSingleInfo)
		end
	end
	table.sort(self.itemSingleInfos, function(a, b)
		return a.iid < b.iid
	end)
	if #self.itemSingleInfos <= 0 then
		SoraDShowMsgBoxNew(i18n("meteoritesmagic_text_54"), i18n("common_text_477"), nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local curState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
			if curState == gActivityState.OPEN then
				uiManager:show("Shiftingstars")
				return
			end
			SoraDShowMsgTip(i18n("nebula_war_text_0175"))
			return
		end)
		return
	end
	backpackltCtrl = nil
	;(nil).curProjectID = self.curProjectID
	uiManager:show("MeteoriteExpBuy", nil)
end
function com_Meteorite_progress:tipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).num = self.lvCfg.talentNum
	_ENV = "meteoritesmagic_text_8"
	;("meteoritesmagic_text_8").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("meteoritesmagic_text_8", nil), "meteoritesmagic_text_8")
end
function com_Meteorite_progress:createItemSingleInfo(itemID)
	local isAllowShow = true
	local backpackCtrl, itemSingleInfo
	local itemCount = backpackCtrl:getItemCount(itemID)
	local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
	local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
	if 0 < itemCount then
		if itemInfo then
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			shopCtrl.gold = itemInfo.price
			shopCtrl.limitData = limitInfo
			shopCtrl.count = itemCount
			itemSingleInfo, shopCtrl.isBuyOnly = shopCtrl, self.isBuyOnly
		else
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			shopCtrl.count = itemCount
			itemSingleInfo, shopCtrl.isBuyOnly = shopCtrl, self.isBuyOnly
		end
	elseif itemInfo then
		backpackCtrl = shopCtrl
		shopCtrl.iid = itemID
		shopCtrl.gold = itemInfo.price
		shopCtrl.limitData = limitInfo
		shopCtrl.isBuyOnly = self.isBuyOnly
		itemSingleInfo, shopCtrl.shopID = shopCtrl, itemInfo.shopItemID
	else
		isAllowShow = false
	end
	if not itemLogic.checkUseCond(itemID) then
		isAllowShow = false
	end
	if itemSingleInfo and itemInfo and itemInfo.isLadder == 1 then
		local count = 0
		if limitInfo then
			count = limitInfo.buyCount
		end
		itemSingleInfo.gold = gModuleMgr.sharedMgr("shopltCtrl"):getLadderPrice(itemInfo.shopItemID, count + 1)
	end
	if isAllowShow then
		return itemSingleInfo
	else
		print("noShow = ", itemID)
		return nil
	end
end
return com_Meteorite_progress
