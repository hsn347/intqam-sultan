local rocketRushRead = include("rocketRushRead")
local publicRead = include("publicRead")
local rocketRushCtrl = SoraDGetCtrl("rocketRushCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SkyrocketPopPanel = class("SkyrocketPopPanel", baseFguiPanel)
function SkyrocketPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SkyrocketPopPanel:ctor", self.viewName)
end
function SkyrocketPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SkyrocketPopPanel:onInit()
	print("=======SkyrocketPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_284"))
	self.fields.Button_price:addClickListener(handler(self, self.btnDonateClick))
	self.fields.slider:setSliderCallBack(handler(self, self.updateView))
	self.fields.slider:setInpuBoxFixPos()
end
function SkyrocketPopPanel:onShow()
	print("=======SkyrocketPopPanel:onShow")
	self.donateType = self.param.donateType
	self.classType = rocketRushCtrl:getClassType()
	self.itemID, self.donateNum = rocketRushRead.getExpandItemCfg(self.classType, self.donateType)
	_ENV = nil
	;(nil).name = publicRead.getName(self.itemID)
	self.fields.Text_ask:setString(i18n("RocketRush_text_02", nil))
	self.rewardID, self.rewardNum = rocketRushRead.getExpandRewardCfg(self.classType, self.donateType)
	self.point = rocketRushRead.getExpandPoint(self.classType, self.donateType)
	self.fields.Label_Item:setIcon(publicRead.getIcon(self.rewardID))
	self.fields.Label_Item:setTextName(publicRead.getName(self.rewardID))
	self.fields.Label_Point:setTextName(i18n("common_text_1764"))
	self.fields.Button_price:setItemID(self.itemID)
	self.maxValue = rocketRushRead.getExpandLimit(self.classType, self.donateType)
	local myCount = backpackCtrl:getItemCount(self.itemID)
	local curMax = math.floor(myCount / self.donateNum)
	self.maxValue = math.min(self.maxValue, curMax)
	_ENV = curMax
	curMax.maxValue = self.maxValue
	curMax.minValue = 1
	curMax.curValue = 1
	self.fields.slider:initData(curMax)
	self.fields.slider:setTitle("/" .. self.maxValue)
end
function SkyrocketPopPanel:updateView(num)
	self.fields.Label_Item:setTitle(self.rewardNum * num)
	self.fields.Label_Point:setTitle(self.point * num)
	self.fields.Button_price:setPrice(num * self.donateNum)
end
function SkyrocketPopPanel:btnDonateClick()
	SoraDPlaySound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		return
	end
	rocketRushCtrl:sendDonate(self.donateType, self.fields.slider:getSliderCurValue())
	self:close()
end
return SkyrocketPopPanel
