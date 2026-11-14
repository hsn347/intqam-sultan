local baseComponent = require("fgui.base.baseComponent")
local Com_levelRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001732/Com_levelRewardSingle", Com_levelRewardSingle)
function Com_levelRewardSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_levelRewardSingle:onShow()
end
function Com_levelRewardSingle:initData(level, cfg, unlock, gotRewardLv, curLv)
	self.unlock = unlock
	self.gotRewardLv = gotRewardLv
	self.curLv = curLv
	self.fields.Text_level:setString(tostring(level))
	local _ENV, dataList = self.fields.Text_level.setString, self.fields.Text_level.setString
	local rewards1 = cfg.normalReward
	_ENV = tostring(level)
	tostring(level).rewardType = 1
	tostring(level).reward = rewards1[1]
	table.insert(dataList, tostring(level))
	local rewards2 = cfg.advanceReward
	_ENV = rewards1[1]
	rewards1[1].rewardType = 2
	rewards1[1].reward = rewards2[1]
	table.insert(dataList, rewards1[1])
	_ENV = rewards1[1]
	rewards1[1].rewardType = 2
	rewards1[1].reward = rewards2[2]
	table.insert(dataList, rewards1[1])
	local rewards3 = cfg.seniorReward
	_ENV = rewards2[2]
	rewards2[2].rewardType = 3
	rewards2[2].reward = rewards3[1]
	table.insert(dataList, rewards2[2])
	_ENV = rewards2[2]
	rewards2[2].rewardType = 3
	rewards2[2].reward = rewards3[2]
	table.insert(dataList, rewards2[2])
	for i, data in ipairs(dataList) do
		data.lv = level
		local Com_item = self.fields["Com_item" .. i]
		self:updateItemLevel(Com_item, data)
	end
end
function Com_levelRewardSingle:updateItemLevel(obj, data)
	local reward = data.reward
	if reward and next(reward) then
		obj:setVisible(true)
		local _fields = fguiHelper.get_fields(obj)
		_fields.Com_item:initData(reward.id, reward.count)
		local c_state = obj:getController("state")
		c_state:setSelectedIndex(self:getItemSingleState(data))
		if not self.isAniItemInit then
			_fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
			self.isAniItemInit = true
		end
	else
		obj:setVisible(false)
	end
end
function Com_levelRewardSingle:getItemSingleState(data)
	local rewardType = data.rewardType
	if not self.unlock[rewardType] then
		return 0
	end
	local gotLv = self.gotRewardLv[rewardType] or 0
	local showLv = data.lv
	if gotLv >= showLv then
		return 2
	elseif showLv <= self.curLv then
		return 1
	else
		return 3
	end
end
return Com_levelRewardSingle
