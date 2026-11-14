local baseComponent = require("fgui.base.baseComponent")
local Com_rewardsingle2_9001573 = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local activity_9001573_Read = include("activity_9001573_Read")
fgui.register_extension("ui://Activity_9001573/Com_rewardsingle2_9001573", Com_rewardsingle2_9001573)
function Com_rewardsingle2_9001573:onInit()
	self.fields.Text_finish:setString(i18n("common_text_2601"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_rewardsingle2_9001573:onShow()
end
function Com_rewardsingle2_9001573:initData(cfg)
	self.reward, activity_9001573_Ctrl = nil, nil
	local lv = activity_9001573_Ctrl:getPowerRatio()
	local powerRatio = activity_9001573_Read.getRewardRatio(lv)
	for i, v in ipairs(cfg.reward) do
		activity_9001573_Ctrl = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(self.reward, nil)
	end
	for i, v in ipairs(cfg.diffReward) do
		local addNum = math.floor(v.count * powerRatio / 1000)
		local isIn = false
		for i2, v2 in ipairs(self.reward) do
			if v2.id == v.id then
				isIn = true
				v2.count = v2.count + addNum
			end
		end
		if not isIn then
			activity_9001573_Ctrl = ipairs(self.reward)
			ipairs(self.reward).id = v.id
			ipairs(self.reward).count = addNum
			table.insert(self.reward, ipairs(self.reward))
		end
	end
	local cnt = #self.reward
	if cfg.rewardType == 3 then
		local num2 = cfg.luckyType[2]
		local num1 = activity_9001573_Ctrl:getRuinBuildData(cfg.luckyType[1])
		if cfg.rewardDes then
			activity_9001573_Ctrl = table.insert
			table.insert.num1 = num1
			table.insert.num2 = num2
			if i18n(cfg.rewardDes, table.insert) then
				goto lbl_88
			end
		end
		::lbl_88::
		self.fields.txt_des:setString("")
		self.controllers.c1:setSelectedIndex(num2 <= num1 and 1 or 0)
	else
		self.fields.txt_des:setString(i18n(cfg.rewardDes))
	end
	self.fields.List_reward:setNumItems(cnt)
	self.fields.List_reward:scrollToView(0, false, false)
end
function Com_rewardsingle2_9001573:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
return Com_rewardsingle2_9001573
