local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001613 = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001613_Ctrl = SoraDGetCtrl("activity_9001613_Ctrl")
local activity_9001613_Read = include("activity_9001613_Read")
fgui.register_extension("ui://Activity_9001613/Com_Activity_9001613", Com_Activity_9001613)
function Com_Activity_9001613:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_PRIVILEGES
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Button_get:addClickListener(handler(self, self.onGetClick))
	local lossDay = activity_9001613_Ctrl:getLossDay()
	_ENV = handler(self, self.onGetClick)
	handler(self, self.onGetClick).num = lossDay
	self.fields.text_title1:setString(i18n("backprivilege_text_01", handler(self, self.onGetClick)))
	self.fields.text_title2:setString(i18n("backprivilege_text_02"))
	self.fields.text_title3:setString(i18n("activity_name_9001296"))
	self.fields.list_buff:setVirtual()
	self.fields.list_buff:setItemRenderer(handler(self, self.onBuffRenderer))
	self.fields.list_reward:setVirtual()
	self.fields.list_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_Activity_9001613:onShow()
	self:updateView()
end
function Com_Activity_9001613:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001613_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateView))
end
function Com_Activity_9001613:updateView()
	self.isGetReward = activity_9001613_Ctrl:getRewardTime()
	self.fields.Button_get:setString(i18n(self.isGetReward and "common_text_1892" or "common_text_1146"))
	self.fields.Button_get:setEnabled(not self.isGetReward)
	local backDay = activity_9001613_Ctrl:getBackDay()
	local buffCfg = activity_9001613_Read.getBuffCfg(backDay)
	activity_9001613_Read = i18n(self.isGetReward and "common_text_1892" or "common_text_1146")
	i18n(self.isGetReward and "common_text_1892" or "common_text_1146")[1] = buffCfg
	i18n(self.isGetReward and "common_text_1892" or "common_text_1146")[2] = backDay
	dump(i18n(self.isGetReward and "common_text_1892" or "common_text_1146"))
	if not buffCfg or not buffCfg.buffType then
		local activity_9001613_Ctrl, tmpBuffList = buffCfg.buffType, buffCfg.buffType
	end
	self.buffList, activity_9001613_Ctrl = i18n(self.isGetReward and "common_text_1892" or "common_text_1146")
	for i, v in ipairs(tmpBuffList) do
		local buffDesCfg = activity_9001613_Read.getBuffDesCfg(v)
		if buffDesCfg then
			table.insert(self.buffList, buffDesCfg)
		end
	end
	self.fields.list_buff:setNumItems(#self.buffList)
	local lossDay = activity_9001613_Ctrl:getLossDay()
	local rewardCfg = activity_9001613_Read.getRewardCfg(lossDay)
	activity_9001613_Read = i18n(self.isGetReward and "common_text_1892" or "common_text_1146")
	i18n(self.isGetReward and "common_text_1892" or "common_text_1146")[1] = rewardCfg
	i18n(self.isGetReward and "common_text_1892" or "common_text_1146")[2] = lossDay
	dump(i18n(self.isGetReward and "common_text_1892" or "common_text_1146"))
	if not rewardCfg or not rewardCfg.backReward then
		activity_9001613_Ctrl = rewardCfg.backReward
	end
	self.rewardList = rewardCfg.backReward
	self.fields.list_reward:setNumItems(#self.rewardList)
end
function Com_Activity_9001613:onGetClick()
	SoraDPlaySound()
	activity_9001613_Ctrl:reqGetReward()
end
function Com_Activity_9001613:onBuffRenderer(index, obj)
	local data = self.buffList[index + 1]
	obj:initData(data)
end
function Com_Activity_9001613:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
return Com_Activity_9001613
