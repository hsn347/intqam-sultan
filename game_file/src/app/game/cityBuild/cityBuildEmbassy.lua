local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildEmbassy = class("cityBuildEmbassy", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildEmbassy:ctor()
end
function cityBuildEmbassy:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.msgUpdateView))
end
function cityBuildEmbassy:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_111"), i18n("buildDes_name_111")
	i18n("buildDes_name_111").x = 0
	;(nil).pos, i18n("buildDes_name_111").y = i18n("buildDes_name_111"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildEmbassy:msgUpdateView(target, data)
	self:updateIsLock()
end
function cityBuildEmbassy:onAfterInitWithBuildCell()
	self:updateIsLock()
end
return cityBuildEmbassy
