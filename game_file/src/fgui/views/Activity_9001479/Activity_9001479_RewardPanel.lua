local activity_9001479_Read = include("activity_9001479_Read")
local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001479_RewardPanel = class("Activity_9001479_RewardPanel", baseFguiPanel)
function Activity_9001479_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001479_RewardPanel:ctor", self.viewName)
	self.showRound = self.proxy.param and self.proxy.param.showRound or activity_9001479_Ctrl:getCurRound()
end
function Activity_9001479_RewardPanel:onInit()
	print("=======Activity_9001479_RewardPanel:onInit")
	self.fields.Com_title:initData(i18n("camp_integral_10"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setItemProvider(handler(self, self.onRewardItemProvider))
	_ENV = self.fields.List_reward.setItemProvider
	self.fields.List_reward.setItemProvider.defaultClick = self.showRound
	self.fields.List_reward.setItemProvider.tabsetArray = activity_9001479_Read.getTabsetArray()
	local self.fields.List_reward.setItemProvider.callback, param = handler(self, self.onClickTab), self.fields.List_reward.setItemProvider
	self.fields.com_Tab:initView(param)
end
function Activity_9001479_RewardPanel:onShow()
	print("=======Activity_9001479_RewardPanel:onShow")
end
function Activity_9001479_RewardPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("camp_integral_2"))
end
function Activity_9001479_RewardPanel:onClickTab(tag)
	self.showRound = tag
	self:updateRoundConfig()
end
function Activity_9001479_RewardPanel:updateRoundConfig(...)
	local _ENV, ret
	local _ENV, _ENV, titleMap
	_ENV = nil
	;(nil).result = i18n("camp_integral_13")
	;(nil)[1] = i18n("camp_integral_11", nil)
	_ENV = nil
	;(nil).result = i18n("camp_integral_14")
	;(nil)[2] = i18n("camp_integral_11", nil)
	_ENV = nil
	;(nil).result = i18n("camp_integral_13")
	;(nil)[3] = i18n("camp_integral_12", nil)
	_ENV = nil
	;(nil).result = i18n("camp_integral_14")
	local (nil)[4], titleConfig = i18n("camp_integral_12", nil), nil
	local config = activity_9001479_Read.getAwardConfigByRound(self.showRound)
	for i, v in ipairs(config) do
		if not titleMap[v.type] then
			titleMap[v.type] = 0
			_ENV = nil
			;(nil).itemType = 1
			;(nil).title = titleConfig[v.type]
			table.insert(ret, nil)
		end
		titleMap[v.type] = titleMap[v.type] + 1
		local titleStr
		if not v.rank then
			local _ENV, rank = v.rank, v.rank
		end
		local showTop3 = false
		if 0 < #rank then
			if #rank == 1 or rank[1] == rank[2] then
				showTop3 = rank[1] > 0 and rank[1] <= 3
				_ENV = nil
				;(nil).var = rank[1]
				titleStr = i18n("atlantiswar_text_0133", nil)
			elseif #rank == 2 then
				_ENV = nil
				;(nil).var1 = rank[1]
				;(nil).var2 = rank[2]
				titleStr = i18n("atlantiswar_text_0134", nil)
			end
		end
		local showLine = titleMap[v.type] % 2 == 0
		_ENV = rank[2]
		rank[2].itemType = 2
		rank[2].title = titleStr
		rank[2].award = v.award
		rank[2].rank = rank
		rank[2].showTop3 = showTop3
		rank[2].showLine = showLine
		table.insert(ret, rank[2])
	end
	self.rewardData = ret
	self.fields.List_reward:removeChildrenToPool()
	self.fields.List_reward:setNumItems(#self.rewardData)
	_ENV = nil
	;(nil).num = self.showRound
	self.fields.Text_des:setString(i18n("camp_integral_15", nil))
end
function Activity_9001479_RewardPanel:onRewardItemRenderer(index, obj)
	local data = self.rewardData[index + 1]
	if data.title then
		obj:setString(data.title)
	else
		obj:setString("")
	end
	if data.itemType == 1 then
		return
	end
	local c_rank = obj:getController("c_rank")
	if data.showTop3 then
		c_rank:setSelectedIndex(data.rank[1] - 1)
	else
		c_rank:setSelectedIndex(3)
	end
	local c_line = obj:getController("c_line")
	if data.showLine then
		c_line:setSelectedIndex(1)
	else
		c_line:setSelectedIndex(0)
	end
	local award = data.award
	if award then
		local List_reward = obj:getChild("List_reward")
		List_reward:setItemRenderer(function(_index, _obj)
			_obj:initData(award[_index * 2 + 1], award[_index * 2 + 2])
		end)
		List_reward:setNumItems(#award / 2)
		List_reward:scrollToView(0)
	end
	if not obj.isInit then
		obj.isInit = true
		obj:fixChildrenPos()
	end
end
function Activity_9001479_RewardPanel:onRewardItemProvider(index)
	local data = self.rewardData[index + 1]
	if data.itemType == 1 then
		return "ui://Activity_9001479/Com_rewardTitle"
	else
		return "ui://Activity_9001479/Com_rewardSingle"
	end
end
return Activity_9001479_RewardPanel
