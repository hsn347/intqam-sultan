local nebulaExplorationCtrl = SoraDGetCtrl("nebulaExplorationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasurePopPanel = class("NebulaTreasurePopPanel", baseFguiPanel)
function NebulaTreasurePopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaTreasurePopPanel:ctor", self.viewName)
end
function NebulaTreasurePopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasurePopPanel:onInit()
	print("=======NebulaTreasurePopPanel:onInit")
	self.param = self.proxy.param
	self.canTouch = true
	_ENV = nil
	;(nil).num = self.param.level
	self.fields.Panel_bg:setTitle(i18n("nebula_treasure_hunt_05", nil))
	self.fields.Text_Tips:setString(i18n("nebula_treasure_hunt_06"))
	self.fields.Button_Get:addClickListener(handler(self, self.onClickButtonGet))
	self.fields.Button_Get:setTitle(i18n("common_text_854"))
	self.fields.List_Item:setItemRenderer(handler(self, self.onItemRederer))
end
function NebulaTreasurePopPanel:onShow()
	print("=======NebulaTreasurePopPanel:onShow")
	self.chooseIndex = self.param.chooseIndex or 0
	self.controllers.c1:setSelectedIndex(self.param.index)
	if self.param.index == 0 then
		_ENV = nil
		;(nil).member = nebulaExplorationCtrl:getCurLevel()
		;(nil).total = self.param.level
		self.fields.Text_Status:setString(i18n("common_text_155", nil))
	elseif self.param.index == 2 then
		self.canTouch = false
		self.fields.Text_Status:setString(i18n("common_text_1892"))
	end
	if not self.param.awardConfig then
		_ENV = self.param.awardConfig
	end
	self.awardConfig = self.param.awardConfig
	self.fields.List_Item:setNumItems(table.nums(self.awardConfig))
	self.fields.Button_Get:setEnabled(self.chooseIndex > 0 and true or false)
end
function NebulaTreasurePopPanel:onItemRederer(index, object)
	object:initdata(index + 1, self.awardConfig[index + 1], self.chooseIndex == index + 1, self.canTouch)
	object:setHandleBack(handler(self, self.onClickItem))
end
function NebulaTreasurePopPanel:onClickItem(index)
	self.chooseIndex = index
	self.fields.List_Item:setNumItems(table.nums(self.awardConfig))
	self.fields.Button_Get:setEnabled(self.chooseIndex > 0 and true or false)
end
function NebulaTreasurePopPanel:onClickButtonGet()
	SoraDPlaySound()
	if self.chooseIndex > 0 then
		SoraDShowLoading()
		nebulaExplorationCtrl:reqNebuleExplorationClaim(self.param.level, self.chooseIndex)
		self:removeFromParent()
	end
end
return NebulaTreasurePopPanel
