local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_role = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001705/Com_9001705_role", Com_9001705_role)
function Com_9001705_role:onInit()
	self.fields.Ani_role1:setAllFrameNameOnce("n1705_yd_n_%02d.png", 1, true)
	self.fields.shine1:setAllFrameNameOnce("activity_9001705_01_%02d.png", 1, true)
	self.fields.shine2:setAllFrameNameOnce("activity_9001705_02_%02d.png", 1, true)
	self.fields.shine3:setAllFrameNameOnce("activity_9001705_03_%02d.png", 1, true)
end
function Com_9001705_role:onShow()
end
function Com_9001705_role:resetRole()
	self.fields.shine1:setVisible(false)
	self.fields.shine2:setVisible(false)
	self.fields.shine3:setVisible(false)
	self.fields.shine1:stopActionByTag(995)
	self.fields.shine2:stopActionByTag(996)
	self.fields.Ani_role1:setVisible(true)
	self.fields.Ani_role2:setVisible(false)
end
function Com_9001705_role:hitItem(itemType)
	if itemType == 1 then
		self.fields.Ani_role1:setVisible(true)
		self.fields.Ani_role2:setVisible(false)
		self.fields.shine1:stopActionByTag(995)
		self.fields.shine1:setVisible(true)
		self.fields.shine1:setAlpha(0)
		local action = ffa.seq(ffa.fadeIn(0.1), ffa.delay(0.5), ffa.fadeOut(0.1), ffa.callFunc(function()
			self.fields.shine1:setVisible(false)
		end))
		action:setTag(995)
		self.fields.shine1:runAction(action)
	elseif itemType == 2 then
		self.isInShinning = true
		self.fields.shine2:setVisible(false)
		self.fields.shine2:stopActionByTag(996)
		if not self.fields.shine3:isVisible() then
			self.fields.shine3:setVisible(true)
		end
	elseif itemType == 3 or itemType == 4 then
		self.fields.shine1:setVisible(false)
		self.fields.Ani_role1:setVisible(false)
		self.fields.Ani_role2:setAllFrameName("ssxj_sj_n_%02d.png", 1)
		self.fields.Ani_role2:setVisible(true)
		self.fields.Ani_role2:setPlaySettings(0, -1, 1, -1, function()
			self.fields.Ani_role2:setVisible(false)
			self.fields.Ani_role1:setVisible(true)
		end)
	end
end
function Com_9001705_role:nearTimeOver(lastTime)
	if self.isInShinning then
		self.isInShinning = false
		self.fields.shine2:setVisible(true)
		local seq = ffa.seq(ffa.delay(lastTime), ffa.callFunc(function()
			self.fields.shine3:setVisible(false)
			self.fields.shine2:setVisible(false)
		end))
		seq:setTag(996)
		self.fields.shine2:runAction(seq)
	end
end
return Com_9001705_role
