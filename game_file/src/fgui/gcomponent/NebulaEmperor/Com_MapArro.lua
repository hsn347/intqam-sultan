local baseComponent = require("fgui.base.baseComponent")
local Com_MapArro = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperor/Com_MapArro", Com_MapArro)
_ENV, _UPVALUE8_ = "ui://NebulaEmperor/Com_MapArro", fgui.register_extension
;("ui://NebulaEmperor/Com_MapArro").pos = cc.p(179, 46)
;("ui://NebulaEmperor/Com_MapArro").scale = 1
_ENV, ("ui://NebulaEmperor/Com_MapArro").offset = cc.p(-12, -10), cc.p(-12, -10)
cc.p(-12, -10).pos = cc.p(110, -16)
cc.p(-12, -10).scale = 1
_ENV, cc.p(-12, -10).offset = cc.p(-13, -7), cc.p(-13, -7)
cc.p(-13, -7).pos = cc.p(-47, -10)
cc.p(-13, -7).scale = -1
_ENV, cc.p(-13, -7).offset = cc.p(15, -3), cc.p(15, -3)
cc.p(15, -3).pos = cc.p(-178, 27)
cc.p(15, -3).scale = -1
_ENV, cc.p(15, -3).offset = cc.p(12, -10), cc.p(12, -10)
cc.p(12, -10).pos = cc.p(-202, 113)
cc.p(12, -10).scale = -1
_ENV, cc.p(12, -10).offset = cc.p(6, -14), cc.p(6, -14)
cc.p(6, -14).pos = cc.p(-159, 225)
cc.p(6, -14).scale = -1
_ENV, cc.p(6, -14).offset = cc.p(-3, -15), cc.p(-3, -15)
cc.p(-3, -15).pos = cc.p(247, 124)
cc.p(-3, -15).scale = 1
_ENV, cc.p(-3, -15).offset = cc.p(-6, -14), cc.p(-6, -14)
cc.p(-6, -14).pos = cc.p(205, 215)
cc.p(-6, -14).scale = 1
cc.p(-6, -14).offset = cc.p(3, -15)
fgui.register_extension[1] = "ui://NebulaEmperor/Com_MapArro"
fgui.register_extension[2] = cc.p(-12, -10)
fgui.register_extension[3] = cc.p(-13, -7)
fgui.register_extension[4] = cc.p(15, -3)
fgui.register_extension[5] = cc.p(12, -10)
fgui.register_extension[6] = cc.p(6, -14)
fgui.register_extension[7] = cc.p(-3, -15)
local fgui.register_extension[8], config = cc.p(-6, -14), fgui.register_extension
function Com_MapArro:onInit()
	self.fields.movie:setAllFrameName("dh_xydwyg_jt_%.2d.png")
end
function Com_MapArro:onShow()
end
function Com_MapArro:initData(rId)
	local centerPos = cc.p(320, 0)
	self.fields.icon_me:setPosition(cc.pAdd(centerPos, config[rId].pos))
	local scale = config[rId].scale
	self.fields.movie:setScaleX(scale)
	for i = 1, 8 do
		if i == rId then
			self.fields["n" .. i]:setScale(1.5)
			self.fields.movie:setRotation(self.fields["n" .. i]:getRotation() + scale * 3)
			self.fields.movie:setPosition(cc.pAdd(self.fields["n" .. i]:getPosition(), config[rId].offset))
		elseif i == 3 then
			self.fields["n" .. i]:setScale(0.8)
		else
			self.fields["n" .. i]:setScale(1)
		end
	end
end
return Com_MapArro
