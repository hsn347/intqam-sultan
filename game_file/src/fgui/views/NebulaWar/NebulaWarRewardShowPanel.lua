local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarRewardShowPanel = class("NebulaWarRewardShowPanel", baseFguiPanel)
function NebulaWarRewardShowPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarRewardShowPanel:ctor", self.viewName)
	self.clickState, _ENV, self.showTeamType = print, print, 1
end
function NebulaWarRewardShowPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarRewardShowPanel:onInit()
	print("=======NebulaWarRewardShowPanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_war_text_0002"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	_ENV = self.fields.List_reward.setItemRenderer
	_ENV, _ENV, self.fields.List_reward.setItemRenderer.defaultClick = nebulaActivityCtrl, nebulaActivityCtrl:getCurRound(), nebulaActivityCtrl:getCurRound()
	_ENV, nebulaActivityCtrl:getCurRound()[1], nebulaActivityCtrl.title = nebulaActivityCtrl, nebulaActivityCtrl, i18n("nebula_stage_name_004")
	_ENV, nebulaActivityCtrl:getCurRound()[2], nebulaActivityCtrl.title = nebulaActivityCtrl, nebulaActivityCtrl, i18n("nebula_stage_name_005")
	_ENV, nebulaActivityCtrl:getCurRound()[3], nebulaActivityCtrl.title = nebulaActivityCtrl, nebulaActivityCtrl, i18n("nebula_stage_name_006")
	self.fields.List_reward.setItemRenderer.tabsetArray, nebulaActivityCtrl:getCurRound()[4], nebulaActivityCtrl.title = nebulaActivityCtrl:getCurRound(), nebulaActivityCtrl, i18n("nebula_stage_name_007")
	local self.fields.List_reward.setItemRenderer.callback, param = handler(self, self.onClickTab), self.fields.List_reward.setItemRenderer
	self.fields.com_Tab:initView(param)
	_ENV = self.fields.com_Tab.initView
	_ENV, _ENV, self.fields.com_Tab.initView.defaultClick = param, self.fields.com_Tab, 1
	_ENV, self.fields.com_Tab[1], param.title = param, param, i18n("nebula_war_text_0371")
	self.fields.com_Tab.initView.tabsetArray, self.fields.com_Tab[2], param.title = self.fields.com_Tab, param, i18n("nebula_war_text_0593")
	local self.fields.com_Tab.initView.callback, param = handler(self, self.onClickTab2), self.fields.com_Tab.initView
	self.fields.com_Tab2:initView(param)
end
function NebulaWarRewardShowPanel:onShow()
	print("=======NebulaWarRewardShowPanel:onShow")
end
function NebulaWarRewardShowPanel:onClickHelp(...)
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEBULA_AREA_ROS)
	end
end
function NebulaWarRewardShowPanel:onClickTab(tag)
	if self.showRound == tag then
		return
	end
	self.showRound = tag
	if self.showTeamType ~= 1 then
		self.fields.com_Tab2:setTabIndex(1, true)
	else
		self:updateRoundConfig()
	end
end
function NebulaWarRewardShowPanel:onClickTab2(tag)
	print("==onClickTab2==", tag)
	if self.showTeamType == tag then
		return
	end
	self.showTeamType = tag
	self:updateRoundConfig()
end
function NebulaWarRewardShowPanel:updateRoundConfig(...)
	self.clickState, _ENV = nil, nil
	if not self.rewardConfig then
		_ENV = self.rewardConfig
	end
	self.rewardConfig = self.rewardConfig
	if not self.rewardConfig[self.showRound] then
		_ENV = self.rewardConfig[self.showRound]
	end
	self.rewardConfig[self.showRound] = self.rewardConfig[self.showRound]
	if not self.rewardConfig[self.showRound][self.showTeamType] then
		local _ENV, ret = self.rewardConfig[self.showRound][self.showTeamType], self.rewardConfig[self.showRound][self.showTeamType]
		local _ENV, _ENV, _ENV, titleMap = self.showRound, self.rewardConfig[self.showRound], self.showTeamType, self.showTeamType
		self.showRound.sort = 1
		_ENV, self.rewardConfig[self.showRound]["3_0"], self.showRound.title = self.showRound, self.showRound, i18n("common_text_2195")
		self.showRound.sort = 2
		_ENV, self.rewardConfig[self.showRound]["1_0"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0005")
		self.showRound.sort = 3
		_ENV, self.rewardConfig[self.showRound]["2_0"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0252")
		self.showRound.sort = 10
		_ENV, self.rewardConfig[self.showRound]["3_1"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0519")
		self.showRound.sort = 20
		_ENV, self.rewardConfig[self.showRound]["3_2"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0520")
		self.showRound.sort = 30
		_ENV, self.rewardConfig[self.showRound]["1_1"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0521")
		self.showRound.sort = 40
		_ENV, self.rewardConfig[self.showRound]["2_1"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0522")
		self.showRound.sort = 50
		_ENV, self.rewardConfig[self.showRound]["1_2"], self.showRound.title = self.showRound, self.showRound, i18n("nebula_war_text_0523")
		self.showRound.sort = 60
		self.rewardConfig[self.showRound]["2_2"], self.showRound.title = self.showRound, i18n("nebula_war_text_0524")
		local titleConfig = self.rewardConfig[self.showRound]
		local selfReginId = nebulaActivityCtrl:getSelfRegionId()
		if nebulaWarRead.checkCampType1(selfReginId) then
			_ENV, _ENV = selfReginId, nebulaWarRead.checkCampType1(selfReginId)
			selfReginId.sort = 21
			_ENV = nil
			;(nil).num = 3
			_ENV, nebulaWarRead.checkCampType1(selfReginId)["3_3"], selfReginId.title = selfReginId, selfReginId, i18n("nebula_war_text_0619", nil)
			selfReginId.sort = 22
			_ENV = nil
			;(nil).num = 4
			_ENV, nebulaWarRead.checkCampType1(selfReginId)["3_4"], selfReginId.title = selfReginId, selfReginId, i18n("nebula_war_text_0619", nil)
			selfReginId.sort = 61
			_ENV = nil
			;(nil).num = 3
			_ENV, nebulaWarRead.checkCampType1(selfReginId)["1_3"], selfReginId.title = selfReginId, selfReginId, i18n("nebula_war_text_0617", nil)
			selfReginId.sort = 62
			_ENV = nil
			;(nil).num = 3
			_ENV, nebulaWarRead.checkCampType1(selfReginId)["2_3"], selfReginId.title = selfReginId, selfReginId, i18n("nebula_war_text_0618", nil)
			selfReginId.sort = 63
			_ENV = nil
			;(nil).num = 4
			_ENV, nebulaWarRead.checkCampType1(selfReginId)["1_4"], selfReginId.title = selfReginId, selfReginId, i18n("nebula_war_text_0617", nil)
			selfReginId.sort = 64
			_ENV = nil
			;(nil).num = 4
			nebulaWarRead.checkCampType1(selfReginId)["2_4"], selfReginId.title = selfReginId, i18n("nebula_war_text_0618", nil)
			local config = nebulaWarRead.checkCampType1(selfReginId)
			table.merge(titleConfig, config)
		end
		local config = clone(nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType))
		local _ENV, temp = nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType)
		for i, v in ipairs(config) do
			v.key = v.key or v.type .. "_" .. v.battldId
			if titleConfig[v.key] then
				v.sort = v.sort or titleConfig[v.key].sort
				v.title = v.title or titleConfig[v.key].title
				table.insert(temp, v)
			end
		end
		config = temp
		table.sort(config, function(a, b)
			if a.sort ~= b.sort then
				return a.sort < b.sort
			end
			return a.id < b.id
		end)
		for i, v in ipairs(config) do
			if not titleMap[v.key] then
				_ENV = v
				v.itemType = 1
				v.title = v.title
				v.list, _ENV, v.index = #ret + 1, #ret + 1, #ret + 1
				table.insert(ret, v)
				titleMap[v.key] = #ret
			end
			local titleStr
			local rank = v.rank
			if #rank == 1 then
				_ENV = nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType)
				nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType).var = rank[1]
				titleStr = i18n("atlantiswar_text_0133", nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType))
			elseif #rank == 2 then
				_ENV = nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType)
				nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType).var1 = rank[1]
				nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType).var2 = rank[2]
				titleStr = i18n("atlantiswar_text_0134", nebulaWarRead.getRewardShowConfig(self.showRound, self.showTeamType))
			end
			local tab = ret[titleMap[v.key]]
			_ENV = rank[2]
			rank[2].itemType = 2
			rank[2].title = titleStr
			rank[2].award = v.award
			table.insert(tab.list, rank[2])
		end
		self.rewardConfig[self.showRound][self.showTeamType] = ret
	end
	self.rewardData = self.rewardConfig[self.showRound][self.showTeamType]
	self.fields.List_reward:setNumItems(#self.rewardData)
	self.fields.List_reward:getScrollPane():updatePositionImmediately()
	self.fields.List_reward:jumpToTop()
end
function NebulaWarRewardShowPanel:onRewardItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		_fields.Panel_click:addClickListener(function(EventContext)
			local _obj = EventContext:getSender()
			local _index = _obj.index + 1
			local isLaunched = not self.clickState[_index]
			self.clickState[_index] = isLaunched
			if isLaunched then
				_fields.List:setNumItems(0)
				_fields.List:resizeToFit(0)
				_fields.Sprite_arr:setRotation(SoraDFPosX(90, 0))
			else
				local data = self.rewardData[_index]
				_fields.List:setNumItems(#data.list)
				_fields.List:resizeToFit(#data.list)
				_fields.Sprite_arr:setRotation(0)
			end
		end)
	end
	_fields.Panel_click.index = index
	local data = self.rewardData[index + 1]
	obj:setString(data.title or "")
	_fields.List:setItemRenderer(function(_index1, _obj1)
		local _data = data.list[_index1 + 1]
		_obj1:setString(_data.title or "")
		local award = _data.award
		if award then
			local List_reward = _obj1:getChild("List_reward")
			List_reward:setItemRenderer(function(_index2, _obj2)
				_obj2:initData(award[_index2 * 2 + 1], award[_index2 * 2 + 2])
			end)
			List_reward:setNumItems(#award / 2)
			if #award / 2 > 0 then
				List_reward:scrollToView(0)
			end
		end
	end)
	_fields.List:setNumItems(#data.list)
	_fields.List:resizeToFit(#data.list)
	_fields.Sprite_arr:setRotation(0)
end
return NebulaWarRewardShowPanel
