local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local btn_stage = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/btn_stage", btn_stage)
function btn_stage:onInit()
	self.fields.mv_hy:setAllFrameName("9001674_fireball_%.2d.png", 1)
	self:addClickListener(handler(self, self.btnClick))
end
function btn_stage:onShow()
end
function btn_stage:initData(cfg)
	self.cfg = cfg
	self.fields.title:setString(self.cfg.index)
	self.status = 0
	local status, remainTime = roaringFlameWarRead.getDuneHistoryStatus(cfg.index)
	self.status = status
	if status == 2 then
		local progress = roaringFlameWarCtrl:getMileStoneProgress(cfg.index)
		local condition = cfg.task_cond[1]
		self.status = progress >= condition.num and 3 or 2
	end
	self.controllers.c1:setSelectedIndex(self.status)
	local isClaimed = roaringFlameWarCtrl:isMileStoneRewarded(self.cfg.index)
	self.fields.box:setVisible(not isClaimed)
	self.fields.box:setGrayed(self.status < 2)
end
function btn_stage:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_MILESTONE"
	;(nil).key = "jump"
	;(nil).index = self.cfg.index
	SoraDSendMessage(nil)
end
return btn_stage
