local baseComponent = require("fgui.base.baseComponent")
local Com_9001577_stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001577/Com_9001577_stage", Com_9001577_stage)
local activity_9001577_Ctrl = SoraDGetCtrl("activity_9001577_Ctrl")
function Com_9001577_stage:onInit()
end
function Com_9001577_stage:onShow()
end
function Com_9001577_stage:initData(stage)
	self.fields.Text_stage:setString(stage)
	local curStage = activity_9001577_Ctrl:getCurrentStage()
	if activity_9001577_Ctrl:isActivityCalc() then
		curStage = curStage + 1
	end
	self:setGrayed(stage < curStage)
	if stage == curStage then
		self.controllers.c1:setSelectedIndex(1)
	elseif stage < curStage then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(2)
	end
	local stageName = activity_9001577_Ctrl:getStageName(stage)
	self.fields.title:setString(i18n(stageName))
end
return Com_9001577_stage
