local starlightPavilionCtrl = SoraDGetCtrl("starlightPavilionCtrl")
local nebulastoreRead = include("nebulastoreRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarsTowerMainPanel = class("StarsTowerMainPanel", baseFguiPanel)
function StarsTowerMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("StarsTowerMainPanel:ctor", self.viewName)
end
function StarsTowerMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarsTowerMainPanel:onInit()
	print("=======StarsTowerMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.STARLIGHT_PAVILION_ACTIVITY
	self.tabIndex = 1
	self.menuIndex = 1
	self.fields.Com_title:initData(i18n("activity_name_9001484"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_menu:setItemRenderer(handler(self, self.onMenuRenderer))
	self.fields.List_gift:setVirtual()
	self.fields.List_gift:setItemRenderer(handler(self, self.onGiftRenderer))
	_ENV = handler(self, self.onGiftRenderer)
	_ENV, _ENV, handler(self, self.onGiftRenderer).defaultClick = handler(self, self.onGiftRenderer)
	handler(self, self.onGiftRenderer).title = i18n("limited_text_10")
	_ENV, self.tabIndex[1], handler(self, self.onGiftRenderer).tag = handler(self, self.onGiftRenderer)
	handler(self, self.onGiftRenderer).title = i18n("recharge_btn_02")
	handler(self, self.onGiftRenderer).tabsetArray, self.tabIndex[2], handler(self, self.onGiftRenderer).tag = self.tabIndex, handler(self, self.onGiftRenderer)
	handler(self, self.onGiftRenderer).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(handler(self, self.onGiftRenderer))
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	starlightPavilionCtrl:sendData()
end
function StarsTowerMainPanel:onShow()
	print("=======StarsTowerMainPanel:onShow")
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.itemList, _ENV = self.fields.Label_time.initCommonActivityTime, self.fields.Label_time.initCommonActivityTime
	local itemList = nebulastoreRead.getItemList()
	local quality, lv, starLv = SoraDGetBuildQuality()
	for k, v in ipairs(itemList) do
		if v.limitStarLevel <= SoraDGetBuildStarLv() and v.limitLevel <= SoraDGetCastleLv() and starLv >= v.limitStatueLevel and v.groupType == starlightPavilionCtrl:getClassType() then
			table.insert(self.itemList, v)
		end
	end
	self.menuList = nebulastoreRead.getLabelList()
end
function StarsTowerMainPanel:onItemRenderer(index, obj)
	obj:initData(self.shopList[index + 1])
end
function StarsTowerMainPanel:onMenuRenderer(index, obj)
	obj:initData(self.menuList[index + 1], index + 1, self.menuIndex)
end
function StarsTowerMainPanel:onGiftRenderer(index, obj)
	obj:initData(self.giftList[index + 1])
end
function StarsTowerMainPanel:updateGift(target, data)
	self:showGift()
end
function StarsTowerMainPanel:updateView(target, data)
	if self.tabIndex == 1 then
		self.fields.Text_none:setString(i18n("Nebulastore_text_03"))
		self:showItem()
	else
		self.fields.Text_none:setString(i18n("Nebulastore_text_04"))
		self:showGift()
	end
end
function StarsTowerMainPanel:updateMenu(target, data)
	if self.menuIndex == data.index then
		return
	end
	self.menuIndex = data.index
	self:showGift()
end
function StarsTowerMainPanel:showItem()
	self.shopList, _ENV = nil, nil
	for i = 1, #self.itemList, 2 do
		_ENV = nil
		;(nil).cfg1 = self.itemList[i]
		;(nil).cfg2 = self.itemList[i + 1]
		table.insert(self.shopList, nil)
	end
	self.fields.Text_none:setVisible(#self.shopList == 0)
	self.fields.List_item:setNumItems(#self.shopList)
end
function StarsTowerMainPanel:showGift()
	self.fields.List_menu:setNumItems(#self.menuList)
	self.fields.List_menu:scrollToView(0)
	self.fields.List_menu:setScrollEnable(#self.menuList > 4)
	self.giftList, nebulastoreRead = self.fields.List_menu.setScrollEnable, self.fields.List_menu.setScrollEnable
	if #self.menuList > 0 then
		self.giftList = nebulastoreRead.getGiftList(self.menuList[self.menuIndex].ID)
	end
	self.fields.List_gift:setNumItems(#self.giftList)
	self.fields.Text_none:setVisible(#self.menuList == 0)
end
function StarsTowerMainPanel:onClickTab(index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	self:updateView()
end
function StarsTowerMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Nebulastore_text_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return StarsTowerMainPanel
