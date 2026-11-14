local publicUtil = include("publicUtil")
local publicRead = include("publicRead")
local footballClothesCtrl = SoraDGetCtrl("footballClothesCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local jerseyActivityPanel = class("jerseyActivityPanel", baseFguiPanel)
_ENV = "jerseyActivityPanel"
;("jerseyActivityPanel").personal = 1
local ("jerseyActivityPanel").alliance, AwardType = 2, "jerseyActivityPanel"
function jerseyActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("jerseyActivityPanel:ctor", self.viewName)
end
function jerseyActivityPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function jerseyActivityPanel:onInit()
	print("=======jerseyActivityPanel:onInit")
	self.itemID = 858901
	self.activityID = gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY
	self.fields.Com_title:initData(i18n("footballclothes_title"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Com_ItemNum:initData(self.itemID)
	self.fields.Com_ItemNum:setAddCallback(handler(self, self.onClickAdd))
	self.fields.label_Button:setTitle(i18n("common_text_284"))
	self.fields.label_Button:fixChildrenPos()
	self.fields.label_Button:getChildByName("Icon_gold"):setIcon(publicRead.getIcon(self.itemID))
	self.fields.Button_Cost:addClickListener(handler(self, self.onClickCost))
	self.fields.text_Tips:setString(i18n("footballclothes_text_01"))
	self.fields.Com_Score_M:initData(AwardType.personal)
	self.fields.Com_Score_A:initData(AwardType.alliance)
end
function jerseyActivityPanel:onShow()
	print("=======jerseyActivityPanel:onShow")
	SoraDShowLoading(self:displayObject())
	footballClothesCtrl:sendReqInitDataMsg()
	self:updateButton()
	self:updateItem()
end
function jerseyActivityPanel:updateItem()
	self.fields.Com_ItemNum:updateNum()
end
function jerseyActivityPanel:updateScore()
	_ENV = nil
	;(nil).score = footballClothesCtrl:getPersonScore()
	self.fields.Com_Score_M:setString(i18n("common_text_4404", nil))
	_ENV = i18n("common_text_4404", nil)
	i18n("common_text_4404", nil).num = footballClothesCtrl:getAllianceScore()
	self.fields.Com_Score_A:setString(i18n("common_text_1492", i18n("common_text_4404", nil)))
	self.fields.Com_Score_M:updateItems()
	self.fields.Com_Score_A:updateItems()
end
function jerseyActivityPanel:updateButton()
	local ownNum = publicUtil.getCount(self.itemID)
	self.fields.Button_Cost:setEnabled(0 < ownNum)
end
function jerseyActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).num = include("constantRead").getConstValue("FOOTBALLCLOTHES_ITEM_NUM")
	;(nil).content = i18n("footballclothes_rule", nil)
	uiManager:show("RuleView", nil)
end
function jerseyActivityPanel:onClickCost()
	SoraDPlaySound()
	local ownNum = publicUtil.getCount(self.itemID)
	if 0 < ownNum then
		_ENV = self.itemID
		self.itemID.btnTitle = i18n("common_text_284")
		self.itemID.itemID = self.itemID
		self.itemID.minValue = 1
		self.itemID.maxValue = ownNum
		self.itemID.btnHandle = handler(self, self.onClickDonate)
		local self.itemID.curValue, param = ownNum, self.itemID
		uiManager:show("jerseyDonate", param):setOwnerKey(self)
	end
end
function jerseyActivityPanel:onClickDonate(num)
	print("handler(self, self.onClickDonate)", num)
	footballClothesCtrl:reqFootballClothesDonate(num)
end
function jerseyActivityPanel:onClickAdd()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("jerseyGetWay", nil)
end
return jerseyActivityPanel
