local petDesRead = include("petDesRead")
local petltCtrl = include("petltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetShareViewPanel = class("PetShareViewPanel", baseFguiPanel)
function PetShareViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetShareViewPanel:ctor", self.viewName)
end
function PetShareViewPanel:onInit()
	print("=======PetShareViewPanel:onInit")
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
end
function PetShareViewPanel:onShow()
	print("=======PetShareViewPanel:onShow")
	self:init(self.param and self.param.petData)
end
function PetShareViewPanel:onAttrRenderer(index, obj)
	obj:fixChildrenPos()
	local data = self.attrList[index + 1]
	obj:setString(petDesRead.getAttrStr(data))
	obj:setIcon(petDesRead.getAttrGroupIcon(data.attrGroup))
end
function PetShareViewPanel:init(data)
	self.petData = data
	self.fields.Sprite_rank:setURL(petDesRead.getRankIcon(self.petData.rank))
	petDesRead = petDesRead.getRankIcon(self.petData.rank)
	petDesRead.getRankIcon(self.petData.rank).lv = self.petData.level
	petDesRead.getRankIcon(self.petData.rank).name = petDesRead.getName(self.petData.petid)
	self.fields.Text_name:setString(i18n("common_text_134", petDesRead.getRankIcon(self.petData.rank)))
	local pet_model = self.fields.Com_bg:getChild("pet_model")
	petDesRead = i18n("common_text_134", petDesRead.getRankIcon(self.petData.rank))
	i18n("common_text_134", petDesRead.getRankIcon(self.petData.rank)).pid = self.petData.petid
	i18n("common_text_134", petDesRead.getRankIcon(self.petData.rank)).rank = self.petData.rank
	pet_model:initData(i18n("common_text_134", petDesRead.getRankIcon(self.petData.rank)))
	local attrData = petltCtrl.getPetTelentAndSecialSkill(self.petData.petid, self.petData.rank, self.petData.level)
	_UPVALUE3_ = self.petData.petid
	self.petData.petid[1] = "special_add"
	self.petData.petid[2] = "special_send"
	local self.petData.petid[3], attrKey = "telent", self.petData.petid
	local petDesRead, ret = "special_add", "special_add"
	for _, k in ipairs(attrKey) do
		if 0 < #attrData[k] then
			for i = 1, #attrData[k] do
				table.insert(ret, attrData[k][i])
			end
		end
	end
	self.attrList = ret
	self.fields.List_attr:setNumItems(#self.attrList)
end
return PetShareViewPanel
