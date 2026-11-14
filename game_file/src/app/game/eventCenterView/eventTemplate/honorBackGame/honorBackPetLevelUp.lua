local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local newServerPetCtrl = SoraDGetCtrl("newServerPetCtrl")
local publicRead = include("publicRead")
local honorBackPetLevelUp = class("honorBackPetLevelUp", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("honorBackPetLevelUp")
	end
	return target
end)
function honorBackPetLevelUp:ctor()
	self:setBackGround(229.5)
	self:initWidget()
end
function honorBackPetLevelUp:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.Panel_touch:setContentSize(cc.size(500, 440))
end
function honorBackPetLevelUp:initData(isFromeNewServer)
	if isFromeNewServer then
		self.isUnlock = newServerPetCtrl:getInitData().isUnlock
		self.curPetLv = newServerPetCtrl:getInitData().curPetLv
	else
		self.isUnlock = friendPetCtrl:getInitData().isUnlock
		self.curPetLv = friendPetCtrl:getInitData().curPetLv
	end
	_UPVALUE3_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	;(nil)[3] = "ko"
	local iconName = SoraDGetImageNameByLang("frame_lingchong_youmao_%s.png", nil)
	if self.isUnlock then
		_UPVALUE3_ = "ar"
		;("ar")[1] = "ar"
		;("ar")[2] = "en"
		;("ar")[3] = "ko"
		iconName = SoraDGetImageNameByLang("frame_lingchong_zhanmao_%s.png", "ar")
	end
	self.Sprite_name:setSpriteFrame(iconName)
	newServerPetCtrl = "en"
	;("en").lv = self.curPetLv
	self.Text_lv:setString(i18n("common_text_100", "en"))
	self.Text_reward:setString(i18n("god_beast_text_04"))
	self.Node_single:setVisible(false)
	self.Node_single_en:setVisible(false)
end
function honorBackPetLevelUp:createSpineCat(...)
	local spine_cat
	if self.isUnlock then
		spine_cat = sp.SkeletonAnimation:create("spine/lingmao_zhanmao.skel", "spine/lingmao_zhanmao.atlas", 1)
	else
		spine_cat = sp.SkeletonAnimation:create("spine/lingmao_youmao.skel", "spine/lingmao_youmao.atlas", 1)
	end
	spine_cat:setAnimation(0, "animation", true)
	return spine_cat
end
function honorBackPetLevelUp:initLevelUpReward(reward, isFromNewServer)
	self:initReward(reward, false, isFromNewServer)
	_UPVALUE2_ = reward
	reward[1] = "ar"
	reward[2] = "en"
	local iconName = SoraDGetImageNameByLang("frame_lingchong_levelup_%s.png", reward)
	self.Sprite_title:setSpriteFrame(iconName)
	local effect = SoraDCreatAnimation("Node_Effect_lcks04", nil, false)
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.Node_cat, -1)
	effect:setPosition(-20, -110)
	self.Node_spine = SoraDGetChildByName(effect, "Node_spine")
	local spine_cat = self:createSpineCat()
	spine_cat:addTo(self.Node_spine, -1)
	spine_cat:setPosition(20, 30)
end
function honorBackPetLevelUp:initUnlockReward(reward, isFromNewServer)
	self:initReward(reward, false, isFromNewServer)
	_UPVALUE3_ = self
	self[1] = self.Node_title
	self[2] = self.Node_cat
	self[3] = self.Node_reward
	for i, v in ipairs(self) do
		v:setVisible(false)
	end
	local spine_cat = self:createSpineCat()
	spine_cat:addTo(self.Node_cat, -1)
	spine_cat:setPosition(0, -80)
	local effect = SoraDCreatAnimation("Node_Effect_lcks03", nil, false)
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.scaleActTarget, -1)
	self.Node_spine = SoraDGetChildByName(effect, "Node_spine")
	local spine_cat = self:createSpineCat()
	spine_cat:addTo(self.Node_spine, -1)
	spine_cat:setPosition(0, -140)
	self.singleList = SoraDGetChildsArrayByName(effect, "Node_single_", 2, 1)
	self.Sprite_title = SoraDGetChildByName(effect, "Sprite_title")
	self.Text_reward = SoraDGetChildByName(effect, "Text_reward")
	self.Sprite_name = SoraDGetChildByName(effect, "Sprite_name")
	self.Text_lv = SoraDGetChildByName(effect, "Text_lv")
	self:initReward(reward, true, isFromNewServer)
	_UPVALUE3_ = reward
	reward[1] = "ar"
	reward[2] = "en"
	reward[3] = "ko"
	local iconName = SoraDGetImageNameByLang("frame_lingchong_unlocked_%s.png", reward)
	self.Sprite_title:setSpriteFrame(iconName)
end
function honorBackPetLevelUp:initReward(reward, isUnlock, isFromNewServer)
	self:initData(isFromNewServer)
	if not reward or not next(reward) then
		self.Node_reward:setVisible(false)
		return
	end
	local itemH = 70
	for i, v in ipairs(reward) do
		local single = SoraDFIsRA() and self.Node_single:clone() or self.Node_single_en:clone()
		single:setVisible(true)
		if isUnlock and self.singleList[i] then
			single:addTo(self.singleList[i])
			single:setPosition(0, -itemH / 2)
		else
			single:addTo(self.Node_reward)
			single:setPosition(0, -110 - itemH * (i - 1))
		end
		local item = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_item")
		item:setOwnView(self)
		item:initData(v.id)
		item:setBaseScale(1.0)
		local Text_name = SoraDGetChildByName(single, "Text_name")
		Text_name:setString(publicRead.getName(v.id))
		local Text_num = SoraDGetChildByName(single, "Text_num")
		Text_num:setString(string.formatnumberthousands(v.count))
		SoraDGetChildByName(single, "Image_sheer"):setVisible(i % 2 == 1)
	end
	_UPVALUE2_ = ipairs(reward)
	ipairs(reward)[1] = self.Panel_touch
	ipairs(reward)[2] = self.Image_itemList
	for i, v in ipairs(ipairs(reward)) do
		local size = v:getContentSize()
		v:setContentSize(cc.size(size.width, size.height + (#reward - 2) * itemH))
	end
end
return honorBackPetLevelUp
