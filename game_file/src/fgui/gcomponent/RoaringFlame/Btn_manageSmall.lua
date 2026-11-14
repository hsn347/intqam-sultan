local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_manageSmall = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/Btn_manageSmall", Btn_manageSmall)
function Btn_manageSmall:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_manageSmall:onShow()
end
function Btn_manageSmall:initData(cfg)
	self.cfg = cfg
	self.fields.icon:setSpriteFrame(self.cfg.png)
	self.fields.title:setString(self.cfg.title)
	if cfg.enum == 4 then
		_ENV = self.cfg.title
		self.cfg.title.byUID = true
		local readTime = SoraDConfigGet("Game:RoaringFlame_notice:readTime~integer", self.cfg.title) or 0
		local ret = readTime < roaringFlameWarCtrl:getNoticeLastTime()
		self:setReddot(ret)
	else
		self:setReddot(false)
	end
end
function Btn_manageSmall:setHandle(handle)
	self.handle = handle
end
function Btn_manageSmall:btnClick()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.cfg)
	end
end
return Btn_manageSmall
