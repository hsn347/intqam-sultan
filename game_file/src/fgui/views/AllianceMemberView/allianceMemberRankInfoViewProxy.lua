local baseProxy = require("fgui.base.baseProxy")
local allianceMemberRankInfoViewProxy = class("allianceMemberRankInfoViewProxy", baseProxy)
function allianceMemberRankInfoViewProxy:onRegisterEvent()
	print("=======allianceMemberRankInfoViewProxy:onRegisterEvent")
end
return allianceMemberRankInfoViewProxy
