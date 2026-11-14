local baseProxy = require("fgui.base.baseProxy")
local FollowTestProxy = class("FollowTestProxy", baseProxy)
function FollowTestProxy:onRegisterEvent()
	print("=======FollowTestProxy:onRegisterEvent")
end
return FollowTestProxy
