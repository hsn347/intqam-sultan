local publicRead = include("publicRead")
local equipmentltCtrl = include("equipmentltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_baptizeNeed = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_baptizeNeed", Btn_baptizeNeed)
function Btn_baptizeNeed:onInit()
	self.curLockItem = 207701
	self:addClickListener(handler(self, self.btnClick))
	self.fields.Image_numBg:fix()
	self.fields.Text_num:fixPos()
end
function Btn_baptizeNeed:onShow()
end
function Btn_baptizeNeed:initData(data, equipCell)
	self.data = data
	self.equipCell = equipCell
	self.fields.Image_quality:setSpriteFrame(publicRead.getBg(self.data.id))
	self.fields.Image_icon:setSpriteFrame(publicRead.getIcon(self.data.id))
	publicRead = publicRead.getIcon(self.data.id)
	publicRead.getIcon(self.data.id).var1 = fguiHelper.getColorString(self.data.own >= self.data.num and "#FFFFFF" or "#FF0000", self.data.own)
	publicRead.getIcon(self.data.id).var2 = self.data.num
	self.fields.Text_num:setString(i18n("%{var1}/%{var2}", publicRead.getIcon(self.data.id)))
	self.controllers.c1:setSelectedIndex(self.data.own >= self.data.num and 0 or 1)
end
function Btn_baptizeNeed:btnClick()
	SoraDPlaySound()
	if self.data.id == self.curLockItem then
		_ENV = nil
		;(nil).itemID = self.curLockItem
		uiManager:show("CommonSourceGuide", nil)
		return
	end
	local _ENV, itemTitle = uiManager.show, uiManager.show
	local _ENV, btnCallBackParam = uiManager, uiManager
	local _ENV, btnCallBack = "CommonSourceGuide", "CommonSourceGuide"
	local _ENV, btnTitle
	if equipmentltCtrl.getMaterialIDOfMerge(self.data.id) then
		table.insert(itemTitle, i18n("equip_text_28"))
		table.insert(btnTitle, i18n("common_text_477"))
		table.insert(btnCallBack, handler(self, self.onBoxClick))
	end
	if self.equipCell:getEquipmentQuality() >= gQualityDef.PURPLE then
		table.insert(itemTitle, i18n("item_name_719101"))
		table.insert(btnTitle, i18n("common_text_314"))
		table.insert(btnCallBack, handler(self, self.onUseItem))
	end
	local itemID2List = gModuleMgr.sharedMgr("shopltCtrl"):getRemakeMaterialQuickShopList()
	if #itemID2List[self.data.id] >= 1 then
		table.insert(itemTitle, 1, i18n("Remake_equip_tips_0001"))
		table.insert(btnTitle, 1, i18n("common_text_282"))
		table.insert(btnCallBackParam, 1, itemID2List[self.data.id][#itemID2List[self.data.id]])
		table.insert(btnCallBack, 1, handler(self, self.onBuyClick))
		table.insert(itemTitle, i18n("Tycoon_text_22"))
		table.insert(btnTitle, i18n("common_text_477"))
		table.insert(btnCallBack, handler(self, self.openBuyView))
	end
	_ENV = table.insert
	_ENV = handler(self, self.openBuyView)
	handler(self, self.openBuyView).name = publicRead.getName(self.data.id)
	table.insert.title = i18n("equip_text_27", handler(self, self.openBuyView))
	table.insert.itemTitle = itemTitle
	table.insert.btnTitle = btnTitle
	table.insert.btnCallBack = btnCallBack
	table.insert.btnCallBackParam = btnCallBackParam
	local table.insert.size, param = table.nums(itemTitle), table.insert
	uiManager:show("GetWayPopBox", param)
end
function Btn_baptizeNeed:onBoxClick(param)
	SoraDPlaySound()
	_ENV = nil
	;(nil).mid = self.data.id
	;(nil).isBase = true
	uiManager:show("equipSetsMaterialsView", nil)
end
function Btn_baptizeNeed:onUseItem(param)
	SoraDPlaySound()
	local itemNum = backpackCtrl:getItemCount(719101)
	if 0 < itemNum then
		include("itemLogic").useItemsLine(719101, itemNum)
	else
		SoraDShowMsgTip(i18n("Remake_equip_tips_0002"))
	end
end
function Btn_baptizeNeed:onBuyClick(param)
	SoraDPlaySound()
	local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByShopItem(param.shopItemID)
	if itemInfo then
		if SoraDEnoughGold(param.price, false) then
			_ENV = nil
			;(nil).item = publicRead.getName(self.data.id)
			;(nil).num = param.price
			;(nil).num2 = 50
			SoraDShowMsgBox(i18n("Remake_equip_tips_0003", nil), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					local shopCtrl = SoraDGetCtrl("shopCtrl")
					_ENV = nil
					;(nil).source = gShopBuySource.BUY_AND_USE_IN_BAG
					shopCtrl:reqBuyInItemShop(param.shopItemID, 1, false, nil)
				end
			end)
		end
	else
		SoraDShowMsgTip(i18n("notice_0170"))
	end
end
function Btn_baptizeNeed:openBuyView()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("washFaceBuyView")
	panel:initData(self.data.id)
	panel:show()
end
return Btn_baptizeNeed
