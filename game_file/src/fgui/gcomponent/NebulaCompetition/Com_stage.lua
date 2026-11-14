local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Com_stage", Com_stage)
function Com_stage:onInit()
end
function Com_stage:onShow()
end
function Com_stage:initData(stage)
	self.fields.Text_stage:setString(stage)
	local curStage = nebulaCompetitionCtrl:getCurrentStage()
	if nebulaCompetitionCtrl:isActivityCalc() then
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
	local stageName = nebulaCompetitionCtrl:getStageName(stage)
	self.fields.title:setString(i18n(stageName))
end
return Com_stage
