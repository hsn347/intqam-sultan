local baseComponent = require("fgui.base.baseComponent")
local worldStrongPointSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceStrongPointView/worldStrongPointSingle", worldStrongPointSingle)
function worldStrongPointSingle:onInit()
	self.icon_gw = self.fields.icon_gw
	self.frame_killed = self.fields.frame_killed
	self.frame_killed:setVisible(false)
	self.frame_nd = self.fields.frame_nd
	self.Text_stage = self.fields.Text_stage
	self.Text_count = self.fields.Text_count
	self.frame_xz = self.fields.frame_xz
	self.frame_xz:setVisible(false)
	self:addClickListener(handler(self, self.btnTouchClick))
end
function worldStrongPointSingle:onShow()
end
function worldStrongPointSingle:initData(data)
	dump(data, "data====")
	_ENV, _ENV, self.bossType = data, data.bossType, data.bossType
	data.dif = i18n("devilvalley_btn_04")
	data.color = cc.c3b(152, 251, 87)
	_ENV, data.bossType[1], data.lace = data, data, "frame_ldjd_dk_jiandan.png"
	data.dif = i18n("alliance_stronghold_text_052")
	data.color = cc.c3b(97, 171, 255)
	_ENV, data.bossType[2], data.lace = data, data, "frame_ldjd_dk_zhong.png"
	data.dif = i18n("devilvalley_btn_06")
	data.color = cc.c3b(221, 121, 254)
	data.bossType[3], data.lace = data, "frame_ldjd_dk_kunnan.png"
	local gwCfg = data.bossType
	local cfg = gwCfg[data.bossType]
	self.icon_gw:setURL(data.icon)
	self.frame_nd:setURL(cfg.lace)
	self.Text_stage:setString(cfg.dif)
	self.Text_stage:setColor(cfg.color)
	_ENV = nil
	;(nil).var1 = data.curPro
	_ENV, _ENV, (nil).var2 = nil, data.total, data.total
	data.total.var1, (nil).color = nil, data.curPro >= data.total and "#FFFFFF" or "#FF0600"
	self.Text_count:setString(i18n_html("%{var1}/%{var2}", nil, data.total))
	self:isKilled(data.curPro <= 0)
end
function worldStrongPointSingle:setHandle(handle)
	self.handle = handle
end
function worldStrongPointSingle:isKilled(ret)
	self.frame_killed:setVisible(ret)
	if ret then
		self.icon_gw:setGrayed(true)
	else
		self.icon_gw:setGrayed(false)
	end
end
function worldStrongPointSingle:isSelected(ret)
	self.frame_xz:setVisible(ret)
end
function worldStrongPointSingle:btnTouchClick()
	SoraDPlaySound()
	if self.handle then
		self.frame_xz:setVisible(true)
		self.handle(self.bossType)
	end
end
return worldStrongPointSingle
