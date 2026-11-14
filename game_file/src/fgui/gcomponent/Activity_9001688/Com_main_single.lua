local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local activityCommonSignRead = include("activityCommonSignRead")
local activity_9001688_Read = include("activity_9001688_Read")
local constantRead = include("constantRead")
local activityID = gActivityTimeActivityID.DAILY_SALUTE
local baseComponent = require("fgui.base.baseComponent")
local Com_main_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001688/Com_main_single", Com_main_single)
function Com_main_single:onInit()
	self.fields.Text_mail:setString(i18n("daily_salute_text09"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_sign:addClickListener(handler(self, self.btnSignClick))
end
function Com_main_single:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_main_single:onShow()
end
function Com_main_single:initData(model)
	self.fields.Text_title:setString(model == 1 and i18n("login_title_02") or i18n("daily_salute_text08"))
	if model == 1 then
		self.fields.Text_mail:setVisible(false)
		self.fields.Button_sign:setVisible(true)
		local curDay = math.max(1, activityCommonSignCtrl:getCurDay(activityID))
		local signState = activityCommonSignCtrl:getSignInfoByDay(activityID, curDay)
		print("curDay,signState=====", curDay, signState)
		local isSigned = signState ~= gSignRewardType.NO_SIGN
		local cfg = activityCommonSignRead.getRewardConfig(activityID, SoraDGetActivityClassType(activityID))
		activityID = SoraDGetActivityClassType(activityID)
		SoraDGetActivityClassType(activityID)[1] = "id"
		SoraDGetActivityClassType(activityID)[2] = "count"
		self.reward = serviceFunctions.tableFormat(cfg[curDay].normalReward, SoraDGetActivityClassType(activityID))
		self.fields.List:setNumItems(#self.reward)
		self.fields.List:setScrollEnable(#self.reward > 6)
		self.fields.Button_sign:setString(isSigned and i18n("common_text_2874") or i18n("common_text_2477"))
		self.fields.Button_sign:setEnabled(not isSigned)
		self.fields.Button_sign:setReddot(not isSigned)
	else
		self.fields.Text_mail:setVisible(true)
		self.fields.Button_sign:setVisible(false)
		local value = activity_9001688_Ctrl:getGlobalScore()
		local baseReward = constantRead.getConstValueArray("DAILY_SALUTE_BASE_REWARD")
		local stageReward = activity_9001688_Read.getStageReward(value)
		local _ENV, rewardMap = value, value
		for i = 1, #baseReward - 1, 2 do
			rewardMap[baseReward[i]] = baseReward[i + 1]
		end
		for k, v in ipairs(stageReward) do
			rewardMap[v.id] = v.count + (rewardMap[v.id] or 0)
		end
		self.reward, _ENV = ipairs(stageReward)
		for id, count in pairs(rewardMap) do
			_ENV = rewardMap[v.id] or 0
			;(rewardMap[v.id] or 0).id = id
			;(rewardMap[v.id] or 0).count = count
			table.insert(self.reward, rewardMap[v.id] or 0)
		end
		table.sort(self.reward, function(a, b)
			return a.id < b.id
		end)
		self.fields.List:setNumItems(#self.reward)
		self.fields.List:setScrollEnable(#self.reward > 6)
	end
end
function Com_main_single:btnSignClick()
	SoraDPlaySound()
	activityCommonSignCtrl:reqSign(activityID)
end
return Com_main_single
