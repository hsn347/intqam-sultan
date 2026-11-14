local masteryDetailSkillSingle = class("masteryDetailSkillSingle", function(target)
	return target
end)
local buffDesRead = include("buffDesRead")
local specializationRead = include("specializationRead")
masteryDetailSkillSingle.COLOR_GRAY = cc.c3b(170, 170, 170)
function masteryDetailSkillSingle:ctor()
	self:initWidget()
end
function masteryDetailSkillSingle:initWidget(...)
	_UPVALUE1_ = nil
	;(nil)[1] = "Text_6"
	self.Text_stars = SoraDGetChildByFullPath(self, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Text_7"
	self.Text_des = SoraDGetChildByFullPath(self, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Image_frame"
	self.Image_frame = SoraDGetChildByFullPath(self, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Image_touch"
	self.Image_touch = SoraDGetChildByFullPath(self, nil)
	self.Image_touch:setTouchEnabled(true)
	self.Image_touch:addTouchEventListener(handler(self, self.onClick_touch))
	_UPVALUE1_ = handler(self, self.onClick_touch)
	handler(self, self.onClick_touch)[1] = "Sprite_icon"
	self.Sprite_icon = SoraDGetChildByFullPath(self, handler(self, self.onClick_touch))
	_UPVALUE1_ = handler(self, self.onClick_touch)
	handler(self, self.onClick_touch)[1] = "Node_lock"
	self.Node_lock = SoraDGetChildByFullPath(self, handler(self, self.onClick_touch))
	_UPVALUE1_ = handler(self, self.onClick_touch)
	handler(self, self.onClick_touch)[1] = "Button_7"
	self.Button_up = SoraDGetChildByFullPath(self, handler(self, self.onClick_touch))
	self.Button_up:setTitleText(i18n("specialization_text_10"))
	self.Button_up:addTouchEventListener(handler(self, self.onClick_up))
	SoraDAutoSizeButtonText(self.Button_up, cc.size(150, 50))
	_UPVALUE1_ = cc.size(150, 50)
	cc.size(150, 50)[1] = "Sprite_15"
	self.Sprite_star = SoraDGetChildByFullPath(self, cc.size(150, 50))
	_UPVALUE1_ = cc.size(150, 50)
	cc.size(150, 50)[1] = "Node_effect_set"
	self.Node_effect_set = SoraDGetChildByFullPath(self, cc.size(150, 50))
	_UPVALUE1_ = cc.size(150, 50)
	cc.size(150, 50)[1] = "Node_effect_reset"
	self.Node_effect_reset = SoraDGetChildByFullPath(self, cc.size(150, 50))
	self.Node_effect_set:setVisible(false)
	self.Node_effect_reset:setVisible(false)
end
function masteryDetailSkillSingle:initData(data)
	if data.handler then
		self.handler = data.handler
	end
	if data.buffID then
		self.mid = data.mid
		self.buffID = data.buffID
		self.Sprite_icon:setSpriteFrame(specializationRead.getBuffIcon(self.buffID))
	end
	if data.buffLv then
		self.buffLv = data.buffLv
		self.Text_stars:setString(self.buffLv)
		local value = specializationRead.getMasteryBuffValue(self.mid, self.buffID, self.buffLv) or 0
		local des = specializationRead.getBuffDesBase(self.buffID) or self.buffID
		specializationRead = specializationRead.getBuffIcon(self.buffID)
		specializationRead.getBuffIcon(self.buffID).num = des
		specializationRead.getBuffIcon(self.buffID).char = value
		self.Text_des:setString(i18n("common_text_1470", specializationRead.getBuffIcon(self.buffID)))
	end
	if data.state then
		local specializationRead = include("specializationRead")
		local MASTERY_STATE = specializationRead.MASTERY_STATE
		local state = data.state
		if state == MASTERY_STATE.lock or state == MASTERY_STATE.invalid then
			self.Node_lock:setVisible(true)
			self.Button_up:setVisible(false)
			SoraDSetNodeGray(self.Image_frame, true)
			SoraDSetNodeGray(self.Sprite_star, true)
			self.Text_stars:setColor(masteryDetailSkillSingle.COLOR_GRAY)
			self.Text_des:setColor(masteryDetailSkillSingle.COLOR_GRAY)
			self.Sprite_icon:setVisible(false)
		else
			self.Node_lock:setVisible(false)
			self.Button_up:setVisible(true)
			SoraDSetNodeGray(self.Image_frame, false)
			SoraDSetNodeGray(self.Sprite_star, false)
			self.Text_stars:setColor(cc.c3b(250, 250, 0))
			self.Text_des:setColor(cc.c3b(255, 255, 255))
			self.Sprite_icon:setVisible(true)
		end
	end
end
function masteryDetailSkillSingle:onClick_touch(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	local panel = SoraDCreatePanel("masterySkillPopView")
	_ENV = nil
	;(nil).mid = self.mid
	;(nil).buffID = self.buffID
	;(nil).buffLv = self.buffLv
	panel:initData(nil)
	panel:show()
end
function masteryDetailSkillSingle:onClick_up(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if self.handler then
		self.handler(self.buffID)
	end
end
function masteryDetailSkillSingle:showSetStarEffect(...)
	masteryDetailSkillSingle.resetSystemAllChildren(self.Node_effect_set)
end
function masteryDetailSkillSingle:showResetEffect(...)
	masteryDetailSkillSingle.resetSystemAllChildren(self.Node_effect_reset)
end
function masteryDetailSkillSingle.resetSystemAllChildren(widget)
	widget:setVisible(true)
	for i, v in ipairs(widget:getChildren()) do
		v:resetSystem()
	end
end
function masteryDetailSkillSingle:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_up" then
		return self.Button_up
	end
end
return masteryDetailSkillSingle
