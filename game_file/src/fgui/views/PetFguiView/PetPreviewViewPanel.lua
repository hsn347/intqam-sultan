local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetPreviewViewPanel = class("PetPreviewViewPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function PetPreviewViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("PetPreviewViewPanel:ctor", self.viewName)
end
function PetPreviewViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "PetFguiView"
	end
	return self._packageList
end
function PetPreviewViewPanel:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	print("=======PetPreviewViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Dear_pet_main_07"))
	local pid = self.proxy.param.pid
	self.tablePetMap, _ENV = self.fields.Panel_bg, self.fields.Panel_bg
	local petMapList = petltCtrl:getPetMapInfoList()
	for _, petInfo in ipairs(petMapList) do
		if petCtrl:getPet(petInfo.pid) ~= nil then
			table.insert(self.tablePetMap, petInfo)
		end
	end
	self.fields.pet_model = self.fields.pet_cut:getChild("pet_model")
	self.fields.Button_left:addClickEventListener(handler(self, self.onPageBtnClick), SoraDFIsRA() and 1 or -1)
	self.fields.Button_right:addClickEventListener(handler(self, self.onPageBtnClick), SoraDFIsRA() and -1 or 1)
	self.fields.scroll_attributes:setItemRenderer(handler(self, self.onAttributeRenderer))
	self.fields.scroll_attributes:setItemProvider(handler(self, self.onAttributeProvider))
	self.fields.scroll_page:setItemRenderer(handler(self, self.onPageRenderer))
	self.fields.Button_left:setVisible(#self.tablePetMap > 1)
	self.fields.Button_right:setVisible(#self.tablePetMap > 1)
	self:setCurPet(pid)
end
function PetPreviewViewPanel:onShow()
	print("=======PetPreviewViewPanel:onShow")
end
function PetPreviewViewPanel:setCurPet(petId)
	if self.selectPetId ~= petId then
		self.fields.scroll_attributes:removeChildrenToPool()
	end
	self.curPet, self.selectIndex = self:getCurPet(petId)
	local petData = petCtrl:getPet(petId)
	self.curRank = petData and petData.rank or nil
	if self.curRank == nil then
		self.curRank = #self.curPet.rankInfo
	end
	petCtrl = nil
	;(nil).pet = self.curPet
	;(nil).rank = self.curRank
	;(nil).pet_model = self.fields.pet_model
	self.fields.pet_step_btns:setBtnPetData(nil)
	self.fields.pet_name:setString(petDesRead.getName(petId))
	self.petData = petData
	if not petData then
		return
	end
	self.selectPetId = petId
	local maxLv = petltCtrl.getPetMaxLev(petId)
	petCtrl = petDesRead.getName(petId)
	petDesRead.getName(petId).num = maxLv
	self.fields.txt_unlock_lv:setString(i18n("Dear_pet_main_02", petDesRead.getName(petId)))
	self.fields.text_max_tip:setString(i18n("pet_text_07"))
	self.fields.Com_power:setString(string.formatnumberthousands(self.petData:getPower()))
	self:updateAttr(petId, maxLv, #self.curPet.rankInfo)
	self.fields.scroll_page:setNumItems(#self.tablePetMap)
end
function PetPreviewViewPanel:getCurPet(petId)
	for key, value in pairs(self.tablePetMap) do
		if value.pid == petId then
			return value, key
		end
	end
end
function PetPreviewViewPanel:updateAttr(petId, lv, rank)
	local tableAttr = petltCtrl.getPetTelentAndSecialSkill(petId, rank, lv)
	local tableAttr1 = tableAttr.special_send
	self.atts, petltCtrl = rank, rank
	if tableAttr1 and next(tableAttr1) then
		petltCtrl = nil
		;(nil).type = 1
		;(nil).value = tableAttr1
		table.insert(self.atts, nil)
	end
	for i, v in ipairs(tableAttr.special_add) do
		petltCtrl = nil
		;(nil).type = 2
		;(nil).value = v
		table.insert(self.atts, nil)
	end
	for i, v in ipairs(tableAttr.telent) do
		petltCtrl = nil
		;(nil).type = 3
		;(nil).value = v
		table.insert(self.atts, nil)
	end
	self.fields.scroll_attributes:setNumItems(#self.atts)
end
function PetPreviewViewPanel:onPageRenderer(index, obj)
	local isSelect = index + 1 == self.selectIndex
	if isSelect then
		obj:setIcon("frame_lace_09_01.png")
	else
		obj:setIcon("frame_lace_09_02.png")
	end
end
function PetPreviewViewPanel:onAttributeRenderer(index, obj)
	local data = self.atts[index + 1]
	obj:setSize(cc.size(549, obj:getSize().height))
	obj:initData(data, nil, index + 1)
end
function PetPreviewViewPanel:onAttributeProvider(index)
	local data = self.atts[index + 1]
	if data.type == 2 or data.type == 3 then
		return "ui://PetFguiView/Pet_Com_Attribute_2"
	else
		return "ui://PetFguiView/Pet_Com_Attribute"
	end
end
function PetPreviewViewPanel:onPageBtnClick(sender, params)
	local nextIdx = self.selectIndex + params
	if nextIdx > #self.tablePetMap then
		nextIdx = 1
	elseif nextIdx <= 0 then
		nextIdx = #self.tablePetMap
	end
	local curPet = self.tablePetMap[nextIdx]
	self:setCurPet(curPet.pid)
end
return PetPreviewViewPanel
