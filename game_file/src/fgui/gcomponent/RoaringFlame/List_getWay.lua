local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local List_getWay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/List_getWay", List_getWay)
function List_getWay:onInit()
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function List_getWay:onShow()
end
function List_getWay:initData(cfg, parent)
	self.cfg = cfg
	self.parent = parent
	self.fields.icon:setSpriteFrame(cfg.icon)
	self.fields.Text_name:setString(cfg.title)
end
function List_getWay:btnGoClick()
	SoraDPlaySound()
	if self.cfg.tag == 3 then
		local giftCfg = roaringFlameWarRead.getRechargeConfig(3)
		if roaringFlameWarCtrl:isSeniorRewardLock() then
			SoraDShowMsgTip(i18n("StarlitNight_text_10"))
		else
			uiManager:show("RoaringFlame_DecreeGift")
		end
	else
		_ENV = "RoaringFlame_DecreeGift"
		;("RoaringFlame_DecreeGift").tag = self.cfg.jumpTag
		uiManager:show("RoaringFlame_Decree", "RoaringFlame_DecreeGift")
	end
	if self.parent then
		self.parent:close()
	end
end
return List_getWay
