local worldMapBattleSkill = class("worldMapBattleSkill", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapBattleSkill")
	end
	return target
end)
local talentSkillCtrl = SoraDGetCtrl("talentSkillCtrl")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
function worldMapBattleSkill:ctor()
	self.skillData = talentSkillCtrl:getSkillData()
	self.itemList, talentSkillCtrl, self.selectSkillID = talentSkillCtrl:getSkillData(), talentSkillCtrl:getSkillData(), nil
	self:initWidget()
	self:initData()
end
function worldMapBattleSkill:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TALENTSKILL_REFRESH", handler(self, self.refreshTalentSkill))
end
function worldMapBattleSkill:refreshTalentSkill(target, data)
	self.skillData = talentSkillCtrl:getSkillData()
	self:refreshActivedSkill()
	for k, v in pairs(self.itemList) do
		v:refreshActiveState()
	end
	if self.selectSkillID and talentSkillCtrl:checkSkillActived(self.selectSkillID) then
		self:refreshBtnState(self.selectSkillID)
	end
end
function worldMapBattleSkill:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("talSkill_text_02"))
	self.Text_top:setAnchorPoint(cc.p(SoraDFIsRA() and 0 or 1, self.Text_top:getAnchorPoint().y))
	self.Text_top:setPositionX(SoraDFSign(-self.Text_top:getPositionX()))
	self.Text_top:setString(i18n("common_text_1765"))
	self.Text_des:setString(i18n("talSkill_text_03"))
	self.Button_active:setTitleText(i18n("talSkill_text_04"))
	self.Button_active:addTouchEventListener(handler(self, self.onClickActive))
	self.Text_actived:setString(i18n("talSkill_text_05"))
	self.Node_info:setVisible(false)
end
function worldMapBattleSkill:initData()
	self:refreshActivedSkill()
	local itemSize = cc.size(128, 138)
	for i = 1, talentSkillCtrl:getSkillNum() do
		local item = self:createSingle(i)
		item:addTo(self.Node_skill)
		local row = math.ceil(i / 4)
		local col = (i - 1) % 4 + 1
		item:setPosition((col - 2.5) * itemSize.width, (1 - row) * itemSize.height)
		item:refreshActiveState()
		self.itemList[i] = item
	end
end
function worldMapBattleSkill:refreshActivedSkill(...)
	for i = 1, 2 do
		local widget = self["Node_skill_" .. i]
		if widget then
			local Sprite_icon = SoraDGetChildByName(widget, "Sprite_icon")
			if self.skillData[i] then
				Sprite_icon:setSpriteFrame(talentSkillCtrl:getSkillIcon(self.skillData[i]))
				Sprite_icon:setVisible(true)
			else
				Sprite_icon:setVisible(false)
			end
		end
	end
end
function worldMapBattleSkill:createSingle(index)
	local ocx = self.Node_single:clone()
	SoraDGetAllChildFromWidget(ocx, ocx)
	ocx.Sprite_icon:setSpriteFrame(talentSkillCtrl:getSkillIcon(index))
	ocx.Text_name:setString(i18n(talentSkillCtrl:getSkillName(index)))
	ocx.dh_xz:setVisible(false)
	ocx.Image_actived:setVisible(false)
	ocx.Button_touch:addTouchEventListener(handler(self, self.onClickSelect))
	ocx.Button_touch:setTag(index)
	function ocx.setSelectState(target, isSelect)
		if isSelect then
			ocx.dh_xz:setVisible(true)
		else
			ocx.dh_xz:setVisible(false)
		end
	end
	function ocx.refreshActiveState(target)
		if talentSkillCtrl:checkSkillActived(index) then
			ocx.Image_actived:setVisible(true)
			ocx.Sprite_icon:setColor(cc.c3b(150, 150, 150))
		end
	end
	return ocx
end
function worldMapBattleSkill:onClickActive(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.selectSkillID and not talentSkillCtrl:checkSkillActived(self.selectSkillID) then
			talentSkillCtrl:reqSelectSkill(self.selectSkillID)
		end
	end
end
function worldMapBattleSkill:onClickSelect(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button:getTag()
		for k, v in pairs(self.itemList) do
			v:setSelectState(k == index)
		end
		self.selectSkillID = index
		self.Node_info:setVisible(true)
		self.Text_skillName:setString(i18n(talentSkillCtrl:getSkillName(index)))
		local skillDes = talentSkillCtrl:getSkillDes(index)
		local buffList = talentSkillCtrl:getBuffList(index)
		local str
		if buffList[1] then
			str = propParser.getFormatByAttrIDAndValue(buffList[1].attrId, buffList[1].attrValue, gPropShowValueType.numbert)
		end
		local str1
		if buffList[2] then
			local attrId = buffList[2].attrId
			local attrValue = buffList[2].attrValue
			str1 = propParser.getFormatByAttrIDAndValue(attrId, attrValue, gPropShowValueType.numbert)
		end
		_ENV = attrValue
		attrValue.num = str
		attrValue.num1 = str1
		self.Text_skillDes:setString(i18n(skillDes, attrValue))
		self:refreshBtnState(index)
	end
end
function worldMapBattleSkill:refreshBtnState(index)
	if #self.skillData < 2 then
		if talentSkillCtrl:checkSkillActived(index) then
			self.Button_active:setVisible(false)
			self.Text_actived:setVisible(true)
		else
			self.Button_active:setVisible(true)
			self.Text_actived:setVisible(false)
		end
	else
		self.Button_active:setVisible(false)
		self.Text_actived:setVisible(false)
	end
end
return worldMapBattleSkill
