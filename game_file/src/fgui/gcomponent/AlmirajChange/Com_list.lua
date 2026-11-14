local mirajChallengeCtrl = SoraDGetCtrl("mirajChallengeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AlmirajChange/Com_list", Com_list)
function Com_list:onInit()
	self.fields.n6:fixPos()
	self.fields.Text_score:fixPos()
	self.fields.Text_times:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.n11:fixPos()
end
function Com_list:onShow()
end
function Com_list:initData(data)
	if data.cType == 1 then
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(data.cfg[1]))
		self.fields.Text_des:setString(i18n("almirajChange_text04", nil))
		local soldierCount = math.min(mirajChallengeCtrl:getSoldierCount(), data.cfg[3])
		_ENV = i18n("almirajChange_text04", nil)
		i18n("almirajChange_text04", nil).var = fguiHelper.getColorString("#E2AF27", soldierCount)
		i18n("almirajChange_text04", nil).var1 = data.cfg[3]
		self.fields.Text_times:setString(i18n("almirajChange_text02", i18n("almirajChange_text04", nil)))
	elseif data.cType == 2 then
		_ENV = i18n("almirajChange_text02", i18n("almirajChange_text04", nil))
		i18n("almirajChange_text02", i18n("almirajChange_text04", nil)).num = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(data.cfg[1]))
		self.fields.Text_des:setString(i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))))
		local buildCount = math.min(mirajChallengeCtrl:getBuildCount(), data.cfg[3])
		_ENV = i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil)))
		i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))).var = fguiHelper.getColorString("#E2AF27", buildCount)
		i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))).var1 = data.cfg[3]
		self.fields.Text_times:setString(i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil)))))
	elseif data.cType == 3 then
		_ENV = i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))))
		i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil)))).num = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(data.cfg[1]))
		self.fields.Text_des:setString(i18n("almirajChange_text06", i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))))))
		local monsterCount = math.min(mirajChallengeCtrl:getMonsterCount(), data.cfg[3])
		_ENV = i18n("almirajChange_text06", i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil)))))
		i18n("almirajChange_text06", i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))))).var = fguiHelper.getColorString("#E2AF27", monsterCount)
		i18n("almirajChange_text06", i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil))))).var1 = data.cfg[3]
		self.fields.Text_times:setString(i18n("almirajChange_text02", i18n("almirajChange_text06", i18n("almirajChange_text02", i18n("almirajChange_text05", i18n("almirajChange_text02", i18n("almirajChange_text04", nil)))))))
	end
	self.fields.Text_score:setString(string.formatnumberthousands(data.cfg[2]))
end
return Com_list
