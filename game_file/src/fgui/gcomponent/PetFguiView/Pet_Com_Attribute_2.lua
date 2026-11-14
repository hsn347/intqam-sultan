local baseComponent = require("fgui.base.baseComponent")
local Pet_Com_Attribute_2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/Pet_Com_Attribute_2", Pet_Com_Attribute_2)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function Pet_Com_Attribute_2:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
end
function Pet_Com_Attribute_2:onShow()
end
function Pet_Com_Attribute_2:initData(data, pet, idx)
	self.fields.bg:setVisible(idx % 2 == 1)
	local attData = data.value
	local nextAttData = data.nextValue
	local attrStr = ""
	local attrValue = ""
	local attrNextValue = ""
	local unlockAttrStr = ""
	local nextLv, add
	local nextColor = cc.c3b(112, 199, 35)
	attrStr, attrValue = petDesRead.getAttrStrAndValue(attData)
	if pet and not nextAttData then
		nextLv, add = petltCtrl.getTalentSkillUpgradeLevel(pet.petid, pet.level, attData.attrType)
		if nextLv then
			if nextLv - 1 == pet.level then
				attrNextValue = petDesRead.getAttrAdd(attData, add)
				if string.find(attrValue, "-") then
					attrNextValue = "-" .. attrNextValue
				end
			else
				attrNextValue = attrValue
				_ENV = "-"
				;("-").num = nextLv
				unlockAttrStr = i18n("Dear_pet_main_04", "-")
				nextColor = cc.c3b(116, 110, 101)
			end
		end
	elseif nextAttData then
		attrStr, attrNextValue = petDesRead.getAttrStrAndValue(nextAttData)
	end
	self.fields.text_attr:setString(attrStr)
	self.fields.text_cur_value:setString(attrValue)
	self.fields.text_next_value:setString(attrNextValue)
	self.fields.text_next_value:setColor(nextColor)
	if attrNextValue == "" then
		self.fields.text_cur_value:setVisible(false)
		self.fields.text_next_value:setString(attrValue)
		self.fields.panel_arrow:setVisible(false)
	elseif attrNextValue == attrValue then
		self.fields.text_cur_value:setVisible(false)
		self.fields.text_next_value:setColor(nextColor)
		self.fields.panel_arrow:setVisible(false)
	else
		self.fields.text_cur_value:setVisible(true)
		self.fields.panel_arrow:setVisible(true)
		self.fields.text_next_value:setVisible(true)
	end
	if unlockAttrStr ~= "" then
		self.fields.text_cur_value:setVisible(true)
		self.fields.panel_arrow:setVisible(true)
		self.fields.text_next_value:setVisible(true)
		self.fields.text_next_value:setString(unlockAttrStr)
	end
end
return Pet_Com_Attribute_2
