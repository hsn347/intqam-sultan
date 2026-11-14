local baseProxy = require("fgui.base.baseProxy")
local wastelandHelpProxy = class("wastelandHelpProxy", baseProxy)
function wastelandHelpProxy:onRegisterEvent()
	print("=======wastelandHelpProxy:onRegisterEvent")
end
function wastelandHelpProxy:getHelpData(...)
	if not self.helpData then
		local wasteland_boss = require_data("wasteland_boss", true).data
		local _ENV, ret = "wasteland_boss", "wasteland_boss"
		for _, v in ipairs(wasteland_boss) do
			local bossLV = v.LV
			local point = v.bosspoint
			_ENV = nil
			ret[bossLV], (nil).bosspoint = nil, point
		end
		for _, v in ipairs(wasteland_boss) do
			for i = 1, #v.npc, 3 do
				local monsterID = v.npc[i]
				local point = v.npc[i + 2]
				local monsterLV = worldMapDefine.getMonsterLevel(monsterID)
				if ret[monsterLV] and not ret[monsterLV].monsterpoint then
					ret[monsterLV].monsterpoint = point
				end
			end
		end
		self.helpData = ret
	end
	return self.helpData
end
return wastelandHelpProxy
