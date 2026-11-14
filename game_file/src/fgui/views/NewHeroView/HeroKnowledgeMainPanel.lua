local heroTaskCtrl = SoraDGetCtrl("heroTaskCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroKnowledgeMainPanel = class("HeroKnowledgeMainPanel", baseFguiPanel)
function HeroKnowledgeMainPanel:ctor(...)
	HeroKnowledgeMainPanel.super.ctor(self, ...)
	print("HeroKnowledgeMainPanel:ctor", self.viewName)
end
function HeroKnowledgeMainPanel:onInit()
	print("=======HeroKnowledgeMainPanel:onInit")
	self.taskList, _ENV = print, print
	self.fields.Com_title:initData(i18n("hero_appoint_18"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", strTime)
		return i18n("hero_appoint_19", nil)
	end)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onTaskRenderer))
end
function HeroKnowledgeMainPanel:onTaskRenderer(index, obj)
	obj:initData(self.taskList[index + 1])
end
function HeroKnowledgeMainPanel:onShow()
	print("=======HeroKnowledgeMainPanel:onShow")
	self:updateView()
end
function HeroKnowledgeMainPanel:updateTime()
	local remainTime = serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime()
	self.fields.Label_time:beginTime(remainTime)
end
function HeroKnowledgeMainPanel:updateIngTask()
	local ingTaskList = heroTaskCtrl:getIngTaskList()
	for i = 1, 8 do
		if ingTaskList[i] then
			self.fields["head_" .. i]:setVisible(true)
			self.fields["head_" .. i]:initData(ingTaskList[i])
		else
			self.fields["head_" .. i]:setVisible(false)
		end
	end
end
function HeroKnowledgeMainPanel:updateTaskList()
	self.taskList = heroTaskCtrl:getTaskList()
	self.fields.List:setNumItems(#self.taskList)
end
function HeroKnowledgeMainPanel:updateView(target, data)
	self:updateTime()
	self:updateIngTask()
	self:updateTaskList()
end
function HeroKnowledgeMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("hero_appoint_27")
	;(nil).content = i18n("hero_appoint_28")
	uiManager:show("RuleView", nil)
end
return HeroKnowledgeMainPanel
