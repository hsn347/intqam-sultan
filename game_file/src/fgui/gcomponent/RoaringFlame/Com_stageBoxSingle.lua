local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_stageBoxSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_stageBoxSingle", Com_stageBoxSingle)
function Com_stageBoxSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_stageBoxSingle:onShow()
end
function Com_stageBoxSingle:initData(index)
	local warBeginTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local curTime = serviceFunctions.systemTime()
	if 0 < index then
		self.cfg = roaringFlameWarRead.getWarTimeCfg(index)
		local nextCfg = roaringFlameWarRead.getWarTimeCfg(index + 1)
		local time = warBeginTime + self.cfg.offset_time
		local nextTime = nextCfg and warBeginTime + nextCfg.offset_time
		self.fields.title:setString(i18n(self.cfg.name))
		self.fields.Text_time:setString(os.date("!%m/%d", time))
		local status = 0
		if curTime >= time then
			status = 1
		end
		self.controllers.c_state:setSelectedIndex(status)
	else
		self.controllers.c_state:setSelectedIndex(1)
	end
end
function Com_stageBoxSingle:btnClick()
	if self.cfg then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n(self.cfg.des))
	end
end
return Com_stageBoxSingle
