local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonCaveRewardPanel = class("IceDragonCaveRewardPanel", baseFguiPanel)
local publicRead = include("publicRead")
local iceDragonCaveRead = include("iceDragonCaveRead")
function IceDragonCaveRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonCaveRewardPanel:ctor", self.viewName)
end
function IceDragonCaveRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonCaveRewardPanel:onInit()
	print("=======IceDragonCaveRewardPanel:onInit")
	self.fields.title:setString(i18n("decrypt_text_03"))
	self.fields.desc:setString(i18n("luckyFalcon_text16"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function IceDragonCaveRewardPanel:onShow()
	print("=======IceDragonCaveRewardPanel:onShow")
	self.rewards, _ENV = print, print
	self.drawCfgs = iceDragonCaveRead.getDrawCfgList()
	for i, v in ipairs(self.drawCfgs) do
		for k, v2 in pairs(v.reward) do
			local isAdd = false
			for i3, v3 in ipairs(self.rewards) do
				if v3.id == v2.id and v3.num == v2.id then
					isAdd = true
					break
				end
			end
			if not isAdd then
				v2.quality = publicRead.getQuality(v2.id)
				table.insert(self.rewards, v2)
			end
		end
	end
	table.sort(self.rewards, function(a, b)
		if a.quality ~= b.quality then
			return a.quality > b.quality
		elseif a.id ~= b.id then
			return a.id > b.id
		else
			return a.num > b.num
		end
	end)
	self.fields.list:setNumItems(#self.rewards)
end
function IceDragonCaveRewardPanel:onItemRenderer(index, object)
	fguiHelper.get_fields(object).item:initData(self.rewards[index + 1].id, self.rewards[index + 1].num)
end
return IceDragonCaveRewardPanel
