local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_taskList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001688/Com_taskList", Com_taskList)
function Com_taskList:onInit()
	self:fixChildrenPos()
end
function Com_taskList:onShow()
end
function Com_taskList:initData(cfg, taskType)
	self.fields.Com_item:setIcon(cfg.image, cfg.reward[2])
	self.fields.Text_des:setString(i18n(cfg.des))
	self.fields.Bar:setMax(cfg.aim)
	local status, leftTime = activity_9001688_Ctrl:getCycleState()
	local taskCount = activity_9001688_Ctrl:getStageBoxProgress(taskType)
	local tCount = math.floor(taskCount / cfg.aim)
	self.fields.Bar:setValue(taskCount % cfg.aim)
	if status == 0 then
		_ENV = i18n(cfg.des)
		i18n(cfg.des).num = tCount
		if i18n("daily_salute_text16", i18n(cfg.des)) then
			goto lbl_55
		end
	end
	_ENV = i18n(cfg.des)
	i18n(cfg.des).num = tCount
	::lbl_55::
	self.fields.Text_donate:setString((i18n("daily_salute_text18", i18n(cfg.des))))
end
return Com_taskList
