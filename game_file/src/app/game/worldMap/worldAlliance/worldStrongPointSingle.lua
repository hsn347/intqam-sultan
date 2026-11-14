local worldStrongPointSingle = class("worldStrongPointSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldStrongPointSingle")
	end
	return target
end)
function worldStrongPointSingle:ctor()
	self.frame_dk = SoraDGetChildByName(self, "frame_dk")
	self.icon_gw = SoraDGetChildByName(self, "icon_gw")
	self.frame_killed = SoraDGetChildByName(self, "frame_killed")
	self.frame_killed:setVisible(false)
	self.frame_nd = SoraDGetChildByName(self, "frame_nd")
	self.Text_stage = SoraDGetChildByName(self, "Text_stage")
	self.Text_count = SoraDGetChildByName(self, "Text_count")
	SoraDChangeTextToHtml(self.Text_count)
	self.frame_xz = SoraDGetChildByName(self, "frame_xz")
	self.frame_xz:setVisible(false)
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:addTouchEventListener(handler(self, self.btnTouchClick))
end
function worldStrongPointSingle:initData(data)
	dump(data, "data====")
	_ENV, _ENV = data, dump
	data.dif = i18n("devilvalley_btn_04")
	data.color = cc.c3b(152, 251, 87)
	_ENV, dump[1], data.lace = data, data, "frame_ldjd_dk_jiandan.png"
	data.dif = i18n("alliance_stronghold_text_052")
	data.color = cc.c3b(97, 171, 255)
	_ENV, dump[2], data.lace = data, data, "frame_ldjd_dk_zhong.png"
	data.dif = i18n("devilvalley_btn_06")
	data.color = cc.c3b(221, 121, 254)
	dump[3], data.lace = data, "frame_ldjd_dk_kunnan.png"
	local gwCfg = dump
	local cfg = gwCfg[data.bossType]
	self.Button_touch:setTag(data.bossType)
	self.icon_gw:setSpriteFrame(data.icon)
	self.frame_nd:setSpriteFrame(cfg.lace)
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
		SoraDCreateGraySprite(self.icon_gw)
	else
		SoraDNormalSprite(self.icon_gw)
	end
end
function worldStrongPointSingle:isSelected(ret)
	self.frame_xz:setVisible(ret)
end
function worldStrongPointSingle:btnTouchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.frame_xz:setVisible(true)
			self.handle(button:getTag())
		end
	end
end
return worldStrongPointSingle
