local ramadanSurpriseCtrl = SoraDGetCtrl("ramadanSurpriseCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SelfSelectRewardPanel = class("SelfSelectRewardPanel", baseFguiPanel)
function SelfSelectRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SelfSelectRewardPanel:ctor", self.viewName)
end
function SelfSelectRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SelfSelectRewardPanel:onInit()
	print("=======SelfSelectRewardPanel:onInit")
	self.fields.Button_comfirm:setGrayed(true)
	self.fields.Button_comfirm:setTouchEnabled(false)
	self.fields.List_rewardSelect:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:setTitleText(i18n("common_text_204"))
	self.fields.Button_comfirm:addClickListener(handler(self, self.onClickComfirm))
	function self.tickHandle(index)
		self.curSelect = index
		self.fields.Button_comfirm:setGrayed(false)
		self.fields.Button_comfirm:setTouchEnabled(true)
	end
end
function SelfSelectRewardPanel:onShow()
	print("=======SelfSelectRewardPanel:onShow")
	self.data = self.proxy.param
	self.fields.Panel_bg:setTitle(self.param.title)
	self.fields.Text_tip:setString(self.param.tip)
	self.listData = self.param.itemList
	self.btnHandle = self.param.btnHandle
	dump(self.param.itemList)
	self.fields.List_rewardSelect:setNumItems(table.nums(self.param.itemList))
	local selectIndex = 0
	if ramadanSurpriseCtrl:isSelectedAlready() then
		selectIndex = ramadanSurpriseCtrl:getSelectedIndexByLevel(self.param.index)
	else
		selectIndex = ramadanSurpriseCtrl:getUserSelectByLevel(self.param.index)
	end
	if selectIndex and 0 < selectIndex then
		self.fields.List_rewardSelect:getChildAt(selectIndex - 1):setSelected(true)
		self.fields.List_rewardSelect:scrollToView(selectIndex - 1)
		self.tickHandle(selectIndex)
	end
end
function SelfSelectRewardPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.listData[index + 1], self.tickHandle)
end
function SelfSelectRewardPanel:onClickComfirm()
	self.btnHandle(self.data.index, self.curSelect, self.itemID)
	self:close()
end
function SelfSelectRewardPanel:onHide()
	print("=======SelfSelectRewardPanel:onHide")
end
function SelfSelectRewardPanel:onDispose()
	print("=======SelfSelectRewardPanel:onDispose")
end
return SelfSelectRewardPanel
