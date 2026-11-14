local lordOfDessertCtrl = SoraDGetCtrl("lordOfDessertCtrl")
local lordOfDessertRead = include("lordOfDessertRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertsKingGiftRewardPanel = class("DessertsKingGiftRewardPanel", baseFguiPanel)
function DessertsKingGiftRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DessertsKingGiftRewardPanel:ctor", self.viewName)
end
function DessertsKingGiftRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DessertsKingGiftRewardPanel:onInit()
	print("=======DessertsKingGiftRewardPanel:onInit")
	self.fields.title:setString(i18n("Snowman_Activity_07"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRender))
	self.maxBoxNum = lordOfDessertRead.getBoxMax(lordOfDessertCtrl:getActivityGroup())
	self.maxPoint = lordOfDessertRead.getNeedIntegral(lordOfDessertCtrl:getActivityGroup())
	_ENV = lordOfDessertCtrl:getActivityGroup()
	lordOfDessertCtrl:getActivityGroup().num = self.maxPoint
	self.fields.Text_tip:setString(i18n("EidalAdha_King_text_08", lordOfDessertCtrl:getActivityGroup()))
	self.fields.Button_get:setString(i18n("common_text_1146"))
	lordOfDessertCtrl = lordOfDessertCtrl:getActivityGroup()
	lordOfDessertCtrl:getActivityGroup()[1] = "id"
	lordOfDessertCtrl:getActivityGroup()[2] = "count"
	self.awardConfig = serviceFunctions.tableFormat(lordOfDessertRead.getBoxItem(lordOfDessertCtrl:getActivityGroup()), lordOfDessertCtrl:getActivityGroup())
	self.fields.List_reward:setNumItems(#self.awardConfig)
end
function DessertsKingGiftRewardPanel:onShow()
	print("=======DessertsKingGiftRewardPanel:onShow")
	self:updateButton()
end
function DessertsKingGiftRewardPanel:updateButton()
	self.curScore = lordOfDessertCtrl:getScore()
	local canGetNum = math.min(math.floor(self.curScore / self.maxPoint), self.maxBoxNum)
	local gotNum = lordOfDessertCtrl:getRewardCount()
	lordOfDessertCtrl = nil
	;(nil).member = gotNum
	;(nil).total = self.maxBoxNum
	self.fields.Text_LeftTime:setString(i18n("common_text_155", nil))
	self.fields.Button_get:setEnabled(canGetNum > gotNum)
	self.fields.Button_get:setReddot(canGetNum > gotNum, canGetNum - gotNum)
	if gotNum == self.maxBoxNum then
		self.fields.Button_get:setString(i18n("common_text_1892"))
	else
		self.fields.Button_get:setString(i18n("common_text_1146"))
	end
end
function DessertsKingGiftRewardPanel:onItemRender(index, target)
	target:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function DessertsKingGiftRewardPanel:onClickGet()
	SoraDPlaySound()
	lordOfDessertCtrl:reqLordOfDessertReward()
end
return DessertsKingGiftRewardPanel
