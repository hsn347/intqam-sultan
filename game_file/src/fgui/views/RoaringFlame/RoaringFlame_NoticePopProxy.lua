local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_NoticePopProxy = class("RoaringFlame_NoticePopProxy", baseProxy)
function RoaringFlame_NoticePopProxy:onRegisterEvent()
	print("=======RoaringFlame_NoticePopProxy:onRegisterEvent")
end
return RoaringFlame_NoticePopProxy
