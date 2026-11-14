local baseComponent = require("fgui.base.baseComponent")
local Pet_Com_Attribute = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/Pet_Com_Attribute", Pet_Com_Attribute)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function Pet_Com_Attribute:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false)
	end
	self.fields.btn_claim:addClickEventListener(handler(self, self.claimReward))
end
function Pet_Com_Attribute:onShow()
end
function Pet_Com_Attribute:initData(data, pet, idx)
	self.curPet = pet
	local attData = data.value
	local attsNum = #attData
	local height = 100
	if pet then
		height = 40 + 30 * attsNum
	else
		height = 10 + 30 * attsNum
	end
	height = height < 100 and 100 or height
	self:setSize(cc.size(self:getSize().width, height))
	for index = 1, 3 do
		self.fields["pet_att_" .. index]:setVisible(attsNum >= index)
	end
	local attrStr, attrValue = petDesRead.getAttrStrAndValue(attData[1])
	local attrAllValue
	for i, v in ipairs(attData) do
		local attrValue = self.fields["pet_att_" .. i]:initData(v, pet, data.type)
		attrAllValue = attrAllValue == nil and attrValue or attrAllValue .. ",  " .. attrValue
	end
	self.fields.text_cdTip:setString(i18n("pet_new_text_01"))
	self.fields.text_attr:setString(attrStr)
	self.fields.text_item:setString(attrAllValue)
	if pet then
		self.fields.btn_claim:setVisible(true)
		local leftTime = pet:getSpecialSkillSendCDTime()
		self.fields.btn_claim:initData(leftTime)
	else
		self.fields.btn_claim:setVisible(false)
	end
end
function Pet_Com_Attribute:claimReward()
	SoraDPlaySound()
	petCtrl:reqGetSpecialTool(self.curPet.petid)
end
function Pet_Com_Attribute:gameGuide_getTarget(itemName, parameters)
	if itemName == "btn_claim" then
		if not self.fields.btn_claim:isTouchable() then
			_ENV = self.fields.btn_claim
			self.fields.btn_claim.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			self.fields.btn_claim.step = parameters.endStep
			SoraDSendMessage(self.fields.btn_claim)
			_ENV = self.fields.btn_claim
			self.fields.btn_claim.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(self.fields.btn_claim)
			return nil
		end
		return self.fields.btn_claim
	end
end
return Pet_Com_Attribute
