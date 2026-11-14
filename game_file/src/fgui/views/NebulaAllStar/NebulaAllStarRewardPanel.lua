local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarRewardPanel = class("NebulaAllStarRewardPanel", baseFguiPanel)
function NebulaAllStarRewardPanel:ctor(...)
	NebulaAllStarRewardPanel.super.ctor(self, ...)
	print("NebulaAllStarRewardPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaAllStarRewardPanel:onInit()
	print("=======NebulaAllStarRewardPanel:onInit")
	self.fields.Com_title:initData(i18n("atlantiswar_text_0019"), handler(self, self.onClickClose))
	if nebulaAllStarUtil.isWarTest() then
		self.fields.Com_title:setTitle(i18n("NebulaAllstar_286"))
	end
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setItemProvider(handler(self, self.onRewardItemProvider))
	self.fields.List_reward:setVirtual()
	self.fields.Text_tip:setString(i18n("nebulaemperor_text_79"))
	_ENV = self.fields.Text_tip.setString
	_ENV, _ENV, self.fields.Text_tip.setString.defaultClick = i18n("nebulaemperor_text_79")
	_ENV, self.fields.Text_tip[1], i18n("nebulaemperor_text_79").title = i18n("nebulaemperor_text_79")
	_ENV, self.fields.Text_tip[2], i18n("nebulaemperor_text_79").title = i18n("nebulaemperor_text_79")
	self.fields.Text_tip.setString.tabsetArray, self.fields.Text_tip[3], i18n("nebulaemperor_text_79").title = self.fields.Text_tip, i18n("nebulaemperor_text_79")
	local self.fields.Text_tip.setString.callback, param = handler(self, self.onClickTab), self.fields.Text_tip.setString
	self.fields.com_Tab:initView(param)
end
function NebulaAllStarRewardPanel:onShow()
	print("=======NebulaAllStarRewardPanel:onShow")
end
function NebulaAllStarRewardPanel:onClickTab(tag)
	if self.curIndex == tag then
		return
	end
	self.curIndex = tag
	if not self.rewardConfig then
		_ENV = self.rewardConfig
	end
	self.rewardConfig = self.rewardConfig
	if not self.rewardConfig[self.curIndex] then
		_ENV, _UPVALUE2_, _ENV = nil, self.curIndex, self.rewardConfig[self.curIndex]
		;(nil).rankID = 1
		;(nil).title = i18n("NebulaAllstar_100")
		_ENV, (nil).showHelp = i18n("NebulaAllstar_100"), true
		i18n("NebulaAllstar_100").rankID = 2
		i18n("NebulaAllstar_100").title = i18n("NebulaAllstar_101")
		_ENV, _UPVALUE2_, self.rewardConfig[self.curIndex][1], self.curIndex[1] = nil, self.curIndex, self.curIndex
		_ENV, _UPVALUE2_, self.rewardConfig[self.curIndex][1], self.curIndex[2] = nil, self.curIndex, self.curIndex, i18n("NebulaAllstar_100")
		;(nil).rankID = 5
		_ENV, (nil).title = i18n("NebulaAllstar_102"), i18n("NebulaAllstar_102")
		i18n("NebulaAllstar_102").rankID = 3
		i18n("NebulaAllstar_102").title = i18n("NebulaAllstar_103")
		_ENV, _UPVALUE2_, self.rewardConfig[self.curIndex][2], self.curIndex[1] = nil, self.curIndex, self.curIndex
		_ENV, _UPVALUE2_, self.rewardConfig[self.curIndex][2], self.curIndex[2] = nil, self.curIndex, self.curIndex, i18n("NebulaAllstar_102")
		;(nil).rankID = 6
		_ENV, (nil).title = i18n("NebulaAllstar_104"), i18n("NebulaAllstar_104")
		i18n("NebulaAllstar_104").rankID = 4
		i18n("NebulaAllstar_104").title = i18n("NebulaAllstar_105")
		self.rewardConfig[self.curIndex][3], self.curIndex[1] = self.curIndex
		self.rewardConfig[self.curIndex][3], self.curIndex[2] = self.curIndex, i18n("NebulaAllstar_104")
		local config = self.rewardConfig[self.curIndex]
		local _ENV, ret = self.curIndex, self.curIndex
		for __, cfg in ipairs(config[self.curIndex]) do
			_ENV = nil
			;(nil).itemType = 1
			;(nil).title = cfg.title
			;(nil).showHelp = cfg.showHelp
			table.insert(ret, nil)
			local rewards = nebulaAllStarRead.getRewardConfigByType(cfg.rankID)
			for __, data in ipairs(rewards) do
				local rankCorridor = data.rankCorridor
				_ENV = nil
				;(nil).itemType = 2
				;(nil).rewards = data.reward
				;(nil).cfg = data
				table.insert(ret, nil)
			end
		end
		self.rewardConfig[self.curIndex] = ret
	end
	self.rewardData = self.rewardConfig[self.curIndex]
	self.fields.List_reward:setNumItems(#self.rewardData)
	self.fields.List_reward:scrollToView(0)
end
function NebulaAllStarRewardPanel:onRewardItemRenderer(index, obj)
	local data = self.rewardData[index + 1]
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		if not SoraDFIsRA() and data.itemType ~= 1 then
			obj:fixChildrenPos()
		end
		local _fields = obj._fields
		if _fields.Button_help then
			_fields.Button_help:addClickListener(function()
				SoraDShowHelpMsgTip(i18n("NebulaAllstar_377"))
			end)
		end
	end
	if data.itemType == 1 then
		self:initRewardTitle(obj, data)
	else
		self:initRewardSingle(obj, data)
	end
end
function NebulaAllStarRewardPanel:initRewardTitle(obj, data)
	obj:setString(data.title)
	local _fields = obj._fields
	_fields.Button_help:setVisible(data.showHelp or false)
end
function NebulaAllStarRewardPanel:initRewardSingle(obj, data)
	local _fields = obj._fields
	local rankStr = nebulaAllStarRead.getRewardConfigRankStr(data.cfg)
	local _fields = fguiHelper.get_fields(obj)
	nebulaAllStarRead = nil
	;(nil).rank = data.cfg.rankCorridor[1]
	;(nil).rankStr = rankStr
	_fields.Com_rankBase:initRankBaseData(nil)
	local rewards = data.rewards
	_fields.List:setItemRenderer(function(_index, _obj)
		_obj:initData(rewards[_index * 2 + 1], rewards[_index * 2 + 2])
	end)
	_fields.List:setNumItems(#rewards / 2)
	_fields.List:scrollToView(0)
end
function NebulaAllStarRewardPanel:onRewardItemProvider(index)
	local data = self.rewardData[index + 1]
	if data.itemType == 1 then
		return "ui://NebulaAllStar/Com_rewardTitle"
	else
		return "ui://NebulaAllStar/Com_rewardSingle"
	end
end
return NebulaAllStarRewardPanel
