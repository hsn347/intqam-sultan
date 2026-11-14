local newYearCarnivalltCtrl = include("newYearCarnivalltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewYearCarnival2022Panel = class("NewYearCarnival2022Panel", baseFguiPanel)
function NewYearCarnival2022Panel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NewYearCarnival2022Panel:ctor", self.viewName)
end
function NewYearCarnival2022Panel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function NewYearCarnival2022Panel:onInit()
	print("=======NewYearCarnival2022Panel:onInit")
	if not newYearCarnivalltCtrl.getReward() then
		_ENV = newYearCarnivalltCtrl.getReward()
	end
	self.data = newYearCarnivalltCtrl.getReward()
	self.fields.Text_cel:setString(i18n("newyear_carnival_text_002"))
	self.fields.Text_reward:setString(i18n("newyear_carnival_text_003"))
	self.fields.Button_help:setTitleText(i18n("newyear_carnival_text_004"))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.data))
	self.fields.Button_dressUp:addLongPressListener(handler(self, self.onClickItemInfo))
	self.fields.Button_view:setTitleText(i18n("newyear_carnival_text_001"))
	self.fields.Button_view:addClickListener(handler(self, self.onClickItemInfo))
	self.transitions.t0:play()
end
function NewYearCarnival2022Panel:onClickItemInfo()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = newYearCarnivalltCtrl.getItemID() or 511601
	uiManager:show("commonDressPreview", nil)
end
function NewYearCarnival2022Panel:closeView()
	SoraDRemoveAllAfterPanelFromManager(self)
end
function NewYearCarnival2022Panel:onItemRenderer(index, object)
	object:initData(self.data[index + 1])
end
function NewYearCarnival2022Panel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("newyear_carnival_text_005")
	uiManager:show("RuleViewNoTitle", nil):setOwnerKey(self)
end
function NewYearCarnival2022Panel:onShow()
	print("=======NewYearCarnival2022Panel:onShow")
end
function NewYearCarnival2022Panel:onHide()
	print("=======NewYearCarnival2022Panel:onHide")
end
function NewYearCarnival2022Panel:onDispose()
	print("=======NewYearCarnival2022Panel:onDispose")
end
return NewYearCarnival2022Panel
