local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ThirtyDaySign2022Reward = class("ThirtyDaySign2022Reward", baseFguiPanel)
function ThirtyDaySign2022Reward:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ThirtyDaySign2022Reward:ctor", self.viewName)
end
function ThirtyDaySign2022Reward:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ThirtyDaySign2021"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function ThirtyDaySign2022Reward:onInit()
	print("=======ThirtyDaySign2022Reward:onInit")
	self:setEffect()
end
function ThirtyDaySign2022Reward:setEffect()
	print("=======ThirtyDaySign2022Reward:onInit")
end
function ThirtyDaySign2022Reward:onClickSuccess()
	self.super.onClickClose(self)
end
function ThirtyDaySign2022Reward:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	dump(item, "ThirtyDaySign2022Reward")
	if item.id then
		obj:initData(item.id, item.count or item.num or item.number)
	else
		obj:setIcon(item.icon)
		obj:setQuality(item.quality)
		obj:setSpecialNum(item.specialNum)
		obj:setNum(item.count)
		obj:setEffectShow(item.effect)
		obj:setCustomName(item.name)
		obj:setCustomTip(item.tip)
	end
end
function ThirtyDaySign2022Reward:onShow()
	dump(self.proxy.param, "ThirtyDaySign2022Reward")
	local title = self.proxy.param.title
	local tip = self.proxy.param.tip
	self.fields.Text_tip:setString(tip)
	self.fields.Button_cost:setVisible(false)
	self.fields.Button_comfirm:setVisible(false)
	self.fields.Panel_bg:setString(self.proxy.param.title or "")
	self.controllers.c1:setSelectedIndex(self.proxy.param.controller)
	if self.proxy.param.comfirmFlag then
		self:createComfirmBtn(self.proxy.param)
	else
		self:CreateCostBtn(self.proxy.param)
	end
	self.rewards = self.proxy.param.rewards
	self.handle = self.proxy.param.handle
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.rewards))
	local line = math.ceil(#self.rewards / self.fields.List_reward:getColumnCount())
	self.fields.List_reward:resizeToFit(#self.rewards)
end
function ThirtyDaySign2022Reward:createComfirmBtn(data)
	if data.disabled then
		self.fields.Button_comfirm:setGrayed(true)
	end
	self.fields.Button_comfirm:setVisible(true)
	self.fields.Button_comfirm:setTitle(data.btnText)
	self.fields.Button_comfirm:addClickListener(handler(self, self.onClickBtn))
end
function ThirtyDaySign2022Reward:CreateCostBtn(data)
	self.fields.Button_cost:setVisible(true)
	self.fields.Button_cost:setTitle(data.btnText)
	self.cost = data.cost
	self:setGoldNum()
	self.fields.Button_cost:addClickListener(handler(self, self.onClickBtn))
end
function ThirtyDaySign2022Reward:setGoldNum(cost)
	if not self.view then
		return
	end
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if not self.cost or not haveGold then
		return
	end
	self.fields.Button_cost:setCostNum(self.cost, haveGold)
	if haveGold < self.proxy.param.cost then
		self.fields.Button_cost:setTitleColor(cc.c3b(255, 255, 255))
	end
end
function ThirtyDaySign2022Reward:onClickBtn()
	local success = self.handle()
	if success then
		self:onClickSuccess()
	end
end
function ThirtyDaySign2022Reward:onHide()
	print("=======ThirtyDaySign2022Reward:onHide")
end
function ThirtyDaySign2022Reward:onDispose()
	print("=======ThirtyDaySign2022Reward:onDispose")
end
return ThirtyDaySign2022Reward
