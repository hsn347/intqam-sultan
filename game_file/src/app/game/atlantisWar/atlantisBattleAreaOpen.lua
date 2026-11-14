local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisBattleAreaOpen = class("atlantisBattleAreaOpen", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisBattleAreaOpen")
	end
	return target
end)
function atlantisBattleAreaOpen:ctor()
	self:setBackGround(0)
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initWidget()
end
function atlantisBattleAreaOpen:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Text_tip:setString(i18n("atlantiswar_text_0173"))
	local et_view = SoraDCreatAnimationEx(self.__cname, self._ccsView, false)
	et_view.action:setFrameEventCallFunc(function(frameEventName)
		local frameEvent = frameEventName:getEvent()
		if frameEvent == "hideFrame" then
			self.et_cloud.action:gotoFrameAndPlay(108, 172, false)
		elseif frameEvent == "closeFrame" then
			self:close(nil, ccui.TouchEventType.ended)
			SoraDCreatePanel("atlantisBattleAreaAttack"):show()
		end
	end)
	_ENV = et_view.action
	et_view.action.cssFileName = "animationEpicWarCloud"
	et_view.action.loop = false
	et_view.action.startIndex = 0
	et_view.action.endIndex = 64
	self.et_cloud = SoraDCreatAnimationParam(et_view.action)
	self.et_cloud:addTo(self.Center_Node, -1)
	self.et_cloud:setPosition(320, 0)
end
return atlantisBattleAreaOpen
