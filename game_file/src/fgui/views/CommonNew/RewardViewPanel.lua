local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RewardViewPanel = class("RewardViewPanel", baseFguiPanel)
function RewardViewPanel:ctor(...)
	self.super.ctor(self, ...)
end
function RewardViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function RewardViewPanel:onInit()
	self.fields.Button_confirm:setString(i18n("common_text_204"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickClose))
end
function RewardViewPanel:onClickClose()
	SoraDPlaySound()
	local _ENV, t = SoraDPlaySound, SoraDPlaySound
	for i, v in ipairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
	self.super.onClickClose(self)
end
function RewardViewPanel:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
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
function RewardViewPanel:onShow()
	local titleString = self.proxy.param.title
	self.fields.Text_title:setString(titleString)
	self.rewards = self.proxy.param.rewards
	self.fields.List_reward:setNumItems(#self.rewards)
	local line = math.ceil(#self.rewards / self.fields.List_reward:getColumnCount())
	self.fields.List_reward:resizeToFit(#self.rewards)
end
function RewardViewPanel:onHide()
end
function RewardViewPanel:onDispose()
end
return RewardViewPanel
