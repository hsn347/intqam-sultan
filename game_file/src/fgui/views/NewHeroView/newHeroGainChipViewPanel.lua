local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newHeroGainChipViewPanel = class("newHeroGainChipViewPanel", baseFguiPanel)
function newHeroGainChipViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("newHeroGainChipViewPanel:ctor", self.viewName)
end
function newHeroGainChipViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewHeroView"
	end
	return self._packageList
end
function newHeroGainChipViewPanel:onInit()
	print("=======newHeroGainChipViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_777"))
	self.fields.Button_ok:setTitleText(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOKClick))
	self:initData(self.param.itemID, self.param.needCount, self.param.heroID)
	self.fields.chip:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_have:fixPos()
end
function newHeroGainChipViewPanel:onShow()
	print("=======newHeroGainChipViewPanel:onShow")
end
function newHeroGainChipViewPanel:onHide()
	print("=======newHeroGainChipViewPanel:onHide")
end
function newHeroGainChipViewPanel:onDispose()
	print("=======newHeroGainChipViewPanel:onDispose")
end
function newHeroGainChipViewPanel:initData(itemID, needCount, heroID)
	self.itemID = itemID
	self.needCount = needCount
	self.heroID = heroID
	self.heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID)
	self.heroViewInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function newHeroGainChipViewPanel:initView(...)
	local itemName = publicRead.getName(self.itemID)
	self.fields.chip:initData(self.itemID, self.needCount, self.heroID)
	self.fields.Text_name:setString(itemName)
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	publicRead = nil
	;(nil).num = itemNum
	self.fields.Text_have:setString(i18n("hero_text_26", nil))
	self.fields.lab_des:initData(self.heroID, self.itemID)
end
function newHeroGainChipViewPanel:btnOKClick()
	SoraDPlaySound()
	self:removeFromParent()
end
return newHeroGainChipViewPanel
