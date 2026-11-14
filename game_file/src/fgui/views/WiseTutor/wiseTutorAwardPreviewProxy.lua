local baseProxy = require("fgui.base.baseProxy")
local wiseTutorAwardPreviewProxy = class("wiseTutorAwardPreviewProxy", baseProxy)
function wiseTutorAwardPreviewProxy:onRegisterEvent()
end
function wiseTutorAwardPreviewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.name) then
		self.view:close()
	end
end
return wiseTutorAwardPreviewProxy
