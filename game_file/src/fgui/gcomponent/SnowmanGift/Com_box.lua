local baseComponent = require("fgui.base.baseComponent")
local Com_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SnowmanGift/Com_box", Com_box)
local snowmanGiftCtrl = SoraDGetCtrl("snowmanGiftCtrl")
function Com_box:onInit()
	self.fields.movie:setAllFrameName("dh_xrkz_add_bxtx_%02d.png", 1)
	self.fields.movie_Lock:setAllFrameName("dh_bxjlc_add_kjs_%02d.png", 1)
	self.fields.movie_unLock:setAllFrameName("dh_bxjlc_add_js_%02d.png", 1)
end
function Com_box:onShow()
end
function Com_box:updateBox()
	local status = snowmanGiftCtrl:getExtraRewardStatue(7)
	local lastTime = SoraDConfigGet("SnowmanGift:Com_box:unLockTime~integer") or 0
	if status == 0 and not serviceFunctions.isSameDay(lastTime) then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.movie_unLock:setVisible(true)
		self.fields.movie_Lock:setVisible(false)
		_ENV = nil
		;(nil)[1] = ffa.delay(0.1)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.lock:setVisible(false)
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.lock:setVisible(false)
		end)
		self:runAction(ffa.seq(nil))
		self.fields.movie_unLock:setPlaySettings(0, 25, 1, -1, function()
			self.controllers.c1:setSelectedIndex(status)
		end)
		SoraDConfigSet("SnowmanGift:Com_box:unLockTime~integer", serviceFunctions.systemTime())
	else
		self.controllers.c1:setSelectedIndex(status)
	end
end
return Com_box
