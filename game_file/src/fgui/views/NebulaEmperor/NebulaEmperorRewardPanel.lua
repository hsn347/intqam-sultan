local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorRead = include("nebulaEmperorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorRewardPanel = class("NebulaEmperorRewardPanel", baseFguiPanel)
function NebulaEmperorRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorRewardPanel:ctor", self.viewName)
end
function NebulaEmperorRewardPanel:onInit()
	print("=======NebulaEmperorRewardPanel:onInit")
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initData(i18n("nebulaemperor_text_74"), handler(self, self.onClickClose), handlerHelp)
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Text_tip:setString(i18n("nebulaemperor_text_79"))
	_ENV = self.fields.Text_tip.setString
	_ENV, _ENV, self.fields.Text_tip.setString.defaultClick = i18n("nebulaemperor_text_79")
	_ENV, self.fields.Text_tip[1], i18n("nebulaemperor_text_79").title = i18n("nebulaemperor_text_79")
	_ENV, self.fields.Text_tip[2], i18n("nebulaemperor_text_79").title = i18n("nebulaemperor_text_79")
	_ENV, self.fields.Text_tip[3], i18n("nebulaemperor_text_79").title = i18n("nebulaemperor_text_79")
	self.fields.Text_tip.setString.tabsetArray, self.fields.Text_tip[4], i18n("nebulaemperor_text_79").title = self.fields.Text_tip, i18n("nebulaemperor_text_79")
	local self.fields.Text_tip.setString.callback, param = handler(self, self.onClickTab), self.fields.Text_tip.setString
	self.fields.com_Tab:initView(param)
end
function NebulaEmperorRewardPanel:onShow()
	print("=======NebulaEmperorRewardPanel:onShow")
end
function NebulaEmperorRewardPanel:onClickTab(tag)
	if self.curIndex == tag then
		return
	end
	self.curIndex = tag
	self.rewards = nebulaEmperorRead.getRewardConfigByType(self.curIndex)
	self.fields.List_reward:setNumItems(#self.rewards)
	self.fields.List_reward:scrollToView(0)
end
function NebulaEmperorRewardPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	local condition = data.condition
	local rank1, rank2 = condition[1], condition[2]
	local rewards = data.rewards
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local _fields = obj._fields
	_fields.Load_rank:setVisible(rank1 <= 3)
	_fields.Text_rank:setVisible(3 < rank1)
	if rank1 <= 3 then
		_fields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank1))
	else
		local rankStr = ""
		if rank1 ~= rank2 then
			_ENV = string.format("icon_ranking_%d.png", rank1)
			string.format("icon_ranking_%d.png", rank1).min = rank1
			string.format("icon_ranking_%d.png", rank1).max = rank2
			rankStr = i18n("common_text_1770", string.format("icon_ranking_%d.png", rank1))
		else
			_ENV = string.format("icon_ranking_%d.png", rank1)
			string.format("icon_ranking_%d.png", rank1).num = rank1
			rankStr = i18n("common_text_617", string.format("icon_ranking_%d.png", rank1))
		end
		_fields.Text_rank:setString(rankStr)
	end
	_fields.List:setItemRenderer(function(_index, _obj)
		_obj:initData(rewards[_index * 2 + 1], rewards[_index * 2 + 2])
	end)
	_fields.List:setNumItems(#rewards / 2)
	_fields.List:scrollToView(0)
end
return NebulaEmperorRewardPanel
