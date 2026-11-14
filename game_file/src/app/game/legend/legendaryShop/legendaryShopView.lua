local gametop = gModuleMgr.getObject("gametop")
local legendShopCtrl = gametop.playertop_:getModule("legendShopCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local legendKingRead = include("legendKingRead")
local shopTpye = legendKingRead.shopTpye
local legendaryShopView = class("legendaryShopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendaryShopView")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function legendaryShopView:ctor()
	self.otherData, shopTpye, self.tableItemList, shopTpye, self.curType = shopTpye.SPEED, shopTpye.SPEED, shopTpye.SPEED, shopTpye.SPEED, shopTpye.SPEED
	self.score = 0
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
		self.nodeTitle:setTitle(i18n("kingstarbattle_text_67"))
	else
		self.nodeTitle:setTitle(i18n("worldshop_title_01"))
	end
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
		self.scroll:setSingleCCS("kingStarShopSingle", true)
	else
		self.scroll:setSingleCCS("legendaryShopSingle")
	end
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("worldshop_text_01"))
	self.Text_already = SoraDGetChildByName(self, "Text_already")
	if SoraDGetChildByName(self, "Image_borL") then
		SoraDGetChildByName(self, "Image_borL"):setContentSize(cc.size(10, display.height - 160))
		SoraDGetChildByName(self, "Image_borR"):setContentSize(cc.size(10, display.height - 160))
	end
	shopTpye, shopTpye = SoraDGetChildByName(self, "Image_borR"), SoraDGetChildByName(self, "Image_borR").setContentSize
	SoraDGetChildByName(self, "Image_borR").title = i18n("item_name_300301")
	SoraDGetChildByName(self, "Image_borR").tag = shopTpye.SPEED
	shopTpye, SoraDGetChildByName(self, "Image_borR").setContentSize[1], SoraDGetChildByName(self, "Image_borR").handle = SoraDGetChildByName(self, "Image_borR"), SoraDGetChildByName(self, "Image_borR"), handler(self, self.btn_onClick_btns)
	SoraDGetChildByName(self, "Image_borR").title = i18n("shop_btn_01")
	SoraDGetChildByName(self, "Image_borR").tag = shopTpye.TREAT
	SoraDGetChildByName(self, "Image_borR").setContentSize[2], SoraDGetChildByName(self, "Image_borR").handle = SoraDGetChildByName(self, "Image_borR"), handler(self, self.btn_onClick_btns)
	local tabsetArray = SoraDGetChildByName(self, "Image_borR").setContentSize
	if legendKingRead.checkUnlockConditions(shopTpye.LEGEND_CRYSTAL) then
		shopTpye = self
		self.title = i18n("item_name_1639")
		self.tag = shopTpye.LEGEND_CRYSTAL
		self.handle = handler(self, self.btn_onClick_btns)
		table.insert(tabsetArray, self)
	end
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	shopTpye = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = #tabsetArray
	;("CCS_commonTabBtn_btns").tabsetArray = tabsetArray
	;("CCS_commonTabBtn_btns").unDefaultClick = true
	self.ccs_tab:initView("CCS_commonTabBtn_btns")
	legendShopCtrl:sendInitShop()
	SoraDShowLoading(self)
end
function legendaryShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.updateScrollWithData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function legendaryShopView:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LEGEND_LORD) and not not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KING_STAR_BATTLE) then
		self:removeFromParent()
	end
end
function legendaryShopView:updateScrollWithData(target, data)
	SoraDCloseLoading(self)
	self.ccs_tab:clickByTag(self.curType)
end
function legendaryShopView:updateScrollWithData222(target, data)
	self.tableItemList = legendKingRead.getShopItemList(self.curType, worldMapDefine.currentMapKindomID)
	self.otherData.score = self.score
	self.scroll:updateScrollView(cc.size(622, 180), self.tableItemList, 1, self.otherData)
end
function legendaryShopView:btn_onClick_btns(tag, name)
	self.curType = tag
	if not legendLordWarCtrl:getPersonalData() then
		local legendLordWarCtrl, personalData = legendLordWarCtrl:getPersonalData(), legendLordWarCtrl:getPersonalData()
	end
	local alreadyKey = ""
	if self.curType == shopTpye.SPEED then
		self.score = personalData.speedUpTimes or 0
		alreadyKey = "worldshop_text_02"
	elseif self.curType == shopTpye.TREAT then
		self.score = personalData.killNum or 0
		alreadyKey = "worldshop_text_03"
	elseif self.curType == shopTpye.LEGEND_CRYSTAL then
		self.score = personalData.cureWoundedCount or 0
		alreadyKey = "worldshop_text_08"
	end
	legendLordWarCtrl = nil
	;(nil).num = string.formatnumberthousands(self.score)
	self.Text_already:setString(i18n(alreadyKey, nil))
	self:updateScrollWithData222()
	self.scroll:jumpToTop()
end
function legendaryShopView:jumpToTypeCrystal(...)
	self.curType = shopTpye.LEGEND_CRYSTAL
end
return legendaryShopView
