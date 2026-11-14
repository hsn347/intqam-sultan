local baseProxy = require("fgui.base.baseProxy")
local CommandHallAdviseArmyProxy = class("CommandHallAdviseArmyProxy", baseProxy)
function CommandHallAdviseArmyProxy:onRegisterEvent()
	print("=======CommandHallAdviseArmyProxy:onRegisterEvent")
end
return CommandHallAdviseArmyProxy
