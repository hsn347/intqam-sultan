local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactSkillGroupNode = class("artifactSkillGroupNode", function(target)
	if type(target) == "nil" then
		return SoraDCreateBasePanel("artifactSkillGroupNode")
	elseif type(target) == "userdata" then
		return SoraDCreateCloneBasePanel(target, "artifactSkillGroupNode")
	else
		return target
	end
end)
function artifactSkillGroupNode:ctor()
	self.menuSingleArray, _ENV = nil, nil
	self.Image_arrow = SoraDGetChildByName(self, "Image_arrow")
	for i = 1, 3 do
		self.menuSingleArray[i] = SoraDGetChildByName(self, "Node_single_" .. i)
	end
end
function artifactSkillGroupNode:initData(data, index)
	self.data = data
	self.index = index
	self:updateMenuScroll()
end
function artifactSkillGroupNode:updateMenuScroll()
	_ENV, _ENV = nil, nil
	;(nil).pos1 = cc.p(72, 10)
	_ENV, (nil)[1], (nil).pos2 = nil, nil, cc.p(0, 70)
	;(nil).pos1 = cc.p(0, -50)
	_ENV, (nil)[2], (nil).pos2 = nil, nil, cc.p(60, 0)
	;(nil).pos1 = cc.p(-72, 10)
	;(nil)[3], (nil).pos2 = nil, cc.p(0, -70)
	local singlePos
	local isBorder = SoraDFIsRA() and self.index % 3 == 0 or not SoraDFIsRA() and self.index % 3 == 1
	for k, v in ipairs(self.menuSingleArray) do
		self:setMenuSingleData(self.menuSingleArray[k], k + 1)
		v:setPosition(isBorder and singlePos[k].pos2 or singlePos[k].pos1)
	end
	self.Image_arrow:setRotation(isBorder and -90 or 0)
end
function artifactSkillGroupNode:setMenuSingleData(target, group)
	local Image_cur = SoraDGetChildByName(target, "Image_cur")
	Image_cur:setVisible(group == 1)
	local Text_name = SoraDGetChildByName(target, "Text_name")
	Text_name:setString(godArmsRuneCtrl:getArmGroupName(self.data.weaponID, group))
	local img_num = SoraDGetChildByName(target, "img_num")
	img_num:setSpriteFrame(SoraDFIsRA() and string.format("img_artifact_%d_ar.png", group - 1) or string.format("img_artifact_%d_en.png", group - 1))
	local Button_touch = SoraDGetChildByName(target, "Button_touch")
	Button_touch:setTag(group)
	Button_touch:addTouchEventListener(handler(self, self.btnMenuSingleClick))
end
function artifactSkillGroupNode:btnMenuSingleClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		if artifactRuneRead.isRuneSetLock(tag - 1) then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
			return
		end
		if 1 < tag then
			_ENV = i18n("Weapon_Rune_tips_095")
			_ENV = i18n("Weapon_Rune_tips_095")
			i18n("Weapon_Rune_tips_095").name1 = equipDesRead.getArtifactName(self.data.weaponID)
			i18n("Weapon_Rune_tips_095").name2 = godArmsRuneCtrl:getArmGroupName(self.data.weaponID, tag)
			i18n("Weapon_Rune_tips_095").content = i18n("Weapon_Rune_tips_105", i18n("Weapon_Rune_tips_095"))
			i18n("Weapon_Rune_tips_095").confirmFunc = function()
				godArmsRuneCtrl:sendGroupUse(self.data.weaponID, tag)
			end
			uiManager:show("MessageBox", i18n("Weapon_Rune_tips_095"))
		end
	end
end
return artifactSkillGroupNode
