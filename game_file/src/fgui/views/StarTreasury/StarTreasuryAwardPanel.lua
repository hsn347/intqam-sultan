local baseFguiPanel = require("fgui.base.baseFguiPanel")
local starTreasuryCtrl = SoraDGetCtrl("starTreasuryCtrl")
local starTreasuryRead = include("starTreasuryRead")
local publicRead = include("publicRead")
local StarTreasuryAwardPanel = class("StarTreasuryAwardPanel", baseFguiPanel)
function StarTreasuryAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarTreasuryAwardPanel:ctor", self.viewName)
end
function StarTreasuryAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarTreasuryAwardPanel:onInit()
	print("=======StarTreasuryAwardPanel:onInit")
	self.isCanCloseSelf = false
	self.fields.Scroll_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.button_reward:setTitle(i18n("common_text_204"))
	self.fields.button_reward:addClickEventListener(handler(self, self.onSure))
end
function StarTreasuryAwardPanel:onShow()
	print("=======StarTreasuryAwardPanel:onShow")
	self:updateView()
end
function StarTreasuryAwardPanel:updateView()
	self.rid = self.param.rid
	local tmpReward = self.param.reward
	self.reward, _ENV = nil, nil
	for i, v in ipairs(tmpReward) do
		local isInReward = false
		for i2, v2 in ipairs(self.reward) do
			if v2.id == v.id then
				v2.count = v2.count + v.count
				isInReward = true
				break
			end
		end
		if not isInReward then
			table.insert(self.reward, v)
		end
	end
	if self.rid ~= nil then
		local sType = starTreasuryCtrl:getSType()
		local boxCfg = starTreasuryRead.getBoxCfgByRid(self.rid)
		if boxCfg then
			_ENV = table.insert
			table.insert.name = publicRead.getName(boxCfg.itemId)
			self.fields.Text_Title:setString(i18n("star_treasury_7", table.insert))
		end
	else
		self.fields.Text_Title:setString(i18n("Martial_arts_text_09"))
	end
	self.fields.Scroll_award:setNumItems(#self.reward)
end
function StarTreasuryAwardPanel:onItemRenderer(index, object)
	local data = self.reward[index + 1]
	object:initData(data.id, data.count)
end
function StarTreasuryAwardPanel:onSure()
	SoraDPlaySound()
	SoraDMailGainItems(self.reward, true)
	self:close()
end
return StarTreasuryAwardPanel
