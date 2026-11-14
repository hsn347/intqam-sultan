local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_task = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
fgui.register_extension("ui://Activity_9001705/Com_9001705_task", Com_9001705_task)
function Com_9001705_task:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function Com_9001705_task:onShow()
end
function Com_9001705_task:onItemRender(index, obj)
	local item = self.reward[index + 1]
	obj:initData(item.id, item.count)
end
function Com_9001705_task:initData(data, parent)
	self.data = data
	dump(self.data, "Com_9001705_task:initData")
	self.parent = parent
	local str = data.cfg.achivementDes
	for i, v in pairs(str) do
		if tolua.type(i) == "string" then
			_ENV = nil
			;(nil).color = "#E2AF27"
			;(nil).i = "true"
			str[i] = SoraDWrapHtmlTagByStyle(v, nil)
		end
	end
	_ENV = str
	str.color = "#F0E6D2"
	self.fields.Text_des:setString(SoraDWrapHtmlTagByStyle(i18n(str), str))
	local aim = data.cfg.require
	local progress = activity_9001705_Ctrl:getAchieveNum(data.cfg.achivementType)
	_ENV = SoraDWrapHtmlTagByStyle(i18n(str), str)
	SoraDWrapHtmlTagByStyle(i18n(str), str).var = fguiHelper.getColorString(aim <= progress and "#D7C39B" or "#E02B2B", progress)
	SoraDWrapHtmlTagByStyle(i18n(str), str).var1 = aim
	self.fields.Text_pro:setString(i18n("alliance_stronghold_text_070", SoraDWrapHtmlTagByStyle(i18n(str), str)))
	_UPVALUE2_ = i18n("alliance_stronghold_text_070", SoraDWrapHtmlTagByStyle(i18n(str), str))
	i18n("alliance_stronghold_text_070", SoraDWrapHtmlTagByStyle(i18n(str), str))[1] = "id"
	i18n("alliance_stronghold_text_070", SoraDWrapHtmlTagByStyle(i18n(str), str))[2] = "count"
	self.reward = serviceFunctions.tableFormat(data.cfg.reward, i18n("alliance_stronghold_text_070", SoraDWrapHtmlTagByStyle(i18n(str), str)))
	self.fields.List_reward:setNumItems(#self.reward)
	if self.data.taskStatus == gBtnTargetStatusDef.GOT then
		self.fields.Btn_go:setBtnColorIndex(0)
		self.fields.Btn_go:setString(i18n("common_text_1892"))
		self.fields.Btn_go:setEnabled(false)
		self.fields.Btn_go:setVisible(true)
	elseif self.data.taskStatus == gBtnTargetStatusDef.GET then
		self.fields.Btn_go:setBtnColorIndex(0)
		self.fields.Btn_go:setString(i18n("common_text_1146"))
		self.fields.Btn_go:setEnabled(true)
		self.fields.Btn_go:setVisible(true)
	else
		self.fields.Btn_go:setBtnColorIndex(2)
		self.fields.Btn_go:setString(i18n("common_text_477"))
		self.fields.Btn_go:setEnabled(true)
		self.fields.Btn_go:setVisible(true)
	end
end
function Com_9001705_task:btnGoClick()
	SoraDPlaySound()
	if self.data.taskStatus == gBtnTargetStatusDef.GET then
		activity_9001705_Ctrl:reqSnowCompetitionAchievementReward(self.data.id)
		SoraDShowLoading(self.parent)
	else
		self.parent:close()
	end
end
return Com_9001705_task
