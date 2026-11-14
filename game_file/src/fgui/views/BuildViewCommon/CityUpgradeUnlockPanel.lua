local maincityDesRead = include("maincityDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CityUpgradeUnlockPanel = class("CityUpgradeUnlockPanel", baseFguiPanel)
function CityUpgradeUnlockPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CityUpgradeUnlockPanel:ctor", self.viewName)
end
CityUpgradeUnlockPanel.unlockInfo = 1
CityUpgradeUnlockPanel.unlockSuccess = 2
CityUpgradeUnlockPanel.unlockBlock = 3
function CityUpgradeUnlockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CityUpgradeUnlockPanel:onInit()
	print("=======CityUpgradeUnlockPanel:onInit")
	self.data, _ENV, self.isAddToPopManager = print, print, true
	self.showType = self.unlockInfo
	self.curLv = SoraDGetCastleLv()
	self.fields.Text_unlock:setString(i18n("common_text_4473"))
	self.fields.Button_go:setString(i18n("common_text_204"))
	self.fields.Button_go:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function CityUpgradeUnlockPanel:onShow()
	print("=======CityUpgradeUnlockPanel:onShow")
	self.showType = self.proxy.param.showType
	self:initData()
end
function CityUpgradeUnlockPanel:initData()
	if self.showType == self.unlockInfo then
		self.data = maincityDesRead.getUnlockInfoByLv(self.curLv)
		maincityDesRead = nil
		;(nil).level = self.data[1].unlocklevel
		self.fields.Text_title:setString(i18n("common_text_427", nil))
		self.fields.Button_go:setString(i18n("common_text_477"))
	elseif self.showType == self.unlockSuccess then
		self.fields.Text_title:setString(i18n("common_text_4471"))
		self.data = maincityDesRead.getUnlockInfoByLv(self.curLv, true)
		SoraDGetCtrl("cityCtrl"):sendPopCastleLv()
	elseif self.showType == self.unlockBlock then
		self.fields.Text_title:setString(i18n("common_text_4472"))
		self.data = maincityDesRead.getUnlockBlockInfo()
	end
	self.isAddToPopManager = self.showType ~= self.unlockInfo
	self.controllers.c1:setSelectedIndex(self.showType - 1)
	userSDKManager.logEvent(self.showType == self.unlockInfo and gSDKDef.TDonEvent.cityUnlock_main_button_click or gSDKDef.TDonEvent.cityUnlock_view_click)
	self:initPublicView()
end
function CityUpgradeUnlockPanel:initPublicView()
	if #self.data <= 3 then
		self.fields.List:setScrollEnable(false)
	else
		self.fields.List:setScrollEnable(true)
	end
	self.fields.List:setNumItems(#self.data)
end
function CityUpgradeUnlockPanel:onItemRederer(index, target)
	local isLock = self.showType == self.unlockBlock and self.curLv < self.data[index + 1].level
	target:initData(self.data[index + 1], isLock)
end
function CityUpgradeUnlockPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	if self.showType == self.unlockInfo then
		_ENV = nil
		;(nil).bid = BUILDID.CASTLE
		;(nil).lv = self.data[1].unlocklevel
		gModuleMgr.sharedMgr("mildGuideManager"):starToUpgrade(nil)
	end
	self:removeFromParent()
end
function CityUpgradeUnlockPanel:onHide()
	if not SoraDIsGameGuide() and SoraDGetCastleLv() >= CASTLE_LV3_LIMITED then
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		if not guideCtrl:updateGuideModule(gGuideModule.OVERVIEW) then
			print("触发总览引导")
		end
	end
end
return CityUpgradeUnlockPanel
