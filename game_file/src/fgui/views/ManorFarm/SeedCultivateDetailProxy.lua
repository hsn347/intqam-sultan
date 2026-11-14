local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local SeedCultivateDetailProxy = class("SeedCultivateDetailProxy", baseProxy)
function SeedCultivateDetailProxy:onRegisterEvent()
	print("=======SeedCultivateDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_MERGE", handler(self, self.onFarmlandMergeUpdate))
end
function SeedCultivateDetailProxy:onFarmlandMergeUpdate(target, data)
	if data and data.failed then
		return
	end
	local queue = self.view:getQueue()
	local mergeData = manorCityCtrl:getSeedCultivateData(queue)
	local input = mergeData and mergeData.input
	local seedId1 = input and tonumber(input[1] or input["1"] or input.seedId1)
	local seedId2 = input and tonumber(input[2] or input["2"] or input.seedId2)
	if not mergeData or (not seedId1 or seedId1 == 0) and (not seedId2 or seedId2 == 0) then
		self.view:close()
		return
	end
	self.view:initData()
end
return SeedCultivateDetailProxy
