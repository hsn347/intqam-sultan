local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleHonourBoardPopProxy = class("kingdomBattleHonourBoardPopProxy", baseProxy)
function kingdomBattleHonourBoardPopProxy:onRegisterEvent()
	print("=======kingdomBattleHonourBoardPopProxy:onRegisterEvent")
end
return kingdomBattleHonourBoardPopProxy
