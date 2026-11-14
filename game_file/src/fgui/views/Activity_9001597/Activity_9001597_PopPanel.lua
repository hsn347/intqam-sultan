local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001597_PopPanel = class("Activity_9001597_PopPanel", baseFguiPanel)
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local activity_9001597_Read = include("activity_9001597_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
function Activity_9001597_PopPanel:ctor(...)
	Activity_9001597_PopPanel.super.ctor(self, ...)
	print("Activity_9001597_PopPanel:ctor", self.viewName)
end
function Activity_9001597_PopPanel:onInit()
	print("=======Activity_9001597_PopPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("activity_name_9001597"))
	self.fields.text_choose:setString(i18n("Ramadan_2024_text47"))
	self.fields.text_reward:setTitle(i18n("Ramadan_2024_text32"))
	self.fields.text_rewarddesc:setString(i18n("Ramadan_2024_text33"))
	self.fields.Com_Slider:setInpuBoxFixPos(45, 130, 190)
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.fields.btn_get:setTitle(i18n("common_text_337"))
	self.fields.btn_fire:setTitle(i18n("activity_name_9001597"))
	self.fields.btn_get:addClickEventListener(handler(self, self.onGetClick))
	self.fields.btn_fire:addClickEventListener(handler(self, self.onFireClick))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.itemID1 = constantRead.getConstValue("RAMADAN_2024_ORDINARY_SALUTE", 867701)
	self.itemID2 = constantRead.getConstValue("RAMADAN_2024_LUXURY_Salute", 867801)
	self.fields.Com_lipao1:setTitle(publicRead.getName(self.itemID1))
	self.fields.Com_lipao2:setTitle(publicRead.getName(self.itemID2))
	self.fields.Com_lipao1:setIcon(publicRead.getIcon(self.itemID1))
	self.fields.Com_lipao2:setIcon(publicRead.getIcon(self.itemID2))
	self.fields.Com_lipao1:addClickEventListener(handler(self, self.onLipaoClick), self.itemID1)
	self.fields.Com_lipao2:addClickEventListener(handler(self, self.onLipaoClick), self.itemID2)
	_ENV, self.curItemID = self.itemID1, self.itemID1
	self.itemID1[self.itemID1] = activity_9001597_Read.getShowReward(2)
	self.showRewardDatas, self.itemID1[self.itemID2] = self.itemID1, activity_9001597_Read.getShowReward(3)
	self.fields.Com_lipao1:fixPos()
	self.fields.Com_lipao2:fixPos()
	self.fields.btn_get:fixPos()
	self.fields.btn_fire:fixPos()
end
function Activity_9001597_PopPanel:onShow()
	print("=======Activity_9001597_PopPanel:onShow")
	self:updateView()
end
function Activity_9001597_PopPanel:updateView()
	self.showRewards = self.showRewardDatas[self.curItemID]
	self.fields.Com_lipao1:setSelected(self.curItemID == self.itemID1)
	self.fields.Com_lipao2:setSelected(self.curItemID == self.itemID2)
	self.fields.Image_arr:setPositionX(self.curItemID == self.itemID1 and self.fields.Com_lipao1:getPositionX() or self.fields.Com_lipao1:getPositionY())
	self.itemNum = backpackCtrl:getItemCount(self.curItemID)
	self.maxNum = self.itemNum
	backpackCtrl = self.curItemID
	self.curItemID.maxValue = self.maxNum
	self.curItemID.minValue = 0
	self.curItemID.curValue = 1
	self.curItemID.allowZero = true
	self.fields.Com_Slider:initData(self.curItemID)
	local curCount = 1
	self.curCount = math.min(self.maxNum, curCount)
	self.fields.Com_Slider:setMinValue(0)
	self:sliderCallBack(self.curCount)
	self.fields.btn_fire:setEnabled(self.itemNum > 0)
	self.fields.list:setNumItems(#self.showRewards)
end
function Activity_9001597_PopPanel:sliderCallBack(value)
	self.curCount = value
	self.fields.btn_fire:setEnabled(self.curCount > 0)
end
function Activity_9001597_PopPanel:onItemRenderer(index, obj)
	local item = self.showRewards[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001597_PopPanel:onGetClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.curItemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001597_PopPanel:onFireClick()
	SoraDPlaySound()
	activity_9001597_Ctrl:reqPlay(self.curItemID, self.curCount)
	self:close()
end
function Activity_9001597_PopPanel:onLipaoClick(sender, param)
	SoraDPlaySound()
	self.curItemID = param
	self:updateView()
end
return Activity_9001597_PopPanel
