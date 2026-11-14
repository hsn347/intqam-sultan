local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteExpBuyPanel = class("MeteoriteExpBuyPanel", baseFguiPanel)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemLogic = include("itemLogic")
local shopCtrl = SoraDGetCtrl("shopCtrl")
function MeteoriteExpBuyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MeteoriteExpBuyPanel:ctor", self.viewName)
end
function MeteoriteExpBuyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteExpBuyPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	if not SoraDFIsRA() then
		self.fields.progress:fixChildrenPos(false, true)
	end
	self.fields.Com_title:initData(i18n("meteoritesmagic_text_9"), handler(self, self.onClickClose))
	self.fields.text_lv_des:setString(i18n("meteoritesmagic_text_9"))
	print("=======MeteoriteExpBuyPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.isBuyOnly = false
	self.curProjectID = self.param.curProjectID
	self.fields.btn_icon:addClickEventListener(handler(self, self.iconClick))
end
function MeteoriteExpBuyPanel:onShow()
	print("=======MeteoriteExpBuyPanel:onShow")
	self:updateView(true)
end
function MeteoriteExpBuyPanel:updateView(isInit)
	local curLv = meteorMagicCtrl:getCurLv()
	self.curLv = curLv
	local curExp = meteorMagicRead.getCurLvExp(meteorMagicCtrl:getCurExp())
	local lvCfg, isMax = meteorMagicRead.getCurLvCfg(curLv)
	curExp = isMax and lvCfg.needExp or curExp
	self.curExp = curExp
	if isInit then
		self.fields.text_lv:setString(curLv)
		self.fields.progress:setMax(lvCfg.needExp)
		self.fields.progress:setValue(curExp)
		if isMax then
			fguiHelper.get_fields(self.fields.progress).title:setString("MAX")
		end
	else
		self.showLv = self.oldLv
		self.lvCount = self.curLv - self.oldLv
		self:expRunAction(false)
	end
	self.oldLv = self.curLv
	self.resList = backpackltCtrl:getItemArray(gItemType.METEOR_MAIGC_EXP)
	if not self.resList or not self.resList then
		meteorMagicCtrl = self.resList
	end
	self.itemSingleInfos, meteorMagicCtrl, self.resList = self.resList, self.resList, self.resList
	for i, v in ipairs(self.resList) do
		local itemSingleInfo = self:createItemSingleInfo(v)
		if itemSingleInfo then
			table.insert(self.itemSingleInfos, itemSingleInfo)
		end
	end
	table.sort(self.itemSingleInfos, function(a, b)
		return a.iid < b.iid
	end)
	self.fields.scroll:setNumItems(#self.itemSingleInfos)
	self.ProjectData = meteorMagicCtrl:getProjectData(self.curProjectID)
	meteorMagicCtrl = meteorMagicCtrl:getCurExp()
	meteorMagicCtrl:getCurExp().num = meteorMagicCtrl:getTalentNum() - self.ProjectData.costTalentNum
	self.fields.text_num:setString(i18n("meteoritesmagic_text_4", meteorMagicCtrl:getCurExp()))
end
function MeteoriteExpBuyPanel:expRunAction(isUp)
	self.fields.progress:stopAllActions()
	if self.showLv >= self.curLv then
		self.fields.text_lv:setString(self.curLv)
		local lvCfg, isMax = meteorMagicRead.getCurLvCfg(self.curLv)
		self.fields.progress:setMax(lvCfg.needExp)
		if isUp then
			self.fields.progress:setValue(0)
		end
		self.fields.progress:tweenValue(self.curExp, 0.2)
		if isMax then
			self.fields.progress:runAction(ffa.seq(ffa.delay(0.2), ffa.callFunc(function()
				fguiHelper.get_fields(self.fields.progress).title:setString("MAX")
			end)))
		end
		self.fields.Usm_1:setCompleteCallback(function()
			self.fields.Usm_1:setVisible(false)
		end)
		self.fields.Usm_1:play(false)
		if self.lvCount >= 1 then
			self.fields.Usm_2:setCompleteCallback(function()
				self.fields.Usm_2:setVisible(false)
			end)
			self.fields.Usm_2:play(false)
		end
		return
	end
	self.fields.text_lv:setString(self.showLv)
	local lvCfg, isMax = meteorMagicRead.getCurLvCfg(self.showLv)
	self.fields.progress:setMax(lvCfg.needExp)
	if isUp then
		self.fields.progress:setValue(0)
	end
	self.fields.progress:tweenValue(lvCfg.needExp, 0.2)
	self.fields.progress:runAction(ffa.seq(ffa.delay(0.2), ffa.callFunc(function()
		self.showLv = self.showLv + 1
		self:expRunAction(true)
	end)))
end
function MeteoriteExpBuyPanel:createItemSingleInfo(itemID)
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
function MeteoriteExpBuyPanel:onItemRenderer(index, obj)
	local itemSingleInfo = self.itemSingleInfos[index + 1]
	obj:initData(itemSingleInfo)
	obj:setUseHandler(handler(self, self.buyOrUseCallBack))
end
function MeteoriteExpBuyPanel:buyOrUseCallBack(controlTbl)
	local buyItem = function(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
		if itemInfo then
			_ENV = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			;(nil).needResList = self.needResCount
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if controlTbl.buy then
		if SoraDEnoughGold(controlTbl.needGold) then
			buyItem(controlTbl.itemID)
		end
	elseif controlTbl.use then
		include("itemLogic").useItemsLine(controlTbl.itemID, controlTbl.itemCount)
	end
end
function MeteoriteExpBuyPanel:iconClick()
	SoraDPlaySound()
	_ENV = "item_des_1650"
	;("item_des_1650").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("item_des_1650"), "item_des_1650")
end
return MeteoriteExpBuyPanel
