local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisTreasureRewardPanel = class("AtlantisTreasureRewardPanel", baseFguiPanel)
function AtlantisTreasureRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisTreasureRewardPanel:ctor", self.viewName)
end
function AtlantisTreasureRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function AtlantisTreasureRewardPanel:onInit()
	print("=======AtlantisTreasureRewardPanel:onInit")
	if not atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData then
		local _ENV, treasureData = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData, atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
	end
	local AST = require_data("atlantiswar_season_treasure", true).data
	local treasureType = self.param.treasureType
	_ENV, _ENV = nil, true
	;(nil).icon = "frame_shmc_zlbz_tb_01.png"
	;(nil).title = "frame_shmc_zlbz_%s.png"
	_ENV, (true)[1], (nil).count = nil, nil, i18n("atlantiswar_text_0426")
	;(nil).icon = "frame_shmc_dlbz_tb_02.png"
	;(nil).title = "frame_shmc_dlbz_%s.png"
	_ENV, (true)[2], (nil).count = nil, nil, ""
	;(nil).icon = "frame_shmc_jlbz_tb_03.png"
	;(nil).title = "frame_shmc_jlbz_%s.png"
	;(true)[3], (nil).count = nil, ""
	local config = true
	for treasureType = 2, 3 do
		local countMax = AST[treasureType].count
		if not treasureData[tostring(treasureType)] then
			local _ENV, typeData = treasureData[tostring(treasureType)], treasureData[tostring(treasureType)]
		end
		typeData = table.keys(typeData)
		table.sort(typeData)
		local count = math.max(0, countMax - #typeData)
		_ENV = nil
		;(nil).var = count
		;(nil).var1 = countMax
		config[treasureType].count = i18n("atlantiswar_text_0378", nil)
	end
	local data = config[treasureType]
	self.fields.Load_icon:setURL("ui://Activity2112/Com_treasure" .. treasureType)
	_UPVALUE2_ = table.keys(typeData)
	table.keys(typeData)[1] = "ar"
	table.keys(typeData)[2] = "en"
	self.fields.Load_title:setURL(SoraDGetImageNameByLang(data.title, (table.keys(typeData))))
	self.fields.Text_name:setString(data.count)
	local treasureName = atlantisActivityCtrl:getTreasureName(treasureType)
	_ENV = SoraDGetImageNameByLang(data.title, (table.keys(typeData)))
	SoraDGetImageNameByLang(data.title, (table.keys(typeData))).var = treasureName
	self.fields.Text_des:setString(i18n("atlantiswar_text_0372", SoraDGetImageNameByLang(data.title, (table.keys(typeData)))))
	self.fields.List_rewards:setItemRenderer(handler(self, self.onRewardItemRenderer))
	local rewards = AST[treasureType].rewards
	_UPVALUE2_ = handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer)[1] = "id"
	handler(self, self.onRewardItemRenderer)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(rewards, handler(self, self.onRewardItemRenderer))
	self.fields.List_rewards:setNumItems(#self.rewards)
end
function AtlantisTreasureRewardPanel:onShow()
	print("=======AtlantisTreasureRewardPanel:onShow")
end
function AtlantisTreasureRewardPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
return AtlantisTreasureRewardPanel
