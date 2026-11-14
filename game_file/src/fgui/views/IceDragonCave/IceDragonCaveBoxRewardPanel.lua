local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonCaveBoxRewardPanel = class("IceDragonCaveBoxRewardPanel", baseFguiPanel)
local iceDragonCaveCtrl = SoraDGetCtrl("iceDragonCaveCtrl")
function IceDragonCaveBoxRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonCaveBoxRewardPanel:ctor", self.viewName)
end
function IceDragonCaveBoxRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonCaveBoxRewardPanel:onInit()
	print("=======IceDragonCaveBoxRewardPanel:onInit")
	self.fields.title:setString(i18n("decrypt_text_03"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(self.param.index, self.param.data)
end
function IceDragonCaveBoxRewardPanel:initData(index, data)
	print("=======IceDragonCaveBoxRewardPanel:onInit")
	local getStatus = iceDragonCaveCtrl:getIsReceived(data.draw)
	dump(data, "IceDragonCaveBoxRewardPanel:initData")
	self.index = index
	self.taskNum = data.draw
	self.rewards = data.reward
	if getStatus == gBtnTargetStatusDef.GO then
		self.fields.Button_get:setTitleText(i18n("common_text_2139"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	elseif getStatus == gBtnTargetStatusDef.GET then
		self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		self.fields.Button_get:setGrayed(false)
		self.fields.Button_get:setTouchable(true)
	else
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	end
	self.fields.List_reward:setNumItems(table.nums(self.rewards))
end
function IceDragonCaveBoxRewardPanel:onClickGet()
	SoraDPlaySound()
	iceDragonCaveCtrl:reqCaveReceive(self.taskNum)
	self:close()
end
function IceDragonCaveBoxRewardPanel:onItemRenderer(index, object)
	fguiHelper.get_fields(object).item:initData(self.rewards[index + 1].id, self.rewards[index + 1].num)
end
return IceDragonCaveBoxRewardPanel
