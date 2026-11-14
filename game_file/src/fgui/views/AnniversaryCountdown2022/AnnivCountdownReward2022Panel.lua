local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AnnivCountdownReward2022Panel = class("AnnivCountdownReward2022Panel", baseFguiPanel)
_ENV = "AnnivCountdownReward2022Panel"
;("AnnivCountdownReward2022Panel").COUNTDOWN = 1
;("AnnivCountdownReward2022Panel").WELFARE = 2
local ("AnnivCountdownReward2022Panel").BAG, viewType = 3, "AnnivCountdownReward2022Panel"
function AnnivCountdownReward2022Panel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AnnivCountdownReward2022Panel:ctor", self.viewName)
end
function AnnivCountdownReward2022Panel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ThirtyDaySign2021"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function AnnivCountdownReward2022Panel:onInit()
	print("=======AnnivCountdownReward2022Panel:onInit")
	self.fields.Button_comfirm:setTitle(i18n("common_text_4495"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.Button_comfirm:addClickEventListener(handler(self, self.onBtnClick))
end
function AnnivCountdownReward2022Panel:initData(data)
	dump(data, "KLFdklf")
	self.reward = data.reward
	self.state = data.state
	self.callFunc = data.callFunc
	self.fields.Text_tip:setString(data.title or "")
	if self.state ~= 2 then
		self.fields.Button_comfirm:setEnabled(false)
		self.fields.Button_comfirm:setGrayed(true)
	end
	self.fields.Button_comfirm:setTitle(data.btnTitle or i18n("common_text_4495"))
	if self.state == 3 then
		self.fields.Button_comfirm:setTitle(data.gotTitle or i18n("common_text_1892"))
	end
	self.fields.Button_comfirm:setVisible(data.state7 ~= 1)
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
end
function AnnivCountdownReward2022Panel:onShow()
	self:initData(self.proxy.param)
end
function AnnivCountdownReward2022Panel:onNormalItemRenderer(index, obj)
	obj:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
function AnnivCountdownReward2022Panel:onBtnClick()
	self.callFunc()
	self:closePanel()
end
return AnnivCountdownReward2022Panel
