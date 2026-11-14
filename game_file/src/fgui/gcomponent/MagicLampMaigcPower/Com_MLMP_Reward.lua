local baseComponent = require("fgui.base.baseComponent")
local magicLampSkillRead = include("magicLampSkillRead")
local Com_MLMP_Reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampMaigcPower/Com_MLMP_Reward", Com_MLMP_Reward)
function Com_MLMP_Reward:onInit()
end
function Com_MLMP_Reward:onShow()
end
function Com_MLMP_Reward:initData(item)
	self.controllers.c1:setSelectedIndex(item.isSkill and 0 or 1)
	self.item = item
	if item.isSkill then
		dump(self.item, "Com_MLMP_Reward:initData")
		self.fields.Com_skill:initByType(item.id)
		self.fields.Com_skill:setClickShowDetail()
		local quality = magicLampSkillRead.getSkillQuality(item.id)
		self.fields.ani_effect:setVisible(quality == 4)
		self.fields.ani_effect2:setVisible(quality == 3)
		self.fields.ani_show:setVisible(false)
		self.fields.ani_show2:setVisible(false)
		self.fields.Com_skill:setQualityEffect(false)
		if quality == 3 then
			self.fields.ani_effect2:setAllFrameName("dh_sdslkpzs_%02d.png", 1)
			self.fields.ani_effect2:setHighpSprite()
			self.fields.ani_effect2:setPlaySettings(0, -1, -1)
		elseif quality == 4 then
			self.fields.ani_effect:setHighpSprite()
			self.fields.ani_effect:setAllFrameName("dh_slsdkpjs_%02d.png", 1)
			self.fields.ani_effect:setPlaySettings(0, -1, -1)
		end
	else
		self.fields.item:initData(item.id, item.count)
	end
end
function Com_MLMP_Reward:playShowEffect()
	if self.item.isSkill then
		local quality = magicLampSkillRead.getSkillQuality(self.item.id)
		if quality == 3 then
			self.fields.ani_show2:setHighpSprite()
			self.fields.ani_show2:setAllFrameNameOnce("dh_slkp_zs_%02d.png", 1, false)
		elseif quality == 4 then
			self.fields.ani_show:setHighpSprite()
			self.fields.ani_show:setAllFrameNameOnce("dh_slkp_js_%02d.png", 1, false)
		end
	end
end
function Com_MLMP_Reward:showInAni(showTime)
	for i = 1, self:getChildrenCount() do
		local child = self:getChildAt(i - 1)
		local childName = child:getName()
		if childName ~= "ani_show" or childName ~= "ani_show1" then
			child:setAlpha(0)
			local scale = child:getScale()
			local _ENV, seq = child, child
			table.insert(seq, ffa.delay(showTime))
			if i == 1 then
				table.insert(seq, ffa.callFunc(handler(self, self.playShowEffect)))
			end
			table.insert(seq, ffa.spawn(ffa.seq(ffa.scaleTo(0, 0.14 * scale), ffa.scaleTo(0.1, 1.14 * scale), ffa.scaleTo(0.13333333333333333, 1.0 * scale)), ffa.fadeIn(0.23333333333333334)))
			child:runAction(ffa.seq(seq))
		end
	end
	local addTime = 0.3
	return showTime + addTime
end
return Com_MLMP_Reward
