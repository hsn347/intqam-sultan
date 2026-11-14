local publicRead = include("publicRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarSendGiftPanel = class("NebulaAllStarSendGiftPanel", baseFguiPanel)
function NebulaAllStarSendGiftPanel:ctor(...)
	NebulaAllStarSendGiftPanel.super.ctor(self, ...)
	print("NebulaAllStarSendGiftPanel:ctor", self.viewName)
end
function NebulaAllStarSendGiftPanel:onInit()
	print("=======NebulaAllStarSendGiftPanel:onInit")
	self.itemList, _ENV = print, print
	self.selIndex = 1
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_209"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlignCenter(true)
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.Button_send:setString(i18n("NebulaAllstar_209"))
	self.fields.Button_send:addClickListener(handler(self, self.btnSendClick))
	self.fields.Button_send:setEnabled(false)
	self.fields.slider:setInpuBoxFixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Com_own:fixPos()
end
function NebulaAllStarSendGiftPanel:onShow()
	print("=======NebulaAllStarSendGiftPanel:onShow")
	self.uid = self.param and self.param.uid
	self:initData()
end
function NebulaAllStarSendGiftPanel:onChooseItem()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self:setItemInfo()
end
function NebulaAllStarSendGiftPanel:onItemRenderer(index, obj)
	local id = self.itemList[index + 1].id
	local count = backpackCtrl:getItemCount(id)
	obj:getChildByName("item"):initData(id, count)
	obj:setSelected(index + 1 == self.selIndex)
end
function NebulaAllStarSendGiftPanel:initData()
	self.itemList, backpackltCtrl = nil, nil
	local itemList = backpackltCtrl:getItemListByType(gItemEffectDef.NEBULA_ALLSTAR_GIFT)
	for k, v in ipairs(itemList) do
		local result = backpackltCtrl:getResult(v)
		backpackltCtrl = nil
		;(nil).id = v
		;(nil).resultVal = result[1]
		;(nil).resultType = result[2]
		table.insert(self.itemList, nil)
	end
	table.sort(self.itemList, function(a, b)
		if a.resultType < b.resultType then
			return true
		end
		if a.resultVal < b.resultVal then
			return true
		end
		return a.id < b.id
	end)
	self:updateView()
end
function NebulaAllStarSendGiftPanel:updateView()
	self.fields.List:setNumItems(#self.itemList)
	self:setItemInfo()
end
function NebulaAllStarSendGiftPanel:setItemInfo()
	local id = self.itemList[self.selIndex].id
	local resultType = self.itemList[self.selIndex].resultType
	local count = backpackCtrl:getItemCount(id)
	local maxVal = count
	local itemPos = self.fields.List:getChildAt(self.selIndex - 1):localToGlobal(cc.p(60, 0))
	local toPos = self:globalToLocal(itemPos)
	self.fields.Image_arr:setPositionX(toPos.x)
	self.fields.Text_name:setString(publicRead.getName(id))
	self.fields.Text_des:setString(publicRead.getDes(id))
	local isPayItem = resultType == 1 or resultType == 2
	self.fields.Com_own:initData(id, count, isPayItem)
	if isPayItem then
		maxVal = math.min(count, nebulaAllStarRead.getConstValue("GiftPersentMaxNum", 5))
	end
	backpackCtrl = nebulaAllStarRead.getConstValue("GiftPersentMaxNum", 5)
	nebulaAllStarRead.getConstValue("GiftPersentMaxNum", 5).minValue = 1
	nebulaAllStarRead.getConstValue("GiftPersentMaxNum", 5).curValue = 1
	nebulaAllStarRead.getConstValue("GiftPersentMaxNum", 5).maxValue = maxVal
	self.fields.slider:initData(nebulaAllStarRead.getConstValue("GiftPersentMaxNum", 5))
	self.fields.Button_send:setEnabled(0 < count)
end
function NebulaAllStarSendGiftPanel:btnSendClick()
	SoraDPlaySound()
	nebulaAllStarCtrl:reqViewerGiveGift(self.uid, self.itemList[self.selIndex].id, self.fields.slider:getSliderCurValue())
end
return NebulaAllStarSendGiftPanel
