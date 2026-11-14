local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_achievement = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_achievement", Com_achievement)
function Com_achievement:onInit()
	self.fields.Bar_1:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnGet))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_achievement:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
function Com_achievement:initData(data)
	self.uniqueID = data.uniqueID
	self.state = data.state
	if not activity_9001734_Read.getAchievementCfgByUniqueId(self.uniqueID) then
		local activity_9001734_Read, cfg = activity_9001734_Read.getAchievementCfgByUniqueId(self.uniqueID), activity_9001734_Read.getAchievementCfgByUniqueId(self.uniqueID)
	end
	if cfg.taskIcon and cfg.taskIcon ~= "" then
		self.fields.Load_icon:setURL(cfg.taskIcon)
	end
	local info = activity_9001734_Ctrl:getAchievementInfo(self.uniqueID, true)
	self.fields.Text_des:setString(info.taskDes)
	self.fields.Bar_1:setMax(info.barMax)
	local barValue = math.min(info.barMax, info.barValue)
	self.fields.Bar_1:setValue(barValue)
	if not cfg.reward then
		activity_9001734_Read = cfg.reward
	end
	self.rewards = cfg.reward
	self.fields.List:setNumItems(#self.rewards)
	self.fields.Button_get:setString(i18n("common_text_677"))
	if self.state == gBtnTargetStatusDef.GO then
		self.fields.Button_get:setBright(false)
		self.fields.Button_get:setString(i18n("common_text_677"))
	elseif self.state == gBtnTargetStatusDef.GOT then
		self.fields.Button_get:setBright(false)
		self.fields.Button_get:setString(i18n("common_text_1892"))
	elseif self.state == gBtnTargetStatusDef.GET then
		self.fields.Button_get:setBright(true)
		self.fields.Button_get:setString(i18n("common_text_677"))
	end
end
function Com_achievement:onClickBtnGet()
	SoraDPlaySound()
	if self.state == gBtnTargetStatusDef.GO then
		SoraDShowMsgTip(i18n("common_text_2139"))
	elseif self.state == gBtnTargetStatusDef.GOT then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
	elseif self.state == gBtnTargetStatusDef.GET then
		activity_9001734_Ctrl:reqAchiMsg(self.uniqueID)
		SoraDShowLoading()
	end
end
return Com_achievement
