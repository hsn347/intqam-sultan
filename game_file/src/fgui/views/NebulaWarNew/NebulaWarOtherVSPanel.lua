local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarOtherVSPanel = class("NebulaWarOtherVSPanel", baseFguiPanel)
function NebulaWarOtherVSPanel:ctor(...)
	NebulaWarOtherVSPanel.super.ctor(self, ...)
	print("NebulaWarOtherVSPanel:ctor", self.viewName)
end
function NebulaWarOtherVSPanel:onInit()
	print("=======NebulaWarOtherVSPanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_war_text_0616"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Usm_bg:updateUsmColor(self.fields.Image_bg:getColor())
end
function NebulaWarOtherVSPanel:onShow()
	print("=======NebulaWarOtherVSPanel:onShow")
	local _ENV, groupIdList = print, print
	local round = nebulaActivityCtrl:getCurRound()
	local roundAgainst = nebulaActivityCtrl:getRoundAgainst(round)
	local selfGroupId = nebulaActivityCtrl:getSelfGroupId()
	local index = table.indexof(roundAgainst, selfGroupId)
	local againstId = index and math.ceil(index / 2)
	for i, groupId in ipairs(roundAgainst) do
		if againstId ~= math.ceil(i / 2) then
			table.insert(groupIdList, groupId)
		end
	end
	self.groupIdList = groupIdList
	self.fields.List:setNumItems(math.floor(#self.groupIdList / 2))
end
function NebulaWarOtherVSPanel:onItemRenderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local groupId1 = self.groupIdList[index * 2 + 1]
	_fields.Com_group1:initData(groupId1)
	local groupId2 = self.groupIdList[index * 2 + 2]
	_fields.Com_group2:initData(groupId2)
end
return NebulaWarOtherVSPanel
