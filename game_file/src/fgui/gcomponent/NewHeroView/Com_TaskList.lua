local heroTaskRead = include("heroTaskRead")
local heroTaskCtrl = SoraDGetCtrl("heroTaskCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TaskList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_TaskList", Com_TaskList)
function Com_TaskList:onInit()
	self.heros, _ENV, self.reward, _ENV = nil, nil, nil, nil
	self.increase = 0
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_heros:setItemRenderer(handler(self, self.onHeroRenderer))
	_ENV = handler(self, self.onHeroRenderer)
	handler(self, self.onHeroRenderer).num = ""
	self.fields.Text_bonus:setString(i18n("hero_appoint_23", handler(self, self.onHeroRenderer)))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Btn_star:setString(i18n("hero_appoint_20"))
	self.fields.Btn_star:addClickListener(handler(self, self.btnStarClick))
	self.fields.Btn_stop:setString(i18n("hero_appoint_21"))
	self.fields.Btn_stop:addClickListener(handler(self, self.btnStopClick))
	self:fixChildrenPos()
	self.fields.sheer:fix()
end
function Com_TaskList:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, math.floor(self.reward[index + 1].count * (1 + self.increase)))
end
function Com_TaskList:onHeroRenderer(index, obj)
	obj:initData(self.heros[index + 1])
end
function Com_TaskList:onShow()
end
function Com_TaskList:initData(taskData)
	self.data = taskData
	local cfg = heroTaskRead.getTaskConfig(self.data.id)
	self.fields.Text_name:setString(i18n(cfg.taskName))
	self.fields.Text_des:setString(i18n(cfg.taskDes))
	if not self.data.heros then
		heroTaskRead = self.data.heros
	end
	self.heros = self.data.heros
	self.increase = heroTaskRead.getRewardIncrease(self.data.id, self.heros)
	self.fields.Text_add:setString(tostring(self.increase * 100) .. "%")
	_UPVALUE2_ = tostring(self.increase * 100) .. "%"
	;(tostring(self.increase * 100) .. "%")[1] = "id"
	;(tostring(self.increase * 100) .. "%")[2] = "count"
	self.reward = serviceFunctions.tableFormat(cfg.taskReward, tostring(self.increase * 100) .. "%")
	self.fields.List_reward:setNumItems(#self.reward)
	self.controllers.c1:setSelectedIndex(self.data.state)
	if self.data.state == gHeroTaskState.NORMAL then
		self.Text_time:endTime()
		heroTaskRead = "count"
		;("count").time = SoraDConvertSecondToString(cfg.time)
		self.Text_time:setString(i18n("hero_appoint_24", "count"))
	elseif self.data.state == gHeroTaskState.START then
		self.Text_time:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).num = strTime
			return i18n("hero_appoint_25", nil)
		end)
		self.Text_time:beginTime(self.data.t + cfg.time - serviceFunctions.systemTime())
		self.fields.List_heros:setNumItems(#self.heros)
	else
		self.Text_time:endTime()
		self.Text_time:setString(i18n("hero_appoint_26"))
		self.fields.List_heros:setNumItems(#self.heros)
	end
end
function Com_TaskList:btnStarClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("HeroKnowledgePop", nil)
end
function Com_TaskList:btnStopClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("hero_appoint_35")
	;(nil).confirmFunc = function()
		heroTaskCtrl:reqStopTask(self.data.id)
	end
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	uiManager:show("MessageBox", nil)
end
return Com_TaskList
