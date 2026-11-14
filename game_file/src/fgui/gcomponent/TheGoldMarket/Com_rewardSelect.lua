local goldSoukCtrl = SoraDGetCtrl("goldSoukCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSelect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TheGoldMarket/Com_rewardSelect", Com_rewardSelect)
function Com_rewardSelect:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_rewardSelect:onShow()
end
function Com_rewardSelect:initData(cfg)
	self.cfg = cfg
	self.fields.title:setString(self.cfg.integral)
	local myScore = goldSoukCtrl:getScore()
	self.fields.box:initStyle(math.min(8, self.cfg.Id))
	self.status = gBtnTargetStatusDef.GO
	if goldSoukCtrl:isBoxGot(self.cfg.Id) then
		self.status = gBtnTargetStatusDef.GOT
	elseif myScore >= self.cfg.integral then
		self.status = gBtnTargetStatusDef.GET
	end
	self.fields.box:setStatus(self.status)
end
function Com_rewardSelect:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).cfg = self.cfg
	;(nil).status = self.status
	uiManager:show("rewardPop", nil)
end
return Com_rewardSelect
