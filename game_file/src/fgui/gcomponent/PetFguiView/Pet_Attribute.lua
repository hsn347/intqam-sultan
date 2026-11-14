local baseComponent = require("fgui.base.baseComponent")
local Pet_Attribute = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/Pet_Attribute", Pet_Attribute)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function Pet_Attribute:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Pet_Attribute:onShow()
end
function Pet_Attribute:initData(attData, pet, datType)
	local attrStr, attrValue = petDesRead.getAttrStrAndValue(attData)
	local attrNextValue = ""
	local unlockAttrStr = ""
	local nextRank, add
	local nextColor = cc.c3b(112, 199, 35)
	if pet and attData.goodid then
		nextRank, add = petltCtrl.getTalentSendUpgradeRank(pet.petid, pet.rank, attData)
		if nextRank then
			local isFull = pet:getPetIsReachMaxLvInCurRank() and not pet:getPetIsReachMaxRank()
			if nextRank - 1 == pet.rank and isFull then
				attrNextValue = add
				nextColor = cc.c3b(112, 199, 35)
			else
				attrNextValue = attrValue
				petDesRead = 199
				;(199).num = nextRank
				unlockAttrStr = i18n("Dear_pet_main_05", 199)
				nextColor = cc.c3b(175, 175, 175)
			end
		end
	end
	self.fields.text_next_value:setColor(nextColor)
	if attrNextValue == "" then
		if attData.goodid then
			self.fields.text_cur_value:setString("X" .. attData.count)
		else
			self.fields.text_cur_value:setString(attrValue)
		end
		self.fields.panel_arrow:setVisible(pet ~= nil)
		self.fields.text_cur_value:setVisible(pet ~= nil)
		self.fields.text_next_value:setString(attrValue)
		self.fields.text_next_value:setVisible(true)
	elseif attrNextValue == attrValue then
		self.fields.text_cur_value:setVisible(false)
		self.fields.text_next_value:setString(attrValue)
		self.fields.panel_arrow:setVisible(false)
	else
		self.fields.text_cur_value:setString(attrValue)
		if attData.goodid then
			self.fields.text_cur_value:setString("X" .. attData.count)
		else
			self.fields.text_cur_value:setString(attrValue)
		end
		self.fields.text_next_value:setString(attrNextValue)
		self.fields.panel_arrow:setVisible(pet ~= nil)
		self.fields.text_cur_value:setVisible(pet ~= nil)
		self.fields.text_next_value:setVisible(true)
	end
	if unlockAttrStr ~= "" then
		self.fields.text_cur_value:setVisible(true)
		self.fields.text_cur_value:setString(attrValue)
		self.fields.panel_arrow:setVisible(true)
		self.fields.text_next_value:setVisible(true)
		self.fields.text_next_value:setString(unlockAttrStr)
	end
	return attrValue
end
return Pet_Attribute
