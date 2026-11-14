local baseComponent = class("baseComponent")
function baseComponent:ctor()
	self.fields = fguiHelper.get_fields(self)
	self.controllers = fguiHelper.get_controllers(self)
	self.transitions = fguiHelper.get_transitions(self)
	self:onInit()
end
function baseComponent:onEnter()
	if self then
		if self.registerEvent then
			self:registerEvent()
		end
		if self.onShow then
			self:onShow()
		end
	end
end
function baseComponent:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
	if self then
		if self.removeEvent then
			self:removeEvent()
		end
		if self.onHide then
			self:onHide()
		end
	end
end
function baseComponent:onCleanup()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
	if self then
		if self.removeEvent then
			self:removeEvent()
		end
		if self.onDispose then
			self:onDispose()
		end
	end
end
function baseComponent:onInit()
end
function baseComponent:registerEvent()
end
function baseComponent:onShow()
end
function baseComponent:removeEvent()
end
function baseComponent:onHide()
end
function baseComponent:onDispose()
end
function baseComponent:onExitByCache()
	if not self.fields then
		_ENV = self.fields
	end
	for k, v in pairs(self.fields) do
		if v.onExitByCache then
			v:onExitByCache()
		end
	end
end
return baseComponent
