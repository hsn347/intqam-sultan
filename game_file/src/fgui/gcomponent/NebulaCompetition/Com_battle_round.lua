local baseComponent = require("fgui.base.baseComponent")
local Com_battle_round = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Com_battle_round", Com_battle_round)
function Com_battle_round:onInit()
end
function Com_battle_round:onShow()
end
function Com_battle_round:initData(data, stage, curStage)
	if stage < curStage then
		self.controllers.c1:setSelectedIndex(1)
	elseif stage == curStage then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(2)
	end
	self.fields.Com_battle:initData(data, stage, curStage)
	_ENV = curStage
	curStage.num = stage
	self.fields.title:setString(i18n("common_text_3198", curStage))
end
return Com_battle_round
