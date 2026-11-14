local baseProxy = require("fgui.base.baseProxy")
local newYearSignInPopProxy = class("newYearSignInPopProxy", baseProxy)
function newYearSignInPopProxy:onRegisterEvent()
end
function newYearSignInPopProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.activityName) then
		self.view:close()
	end
end
return newYearSignInPopProxy
