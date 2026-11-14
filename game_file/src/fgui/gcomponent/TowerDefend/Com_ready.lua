local baseComponent = require("fgui.base.baseComponent")
local Com_ready = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_ready", Com_ready)
function Com_ready:onInit()
	self.fields.title:setString(i18n("EP_tips_0001"))
	local lang = SoraDGetDefaultLanguage()
	self.controllers.lang:setSelectedIndex(lang == "ar" and 0 or 1)
	self.fields.Ani_1:setAllFrameName("dh_tf_star_%02d.png", 1)
	self.fields.Ani_2:setAllFrameName("dh_tf_321_%02d.png", 1)
	self.fields.Ani_2:setPlaySettings(1, -1, 1, -1)
	self.transitions.t0:setHook("end0", function()
		self.transitions.t1:play()
	end)
	self.transitions.t1:setHook("end1", function()
		self.transitions.t2:play()
	end)
	self.transitions.t2:setHook("end2", function()
		self.transitions.t3:play()
	end)
	self.transitions.t3:setHook("end3", function()
		self.transitions.t4:play()
	end)
	self.transitions.t4:setHook("end4", function()
		_ENV = nil
		;(nil).msg = "MESSAGE_TOWER_DEFEND_READY_END"
		SoraDSendMessage(nil)
	end)
end
function Com_ready:beignCount()
	self.transitions.t0:play()
end
function Com_ready:onShow()
end
return Com_ready
